import ballerina/io;
import ballerinax/health.hl7v2 as hl7;
import ballerinax/health.hl7v23 as hl7v23;

// The following example is a simple serialized HL v2.3 ADT A01 message.
final string msg = "MSH|^~\\&|ADT1|GOOD HEALTH HOSPITAL|GHH LAB, INC.|GOOD HEALTH HOSPITAL|" +
"198808181126|SECURITY|ADT^A01^ADT_A01|MSG00001|P|2.3||\rEVN|A01|200708181123||" +
"\rPID|1||PATID1234^5^M11^ADT1^MR^GOOD HEALTH HOSPITAL~123456789^^^USSSA^SS||" +
"BATMAN^ADAM^A^III||19610615|M||C|2222 HOME STREET^^GREENSBORO^NC^27401-1020|GL|" +
"(555) 555-2004|(555)555-2004||S||PATID12345001^2^M10^ADT1^AN^A|444333333|987654^NC|" +
"\rNK1|1|NUCLEAR^NELDA^W|SPO^SPOUSE||||NK^NEXT OF KIN$\rPV1|1|I|2000^2012^01||||" +
"004777^ATTEND^AARON^A|||SUR||||ADM|A0|";

// A custom patient record.
type Patient record {
    string firstName;
    string lastName;
    string address;
    string phoneNumber;
};

public function main() returns error? {
    // Parse the HL7 message and ensure that it is of type ADT_A01.
    hl7v23:ADT_A01 adtMsg = check hl7:parse(msg).ensureType(hl7v23:ADT_A01);
    // transform the ADT_AO1 message to a custom patient record.
    Patient patient = adta01ToPatient(adtMsg);
    io:println("Custom patient json: ", patient.toJsonString());
}

function adta01ToPatient(hl7v23:ADT_A01 adtA01) returns Patient => {
    firstName: msg,
    lastName: adtA01.pid.pid5[0].xpn1,
    address: adtA01.pid.pid11[0].xad1,
    phoneNumber: adtA01.pid.pid13[0].xtn1
};

