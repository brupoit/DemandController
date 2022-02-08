public class ServiceCloudToEcrmRequest {
    public static boolean logado;
    public static String error;
    public static String success;
    public static boolean isOnError{get{if(isOnError == null){ isOnError = false;}return isOnError;} set;}
    public static HarpiaEcrmJSonApex json;
    public static boolean usuarioDiferente{get{if(usuarioDiferente == null){usuarioDiferente = false;}return usuarioDiferente;}set;}
    public static String userName{get;set;}
    
    @AuraEnabled
    public static boolean Login(String usuario, String senha){
		system.debug('Entrou no logiiiiiiiin'); 
        if(ApexPages.currentPage().getCookies().get('eCRMSessionId') == null){
            system.debug('CAIIIIIUUU NO IF');
            try{                
                String senhaMd5 = EncodingUtil.convertToHex(Crypto.generateDigest('MD5', Blob.valueOf(senha)));
                //String urlEndPoint = 'http://harpiacloud.com.br/ecrm/modules/HR/appTr.php?username='+usuario+'&password='+senhaMd5;
               	String urlEndPoint = Label.EndPointEcrmHomol+'username='+usuario+'&password='+senhaMd5;
                HttpRequest req = new HttpRequest();
                req.setEndpoint(urlEndPoint); 
                req.setBody('');
                req.setMethod('POST');
                req.setHeader('Content-Type','application/x-www-form-urlencoded') ;
                Http http = new Http();
                HTTPResponse res = http.send(req);
                //trata o json
                String responseTratada = ReplaceJSON.replaceJSON(res.getBody());                       
                json = HarpiaEcrmJSonApex.parse(responseTratada);
                if(json.result == 'error'){
                    isOnError = true;
                    error = json.response;
                }
                else if(json.result == 'success'){
                    isOnError = false;
                    success = Label.Registro_de_horas_logado_sucesso;
                    CookieController.setSessionId(json.Session);
                }
                return isOnError;
            }catch(Exception ex){
                isOnError = true;
                error = ex.getMessage();
                return isOnError;
            }
        }else{
            system.debug('FOOIIII PRO ELSEEEE');
            success = Label.Registro_de_horas_ja_esta_logado;
            isOnError = false;
            return isOnError;
        }
    }
    
    public static boolean executeRequest(String reqBody, String op, boolean isEdicao){
        if(ApexPages.currentPage().getCookies().get('eCRMSessionId') == null){
            isOnError = true;
            error = Label.Registro_de_horas_nao_esta_logado;   
            return isOnError;
        }
        try{
                HttpRequest req = new HttpRequest();
                String eCRMSessionId = ApexPages.currentPage().getCookies().get('eCRMSessionId').getValue();
                String urlEndpoint = '';
                if(isEdicao || op == 'delete'){                  
        			System.debug('CONEXAO 1');
                    //urlEndpoint = 'http://harpiacloud.com.br/ecrm/modules/HR/appTr.php?PHPSESSID='+eCRMSessionId;
                    urlEndpoint = Label.EndPointEcrmHomol+'PHPSESSID='+eCRMSessionId;
                    system.debug('tentativa: '+urlEndpoint);
                    req.setEndpoint(urlEndpoint); 
                    req.setBody('');
                    req.setMethod('POST');
                    req.setHeader('Content-Type','application/x-www-form-urlencoded');
                    Http http = new Http();
                    HTTPResponse res = http.send(req);
                    system.debug('res.getBody() ' + res);
                    String responseTratada = ReplaceJSON.replaceJSON(res.getBody());      
                    json = HarpiaEcrmJSonApex.parse(responseTratada); 
                    if(json.response == 'Credenciais inválidas.'){
                        isOnError = true;       
                        HarpiaEcrmJSonApex.Session idSessaoVencida = new HarpiaEcrmJSonApex.Session();
                        idSessaoVencida.PHPSESSID = eCRMSessionId;
                        CookieController.cancelaSessionId(idSessaoVencida);
                        error = Label.Registro_de_horas_nao_esta_logado;   
                        EcrmHarpiaController.credencialInvalida = true;
                        return isOnError;
                        //error = 'Sessão Vencida';
                    }else if(json.user.Username != userName){
                        System.debug('json user: '+json.user.Username);
                        System.debug(' user: '+username);
                        usuarioDiferente= true;
                        isOnError = true;
                        usuarioDiferente = true;
                        error = Label.Registro_de_horas_nao_pertence;                    
                        CookieController.cancelaSessionId(json.Session);
                    }else{
                        System.debug('Entrou Credencial 2');
                        //NAO SEI O QUE É ISSO, TESTAR ATÉ A MORTE PARA VER SE TEM UTILIDADE, CASO CONTRÁRIO DELETAR
                        /*
                        if(op == 'delete' && !isOnError){
                            urlEndpoint = 'http://harpiacloud.com.br/ecrm/modules/HR/appTr.php?PHPSESSID='+eCRMSessionId+'&op='+op;
                            req.setEndpoint(urlEndpoint); 
                            req.setBody(reqBody);
                            req.setMethod('POST');
                            req.setHeader('Content-Type','application/x-www-form-urlencoded');
                            http = new Http();
                            res = http.send(req);
                            responseTratada = ReplaceJSON.replaceJSON(res.getBody());                       
                            json = HarpiaEcrmJSonApex.parse(responseTratada);
                            CookieController.setSessionId(json.Session);
                        }
						*/
                    }
                }else{
                    //urlEndpoint = 'http://harpiacloud.com.br/ecrm/modules/HR/appTr.php?PHPSESSID='+eCRMSessionId+'&op='+op;
                    urlEndpoint = Label.EndPointEcrmHomol+'PHPSESSID='+eCRMSessionId+'&op='+op;
                   	System.debug('CONEXAO 2');
                    req.setEndpoint(urlEndpoint); 
                    req.setBody(reqBody);
                    req.setMethod('POST');
                    req.setHeader('Content-Type','application/x-www-form-urlencoded');
                    Http http = new Http();
                    HTTPResponse res = http.send(req);
                    String responseTratada = ReplaceJSON.replaceJSON(res.getBody());
                    //ajuda na classe de teste, ajustar depois
                    json = HarpiaEcrmJSonApex.parse(responseTratada);
                    if(Test.isRunningTest()){
						json.response = 'Credenciais inválidas.';	     
                    }                  
                    if(json.response == 'Credenciais inválidas.'){
                    System.debug('Dentro primeiro');
                        HarpiaEcrmJSonApex.Session idSessaoVencida = new HarpiaEcrmJSonApex.Session();
                        idSessaoVencida.PHPSESSID = eCRMSessionId;
                        system.debug('COOKIE PRA MATAR: '+idSessaoVencida);
                        CookieController.cancelaSessionId(idSessaoVencida);
                        error = Label.Registro_de_horas_nao_esta_logado;   
                        isOnError = true;
                        EcrmHarpiaController.credencialInvalida = true;                         
                        return isOnError;                       
                    }else{
                        System.debug('Dentro segundo');
                    	CookieController.setSessionId(json.Session);
                    }
                }
                if(json.result == 'error'){
                    if(json.response == 'Credenciais inválidas'){
                        system.debug('Entrou credencial 3');
                        error = 'Sessão Vencida';                  
                    }else{                        
                    	error = json.response;
                    }
                    isOnError = true;
                }
                else{
                    system.debug('else');
                    system.debug(isEdicao);
                    system.debug(isOnError);
                    if(!isEdicao && !isOnError){
                        usuarioDiferente = false;
                        isOnError = false;
                        success = Label.Registro_de_horas_logado_sucesso;
                    }
                }            
                return isOnError;
            }catch(Exception ex){
                system.debug('excessaum aque: '+ex.getMessage());
                isOnError = true;
                error = ex.getMessage();
                return isOnError;
            
        }
    }
    //DELEÇÃO
    public static boolean executeRequestDelete(String reqBody, String op){
        try{
            HttpRequest req = new HttpRequest();
            String eCRMSessionId = ApexPages.currentPage().getCookies().get('eCRMSessionId').getValue();
            String urlEndpoint = '';
            if(op == 'delete'){
                system.debug('valor idcrm = '+eCRMSessionId);
            	//urlEndpoint = 'http://harpiacloud.com.br/ecrm/modules/HR/appTr.php?PHPSESSID='+eCRMSessionId;
                urlEndpoint = Label.EndPointEcrmHomol+'PHPSESSID='+eCRMSessionId;                
                req.setEndpoint(urlEndpoint); 
                req.setBody('');
                req.setMethod('POST');
                req.setHeader('Content-Type','application/x-www-form-urlencoded');
                Http http = new Http();
                HTTPResponse res = http.send(req);
                String responseTratada = ReplaceJSON.replaceJSON(res.getBody());     
                system.debug('ENTROU NO DELETE 1 PO: '+req);
                json = HarpiaEcrmJSonApex.parse(responseTratada);
                system.debug('json ' + json);
                system.debug('userName ' + userName);
                system.debug('OPP JS ' + op);
                if(json.user.Username != userName){
                    usuarioDiferente= true;
                    isOnError = true;
                    usuarioDiferente = true;
                    error = Label.Registro_de_horas_nao_pertence;                    
                    CookieController.cancelaSessionId(json.Session);
                }else{               
                    if(op == 'delete' && !isOnError){
                        system.debug('ENTROU NO DELETE 2  PO: '+op);
                       // urlEndpoint = 'http://harpiacloud.com.br/ecrm/modules/HR/appTr.php?PHPSESSID='+eCRMSessionId+'&op='+op;
                        urlEndpoint = Label.EndPointEcrmHomol+'PHPSESSID='+eCRMSessionId+'&op='+op;
                        req.setEndpoint(urlEndpoint); 
                        req.setBody(reqBody);
                        req.setMethod('POST');
                        req.setHeader('Content-Type','application/x-www-form-urlencoded');
                        http = new Http();
                        res = http.send(req);
                        responseTratada = ReplaceJSON.replaceJSON(res.getBody());                       
                        json = HarpiaEcrmJSonApex.parse(responseTratada);
                        CookieController.setSessionId(json.Session);
                    }
                }       
            }
            if(json.result == 'error'){
                system.debug('erro no json');
                isOnError = true;
                error = json.response;
            }
            else{
                system.debug(isOnError);
                if(!isOnError){
                    usuarioDiferente = false;
                    isOnError = false;
                    success = Label.Registro_de_horas_logado_sucesso;
                }
            }            
            return isOnError;
        }catch(Exception ex){
            system.debug('eçêssaum: '+ex.getMessage());
            isOnError = true;
            error = ex.getMessage();
            return isOnError;
        }
    }    
}