public with sharing class DataFactoryShared {
    public static Custo_Gestao_de_Demanda__c createCustoGestaoDemanda() {
        //Custo_Gestao_de_Demanda__c
        Custo_Gestao_de_Demanda__c custo = new Custo_Gestao_de_Demanda__c();
        custo.Name = 'teste';
        custo.Custo_Bruto__c = 10000;
        custo.Custo_Liquido__c = 8000;
        custo.Moeda__c = 10000;

        insert custo;
        return custo;
    }

    public static Perfil_Profissional__c createPerfilProfissional() {
        //Perfil_Profissional__c
        Perfil_Profissional__c perfil = new Perfil_Profissional__c();
        perfil.Name = 'Perfil Teste';
        perfil.Carga_Horaria__c = 8;
        perfil.Cor_no_Gr_fico__c = 'Green';
        Custo_Gestao_de_Demanda__c custo = createCustoGestaoDemanda();
        perfil.Pesquisa_por_Custo_do_Perfil__c = custo.Id;

        insert perfil;
        return perfil;

    }

    public static Profissional__c createProfissional(){
        Profissional__c pro = new Profissional__c();
        pro.Name = 'Pro Teste';
        Perfil_Profissional__c perfil = createPerfilProfissional();
        pro.Perfil_Profissional__c = perfil.Id;
        pro.Inicio_Contrato__c = Date.today();

        insert pro;
        createSkillProfissional(pro);
        createSkillDemanda(pro);
        return pro;
    }

    public static Skills_do_Profissional__c createSkillProfissional(Profissional__c pro){
        Skills_do_Profissional__c skillPro = new Skills_do_Profissional__c();
        skillPro.Name = 'Skill Teste';
        skillPro.Profissional__c = pro.Id;
        
        insert skillPro;
        return skillPro;
    }

    public static Skills_Gestao_de_Demandas__c createSkillDemanda(Profissional__c pro){
        Skills_Gestao_de_Demandas__c skillDemandas = new Skills_Gestao_de_Demandas__c();
        skillDemandas.Name = 'Skill Demanda Teste';
        skillDemandas.Profissional__c = pro.Id;

        insert skillDemandas;
        return skillDemandas;
    }

    public static Perfis_Indisponibilidade__c createPerfilIndisponibilidade(){
        Perfis_Indisponibilidade__c perfilIndis = new Perfis_Indisponibilidade__c();
        perfilIndis.Name = 'Teste Perfil Indisponibilidade';

        insert perfilIndis;
        return perfilIndis;
    }

    public static Indisponibilidade__c createIndisponibilidade(){
        Perfis_Indisponibilidade__c perfilIndis= createPerfilIndisponibilidade();
        Profissional__c prof = createProfissional();
        Indisponibilidade__c indis = new Indisponibilidade__c();
        indis.Profissional__c = prof.Id;
        indis.Data_Inicio__c = Date.today();
        indis.Data_Fim__c = Date.today().addDays(7);
        indis.Perfil_Indisponibilidade__c = perfilIndis.Id;

        insert indis;
        return indis;

    }

    public static Account createAccountFull(){
        Account acc = new Account();
        acc.Name = 'Test Account';

        insert acc;
        createProjeto_Gestao_de_Demandas(acc.Id);
        createDemanda(acc.Id);
        return acc;
    }

    public static Projeto_Gestao_de_Demandas__c createProjeto_Gestao_de_Demandas(String accId){
        Projeto_Gestao_de_Demandas__c projeto = new Projeto_Gestao_de_Demandas__c();
        projeto.Name = 'Projeto Teste';
        projeto.Custo_Estimado__c = 20;
        projeto.Faturamento_Negociado__c = 20;
        projeto.Horas_Estimadas__c = 20;

        projeto.Cliente_Projeto__c = accId;
        insert projeto;
        return projeto;
    }

    public static Demanda__c createDemanda(String accId){
        Demanda__c demanda = new Demanda__c();
        demanda.Name = 'Demanda Teste';
        demanda.Conta__c = accId;
        demanda.Data_Inicio__c = Date.newInstance(2022,01,01);
        demanda.Data_Fim__c = Date.newInstance(2022,02,01);
        demanda.Lider__c = createProfissional().Id;

        insert demanda;
        return demanda;
    }

    public static Alocacao_Profissional__c createAlocacao(){
        Alocacao_Profissional__c aloc = new Alocacao_Profissional__c();
        Account acc = createAccountFull();
        Profissional__c pro = createProfissional();
        Demanda__c demanda = [SELECT Id FROM Demanda__c WHERE Conta__c =: acc.Id];
        aloc.Demanda__c = demanda.Id;
        aloc.Profissional__c = pro.Id;
        aloc.Data_Inicio__c = Date.today();
        aloc.Data_Fim__c = Date.today().addDays(5);
        aloc.Horas__c  = 20;

        insert aloc;
        return aloc;
    }

    public static Opportunity createOpportunity(){
        Account acc = createAccountFull();
        Opportunity opp = new Opportunity();
        opp.Name = 'Teste Oportunidade';
        opp.CloseDate = Date.today();
        opp.Type = 'Revenda';
        opp.Tipo_de_receita__c = 'Consultoria';
        opp.Condicao__c = 'Novos projetos';
        opp.StageName = 'Proposta';
        opp.Amount = 100;

        insert opp;
        return opp;
    }
}