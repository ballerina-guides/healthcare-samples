# Working with FHIR Connector: Bulk Export Interactions

This sample demonstrates how to use the Ballerina FHIR Connector to perform bulk export operations with a FHIR server. It supports both FTP and local file storage for exported data.

## Configuration

All configuration values are set in `Config.toml`:

- `baseUrl`: The base URL of the FHIR server.
- `fileServerUrl`: The FTP server URL for storing exported files.
- `fileServerDirectory`: The directory on the FTP server for exported files.
- `tempFileExpiryTime`: Expiry time (in seconds) for temporary files when using local storage.

Example:

```toml
baseUrl = "https://bulk-data.smarthealthit.org/fhir"
fileServerUrl = "localhost"
fileServerDirectory = "/exports"
tempFileExpiryTime = 3600
```

## Running the Sample

1. Update `Config.toml` with your FHIR server and file storage details.
2. Run the Ballerina service:

   ```sh
   bal run service.bal
   ```

3. The service listens on port `8080` and exposes the following endpoints:
   - `GET /Patient/export`: Initiates a bulk export for Patient resources.
   - `GET /Patient/{exportId}/status`: Checks the status of a specific export.

## Endpoints

- **Initiate Export**

  ```curl
  GET http://localhost:8080/Patient/export
  ```

  Returns export details and a polling URL.

- **Check Export Status**

  ```curl
  GET http://localhost:8080/Patient/{exportId}/status
  ```

  Returns the current status of the export.

## Notes

- You can switch between FTP and local file storage by changing the configuration in `service.bal`.
- Make sure your FTP server is accessible if using FTP storage.
