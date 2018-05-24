public class URLRedirectionController {

    
    public PageReference submitPage()
    {
        Account acc = new Account();
        acc.Name = 'My Test Acc mine1'; 
        acc.Country__c = 'United States of America';
        acc.State__c = 'District of Columbia';
        insert acc;
        System.debug('acc ::'+acc);
        ApexPages.Message myMsg = new ApexPages.message(ApexPages.severity.CONFIRM,'Meeting Request Sent Succesfully. We shall get back to you with further details');
                ApexPages.addMessage(myMsg); 
        PageReference page = new Pagereference('https://entertainment.dc.gov');
        return page;
    }
}