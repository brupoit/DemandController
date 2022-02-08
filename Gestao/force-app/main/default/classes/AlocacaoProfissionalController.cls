public with sharing class AlocacaoProfissionalController {
  @AuraEnabled(Cacheable=true)
  public static String getAllAlocacaoProfissional() {
    List<Alocacao_Profissional__c> alocacoes = new List<Alocacao_Profissional__c>(
      [
        SELECT
          Profissional__r.Name,
          Demanda__r.Name,
          Data_Inicio__c,
          Data_Fim__c,
          Total_De_Dias__c,
          Horas__c,
          Periodicidade__c,
          Horas_Executadas__c,
          Total_De_Horas__c
        FROM Alocacao_Profissional__c
      ]
    );

    system.debug('----getAllAlocacaoProfissional: ' + alocacoes);

    return (JSON.serialize(alocacoes));
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
  public static List<String> getDefaultAllocationDateRange() {
    DateHelpers dateHelper = new DateHelpers();
    String[] dateRangeCustom = dateHelper.getDefaultDateRange();
    return dateRangeCustom;
  }

  @AuraEnabled(Cacheable=true)
  public static List<Alocacao_Profissional__c> getMapaAlocacao(
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
          Demanda__r.Horas_Alocadas__c,
          Demanda__r.Horas_Executadas__c,
          Demanda__r.Horas_Por_Alocar__c,
          Data_Inicio__c,
          Data_Fim__c,
          Total_De_Dias__c,
          Horas__c,
          Periodicidade__c,
          Horas_Executadas__c,
          Horas_Por_Dia__c,
          Total_De_Horas__c,
          Profissional__r.Perfil_Profissional__r.Name,
          Profissional__r.Perfil_Profissional__r.Cor_no_Gr_fico__c
        FROM Alocacao_Profissional__c
        WHERE
          Data_Inicio__c >= :queryInitDate
          AND Data_Fim__c <= :queryFinalDate
      ]
    );

    return alocacao;
  }

  @AuraEnabled(Cacheable=true)
  public static String getAlocacaoProfissional() {
    List<Alocacao_Profissional__c> alocacao = new List<Alocacao_Profissional__c>(
      [
        SELECT
          Profissional__r.Name,
          Demanda__r.Name,
          Data_Inicio__c,
          Data_Fim__c,
          Total_De_Dias__c,
          Horas__c,
          Periodicidade__c,
          Horas_Executadas__c,
          Total_De_Horas__c
        FROM Alocacao_Profissional__c
      ]
    );

    system.debug('----alocacaoProfissional: ' + alocacao);

    return (JSON.serialize(alocacao));
  }
}