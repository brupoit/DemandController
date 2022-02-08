public class InvoiceTriggerHandler  extends TriggerHandler{
    /* ===========================  Properties =========================== */
    /**
* @description A map of IDs to the new versions of the sObject records.
* This map is only available in before update, after insert, after update, and after undelete triggers.
*/
    private Map<Id, Invoice__c> newMap;
    /**
* @description A map of IDs to the old versions of the sObject records.
* This map is only available in update and delete triggers.
*/
    private Map<Id, Invoice__c> oldMap;
    /**
* @description Returns a list of the new versions of the sObject records.
* This sObject list is only available in insert, update, and undelete triggers, and the records can only be modified in before triggers.
*/
    private List<Invoice__c> newList;
    /**
* @description Returns a list of the old versions of the sObject records.
* This sObject list is only available in update and delete triggers.
*/
    private List<Invoice__c> oldList;
    /* ===========================  Public methods =========================== */
    /**
* @description Trigger handler constuctor. Initialize the variables
* @example
* new AccountTriggerHandler().run();
*/
    public InvoiceTriggerHandler() {
        this.newMap = (Map<Id, Invoice__c>) Trigger.newMap;
        this.oldMap = (Map<Id, Invoice__c>) Trigger.oldMap;
        this.newList = (List<Invoice__c>) Trigger.new;
        this.oldList = (List<Invoice__c>) Trigger.old;
    }
    
    public override void beforeInsert(){
        for(Invoice__c Record:newList)
        {
            if( Record.Status_da_oportunidade__c=='Fechado - ganho' && record.OppCentroDeCustos__c!=null && 
               record.OppComissaoUtilizada__c>0 && !record.OppneedApproval__c)
   
            {
                Record.Criar_Comissoes__c=true;
            }
        }
    }
    public override void afterInsert() {
        Map<id,id> invoiceToGenerateComissao = new   Map<id,id>();
        for(Invoice__c Record:newList)
        {
            if(Record.Criar_Comissoes__c && Record.Contagem_de_comissionamentos__c==0)
            {
                
                invoiceToGenerateComissao.put(Record.Id, Record.Opportunity__c);
            }
        }
        if(!invoiceToGenerateComissao.isEmpty())
        {
            ComissionamentoHelper.GeraComissoes(invoiceToGenerateComissao);
        }
        
        
        
    }
    
    public override void afterUpdate() {
        Map<id,id> invoiceToGenerateComissao = new   Map<id,id>();
        for(Invoice__c Record:newList)
        {
            if(Record.Criar_Comissoes__c &&  Record.Contagem_de_comissionamentos__c==0 && oldMap.get(Record.Id).Criar_Comissoes__c !=Record.Criar_Comissoes__c )
            {
                invoiceToGenerateComissao.put(Record.Id, Record.Opportunity__c);
            }
        }
        if(!invoiceToGenerateComissao.isEmpty())
        {
           ComissionamentoHelper.GeraComissoes(invoiceToGenerateComissao);
        }
        
        
    }
    
}