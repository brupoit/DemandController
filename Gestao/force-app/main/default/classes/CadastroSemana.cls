public with sharing class CadastroSemana {
    @auraEnabled
    public static String inserirSemana(Date week, Date startDate){
        try{
            Semana_Alocada__c objWeek = new Semana_Alocada__c();
            Datetime startWeek = week.toStartofWeek()+1;
            String nameDate = startWeek.format('dd/MM/yyyy');
            System.debug(startWeek);
            System.debug(nameDate);
            List<Semana_Alocada__c> lstWeek = [SELECT Id, Name FROM Semana_Alocada__c WHERE Name =: nameDate];
            if(lstWeek.isEmpty()){
            objWeek.Name = nameDate;
            objWeek.Data_de_Inicio__c = startDate;        
            insert objWeek;
            return 'Success';
            }
            return 'Null';
        }
        catch(Exception e){
            throw new AuraHandledException(e.getMessage());
        }
        
    }
   /*  @auraEnabled
    public static List<Semana_Alocada__c> getSemanaAlocada(Date week){ 
        try{        
            Datetime inicioSemana = week.toStartofWeek()+1;
            System.debug(inicioSemana);
            String startWeek = inicioSemana.format('dd/MM/yyyy');
            System.debug(startWeek);

        List<Semana_Alocada__c> semana =  [SELECT Id, Name FROM Semana_Alocada__c WHERE Name =: startWeek ORDER BY Data_de_Inicio__c DESC LIMIT 1];
        System.debug(semana);
        return semana;
        } catch(DmlException e){
            System.debug('Retornou vazio' + e.getMessage());
            return null;
        }
    } */
}