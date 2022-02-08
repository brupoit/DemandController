public with sharing class PerfilProfissionalController {
  @AuraEnabled(Cacheable=true)
  public static String getAllPerfil() {
    List<Perfil_Profissional__c> perfis = new List<Perfil_Profissional__c>(
      [
        SELECT Name, Carga_Horaria__c, Periodicidade__c
        FROM Perfil_Profissional__c
      ]
    );

    system.debug('----perfis: ' + perfis);

    return (JSON.serialize(perfis));
  }

  @AuraEnabled(Cacheable=true)
  public static String getPerfil(String idRecord) {
    List<Perfil_Profissional__c> perfil = new List<Perfil_Profissional__c>(
      [
        SELECT Name, Carga_Horaria__c, Periodicidade__c
        FROM Perfil_Profissional__c
        WHERE Id = :idRecord
      ]
    );

    system.debug('----perfil: ' + perfil);

    return (JSON.serialize(perfil));
  }

  @AuraEnabled(Cacheable=true)
  public static String getIndispo(String idRecord) {
    List<Perfis_Indisponibilidade__c> perfis = new List<Perfis_Indisponibilidade__c>(
      [
        SELECT Name
        FROM Perfis_Indisponibilidade__c
      ]
    );

    system.debug('----perfis: ' + perfis);

    return (JSON.serialize(perfis));
  }
 
}