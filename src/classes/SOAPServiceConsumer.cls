public class SOAPServiceConsumer
{
    public static void getStudentDetails()
    {
    	try
        {
            // Create a Session
            partnerSoapSforceCom.Soap sp = new partnerSoapSforceCom.Soap();
            String username = 'gnvkiran582@salesforce.com';
            String password = 'Lakshmi@582s2ntbOh6OeHRqMIphKIYxJwU';
            partnerSoapSforceCom.LoginResult loginResult = sp.login(username,password);
            system.debug('loginResult ::' + loginResult);
            system.debug('Session Id ::' + loginResult.sessionId);
            
            // Create object of Stub class, set the required parameters and Invoke the Service
            soapSforceComSchemasClassSoapwebser.SOAPWebServiceProvider stub = new soapSforceComSchemasClassSoapwebser.SOAPWebServiceProvider();
            soapSforceComSchemasClassSoapwebser.SessionHeader_element serviceSessionHeader = new soapSforceComSchemasClassSoapwebser.SessionHeader_element();
            
            serviceSessionHeader.sessionId = loginResult.sessionId;
            stub.SessionHeader = serviceSessionHeader; 
            system.debug('Stub ::' + stub);
            
            /* To set input headers  
            Map<String,String> headerMap = new Map<String,String>();
            headerMap.put('SessionId', loginResult.sessionId);
            stub.inputHttpHeaders_x = headerMap ;
            */
            Double balance = stub.getBalanceFee('a0C2800000JRBOG');
            System.debug('balance ::'+balance);
        }
        catch(Exception e)
        {
            System.debug('Exception ::'+e.getStackTraceString() + e.getMessage() + e.getLineNumber());
        }
    
    
    }

}