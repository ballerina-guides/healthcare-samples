import ballerina/http;
import ballerina/log;
import ballerinax/health.fhir.r4;
import healthcare_samples/carinbb_package as carinbb;

public type Patient record {
    string id;
    string lastName?;
    string firstName;
    string middleName;
    string gender?;
};

service / on new http:Listener(9090) {

    isolated resource function get [string fhirType]/[string id]() returns @http:Payload {
        mediaType: [
            "application/fhir+json"
        ]
    } r4:FHIRWireFormat|error {

        // Mock Patient payload from legacy healthcare system
        Patient patient = {
            id: "2121",
            lastName: "Doe",
            firstName: "John",
            middleName: "Hemish",
            gender: "male"
        };

        // Convert to Carin BB Patient structure.
        carinbb:C4BBPatient c4bbPatient = {
            id: patient.id,
            identifier: [
                {
                    system: "http://hl7.org/fhir/sid/us-ssn",
                    value: patient.id
                }
            ]
    ,
            gender: <carinbb:C4BBPatientGender>patient.gender,
            name: [
                {
                    family: patient.lastName,
                    given: [patient.firstName, patient.middleName]
                }
            ]
        ,meta: {lastUpdated: "", profile: []}};

        log:printInfo("Responded Patient Resource: " + c4bbPatient.toString());
        return c4bbPatient.toJson();
    }
}
