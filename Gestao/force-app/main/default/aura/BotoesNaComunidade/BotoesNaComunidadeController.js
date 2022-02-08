({
  AprovarCasoJS: function (component, event, helper) {
    console.log("Passou no Controlador -- Aprovar caso");
    //var Verifica = component.find("recordLoader").get("v.targetFields.Status");
    //console.log("Verifica : "+ Verifica);

    //if(Verifica.includes("Em Homologação")){

    //  var recordLoader = component.find("recordLoader");
    //console.log(recordLoader);
    //component.find("recordLoader").set("v.targetFields.Status", "Pendente Aprovação");
    //var teste = component.find("recordLoader").get("v.targetFields.Status");
    //console.log("Teste2"+teste);

    //}// Caso o status anterior for Em Homologação
    //else{
    //console.log("Entrou no pendente aprovação");

    component.set("v.simpleRecord.Status", "Fechado");
    var status = component.get("v.simpleRecord.Status");
    console.log("Status" + status);
    var recordLoader = component.find("recordLoader");
    console.log(recordLoader);
    component.find("recordLoader").set("v.targetFields.Status", "Fechado");
    var teste = component.find("recordLoader").get("v.targetFields.Status");
    console.log("Teste1" + teste);
    //}

    // Atributo que mostra se foi feito um update através do botão
    component.set("v.BotoesUpdate", "Update Dos Botoes");

    // Update no registro
    recordLoader.saveRecord(
      $A.getCallback(function (saveResult) {
        console.log(saveResult.state);
        if (saveResult.state === "ERROR") {
          var errMsg = "";
          var ValidationRule = "";
          // saveResult.error is an array of errors,
          // so collect all errors into one message
          for (var i = 0; i < saveResult.error.length; i++) {
            errMsg += saveResult.error[i].message + "\n";
          }
          console.log("Validation Rule : " + ValidationRule);
          component.set("v.recordError", errMsg);
          console.log(errMsg);

          console.log("Save Result :" + JSON.stringify(saveResult));

          console.log(
            "Status code" + saveResult.error[0].pageErrors[0].statusCode
          ); //JSON.stringify(saveResult.error[0].pageErrors.statusCode));

          //Erro desconhecido
          if (
            !saveResult.error[0].pageErrors[0].statusCode.includes(
              "FIELD_CUSTOM_VALIDATION_EXCEPTION"
            )
          ) {
            errMsg = "Contate o Administrador do Salesforce";
          }

          // Mostrar mensagem de erro
          var resultsToast = $A.get("e.force:showToast");
          resultsToast.setParams({
            title: "Erro",
            key: "info",
            message: errMsg
          });
          resultsToast.fire();
        } else {
          // Caso não tem erro
          component.set("v.recordError", "");
        }
      })
    );
  },
  ReprovarCasoJS: function (component, event, helper) {
    console.log("Passou no Controlador -- Reprovar caso");
    var Verifica = component.find("recordLoader").get("v.targetFields.Status");
    console.log("Verifica : " + Verifica);
    if (Verifica.includes("Em Homologação")) {
      var recordLoader = component.find("recordLoader");
      console.log(recordLoader);
      component
        .find("recordLoader")
        .set("v.targetFields.Status", "Em Desenvolvimento");
      var teste = component.find("recordLoader").get("v.targetFields.Status");
      console.log("Teste2" + teste);
    } // Caso o status anterior for Em Homologação
    else {
      console.log("Entrou no pendente aprovação");

      component.set("v.simpleRecord.Status", "Reprovado");
      var status = component.get("v.simpleRecord.Status");
      console.log("Status" + status);
      var recordLoader = component.find("recordLoader");
      console.log(recordLoader);
      component.find("recordLoader").set("v.targetFields.Status", "Reprovado");
      var teste = component.find("recordLoader").get("v.targetFields.Status");
      console.log("Teste1" + teste);
    }

    // Atributo que mostra se foi feito um update através do botão
    component.set("v.BotoesUpdate", "Update Dos Botoes");

    // Update no registro
    recordLoader.saveRecord(
      $A.getCallback(function (saveResult) {
        console.log(saveResult.state);
        if (saveResult.state === "ERROR") {
          var errMsg = "";
          // saveResult.error is an array of errors,
          // so collect all errors into one message
          for (var i = 0; i < saveResult.error.length; i++) {
            errMsg += saveResult.error[i].message + "\n";
          }
          component.set("v.recordError", errMsg);
          console.log(errMsg);

          console.log(
            "Status code" + saveResult.error[0].pageErrors[0].statusCode
          ); //JSON.stringify(saveResult.error[0].pageErrors.statusCode));

          //Erro desconhecido
          if (
            !saveResult.error[0].pageErrors[0].statusCode.includes(
              "FIELD_CUSTOM_VALIDATION_EXCEPTION"
            )
          ) {
            errMsg = "Contate o Administrador do Salesforce";
          }

          // Mostrar mensagem de erro
          var resultsToast = $A.get("e.force:showToast");
          resultsToast.setParams({
            title: "Erro",
            key: "info",
            message: errMsg
          });
          resultsToast.fire();
        } else {
          // Caso não tem erro
          component.set("v.recordError", "");
        }
      })
    );
  },
  ValidarMelhoriaJS: function (component, event, helper) {
    console.log("Passou no Controlador -- Validar caso");

    var recordLoader = component.find("recordLoader");
    console.log(recordLoader);
    component.find("recordLoader").set("v.targetFields.Status", "Validado");
    var teste = component.find("recordLoader").get("v.targetFields.Status");
    console.log("Teste" + teste);

    // Atributo que mostra se foi feito um update através do botão
    component.set("v.BotoesUpdate", "Update Dos Botoes");

    // Update no registro
    recordLoader.saveRecord(
      $A.getCallback(function (saveResult) {
        console.log(saveResult.state);
        if (saveResult.state === "ERROR") {
          var errMsg = "";
          // saveResult.error is an array of errors,
          // so collect all errors into one message
          for (var i = 0; i < saveResult.error.length; i++) {
            errMsg += saveResult.error[i].message + "\n";
          }
          component.set("v.recordError", errMsg);
          console.log(errMsg);

          console.log(
            "Status code" + saveResult.error[0].pageErrors[0].statusCode
          ); //JSON.stringify(saveResult.error[0].pageErrors.statusCode));

          //Erro desconhecido
          if (
            !saveResult.error[0].pageErrors[0].statusCode.includes(
              "FIELD_CUSTOM_VALIDATION_EXCEPTION"
            )
          ) {
            errMsg = "Contate o Administrador do Salesforce";
          }

          // Mostrar mensagem de erro
          var resultsToast = $A.get("e.force:showToast");
          resultsToast.setParams({
            title: "Erro",
            key: "info",
            message: errMsg
          });
          resultsToast.fire();
        } else {
          // Caso não tem erro
          component.set("v.recordError", "");
        }
      })
    );
  },
  ReabrirCasoJS: function (component, event, helper) {
    console.log("Passou no Controlador -- Reabrir caso");

    var recordLoader = component.find("recordLoader");
    component.find("recordLoader").set("v.targetFields.Status", "Priorizado");
    var teste = component.find("recordLoader").get("v.targetFields.Status");

    // Passou no update pelo botão
    component.set("v.BotoesUpdate", "Update Dos Botoes");
    
    recordLoader.saveRecord(
      $A.getCallback(function (saveResult) {
        console.log(saveResult.state);
        if (saveResult.state === "ERROR") {
          var errMsg = "";
          // saveResult.error is an array of errors,
          // so collect all errors into one message
          console.log("saveResult.error" + JSON.stringify(saveResult.error));
          for (var i = 0; i < saveResult.error.length; i++) {
            errMsg += saveResult.error[i].message + "\n";
          }
          component.set("v.recordError", errMsg);
          console.log(errMsg);

          console.log(
            "Status code" + saveResult.error[0].pageErrors[0].statusCode
          ); //JSON.stringify(saveResult.error[0].pageErrors.statusCode));

          //Erro desconhecido
          if (
            !saveResult.error[0].pageErrors[0].statusCode.includes(
              "FIELD_CUSTOM_VALIDATION_EXCEPTION"
            )
          ) {
            errMsg = "Contate o Administrador do Salesforce";
          }

          var resultsToast = $A.get("e.force:showToast");
          resultsToast.setParams({
            title: "Erro",
            key: "info",
            message: errMsg
          });
          resultsToast.fire();
        } else {
          component.set("v.recordError", "");
        }
      })
    );
  },
  AprovarHomologacaoJS: function (component, event, helper) {
    var recordLoader = component.find("recordLoader");
    console.log(recordLoader);
    component
      .find("recordLoader")
      .set("v.targetFields.Status", "Aguardando Implantação");
    var teste = component.find("recordLoader").get("v.targetFields.Status");
    console.log("Teste" + teste);

    component.set("v.BotoesUpdate", "Update Dos Botoes");

    recordLoader.saveRecord(
      $A.getCallback(function (saveResult) {
        console.log(saveResult.state);
        if (saveResult.state === "ERROR") {
          var errMsg = "";
          // saveResult.error is an array of errors,
          // so collect all errors into one message
          console.log("saveResult.error" + JSON.stringify(saveResult.error));
          for (var i = 0; i < saveResult.error.length; i++) {
            errMsg += saveResult.error[i].message + "\n";
          }
          component.set("v.recordError", errMsg);
          console.log(errMsg);

          console.log(
            "Status code" + saveResult.error[0].pageErrors[0].statusCode
          ); //JSON.stringify(saveResult.error[0].pageErrors.statusCode));

          //Erro desconhecido
          if (
            !saveResult.error[0].pageErrors[0].statusCode.includes(
              "FIELD_CUSTOM_VALIDATION_EXCEPTION"
            )
          ) {
            errMsg = "Contate o Administrador do Salesforce";
          }

          var resultsToast = $A.get("e.force:showToast");
          resultsToast.setParams({
            title: "Erro",
            key: "info",
            message: errMsg
          });
          resultsToast.fire();
        } else {
          component.set("v.recordError", "");
        }
      })
    );
  },
  ReprovarHomologacaoJS: function (component, event, helper) {
    var recordLoader = component.find("recordLoader");
    console.log(recordLoader);
    component
      .find("recordLoader")
      .set("v.targetFields.Status", "Priorizado");
    var teste = component.find("recordLoader").get("v.targetFields.Status");
    console.log("Teste" + teste);

    component.set("v.BotoesUpdate", "Update Dos Botoes");

    recordLoader.saveRecord(
      $A.getCallback(function (saveResult) {
        console.log(saveResult.state);
        if (saveResult.state === "ERROR") {
          var errMsg = "";
          // saveResult.error is an array of errors,
          // so collect all errors into one message
          console.log("saveResult.error" + JSON.stringify(saveResult.error));
          for (var i = 0; i < saveResult.error.length; i++) {
            errMsg += saveResult.error[i].message + "\n";
          }
          component.set("v.recordError", errMsg);
          console.log(errMsg);

          console.log(
            "Status code" + saveResult.error[0].pageErrors[0].statusCode
          ); //JSON.stringify(saveResult.error[0].pageErrors.statusCode));

          //Erro desconhecido
          if (
            !saveResult.error[0].pageErrors[0].statusCode.includes(
              "FIELD_CUSTOM_VALIDATION_EXCEPTION"
            )
          ) {
            errMsg = "Contate o Administrador do Salesforce";
          }

          var resultsToast = $A.get("e.force:showToast");
          resultsToast.setParams({
            title: "Erro",
            key: "info",
            message: errMsg
          });
          resultsToast.fire();
        } else {
          component.set("v.recordError", "");
        }
      })
    );
  },
  handleRecordUpdated: function (component, event, helper) {
    var UpdPag = component.get("v.BotoesUpdate");
    console.log("Botoes Update : " + UpdPag);
    var eventParams = event.getParams();
    console.log("Parametros do evento : " + JSON.stringify(eventParams));
    if (
      (eventParams.changeType === "CHANGED") &
      (UpdPag == "Update Dos Botoes")
    ) {
      // get the fields that are changed for this record
      var changedFields = eventParams.changedFields;
      console.log("Fields that are changed: " + JSON.stringify(changedFields));
      // record is changed so refresh the component (or other component logic)
      var resultsToast = $A.get("e.force:showToast");
      resultsToast.setParams({
        title: "Atualizado",
        key: "check",
        message: "O registro foi atualizado com sucesso!"
      });
      resultsToast.fire();
    } else if (eventParams.changeType === "LOADED") {
      // record is loaded in the cache
    } else if (eventParams.changeType === "REMOVED") {
      // record is deleted and removed from the cache
    } else if (eventParams.changeType === "ERROR") {
      // record get an error
    }
  },

  aprovarCaso: function (component) {
    component.set("v.simpleRecord.Status", "Fechado");
    component.find("recordLoader").set("v.targetFields.Status", "Fechado");
    component.set("v.BotoesUpdate", "Update Dos Botoes");

    helper.saveRecord(component);
  },

  reprovarCaso: function (component) {
    component.set("v.simpleRecord.Status", "Validação");
    component.find("recordLoader").set("v.targetFields.Status", "Validação");
    component.set("v.BotoesUpdate", "Update Dos Botoes");

    helper.saveRecord(component);
  },

  validarCaso: function (component, event, helper) {
    component.set("v.simpleRecord.Status", "Aguardando Implantação");
    component
      .find("recordLoader")
      .set("v.targetFields.Status", "Aguardando Implantação");
    component.set("v.BotoesUpdate", "Update Dos Botoes");

    helper.saveRecord(component);
  }
});