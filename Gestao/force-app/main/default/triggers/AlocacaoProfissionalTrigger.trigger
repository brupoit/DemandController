/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 01-17-2022
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/

trigger AlocacaoProfissionalTrigger on Alocacao_Profissional__c (before insert, before update) {
    //trigger pra qualquer alteração ou nova alocacao profissional
    if (Trigger.isBefore && (Trigger.isInsert || Trigger.isUpdate)){

        // variavel que armazena os registro que serão salvos e
        // todas as alteracoes nos valores que serão feitas nesta classe
        // OBS - acho que essa variavel não é necessária, o trigger faz um INSERT automaticamente se não há erro
        List<Alocacao_Profissional__c> alocToAdd = new List<Alocacao_Profissional__c>();

        // pra cada registro sendo criado/atualizado, verifica se existe indisponibilidade no período
        for (Alocacao_Profissional__c aloc : Trigger.New) {
        
            //busca indisponibilidades pro registro atual do loop
            //se existe, adiciona erro ao registro
            //se não existe, salva na lista de registros a serem salvos
            List<Indisponibilidade__c> indispList = new List<Indisponibilidade__c>([
                SELECT Id, Profissional__r.Id
                FROM Indisponibilidade__c
                WHERE
                Profissional__c = :aloc.Profissional__c
                AND ((Data_Inicio__c <= :aloc.Data_Fim__c
                AND Data_Inicio__c >= :aloc.Data_Inicio__c)
                OR (Data_Fim__c <= :aloc.Data_Fim__c
                AND Data_Fim__c >= :aloc.Data_Inicio__c)
                OR (Data_Inicio__c <= :aloc.Data_Fim__c
                AND Data_Inicio__c >= :aloc.Data_Inicio__c)
                OR (Data_Inicio__c <= :aloc.Data_Inicio__c
                AND Data_Fim__c >= :aloc.Data_Fim__c))
            ]);

            if (indispList.size() > 0) { 
                // se há indisponibilidade
                // adiciona erro ao registro
                aloc.Data_Inicio__c.addError('O Profissional não pode ser alocado nestas datas pois está dentro de período de INDISPONIBILIDADE.');
            } else if (indispList.size() == 0) {
                // se não há indisponibilidade
                // OBS - acho que essa variavel não é necessária, o trigger faz um INSERT automaticamente se não há erro
                alocToAdd.add(aloc);
            }

            //---------calculo diasUteis ------------

            // adiciona valores para as horasAlocadas e diasAlocados levando em conta as businessHours (feriados e dias úteis) cadastradas na ORG
            Date dataInicioPeriodo = Date.valueOf(aloc.Data_Inicio__c);
            Date dataFimPeriodo = Date.valueOf(aloc.Data_Fim__c);
            
            //seleciona business hours da harpia que vamos usar
            BusinessHours bhPadrao = [SELECT Id FROM BusinessHours WHERE IsDefault=true];

            // calcula os dias alocados utilizando a funcao do helper de dias uteis
            Double diasAlocados = HelperDiasUteis.diasUteisNoPeriodo(dataInicioPeriodo, dataFimPeriodo);  

            // calcula os dias executados

            Double diasExecutados = 0 ;
            if (dataInicioPeriodo >= Date.today()) {
                // se a alocacao ainda nao foi iniciada, ou seja, data início é maior que hoje
                diasExecutados = 0 ;
            } else {
                // se a alocacao já foi iniciada
                if (dataFimPeriodo >= Date.today()) {
                    // se a alocacao está em andamento, calcula dias uteis entre o início da alocacao e hoje
                    diasExecutados = HelperDiasUteis.diasUteisNoPeriodo(dataInicioPeriodo, Date.today());
                } else {
                    // se o fim da alocacao já ocorreu, calcula dias uteis entre o início e o fim da alocacao
                    diasExecutados = HelperDiasUteis.diasUteisNoPeriodo(dataInicioPeriodo, dataFimPeriodo);
                }
            }

            // para a alocacao atual do loop, atualiza os campos com os valores calculados diasAlocados e diasExecutados
            aloc.Total_Dias_Trigger__c=diasAlocados;
            aloc.Dias_Executados_Trigger__c = diasExecutados;

        }
    }
}