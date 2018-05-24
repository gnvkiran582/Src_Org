public class EventController {
    
    
    public String eventName {get;set;} 
    public String eventDescription {get;set;}
    public String eventType {get;set;}
    public String specifyOtherEventType {get;set;}
    //public String annualItem {get;set;} 
    
    String annualItem = 'abc';
    public String getAnnualItem() {
        return annualItem;
    }
                    
    public void setAnnualItem(String annualItem) { this.annualItem = annualItem; }
    
    
    public List<SelectOption> getAnnualItemOptions() {
        List<SelectOption> options = new List<SelectOption>(); 
        options.add(new SelectOption('Yes','Yes')); 
        options.add(new SelectOption('No','No')); 
        return options; 
    }
    public String address {get;set;}
    public String city {get;set;}
    public String state {get;set;}
    public String zip {get;set;}
    public Attachment myFile {get;set;}
    public String website {get;set;}
    public String attendance {get;set;}
    public List<SelectOption> getAttendanceEntries() {
        List<SelectOption> options = new List<SelectOption>(); 
        options.add(new SelectOption('Less than 50','Less than 50')); 
        options.add(new SelectOption('50-100','50-100')); 
        options.add(new SelectOption('100-250','100-250')); 
        options.add(new SelectOption('Over 250','Over 250')); 
        options.add(new SelectOption('Other','Other')); 
        return options; 
    }
    public DateTime startDate {get;set;}
    public DateTime endDate {get;set;}
    public String specifyOther {get;set;} 
    public String notableAttendees {get;set;}
    public String additionalInfo {get;set;} 
    public String pressInformation {get;set;}
    public List<SelectOption> getpressInfoEntries() {
        List<SelectOption> options = new List<SelectOption>(); 
        options.add(new SelectOption('Event is open to press and organizers will do outreach','Event is open to press and organizers will do outreach')); 
        options.add(new SelectOption('Event is open to press, but no outreach','Event is open to press, but no outreach')); 
        options.add(new SelectOption('Event is closed to press','Event is closed to press')); 
        return options; 
    }
    
    
    public String firstName {get;set;}
    public String lastName {get;set;}
    public String title {get;set;}
    public String organization {get;set;}
    public String email {get;set;}
    public String phone {get;set;}
   
    //public Director_Event_Invite__c eventInvite {get;set;}
    public Account eventInvite {get;set;}
    
    public EventController() {
        this.verified = false;
        //eventInvite = new Director_Event_Invite__c();
        eventInvite = new Account();
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
    public PageReference selectOnClick() {
         System.debug('isAnnualItem ::'+annualItem);
        return null;
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
        System.debug('isAnnualItem ::'+annualItem);
        PageReference pageRef ;
       /* System.debug('reCAPTCHA verification attempt');
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
        }*/
        return null;
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
       PageReference pageRef;
        try
        {
           /* Director_Event_Invite__c invite = setMeetingInvite();
            Database.SaveResult result = Database.insert(invite,false);
            System.debug('result ::'+result);
            if(result.isSuccess())
            {
                //Attachment a = new Attachment(parentid=result.getId(), Name = myFile.name , Body = myFile.body);
                myFile.ParentId = result.getId();
                insert myFile;
                
               // ApexPages.Message myMsg = new ApexPages.message(ApexPages.severity.CONFIRM,'Hello! Thank you for your Event request. We will review and respond within 72 hours. – OCTFME Executive Staff');
               // ApexPages.addMessage(myMsg); 
                
                pageRef = new PageReference('/apex/EventRequestForm?redirectPage=true');
                pageRef.getParameters().put('message', 'Hello! Thank you for your Event request. We will review and respond within 72 hours. – OCTFME Executive Staff');
       			pageRef.setRedirect(true);
                return pageRef;
            }
            else
            {
                ApexPages.Message myMsg = new ApexPages.message(ApexPages.severity.FATAL,'There seems to be an issue while creating a meeting request. Please try again');
                ApexPages.addMessage(myMsg); 
                pageRef = null;
            }*/
            
            
        }
        catch(Exception e)
        {
            System.debug('Exception e ::'+e.getMessage() + e.getStackTraceString() + e);
             ApexPages.Message myMsg = new ApexPages.message(ApexPages.severity.FATAL,'There seems to be an error while creating a meeting request. Please try again');
            ApexPages.addMessage(myMsg);
            pageRef = null;
        }
        return pageRef;
    }
    
    
  /*  private Director_Event_Invite__c setMeetingInvite()
    {
        Director_Event_Invite__c invite = new Director_Event_Invite__c();
        
        try{
			invite.Event_Name__c = eventName;
            invite.Event_Description__c = eventDescription;
            invite.Event_Type__c = eventType;
            invite.Other_Event_Type__c = specifyOtherEventType;
            if(!String.isBlank(isAnnualItem) && isAnnualItem.equalsIgnoreCase('Yes'))
                invite.Annual_Event__c = true;
            else
                invite.Annual_Event__c = false;
            //invite.Annual_Event__c = isAnnualItem;
			invite.Street_Address__c = address;
			invite.City__c = city;
			//invite.State_Territory__c = state;
			invite.Zip_Code__c = zip;
			invite.Website__c = website;
			invite.Attendance__c = attendance;
			invite.Other_Specify__c = specifyOther;
			invite.Notable_Attendees__c = notableAttendees;
			invite.Additional_Information__c = additionalInfo;
			invite.Press_Information__c = pressInformation;
			invite.First_Name__c = firstName;
			invite.Last_Name__c = lastName;
			invite.Title__c = title;
			invite.Organization__c = organization;
			invite.Email__c = email;
            invite.Phone__c = phone;
            //invite.Start_Date__c = eventInvite.Start_Date__c;
            invite.End_Date__c = eventInvite.End_Date__c;
            invite.Start_Date__c = startDate;
            invite.End_Date__c = endDate;
			invite.State_Territory__c = eventInvite.State_Territory__c;
			invite.Country__c  = eventInvite.Country__c;
            invite.Ward__c  = eventInvite.Ward__c ;
		
			
        }
        catch(Exception e)
        {
            System.debug('Exception e ::'+e.getMessage() + e.getStackTraceString() + e);
        }
        System.debug('invite rec ::'+invite);
        return invite;
    }*/
    
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