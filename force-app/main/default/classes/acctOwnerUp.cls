public class acctOwnerUp {
    @AuraEnabled 
    public static void  ownerUp(string recid){
         
        List<Account> acc = new List<Account>();
        account a = new account(id= recid);
        acc.add(a);
        AccountTeamAdd.teams(acc);
        system.debug(acc);
        
    }
     

}