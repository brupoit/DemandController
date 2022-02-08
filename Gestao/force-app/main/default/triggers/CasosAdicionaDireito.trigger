trigger CasosAdicionaDireito on Case (before insert, before update) {
    if(trigger.isBefore){        
        if(Trigger.isInsert)
        {   
            Set<Id> setContato = new Set<Id>();
            for (Case caso : Trigger.new)
            {
                setContato.add(caso.ContactId);
            }
            // Processo comportará apenas um Entitlement ativo para cada conta - se existir mais de um, ele escolherá um deles
            List<EntitlementContact> listEntitlement = [SELECT EntitlementId,ContactId FROM EntitlementContact WHERE ContactId IN :setContato AND
                                                        Entitlement.STATUS = 'Active'];
            for (Case caso : Trigger.new)
            {
                for (EntitlementContact direito : listEntitlement)
                {
                    if (caso.ContactId == direito.ContactId)
                    {
                        caso.EntitlementId = direito.EntitlementId;
                        break;
                    }
                }
            }
        }        
        if(Trigger.isUpdate)
        {
            List<Profile> profiles = [SELECT Id, Name FROM Profile];
            Id admProfileId;
            Id supProfileId;
            for(Profile currentProfile: profiles){
                if(currentProfile.Name == 'Administrador do sistema')
                {
                    admProfileId = currentProfile.Id;
                }else if(currentProfile.Name == 'Suporte')
                {
                    supProfileId = currentProfile.Id;
                }
            }
            Id userProfileId = UserInfo.getProfileId();
            Set<Id> accountIds = new Set<Id>();
            if(userProfileId == admProfileId || userProfileId == supProfileId){
                for(Case currentCase: Trigger.new){
                    if(Trigger.oldMap.get(currentCase.Id).Prioridade_Interno__c != currentCase.Prioridade_Interno__c){                    
                        accountIds.add(currentCase.AccountId);
                    }   
                }
                List<Case> existentCases = [SELECT Id, AccountId, Prioridade_Interno__c FROM Case WHERE AccountId =: accountIds AND Status !='Cancelado' AND Status !='Fechado'];
                Map<Id, List<Case>> existentCaseAccountMap = new Map <Id,List<Case>>();            
                for(Case currentExistentCase: existentCases){
                    if(existentCaseAccountMap.get(currentExistentCase.AccountId) == null){
                        existentCaseAccountMap.put(currentExistentCase.AccountId, new List<Case>{currentExistentCase});
                    }else{
                        existentCaseAccountMap.get(currentExistentCase.AccountId).add(currentExistentCase);                    
                    }
                }
                if(existentCaseAccountMap.size() > 0){
                    for(Case currentCase: Trigger.new){
                        if(Trigger.oldMap.get(currentCase.Id).Prioridade_Interno__c != currentCase.Prioridade_Interno__c){                    
                            for(Case currentExistentCase: existentCaseAccountMap.get(currentCase.AccountId)){
                                if(currentExistentCase.Id != currentCase.Id){
                                    if(currentExistentCase.Prioridade_Interno__c == currentCase.Prioridade_Interno__c && currentCase.Prioridade_Interno__c != null){
                                        currentCase.Prioridade_Interno__c.addError(Label.Prioridade_j_existente);
                                        break;
                                    }
                                }
                            }
                        }   
                    }
                }
            }
        }
    }
}