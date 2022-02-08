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

import { LightningElement } from "lwc";
import { ShowToastEvent } from "lightning/platformShowToastEvent";

/* ------ Trata de um componente de visualização ModalCadastroIndisponibilidade ----------
    **
    ** Método:  componente class
    ** @input:  Event
    ** @output: -
    ** @action: Exibe uma mensagem de sucesso da Indisponibilidade Criada
    */ 
export default class ModalCadastroIndisponibilidade extends LightningElement {
  handleSuccess(event) {
    console.log(JSON.stringify(event.detail.fields.Name.value));
    const evt = new ShowToastEvent({
      title: "Indisponibilidade Criada",
      message:
        "Record ID: " +
        event.detail.id +
        ". Indisponibilidade: " +
        event.detail.fields.Name.value +
        " foi criado.",
      variant: "success"
    });
    this.dispatchEvent(evt);
  }

  handleClose() {
    this.dispatchEvent(new CustomEvent("close"));
  }
}