@isTest
public with sharing class PerfilProfissionalControllerTest {
    @TestSetup
    static void makeData(){
        DataFactoryShared.createPerfilProfissional();
        DataFactoryShared.createPerfilIndisponibilidade();
    }

    @isTest
    public static void getAllPerfilTest() {
        Perfil_Profissional__c perf = [SELECT Id FROM Perfil_Profissional__c LIMIT 1];
        String exp = '[{"attributes":{"type":"Perfil_Profissional__c","url":"/services/data/v54.0/sobjects/Perfil_Profissional__c/'+perf.Id+'"},"Name":"Perfil Teste","Carga_Horaria__c":8.00,"Periodicidade__c":"Diária","Id":"'+perf.Id+'"}]';
        String msg = 'O retorno do método é diferente do esperado';
        String ret = PerfilProfissionalController.getAllPerfil();
        System.assertEquals(exp, ret, msg);
    }

    @isTest
    public static void getPerfilTest() {
        Perfil_Profissional__c perf = [SELECT Id FROM Perfil_Profissional__c LIMIT 1];
        String exp = '[{"attributes":{"type":"Perfil_Profissional__c","url":"/services/data/v54.0/sobjects/Perfil_Profissional__c/'+perf.Id+'"},"Name":"Perfil Teste","Carga_Horaria__c":8.00,"Periodicidade__c":"Diária","Id":"'+perf.Id+'"}]';
        String msg = 'O retorno do método é diferente do esperado';
        String ret = PerfilProfissionalController.getPerfil(perf.Id);
        System.assertEquals(exp, ret, msg);
    }

    @isTest
    public static void getIndispoTest() {
        Perfis_Indisponibilidade__c perf = [SELECT Id FROM Perfis_Indisponibilidade__c LIMIT 1];
        String exp = '[{"attributes":{"type":"Perfis_Indisponibilidade__c","url":"/services/data/v54.0/sobjects/Perfis_Indisponibilidade__c/'+ perf.Id +'"},"Name":"Teste Perfil Indisponibilidade","Id":"' + perf.Id + '"}]';
        String msg = 'O retorno do método é diferente do esperado';
        String ret = PerfilProfissionalController.getIndispo('string');
        System.assertEquals(exp, ret, msg);
    }
}