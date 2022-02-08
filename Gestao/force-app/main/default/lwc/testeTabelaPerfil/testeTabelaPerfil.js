import { LightningElement } from "lwc";
import getAllPerfil from "@salesforce/apex/PerfilProfissionalController.getAllPerfil";
import getNullOrRecordResult from "c/helpers";

const columns = [
  { label: "Perfil", fieldName: "nomePerfil", type: "text", sortable: true },
  {
    label: "Carga Horária",
    fieldName: "cargaHoraria",
    type: "number",
    sortable: true
  },
  {
    label: "Periodicidade",
    fieldName: "periodicidade",
    type: "text",
    sortable: true
  }
];

export default class TesteTabelaPerfil extends LightningElement {
  columns = columns;
  data;
  untreatedData;

  connectedCallback() {
    getAllPerfil()
      .then((result) => {
        console.log(
          "PerfilProfissionalController.getAllPerfil retornou com sucesso"
        );
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

      addRow.nomePerfil = getNullOrRecordResult(element.Name);
      addRow.cargaHoraria = getNullOrRecordResult(element.Carga_Horaria__c);
      addRow.periodicidade = getNullOrRecordResult(element.Periodicidade__c);

      treatedData.push(addRow);
    });
    this.data = treatedData;
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