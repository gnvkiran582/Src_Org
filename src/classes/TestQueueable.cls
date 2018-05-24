@isTest
public class TestQueueable {
    
    public testMethod static void m1()
    {
        Test.startTest();
        Queueable1 q1 = new Queueable1();
        Account acc = [select id,Name from Account where Name='My Queueable'];
        System.debug('acc ::'+acc);
        Test.stopTest();
    }
}