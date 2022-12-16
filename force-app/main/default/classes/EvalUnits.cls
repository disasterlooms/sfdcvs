public class EvalUnits
{

 public List<AccountWrapper> wrappers {get; set;}
 public static Integer toDelIdent {get; set;}
 public static Integer addCount {get; set;}
 private Integer nextIdent=0;
  
 public EvalUnits()
 {
  wrappers=new List<AccountWrapper>();
  for (Integer idx=0; idx<5; idx++)
  {
   wrappers.add(new AccountWrapper(nextIdent++));
  }
 }
  
 public void delWrapper()
 {
  Integer toDelPos=-1;
  for (Integer idx=0; idx<wrappers.size(); idx++)
  {
   if (wrappers[idx].ident==toDelIdent)
   {
    toDelPos=idx;
   }
  }
   
  if (-1!=toDelPos)
  {
   wrappers.remove(toDelPos);
  }
 }
  
 public void addRows()
 {
  for (Integer idx=0; idx<addCount; idx++)
  {
   wrappers.add(new AccountWrapper(nextIdent++));
  }
 }
  
 public PageReference save()
 {
  List<Eval_Unit_Details__c> accs=new List<Eval_Unit_Details__c>();
  for (AccountWrapper wrap : wrappers)
  {
   accs.add(wrap.acc);
  }
   
  insert accs;
   
  return new PageReference('/' + ApexPages.currentPage().getParameters().get('CF00NA000000AKSaY_lkid'));
 }
  
 public class AccountWrapper
 {
  public Eval_Unit_Details__c acc {get; private set;}
      
  public Integer ident {get; private set;}
   
  public AccountWrapper(Integer inIdent)
  {
   ident=inIdent;
   acc=new Eval_Unit_Details__c(Name='');
   acc.Eval_Request__c = ApexPages.currentPage().getParameters().get('CF00NA000000AKSaY_lkid');
  }
 }
}