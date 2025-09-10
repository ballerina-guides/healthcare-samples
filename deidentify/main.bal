import ballerina/ai;
import ballerina/io;
import ballerina/lang.regexp;
import ballerina/log;
import ballerinax/health.fhir.r4utils.deidentify;
import ballerinax/health.fhir.r4utils.fhirpath;

// Creating Custom De-identification Functions

# Custom function to remove the day from a date
#
# + value - The original date value
# + return - The modified date value without the day
public isolated function removeDayFromDate(json value) returns json|fhirpath:ModificationFunctionError {
    if value is string {
        // Assuming the date is in the format "YYYY-MM-DD"
        // Split the string using "-" delimiter with regexp
        regexp:RegExp|error regexResult = regexp:fromString("-");
        if regexResult is error {
            return error("Error creating regex pattern.", value = value.toString());
        }
        string[] parts = regexp:split(regexResult, value);
        if parts.length() == 3 {
            // Return the date with the day removed
            return parts[0] + "-" + parts[1];
        }
        // If the date format is not as expected, return a shifted date or an error
        io:println("Invalid date format, returning a shifted date.");
        return error("Invalid date format, returning a shifted date.", value = value.toString());
    }
    return value;
}

# Custom partial masking function. Check if the value is a string and mask part of it.
#
# + value - The original value to be masked
# + return - The masked value
public isolated function maskPartially(json value) returns json|fhirpath:ModificationFunctionError {
    if value is string {
        // Mask end of the string with the length preserved
        int length = value.length();
        if length > 4 {
            int asteriskCount = length - 4;
            string[] asterisks = [];
            int i = 0;
            while i < asteriskCount {
                asterisks.push("*");
                i = i + 1;
            }
            string repeatedAsterisks = string:'join("", ...asterisks);
            string masked = value.substring(startIndex = 0, endIndex = 2) + repeatedAsterisks + value.substring(startIndex = length - 2);
            return masked;
        }
    }
    return "**MASKED**";
}

# Custom function to de-identify text using an AI model
#
# + value - The original text value
# + return - The modified text value
public isolated function deIdentifyTextWithAI(json value) returns json|fhirpath:ModificationFunctionError {
    if value is string {
        string|error deIdentifiedText = deIdentifyTextWithDefaultModelProvider(value);
        if deIdentifiedText is error {
            return error("Error during AI de-identification.", value = value.toString());
        }
        return deIdentifiedText.toJson();
    }
    return error("Value is not a string.", value = value.toString());
}

# Function to call an AI model for de-identification.
# Need to configure WSO2 Provider in Config.toml under [ballerina.ai.wso2ProviderConfig] to work.
# Shortcut command to configure default model provider in VS Code: @command:ballerina.configureWso2DefaultModelProvider,
# which will add the  configuration with serviceUrl and accessToken.
# More Info: https://central.ballerina.io/ballerina/ai/latest
#
# + text - The original text to be de-identified
# + return - The de-identified text or an error
public isolated function deIdentifyTextWithDefaultModelProvider(string text) returns string|error {
    ai:Wso2ModelProvider model = check ai:getDefaultModelProvider();
    string|ai:Error deIdentifiedText = model->generate(
        `De-identify the following text by removing or masking any personally identifiable information (PII): ${text}`);
    if deIdentifiedText is string {
        log:printWarn(`Deidentified with AI. Please review for accuracy.`);
    }
    return deIdentifiedText;
}

public function main() {

    // Using Custom Functions for de-identification

    // Create a map of custom operations
    map<fhirpath:ModificationFunction> customOperations = {
        "removeDay": removeDayFromDate,
        "partialMask": maskPartially,
        "aiDeIdentify": deIdentifyTextWithAI
    };

    // Provide de-identify rules programmatically
    deidentify:DeIdentifyRule[] rules = [
        // Patient ID is encrypted so that it can be re-identified later if needed
        {
            "fhirPaths": ["Patient.id"],
            "operation": "encrypt"
        },
        // Remove elements which are not needed
        {
            "fhirPaths": ["Patient.identifier", "Patient.name", "Patient.photo", "Patient.contact", "Patient.link", "Patient.extension[1]"],
            "operation": "redact"
        },
        // De-identify address
        {
            "fhirPaths": ["Patient.address.line", "Patient.address.city", "Patient.address.district"],
            "operation": "redact"
        },
        // Postal code hashed, so we could use it to check if two patients are coming from the same area, without knowing the exact area
        {
            "fhirPaths": ["Patient.address.postalCode"],
            "operation": "hash"
        },
        // Mask phone numbers partially, so that the value is still recognizable as a phone number with the number format preserved, but not identifiable
        {
            "fhirPaths": ["Patient.telecom.value"],
            "operation": "partialMask"
        },
        // The birth date is important for age calculations, so we keep the year and month, but remove the day to reduce identifiability
        {
            "fhirPaths": ["Patient.birthDate"],
            "operation": "removeDay"
        },
        // Encrypt references to other resources, so that they can be re-identified later if needed or for record linkage
        {
            "fhirPaths": ["Patient.generalPractitioner.reference", "Patient.managingOrganization.reference", "Patient.link.other.reference"],
            "operation": "encrypt"
        },
        // Mask display names of references to other resources
        {
            "fhirPaths": ["Patient.generalPractitioner.display", "Patient.managingOrganization.display", "Patient.link.other.display"],
            "operation": "mask"
        },
        // De-identify text fields using an AI model. Please review the results for accuracy.
        {
            "fhirPaths": ["Patient.text.div"],
            "operation": "aiDeIdentify"
        }
    ];

    io:println("Original Patient Resource:\n", patient);
    io:println("------------------------------------------------------------------");
    json|deidentify:DeIdentificationError deIdentifiedPatient = deidentify:deIdentify(patient.clone(), operations = customOperations, deIdentifyRules = rules);
    io:println("De-identified Patient resource:\n", deIdentifiedPatient);

    io:println("\n------------------------------------------------------------------");
    io:println("Original Patient Bundle:\n", patientBundle);
    io:println("------------------------------------------------------------------");
    json|deidentify:DeIdentificationError deIdentifiedBundle = deidentify:deIdentify(patientBundle.clone(), operations = customOperations, deIdentifyRules = rules);
    io:println("De-identified Patient Bundle:\n", deIdentifiedBundle);
}
