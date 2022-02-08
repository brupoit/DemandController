public with sharing class helperHorasAlocadas {
  
    @AuraEnabled(Cacheable=true)
    public static Double horasAlocadasProfissional(String idProfissional, String strDataInicio, String strDataFim){
        
         // CONVERTER AS STRINGS QUE VIERAM COMO PARAMETRO EM DATA
         Date dataInicioPeriodo = Date.valueOf(strDataInicio);
         Date dataFimPeriodo = Date.valueOf(strDataFim);
         system.debug('dataInicioPeriodo: ' + dataInicioPeriodo);
         system.debug('dataFimPeriodo: ' + dataFimPeriodo);    

        List<Alocacao_Profissional__c> alocacoes = new List<Alocacao_Profissional__c>([
            SELECT Id, 
                Name, Data_Inicio__c, Data_Fim__c,
                Demanda__r.Name, Profissional__r.Name,
                Horas__c,Periodicidade__c, Total_De_Horas__c
            FROM Alocacao_Profissional__c
            WHERE (Profissional__c=:idProfissional 
                AND ((Data_Inicio__c<=:dataFimPeriodo AND Data_Inicio__c>=:dataInicioPeriodo) 
                OR (Data_Fim__c<=:dataFimPeriodo AND Data_Fim__c>=:dataInicioPeriodo) 
                OR (Data_Inicio__c<=:dataFimPeriodo AND Data_Inicio__c>=:dataInicioPeriodo)
                OR (Data_Inicio__c<=:dataInicioPeriodo AND Data_Fim__c>=:dataFimPeriodo ) ))
        ]);
        system.debug('queryResultAlocacoes: ' +  alocacoes);
        
        //SELECIONAR AS BUSINESSHOURS PADRAO
        BusinessHours bhPadrao = [SELECT Id FROM BusinessHours WHERE IsDefault=true];
               

        Double horasAlocadas=0;
        Double diasUteisNoPeriodo=0;
        Date compInicio;
        Date compFim;

        for (Alocacao_Profissional__c aloc : alocacoes){

            if(aloc.Periodicidade__c=='Diária'){
                //datas usadas para calcular o intervalo
                compInicio = aloc.Data_Inicio__c>=dataInicioPeriodo?aloc.Data_Inicio__c:dataInicioPeriodo;
                compFim = aloc.Data_Fim__c<=dataFimPeriodo?aloc.Data_Fim__c:dataFimPeriodo;
                system.debug('compInicio: ' + compInicio);
                system.debug('compFim: ' + compFim);

                if(compInicio==compFim){
                    diasUteisNoPeriodo=1;
                    System.debug('dias iguais, intervalo de 1 dia');
                } else{
                    diasUteisNoPeriodo = BusinessHours.diff(bhPadrao.id, compInicio, compFim)/(1000*60*60*9);
                    system.debug(BusinessHours.diff(bhPadrao.id, compInicio, compFim));
                    if(diasUteisNoPeriodo<=0){
                        diasUteisNoPeriodo=0;
                    }else{
                        Boolean isHoliday;
                        Date outDate = (BusinessHours.add(bhPadrao.id, compFim, 1)).date();
                        if(compFim == outDate){
                            isHoliday = false;
                        } else {
                            isHoliday = true;
                        }   

                        datetime dataConvertida = datetime.newInstance(compFim.year(), compFim.month(), compFim.day());
                        String diaSemana = dataConvertida.format('EEEE');
                        System.debug('diaSemana: ' + diaSemana);
                        if (diaSemana!='Saturday' && diaSemana!='Sunday' && !isHoliday){
                            system.debug('é semana');
                            diasUteisNoPeriodo=diasUteisNoPeriodo+1;
                        }
                    }
                }

                horasAlocadas=horasAlocadas + (aloc.Horas__c * diasUteisNoPeriodo);
                system.debug('diasUteisNoPeriodo: ' + diasUteisNoPeriodo);
            }
        }
        system.debug('horasAlocadas: ' + horasAlocadas);
        return horasAlocadas;
    }

    @AuraEnabled(Cacheable=true)
    public static Map<String,Double> horasAlocadasProfissional(List<Profissional__c> profissionais, String strDataInicio, String strDataFim){
        
        // CONVERTER AS STRINGS QUE VIERAM COMO PARAMETRO EM DATA
        Date dataInicioPeriodo = Date.valueOf(strDataInicio);
        Date dataFimPeriodo = Date.valueOf(strDataFim);
        // system.debug('dataInicioPeriodo: ' + dataInicioPeriodo);
        // system.debug('dataFimPeriodo: ' + dataFimPeriodo);    

        List<Alocacao_Profissional__c> alocacoes = new List<Alocacao_Profissional__c> ([
        SELECT 
        Id, Name,
        Data_Inicio__c, Data_Fim__c,
        Demanda__r.Name,
        Profissional__c,
        Profissional__r.Name,
        Profissional__r.Perfil_Profissional__r.Name,
        Horas_Por_Dia__c
        FROM Alocacao_Profissional__c
        WHERE 
            (Profissional__r.Id IN :profissionais
            AND 
            ((Data_Inicio__c<=:dataFimPeriodo AND Data_Inicio__c>=:dataInicioPeriodo) 
            OR (Data_Fim__c<=:dataFimPeriodo AND Data_Fim__c>=:dataInicioPeriodo) 
            OR (Data_Inicio__c<=:dataFimPeriodo AND Data_Inicio__c>=:dataInicioPeriodo)
            OR (Data_Inicio__c<=:dataInicioPeriodo AND Data_Fim__c>=:dataFimPeriodo )))
        ]);

        Map<String,Double> horasAlocadasPorProfissional = new Map<String,Double>();

        for (Alocacao_Profissional__c aloc : alocacoes){

            Date compInicio;
            Date compFim;
            compInicio = aloc.Data_Inicio__c>=dataInicioPeriodo?aloc.Data_Inicio__c:dataInicioPeriodo;
            compFim = aloc.Data_Fim__c<=dataFimPeriodo?aloc.Data_Fim__c:dataFimPeriodo;
            
            String idProfissional = aloc.Profissional__r.Id;
            String nomeProfissional = aloc.Profissional__r.Name;
            Double horasAdicionar =HelperDiasUteis.diasUteisNoPeriodo(compInicio,compFim)*aloc.Horas_Por_Dia__c;
            

            if (horasAlocadasPorProfissional.size()==0){
                horasAlocadasPorProfissional.put(idProfissional,horasAdicionar);
            } else {

                if (horasAlocadasPorProfissional.containsKey(idProfissional)){
                    Double horasAlocadas = horasAlocadasPorProfissional.get(idProfissional);
                    horasAlocadasPorProfissional.put(idProfissional,horasAlocadas+horasAdicionar);
                } else {
                    horasAlocadasPorProfissional.put(idProfissional,horasAdicionar);

                }
            }
        }
        
        // for (String key : horasAlocadasPorProfissional.keySet()) {
        //     System.debug('----Profissional: '+ key +' ----horas: ' +horasAlocadasPorProfissional.get(key));
        // }
        
        
        return horasAlocadasPorProfissional;
    }
}