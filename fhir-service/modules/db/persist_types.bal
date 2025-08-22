// Copyright (c) 2025, WSO2 LLC. (http://www.wso2.com).

// WSO2 LLC. licenses this file to you under the Apache License,
// Version 2.0 (the "License"); you may not use this file except
// in compliance with the License.
// You may obtain a copy of the License at

// http://www.apache.org/licenses/LICENSE-2.0

// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.

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

