# healthcare-samples

![Daily Build](https://github.com/ballerina-guides/healthcare-samples/actions/workflows/daily-build.yml/badge.svg)

A collection of Ballerina samples that demonstrate how to build healthcare integrations using the [Ballerina Health packages](https://central.ballerina.io/search?q=ballerinax%2Fhealth). Each sample is a self-contained Ballerina project that can be run independently with `bal run`.

The samples cover the common building blocks of a healthcare integration: parsing and transforming HL7 v2 and FHIR data, working with implementation guides (IGs) and extended profiles, invoking FHIR servers, generating International Patient Summary (IPS) bundles, and exposing FHIR APIs as services.

## Samples

| Sample | What it shows |
| --- | --- |
| [building-fhir-facade](./building-fhir-facade/README.md) | A full FHIR R4 facade service (Patient, Encounter) over a MySQL database with US Core profile support, search parameters, and an auto-generated capability statement. |
| [fhirpath](./fhirpath/README.md) | Using the `health.fhir.r4utils.fhirpath` package to read, modify, add, redact, and custom-transform values inside FHIR resources via FHIRPath expressions. |
| [generate-ips](./generate-ips/README.md) | Generating an International Patient Summary (IPS) FHIR bundle for a patient by configuring the `$summary` operation on a FHIR Patient API. |
| [hl7v2-to-fhir](./hl7v2-to-fhir/README.md) | Converting HL7 v2.3 messages to FHIR R4 resources using the `v2tofhirr4` utility, including segment-level mapping and custom mapper overrides. |
| [hl7v2-to-json](./hl7v2-to-json/README.md) | Parsing an HL7 v2.3 ADT^A01 message and mapping it to a custom Ballerina record / JSON structure. |
| [working-with-extended-fhir-profiles](./working-with-extended-fhir-profiles/README.md) | Populating sliced elements of a US Core profile (Pulse Oximetry) and serialising it to JSON with fixed slice values preserved. |
| [working-with-fhir](./working-with-fhir/README.md) | Parsing a serialised FHIR Patient resource into a typed Ballerina record using `health.fhir.r4.parser`. |
| [working-with-fhir-connector](./working-with-fhir-connector/README.md) | Invoking external FHIR servers (for example Cerner and the SMART bulk-data server) using the `health.clients.fhir` connector — basic read/search/transaction and bulk-export flows. |
| [working-with-fhir-igs](./working-with-fhir-igs/README.md) | Using IG-specific FHIR packages — mapping custom data to AU Core Patient, and converting HL7 v2 messages to Danish MedCom FHIR profiles. |
| [working-with-health-tool](./working-with-health-tool/README.md) | Using the Ballerina Health CLI tool to generate an IG-specific Ballerina package (CARIN BB) or a FHIR service template (US Core), and consuming the output in an API. |
| [working-with-hl7](./working-with-hl7/README.md) | Parsing a raw HL7 v2.3 message string into the typed HL7 v2.3 message model. |

## Prerequisites

- [Ballerina Swan Lake](https://ballerina.io/downloads/) — 2201.12.3 or later.
- Any sample-specific prerequisites (MySQL, an FHIR server, FTP, the `health` CLI tool, etc.) are listed in the corresponding sample README.

## How to build and run

Each directory is a standalone Ballerina project. Navigate into the sample you want to try and run:

```bash
bal run
```

Most samples either print output to the console or start an HTTP/FHIR listener on a local port. See each sample's README for the exact endpoints, configuration values (`Config.toml`), and example requests.

## Repository layout

```
healthcare-samples/
├── building-fhir-facade/                  FHIR facade over a persistence layer
├── fhirpath/                              FHIRPath read/modify/redact examples
├── generate-ips/                          IPS bundle generation via $summary
├── hl7v2-to-fhir/                         HL7 v2 -> FHIR R4 transformation
├── hl7v2-to-json/                         HL7 v2 -> custom JSON mapping
├── working-with-extended-fhir-profiles/   US Core sliced profile population
├── working-with-fhir/                     FHIR resource parsing
├── working-with-fhir-connector/           FHIR client (basic + bulk export)
├── working-with-fhir-igs/                 IG-specific samples (AU Core, MedCom)
├── working-with-health-tool/              Ballerina Health CLI tool usage
└── working-with-hl7/                      HL7 v2 message parsing
```

## Contributing

Issues and pull requests are welcome. Please use the [issue template](./issue_template.md) and [pull request template](./pull_request_template.md) when filing new items.

## License

Licensed under the [Apache License, Version 2.0](./LICENSE).
