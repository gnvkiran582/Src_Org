public class Queueable1 implements Queueable{
    
	public void execute(QueueableContext con)
    {
        Queueable2 qu = new Queueable2();
        System.enqueueJob(qu);
    }

}