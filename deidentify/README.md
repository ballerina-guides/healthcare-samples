# FHIR De-identification Sample

This sample demonstrates how to use the Ballerina FHIR de-identification utilities to protect sensitive healthcare data by applying various de-identification techniques to FHIR resources.

## Overview

The FHIR de-identification utility provides comprehensive data protection capabilities for healthcare applications by implementing various de-identification operations on FHIR resources. This sample showcases both built-in and custom de-identification operations that can be applied to Patient resources and other FHIR data.

## Features

- **Built-in De-identification Operations**:
  - **Masking**: Replace sensitive data with asterisks or custom patterns
  - **Encryption**: Encrypt sensitive data using secure algorithms
  - **Hashing**: Generate irreversible hash values for data
  - **Redaction**: Completely remove sensitive information

- **Custom Operations**: Support for user-defined de-identification functions
- **FHIRPath Integration**: Use FHIRPath expressions to target specific data elements
- **Flexible Rule Definition**: Define de-identification rules either programmatically in code or through configuration files
- **Two Approaches**: Choose between programmatic rules or configuration-based rules based on your needs

## Prerequisites

- **Ballerina**: Version 2201.12.3 or later

## Package Dependencies

This sample uses the following Ballerina packages:

- [`ballerinax/health.fhir.r4utils.deidentify`](https://central.ballerina.io/ballerinax/health.fhir.r4utils.deidentify) - Core de-identification utilities
- [`ballerinax/health.fhir.r4utils.fhirpath`](https://central.ballerina.io/ballerinax/health.fhir.r4utils.fhirpath) - FHIRPath evaluation support

## Installation

1. **Clone the repository**:
   ```bash
   git clone <repository-url>
   cd healthcare-samples/deidentify
   ```

2. **Install dependencies**:
   ```bash
   bal build
   ```

## Configuration

### 1. Create Configuration File

Since `Config.toml` is gitignored by default, you need to create it from the sample configuration:

```bash
cp sample_Config.toml Config.toml
```

This will copy the sample configuration which contains example de-identification rules that you can customize for your needs.

### 2. Define De-identification Rules

You can define de-identification rules in two ways:

#### Option A: Configuration-Based Rules (Config.toml)

Create your `Config.toml` from the sample and customize the de-identification rules:

```bash
cp sample_Config.toml Config.toml
```

Then edit `Config.toml` to define your de-identification rules. The sample configuration includes comprehensive examples:

```toml
[ballerinax.health.fhir.r4utils.deidentify]
cryptoHashKey = "your-secure-hash-key"
encryptKey = "your-secure-encrypt-key"
skipOnError = false
inputFHIRResourceValidation = false
outputFHIRResourceValidation = false

# Patient ID is encrypted so that it can be re-identified later if needed
[[ballerinax.health.fhir.r4utils.deidentify.rules]]
fhirPaths = ["Patient.id"]
operation = "encrypt"

# Remove elements which are not needed
[[ballerinax.health.fhir.r4utils.deidentify.rules]]
fhirPaths = ["Patient.text", "Patient.identifier", "Patient.name"]
operation = "redact"

# Mask phone numbers partially
[[ballerinax.health.fhir.r4utils.deidentify.rules]]
fhirPaths = ["Patient.telecom.value"]
operation = "partialMask"
```

#### Option B: Programmatic Rules (In Code)

Define rules programmatically in your Ballerina code:

```ballerina
deidentify:DeIdentifyRule[] rules = [
    // Patient ID is encrypted so that it can be re-identified later if needed
    {
        "fhirPaths": ["Patient.id"],
        "operation": "encrypt"
    },
    // Remove elements which are not needed
    {
        "fhirPaths": ["Patient.text", "Patient.identifier", "Patient.name"],
        "operation": "redact"
    },
    // Mask phone numbers partially
    {
        "fhirPaths": ["Patient.telecom.value"],
        "operation": "partialMask"
    }
];

// Apply rules programmatically
json|deidentify:DeIdentificationError result = deidentify:deIdentify(patient, deIdentifyRules = rules);
```

### 3. Security Keys

⚠️ **Important**: Update the cryptographic keys in your configuration:
- `cryptoHashKey`: Used for hashing operations (minimum 16 characters)
- `encryptKey`: Used for encryption operations (minimum 16 characters)

## Usage

### Basic Usage with Configuration-Based Rules

When using configuration-based rules (defined in `Config.toml`):

```ballerina
import ballerinax/health.fhir.r4utils.deidentify;

public function main() {
    json patient = {
        "resourceType": "Patient",
        "id": "12345",
        "name": [{"family": "Smith", "given": ["John"]}],
        // ... other patient data
    };

    // Apply de-identification rules from Config.toml
    json|deidentify:DeIdentificationError result = deidentify:deIdentify(patient);
    
    if result is json {
        // Successfully de-identified data
        io:println("De-identified patient: ", result);
    } else {
        // Handle error
        io:println("Error: ", result.message());
    }
}
```

### Usage with Programmatic Rules

When defining rules programmatically in code:

```ballerina
import ballerinax/health.fhir.r4utils.deidentify;

public function main() {
    json patient = {
        "resourceType": "Patient",
        "id": "12345",
        "name": [{"family": "Smith", "given": ["John"]}],
        // ... other patient data
    };

    // Define rules programmatically
    deidentify:DeIdentifyRule[] rules = [
        {
            "fhirPaths": ["Patient.id"],
            "operation": "encrypt"
        },
        {
            "fhirPaths": ["Patient.name"],
            "operation": "redact"
        }
    ];

    // Apply de-identification rules programmatically
    json|deidentify:DeIdentificationError result = deidentify:deIdentify(patient, deIdentifyRules = rules);
    
    if result is json {
        io:println("De-identified patient: ", result);
    } else {
        io:println("Error: ", result.message());
    }
}
```

### Custom De-identification Functions

You can create and register custom de-identification functions for both approaches:

```ballerina
# Custom function to remove the day from a date
public isolated function removeDayFromDate(json value) returns json|fhirpath:ModificationFunctionError {
    if value is string {
        regexp:RegExp|error regexResult = regexp:fromString("-");
        if regexResult is error {
            return error("Error creating regex pattern.", value = value.toString());
        }
        string[] parts = regexp:split(regexResult, value);
        if parts.length() == 3 {
            // Return the date with the day removed (YYYY-MM-DD → YYYY-MM)
            return parts[0] + "-" + parts[1];
        }
        return error("Invalid date format.", value = value.toString());
    }
    return value;
}

# Custom partial masking function
public isolated function maskPartially(json value) returns json|fhirpath:ModificationFunctionError {
    if value is string {
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
```

Create a map of custom operations

```ballerina
map<fhirpath:ModificationFunction> customOperations = {
    "removeDay": removeDayFromDate,
    "partialMask": maskPartially
};
```

#### Using Custom Functions with Configuration-Based Rules

Configure custom operations in your `Config.toml`:

```toml
# Use custom function in configuration
[[ballerinax.health.fhir.r4utils.deidentify.rules]]
fhirPaths = ["Patient.birthDate"]
operation = "removeDay"

[[ballerinax.health.fhir.r4utils.deidentify.rules]]
fhirPaths = ["Patient.telecom.value"]
operation = "partialMask"
```

Provide custom operations map when calling de-identification:

```ballerina
json|deidentify:DeIdentificationError result = deidentify:deIdentify(patient, operations = customOperations);
```

#### Using Custom Functions with Programmatic Rules

Define rules programmatically with custom operations

```ballerina
deidentify:DeIdentifyRule[] rules = [
    {
        "fhirPaths": ["Patient.birthDate"],
        "operation": "removeDay"
    },
    {
        "fhirPaths": ["Patient.telecom.value"],
        "operation": "partialMask"
    }
];

// Apply programmatic rules with custom operations
json|deidentify:DeIdentificationError result = deidentify:deIdentify(patient, operations = customOperations, deIdentifyRules = rules);
```

#### Using AI capabilities for De-identification

You can use AI-based de-identification for text fields by creating a custom function that integrates with an AI model. This sample includes an example function (`deIdentifyTextWithAI`) and a rule (`aiDeIdentify`) for de-identifying text fields using a default WSO2 model provider.

In order to work with the AI model, you need to configure the default WSO2 model provider. Add the following to your `Config.toml`:

```toml
[ballerina.ai.wso2ProviderConfig]
serviceUrl = "https://dev-tools.wso2.com/ballerina-copilot/v2.0"
accessToken = "<ACCESS_TOKEN>"
```

OR you can use a shortcut command to configure default model provider in VS Code: `@command:ballerina.configureWso2DefaultModelProvider`, which will add the  configuration with serviceUrl and accessToken. The Wso2DefaultModelProvider is only for testing and evaluation purposes. For production use, you should set up your own AI model provider.

If you want to use a different AI model provider, you can implement your own custom function that calls the desired AI service and register it similarly to the other custom functions. For more ballerina AI capabilities, refer to the [Ballerina AI usecases](https://ballerina.io/use-cases/ai/).

⚠️ Note: AI-based de-identification is non-deterministic and may not be accurate. Please review the results manually.

## Running the Sample

### 1. Run the Main Sample

```bash
bal run
```

This will execute the sample demonstrating programmatic rule definition with custom de-identification operations.

### 2. Expected Output

The sample will show:
- Original patient data
- De-identified patient resource using programmatic rules
- De-identified patient bundle using the same rules

### 3. Customize the Sample

You can modify the sample in several ways:

#### For Configuration-Based Approach:
- Create your configuration file: `cp sample_Config.toml Config.toml`
- Edit `Config.toml` to add/modify de-identification rules
- Update `main.bal` to use configuration-based rules:
  ```ballerina
  json|deidentify:DeIdentificationError result = deidentify:deIdentify(patient, operations = customOperations);
  ```

#### For Programmatic Approach:
- Modify `main.bal` to:
  - Add your own patient data in `patient_resource.bal`
  - Create additional custom de-identification functions
  - Define different programmatic rules
  - Test different FHIRPath expressions

### 4. Choosing Your Approach

**Use Configuration-Based Rules when:**
- Rules need to be changed without code modifications
- Different environments require different de-identification strategies
- Non-developers need to manage de-identification policies
- You want to use the comprehensive example rules provided in `sample_Config.toml`

**Use Programmatic Rules when:**
- Rules are complex and require conditional logic
- Rules are tightly coupled with application logic
- You need dynamic rule generation based on runtime conditions

## Configuration Reference

### Built-in Operations

| Operation | Description | Example |
|-----------|-------------|---------|
| `mask` | Replace data with asterisks | `"John Smith"` → `"*********"` |
| `encrypt` | Encrypt using AES | `"12345"` → `"encrypted_value"` |
| `hash` | Generate SHA-256 hash | `"phone"` → `"hash_value"` |
| `redact` | Remove data completely | `"sensitive"` → `null` |

### Configuration Format

#### Configuration-Based Rules (`Config.toml`)

```toml
[ballerinax.health.fhir.r4utils.deidentify]
cryptoHashKey = "your-secure-hash-key"
encryptKey = "your-secure-encrypt-key"
skipOnError = false
inputFHIRResourceValidation = false
outputFHIRResourceValidation = false

# Define multiple rules
[[ballerinax.health.fhir.r4utils.deidentify.rules]]
fhirPaths = ["Patient.id"]
operation = "encrypt"

[[ballerinax.health.fhir.r4utils.deidentify.rules]]
fhirPaths = ["Patient.name", "Patient.identifier"]
operation = "redact"
```

#### Programmatic Rules (In Code)

```ballerina
deidentify:DeIdentifyRule[] rules = [
    {
        "fhirPaths": ["Patient.id"],
        "operation": "encrypt"
    },
    {
        "fhirPaths": ["Patient.name", "Patient.identifier"],
        "operation": "redact"
    }
];
```

### Rule Structure

Both configuration and programmatic approaches support:

- **`fhirPaths`**: Array of FHIRPath expressions targeting specific data elements
- **`operation`**: The de-identification operation to apply (built-in or custom)


## Resources

- [Ballerina FHIR De-identification Package Documentation](https://central.ballerina.io/ballerinax/health.fhir.r4utils.deidentify)
- [FHIRPath Specification](http://hl7.org/fhirpath/)
- [FHIR R4 Specification](http://hl7.org/fhir/R4/)
- [Healthcare Data De-identification Guidelines](https://www.hhs.gov/hipaa/for-professionals/privacy/special-topics/de-identification/index.html)
