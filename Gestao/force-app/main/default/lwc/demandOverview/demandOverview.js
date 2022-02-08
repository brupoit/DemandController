import { LightningElement, track, api} from "lwc";
import getDemandas from "@salesforce/apex/DemandaController.getDemandas";
import getDefaultAllocationDateRange  from "@salesforce/apex/AlocacaoProfissionalController.getDefaultAllocationDateRange";
import { getNullOrRecordResult } from "c/helpers";

export default class DemandOverview extends LightningElement {
  cadDemanda              = false;
  hasRendered             = false;
  columns = [
    { label: "Demanda", fieldName: "InfoId", type: "url",
     typeAttributes:{
        label:{ fieldName: 'demanda'}
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

  data;
  url = window.location.href.substring(0, window.location.href.indexOf('/lightning/'));

  @track variantStartDate;
  @track variantEndDate;

  renderedCallback() {
    if(!this.hasRendered){
      this.getDefaultAllocationDateRange();
    }
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
        
        let params = {
          dateRange: [result[0], result[1]]
        };
    
        this.getTableDataMapa(params);
        this.hasRendered = true;
   
      })
      .catch((error) => {
        console.log(error);
        this.hasRendered = true;
      });
  }

  @api getTableDataMapa(params){
    if(params.dateRange[0]!==null){
      getDemandas(params)
      .then((result) => {
        let treatedData = [];
        let addRow = {};
        console.log(result);
        result.forEach((element) => {
          addRow = {};
          addRow.demanda = getNullOrRecordResult(element.Demanda__r.Name);
          addRow.InfoId = this.url+'/'+element.Demanda__r.Id;
          addRow.cliente = getNullOrRecordResult(element.Demanda__r.Conta__r.Name);
          addRow.clienteid = this.url+'/'+element.Demanda__r.Conta__r.Id;
          addRow.lider = getNullOrRecordResult(element.Demanda__r.Lider__r.Name);
          addRow.liderid =  this.url+'/'+element.Id.Lider__r;
          addRow.estimativa = getNullOrRecordResult(
            element.Demanda__r.Estimativa_Horas__c
          );
          addRow.horasAlocadas = getNullOrRecordResult(
            element.Demanda__r.Horas_Alocadas__c
          );
          addRow.horasExecutadas = getNullOrRecordResult(
            element.Demanda__r.Horas_Executadas__c
          );
          addRow.horasPorAlocar = getNullOrRecordResult(
            element.Demanda__r.Horas_Por_Alocar__c
          );
          treatedData.push(addRow);
        });
        this.data = treatedData;
        this.hasRendered = true;
      })
      .catch((error) => {
        this.hasRendered = true;
        console.log("Error in getDemandas:", error);
      });
    }
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
  handleClickDemanda() {
    this.cadDemanda = true;
  }

  handleClose() {
    this.cadDemanda = false;
  }
}