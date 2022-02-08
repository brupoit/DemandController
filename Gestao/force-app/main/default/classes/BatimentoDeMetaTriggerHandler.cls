public class BatimentoDeMetaTriggerHandler  extends TriggerHandler{
        /* ===========================  Properties =========================== */
    /**
* @description A map of IDs to the new versions of the sObject records.
* This map is only available in before update, after insert, after update, and after undelete triggers.
*/
    private Map<Id, Batimento_de_meta__c> newMap;
    /**
* @description A map of IDs to the old versions of the sObject records.
* This map is only available in update and delete triggers.
*/
    private Map<Id, Batimento_de_meta__c> oldMap;
    /**
* @description Returns a list of the new versions of the sObject records.
* This sObject list is only available in insert, update, and undelete triggers, and the records can only be modified in before triggers.
*/
    private List<Batimento_de_meta__c> newList;
    /**
* @description Returns a list of the old versions of the sObject records.
* This sObject list is only available in update and delete triggers.
*/
    private List<Batimento_de_meta__c> oldList;
    /* ===========================  Public methods =========================== */
    /**
* @description Trigger handler constuctor. Initialize the variables
* @example
* new AccountTriggerHandler().run();
*/
    public BatimentoDeMetaTriggerHandler() {
        this.newMap = (Map<Id, Batimento_de_meta__c>) Trigger.newMap;
        this.oldMap = (Map<Id, Batimento_de_meta__c>) Trigger.oldMap;
        this.newList = (List<Batimento_de_meta__c>) Trigger.new;
        this.oldList = (List<Batimento_de_meta__c>) Trigger.old;
    }
    
    public override void afterInsert(){
       ComissionamentoHelper.UpdateDetalhes(newList);
    }
     public override void afterUpdate(){
       ComissionamentoHelper.UpdateDetalhes(newList);
    }
    


}