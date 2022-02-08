public with sharing class HelperDiasUteis {
    
    public static Double diasUteisNoPeriodo(Date dataInicioPeriodo, Date dataFimPeriodo) {
        

        // system.debug('dataInicioPeriodo: ' + dataInicioPeriodo);
        // system.debug('dataFimPeriodo: ' + dataFimPeriodo);  
        
        //SELECIONAR AS BUSINESSHOURS PADRAO
        BusinessHours bhPadrao = [SELECT Id FROM BusinessHours WHERE IsDefault=true];

        Double diasUteisNoPeriodo;
        if(dataInicioPeriodo==dataFimPeriodo){
            diasUteisNoPeriodo=1;
            // System.debug('dias iguais, intervalo de 1 dia');
        } else{
            diasUteisNoPeriodo = BusinessHours.diff(bhPadrao.id, dataInicioPeriodo, dataFimPeriodo)/(1000*60*60*9);
            // System.debug(BusinessHours.diff(bhPadrao.id, dataInicioPeriodo, dataFimPeriodo));
            if(diasUteisNoPeriodo<=0){
                diasUteisNoPeriodo=0;
            }else{
                Boolean isHoliday;
                Date outDate = (BusinessHours.add(bhPadrao.id, dataFimPeriodo, 1)).date();
                if(dataFimPeriodo == outDate){
                    isHoliday = false;
                } else {
                    isHoliday = true;
                }   

                datetime dataConvertida = datetime.newInstance(dataFimPeriodo.year(), dataFimPeriodo.month(), dataFimPeriodo.day());
                String diaSemana = dataConvertida.format('EEEE');
                // System.debug('diaSemana: ' + diaSemana);
                if (diaSemana!='Saturday' && diaSemana!='Sunday' && !isHoliday){
                    // System.debug('é semana');
                    diasUteisNoPeriodo=diasUteisNoPeriodo+1;
                }
            }
        }

        // System.debug('diasUteisNoPeriodo: '+diasUteisNoPeriodo);
        return diasUteisNoPeriodo;
    }
}