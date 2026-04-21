# Working with FHIR Implementation Guides

This directory contains samples that demonstrate how to work with **region- or IG-specific FHIR packages** in Ballerina. An Implementation Guide (IG) tailors the base FHIR R4 specification with localised profiles, value sets, and extensions (e.g. race/ethnicity for the US, IHI identifiers for Australia, MedCom profiles for Denmark). The Ballerina Health library ships typed packages for many common IGs so that you can build IG-compliant resources without hand-assembling profile metadata.

## Samples Included

| Sample | IG | What it shows |
| --- | --- | --- |
| [au-core](./au-core/README.md) | [AU Core](https://build.fhir.org/ig/hl7au/au-fhir-core/) (Australia) | Mapping a custom Ballerina patient record into an AU Core Patient resource using the Ballerina data mapper. A simple starting point for Australian healthcare integrations. |
| [hl7v2-to-dk-medcom](./hl7v2-to-dk-medcom/README.md) | [MedCom Core 2.4.0](https://medcomfhir.dk/) (Denmark) | An HTTP service that accepts an HL7 v2 ADT^A01 message and transforms it to a FHIR Bundle of MedCom-profiled resources (Patient, Encounter). Demonstrates combining the `v2tofhirr4` utility with a Danish IG package. |

## When to Use These Samples

Pick the sample that matches your target jurisdiction or vendor IG. If your target IG is not represented here directly, the pattern is the same across all of them:

1. Pull in the Ballerina package for the IG (`ballerinax/health.fhir.r4.<ig-name>`).
2. Construct or map into the IG's typed profile records.
3. Serialise with `toJson()` — the fixed systems, codes, and profile URLs embedded in the typed records are emitted automatically.

If no package exists for your IG, see [working-with-health-tool](../working-with-health-tool/README.md) to generate one from the IG's JSON definitions using the Ballerina Health CLI.

## Prerequisites

- [Ballerina Swan Lake](https://ballerina.io/downloads/) — each sub-sample lists its exact minimum version.
- Basic familiarity with FHIR R4 and, for the `hl7v2-to-dk-medcom` sample, HL7 v2 message structure.

## Running a Sample

Navigate into the chosen sub-directory and follow its README. At minimum:

```bash
cd au-core          # or: cd hl7v2-to-dk-medcom
bal run
```

## References

- [FHIR Implementation Guides registry](https://www.fhir.org/guides/registry/)
- [Ballerina Health packages on Ballerina Central](https://central.ballerina.io/search?q=ballerinax%2Fhealth.fhir.r4)
