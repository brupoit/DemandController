trigger AlocacaoTrigger on Alocacao__c(
  before update,
  before insert,
  after insert,
  after update,
  before delete,
  after delete
) {
  if (Trigger.isBefore)
    if (Trigger.isUpdate)
      AlocacaoTriggerHandler.beforeUpdate();
    else if (Trigger.isInsert)
      AlocacaoTriggerHandler.beforeInsert();
    else
      AlocacaoTriggerHandler.beforeDelete();
  else if (Trigger.isUpdate)
    AlocacaoTriggerHandler.afterUpdate();
  else if (Trigger.isInsert)
    AlocacaoTriggerHandler.afterInsert();
  else
    AlocacaoTriggerHandler.afterDelete();
}