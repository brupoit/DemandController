trigger CheckIndisponibilidadeSobreposta on Indisponibilidade__c (before insert) {
    
    //for each of the records being created or updated
    //check if there's indisponibilidade no período    
    for(Indisponibilidade__c indisp : Trigger.New) {
        System.debug('----- aloc loop atual' + JSON.serialize(indisp));
        
        //busca indisponibilidades pro registro atual do loop
        //se existe, adiciona erro ao registro
        //se não existe, salva na lista de registros a serem salvos
       
        List<Indisponibilidade__c> indispList = new List<Indisponibilidade__c>(
        [SELECT Id FROM Indisponibilidade__c WHERE 
          (Profissional__c=:indisp.Profissional__c AND ((Data_Inicio__c<=:indisp.Data_Fim__c AND Data_Inicio__c>=:indisp.Data_Inicio__c) 
                                               OR (Data_Fim__c<=:indisp.Data_Fim__c AND Data_Fim__c>=:indisp.Data_Inicio__c) 
                                               OR (Data_Inicio__c<=:indisp.Data_Fim__c AND Data_Inicio__c>=:indisp.Data_Inicio__c)
                                              OR (Data_Inicio__c<=:indisp.Data_Inicio__c AND Data_Fim__c>=:indisp.Data_Fim__c ) ))]);
        
        List<Alocacao_Profissional__c> alocList = new List<Alocacao_Profissional__c>(
        [SELECT Id FROM Alocacao_Profissional__c WHERE 
          (Profissional__c=:indisp.Profissional__c AND ((Data_Inicio__c<=:indisp.Data_Fim__c AND Data_Inicio__c>=:indisp.Data_Inicio__c) 
                                               OR (Data_Fim__c<=:indisp.Data_Fim__c AND Data_Fim__c>=:indisp.Data_Inicio__c) 
                                               OR (Data_Inicio__c<=:indisp.Data_Fim__c AND Data_Inicio__c>=:indisp.Data_Inicio__c)
                                              OR (Data_Inicio__c<=:indisp.Data_Inicio__c AND Data_Fim__c>=:indisp.Data_Fim__c ) ))]);
        if (indispList.size() > 0) {
      		indisp.Data_Inicio__c.addError('O período indicado já possui uma Indisponibilidade cadastrada, não é possível criar mais de uma Indisponibilidade para os mesmos dias.');
    		//System.debug('----- Há indisponibilidade neste período.');
        }    
        if (alocList.size() > 0) {
      		indisp.Data_Inicio__c.addError('Há uma ALOCAÇÃO no período no período indicado, não é possível criar uma INDISPONIBILIDADE. Excluir ou editar a ALOCAÇÃO antes de criar uma indisponibilidade para o mesmo período.');
        }   
    } // fim for
}