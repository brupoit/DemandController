public inherited sharing class AlocacaoBO {
    
    public static void updateComissaoAlocacao(List<Alocacao__c> listAloc, Map<Id, Alocacao__c> mapAlocOld)
    {
        Map<Id, Alocacao__c> mapContatoAloc = new Map<Id, Alocacao__c>();
        List<Detalhe_do_comissionamento__c> listComissaoToUpdate = new List<Detalhe_do_comissionamento__c>();
        
        for(Alocacao__c a : listAloc)
        {
            if((mapAlocOld != null && a.Calcular__c && !mapAlocOld.get(a.Id).Calcular__c) || (mapAlocOld == null && a.Calcular__c))
            {
                mapContatoAloc.put(a.Colaborador__c, a);
            }
        }
        
        if(mapContatoAloc.size() > 0)
        {
            system.debug('key set: ' + mapContatoAloc.keySet() );
            list<Detalhe_do_comissionamento__c> lista = [SELECT Id,
                                                   Comissionamento__r.Colaborador__c,
                                                   Comissionamento__r.Invoice__r.Data_de_emissao__c
                                                   FROM Detalhe_do_comissionamento__c
                                                   WHERE Comissionamento__r.Colaborador__c IN :mapContatoAloc.keySet()
                                                  AND Comissionamento__r.Invoice__r.Data_de_emissao__c != NULL
                                                  AND Liberado__c = false
                                                  AND Tipo__c = 'Alocação'];
            for(Detalhe_do_comissionamento__c d : lista) {
                Decimal yearInvoice = d.Comissionamento__r.Invoice__r.Data_de_emissao__c.year();
                Alocacao__c a = mapContatoAloc.get(d.Comissionamento__r.Colaborador__c);

                if(yearInvoice == a.Ano__c)
                {
                    d.Fator__c = a.Fator__c;
                    listComissaoToUpdate.add(d);
                }
            }
            
            if(listComissaoToUpdate.size() > 0)
            {
                update listComissaoToUpdate;
            }
        }
    }
}