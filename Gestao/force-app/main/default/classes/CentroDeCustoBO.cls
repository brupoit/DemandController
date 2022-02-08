public inherited sharing class CentroDeCustoBO {
    
    public static void updateComissaoPorMargem(List<CentroDeCusto__c> listCC, Map<Id, CentroDeCusto__c> mapCCOld)
    {
        List<Detalhe_do_comissionamento__c> listComissaoToUpdate = new List<Detalhe_do_comissionamento__c>();
        Map<Id, CentroDeCusto__c> mapCCCalcular = new Map<Id, CentroDeCusto__c>();
        
        for(CentroDeCusto__c c : listCC)
        {
            if(c.Calcular_comissao_por_margem__c && !mapCCOld.get(c.Id).Calcular_comissao_por_margem__c)
            {
                mapCCCalcular.put(c.Id, c);
            }
        }
        
        
        if(mapCCCalcular.size() > 0)
        {
            for(Detalhe_do_comissionamento__c d : [SELECT Id,
                                                   Comissionamento__r.Invoice__r.Opportunity__r.CentroDeCusto__c
                                                   FROM Detalhe_do_comissionamento__c
                                                   WHERE Tipo__c = 'Margem CC'
                                                   AND Comissionamento__r.Invoice__r.Opportunity__r.CentroDeCusto__c IN :mapCCCalcular.keySet()
                                                   AND Liberado__c = false])
            {
                Decimal fator = mapCCCalcular.get(d.Comissionamento__r.Invoice__r.Opportunity__r.CentroDeCusto__c).Fator_comissionamento_por_margem__c;
                
                d.Fator__c = fator;
                
                listComissaoToUpdate.add(d);
            }
            
            if(listComissaoToUpdate.size() > 0)
            {
                update listComissaoToUpdate;
            }
        }
        
    }
    
    public static void updateValorFaturamento(List<CentroDeCusto__c> listCC)
    {
               system.debug('============updateValorFaturamento');
        List<Id> listIdCCs = new List<Id>();
        Map<Id, CentroDeCusto__c> mapIdCC = new Map<Id, CentroDeCusto__c>();
        
        for(CentroDeCusto__c c : listCC)
        {
            listIdCCs.add(c.Id);
        }
        
        for(Opportunity o : OpportunitySelector.queryOppByCC(listIdCCs))
        {
            
            if((o.amount != null && o.amount > 0)||(o.Invoices_Sum__c != null && o.Invoices_Sum__c > 0))
            {
                if(!mapIdCC.containsKey(o.CentroDeCusto__c))
                {
                    CentroDeCusto__c c = new CentroDeCusto__c();
                    c.FaturamentoTotal__c = 0;
                    c.Id = o.CentroDeCusto__c;
                    
                    mapIdCC.put(c.Id, c);
                }
                         system.debug('============o.Invoices_Sum__c; ' +o.Invoices_Sum__c);
                
                CentroDeCusto__c c = mapIdCC.get(o.CentroDeCusto__c);
                c.FaturamentoTotal__c += o.Invoices_Sum__c>0?o.Invoices_Sum__c:o.amount;
                
                mapIdCC.put(c.Id, c);
            }
        }
        
        if(mapIdCC.size() > 0)
        {
            update mapIdCC.values();
        }
    }
}