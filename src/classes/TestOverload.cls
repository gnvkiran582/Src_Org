public class TestOverload {

    public TestOverload()
    {
        this(40);
        system.debug('Hello 1');
    }
    
    public TestOverload(Integer i)
    {
        this();
        system.debug('Hello 2');
    }
    
    public static void m1(String s)
    {
        system.debug(s);
    }
    
        public static void m1(Integer i)
    {
        system.debug(i);
    }
    
    
    public static void m2()
    {
        Contact con = new Contact(LastName='John');
        Account acc = new Account(abc__c = 'abc',state__c='District of Columbia');
        con.account = acc;
        
        Account pac = new Account(Name='John',abc__c = 'abc',state__c='District of Columbia');
        List<Database.SaveResult> results = Database.insert(new SObject[]{pac,con} , false);
        System.debug('results ::'+results);
        
    }
}