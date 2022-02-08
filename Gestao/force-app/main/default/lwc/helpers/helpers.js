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
      let d = new Date(elm.initTimestamp);
      d <= new Date(elm.endTimestamp);
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
  activityDate,
  tableField
) => {
  let tmpDateArray = [];
  let outputArray = [];


  for (let d = initialDate; d <= finalDate; d.setDate(d.getDate() + 1)) {
  
    if (d.getMonth() === 0) {
      d.setMonth(d.getMonth() + 1);
    }
    let addData = {};
    let dateTimestamp = d.getTime();
    if (
      !tmpDateArray.includes(dateTimestamp) &&
      getTimeInRange(activityDate, dateTimestamp)
    ) {
      tmpDateArray.push(dateTimestamp);
      addData.label =
        getFullDate(d.getDate()) +
        "/" +
        getFullDate(d.getMonth()) +
        "/" +
        d.getFullYear();
      let timeline = d.getTime();
      addData.type = "text";
      addData.sortable = true;
      addData.fieldName = tableField;
      outputArray.push(timeline);
      currentColumns.push(addData);
    }
  }
  return [currentColumns, outputArray];
};

const getLucasQueroTeMatar = (
  initialDate,
  finalDate,
  currentColumns,
  activityDate,
  perfilProfissional
  ) => {
  let tmpDateArray = [];
  let outputArray = [];


  for (let d = initialDate; d <= finalDate; d.setDate(d.getDate() + 1)) {
  
    if (d.getMonth() === 0) {
      d.setMonth(d.getMonth() + 1);
    }
    let addData = {};
    let dateTimestamp = d.getTime();
    if (
      !tmpDateArray.includes(dateTimestamp) &&
      getTimeInRange(activityDate, dateTimestamp)
    ) {
      tmpDateArray.push(dateTimestamp);
      addData.label =
        getFullDate(d.getDate()) +
        "/" +
        getFullDate(d.getMonth()) +
        "/" +
        d.getFullYear();
      let timeline = d.getTime();
      addData.type = "text";
      addData.sortable = true;
      addData.fieldName = tableField;
      outputArray.push(timeline);
      currentColumns.push(addData);
    }
  }
  return [currentColumns, outputArray];
};

const getProjectTaskActivity = (inputData) => {
  let outputData = [];
  inputData.forEach((elm) => {
    let startDate = new Date(elm.Data_Inicio__c + "T13:01:00");
    let endDate = new Date(elm.Data_Fim__c + "T13:01:00");

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
    let startDate = new Date(elm.Data_Inicio__c + "T13:01:00");
    let endDate = new Date(elm.Data_Fim__c + "T13:01:00");
    row.resource = elm.Profissional__r.Name;
    row.initTimestamp = startDate.getTime();
    row.endTimestamp = endDate.getTime();
    outputData.push(row);
  });

  return outputData;
};

const parseDataToJs = (startDate,endDate) => {
let preOutputStartDate = [];
let preOutputEndDate = [];

}

export {
  getNullOrRecordResult,
  getColumnsByDateRange,
  loadTableData,
  getFullDate,
  getProjectResourceActivity,
  getTimeInRange,
  getProjectTaskActivity
};