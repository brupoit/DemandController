import { LightningElement } from 'lwc';
import {getNullOrRecordResult,getDefaultAllocationDateRange,getProjectResourceActivity,getColumnsByDateRange} from "c/helpers";
import getMapaAlocacao from "@salesforce/apex/AlocacaoProfissionalController.getMapaAlocacao";

const columns = [
    { label: 'Horas Disponíveis Totais', fieldName: 'disptotal', type: 'text', sortable:true},
    { label: 'Horas Alocadas Totais', fieldName: 'aloctotal', type: 'text', sortable:true},
  ];
  
export default class TesteTabelaCapacity extends LightningElement {

    columns=columns;
    data;
    datasum = {horasCapacity: 0, disptotal:0, aloctotal:0};

    connectedCallback(){

    
      
let dataparcial = [];
let tableColumns = [
  {
    label: "Perfil Profissional",
    fieldName: "perfilprofissional",
    type: "text",
    sortable: true
  },
  {
    label: "Total de Horas",
    fieldName: "totalhoras",
    type: "text",
    sortable: true
  }
];

let params = {
      dateRange: ['2021-07-01T13:01:00','2021-12-31T13:01:00']
    };
      getMapaAlocacao(params).then(result=>{
        let test = getProjectResourceActivity(result);
        result.forEach((linha) => {
          let perfilprof = linha.Profissional__r.Perfil_Profissional__r.Name;
          let verif = getColumnsByDateRange(new Date(linha.Data_Inicio__c + 'T13:01:00'), new Date(linha.Data_Fim__c + 'T13:01:00'),tableColumns,test,'demanda');
          
         
      
          if(!dataparcial[perfilprof] === undefined){
            dataparcial[perfilprof] = [];
         }
          for(let d = new Date(linha.Data_Inicio__c+ 'T13:01:00'); d <= new Date(linha.Data_Fim__c+ 'T13:01:00'); d.setDate(d.getDate() + 1)){
            console.log (d);
            console.log(perfilprof);
            console.log (dataparcial);

            if(dataparcial[perfilprof].lengh > 0 ){
              dataparcial[perfilprof][d.getTime()] = dataparcial[perfilprof][d.getTime()] + 8;
  
            } else {
              
              dataparcial[perfilprof][d.getTime()] = 8;
  
            } 
            
         }
          console.log (linha)
        });
        console.log (dataparcial);
        })
    };

}