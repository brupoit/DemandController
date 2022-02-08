@isTest
public class OpportunitySelectorTest {

    public testMethod static void testQueryOppByCC(){
		Account acc = new Account(Name ='Sample Account');
        insert acc;
        List<CentroDeCusto__c> listCCs = TestDataFactory.createCCs(1);
        insert listCCs;
        Opportunity opp = TestDataFactory.createOpps(new List<Account>{acc})[0];
        insert opp;

        OpportunitySelector.queryOppByCC(new List<Id>{listCCs[0].Id});        
    }
}