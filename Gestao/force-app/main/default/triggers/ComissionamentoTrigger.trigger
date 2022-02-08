trigger ComissionamentoTrigger on Comissionamento__c  (before insert, before update,after insert, after update)  {
    new ComissionamentoTriggerHandler().run();
}