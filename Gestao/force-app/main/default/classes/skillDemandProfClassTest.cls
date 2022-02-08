@isTest
public with sharing class skillDemandProfClassTest {
    @TestSetup
    static void criarDados(){

        DataFactoryShared.createProfissional();

    }
    @isTest
    public static void getSkillDemandaProfissionalTest() {

        Skills_do_Profissional__c skill = [SELECT Id, Profissional__c FROM Skills_do_Profissional__c LIMIT 1];
        String exp = '[{"attributes":{"type":"Skills_do_Profissional__c","url":"/services/data/v54.0/sobjects/Skills_do_Profissional__c/'+skill.Id+'"},"Id":"'+skill.Id+'","Name":"Skill Teste","Profissional__c":"'+skill.Profissional__c+'","Profissional__r":{"attributes":{"type":"Profissional__c","url":"/services/data/v54.0/sobjects/Profissional__c/'+skill.Profissional__c+'"},"Id":"'+skill.Profissional__c+'","Name":"Pro Teste"}}]';
        String msg = 'O retorno do método não é o esperado';
        // Profissional__c pro = [SELECT Id, Name FROM Profissional__c WHERE Name = 'Pro Teste' LIMIT 1];
        String ret = skillDemandProfClass.getSkillDemandaProfissional();
        system.debug('retorno');
        system.debug(ret);
        system.assertEquals(exp, ret, msg);
    }

    @isTest
    public static void getskillDemTest() {

        Skills_Gestao_de_Demandas__c skillGestao = [SELECT Id, Profissional__c FROM Skills_Gestao_de_Demandas__c LIMIT 1];
        String exp = '[{"attributes":{"type":"Skills_Gestao_de_Demandas__c","url":"/services/data/v54.0/sobjects/Skills_Gestao_de_Demandas__c/'+skillGestao.Id+'"},"Id":"'+skillGestao.Id+'","Name":"Skill Demanda Teste","Profissional__c":"'+skillGestao.Profissional__c+'","Profissional__r":{"attributes":{"type":"Profissional__c","url":"/services/data/v54.0/sobjects/Profissional__c/'+skillGestao.Profissional__c+'"},"Id":"'+skillGestao.Profissional__c+'","Name":"Pro Teste"}}]';
        String msg = 'O retorno do método não é o esperado';
        // Profissional__c pro = [SELECT Id, Name FROM Profissional__c WHERE Name = 'Pro Teste' LIMIT 1];
        String ret = skillDemandProfClass.getskillDem();
        system.debug('retorno');
        system.debug(ret);
        system.assertEquals(exp, ret, msg);

    }
}