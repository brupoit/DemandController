public class ConsumeCaseRestFromBombril {

    public static AmbienteBombril__c ambienteConexao = AmbienteBombril__c.getValues('ambiente');

    @future(callout=true)
    public static void futureCalloutUpdateCases(String sId, String scSolucao, String scDescricao, String scStatus, String scComentarioPublico) {
        System.debug('update id: ' + sId);

        // configurações personalizadas - conexão rest com a Bombril
        BombrilREST__c restConfig = BombrilREST__c.getValues(ambienteConexao.Ambiente__c);

        String sAccess_Token = getSessionId(restConfig);


        // "de-para" status
        String sStatus = getStatus(scStatus);

        String sJson = '{';
        if(sStatus != ''){
            sJson += '"BB_Status__c": "' + sStatus + '",'; 
        }
        sJson += '"BB_Solucao__c": "' + handleString(scSolucao) + '",';
        sJson += '"BB_Comentario_publico__c": "' + handleString(scComentarioPublico) + '",';
        sJson += '"BB_Descricao__c": "' + handleDescription(scDescricao) + '"';
        sJson += '}';

        System.debug('Json: ' + sJson);
        makePatchCallout(restConfig, sId, sAccess_Token, sJson);
    }

    public static Integer calloutUpdateCases(String sId, String scSolucao, String scDescricao, String scStatus, String scComentarioPublico) {
        // configurações personalizadas - conexão rest com a Bombril
        BombrilREST__c restConfig = BombrilREST__c.getValues(ambienteConexao.Ambiente__c);

        String sAccess_Token = getSessionId(restConfig);

        // "de-para" status
        String sStatus = getStatus(scStatus);

        String sJson = '{';
        if(sStatus != ''){
            sJson += '"BB_Status__c": "' + sStatus + '",'; 
        }
        sJson += '"BB_Solucao__c": "' + handleString(scSolucao) + '",';
        sJson += '"BB_Comentario_publico__c": "' + handleString(scComentarioPublico) + '",';
        sJson += '"BB_Descricao__c": "' + handleDescription(scDescricao) + '"';
        sJson += '}';

        //System.debug('Json: ' + sJson);
        Integer statusCode = 0;

        try{
            statusCode = makePatchCallout(restConfig, sId, sAccess_Token, sJson).getStatusCode();
        }catch(Exception ex){
            system.debug('Patch callout exception: ' + ex);
        }
        
        if(statusCode != 200){
            system.debug('Error. Id: ' + sId + ' - Request Body Json: ' + sJson);
        }

        return statusCode;
    }

    public static String getSessionId(BombrilREST__c restConfig) {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        
        String endpoint = restConfig.AuthEndpoint__c;
        String username = restConfig.Username__c;
        String password = restConfig.Password__c;
        String token = restConfig.Token__c;
        String ClientId = restConfig.ClientId__c;
        String ClientSecret = restConfig.ClientSecret__c;

        String sAccess_Token = '';
        
        request.setMethod('POST');    
        
        request.setBody('grant_type=password&client_id=' + ClientId + '&client_secret=' + ClientSecret + '&username=' + username +'&password=' + password + token); 
        system.debug('req.body: ' + request.getBody());
        request.setEndpoint(endpoint);
        request.setMethod('POST');
        
        HttpResponse response = http.send(request);
        
        if (response.getStatusCode() == 200) {
            // system.debug('body:'+response.getBody());  
            JSONParser parser = JSON.createParser(response.getBody());
            while (parser.nextToken() != null) {
                if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'access_token')) {
                    parser.nextToken();
                    sAccess_Token = parser.getText();    
                } 
            }//fim while
            
            System.debug('Access_Token: '+sAccess_Token.substring(0, 15) + ' ' +  sAccess_Token.substring(15));
        }else{
            system.debug('Error. Response body: '+response.getBody());
        }
        
           return sAccess_Token;
    }
        
    public static HttpResponse makePatchCallout(BombrilREST__c restConfig, String sId, String sAccess_Token, String sJson) {
        Http httpUpdate = new Http();
        HttpRequest requestUpdate = new HttpRequest();

        String sEndpoint = restConfig.CallbackUrl__c;
        sEndpoint += '/services/data/v49.0/sobjects/Issue__c/Case_Id__c/' + sId;

        // System.debug('endpoint: ' + sEndpoint);

        requestUpdate.setEndpoint(sEndpoint);
        requestUpdate.setMethod('PATCH');
        requestUpdate.setHeader('Content-Type', 'application/json;charset=UTF-8');
        // aqui passo o token retornado na autenticação
        requestUpdate.setHeader('Authorization','Bearer '+sAccess_Token); 
        
        // mando dados do objeto por json
        requestUpdate.setBody(sJson);
        HttpResponse responseUpdate = httpUpdate.send(requestUpdate);
        // Parse the JSON response
        if (responseUpdate.getStatusCode() != 200) {
            System.debug('The status code returned was not expected: ' + responseUpdate.getStatusCode() + ' ' + responseUpdate.getStatus());
            System.debug('endpoint: ' + sEndpoint);
        }
        
        System.debug('response status code: ' + responseUpdate.getStatusCode());
        
        return responseUpdate;
    } 

  


    // trata string e retira concatenação [proprietario - modulo - processo]
    public static String handleDescription(String sDesc) {
        String sResult = '';

        // retirar a substring [RESP - MODULO - SUBMODULO]
        if(sDesc.contains(']')){
            sDesc = sDesc.right(sDesc.length() - (sDesc.indexOf(']') + 1 ) );
        }

        // lida com string para o json
        sResult = handleString(sDesc);

        return sResult;
    }

    // tratar strings para não termos problema no Json
    // lida com \, "", e quebras de linha
    public static String handleString(String sString) {
        String sResult = '';

        if(sString != null){
            sResult = sString.replace('\\' , '\\\\');
            sResult = sResult.replace('\r\n','\n');
            sResult = sResult.replace('\n','\\n');
            sResult = sResult.replace('\"' , '\\\"');
        }

        return sResult;
    }

    public static String getStatus(String siStatus) {
        List<String> statusList = new List<String>();
        statusList.add('Novo');      
        statusList.add('Refinamento');
        statusList.add('Backlog');
        statusList.add('Priorizado');
        statusList.add('Em Andamento');
        statusList.add('Validação');
        statusList.add('Aguardando Implementação');
        statusList.add('Fechado');
        statusList.add('Cancelado');
        /*
        statusList.add('Em Desenvolvimento');
        statusList.add('Fechado');
        statusList.add('Cancelado');
        statusList.add('Pendente Informação');
        statusList.add('Melhoria Pendente');
        statusList.add('Em Homologação');
        statusList.add('Pendente Aprovação');
        statusList.add('Pendente Fornecedor');
        statusList.add('Estimando Melhoria');
*/
		
        
        if(statusList.contains(siStatus)){
            return siStatus;
        }else return '';
    }

}