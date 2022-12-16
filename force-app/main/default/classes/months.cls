public class months {
    @AuraEnabled
    public static List<Date> getMonths()
    {   
        Date cm   = System.today().toStartOfMonth().addMonths(0);
        Date cm1  = System.today().toStartOfMonth().addMonths(1);
        Date cm2  = System.today().toStartOfMonth().addMonths(2);
        Date cm3  = System.today().toStartOfMonth().addMonths(3);
        Date cm4  = System.today().toStartOfMonth().addMonths(4);
        Date cm5  = System.today().toStartOfMonth().addMonths(5);
        Date cm6  = System.today().toStartOfMonth().addMonths(6);
        Date cm7  = System.today().toStartOfMonth().addMonths(7);
        Date cm8  = System.today().toStartOfMonth().addMonths(8);
        Date cm9  = System.today().toStartOfMonth().addMonths(9);
        Date cm10 = System.today().toStartOfMonth().addMonths(10);
        Date cm11 = System.today().toStartOfMonth().addMonths(11);
        
       List<Date> dates = new List<Date>();
        dates.add(cm);
        dates.add(cm1);
        dates.add(cm2);
        dates.add(cm3);
        dates.add(cm4);
        dates.add(cm5);
        dates.add(cm6);
        dates.add(cm7);
        dates.add(cm8);
        dates.add(cm9);
        dates.add(cm10);
        dates.add(cm11);
        return dates;
    }
}