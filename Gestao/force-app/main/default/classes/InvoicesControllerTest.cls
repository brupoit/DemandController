@isTest
private class InvoicesControllerTest {

    public testMethod static void testDesktopSemInvoice(){
        Account acc = new Account(Name ='Sample Account');
        insert acc;
        List<CentroDeCusto__c> listCCs = TestDataFactory.createCCs(1);
        insert listCCs;
        Opportunity opp = TestDataFactory.createOpps(new List<Account>{acc})[0];
        insert opp;
        PageReference pageRef = Page.Invoices;
        pageRef.getParameters().put('id', opp.Id);
        Test.setCurrentPage(pageRef);
        ApexPages.StandardSetController stdSetController = new ApexPages.StandardSetController(new List<Invoice__c>());
        InvoicesController ext = new InvoicesController (stdSetController);
        ext.fields();
        ext.newInvoice();
        ext.doSave();
        ext.doGoBack();
    }
    
    public testMethod static void testDesktopComInvoice(){
        Account acc = new Account(Name ='Sample Account');
        insert acc;
        List<CentroDeCusto__c> listCCs = TestDataFactory.createCCs(1);
        insert listCCs;
        Opportunity opp = TestDataFactory.createOpps(new List<Account>{acc})[0];
        insert opp;
        
        Invoice__c inv1 = new Invoice__c();
        inv1.Date__c = System.today();
        inv1.Opportunity__c = opp.Id;
        inv1.Status__c = 'Expected';
        inv1.Quantidade__c = 100;
        inv1.Valor_unitario__c = 1;         
        inv1.Value__c = 100;
        insert inv1;

        Invoice__c inv2 = new Invoice__c();
        inv2.Date__c = System.today()+1;
        inv2.Opportunity__c = opp.Id;
        inv2.Status__c = 'Expected';
          inv2.Quantidade__c = 100;
         inv2.Valor_unitario__c = 1;
        inv2.Value__c = 100;
        insert inv2;
        
        ApexPages.StandardSetController stdSetController = new ApexPages.StandardSetController(Database.getQueryLocator(
                    [SELECT Id,
                      Name,
                      Date__c,
                      Opportunity__c,
                      Status__c,
                      Value__c FROM Invoice__c 
                      where Opportunity__c = :opp.Id]));
        PageReference pageRef = Page.Invoices;
        pageRef.getParameters().put('id', opp.Id);
        Test.setCurrentPage(pageRef);
        InvoicesController ext = new InvoicesController (stdSetController);
        ext.deleteInvoice = 0;
        ext.doRemoveInvoice();
        ext.fields();
        ext.doSave();
        ext.doGoBack();
    }
    
    public testMethod static void testMobile(){
        Account acc = new Account(Name ='Sample Account');
        insert acc;
        List<CentroDeCusto__c> listCCs = TestDataFactory.createCCs(1);
        insert listCCs;
        Opportunity opp = TestDataFactory.createOpps(new List<Account>{acc})[0];
        insert opp;
        ApexPages.StandardController con = new ApexPages.StandardController(opp);
        InvoicesController ext = new InvoicesController (con);
        ext.newInvoice();
        ext.doSaveMobile();
        ext.doGoBack();
    }
}