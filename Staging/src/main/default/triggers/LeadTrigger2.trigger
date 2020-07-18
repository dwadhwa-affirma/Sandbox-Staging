trigger LeadTrigger2 on Lead (before insert, before update) {
    List<Lead> leadsToUpdate;
    
    if (Trigger.isBefore) {
        if (Trigger.isInsert) {
            updateleadCreator(Trigger.new);
        }

        if (Trigger.isUpdate) {
            updateleadCreator(Trigger.new);
        }
    }

  
    // Method to update the Creator's Epysis ID of the Lead records
    public void updateleadCreator(List<Lead> newLeads) {
          // List<string> actNum = new List<string>();
     
      
        String curUserEmail = UserInfo.getUserEmail();
        
    //  String curUserAlias = UserInfo.getUserEmail().left(4);
         
       List<User> curUser = [select id, name, alias from User where Email = :curUserEmail];
        
        String curUserAlias = curUser[0].alias;
        
       Map<String, Decimal> episysMap = new Map<String, Decimal>();
        
     //    List<Double> U_BranchList = new List<Double>();
        
        Set<Double> episysSet = new Set<Double>();
        List<Episys_User__c> episysUsr = [Select Alias__c, Episys_ID__c, Assigned_Branch__c, DefaultValue__c from Episys_User__c where Alias__c =:curUserAlias order by DefaultValue__c asc];
    
        System.Debug('>>>> The Current User Alias is ' + curUserAlias);
        for(Episys_User__c eu : episysUsr ){
            episysMap.put(eu.Alias__c, eu.Episys_ID__c); 
          // U_BranchList.add(eu.Assigned_Branch__c);
            //episysSet.add(eu.Episys_ID__c);
         }
        
        
        
        
        System.Debug('>>>> The Current User Id is:::: ' + episysMap.get(curUserAlias));  
        for(Lead lead: Trigger.new){
             if (Trigger.isUpdate) {
                 Lead oldLead = Trigger.oldMap.get(lead.Id);
                 //Lead.Episys_User_ID__c = episysMap.get(oldLead.Episys_User__c);
                System.Debug('>>>> Update - CreatedBy(EpisysID) is ' + oldLead.Episys_User__c + '/'+ episysMap.get(oldLead.Episys_User__c));
             } else if (Trigger.isInsert) {
                 System.Debug('>>>> Insert - CreatedBy(EpisysID) is ' + curUserAlias + '/' + episysMap.get(curUserAlias)); 
                 Lead.Episys_User_ID__c = episysMap.get(curUserAlias);
                // Lead.UserBranch__c =  U_BranchList;
             }
        }
    }
 }