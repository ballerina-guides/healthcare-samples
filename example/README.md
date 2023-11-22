# Generate a Ballerina Package from Health Tool and Develop a FHIR API

Using the Ballerina-Health Tool, you can generate a Balllerina package
for a given FHIR Implementation Guide.
This guide shows how to generate a package and use the generated package in a REST API

### Pre-requisites
- Ballerina [Swan Lake Update 7](https://ballerina.io/downloads/) or higher
- Ballerina Health Tool installed
  > `bal tool pull health`

### Generate Ballerina Package using Health Tool

- Clone the repository to your local machine.
- Navigate to `working_with_health_tool` directory
    > `cd working_with_health_tool`
- Run `bal health fhir -m package -o ig_carinbb/gen --org-name healthcare_samples --package-name carinbb_package ig_carinbb/definitions/`
    > Note: `definitions` directory contains the JSON definitions of the CarinBB IG
- This will generate a Ballerina package in `ig_carinbb/gen` directory

### Build and Push

- Navigate to `ig_carinbb/gen/carinbb_package`
- Run `bal pack` and then `bal push --repository=local`

### Run the project

- Navigate to project root of `working_with_health_tool`(where the Ballerina.toml file exist.)
- Run `bal run`

> For more information, go to [Health tool (FHIR/HL7)](https://ballerina.io/learn/health-tool/).
