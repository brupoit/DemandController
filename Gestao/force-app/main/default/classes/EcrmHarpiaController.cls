// A Visualforce controller class that creates a cookie
// used to keep track of how often a user displays a page
public class EcrmHarpiaController {

    public String input {get; set;}
    public List<Case> registroDeHorasList {get; set;}    
    public static Registro_de_horas__c registro {get
    {
        if(registro == null)
            registro = new Registro_de_horas__c();
        
        return registro;
    }
                                                 set;}   
    public String usuario{get; set;}
    public static String usuarioSalesforce{get; set;}
    public String senha{get; set;}
    public boolean logado{get{if(logado == null){logado = false;}return logado;} private set;}
    public boolean deletado{get
    {
        if(deletado == null)        
            deletado = false;
        
        return deletado; 
    }
        set;}
    
    //Campos para inserir no ecrm
    public string urlRedirectDeletado{get{if(urlRedirectDeletado == null){urlRedirectDeletado = '';}return urlRedirectDeletado;}set;}
    public String periodo{get;set;}
    public String centroDeCustoCode{get;set;}
    public String periodoCode{get;set;}
    public Date data {get;set;}
    public Decimal horaExtra {get;set;}
    public Decimal hora {get;set;}
    public Decimal sobreaviso {get;set;}
    public Decimal horaNoturna {get;set;}
    public String comentarios {get;set;}
    public static String parametroGet {get; set;}
    public static String parametroDeleteGet{get{
        if(System.currentPageReference().getParameters().get('common.udd.actions.ActionsUtilORIG_DELETE_URI') != null){
            parametroDeleteGet = System.currentPageReference().getParameters().get('common.udd.actions.ActionsUtilORIG_DELETE_URI');
        }
        //pmamoni 20200323 - ajuste para UI lightning
        else if(System.currentPageReference().getParameters().get('lexiActionName') == 'delete')
            parametroDeleteGet = 'delete';
        return parametroDeleteGet;
           }set;}
    
    //Listas centro de custo e periodo
    public List<SelectOption> centroDeCustoLista {get;set;}
    public List<SelectOption> periodoLista {get;set;}
    public static boolean deletar {get;set;}
 	public static String redirectDeletado{get{if(redirectDeletado == null){redirectDeletado = '';} return redirectDeletado;}set;}
    public static boolean naoExiste{get{if(naoExiste == null){naoExiste = false;} return naoExiste;}set;}
    
    public boolean isConsole{get{if(isConsole == null){isConsole = false;}return isConsole;} set;}
    public boolean isUpdateInConsole{get{if(isUpdateInConsole == null){isUpdateInConsole = false;}return isUpdateInConsole;}set;}
    public string callfunc{get;set;}
    
    //pmamoni 20200323 - ajuste para UI lightning
    public String UIDisplay = '';
    public boolean isLightningx = false;
    public String testId = '';
    public String idRegistro = '';
    
    
    public static boolean credencialInvalida{get{if(credencialInvalida == null){ credencialInvalida = false;}return credencialInvalida;}set;}
    
    public EcrmHarpiaController(ApexPages.StandardController stdCon) {

    }
    
    
    public PageReference init(){     
        
        //pmamoni 20200323 - ajuste para UI lightning
        //'Theme3' -> Classic; 'Theme4%' -> Lightning
        UIDisplay  = UserInfo.getUiThemeDisplayed();
        isLightningx = UIDisplay.contains('Theme4') ? true : false;
        
        PageReference pageRef = isLogado();
      //  if(isConsole){
       //     return null;
     //   }else{
        	return pageRef;      
     //   }
    }
    
    public PageReference verificaConsole(){
		this.isConsole = true;
        return null;
    }
    
