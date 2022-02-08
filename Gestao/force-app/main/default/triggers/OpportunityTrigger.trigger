trigger OpportunityTrigger on Opportunity (before update, before insert, after insert, after update, before delete, after delete) {
    if (Trigger.isBefore)
        if (Trigger.isUpdate)
        OpportunityTriggerHandler.beforeUpdate();
    else if (Trigger.isInsert)
        OpportunityTriggerHandler.beforeInsert();
    else
        OpportunityTriggerHandler.beforeDelete();
    else
        if (Trigger.isUpdate)
        OpportunityTriggerHandler.afterUpdate();
    else if (Trigger.isInsert)
        OpportunityTriggerHandler.afterInsert();
    else
        OpportunityTriggerHandler.afterDelete();   
}