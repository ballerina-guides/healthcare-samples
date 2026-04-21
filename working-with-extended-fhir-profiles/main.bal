import ballerina/io;
import ballerinax/health.fhir.r4.uscore501;

public function main() returns error? {
    // The following example shows how to populate slice elements of UScore Pulse Oximetry Profile

    // PulseOx slice of the USCorePulseOximetryProfile.code.coding field
    // Min = 1, Max = 1
    // Fixed Value - system = "http://loinc.org", code = "59408-5"
    uscore501:USCorePulseOximetryProfileCodeCodingPulseOx pulseOXCoding = {
        display: "Pulse Oximetry"
    };

    // O2Sat slice of the USCorePulseOximetryProfile.code.coding field
    // Min = 1, Max = 1
    // Fixed Value - system = "http://loinc.org", code = "2708-6"
    uscore501:USCorePulseOximetryProfileCodeCodingO2Sat o2SatCoding = {
        display: "Oxygen saturation"
    };

    // Concentration slice of the USCorePulseOximetryProfile.component field
    // Min = 0, Max = 1
    // Fixed Value - concentration.code.system = "http://loinc.org", concentration.code.code = "3150-0"
    uscore501:USCorePulseOximetryProfileComponentConcentration concetration = {
        code: {
            coding: [{}]
        }
    };

    // FlowRate slice of the USCorePulseOximetryProfile.component field
    // Min = 0, Max = 1
    // Fixed Value - flowRate.code.system = "http://unitsofmeasure.org", flowRate.code.code = "L/min"
    uscore501:USCorePulseOximetryProfileComponentFlowRate flowRate = {
        valueQuantity: {
            unit: "/min",
            value: 5
        },
        code: {
            coding: [{}]
        }
    };

    // VS Cat slice of the USCorePulseOximetryProfile.category field
    // Min = 1, Max = 1
    // Fixed Value - system = "http://terminology.hl7.org/CodeSystem/observation-category", code = "vital-signs"
    uscore501:USCorePulseOximetryProfileCategoryVSCat vsCat = {
        coding: [{}]
    };

    uscore501:USCorePulseOximetryProfile pulseOximetryProfile = {
        code: {
            coding: [pulseOXCoding, o2SatCoding]
        },
        component: [concetration, flowRate],
        effectivePeriod: {
            'start: "2020-03-01T00:00:00.000Z",
            end: "2020-03-01T00:00:00.000Z"
        },
        effectiveDateTime: "2020-03-01T00:00:00.000Z",
        subject: {
            reference: "Patient/123"
        },
        category: [vsCat],
        status: "preliminary"
    };

    // Serialize the UScore Pulse Oximetry Profile to JSON string
    // The serialized JSON will explicitely include fixed values of slice elements
    io:print(pulseOximetryProfile.toJson());
}
