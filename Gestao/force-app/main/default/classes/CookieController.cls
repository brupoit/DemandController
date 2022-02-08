// A Visualforce controller class that creates a cookie
// used to keep track of how often a user displays a page
public class CookieController {

    public CookieController() {
    }
	
    public static void setSessionId(HarpiaEcrmJSonApex.Session sessionId){ 
        System.debug('Seta novo cookie: '+sessionId.PHPSESSID);
        Cookie eCRMSessionId = new Cookie('eCRMSessionId', sessionId.PHPSESSID, null, 1440, false);
        ApexPages.currentPage().setCookies(new Cookie[]{eCRMSessionId});
    }
    
    public static void cancelaSessionId(HarpiaEcrmJSonApex.Session sessionId){
        Cookie eCRMSessionId = new Cookie('eCRMSessionId', sessionId.PHPSESSID, null, 0, false);
        ApexPages.currentPage().setCookies(new Cookie[]{eCRMSessionId});
    }
    //APARENTEMENTE NÃO É USADO, TESTAR ATÉ A MORTE E DEPOIS SE NÃO FOR USADO DELETAR!!!
    public String geteCRMSessionId() {
        Cookie eCRMSessionId = ApexPages.currentPage().getCookies().get('eCRMSessionId');
        if(eCRMSessionId == null) {
            return 'Erro';
        }
        return eCRMSessionId.getValue();
    }
}