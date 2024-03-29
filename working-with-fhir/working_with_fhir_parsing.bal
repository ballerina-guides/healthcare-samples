import ballerina/io;
import ballerinax/health.fhir.r4 as fhir;
import ballerinax/health.fhir.r4.international401;
import ballerinax/health.fhir.r4.parser as fhirParser;

public function main() returns error? {
    // The following example is a simple serialized Patient resource to parse
    json input = {
        "resourceType": "Patient",
        "name": [
            {
                "family": "Simpson"
            }
        ]
    };

    // Parse it - you can pass the input (as a string or a json) and the
    // type of the resource you want to parse.
    international401:Patient patient = check fhirParser:parse(input).ensureType();

    // Access the parsed data
    fhir:HumanName[]? names = patient.name;
    if names is () || names.length() == 0 {
        return error("Failed to parse the names");
    }
    io:println("Family Name: ", names[0]);
}
