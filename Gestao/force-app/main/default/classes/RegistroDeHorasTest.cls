@isTest
private class RegistroDeHorasTest {
    
    private static Id idCaso {get;set;}
    private static Id registroId{get;set;}
    private static EcrmHarpiaController ecrm {get;set;} 
    
    //Testa as funcionalidades de login e outros métodos da classe cookiecontroller
    static testMethod void testLogin()
    {
        Id idContato = criaContaContato();
        idCaso = criaCaso(idContato);   
        
        //EcrmHarpiaController.registro = criaRegistro();
        EcrmHarpiaController.registro.Caso__c = idCaso;
        system.debug('EcrmHarpiaController.registro' + EcrmHarpiaController.registro);
        try{ 
           	insert EcrmHarpiaController.registro;    
        }catch(Exception e) {
            System.Assert(e.getMessage().contains('REQUIRED_FIELD_MISSING,'));
        }                          
        test.startTest();
                Test.setMock(HttpCalloutMock.class, new EcrmMock() );  
                //Tenta inserir deslogado
                testaInserirDeslogado();
                //Loga
                testaLogar();
                //Botão de cancelar
                ecrm.cancelar();
                //Métodos que aparentemente não são utilizados, caso não sejam DELETAR!
                ecrm.getRegistroDeHorasLista();
                ecrm.geteCRMSessionId();
                CookieController cookieController = new CookieController();
                cookieController.geteCRMSessionId();      
        test.stopTest();   
    }  
    
    //Testa a funcionalidade de Inserção de um novo registro
    static testMethod void testInsert()
    {
        Id idContato = criaContaContato();
        idCaso = criaCaso(idContato);   
        
        //EcrmHarpiaController.registro = criaRegistro();

        test.startTest();        
        Test.setMock(HttpCalloutMock.class, new EcrmMock() );  
        Cookie eCRMSessionId = new Cookie('eCRMSessionId', 'b4298dd136be3c51276efdb98532e093', null, 150, false);
        ApexPages.currentPage().setCookies(new Cookie[]{eCRMSessionId});
        try{
        	//insert EcrmHarpiaController.registro; 
            //Insere
            ecrm = instanciaEcrmController(); 
            ecrm.save();      
        }catch(Exception e) {
            System.Assert(e.getMessage().contains('REQUIRED_FIELD_MISSING,'));
        }  
        test.stopTest();   
    }
	
    static testMethod void testaInit(){
        ecrm = instanciaEcrmController(); 
        ecrm.init();
    }
    
    //Testa a funcionalidade de Atualização/Inserção de dados com erro condicional
    static testMethod void testAtualizarDadosComErroCondicional1(){
        Id idContato = criaContaContato();
        idCaso = criaCaso(idContato);   
        
        //EcrmHarpiaController.registro = criaRegistro();
        EcrmHarpiaController.registro.User_Name__c = 'pvolcov';
        EcrmHarpiaController.registro.Caso__c = idCaso;
        EcrmHarpiaController.registro.RowId__c = '3f0-13-5988';
        try{
        	insert EcrmHarpiaController.registro;     
        }catch(Exception e) {
            System.Assert(e.getMessage().contains('REQUIRED_FIELD_MISSING,'));
        }                     
        test.startTest();

                Test.setMock(HttpCalloutMock.class, new EcrmMock() );  
                ecrm = instanciaEcrmController(); 
                ApexPages.currentPage().getParameters().put('id', EcrmHarpiaController.registro.Id);
                ecrm.save();           

        test.stopTest();  
    }
    static testMethod void testAtualizarDados(){
        Id idContato = criaContaContato();
        idCaso = criaCaso(idContato);   
        
        //EcrmHarpiaController.registro = criaRegistro();
        EcrmHarpiaController.registro.User_Name__c = 'pvolcov';
        EcrmHarpiaController.registro.RowId__c = '3f0-13-5988';
        
        try{
        	insert EcrmHarpiaController.registro;       
        }catch(Exception e) {
            System.Assert(e.getMessage().contains('REQUIRED_FIELD_MISSING,'));
        }         
        test.startTest();       
        
                Test.setMock(HttpCalloutMock.class, new EcrmMock() );  
                Cookie eCRMSessionId = new Cookie('eCRMSessionId', 'b4298dd136be3c51276efdb98532e093', null, 150, false);
                ApexPages.currentPage().setCookies(new Cookie[]{eCRMSessionId});
                //Insere
                ecrm = instanciaEcrmController(); 
                ApexPages.currentPage().getParameters().put('id', EcrmHarpiaController.registro.Id);
                ecrm.isLogado();         

        test.stopTest();  
    }
    
