({
    getMapaAlocacao : function (component, helper, data) {
        if (data) {
      
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
            
            let moduleHelpers = component.find("moduleHelpers");
            
            let arrayProjectActivity = moduleHelpers.getProjectResourceActivity(data);
            let matrixData = moduleHelpers.getColumnsByDateRange(
              new Date(component.get("v.initialDate")),
              new Date(component.get("v.endDate")),
              tableColumns,
              arrayProjectActivity,
              "demanda"
            );
      
            let columns = matrixData[0];
            component.set("v.columns", columns);
            console.log('final do método');
            console.log(columns);
            console.log(matrixData);
            
            helper.loadTableAndChartTaskData(component, helper, data, arrayProjectActivity)
            // loadScript(this, Underscore + "/underscore-min.js").then(() => {
            //   console.log(data);
            //   let _ = window._;
            //   this.loadTableAndChartTaskData(data, arrayProjectActivity, _);
            //   this.loadTableAndChartProfileCapacityData(data, arrayProjectActivity,_);
            //   this.loadChartProfileData(data, _);
              
            // });
          }
    },
    handleFilter :function (component, helper) {
        let action = component.get("c.getMapaAlocacao");
        action.setParams({dateRange: [component.get("v.initialDate"),component.get("v.endDate")]});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                helper.getMapaAlocacao(component, helper, response.getReturnValue());
                component.set("v.hasRendered", true);
            }
            else if (state == "ERROR"){
                console.log('error');
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                        errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
    },
    handleDefaultAllocationDateRange : function(component, event, helper ){
        let action = component.get("c.getDefaultAllocationDateRange");
        let action2 = component.get("c.getMapaAlocacao");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                let result = response.getReturnValue();
                component.set("v.initialDate", result[0]);
                component.set("v.endDate", result[1]);
                
                let params = {
                    dateRange: [result[0], result[1]]
                };
                action2.setParams({dateRange: params});
                action2.setCallback(this, function(response) {
                    var state = response.getState();
                    if (state === "SUCCESS") {
                        helper.getMapaAlocacao(component, helper, response.getReturnValue());
                        component.set("v.hasRendered", true);
                    }
                    else if (state == "ERROR"){
                        console.log('error');
                        var errors = response.getError();
                        if (errors) {
                            if (errors[0] && errors[0].message) {
                                console.log("Error message: " + 
                                errors[0].message);
                            }
                        } else {
                            console.log("Unknown error");
                        }
                    }
                });
            }
        });
        $A.enqueueAction(action);
        $A.enqueueAction(action2);
    },
    loadTableAndChartTaskData : function(component, helper, receivedData, dateColumns){
        
        let moduleHelpers = component.find("moduleHelpers");
        let columns = component.get("v.columns");
        
        let tableData = [];
        let addRow = {};

        let chartDemandaLabelTemp = [];
        let chartDemandaLabel = [];

        let chartDemandaExecutadasLabel = [];
        let chartDemandaAlocadasLabel = [];
        let chartDemandaAbertasLabel = [];

        let chartDemandaHorasAlocadasData = [];
        let chartDemandaHorasExecutadasData = [];
        let chartDemandaHorasAbertasData = [];

        let chartDemandaHorasAlocadasTemp = [];
        let chartDemandaHorasExecutadasTemp = [];
        let chartDemandaHorasAbertasTemp = [];


        //this.isChartJsInitialized = false;
        let tmpNameArray = [];
        let tmpHourArray = [];
        let nameExists = false;
        let tmpRow = [];

        receivedData.forEach((element) => {

            addRow = helper.getResourceHasActivityOnTheWeek(
              helper,
              dateColumns,
              element,
              tableData,
              columns
            );
      
            // tmpRow = underscore.where(tableData, {
            //   consultor: element.Profissional__r.Name
            // });
            tmpRow = tableData.filter( item =>{
                return item.consultor == element.Profissional__r.Name;
            });
      
            if (tmpRow.length === 0) {
              
              addRow.consultor = moduleHelpers.getNullOrRecordResult(element.Profissional__r.Name);
              addRow.hrs = moduleHelpers.getNullOrRecordResult(element.Total_De_Horas__c);
              
              addRow.nivel = moduleHelpers.getNullOrRecordResult(
                element.Profissional__r.Perfil_Profissional__r.Name
              );
      
              tmpHourArray[element.Profissional__r.Name] = element.Total_De_Horas__c;
              tmpNameArray.push(element.Profissional__r.Name);
      
              nameExists = false;
      
            } else {
      
              tmpHourArray[element.Profissional__r.Name] = moduleHelpers.getNullOrRecordResult(element.Total_De_Horas__c) + tmpHourArray[element.Profissional__r.Name];
      
              tmpRow[0].hrs = tmpHourArray[element.Profissional__r.Name];
              addRow = tmpRow[0];
      
              nameExists = true;
            }
            
            chartDemandaLabelTemp["'"+element.Demanda__r.Name+"'"]  = element.Demanda__r.Name;
      
            chartDemandaExecutadasLabel.push(
                moduleHelpers.getNullOrRecordResult(element.Demanda__r.Name) + " Executadas"
            );
            chartDemandaAlocadasLabel.push(
                moduleHelpers.getNullOrRecordResult(element.Demanda__r.Name) + " Alocadas"
            );
            chartDemandaAbertasLabel.push(
                moduleHelpers.getNullOrRecordResult(element.Demanda__r.Name) + " Abertas"
            );
      
            chartDemandaHorasExecutadasTemp["'"+element.Demanda__r.Name+"'"]  = element.Demanda__r.Horas_Executadas__c;
            chartDemandaHorasAlocadasTemp["'"+element.Demanda__r.Name+"'"]    = element.Demanda__r.Horas_Alocadas__c;
            chartDemandaHorasAbertasTemp["'"+element.Demanda__r.Name+"'"]     = element.Demanda__r.Horas_Por_Alocar__c;
      
            if (!nameExists) {
              tableData.push(addRow);
            }
          });
          
    for (let key in chartDemandaHorasExecutadasTemp) {
        if (key !== undefined) {
          chartDemandaHorasExecutadasData.push(chartDemandaHorasExecutadasTemp[key]);
        }
      }
  
      for (let key in chartDemandaHorasAlocadasTemp) {
        if (key !== undefined) {
          chartDemandaHorasAlocadasData.push(chartDemandaHorasAlocadasTemp[key]);
        }
      }
  
      for (let key in chartDemandaHorasAbertasTemp) {
        if (key !== undefined) {
          chartDemandaHorasAbertasData.push(chartDemandaHorasAbertasTemp[key]);
        }
      }
  
      for (let key in chartDemandaLabelTemp) {
        if (key !== undefined) {
          chartDemandaLabel.push(chartDemandaLabelTemp[key]);
        }
      }
  
      let chartTaskConfiguration = {
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
      console.log('end loadTableAndChartTaskData');
      console.log(chartTaskConfiguration);
      component.set("v.configChart1", chartTaskConfiguration);
      helper.loadChart(component, helper, 1, chartTaskConfiguration);
    //   this.handleChange("taskChart");
    //   this.error = undefined;
    //   this.data = tableData;
    },
    getResourceHasActivityOnTheWeek : function (helper, allActivity, currentActivity, addRowExtra, columns) {
        
        let inicioAtividadeAtual = new Date(
          currentActivity.Data_Inicio__c + "T00:01:00"
        )
        let fimAtividadeAtual = new Date(
          currentActivity.Data_Fim__c + "T23:59:00"
        )
        let foundInTheWeek = [];
        let modRef = null;
        
        
        let addRow = {};
          for (let i = 0; i < allActivity.length; i++) {
            if (
              currentActivity.Profissional__r.Name === allActivity[i].consultor
            ) {
              let tmpRow = {};
              for (
                let d = new Date(inicioAtividadeAtual.getTime() );
                d <= new Date(fimAtividadeAtual.getTime() );
                d.setDate(d.getDate() + 1)
              ) {
                // foundInTheWeek = underscore.where(columns, {
                //   compare: getMonday(d.getTime()).getTime()
                // });
                foundInTheWeek = columns.filter( item =>{
                    return item.compare == helper.getMonday(d.getTime()).getTime()
                });
                
                if(foundInTheWeek.length > 0){
      
                  modRef = helper.getMonday(d.getTime());
                  let currAct =
                    '{"' +
                    modRef.getTime() +
                    '":"' +
                    currentActivity.Demanda__r.Name +
                    '"}';
      
                  let subAddRow = JSON.parse(currAct);
                  
                //   let foundResource = underscore.where(addRowExtra, {
                //     consultor: currentActivity.Profissional__r.Name
                //   });
                let foundResource = addRowExtra.filter( item =>{
                    return item.consultor == currentActivity.Profissional__r.Name;
                });
      
                  if (foundResource !== undefined && foundResource.length > 0) {
                    tmpRow = Object.assign(foundResource[0], subAddRow);
                  } else {
                    tmpRow = Object.assign(addRow, subAddRow);
                  }
                }
              }
            
              addRow = tmpRow;
            }
          }
        
        return addRow;
      },
      loadChart : function (component, helper, chartNum,data){
        let body = component.get("v.var"+chartNum);
        console.log("v.var"+chartNum);
        console.log(chartNum);
        console.log(data);
        $A.createComponent(
                "c:chartTestClear",  // The name of the component you want to display
                {
                    "config": data  // With the dataset to show
                },
                function(newChartComp, status, errorMessage){
                    if(!!body && status == "SUCCESS" ){
                        body.pop(); // Remove the old body
                        body.push(newChartComp);  // Add the new version of the component to the body
                        component.set("v.var"+chartNum, body); 
                    } 
                }
            );
      },
      getMonday : function (id) {
            let d = new Date(id);
            let day = d.getDay(),
            diff = d.getDate() - day + (day === 0 ? -6:1); // adjust when day is sunday
            return new Date(d.setDate(diff));
          
      } 
})