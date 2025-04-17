import ballerinax/health.fhir.r4;
import ballerinax/health.fhir.r4.medcom240;
import ballerinax/health.hl7v2 as hl7;
import ballerinax/health.hl7v2commons as hl7types;

# Custom v2 to fhir mapping implementation. pv1 segments will refer this when transforming
#
# + pv1 - PV1 segment of message
# + return - Transformed encounter resource
public isolated function pv1ToMedcomEncounter(hl7types:Pv1 pv1) returns medcom240:MedComCoreEncounter {
    string encounterClass = pv1.pv12.toString() == "I" ? "inpatient encounter" : "ambulatory";
    medcom240:MedComCoreEncounter encounter = {
        meta: {
            profile: ["http://medcomfhir.dk/ig/core/StructureDefinition/medcom-core-encounter"]
        },
        id: pv1.pv11.toString(),
        'class: {display: encounterClass},
        status: "in-progress",
        subject: {
            reference: "Patient/221" //this value has to be taken from PID segment, kept a constant for demo purpose
        },
        location: []
    };
    return encounter;
};

# Update resources in the bundle that are defined in Danish IG.
#
# + bundle - Bundle resource from v2toFHIR transformation  
# + incomingMsg - incoming HL7v2 message
# + return - Updated bundle resource
public isolated function processBundle(r4:Bundle bundle, hl7:Message incomingMsg) returns r4:Bundle|error? {

    r4:BundleEntry[] updatedEntries = [];
    r4:BundleEntry[] entries = <r4:BundleEntry[]>bundle.entry;
    foreach var entry in entries {
        r4:Resource unionResult = check entry?.'resource.cloneWithType(r4:Resource);
        string resourceType = unionResult.resourceType;

        match resourceType {
            "Patient" => {
                updatedEntries.push({'resource: check transformPatient(unionResult, incomingMsg)});
            }
            "Encounter" => {
                updatedEntries.push({'resource: check transformEncounter(unionResult, incomingMsg)});
            }
            "DiagnosticReport" => {
                updatedEntries.push({'resource: check transformDiagnosticReport(unionResult, incomingMsg)});
            }
            "Observation" => {
                updatedEntries.push({'resource: check transformObservation(unionResult, incomingMsg)});
            }
            "Organization" => {
                updatedEntries.push({'resource: check transformOrganization(unionResult, incomingMsg)});
            }
            "Practitioner" => {
                updatedEntries.push({'resource: check transformPractitioner(unionResult, incomingMsg)});
            }
            _ => {
                updatedEntries.push(entry);
            }
        }
    }
    bundle.entry = updatedEntries;

    return bundle;

}
