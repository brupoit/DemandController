/* --------- Copyright 2022 Harpia Cloud ---------------
**
** Licensed under the Apache License, Version 2.0 (the "License");
** you may not use this file except in compliance with the License.
** You may obtain a copy of the License at
**
**     http://www.apache.org/licenses/LICENSE-2.0
**
** Unless required by applicable law or agreed to in writing, software
** distributed under the License is distributed on an "AS IS" BASIS,
** WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
** See the License for the specific language governing permissions and
** limitations under the License.
-------------------------------------------------------- */
import { LightningElement, api } from "lwc";
import EXPERTISE from "@salesforce/schema/Employee__c.Expertise__c";
import STATUS from "@salesforce/schema/Employee__c.Consultor_Disponivel__c";
import cadastrarConsultor from "@salesforce/apex/CadastroConsultor.cadastrarConsultor";
import { ShowToastEvent } from "lightning/platformShowToastEvent";

/* ------ Trata do Formulário de Cadastro do Consultor ----------
  **
  ** Método:  Componente Class CadastroConsultor
  ** @input:   -
  ** @output:  -
  ** @action:  Informações sobre os dados para realizar o cadastro de um consultor
  */
export default class CadastroConsultor extends LightningElement {    
  expertise = EXPERTISE;
  status = STATUS;
  @api recordId;
  @api objectApiName;
  nameExpertise;
  nameStatus;
  nameConsultor;
  horas;

  /* ------ Trata do Formulário de Cadastro do Consultor ----------
  **
  ** Método:  handleExpertise(event)
  ** @input:   event
  ** @output:  -
  ** @action:  método dos campos de input do Formulário de Cadastro do Consultor, retorna o elemento que acionou o evento
  */
  handleExpertise(event) {
    this.nameExpertise = event.target.value;
  }

  handleStatus(event) {
    this.nameStatus = event.target.value;
  }
  handleHoras(event) {
    this.horas = event.target.value;
  }
  handleConsultor(event) {
    this.nameConsultor = event.target.value;
  }

   /* ------ Trata da função do Botão OK do formulário ----------
  **
  ** Método:   handleOk() local
  ** @input:  - 
  ** @output:  -
  ** @action:  Envia os dados inseridos para o banco de dados,
  **           verifica os atributos e dá um retorno de sucesso ou fracassou no cadastro do consultor     
  */
  handleOk() {
    cadastrarConsultor({
      nome: this.nameConsultor,
      expertise: this.nameExpertise,
      horas: this.horas,
      status: this.nameStatus
    })
      .then((result) => {
        const event = new ShowToastEvent({
          title: "Sucesso",
          message: "Consultor cadastrado com sucesso!", 
          variant: "success",
          mode: "dismissable"
        });
        console.log("sucesso", result);
        this.dispatchEvent(event);
        this.dispatchEvent(new CustomEvent("close"));
        this.handleClose();
      })
      .catch((error) => {
        const event = new ShowToastEvent({
          title: "Erro ao cadastrar",
          message: "Houve uma falha ao cadastraro consultor",
          variant: "error",
          mode: "dismissable"
        });
        console.log("erro", error);
        console.log("event", event);
      });
  }
//Evento para fechar
  handleClose() {
    this.dispatchEvent(new CustomEvent("close"));
  }
}