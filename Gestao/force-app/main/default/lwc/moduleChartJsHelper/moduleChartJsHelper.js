/* eslint-disable @lwc/lwc/no-inner-html */
import { LightningElement, api } from "lwc";
import ChartJs from "@salesforce/resourceUrl/ChartJs";
import { loadScript } from "lightning/platformResourceLoader";
import { ShowToastEvent } from "lightning/platformShowToastEvent";

export default class moduleChartJsHelper extends LightningElement {
  
  @api chartConfig;
  @api chartClass;
  @api chartLoaded;
  @api parentChartChanged;

  compId;
  loadingHolder;
  loadingClass

  isChartJsInitialized;

  @api parentChartLoaded(event) {
    //this.createchart();
  }

  createChart(){
    return new Promise((resolve,reject)=>{
      let ctx;
      let canvasChart = this.template.querySelector(
        "canvas." + this.chartClass
      );
      
      if(canvasChart!==undefined && canvasChart!==null){
        ctx = canvasChart.getContext("2d");
      }else{

        let chartContainer = this.template.querySelector('div.chart-container');
        const CONTAINER_HTML = '<canvas class="'+this.chartClass+'" id="'+this.chartClass+'" lwc:dom="manual"></canvas>';
        chartContainer.innerHTML = CONTAINER_HTML;
        
        canvasChart = this.template.querySelector(
          "canvas." + this.chartClass
        );

        ctx = canvasChart.getContext("2d");
      }
      if(this.chartConfig!==undefined){
        this.chart = new window.Chart(
          ctx,
          JSON.parse(JSON.stringify(this.chartConfig))
        );
        resolve(true);
      }else{
        reject(true);
      }
      
      
      
    });
    

  }

  destroyChart(){
    return new Promise((resolve,reject)=>{
      if (this.chart) {
        this.chart.destroy();
        this.chart = null;

        let canvasChart = this.template.querySelector(
          "canvas." + this.chartClass
        );

        canvasChart.remove();
      }
      resolve(true);
    });
    
  }

  connectedCallback(){
    this.compId = Math.random(0,5);
    this.loadingHolder= Math.random(0,5);
    this.loadingClass= Math.random(0,5);
  }

  updateChart(){

  }

  @api loadChart() {

    this.chartChanged = this.parentChartChanged;

    if (!this.chartChanged) {
      return;
    }

    // load chartjs from the static resource
    Promise.all([loadScript(this, ChartJs)])
      .then(() => {
        let that = this;
        this.destroyChart().then((result)=>{

          that.createChart().then(()=>{

            this.isChartJsInitialized = true;
            let canvasChart = this.template.querySelector(
              "canvas." + this.chartClass
            );
            
            canvasChart.parentNode.style.position = "relative";
            canvasChart.parentNode.style.height = "50vh";
            canvasChart.parentNode.style.width = "100%";

            this.chart.resize();
            this.chart.update();

            this.chartChanged = false;
          });
          
        });

      })
      .catch((error) => {
        this.dispatchEvent(
          new ShowToastEvent({
            title: "Error loading Chart",
            message: error.message,
            variant: "error"
          })
        );
      })
      .finally(() => {});
  }

  renderedCallback() {
    this.loadChart();
  }
}