# Health Tool — Template Generation Sample

This sample demonstrates the **template-generation** mode of the Ballerina Health CLI tool. Unlike package-generation (which produces a library of typed records for you to depend on), template-generation scaffolds a **ready-to-edit Ballerina service project** for the profiles in a FHIR Implementation Guide — complete with service endpoints, API configs, and resource handlers wired up for each profile.

The example IG used here is [US Core](https://hl7.org/fhir/us/core/).

## Directory Layout

```
template-generation/
└── ig-uscore/
    └── definitions/     US Core IG JSON (StructureDefinitions, SearchParameters,
                         CapabilityStatement, ImplementationGuide, ValueSets,
                         CodeSystems)
```

The `definitions/` directory is the **input** to the tool; the generated Ballerina service project is created next to it when you run the command below.

## What This Sample Does

The template generator inspects the IG definitions and emits a Ballerina project that includes:

- A `service.bal` with an HTTP/FHIR listener for each profiled resource type in the IG.
- `api_config.bal` entries (`ResourceAPIConfig`) pre-populated with the profile URL and the `SearchParameter` list from the IG.
- Stub resource handlers (`get`, `search`, `create`, etc.) that you fill in with your own business logic.
- `Ballerina.toml` with the right dependency on the matching IG package (e.g. `health.fhir.r4.uscore501`).

This lets you skip the boilerplate of wiring up FHIR listeners and jump straight to implementing the data-access logic for each resource.

## Prerequisites

- [Ballerina Swan Lake](https://ballerina.io/downloads/) 2201.12.3 or later.
- The Ballerina Health CLI tool:

  ```bash
  bal tool pull health
  ```

## Generating the Template

From this directory, run:

```bash
bal health fhir -m template \
  -o ig-uscore/gen \
  --org-name healthcare_samples \
  --package-name uscore_service \
  ig-uscore/definitions/
```

The generated service project appears at `ig-uscore/gen/uscore_service`.

## Running the Generated Service

```bash
cd ig-uscore/gen/uscore_service
bal run
```

The service starts with FHIR endpoints for each US Core profile. Replace the stub handlers in `service.bal` with your own persistence or backend-integration logic.

## References

- [Ballerina Health Tool documentation](https://ballerina.io/learn/health-tool/)
- [US Core Implementation Guide](https://hl7.org/fhir/us/core/)
