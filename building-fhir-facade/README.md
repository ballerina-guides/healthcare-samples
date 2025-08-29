# FHIR Service

A Ballerina-based FHIR R4 Service sample implemented to showcase FHIR Facade pattern that provides REST APIs for managing Patient and Encounter resources with US Core profile support.

## Overview

This service implements the Fast Healthcare Interoperability Resources (FHIR) R4 standard, providing a robust healthcare data management system. It includes support for US Core profiles to ensure compliance with US healthcare interoperability requirements.

## Features

- **FHIR R4 Compliance**: Full support for FHIR R4 standard
- **US Core Profiles**: Implementation of US Core Patient and Encounter profiles
- **RESTful APIs**: Complete CRUD operations for healthcare resources
- **Search Capabilities**: FHIR-compliant search parameters for resource discovery
- **Database Integration**: MySQL persistence layer with auto-generated client
- **Data Mapping**: Seamless conversion between database models and FHIR resources
- **Capability Statement**: Auto-generated FHIR capability statement endpoint

## Supported Resources

### Patient Resource
- **Profile**: US Core Patient Profile
- **Operations**: Create, Read, Update, Delete, Search
- **Search Parameters**: 
  - `name` - Search by patient name
  - `family` - Search by family name
  - `given` - Search by given name
  - `identifier` - Search by patient identifier
  - `gender` - Search by gender
  - `birthdate` - Search by birth date
  - `race` - Search by race extension
  - `ethnicity` - Search by ethnicity extension

### Encounter Resource
- **Profile**: US Core Encounter Profile
- **Operations**: Create, Read, Update, Delete, Search (planned)
- **Search Parameters**:
  - `class` - Classification of patient encounter
  - `patient` - The patient present at the encounter
  - `status` - Encounter status
  - `date` - Date within the encounter period
  - `type` - Specific type of encounter
  - `identifier` - Encounter identifier

## API Endpoints

### Capability Statement
- `GET /fhir/r4/metadata` - Retrieve FHIR capability statement

### Patient API
- `GET /fhir/r4/Patient/{id}` - Read patient by ID
- `GET /fhir/r4/Patient` - Search patients
- `POST /fhir/r4/Patient` - Create new patient
- `PUT /fhir/r4/Patient/{id}` - Update patient (planned)
- `PATCH /fhir/r4/Patient/{id}` - Partial update patient (planned)
- `DELETE /fhir/r4/Patient/{id}` - Delete patient (planned)

### Encounter API
- `GET /fhir/r4/Encounter/{id}` - Read encounter by ID (planned)
- `GET /fhir/r4/Encounter` - Search encounters (planned)
- `POST /fhir/r4/Encounter` - Create new encounter (planned)
- `PUT /fhir/r4/Encounter/{id}` - Update encounter (planned)
- `PATCH /fhir/r4/Encounter/{id}` - Partial update encounter (planned)
- `DELETE /fhir/r4/Encounter/{id}` - Delete encounter (planned)

## Configuration

The service requires the following configuration parameters:

### Database Configuration
```toml
# Database connection settings
host = "localhost"
port = 3306
user = "your_username"
password = "your_password"
database = "fhir_db"

# Server configuration
SERVER_BASE_URL = "http://localhost:9090"
```

## Database Schema

### PatientData Table
- `id` (string) - Primary key
- `name` (string, optional) - Patient name
- `gender` (string, optional) - Patient gender
- `birthDate` (string, optional) - Patient birth date

### EncounterData Table
- `id` (string) - Primary key
- `status` (string) - Encounter status
- `encounterClassSystem` (string, optional) - Class system
- `encounterClassCode` (string, optional) - Class code
- `encounterClassDisplay` (string, optional) - Class display
- `typeText` (string, optional) - Encounter type
- `subjectRef` (string) - Reference to patient
- `periodStart` (string, optional) - Start time
- `periodEnd` (string, optional) - End time

## Getting Started

### Prerequisites
- Ballerina Swan Lake (latest version)
- MySQL database server

### Installation

1. Clone the repository
2. Configure the database connection in `Config.toml`
3. Set up the MySQL database with required tables
4. Run the service:

```bash
bal run
```

### Example Usage

#### Create a Patient
```bash
curl -X POST http://localhost:9090/fhir/r4/Patient \
  -H "Content-Type: application/json" \
  -d '{
    "resourceType": "Patient",
    "name": [{"given": ["John"]}],
    "gender": "male",
    "birthDate": "1990-01-01"
  }'
```

#### Search Patients by Name
```bash
curl "http://localhost:9090/fhir/r4/Patient?name=John Doe"
```

#### Get Patient by ID
```bash
curl http://localhost:9090/fhir/r4/Patient/{patient-id}
```

## Architecture

The service follows a layered architecture:

1. **Service Layer**: FHIR-compliant REST endpoints
2. **Data Transformation Layer**: Data mapping between FHIR and database models
3. **Persistence Layer**: Database operations using Ballerina Persist and auto-generated persistent client
4. **Database Layer**: MySQL storage


## License

Copyright (c) 2025, WSO2 LLC. Licensed under the Apache License, Version 2.0.