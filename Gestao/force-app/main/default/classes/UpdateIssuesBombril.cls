public class UpdateIssuesBombril implements Database.Batchable<sObject>,    Database.AllowsCallouts, Database.Stateful{
    public final String Query;
    public Map<String, String> sucessList = new Map<String, String>();
    public Map<String, String> failList = new Map<String, String>();
    // public final String Entity;
    // public final String Field;
    // public final String Value;
    
    public UpdateIssuesBombril(){
        // SELECT Id, Resolucao__c, Description, Status FROM Case WHERE Origin = 'Issues Bombril' AND Status NOT IN ('Fechado','Parado','Cancelado')
        Query = 'SELECT Id, Resolucao__c, Description, Status, CaseNumber, Ultimo_comentario_publico__c FROM Case WHERE Origin = \'Issues Bombril\' AND Status NOT IN (\'Fechado\',\'Cancelado\')';
        System.debug(Query);
    }
    
    
    public Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator(query);
    }
    
    public void execute(Database.BatchableContext BC, 
        List<Case> scope){
        for(Case caso : scope){
            Integer sCode = ConsumeCaseRestFromBombril.calloutUpdateCases(caso.Id, caso.Resolucao__c, caso.Description, caso.Status, caso.Ultimo_comentario_publico__c);
            if(sCode == 200){
                sucessList.put(caso.Id, caso.CaseNumber);
            }else{
                failList.put(caso.Id, caso.CaseNumber);
            }
        }
    }
    
    public void finish(Database.BatchableContext BC){
        String sEmail = 'suporte_bombril@harpiacloud.com.br';
        
        System.debug('Integração OK: ' + sucessList.size());
        System.debug('Falha na integração: ' + failList.size());

        String sBody = '';
        // mandar  IDs de falha por email
        if(failList.size() > 0){
            sBody = 'Falha na integração para os Casos: \n'; 
            for(String sId : failList.keySet()){
                sBody += sId + ' - ' + failList.get(sId) + '\n';
            }
        }else{
            sBody = 'Integração de casos OK. ' + sucessList.size() + ' casos foram reenviados.';
        }

        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
    
        mail.setToAddresses(new String[] {sEmail});
        // mail.setReplyTo('batch@acme.com');
        mail.setSenderDisplayName('Batch Processing');
        mail.setSubject('Update Issues Bombril -  Batch Process Completed');
        mail.setPlainTextBody(sBody);
        
        try{
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        }catch(Exception ex){
            System.debug('Erro ao enviar e-mail. ' + ex);
        }
           
    }
}