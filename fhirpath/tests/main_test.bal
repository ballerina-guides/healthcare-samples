// Copyright (c) 2026, WSO2 LLC. (http://www.wso2.com).

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
import ballerina/test;
import ballerinax/health.fhir.r4utils.fhirpath;

@test:Config {}
function testExtract() returns error? {
    // Extract simple value - patient's id
    json|error id = fhirpath:getValuesFromFhirPath(patient, "Patient.id");
    test:assertEquals(id, ["12345"]);

    // Extract multiple values from an array - all the given names of the patient
    json|error allGivenNames = fhirpath:getValuesFromFhirPath(patient, "Patient.name.given");
    test:assertEquals(allGivenNames, ["John", "Michael", "Johnny"]);

    // Extract a specific value from an array - phone number of the patient
    json|error phoneNumber = fhirpath:getValuesFromFhirPath(patient, "Patient.telecom[0].value");
    test:assertEquals(phoneNumber, ["+1-555-123-4567"]);
}

@test:Config {}
function testModify() returns error? {
    // Modify a simple value - patient's active status
    json|error activeModifiedPatient = fhirpath:setValuesToFhirPath(patient.clone(), "Patient.active", false);
    if activeModifiedPatient is json {
        test:assertEquals(check activeModifiedPatient.active, false);
    } else {
        test:assertFail("Expected json but got error: " + activeModifiedPatient.message());
    }

    // Modify multiple values in an array - Mask patient's given names
    json|error namesMaskedPatient = fhirpath:setValuesToFhirPath(patient.clone(), "Patient.name.given", "***");
    if namesMaskedPatient is json {
        json expectedNames = [
            {
                "use": "official",
                "family": "Smith",
                "given": "***"
            },
            {
                "use": "usual",
                "given": "***"
            }
        ];
        test:assertEquals(check namesMaskedPatient.name, expectedNames);
    } else {
        test:assertFail("Expected json but got error: " + namesMaskedPatient.message());
    }

    // Change a specific value - patient's phone number
    json|error phoneNumberModifiedPatient = fhirpath:setValuesToFhirPath(patient.clone(), "Patient.telecom[0].value", "000-000-0000");
    if phoneNumberModifiedPatient is json {
        json[] telecomArr = <json[]>check phoneNumberModifiedPatient.telecom;
        test:assertEquals(check telecomArr[0].value, "000-000-0000");
    } else {
        test:assertFail("Expected json but got error: " + phoneNumberModifiedPatient.message());
    }
}

@test:Config {}
function testCreateNewPath() returns error? {
    // Setting a non-existent path should return an error
    json|error newAgePatient = fhirpath:setValuesToFhirPath(patient.clone(), "Patient.age", 30);
    if newAgePatient is error {
        test:assertEquals(newAgePatient.message(), "Path 'age' does not exist in the resource");
    } else {
        test:assertFail("Expected error but got json");
    }
}

@test:Config {}
function testRedact() returns error? {
    // Redact multiple values - patient's contact information
    json|error contactInfoRemovedPatient = fhirpath:setValuesToFhirPath(patient.clone(), "Patient.telecom.value", ());
    if contactInfoRemovedPatient is json {
        json expectedTelecom = [
            {
                "system": "phone",
                "use": "mobile"
            },
            {
                "system": "email"
            }
        ];
        test:assertEquals(check contactInfoRemovedPatient.telecom, expectedTelecom);
    } else {
        test:assertFail("Expected json but got error: " + contactInfoRemovedPatient.message());
    }
}

@test:Config {}
function testCustomModification() returns error? {
    // Read and modify a value - remove day from patient's birthday
    json|error birthdayModifiedPatient = fhirpath:setValuesToFhirPath(patient.clone(), "Patient.birthDate", removeDayFromDate);
    if birthdayModifiedPatient is json {
        test:assertEquals(check birthdayModifiedPatient.birthDate, "1985-06");
    } else {
        test:assertFail("Expected json but got error: " + birthdayModifiedPatient.message());
    }
}
