@isTest
private class CommunityReportControllerTest {
	
	@isTest static void test_method_one() {
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

		Case caso = new Case();
		caso.AccountId = acc.Id;
		caso.ContactId = contato.Id;
		caso.Status = 'Novo';
		caso.Type = 'Incidente';
		caso.Origin = 'Email';
		caso.Priority = 'Baixa';
		caso.Subject = 'teste';
		caso.Description = 'Teste';
		insert caso;

		Case caso1 = new Case();
		caso1.AccountId = acc.Id;
		caso1.ContactId = contato.Id;
		caso1.Status = 'Novo';
		caso1.Type = 'Incidente';
		caso1.Origin = 'Email';
		caso1.Priority = 'Baixa';
		caso1.Subject = 'teste2';
		caso1.Description = 'Teste2';
		insert caso1;

		Registro_de_horas__c reg = new Registro_de_horas__c();
		reg.Caso__c = caso.Id;
		reg.Data__c = System.today().addMonths(-1);
		reg.Hora__c = 5;
		reg.Hora_extra__c = 2;
		insert reg;

		Registro_de_horas__c reg1 = new Registro_de_horas__c();
		reg1.Caso__c = caso.Id;
		reg1.Data__c = System.today();
		reg1.Hora__c = 5;
		reg1.Hora_extra__c = 2;
		reg1.Sobreaviso__c = 2;
		insert reg1;

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
        	CommunityReportController controller = new CommunityReportController();

        	// Mês anterior
        	System.assertEquals(controller.horasMesPassadoEAtual[0].data1,7);
        	// Mês atual
        	System.assertEquals(controller.horasMesPassadoEAtual[1].data1,9);

        }
        Test.stopTest();
	}
}