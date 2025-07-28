# IPS Generation Sample

This sample demonstrates how to generate an International Patient Summary (IPS) FHIR bundle using Ballerina and the HL7 FHIR R4 specification.

## Configuration

The IPS generation logic is primarily controlled via the `summary` operation configuration in [`api_config.bal`](./api_config.bal). Within this configuration, the `ipsSectionConfig` property allows you to specify which sections and resources should be included in the generated IPS bundle.

Example from `api_config.bal`  
**Add this configuration to the Patient resource API configuration to automatically generate the IPS for the given patient:**

```ballerina
operations: [
    {
        name: "summary",
        active: true,
        additionalProperties: {
            ipsSectionConfig: [
                {
                    sectionName: ips:PROBLEMS,
                    sectionTitle: "Active Problems",
                    resources: [
                        {resourceType: "Condition"}
                    ]
                },
                // ...other sections...
            ],
            ipsMetaData: {
                authors: ["Organization/50"]
            }
        }
    }
]
```

## Default IPS Section Config

If `ipsSectionConfig` is not provided in the operation configuration, the system will use the default IPS section configuration. This default includes all mandatory sections required for a valid IPS bundle, ensuring compliance with the IPS specification.

## Running the Sample

- Review and modify the resource API configurations in `api_config.bal` as needed.
- Start the Ballerina services defined in `service.bal`.
- To generate an IPS bundle for a patient, send a **POST** request to the `$summary` operation endpoint, for example:

  ```request
  POST "http://localhost:9050/Patient/102/$summary"
  ```

  ```curl
  curl -X POST "http://localhost:9050/Patient/102/$summary" \
    -H "Content-Type: application/fhir+json"
  ```

  This will trigger the IPS generation logic using the configured sections.

### Middleware Behavior

- If the service **does not** implement the `summary` operation, the middleware automatically generates the IPS bundle using the configuration.
- If the service **does** implement the `summary` operation, the middleware forwards the request to the service's own implementation, and does **not** generate the IPS bundle itself.

## References

- [HL7 FHIR IPS Implementation Guide](https://hl7.org/fhir/uv/ips/)
- [Ballerina FHIR R4](https://central.ballerina.io/ballerinax/health.fhirr4/2.2.0)
- [Ballerina R4 IPS](https://central.ballerina.io/ballerinax/health.fhir.r4.ips/3.0.0)
