public with sharing class DemandaController {
  @AuraEnabled(Cacheable=true)
  public static List<Demanda__c> getAllDemandas() {
    return [
      SELECT
        Id,
        Name,
        Conta__r.Name,
        Lider__r.Name,
        Estimativa_Horas__c,
        Horas_Alocadas__c,
        Horas_Executadas__c,
        Horas_Por_Alocar__c
      FROM Demanda__c
    ];
  }

  @AuraEnabled(Cacheable=true)
  public static Date getTranslatedDate(String input) {
    
    String[] arrDate = input.split('-');

    Integer year = integer.valueof(arrDate[0]);
    Integer month = integer.valueof(arrDate[1]);
    String[] preDay = arrDate[2].split('T');
    Integer day = integer.valueof(preDay[0]);

    Date output = Date.newInstance(year, month, day);

    return output;
  }

  @AuraEnabled(Cacheable=true)
  public static List<Alocacao_Profissional__c> getDemandas(
    String[] dateRange
  ) {
    Date queryInitDate;
    Date queryFinalDate;
    
    if (dateRange.size() > 0) {
      queryInitDate = getTranslatedDate(dateRange[0]);
      queryFinalDate = getTranslatedDate(dateRange[1]);
    } else {
      DateHelpers dateHelper = new DateHelpers();
      String[] dateRangeCustom = dateHelper.getDefaultDateRange();
      queryInitDate = getTranslatedDate(dateRangeCustom[2]);
      queryFinalDate = getTranslatedDate(dateRangeCustom[3]);
    }

    List<Alocacao_Profissional__c> alocacao = new List<Alocacao_Profissional__c>(
      [
        SELECT
          Profissional__r.Name,
          Demanda__r.Name,
          Demanda__r.Id,
          Demanda__r.Horas_Alocadas__c,
          Demanda__r.Horas_Executadas__c,
          Demanda__r.Horas_Por_Alocar__c,
          Demanda__r.Estimativa_Horas__c,
          Demanda__r.Conta__r.Name,
          Demanda__r.Conta__r.Id,
          Demanda__r.Lider__r.Name,
          Demanda__r.Lider__r.Id,
          Data_Inicio__c,
          Data_Fim__c,
          Total_De_Dias__c,
          Horas__c,
          Periodicidade__c,
          Horas_Executadas__c,
          Horas_Por_Dia__c,
          Total_De_Horas__c
        FROM Alocacao_Profissional__c
        WHERE
          Data_Inicio__c >= :queryInitDate
          AND Data_Fim__c <= :queryFinalDate
      ]
    );

    return alocacao;
  }

  @AuraEnabled(Cacheable=true)
  public static String getDemanda(String idRecord) {
    List<Demanda__c> demanda = new List<Demanda__c>(
      [
        SELECT
          Id,
          Name,
          Conta__r.Name,
          Lider__r.Name,
          Estimativa_Horas__c,
          Horas_Alocadas__c,
          Horas_Executadas__c,
          Horas_Por_Alocar__c
        FROM Demanda__c
        WHERE Id = :idRecord
      ]
    );

    System.debug(demanda);
    return JSON.serialize(demanda);
  }
}