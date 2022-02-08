import { LightningElement } from 'lwc';
import {getNullOrRecordResult} from "c/helpers"
import getSkillDemandaProfissional from '@salesforce/apex/skillDemandProfClass.getSkillDemandaProfissional'


const columns = [
    { label: 'Profissional', fieldName: 'InfoId', type: 'url', sortable:true ,
    typeAttributes:{
       label:{fieldName: 'Profissional'}
     }},
    { label: 'Skill', fieldName: 'Skill', type: 'text', sortable:true}
];

export default class Skills extends LightningElement {
    columns=columns;
    data;
    url = window.location.href.substring(0, window.location.href.indexOf('/lightning/'));
    connectedCallback(){
        getSkillDemandaProfissional().then(result=>{
          console.log('getSkillDemandaProfissional retornou com sucesso');  
          console.log('resultado getSkillDemandaProfissional: ',result);
          let treatedData=[];
          let addRow={};
          let parsedResult=JSON.parse(result);
          console.log('parsedResult: ',parsedResult);
          parsedResult.forEach((element)=>{
            addRow={};
            addRow.Profissional = getNullOrRecordResult(element.Profissional__r.Name);
            addRow.InfoId = this.url+'/'+element.idProfissional;
            addRow.Skill = getNullOrRecordResult(element.Name);
            treatedData.push(addRow);
          });
          this.data=treatedData;
          console.log('treatedData: ',treatedData);
      })
      .catch(error=>{
          console.log('Error in getSkillDemandaProfissional:',error);
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
      getSkillDemandaProfissional().then(result=>{
        console.log('getSkillDemandaProfissional retornou com sucesso');  
        console.log('resultado getSkillDemandaProfissional: ',result);
        let treatedData=[];
        let addRow={};
        let parsedResult=JSON.parse(result);
        console.log('parsedResult: ',parsedResult);
        parsedResult.forEach((element)=>{
          if (element) {
            this.inputInicialDate = new Date(this.componentInicialDate);
            this.inputFinalDate = new Date(this.componentFinalDate);
          addRow={};
          addRow.Profissional = getNullOrRecordResult(element.Profissional__r.Name);
          addRow.InfoId = this.url+'/'+element.idProfissional;
          addRow.Skill = getNullOrRecordResult(element.Name);
          treatedData.push(addRow);
          }
        });
        this.data=treatedData;
        console.log('treatedData: ',treatedData);
    })
    .catch(error=>{
        console.log('Error in getSkillDemandaProfissional:',error);
    });
      
  }
}