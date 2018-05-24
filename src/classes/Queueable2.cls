public class Queueable2 implements Queueable{
    
    public void execute(QueueableContext con)
    {
        Account acc = new Account(Name='My Queueable');
        insert acc;
    }

}