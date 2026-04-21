# HL7 v2 to FHIR R4 Sample

This sample demonstrates how to convert HL7 v2 messages into FHIR R4 resources using Ballerina's `ballerinax/health.hl7v23.utils.v2tofhirr4` utility library. The mappings follow the official [HL7 v2-to-FHIR Implementation Guide](https://build.fhir.org/ig/HL7/v2-to-fhir/branches/master/datatype_maps.html).

## What This Sample Does

The sample walks through three progressively lower-level ways to work with the HL7 v2 → FHIR conversion utility, all driven from a single ADT^A01 message hard-coded in [`main.bal`](./main.bal):

1. **Full-message transformation** — Calls `v2tofhirr4:v2ToFhir(msg)` on a raw HL7 v2.3 ADT^A01 string and produces a FHIR R4 `Bundle` containing the resources (`Patient`, `Encounter`, `Provenance`, `MessageHeader`, etc.) derived from each segment.
2. **Segment-level mapping** — Parses the v2 message into a typed `hl7v23:ADT_A01` model using `v2tofhirr4:stringToHl7`, then calls a specific segment mapper (`pidToPatientName`) to get just a FHIR `HumanName[]` out of the PID segment. This is useful when you only need a fragment of a resource.
3. **Custom mapper overrides** — Defines a custom `pv1ToEncounter` function that classifies inpatient vs. ambulatory encounters, registers it on a `V2SegmentToFhirMapper`, and passes the mapper to `v2ToFhir` so the custom logic replaces the default PV1 → Encounter mapping.


## Prerequisites

- [Ballerina Swan Lake](https://ballerina.io/downloads/) 2201.12.3 or later.

## How to Run

```bash
bal run
```

The program prints:

- The full FHIR Bundle produced from the default mapping.
- The `HumanName` derived from the PID segment.
- The FHIR Bundle produced after the custom `pv1ToEncounter` mapper is applied — note the `class.display` value changes to `"inpatient encounter"` (because PV1-2 is `I`), instead of the default mapping.

## References

- [Ballerina `v2tofhirr4` package](https://central.ballerina.io/ballerinax/health.hl7v23.utils.v2tofhirr4)
- [HL7 v2-to-FHIR Implementation Guide — Datatype Maps](https://build.fhir.org/ig/HL7/v2-to-fhir/branches/master/datatype_maps.html)
- [HL7 v2-to-FHIR Implementation Guide — Segment Maps](https://build.fhir.org/ig/HL7/v2-to-fhir/branches/master/segment_maps.html)
