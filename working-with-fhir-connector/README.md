# Ballerina FHIR Connector Samples

This repository contains sample projects demonstrating how to use the Ballerina FHIR connector to interact with Cerner EMR and other FHIR-compliant servers.

## Samples Included

- [Basic Interactions](./working_with_basic_interactions/README.md):  
  Demonstrates reading, searching, conditional create, and transaction bundle operations with a FHIR server.

- [Bulk Export Interactions](./working_with_bulk_export_interactions/README.md):  
  Shows how to perform bulk export operations and store exported data using FTP or local file storage.

## Prerequisites

- [Ballerina](https://ballerina.io/downloads/) installed
- Access to a FHIR server (e.g., Cerner)
- Connection parameters (see individual sample READMEs for details)

## Setup

1. Clone this repository.
2. Update the configuration files (`Config.toml`) in each sample directory with your FHIR server and credentials.

## Running a Sample

Navigate to the desired sample directory and run:

```sh
bal run
```

Refer to each sample's README for detailed instructions and endpoint information.

## References

- [Ballerina FHIR Connector](https://central.ballerina.io/ballerinax/health.clients.fhir)
- [Cerner FHIR Documentation](https://docs.cerner.com)
