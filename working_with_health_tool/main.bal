import ballerina/http;
import ballerinax/health.fhir.r4;
import healthcare_samples/carinbb_package as carinbb;

listener http:Listener httpListener = new (9090);

public type Patient record {
    string id;
    string lastName?;
    string firstName;
    string middleName;
    string gender?;
};

service / on httpListener {

    isolated resource function get [string fhirType]/[string id]() returns @http:Payload {mediaType: ["application/fhir+json", "application/fhir+xml"]}r4:FHIRWireFormat|error {

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
            gender: <carinbb:PatientGender>patient.gender,
            name: [
                {
                    family: patient.lastName,
                    given: [patient.firstName, patient.middleName]
                }
            ]
        };

        return c4bbPatient.toJson();
    }
}
