import { LightningElement } from 'lwc';
import getIndispo from '@salesforce/apex/ProfessionalProfile.getIndispo';

const columns = [
    { label: 'Nome', fieldName: 'nome', type: 'text', sortable:true},
    {label: 'Periodicidade', fieldName: 'periodicidade', type: 'number'}
 ];

export default class PerfisIndispo extends LightningElement {
    columns=columns;
    data;

    connectedCallback(){

        getIndispo().then(result=>{
            console.log('getIndispo retornou com sucesso'); 
            console.log('resultado getIndispo: ',result);

            let treatedData=[];
            let addRow={};
            let parsedResult=JSON.parse(result);
            console.log('parsedResult: ',parsedResult);

            parsedResult.forEach((element)=>{
            addRow={};
            element.Name===undefined? "" : addRow.nome=element.Name;
            element.Periodicidade__c===undefined? "" : addRow.periodicidade=element.Periodicidade__c;
                treatedData.push(addRow);
            });
            this.data=treatedData;
            console.log('treatedData: ',treatedData);
            
        })
        .catch(error=>{
            console.log('Error in getIndispo:',error);
        });

    };

}