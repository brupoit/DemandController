public class ReplaceJSON {
    public static String replaceJSON(String response){
        
       	response = response.replace('"Row Version"', '"Row_Version"');
       	response = response.replace('"Start Date"', '"Start_Date"');
       	response = response.replace('"Final Date"', '"Final_Date"');
       	response = response.replace('"Ro Flg"', '"Ro_Flg"');
       	response = response.replace('"Last Used"', '"Last_Used"');
       	response = response.replace('"Work Hrs"', '"Work_Hrs"');
       	response = response.replace('"Over Time"', '"Over_Time"');
       	response = response.replace('"Night Hours"', '"Night_Hours"');
       	response = response.replace('"Stand by"', '"Stand_by"');
       	response = response.replace('"Over Time"', '"Over_Time"');
       	response = response.replace('"Date"', '"Date_Apex"'); //TODO
       	response = response.replace('"Period id"', '"Period_id"'); 
       	response = response.replace('"Approved Flg"', '"Approved_Flg"'); 
       	response = response.replace('"Cost Center"', '"Cost_Center"');     
        
        
        
        return response;
    }
}