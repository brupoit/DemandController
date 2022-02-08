@isTest
public with sharing class MapaAlocacaoControllerTest {
    @TestSetup
    static void makeData(){
        DataFactoryShared.createAlocacao();
    }

    @isTest
    public static void getMappedQueryTest() {
        String msg = 'O Id da alocacao é diferente do esperado';
        Alocacao_Profissional__c aloc = [SELECT Id FROM Alocacao_Profissional__c LIMIT 1];
        List<Alocacao_Profissional__c> lista = MapaAlocacaoController.getMappedQuery();
        system.debug(lista);
        system.assertEquals(aloc.Id, lista[0].Id, msg);
    }
}