import ballerinax/health.clients.fhir as fhirClient;
import ballerina/io;

// Connection parameters to your Cerner EMR
configurable string base = "https://fhir-ehr-code.cerner.com/r4/XXXXXXXXXXXXX";
configurable string tokenUrl = "https://authorization.cerner.com/tenants/XXXXXXXXXXXXX/protocols/oauth2/profiles/smart-v1/token";
configurable string clientId = "XXXXXXXXXXXXX";
configurable string clientSecret = "XXXXXXXXXXXXX";
configurable string[] scopes = [ "system/Patient.read" ];

// Create a FHIR client configuration by providing the connection parameters
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

// Create a FHIR client using the configuration
final fhirClient:FHIRConnector fhirConnectorObj = check new (cernerConfig);

public function main() returns error? {
    // Get a patient resource by id using the initialized FHIR client
    fhirClient:FHIRResponse fhirResponse = check fhirConnectorObj->getById("Patient", "12724067");
    // Print the response
    io:println("Cerner EMR response: ", fhirResponse.'resource);

    // Search for patients who has the given name "John" and birthdate greater than 2000-01-01
    fhirClient:FHIRResponse searchResponse = check fhirConnectorObj->search("Patient", {
        "given": "John",
        "birthdate": "gt2000-01-01"
    });
    // Print the response
    io:println("Cerner EMR search response: ", searchResponse.'resource);
}
