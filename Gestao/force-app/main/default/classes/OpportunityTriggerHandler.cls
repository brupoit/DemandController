public class OpportunityTriggerHandler {
    
    public static void beforeInsert(){
        OpportunityBO.LimpaAcelerador((List<Opportunity>)Trigger.New);
        OpportunityBO.setPolitica((List<Opportunity>)Trigger.New, null);
        OpportunityBO.updateComissaoMax((List<Opportunity>)Trigger.New, null);
    }
    
    public static void beforeUpdate(){
        OpportunityBO.LimpaAcelerador((List<Opportunity>)Trigger.New);
        OpportunityBO.CCChanged((List<Opportunity>)Trigger.New, (Map<Id, Opportunity>) Trigger.oldMap);
         OpportunityBO.updateCCs((List<Opportunity>)Trigger.New);
         OpportunityBO.setPolitica((List<Opportunity>)Trigger.New, (Map<Id, Opportunity>) Trigger.oldMap);
        OpportunityBO.updateComissaoMax((List<Opportunity>)Trigger.New,(Map<Id, Opportunity>) Trigger.oldMap);
        OpportunityBO.trocaStatus((List<Opportunity>)Trigger.New, (Map<Id, Opportunity>) Trigger.oldMap);
        
         
        
    }
    
    public static void beforeDelete(){
    }
    
    public static void afterInsert(){
    }
    
    public static void afterUpdate(){ 
         
		 OpportunityBO.verificaAprovacao((List<Opportunity>)Trigger.New, (Map<Id, Opportunity>) Trigger.oldMap);
        OpportunityBO.updateMembros((List<Opportunity>)Trigger.New, (Map<Id, Opportunity>) Trigger.oldMap);
         OpportunityBO.fechadoPerdido((List<Opportunity>)Trigger.New, (Map<Id, Opportunity>) Trigger.oldMap);
        OpportunityBO.recalculateComissoes((List<Opportunity>)Trigger.New, (Map<Id, Opportunity>) Trigger.oldMap);
    }
    
    public static void afterDelete(){
    }
}