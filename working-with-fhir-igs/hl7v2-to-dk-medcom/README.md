# Ballerina HL7v2 to Danish FHIR Converter

This project demonstrates how to use Ballerina's HL7v2 to FHIR conversion utilities along with the MedCom240 Ballerina library to convert standard HL7v2 messages into Danish FHIR resources (referring MedCom Implementation Guide version 2.4.0.)

## Overview

Healthcare interoperability in Denmark requires conformance to the MedCom FHIR profiles. This utility simplifies the process of converting legacy HL7v2 messages into MedCom-compliant FHIR resources, enabling seamless integration between legacy systems and modern FHIR-based healthcare platforms.

## Features

- Convert HL7v2 ADT messages to MedCom FHIR resources
- Support for MedCom Implementation Guide v2.4.0 profiles
- Validation against Danish healthcare requirements
- Comprehensive error handling and logging

## Prerequisites

- [Ballerina](https://ballerina.io/downloads/) 2024R1 (Swan Lake) or newer
- Basic knowledge of HL7v2 and FHIR standards
- Knowledge of Danish healthcare standards and MedCom profiles

## Installation

1. Clone this repository:
   ```bash
   git clone https://github.com/ballerina-guides/healthcare-samples.git
   cd working-with-fhir-igs/hl7v2-to-dk-medcom
   ```

2. Install dependencies:
   ```bash
   bal build
   ```

## Dependencies

Add the following dependencies to your `Ballerina.toml` file:

```toml
[dependencies]
"ballerinax/health.hl7v2" = "2.X.X"
"ballerinax/health.fhir.r4" = "5.X.X"
```
