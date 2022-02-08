import { LightningElement, api } from "lwc";
import ChartJs from "@salesforce/resourceUrl/ChartJs";
import { loadScript } from "lightning/platformResourceLoader";
import { ShowToastEvent } from "lightning/platformShowToastEvent";

export default class helpers_chartjs extends LightningElement {
  @api chartConfig;
  @api chartClass;
  isChartJsInitialized;
  renderedCallback() {
    if (this.isChartJsInitialized) {
      return;
    }
    // load chartjs from the static resource
    Promise.all([loadScript(this, ChartJs)])
      .then(() => {

        let canvasChart = this.template.querySelector(
          "canvas." + this.chartClass
        );
        this.isChartJsInitialized = true;
        const ctx = canvasChart.getContext("2d");
        this.chart = new window.Chart(
          ctx,
          JSON.parse(JSON.stringify(this.chartConfig))
        );
        canvasChart.parentNode.style.position = "relative";
        canvasChart.parentNode.style.height = "50vh";
        //canvasChart.parentNode.style.width = "70vw";
        //this.template.querySelector("canvas.barChart").style.height = '80vh';

        //this.template.querySelector("canvas.barChart").style.width = '1200px';
        //this.template.querySelector("canvas.barChart").parentNode.style.width = '1200px';
        this.chart.resize();
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
}