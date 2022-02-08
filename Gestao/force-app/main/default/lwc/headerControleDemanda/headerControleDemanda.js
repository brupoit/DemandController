import { LightningElement, track } from "lwc";
import getAllProfissionalComDadosDeHoras from '@salesforce/apex/ProfissionalController.getAllProfissionalComDadosDeHoras'

export default class CadastroDemanda extends LightningElement {
  @track isModalOpen = false;
  cadProfissional = false;
  cadDemanda = false;
  cadPerfil = false;

  handleClickProfissional() {
    this.cadProfissional = true;
  }

  handleClickDemanda() {
    this.cadDemanda = true;
  }

  handleClickPerfil() {
    this.cadPerfil = true;
  }

  handleClose() {
    this.cadProfissional = false;
    this.cadDemanda = false;
    this.cadPerfil = false;
  }

  connectedCallback(){
        
    getAllProfissionalComDadosDeHoras({strDataInicio:'2021-12-01',strDataFim:'2021-12-31'}).then(result=>{
        console.log('getAllProfissionalComDadosDeHoras retornou com sucesso');  
        console.log(JSON.parse(result));
    })
    .catch(error=>{
        console.log('Error in getAllProfissionalComDadosDeHoras:',error);
    });

};
}