import ballerina/io;
import ballerinax/health.fhir.r4;
import ballerinax/health.hl7v2;
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
    r4:Bundle transformedBundle = check v2tofhirResult.cloneWithType(r4:Bundle);

    // Parsing HL7v2 message
    hl7v2:Message incomingMsg = check hl7v2:parse(msg);

    // Casting to Danish IG resources
    //http://medcomfhir.dk/ig/core/2.4.0/
    r4:Bundle castedBundle = <r4:Bundle>check processBundle(transformedBundle, incomingMsg);
    io:println("Danish FHIR bundle: ", castedBundle);
    io:println("------------------------------------------------------------------");

    // You can also bind custom mapping function implementations by overriding 
    // the default mapping functions. Following are the supported mapping functions. These functions are
    // defined to map Hl7 segments to FHIR resources as per the standard mappings defined at 
    // https://build.fhir.org/ig/HL7/v2-to-fhir/branches/master/segment_maps.html.
    // Supported functions: Pv1ToPatient, Pv1ToEncounter, Nk1ToPatient, Pd1ToPatient, PidToPatient, Dg1ToCondition,
    // ObxToObservation, ObrToDiagnosticReport, Al1ToAllerygyIntolerance, EvnToProvenance, MshToMessageHeader,
    // Pv2ToEncounter, OrcToImmunization.
    v2tofhirr4:V2SegmentToFhirMapper customMapper = {
        pv1ToEncounter: pv1ToMedcomEncounter
    };
    // You can pass the custom mapper implementation as a function parameter to the v2ToFhir module.
    v2tofhirResult = check v2tofhirr4:v2ToFhir(msg, customMapper);
    io:println("Transformed FHIR message using the custom mapper: ", v2tofhirResult.toString());
    io:println("------------------------------------------------------------------");

}
