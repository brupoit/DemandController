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

import { LightningElement, track } from "lwc";

const actions = [
  { label: "Show details", name: "show_details" },
  { label: "Delete", name: "delete" }
];

/* ------ Trata da Tabela de Cadastro de demandas ----------
  **
  ** Método:  componente tabela
  ** @input: - 
  ** @output: -
  ** @action: exibe informações das demandas cadastradas
  **  
  */
const columns = [
  { label: "Demanda", fieldName: "Demanda" },
  { label: "Cliente", fieldName: "Cliente" },
  { label: "Líder", fieldName: "Líder" },
  { label: "Estimativa", fieldName: "Estimativa", type: "number" },
  { label: "Horas Alocadas", fieldName: "Horas Alocadas", type: "number" },
  { label: "Horas Por Alocar", fieldName: "Horas Por Alocar", type: "number" },
  { label: "Horas Executadas", fieldName: "Horas Executadas", type: "number" },
  {
    type: "action",
    typeAttributes: { rowActions: actions }
  }
];

export default class CadastroDemanda extends LightningElement {
  @track isModalOpen = false;
  @track cadSemana = false;

  cadConsultor = false;
  cadAlocacao = false;

   /* ------ Trata dos métodos de ativação de cadastro ----------
  **
  ** Método: handleClickSemana(), handleClickConsultor(), handleClickAlocacao()
  ** @input: - 
  ** @output: -
  ** @action: ativam opções de cadastro: Semana, Consultor, Alocação Semanal 
  **  
  */
  handleClickSemana() {
    this.cadSemana = true;
  }

  handleClickConsultor() {
    this.cadConsultor = true;
  }

  handleClickAlocacao() {
    this.isModalOpen = true;
    this.cadAlocacao = true;
  }

//fecha os modais cadastro de semana, alocação e consultor
  handleClose() {
    this.isModalOpen = false;
    this.cadSemana = false;
    this.cadAlocacao = false;
    this.cadConsultor = false;
  }
  get options() {
    return [
      { label: "Selecione um valor", value: "none" },
      { label: "SIM", value: "sim" },
      { label: "NÃO", value: "nao" }
    ];
  }
  data = [];
  columns = columns;
  record = {};

 
  /* ------ Trata da Função de Cadastro Demanda ----------
  **
  ** Método:  connectedCallback() local
  ** @input:  -
  ** @output: -
  ** @action: Realiza uma conexão assíncrona com o banco de dados
  **          para a buscar os registros de Demandas
  */ 
  // eslint-disable-next-line @lwc/lwc/no-async-await
  async connectedCallback() {
    // eslint-disable-next-line no-undef
    this.data = await fetchDataHelper({ amountOfRecords: 100 });
  }

  
    /* ---- Trata de uma função de manipulação da Tabela de Dados em Demandas ----- /
  **
  ** Método:  handleRowAction() local
  ** @input:  event
  ** @output: -
  ** @action: Seleciona o registro e oferece opções de deletar ou exibir mais informações
  */

  handleRowAction(event) {
    const actionName = event.detail.action.name;
    const row = event.detail.row;
    switch (actionName) {
      case "delete":
        this.deleteRow(row);
        break;
      case "show_details":
        this.showRowDetails(row);
        break;
      default:
    }
  }

  deleteRow(row) {
    const { id } = row;
    const index = this.findRowIndexById(id);
    if (index !== -1) {
      this.data = this.data.slice(0, index).concat(this.data.slice(index + 1));
    }
  }

  findRowIndexById(id) {
    let ret = -1;
    this.data.some((row, index) => {
      if (row.id === id) {
        ret = index;
        return true;
      }
      return false;
    });
    return ret;
  }
  
  //Recebe a linha e mostra os detalhes
  showRowDetails(row) {
    this.record = row;
  }
}