trigger InvoiceTrigger on Invoice__c  (before insert, before update,after insert, after update) {
    new InvoiceTriggerHandler().run();
}