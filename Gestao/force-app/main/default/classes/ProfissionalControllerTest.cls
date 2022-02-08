@isTest
public class ProfissionalControllerTest {

    @TestSetup
    static void criarDados(){

        DataFactoryShared.createIndisponibilidade();
        
    }

    @isTest
    public static void getCapacityPorPerfilTest(){
        
        String exp = '[{"somaCapacityPerfil":16.0,"contagemPerfil":1,"perfilProfissional":"Perfil Teste"}]';
        String msg = 'O retorno do método não é o esperado';
        // Profissional__c pro = [SELECT Id, Name FROM Profissional__c WHERE Name = 'Pro Teste' LIMIT 1];
        String ret = ProfissionalController.getCapacityPorPerfil();
        system.debug('retorno');
        system.debug(ret);
        system.assertEquals(exp, ret, msg);
    }

    @isTest
    public static void getAllProfissionalTest(){

        Profissional__c pro = [SELECT Id, Perfil_Profissional__c FROM Profissional__c LIMIT 1];
        String exp = '[{"attributes":{"type":"Profissional__c","url":"/services/data/v54.0/sobjects/Profissional__c/' + pro.Id + '"},"Name":"Pro Teste","Perfil_Profissional__c":"' + pro.Perfil_Profissional__c + '","Carga_Horaria_Perfil__c":8.00,"Periodicidade_Perfil__c":"Diária","Inicio_Contrato__c":"2022-02-02","Id":"' + pro.Id + '","Perfil_Profissional__r":{"attributes":{"type":"Perfil_Profissional__c","url":"/services/data/v54.0/sobjects/Perfil_Profissional__c/' + pro.Perfil_Profissional__c + '"},"Id":"' + pro.Perfil_Profissional__c + '","Name":"Perfil Teste"}}]';
        String msg = 'O retorno do método não é o esperado';
        // Profissional__c pro = [SELECT Id, Name FROM Profissional__c WHERE Name = 'Pro Teste' LIMIT 1];
        String ret = ProfissionalController.getAllProfissional();
        system.debug('retorno');
        system.debug(ret);
        system.assertEquals(exp, ret, msg);
    }

    @isTest
    public static void getProfissionalTest(){

        Profissional__c pro = [SELECT Id, Perfil_Profissional__c FROM Profissional__c LIMIT 1];
        String exp = '[{"attributes":{"type":"Profissional__c","url":"/services/data/v54.0/sobjects/Profissional__c/' + pro.Id + '"},"Name":"Pro Teste","Perfil_Profissional__c":"' + pro.Perfil_Profissional__c + '","Carga_Horaria_Perfil__c":8.00,"Periodicidade_Perfil__c":"Diária","Inicio_Contrato__c":"2022-02-02","Id":"' + pro.Id + '","Perfil_Profissional__r":{"attributes":{"type":"Perfil_Profissional__c","url":"/services/data/v54.0/sobjects/Perfil_Profissional__c/' + pro.Perfil_Profissional__c + '"},"Id":"' + pro.Perfil_Profissional__c + '","Name":"Perfil Teste"}}]';
        String msg = 'O retorno do método não é o esperado';
        // Profissional__c pro = [SELECT Id, Name FROM Profissional__c WHERE Name = 'Pro Teste' LIMIT 1];
        String ret = ProfissionalController.getProfissional(pro.Id);
        system.debug('retorno');
        system.debug(ret);
        system.assertEquals(exp, ret, msg);
    }

    @isTest
    public static void getAllProfissionalComDadosDeHorasTest(){

        Profissional__c pro = [SELECT Id, Perfil_Profissional__c, Perfil_Profissional__r.Periodicidade__c FROM Profissional__c LIMIT 1];
        //[{"attributes":{"type":"Profissional__c","url":"/services/data/v54.0/sobjects/Profissional__c/a1W7h000000FItzEAG"},"Name":"Pro Teste","Perfil_Profissional__c":"a1X7h000000E5L1EAK","Carga_Horaria_Perfil__c":8.00,"Periodicidade_Perfil__c":"Diária","Inicio_Contrato__c":"2022-02-02","Id":"a1W7h000000FItzEAG","Perfil_Profissional__r":{"attributes":{"type":"Perfil_Profissional__c","url":"/services/data/v54.0/sobjects/Perfil_Profissional__c/a1X7h000000E5L1EAK"},"Id":"a1X7h000000E5L1EAK","Name":"Perfil Teste"}}]
        String exp = '[{"horasDisponíveis":56.0,"horasCapacity":56.0,"horasIndisponiveis":48.0,"horasAlocadas":0.0,"inicioContrato":"2022-02-02","cargaHorariaPerfilPorDia":8.00,"nomePerfilProfissional":"Perfil Teste","nomeProfissional":"Pro Teste","idProfissional":"'+pro.Id+'","idPerfil":"'+pro.Perfil_Profissional__c+'"}]';
        String msg = 'O retorno do método não é o esperado';
        // Profissional__c pro = [SELECT Id, Name FROM Profissional__c WHERE Name = 'Pro Teste' LIMIT 1];
        String ret = ProfissionalController.getAllProfissionalComDadosDeHoras('2022-01-20', '2022-02-20');
        system.debug('retorno');
        system.debug(ret);
        system.assertEquals(exp, ret, msg);
    }
}