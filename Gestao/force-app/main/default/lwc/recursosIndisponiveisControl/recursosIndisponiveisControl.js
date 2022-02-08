import { LightningElement } from "lwc";
import getAllProfissionalComDadosDeHoras from '@salesforce/apex/ProfissionalController.getAllProfissionalComDadosDeHoras'
import {getNullOrRecordResult} from "c/helpers"

const columns = [
  { label: 'Nome', fieldName: 'InfoId', type: 'url', sortable:true ,
    typeAttributes:{
       label:{fieldName: 'nome'}
     }},
     { label: 'Perfil', fieldName: 'PerfilId', type: 'url', sortable:true ,
     typeAttributes: {
   label:{fieldName: 'perfil'}
 }},
  { label: 'Horas Indisponiveis', fieldName: 'HorasIndisponiveis', type:'number', sortable:true}
];

export default class RecursosIndisponiveisControl extends LightningElement {
  columns=columns;
    data;
    url = window.location.href.substring(0, window.location.href.indexOf('/lightning/'));
    connectedCallback(){
      getAllProfissionalComDadosDeHoras({strDataInicio:'2021-12-01',strDataFim:'2021-12-31'}).then(result=>{
        console.log('getAllProfissionalComDadosDeHoras retornou com sucesso');  
        console.log('resultado getAllProfissionalComDadosDeHoras: ',result);
        let treatedData=[];
        let addRow={};
        let parsedResult=JSON.parse(result);
        console.log('parsedResult: ',parsedResult);
        parsedResult.forEach((element)=>{
          if(element.horasIndisponiveis > 0){
          addRow={};
          addRow.nome = getNullOrRecordResult(element.nomeProfissional);
          addRow.InfoId = this.url+'/'+element.idProfissional;
          addRow.perfil = getNullOrRecordResult(element.nomePerfilProfissional);
          addRow.PerfilId = this.url+'/'+element.idPerfil;
          addRow.HorasIndisponiveis = getNullOrRecordResult(element.horasIndisponiveis);
          treatedData.push(addRow);
          }
        });
        this.data=treatedData;
        console.log('treatedData: ',treatedData);
    })
    .catch(error=>{
        console.log('Error in getAllProfissionalComDadosDeHoras:',error);
    });
};
    handleClickDatePicker() {
      let startDate = this.template.querySelector(".startDate");
      let endDate = this.template.querySelector(".endDate");
      if (startDate.value.indexOf("T") <= -1) {
        startDate.value = startDate.value + "T00:01:00";
      }
      if (endDate.value.indexOf("T") <= -1) {
        endDate.value = endDate.value + "T23:59:00";
      }
      this.componentInicialDate = startDate.value;
      this.componentFinallDate = endDate.value;

      let params = {
        data: [this.componentInicialDate, this.componentFinallDate]
      };
      getAllProfissionalComDadosDeHoras({strDataInicio:this.componentInicialDate,strDataFim:this.componentFinallDate}).then(result=>{
        console.log('getAllProfissionalComDadosDeHoras retornou com sucesso');  
        console.log('resultado getAllProfissionalComDadosDeHoras: ',result);
        let treatedData=[];
        let addRow={};
        let parsedResult=JSON.parse(result);
        console.log('parsedResult: ',parsedResult);
        parsedResult.forEach((element)=>{
          if(element.horasIndisponiveis > 0){
            if (element) {
              this.inputInicialDate = new Date(this.componentInicialDate);
              this.inputFinalDate = new Date(this.componentFinalDate);
          addRow={};
          addRow.nome = getNullOrRecordResult(element.nomeProfissional);
          addRow.InfoId = this.url+'/'+element.idProfissional;
          addRow.perfil = getNullOrRecordResult(element.nomePerfilProfissional);
          addRow.PerfilId = this.url+'/'+element.idPerfil;
          addRow.HorasIndisponiveis = getNullOrRecordResult(element.horasIndisponiveis);
          treatedData.push(addRow);
          }
        }
        });
        this.data=treatedData;
        console.log('treatedData: ',treatedData);
    })
  }
}