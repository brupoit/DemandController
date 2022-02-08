@isTest
public class OpportunityTest {
    
    public testMethod static void testComissao(){
        Account acc = new Account(Name ='Harpia');
        insert acc;
        List<CentroDeCusto__c> listCCs = TestDataFactory.createCCs(1);
        insert listCCs;
        Opportunity opp = TestDataFactory.createOpps(new List<Account>{acc})[0];
        opp.CentroDeCusto__c = listCCs[0].Id;
        insert opp;
        Contact con = TestDataFactory.createContacts(new List<Account>{acc})[0];
        con.Tipo__c = 'Gerente';
        insert con;
        Contact con2 = TestDataFactory.createContacts(new List<Account>{acc})[0];
        con2.Tipo__c = 'Comercial';
        
        insert con2;
        Time_da_oportunidade__c t = TestDataFactory.createTimeDaOportunidade(opp, con);
        
        insert t;
        Time_da_oportunidade__c t2 = TestDataFactory.createTimeDaOportunidade(opp, con2);
        insert t2;
        
        system.debug(json.serialize([select id,Oportunidade__c from Time_da_oportunidade__c]));
        List<Invoice__c> listInvs = TestDataFactory.createInvoices(opp, 2);
        insert listInvs;
        
        opp.Margem_na_venda__c = 0.5;
        opp.StageName = 'Fechado - ganho';
        update opp;
        
        CentroDeCusto__c cc = listCCs[0];
        cc.Calcular_comissao_por_margem__c = true;
        cc.MargemFinal__c = 0.6;
        
        system.debug('update cc1');
        //update cc;
        
        Invoice__c inv = listInvs[0];
        inv.Data_de_emissao__c = system.today();
        update inv;
        inv.id=null;
        inv.Criar_Comissoes__c=true;
        insert inv;
        Detalhe_do_comissionamento__c det = new Detalhe_do_comissionamento__c();
        Detalhe_do_comissionamento__c det2 = new Detalhe_do_comissionamento__c();
        Comissionamento__c com = new Comissionamento__c();
        com.colaborador__c = con.id;
        com.Invoice__c = inv.id;
        insert com;
        com.Atualizar__c=true;
        update com;
        system.debug('before update det1');
        det.Comissionamento__c = com.id;
        det.Liberado__c = false;
        det.Tipo__c = 'Alocação';
        insert det;
        
        det.Tipo__c = 'Margem CC';
        update det;
        
        cc.MargemFinal__c = 0.7;
        
        system.debug('update cc2');
        update cc;
        
        Alocacao__c aloc = new Alocacao__c();
        aloc.colaborador__c = con.Id;
        aloc.ano__c = system.today().year();
        aloc.Alocacao__c = 0.9;
        
        insert aloc;
        
        aloc.Calcular__c = true;
        update aloc;
        
        inv.Value__c=20;
        update inv;
        
        system.debug(json.serialize([select id from Invoice__c]));
        system.debug(json.serialize([select id from Comissionamento__c]));
        system.debug(json.serialize([select count() from Detalhe_do_comissionamento__c]));        
        system.debug(json.serialize([select id, tipo__c from Detalhe_do_comissionamento__c]));
    }
    public testMethod static void testComissaoFechada(){
        Account acc = new Account(Name ='Harpia');
        insert acc;
        List<CentroDeCusto__c> listCCs = TestDataFactory.createCCs(1);
        insert listCCs;
        Opportunity opp = TestDataFactory.createOpps(new List<Account>{acc})[0];
        opp.CentroDeCusto__c = listCCs[0].Id;
        insert opp;
        Contact con = TestDataFactory.createContacts(new List<Account>{acc})[0];
        con.Tipo__c = 'Comercial';
        insert con;
        Time_da_oportunidade__c t = TestDataFactory.createTimeDaOportunidade(opp, con);
        t.finder_fee__c=false;
        insert t;
        con = TestDataFactory.createContacts(new List<Account>{acc})[0];
        con.Tipo__c = 'Gerente';
        insert con;
        
        t = TestDataFactory.createTimeDaOportunidade(opp, con);
        t.finder_fee__c=true;
        insert t;
        
        List<Invoice__c> listInvs = TestDataFactory.createInvoices(opp, 2);
        
        
        opp.Margem_na_venda__c = 0.5;
        opp.StageName = 'Fechado - ganho';
        update opp;
        insert listInvs;
        opp.StageName = 'Fechado - perdido';
        update opp;
    }
    public testMethod static void testDeleteAlocacao() {
        Alocacao__c aloc = new Alocacao__c();
        aloc.ano__c = system.today().year();
        aloc.Alocacao__c = 0.9;
        insert(aloc);
        
        delete(aloc);
    }
    
    public testMethod static void testDeleteOpp() {
        Account acc = new Account(Name ='Harpia');
        insert acc;
        Opportunity opp = TestDataFactory.createOpps(new List<Account>{acc})[0];
        insert opp;
        
        delete(opp);
    }
}