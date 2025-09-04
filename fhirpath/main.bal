import ballerina/io;
import ballerina/lang.regexp;
import ballerinax/health.fhir.r4utils.fhirpath;

json patient = {
    "resourceType": "Patient",
    "id": "12345",
    "active": true,
    "name": [
        {
            "use": "official",
            "family": "Smith",
            "given": ["John", "Michael"]
        },
        {
            "use": "usual",
            "given": ["Johnny"]
        }
    ],
    "gender": "male",
    "birthDate": "1985-06-15",
    "address": [
        {
            "use": "home",
            "line": ["123 Main Street", "Apt 4B"],
            "city": "Springfield",
            "state": "IL",
            "postalCode": "62701"
        }
    ],
    "telecom": [
        {
            "system": "phone",
            "value": "+1-555-123-4567",
            "use": "mobile"
        },
        {
            "system": "email",
            "value": "john.smith@email.com"
        }
    ]
};

public function extract() {
    io:println("\n", "Extract values from FHIR resource");
    io:println("------------------------------------------------------------------");

    // Extract simple value - patient's id
    json|error id = fhirpath:getValuesFromFhirPath(patient, "Patient.id");
    io:println("Patient ID(s): ", id);

    // Extract multiple values from an array - all the given names of the patient
    json|error allGivenNames = fhirpath:getValuesFromFhirPath(patient, "Patient.name.given");
    io:println("Given name(s): ", allGivenNames);

    // Extract a specific value from an array - phone number of the patient
    json|error phoneNumber = fhirpath:getValuesFromFhirPath(patient, "Patient.telecom[0].value");
    io:println("Phone Number(s): ", phoneNumber);
}

public function modify() {
    io:println("\n", "Modify values in FHIR resource");
    io:println("------------------------------------------------------------------");

    // Modify a simple value - patient's active status
    json|error activeModifiedPatient = fhirpath:setValuesToFhirPath(patient.clone(), "Patient.active", false);
    io:println("Active status modified patient resource:", "\n", activeModifiedPatient, "\n");

    // Modify multiple values in an array - Mask patient's given names
    // Since the given name should be an array and we change it to string, it will result in an validation error. We can use the `validateFHIRResource` flag to bypass this.
    json|error namesMaskedPatient = fhirpath:setValuesToFhirPath(patient.clone(), "Patient.name.given", "***");
    io:println("Names masked patient resource:", "\n", namesMaskedPatient, "\n");

    // Change a specific value - patient's phone number
    json|error phoneNumberModifiedPatient = fhirpath:setValuesToFhirPath(patient.clone(), "Patient.telecom[0].value", "000-000-0000");
    io:println("Phone number modified patient resource:", "\n", phoneNumberModifiedPatient, "\n");
}

public function createNewPath() {
    io:println("Create new FHIR path");
    io:println("------------------------------------------------------------------");

    // Create a new FHIR path - add a age of the patient
    // Add `createMissingPaths = true` in Config.toml under [ballerinax.health.fhir.r4utils.fhirpath] to create missing paths
    json|error newAgePatient = fhirpath:setValuesToFhirPath(patient.clone(), "Patient.age", 30);
    io:println("New age added patient:", "\n", newAgePatient, "\n");
}

public function redact() {
    io:println("Redact values in FHIR resource");
    io:println("------------------------------------------------------------------");

    // Redact multiple values - patient's contact information
    json|error contactInfoRemovedPatient = fhirpath:setValuesToFhirPath(patient.clone(), "Patient.telecom.value", ());
    io:println("Contact information removed patient:", "\n", contactInfoRemovedPatient, "\n");
}

isolated function removeDayFromDate(json value) returns json|fhirpath:ModificationFunctionError {
    if value is string {
        // Assuming the date is in the format "YYYY-MM-DD"
        // Split the string using "-" delimiter with regexp
        regexp:RegExp|error regexResult = regexp:fromString("-");
        if regexResult is error {
            return error("Error creating regex pattern", value = value.toString());
        }

        string[] parts = regexp:split(regexResult, value);
        if parts.length() == 3 {
            // Return the date without the day
            return parts[0] + "-" + parts[1];
        }
        // If the date format is not as expected, return an error
        return error("Invalid date format", value = value.toString());
    }
    return value;
}

public function customModification() {
    io:println("Custom modifications to FHIR resource");
    io:println("------------------------------------------------------------------");

    // Read and modify a value - remove day from patient's birthday
    json|error birthdayModifiedPatient = fhirpath:setValuesToFhirPath(patient.clone(), "Patient.birthDate", removeDayFromDate);
    io:println("Birthday modified patient:", "\n", birthdayModifiedPatient, "\n");
}

public function main() {
    io:println("Original Patient Resource:", "\n", patient);
    extract();
    modify();
    createNewPath();
    redact();
    customModification();
}
