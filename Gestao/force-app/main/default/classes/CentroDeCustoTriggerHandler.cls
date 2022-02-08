public class CentroDeCustoTriggerHandler {
    
    public static void beforeInsert(){
    }
    
    public static void beforeUpdate(){
    }
    
    public static void beforeDelete(){
    }
    
    public static void afterInsert(){
    }
    
    public static void afterUpdate(){ 
        CentroDeCustoBO.updateComissaoPorMargem((List<CentroDeCusto__c>)Trigger.New, (Map<Id, CentroDeCusto__c>)Trigger.OldMap);
    }
    
    public static void afterDelete(){
    }
}