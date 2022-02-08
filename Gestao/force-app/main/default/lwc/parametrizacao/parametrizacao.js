import { LightningElement } from "lwc";

export default class Parametrizacao extends LightningElement {
  modalAlocacao = false;

  handleClickAddAlocacao() {
    this.modalAlocacao = true;
  }

  handleClose() {
    this.modalAlocacao = false;
  }
}