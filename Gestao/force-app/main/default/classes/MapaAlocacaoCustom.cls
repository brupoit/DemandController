public with sharing class MapaAlocacaoCustom {
  @AuraEnabled(cacheable=true)
  public static String getInfoGeral() {
    List<String> listInfo = new List<String>();

    List<Profissional__c> Consultores = [SELECT Id, Name FROM Profissional__c];
    for (Profissional__c Consult : Consultores) {
      listInfo.add(Consult.Name);
    }

    List<Perfil_Profissional__c> horasSemana = [
      SELECT Id, Carga_Horaria__c, Name
      FROM Perfil_Profissional__c
    ];
    for (Perfil_Profissional__c hrsS : horasSemana) {
      listInfo.add(String.valueOf(hrsS.Carga_Horaria__c));
      listInfo.add(hrsS.Name);
    }

    List<Alocacao_Profissional__c> AlocacaoProf = [
      SELECT Id, Demanda__c, Horas_Executadas__c
      FROM Alocacao_Profissional__c
    ];
    for (Alocacao_Profissional__c AlocP : AlocacaoProf) {
      listInfo.add(AlocP.Demanda__c);
      listInfo.add(String.valueOf(AlocP.Horas_Executadas__c));
    }

    return JSON.serialize(listInfo);
  }
  public class InfoWrapper {
    @AuraEnabled
    public List<String> listInfo;
  }
}