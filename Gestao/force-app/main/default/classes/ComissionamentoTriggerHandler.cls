public class ComissionamentoTriggerHandler extends TriggerHandler {
    
    /* ===========================  Properties =========================== */
    /**
* @description A map of IDs to the new versions of the sObject records.
* This map is only available in before update, after insert, after update, and after undelete triggers.
*/
    private Map<Id, Comissionamento__c> newMap;
    /**
* @description A map of IDs to the old versions of the sObject records.
* This map is only available in update and delete triggers.
*/
    private Map<Id, Comissionamento__c> oldMap;
    /**
* @description Returns a list of the new versions of the sObject records.
* This sObject list is only available in insert, update, and undelete triggers, and the records can only be modified in before triggers.
*/
    private List<Comissionamento__c> newList;
    /**
* @description Returns a list of the old versions of the sObject records.
* This sObject list is only available in update and delete triggers.
*/
    private List<Comissionamento__c> oldList;
    /* ===========================  Public methods =========================== */
    /**
* @description Trigger handler constuctor. Initialize the variables
* @example
* new AccountTriggerHandler().run();
*/
    public ComissionamentoTriggerHandler() {
        this.newMap = (Map<Id, Comissionamento__c>) Trigger.newMap;
        this.oldMap = (Map<Id, Comissionamento__c>) Trigger.oldMap;
        this.newList = (List<Comissionamento__c>) Trigger.new;
        this.oldList = (List<Comissionamento__c>) Trigger.old;
    }
    
    public override void beforeUpdate() {
        List<Comissionamento__c> comissionamentoToUpd = new List<Comissionamento__c>();
        for(Comissionamento__c Record:newList)
        {
            if(Record.Atualizar__c && oldMap.get(Record.Id).Atualizar__c!=Record.Atualizar__c )
            {
                comissionamentoToUpd.add(Record);
            }
        }
        if(comissionamentoToUpd.size()>0)
        {
            ComissionamentoHelper.atualizarComissoes(comissionamentoToUpd);
        }
    }
    public override void afterInsert(){
        
        ComissionamentoHelper.criarDetalhesComissionamento(newList);
        
    }
}