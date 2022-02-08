/**
* @description       
* @author             JCOSTA
* @group             TriggerHandler 
* @date               12122020
* @last modified by   JCOSTA
* Modifications Log 
* Ver   Date       Author   Modification
* 1.0   12122020   JCOSTA   Initial Version
**/
public with sharing class PoliticaComissioamentoTriggerHandler extends TriggerHandler {
    
    /* ===========================  Properties =========================== */
    /**
* @description A map of IDs to the new versions of the sObject records.
* This map is only available in before update, after insert, after update, and after undelete triggers.
*/
    private Map<Id, Politica_de_comissionamento__c> newMap;
    /**
* @description A map of IDs to the old versions of the sObject records.
* This map is only available in update and delete triggers.
*/
    private Map<Id, Politica_de_comissionamento__c> oldMap;
    /**
* @description Returns a list of the new versions of the sObject records.
* This sObject list is only available in insert, update, and undelete triggers, and the records can only be modified in before triggers.
*/
    private List<Politica_de_comissionamento__c> newList;
    /**
* @description Returns a list of the old versions of the sObject records.
* This sObject list is only available in update and delete triggers.
*/
    private List<Politica_de_comissionamento__c> oldList;
    /* ===========================  Public methods =========================== */
    /**
* @description Trigger handler constuctor. Initialize the variables
* @example
* new AccountTriggerHandler().run();
*/
    public PoliticaComissioamentoTriggerHandler() {
        this.newMap = (Map<Id, Politica_de_comissionamento__c>) Trigger.newMap;
        this.oldMap = (Map<Id, Politica_de_comissionamento__c>) Trigger.oldMap;
        this.newList = (List<Politica_de_comissionamento__c>) Trigger.new;
        this.oldList = (List<Politica_de_comissionamento__c>) Trigger.old;
    }
    
    /**
* @description 
* @author JCOSTA | 12122020 
**/
    public override void beforeUpdate() {
        for(Politica_de_comissionamento__c record : (List<Politica_de_comissionamento__c>) newList) {
            
            if(record.Ativo__c)
            {
                record.CompanyActive__c=record.Empresa__c+'TRUE';
            }
            else{
                record.CompanyActive__c='';
            }
            // do something
        }
    }
    public override void beforeInsert() {
        for(Politica_de_comissionamento__c record : (List<Politica_de_comissionamento__c>) newList) {
            
            if(record.Ativo__c)
            {
                record.CompanyActive__c=record.Empresa__c+'TRUE';
            }
            else{
                record.CompanyActive__c='';
            }
            // do something
        }
    }
}