public with sharing class vfChildRecords {
    public Id pId {get;set;}
    public String squery {get;set;}
    public String obj {get;set;}
    List<SObject> records {get;set;}
    List<SObject> childrenRecords {get;set;}
    
    public List<SObject> getrecords()
    {
        List<SObject> oppty;
       records = oppty;
       childrenRecords = records;
        return oppty;
    }
}