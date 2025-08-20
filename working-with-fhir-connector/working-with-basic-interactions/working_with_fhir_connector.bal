import ballerina/io;
import ballerinax/health.clients.fhir as fhirClient;

// This sample demonstrates how to use the Ballerina FHIR connector to interact with a Cerner EMR system.
// It covers basic FHIR operations such as reading, searching, conditional create, and transaction bundles.
// Before running, configure the connection parameters in `Config.toml` or via environment variables.

// Connection parameters to the Cerner EMR (set these in Config.toml or as environment variables)
// See https://docs.cerner.com for details on obtaining these values.
configurable string base = ?;           // Base URL of the FHIR server
configurable string tokenUrl = ?;       // OAuth2 token endpoint
configurable string clientId = ?;       // OAuth2 client ID
configurable string clientSecret = ?;   // OAuth2 client secret
configurable string[] scopes = ?;       // OAuth2 scopes required for access

// FHIR client configuration for Cerner EMR.
// Includes authentication and connection details.
fhirClient:FHIRConnectorConfig cernerConfig = {
    baseURL: base,
    mimeType: fhirClient:FHIR_JSON,
    authConfig: {
        tokenUrl: tokenUrl,
        clientId: clientId,
        clientSecret: clientSecret,
        scopes: scopes
    }
};

// Create a FHIR client instance using the above configuration
final fhirClient:FHIRConnector fhirConnectorObj = check new (cernerConfig);

// Main entry point for the FHIR connector sample.
// Demonstrates:
//   1. Reading a Patient resource by ID
//   2. Searching for patients by name and birthdate (GET & POST)
//   3. Conditional create of a Patient resource
//   4. Executing a transaction bundle (Patient + Observation)
public function main() returns error? {
    // 1. Read a Patient resource by ID
    // Retrieves the patient with ID "12724067" from Cerner EMR.
    fhirClient:FHIRResponse fhirResponse = check fhirConnectorObj->getById("Patient", "12724067");
    io:println("[FHIR GET] Patient resource by ID (12724067): ", fhirResponse.'resource);

    // 2. Search for patients by name and birthdate using GET
    // Finds patients named "John" with birthdate after 2000-01-01.
    fhirClient:FHIRResponse getSearchResponse = check fhirConnectorObj->search("Patient", searchParameters = {
        "given": "John",
        "birthdate": "gt2000-01-01"
    });
    io:println("[FHIR SEARCH - GET] Patients named 'John' born after 2000-01-01: ", getSearchResponse.'resource);

    // 3. Search for patients by name and birthdate using POST
    // Uses POST for search interaction (useful for complex queries or large parameter sets).
    fhirClient:FHIRResponse postSearchResponse = check fhirConnectorObj->search("Patient", mode = fhirClient:POST, searchParameters = {
        "given": "John",
        "birthdate": "gt2000-01-01"
    });
    io:println("[FHIR SEARCH - POST] Patients named 'John' born after 2000-01-01: ", postSearchResponse.'resource);

    // 4. Conditional create of a Patient resource
    // Creates a Patient only if one with _id "demo-123" does not already exist.
    map<string[]> condition = {"_id": ["demo-123"]};
    fhirClient:FHIRResponse response = check fhirConnectorObj->create(newPatient, onCondition = condition);
    io:println("[FHIR CONDITIONAL CREATE] Patient with _id 'demo-123': ", response.'resource);

    // 5. Transaction interaction: create/update multiple resources atomically
    // Bundle includes a Patient and an Observation linked to that patient.
    // Send the transaction bundle to Cerner EMR
    fhirClient:FHIRResponse transactionResponse = check fhirConnectorObj->'transaction(bundleForTransaction);
    io:println("[FHIR TRANSACTION] Bundle response (Patient + Observation): ", transactionResponse.'resource);
}
