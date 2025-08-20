import ballerina/persist as _;

public type PatientData record {|
    // FHIR: Patient.id
    readonly string id;

    // FHIR: Patient.name[0].text
    string? name;

    // FHIR: Patient.gender
    string? gender;

    // FHIR: Patient.birthDate
    string? birthDate;
|};

public type EncounterData record {|
    // FHIR: Encounter.id
    readonly string id;

    // FHIR: Encounter.status
    string status;  // required

    // FHIR: Encounter.class.system
    string? encounterClassSystem;

    // FHIR: Encounter.class.code
    string? encounterClassCode;

    // FHIR: Encounter.class.display
    string? encounterClassDisplay;

    // FHIR: Encounter.type[0].text
    string? typeText;

    // FHIR: Encounter.subject.reference
    string subjectRef;  // required

    // FHIR: Encounter.period.start
    string? periodStart;

    // FHIR: Encounter.period.end
    string? periodEnd;
|};
