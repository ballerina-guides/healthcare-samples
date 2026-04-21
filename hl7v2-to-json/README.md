# HL7 v2 to Custom JSON Sample

This sample demonstrates how to parse a raw HL7 v2.3 message string into a typed Ballerina HL7 v2 message model and then project selected fields into a **custom JSON structure** — a common need when an HL7 v2 message has to be handed off to a downstream system that expects its own record shape.

## What This Sample Does

The code in [`main.bal`](./main.bal) does the following:

1. Starts with a serialised HL7 v2.3 `ADT^A01` admission message (MSH, EVN, PID, NK1, PV1 segments) stored in the `msg` constant.
2. Calls `hl7v2:parse(msg)` and uses `ensureType(hl7v23:ADT_A01)` to get a strongly-typed `ADT_A01` record. Field access on this record is type-checked by the compiler.
3. Defines a lightweight application-specific `Patient` record with just `firstName`, `lastName`, `address`, and `phoneNumber`.
4. Maps selected segment/field values (PID-5 name parts, PID-11 address, PID-13 phone) from the ADT message into the `Patient` record using the `adta01ToPatient` transform function.
5. Prints the result as a JSON string via `toJsonString()`.


## Prerequisites

- [Ballerina Swan Lake](https://ballerina.io/downloads/) 2201.12.3 or later.

## How to Run

```bash
bal run
```

Expected output:

```
Custom patient json: {"firstName":"ADAM", "lastName":"BATMAN", "address":"2222 HOME STREET", "phoneNumber":"(555) 555-2004"}
```

## References

- [Ballerina `health.hl7v2` package](https://central.ballerina.io/ballerinax/health.hl7v2)
- [Ballerina `health.hl7v23` message models](https://central.ballerina.io/ballerinax/health.hl7v23)
- [HL7 v2.3 Standard](https://www.hl7.org/implement/standards/product_brief.cfm?product_id=140)
