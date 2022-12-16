@isTest
public class LOARequestControllerTest {

    @isTest(seeAllData=true)
    public static void LOATest(){
        LOARequestcontroller.getUserContactInfo();
        Date d = Date.today();
        String s = 'test';
        LOARequestcontroller.insertLOARequest(s,d);
    }
    
}