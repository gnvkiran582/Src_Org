@isTest(seeAllData=false)
public Class DemoTest{

    public static testmethod void testdemoMethod()
    {
       String str = Demo.demoMethod();
       System.assert(str=='Demo Method','Method exec failed');
    }
}