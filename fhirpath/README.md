# FHIRPath Sample

This sample demonstrates how to use the Ballerina FHIRPath library to extract, modify, and manipulate FHIR resources using FHIRPath expressions.

## Overview

FHIRPath is a powerful expression language for navigating and manipulating FHIR resources. This sample showcases various operations you can perform on FHIR resources using the `ballerinax/health.fhir.r4utils.fhirpath` package, including:

- **Data Extraction**: Retrieving specific values from FHIR resources
- **Data Modification**: Updating existing values in FHIR resources
- **Path Creation**: Adding new fields to FHIR resources
- **Data Redaction**: Removing sensitive information
- **Custom Modifications**: Applying custom transformation functions

## Package Usage

This sample uses the [`ballerinax/health.fhir.r4utils.fhirpath`](https://central.ballerina.io/ballerinax/health.fhir.r4utils.fhirpath) package. For detailed API documentation and usage instructions, please refer to the [official package documentation](https://central.ballerina.io/ballerinax/health.fhir.r4utils.fhirpath).

### Key Functions Demonstrated

- `fhirpath:getFhirPathValues()` - Extract values from FHIR resources
- `fhirpath:setFhirPathValues()` - Set/modify values in FHIR resources

## Prerequisites

Before running this sample, ensure you have:

**Ballerina**: Install Ballerina version 2201.12.3 or later
   - Download from: https://ballerina.io/downloads/
   - Verify installation: `bal version`

## How to Run the Sample

1. **Clone the repository** (if not already done):
   ```bash
   git clone <repository-url>
   cd healthcare-samples/fhirpath
   ```

2. **Run the sample**:
   ```bash
   bal run
   ```

## Sample Operations

The sample demonstrates the following operations on a Patient FHIR resource:

### 1. Data Extraction
- Extract patient ID
- Retrieve all given names
- Get specific telecom values (phone numbers, emails)

### 2. Data Modification
- Modify patient's active status
- Mask patient names for privacy
- Update contact information

### 3. Path Creation
- Add new fields (like age) to the patient resource
- Create missing paths in the FHIR structure

### 4. Data Redaction
- Remove sensitive contact information
- Redact personal identifiers

### 5. Custom Modifications
- Apply custom transformation functions
- Example: Remove day from birth date for privacy compliance

## Expected Output

When you run the sample, you'll see output demonstrating each operation:

```
[EXTRACT] >>>
1. Patient ID: ["12345"]
2. All given names: [["John","Michael"],["Johnny"]]
3. Phone Number: ["+1-555-123-4567"]

[MODIFY] >>>
1. Active status modified patient: {...}
2. Names masked patient: {...}
3. Phone number modified patient: {...}

[NEW PATH CREATION] >>>
1. New age added patient: {...}

[REDACT] >>>
1. Contact information removed patient: {...}

[CUSTOM MODIFICATION] >>>
1. Birthday modified patient: {...}
```

## Configuration Options

The FHIRPath package supports various configuration options:

- `validateFHIRResource`: Set to `false` to bypass FHIR resource validation
- `createMissingPaths`: Set to `true` to automatically create missing paths in the resource structure

Refer to the [package documentation](https://central.ballerina.io/ballerinax/health.fhir.r4utils.fhirpath) for complete configuration options.

## Use Cases

This sample is useful for:

- **Healthcare Data Processing**: Transform and manipulate FHIR resources
- **Privacy Compliance**: Redact or mask sensitive patient information
- **Data Integration**: Extract specific data elements for integration workflows
- **Data Validation**: Modify resources while maintaining FHIR compliance
- **Custom Transformations**: Apply business-specific data transformation rules

## Additional Resources

- [FHIRPath Specification](http://hl7.org/fhirpath/)
- [FHIR R4 Specification](http://hl7.org/fhir/R4/)
- [Ballerina Health Package Documentation](https://central.ballerina.io/search?q=health)
- [Ballerina Language Documentation](https://ballerina.io/learn/)

## Support

For issues related to this sample or the FHIRPath package, please refer to the [package repository](https://github.com/ballerina-platform/module-ballerinax-health.fhir.r4utils.fhirpath) or [Ballerina Slack community](https://ballerina.io/community/#slack).