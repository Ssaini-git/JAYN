@isTest
public class CustomerCityLoginControllerTest {
    
	public static testMethod void createFields(){
        
        HealthReport__Customer_city__c hcc = new HealthReport__Customer_city__c();
        hcc.Name = 'test2';
        hcc.HealthReport__Customer_City_User_Name__c = 'test@gmail.com';
        hcc.HealthReport__Customer_City_Password__c = '12345';
        insert hcc;
        
        
        Test.startTest();
        CustomerCityLoginController.CheckCrenditials();
        CustomerCityLoginController.HealthMatrixLoginWrapper wrap = new CustomerCityLoginController.HealthMatrixLoginWrapper();
        wrap.password = '12345';
        wrap.username = 'test@gmail.com';
        Test.stopTest();
    }
}