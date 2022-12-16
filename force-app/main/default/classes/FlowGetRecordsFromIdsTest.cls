@isTest
public class FlowGetRecordsFromIdsTest {
    @isTest
    public static void CanGetRecordsFromIds() {
        

        FlowGetRecordsFromIds.Request curRequest = new FlowGetRecordsFromIds.Request();
        curRequest.objectName = 'AccountTeamMember';
        curRequest.fieldNames = 'Id,Name';
        curRequest.inputIds = new List<String>();
        curRequest.inputIds.add('4o4M4o4M');
        curRequest.inputIds.add('j34k4o4M');
        
        List<FlowGetRecordsFromIds.Request> curRequests = new List<FlowGetRecordsFromIds.Request>();
        curRequests.add(curRequest);
        List<FlowGetRecordsFromIds.Result> curResponses = FlowGetRecordsFromIds.execute(curRequests);
        System.debug('curResponses is:' + curResponses);
        System.assertEquals(curResponses[0].records, null);
    }

}