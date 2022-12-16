@isTest
public class spabrControllerTest {
    static testMethod void  getAccessDetailsTest(){
        Boolean flag = spabrController.getAccessDetails();
        system.assertEquals(true, flag);
    }
    
}