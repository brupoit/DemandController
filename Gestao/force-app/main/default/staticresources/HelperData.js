
function getNullOrRecordResult(input){
    let output = null;
    let emptyValue = '';

    if(input===undefined){
        output = emptyValue;
    }else{
        output = input;
    }

    return output;
}

