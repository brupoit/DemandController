@isTest
public class DemandaControllerTest {
    @TestSetup
    static void criarDados(){
        DataFactoryShared.createAccountFull();
    }

    @isTest
    public static void getAllDemandasTest(){
        String msg = 'O retorno do método não é o esperado';
        Demanda__c dem = [SELECT Id FROM Demanda__c LIMIT 1];
        List<Demanda__c> lista = DemandaController.getAllDemandas();

        system.assertEquals(dem.Id, lista[0].Id, msg);
    }

    @isTest
    public static void getTranslatedDateTest(){
        String msg = 'O retorno do método não é o esperado';
        String stringDate = '2022-12-22T00:00:00';
        Date ret = DemandaController.getTranslatedDate(stringDate);
        Date exp = Date.newInstance(2022, 12, 22);
        system.assertEquals(exp, ret, msg);
    }
    
    @isTest
    public static void getDemandasTest(){
        String msg = 'O retorno do método não é o esperado';
        Demanda__c dem = [SELECT Id, Data_Inicio__c, Data_Fim__c, Conta__c, Lider__c FROM Demanda__c LIMIT 1];
        String exp = '[{"attributes":{"type":"Demanda__c","url":"/services/data/v54.0/sobjects/Demanda__c/'+dem.Id+'"},"Id":"'+dem.Id+'","Name":"Demanda Teste","Conta__c":"'+dem.Conta__c+'","Lider__c":"'+dem.Lider__c+'","Horas_Alocadas__c":0.00,"Horas_Executadas__c":0.00,"Horas_Por_Alocar__c":0.00,"Conta__r":{"attributes":{"type":"Account","url":"/services/data/v54.0/sobjects/Account/'+dem.Conta__c+'"},"Id":"'+dem.Conta__c+'","Name":"Test Account"},"Lider__r":{"attributes":{"type":"Profissional__c","url":"/services/data/v54.0/sobjects/Profissional__c/'+dem.Lider__c+'"},"Id":"'+dem.Lider__c+'","Name":"Pro Teste"}}]';
        String[] arrayDate = new String[] {'2021-01-22T00:00:00', '2022-12-22T00:00:00'};
        String ret = DemandaController.getDemandas(arrayDate);
        System.debug('Ret >>> '+ret);
        system.assertEquals(exp, ret, msg);
    }

    @isTest
    public static void getDemandaTest(){
        Demanda__c dem = [SELECT Id, Conta__c, Lider__c FROM Demanda__c LIMIT 1];
        String exp = '[{"attributes":{"type":"Demanda__c","url":"/services/data/v54.0/sobjects/Demanda__c/'+dem.Id+'"},"Id":"'+dem.Id+'","Name":"Demanda Teste","Conta__c":"'+dem.Conta__c+'","Lider__c":"'+dem.Lider__c+'","Horas_Alocadas__c":0.00,"Horas_Executadas__c":0.00,"Horas_Por_Alocar__c":0.00,"Conta__r":{"attributes":{"type":"Account","url":"/services/data/v54.0/sobjects/Account/'+dem.Conta__c+'"},"Id":"'+dem.Conta__c+'","Name":"Test Account"},"Lider__r":{"attributes":{"type":"Profissional__c","url":"/services/data/v54.0/sobjects/Profissional__c/'+dem.Lider__c+'"},"Id":"'+dem.Lider__c+'","Name":"Pro Teste"}}]';
        String ret = DemandaController.getDemanda(dem.Id);
        String msg = 'O retorno do método não é o esperado';

        system.assertEquals(exp, ret, msg);
    }
}