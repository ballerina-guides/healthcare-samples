import ballerina/io;
import wso2healthcare/healthcare.hl7 as hl7;
import wso2healthcare/healthcare.hl7v23 as hl7v23;

public function main() returns error? {

    // The following example is a simple serialized HL v2.3 ADT A01 message.
    string msg = "MSH|^~\\&|ADT1|GOOD HEALTH HOSPITAL|GHH LAB, INC.|GOOD HEALTH HOSPITAL|198808181126|SECURITY|ADT^A01^ADT_A01|MSG00001|P|2.3||\r"
                + "EVN|A01|200708181123||\r"
                + "PID|1||PATID1234^5^M11^ADT1^MR^GOOD HEALTH HOSPITAL~123456789^^^USSSA^SS||BATMAN^ADAM^A^III||19610615|M||C|2222 HOME STREET^^"
                + "GREENSBORO^NC^27401-1020|GL|(555) 555-2004|(555)555-2004||S||PATID12345001^2^M10^ADT1^AN^A|444333333|987654^NC|\r"
                + "NK1|1|NUCLEAR^NELDA^W|SPO^SPOUSE||||NK^NEXT OF KIN\r"
                + "PV1|1|I|2000^2012^01||||004777^ATTEND^AARON^A|||SUR||||ADM|A0|";

    // TODO remove once the string input is supported
    byte[] msgBytes = hl7:createHL7WirePayload(msg.toBytes());

    // Parse it
    hl7:HL7Parser parser = new ();
    hl7:Message|hl7:GenericMessage|hl7:HL7Error parsedMsg = parser.parse(msgBytes);

    if parsedMsg is hl7:HL7Error {
        io:println("Error occurred while parsing the received message. Details: "+ (parsedMsg.detail().message?:""));
        return error("Error occurred while parsing the received message", parsedMsg);
    }

    // This message, ADT^A01 is an HL7 data type consisting of several components, so we
    // will cast it as such. The ADT_A01 class extends from Message, providing specialized
    // accessors for ADT^A01's segments.
    //  
    // Ballerina HL7 provides several versions of the ADT_A01 record type, each in a different package (note
    // the import statement above) corresponding to the HL7 version for the message.

    hl7v23:ADT_A01 adtMsg = <hl7v23:ADT_A01>parsedMsg;
    hl7v23:XPN[] patientName = adtMsg.pid.pid5;
    io:println("Patient Family Name: " + patientName[0].xpn1);
}

