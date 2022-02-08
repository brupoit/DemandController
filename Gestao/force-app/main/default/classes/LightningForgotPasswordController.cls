global class LightningForgotPasswordController {

    public LightningForgotPasswordController() {

    }

    @AuraEnabled
    public static String forgotPassword(String username, String checkEmailUrl) {
        try {
            system.debug('checkEmailUrl: '+checkEmailUrl);
            Site.forgotPassword(username);
            ApexPages.PageReference checkEmailRef = new PageReference(checkEmailUrl);
            system.debug('!Site.isValidUsername(username): '+!Site.isValidUsername(username) + ' ' + username);
            if(!Site.isValidUsername(username)) {
                return Label.Site.invalid_email;
            }
            if(!Test.isRunningTest())
            	aura.redirect(checkEmailRef);
            system.debug('passei do redirect');
            return null;
        }
        catch (Exception ex) {
            return ex.getMessage();
        }
    }

    @AuraEnabled
    global static String setExperienceId(String expId) {    
        // Return null if there is no error, else it will return the error message 
        try {
            if (expId != null) {
                Site.setExperienceId(expId);               
            }
            return null; 
        } catch (Exception ex) {
            return ex.getMessage();            
        }        
    } 
}