@isTest
private class CasosAdicionaDireitoTriggerTest {
	
    static testmethod void test_method_two(){
        List<Profile> profiles = [SELECT Id, Name FROM Profile];
        Id admProfileId;
        Id supProfileId;
        for(Profile currentProfile: profiles){
            system.debug('perfil '+currentProfile);
            if(currentProfile.Name == 'Administrador do sistema')
            {
                admProfileId = currentProfile.Id;
            }else if(currentProfile.Name == 'Suporte')
            {
                supProfileId = currentProfile.Id;
            }
        }
        User u = new User(Alias = 'standt2', Email='standarduse2r@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testin2g', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = admProfileId, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='standarduse2r@testorg.com');
        
        Account acc = new Account();
		acc.Name = 'Teste';
		insert acc;

		Contact contato = new Contact();
		contato.LastName = 'teste2';
        contato.AccountId = acc.Id;
        contato.Title = 'teste';
        contato.Phone = '1112345678';
        contato.Email = 'a@a.com';
        insert contato;
        
        Case caso = new Case();
        caso.ContactId = contato.Id;
        caso.AccountId = acc.Id;
        caso.Status = 'Novo';
        caso.Type = 'Incidente';
        caso.Origin = 'Email';
        caso.Priority = 'Baixa';
        caso.Subject = 'teste';
        caso.Description = 'Teste';
        caso.Prioridade_Interno__c = 2;
        
        Case caso2 = new Case();
        caso2.ContactId = contato.Id;
        caso2.AccountId = acc.Id;
        caso2.Status = 'Novo';
        caso2.Type = 'Incidente';
        caso2.Origin = 'Email';
        caso2.Priority = 'Baixa';
        caso2.Subject = 'teste';
        caso2.Description = 'Teste';
        
        Case caso3 = new Case();
        caso3.ContactId = contato.Id;
        caso3.AccountId = acc.Id;
        caso3.Status = 'Novo';
        caso3.Type = 'Incidente';
        caso3.Origin = 'Email';
        caso3.Priority = 'Baixa';
        caso3.Subject = 'teste';
        caso3.Description = 'Teste';
        
        insert caso;
        insert caso2;
        insert caso3;
        
        caso2.Prioridade_Interno__c = 2;
        caso3.Prioridade_Interno__c = 4;
        try{
        	update caso2;
        }catch(Exception e) {
        	System.Assert(e.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION'));
        }        
        update caso3;
        system.runAs(u){            
            caso.Prioridade_Interno__c = 1;
            caso2.Prioridade_Interno__c = 4;
            caso3.Prioridade_Interno__c = 5;
            update caso;
            update caso2;
            update caso3;
        }
    }
    
	@isTest(seeAllData = true)
	static void test_method_one() {
		SlaProcess processoCasos = [SELECT ID FROM SLAPROCESS WHERE NAME = 'Casos' LIMIT 1];
		Account acc = new Account();
		acc.Name = 'Teste';
		insert acc;

		Contact contato = new Contact();
		contato.LastName = 'teste';
		contato.AccountId = acc.Id;
		contato.Title = 'teste';
		contato.Phone = '1112345678';
		contato.Email = 'a@a.com';
		insert contato;

		Entitlement ent = new Entitlement();
		ent.AccountId = acc.Id;
		ent.Name = 'teste';
		ent.SlaProcessId = processoCasos.Id;
		ent.StartDate = System.today().addDays(-1);
		ent.EndDate = System.today().addDays(1);
		insert ent;

		EntitlementContact entContact = new EntitlementContact();
		entContact.ContactId = contato.Id;
		entContact.EntitlementId = ent.Id;
		insert entContact;

		Profile p = [SELECT Id FROM Profile WHERE Name='Customer Community - Harpia']; 
        
        User u = new User(Alias = 'test', Email='tesfafsdaft@testafsdfaorg.com', 
        EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
        LocaleSidKey='en_US', ProfileId = p.Id, 
        TimeZoneSidKey='America/Los_Angeles', UserName='standarduserrasra@testofsadfafarg.com',
        PostalCode = '01523-030', Country ='Brasil', City ='São Paulo', State = 'São Paulo', Street = 'Rua do Rócio, 423');
    	u.Latitude = 0;
    	u.Longitude = 0;
    	u.ContactId = contato.Id;

        insert u;
        Test.startTest();
        System.runAs(u)
        {
        	Case caso = new Case();
			caso.ContactId = contato.Id;
			caso.Status = 'Novo';
			caso.Type = 'Incidente';
			caso.Origin = 'Email';
			caso.Priority = 'Baixa';
			caso.Subject = 'teste';
			caso.Description = 'Teste';
			insert caso;

			Case casoAtualizado = [SELECT ENTITLEMENTID FROM CASE WHERE ID = :caso.Id];

        	System.assertEquals(casoAtualizado.EntitlementId,ent.Id);
        }
        Test.stopTest();
	}
	
}