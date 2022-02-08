public class IndisponibilidadeController {
  @AuraEnabled(Cacheable=true)
  public static String getAllIndisponibilidade() {
    List<Indisponibilidade__c> indisponibilidades = new List<Indisponibilidade__c>(
      [
        SELECT
          Name,
          Profissional__r.Name,
          Data_Inicio__c,
          Data_Fim__c,
          Horas__c,
          Motivo__c
        FROM Indisponibilidade__c
      ]
    );

    system.debug('----indisponibilidades: ' + indisponibilidades);

    return (JSON.serialize(indisponibilidades));
  }

  @AuraEnabled(Cacheable=true)
  public static String getIndisponibilidade(String idRecord) {
    List<Indisponibilidade__c> indisponibilidade = new List<Indisponibilidade__c>(
      [
        SELECT
          Name,
          Profissional__r.Name,
          Data_Inicio__c,
          Data_Fim__c,
          Horas__c,
          Motivo__c
        FROM Indisponibilidade__c
        WHERE Id = :idRecord
      ]
    );

    system.debug('----indisponibilidade: ' + indisponibilidade);

    return (JSON.serialize(indisponibilidade));
  }
}