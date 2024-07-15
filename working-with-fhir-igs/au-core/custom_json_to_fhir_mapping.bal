import ballerina/io;
import ballerinax/health.fhir.r4;
import ballerinax/health.fhir.r4.aubase421;
import ballerinax/health.fhir.r4.aucore040;

public function main() returns error? {
    json patientData = {
        "patient_id": "12345",
        "first_name": "John",
        "last_name": "Doe",
        "date_of_birth": "1980-01-01",
        "gender": "male",
        "contact_information": {
            "phone": "555-1234",
            "email": "john.doe@example.com",
            "address": {
                "street": "123 Main St",
                "city": "Anytown",
                "state": "AU-NSW",
                "zip": "12345"
            }
        },
        "emergency_contact": {
            "name": "Jane Doe",
            "relationship": "spouse",
            "phone": "555-5678"
        },
        "insurance_information": {
            "provider": "Health Insurance Co.",
            "policy_number": "XYZ123456",
            "group_number": "98765"
        },
        "medical_history": [
            {
                "condition": "hypertension",
                "diagnosis_date": "2010-05-15",
                "notes": "Managed with medication"
            },
            {
                "condition": "diabetes",
                "diagnosis_date": "2015-09-23",
                "notes": "Type 2 diabetes, diet-controlled"
            }
        ],
        "current_medications": [
            {
                "name": "Lisinopril",
                "dosage": "10mg",
                "frequency": "once daily"
            },
            {
                "name": "Metformin",
                "dosage": "500mg",
                "frequency": "twice daily"
            }
        ],
        "allergies": [
            {
                "substance": "Penicillin",
                "reaction": "rash"
            }
        ],
        "lab_results": [
            {
                "test": "HbA1c",
                "result": "6.5%",
                "date": "2023-06-15"
            },
            {
                "test": "Lipid Panel",
                "result": {
                    "total_cholesterol": "190 mg/dL",
                    "hdl": "50 mg/dL",
                    "ldl": "110 mg/dL",
                    "triglycerides": "150 mg/dL"
                },
                "date": "2023-06-15"
            }
        ],
        "appointments": [
            {
                "date": "2024-01-20",
                "time": "10:00 AM",
                "provider": "Dr. Smith",
                "reason": "Routine check-up"
            }
        ]
    };
    // Convert the JSON payload to a Ballerina record representation
    PatientData patientRecord = check patientData.cloneWithType(PatientData);
    // Map the custom patient data structure to AU Core Patient using created data mapping function
    aucore040:AUCorePatient mapToAUPatientResult = mapToAUPatient(patientRecord);
    io:println("Converted AU FHIR Patient resource: ", mapToAUPatientResult);
}

// Data mapping function for mapping custom patient data structure to AU Core Patient
// Follow visual data mapping guide to create the data mapping function: https://ballerina.io/learn/vs-code-extension/implement-the-code/data-mapper/#open-the-data-mapper
function mapToAUPatient(PatientData patientData) returns aucore040:AUCorePatient => {
    gender: <aucore040:AUCorePatientGender>patientData.gender,
    birthDate: patientData.date_of_birth,
    name: [
        {
            family: patientData.last_name,
            text: patientData.first_name
        }
    ],
    identifier: <aubase421:AuMedicarecardnumber[]>[
        {
            value: patientData.patient_id,
            'type: {
                coding: [
                    {
                        system: "http://terminology.hl7.org/CodeSystem/v2-0203",
                        code: "MC"
                    }
                ]
            },
            system: "http://ns.electronichealth.net.au/id/medicare-number"
        }
    ],
    telecom: [
        {
            value: patientData.contact_information.phone,
            use: r4:mobile,
            system: r4:phone
        },
        {
            value: patientData.contact_information.email,
            use: r4:work,
            system: r4:email
        }
    ],
    address: <r4:Address[]>[
        {
            city: patientData.contact_information.address.city,
            state: patientData.contact_information.address.state,
            postalCode: patientData.contact_information.address.zip,
            line: [
                patientData.contact_information.address.street
            ]
        }
    ],
    contact: [
        {
            name: {
                given: [
                    patientData.emergency_contact.name
                ]
            },
            telecom: [
                {
                    value: patientData.emergency_contact.phone,
                    use: r4:mobile,
                    system: r4:phone
                }
            ]
        }
    ]
};

// Generated record type from datamapper for patient data by giving the sample input payload. 
// Refer to the datamapper documentation for more information: https://ballerina.io/learn/vs-code-extension/implement-the-code/data-mapper/#provide-inputs-and-output
type PatientData record {
    string patient_id;
    string first_name;
    string last_name;
    string date_of_birth;
    string gender;
    record {
        string phone;
        string email;
        record {
            string street;
            string city;
            string state;
            string zip;
        } address;
    } contact_information;
    record {
        string name;
        string relationship;
        string phone;
    } emergency_contact;
    record {
        string provider;
        string policy_number;
        string group_number;
    } insurance_information;
    record {
        string condition;
        string diagnosis_date;
        string notes;
    }[] medical_history;
    record {
        string name;
        string dosage;
        string frequency;
    }[] current_medications;
    record {
        string substance;
        string reaction;
    }[] allergies;
    record {
        string test;
        (record {
            string total_cholesterol;
            string hdl;
            string ldl;
            string triglycerides;
        }|string) result;
        string date;
    }[] lab_results;
    record {
        string date;
        string time;
        string provider;
        string reason;
    }[] appointments;
};
