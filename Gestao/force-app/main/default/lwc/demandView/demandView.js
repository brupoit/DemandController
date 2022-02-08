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
import getDemandas from "@salesforce/apex/DemandaController.getDemandas";
import { getNullOrRecordResult } from "c/helpers";
import getDefaultAllocationDateRange  from "@salesforce/apex/AlocacaoProfissionalController.getDefaultAllocationDateRange";

/* ------ Trata da Tabela de Cadastro de demandas ----------
  **
  ** Método:  componente tabela
  ** @input: - 
  ** @output: -
  ** @action: exibe informações das demandas cadastradas
  **  
  */
const columns = [
  { label: "Demanda", fieldName: "demandaid", type: "url",
    typeAttributes:{
      label:{fieldName: 'demanda'}
    }},
  { label: "Cliente", fieldName: "clienteid", type: "url",
  typeAttributes:{
    label:{fieldName: 'cliente'}
  }},
  { label: "Líder", fieldName: "liderid", type: "url", 
  typeAttributes:{
    label:{fieldName: 'lider'}
  }},
  {
    label: "Estimativa",
    fieldName: "estimativa",
    type: "number",
    sortable: true
  },
  {
    label: "Horas Por Alocar",
    fieldName: "horasPorAlocar",
    type: "number",
    sortable: true
  },
  {
    label: "Horas Alocadas",
    fieldName: "horasAlocadas",
    type: "number",
    sortable: true
  },
  {
    label: "Horas Executadas",
    fieldName: "horasExecutadas",
    type: "number",
    sortable: true
  }
];

//
export default class DemandView extends LightningElement {
  modalAlocacao = false;
  cadDemanda = false;
  columns = columns;
  data;
  url = window.location.href.substring(0, window.location.href.indexOf('/lightning/'));
  /* ------ Trata de --------
  **
  ** Método: connectedCallback() local
  ** @input: -
  ** @output: -
  ** @action: busca demandas cadastradas na base de dados
  **    
  */
  getDefaultAllocationDateRange() {
    
    getDefaultAllocationDateRange()
      .then((result) => {
        
        this.componentInicialDate = result[0];
        this.componentFinalDate = result[1];
        
       // let params = {
      //    dateRange: [result[0], result[1]]
      //  };

       let params = {
          dateRange: ['2021-07-01T00:00:00', '2021-12-01T23:00:00']
        };
    
        this.getInicialData(params);
        this.hasRendered = true;
   
      })
      .catch((error) => {
        console.log(error);
        this.hasRendered = true;
      });
  }
   getInicialData(params){
    getDemandas(params)
    .then((result) => {
      let treatedData = [];
      let addRow = {};
      let parsedResult = JSON.parse(result);
      console.log("parsedResult: ", parsedResult);
      parsedResult.forEach((element) => {
        addRow = {};
        addRow.demanda = getNullOrRecordResult(element.Name);
        addRow.demandaid =  this.url+'/'+element.Id;
        addRow.cliente = getNullOrRecordResult(element.Conta__r.Name);
        addRow.clienteid = this.url+'/'+element.Conta__r.Id;
        addRow.lider = getNullOrRecordResult(element.Lider__r.Name);
        addRow.liderid =  this.url+'/'+element.Lider__r.Id;
        console.log(element);
        addRow.estimativa = getNullOrRecordResult(
          element.Estimativa_Horas__c
        );
        addRow.horasAlocadas = getNullOrRecordResult(
          element.Horas_Alocadas__c
        );
        addRow.horasExecutadas = getNullOrRecordResult(
          element.Horas_Executadas__c
        );
        addRow.horasPorAlocar = getNullOrRecordResult(
          element.Horas_Por_Alocar__c
        );
        treatedData.push(addRow);
      });
      this.data = treatedData;
    })
    .catch((error) => {
      console.log("Error in getDemandas:", error);
    });
   }

  connectedCallback() {
    this.getDefaultAllocationDateRange();
  }

  //-------------- HANDLE SORT-------------------------
  onHandleSort(event) {
    this.sortBy = event.detail.fieldName;
    this.sortDirection = event.detail.sortDirection;
    this.sortAccountData(event.detail.fieldName, event.detail.sortDirection);
  }

  sortAccountData(fieldname, direction) {
    let parseData = JSON.parse(JSON.stringify(this.data));
    let keyValue = (a) => {
      return a[fieldname];
    };

    let isReverse = direction === "asc" ? 1 : -1;
    parseData.sort((x, y) => {
      x = keyValue(x) ? keyValue(x) : "";
      y = keyValue(y) ? keyValue(y) : "";
      return isReverse * ((x > y) - (y > x));
    });
    this.data = parseData;
  }
  //---------- Funções dos botões Criar Demanda e Criar Alocação no Controle de Demandas ------------
  
  handleClickDemanda() {
    this.cadDemanda = true;
  }
  handleClickAddAlocacao() {
    this.modalAlocacao = true;
  }

  handleClose() {
    this.cadDemanda = false;
    this.modalAlocacao = false;
  }
}