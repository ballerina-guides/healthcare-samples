# Working with Extended FHIR Profiles Sample

This sample demonstrates how to work with **sliced elements** of an extended FHIR profile in Ballerina, using the US Core Pulse Oximetry profile (`USCorePulseOximetryProfile`) from the `ballerinax/health.fhir.r4.uscore501` package.

## What This Sample Does

FHIR profiles often constrain a base resource by slicing elements — i.e. partitioning an array element (such as `Observation.code.coding` or `Observation.component`) into named sub-elements, each with its own fixed values and cardinality. The Ballerina US Core package models each slice as a distinct Ballerina record type so that the compiler can enforce the cardinality and the fixed values can be serialised automatically.

[`main.bal`](./main.bal) constructs a `USCorePulseOximetryProfile` Observation that conforms to all of the profile's slice constraints:

- **`code.coding` — PulseOx slice** (`code = 59408-5`, LOINC) and **O2Sat slice** (`code = 2708-6`, LOINC). Both slices are mandatory (min=1, max=1) and their `system`/`code` are fixed by the profile; only the display and extensions need to be supplied at runtime.
- **`component` — Concentration slice** (LOINC `3150-0`) and **FlowRate slice** (UCUM `L/min`). These are optional components for oxygen concentration and flow rate. The sample populates `flowRate.valueQuantity` with `5 /min`.
- **`category` — VSCat slice** (`vital-signs`), which is mandatory on every vital-signs observation.

It also sets `effectivePeriod`, `effectiveDateTime`, `subject`, and `status`, then calls `toJson()` on the resulting record. The serialised JSON includes the fixed `system`/`code` values from each slice automatically — without the developer having to set them explicitly — which is the key ergonomic benefit of using the typed slice records.


## Prerequisites

- [Ballerina Swan Lake](https://ballerina.io/downloads/) 2201.12.3 or later.

## How to Run

```bash
bal run
```

The program prints a JSON Observation resource that validates against the US Core Pulse Oximetry profile. You can copy it into an online FHIR validator (e.g. [validator.fhir.org](https://validator.fhir.org/)) to confirm conformance.


## References

- [Ballerina `health.fhir.r4.uscore501` package](https://central.ballerina.io/ballerinax/health.fhir.r4.uscore501)
- [US Core Pulse Oximetry Profile](https://hl7.org/fhir/us/core/STU5.0.1/StructureDefinition-us-core-pulse-oximetry.html)
- [FHIR R4 Profiling and Slicing](https://hl7.org/fhir/R4/profiling.html#slicing)
