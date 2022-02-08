public class CasosTriggerHandler {
    
    public static void verificaNumeroProjetos(List<Case> casos, Map<Id, Case> oldCase, Map<Id, case> newCase){
      
		Map<Id, Case> casosId = new Map<Id, Case>(casos);
        Set<Id> casoId = casosId.keySet();
       
        Map<Id, Id> contasId = new Map<Id, Id>();
        for (Case c : [select AccountId from case where id =: casoId]){
            contasId.put(c.AccountId , c.Id);
        }
        
       	Set<Id> accId = contasId.keySet();
        
        Map <Id,Id> accProj = new Map<Id, Id>();
        for(Projeto__c p : [SELECT Id, Conta__c FROM Projeto__c WHERE Conta__c IN :accId]){
            accProj.put(p.Conta__c , p.Id);
        }

        for (Account acc : [Select Numero_de_Projetos__c from Account where Id =: accId]){
		    for(Case c : casos){
				if (acc.Numero_de_Projetos__c == 1) {
                    if(c.AccountId == acc.Id && oldCase.get(c.Id).Usuario__c != newCase.get(c.Id).Usuario__c){
                        // c.Status = 'Atribuído';
                        c.Projeto__c = accProj.get(acc.Id);
                    }
                }
            }
        }
    }

    public static void apagaCampoDuvida(List<Case> casos, Map<Id, Case> oldCase, Map<Id, case> newCase){
        for (Case c : casos){
            if(oldCase.get(c.Id).Duvidas__c != '' && newCase.get(c.Id).Status != 'Pendente Informação'){
            	c.Duvidas__c = '';
            }
        }
    }
    
	    
    public static void criaComentarioNoCaso(List<Case> casos, Map<Id, Case> oldCase, Map<Id, case> newCase){
        for (Case c : casos){
            if(oldCase.get(c.Id).Duvidas__c  != newCase.get(c.Id).Duvidas__c && newCase.get(c.Id).Status == 'Pendente Informação'){
                CaseComment cc = new CaseComment(ParentId = c.Id,CommentBody = newCase.get(c.Id).Duvidas__c, IsPublished = true);
                insert cc;
                enviaEmailCliente(c);
            }
        }
    }
    
    
    public static void enviaEmailCliente(Case c) {
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        message.setTargetObjectId(c.ContactId);
        message.setSenderDisplayName('Harpia Suporte');
        message.setReplyTo('no-reply@harpiacloud.com');
        message.setUseSignature(false);
        message.setBccSender(false);
        message.setSaveAsActivity(false);
        EmailTemplate emailTemplate = [Select Id,Subject,Description,HtmlValue,DeveloperName,Body 
                                       from EmailTemplate where DeveloperName = 'Caso_novo_comentario'];
        message.setTemplateID(emailTemplate.Id);
        message.setWhatId(c.Id); // Aqui é passado o objeto Caso para o template associar os campos na VF
        message.toAddresses = new String[] { c.ContactEmail };
        Messaging.SingleEmailMessage[] messages = new List<Messaging.SingleEmailMessage> {message};
        Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
        if (results[0].success) {
            System.debug('The email was sent successfully.');
        } else {
            System.debug('The email failed to send: ' +  results[0].errors[0].message);
        }
    }    
}