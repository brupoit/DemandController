public with sharing class MapaAlocacaoController {
  @AuraEnabled(Cacheable=true)
  public static List<Alocacao_Profissional__c> getMappedQuery() {
    return [
      SELECT
        Horas__c,
        Horas_Executadas__c,
        Total_De_Horas__c,
        Profissional__r.Name,
        Profissional__r.Id,
        Data_Inicio__c,
        Data_Fim__c
      FROM Alocacao_Profissional__c
    ];
  }
}