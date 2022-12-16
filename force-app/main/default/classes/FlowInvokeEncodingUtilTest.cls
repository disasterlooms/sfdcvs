@isTest
public class FlowInvokeEncodingUtilTest {
    @isTest
    private static void validateUpdateArchivedTasks(){            
        Test.startTest();
        List<String> InputApikeys = new List<String>{'abcdefghijk'};
        FlowInvokeEncodingUtil.getBase64String(InputApikeys); 
        Test.stopTest();
    }
    
    
}