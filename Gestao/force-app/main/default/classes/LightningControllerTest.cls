@isTest
public class LightningControllerTest {
	public testMethod static void testForgotPassword(){
        String errMsg1 = LightningForgotPasswordController.forgotPassword('suporte@harpiacloud.com.br.dev1', 'joao.silva@harpiacloud.com.br');
        String errMsg2 = LightningForgotPasswordController.forgotPassword('aaaaaaaharpianuvem.com.br', 'henrique.cerquinho@harpiacloud.com.br');
        String errMsg3 = LightningForgotPasswordController.forgotPassword(null, null);
        System.assertEquals(null, errMsg1);
        System.assertEquals('Endereço de email inválido', errMsg2);
        System.assertEquals('Argument 1 cannot be null', errMsg3);
    }
    
	public testMethod static void testSetExperienceId(){
        String errMsg1 = LightningForgotPasswordController.setExperienceId('abcdefg12345678');
        String errMsg2 = LightningForgotPasswordController.setExperienceId('aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa');
        String errMsg3 = LightningForgotPasswordController.setExperienceId(null);
        system.debug(errMsg1 + '---' +errMsg2 + '---' +errMsg3);
        System.assertEquals('Esse método pode ser chamado somente de dentro de uma comunidade.', errMsg1);
		System.assertEquals('Esse método pode ser chamado somente de dentro de uma comunidade.', errMsg2);
        System.assertEquals(null, errMsg3);
    }

    public testMethod static void testLogin(){
        string errMsg1 = LightningLoginFormController.login('suporte@harpiacloud.com.br.dev1', 'asdasdasd', 'test.salesforce.com');
        system.debug('1: '+errMsg1);
        string errMsg2 = LightningLoginFormController.login('aaaaaaaaaaaa', null, null);
        system.debug('2: '+errMsg1);
    }

    public testMethod static void testGetIsUsernamePasswordEnabled(){
        boolean result = LightningLoginFormController.getIsUsernamePasswordEnabled();
        system.debug(result);
    }

    public testMethod static void testGetIsSelfRegistrationEnabled(){
        boolean result = LightningLoginFormController.getIsSelfRegistrationEnabled();
        system.debug(result);
    }

    public testMethod static void testGetSelfRegistrationUrl(){
        String result = LightningLoginFormController.getSelfRegistrationUrl();
        system.debug(result);
    }

    public testMethod static void testGetForgotPasswordUrl(){
        String result = LightningLoginFormController.getForgotPasswordUrl();
        system.debug(result);
    }

    public testMethod static void testSetExperienceIdLogin(){
        String errMsg1 = LightningLoginFormController.setExperienceId('abcdefg12345678');
        String errMsg3 = LightningLoginFormController.setExperienceId(null);
        system.debug(errMsg1 + '---' + errMsg3);
        System.assertEquals('Esse método pode ser chamado somente de dentro de uma comunidade.', errMsg1);
        System.assertEquals(null, errMsg3);
    }

}