public with sharing class ProfessionalProfile {
    @AuraEnabled(Cacheable=true)
    public static String getProfessionalProfile() {

        List<Perfil_Profissional__c> listaPorPerfisDisponivel = [
        SELECT
        Name,
        Carga_Horaria__c,
        Periodicidade__c
        FROM Perfil_Profissional__c
    ];

        return JSON.serialize(listaPorPerfisDisponivel);
  }

  @AuraEnabled(Cacheable=true)
    public static String getIndispo() {

        List<Perfis_Indisponibilidade__c> perfis = [
        SELECT
        Name, Periodicidade__c
        FROM Perfis_Indisponibilidade__c
    ];

        return JSON.serialize(perfis);
  }



    }