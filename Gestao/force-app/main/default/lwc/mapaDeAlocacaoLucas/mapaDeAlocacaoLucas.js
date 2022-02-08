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

import { LightningElement, track }    from "lwc";
import { loadScript }                 from "lightning/platformResourceLoader";
import getMapaAlocacao                from "@salesforce/apex/AlocacaoProfissionalController.getMapaAlocacao";
import getDefaultAllocationDateRange  from "@salesforce/apex/AlocacaoProfissionalController.getDefaultAllocationDateRange";
import Underscore                     from "@salesforce/resourceUrl/Underscore";

import {
  getNullOrRecordResult,
  getColumnsByDateRange,
  getProjectResourceActivity,
  getResourceHasActivity,
  getResourceHasActivityOnTheWeek,
  getProfileCapacityActivity,
  getFullDate,
  getProfileCapacityActivityOnTheWeek
} from "c/moduleHelpers";

// [START lwc mapaDeAlocacao]
export default class mapaDeAlocacao extends LightningElement {

  modalAlocacao = false;
  modalIndisponibilidade = false;
  cadDemanda = false;

  @track componentInicialDate;
  @track componentFinalDate;
  @track paramDateRange;
  @track optionsType;

  @track taskChartChanged;
  @track profileChartChanged;
  @track profileCapacityChartChanged;
  @track chartTaskConfiguration;
  @track chartProfileConfiguration;
  @track chartProfileCapacityConfiguration;

  isChartJsInitialized;
  inputInicialDate;
  inputFinalDate;
  columns;
  data;
  profileCapacityChartData;
  hasRendered = false;

  /* ------ Inicio do Processo ----------
  **
  ** Inicializador:  connectedCallback() Salesforce API
  ** @see: https://developer.salesforce.com/docs/component-library/documentation/en/lwc/lwc.create_lifecycle_hooks_dom
  ** @input:   -
  ** @output:  -
  ** @action: Chama método local para trazer as datas padrão de inicio
  **          e fim. Metodo Local
  */
  renderedCallback() {
    if(!this.hasRendered){
      this.getDefaultAllocationDateRange();
    }
  }

  /* ------ Trata Exibição de Gráficos ----------
  **
  ** Método:  handleChange(graphType) Local, Custom 
  ** @input:  graphType String
  ** @output:  -
  ** @action: Parametriza módulo moduleChartJsHelper 
  **          por tipo de gráfico e informação de 
  **          mudança.
  */
  handleChange(graphType) {

    if (graphType === "task") {
      this.taskChartChanged = true;
      this.template.querySelector("c-module-chart-js-helper").loadChart();
      this.template.querySelector("c-demand-overview").getTableDataMapa();
    } else if (graphType === "profile") {
      this.template.querySelector("c-module-chart-js-helper").loadChart();
      this.profileChartChanged = true;
    } else if (graphType === "profileCapacity") {
      this.template.querySelector("c-module-chart-js-helper").loadChart();
      this.profileCapacityChartChanged = true;
    }
    
  }

  handleFalseChange(graphType) {
    if (graphType === "task") {
      this.taskChartChanged = false;
    } else if (graphType === "profile") {
      this.profileChartChanged = false;
    }else if (graphType === "profileCapacity") {
      this.profileCapacityChartChanged = false;
    }
  }

  /* ------ Trata Escolha de DatePicker ----------
  **
  ** Método:  handleClickDatePicker() Local, Custom 
  ** @input:   -
  ** @output:  -
  ** @action: Parametriza metodo Apex getMapaAlocacao(params)
  **          retornando as alocações no período selecionado.
  */
  handleClickDatePicker() {

    let startDate = this.template.querySelector(".startDate");
    let endDate = this.template.querySelector(".endDate");

    if (startDate.value.indexOf("T") <= -1) {
      startDate.value = startDate.value + "T00:01:00";
    }
    if (endDate.value.indexOf("T") <= -1) {
      endDate.value = endDate.value + "T23:59:00";
    }

    this.componentInicialDate = startDate.value;
    this.componentFinallDate = endDate.value;

    let params = {
      dateRange: [this.componentInicialDate, this.componentFinallDate]
    };

    getMapaAlocacao(params).then((data) => {
      this.getMapaAlocacao(data);
    });

  }

