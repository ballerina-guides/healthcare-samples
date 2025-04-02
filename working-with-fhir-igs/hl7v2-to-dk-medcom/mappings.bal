import ballerinax/health.fhir.r4;
import ballerinax/health.fhir.r4.international401;

import healthcare/medcom240;

public isolated function transformPatient(international401:Patient patient) returns medcom240:MedComCorePatient {

    medcom240:MedComCorePatient result = {
        id: patient.id,
        identifier: [],
        gender: patient.gender,
        extension: patient.extension,
        modifierExtension: patient.modifierExtension,
        link: patient.link,

        communication: patient.communication,

        name: [],
        language: patient.language,
        contact: patient.contact,
        deceasedDateTime: patient.deceasedDateTime,
        generalPractitioner: patient.generalPractitioner,
        telecom: patient.telecom,
        text: patient.text,
        address: patient.address,
        multipleBirthBoolean: patient.multipleBirthBoolean,
        active: patient.active,
        photo: patient.photo,
        birthDate: patient.birthDate,
        contained: patient.contained,
        deceasedBoolean: patient.deceasedBoolean,
        managingOrganization: patient.managingOrganization,
        meta: patient.meta,
        multipleBirthInteger: patient.multipleBirthInteger,
        implicitRules: patient.implicitRules,
        maritalStatus: patient.maritalStatus
    };

    r4:Identifier[]? originalIdentifiers = patient.identifier;
    if originalIdentifiers is r4:Identifier[] {
        result.identifier = originalIdentifiers;
    }

    r4:HumanName[]? originalNames = patient.name;
    if originalNames is r4:HumanName[] {
        result.name = originalNames;
    }

    r4:canonical[] profiles = ["URL"];

    result.meta.profile = profiles;

    medcom240:MedComCorePatientIdentifierCpr identifier = {
        system: "system",
        value: "wso2id"
    };

    result.identifier.push(identifier);

    return result;
}

public isolated function transformEncounter(international401:Encounter encounter) returns medcom240:MedComCoreEncounter {

    medcom240:MedComCoreEncounter result = {

        'class: encounter.'class,
        subject: {},
        status: encounter.status,

        serviceType: encounter.serviceType,
        partOf: encounter.partOf,
        extension: encounter.extension,
        modifierExtension: encounter.modifierExtension,
        reasonReference: encounter.reasonReference,
        appointment: encounter.appointment,
        language: encounter.language,
        'type: encounter.'type,
        participant: encounter.participant,
        episodeOfCare: encounter.episodeOfCare,
        id: encounter.id,
        reasonCode: encounter.reasonCode,
        text: encounter.text,
        basedOn: encounter.basedOn,
        identifier: encounter.identifier,
        period: encounter.period,
        classHistory: encounter.classHistory,
        hospitalization: encounter.hospitalization,
        length: encounter.length,
        diagnosis: encounter.diagnosis,
        priority: encounter.priority,
        contained: encounter.contained,
        statusHistory: encounter.statusHistory,
        meta: encounter.meta,
        serviceProvider: encounter.serviceProvider,
        implicitRules: encounter.implicitRules,
        location: encounter.location,
        account: encounter.account

    };

    r4:canonical[] profiles = ["URL"];

    result.meta.profile = profiles;

    return result;
}

public isolated function transformDiagnosticReport(international401:DiagnosticReport diagnosticReport) returns medcom240:MedComCoreDiagnosticReport {

    medcom240:MedComCoreDiagnosticReport result = {
        // Required fields
        code: diagnosticReport.code,
        subject: {},
        issued: "",
        status: diagnosticReport.status,

        extension: diagnosticReport.extension,
        modifierExtension: diagnosticReport.modifierExtension,
        presentedForm: diagnosticReport.presentedForm,
        language: diagnosticReport.language,
        media: diagnosticReport.media,
        conclusion: diagnosticReport.conclusion,
        result: diagnosticReport.result,
        specimen: diagnosticReport.specimen,
        id: diagnosticReport.id,
        text: diagnosticReport.text,
        basedOn: diagnosticReport.basedOn,
        identifier: diagnosticReport.identifier,
        performer: diagnosticReport.performer,
        effectivePeriod: diagnosticReport.effectivePeriod,
        resultsInterpreter: diagnosticReport.resultsInterpreter,
        conclusionCode: diagnosticReport.conclusionCode,
        encounter: diagnosticReport.encounter,
        contained: diagnosticReport.contained,
        effectiveDateTime: diagnosticReport.effectiveDateTime,
        meta: diagnosticReport.meta,
        implicitRules: diagnosticReport.implicitRules,
        category: diagnosticReport.category,
        imagingStudy: diagnosticReport.imagingStudy
    };

    r4:Reference? subject = diagnosticReport.subject;
    if subject is r4:Reference {
        result.subject = subject;
    }

    r4:instant? originaInstant = diagnosticReport.issued;
    if originaInstant is r4:instant {
        result.issued = originaInstant;
    }

    r4:canonical[] profiles = ["URL"];

    result.meta.profile = profiles;

    return result;
}

