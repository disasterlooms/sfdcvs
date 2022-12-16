trigger countattachment on Attachment (after insert, after update, after delete, after undelete) {
  Map<Id,List<Attachment>> parent = new Map<Id,List<Attachment>>();
  set<id> attids = new set<id>();
     
   if(Trigger.new<>null){
       for(Attachment c:Trigger.new){
           Eval_Request__c l;
           if(c.ParentId != null)
               attids.add(c.parentid);
       }
           
   }else if(Trigger.old != null){
       for(Attachment c:Trigger.old){
           if(c.ParentId<>null)      
               attids.add(Trigger.oldMap.get(c.id).parentid);
       }
   }
   if(attids.size()>0){
       try{
           List<Attachment> a = new List<Attachment>();
           Map<id,Eval_Request__c> testmap = new Map<id,Eval_Request__c>([select id,Attachments__c from Eval_Request__c where id IN: attids]);
           a = [select id,parentid from Attachment where parentid IN:attids];
           
           for(Attachment at: a){
               List<Attachment> llist = new List<Attachment>();
               if(parent.get(at.parentid) == null){
                   llist = new List<Attachment>();
                   llist.add(at);
                   parent.put(at.parentid,llist);
               }else if(parent.get(at.parentid) != null){
                   llist = new List<Attachment>();
                   llist = parent.get(at.parentid);
                   llist.add(at);
                   parent.put(at.parentid,llist);
               }
           }
           
           for(Id i: attids){
               if(testmap.get(i) != null && parent.get(i) != null){
                  testmap.get(i).Attachments__c = parent.get(i).size(); 
               
               }else if(testmap.get(i) != null && parent.get(i) == null){
                  testmap.get(i).Attachments__c = 0; 
               }
           }
       
           update testmap.values();
           System.Debug(testmap.values());
       }catch(Exception e){}
    }

}