  /* ------ Parametriza datas Padrão ----------
  **
  ** Método:  getDefaultAllocationDateRange() Local, Custom 
  ** @input:   -
  ** @output:  -
  ** @action: Parametriza metodo Apex getDefaultAllocationDateRange()
  **          acionando método Apex getMapaAlocacao(params) que retorna 
  **          dados de alocação do Salesforce
  */
  getDefaultAllocationDateRange() {
    
    getDefaultAllocationDateRange()
      .then((result) => {
        
        this.componentInicialDate = result[0];
        this.componentFinalDate = result[1];

        console.log(result)
        
        let params = {
          dateRange: [result[0], result[1]]
        };
    
        getMapaAlocacao(params).then((data) => {
          this.getMapaAlocacao(data);
          this.hasRendered = true;
        });
      })
      .catch((error) => {
        console.log(error);
      });
  }

  /* ------ Trata retorno Apex do Mapa de Alocação ----------
  **
  ** Método:  getMapaAlocacao(data) Local, Custom 
  ** @input:  data Apex Json (Lista de Dados)
  ** @output: -
  ** @action: Parametriza Datatables e chama Métodos para Tratamento de Gráficos locais
  ** @see:    Datatables: https://developer.salesforce.com/docs/component-library/documentation/en/lwc/lwc.create_lifecycle_hooks_dom
  **          ChartJs:    https://developer.salesforce.com/docs/component-library/documentation/en/lwc/lwc.create_lifecycle_hooks_dom
  */
  getMapaAlocacao(data) {
    
    if (data) {
      this.inputInicialDate = new Date(this.componentInicialDate);
      this.inputFinalDate = new Date(this.componentFinalDate);

      let tableColumns = [
        {
          label: "Consultor",
          fieldName: "consultor",
          type: "text",
          sortable: false
        },
        {
          label: "Hrs/Período",
          fieldName: "hrs",
          type: "text",
          sortable: false
        },
        { label: "Nível", fieldName: "nivel", type: "text", sortable: false }
      ];

      let arrayProjectActivity = getProjectResourceActivity(data);

      let matrixData = getColumnsByDateRange(
        this.inputInicialDate,
        this.inputFinalDate,
        tableColumns,
        arrayProjectActivity,
        "demanda"
      );

      this.columns = matrixData[0];

      loadScript(this, Underscore + "/underscore-min.js").then(() => {
        
        let _ = window._;
        this.loadTableAndChartTaskData(data, arrayProjectActivity, _);
        this.loadTableAndChartProfileCapacityData(data, arrayProjectActivity,_);
        this.loadChartProfileData(data, _);
          console.log(data);
      });
    }
  } 

