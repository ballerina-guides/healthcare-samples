import ballerina/io;
import ballerinax/health.fhir.r4.parser as fhirParser;
import ballerinax/health.fhir.r4 as fhir;

final string patientData = string `{"resourceType" : "Patient", "name" : [{"family" : "Simpson"}]}`;

public function main(string input = patientData) returns error? {
    // Parse the input string to a FHIR Patient object
    fhir:Patient patient = check fhirParser:parse(input, fhir:Patient).ensureType();

    // Access the parsed data
    fhir:HumanName[]? names = patient.name;
    if names is () || names.length() == 0 {
        return error("Failed to parse the names");
    }
    io:println("Family Name: ", names[0]);
}
