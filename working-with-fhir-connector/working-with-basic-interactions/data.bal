json newPatient = {
    "resourceType": "Patient",
    "id": "demo-123",
    "text": {
        "status": "generated",
        "div": "<div xmlns=\"http://www.w3.org/1999/xhtml\"><table class=\"hapiPropertyTable\"><tbody/></table></div>"
    }
};

json bundleForTransaction = {
    "resourceType": "Bundle",
    "type": "transaction",
    "entry": [
        {
            "resource": {
                "resourceType": "Patient",
                "id": "txn-demo-patient",
                "text": {
                    "status": "generated",
                    "div": "<div xmlns=\"http://www.w3.org/1999/xhtml\">Transaction Patient</div>"
                }
            },
            "request": {
                "method": "PUT",
                "url": "Patient/txn-demo-patient"
            }
        },
        {
            "resource": {
                "resourceType": "Observation",
                "id": "txn-demo-obs",
                "status": "final",
                "code": {
                    "coding": [
                        {
                            "system": "http://loinc.org",
                            "code": "3141-9",
                            "display": "Weight Measured"
                        }
                    ]
                },
                "subject": {
                    "reference": "Patient/txn-demo-patient"
                },
                "valueQuantity": {
                    "value": 70.0,
                    "unit": "kg"
                }
            },
            "request": {
                "method": "PUT",
                "url": "Observation/txn-demo-obs"
            }
        }
    ]
};