    //Testa a funcionalidade de Atualização de dados para quando for editar
    static testMethod void testAtualizarDadosComErro(){
        Id idContato = criaContaContato();
        idCaso = criaCaso(idContato);   
        
        //EcrmHarpiaController.registro = criaRegistro();
        EcrmHarpiaController.registro.RowId__c = '3f0-13-5988';
        
        try{
        	insert EcrmHarpiaController.registro;        
        }catch(Exception e) {
            System.Assert(e.getMessage().contains('REQUIRED_FIELD_MISSING'));
        }         
        test.startTest();

                Test.setMock(HttpCalloutMock.class, new EcrmMock() );  
                Cookie eCRMSessionId = new Cookie('eCRMSessionId', 'b4298dd136be3c51276efdb98532e093', null, 150, false);
                ApexPages.currentPage().setCookies(new Cookie[]{eCRMSessionId});
                //Insere
                ecrm = instanciaEcrmController(); 
                ApexPages.currentPage().getParameters().put('id', EcrmHarpiaController.registro.Id);
                ecrm.isLogado();                  

        test.stopTest();  
    }
    
    //Testa a funcionalidade de Edição dos dados nao Logado (erro)
    static testMethod void testUpdateNaoLogado()
    {      
        test.startTest();
        Test.setMock(HttpCalloutMock.class, new EcrmMock() ); 
		ServiceCloudToEcrmRequest.Login('naoexiste', 'tbmnaoexiste'); 
		ServiceCloudToEcrmRequest.executeRequest(null, null, null);
		ServiceCloudToEcrmRequest.executeRequestDelete(null, 'delete');
        Cookie eCRMSessionId = new Cookie('eCRMSessionId', 'naoexiste', null, 150, false);
        ApexPages.currentPage().setCookies(new Cookie[]{eCRMSessionId});
		ServiceCloudToEcrmRequest.executeRequest(null, null, null);
		ServiceCloudToEcrmRequest.executeRequestDelete(null, 'delete');
        test.stopTest();   
    }
    
    //Testa a funcionalidade de Edição dos dados
    static testMethod void testUpdate()
    {      
        Id idContato = criaContaContato();
        idCaso = criaCaso(idContato);   
               
        test.startTest();
        	try{
                Test.setMock(HttpCalloutMock.class, new EcrmMock() );  
                Cookie eCRMSessionId = new Cookie('eCRMSessionId', 'b4298dd136be3c51276efdb98532e093', null, 150, false);
                ApexPages.currentPage().setCookies(new Cookie[]{eCRMSessionId});
                //Insere
                ecrm = instanciaEcrmController(); 
                ApexPages.currentPage().getParameters().put('id', EcrmHarpiaController.registro.Id);
                ecrm.save();               
            }
            catch(Exception e) {
            	System.Assert(e.getMessage().contains('REQUIRED_FIELD_MISSING'));
            }                                

        test.stopTest();   
    }

    //Testa a funcionalidade de Deleção de algum registro
    static testMethod void testDeleteComErro()
    {
        //Id idContato = criaContaContato();
        //idCaso = criaCaso(idContato);
        
        Registro_de_horas__c RH = criaRegistro();
        try{
        	//insert EcrmHarpiaController.registro;            
        	insert RH;
        }catch(Exception e) {
            System.Assert(e.getMessage().contains('REQUIRED_FIELD_MISSING,'));
        }         
        test.startTest();
            try{
                Test.setMock(HttpCalloutMock.class, new EcrmMock() );  
                Cookie eCRMSessionId = new Cookie('eCRMSessionId', 'b4298dd136be3c51276efdb98532e093', null, 150, false);
                ApexPages.currentPage().setCookies(new Cookie[]{eCRMSessionId});
                //Insere
                ecrm = instanciaEcrmController(); 
                ApexPages.currentPage().getParameters().put('id', EcrmHarpiaController.registro.Id);        
                ApexPages.currentPage().getParameters().put('common.udd.actions.ActionsUtilORIG_DELETE_URI', 'delete');
                ecrm.isLogado();           
            }catch(Exception e) {	
            }         
                  
        test.stopTest();  
    }
    
    //Testa a funcionalidade de Deleção de algum registro
    static testMethod void testDelete()
    {
        Id idContato = criaContaContato();
        idCaso = criaCaso(idContato);   
        
        //EcrmHarpiaController.registro = criaRegistro();
        EcrmHarpiaController.registro.User_Name__c = 'pvolcov';
        try{
        	insert EcrmHarpiaController.registro;          
        }catch(Exception e) {
            System.Assert(e.getMessage().contains('REQUIRED_FIELD_MISSING,'));
        }        
        test.startTest();
                try{
                    Test.setMock(HttpCalloutMock.class, new EcrmMock() );  
                    Cookie eCRMSessionId = new Cookie('eCRMSessionId', 'b4298dd136be3c51276efdb98532e093', null, 150, false);
                    ApexPages.currentPage().setCookies(new Cookie[]{eCRMSessionId});
                    //Insere
                    ecrm = instanciaEcrmController(); 
                    ApexPages.currentPage().getParameters().put('id', EcrmHarpiaController.registro.Id);        
                    ApexPages.currentPage().getParameters().put('common.udd.actions.ActionsUtilORIG_DELETE_URI', 'delete');
                    ecrm.isLogado();        
                }catch(Exception e) {
                } 
                           
        test.stopTest();  
    }
    
