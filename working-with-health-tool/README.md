# Working with the Ballerina Health Tool

The [Ballerina Health CLI tool](https://ballerina.io/learn/health-tool/) (`bal health`) takes a folder of FHIR Implementation Guide (IG) JSON definitions and emits ready-to-use Ballerina artifacts. This directory contains two samples that cover the two modes the tool supports:

| Mode | Sample | Output |
| --- | --- | --- |
| `package` | [package-generation](./package-generation/README.md) | A Ballerina **library package** of typed records for every profile, value set, and code system in the IG — ready to depend on from any Ballerina project. The sample uses the CARIN BB IG and consumes the generated package from a small HTTP service. |
| `template` | [template-generation](./template-generation/README.md) | A Ballerina **service project** scaffolded for the IG — listeners, `ResourceAPIConfig` entries, and stub handlers for each profiled resource. The sample uses the US Core IG. |

Pick `package` when you want typed records for resource construction and parsing, and `template` when you want to bootstrap a whole FHIR service for an IG.

## Prerequisites

- [Ballerina Swan Lake](https://ballerina.io/downloads/) Update 7 (2201.7.0) or later.
- Install the Health CLI tool once:

  ```bash
  bal tool pull health
  ```

## Running a Sample

Follow the README inside each sub-directory — both walk through the exact `bal health fhir` command and the steps to run the resulting project.

## References

- [Ballerina Health Tool documentation](https://ballerina.io/learn/health-tool/)
- [FHIR Implementation Guides registry](https://www.fhir.org/guides/registry/)
