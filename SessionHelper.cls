public inherited sharing class SessionHelper { 
    public static String getSessionId()  {
        String sessionId = '';
        String vfContent='';
        PageReference reportPage = Page.FindSessionId;
        if(!Test.isRunningTest()){
            vfContent = reportPage.getContent().toString();
        }else{
            vfContent='Start_Of_Session_Id00DDn00000CYAjO!AQEAQBIAbYM.cuxZ_JiLuj1sVe8n3OCVZF9WhKxf6fMy7FimWF4swbSTeSZQ83KNsHcm_nPQnDOAAwE9rZxrJWE6f5.5DkOPEnd_Of_Session_Id';
        }
        Integer startP = vfContent.indexOf('Start_Of_Session_Id') + 'Start_Of_Session_Id'.length(),
            endP = vfContent.indexOf('End_Of_Session_Id');
        sessionId = vfContent.substring(startP, endP);
        return sessionId;
    }
    
}