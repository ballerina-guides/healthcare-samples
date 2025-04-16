import ballerina/uuid;
import ballerinax/health.fhir.r4;
import ballerinax/health.fhir.r4.international401;
import ballerinax/health.hl7v2 as hl7;
import ballerinax/health.hl7v23;
import ballerinax/health.fhir.r4.medcom240;


# Custom values can be populated using the incoing message. Result need to be merge with original resource.
#
# + originalMessage - incoming HL7v2 message
# + return - Patient resource containing only the customly mapped values.
public isolated function createCustomPatient(hl7:Message originalMessage) returns medcom240:MedComCorePatient|error {

    hl7v23:ADT_A01 adtMsg = <hl7v23:ADT_A01>originalMessage;
    hl7v23:PID pidSegment = adtMsg.pid;
    hl7v23:PV1 pv1Segment = adtMsg.pv1;

    string internalId = pidSegment.pid3[0].cx1;
    string danishFHIRId = uuid:createType1AsString();
    string familyName = pidSegment.pid5[0].xpn1;
    string givenName = pidSegment.pid5[0].xpn2;

    string referringDoctorId = pv1Segment.pv18[0].xcn1;

    medcom240:MedComCorePatientIdentifierD_ecpr deprIdentifier = {
        value: internalId

    };

    medcom240:MedComCorePatientIdentifierCpr cprIdentifier = {
        value: danishFHIRId
    };

    medcom240:MedComCorePatientNameOfficial slicedName = {
        family: familyName,
        given: [givenName]
    };

    medcom240:MedComCorePatientGeneralPractitionerReferencedSORUnit slicedPractitioner = {
        identifier: {
            value: referringDoctorId,
            system: "urn:oid:1.2.208.176.1.1",
            use: "official"
        }

    };
    r4:canonical[] profiles = ["http://medcomfhir.dk/ig/core/StructureDefinition/medcom-core-patient"];

    medcom240:MedComCorePatient customPatient = {

        identifier: [cprIdentifier, deprIdentifier],
        name: [slicedName],
        generalPractitioner: [slicedPractitioner],
        meta: {
            profile: profiles
        }
    };

    return customPatient;
}

# Transformation function for patient resource. Includes custom mappings as well
#
# + originalResource - generic R4 resource  
# + incomingMsg - original HL7v2 message
# + return - completed Danish FHIR profiled resource
public isolated function transformPatient(r4:Resource originalResource, hl7:Message incomingMsg) returns medcom240:MedComCorePatient|error {

    international401:Patient patient = check originalResource.cloneWithType(international401:Patient);

    // add IG specific constrained values for typed clone.
    patient.identifier = [];
    patient.name = [];

    medcom240:MedComCorePatient originalPatient = check patient.cloneWithType(medcom240:MedComCorePatient);
    medcom240:MedComCorePatient customPatient = check createCustomPatient(incomingMsg);

    //Merge identifiers
    if originalPatient.identifier.length() == 0 {
        originalPatient.identifier = customPatient.identifier;
    } else {
        foreach medcom240:MedComCorePatientIdentifierD_ecpr|medcom240:MedComCorePatientIdentifierCpr identifier in customPatient.identifier {
            originalPatient.identifier.push(identifier);
        }
    }

    //Merge Names
    if originalPatient.name.length() == 0 {
        originalPatient.name = customPatient.name;
    } else {
        foreach r4:HumanName|medcom240:MedComCorePatientNameOfficial name in customPatient.name {
            originalPatient.name.push(name);
        }
    }

    //Set profile
    originalPatient.meta.profile = customPatient.meta?.profile;

    return originalPatient;
}

# Contains generic convertion and type casting implementation for Encounter resource.
#
# + originalResource - generic R4 resource  
# + incomingMsg - original HL7v2 message
# + return - completed Danish FHIR profiled resource
public isolated function transformEncounter(r4:Resource originalResource, hl7:Message incomingMsg) returns medcom240:MedComCoreEncounter|error {

    international401:Encounter typedResource = check originalResource.cloneWithType(international401:Encounter);

    // add IG specific constrained values for typed clone.
    typedResource.subject = {};

    medcom240:MedComCoreEncounter castedResource = check typedResource.cloneWithType(medcom240:MedComCoreEncounter);
    r4:canonical[] profiles = ["http://medcomfhir.dk/ig/core/StructureDefinition/medcom-core-encounter"];

    castedResource.meta.profile = profiles;

    return castedResource;
}

public isolated function transformDiagnosticReport(r4:Resource originalResource, hl7:Message incomingMsg) returns medcom240:MedComCoreDiagnosticReport|error {

    international401:DiagnosticReport typedResource = check originalResource.cloneWithType(international401:DiagnosticReport);

    // add IG specific constrained values for typed clone.
    typedResource.subject = {};
    typedResource.status = "registered";
    typedResource.issued = "2015-02-07T13:28:17.239+02:00";

    medcom240:MedComCoreDiagnosticReport castedResource = check typedResource.cloneWithType(medcom240:MedComCoreDiagnosticReport);
    r4:canonical[] profiles = ["http://medcomfhir.dk/ig/core/StructureDefinition/medcom-core-diagnosticreport"];

    castedResource.meta.profile = profiles;

    return castedResource;
}

public isolated function transformObservation(r4:Resource originalResource, hl7:Message incomingMsg) returns medcom240:MedComCoreObservation|error {

    international401:Observation typedResource = check originalResource.cloneWithType(international401:Observation);

    // add IG specific constrained values for typed clone.
    typedResource.subject = {};

    medcom240:MedComCoreObservation castedResource = check typedResource.cloneWithType(medcom240:MedComCoreObservation);
    r4:canonical[] profiles = ["http://medcomfhir.dk/ig/core/StructureDefinition/medcom-core-diagnosticreport"];

    castedResource.meta.profile = profiles;

    return castedResource;
}

public isolated function transformOrganization(r4:Resource originalResource, hl7:Message incomingMsg) returns medcom240:MedComCoreOrganization|error {

    international401:Organization typedResource = check originalResource.cloneWithType(international401:Organization);

    // add IG specific constrained values for typed clone.
    typedResource.identifier = [];

    medcom240:MedComCoreOrganization castedResource = check typedResource.cloneWithType(medcom240:MedComCoreOrganization);
    r4:canonical[] profiles = ["http://medcomfhir.dk/ig/core/StructureDefinition/medcom-core-organization"];

    castedResource.meta.profile = profiles;

    return castedResource;
}

public isolated function transformPractitioner(r4:Resource originalResource, hl7:Message incomingMsg) returns medcom240:MedComCorePractitioner|error {

    international401:Practitioner typedResource = check originalResource.cloneWithType(international401:Practitioner);

    medcom240:MedComCorePractitioner castedResource = check typedResource.cloneWithType(medcom240:MedComCorePractitioner);
    r4:canonical[] profiles = ["http://medcomfhir.dk/ig/core/StructureDefinition/medcom-core-practitioner"];

    castedResource.meta.profile = profiles;

    return castedResource;
}
