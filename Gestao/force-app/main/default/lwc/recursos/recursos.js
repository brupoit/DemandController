import { LightningElement, track } from "lwc";
import getDefaultAllocationDateRange from "@salesforce/apex/AlocacaoProfissionalController.getDefaultAllocationDateRange";

export default class Recursos extends LightningElement {
  modalProfissional = false;
  modalAlocacao = false;
  modalIndisponibilidade = false;

  @track componentInicialDate;
  @track componentFinalDate;

  getDefaultAllocationDateRange() {

  getDefaultAllocationDateRange()
      .then((result) => {
        //console.log(result);
        this.componentInicialDate = result[0];
        this.componentFinalDate = result[1];
        this.optionsType = this.template.querySelector(".optionsType");
        //that.handleClickDatePicker();
      })
      .catch((error) => {
        console.log(error);
      });
  }

  renderedCallback(){
    this.getDefaultAllocationDateRange();
  }

  handleClickAddProfissional() {
    this.modalProfissional = true;
  }
  handleClickAddAlocacao() {
    this.modalAlocacao = true;
  }
  handleClickAddIndisponibilidade() {
    this.modalIndisponibilidade = true;
  }


  handleClose() {
    this.modalProfissional = false;
    this.modalAlocacao = false;
    this.modalIndisponibilidade = false;
  }
}