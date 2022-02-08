public class AlocacaoTriggerHandler {
    public static void beforeInsert(){
    }
    
    public static void beforeUpdate(){
    }
    
    public static void beforeDelete(){
    }
    
    public static void afterInsert(){
        AlocacaoBO.updateComissaoAlocacao((List<Alocacao__c>)Trigger.New, null);
    }
    
    public static void afterUpdate(){ 
        AlocacaoBO.updateComissaoAlocacao((List<Alocacao__c>)Trigger.New, (Map<Id, Alocacao__c>)Trigger.OldMap);
    }
    
    public static void afterDelete(){
    }
}