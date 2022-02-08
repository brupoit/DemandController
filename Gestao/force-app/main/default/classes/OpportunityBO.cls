public inherited sharing class OpportunityBO {
     static final String STAGE_EM_APROVACAO='Pendente aprovação';
    
    public static void LimpaAcelerador(List<Opportunity> listNew)
    {
         for(Opportunity record:listNew)
        {
            if(Record.Acelerador__c==null)
            {
                Record.Acelerador_Aprovado__c=false;
            }
        }
    }
    
    public static void CCChanged(List<Opportunity> listNew,  map<Id,Opportunity> oldmap)
    {
        for(Opportunity record:listNew)
        {
        	if( oldmap!= null && oldmap.get(record.id).CentroDeCusto__c != record.CentroDeCusto__c )
            {
                record.Fechamento_Aprovado__c =false;
            }
        }
    }
    public static void updateCCs(List<Opportunity> listNew)
    {
         system.debug('============UPDATECC');
        List<CentroDeCusto__c> listCC = new List<CentroDeCusto__c>();
        
        for(Opportunity opp : listNew)
        {
            if(opp.IsWon && opp.CentroDeCusto__c != null)
            {
                listCC.add(new CentroDeCusto__c(Id=opp.CentroDeCusto__c));
            }
        }
        
        if(listCC.size()> 0)
        {
            
            CentroDeCustoBO.updateValorFaturamento(listCC);
        }
    }
    public static void verificaAprovacao(List<Opportunity> listNew, map<Id,Opportunity> oldmap)
    {
        system.debug('============VerificandoAprovacao');
        for(Opportunity record:listNew)
        {
             system.debug('============record.fechamento_aprovado__c  '+ record.fechamento_aprovado__c );
             system.debug('============record.Margem_Recomendada__c '+ record.Margem_Recomendada__c);
             system.debug('============ecord.Margem_na_venda__c ' +record.Margem_na_venda__c);
             system.debug('============record.StageName '+ record.StageName);
              system.debug('============record.needApproval__c '+ record.needApproval__c);
             system.debug('============oldmap.get(record.id).StageName!=record.StageName '+ oldmap.get(record.id).StageName!=record.StageName);
            if( record.needApproval__c && oldmap.get(record.id).needApproval__c!=record.needApproval__c)
                                                                             
            {
                system.debug('============CriaAprovacao');
                
                Approval.ProcessSubmitRequest req1 =    new Approval.ProcessSubmitRequest();
                req1.setComments('Aprovação automática.');
                req1.setObjectId(record.id);
                
                // Submit on behalf of a specific submitter
                req1.setSubmitterId(record.LastModifiedById); 
                
                // Submit the record to specific process and skip the criteria evaluation
                req1.setProcessDefinitionNameOrId('Aprovar_Fechamento_de_Oportunidade');
                req1.setSkipEntryCriteria(true);
                
                // Submit the approval request for the account
                Approval.ProcessResult result = Approval.process(req1);
                
            }
        }
    }
    public static void trocaStatus(List<Opportunity> listNew, map<Id,Opportunity> oldmap)
    {
        system.debug('============trocaStatus');
        for(Opportunity record:listNew)
        {
			 system.debug('============fechamento_aprovado__c ' +record.fechamento_aprovado__c );
             system.debug('============Margem_Recomendada__c ' +record.Margem_Recomendada__c );
             system.debug('============Margem_na_venda__c ' +record.Margem_na_venda__c ); 
            system.debug('============StageName' +record.StageName );
            if(!record.fechamento_aprovado__c && record.Margem_Recomendada__c>record.Margem_na_venda__c 
               && record.StageName=='Fechado - ganho'    && oldmap!= null &&
               ( oldmap.get(record.id).StageName!=record.StageName || oldmap.get(record.id).CentroDeCusto__c!=record.CentroDeCusto__c ))
                                                                             
            {
                 
                record.needApproval__c=true;
                record.StageName=STAGE_EM_APROVACAO;              
            }
        }
    }
    public static void setPolitica(List<Opportunity> listNew, map<Id,Opportunity> oldmap)
    {
        List<Politica_de_comissionamento__c> polAtiva = [Select Id,Empresa__c  from Politica_de_comissionamento__c where Ativo__c=true];  
        for(Politica_de_comissionamento__c pol:polAtiva){
            
            for(Opportunity record:listNew)
            {
                if(record.Politica_de_comissionamento__c==null ||
                   (record.StageName=='Fechado - ganho' && oldmap!= null && oldmap.get(record.id).StageName!=record.StageName)
                  )
                {
                    system.debug('troca politica');
                    
                    if(record.Empresa__c==pol.Empresa__c && pol.id!=record.Politica_de_comissionamento__c )
                    {
                        record.Acelerador__c=null;
                        record.Acelerador_Aprovado__c=false;
                        record.Politica_de_comissionamento__c=pol.id;
                    }
                }
            }
        }
        
    }
    public static void updateComissaoMax(List<Opportunity> listNew,  map<Id,Opportunity> oldmap)
    {
        Set<Id> PoliticasOpp = new Set<Id>();
        for(Opportunity record:listNew)
        {
            PoliticasOpp.add(record.Politica_de_comissionamento__c);
        }
        List<Regra_de_comissionamento__c>   AllRules = [Select Comissao_Finders_Fee__c,Politica_de_comissionamento__c,Condi_o_do_projeto__c,Tipo_de_projeto__c,Origem_do_projeto__c,Comissao_maxima__c
                                                        from Regra_de_comissionamento__c                                                        
                                                        where Politica_de_comissionamento__c in:PoliticasOpp];      
        Map<String, Regra_de_comissionamento__c> AllRulesMap = new  Map<String, Regra_de_comissionamento__c>();
        for(Regra_de_comissionamento__c Record:AllRules){
            
            AllRulesMap.put(Record.Politica_de_comissionamento__c+Record.Condi_o_do_projeto__c+Record.Tipo_de_projeto__c+Record.Origem_do_projeto__c,Record);
        }
        for(Opportunity Record:listNew)
        {
            if(!Record.Acelerador_Aprovado__c && (oldmap==null || (Record.Comissao_Max__c==oldmap.get(Record.Id).Comissao_Max__c)))
            {
                Record.Comissao_Max__c=AllRulesMap.get(Record.Politica_de_comissionamento__c+Record.Condicao__c+Record.Tipo_de_receita__c+Record.Type)?.Comissao_maxima__c;
            }
            if(!Record.Acelerador_Aprovado__c && (oldmap==null || (Record.Comissao_Finders_Fee__c==oldmap.get(Record.Id).Comissao_Finders_Fee__c)))
            {
                Record.Comissao_Finders_Fee__c=AllRulesMap.get(Record.Politica_de_comissionamento__c+Record.Condicao__c+Record.Tipo_de_receita__c+Record.Type)?.Comissao_Finders_Fee__c;
            }
        }
        
        
    }
    public static void recalculateComissoes(List<Opportunity> listNew,map<Id,Opportunity> oldmap)
    {
        Set<Id> idOppToUpdateComissao = new Set<Id>();
        for(Opportunity Record:listNew)
        {
            if(Record.Numero_de_Finders_Fee__c!=oldmap.get(Record.Id).Numero_de_Finders_Fee__c ||
               Record.Numero_de_participantes__c!=oldmap.get(Record.Id).Numero_de_participantes__c ||
              oldmap.get(record.id).CentroDeCusto__c != record.CentroDeCusto__c ||
               Record.ComissaoUtilizada__c != oldmap.get(record.id).ComissaoUtilizada__c
              )
            {
                idOppToUpdateComissao.add(Record.Id);      
            }
        }
        if(idOppToUpdateComissao.size()>0)
        {
            ComissionamentoHelper.DeleteComissoes(idOppToUpdateComissao,true);
        }
    }
    public static void updateMembros(List<Opportunity> listNew,map<Id,Opportunity> oldmap)
    {     
        Set<Id> idOppToUpdateComissao = new Set<Id>();
        for(Opportunity Record:listNew)
        {
            if(Record.Comissao_Max__c!=oldmap.get(Record.Id).Comissao_Max__c ||
               Record.Comissao_Finders_Fee__c!=oldmap.get(Record.Id).Comissao_Finders_Fee__c)
            {
                idOppToUpdateComissao.add(Record.Id);      
            }
        }
        if(idOppToUpdateComissao.size()>0)
        {
            ComissionamentoHelper.DeleteComissoes(idOppToUpdateComissao,true);
        }
        
        
    }
    
    public static void fechadoPerdido(List<Opportunity> listNew ,map<Id,Opportunity> oldmap)
    {
        
        Set<Id> idOppToDeleteeComissao = new Set<Id>();
        for(Opportunity record:listNew)
        {
            if  (record.StageName=='Fechado - perdido' && oldmap!= null && oldmap.get(record.id).StageName!=record.StageName)
            {
                idOppToDeleteeComissao.add(record.id);
            }
        }
        if(idOppToDeleteeComissao.size()>0)
        {
            ComissionamentoHelper.DeleteComissoes(idOppToDeleteeComissao, false);
        }
    }
}