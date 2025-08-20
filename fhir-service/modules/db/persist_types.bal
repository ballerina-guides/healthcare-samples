// AUTO-GENERATED FILE. DO NOT MODIFY.

// This file is an auto-generated file by Ballerina persistence layer for model.
// It should not be modified by hand.

public type PatientData record {|
    readonly string id;
    string? name;
    string? gender;
    string? birthDate;
|};

public type PatientDataOptionalized record {|
    string id?;
    string? name?;
    string? gender?;
    string? birthDate?;
|};

public type PatientDataTargetType typedesc<PatientDataOptionalized>;

public type PatientDataInsert PatientData;

public type PatientDataUpdate record {|
    string? name?;
    string? gender?;
    string? birthDate?;
|};

public type EncounterData record {|
    readonly string id;
    string status;
    string? encounterClassSystem;
    string? encounterClassCode;
    string? encounterClassDisplay;
    string? typeText;
    string subjectRef;
    string? periodStart;
    string? periodEnd;
|};

public type EncounterDataOptionalized record {|
    string id?;
    string status?;
    string? encounterClassSystem?;
    string? encounterClassCode?;
    string? encounterClassDisplay?;
    string? typeText?;
    string subjectRef?;
    string? periodStart?;
    string? periodEnd?;
|};

public type EncounterDataTargetType typedesc<EncounterDataOptionalized>;

public type EncounterDataInsert EncounterData;

public type EncounterDataUpdate record {|
    string status?;
    string? encounterClassSystem?;
    string? encounterClassCode?;
    string? encounterClassDisplay?;
    string? typeText?;
    string subjectRef?;
    string? periodStart?;
    string? periodEnd?;
|};

