public class PermitAppController {
    
    
    
    
    
    public String  firstname{get;set;}
    public String  lastname {get;set;}
    public String  email {get;set;}
    public String  phone {get;set;}
    public String  producerFirstname{get;set;}
    public String  producerLastname {get;set;}
    public String  productionCompanyname {get;set;} 
    public String  producerEmail {get;set;}
    public String  producerPhone {get;set;}
    public Attachment companyLogo {get;set;}
    public Attachment insuranceCert {get;set;}
    public Attachment complexParkingLocation {get;set;}
    public Attachment otherAttachments {get;set;}
    public String  address{get;set;}
    public String  city{get;set;}
    public String  state{get;set;}
    public String  postalcode{get;set;}
    public String  productionTitle{get;set;}
    Public String  productiontype{get;set;}
    Public DateTime  firstShootDateTime{get;set;}
    Public DateTime  lastShootDateTime{get;set;}
    Public boolean  additionalDays{get;set;}
    public boolean studentPermit {get;set;}
    Public Date  previousShootDate{get;set;}
    Public boolean  isStillPhotography{get;set;}
    Public boolean  isPrimaryContact{get;set;}
    Public Integer productionBudget{get;set;}
    //public Permit_Application__c filmProdReq {get;set;}
    public Account filmProdReq {get;set;}
    public boolean showContactDetails {get;set;}
    public boolean showProductionDetails {get;set;}
    public boolean showPermitDetails {get;set;}
    public boolean showReview {get;set;}
    public boolean showProdAttachments {get;set;}
	public String fireEMS {get;set;}
	public String policeSupport {get;set;}
	
 
    public List<SelectOption> getFireEMSOptions() {
        List<SelectOption> options = new List<SelectOption>(); 
        options.add(new SelectOption('Yes','Yes')); 
        options.add(new SelectOption('No','No')); 
        return options; 
    }
    
    
    public PermitAppController()
    {
        filmProdReq = new Account();
        //filmProdReq = new Permit_Application__c();
        this.verified = false;
        companyLogo = new Attachment();
        insuranceCert = new Attachment();
        complexParkingLocation = new Attachment();
        otherAttachments = new Attachment();
        switchToContactDetails();
        showReview = true;
        
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
    
    public PageReference switchToContactDetails()
    {
        System.debug('in switchToContactDetails ');
        showContactDetails = true;
        showProductionDetails = false;
        showPermitDetails = false;
        PageReference pageRef = new PageReference('/apex/PermitApplication');
        pageRef.setRedirect(false);
        return null;
        
    }
    
    public PageReference switchToProductionDetails()
    {
        System.debug('in switchToProductionDetails ');
        showContactDetails = false;
        showProductionDetails = true;
        showPermitDetails = false;
        showProdAttachments = true;
        //setContactInformation();
        PageReference pageRef = new PageReference('/apex/PermitApplication');
pageRef.setRedirect(false);
return null;
        
    }
    
    public PageReference switchToPermitDetails()
    {
        showContactDetails = false;
        showProductionDetails = false;
        showPermitDetails = true;
        //setProductionInformation();
        PageReference pageRef = new PageReference('/apex/PermitApplication');
pageRef.setRedirect(false);
return null;
        
    }
    
    public PageReference reviewForm()
    {
        showContactDetails = true;
        showProductionDetails = true;
        showPermitDetails = true;
        showReview = false;
        setPermitDetails();
        PageReference pageRef = new PageReference('/apex/PermitApplication');
        pageRef.setRedirect(false);
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
    
  /*  public void setContactInformation()
    {
        
        try{
            filmProdReq.Applicant_First_Name__c = firstName;
            filmProdReq.Applicant_Last_Name__c = lastName;
            filmProdReq.Applicant_Email__c = email;
            filmProdReq.Applicant_Phone__c = phone;
            filmProdReq.Is_Primary_Contact__c  = isPrimaryContact;
            filmProdReq.Applicant_Role__c = filmProdReq.Applicant_Role__c;
        }
        catch(Exception e)
        {
            System.debug('Exception e ::'+e.getMessage() + e.getStackTraceString() + e);
        }
    }
    
    public void setProductionInformation()
    {
        
        try{
            System.debug('address ::'+address);
            System.debug('postalcode ::'+postalcode);
            filmProdReq.Producer_First_Name__c = producerFirstname;
            filmProdReq.Producer_Last_Name__c = producerLastname;
            filmProdReq.Producer_Phone__c = producerPhone;
            filmProdReq.Producer_Email__c = producerEmail;
            filmProdReq.Company_Name__c = productionCompanyname;
            filmProdReq.Street_Address__c = address;
            filmProdReq.City__c = city;
            filmProdReq.State__c = filmProdReq.State__c;
            filmProdReq.Country__c = filmProdReq.Country__c;
            filmProdReq.ZipCode__c = postalcode;
            filmProdReq.Production_Title__c = productionTitle;
            filmProdReq.Production_Type__c = Productiontype;
        }
        catch(Exception e)
        {
            System.debug('Exception e ::'+e.getMessage() + e.getStackTraceString() + e);
        }
    }*/
    
     public void setPermitDetails()
    {
        
        try{
             System.debug('firstShootDateTime ::'+firstShootDateTime+', lastShootDateTime ::'+lastShootDateTime);
            filmProdReq.DateTime__c = firstShootDateTime;
            //firstShootDateTime = firstShootDateTime;
            filmProdReq.DateTime__c  = lastShootDateTime;
              System.debug('firstShootDateTime 1::'+firstShootDateTime+', lastShootDateTime 1::'+lastShootDateTime);
            /*filmProdReq.Cast_Crew__c = filmProdReq.Cast_Crew__c;
            filmProdReq.Additional_Day__c   = additionalDays ;
            filmProdReq.Student_Permit__c = studentPermit;
            filmProdReq.Previous_Shoot_Date__c  = previousShootDate;
            filmProdReq.Shoot_Description__c  = filmProdReq.Shoot_Description__c;
            filmProdReq.Still_Photography_Only__c  = isStillPhotography;
            filmProdReq.Police_MPD_Support__c  = policeSupport.equalsIgnoreCase('Yes')?true:false;
            filmProdReq.Fire_EMS__c  = fireEMS.equalsIgnoreCase('Yes')?true:false;
            filmProdReq.Equipment__c  = filmProdReq.Equipment__c;
            filmProdReq.Filming_Parking_Loc_Simple__c  = filmProdReq.Filming_Parking_Loc_Simple__c;
            filmProdReq.Total_Production_Budget__c  = productionBudget;
            filmProdReq.Notes__c  = filmProdReq.Notes__c;*/
            
        }
        catch(Exception e)
        {
            System.debug('Exception e ::'+e.getMessage() + e.getStackTraceString() + e);
        }
    }
    
    public PageReference submitRequest()
    {
        PageReference pageRef ;
        try
        {
		System.debug('filmProdReq before inserting::'+filmProdReq);
            //Permit_Application__c filmProdReq = setFilmProductionRequest();
            
            //Database.SaveResult result = Database.insert(filmProdReq,false);
            Database.SaveResult result = Database.insert(filmProdReq,false);
            System.debug('result ::'+result);
            if(result.isSuccess())
            {
                /*List<Attachment> atts = new List<Attachment>();             	
                
                companyLogo.parentid=result.getId();
                insuranceCert.parentid=result.getId();
                complexParkingLocation.parentid=result.getId();
                otherAttachments.parentid=result.getId();
                
                atts.add(companyLogo);
                atts.add(insuranceCert);
                atts.add(complexParkingLocation);
                atts.add(otherAttachments);
                
                List<Database.SaveResult> attResults = Database.insert(atts,false);
                System.debug('After inserting attachments ::'+attResults);*/
                
                pageRef = new PageReference('/apex/PermitApplication?redirectPage=true');
                pageRef.getParameters().put('message', 'Hello! Thank you for your request. We will review and respond within 72 hours. – OCTFME Executive Staff');
                pageRef.setRedirect(true);
                
            }
            else
            {
                ApexPages.Message myMsg = new ApexPages.message(ApexPages.severity.FATAL,'There seems to be an issue while creating a Film Production Shoot request. Please try again');
                ApexPages.addMessage(myMsg);
                pageRef = null;
            }
            
            
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
    
    
   /* private Permit_Application__c setFilmProductionRequest()
    {
        Permit_Application__c filmProdRequest = new Permit_Application__c();
        
        try{
            filmProdRequest.Applicant_First_Name__c = firstName;
            filmProdRequest.Applicant_Last_Name__c = lastName;
            filmProdRequest.Applicant_Email__c = email;
            filmProdRequest.Applicant_Phone__c = phone;
            filmProdRequest.Producer_First_Name__c = producerFirstname;
            filmProdRequest.Producer_Last_Name__c = producerLastname;
            filmProdRequest.Production_Company__c = productionCompanyname;
            filmProdRequest.Street_Address__c = address;
            filmProdRequest.City__c = city;
            filmProdRequest.State__c = filmProdReq.State__c;
            filmProdRequest.Country__c = filmProdReq.Country__c;
            filmProdRequest.ZipCode__c = postalcode;
            filmProdRequest.Production_Title__c = productionTitle;
            filmProdRequest.Production_Type__c = Productiontype;
            filmProdRequest.Cast_Crew__c = filmProdReq.Cast_Crew__c;
            filmProdRequest.First_Shoot_Date__c = firstShootDateTime;
            filmProdRequest.Last_Shoot_Date__c  = lastShootDateTime;
            filmProdRequest.Additional_Day__c   = additionalDays ;
            filmProdRequest.Previous_Shoot_Date__c  = previousShootDate;
            filmProdRequest.Shoot_Description__c  = filmProdReq.Shoot_Description__c;
            filmProdRequest.Still_Photography_Only__c  = isStillPhotography;
            filmProdRequest.Equipment__c  = filmProdReq.Equipment__c;
            filmProdRequest.Filming_Parking_Loc_Simple__c  = filmProdReq.Filming_Parking_Loc_Simple__c;
            filmProdRequest.Total_Production_Budget__c  = productionBudget;
            filmProdRequest.Notes__c  = filmProdReq.Notes__c;
            filmProdRequest.Student_Permit__c = studentPermit;
            filmProdRequest.Is_Primary_Contact__c  = isPrimaryContact;
            filmProdRequest.Applicant_Role__c = filmProdReq.Applicant_Role__c;
            filmProdRequest.Producer_Phone__c = producerPhone;
            filmProdRequest.Producer_Email__c = producerEmail;
			filmProdRequest.Police_MPD_Support__c  = policeSupport;
            filmProdRequest.Fire_EMS__c  = fireEMS;
            
            
            
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
    
    public PageReference cancel()
    {
        return null;
    }
    
    
}