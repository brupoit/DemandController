const getNullOrRecordResult = (input) => {
  let output = null;
  let emptyValue = "";

  if (input === undefined) {
    output = emptyValue;
  } else {
    output = input;
  }

  return output;
};

function getMonday(id) {
  let d = new Date(id);
  let day = d.getDay(),
  diff = d.getDate() - day + (day === 0 ? -6:1); // adjust when day is sunday
  return new Date(d.setDate(diff));
}

const loadTableData = (data, columns) => {
  let tableData = [];

  data.forEach((element) => {
    let tempData = {};
    columns.forEach((column) => {
      tempData.key = column.key;
      tempData.val = getNullOrRecordResult(element[column.val]);
    });

    tableData.push(tempData);
  });

  this.data = tableData;
};

const getFullDate = (inputDate) => {
  let outputDate = "";
  if (inputDate < 10) {
    outputDate = "0" + inputDate;
  } else {
    outputDate = inputDate;
  }

  return outputDate;
};

const getTimeInRange = (activity, input) => {

  let inputtedDate = new Date(input);
  let tmpDateArray = [];
  let formattedInputDate =
    inputtedDate.getDate() +
    "/" +
    inputtedDate.getMonth() +
    "/" +
    inputtedDate.getFullYear();
  activity.forEach((elm) => {
    for (
      let d = new Date(elm.inicioAtividade);
      d <= new Date(elm.fimAtividade);
      d.setDate(d.getDate() + 1)
    ) {
      let formattedRangeDate =
        d.getDate() + "/" + d.getMonth() + "/" + d.getFullYear();
      if (!tmpDateArray.includes(formattedRangeDate)) {
        tmpDateArray.push(formattedRangeDate);
      }
    }
  });
  if (tmpDateArray.includes(formattedInputDate)) {
    return true;
  }
  return false;
};

const getColumnsByDateRange = (
  initialDate,
  finalDate,
  currentColumns,
  activityDate
) => {

  let tmpDateArray = [];
  let outputArray = [];

  for (let d = initialDate; d <= finalDate; d.setDate(d.getDate() + 1)) {
    
    
    let addData = {};
    let dateTimestamp = d.getTime();
    if (
      !tmpDateArray.includes(dateTimestamp) &&
      getTimeInRange(activityDate, dateTimestamp) &&
      d.getDay() === 1

    ) {
      tmpDateArray.push(dateTimestamp);
      addData.label =
        getFullDate(d.getDate()) +
        "/" +
        getFullDate(d.getMonth() + 1) +
        "/" +
        d.getFullYear();
      let timeline = d.getTime();
      addData.type = "text";
      addData.compare = dateTimestamp;
      addData.sortable = true;
      addData.fieldName = dateTimestamp;
      outputArray.push(timeline);
      currentColumns.push(addData);
    }
  }
  
  return [currentColumns, outputArray];
};

const getProjectTaskActivity = (inputData) => {
  let outputData = [];
  inputData.forEach((elm) => {
    let startDate = new Date(elm.Data_Inicio__c + "T00:01:00");
    let endDate = new Date(elm.Data_Fim__c + "T23:59:00");

    for (let d = startDate; d <= endDate; d.setDate(d.getDate() + 1)) {
      outputData.push(d.getTime());
    }
  });

  return outputData;
};

const getProjectResourceActivity = (inputData) => {

  let outputData = [];
  inputData.forEach((elm) => {
    let row = {};
    let startDate = new Date(elm.Data_Inicio__c + "T00:01:00");
    let endDate = new Date(elm.Data_Fim__c + "T23:59:00");
    row.consultor = elm.Profissional__r.Name;
    row.demanda = elm.Demanda__r.Name;
    row.hrs = elm.Total_De_Horas__c;
    row.inicioAtividade = startDate.getTime();
    row.fimAtividade = endDate.getTime();
    outputData.push(row);
  });
  return outputData;
};

