@isTest
public class CreateDynamicFieldsTest {
    @isTest
    public static void testpost1(){
        
        Test.startTest();
        try{
            SessionHelper.getSessionId();
            Account acc = new Account();
            acc.Name = 'testing';
            acc.HealthReport__HealthScore__c = 100;
            acc.HealthReport__LastUpdated__c = system.now();
            acc.HealthReport__Recommendations__c = 'test';
            insert acc;
            
            CreateDynamicFields.createField('Account');
            CreateDynamicFields.givePermissions('Account');
            CreateDynamicFields.checkHealthReportFields('Account');
            CreateDynamicFields.getRecordsDetails(acc.Id,'Account');
            CreateDynamicFields.ValidateUserCred('test@gmail.com', '12345');
            CreateDynamicFields.getAccessToken token = new CreateDynamicFields.getAccessToken();
            token.accessToken = 'test';
            CreateDynamicFields.wrapperValidateUser wrap = new CreateDynamicFields.wrapperValidateUser();
            wrap.message = 'test';
            wrap.success = true;
            
            CreateDynamicFields.RecordWrapper rwrap = new CreateDynamicFields.RecordWrapper();
            rwrap.HealthScore = '100';
            rwrap.LastUpdated = 'test';
            
            
        }
        catch(Exception e){
            System.debug('exceptin');
        }
        Test.stopTest();
    }
}