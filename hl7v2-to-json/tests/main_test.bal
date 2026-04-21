import ballerina/test;
import ballerinax/health.hl7v2 as hl7;
import ballerinax/health.hl7v23 as hl7v23;

@test:Config {}
function testAdta01ToPatient() returns error? {
    hl7v23:ADT_A01 adtMsg = check hl7:parse(msg).ensureType(hl7v23:ADT_A01);
    Patient patient = adta01ToPatient(adtMsg);
    
    test:assertEquals(patient.firstName, "ADAM");
    test:assertEquals(patient.lastName, "BATMAN");
    test:assertEquals(patient.address, "2222 HOME STREET");
    test:assertEquals(patient.phoneNumber, "(555) 555-2004");
}
