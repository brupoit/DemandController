public with sharing class skillDemandProfClass {
    @AuraEnabled(Cacheable=true)
    public static String getSkillDemandaProfissional() {

        List<Skills_do_Profissional__c> skillProf = [
            SELECT Id, Name, Profissional__r.Name
            FROM Skills_do_Profissional__c
    ];
        system.debug('----Skill Profissional: ' + skillProf);
        return JSON.serialize(skillProf);
  }

  @AuraEnabled(Cacheable=true)
    public static String getskillDem() {

        List<Skills_Gestao_de_Demandas__c> skillDem = [
            SELECT Id, Name, Profissional__r.Name
            FROM Skills_Gestao_de_Demandas__c
    ];  
        system.debug('----Skill Gestão de Demandas: ' + skillDem);
        return JSON.serialize(skillDem);
  }



    }