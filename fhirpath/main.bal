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
    io:println("[EXTRACT] >>>");

    // 1. Extract simple value - patient's id
    json|error id = fhirpath:getFhirPathValues(patient, "Patient.id");
    io:println("1. Patient ID: ", id);

    // 2. Extract multiple values from an array - all the given names of the patient
    json|error allGivenNames = fhirpath:getFhirPathValues(patient, "Patient.name.given");
    io:println("2. All given names: ", allGivenNames);

    // 3. Extract a specific value from an array - phone number of the patient
    json|error phoneNumber = fhirpath:getFhirPathValues(patient, "Patient.telecom[0].value");
    io:println("3. Phone Number: ", phoneNumber);
}

public function modify() {
    io:println("[MODIFY] >>>");

    // 1. Modify a simple value - patient's active status
    json|error activeModifiedPatient = fhirpath:setFhirPathValues(patient.clone(), "Patient.active", false);
    io:println("1. Active status modified patient: ", activeModifiedPatient);

    // 2. Modify multiple values in an array - Mask patient's given names
    // Since the given name should be an array and we change it to string, it will result in an validation error. We can use the `validateFHIRResource` flag to bypass this.
    json|error namesMaskedPatient = fhirpath:setFhirPathValues(patient.clone(), "Patient.name.given", "***", validateFHIRResource = false);
    io:println("2. Names masked patient: ", namesMaskedPatient);

    // 3. Change a specific value - patient's phone number
    json|error phoneNumberModifiedPatient = fhirpath:setFhirPathValues(patient.clone(), "Patient.telecom[0].value", "000-000-0000");
    io:println("3. Phone number modified patient: ", phoneNumberModifiedPatient);
}

public function createNewPath() {
    io:println("[NEW PATH CREATION] >>>");

    // 1. Create a new FHIR path - add a age of the patient
    // Add `createMissingPaths = true` in Config.toml under [ballerinax.health.fhir.r4utils.fhirpath] to create missing paths
    json|error newAgePatient = fhirpath:setFhirPathValues(patient.clone(), "Patient.age", 30, validateFHIRResource = false);
    io:println("1. New age added patient: ", newAgePatient);
}

public function redact() {
    io:println("[REDACT] >>>");

    // 1. Redact multiple values - patient's contact information
    json|error contactInfoRemovedPatient = fhirpath:setFhirPathValues(patient.clone(), "Patient.telecom.value", ());
    io:println("1. Contact information removed patient: ", contactInfoRemovedPatient);
}

isolated function removeDayFromDate(json value) returns json|fhirpath:ModificationFunctionError {
    if value is string {
        // Assuming the date is in the format "YYYY-MM-DD"
        // Split the string using "-" delimiter with regexp
        regexp:RegExp|error regexResult = regexp:fromString("-");
        if regexResult is error {
            return fhirpath:createModificationFunctionError("Error creating regex pattern", (), value.toString());
        }

        string[] parts = regexp:split(regexResult, value);
        if parts.length() == 3 {
            // Return the date without the day
            return parts[0] + "-" + parts[1];
        }
        // If the date format is not as expected, return an error
        return fhirpath:createModificationFunctionError("Invalid date format", (), value.toString());
    }
    return value;
}

public function customModification() {
    io:println("[CUSTOM MODIFICATION] >>>");

    // 1. Read and modify a value - remove day from patient's birthday
    json|error birthdayModifiedPatient = fhirpath:setFhirPathValues(patient.clone(), "Patient.birthDate", removeDayFromDate);
    io:println("1. Birthday modified patient: ", birthdayModifiedPatient);
}

public function main() {
    extract();
    modify();
    createNewPath();
    redact();
    customModification();
}
