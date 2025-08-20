import ballerina/io;
import ballerinax/health.fhir.r4utils.fhirpath;

json patient = {
    "resourceType": "Patient",
    "id": "1",
    "meta": {
        "profile": [
            "http://hl7.org/fhir/StructureDefinition/Patient"
        ]
    },
    "active": true,
    "name": [
        {
            "use": "official",
            "family": "Chalmers",
            "given": [
                "Peter",
                "James"
            ]
        },
        {
            "use": "usual",
            "given": [
                "Jim"
            ]
        }
    ],
    "birthDate": "1974-12-25",
    "managingOrganization": {
        "reference": "Organization/1",
        "display": "Burgers University Medical Center"
    },
    "address": [
        {
            "use": "home",
            "line": ["123 Main St"],
            "city": "Anytown",
            "state": "CA",
            "postalCode": "12345"
        },
        {
            "use": "work",
            "line": ["456 Work St"],
            "city": "Worktown",
            "state": "CA",
            "postalCode": "67890"
        }
    ]
};

public function main() {

    // Get single value using FHIRPath
    json|error result = fhirpath:getFhirPathValues(patient, "Patient.name[0].given[0]");
    if result is json {
        io:println("1. First given name: ", result);
    }

    // Get all given names from all name records
    json|error allGivenResult = fhirpath:getFhirPathValues(patient, "Patient.name.given[0]");
    if allGivenResult is json {
        io:println("\n2. All first given names: ", allGivenResult);
    }

    // Update a value in the FHIR resource
    json|error updateResult = fhirpath:setFhirPathValues(patient, "Patient.active", false);
    if updateResult is json {
        io:println("\n3. Updated patient after active status change: ", updateResult);
    }

    // Update multiple values in the FHIR resource
    json|error updatedAddresses = fhirpath:setFhirPathValues(patient, "Patient.address.line", "***", validateFHIRResource = false);
    if updatedAddresses is json {
        io:println("\n4. Updated patient after address line masking: ", updatedAddresses);
    }

    // Handle errors
    json|error errorResult = fhirpath:getFhirPathValues(patient, "Patient.invalidPath");
    if errorResult is error {
        io:println("\n5. Error: ", errorResult.message());
    }
}
