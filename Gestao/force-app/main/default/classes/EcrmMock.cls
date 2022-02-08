public class EcrmMock implements HttpCalloutMock {
    protected Integer code;
    protected String status;
    protected String bodyAsString;
    protected Blob bodyAsBlob;
    protected Map<String, String> responseHeaders;
    
    
    
    public EcrmMock() {         
    }
    
    
    public HTTPResponse respond(HTTPRequest request) {
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        //Seta a resposta em caso de consulto sem ser upsert ou delete
        String requeste = request.getEndpoint();
        
        system.debug('Requeste: '+requeste);
        
        if(requeste.contains('username=') && !requeste.contains('username=naoexiste')){
            system.debug('entrou qualquer coisa');
            res.setBody(
            '            {' + 
            '                "session": {' + 
            '                        "PHPSESSID":"b4298dd136be3c51276efdb98532e093"' + 
            '                            },' + 
            '                                "result" : "success",' + 
            '                                "user":{'+
            '									"Rowid":"3f0",' + 
            '                                "Name": "Paulo Furtado Volcov",' + 
            '										"Username":"pvolcov",'+
            '										"Work Hrs": "8"'+
            '                            },'+
            '								"response": "",'+
            '								"cost_centers":['+
            '								{'+
            '									"Rowid":"90-13-ed6",'+
            '									 "Code": "3.3.002.03",'+
            '								     "Description": "Administrativo Geral",'+
            '									 "Last Used": "Y"'+
            '								},'+
            '								{'+
            '									"Rowid":"ee-13-4e55",'+
            '									 "Code": "3.3.003.31",'+
            '								     "Description": "Ausência Outros Motivos Consultoria",'+
            '									 "Last Used": "Y"'+
            '								},'+
            '								{'+
            '									"Rowid":"90-13-efc",'+
            '									 "Code": "3.4.000.01",'+
            '								     "Description": "Bexpert Starup Harpia",'+
            '									 "Last Used": "Y"'+
            '								}'+
            '								],'+
            '						"periods": ['+
            '						{'+
            '							"Rowid": "3d0-13-583e",'+
            '							"Row Version": "1",'+
            '							"Start Date": "2016-04-16",'+
            '							"Final Date": "2016-04-30",'+
            ' 							"Name": "2ª quinzena - abril/16",'+
            '							"Ro Flg": "",'+
            ' 							"Status": "Aberto",'+
            '							"hours": ['+
            '                            {'+
            '                          	"Rowid": "3d0-13-585a",'+
            '                          	"Row Version": "1",'+
            '                         	"Hours": "8",'+
            '                        	"Over Time": "0",'+
            '                        	"Night Hours": "0",'+
            '                        	"Stand by": "0",'+
            '                        	"Date": "2016-04-21",'+
            '                        	"Period id": "3d0-13-583e",'+
            '                        	"Ro Flg": "Y",'+
            '                        	"Approved Flg": "Y",'+
            '                        	"Comments": "Campo preenchido automaticamente",'+
            '                       	"Path": "",'+
            '                      		"RealPath": "",'+
            '                      		"Cost Center": {'+
            '                        	"Rowid": "ee-13-4e4f",'+
            '                        	"Code": "3.3.003.25",'+
            '                        	"Description": "Feriado Consultoria",'+
            '                        	"Last Used": "N"'+
            '                      		}'+
            '                    		},'+	
            '                            {'+
            '                          		"Rowid": "3f0-13-5988",'+
            '                         		"Row Version": "1",'+
            '                        		"Hours": "4",'+
            '                       		"Over Time": "0",'+
            '                      			"Night Hours": "0",'+
            '                     			"Stand by": "0",'+
            '                    			"Date": "2016-04-15",'+
            '                   			"Period id": "3d0-13-5675",'+
            '                  				"Ro Flg": "N",'+
            '                 				"Approved Flg": "N",'+
            '                				"Comments": "Carga Leads, Conta e Contatos e relatórios",'+
            '               				"Path": "",'+
            '              					"RealPath": "",'+
            '             					"Cost Center": {'+
            '              					"Rowid": "90-13-eef",'+
            '             					"Code": "3.3.005.01",'+
            '            					"Description": "Comercial",'+
            '           					"Last Used": "N"'+
            '        						}'+
            '     						}'+
            '							]'+
            ' 						}'+
            '						]'+
            '				}'      
        	);
        }else if(requeste.contains('op=upsert')){
            system.debug('entrou upsert');
            res.setBody(
            '            {' + 
            '                "session": {' + 
            '                        "PHPSESSID":"b4298dd136be3c51276efdb98532e093"' + 
            '                            },' + 
            '                                "result" : "success",' + 
            '                                "user":{'+
            '									"Rowid":"3f0",' + 
            '                                "Name": "Paulo Furtado Volcov",' + 
            '										"Username":"pvolcov",'+
            '										"Work Hrs": "8"'+
            '                            },'+
            '								"response": "Registro apagado com sucesso",'+
            '								"cost_centers":['+
            '								{'+
            '									"Rowid":"90-13-ed6",'+
            '									 "Code": "3.3.002.03",'+
            '								     "Description": "Administrativo Geral",'+
            '									 "Last Used": "Y"'+
            '								},'+
            '								{'+
            '									"Rowid":"ee-13-4e55",'+
            '									 "Code": "3.3.003.31",'+
            '								     "Description": "Ausência Outros Motivos Consultoria",'+
            '									 "Last Used": "Y"'+
            '								},'+
            '								{'+
            '									"Rowid":"90-13-efc",'+
            '									 "Code": "3.4.000.01",'+
            '								     "Description": "Bexpert Starup Harpia",'+
            '									 "Last Used": "Y"'+
            '								}'+
            '								],'+
            '						"periods": ['+
            '						{'+
            '							"Rowid": "3d0-13-583e",'+
            '							"Row Version": "1",'+
            '							"Start Date": "2016-04-16",'+
            '							"Final Date": "2016-04-30",'+
            ' 							"Name": "2ª quinzena - abril/16",'+
            '							"Ro Flg": "",'+
            ' 							"Status": "Aberto",'+
            '							"hours": ['+
            '                            {'+
            '                          	"Rowid": "3d0-13-585a",'+
            '                          	"Row Version": "1",'+
            '                         	"Hours": "8",'+
            '                        	"Over Time": "0",'+
            '                        	"Night Hours": "0",'+
            '                        	"Stand by": "0",'+
            '                        	"Date": "2016-04-21",'+
            '                        	"Period id": "3d0-13-583e",'+
            '                        	"Ro Flg": "Y",'+
            '                        	"Approved Flg": "Y",'+
            '                        	"Comments": "Campo preenchido automaticamente",'+
            '                       	"Path": "",'+
            '                      		"RealPath": "",'+
            '                      		"Cost Center": {'+
            '                        	"Rowid": "ee-13-4e4f",'+
            '                        	"Code": "3.3.003.25",'+
            '                        	"Description": "Feriado Consultoria",'+
            '                        	"Last Used": "N"'+
            '                      		}'+
            '                    		},'+	
            '                            {'+
            '                          		"Rowid": "3f0-13-5988",'+
            '                         		"Row Version": "1",'+
            '                        		"Hours": "4",'+
            '                       		"Over Time": "0",'+
            '                      			"Night Hours": "0",'+
            '                     			"Stand by": "0",'+
            '                    			"Date": "2016-04-15",'+
            '                   			"Period id": "3d0-13-5675",'+
            '                  				"Ro Flg": "N",'+
            '                 				"Approved Flg": "N",'+
            '                				"Comments": "Carga Leads, Conta e Contatos e relatórios",'+
            '               				"Path": "",'+
            '              					"RealPath": "",'+
            '             					"Cost Center": {'+
            '              					"Rowid": "90-13-eef",'+
            '             					"Code": "3.3.005.01",'+
            '            					"Description": "Comercial",'+
            '           					"Last Used": "N"'+
            '        						}'+
            '     						},'+                
            '                           {'+
            '                          	"Rowid": "3d0-13-585t",'+
            '                          	"Row Version": "1",'+
            '                         	"Hours": "2",'+
            '                        	"Over Time": "3",'+
            '                        	"Night Hours": "4",'+
            '                        	"Stand by": "1",'+
            '                        	"Date": "2016-2-16",'+
            '                        	"Period id": "3d0-13-583e",'+
            '                        	"Ro Flg": "Y",'+
            '                        	"Approved Flg": "Y",'+
            '                        	"Comments": "teste",'+
            '                       	"Path": "",'+
            '                      		"RealPath": "",'+
            '                      		"Cost Center": {'+
            '                        	"Rowid": "90-13-ed6",'+
            '                        	"Code": "3.3.002.03",'+
            '                        	"Description": "Administrativo Geral",'+
            '                        	"Last Used": "N"'+
            '                      		}'+
            '                    		}'+	
            '							]'+
            ' 						}'+
            '						]'+
            '				}'      
        	);
            system.debug('body res: '+res.getBody());
        }else if(requeste.contains('op=delete') && !requeste.contains('PHPSESSID=naoexiste')){
            res.setBody(
            '            {' + 
            '                "session": {' + 
            '                        "PHPSESSID":"b4298dd136be3c51276efdb98532e093"' + 
            '                            },' + 
            '                                "result" : "success",' + 
            '                                "user":{'+
            '									"Rowid":"3f0",' + 
            '                                "Name": "Paulo Furtado Volcov",' + 
            '										"Username":"pvolcov",'+
            '										"Work Hrs": "8"'+
            '                            },'+
            '								"response": "Registro inserido com sucesso",'+
            '								"cost_centers":['+
            '								{'+
            '									"Rowid":"90-13-ed6",'+
            '									 "Code": "3.3.002.03",'+
            '								     "Description": "Administrativo Geral",'+
            '									 "Last Used": "Y"'+
            '								},'+
            '								{'+
            '									"Rowid":"ee-13-4e55",'+
            '									 "Code": "3.3.003.31",'+
            '								     "Description": "Ausência Outros Motivos Consultoria",'+
            '									 "Last Used": "Y"'+
            '								},'+
            '								{'+
            '									"Rowid":"90-13-efc",'+
            '									 "Code": "3.4.000.01",'+
            '								     "Description": "Bexpert Starup Harpia",'+
            '									 "Last Used": "Y"'+
            '								}'+
            '								],'+
            '						"periods": ['+
            '						{'+
            '							"Rowid": "3d0-13-583e",'+
            '							"Row Version": "1",'+
            '							"Start Date": "2016-04-16",'+
            '							"Final Date": "2016-04-30",'+
            ' 							"Name": "2ª quinzena - abril/16",'+
            '							"Ro Flg": "",'+
            ' 							"Status": "Aberto",'+
            '							"hours": ['+
            '                            {'+
            '                          	"Rowid": "3d0-13-585a",'+
            '                          	"Row Version": "1",'+
            '                         	"Hours": "8",'+
            '                        	"Over Time": "0",'+
            '                        	"Night Hours": "0",'+
            '                        	"Stand by": "0",'+
            '                        	"Date": "2016-04-21",'+
            '                        	"Period id": "3d0-13-583e",'+
            '                        	"Ro Flg": "Y",'+
            '                        	"Approved Flg": "Y",'+
            '                        	"Comments": "Campo preenchido automaticamente",'+
            '                       	"Path": "",'+
            '                      		"RealPath": "",'+
            '                      		"Cost Center": {'+
            '                        	"Rowid": "ee-13-4e4f",'+
            '                        	"Code": "3.3.003.25",'+
            '                        	"Description": "Feriado Consultoria",'+
            '                        	"Last Used": "N"'+
            '                      		}'+
            '                    		},'+	
            '                            {'+
            '                          		"Rowid": "3f0-13-5988",'+
            '                         		"Row Version": "1",'+
            '                        		"Hours": "4",'+
            '                       		"Over Time": "0",'+
            '                      			"Night Hours": "0",'+
            '                     			"Stand by": "0",'+
            '                    			"Date": "2016-04-15",'+
            '                   			"Period id": "3d0-13-5675",'+
            '                  				"Ro Flg": "N",'+
            '                 				"Approved Flg": "N",'+
            '                				"Comments": "Carga Leads, Conta e Contatos e relatórios",'+
            '               				"Path": "",'+
            '              					"RealPath": "",'+
            '             					"Cost Center": {'+
            '              					"Rowid": "90-13-eef",'+
            '             					"Code": "3.3.005.01",'+
            '            					"Description": "Comercial",'+
            '           					"Last Used": "N"'+
            '        						}'+
            '     						},'+                
            '                           {'+
            '                          	"Rowid": "3d0-13-585t",'+
            '                          	"Row Version": "1",'+
            '                         	"Hours": "2",'+
            '                        	"Over Time": "3",'+
            '                        	"Night Hours": "4",'+
            '                        	"Stand by": "1",'+
            '                        	"Date": "2016-2-16",'+
            '                        	"Period id": "3d0-13-583e",'+
            '                        	"Ro Flg": "Y",'+
            '                        	"Approved Flg": "Y",'+
            '                        	"Comments": "teste",'+
            '                       	"Path": "",'+
            '                      		"RealPath": "",'+
            '                      		"Cost Center": {'+
            '                        	"Rowid": "90-13-ed6",'+
            '                        	"Code": "3.3.002.03",'+
            '                        	"Description": "Administrativo Geral",'+
            '                        	"Last Used": "N"'+
            '                      		}'+
            '                    		}'+	
            '							]'+
            ' 						}'+
            '						]'+
            '				}'      
        	);
        }else if(requeste.contains('username=naoexiste')){
            res.setBody(
                '{'+
                '"response": "Usuário ou senha incorreta.",'+
                '"result": "error"'+
                '}'      
        	);  
        }else if(requeste.contains('PHPSESSID=naoexiste')){
            res.setBody(
                '{'+
                ' "response": "Credenciais inválidas.",'+
                ' "result": "error"'+
                '}'
            );
        }
        else{            
            system.debug('entrou qualquer coisa');
            res.setBody(
            '            {' + 
            '                "session": {' + 
            '                        "PHPSESSID":"b4298dd136be3c51276efdb98532e093"' + 
            '                            },' + 
            '                                "result" : "success",' + 
            '                                "user":{'+
            '									"Rowid":"3f0",' + 
            '                                "Name": "Paulo Furtado Volcov",' + 
            '										"Username":"pvolcov",'+
            '										"Work Hrs": "8"'+
            '                            },'+
            '								"response": "",'+
            '								"cost_centers":['+
            '								{'+
            '									"Rowid":"90-13-ed6",'+
            '									 "Code": "3.3.002.03",'+
            '								     "Description": "Administrativo Geral",'+
            '									 "Last Used": "Y"'+
            '								},'+
            '								{'+
            '									"Rowid":"ee-13-4e55",'+
            '									 "Code": "3.3.003.31",'+
            '								     "Description": "Ausência Outros Motivos Consultoria",'+
            '									 "Last Used": "Y"'+
            '								},'+
            '								{'+
            '									"Rowid":"90-13-efc",'+
            '									 "Code": "3.4.000.01",'+
            '								     "Description": "Bexpert Starup Harpia",'+
            '									 "Last Used": "Y"'+
            '								}'+
            '								],'+
            '						"periods": ['+
            '						{'+
            '							"Rowid": "3d0-13-583e",'+
            '							"Row Version": "1",'+
            '							"Start Date": "2016-04-16",'+
            '							"Final Date": "2016-04-30",'+
            ' 							"Name": "2ª quinzena - abril/16",'+
            '							"Ro Flg": "",'+
            ' 							"Status": "Aberto",'+
            '							"hours": ['+
            '                            {'+
            '                          	"Rowid": "3d0-13-585a",'+
            '                          	"Row Version": "1",'+
            '                         	"Hours": "8",'+
            '                        	"Over Time": "0",'+
            '                        	"Night Hours": "0",'+
            '                        	"Stand by": "0",'+
            '                        	"Date": "2016-04-21",'+
            '                        	"Period id": "3d0-13-583e",'+
            '                        	"Ro Flg": "Y",'+
            '                        	"Approved Flg": "Y",'+
            '                        	"Comments": "Campo preenchido automaticamente",'+
            '                       	"Path": "",'+
            '                      		"RealPath": "",'+
            '                      		"Cost Center": {'+
            '                        	"Rowid": "ee-13-4e4f",'+
            '                        	"Code": "3.3.003.25",'+
            '                        	"Description": "Feriado Consultoria",'+
            '                        	"Last Used": "N"'+
            '                      		}'+
            '                    		},'+	
            '                            {'+
            '                          		"Rowid": "3f0-13-5988",'+
            '                         		"Row Version": "1",'+
            '                        		"Hours": "4",'+
            '                       		"Over Time": "0",'+
            '                      			"Night Hours": "0",'+
            '                     			"Stand by": "0",'+
            '                    			"Date": "2016-04-15",'+
            '                   			"Period id": "3d0-13-5675",'+
            '                  				"Ro Flg": "N",'+
            '                 				"Approved Flg": "N",'+
            '                				"Comments": "Carga Leads, Conta e Contatos e relatórios",'+
            '               				"Path": "",'+
            '              					"RealPath": "",'+
            '             					"Cost Center": {'+
            '              					"Rowid": "90-13-eef",'+
            '             					"Code": "3.3.005.01",'+
            '            					"Description": "Comercial",'+
            '           					"Last Used": "N"'+
            '        						}'+
            '     						}'+
            '							]'+
            ' 						}'+
            '						]'+
            '				}'      
        	);        
        }
        
        
        
        
        
        
        res.setStatusCode(200);
        return res;
    }
    
}