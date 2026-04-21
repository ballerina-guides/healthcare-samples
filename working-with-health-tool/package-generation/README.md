# Health Tool — Package Generation Sample

This sample demonstrates the **package-generation** mode of the Ballerina Health CLI tool: pointing the tool at a folder of FHIR IG JSON definitions and having it emit a ready-to-publish Ballerina package that contains typed records for every StructureDefinition, ValueSet, and CodeSystem in the IG.

The example IG used here is the [CARIN Consumer-Directed Payer Data Exchange (CARIN BB)](https://hl7.org/fhir/us/carin-bb/) IG.

## Directory Layout

```
package-generation/
├── ig-carinbb/
│   └── definitions/            IG JSON definitions (StructureDefinitions,
│                               ValueSets, CodeSystems, CapabilityStatement)
└── carinbb-patient-service/
    ├── Ballerina.toml          Depends on the generated carinbb_package
    └── service.bal             Example HTTP service that builds and returns
                                a CARIN BB Patient resource
```

## What This Sample Does

The workflow has three stages:

1. **Generate the Ballerina package** from the CARIN BB IG definitions using the Health CLI. The generated package contains typed records such as `C4BBPatient` with the correct slices, extensions, and fixed codes baked in.
2. **Build and install the package locally** with `bal pack` and `bal push --repository=local` so other Ballerina projects on the same machine can depend on it.
3. **Consume the package** from a downstream HTTP service ([`carinbb-patient-service/service.bal`](./carinbb-patient-service/service.bal)). The service takes a legacy/mock `Patient` record, maps it onto a typed `carinbb:C4BBPatient`, and returns it as `application/fhir+json`. The compiler verifies that the resource conforms to the IG's shape.

## Prerequisites

- [Ballerina Swan Lake](https://ballerina.io/downloads/) 2201.12.3 or later.
- The Ballerina Health CLI tool:

  ```bash
  bal tool pull health
  ```

## Step 1 — Generate the Package

From this directory, run:

```bash
bal health fhir -m package \
  -o ig-carinbb/gen \
  --org-name healthcare_samples \
  --package-name carinbb_package \
  ig-carinbb/definitions/
```

This produces a Ballerina package at `ig-carinbb/gen/carinbb_package` with org `healthcare_samples` and name `carinbb_package`.

## Step 2 — Build and Install Locally

```bash
cd ig-carinbb/gen/carinbb_package
bal pack
bal push --repository=local
```

## Step 3 — Run the Consumer Service

```bash
cd ../../../carinbb-patient-service
bal run
```

The service listens on port `9090`. Send a request to retrieve a CARIN BB–conforming Patient:

```bash
curl -H "Accept: application/fhir+json" http://localhost:9090/Patient/2121
```

The response is a JSON Patient resource typed as `C4BBPatient`, with the fixed values from the CARIN BB profile (systems, profile URL in `meta.profile`, etc.) emitted automatically.


## References

- [Ballerina Health Tool documentation](https://ballerina.io/learn/health-tool/)
- [CARIN Blue Button IG](https://hl7.org/fhir/us/carin-bb/)
