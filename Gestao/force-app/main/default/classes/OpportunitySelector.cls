public inherited sharing class OpportunitySelector {
    
	public static List<Opportunity> queryOppByCC(List<Id> listIdCC)
    {
        return [SELECT Id,
               CentroDeCusto__c,
               Invoices_Sum__c,
                amount
               FROM Opportunity
               WHERE CentroDeCusto__c IN :listIdCC];
    }
}