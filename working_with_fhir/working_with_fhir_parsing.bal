import ballerinax/health.fhir.r4.parser as fhirParser;
import ballerinax/health.fhir.r4 as fhir;
import ballerina/io;

public function main() returns error? {

    // The following example is a simple serialized Patient resource to parse
    string input = "{" +
    "\"resourceType\" : \"Patient\"," +
    "  \"name\" : [{" +
    "    \"family\": \"Simpson\"" +
    "  }]" +
    "}";

    // Parse it - you can pass the input string or a json as input and the 
    // type of the resource you want to parse.
    fhir:Patient patient = check fhirParser:parse(input, fhir:Patient).ensureType();

    // Access the parsed data
    fhir:HumanName[] names = patient.name ?: [];
    io:println("Family name: " + (names[0].family ?: ""));
}
