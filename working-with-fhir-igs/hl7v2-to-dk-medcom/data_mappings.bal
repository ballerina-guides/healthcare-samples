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

import ballerina/uuid;
import ballerinax/health.fhir.r4;
import ballerinax/health.fhir.r4.medcom240;
import ballerinax/health.hl7v23;

isolated function mapMedcomPatient(hl7v23:ADT_A01 incomingMessage) returns medcom240:MedComCorePatient => let
var familyName = incomingMessage.pid.pid5[0].xpn1,
var givenName = incomingMessage.pid.pid5[0].xpn2,
medcom240:MedComCorePatientIdentifierCpr cprIdentifier = {
        value: uuid:createType1AsString()
    },
    medcom240:MedComCorePatientNameOfficial slicedName = {
        family: familyName,
        given: [givenName]
    },
    medcom240:MedComCorePatientGeneralPractitionerReferencedSORUnit slicedPractitioner = {
        identifier: {
            value: incomingMessage.pv1.pv18[0].xcn1,
            system: "urn:oid:1.2.208.176.1.1",
            use: "official"
        }

    },
    r4:canonical[] profiles = ["http://medcomfhir.dk/ig/core/StructureDefinition/medcom-core-patient"]
    in {
        identifier: [

            <medcom240:MedComCorePatientIdentifierD_ecpr>{
                value: incomingMessage.pid.pid3[0].cx1

            },
            cprIdentifier

        ],
        name: [
            slicedName
        ],
        generalPractitioner: [
            slicedPractitioner
        ],
        meta: {
            profile: profiles
        },
        id: incomingMessage.pid.pid1
    };

isolated function mapMedcomEncounter(hl7v23:ADT_A01 incomingMessage) returns medcom240:MedComCoreEncounter => let
r4:canonical[] profiles = ["http://medcomfhir.dk/ig/core/StructureDefinition/medcom-core-patient"]
    in {

        'class: {code: "IMP"},
        subject: {},
        status: "in-progress",
        meta: {profile: profiles}
    };

isolated function mapMedcomDiagnosticReport(hl7v23:ADT_A01 incomingMessage) returns medcom240:MedComCoreDiagnosticReport => let
r4:canonical[] profiles = ["http://medcomfhir.dk/ig/core/StructureDefinition/medcom-core-diagnosticreport"]
    in {

        issued: "2015-02-07T13:28:17.239+02:00",
        subject: {},
        status: "registered",
        meta: {profile: profiles}
        ,
        code: {}
    };

isolated function mapMedcomPractitioner(hl7v23:ADT_A01 incomingMessage) returns medcom240:MedComCorePractitioner => let
r4:canonical[] profiles = ["http://medcomfhir.dk/ig/core/StructureDefinition/medcom-core-practitioner"]
    in {
        meta: {profile: profiles}
    };
