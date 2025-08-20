import ballerinax/health.fhir.r4;
import ballerinax/health.fhir.r4.ips;

final r4:ResourceAPIConfig patientApiConfig = {
    resourceType: "Patient",
    profiles: [
        "http://hl7.org/fhir/us/core/StructureDefinition/us-core-patient"
    ],
    defaultProfile: (),
    searchParameters: [],
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
                    {
                        sectionName: ips:ALLERGIES,
                        sectionTitle: "Allergies and Intolerances",
                        resources: [
                            {resourceType: "AllergyIntolerance"}
                        ]
                    },
                    {
                        sectionName: ips:MEDICATIONS,
                        sectionTitle: "Medication Summary",
                        resources: [
                            {resourceType: "MedicationStatement"}
                        ]
                    }
                ],
                ipsMetaData: {
                    authors: ["Organization/50"]
                }
            }
        }
    ],
    serverConfig: (),
    authzConfig: (),
    auditConfig: ()
};

final r4:ResourceAPIConfig organizationApiConfig = {
    resourceType: "Organization",
    profiles: [
        "http://hl7.org/fhir/us/core/StructureDefinition/us-core-organization"
    ],
    defaultProfile: (),
    searchParameters: [],
    operations: [],
    serverConfig: (),
    authzConfig: ()
};

final r4:ResourceAPIConfig allergicApiConfig = {
    resourceType: "AllergyIntolerance",
    profiles: [
        "http://hl7.org/fhir/us/core/StructureDefinition/us-core-allergyintolerance"
    ],
    defaultProfile: (),
    searchParameters: [
        {
            name: "patient",
            active: true,
            'type: r4:STRING,
            information: {
                description: "Patient receiving the products or services",
                documentation: "https://hl7.org/fhir/R4/search.html#reference"
            }
        }
    ],
    operations: [],
    serverConfig: (),
    authzConfig: ()
};

final r4:ResourceAPIConfig conditionApiConfig = {
    resourceType: "Condition",
    profiles: [
        "http://hl7.org/fhir/us/core/StructureDefinition/us-core-condition"
    ],
    defaultProfile: (),
    searchParameters: [
        {
            name: "patient",
            active: true,
            'type: r4:STRING,
            information: {
                description: "Who has the condition?",
                documentation: "https://hl7.org/fhir/R4/search.html#reference"
            }
        }
    ],
    operations: [],
    serverConfig: (),
    authzConfig: ()
};

final r4:ResourceAPIConfig medicationStatementApiConfig = {
    resourceType: "MedicationStatement",
    profiles: [
        "http://hl7.org/fhir/StructureDefinition/MedicationStatement"
    ],
    defaultProfile: (),
    searchParameters: [
        {
            name: "subject",
            active: true,
            'type: r4:STRING,
            information: {
                description: "Who the goal is for",
                documentation: "https://hl7.org/fhir/R4/search.html#reference"
            }
        },
        {
            name: "patient",
            active: true,
            'type: r4:STRING,
            information: {
                description: "Who the goal is for",
                documentation: "https://hl7.org/fhir/R4/search.html#reference"
            }
        }
    ],
    operations: [],
    serverConfig: (),
    authzConfig: ()
};

final r4:ResourceAPIConfig medicationApiConfig = {
    resourceType: "Medication",
    profiles: [
        "http://hl7.org/fhir/StructureDefinition/Medication"
    ],
    defaultProfile: (),
    searchParameters: [
        {
            name: "code",
            active: true,
            'type: r4:STRING,
            information: {
                description: "Returns medications with the specified code",
                documentation: "https://hl7.org/fhir/R4/search.html#token"
            }
        },
        {
            name: "_id",
            active: true,
            'type: r4:STRING,
            information: {
                description: "Logical id of this artifact",
                documentation: "https://hl7.org/fhir/R4/search.html#string"
            }
        }
    ],
    operations: [],
    serverConfig: (),
    authzConfig: ()
};