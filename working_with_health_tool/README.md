# Generate a Ballerina Package from Health Tool and Develop a FHIR API

Using the Ballerina-Health Tool, you can generate a Balllerina package
for a given FHIR Implementation Guide.
This guide shows how to generate a package and use the generated package in a REST API

### Generate Ballerina Package using Health Tool

- Navigate to `ig_carinbb` directory
- Run `bal health fhir -m package -o gen --org-name healthcare_samples --package-name carinbb_package definitions/`
    > Note: `definitions` directory contains the JSON definitions of the CarinBB IG
- This will generate a Ballerina package in `ig_carinbb/gen` directory

### Build and Push

- Navigate to `ig_carinbb/gen/carinbb_package`
- Run `bal pack` and then `bal push --repository=local`

### Run the project

- Navigate to project root of `working_with_health_tool`(where the Ballerina.toml file exist.)
- Run `bal run`
