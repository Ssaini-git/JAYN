public class DemoCallAPI {
    @future(callout =true)
    public static void ValidateUserCred(){
        HTTP objectOfHttp = new HTTP(); 
        HTTPRequest req = new HTTPRequest();
        req.setEndpoint('https://people.googleapis.com/$discovery/rest?version=v1');
        req.setMethod('GET');  
        integer StatusCode = 0; 
        String responseBody='';
        HTTPResponse res =new HTTPResponse();
        res = objectOfHttp.send(req); 
        StatusCode=res.getStatusCode(); 
        system.debug('StatusCode'+ StatusCode);
        responseBody = res.getBody();
        system.debug('responseBody'+ responseBody);
    }
  public static String createTrigger(String name, String sourceCode, SObjectType  Type) {
/* Run in anonyous window
 * String sCode ='trigger testT on Contact (after insert,after update){}';
CreateDynamicFields.createTrigger('TestTrigger',sCode,Contact.sObjectType);
*/
    Map<String, String> body = new Map<String, String>{
        'Name' => name,
        'TableEnumOrId' => String.valueOf(type),
        'Body' => sourceCode
    };
    String url = ''
        + Url.getSalesforceBaseUrl().toExternalForm()
        + '/services/data/'
        + 'v48.0'
        + '/sobjects/'
        + 'ApexTrigger';

    HttpRequest req = new HttpRequest();
    req.setHeader('Authorization', 'OAuth ' + UserInfo.getSessionId());
    req.setHeader('Content-Type', 'application/json');
    req.setMethod('POST');
    System.debug('==>'+body);
    req.setBody(JSON.serialize(body));
    req.setEndpoint(url);
     System.debug('==JSON.serialize(body)>'+JSON.serialize(body));
    HttpResponse res = new Http().send(req);
    System.debug('==>url>>'+url);
    return String.format(
        'Result of {0} POST is statusCode={1} body={2}',
        new Object[] {url, res.getStatusCode(), res.getBody().abbreviate(1000)}
    );
}
}