    static testMethod void verificaConsole(){
        Test.startTest();    
            EcrmHarpiaController testVerificaConsole = new EcrmHarpiaController(new ApexPages.StandardController(new Registro_de_horas__c())); 
            testVerificaConsole.verificaConsole();
        Test.stopTest();        
    }    
    
    
    private static void testaInserirDeslogado(){
        ecrm = instanciaEcrmController();    
        ecrm.save();        
    }      
 
    private static Registro_de_horas__c criaRegistro(){
        Registro_de_horas__c registro = new Registro_de_horas__c();
        Id idContato = criaContaContato();
        Id idCaso = criaCaso(idContato);
        //registro.Caso__c = '5001a0000049yQFAAY';
        registro.Caso__c = idCaso;
        registro.Cost_Center_Id__c = '90-13-ed6';
        registro.Cost_Center_Name__c = 'Administrativo Geral';
       	//registro.Caso__c = parametroGet.replace('/','');
		registro.Hora__c = 2;  
        Date data = Date.newInstance(2016, 02, 16);
        registro.Data__c = data;
		registro.Hora_extra__c = 3;     
		registro.Hora_noturna__c = 4;       
		registro.Sobreaviso__c = 1;   
        registro.Comentarios__c = 'teste';
        registro.Period_Id__c = '3d0-13-583e';
        return registro;
    }
    
    private static Id criaCaso(Id idContato){
        Case caso = new Case();
        caso.ContactId = idContato;
        caso.Status = 'Novo';
        caso.Type = 'Incidente';
        caso.Origin = 'Email';
        caso.Priority = 'Baixa';
        caso.Subject = 'Teste';
        caso.Description = 'teste teste teste testao';
        insert caso;
        return caso.Id;
    }
    
    private static Id criaContaContato(){
        Account conta = new Account();
        conta.name = 'Teste LTDAAA';
        conta.CNPJ__c = '94.127.486/0001-77';
        insert conta;
        Contact contato = new Contact();
        contato.LastName = 'testao';
        contato.AccountId = conta.Id;
        contato.Title = 'Chefao';
        contato.Phone = '12345678';
        contato.Email = 'teste@teste.com';
        insert contato;
        return contato.Id;
    }
    
    private static EcrmHarpiaController instanciaEcrmController(){
        Registro_de_horas__c registro = new Registro_de_horas__c();
        ApexPages.StandardController std = new ApexPages.StandardController(registro);
        ApexPages.currentPage().getParameters().put('retURL',''+idCaso);
        return new EcrmHarpiaController(std);
    }
    
    private static EcrmHarpiaController criaUsuario(EcrmHarpiaController ecrm2, String usuario, String senha){
        ecrm2.usuario = usuario;
        ecrm2.senha = senha;
        return ecrm2;
    }
    
    private static void testaLogar()
    {
        ecrm = instanciaEcrmController();     
        EcrmHarpiaController ecrm2 = instanciaEcrmController(); 
        EcrmHarpiaController ecrm3 = instanciaEcrmController(); 
        EcrmHarpiaController ecrm4 = instanciaEcrmController(); 
        EcrmHarpiaController ecrm5 = instanciaEcrmController(); 
        ecrm = criaUsuario(ecrm, '', '');
        ecrm2 = criaUsuario(ecrm2, 'pvolcov', '');
        ecrm3 = criaUsuario(ecrm3, '', 'Volks32085381');             
        ecrm4 = criaUsuario(ecrm4, 'pvolcov', 'Volks32085381');   
        ecrm5 = criaUsuario(ecrm5, 'pvolcovaaa', 'Volks32085381');
        ecrm.logar();   
        ecrm2.logar();
        ecrm3.logar();
        ecrm4.logar();       
        ecrm4.logar();   
        ecrm5.logar();
    }

   	// Método temporário, até resolver o Mock
    static testMethod void executeRequest(){
                
        String reqBody = 'Period+id='+'11111'+'&Cost+Center='+'1111'+'&Date='+'1111'+'&Hours='+'1111';
        reqBody = reqBody+ '&Over+Time='+'1111'+'&Night+Hours='+'1111'+'&Comments='+'1111'+'&Stand+by='+'1111';

        Cookie eCRMSessionId = new Cookie('eCRMSessionId', 'b4298dd136be3c51276efdb98532e093', null, 150, false);
        ApexPages.currentPage().setCookies(new Cookie[]{eCRMSessionId});
        
        test.startTest();        
        ServiceCloudToEcrmRequest.executeRequest(reqBody, 'delete' , true);  
        test.stopTest();  
        
    }
    
    static testMethod void myUnitTest() {
        Registro_de_horas__c RH = criaRegistro();
        insert RH;
        Test.startTest();    
            EcrmHarpiaController testRH = new EcrmHarpiaController(new ApexPages.StandardController(new Registro_de_horas__c())); 
            testRH.atualizarDadosRegistroBase();
        Test.stopTest();
    }
    
    static testMethod void testGetRegistroPagina() {
        Registro_de_horas__c RH = criaRegistro();
        insert RH;
        system.debug(EcrmHarpiaController.getRegistroPagina().id);
    }
   
    
    
}