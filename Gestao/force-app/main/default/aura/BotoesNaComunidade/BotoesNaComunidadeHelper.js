({
  saveRecord: function (component) {
    console.log("Update record");
    component.find("recordLoader").saveRecord(
      $A.getCallback(function (saveResult) {
        console.log(saveResult);

        if (saveResult.state === "ERROR") {
          var errMsg = "";

          for (var i = 0; i < saveResult.error.length; i++) {
            errMsg += saveResult.error[i].message + "\n";
          }

          if (!saveResult.error[0].pageErrors[0].statusCode) {
            errMsg = "Contate o Administrador do Salesforce";
          }

          component.set("v.recordError", errMsg);

          var resultsToast = $A.get("e.force:showToast");
          resultsToast.setParams({
            title: "Erro",
            key: "error",
            type: "error",
            message: errMsg
          });
          resultsToast.fire();
        } else {
          component.set("v.recordError", "");
        }
      })
    );
  }
});