public class CreateDynamicFields {
    @AuraEnabled(cacheable=true)
    public static RecordWrapper getRecordsDetails(String recordId, String ObjectS) {
        RecordWrapper Rw = new RecordWrapper();
        try{
            List<SObject> sData = new List<SObject>();
            String query = 'select Id, HealthScore__c, LastUpdated__c, Recommendations__c From '+ObjectS+' WHERE Id =: recordId';
            sData = Database.query(query);
            for(SObject Re : sData){
                if(Re.get('HealthScore__c') != null && Re.get('HealthScore__c') != ''){
                    Rw.HealthScore = string.valueof(Re.get('HealthScore__c'));   
                }else{Rw.HealthScore = '0';}
                if(Re.get('LastUpdated__c') != null && Re.get('LastUpdated__c') != ''){
                    Rw.LastUpdated = string.valueof(Re.get('LastUpdated__c'));   
                }else{Rw.LastUpdated = '0';}
                if(Re.get('Recommendations__c') != null && Re.get('Recommendations__c') != ''){
                    String str = string.valueof(Re.get('Recommendations__c'));
                    List<String> res = str.split(',');
                    Rw.Recommend = new List<string>();
                    Rw.Recommend.addAll(res);
                    system.debug('Rw.Recommend==>'+ Rw.Recommend);
                    system.debug('res==>'+ res);
                }
            }
            return rw;
        }
        catch(Exception e){  
            return rw;
        }
    }
    public class RecordWrapper{
        @AuraEnabled
        public String HealthScore{get;set;}
        @AuraEnabled
        public String LastUpdated{get;set;}
        @AuraEnabled 
        public list<string> Recommend {get;set;}
    }
    @AuraEnabled
    public static Boolean createField(String sObjectName){    
        try{
            MetadataService.MetadataPort service = new MetadataService.MetadataPort();
            service.SessionHeader = new MetadataService.SessionHeader_element();
            service.SessionHeader.sessionId = SessionHelper.getSessionId();
            List<MetadataService.CustomField> customFields = new List<MetadataService.CustomField>();
            MetadataService.CustomField cf1 = new MetadataService.CustomField();
            MetadataService.CustomField cf2 = new MetadataService.CustomField();
            MetadataService.CustomField cf3 = new MetadataService.CustomField();
            cf1.type_x = 'Number';  
            cf1.label = 'Health Score';  
            cf1.fullName = sObjectName+'.HealthScore__c';  
            cf1.externalId = false;  
            cf1.precision = 18;  
            cf1.required = false;  
            cf1.scale = 2;  
            cf1.unique = false; 
            customFields.add(cf1);
            cf2.fullName = sObjectName+'.LastUpdated__c';
            cf2.label = 'Last Updated';
            cf2.type_x = 'DateTime';
            customFields.add(cf2);
            cf3.fullName = sObjectName+'.Recommendations__c';
            cf3.label = 'Recommendations ';
            cf3.type_x = 'TextArea';
            customFields.add(cf3);
            for(Integer i=0;i<3;i++){
                if(!Test.isRunningTest()){
                    List<MetadataService.SaveResult> results = service.createMetadata(new MetadataService.Metadata[] { customFields[i] });
               }
            }
            return true;
        }
        catch(Exception e){
            return false;
        }
    }
    @AuraEnabled
    public static Boolean checkHealthReportFields(String sObjectName){
        try{
            set<String>fldsToChk = new set<String>{'Health Score','Last Updated','Recommendations'};
                Boolean isAvl= false;
            Schema.DescribeSObjectResult[] descResult = Schema.describeSObjects(
                new String[]{String.valueOf(sObjectName)});
            set<String> allObjFlds = descResult[0].fields.getMap().keySet();
            System.debug('=allObjFlds=>'+allObjFlds);
            for(String currFldName : fldsToChk){
                if(allObjFlds.contains(currFldName.toLowerCase())){
                    isAvl = true;
                }
            }
            return isAvl;
        }
        catch(Exception e){
            return false;
        }
    }  
    @AuraEnabled
    public static Boolean givePermissions(String sObjectName){
        try{
            MetadataService.MetadataPort service = new MetadataService.MetadataPort();
            service.SessionHeader = new MetadataService.SessionHeader_element();
            service.SessionHeader.sessionId = SessionHelper.getSessionId();
            system.debug('service==>'+service);
            MetadataService.Profile admin = new MetadataService.Profile();
            admin.fullName = 'Admin';
            admin.custom = false;
            system.debug('admin==>'+admin);
            MetadataService.ProfileFieldLevelSecurity fieldSec = new MetadataService.ProfileFieldLevelSecurity();
            Set<String>fields = new set<String>{sObjectName+'.HealthScore__c',sObjectName+'.Recommendations__c',sObjectName+'.LastUpdated__c'};
                system.debug('fields==>'+fields);
            for(String flds:fields){
                fieldSec.field=flds;
                fieldSec.editable=true;
                admin.fieldPermissions  = new MetadataService.ProfileFieldLevelSecurity[] {fieldSec} ;
                    if(!Test.isRunningTest()){
                    List<MetadataService.SaveResult> results =service.updateMetadata(new MetadataService.Metadata[] { admin });
                    }
            }
        return true;}
        catch(Exception e){
            system.debug('Line==>'+e.getLineNumber());
            system.debug('GetMeaasage==>'+e.getMessage());
            return false; }
    }
    @AuraEnabled
    public static Boolean ValidateUserCred(string email, string password){
        
        HTTP objectOfHttp = new HTTP(); 
        HTTPRequest req = new HTTPRequest();
        req.setEndpoint('https://api.customercitydev.com/auth/login');
        req.setHeader('Content-Type', 'application/json');
        //req.setHeader('Authorization', 'Bearer 00006K3Bo!ARwAQBBc8r.Mab2cRGsPR0kj2PHcygcS9X3NvHjrVoIbQUpMoEaCEJEq_O1LTA95bhIeHeKnUkW5THavyfVyNq0uQqfsl7ijQ');
        //req.setHeader('Cookie', 'debug_logs=debug_logs,domain=.force.com');
        req.setMethod('POST');  
        String JSONBody ='{"email":"'+email.trim() +'","password":"'+password.trim()+'"}';
        System.debug('===>'+JSONBody);
        req.setBody(JSONBody);
        integer StatusCode = 0; 
        String responseBody='';
        HTTPResponse res =new HTTPResponse();
        if(!Test.isRunningTest()){    
            res = objectOfHttp.send(req); 
            StatusCode=res.getStatusCode(); 
        }else{
            StatusCode = 200;
            responseBody = '';
        }
        system.debug('StatusCode'+ StatusCode);
        responseBody = res.getBody();
        system.debug('responseBody'+ responseBody);
        wrapperValidateUser wrap = (wrapperValidateUser)JSON.deserialize(responseBody, wrapperValidateUser.class);
        system.debug('success==>'+ wrap.success);
        system.debug('message==>'+ wrap.message);
        system.debug('data==>'+ wrap.data);
            return wrap.success == true?true:false;
    }
    public class wrapperValidateUser{
        public Boolean success {get;set;}
        public string message {get;set;}
        public getAccessToken data {get;set;}    
    }
    public class getAccessToken{
        public string accessToken{get;set;}
    }
}