json patient = {
    "resourceType": "Patient",
    "id": "full-example",
    "meta": {
        "versionId": "23",
        "lastUpdated": "2023-09-01T10:23:45Z"
    },
    "text": {
        "status": "generated",
        "div": "<div>Patient John A. Smith, 43-year-old male from Boston, MRN 123456. Contact: 555-123-4567</div>"
    },
    "identifier": [
        {
            "system": "http://hospital.org/mrn",
            "value": "123456"
        },
        {
            "system": "http://hl7.org/fhir/sid/us-ssn",
            "value": "123-45-6789"
        }
    ],
    "active": true,
    "name": [
        {
            "use": "official",
            "family": "Smith",
            "given": ["John", "Andrew"],
            "prefix": ["Mr."]
        },
        {
            "use": "maiden",
            "family": "Johnson"
        }
    ],
    "telecom": [
        {
            "system": "phone",
            "value": "555-123-4567",
            "use": "home"
        },
        {
            "system": "phone",
            "value": "555-987-6543",
            "use": "mobile"
        },
        {
            "system": "email",
            "value": "john.smith@example.com"
        }
    ],
    "gender": "male",
    "birthDate": "1980-06-15",
    "deceasedDateTime": "2022-04-12T09:30:00Z",
    "address": [
        {
            "use": "home",
            "line": ["123 Main Street"],
            "city": "Boston",
            "district": "Suffolk",
            "state": "MA",
            "postalCode": "02115",
            "country": "USA"
        },
        {
            "use": "work",
            "line": ["456 Corporate Blvd"],
            "city": "Cambridge",
            "state": "MA",
            "postalCode": "02139",
            "country": "USA"
        }
    ],
    "maritalStatus": {
        "coding": [
            {
                "system": "http://terminology.hl7.org/CodeSystem/v3-MaritalStatus",
                "code": "M",
                "display": "Married"
            }
        ]
    },
    "multipleBirthInteger": 2,
    "photo": [
        {
            "contentType": "image/jpeg",
            "url": "http://hospital.org/photos/patient123.jpg"
        }
    ],
    "contact": [
        {
            "relationship": [
                {
                    "coding": [
                        {
                            "system": "http://terminology.hl7.org/CodeSystem/v2-0131",
                            "code": "N",
                            "display": "Next of Kin"
                        }
                    ]
                }
            ],
            "name": {
                "family": "Smith",
                "given": ["Jane"]
            },
            "telecom": [
                {
                    "system": "phone",
                    "value": "555-765-4321"
                }
            ],
            "address": {
                "line": ["456 Oak Avenue"],
                "city": "Cambridge",
                "state": "MA",
                "postalCode": "02139"
            }
        }
    ],
    "communication": [
        {
            "language": {
                "coding": [
                    {
                        "system": "urn:ietf:bcp:47",
                        "code": "en",
                        "display": "English"
                    }
                ]
            },
            "preferred": true
        }
    ],
    "generalPractitioner": [
        {
            "reference": "Practitioner/123",
            "display": "Dr. Alice Brown"
        }
    ],
    "managingOrganization": {
        "reference": "Organization/1",
        "display": "Smalltown Family Practice"
    },
    "link": [
        {
            "other": {
                "reference": "Patient/related1",
                "display": "Twin Brother"
            },
            "type": "seealso"
        }
    ],
    "extension": [
        {
            "url": "http://example.org/fhir/StructureDefinition/patient-bloodType",
            "valueString": "A+"
        },
        {
            "url": "http://example.org/fhir/StructureDefinition/employer",
            "valueString": "TechCorp International"
        }
    ]
};

json patientBundle = {
    "resourceType": "Bundle",
    "type": "collection",
    "entry": [
        {
            "resource": {
                "resourceType": "Patient",
                "id": "patient-1",
                "identifier": [
                    {"system": "http://hospital.org/mrn", "value": "1001"}
                ],
                "name": [{"use": "official", "family": "Smith", "given": ["John"]}],
                "gender": "male",
                "birthDate": "1980-06-15",
                "telecom": [{"system": "phone", "value": "555-123-4567"}],
                "address": [{"city": "Boston", "state": "MA"}],
                "deceasedBoolean": false
            }
        },
        {
            "resource": {
                "resourceType": "Patient",
                "id": "patient-2",
                "identifier": [
                    {"system": "http://hospital.org/mrn", "value": "1002"}
                ],
                "name": [{"use": "official", "family": "Doe", "given": ["Jane"]}],
                "gender": "female",
                "birthDate": "1990-11-20",
                "telecom": [{"system": "email", "value": "jane.doe@example.com"}],
                "address": [{"city": "Cambridge", "state": "MA"}],
                "deceasedBoolean": false
            }
        },
        {
            "resource": {
                "resourceType": "Patient",
                "id": "patient-3",
                "identifier": [
                    {"system": "http://hospital.org/mrn", "value": "1003"}
                ],
                "name": [{"use": "official", "family": "Lee", "given": ["Kevin"]}],
                "gender": "male",
                "birthDate": "1975-03-05",
                "telecom": [
                    {"system": "phone", "value": "555-987-6543"},
                    {"system": "email", "value": "kevin.lee@example.com"}
                ],
                "address": [{"city": "Springfield", "state": "IL"}],
                "deceasedBoolean": true
            }
        }
    ]
};

