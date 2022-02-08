/**
 * @description        
 * @author             JCOSTA
 * @group              Trigger
 * @date               12122020
 * @last modified by   JCOSTA
 * Modifications Log 
 * Ver   Date       Author   Modification
 * 1.0   12122020   JCOSTA   Initial Version
**/
trigger PoliticaComissionamentoTrigger on Politica_de_comissionamento__c (before insert, before update) {
    new PoliticaComissioamentoTriggerHandler().run();
}