// Copyright (c) 2025, WSO2 LLC. (http://www.wso2.com).

// WSO2 LLC. licenses this file to you under the Apache License,
// Version 2.0 (the "License"); you may not use this file except
// in compliance with the License.
// You may obtain a copy of the License at

// http://www.apache.org/licenses/LICENSE-2.0

// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.

import ballerina/http;
import ballerina/io;
import ballerina/log;
import ballerinax/health.fhir.r4;
import ballerinax/health.hl7v2;
import ballerinax/health.hl7v2.utils.v2tofhirr4;

type Hl7Message readonly & record {|
    string content;
|};

configurable int servicePort = 9090;

function init(){
    log:printInfo("HL7v2 to Danish Transformation Service Started..");
}

service /hl7 on new http:Listener(servicePort) {
    resource function post transform(@http:Payload string payload) returns json|string|error {
        string incomingMessage = payload;

        // Log the incoming raw payload
        log:printInfo("Received HL7 message", rawMessage = incomingMessage);

        // Validate if it's a valid HL7 message, and parse
        hl7v2:Message|error parsedMessage = hl7v2:parse(incomingMessage);
        if parsedMessage is error {
            log:printError("Invalid HL7 message", 'error = parsedMessage);
            return error("Invalid HL7 message format");
        }

        json v2tofhirResult = check v2tofhirr4:v2ToFhir(parsedMessage);

        // Cast to FHIR Bundle
        r4:Bundle defaultTransformedBundle = check v2tofhirResult.cloneWithType(r4:Bundle);
        io:println("-------------------- Standard FHIR bundle --------------------");
        io:println(v2tofhirResult);

        // Converting to Danish IG resources
        //http://medcomfhir.dk/ig/core/2.4.0/
        r4:Bundle danishMappingIncludedBundle = check processBundle(defaultTransformedBundle, parsedMessage);

        io:println("-------------------- Danish FHIR bundle --------------------");
        io:println(danishMappingIncludedBundle);
        io:println("------------------------------------------------------------------");

        return danishMappingIncludedBundle.toJson();
    }

}
