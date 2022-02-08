public with sharing class HelperHorasCapacity {

    @AuraEnabled(Cacheable=true)
    public static Double HorasCapacityProfissional(String idProfissional, String strDataInicio, String strDataFim){
        
        // CONVERTER AS STRINGS QUE VIERAM COMO PARAMETRO EM DATA
        Date dataInicioPeriodo = Date.valueOf(strDataInicio);
        Date dataFimPeriodo = Date.valueOf(strDataFim);
        // System.debug('dataInicioPeriodo: ' + dataInicioPeriodo);
        // System.debug('dataFimPeriodo: ' + dataFimPeriodo);    
        
        
        
        List<Profissional__c> profissionais = new List<Profissional__c>([
            SELECT Id, Name, Inicio_Contrato__c, Perfil_Profissional__r.Name, Perfil_Profissional__r.Carga_Horaria_Por_Dia__c
            FROM Profissional__c
            WHERE Id=:idProfissional
        ]);
        // System.debug('profissionaisCapacity:' + profissionais);

        //SELECIONAR AS BUSINESSHOURS PADRAO
        BusinessHours bhPadrao = [SELECT Id FROM BusinessHours WHERE IsDefault=true];
               

        Double horasCapacity=0;
        Double diasUteisNoPeriodo=0;
        Date compInicio;
        Date compFinal;

        for (Profissional__c prof : profissionais){
            if(prof.Inicio_Contrato__c>=dataInicioPeriodo){
                compInicio=prof.Inicio_Contrato__c;
                compFinal=dataFimPeriodo;
            } else if (prof.Inicio_Contrato__c>=dataFimPeriodo){
                horasCapacity=0;
                return horasCapacity;
            } else {
                compInicio=dataInicioPeriodo;
                compFinal=dataFimPeriodo;
            }

            if(compInicio==compFinal){
                diasUteisNoPeriodo=1;
                // System.debug('é igual');
            } else{
                // System.debug('compInicio: ' + compInicio);
                // System.debug('compFinal: ' + compFinal);
                diasUteisNoPeriodo = BusinessHours.diff(bhPadrao.id, compInicio, compFinal)/(1000*60*60*9);
                // System.debug(BusinessHours.diff(bhPadrao.id, compInicio, compFinal));
                if(diasUteisNoPeriodo<=0){
                    diasUteisNoPeriodo=0;
                }else{
                    Boolean isHoliday;
                    Date outDate = (BusinessHours.add(bhPadrao.id, compFinal, 1)).date();
                    if(compFinal == outDate){
                        isHoliday = false;
                    } else {
                        isHoliday = true;
                    }   

                    datetime dataConvertida = datetime.newInstance(compFinal.year(), compFinal.month(), compFinal.day());
                    String diaSemana = dataConvertida.format('EEEE');
                    // System.debug('diaSemana: ' + diaSemana);
                    if (diaSemana!='Saturday' && diaSemana!='Sunday' && !isHoliday){
                        // System.debug('é semana');
                        diasUteisNoPeriodo=diasUteisNoPeriodo+1;
                    }
                }
            }
            // System.debug('cargaDia: ' + prof.Perfil_Profissional__r.Carga_Horaria_Por_Dia__c );
            horasCapacity=prof.Perfil_Profissional__r.Carga_Horaria_Por_Dia__c * diasUteisNoPeriodo;
            // System.debug('diasUteisNoPeriodo: ' + diasUteisNoPeriodo);
        }
        // }
        // System.debug('horasCapacity: ' + horasCapacity);
        return horasCapacity;
    }

    @AuraEnabled(Cacheable=true)
    public static Map<String,Double> HorasCapacityProfissional(List<Profissional__c> profissionaisSelecionados, String strDataInicio, String strDataFim){
        
        // CONVERTER AS STRINGS QUE VIERAM COMO PARAMETRO EM DATA
        Date dataInicioPeriodo = Date.valueOf(strDataInicio);
        Date dataFimPeriodo = Date.valueOf(strDataFim);   
        
        //BUSCAR PROFISSIONAIS NA lista profissionais recebida        
        List<Profissional__c> profissionais = new List<Profissional__c>([
            SELECT Id, Name, Inicio_Contrato__c, Perfil_Profissional__r.Name, Perfil_Profissional__r.Carga_Horaria_Por_Dia__c
            FROM Profissional__c
            WHERE Id IN :profissionaisSelecionados
        ]);
        // System.debug('profissionaisCapacity:' + profissionais);

        Map<String,Double> capacityPorProfissional = new Map<String,Double>();

        for (Profissional__c prof : profissionais){

            Date compInicio;
            Date compFim;
            Double horasAdicionar;

            if(prof.Inicio_Contrato__c>=dataInicioPeriodo){
                compInicio=prof.Inicio_Contrato__c;
                compFim=dataFimPeriodo;
                horasAdicionar =HelperDiasUteis.diasUteisNoPeriodo(compInicio,compFim)*prof.Perfil_Profissional__r.Carga_Horaria_Por_Dia__c;
            } else if (prof.Inicio_Contrato__c>=dataFimPeriodo){
                horasAdicionar=0;
            } else {
                compInicio=dataInicioPeriodo;
                compFim=dataFimPeriodo;
                horasAdicionar =HelperDiasUteis.diasUteisNoPeriodo(compInicio,compFim)*prof.Perfil_Profissional__r.Carga_Horaria_Por_Dia__c;
            
            }

            String idProfissional = prof.Id;
            String nomeProfissional = prof.Name;
           

            if (capacityPorProfissional.size()==0){
                capacityPorProfissional.put(idProfissional,horasAdicionar);
            } else {

                if (capacityPorProfissional.containsKey(idProfissional)){
                    Double horasCapacity = capacityPorProfissional.get(idProfissional);
                    capacityPorProfissional.put(idProfissional,horasCapacity+horasAdicionar);
                } else {
                    capacityPorProfissional.put(idProfissional,horasAdicionar);

                }
            }
        }

        // for (String key : capacityPorProfissional.keySet()){
        //     System.debug('Id: ' + key + ' - Horas: ' + capacityPorProfissional.get(key));
        // }

       return capacityPorProfissional ;
    }
}