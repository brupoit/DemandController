public class UpdateIssueCalloutBombril {
    @InvocableMethod
    public static void makeCallout(List<Case> casos){
        for(Case caso : casos){
            System.debug('Update case: ' + caso.Id);
            ConsumeCaseRestFromBombril.futureCalloutUpdateCases(caso.Id, caso.Resolucao__c, caso.Description, caso.Status, caso.Ultimo_comentario_publico__c);
        }
    }
}