public isolated function transformObservation(international401:Observation observation) returns medcom240:MedComCoreObservation {

    medcom240:MedComCoreObservation result = {
        // Required fields
        code: observation.code,
        subject: {},
        status: <medcom240:MedComCoreObservationStatus>observation.status,

        valueBoolean: observation.valueBoolean,
        dataAbsentReason: observation.dataAbsentReason,
        note: observation.note,
        partOf: observation.partOf,
        extension: observation.extension,
        valueTime: observation.valueTime,
        valueRange: observation.valueRange,
        modifierExtension: observation.modifierExtension,
        focus: observation.focus,
        language: observation.language,
        valueCodeableConcept: observation.valueCodeableConcept,
        valueRatio: observation.valueRatio,
        specimen: observation.specimen,
        derivedFrom: observation.derivedFrom,
        valueDateTime: observation.valueDateTime,
        id: observation.id,
        text: observation.text,
        issued: observation.issued,
        valueInteger: observation.valueInteger,
        basedOn: observation.basedOn,
        valueQuantity: observation.valueQuantity,
        identifier: observation.identifier,
        performer: observation.performer,
        effectivePeriod: observation.effectivePeriod,
        effectiveTiming: observation.effectiveTiming,
        method: observation.method,
        hasMember: observation.hasMember,
        encounter: observation.encounter,
        bodySite: observation.bodySite,
        component: [],
        contained: observation.contained,
        referenceRange: observation.referenceRange,
        valueString: observation.valueString,
        effectiveDateTime: observation.effectiveDateTime,
        interpretation: observation.interpretation,
        meta: observation.meta,
        valueSampledData: observation.valueSampledData,
        valuePeriod: observation.valuePeriod,
        implicitRules: observation.implicitRules,
        category: observation.category,
        device: observation.device,
        effectiveInstant: observation.effectiveInstant
    };

    // Handle subject which is required but might be null in the source
    r4:Reference? subject = observation.subject;
    if subject is r4:Reference {
        result.subject = subject;
    }

    // Set the profile
    r4:canonical[] profiles = ["URL"];

    // Check if meta exists, if not create it
    if result.meta is () {
        result.meta = {};
    }

    // Now safely set the profile
    result.meta.profile = profiles;

    return result;
}

public isolated function transformOrganization(international401:Organization organization) returns medcom240:MedComCoreOrganization {

    medcom240:MedComCoreOrganization result = {
        // Required field
        identifier: [],

        // Remaining elements
        partOf: organization.partOf,
        extension: organization.extension,
        address: organization.address,
        modifierExtension: organization.modifierExtension,
        active: organization.active,
        language: organization.language,
        'type: organization.'type,
        endpoint: organization.endpoint,
        contained: organization.contained,
        meta: organization.meta,
        contact: organization.contact,
        name: organization.name,
        alias: organization.alias,
        implicitRules: organization.implicitRules,
        telecom: organization.telecom,
        id: organization.id,
        text: organization.text
    };

    // Handle identifier which is required
    r4:Identifier[]? identifiers = organization.identifier;
    if identifiers is r4:Identifier[] {
        result.identifier = identifiers;
    }

    // Set the profile
    r4:canonical[] profiles = ["URL"];

    // Check if meta exists, if not create it
    if result.meta is () {
        result.meta = {};
    }

    // Now safely set the profile
    result.meta.profile = profiles;

    return result;
}

public isolated function transformPractitioner(international401:Practitioner practitioner) returns medcom240:MedComCorePractitioner {

    medcom240:MedComCorePractitioner result = {

        // Map all fields from source
        identifier: practitioner.identifier,
        extension: practitioner.extension,
        address: practitioner.address,
        gender: practitioner.gender,
        modifierExtension: practitioner.modifierExtension,
        active: practitioner.active,
        photo: practitioner.photo,
        language: practitioner.language,
        birthDate: practitioner.birthDate,
        qualification: practitioner.qualification,
        contained: practitioner.contained,
        meta: practitioner.meta,
        name: practitioner.name,
        implicitRules: practitioner.implicitRules,
        telecom: practitioner.telecom,
        id: practitioner.id,
        text: practitioner.text,
        communication: practitioner.communication
    };

    // Set the profile
    r4:canonical[] profiles = ["URL"];

    // Check if meta exists, if not create it
    if result.meta is () {
        result.meta = {};
    }

    // Now safely set the profile
    result.meta.profile = profiles;

    return result;
}
