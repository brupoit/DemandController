import { LightningElement } from 'lwc';
import {getNullOrRecordResult} from "c/helpers"
import getskillDem from '@salesforce/apex/skillDemandProfClass.getskillDem'

const columns = [
    { label: 'Profissional', fieldName: 'Profissional', type: 'text', sortable:true},
    { label: 'Skill', fieldName: 'Skill', type: 'text', sortable:true}
];

export default class SkillGest extends LightningElement {
    columns=columns;
    data;
    connectedCallback(){
    getskillDem().then(result=>{
          console.log('getskillDem retornou com sucesso');  
          console.log('resultado getskillDem: ',result);
          let treatedData=[];
          let addRow={};
          let parsedResult=JSON.parse(result);
          console.log('parsedResult: ',parsedResult);
          parsedResult.forEach((element)=>{
            addRow={};
            addRow.Profissional = getNullOrRecordResult(element.Profissional__r.Name);
            addRow.Skill = getNullOrRecordResult(element.Name);
            treatedData.push(addRow);
          });
          this.data=treatedData;
          console.log('treatedData: ',treatedData);
      })
      .catch(error=>{
          console.log('Error in getskillDem:',error);
      });
    }
}