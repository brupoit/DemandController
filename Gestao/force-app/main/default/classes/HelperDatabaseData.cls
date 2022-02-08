global  class HelperDatabaseData {

    public void HelperDatabaseData(){

    }
    
    @AuraEnabled(Cacheable=true)
    public static String getNullOrRecordResult(String input){

        string output = null;
        string emptyValue = '';

        if(input=='undefined'){
            output = emptyValue;
        }else{
            output = input;
        }
        System.debug(output);
        return output;
    }
}