const getResourceHasActivity = (
  allActivity,
  currentActivity,
  underscore,
  addRowExtra,
  columns
) => {
  let inicioAtividadeAtual = new Date(
    currentActivity.Data_Inicio__c + "T00:01:00"
  )
  let fimAtividadeAtual = new Date(
    currentActivity.Data_Fim__c + "T23:59:00"
  )


  let inicioEstaContidoNasColumas = underscore.where(columns, {
    compare: inicioAtividadeAtual.getTime()
  });
  let fimEstaContidoNasColumas = underscore.where(columns, {
    compare: fimAtividadeAtual.getTime()
  });
  
  let addRow = {};
 
  if (
    inicioEstaContidoNasColumas.length > 0 &&
    fimEstaContidoNasColumas.length > 0
  ) {
    for (let i = 0; i <= allActivity.length; i++) {
      if (allActivity[i] !== undefined) {
        if (
          inicioAtividadeAtual.getTime() >= inicioEstaContidoNasColumas[0].compare &&
          fimAtividadeAtual.getTime() <= fimEstaContidoNasColumas[0].compare
        ) {
          if (
            currentActivity.Profissional__r.Name === allActivity[i].consultor
          ) {
            for (
              let d = new Date(inicioAtividadeAtual.getTime() );
              d <= new Date(fimAtividadeAtual.getTime() );
              d.setDate(d.getDate() + 1)
            ) {
              let currAct =
              '{"' +
              d.getTime() +
              '":"' +
              currentActivity.Demanda__r.Name +
              '"}';
              let subAddRow = JSON.parse(currAct);
              let tmpRow = {};

              let foundResource = underscore.where(addRowExtra, {
                consultor: currentActivity.Profissional__r.Name
              });
              if (foundResource !== undefined && foundResource.length > 0) {
                tmpRow = Object.assign(foundResource[0], subAddRow);
              } else {
                tmpRow = Object.assign(addRow, subAddRow);
              }
              addRow = tmpRow;
            }
          }
        }
      }
    }
  }
  return addRow;
};

const getResourceHasActivityOnTheWeek = (
  allActivity,
  currentActivity,
  underscore,
  addRowExtra,
  columns
) => {
  
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
          foundInTheWeek = underscore.where(columns, {
            compare: getMonday(d.getTime()).getTime()
          });
          
          if(foundInTheWeek.length > 0){

            modRef = getMonday(d.getTime());
            let currAct =
              '{"' +
              modRef.getTime() +
              '":"' +
              currentActivity.Demanda__r.Name +
              '"}';

            let subAddRow = JSON.parse(currAct);
            
            let foundResource = underscore.where(addRowExtra, {
              consultor: currentActivity.Profissional__r.Name
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
};

const getProfileCapacityActivityOnTheWeek = (
  allActivity,
  currentActivity,
  addRowExtra,
  underscore
) => {

  let addRow = {};
  let modRef = null;
  let currAct = '{}';

  console.log(addRowExtra);
    
    for (let i = 0; i <= allActivity.length; i++) {
      if (allActivity[i] !== undefined) {
        let tmpRow = {};
          for (
            let d = new Date(allActivity[i].inicioAtividade);
            d <= new Date(allActivity[i].fimAtividade);
            d.setDate(d.getDate() + 1)
          ) {

            modRef = getMonday(d.getTime());

            let foundLabourActivity = underscore.where(addRowExtra, {
              atividade: d.getTime()
            });

            if(foundLabourActivity===undefined){
              currAct = '{"' + modRef.getTime() + '":"' + parseFloat(currentActivity.Horas_Por_Dia__c) + '"}';
            }else{
              currAct = '{"' + modRef.getTime() + '":"' + (parseFloat(allActivity[i].hrs) + parseFloat(currentActivity.Horas_Por_Dia__c)) + '"}';
            }
            
            let subAddRow = JSON.parse(currAct);
            tmpRow = Object.assign(addRow, subAddRow);
          }
          
          addRow = tmpRow;
        }
      }
  return addRow;
};

const getProfileCapacityActivity = (
  allActivity,
  currentActivity,
  underscore,
  addRowExtra,
  columns
) => {

  let addRow = {};
    
    for (let i = 0; i <= allActivity.length; i++) {
      if (allActivity[i] !== undefined) {
          for (
            let d = new Date(allActivity[i].inicioAtividade);
            d <= new Date(allActivity[i].fimAtividade);
            d.setDate(d.getDate() + 1)
          ) {
            let foundResource = underscore.where(addRowExtra, {
              atividade: d.getTime()
            });

            let currAct =
              '{"' +
              d.getTime() +
              '":' +
              allActivity[i].hrs/currentActivity.Total_De_Dias__c +
              '}';

            let subAddRow = JSON.parse(currAct);
            let tmpRow = {};

            if (foundResource !== undefined && foundResource.length > 0) {
              tmpRow = Object.assign(foundResource[0], subAddRow);
            } else {
              tmpRow = Object.assign(addRow, subAddRow);
            }
            addRow = tmpRow;
          }
        }
      }
  return addRow;
};

export {
  getNullOrRecordResult,
  getColumnsByDateRange,
  loadTableData,
  getFullDate,
  getProjectResourceActivity,
  getTimeInRange,
  getProjectTaskActivity,
  getResourceHasActivity,
  getResourceHasActivityOnTheWeek,
  getProfileCapacityActivity,
  getProfileCapacityActivityOnTheWeek
};