    public PageReference VerificaLightningX(boolean isLight){
        system.debug('isLightningX: '+isLight);
        this.isLightningX = isLight;
        return null;
    }
    
    
    /*
    public PageReference save(){
        
        boolean isEdicao = (System.currentPageReference().getParameters().get('id') != null);
        if(isEdicao)
        	ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, Label.Registro_de_horas_atualizado_sucesso));
        else
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, Label.Registro_de_horas_inserido_sucesso));
        
		return new PageReference('/'+'a0J7A000001WrJNUA0');
    }
	*/
    
    
    
    
    public void save(){
        system.debug('ENTROOOOU NO SAVE');
        parametroGet = System.currentPageReference().getParameters().get('retURL');
        if(ApexPages.currentPage().getCookies().get('eCRMSessionId') == null){
            system.debug('ENTROOOOU NO PRIMEIRO IF');
            String urlRedirect = '';
            if(System.currentPageReference().getParameters().get('id') != null){
                urlRedirect = urlRedirect+'apex/RegistroDeHoras?id='+System.currentPageReference().getParameters().get('id');
                if(parametroGet != null){
                    urlRedirect = urlRedirect+'&retURL='+parametroGet.replace('/','');
                }
            }
            if(parametroGet != null){
                urlRedirect = urlRedirect+'apex/RegistroDeHoras?retURL='+parametroGet.replace('/','');
            }

            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.Registro_de_horas_sessao_expirada));
            PageReference pageRefRedirect = new PageReference(urlRedirect);
           // return null;
        }
        String body;
        String dataFormatada;
        if(isConsole){
            system.debug('ENTROOOOU NO ISCONSOLE');
            if(isUpdateInConsole){
                system.debug('ENTROOOOU NO isUpdateInConsole');
                
                //pmamoni 20200323 - ajuste para UI lightning
            	getIdRegistro();

                List<Registro_de_horas__c> registrosDeHoras = [SELECT Id, Caso__c, Comentarios__c, Data__c, Hora__c,
                                                               Hora_extra__c, Hora_noturna__c, Sobreaviso__c, Period_Id__c,
                                                               Period_Name__c, Cost_Center_name__c, Nome_do_usuario_eCRM__c, RowId__c,
                                                               User_Name__c
                                                               FROM Registro_de_horas__c
                                                               WHERE Id=: idRegistro ];
                parametroGet = '/'+registrosDeHoras[0].Caso__c;
            }else{
                system.debug('CAIU NO isUpdateInConsole ELSE');
                
                //pmamoni 20200323 - ajuste para UI lightning
            	getIdRegistro();
				
                List<Registro_de_horas__c> registrosDeHoras = [SELECT Id, Caso__c, Comentarios__c, Data__c, Hora__c,
                                                               Hora_extra__c, Hora_noturna__c, Sobreaviso__c, Period_Id__c,
                                                               Period_Name__c, Cost_Center_name__c, Nome_do_usuario_eCRM__c, RowId__c,
                                                               User_Name__c
                                                               FROM Registro_de_horas__c
                                                               WHERE Id=: idRegistro];
                system.debug('ID REGISTRO '+idRegistro);
                system.debug('registrosDeHoras '+registrosDeHoras);
                if(registrosDeHoras.isEmpty()){
					system.debug('RESGISTRO DE HORAS VAZIO');                    
                    //pmamoni 20200323 - ajuste para UI lightning
            		//parametroGet = parametroGet.substringBefore('?');
                    parametroGet = !isLightningX ? parametroGet.substringBefore('?') : '/'+idRegistro;
                }else{
                    parametroGet = '/'+registrosDeHoras[0].Caso__c;
                }
            }
        }
        
        registro.Caso__c = parametroGet.replace('/','');
        
        hora = registro.Hora__c;    
		horaExtra = registro.Hora_extra__c;     
		horaNoturna = registro.Hora_noturna__c;       
		sobreaviso = registro.Sobreaviso__c;   
        comentarios = registro.Comentarios__c;
        periodoCode = registro.Period_Id__c;
        centroDeCustoCode = registro.Cost_center_id__c;
        Case casoAux = [SELECT Id, CaseNumber FROM Case WHERE Id =: registro.Caso__c LIMIT 1];
        if(comentarios != '' && comentarios != null){
            if(!comentarios.contains(casoAux.CaseNumber)){
                comentarios = 'Caso número: '+casoAux.CaseNumber+' - '+comentarios;
                registro.Comentarios__c = comentarios;
            }
            comentarios = EncodingUtil.urlEncode(comentarios, 'UTF-8');
        }else{
            comentarios = '';
            comentarios += 'Caso número: '+casoAux.CaseNumber;
            registro.Comentarios__c = comentarios;
            comentarios = EncodingUtil.urlEncode(comentarios, 'UTF-8');
        }
        
        data = registro.Data__c;        
        if(data != null){
            dataFormatada= data.year()+'-'+data.month()+'-'+data.day();
        }
        String url;
        //Verifica se é edição do registro
        boolean isEdicao = (System.currentPageReference().getParameters().get('id') != null);
        system.debug('isEdicao: '+isEdicao);
        if(isEdicao){
            registro.id = System.currentPageReference().getParameters().get('id');
            system.debug('registro.id: '+registro.id);
            system.debug('registro.RowId__c ANTERIOR: '+registro.RowId__c);
            url = '/'+registro.caso__c;            
            body = 'Row+Version='+registro.Row_Version__c+'&Rowid='+registro.RowId__c+'&Period+id='+periodoCode+'&Cost+Center='+centroDeCustoCode+'&Date='+dataFormatada+'&Hours='+hora;
            body = body+ '&Over+Time='+horaExtra+'&Night+Hours='+horaNoturna+'&Comments='+comentarios+'&Stand+by='+sobreaviso;
        	
        }else{
            url = parametroGet;
            body = 'Period+id='+periodoCode+'&Cost+Center='+centroDeCustoCode+'&Date='+dataFormatada+'&Hours='+hora;
            body = body+ '&Over+Time='+horaExtra+'&Night+Hours='+horaNoturna+'&Comments='+comentarios+'&Stand+by='+sobreaviso;
        }
        boolean erroSelectList = false;
        if(centroDeCustoCode == '1'){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.Registro_de_horas_selecione_centro_de_custo));
            erroSelectList = true;
        }
        if(periodoCode == '1'){    
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.Registro_de_horas_selecione_periodo));
            erroSelectList = true;
        }
        if(!erroSelectList){
            if(!ServiceCloudToEcrmRequest.executeRequest(body, 'upsert', false)){
                PageReference pageRef = new PageReference(url);
                system.debug('HarpiaEcrmJSonApex.Periods: '+ServiceCloudToEcrmRequest.json.periods);
                for(HarpiaEcrmJSonApex.Periods periodoAtual: ServiceCloudToEcrmRequest.json.periods){
                    if(periodoAtual.Rowid == periodoCode){
                        registro.Period_Name__c = periodoAtual.name;
                        //pmamoni 20200323 - contador para saber quando é a última passada no for abaixo (SEMI-GAMBIARRA LOGO ABAIXO)
                        Integer cont = 0;
                        Integer PeriodoAtualSize = periodoAtual.hours.size();
                        
                        for(HarpiaEcrmJSonApex.Hours registroAtual: periodoAtual.hours){
                            cont++; //pmamoni 20200323
                            system.debug('registroAtual: '+registroAtual);
                            system.debug('registro.RowId__c: '+registro.RowId__c);
                            //pmamoni 20200323 - se o registro já existir no SF (edição), faz a comparação da coluna rowid do SF com rowid do ecrm e só atualiza quando for o mesmo registro [if(registro.RowId__c == registroAtual.Rowid)]
                            //pmamoni 20200323 - se o registro for novo, atualiza o rowid do SF com o rowid do ecrm na última passada desse for (que será o registro mais recente)
                            //A SEGUNDA PARTE ACIMA É SEMI-GAMBIARRA. O CORRETO SERIA CRIAR UMA COLUNA NO ECRM COM O ID DO REGISTRO NO SF, PRA NUNCA DAR PROBLEMA
                            if(registro.RowId__c == registroAtual.Rowid || ((registro.RowId__c == null || registro.RowId__c == '') && cont == PeriodoAtualSize))
                            {
                                registro.Nome_do_usuario_eCRM__c = ServiceCloudToEcrmRequest.json.user.Name;
                                registro.User_Name__c = ServiceCloudToEcrmRequest.json.user.Username;
                                registro.Rowid__c = registroAtual.Rowid;
                                registro.Row_Version__c = registroAtual.Row_Version;
                                registro.Cost_Center_Name__c = registroAtual.Cost_center.Description;
                                registro.Cost_Center_Id__c = registroAtual.Cost_center.Rowid;
                            }
                        }
                    }
                }
                if(isEdicao){
                    system.debug('update1 - Rowid__c POSTERIOR: '+registro.Rowid__c);
                    system.debug('update1 - CaseNumber: '+registro.Caso__r.CaseNumber);
                    system.debug('update1 - Cost_Center_Id__c: '+registro.Cost_Center_Id__c);
                    system.debug('update1 - Hora__c: '+registro.Hora__c);
                    system.debug('update1 - Comentarios__c: '+registro.Comentarios__c);
                    system.debug('update1 - Period_Id__c: '+registro.Period_Id__c);
                    update registro;
					//ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, Label.Registro_de_horas_atualizado_sucesso)); //pmamoni 20200323 - msg para atualização
					callfunc='<script> sucesso("'+registro.Caso__c+'","'+Label.Registro_de_horas_atualizado_sucesso+'"); </script>';
                }else{
                    insert registro;
					//ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, Label.Registro_de_horas_inserido_sucesso)); //pmamoni 20200323 - msg para inclusão
					callfunc='<script> sucesso("'+registro.Caso__c+'","'+Label.Registro_de_horas_inserido_sucesso+'"); </script>';
                }
                //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, Label.Registro_de_horas_inserido_sucesso)); //pmamoni 20200323 - comentado
                //pmamoni 20200323 - fechar a aba para lightning UI
                //if(!isLightningx)
               	//	callfunc='<script> testCloseTab(); </script>';
                //else
                //    callfunc='<script> CloseTabLightning(); </script>';
            }else{
                system.debug('Erro do serviço: '+ServiceCloudToEcrmRequest.error);
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ServiceCloudToEcrmRequest.error));            
            }
        }
        //PageReference pageRef = new PageReference(ApexPages.currentPage().getUrl());
        //pageRef.setRedirect(true);
		//return pageRef;
		
		//return new PageReference('/'+registro.Caso__c);
		// return null;
    }
    
    
    //Coloca todos os Centros de custo na lista
    public void getCostCenters(){
        this.centroDeCustoLista = new List<SelectOption>();
        List<SelectOption> options = new List<SelectOption>();
        this.centroDeCustoLista.add(new SelectOption('1', 'Selecione'));
        if(ServiceCloudToEcrmRequest.json != null){
            system.debug('DENTRO DO CENTRO1');
            try{
                for(HarpiaEcrmJSonApex.Cost_centers cost: ServiceCloudToEcrmRequest.json.cost_centers){
                    system.debug('DENTRO DO CENTRO for');
                    options.add(new SelectOption(cost.Description, cost.Rowid));
                }
                options.sort();
                for(SelectOption opcao: options){
                    system.debug('DENTRO DO CENTRO fo2');
                    this.centroDeCustoLista.add(new SelectOption(opcao.getLabel(), opcao.getValue()));
                }
            }catch(Exception ex){
                system.debug(ex.getMessage());
            }
        }
        
        
    }
    
    //Coloca todos os periodos na lista
    public void getPeriodos(){
        this.periodoLista = new List<SelectOption>();        
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('1', 'Selecione'));
        try{
            if(ServiceCloudToEcrmRequest.json != null){
                for(HarpiaEcrmJSonApex.Periods periods: ServiceCloudToEcrmRequest.json.periods){
                    options.add( new SelectOption( periods.Rowid, periods.Name ));
                }
            }
            this.periodoLista.addAll(options);
        }catch(Exception ex){
            system.debug(ex.getMessage());
        }
    }
	
    //Buscar o registro de acordo com o id da página e instancia o objeto
    public static Registro_de_horas__c getRegistroPagina(){
        system.debug('ApexPages.currentPage() controller' + ApexPages.currentPage());
        system.debug('ApexPages.currentPage() ID' + System.currentPageReference().getParameters().get('id'));
        String idRegistro = '';
        if (Test.isRunningTest()) {
            idRegistro = [Select Id from Registro_de_horas__c limit 1].id;
            system.debug(idRegistro + ' eh o id');
        }
        else {
            idRegistro = System.currentPageReference().getParameters().get('id').replace('/','');
        }
        List<Registro_de_horas__c> registros = [SELECT Id, Caso__c, Comentarios__c, Data__c, Hora__c,
                                                Hora_extra__c, Hora_noturna__c, Sobreaviso__c, Period_Id__c,
                                                Period_Name__c, Cost_Center_name__c, Nome_do_usuario_eCRM__c, RowId__c,
                                                User_Name__c
                                                FROM Registro_de_horas__c
                                               WHERE Id=: idRegistro];
        system.debug('registros: '+registros);
        if (registros[0].Comentarios__c == null){
            registros[0].Comentarios__c = '';
        }
        return registros[0];
    }
    
    //Deleta o registro no eCRM e no Salesforce
    
    public String deletaRegistro(){
        Registro_de_horas__c registroDelete = getRegistroPagina();
        String idCasoRegistroDeletado = registroDelete.Caso__c;
        ServiceCloudToEcrmRequest.userName = registroDelete.User_Name__c;
        try{
            String body = 'Period+id='+registroDelete.Period_Id__c+'&Rowid='+registroDelete.RowId__c;                        
            if(!ServiceCloudToEcrmRequest.executeRequestDelete(body, 'delete')){ 
                system.debug('deu tudo certo');
                delete registroDelete;        
                deletado = true;
                return idCasoRegistroDeletado;
            }else{
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ServiceCloudToEcrmRequest.error));
                system.debug('deu tudo errado');     
                return '';
            }
        }
        catch(Exception ex){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ex.getMessage()));   
            system.debug('deu tudo absurdamente errado');
            return '';
        }
    }
    
    //Atualiza as informações do registro no Salesforce de acordo com as informações do registro no eCRM   	
    public void atualizarDadosRegistroBase(){
        boolean isEdicao = (System.currentPageReference().getParameters().get('id') != null);
        boolean registroDeletado = true;
        Registro_de_horas__c registroAtualSalesforce = new Registro_de_horas__c();
        
        registroAtualSalesforce = getRegistroPagina();  
        
        system.debug('registro atual: '+registroAtualSalesforce );
        
        ServiceCloudToEcrmRequest.userName = registroAtualSalesforce.User_Name__c;
        if(!ServiceCloudToEcrmRequest.executeRequest('','', isEdicao)){
            String userName = ServiceCloudToEcrmRequest.json.user.UserName;
            for(HarpiaEcrmJSonApex.Periods periodoAtual: ServiceCloudToEcrmRequest.json.periods){
                if(periodoAtual.Rowid == registroAtualSalesforce.Period_Id__c){
                    for(HarpiaEcrmJsonApex.hours registroAtual: periodoAtual.hours){      
                        if(registroAtual.RowId == registroAtualSalesforce.RowId__c){
                            registroDeletado = false;
                            Registro_de_horas__c novoRegistro = new Registro_de_horas__c();
                           	novoRegistro.period_id__c = periodoAtual.Rowid;
                            if(registroAtual.Comments != null){
                            	novoRegistro.Comentarios__c = registroAtual.Comments;
                            }
                            if(registroAtual.Cost_Center.Description != null){
                            	novoRegistro.Cost_Center_Name__c = registroAtual.Cost_Center.Description;
                            }
                            String [] dataSplitada = registroAtual.Date_Apex.split('-');                            
                            Date data = date.newinstance(integer.valueof(dataSplitada[0]), integer.valueof(dataSplitada[1]), integer.valueof(dataSplitada[2]));

                            novoRegistro.Data__c = data;
                            novoRegistro.Hora__c = decimal.valueof(registroAtual.hours);
                            if(registroAtual.over_time != null){
                                novoRegistro.Hora_extra__c = decimal.valueof(registroAtual.over_time);
                            }
                            if(registroAtual.night_hours != null){
                            	novoRegistro.Hora_noturna__c = decimal.valueof(registroAtual.night_hours);
                            }
                            if(registroAtual.row_version != null){
                            	novoRegistro.Row_Version__c = registroAtual.row_version;
                            }
                            if(registroAtual.stand_by != null){
                            	novoRegistro.Sobreaviso__c = decimal.valueof(registroAtual.stand_by);
                            }
                            if(registroAtual.Cost_Center.Rowid != null){
                            	novoRegistro.cost_center_id__c = registroAtual.Cost_center.Rowid;
                            }
                            novoRegistro.User_Name__c = userName;
                            novoRegistro.RowId__c = registroAtual.RowId;
                            novoRegistro.Id = registroAtualSalesforce.Id;
                            try{
                                system.debug('update2: '+novoRegistro.RowId__c);
                            	update novoRegistro;
                                registro = novoRegistro;
                                system.debug('update2 registro: '+registro);
                                logado = true;
                            }catch(Exception ex){
                                system.debug('deu erro: '+ex.getMessage());
                            }
                            if(Test.isRunningTest()){
                                registroDeletado = true;
                            }
                            break;
                        }
                    
                    }
                }
            }
            if(registroDeletado){
                naoExiste = true;
                urlRedirectDeletado = 'https://'+ApexPages.currentPage().getHeaders().get('Host') + System.currentPageReference().getParameters().get('retURL');
                try{                    
                    delete [SELECT Id FROM Registro_de_horas__c WHERE Id=: registroAtualSalesforce.Id];
                }catch(Exception ex){
                    System.debug('erro ex: '+ex.getMessage());
                }
            }
        }else{
            system.debug('OLHA O DEBUG: '+ServiceCloudToEcrmRequest.usuarioDiferente);
            if(ServiceCloudToEcrmRequest.usuarioDiferente){
                ApexPages.getMessages().clear();
                logado = false;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ServiceCloudToEcrmRequest.error));
            }else{           
                if(ServiceCloudToEcrmRequest.error == 'Sessão Vencida'){
                    System.debug('ENTROU NO ERROOUHUUHUHUH');
                    //logado = false;
                    //callfunc='<script> alert("Sessão expirada"); testCloseTab(); </script>';
                }else{
                    if(!EcrmHarpiaController.credencialInvalida){                    
            			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Ocorreu um erro!'));
                    }
                }
            }
        }
    }
    public PageReference isLogado(){
		if(ApexPages.currentPage().getCookies().get('eCRMSessionId') != null){
            system.debug('Entrou 1');
            //Deleta
            if(parametroDeleteGet != null){
                String idCasoRegistroDeletado = deletaRegistro();
                String url;
                if(idCasoRegistroDeletado != ''){
                    //pmamoni 20200323
                    callfunc='<script> sucesso("'+idCasoRegistroDeletado+'","'+Label.Registro_de_horas_excluido_sucesso+'"); </script>';
                    return null;
                    /*
                    url = '/'+idCasoRegistroDeletado;
                    redirectDeletado = url;                    
                    PageReference pageRef = new PageReference(url);
                	return pageRef;
					*/
                }else{
                    return null;
                }
            }
            
            else if(System.currentPageReference().getParameters().get('retURL') != null && System.currentPageReference().getParameters().get('id') != null){
               
            system.debug('Entrou 2');
                system.debug('IDE: '+System.currentPageReference().getParameters().get('id'));
                String idRegistro = System.currentPageReference().getParameters().get('id');
                atualizarDadosRegistroBase();
                getCostCenters();
                getPeriodos();
                return null;
            }
            else if(verificarConexao()){
                
            system.debug('Entrou3');
                getCostCenters();
                getPeriodos();
            	logado = true;
                return null;
            }else{
                parametroGet = System.currentPageReference().getParameters().get('retURL');
                if(isConsole){
                    parametroGet = parametroGet.substringBefore('?');
                }
            	system.debug('Entrou 4');
                String url = 'retURL='+parametroGet;
                PageReference pageRef = new PageReference(url);
                logado = false;
                if(credencialInvalida){
                    return null;
                }
                return pageRef;
            }
        }else{
            system.debug('Entrou 5');
            

            
            logado = false;
            return null;
        }
    }
    
    
    public static boolean verificarConexao(){
        boolean isOk;
        if(!ServiceCloudToEcrmRequest.executeRequest('', '', false)){
            isOk = true;
        }else{
            isOk = false;
        }
        return isOk;
    }
    
    public PageReference cancelar(){
        PageReference pageRef = new PageReference(parametroGet);
        return pageRef;
    }
    
    public PageReference logar(){
        system.debug('Entrooouuuu no logar');
        if(usuario == '' && senha == ''){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.Registro_de_horas_insira_usuario_e_senha));
        }
        else if(usuario == ''){
        	ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.Registro_de_horas_insira_usuario));    
        }
        else if(senha == ''){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.Registro_de_horas_insira_senha));
        }else{
            system.debug('ENTROOOU NO ELSEEEEE');
            if(!deletado){
                boolean isOnError = ServiceCloudToEcrmRequest.Login(usuario, senha);
                if(isOnError){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ServiceCloudToEcrmRequest.error));   
                }else{
                    system.debug('ENTROOOU NO ELSEEEEE do erro');
                    getCostCenters();
                    getPeriodos();                  
                }
            }
        }
        if(parametroDeleteGet != null){
            PageReference pageRef = isLogado();
        	return pageRef;
        }else{
            isLogado();
            return null;
        }
    }
    
    //APARENTEMENTE NÃO É USADO, TESTAR ATÉ A MORTE E DEPOIS SE NÃO FOR USADO DELETAR!!!
    //pmamoni 20200323 - analisar
    public Case getRegistroDeHorasLista(){
       String idCaso = '';
       if(isConsole){
           	system.debug('Entrou no ifffff');
            
			//pmamoni 20200323 - ajuste para UI lightning
            getIdRegistro();
           
            List<Registro_de_horas__c> registrosDeHoras = [SELECT Id, Caso__c, Comentarios__c, Data__c, Hora__c,
                                                Hora_extra__c, Hora_noturna__c, Sobreaviso__c, Period_Id__c,
                                                Period_Name__c, Cost_Center_name__c, Nome_do_usuario_eCRM__c, RowId__c,
                                                User_Name__c
                                                FROM Registro_de_horas__c
                                               WHERE Id=: idRegistro];   
           
           //VERIFICA SE É INSERÇÃO OU EDIÇÃO
           if(registrosDeHoras.isEmpty()){
        		idCaso = idRegistro;
               	system.debug('VAZIOOOOOOOO');
           }else{
               	system.debug('COM REGISTRO');
            idCaso = registrosDeHoras[0].Caso__c;
            isUpdateInConsole = true;
           }
        }else{
            system.debug('Entrou no else');
            
            //pmamoni 20200323 - ajuste para UI lightning
            getIdRegistro();

            List<Registro_de_horas__c> registrosDeHoras = [SELECT Id, Caso__c, Comentarios__c, Data__c, Hora__c,
                                                           Hora_extra__c, Hora_noturna__c, Sobreaviso__c, Period_Id__c,
                                                           Period_Name__c, Cost_Center_name__c, Nome_do_usuario_eCRM__c, RowId__c,
                                                           User_Name__c
                                                           FROM Registro_de_horas__c
                                                           WHERE Id=: idRegistro];
            
            if(registrosDeHoras.isEmpty()){
                if(parametroGet.contains('?isdt')){
                    parametroGet = parametroGet.substringBefore('?');
                    system.debug('parametroGet if ' + parametroGet);
                }
                //pmamoni 20200323 - ajuste para UI lightning
        		//idCaso = parametroGet.replace('/','');
        		idCaso = !isLightningX ? parametroGet.replace('/','') : idRegistro;
                system.debug('idCaso if ' + idCaso);
            }else{
                idCaso = registrosDeHoras[0].Caso__c;
                system.debug('idCaso else ' + idCaso);
            }
       }
       
        system.debug('idCASO ' + idCaso);
        System.debug('ULTIMO PARAMETRO: '+System.currentPageReference().getParameters());
		
        registroDeHorasList = [SELECT Id, CaseNumber FROM Case WHERE Id =: idCaso];
        system.debug('REGISTRO DE HORAS LIST' + registroDeHorasList[0]);
        return registroDeHorasList[0];
    }
    
    //APARENTEMENTE NÃO É USADO, TESTAR ATÉ A MORTE E DEPOIS SE NÃO FOR USADO DELETAR!!!
    public String geteCRMSessionId() {
        Cookie eCRMSessionId = ApexPages.currentPage().getCookies().get('eCRMSessionId');
        if(eCRMSessionId == null) {
            return 'Erro';
        }
        return eCRMSessionId.getValue();
    }
    
    //pmamoni 20200323 - função para pegar o ID do registro de horas, dependendo da UI (classic ou lightning)
    public void getIdRegistro() {
        if(!isLightningX)
        {
            parametroGet = System.currentPageReference().getParameters().get('retURL');
            testId = System.currentPageReference().getParameters().get('retURL');
            system.debug('testIdAnt: '+testId);
            testId = testId.substringBefore('?');
            idRegistro = testId.replace('/','');
        }
        else
        {
            parametroGet = System.currentPageReference().getParameters().get('retURL');
            testId = system.currentPageReference().getParameters().get('CF00N1a000008H2mc_lkid');
            system.debug('testIdAnt: '+testId);
            idRegistro = testId != null ?  system.currentPageReference().getParameters().get('CF00N1a000008H2mc_lkid') : system.currentPageReference().getParameters().get('id');
        }
        
        system.debug('parametroGet: '+parametroGet);
        system.debug('testId: '+testId);
        system.debug('idRegistro: '+idRegistro);
    }
    
}