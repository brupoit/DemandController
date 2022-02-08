@isTest
public with sharing class IndisponibilidadeControllerTest {
    @TestSetup
    static void makeData(){
        DataFactoryShared.createIndisponibilidade();
    }
    @isTest
    public static void getAllIndisponibilidadeTest() {
        String msg = 'O retorno do método não é o esperado';
        Indisponibilidade__c indisp = [SELECT Id, Name, Profissional__c FROM Indisponibilidade__c LIMIT 1];
        String exp = '[{"attributes":{"type":"Indisponibilidade__c","url":"/services/data/v54.0/sobjects/Indisponibilidade__c/'+indisp.Id+'"},"Name":"'+indisp.Name+'","Profissional__c":"'+indisp.Profissional__c+'","Data_Inicio__c":"2022-02-02","Data_Fim__c":"2022-02-09","Id":"'+indisp.Id+'","Profissional__r":{"attributes":{"type":"Profissional__c","url":"/services/data/v54.0/sobjects/Profissional__c/'+indisp.Profissional__c+'"},"Id":"'+indisp.Profissional__c+'","Name":"Pro Teste"}}]';
        String ret = IndisponibilidadeController.getAllIndisponibilidade();
        system.debug(ret);
        system.assertEquals(exp, ret, msg);
    }


    @isTest    
    public static void getIndisponibilidadeTest() {
    String msg = 'O retorno do método não é o esperado';
        Indisponibilidade__c indisp = [SELECT Id, Name, Profissional__c FROM Indisponibilidade__c LIMIT 1];
        String exp = '[{"attributes":{"type":"Indisponibilidade__c","url":"/services/data/v54.0/sobjects/Indisponibilidade__c/'+indisp.Id+'"},"Name":"'+indisp.Name+'","Profissional__c":"'+indisp.Profissional__c+'","Data_Inicio__c":"2022-02-02","Data_Fim__c":"2022-02-09","Id":"'+indisp.Id+'","Profissional__r":{"attributes":{"type":"Profissional__c","url":"/services/data/v54.0/sobjects/Profissional__c/'+indisp.Profissional__c+'"},"Id":"'+indisp.Profissional__c+'","Name":"Pro Teste"}}]';
        String ret = IndisponibilidadeController.getIndisponibilidade(indisp.Id);
        system.debug(ret);
        system.assertEquals(exp, ret, msg);
    }
}