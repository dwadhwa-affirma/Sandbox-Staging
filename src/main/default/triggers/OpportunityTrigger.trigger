trigger OpportunityTrigger on Opportunity (before insert, before update ) {

    if(OpportunityTriggerHandler.hasExecuted)// To prevent recursive re-entry
    {
         return;
    }
    
    OpportunityTriggerHandler.hasExecuted = true;
    
    OpportunityTriggerHandler handler = new OpportunityTriggerHandler(Trigger.isExecuting, Trigger.size);
    
    if(Trigger.isInsert && Trigger.isBefore)
    { 
        system.debug('OnBefore Insert###');
        handler.OnBeforeInsert(Trigger.new);
    }
    else if(Trigger.isUpdate && Trigger.isBefore)
    {

        handler.OnBeforeUpdate(Trigger.new, Trigger.newMap, Trigger.oldMap);

    }
    
}
   /* string uid= UserInfo.getUserId();
    User usr = [Select id, name, alias from User where id=:uid];
    List<Episys_User__c> eusr = [SELECT id, alias__c, Assigned_Branch__c,Episys_ID__c, Branch_Name__c,Default__c from Episys_User__c 
                                    where alias__c=:usr.alias order by Default__c desc]; 
                        
 if(Trigger.IsInsert)
    { 
                    Set<ID> accountid = new Set<Id>();
                     
                    for(Opportunity opp: trigger.New)
                    {
                            accountid.Add(opp.accountid);
        
                        if((opp.StageName == 'Closed Lost' || opp.StageName == 'Closed Won'))
                        {
                            opp.closedate = system.today();
                        }
                        if(eusr.size() > 0){
                            opp.Branch_of_Lead_creator__c =   eusr[0].Branch_Name__c;
                        }
                        
                        if(opp.Mortgage_Loan_Officer__c != null)
                        {
                            opp.Ownerid = opp.Mortgage_Loan_Officer__c;
                        }
                       // opp.Name = opp.Opportunity_Number__c; 
                       
                    }

               
                    List<Person_Account__c> pa =[select id,Account_Number__c,Account_Number__r.Brand__c,Person_Account__c.PersonID__c ,Account_Number__r.RecType__c
                            from Person_Account__c where PersonID__c IN : accountid];
                    List<Account> listAccountBrand = [select id,Parent_Lead__c,Parent_Lead__r.Brand__C from account where id in: accountid and Parent_Lead__c != null];
                    
                    
                     
                    for(Opportunity opp: trigger.New)   
                    {
                        
                        for(Account acc : listAccountBrand)
                        {
                            if(acc.id == opp.accountid && acc.Parent_Lead__c != null)
                            {
                                if(acc.Parent_Lead__r.Brand__C == 'CFCU'){
                                    opp.Brand__c = 'Chevron';
                                }
                                else{   
                                    opp.Brand__c = acc.Parent_Lead__r.Brand__C;
                                }
                                
                                break;
                            }   
                        
                        }
                        
                        
                        boolean found = false;
                        string brand = '';
                        for(Person_Account__c item : pa)
                        {
                            
                            if(opp.accountid == item.PersonID__c)
                            {
                                if(item.Account_Number__r.RecType__c == 'ACCT')
                                {
                                    opp.Brand__c = item.Account_Number__r.Brand__c;
                                    break;
                                }
                                else{
                                    if(brand == '')
                                    {
                                        brand = item.Account_Number__r.Brand__c;
                                    }
                                }
                                
                                
                            }
                            
                        }
                        if(brand != '')
                        {
                            opp.Brand__c = brand;
                        
                        }
    
                    }
             
    }
           
    if(Trigger.isupdate)
    {                              
               
        for(Opportunity opp: trigger.New)
        {
                 Opportunity oldOpp = trigger.oldMap.get(opp.Id);
                
                if(opp.Is_Converted__c && oldOpp.Opportunity_Source__c != opp.Opportunity_Source__c)
                {
                   opp.Adderror('Opportunity Source is read only for Opportunity converted from Lead.');
                }
                                
                if(opp.Is_Converted__c && oldOpp.Brand__C != opp.Brand__C)
                {
                    opp.Adderror('Brand is read only for Opportunity converted from Lead.');
                }
                
                if(opp.Is_Converted__c && oldOpp.Product_Type__c != opp.Product_Type__c)
                {
                    opp.Adderror('Product Type is read only for Opportunity converted from Lead.');
                }
                if(opp.Is_Converted__c && oldOpp.Product_Sub__c != opp.Product_Sub__c)
                {
                    opp.Adderror('Product Subtype is read only for Opportunity converted from Lead.');
                }
                
                if(oldOpp.How_did_you_hear_about_us__c != opp.How_did_you_hear_about_us__c)
                {
                    opp.Adderror('How did you hear about us is read only for Opportunity converted from Lead.');
                }
                
                if(opp.Is_Converted__c && oldOpp.Event_Source__c != opp.Event_Source__c)
                {
                    opp.Adderror('Event Source is read only for Opportunity converted from Lead.');
                }
                if(oldOpp.closedate != opp.closedate)
                {
                     opp.Adderror('Close date is read only');
                }
                if(oldOpp.AccountId != opp.AccountId && ((oldOpp.IsMemberOpportunity__c == opp.IsMemberOpportunity__c) && opp.IsMemberOpportunity__c ==false))
                {
                     opp.Adderror('Member name is read only');
                }
              
                if(oldOpp.Name != null && oldOpp.Name !='Name' && oldOpp.Name != opp.Name)
                {
                     opp.Adderror('Opportunity Number is read-only');
                }
                if((opp.StageName == 'Closed Lost' || opp.StageName == 'Closed Won') && oldOpp.StageName != opp.StageName)
                {
                    opp.closedate = system.today();
                } 

              if(opp.Is_Converted__c && oldOpp.Member_Branch__c != opp.Member_Branch__c)
              {
                opp.Adderror('Member Branch is read only for Opportunity converted from Lead.');
              }
              
              if(oldOpp.Mortgage_Loan_Officer__c != opp.Mortgage_Loan_Officer__c && opp.Mortgage_Loan_Officer__c!=null )
              {
                opp.Ownerid = opp.Mortgage_Loan_Officer__c;
              }
               if(oldOpp.Lead_Episys_User_ID__c != opp.Lead_Episys_User_ID__c)
                {
                     opp.Adderror('Lead Episys User Id is read only');
                }
               
                
        }
        
        
    }*/