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
import chartjs from "@salesforce/resourceUrl/ChartJs";
import { loadScript } from "lightning/platformResourceLoader";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import getDemandas from "@salesforce/apex/DemandaController.getDemandas";
import getNullOrRecordResult from "c/helpers";

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

export default class allocationView extends LightningElement {
  chartConfiguration;

  isChartJsInitialized;
  columns = columns;
  data;

  getMappedQuery({ error, data }) {
    if (error) {
      this.error = error;
      this.chartConfiguration = undefined;
    } else if (data) {
      let chartAmtData = [];
      let chartRevData = [];
      let chartLabel = [];

      data.forEach((opp) => {
        chartAmtData.push(opp.amount);
        chartRevData.push(opp.expectRevenue);
        chartLabel.push(opp.stage);
      });

      this.chartConfiguration = {
        type: "line",
        data: {
          datasets: [
            {
              label: "Recurso",
              backgroundColor: "green",
              data: chartAmtData
            },
            {
              label: "Horas Alocadas",
              backgroundColor: "orange",
              data: chartRevData
            },
            {
              label: "Horas Livres",
              backgroundColor: "orange",
              data: chartRevData
            },
            {
              label: "Horas Executadas",
              backgroundColor: "orange",
              data: chartRevData
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
          plugins: {
            filler: {
              propagate: false
            },
            "samples-filler-analyser": {
              target: "chart-analyser"
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

  renderedCallback() {
    if (this.isChartJsInitialized) {
      return;
    }
    // load chartjs from the static resource
    Promise.all([loadScript(this, chartjs)])
      .then(() => {
        this.isChartJsInitialized = true;
        const ctx = this.template
          .querySelector("canvas.lineChart")
          .getContext("2d");
        this.chart = new window.Chart(
          ctx,
          JSON.parse(JSON.stringify(this.chartConfiguration))
        );
      })
      .catch((error) => {
        this.dispatchEvent(
          new ShowToastEvent({
            title: "Error loading Chart",
            message: error.message,
            variant: "error"
          })
        );
      });
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
  //------------------------------------------
}