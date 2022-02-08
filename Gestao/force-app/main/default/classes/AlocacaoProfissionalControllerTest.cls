@isTest
public class AlocacaoProfissionalControllerTest {
    @TestSetup
    static void criarDados(){
        DataFactoryShared.createAlocacao();
    }

    @isTest
    public static void getAllAlocacaoProfissionalTest(){
        
        Alocacao_Profissional__c dem = [SELECT Id, Profissional__c, Demanda__c FROM Alocacao_Profissional__c LIMIT 1];

        String exp ='[{"attributes":{"type":"Alocacao_Profissional__c","url":"/services/data/v54.0/sobjects/Alocacao_Profissional__c/'+dem.Id+'"},"Profissional__c":"'+dem.Profissional__c+'","Demanda__c":"'+dem.Demanda__c+'","Data_Inicio__c":"2022-02-03","Data_Fim__c":"2022-02-08","Total_De_Dias__c":4,"Horas__c":20.00,"Periodicidade__c":"Diária","Horas_Executadas__c":0.00,"Total_De_Horas__c":80.00,"Id":"'+dem.Id+'","Profissional__r":{"attributes":{"type":"Profissional__c","url":"/services/data/v54.0/sobjects/Profissional__c/'+dem.Profissional__c+'"},"Id":"'+dem.Profissional__c+'","Name":"Pro Teste"},"Demanda__r":{"attributes":{"type":"Demanda__c","url":"/services/data/v54.0/sobjects/Demanda__c/'+dem.Demanda__c+'"},"Id":"'+dem.Demanda__c+'","Name":"Demanda Teste"}}]';
        String ret = AlocacaoProfissionalController.getAllAlocacaoProfissional();
        String msg = 'O retorno do método não é o esperado';
        system.debug('retorno');
        system.debug(ret);
        system.assertEquals(exp, ret, msg);
    }

    @isTest
    public static void getTranslatedDateTest(){
        String msg = 'O retorno do método não é o esperado';
        String stringDate = '2022-12-22T00:00:00';
        Date ret = AlocacaoProfissionalController.getTranslatedDate(stringDate);
        Date exp = Date.newInstance(2022, 12, 22);
        system.assertEquals(exp, ret, msg);
    }

    @isTest
    public static void getMapaAlocacaoTest(){
        String msg = 'O retorno do método não é o esperado';
        List<Alocacao_Profissional__c> prof = [SELECT Id, Data_Inicio__c, Data_Fim__c, Demanda__c, Profissional__c FROM Alocacao_Profissional__c LIMIT 1];
        String[] arrayDate = new String[] {'2021-01-22T00:00:00', '2022-12-22T00:00:00'};
        List<Alocacao_Profissional__c> ret = AlocacaoProfissionalController.getMapaAlocacao(arrayDate);
        System.debug('Ret >>> '+ret);
        system.assertEquals(prof[0].Id, ret[0].Id, msg);
    }
}