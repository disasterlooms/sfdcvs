@isTest
private class TestApprovalRecordPage {
@testSetup
    private static void BuildTestData(){
        BuildTestData.AddRecords();
    }       
    static testmethod void TestgetSpas()
  {		        
      
      String recid  = '04i';
     
      test.startTest();
      
      approvalRecId.getRecId(recid);
      recid = '04h';
      approvalRecId.getRecId(recid);
      test.stopTest();
    }
     static testmethod void TestgetParentRec()
  {		        
      
      String recid  = '';
     
      test.startTest();
      String fieldNames = 'Id, OpportunityId,AccountId';
      string ObjName = 'Quote';
      Quote q = [Select id,AccountId from quote limit 1];
      recid = q.Id;
      Sobject qT = approvalRecId.getRecordDetail(recid, fieldNames, ObjName);
      system.debug('ret value');
      system.debug(qT);
      test.stopTest();
      Quote chkQt = (Quote)qT;
      system.assertEquals(q.AccountId, chkQt.AccountId);
    }
 }