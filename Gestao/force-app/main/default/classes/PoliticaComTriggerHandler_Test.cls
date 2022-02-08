/**
 * @description
 * @author             JCOSTA
 * @group             Test Class
 * @date               12122020
 * @last modified by   JCOSTA
 * Modifications Log
 * Ver   Date       Author   Modification
 * 1.0   12122020   JCOSTA   Initial Version
 **/
@isTest
public with sharing class PoliticaComTriggerHandler_Test {
  static testMethod void TestTriggerHandler() {
    Politica_de_comissionamento__c pol = (Politica_de_comissionamento__c) TestDataFactory.createSObject(
      'Politica_de_comissionamento__c',
      new Map<String, Object>{ 'Ativo__c' => true }
    );
    pol.Ativo__c = false;
    update pol;
    pol.Ativo__c = true;
    update pol;
    Politica_de_comissionamento__c pol2 = (Politica_de_comissionamento__c) TestDataFactory.createSObject(
      'Politica_de_comissionamento__c'
    );
      
      
      Account acc = (Account) TestDataFactory.createSObject(
      'Account',
      new Map<String, Object>{ 'Name' => 'Harpia' }
            );
         Contact c = (Contact) TestDataFactory.createSObject(
      'Contact',
      new Map<String, Object>{ 'AccountId' => acc.id }
            );
      Batimento_de_meta__c Bat = (Batimento_de_meta__c) TestDataFactory.createSObject(
      'Batimento_de_meta__c',
      new Map<String, Object>{ 'Colaborador__c' => c.id }
            );
      bat.Ano_do_batimento__c=2021;
     
      update bat;
  }
    
}