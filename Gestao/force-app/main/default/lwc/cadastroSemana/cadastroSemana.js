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

import { LightningElement, track, wire } from 'lwc';
import inserirSemana from '@salesforce/apex/CadastroSemana.inserirSemana';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';


export default class CadastroSemana extends LightningElement {
    day;
    month;
    year;
    dayWeek;
    startDay;
    @track week;

 /* ------ Trata da função do Botão Ok do formulário Cadastro Semana ----------
    **
    ** Método:  handleOk() local, custom
    ** @input:  
    ** @output: -
    ** @action: Envia as informações inseridas no formulário de Cadastro Semana para o banco de dados.
    **          Retorna mensagens que identificam se o cadastro teve sucesso ou erro.
    */        
    handleOk(){
        inserirSemana({week : this.dayWeek, startDate: this.startDay})
        .then((result) =>{
            if(result == 'Success'){
                const event = new ShowToastEvent({
                    title:'Sucesso',
                    message: 'Semana cadastrada com sucesso!',
                    variant: 'success',
                    mode: 'dismissable'
                });
                this.dispatchEvent(event);
                this.handleClose();
            }else{
                const event = new ShowToastEvent({
                    title:'Erro',
                    message: 'Já existe uma semana cadastrada neste período.',
                    variant: 'error',
                    mode: 'dismissable'
            });
            this.dispatchEvent(event);
        }
            console.log('Sucesso ao cadastrar==>', result);
        })
        .catch(error =>{
            const event = new ShowToastEvent({
                title:'Erro',
                message: 'Houve uma falha no cadastro!',
                variant: 'error',
                mode: 'dismissable'
            });
            this.dispatchEvent(event);
            this.handleClose();
            console.log('Erro ao cadastrar==>', error);
        })
    }

/* ------ Trata da função que faz o controle de entrada do formulário CadastroSemana ----------
    **
    ** Método:  handleDate(event)
    ** @input:  Event
    ** @output: -
    ** @action: Realiza o controle de datas(day, month e year) no formuláro de CadastroSemana
    */    
    handleDate(event){
        var dateObj = new Date(event.target.value);
        var getDate = new Date(event.target.value);
        this.startDay = getDate;
        this.dayWeek = dateObj;

        var firstDay = dateObj.getDay()+1 || 7;
        if(firstDay !== 1){
            dateObj.setHours(-24 * (firstDay-2));
        }

        this.day = dateObj.getDate();
        this.month = dateObj.getMonth()+1;
        this.year = dateObj.getFullYear();
        this.week = this.day + '/' + this.month + '/' + this.year;
        console.log(this.dayWeek);
        console.log(this.week);
        console.log(dateObj);
    }
//Evento para fechar
    handleClose() {
        this.dispatchEvent(new CustomEvent("close"));
    }
}