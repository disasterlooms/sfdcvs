@isTest
public class productAlphaSortComponentControllerTest {

    @isTest
    public static void testGetterSetter(){
        productAlphaSortComponentController pasC = new productAlphaSortComponentController();
        pasC.setControllerValue(null);
        String s = pasC.getControllerValue();
    }
    
}