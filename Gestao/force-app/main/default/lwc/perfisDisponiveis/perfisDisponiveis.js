import { LightningElement } from 'lwc';
import getProfessionalProfile from '@salesforce/apex/ProfessionalProfile.getProfessionalProfile';

const columns = [
    { label: 'Nome', fieldName: 'nome', type: 'text', sortable:true},
    { label: 'Carga Horária', fieldName: 'cargahoraria', type: 'text', sortable:true},
    { label: 'Periodicidade', fieldName: 'Periodicidade', type:'text'}
];

export default class perfisDisponiveis extends LightningElement {
    columns=columns;
    data;

    connectedCallback(){

        getProfessionalProfile().then(result=>{
            console.log('getProfessionalProfile retornou com sucesso');  
            console.log('resultado getProfessionalProfile: ',result);

            let treatedData=[];
            let addRow={};
            let parsedResult=JSON.parse(result);
            console.log('parsedResult: ',parsedResult);

            parsedResult.forEach((element)=>{
            addRow={};
            element.Name===undefined? "" : addRow.nome=element.Name;
            element.Carga_Horaria__c===undefined? "" : addRow.cargahoraria=element.Carga_Horaria__c;
            element.Periodicidade__c===undefined? "" : addRow.Periodicidade=element.Periodicidade__c;
                treatedData.push(addRow);
            });
            this.data=treatedData;
            console.log('treatedData: ',treatedData);
            
        })
        .catch(error=>{
            console.log('Error in getProfessionalProfile:',error);
        });

    };

}