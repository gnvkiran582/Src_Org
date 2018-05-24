public class MeetingRequestController {
    
    public PageReference verifyCaptcha() {
        return null;
    }
    
    public String firstName {get;set;}
    public String lastName {get;set;}
    public String title {get;set;}
    public String organization {get;set;}
    public String email {get;set;}
    public String phone {get;set;}
    public String address {get;set;}
    public String city {get;set;}
    public String state {get;set;}
    public String zip {get;set;}
    public String ward {get;set;}
    public DateTime preferredDateTime {get;set;}
    public DateTime firstAltDateTime {get;set;}
    public DateTime secAltDateTime {get;set;}
    public String  meetingType {get;set;}
    public String meetingPurpose {get;set;}
    public String attendeeTitle {get;set;}
    public String backgroundInfo {get;set;}
    //public Director_Meeting_Invite__c meetingInvite {get;set;}
    public String fileName {get;set;}
    public Blob fileData {get;set;}
    public Account meetingInvite {get;set;}
    public Attachment myFile {get;set;}
    
    public MeetingRequestController() {
        this.verified = false;
        //meetingInvite = new Director_Meeting_Invite__c();
        meetingInvite = new Account();
        myFile = new Attachment();
        
        String message = '' + ApexPages.CurrentPage().GetParameters().Get('message');
        String pageRedirectFlag = ApexPages.CurrentPage().GetParameters().Get('redirectPage'); 
		System.debug('message ::'+message + 'pageRedirectFlag ::'+pageRedirectFlag);
        // Use the referrer parameter to only show the message when coming from Page 1
        if(pageRedirectFlag != null && pageRedirectFlag.containsIgnoreCase('true') && message != 'null')
        {
            System.debug('in if in const'); 
               ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, message)); 
            
        }
        
    }
    
    /* Configuration */
    
    public Boolean verified { get; private set; } // The API endpoint for the reCAPTCHA service
    private static String baseUrl = Label.Captcha_Base_URL;
    public static String publicKey {
        get { return Label.Captcha_Site_Key; }
    } 
    public String privateKey {
        get { return Label.Captcha_Secret_Key; } // The keys you get by signing up for reCAPTCHA for your domain
    }
    
    public String response  {
        get {
            System.debug('Secret Value from form ::'+ApexPages.currentPage().getParameters().get('g-recaptcha-response'));
            return ApexPages.currentPage().getParameters().get('g-recaptcha-response'); // Secret Code user entered in VF Page
        }
    }
    
    public PageReference verifyAndSubmitRequest() {
        PageReference pageRef ;
        System.debug('reCAPTCHA verification attempt');
        HttpResponse r = makeRequest(baseUrl,
                                     'secret=' + privateKey +
                                     '&response='  + response
                                    );
        
        System.debug('Response ::'+r);
        String str = r.getBody();
        if ( r!= null ) {
            CaptchaResponse responseWrapper = (CaptchaResponse)JSON.deserialize(r.getBody(), CaptchaResponse.class);
            this.verified = responseWrapper.success;
        }
        System.debug('this.verified ::'+this.verified);
        if(this.verified) {
            pageRef = submitRequest();
        }
        else {
            // stay on page to re-try reCAPTCHA
            ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Please verify the captcha');
            ApexPages.addMessage(errorMsg);
            pageRef = null;
        }
        return pageRef;
    }
    
    private static HttpResponse makeRequest(string url, string body)  {
        System.debug('url: ' + url + ', body ::'+body);
        HttpResponse response = null;
        HttpRequest req = new HttpRequest();  
        req.setEndpoint(url);
        req.setMethod('POST');
        req.setBody (body);
        try {
            Http http = new Http();
            response = http.send(req);
            System.debug('reCAPTCHA Response: ' + response);
            System.debug('reCAPTCHA Response Body: ' + response.getBody());
        } catch(System.Exception e) {
            System.debug('ERROR: ' + e);
        }
        return response;
    }  
    
    public PageReference submitRequest()
    {
        PageReference pageRef ;
        try
        {
            //Director_Meeting_Invite__c invite = setMeetingInvite();
            /*if(myFile.BodyLength > 5242880))
{
ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'File size is greater than 5 MB. Please choose a lesser size file'));  
return null;      
}*/
            /*Database.SaveResult result = Database.insert(invite,false);
            System.debug('result ::'+result);
            if(result.isSuccess())
            {
                //Attachment a = new Attachment(parentid=result.getId(), Name = myFile.name , Body = myFile.body);
                System.debug('Name ::'+fileName + ', Body ::'+fileData);
                myFile.Name = fileName;
                myFile.Body = fileData;
                myFile.ParentId = result.getId();
                insert myFile;
                //Database.SaveResult attResult = Database.insert(myFile,false);
                System.debug('myFile ::'+myFile);
                
                 
                System.debug('After inserting attachments');
                
                pageRef = new PageReference('/apex/MeetingRequestForm?redirectPage=true');
                pageRef.getParameters().put('message', 'Hello! Thank you for your meeting request. We will review and respond within 72 hours. – OCTFME Executive Staff');
       			pageRef.setRedirect(true);
             
            }
            else
            {
                ApexPages.Message myMsg = new ApexPages.message(ApexPages.severity.FATAL,'There seems to be an issue while creating a meeting request. Please try again');
                ApexPages.addMessage(myMsg);
                pageRef = null;
            }
            */
            
        }
        catch(Exception e)
        {
            System.debug('Exception e ::'+e.getMessage() + e.getStackTraceString() + e);
            ApexPages.Message myMsg = new ApexPages.message(ApexPages.severity.FATAL,'There seems to be an error while creating a meeting request. Please try again');
            ApexPages.addMessage(myMsg);
            pageRef = null;
        }
        System.debug('Returning Page ::'+pageRef);
        return pageRef;
    }
    
    
   /* private Director_Meeting_Invite__c setMeetingInvite()
    {
        Director_Meeting_Invite__c invite = new Director_Meeting_Invite__c();
        
        try{
            invite.First_Name_host__c = firstName;
            invite.Last_Name_Host__c = lastName;
            invite.Position_Title__c = title;
            invite.Organization__c = organization;
            invite.Email__c = email;
            invite.Phone__c = phone;
            invite.Organization_Address__c = address;
            invite.City__c = city;
            //invite.State__c = state;
            invite.Zip__c = zip;
            //invite.Ward__c = ward;
            invite.Preferred__c = meetingInvite.Preferred__c;
            invite.X1st_Alternate_Date__c = meetingInvite.X1st_Alternate_Date__c;
            invite.X2nd_Alternate_Date__c = meetingInvite.X2nd_Alternate_Date__c;
            invite.Meeting_Purpose__c = meetingPurpose;
            invite.Meeting_Type__c = meetingType;
            invite.Attendees_Titles__c = attendeeTitle;
            invite.Country__c  = meetingInvite.Country__c;
            invite.State__c   = meetingInvite.State__c ;
            invite.Ward__c  = meetingInvite.Ward__c ;
            
        }
        catch(Exception e)
        {
            System.debug('Exception e ::'+e.getMessage() + e.getStackTraceString() + e);
        }
        System.debug('invite rec ::'+invite);
        return invite;
    }
    */
    public class CaptchaResponse {
        
        public boolean success {get;set;}
        public DateTime challenge_ts {get;set;}
        public String apk_package_name  {get;set;}
        //public List<String> error_codes  {get;set;}
        
    }
    
    
    /*public PageReference verifyCaptcha()
{
System.debug('reCAPTCHA verification attempt');
HttpResponse r = makeRequest(baseUrl,
'secret=' + privateKey +
'&response='  + response
);

System.debug('Response ::'+r);
String str = r.getBody();
if ( r!= null ) {
CaptchaResponse responseWrapper = (CaptchaResponse)JSON.deserialize(r.getBody(), CaptchaResponse.class);
this.verified = responseWrapper.success;
}
System.debug('this.verified ::'+this.verified);
if(!this.verified) {
// stay on page to re-try reCAPTCHA
ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Please verify the captcha');
ApexPages.addMessage(errorMsg);
}
return null;
}*/
    
    /* private String remoteHost {
get {
String ret = '127.0.0.1';
// also could use x-original-remote-host
Map<String, String> hdrs = ApexPages.currentPage().getHeaders();
if (hdrs.get('x-original-remote-addr')!= null)
ret =  hdrs.get('x-original-remote-addr');
else if (hdrs.get('X-Salesforce-SIP')!= null)
ret =  hdrs.get('X-Salesforce-SIP');
return ret;
}
}*/
    
}