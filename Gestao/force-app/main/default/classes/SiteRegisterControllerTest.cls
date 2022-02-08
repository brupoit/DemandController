/**
 * Class containing tests for SiteRegisterController
 */
@IsTest public with sharing class SiteRegisterControllerTest {
    @IsTest(SeeAllData=true) static void testRegistration() {
        SiteRegisterController controller = new SiteRegisterController();
        controller.username = 'suporte@harpiacloud.com.br.dev1';
        controller.email = 'test@force.com';
        controller.communityNickname = 'test';
        // registerUser will always return null when the page isn't accessed as a guest user
        System.assert(controller.registerUser() != null);
        
        controller.password = 'outrasenha';
        controller.confirmPassword = 'asdf1234';
        System.assert(controller.registerUser() == null);    
        
        controller.password = 'asdf1234';
        controller.confirmPassword = 'asdf1234';
        System.assert(controller.registerUser() == null);  
    }
}