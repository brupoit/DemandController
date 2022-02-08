@isTest
public class GEN_ChartControllerTest {

    @TestSetup
    static void makeData(){
        
        DataFactoryShared.createOpportunity();

    }

    @isTest
    public static void getOpportunitiesTest(){

        Opportunity opp = [SELECT Id, Amount FROM Opportunity LIMIT 1];
        String msg = 'O retorno do método não é o esperado';
        List<AggregateResult> ret = GEN_ChartController.getOpportunities();
        Boolean exp = ret[0].get('amount') == opp.Amount ? true : false;
        system.debug('retorno');
        system.debug(ret);
        system.assert(exp, msg);

    }

}