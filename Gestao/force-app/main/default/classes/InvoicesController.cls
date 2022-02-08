public with sharing class InvoicesController {
  
    public Opportunity opp {get;set;}
    public List<Invoice__c> invoices {get; set;}
    public Invoice__c newInvoice {get; set;}
    public Integer deleteInvoice {get;set;}
    public Boolean renderNewInvoice {get; set;}
    public Boolean hasError {get;set;}
    public List<Invoice__c> invoicesToBeDeleted {get;set;}

    public InvoicesController (ApexPages.StandardController stdCon) {
        if (!Test.isRunningTest())
            stdCon.addFields(fields());

        opp = (Opportunity)stdCon.getRecord();
        renderNewInvoice = false;

        init();
        if (invoices.size() == 0)
            newInvoice();
		invoicesToBeDeleted = new List<Invoice__c>();
    }

    public InvoicesController (ApexPages.StandardSetController setCont) 
    {
        ID oppId = ApexPages.currentPage().getParameters().get('id');
        try
        {
            opp = [SELECT ID, NAME FROM OPPORTUNITY WHERE ID =:oppId];
        } catch (Exception e)
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, e.getMessage()));
        }
        init();
        if (invoices.size() == 0)
        {
            newInvoice();
        }

        invoicesToBeDeleted = new List<Invoice__c>();
    }
  
    public void init () 
    {
        invoices = [SELECT
              Id,
              Name,
              Date__c,
              Opportunity__c,
              Status__c,
              Value__c,
                    Numero_da_NF__c,
                    Data_de_emissao__c,
                    Data_de_deposito__c
              FROM Invoice__c
              WHERE Opportunity__c = :opp.Id
              ORDER BY Date__c ASC];
    }
  
    public void newInvoice()
    {
        newInvoice = new Invoice__c();
        newInvoice.Date__c = System.today();
        newInvoice.Value__c = 0;
        newInvoice.Status__c = 'Expected';
        newInvoice.Opportunity__c = opp.Id;
        	invoices.add(newInvoice);
    }

    public PageReference doSave(){
        try{
            if (invoicesToBeDeleted.size()>0)
            	delete invoicesToBeDeleted;
            upsert invoices;
            return new Pagereference('/' + opp.Id);
        }
        catch(Exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage()));
            return ApexPages.currentPage();
        }
    }

    public void doSaveMobile() {
        doSave();
    }

    public void doRemoveInvoice()
    {
    	Invoice__c inv = invoices.remove(deleteInvoice);
        if (inv.Id != null)
            invoicesToBeDeleted.add(inv);
    }

    public Pagereference doGoBack(){
        return new Pagereference('/' + opp.Id);
    }
    
    @TestVisible
    private List<String> fields() {
        List<String> fields = new List<String>();
        fields.add('Name');
        return fields;
    }
}