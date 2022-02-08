public class ProfissionalController {
  // ------------------- GET CAPACITY POR PERFIL -----------------------------
  @AuraEnabled(Cacheable=true)
  public static String getCapacityPorPerfil() {
    date todayDate = System.today();
    date weekStart = todayDate.toStartofWeek().addDays(1);
    date weekEnd = todayDate.toStartofWeek().addDays(5);
    system.debug('-----começo semana: ' + weekStart);
    system.debug('-----final semana: ' + weekEnd);

    //pegar profissionais que já posso alocar, não estão em treinamento
    List<Profissional__c> profissionais = new List<Profissional__c>(
      [
        SELECT
          Id,
          Name,
          Perfil_Profissional__r.Name,
          Carga_Horaria_Perfil__c,
          Perfil_Profissional__r.Periodicidade__c
        FROM Profissional__c
      ]
    );
    system.debug('----profissionais: ' + profissionais);

    //inicializa set de perfis de profissionais existentes
    Set<String> setPerfis = new Set<String>();

    //inicializa a lista de capacities
    List<Map<String, Object>> capacityProfissionais = new List<Map<String, Object>>();

    //------------ INICIO LOOP PROFISSIONAIS -------------------
    for (Profissional__c prof : profissionais) {
      setPerfis.add(prof.Perfil_Profissional__r.Name); // contains distict accounts

      //seleciona todas indisponibilidade do profissional atual do loop
      List<Indisponibilidade__c> indisponibilidades = new List<Indisponibilidade__c>(
        [
          SELECT Id, Data_Inicio__c, Data_Fim__c
          FROM Indisponibilidade__c
          WHERE
            Profissional__c = :prof.Id
            AND ((Data_Inicio__c <= :weekEnd
            AND Data_Inicio__c >= :weekStart)
            OR (Data_Fim__c <= :weekEnd
            AND Data_Fim__c >= :weekStart)
            OR (Data_Inicio__c <= :weekEnd
            AND Data_Inicio__c >= :weekStart)
            OR (Data_Inicio__c <= :weekStart
            AND Data_Fim__c >= :weekEnd))
        ]
      );

      //para cada uma das indisponibilidades encontradas
      //calcular o número de horas indisponíveis
      Double cargaHoraria = prof.Carga_Horaria_Perfil__c;
      Double totalCargaHoraria = cargaHoraria * 5;
      Double somaHorasIndisp = 0;
      for (Indisponibilidade__c indisp : indisponibilidades) {
        Date inicioIndisp = indisp.Data_Inicio__c >= weekStart
          ? indisp.Data_Inicio__c
          : weekStart;
        Date fimIndisp = indisp.Data_Fim__c <= weekEnd
          ? indisp.Data_Fim__c
          : weekEnd;
        Integer diasIndisponiveis = inicioIndisp.daysBetween(fimIndisp) + 1;

        if (prof.Perfil_Profissional__r.Periodicidade__c == 'Diária') {
          Double horasIndisponiveis = diasIndisponiveis * cargaHoraria;
          somaHorasIndisp = somaHorasIndisp + horasIndisponiveis;
        }
      }

      Double capacity = totalCargaHoraria - somaHorasIndisp;

      Map<String, Object> addCapacity = new Map<String, Object>();
      addCapacity.put('nomeProfissional', prof.Name);
      addCapacity.put('perfilProfissional', prof.Perfil_Profissional__r.Name);
      addCapacity.put('cargaHoraria', prof.Carga_Horaria_Perfil__c);
      addCapacity.put(
        'periodicidade',
        prof.Perfil_Profissional__r.Periodicidade__c
      );
      addCapacity.put('totalCargaHoraria', prof.Carga_Horaria_Perfil__c * 5);
      addCapacity.put('totalHorasIndisponiveis', somaHorasIndisp);
      addCapacity.put('capacity', capacity);
      capacityProfissionais.add(addCapacity);

      system.debug(
        'nome: ' +
        prof.Name +
        ' - periodicidade: ' +
        prof.Perfil_Profissional__r.Periodicidade__c +
        ' - perfil: ' +
        prof.Perfil_Profissional__r.Name +
        ' - carga horária: ' +
        prof.Carga_Horaria_Perfil__c +
        ' - totalCargaHoraria: ' +
        prof.Carga_Horaria_Perfil__c * 5 +
        ' - somaHorasIndisp: ' +
        somaHorasIndisp +
        ' - capacity: ' +
        capacity
      );
    }
    //------------ FIM LOOP PROFISSIONAIS -------------------
    List<Map<String, Object>> capacityPorPerfil = new List<Map<String, Object>>();

    for (String perfil : setPerfis) {
      Map<String, Object> addCapacityPorPerfil = new Map<String, Object>();
      String perfilAtual = perfil;
      /*
            addCapacityPorPerfil.put('perfilProfissional', perfil);
            addCapacityPorPerfil.put('contagemPerfil', 0);
            addCapacityPorPerfil.put('somaCapacityPerfil', 0);
            capacityPorPerfil.add(addCapacityPorPerfil);
            system.debug('----initializedCapacityPerfil: '+addCapacityPorPerfil);
            */
      Double somaSemana = 0;
      Integer contagemProf = 0;
      for (Map<String, Object> profissional : capacityProfissionais) {
        if (profissional.get('perfilProfissional') == perfilAtual) {
          system.debug('true');
          somaSemana =
            somaSemana + Double.valueOf(profissional.get('capacity'));
          contagemProf++;
        }
      }
      addCapacityPorPerfil.put('perfilProfissional', perfil);
      addCapacityPorPerfil.put('contagemPerfil', contagemProf);
      addCapacityPorPerfil.put('somaCapacityPerfil', somaSemana);
      capacityPorPerfil.add(addCapacityPorPerfil);
      system.debug('----initializedCapacityPerfil: ' + addCapacityPorPerfil);
    }
    system.debug('final agregado por perfil: ' + capacityPorPerfil);
    return JSON.serialize(capacityPorPerfil);
  }

  // ------------------- GET ALL PROFISSIONAIS -----------------------------
  @AuraEnabled(Cacheable=true)
  public static String getAllProfissional() {
    List<Profissional__c> profissionais = new List<Profissional__c>(
      [
        SELECT
          Name,
          Perfil_Profissional__r.Name,
          Carga_Horaria_Perfil__c,
          Periodicidade_Perfil__c,
          Inicio_Contrato__c
        FROM Profissional__c
      ]
    );
    system.debug(profissionais);
    return (JSON.serialize(profissionais));
  }

  // ------------------- GET PROFISSIONAL BY ID -----------------------------
  @AuraEnabled(Cacheable=true)
  public static String getProfissional(String idRecord) {
    List<Profissional__c> profissional = new List<Profissional__c>(
      [
        SELECT
          Name,
          Perfil_Profissional__r.Name,
          Carga_Horaria_Perfil__c,
          Periodicidade_Perfil__c,
          Inicio_Contrato__c
        FROM Profissional__c
        WHERE Id = :idRecord
      ]
    );
    system.debug(profissional);
    return (JSON.serialize(profissional));
  }

  // // ------------------- GET ALL PROFISSIONAIS WITH HOURS -----------------------------
  // @AuraEnabled(Cacheable=true)
  // //'AAAA-MM-DD'
  // public static String getAllProfissionalComDadosDeHoras(String strDataInicio, String strDataFim) {

  //     List<Profissional__c> profissionais = new List<Profissional__c>(
  //         [
  //             SELECT
  //             Name,
  //             Perfil_Profissional__r.Name,
  //             Perfil_Profissional__r.Carga_Horaria_Por_Dia__c,
  //             Periodicidade_Perfil__c,
  //             Inicio_Contrato__c,
  //             Horas_Alocadas__c
  //             FROM Profissional__c
  //         ]
  //     );

  //     List<Map<String,Object>> dadosProfissionaisTratados = new List<Map<String,Object>> ();

  //     for (Profissional__c prof : profissionais){

  //         Double horasAlocadas = helperHorasAlocadas.HorasAlocadasProfissional(prof.Id,strDataInicio,strDataFim);
  //         Double horasIndisponiveis = HelperHorasIndisponibilidade.HorasIndisponibilidadeProfissional(prof.Id,strDataInicio,strDataFim);
  //         Double horasCapacity = HelperHorasCapacity.HorasCapacityProfissional(prof.Id, strDataInicio, strDataFim);

  //         Map<String,Object> profToAdd = new Map<String, Object>{
  //             'idProfissional'=>prof.Id,
  //             'nomeProfissional'=>prof.Name,
  //             'nomePerfilProfissional'=>prof.Perfil_Profissional__r.Name,
  //             'cargaHorariaPerfilPorDia'=>prof.Perfil_Profissional__r.Carga_Horaria_Por_Dia__c,
  //             'inicioContrato'=>prof.Inicio_Contrato__c,
  //             'horasAlocadas'=>horasAlocadas,
  //             'horasIndisponiveis'=> horasIndisponiveis,
  //             'horasCapacity'=>horasCapacity,
  //             'horasDisponíveis'=>  horasCapacity - horasIndisponiveis
  //         };

  //         dadosProfissionaisTratados.add(profToAdd);
  //     }
  //     system.debug('DadoProfissionaisTratados: ' + dadosProfissionaisTratados);
  //     return (JSON.serialize(dadosProfissionaisTratados));
  // }

  // ------------------- GET ALL PROFISSIONAIS WITH HOURS -----------------------------
  @AuraEnabled(Cacheable=true)
  //'AAAA-MM-DD'
  public static String getAllProfissionalComDadosDeHoras(
    String strDataInicio,
    String strDataFim
  ) {
    List<Profissional__c> profissionais = new List<Profissional__c>(
      [
        SELECT
          Id,
          Name,
          Perfil_Profissional__r.Id,
          Perfil_Profissional__r.Name,
          Perfil_Profissional__r.Carga_Horaria_Por_Dia__c,
          Periodicidade_Perfil__c,
          Inicio_Contrato__c,
          Horas_Alocadas__c
        FROM Profissional__c
      ]
    );

    Map<String, Double> horasAlocadas = helperHorasAlocadas.HorasAlocadasProfissional(
      profissionais,
      strDataInicio,
      strDataFim
    );
    Map<String, Double> horasIndisponiveis = HelperHorasIndisponibilidade.HorasIndisponibilidadeProfissional(
      profissionais,
      strDataInicio,
      strDataFim
    );
    Map<String, Double> horasCapacity = HelperHorasCapacity.HorasCapacityProfissional(
      profissionais,
      strDataInicio,
      strDataFim
    );

    System.debug('horasAlocadasHelperChamado------------------');
    for (String key : horasAlocadas.keySet()) {
      System.debug(
        '----Profissional: ' +
        key +
        ' ----horas: ' +
        horasAlocadas.get(key)
      );
    }

    System.debug('horasIndisponiveisChamado------------------');
    for (String key : horasIndisponiveis.keySet()) {
      System.debug(
        '----Profissional: ' +
        key +
        ' ----horas: ' +
        horasIndisponiveis.get(key)
      );
    }

    System.debug('horasCapacityChamada------------------');
    for (String key : horasCapacity.keySet()) {
      System.debug(
        '----Profissional: ' +
        key +
        ' ----horas: ' +
        horasCapacity.get(key)
      );
    }

    List<Map<String, Object>> dadosProfissionaisTratados = new List<Map<String, Object>>();

    for (Profissional__c prof : profissionais) {
      Double horasAlocadasAdd = horasAlocadas.get(prof.Id) != null
        ? horasAlocadas.get(prof.Id)
        : 0;
      Double horasIndisponiveisAdd = horasIndisponiveis.get(prof.Id) != null
        ? horasIndisponiveis.get(prof.Id)
        : 0;
      Double horasCapacityAdd = horasCapacity.get(prof.Id) != null
        ? horasCapacity.get(prof.Id)
        : 0;

      Map<String, Object> profToAdd = new Map<String, Object>{
        'idPerfil'=> prof.Perfil_Profissional__r.Id,
        'idProfissional' => prof.Id,
        'nomeProfissional' => prof.Name,
        'nomePerfilProfissional' => prof.Perfil_Profissional__r.Name,
        'cargaHorariaPerfilPorDia' => prof.Perfil_Profissional__r.Carga_Horaria_Por_Dia__c,
        'inicioContrato' => prof.Inicio_Contrato__c,
        'horasAlocadas' => horasAlocadasAdd,
        'horasIndisponiveis' => horasIndisponiveisAdd,
        'horasCapacity' => horasCapacityAdd - horasIndisponiveisAdd,
        'horasDisponíveis' => horasCapacityAdd -
        horasIndisponiveisAdd -
        horasAlocadasAdd
      };

      dadosProfissionaisTratados.add(profToAdd);
    }

    return JSON.serialize(dadosProfissionaisTratados);
  }
}