  /* ------ Trata do carregamento e organização dos dados da tabela e dos gráficos ----------
  **
  ** Método: loadTableAndChartTaskData(receivedData, dateColumns, underscore) local
  ** @input:  receivedData, dateColumns, underscore
  ** @output: -
  ** @action: carrega e organiza os dados para serem renderizados nas tabelas e gráficos
  **     
  */
  loadTableAndChartTaskData(receivedData, dateColumns, underscore) {

    let tableData = [];
    let addRow = {};

    let chartDemandaLabelTemp = [];

    let chartDemandaExecutadasLabel= [];
    let chartDemandaAlocadasLabel = [];
    let chartDemandaAbertasLabel = [];

    let chartDemandaHorasAlocadasTemp = [];
    let chartDemandaHorasExecutadasTemp = [];
    let chartDemandaHorasAbertasTemp = [];

    let chartRecursoLabel = [];
    let chartRecursoData = [];
    let chartHoras = [];

    this.isChartJsInitialized = false;
    let tmpNameArray = [];
    let tmpHourArray = [];
    let nameExists = false;
    let tmpRow = [];

    receivedData.forEach((element) => {

      addRow = getResourceHasActivityOnTheWeek(
        dateColumns,
        element,
        underscore,
        tableData,
        this.columns
      );

      tmpRow = underscore.where(tableData, {
        consultor: element.Profissional__r.Name
      });

      if (tmpRow.length === 0) {
        
        addRow.consultor = getNullOrRecordResult(element.Profissional__r.Name);
        addRow.hrs = getNullOrRecordResult(element.Total_De_Horas__c);
        
        addRow.nivel = getNullOrRecordResult(
          element.Profissional__r.Perfil_Profissional__r.Name
        );

        tmpHourArray[element.Profissional__r.Name] = element.Total_De_Horas__c;
        tmpNameArray.push(element.Profissional__r.Name);

        nameExists = false;

      } else {

        tmpHourArray[element.Profissional__r.Name] = getNullOrRecordResult(element.Total_De_Horas__c) + tmpHourArray[element.Profissional__r.Name];

        tmpRow[0].hrs = tmpHourArray[element.Profissional__r.Name];
        addRow = tmpRow[0];

        nameExists = true;
      }
      
      chartDemandaLabelTemp.push(getNullOrRecordResult(element.Demanda__r.Name));

      chartDemandaExecutadasLabel.push(
        getNullOrRecordResult(element.Demanda__r.Name) + " Executadas"
      );
      chartDemandaAlocadasLabel.push(
        getNullOrRecordResult(element.Demanda__r.Name) + " Alocadas"
      );
      chartDemandaAbertasLabel.push(
        getNullOrRecordResult(element.Demanda__r.Name) + " Abertas"
      );
      chartDemandaHorasAlocadasTemp.push(
        getNullOrRecordResult(element.Demanda__r.Horas_Alocadas__c)
      );
      chartDemandaHorasExecutadasTemp.push(
        getNullOrRecordResult(element.Demanda__r.Horas_Executadas__c)
      );
      chartDemandaHorasAbertasTemp.push(
        getNullOrRecordResult(element.Demanda__r.Horas_Por_Alocar__c)
      );

      chartRecursoLabel.push(
        getNullOrRecordResult(element.Profissional__r.Name)
      );

      chartRecursoData.push(getNullOrRecordResult(element.Total_De_Horas__c));
      chartHoras.push(getNullOrRecordResult(element.Total_De_Horas__c));

      if (!nameExists) {
        tableData.push(addRow);
      }
    });
    var chartDemandaLabel = [...new Set(chartDemandaLabelTemp)]
  

    var chartDemandaHorasAlocadasData = [...new Set(chartDemandaHorasAlocadasTemp)]
    var chartDemandaHorasExecutadasData = [...new Set(chartDemandaHorasExecutadasTemp)]
    var chartDemandaHorasAbertasData = [...new Set(chartDemandaHorasAbertasTemp)]

    console.log(chartDemandaHorasAlocadasData);
    console.log(chartDemandaHorasExecutadasData);
    console.log(chartDemandaHorasAbertasData);

    this.chartTaskConfiguration = {
      type: "bar",
      responsive: false,
      data: {
        datasets: [
          {
            label: "Executadas",
            backgroundColor: "rgba(23,219,114,0.5)",
            hoverBackgroundColor: "rgba(23,219,114,0.8)",
            hoverBorderColor: "rgba(23,219,114,1)",
            data: chartDemandaHorasExecutadasData
          },
          {
            label: "Alocadas",
            backgroundColor: "rgba(219,197,24,0.5)",
            hoverBackgroundColor: "rgba(219,197,24,0.8)",
            hoverBorderColor: "rgba(219,197,24,1)",
            data: chartDemandaHorasAlocadasData
          },
          {
            label: "Em Aberto",
            backgroundColor: "rgba(224,128,123,0.5)",
            hoverBackgroundColor: "rgba(224,128,123,0.8)",
            hoverBorderColor: "rgba(224,128,123,1)",
            data: chartDemandaHorasAbertasData
          }
        ],
        labels: chartDemandaLabel
      },
      options: {
        maintainAspectRatio: false,
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
    this.handleChange("task");
    this.error = undefined;
    this.data = tableData;
  }


 /* ------ Trata  ----------
  **
  ** Método: loadTableAndChartTaskData(receivedData, dateColumns) local, custom
  ** @input:  receivedData, dateColumns
  ** @output: -
  ** @action: declaração de variaveis para otimizar a capacidade de perfil de tabela e dos gráficos
  **     
  */
  loadTableAndChartProfileCapacityData(receivedData, dateColumns) {
    
    let addRow = {};

    let chartProfileCapacityLabel = [];
    let chartProfileChartCapacityTimeline = [];

    let chartProfileCapacityLabelTmp = [];
    let chartProfileChartCapacityTimelineTmp = [];
    
    this.isChartJsInitialized = false;

    let currElm = 0;

    receivedData.forEach((element) => {

      addRow = getProfileCapacityActivityOnTheWeek(
        dateColumns,
        element
      );

      currElm += element.Horas_Por_Dia__c;

      for (const [key] of Object.entries(addRow)) {

        let dateTmp = new Date(parseInt(key, 10));

        if((typeof dateTmp)=='object'){

          let dataFormatada = getFullDate(dateTmp.getDate()) + "/" + getFullDate(dateTmp.getMonth() + 1) + "/" + dateTmp.getFullYear();
          
          if(chartProfileCapacityLabelTmp[dateTmp.getTime()]===undefined){
            chartProfileCapacityLabelTmp[dateTmp.getTime()]         = dataFormatada;
            chartProfileChartCapacityTimelineTmp[dateTmp.getTime()] = parseFloat(currElm);
          }else{
            chartProfileChartCapacityTimelineTmp[dateTmp.getTime()] = parseFloat(chartProfileChartCapacityTimelineTmp[dateTmp.getTime()]) + parseFloat(currElm);
            currElm = 0;
          }

        }
        
      }
    });

    for (let key in chartProfileCapacityLabelTmp) {
      if (Object.prototype.hasOwnProperty.call(chartProfileCapacityLabelTmp, key)) {
        chartProfileCapacityLabel.push(chartProfileCapacityLabelTmp[key]);
      }
    }

    for (let key in chartProfileChartCapacityTimelineTmp) {
      if (Object.prototype.hasOwnProperty.call(chartProfileChartCapacityTimelineTmp, key)) {
        chartProfileChartCapacityTimeline.push(chartProfileChartCapacityTimelineTmp[key]);
      }
    }
    
    this.chartProfileCapacityConfiguration = {
      type: "line",
      responsive: false,
      data: {
        datasets: [
          {
            label: "Período",
            data: chartProfileChartCapacityTimeline
          }
        ],
        labels: chartProfileCapacityLabel
      },
      options: {
        maintainAspectRatio: false,
        scales: {
          y: {
            stacked: false
          }
        },
        interaction: {
          intersect: false
        }
      }
    };
    this.handleChange("profileCapacity");
    this.error = undefined;
    //this.profileCapacityChartData = tableData;
  }

   /* ------ Trata  ----------
  **
  ** Método: loadChartProfileData(receivedData) local
  ** @input:  receivedData
  ** @output: -
  ** @action: 
  **     
  */
  loadChartProfileData(receivedData) {

    let perfilProfissionalStage = [];
    let perfilProfissionalChartLabel = [];
    let perfilProfissionalChartData = [];
    let perfilProfissionalChartColorData = [];
    let chartcolorRGB = [];

    receivedData.forEach((element) => {
      if (
        perfilProfissionalStage[
          element.Profissional__r.Perfil_Profissional__r.Name
        ] === undefined
      ) {
        perfilProfissionalStage[
          element.Profissional__r.Perfil_Profissional__r.Name
        ] = 0;
      }

      perfilProfissionalChartColorData[
        element.Profissional__r.Perfil_Profissional__r.Name
      ] = element.Profissional__r.Perfil_Profissional__r.Cor_no_Gr_fico__c;
      

      perfilProfissionalStage[
        element.Profissional__r.Perfil_Profissional__r.Name
      ] += element.Demanda__r.Horas_Alocadas__c;
    });

    for (let key in perfilProfissionalStage) {
      if (key !== undefined) {
        perfilProfissionalChartLabel.push(key);
        perfilProfissionalChartData.push(perfilProfissionalStage[key]);
      }
    }

    for (let key in perfilProfissionalChartColorData) {
      if (key !== undefined) {
        chartcolorRGB.push(perfilProfissionalChartColorData[key]);
      }
    }

    this.chartProfileConfiguration = {
      type: "polarArea",
      responsive: false,
      data: {
        datasets: [
          {
            data: perfilProfissionalChartData,
            backgroundColor: chartcolorRGB,
            hoverBackgroundColor: chartcolorRGB,
            hoverBorderColor: chartcolorRGB
          }
        ],
        labels: perfilProfissionalChartLabel
      },
      options: {
        maintainAspectRatio: false
      }
    };
    this.handleChange("profile");
    this.error = undefined;
  }

  handleClickDemanda() {
    this.cadDemanda = true;
  }

  handleClickAddAlocacao() {
    this.modalAlocacao = true;
  }

  handleClickAddIndisponibilidade() {
    this.modalIndisponibilidade = true;
  }

  handleClose() {
    this.cadDemanda = false;
    this.modalAlocacao = false;
    this.modalIndisponibilidade = false;
  }

}