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

import fhir_service.db;

import ballerina/http;
import ballerina/persist;
import ballerinax/health.fhir.r4;
import ballerinax/health.fhir.r4.uscore700;

final db:Client dbClient;

function init() returns error? {
    dbClient = check new ();
}

public isolated function getPatient(string id) returns uscore700:USCorePatientProfile|r4:FHIRError {
    lock {
        db:PatientDataOptionalized|persist:Error response = dbClient->/patientdata/[id]();

        if response is persist:Error {
            if response is persist:NotFoundError {

                // These errors will later be converted to the OperationOutcome. 
                return r4:createFHIRError(string `No resource found with id: ${id}`,
                        r4:ERROR,
                        r4:PROCESSING_NOT_FOUND,
                        cause = response,
                        httpStatusCode = http:STATUS_NOT_FOUND);
            } else {

                // These errors will later be converted to the OperationOutcome.
                return r4:createFHIRError(string `Something went wrong while querying data for id: ${id}`,
                        r4:ERROR,
                        r4:SECURITY_UNKNOWN,
                        cause = response,
                        httpStatusCode = http:STATUS_INTERNAL_SERVER_ERROR);
            }
        } else {
            return mapDbDataToFHIR(response);
        }

    }

}

public isolated function createPatient(uscore700:USCorePatientProfile patient) returns r4:FHIRError|string[] {
    lock {
        db:PatientDataInsert mapFHIRTodbDataResult = mapFhirToDbData(patient);
        string[]|persist:Error response = dbClient->/patientdata.post([mapFHIRTodbDataResult]);

        if response is persist:Error {
            if response is persist:AlreadyExistsError {

                // These errors will later be converted to the OperationOutcome.
                return r4:createFHIRError(string `Resource already found`,
                        r4:ERROR,
                        r4:PROCESSING_DUPLICATE,
                        cause = response,
                        httpStatusCode = http:STATUS_CONFLICT);
            } else {

                // These errors will later be converted to the OperationOutcome.
                return r4:createFHIRError(string `Something went wrong while storing the data`,
                        r4:ERROR,
                        r4:SECURITY_UNKNOWN,
                        cause = response,
                        httpStatusCode = http:STATUS_INTERNAL_SERVER_ERROR);
            }
        }
        return response;
    }
}
