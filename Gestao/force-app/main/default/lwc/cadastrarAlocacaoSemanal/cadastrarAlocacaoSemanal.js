import { LightningElement, wire } from "lwc";
import { ShowToastEvent } from "lightning/platformShowToastEvent";

import retornarConsultores from "@salesforce/apex/CadastroDemandas.retornarConsultores";
import searchDemands from "@salesforce/apex/CadastroDemandas.searchDemands";
import cadastrarDemanda from "@salesforce/apex/CadastroDemandas.cadastrarDemanda";
import getSemana from '@salesforce/apex/CadastroSemana.inserirSemana';

export default class CadastrarAlocacaoSemanal extends LightningElement {
    consultor;
    startDate;
    newDate;
    newDateId;
    validateWeek = null;
    endDate;
    day;
    month;
    year; 
    demand;
    searchValue = "";
    consultors;
    dateResult;
    @wire(searchDemands, { searchValue: "$searchValue" }) demands;
    hasFocus = true;
    delayTimeout;

    get showDemands() {
        return this.hasFocus && this.demands.data;
    }

    handleClose() {
        this.dispatchEvent(new CustomEvent("close"));
    }
    
    handleChange(event) {        
        this[event.target.name] = event.target.value;
    }
    handleStartDate(event){
        this.startDate = event.target.value;
        /* var dateObj = new Date(event.target.value);
        console.log(dateObj);
        let day = dateObj.getDay();
        let month = dateObj.getMonth();
        let year = dateObj.getFullYear();
        var dateString = day + '/' + month + '/' + year;
        console.log(dateString);
                
        getSemanaAlocada({week:dateObj})
        .then((result =>{
            this.newDateId = result.Data_de_Inicio__c;
            this.validateWeek = true;
            console.log('return Data==>', this.newDateId);
            console.log('return metodo==>',result);
        }))
        .catch((error)=>{
            this.validateWeek = false;
            console.log('Error: ', error);
        }) */
    }
    handleDataInicio(event){
        
    }

    handleFocus() {
        this.hasFocus = true;
    }

    handleBlur() {
        // this.hasFocus = false;
    }

    async handleOk() {
        console.clear();
        console.log(this.consultor);
        console.log(this.startDate);
        console.log(this.endDate);
        console.log(this.demand);


        
            try {
                const success = await cadastrarDemanda({ empId: this.consultor, demandId: this.demand, startDate: this.startDate, endDate: this.endDate });
                if (success === "SUCCESS") {
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: "Sucesso",
                            message: "Alocação atualizada com sucesso!",
                            variant: "success"
                        })
                    );
    
                    this.dispatchEvent(new CustomEvent("close"));
                }
            } catch (err) {
                console.log(err);
                this.dispatchEvent(new ShowToastEvent({ title: "Erro", message: "Ocorreu um erro ao tentar atualizar as demandas", variant: "error" }));
            }
        
    }

    handleSelect(event) {
        this.searchValue = event.currentTarget.getAttribute("data-label");
        this.demand = event.currentTarget.getAttribute("data-id");
        this.hasFocus = false;
    }

    searchDemands(event) {
        window.clearTimeout(this.delayTimeout);
        const value = event.target.value;
        this.delayTimeout = setTimeout(() => {
            this.searchValue = value;
        }, 300);
    }

    @wire(retornarConsultores) getConsultors({ error, data }) {
        if (error) {
            console.log(error);
        }

        if (data) {
            this.consultors = data.map(({ Id, Name }) => ({ label: Name, value: Id }));
        }
    }
}