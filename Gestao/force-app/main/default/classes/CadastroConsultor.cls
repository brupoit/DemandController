public with sharing class CadastroConsultor {
@AuraEnabled
public static void cadastrarConsultor(String expertise, String status, String nome, Decimal horas){
            try {
                Employee__c emp = new Employee__c();
                emp.Name = nome;
                emp.Consultor_Disponivel__c = status;
                emp.Expertise__c = expertise;
                emp.Hours_per_Week__c = horas;
                insert emp;
                Employee__c teste = [SELECT Name FROM Employee__c WHERE Name =: nome];
                System.debug('sucesso===' + teste);
            } catch (Exception e) {
                System.debug(e.getMessage());
        }       
    }
}