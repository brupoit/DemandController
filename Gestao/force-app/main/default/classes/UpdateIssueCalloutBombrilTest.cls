@isTest
private class UpdateIssueCalloutBombrilTest {
    static testMethod void UpdateIssueCalloutBombrilTest() {
        // mock
        HttpMockFactory mock = new HttpMockFactory(200, 'OK', '{"id": "a0k55000002IXnMAAW"}', new Map<String,String>());
        Test.setMock(HttpCalloutMock.class, mock);


        BombrilREST__c restConfig = new BombrilREST__c(Name = 'devrunning');
        restConfig.AuthEndpoint__c = 'https://test.salesforce.com/services/oauth2/token';
        restConfig.CallbackUrl__c	 = 'https://bombril--running.my.salesforce.com';
        restConfig.ClientId__c = 'xxxxxxxxxxxxxxxxxxxx';
        restConfig.ClientSecret__c = 'xxxxxxxxxxxxxxxxxxxxxxx';
        restConfig.Password__c = 'xxxxxxxxxxxxxxx';
        restConfig.Token__c = 'xxxxxxxxxxxxxxxxxxxxxxxx';
        restConfig.Username__c = 'xxxxxxxxxxxxxxxxxxxxxx';
        insert restConfig;

        AmbienteBombril__c ambiente = new AmbienteBombril__c(Name = 'ambiente', Ambiente__c = 'devrunning');
        insert ambiente;

        Account conta = new Account(Name='Bombril');
        insert conta;

        Contact contato = new Contact(FirstName='Integração',LastName='Bombril', AccountId=conta.Id);
        insert contato;

        Projeto__c proj = new Projeto__c(Name='Projeto Bombril', Conta__c=conta.Id);
        insert proj;

        Case caso = new Case(Type='Incidente', Subject='[Modulo - processo] Assunto', Description='Descrição', Origin='Issues Bombril', Priority='Normal',Status='Novo',ContactId=contato.Id,Projeto__c=proj.Id);
        insert caso;

        caso.Resolucao__c = 'Solução';
        Test.startTest();
            update caso;
        Test.stopTest();

    }
}