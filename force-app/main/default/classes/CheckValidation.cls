global inherited sharing class CheckValidation {

// Attributes passed in from the Flow
global class Requests {

@InvocableVariable(label='Input Record')
global SObject inputRecord;

@InvocableVariable(label='Input Record Collection')
global List<sobject> inputCollection;

@InvocableVariable(Label='Record Identifier Field API Name')
global String recordField;

@InvocableVariable(Label='If no errors, commit inserted & updated records?')
global Boolean isCommit;

@InvocableVariable(Label='Check duplicate rules on new records?')
global Boolean checkDuplicates;


}

// Attributes passed back to the Flow
global class Results {

@InvocableVariable
global Boolean isError;

@InvocableVariable
global Boolean isDuplicate;

@InvocableVariable
global String errorMessages;

@InvocableVariable
global String firstInsertedId;

@InvocableVariable
global List<string> insertedIdCollection;

@InvocableVariable
global List<string> duplicateIdsCollection;

}

// Standard Exception Handling
global class InvocableActionException extends Exception {}

// Expose this Action to the Flow
@InvocableMethod
global static List<results> checkForValidationErrors(List<requests> requestList) {

// Prepare the response to send back to the Flow
Results response = new Results();
List<results> responseWrapper = new List<results>();

// Bulkify proccessing of multiple requests
for (Requests req : requestList) {

// Set initial values
Boolean errorFlag = false;
Boolean isDuplicate = false;
String errorMessages = '';
Integer nullAttributeCount = 0;
String recordIdentifier = '';
List<sobject> insertCollection = new List<sobject>();
List<sobject> updateCollection = new List<sobject>();
List<string> recordFieldIdentifierList = new List<string>();
String firstInsertedId = '';
List<string> insertedIdCollection = new List<string>();
Boolean isFirst = true;
Boolean invalidFieldName = false;
List<string> duplicateIds = new List<string>();

// Get Input Value(s)
SObject inputRecord = req.inputRecord;
List<sobject> inputCollection = req.inputCollection;
String recordField = req.recordField;
Boolean isCommit = req.isCommit == null ? false : true;
Boolean allowSave = !req.checkDuplicates;

// Process input attributes
if (inputRecord == null) {
nullAttributeCount++;
}
if (inputCollection == null) {
nullAttributeCount++;
}
if (recordField == null) {
recordField = 'Id';
}

// Handle Single Record
if (inputRecord != null) {
inputCollection = new List<sobject>();
inputCollection.add(inputRecord);
}

// Validate input attributes
if (nullAttributeCount == 2) {
throw new InvocableActionException('Flow Action Inputs Error: You need to pass a Record or Record Collection into this action.');
}
if (nullAttributeCount != 1) {
throw new InvocableActionException('Flow Action Inputs Error: You must pass only one of Record or Record Collection into this action.');
}
try {
String testFieldName = inputCollection[0].get(recordField).toString(); // This will error out if the recordField is not a valid field API name
}
catch (Exception e) {
invalidFieldName = true;
}

// Process Check for Duplicates Attribute
Database.DMLOptions dml = new Database.DMLOptions();
dml.DuplicateRuleHeader.AllowSave = allowSave;
dml.DuplicateRuleHeader.runAsCurrentUser = true;

// BEGIN APEX ACTION PROCESSING LOGIC

if (!errorFlag) {

// Create Insert & Update Collections
System.debug('Processing ' + inputCollection.size() + ' records');
Integer recCounter = 0;
String recIdentifier = '';
for (SObject ir : inputCollection) {
if (recordField == 'Id' && ir.Id == null) {
recIdentifier = '<new record="">';
} else {
recIdentifier = (!invalidFieldName) ? ir.get(recordField).toString() : '';
}
recordFieldIdentifierList.add(recIdentifier);
recCounter ++;
if (ir.Id == null) {
insertCollection.add(ir);
} else {
updateCollection.add(ir);
}
}
System.debug('Processing ' + insertCollection.size() + ' Insert records');
System.debug('Processing ' + updateCollection.size() + ' Update records');

// Set Save Point
Savepoint sp = Database.setSavepoint();

// Check for Insert Errors
if (insertCollection.size() > 0) {
// Process inserts individually so duplicate rules will fire
for (SObject ir : insertCollection) {
recCounter = 0;
Database.SaveResult sr = Database.insert(ir, dml);
recordIdentifier = recordFieldIdentifierList.get(recCounter);
recCounter ++;
if (sr.isSuccess()) {
if (isCommit) {
if (isFirst) {
isFirst = false;
firstInsertedId = sr.getId();
}
insertedIdCollection.add(sr.getId());
}
System.debug ('Insert Record Passed Validation: ' + sr.getId() + ' ' + recordIdentifier);
} else {
errorFlag = true;
for (Database.Error err : sr.getErrors()) {
System.debug ('New Record Validation Error: ' + err.getStatusCode() + ' - ' + err.getMessage());
//If a duplicate error was returned
if (err.getStatusCode() === StatusCode.DUPLICATES_DETECTED) {
isDuplicate = true;
Datacloud.DuplicateResult duplicateResult = ((Database.DuplicateError)err).getDuplicateResult();
Datacloud.MatchResult[] matchResults = duplicateResult.getMatchResults();
Datacloud.MatchResult matchResult = matchResults[0];
Datacloud.MatchRecord[] matchRecords = matchResult.getMatchRecords();
for ( Datacloud.MatchRecord matchRecord : matchRecords )
{
//duplicateIds.add(matchRecord.getRecord().Id);
duplicateIds.add(matchRecord.getRecord().Id );
errorMessages += 'Duplicate Rule Error: ' + recordIdentifier + ' [' + duplicateResult.getErrorMessage() + ']\n';
System.debug('Duplicate Rule Error: ' + duplicateResult.getDuplicateRule());
}
} else {
errorMessages += 'New Record Error: ' + recordIdentifier + ' [' + err.getMessage() + ']\n';
}
}
}
}
}

// Check for Update Errors
if (updateCollection.size() > 0) {
// Process inserts individually so duplicate rules will fire
for (SObject uc : updateCollection) {
recCounter = 0;
try {
Database.SaveResult sr = Database.update(uc, dml);
recordIdentifier = recordFieldIdentifierList.get(recCounter);
recCounter ++;
if (sr.isSuccess()) {
System.debug ('Update Record Passed Validation: ' + sr.getId() + ' ' + recordIdentifier);
}
else {
errorFlag = true;
for (Database.Error err : sr.getErrors())
{
System.debug ('Record Update Validation Error: ' + err.getStatusCode() + ' - ' + err.getMessage());
//If a duplicate error was returned
if (err.getStatusCode() == StatusCode.DUPLICATES_DETECTED)
{
isDuplicate = true;
Datacloud.DuplicateResult duplicateResult = ((Database.DuplicateError)err).getDuplicateResult();
Datacloud.MatchResult[] matchResults = duplicateResult.getMatchResults();
Datacloud.MatchResult matchResult = matchResults[0];
Datacloud.MatchRecord[] matchRecords = matchResult.getMatchRecords();
for ( Datacloud.MatchRecord matchRecord : matchRecords )
{
duplicateIds.add(matchRecord.getRecord().Id );
errorMessages += 'Duplicate Rule Error: ' + recordIdentifier + ' [' + duplicateResult.getErrorMessage() + ']\n';
System.debug('Duplicate Rule Error: ' + duplicateResult.getDuplicateRule());
}
}
else
{
errorMessages += 'Record Update Error: ' + recordIdentifier + ' [' + err.getMessage() + ']\n';
}
}
}


}
catch (exception e) {
errorFlag = true;
errorMessages += 'Update Error: ' + e.getMessage();
System.debug ('Update Error: ' + e.getMessage());
}
}
}

// Revert Any Updates
if (!isCommit || errorFlag) {
Database.rollback(sp);
}

// END APEX ACTION PROCESSING LOGIC

// Set Output Values
response.isError = errorFlag;
response.isDuplicate = isDuplicate;
response.errorMessages = errorMessages;
response.duplicateIdsCollection = duplicateIds;
if (!errorFlag) {
response.firstInsertedId = firstInsertedId;
response.insertedIdCollection = insertedIdCollection;
}
responseWrapper.add(response);

}

}

// Return values back to the Flow
return responseWrapper;
}

}