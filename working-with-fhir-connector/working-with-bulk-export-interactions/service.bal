import ballerina/http;
import ballerinax/health.clients.fhir as fhir_client;

// Configurable variables for FHIR server and bulk export settings
configurable string baseUrl = ?;
configurable string fileServerUrl = ?;
configurable string fileServerDirectory = ?;
configurable decimal tempFileExpiryTime = ?;

// Configuration for the FHIR server and bulk export settings
fhir_client:FHIRConnectorConfig fhirServerConfig = {
    baseURL: baseUrl,
    mimeType: fhir_client:FHIR_JSON,
    bulkExportConfig: bulkExportConfig // Use the FTP configuration for bulk export
};

// Configuration for bulk export
// This configuration uses FTP for file storage
fhir_client:BulkExportConfig bulkExportConfig = {
    fileServerType: fhir_client:FTP,
    fileServerUrl: fileServerUrl,     // Configurable FTP server URL
    fileServerDirectory: fileServerDirectory // Configurable directory on the FTP server
};

// Local configuration for bulk export
// This configuration uses local file storage with a configurable temporary file expiry time
// Use this configuration within 'fhirServerConfig' if you want to test locally
fhir_client:BulkExportConfig bulkExportConfigLocal = {
    fileServerType: fhir_client:LOCAL,
    tempFileExpiryTime: tempFileExpiryTime // Configurable expiry time
};

// Create a FHIR connector instance with the specified configuration
// Disabling capability statement validation for simplicity
final fhir_client:FHIRConnector fhirConnector = check new (fhirServerConfig, enableCapabilityStatementValidation = false);

// Demonstration service for handling FHIR Patient bulk export requests
// The service listens on port 8080 and provides endpoints for export and status checking
service /Patient on new http:Listener(8080) {
    isolated resource function get export(http:Request req) returns http:Response|error? {
        // Initiate a bulk export for Patient resources
        // The response will contain the export ID and polling URL for checking status
        fhir_client:FHIRResponse response = check fhirConnector->bulkExport(fhir_client:EXPORT_PATIENT);

        // Create an HTTP response with the export details
        // Set the X-Progress header to indicate the status of the export
        http:Response httpResponse = new;
        httpResponse.setJsonPayload(response.'resource.toJson());
        httpResponse.setHeader("X-Progress", response.serverResponseHeaders["X-Progress"] ?: "In-progress");
        httpResponse.statusCode = response.httpStatusCode;
        return httpResponse;
    }

    isolated resource function get [string exportId]/status() returns http:Response|error? {
        // Check the status of a specific export using the export ID
        // The response will contain the current status of the export
        fhir_client:FHIRResponse response = check fhirConnector->bulkStatus(exportId = exportId);

        // Create an HTTP response with the export status details
        // Set the X-Progress header to indicate the status of the export
        http:Response httpResponse = new;
        httpResponse.setJsonPayload(response.'resource.toJson());
        httpResponse.setHeader("X-Progress", response.serverResponseHeaders["X-Progress"] ?: "In-progress");
        httpResponse.statusCode = response.httpStatusCode;
        return httpResponse;
    }
}