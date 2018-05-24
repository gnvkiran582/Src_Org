public class ObjectFieldMapping {

    public static void m1()
    {
        Account acc = new Account();
        acc.Name = 'Test';
        
        System.debug('acc ::'+acc);
        System.debug('acc1 ::'+acc.get('Name'));
    }
}