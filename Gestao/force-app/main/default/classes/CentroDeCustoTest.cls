@isTest
public class CentroDeCustoTest {

    public testMethod static void testCC1(){
        Account acc = new Account(Name ='Sample Account');
        insert acc;
        List<CentroDeCusto__c> listCCs = TestDataFactory.createCCs(1);
        insert listCCs;
        Opportunity opp = TestDataFactory.createOpps(new List<Account>{acc})[0];
        insert opp;
        
        CentroDeCusto__c cc = listCCs[0];
        cc.MargemFinal__c = 0.5;
        cc.Calcular_comissao_por_margem__c = true;
        update cc;
        
        delete cc;
    }
}