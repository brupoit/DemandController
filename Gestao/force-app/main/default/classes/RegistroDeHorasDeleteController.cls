public class RegistroDeHorasDeleteController {
   	public RegistroDeHorasDeleteController(ApexPages.StandardController stdCon) {

    }
    
    public PageReference gotoRegistroDeHoras(){
        system.debug(ApexPages.currentPage().getParameters().get('id'));
        PageReference pr = Page.RegistroDeHoras;
        pr.setRedirect(true);
        pr.getParameters().put('operacao', 'delete');
        pr.getParameters().put('id', ApexPages.currentPage().getParameters().get('id'));
        return pr;
    }
}