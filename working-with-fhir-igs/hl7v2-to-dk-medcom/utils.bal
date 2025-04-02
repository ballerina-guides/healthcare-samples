import ballerina/log;
import ballerinax/health.fhir.r4;
import ballerinax/health.fhir.r4.international401;
import ballerinax/health.fhir.r4.parser as r4parser;
import ballerinax/health.hl7v2commons as hl7types;

import healthcare/medcom240;

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

public isolated function processBundle(json fhirBundle) returns r4:Bundle|error? {

    r4:Bundle bundle = <r4:Bundle>check r4parser:parse(fhirBundle);
    r4:BundleEntry[] updatedEntries = [];
    if bundle is r4:Bundle {
        r4:BundleEntry[] entries = <r4:BundleEntry[]>bundle.entry;
        foreach var entry in entries {
            map<anydata> fhirResource = <map<anydata>>entry?.'resource;
            if fhirResource["resourceType"].toString() == "Patient" {
                international401:Patient patientResource = <international401:Patient>check r4parser:parse(fhirResource.toJson(), international401:Patient, ());

                log:printInfo(string `Updated Patient resource: ${patientResource.toJsonString()}`);
                updatedEntries.push({'resource: transformPatient(patientResource)});
            } else if fhirResource["resourceType"].toString() == "Encounter" {
                international401:Encounter encounterResource = <international401:Encounter>check r4parser:parse(fhirResource.toJson(), international401:Encounter);

                log:printDebug(string `Encounter resource: ${encounterResource.toJsonString()}`);

                updatedEntries.push({'resource: transformEncounter(encounterResource)});
            } else if fhirResource["resourceType"].toString() == "DiagnosticReport" {
                international401:DiagnosticReport diagnosticReportResource = <international401:DiagnosticReport>check r4parser:parse(fhirResource.toJson());

                log:printDebug(string `DiagnosticReport resource: ${diagnosticReportResource.toJsonString()}`);

                updatedEntries.push({'resource: transformDiagnosticReport(diagnosticReportResource)});

            } else if fhirResource["resourceType"].toString() == "Observation" {
                international401:Observation observationResource = <international401:Observation>check r4parser:parse(fhirResource.toJson());

                log:printDebug(string `Observation resource: ${observationResource.toJsonString()}`);

                updatedEntries.push({'resource: transformObservation(observationResource)});
            } else if fhirResource["resourceType"].toString() == "Organization" {
                international401:Organization organizationResource = <international401:Organization>check r4parser:parse(fhirResource.toJson());

                log:printDebug(string `Organization resource: ${organizationResource.toJsonString()}`);

                updatedEntries.push({'resource: transformOrganization(organizationResource)});
            } else if fhirResource["resourceType"].toString() == "Practitioner" {
                international401:Practitioner practitionerResource = <international401:Practitioner>check r4parser:parse(fhirResource.toJson());

                log:printDebug(string `Practitioner resource: ${practitionerResource.toJsonString()}`);

                updatedEntries.push({'resource: transformPractitioner(practitionerResource)});
            } else {
                updatedEntries.push(entry);
            }
        }
    }
    bundle.entry = updatedEntries;

    return bundle;

}

