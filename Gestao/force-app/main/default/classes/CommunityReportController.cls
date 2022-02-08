public with sharing class CommunityReportController{

    public List<Registro_de_horas__c> listRegistrosHoras {get;set;}
    public List<Case> listOpenCases {get;set;}
    public List<Case> listOpenCasesType {get;set;}
    public transient User compania {get;set;}
    public transient List<Data> horasMesPassadoEAtual {get;set;}
    public transient List<Data> chamdosAbertosPorTipo {get;set;}
    public transient List<Data> chamdosAbertosPorStatus {get;set;}

    private Map<Integer,String> nomeMes;

    public CommunityReportController()
    {
        
        compania = [SELECT ACCOUNTID FROM USER WHERE ID =: UserInfo.getUserId()];
        // Como os casos são particulares, o usuário apenas verá de acordo com a sua prórpia visibilidade
        listRegistrosHoras = [SELECT Data__c, Horas_Totais__c,Hora_extra__c,Hora_noturna__c,Hora__c,Sobreaviso__c, Caso__c, Caso__r.AccountId
        FROM Registro_de_horas__c WHERE Data__c >= LAST_MONTH AND Caso__r.AccountId = :compania.AccountId
        ORDER BY Data__c];

        listOpenCases = [SELECT Id, AccountId,CaseNumber,ClosedDate,CreatedDate,Horas_estimadas__c,
        Priority,Status,Type FROM Case WHERE IsClosed = false ORDER BY Status];

        listOpenCasesType = [SELECT Id, AccountId,CaseNumber,ClosedDate,CreatedDate,Horas_estimadas__c,
        Priority,Status,Type FROM Case WHERE IsClosed = false ORDER BY Type];

        getNomeMes();
        getRegistroHorasReport(listRegistrosHoras);
        getCasosAbertosPorTipo(listOpenCases);
        getCasosAbertosPorStatus(listOpenCasesType);
    }
    
    private void getRegistroHorasReport(List<Registro_de_horas__c> listRegistrosHoras)
    {
        Data mesPassado = new Data(nomeMes.get(System.today().month()-1));
        Data mesAtual = new Data(nomeMes.get(System.today().month()));
        for (Registro_de_horas__c registro : listRegistrosHoras)
        {
            // Mês atual
            if (registro.Data__c.month() == System.today().month())
            {
                mesAtual.data1 += registro.Horas_Totais__c;
            }
            else if (registro.Data__c.month() == System.today().month()-1)
            {
                mesPassado.data1 += registro.Horas_Totais__c;
            }
        }
        
        horasMesPassadoEAtual = new List<Data>();
        horasMesPassadoEAtual.add(mesPassado);
        horasMesPassadoEAtual.add(mesAtual);
    }

    private void getCasosAbertosPorTipo (List<Case> listOpenCases)
    {
        Map<String,Integer> mapaCasoTipo = new Map<String,Integer>();

        for (Case caso : listOpenCases)
        {
            if (mapaCasoTipo.containsKey(caso.Type))
            {
                Integer valorAtual = mapaCasoTipo.get(caso.Type);
                mapaCasoTipo.put(caso.Type, valorAtual +1);
            }
            else
            {
                mapaCasoTipo.put(caso.Type, 1);
            }
        }
        chamdosAbertosPorTipo = new List<Data>();
        for (String tipo : mapaCasoTipo.keySet())
        {
            chamdosAbertosPorTipo.add(new Data(tipo,mapaCasoTipo.get(tipo),0,0));
        }

        for (Data data : chamdosAbertosPorTipo)
        {
            data.name = data.name + ': ' + data.data1;
        }
    }

    private void getCasosAbertosPorStatus (List<Case> listOpenCases)
    {
        Map<String,Integer> mapaCasoStatus = new Map<String,Integer>();

        for (Case caso : listOpenCases)
        {
            if (mapaCasoStatus.containsKey(caso.Status))
            {
                Integer valorAtual = mapaCasoStatus.get(caso.Status);
                mapaCasoStatus.put(caso.Status, valorAtual +1);
            }
            else
            {
                mapaCasoStatus.put(caso.Status, 1);
            }
        }
        chamdosAbertosPorStatus = new List<Data>();
        for (String status : mapaCasoStatus.keySet())
        {
            chamdosAbertosPorStatus.add(new Data(status,mapaCasoStatus.get(status),0,0));
        }
        for (Data data : chamdosAbertosPorStatus)
        {
            data.name = data.name + ': ' + data.data1;
        }
    }

    private void getNomeMes ()
    {
        nomeMes = new Map<Integer,String>();
        nomeMes.put(0,'Dezembro'); // Para buscar o mês anterior, caso o atual seja Janeiro
        nomeMes.put(1,'Janeiro');
        nomeMes.put(2,'Fevereiro');
        nomeMes.put(3,'Março');
        nomeMes.put(4,'Abril');
        nomeMes.put(5,'Maio');
        nomeMes.put(6,'Junho');
        nomeMes.put(7,'Julho');
        nomeMes.put(8,'Agosto');
        nomeMes.put(9,'Setembro');
        nomeMes.put(10,'Outubro');
        nomeMes.put(11,'Novembro');
        nomeMes.put(12,'Dezembro');
    }
    
    // Wrapper class
    // Classe que comporta 3 gráficos
    public class Data
    {
        public String name { get; set; }
        public Decimal data1 { get; set; }
        public Decimal data2 { get; set; }
        public Decimal data3 { get; set; }
        public Data(String name, Decimal data1, Decimal data2, Decimal data3)
        {
            this.name = name;
            this.data1 = data1;
            this.data2 = data2;
            this.data3 = data3;
        }
        public Data (String name)
        {
            this.name = name;
            data1 = 0;
            data2 = 0;
            data3 = 0;
        }
    }
}