({
    setupChart  : function(component) {


        // Normally call apex controller to get data but hardcoded for demonstration purposes
        var dataset = component.get('v.dataset');
        var data;
        var jsonRetVal
        if (dataset == '1'){
            jsonRetVal = {"chartLabels":["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"],"chartData":[1.00,3.00,6.00,10.00,15.00,21.00]}
        } else {
           jsonRetVal = {"chartLabels":["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"],"chartData":[21.00,3.00,16.00,19.00,17.00,12.00]} 
        }


        var el = component.find('andeeChart').getElement();
        var ctx = el.getContext('2d'); 

        // Need something here to destroy any chart that is currently being displayed to stop the 'flicker'

        new Chart(ctx, {
            type: 'bar',
            data: {
                labels: jsonRetVal.chartLabels,
                datasets: [
                    {
                        label: "Data",
                        fillColor: "rgba(220,220,220,1)",
                        strokeColor: "rgba(220,220,220,1)",                
                        data: jsonRetVal.chartData
                    }
                ]
            },
            options: {
                hover: {
                    mode: "none"
                },
                scales: {
                    yAxes: [{
                        ticks: {
                            beginAtZero:true
                        }
                    }]
                }
            }
        });



    },
    configChart: function (component) {
            let conf = component.get("v.config");
            var el = component.find('andeeChart').getElement();
            var ctx = el.getContext('2d'); 
    
            // Need something here to destroy any chart that is currently being displayed to stop the 'flicker'
    
            new Chart(ctx, conf);
 

    }
})