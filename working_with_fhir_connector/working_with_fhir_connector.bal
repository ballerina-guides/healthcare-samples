import ballerina/io;
import ballerinax/health.clients.fhir as fhirClient;

// Connection parameters to the  Cerner EMR
configurable string base = ?;
configurable string tokenUrl = ?;
configurable string clientId = ?;
configurable string clientSecret = ?;
configurable string[] scopes = ?;

// Create a FHIR client configuration
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

// Create a FHIR client
final fhirClient:FHIRConnector fhirConnectorObj = check new (cernerConfig);

public function main() returns error? {
    // Get a patient resource by id
    fhirClient:FHIRResponse fhirResponse = check fhirConnectorObj->getById("Patient", "12724067");
    io:println("Cerner EMR response: ", fhirResponse.'resource);

    // Search for patients who has the given name "John" and birthdate greater than 2000-01-01
    fhirClient:FHIRResponse searchResponse = check fhirConnectorObj->search("Patient", {
        "given": "John",
        "birthdate": "gt2000-01-01"
    });
    io:println("Cerner EMR search response: ", searchResponse.'resource);
}
