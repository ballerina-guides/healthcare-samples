import ballerina/log;
import ballerinax/health.fhir.r4;
import ballerinax/health.fhir.r4.parser;
import ballerinax/health.hl7v2;

// This file contains utility function that will be added to v2tofhir lib

isolated map<enrichFhirResource> customTransformationFunctions = {
};

isolated boolean isSkipMergeConfig = false;

public type enrichFhirResource isolated function (r4:Resource originalResource, hl7v2:Message incomingMsg) returns r4:Resource|error;

public isolated function postProcessBundle(r4:Bundle bundle, hl7v2:Message incomingMsg) returns r4:Bundle|error {
    r4:BundleEntry[] updatedEntries = [];
    r4:BundleEntry[] entries = <r4:BundleEntry[]>bundle.entry;
    map<enrichFhirResource> customMappings = {};
    boolean isSkipMerge = false;

    lock {
        isSkipMerge = isSkipMergeConfig;
    }

    lock {
        customMappings = customTransformationFunctions.clone();
    }
    foreach var entry in entries {
        r4:Resource unionResult = check entry?.'resource.cloneWithType(r4:Resource);
        string resourceType = unionResult.resourceType;

        if customMappings.hasKey(resourceType) {
            enrichFhirResource customFunction = customMappings.get(resourceType);
            r4:Resource transformedResource = check customFunction(unionResult.clone(), incomingMsg.clone());
            // Merge original resource with transformed resource
            if isSkipMerge.clone() {
                updatedEntries.push({'resource: transformedResource});
            } else {
                updatedEntries.push({'resource: mergeFhirResources(unionResult, transformedResource)});
            }
        } else {
            updatedEntries.push(entry.clone());
        }
        continue;
    }
    bundle.entry = updatedEntries;

    return bundle;
}

public isolated function mergeFhirResources(r4:Resource originalResource, r4:Resource transformedResource) returns r4:Resource {
    // Merge logic here
    // This is a placeholder for the actual merge logic
    json transformed = transformedResource.toJson();
    json original = originalResource.toJson();
    json|error merged = original.mergeJson(transformed);

    if merged is error {
        log:printError("Error merging resources. Ignoring original FHIR resource", merged);
        return transformedResource;
    }
    // Convert merged json back to FHIR resource
    r4:Resource|error mergedResource = parser:parse(merged.toString()).ensureType(r4:Resource);
    if mergedResource is error {
        log:printError("Error parsing merged resource. Ignoring original FHIR resource", mergedResource);
        return transformedResource;
    }
    return mergedResource;
}

public isolated function addCustomTransformationFunction(string resourceType, enrichFhirResource customFunction) {
    lock {
        customTransformationFunctions[resourceType] = customFunction;
    }
}
