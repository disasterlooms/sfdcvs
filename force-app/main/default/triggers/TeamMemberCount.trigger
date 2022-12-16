trigger TeamMemberCount on OpportunityTeamMember (after delete) {
      
List<Opportunity> OpportunityList = new List<Opportunity>();
Map<Id, Id> OppIdOppMemberIdMap = new Map<Id, Id>();

for(OpportunityTeamMember OpportunityTeamMemberObj: Trigger.Old){
    if(OpportunityTeamMemberObj.TeamMemberRole =='Distributor')
        OppIdOppMemberIdMap.put(OpportunityTeamMemberObj.OpportunityId , OpportunityTeamMemberObj.Id);
}

for(Opportunity opportunityObj : [Select Id, Team_Member_Count__c from Opportunity where Id IN: OppIdOppMemberIdMap.keyset()]){
    if(OppIdOppMemberIdMap.Containskey(opportunityObj.Id)){
        opportunityObj.Team_Member_Count__c = True;
        OpportunityList.add(opportunityObj);
        }
    }
update OpportunityList;

}