@isTest
public with sharing class MapaAlocacaoCustomTest {
    @TestSetup
    static void makeData(){
        DataFactoryShared.createAlocacao();
    }
    
    @isTest
    public static void getInfoGeralTest() {
        String msg = 'O retorno do método não é o esperado';
        Demanda__c demanda = [SELECT Id FROM Demanda__c LIMIT 1];
        String exp = '["Pro Teste","Pro Teste","8.00","Perfil Teste","8.00","Perfil Teste","'+demanda.Id+'","0.00"]';
        String ret = MapaAlocacaoCustom.getInfoGeral();
        system.debug(ret);
        system.assertEquals(exp, ret, msg);
    }
}