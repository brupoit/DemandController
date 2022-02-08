public with sharing class HelperHorasIndisponibilidade {

    @AuraEnabled(Cacheable=true)
    public static Double HorasIndisponibilidadeProfissional(String idProfissional){
        //SELECT PROFISSIONAL
        List<Indisponibilidade__c> indisponibilidades = new List<Indisponibilidade__c>([
            SELECT Id, Name, Data_Inicio__c, Data_Fim__c, Profissional__r.Name, Profissional__r.Perfil_Profissional__r.Carga_Horaria_Por_Dia__c
            FROM Indisponibilidade__c
            WHERE Profissional__c=:idProfissional
        ]);

        //SELECIONAR AS BUSINESSHOURS PADRAO
        BusinessHours bhPadrao = [SELECT Id FROM BusinessHours WHERE IsDefault=true];

        Double somaHorasIndisponiveis=0;

        for (Indisponibilidade__c indisp : indisponibilidades){
            Double diasUteisNoPeriodo = BusinessHours.diff(bhPadrao.id, indisp.Data_Inicio__c, indisp.Data_Fim__c)/(1000*60*60*9)+1;
            Double horasProf=(indisp.Profissional__r.Perfil_Profissional__r.Carga_Horaria_Por_Dia__c*diasUteisNoPeriodo);
            somaHorasIndisponiveis=somaHorasIndisponiveis+horasProf;
            system.debug('-----indisp: ' + indisp.Profissional__r.Name);
            system.debug('cargaHorariaDiaria: '+indisp.Profissional__r.Perfil_Profissional__r.Carga_Horaria_Por_Dia__c);
            system.debug('diasUteisNoPeriodo: ' + diasUteisNoPeriodo);
            system.debug('horasProf: ' + horasProf);
            system.debug('somaHorasIndisponiveis: ' + somaHorasIndisponiveis);

        }
        system.debug('somaHorasIndisponiveisFinal: ' + somaHorasIndisponiveis);
        
        return somaHorasIndisponiveis;
    }

    @AuraEnabled(Cacheable=true)
    public static Double HorasIndisponibilidadeProfissional(String idProfissional, String strDataInicio, String strDataFim){
        
        Date dataInicio = Date.valueOf(strDataInicio);
        Date dataFim = Date.valueOf(strDataFim);
        system.debug('dataInicio:' + dataInicio);
        system.debug('dataFim:' + dataFim);

        List<Indisponibilidade__c> indisponibilidades = new List<Indisponibilidade__c>([
            SELECT Id, Name, Data_Inicio__c, Data_Fim__c, Profissional__r.Name, Profissional__r.Perfil_Profissional__r.Carga_Horaria_Por_Dia__c
            FROM Indisponibilidade__c
            WHERE (Profissional__c=:idProfissional 
                AND ((Data_Inicio__c<=:dataFim AND Data_Inicio__c>=:dataInicio) 
                OR (Data_Fim__c<=:dataFim AND Data_Fim__c>=:dataInicio) 
                OR (Data_Inicio__c<=:dataFim AND Data_Inicio__c>=:dataInicio)
                OR (Data_Inicio__c<=:dataInicio AND Data_Fim__c>=:dataFim ) ))
        ]);
        system.debug('queryResultIndisponibilidade: ' +  indisponibilidades);
        //SELECIONAR AS BUSINESSHOURS PADRAO
        BusinessHours bhPadrao = [SELECT Id FROM BusinessHours WHERE IsDefault=true];

        Double somaHorasIndisponiveis=0;
        Date dataInicioIntervalo;
        Date dataFimIntervalo;

        for (Indisponibilidade__c indisp : indisponibilidades){
            
            dataInicioIntervalo = indisp.Data_Inicio__c>=dataInicio? indisp.Data_Inicio__c :dataInicio;
            dataFimIntervalo = indisp.Data_Fim__c<=dataFim? indisp.Data_Fim__c :dataFim;
            
            Double diasUteisNoPeriodo = BusinessHours.diff(bhPadrao.id, dataInicioIntervalo, dataFimIntervalo)/(1000*60*60*9)+1;
            Double horasProf=(indisp.Profissional__r.Perfil_Profissional__r.Carga_Horaria_Por_Dia__c*diasUteisNoPeriodo);
            
            somaHorasIndisponiveis=somaHorasIndisponiveis+horasProf;
            
            system.debug('-----indisp: ' + indisp.Profissional__r.Name);
            system.debug('cargaHorariaDiaria: '+indisp.Profissional__r.Perfil_Profissional__r.Carga_Horaria_Por_Dia__c);
            system.debug('diasUteisNoPeriodo: ' + diasUteisNoPeriodo);
            system.debug('horasProf: ' + horasProf);
            system.debug('somaHorasIndisponiveis: ' + somaHorasIndisponiveis);

        }
        system.debug('somaHorasIndisponiveisFinal: ' + somaHorasIndisponiveis);
        
        return somaHorasIndisponiveis;
    }

    public static Map<String,Double> HorasIndisponibilidadeProfissional(List<Profissional__c> profissionais, String strDataInicio, String strDataFim){
        
        Date dataInicioPeriodo = Date.valueOf(strDataInicio);
        Date dataFimPeriodo = Date.valueOf(strDataFim);    

        List<Indisponibilidade__c> indisponibilidades = new List<Indisponibilidade__c> ([
            SELECT 
                Id, Name, 
                Data_Inicio__c, Data_Fim__c,
                Profissional__r.Name, 
                Profissional__r.Perfil_Profissional__r.Carga_Horaria_Por_Dia__c
            FROM Indisponibilidade__c
            WHERE 
                (Profissional__r.Id IN :profissionais
                AND 
                ((Data_Inicio__c<=:dataFimPeriodo AND Data_Inicio__c>=:dataInicioPeriodo) 
                OR (Data_Fim__c<=:dataFimPeriodo AND Data_Fim__c>=:dataInicioPeriodo) 
                OR (Data_Inicio__c<=:dataFimPeriodo AND Data_Inicio__c>=:dataInicioPeriodo)
                OR (Data_Inicio__c<=:dataInicioPeriodo AND Data_Fim__c>=:dataFimPeriodo )))
        ]);

        Map<String,Double> horasIndisponiveisPorProfissional = new Map<String,Double>();

        for (Indisponibilidade__c indisp : indisponibilidades){

            Date compInicio;
            Date compFim;
            compInicio = indisp.Data_Inicio__c>=dataInicioPeriodo?indisp.Data_Inicio__c:dataInicioPeriodo;
            compFim = indisp.Data_Fim__c<=dataFimPeriodo?indisp.Data_Fim__c:dataFimPeriodo;
            
            String idProfissional = indisp.Profissional__r.Id;
            String nomeProfissional = indisp.Profissional__r.Name;
            Double horasAdicionar =HelperDiasUteis.diasUteisNoPeriodo(compInicio,compFim)*indisp.Profissional__r.Perfil_Profissional__r.Carga_Horaria_Por_Dia__c;
            

            if (horasIndisponiveisPorProfissional.size()==0){
                horasIndisponiveisPorProfissional.put(idProfissional,horasAdicionar);
            } else {

                if (horasIndisponiveisPorProfissional.containsKey(idProfissional)){
                    Double horasIndisponiveis = horasIndisponiveisPorProfissional.get(idProfissional);
                    horasIndisponiveisPorProfissional.put(idProfissional,horasIndisponiveis+horasAdicionar);
                } else {
                    horasIndisponiveisPorProfissional.put(idProfissional,horasAdicionar);

                }
            }
        }
       return horasIndisponiveisPorProfissional ;
    }    
}