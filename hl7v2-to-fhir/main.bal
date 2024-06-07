import ballerina/io;
import ballerinax/health.fhir.r4;
import ballerinax/health.fhir.r4.international401;
import ballerinax/health.hl7v2 as hl7;
import ballerinax/health.hl7v23;
import ballerinax/health.hl7v2commons as hl7types;
import ballerinax/health.hl7v2.utils.v2tofhirr4;

final string msg =
"MSH|^~\\&|ADT1|GOOD HEALTH HOSPITAL|GHH LAB, INC.|GOOD HEALTH" +
"HOSPITAL|198808181126|SECURITY|ADT^A01^ADT_A01|MSG00001|P|2.3||\rEVN|A01|" +
"200708181123||\rPID|1||PATID1234^5^M11^ADT1^MR^GOOD HEALTH HOSPITAL~123456789^^^USSSA^SS||" +
"BATMAN^ADAM^A^III||19610615|M||C|2222 HOME STREET^^GREENSBORO^NC^27401-1020|GL|" +
"(555)555-2004|(555)555-2004||S||PATID12345001^2^M10^ADT1^AN^A|444333333|987654^NC|" +
"\rNK1|1|NUCLEAR^NELDA^W|SPO^SPOUSE||||NK^NEXT OF KIN$\rPV1|1|I|2000^2012^01||||" +
"004777^ATTEND^AARON^A|||SUR||||ADM|A0|";

public function main() returns error? {
    // Transform HL7v2 message to FHIR R4.
    // You can pass a HL7v2 message and get a FHIR R4 Bundle based on
    // the mappings defined at
    // https://build.fhir.org/ig/HL7/v2-to-fhir/branches/master/datatype_maps.html.
    json v2tofhirResult = check v2tofhirr4:v2ToFhir(msg);
    io:println("Transformed FHIR message: ", v2tofhirResult.toString());
    io:println("------------------------------------------------------------------");

    // v2tofhirr4 library exposes these low level functions as well,
    // In this case, by using stringToHl7 function you can pass a HL7v2 message string and get a parsed HL7v2 message model.
    hl7:Message hl7msg = check v2tofhirr4:stringToHl7(msg);
    if (hl7msg is hl7v23:ADT_A01) {
        // if you want to work with HL7v2 segments directly.
        // Transform HL7v2 PID to FHIR R4 Patient Name.
        r4:HumanName[]? patientName = v2tofhirr4:pidToPatientName(hl7msg.pid.pid5,
                hl7msg.pid.pid9);
        if patientName is r4:HumanName[] {
            io:println("HL7v23 PID Patient Name: ", patientName[0].toString());
        }
    }
    io:println("------------------------------------------------------------------");

    // You can also bind custom mapping function implementations by overriding 
    // the default mapping functions. Following are the supported mapping functions. These functions are
    // defined to map Hl7 segments to FHIR resources as per the standard mappings defined at 
    // https://build.fhir.org/ig/HL7/v2-to-fhir/branches/master/segment_maps.html.
    // Supported functions: Pv1ToPatient, Pv1ToEncounter, Nk1ToPatient, Pd1ToPatient, PidToPatient, Dg1ToCondition,
    // ObxToObservation, ObrToDiagnosticReport, Al1ToAllerygyIntolerance, EvnToProvenance, MshToMessageHeader,
    // Pv2ToEncounter, OrcToImmunization.
    v2tofhirr4:V2SegmentToFhirMapper customMapper = {
        pv1ToEncounter: pv1ToEncounter
    };
    // You can pass the custom mapper implementation as a function parameter to the v2ToFhir module.
    v2tofhirResult = check v2tofhirr4:v2ToFhir(msg, customMapper);
    io:println("Transformed FHIR message using the custom mapper: ", v2tofhirResult.toString());
    io:println("------------------------------------------------------------------");

}

# Custom mapping function for PV1 segment to Encounter resource.
#
# + pv1 - PV1 segment
# + return - Encounter FHIR resource
isolated function pv1ToEncounter(hl7types:Pv1 pv1) returns international401:Encounter {
    string encounterClass = pv1.pv12.toString() == "I" ? "inpatient encounter" : "ambulatory";
    international401:Encounter encounter = {id: pv1.pv11.toString(), 'class: {display: encounterClass}, status: "in-progress"};
    return encounter;
};
