public class TestRadioController {

    
    public String isAnnualItem {get;set;} 
    
    public List<SelectOption> getAnnualItemOptions() {
        List<SelectOption> options = new List<SelectOption>(); 
        options.add(new SelectOption('Yes','Yes')); 
        options.add(new SelectOption('No','No')); 
        return options; 
    }
}