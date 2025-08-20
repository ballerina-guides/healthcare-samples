# Working with FHIR Connector: Basic Interactions

This sample demonstrates how to use the Ballerina FHIR connector to interact with a Cerner EMR system. It covers basic FHIR operations such as reading, searching, conditional create, and transaction bundles.

## Prerequisites

- [Ballerina](https://ballerina.io/downloads/) installed
- Access to a Cerner FHIR server (with credentials)
- Required connection parameters:
  - Base URL of the FHIR server
  - OAuth2 token endpoint
  - OAuth2 client ID and secret
  - OAuth2 scopes

## Setup

1. Clone this repository.
2. Set the connection parameters in `Config.toml` or as environment variables:
    - `base`
    - `tokenUrl`
    - `clientId`
    - `clientSecret`
    - `scopes`
3. Ensure the FHIR connector dependency is available.

## Running the Sample

Execute the following command in this directory:

```sh
bal run working_with_fhir_connector.bal
```

## What This Sample Does

- **Read Patient by ID:** Retrieves a patient resource using its FHIR ID.
- **Search Patients:** Finds patients by name and birthdate using both GET and POST methods.
- **Conditional Create:** Creates a patient only if one with a specific ID does not exist.
- **Transaction Bundle:** Atomically creates/updates multiple resources (Patient + Observation).

## References

- [Ballerina FHIR Connector](https://central.ballerina.io/ballerinax/health.clients.fhir)
- [Cerner FHIR Documentation](https://docs.cerner.com)
