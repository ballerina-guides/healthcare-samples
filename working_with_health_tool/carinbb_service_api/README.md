# Generate a Ballerina Package using the Health Tool and develop an FHIR API

You can generate a Ballerina package using the Ballerina-Health Tool for a given FHIR implementation guide.

This guide shows how to generate a package and use that generated package in a REST API.

## Set up the pre-requisites

- Ballerina [Swan Lake Update 7](https://ballerina.io/downloads/) or higher
- Ballerina Health Tool installed by executing the command below.
  > `bal tool pull health`

## Generate the Ballerina package using the Health Tool

1. Clone the repository to your local machine.

2. Navigate to the `working_with_health_tool/carinbb_service_api` directory.

  > `cd working_with_health_tool/carinbb_service_api`

3. Generate the package.

  > `bal health fhir -m package -o ig_carinbb/gen --org-name healthcare_samples --package-name carinbb_package ig_carinbb/definitions/`

  > **Info:** The `definitions` directory contains the JSON definitions of the CarinBB IG.

  This will generate a Ballerina package in the `ig_carinbb/gen` directory.

## Build and push the package

1. Navigate to the `ig_carinbb/gen/carinbb_package` directory.

2. Run `bal pack` and then `bal push --repository=local`.

## Run the project

1. Navigate to the project root of the `working_with_health_tool/carinbb_service_api` directory (i.e., where the `Ballerina.toml`` file exists.)

2. Run `bal run`.

> For more information, go to [Health tool (FHIR/HL7)](https://ballerina.io/learn/health-tool/).
