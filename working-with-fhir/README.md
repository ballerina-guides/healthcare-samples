# Working with FHIR Sample

This sample demonstrates how to parse a serialised FHIR R4 resource (received as JSON) into a typed Ballerina record using the `ballerinax/health.fhir.r4.parser` package. This is the standard first step for any inbound-FHIR flow — a REST API handler, a message consumer, or a file-based ingestion pipeline.

## What This Sample Does

[`working_with_fhir_parsing.bal`](./working_with_fhir_parsing.bal) performs the following:

1. Declares an inline `json` value representing a minimal FHIR R4 `Patient` resource with a single `name` entry (`family: "Simpson"`).
2. Calls `fhirParser:parse(input)` to convert the JSON into a generic FHIR resource, then `ensureType()` to narrow it to the typed `international401:Patient` record. The parser validates that `resourceType` is `"Patient"` and that the structure matches the FHIR R4 International profile.
3. Reads the `name` field from the parsed record and prints the first entry.

The same `parse` / `ensureType` pattern works for any FHIR R4 resource and for any profiled variant (US Core, AU Core, IPS, CARIN BB, etc.) — simply pass a different resource type to `ensureType`.

## Why Use the Parser?

- **Validation** — the parser rejects input that is not a well-formed FHIR resource (missing `resourceType`, wrong field types, etc.), so bad data never reaches your business logic.
- **Type safety** — downstream code works against the typed `international401:Patient` record, so field access is checked by the compiler and supported by IDE autocomplete.
- **Profile awareness** — if you `ensureType` to a profiled resource (e.g. `uscore501:USCorePatientProfile`), the parser verifies the resource's `meta.profile` and slice constraints.

## Prerequisites

- [Ballerina Swan Lake](https://ballerina.io/downloads/) 2201.12.3 or later.

## How to Run

```bash
bal run
```

Expected output:

```
Family Name: {"family":"Simpson"}
```


## References

- [Ballerina `health.fhir.r4.parser` package](https://central.ballerina.io/ballerinax/health.fhir.r4.parser)
- [Ballerina `health.fhir.r4.international401` package](https://central.ballerina.io/ballerinax/health.fhir.r4.international401)
- [FHIR R4 Patient Resource](https://hl7.org/fhir/R4/patient.html)
