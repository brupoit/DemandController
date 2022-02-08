public class ComissionamentoHelper {
    
    
    public static void UpdateDetalhes(List<Batimento_de_meta__c> newList)
    {
        system.debug('======== Inicio Debug');
        Set<Id> Colaborador = new Set<Id>();
       Set<Id> Politica = new Set<Id>();
        for(Batimento_de_meta__c Record:newList)
        {
            Colaborador.add(Record.Colaborador__c);
            Politica.add(Record.Politica_de_comissionamento__c);
        }
        if(Colaborador.Size()>0)
        {
            List<Detalhe_do_comissionamento__c> DetalhesToUpdate = [Select Id, ColaboradorId__c, Ano_da_Invoice__c, Fator__c,Politica_de_Comissionamento__c 
                                                                    from Detalhe_do_comissionamento__c
                                                                    where ColaboradorId__c in:Colaborador and Tipo__c='Baldão' 
                                                                    AND Politica_de_Comissionamento__c in:Politica
                                                                   ];
            system.debug('========  Detalhes '+DetalhesToUpdate.size());
            if(DetalhesToUpdate.size()>0)
            {
                system.debug('======== Encontrou Detalhes '+DetalhesToUpdate.size());
                for(Batimento_de_meta__c Record:newList)
                {
                    for(Detalhe_do_comissionamento__c Det:DetalhesToUpdate)
                    {
                        system.debug('======== Ano_da_Invoice__c '+Det.Ano_da_Invoice__c);
                        system.debug('======== Ano_do_batimento__c '+Record.Ano_do_batimento__c);
                        system.debug('======== ColaboradorId__c '+Det.ColaboradorId__c);
                        system.debug('======== Colaborador__c '+Record.Colaborador__c);
                        if(Det.Politica_de_Comissionamento__c==Record.Politica_de_Comissionamento__c && Det.Ano_da_Invoice__c==Record.Ano_do_batimento__c && Det.ColaboradorId__c==Record.Colaborador__c)
                        {
                            Det.Fator__c=Record.Fator_multiplicador__c/100;
                        }
                    }
                }
                update DetalhesToUpdate;
            }
            
        }
    }
    
    public static void DeleteComissoes(Set<Id> oppsIdsToDelete, boolean geraComissao)
    {
        delete [Select Id 
                From Comissionamento__c 
                where Invoice__r.Opportunity__r.id in:oppsIdsToDelete 
                and Invoice__r.Status__c!='Canceled'
                and Invoice__r.Status__c!='Received'
               ];
        if(geraComissao)
        {
            Map<Id,id> MapInvoiceOppIds= new Map<Id,id>();
            List<Invoice__c> InvoicesTogenerate=  [ Select id ,Opportunity__c
                                                   from Invoice__c
                                                   where Opportunity__c in:oppsIdsToDelete
                                                   and Status__c!='Canceled'
                                                   and Status__c!='Received'];
            for(Invoice__c Record:InvoicesTogenerate){
                
                MapInvoiceOppIds.put(Record.id,Record.Opportunity__c);
            }
            if(!MapInvoiceOppIds.isEmpty())
            {
                GeraComissoes(MapInvoiceOppIds);
            }
            
        }
    }
    
    
    public static void GeraComissoes(Map<Id,id> MapInvoiceOppIds){
        List< Time_da_oportunidade__c> EquipeToGenerate = [Select Oportunidade__r.Tipo_de_receita__c, Comissao_Calculada_Finders_Fee__c ,Finder_Fee__c, Oportunidade__c,Colaborador__c, Comiss_o_calculada__c 
                                                           from Time_da_oportunidade__c where Oportunidade__c in:MapInvoiceOppIds.values()];
        Map<ID, Invoice__C> InvoicesMap = new Map<ID, Invoice__c>([SELECT Id, Criar_Comissoes__c  FROM Invoice__c where id in:MapInvoiceOppIds.keySet()]);
        Map<Id, List<Time_da_oportunidade__c>> timesByOppId = (Map<Id, List<Time_da_oportunidade__c>>) CollectionUtils.mapFromCollectionWithCollectionValues('Oportunidade__c', EquipeToGenerate);
        
        List<Comissionamento__c> listComissionamentoToInsert = new  List<Comissionamento__c>();
        for(Id invoiceId:MapInvoiceOppIds.keySet())
        {
            
            if(InvoicesMap.get(invoiceId).Criar_Comissoes__c && timesByOppId.containsKey(MapInvoiceOppIds.get(invoiceId)))
            {
                if(timesByOppId.get(MapInvoiceOppIds.get(invoiceId)).size()>0)
                {
                    for(Time_da_oportunidade__c teamMember:timesByOppId.get(MapInvoiceOppIds.get(invoiceId)))
                    {
                        Comissionamento__c  comissionamentoToInsert = new Comissionamento__c();
                        comissionamentoToInsert.Colaborador__c=teamMember.Colaborador__c;
                        comissionamentoToInsert.Is_Finders_Fee__c=teamMember.Finder_Fee__c;
                        comissionamentoToInsert.Comissao__c= teamMember.Finder_Fee__c ?teamMember.Comissao_Calculada_Finders_Fee__c:teamMember.Comiss_o_calculada__c;                      
                        comissionamentoToInsert.Invoice__c=invoiceId;
                        listComissionamentoToInsert.add(comissionamentoToInsert);
                    }
                }
            }
        }
        
        insert listComissionamentoToInsert;
    }
    
    
    public static void atualizarComissoes (List<Comissionamento__c> ComissoesToUpdate) 
    {
        set<String> listOpp = new   set<String>();
        
        for(Comissionamento__c Record:ComissoesToUpdate)
        {
            listOpp.add(Record.OpportunityId__c);
        }
        List< Time_da_oportunidade__c> EquipeToGenerate = [Select Finder_Fee__c, Oportunidade__c,Colaborador__c, Comiss_o_calculada__c,Comissao_Calculada_Finders_Fee__c
                                                           from Time_da_oportunidade__c where Oportunidade__c in:listOpp];
        Map<Id, List<Time_da_oportunidade__c>> timesByOppId = (Map<Id, List<Time_da_oportunidade__c>>) CollectionUtils.mapFromCollectionWithCollectionValues('Oportunidade__c', EquipeToGenerate);
        
        for(Comissionamento__c Record:ComissoesToUpdate)
        {
            for(Time_da_oportunidade__c teamMember:timesByOppId.get(Record.OpportunityId__c))
            {
                Record.Comissao__c= teamMember.Finder_Fee__c ?teamMember.Comissao_Calculada_Finders_Fee__c:teamMember.Comiss_o_calculada__c;                      
                
            }
        }
    }
    
    public static void criarDetalhesComissionamento(List<Comissionamento__c> Comissionamento) 
    {
        List<Detalhe_do_comissionamento__c> detalhesToCreate = new List<Detalhe_do_comissionamento__c>();
        Set<Id> idsDetalheComissionamento = new Set<id>();
        for(Comissionamento__c Record:Comissionamento)
        {
            idsDetalheComissionamento.add(record.Politica_de_Comissionamento__c);
        }
        List<Batimento_de_meta__c> metasBatidas = [select Recordkey__c,Colaborador__c,Ano_do_batimento__c,Fator_multiplicador__c,Politica_de_comissionamento__c
                                                   from Batimento_de_meta__c
                                                   where Politica_de_comissionamento__c in:idsDetalheComissionamento];
        
        Map<String, Batimento_de_meta__c> metasBatidasByKey = new Map<String, Batimento_de_meta__c>();
        if(metasBatidas.size()>0)
        {
            metasBatidasByKey= (Map<String, Batimento_de_meta__c>)  CollectionUtils.stringMapFromCollectionByKey('Recordkey__c', metasBatidas);
            
        }
        
        
        for(Comissionamento__c Record:Comissionamento)
        {
            
            if(Record.Is_Finders_Fee__c)
            {
                Detalhe_do_comissionamento__c findersfee = new Detalhe_do_comissionamento__c();
                findersfee.Comissionamento__c = Record.id;
                findersfee.Percentual__c = Record.Finders_Fee__c;
                findersfee.Tipo__c = 'Pagamento Cliente/ Finder Fee';
                detalhesToCreate.add(findersfee); 
            }
            else if(Record.Tipo_de_Colaborador__c=='Gerente')
            {
                
                Detalhe_do_comissionamento__c recebimento = new Detalhe_do_comissionamento__c();
                Detalhe_do_comissionamento__c alocacao = new Detalhe_do_comissionamento__c();
                Detalhe_do_comissionamento__c margem = new Detalhe_do_comissionamento__c();
                if(Record.Tipo_de_receita__c=='Referral')
                {
                    recebimento.Comissionamento__c = Record.id;     
                    recebimento.Percentual__c = 100;                
                    recebimento.Tipo__c = 'Pagamento cliente/Baldinho';              
                    detalhesToCreate.add(recebimento); 
                }
                else
                {
                    recebimento.Comissionamento__c = Record.id;
                    alocacao.Comissionamento__c = Record.id;
                    margem.Comissionamento__c = Record.id;
                    
                    recebimento.Percentual__c = Record.GP_venda__c;
                    alocacao.Percentual__c = Record.GP_chargeability__c;
                    margem.Percentual__c = Record.GP_margem_cc__c;
                    
                    recebimento.Tipo__c = 'Pagamento cliente/Baldinho';
                    alocacao.Tipo__c = 'Alocação';
                    margem.Tipo__c = 'Margem CC';
                    detalhesToCreate.add(recebimento);
                    detalhesToCreate.add(alocacao);
                    detalhesToCreate.add(margem);  
                }
            }
            else if(Record.Tipo_de_Colaborador__c=='Comercial')
            {
                Detalhe_do_comissionamento__c recebimento = new Detalhe_do_comissionamento__c();
                Detalhe_do_comissionamento__c baldao = new Detalhe_do_comissionamento__c();
                recebimento.Comissionamento__c = Record.id;
                baldao.Comissionamento__c = Record.id;
                
                recebimento.Percentual__c = Record.Comercial_baldinho__c;
                Double multiplicador = 1;
                system.debug('metasBatidasByKey '+metasBatidasByKey);
                system.debug('Record.Colaborador__c+Record.Politica_de_Comissionamento__c '+ Record.Colaborador__c+Record.Politica_de_Comissionamento__c);
                if(metasBatidasByKey.containsKey(Record.Colaborador__c+Record.Politica_de_Comissionamento__c))
                {
                    system.debug('===== Encontrou meta');
                    system.debug('Data Batimento '+metasBatidasByKey.get(Record.Colaborador__c+Record.Politica_de_Comissionamento__c).Ano_do_batimento__c);
                    
                    system.debug('Data Fatura '+Record.Data_de_fechamento__c);
                    if(metasBatidasByKey.get(Record.Colaborador__c+Record.Politica_de_Comissionamento__c).Ano_do_batimento__c==Record.Ano_da_Invoice__c	)
                    {
                        system.debug('====== Encontrou multiplicador');
                        system.debug(metasBatidasByKey.get(Record.Colaborador__c+Record.Politica_de_Comissionamento__c).Fator_multiplicador__c);
                        multiplicador= metasBatidasByKey.get(Record.Colaborador__c+Record.Politica_de_Comissionamento__c).Fator_multiplicador__c/100;
                    }
                }
                system.debug('multiplicador '+multiplicador);
                baldao.Percentual__c = Record.Comercial_baldao__c;
                baldao.Fator__c=multiplicador;
                
                recebimento.Tipo__c =  'Pagamento cliente/Baldinho';
                baldao.Tipo__c = 'Baldão';
                
                detalhesToCreate.add(recebimento);
                detalhesToCreate.add(baldao);
            }
            
        }
        if(detalhesToCreate.size()>0)
        {
            insert detalhesToCreate;
        }
    }
    
}