public with sharing class CadastroDemandas {
    @AuraEnabled(cacheable=true)
    public static List<Employee__c> retornarConsultores() {
        try {
            return new List<Employee__c>([SELECT Id, Name FROM Employee__c]);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled(cacheable=true)
    public static List<Demand__c> searchDemands(String searchValue) {
        try {
            if (searchValue.length() >= 3) {
                String likeToken = '%' + searchValue + '%';
                return [SELECT Id, Name FROM Demand__c WHERE Name LIKE :likeToken];
            }

            return null;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static String cadastrarDemanda(Id empId, Id demandId, Date startDate, Date endDate) {
        try {
            List<Semana_Alocada__c> weeks = [
                SELECT Id, Data_de_Inicio__c
                FROM Semana_Alocada__c
                WHERE Data_de_Inicio__c >= :startDate AND Data_de_Inicio__c < :endDate
            ];
            Date startWeek = startDate.toStartofWeek();
            System.debug('start week=='+startWeek);

            if(weeks.isEmpty()){
                Semana_Alocada__c newWeek = new Semana_Alocada__c(
                    Data_de_Inicio__c = startDate,
                    Name = String.valueOf(startWeek)
                );
                insert newWeek;
            }
            System.debug('semana===' + weeks);
            System.debug('semana inicio===' + startDate);
            System.debug('semana fim===' + endDate);

            List<Alocacao_Semanal__c> toUpsert = new List<Alocacao_Semanal__c>();

            for (Semana_Alocada__c w : weeks) {
                toUpsert.add(
                    new Alocacao_Semanal__c(
                        Consultor__c = empId,
                        Semanas__c = w.Id,
                        Demanda__c = demandId,
                        EstaAlocado__c = 'SIM',
                        Identificador__c = (String) empId + (String) w.Id
                    )
                );
            }

            System.debug('Teste');

            upsert toUpsert Identificador__c;

            return 'SUCCESS';
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
        
    }
}