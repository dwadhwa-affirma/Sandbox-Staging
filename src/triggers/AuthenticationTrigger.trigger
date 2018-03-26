trigger AuthenticationTrigger on Authenticated_Log__c (before insert, before update) {

   public string uid= UserInfo.getUserId();

   if(trigger.isbefore){
        if(trigger.isUpdate){
        updateMember(Trigger.new);
    }
    
    if(trigger.isInsert){
        updateMember(Trigger.new);
       // updateStaff(Trigger.new);
    }
    
   }
   
      
   

    public void updateMember(List<Authenticated_Log__c> auth){
   
       List<Account> act;
       List<Person_Account__c> prsn;
      // List<Account_details__c> ActNum;
       
       
             
       if (auth[0].SalesforceID__c != '')
        {
        act = [Select id, Email_raw__c, FirstName, PersonID__c  from Account where id =:auth[0].SalesforceID__c]; 
        
        }
       if (act.size() > 0)
       {
                      
            prsn = [Select id, Brand__c, Account_Number__c, RecType__c from Person_Account__c where PersonID__c =:act[0].ID];
            system.debug('prsn number of records::::' + prsn.size()); 
            system.debug('Member Name number of records::::' + act.size());
            
                      
             if(prsn.size()>0){
            for(Authenticated_Log__c au:Trigger.new){
                 
                     //Commenting for production deployment since these fields don't exist 
                              au.Email__c = act[0].Email_raw__c;
                              au.Brand__c = prsn[0].Brand__c;
                              au.First_Name__c = act[0].FirstName;
                              au.PersonId__c = act[0].PersonID__c;
                          
                            
                            
               } 
            
                
                
                
       }
       List<user> usr = [Select id, alias, Name from user where id=:uid];
      system.debug('current user id is :::' + uid);
      system.debug('current user alias is :::' + usr[0].alias);
     
         //Commenting for production deployment since these fields don't exist 
         List<Episys_User__c> epId = [Select id, Episys_ID__c, Branch_Name__c from Episys_User__c where alias__c = :usr[0].alias];
         //List<Episys_User__c> epId = [Select id from Episys_User__c where alias__c = :usr[0].alias];
         if(epId.size()>0){ 
            // auth[0].Staff_Episys_Id__c = epId[0].Episys_ID__c;
             system.debug('current user ep.alias is :::' + usr[0].alias);
             //system.debug('current user ep.id is :::' + epId[0].Episys_ID__c);
              for(Authenticated_Log__c au:Trigger.new){
                 au.Staff_Episys_ID__c = epId[0].Episys_ID__c;
                 au.Staff_Name__c = usr[0].Name;
              }
             
         }
         
     
           
       }
   }
}