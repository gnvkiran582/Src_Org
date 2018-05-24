public class FilmProductionController {
    
    
    
    public String  firstname{get;set;}
    public String  lastname {get;set;}
    public String  email {get;set;}
    public String  phone {get;set;}
    public String  producerFirstname{get;set;}
    public String  producerLastname {get;set;}
    public String  productionCompanyname {get;set;} 
    public Attachment companyLogo {get;set;}
    public Attachment insuranceCert {get;set;}
    public Attachment complexParkingLocation {get;set;}
    public String  address{get;set;}
    public String  city{get;set;}
    public String  state{get;set;}
    public String  postalcode{get;set;}
    public String  productionTitle{get;set;}
    Public String  productiontype{get;set;}
    Public DateTime  firstShootDateTime{get;set;}
    Public DateTime  lastShootDateTime{get;set;}
    Public boolean  additionalDays{get;set;}
    Public Date  previousShootDate{get;set;}
    Public boolean  isStillPhotography{get;set;}
    Public Integer productionBudget{get;set;}
    //public Film_Production__c filmProdReq {get;set;}
    public Account filmProdReq {get;set;}
    
    public FilmProductionController()
    {
        filmProdReq = new Account();
        //filmProdReq = new Film_Production__c();
        this.verified = false;
        companyLogo = new Attachment();
        insuranceCert = new Attachment();
        complexParkingLocation = new Attachment();
        
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
           /* Film_Production__c filmProdReq = setFilmProductionRequest();
            
            Database.SaveResult result = Database.insert(filmProdReq,false);
            System.debug('result ::'+result);
            if(result.isSuccess())
            {
				List<Attachment> atts = new List<Attachment>();             	

				companyLogo.parentid=result.getId();
				insuranceCert.parentid=result.getId();
				complexParkingLocation.parentid=result.getId();

				atts.add(companyLogo);
				atts.add(insuranceCert);
				atts.add(complexParkingLocation);

                List<Database.SaveResult> attResult = Database.insert(atts,false);
                System.debug('After inserting attachments ::'+attResults);
                
                pageRef = new PageReference('/apex/FilmProductionForm?redirectPage=true');
                pageRef.getParameters().put('message', 'Hello! Thank you for your request. We will review and respond within 72 hours. – OCTFME Executive Staff');
       			pageRef.setRedirect(true);
             
            }
            else
            {
                ApexPages.Message myMsg = new ApexPages.message(ApexPages.severity.FATAL,'There seems to be an issue while creating a Film Production Shoot request. Please try again');
                ApexPages.addMessage(myMsg);
                pageRef = null;
            }
            */
            
        }
        catch(Exception e)
        {
            System.debug('Exception e ::'+e.getMessage() + e.getStackTraceString() + e);
            ApexPages.Message myMsg = new ApexPages.message(ApexPages.severity.FATAL,'There seems to be an error while creating a Film Production Shoot request. Please try again');
            ApexPages.addMessage(myMsg);
            pageRef = null;
        }
        System.debug('Returning Page ::'+pageRef);
        return pageRef;
    }
    
    
 /*   private Film_Production__c setFilmProductionRequest()
    {
        Film_Production__c filmProdReq = new Film_Production__c();
        
        try{
            filmProdReq.Applicant_First_Name__c = firstName;
            filmProdReq.Applicant_Last_Name__c = lastName;
            filmProdReq.Applicant_Email__c = email;
            filmProdReq.Applicant_Phone__c = phone;
            filmProdReq.Producer_First_Name__c = producerFirstname;
            filmProdReq.Producer_Last_Name__c = producerLastname;
            filmProdReq.Production_Company__c = productionCompanyname;
            filmProdReq.Street_Address__c = address;
            filmProdReq.City__c = city;
            filmProdReq.State__c = filmProdReq.State__c;
            filmProdReq.Country__c = filmProdReq.Country__c;
            filmProdReq.ZipCode__c = postalcode;
            filmProdReq.Production_Title__c = productionTitle;
            filmProdReq.Production_Type__c = Productiontype;
            filmProdReq.Cast_Crew__c = filmProdReq.Cast_Crew__c;
            filmProdReq.First_Shoot_Date__c = firstShootDateTime;
            filmProdReq.Last_Shoot_Date__c  = lastShootDateTime;
            filmProdReq.Additional_Day__c   = additionalDays ;
            filmProdReq.Previous_Shoot_Date__c  = previousShootDate;
			filmProdReq.Shoot_Description__c  = filmProdReq.Shoot_Description__c;
			filmProdReq.Still_Photography__c  = isStillPhotography;
			filmProdReq.Equipment__c  = filmProdReq.Equipment__c;
			filmProdReq.Filming_Parking_Loc_Simple__c  = filmProdReq.Filming_Parking_Loc_Simple__c;
			filmProdReq.Payment_Amount__c  = productionBudget;
			filmProdReq.Notes__c  = filmProdReq.Notes__c;
			

            
        }
        catch(Exception e)
        {
            System.debug('Exception e ::'+e.getMessage() + e.getStackTraceString() + e);
        }
        System.debug('filmProdReq rec ::'+filmProdReq);
        return filmProdReq;
    }*/
    
    public class CaptchaResponse {
        
        public boolean success {get;set;}
        public DateTime challenge_ts {get;set;}
        public String apk_package_name  {get;set;}
        //public List<String> error_codes  {get;set;}
        
    }
        
    
    
    
}