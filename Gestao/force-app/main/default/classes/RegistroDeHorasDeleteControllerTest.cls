@isTest
public class RegistroDeHorasDeleteControllerTest {
    static testMethod void myUnitTest() {
        Test.startTest();    
            RegistroDeHorasDeleteController testRHDelete = new RegistroDeHorasDeleteController(new ApexPages.StandardController(new Registro_de_horas__c())); 
            testRHDelete.gotoRegistroDeHoras();
        Test.stopTest();
    }    
}