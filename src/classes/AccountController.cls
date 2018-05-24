public class AccountController {

    
    @AuraEnabled
    public static void saveAccount(Account accRec)
    {
        insert accRec;
    }
}