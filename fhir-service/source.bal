import fhir_service.db;

import ballerina/http;
import ballerina/persist;
import ballerinax/health.fhir.r4;
import ballerinax/health.fhir.r4.uscore501;

final db:Client dbClient;

function init() returns error? {
    dbClient = check new ();
}

public isolated function getPatient(string id) returns uscore501:USCorePatientProfile|r4:FHIRError {
    lock {
        db:PatientDataOptionalized|persist:Error response = dbClient->/patientdata/[id]();

        if response is persist:Error {
            if response is persist:NotFoundError {
                return r4:createFHIRError(string `No resource found with id: ${id}`,
                        r4:ERROR,
                        r4:PROCESSING_NOT_FOUND,
                        cause = response,
                        httpStatusCode = http:STATUS_NOT_FOUND);
            } else {
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

public isolated function createPatient(uscore501:USCorePatientProfile patient) returns r4:FHIRError|string[] {
    lock {
        db:PatientDataInsert mapFHIRTodbDataResult = mapFhirToDbData(patient);
        string[]|persist:Error response = dbClient->/patientdata.post([mapFHIRTodbDataResult]);

        if response is persist:Error {
            if response is persist:AlreadyExistsError {
                return r4:createFHIRError(string `Resource already found`,
                        r4:ERROR,
                        r4:PROCESSING_DUPLICATE,
                        cause = response,
                        httpStatusCode = http:STATUS_CONFLICT);
            } else {
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
