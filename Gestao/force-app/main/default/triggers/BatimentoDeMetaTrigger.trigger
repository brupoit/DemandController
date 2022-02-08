trigger BatimentoDeMetaTrigger on Batimento_de_meta__c (before insert, before update,after insert, after update) {
    new BatimentoDeMetaTriggerHandler().run();
    

}