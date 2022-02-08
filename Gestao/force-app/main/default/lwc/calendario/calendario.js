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

import { LightningElement, wire } from "lwc";
import getDemandas from "@salesforce/apex/DemandaController.getDemandas";
import getMappedQuery from "@salesforce/apex/MapaAlocacaoController.getMappedQuery";
import getNullOrRecordResult from "c/helpers";
import { ShowToastEvent } from "lightning/platformShowToastEvent";

//Contrução de colunas
const columns = [
  { label: "Demanda", fieldName: "demanda", type: "text", sortable: true },
  { label: "Cliente", fieldName: "cliente", type: "text", sortable: true },
  { label: "Líder", fieldName: "lider", type: "text", sortable: true },
  {
    label: "Estimativa",
    fieldName: "estimativa",
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
    label: "Horas Por Alocar",
    fieldName: "horasPorAlocar",
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

const inputs = {
  min: 20,
  max: 80,
  count: 8,
  decimals: 2,
  continuity: 1
};

const MONTHS = [
  "January",
  "February",
  "March",
  "April",
  "May",
  "June",
  "July",
  "August",
  "September",
  "October",
  "November",
  "December"
];

/* ------ Trata da função do Botão Ok do formulário Cadastro Semana ----------
    **
    ** Método:  function months(config)
    ** @input:  config
    ** @output: -
    ** @action: Realiza configuração e formatação do mês
    **          
    */  
function months(config) {
  var cfg = config || {};
  var count = cfg.count || 12;
  var section = cfg.section;
  var values = [];
  var i, value;

  for (i = 0; i < count; ++i) {
    value = MONTHS[Math.ceil(i) % 12];
    values.push(value.substring(0, section));
  }

  return values;
}

const generateTempLabels = () => {
  return months({ count: inputs.count });
};

console.log(generateTempLabels());

/* ------ Trata da função do Botão Ok do formulário Cadastro Semana ----------
    **
    ** Método:   Componente Class allocationView
    ** @input:  -
    ** @output: -
    ** @action: Realiza configuração de datas e impede que a data inicial seja 
    **           maior que a data final       
    */ 
export default class allocationView extends LightningElement {
  chartConfiguration;
  isChartJsInitialized;
  columns = columns;
  data;
  inicialDate;
  finalDate;
  dataRange;
  @wire(getMappedQuery)
  getMappedQuery({ error, data }) {
    if (error) {
      this.error = error;
      this.chartConfiguration = undefined;
    } else if (data) {
      let chartHrsLivres = [];
      let chartHrsExec = [];
      let chartHrsTotal = [];
      let dateRange = [];
      let chartLabel = [];
      console.log(this.dataInicial,this.finalDate);
      if(this.inicialDate<=this.finalDate){
        dataRange.push(this.inicialDate);
        dataRange.push(this.finalDate);

      }else {
           new ShowToastEvent({

            title: "Error Data",
            
            message: "A data inicial é maior que a data final",
            
            variant: "error"
            
            });
            return false;          
      }
          
      
      let dataRange=[this.inicialDate,this.finalDate];
      data.forEach((opp) => {
        chartHrsLivres.push(opp.Horas__c);
        chartHrsExec.push(opp.Horas_Executadas__c);
        chartHrsTotal.push(opp.Total_De_Horas__c);
        chartLabel.push(opp.Profissional__r.Name);
        dateRange.push(opp.Data_Inicio__c);
        dateRange.push(opp.Data_Fim__c);
      });

      this.chartConfiguration = {
        type: "line",
        responsive: false,
        data: {
          datasets: [
            {
              label: "Horas Totais",
              backgroundColor: "green",
              data: chartHrsTotal
            },
            {
              label: "Horas Livres",
              backgroundColor: "blue",
              data: chartHrsLivres
            },
            {
              label: "Horas Executadas",
              backgroundColor: "red",
              data: chartHrsExec
            }
          ],
          labels: chartLabel
        },
        options: {
          scales: {
            y: {
              stacked: true
            }
          },
          interaction: {
            intersect: false
          }
        }
      };
      console.log("data => ", data);
      this.error = undefined;
    }
  }

  connectedCallback() {
    // load chartjs from the static resource
    getDemandas()
      .then((result) => {
        console.log("DemandaControle.getDemandas retornou com sucesso");
        this.untreatedData = result;
        this.loadTableData(this.untreatedData);
      })
      .catch((error) => {
        console.log("Error in getDemandas:", error);
      });
  }

  loadTableData(receivedData) {
    let treatedData = [];
    let addRow = {};
    let receivedDataParsed = JSON.parse(receivedData);
    console.log(receivedDataParsed);
    receivedDataParsed.forEach((element) => {
      addRow = {};

      addRow.demanda = getNullOrRecordResult(element.Name);
      addRow.lider = getNullOrRecordResult(element.Lider__r.Name);
      addRow.cliente = getNullOrRecordResult(element.Conta__r.Name);
      addRow.estimativa = getNullOrRecordResult(element.Estimativa_Horas__c);
      addRow.horasAlocadas = getNullOrRecordResult(element.Horas_Alocadas__c);
      addRow.horasPorAlocar = getNullOrRecordResult(
        element.Horas_Por_Alocar__c
      );
      addRow.horasExecutadas = getNullOrRecordResult(
        element.Horas_Executadas__c
      );

      treatedData.push(addRow);
    });
    this.data = treatedData;
  
  }

  //-------------- HANDLE SORT - Classifica os dados por direção ou por nome -------------------------
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
  //------------------------------------------
}