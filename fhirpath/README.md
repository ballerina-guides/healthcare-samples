# FHIRPath Sample

This sample demonstrates how to use the Ballerina FHIRPath library v3.0.0 to extract, modify, and manipulate FHIR resources using FHIRPath expressions.

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

- `fhirpath:getValuesFromFhirPath()` - Extract values from FHIR resources
- `fhirpath:setValuesToFhirPath()` - Set/modify values in FHIR resources

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
Original Patient Resource:
{"resourceType":"Patient","id":"12345","active":true,"name":[{"use":"official","family":"Smith","given":["John","Michael"]},{"use":"usual","given":["Johnny"]}],"gender":"male","birthDate":"1985-06-15","address":[{"use":"home","line":["123 Main Street","Apt 4B"],"city":"Springfield","state":"IL","postalCode":"62701"}],"telecom":[{"system":"phone","value":"+1-555-123-4567","use":"mobile"},{"system":"email","value":"john.smith@email.com"}]}

Extract values from FHIR resource
------------------------------------------------------------------
Patient ID(s): ["12345"]
Given name(s): [["John","Michael"],["Johnny"]]
Phone Number(s): ["+1-555-123-4567"]

Modify values in FHIR resource
------------------------------------------------------------------
Active status modified patient resource:
{"resourceType":"Patient","id":"12345","active":false,"name":[{"use":"official","family":"Smith","given":["John","Michael"]},{"use":"usual","given":["Johnny"]}],"gender":"male","birthDate":"1985-06-15","address":[{"use":"home","line":["123 Main Street","Apt 4B"],"city":"Springfield","state":"IL","postalCode":"62701"}],"telecom":[{"system":"phone","value":"+1-555-123-4567","use":"mobile"},{"system":"email","value":"john.smith@email.com"}]}

Names masked patient resource:
{"resourceType":"Patient","id":"12345","active":true,"name":[{"use":"official","family":"Smith","given":"***"},{"use":"usual","given":"***"}],"gender":"male","birthDate":"1985-06-15","address":[{"use":"home","line":["123 Main Street","Apt 4B"],"city":"Springfield","state":"IL","postalCode":"62701"}],"telecom":[{"system":"phone","value":"+1-555-123-4567","use":"mobile"},{"system":"email","value":"john.smith@email.com"}]}

Phone number modified patient resource:
{"resourceType":"Patient","id":"12345","active":true,"name":[{"use":"official","family":"Smith","given":["John","Michael"]},{"use":"usual","given":["Johnny"]}],"gender":"male","birthDate":"1985-06-15","address":[{"use":"home","line":["123 Main Street","Apt 4B"],"city":"Springfield","state":"IL","postalCode":"62701"}],"telecom":[{"system":"phone","value":"000-000-0000","use":"mobile"},{"system":"email","value":"john.smith@email.com"}]}

Create new FHIR path
------------------------------------------------------------------
New age added patient:
{"resourceType":"Patient","id":"12345","active":true,"name":[{"use":"official","family":"Smith","given":["John","Michael"]},{"use":"usual","given":["Johnny"]}],"gender":"male","birthDate":"1985-06-15","address":[{"use":"home","line":["123 Main Street","Apt 4B"],"city":"Springfield","state":"IL","postalCode":"62701"}],"telecom":[{"system":"phone","value":"+1-555-123-4567","use":"mobile"},{"system":"email","value":"john.smith@email.com"}],"age":30}

Redact values in FHIR resource
------------------------------------------------------------------
Contact information removed patient:
{"resourceType":"Patient","id":"12345","active":true,"name":[{"use":"official","family":"Smith","given":["John","Michael"]},{"use":"usual","given":["Johnny"]}],"gender":"male","birthDate":"1985-06-15","address":[{"use":"home","line":["123 Main Street","Apt 4B"],"city":"Springfield","state":"IL","postalCode":"62701"}],"telecom":[{"system":"phone","use":"mobile"},{"system":"email"}]}

Custom modifications to FHIR resource
------------------------------------------------------------------
Birthday modified patient:
{"resourceType":"Patient","id":"12345","active":true,"name":[{"use":"official","family":"Smith","given":["John","Michael"]},{"use":"usual","given":["Johnny"]}],"gender":"male","birthDate":"1985-06","address":[{"use":"home","line":["123 Main Street","Apt 4B"],"city":"Springfield","state":"IL","postalCode":"62701"}],"telecom":[{"system":"phone","value":"+1-555-123-4567","use":"mobile"},{"system":"email","value":"john.smith@email.com"}]}
```

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