({
    init : function(component, event, helper) {
        console.log('init');
        component.set("v.hasRendered", true);
        helper.handleDefaultAllocationDateRange(component, event, helper);
    },
    // onChangeInitialDate : function (component, event, helper) {
    //     console.log(event.target.value);
    //     component.set("v.initialDate",event.target.value);
    // },
    // onChangeEndDate : function (component, event, helper) {
    //     component.set("v.endDate",event.target.value);
    // },
    onFilter : function (component, event, helper) {

        console.log('datas');
        console.log(component.get("v.initialDate"));
        console.log(component.get("v.endDate"));
        helper.handleFilter(component, helper);
    },
    updateDatasetDel : function(component, event, helper) {
        
        var dataset = component.get('v.dataset');
        if (dataset == '1'){
            dataset = '2';
        } else {
            dataset = '1';
        }
        component.set('v.dataset', dataset);
        let body1 = component.get("v.var1");
        let body2 = component.get("v.var2");
        let body3 = component.get("v.var3");

        $A.createComponent(
                "c:chartTestClear",  // The name of the component you want to display
                {
                    "dataset": dataset  // With the dataset to show
                },
                function(newChartComp, status, errorMessage){
                    if(!!body1 && status == "SUCCESS" ){
                        body1.pop(); // Remove the old body
                        body1.push(newChartComp);  // Add the new version of the component to the body
                        component.set("v.var1", body1); 
                    } 
                }
            );
        
        $A.createComponent(
            "c:chartTestClear",  // The name of the component you want to display
            {
                "dataset": dataset  // With the dataset to show
            },
            function(newChartComp, status, errorMessage){
                if(!!body2 && status == "SUCCESS"){
                    body2.pop(); // Remove the old body
                    body2.push(newChartComp);  // Add the new version of the component to the body
                    component.set("v.var2", body2); 
                } 
            }
        );
        $A.createComponent(
            "c:chartTestClear",  // The name of the component you want to display
            {
                "dataset": dataset  // With the dataset to show
            },
            function(newChartComp, status, errorMessage){
                if(!!body3 && status == "SUCCESS"){
                    body3.pop(); // Remove the old body
                    body3.push(newChartComp);  // Add the new version of the component to the body
                    component.set("v.var3", body3); 
                } 
            }
        );
    },
    handleActive : function(component, event, helper) {
        if (component.get("v.hasRendered")) {
            helper.loadChart(component, helper, 1, component.get("v.configChart1"));
        }
    }
})