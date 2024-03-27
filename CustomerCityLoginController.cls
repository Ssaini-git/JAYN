@RestResource(urlMapping='/api/checkcred/*')
global class CustomerCityLoginController {
    @HttpPost
    global static boolean CheckCrenditials(){
        RestRequest req = RestContext.request;
        String requestString='';
        if(!Test.isRunningTest()){
            Blob body = req.requestBody;
            requestString = body.toString();
        }else{
            requestString='{"username":"test12@gmail.com","password":"access@123"}';
        }
        system.debug('requestString==>'+ requestString);
        HealthMatrixLoginWrapper wrap = (HealthMatrixLoginWrapper)JSON.deserialize(requestString, HealthMatrixLoginWrapper.class);
        Map<String, HealthReport__Customer_city__c> customSettingsMap = HealthReport__Customer_city__c.getAll();
        Map<String, String>mapUsrPwd = new Map<String,String>();
        for(HealthReport__Customer_city__c hcc:customSettingsMap.values()){
            mapUsrPwd.put(hcc.HealthReport__Customer_City_User_Name__c,hcc.HealthReport__Customer_City_Password__c);
        }
        
        System.debug('@wrap@'+wrap);
        System.debug('@@'+mapUsrPwd);
        if(mapUsrPwd.containsKey(wrap.username.trim()) && mapUsrPwd.get(wrap.username.trim()) == wrap.password.trim()){
            System.debug('===>true');
            return true;
        }
        else{
            System.debug('==>else false');
            return false;
        }
        //return false;
    }
    public class HealthMatrixLoginWrapper{
        public String password{get;set;}
        public String username{get;set;}
    }
}