trigger CentroDeCustoTrigger on CentroDeCusto__c (before update, before insert, after insert, after update, before delete, after delete) {
    if (Trigger.isBefore)
        if (Trigger.isUpdate)
        CentroDeCustoTriggerHandler.beforeUpdate();
    else if (Trigger.isInsert)
        CentroDeCustoTriggerHandler.beforeInsert();
    else
        CentroDeCustoTriggerHandler.beforeDelete();
    else
        if (Trigger.isUpdate)
        CentroDeCustoTriggerHandler.afterUpdate();
    else if (Trigger.isInsert)
        CentroDeCustoTriggerHandler.afterInsert();
    else
        CentroDeCustoTriggerHandler.afterDelete();   
}