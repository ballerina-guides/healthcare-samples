import ballerina/http;
import ballerinax/health.fhir.r4;
import ballerinax/health.fhir.r4.international401;
import ballerinax/health.fhirr4;

// Patient Service
service / on new fhirr4:Listener(9050, patientApiConfig) {
    isolated resource function get Patient/[string pid](r4:FHIRContext context) returns http:Response {
        international401:Patient patient = {
            id: pid,
            resourceType: "Patient",
            meta: {
                lastUpdated: "2023-10-01T12:00:00Z"
            },
            name: [
                {
                    use: "official",
                    family: "Doe",
                    given: ["John"]
                }
            ],
            birthDate: "1980-01-01"
        };
        
        http:Response response = new;
        response.setPayload(patient);
        response.setHeader("Content-Type", "application/fhir+json");
        response.statusCode = 200;
        return response;
    }
}

// Organization Service
service / on new fhirr4:Listener(9051, organizationApiConfig) {
    isolated resource function get Organization/[string oid](r4:FHIRContext context) returns http:Response {
        international401:Organization organization = {
            id: oid,
            resourceType: "Organization",
            meta: {
                lastUpdated: "2023-10-01T12:00:00Z"
            },
            active: true,
            name: "Example Organization"
        };
        http:Response response = new;
        response.setPayload(organization);
        response.setHeader("Content-Type", "application/fhir+json");
        response.statusCode = 200;
        return response;
    }
}

// AllergyIntolerance Service
service / on new fhirr4:Listener(9052, allergicApiConfig) {
    isolated resource function get AllergyIntolerance(r4:FHIRContext context) returns http:Response {
        international401:AllergyIntolerance[] allergies = [
            {
                id: "allergy-id-1",
                resourceType: "AllergyIntolerance",
                meta: {
                    lastUpdated: "2023-10-01T12:00:00Z"
                },
                patient: {
                    reference: "Patient/102"
                },
                clinicalStatus: {
                    coding: [
                        {
                            system: "http://terminology.hl7.org/CodeSystem/allergyintolerance-clinical",
                            code: "active",
                            display: "Active"
                        }
                    ]
                }
            }
        ];
        r4:Bundle bundle = r4:createFhirBundle(r4:BUNDLE_TYPE_SEARCHSET, allergies);
        http:Response response = new;
        response.setPayload(bundle);
        response.setHeader("Content-Type", "application/fhir+json");
        response.statusCode = 200;
        return response;
    }
}

// Condition Service
service / on new fhirr4:Listener(9053, conditionApiConfig) {
    isolated resource function get Condition(r4:FHIRContext context) returns http:Response {
        international401:Condition[] conditions = [
            {
                id: "condition-id-1",
                resourceType: "Condition",
                meta: {
                    lastUpdated: "2023-10-01T12:00:00Z"
                },
                clinicalStatus: {
                    coding: [
                        {
                            system: "http://terminology.hl7.org/CodeSystem/condition-clinical",
                            code: "active",
                            display: "Active"
                        }
                    ]
                },
                subject: {
                    reference: "Patient/102"
                }
            },
            {
                id: "condition-id-2",
                resourceType: "Condition",
                meta: {
                    lastUpdated: "2023-10-01T12:00:00Z"
                },
                clinicalStatus: {
                    coding: [
                        {
                            system: "http://terminology.hl7.org/CodeSystem/condition-clinical",
                            code: "resolved",
                            display: "Resolved"
                        }
                    ]
                },
                subject: {
                    reference: "Patient/102"
                }
            }
        ];
        r4:Bundle bundle = r4:createFhirBundle(r4:BUNDLE_TYPE_SEARCHSET, conditions);
        http:Response response = new;
        response.setPayload(bundle);
        response.setHeader("Content-Type", "application/fhir+json");
        response.statusCode = 200;
        return response;
    }
}

// MedicationStatement Service
service / on new fhirr4:Listener(9054, medicationStatementApiConfig) {
    isolated resource function get MedicationStatement(r4:FHIRContext context) returns http:Response {
        international401:MedicationStatement[] medications = [
            {
                id: "medication-statement-id-1",
                resourceType: "MedicationStatement",
                meta: {
                    lastUpdated: "2023-10-01T12:00:00Z"
                },
                subject: {
                    reference: "Patient/102"
                },
                medicationReference: {
                    reference: "Medication/medication-id-1"
                },
                medicationCodeableConcept: {
                    coding: [
                        {
                            system: "http://www.nlm.nih.gov/research/umls/rxnorm",
                            code: "123456",
                            display: "Example Medication"
                        }
                    ]
                },
                status: "unknown"
            }
        ];
        r4:Bundle bundle = r4:createFhirBundle(r4:BUNDLE_TYPE_SEARCHSET, medications);
        http:Response response = new;
        response.setPayload(bundle);
        response.setHeader("Content-Type", "application/fhir+json");
        response.statusCode = 200;
        return response;
    }
}

// Medication Service
service / on new fhirr4:Listener(9055, medicationApiConfig) {
    isolated resource function get Medication/[string mid](r4:FHIRContext context) returns http:Response {
        international401:Medication medication = {
            id: mid,
            resourceType: "Medication",
            meta: {
                lastUpdated: "2023-10-01T12:00:00Z"
            },
            code: {
                coding: [
                    {
                        system: "http://www.nlm.nih.gov/research/umls/rxnorm",
                        code: "123456",
                        display: "Example Medication"
                    }
                ]
            }
        };
        http:Response response = new;
        response.setPayload(medication);
        response.setHeader("Content-Type", "application/fhir+json");
        response.statusCode = 200;
        return response;
    }
}