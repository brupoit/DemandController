@isTest
public class CasosTriggerHandlerTest {

	@testSetup static void setup() {
        Account acc = new Account();
        acc.Name = 'Conta';
        
        insert acc;
        
        Contact con = new Contact();
        con.FirstName  = 'Contato';
        con.LastName  = '1';
        con.Phone = '9743800309';
        con.AccountId = acc.Id;
        con.Title = 'Test';
        con.email = 'test@test.com';
        
        insert con;
        
        Projeto__c p = new Projeto__c();
        p.Name = 'Projeto';
        p.Conta__c = acc.Id;
        
        insert p;
        
        Case c = new Case();
        c.ContactId = con.Id;
        c.Status = 'Novo';
        c.Origin = 'Portal';
        c.Duvidas__c = '';
        c.Type = 'Solicitação';
        c.Priority = 'Normal';
        c.Subject = 'Teste';
        c.Description = 'Testeee';
        
        insert c;
    }
    
    public testMethod static void testVerificaNumeroProjetos(){
		
        Case c = [select status, duvidas__c from case where status = 'Novo'];
        
        Usuario_do_Suporte__c user = new Usuario_do_Suporte__c();
        user.Name = 'User';
        
        insert user;
           
        c.Usuario__c = user.Id;
        update c;
                
    }
    
    public testMethod static void testCriaComentario(){
		
        Case c = [select status, duvidas__c from case where status = 'Novo'];
        
        test.startTest();
        c.Status = 'Pendente Informação';
        c.Duvidas__c = 'Testeeee dúvidaaaas';        
        update c;
        test.stopTest();
        
    }    
    
    
}