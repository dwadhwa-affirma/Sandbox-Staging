public class OpportunityTriggerHandler {
    
    public static boolean hasExecuted = false;
    
   private boolean m_isExecuting = false;
   private integer BatchSize = 0;
   private Sla_Manager__mdt[] slaDefList;
   private String NewOppSources;
        
   public OpportunityTriggerHandler(boolean isExecuting, integer size )
     {
    m_isExecuting =  isExecuting;
    BatchSize = size;
    slaDefList = [SELECT DeveloperName,Event_Source__c,Opportunity_Source__c,Product_Type__c,SLA__c,StageName__c FROM Sla_Manager__mdt WHERE Object_Name__c = 'Opportunity' ORDER BY DeveloperName ASC];
    NewOppSources = slaDefList[0].Opportunity_Source__c; // First Definition is used for Opportunity Source Breaches
    }
    
    decimal getSLA(Opportunity opp) {
        // Routine loops through all metadata for opportunities and if a match is found, returns the SLA based on Event_Source__c,Opportunity_Source__c,Product_Type__c & StageName__c combination.
        // Definitions can include single values or lists for Event_Source__c & Opportunity_Source__c.
        // Wildcard * in Event_Source__c or Opportunity_Source__c def means it only requires opp.[field] is populated.
        Boolean opportunitySourceOK,productTypeOK,eventSourceOK,stageOK;
        String defEventSource,defOppSource,defOppProductType,defStage;
        Decimal sla;
        opportunitySourceOK = false;
        productTypeOK       = false;
        eventSourceOK       = false;
        stageOK             = false;
        for(Sla_Manager__mdt slaDef : slaDefList) {
          if(slaDef.Event_Source__c == '*') { // * = something has to have been chosen, but it doesn't matter what.
            if(!String.isBlank(opp.Event_Source__c)) {
              eventSourceOK = true;
            }
          } else {
            if(String.isBlank(slaDef.Event_Source__c)) {
              eventSourceOK = true;
            } else  {
              defEventSource = slaDef.Event_Source__c;
              if(String.isNotBlank(opp.Event_Source__c) && defEventSource.contains(opp.Event_Source__c)) {
                eventSourceOK = true;
              }
            }
          }
          if(slaDef.Opportunity_Source__c == '*') { // * = something has to have been chosen, but it doesn't matter what.
            if(!String.isBlank(opp.Opportunity_Source__c)) {
              opportunitySourceOK = true;
            }
          } else {
            if(String.isBlank(slaDef.Opportunity_Source__c)) {
              opportunitySourceOK = true;
            } else  {
              defOppSource = slaDef.Opportunity_Source__c;
              if(String.isNotBlank(opp.Opportunity_Source__c) && defOppSource.contains(opp.Opportunity_Source__c)) {
                opportunitySourceOK = true;
              } 
            }
          }
          if(String.isBlank(slaDef.Product_Type__c)) {
            productTypeOK = true;
          } else {
            defOppProductType = slaDef.Product_Type__c;
            // Maybe one day, list of product will be used.  Ready for that.
            if(String.isNotBlank(opp.Product_Type__c) && defOppProductType.contains(opp.Product_Type__c)) {
              productTypeOK = true;
            }
          }
          if(String.isBlank(slaDef.StageName__c)) {
            stageOK = true;
          } else {
            defStage = slaDef.StageName__c;
            if(defStage == opp.StageName) {
              stageOK = true;
            }
          }
          if(eventSourceOK && opportunitySourceOK && productTypeOK && stageOK) {
            sla = slaDef.Sla__c;
            break;
          }
          else{
            sla = null;  
          }
        }
        return sla;
      }

    public void OnBeforeInsert(Opportunity[] newOpportunities) {
        BusinessHours stdBusinessHours = [select id from businesshours where isDefault = true];
        
        system.debug('Handler Called###');
        string uid= UserInfo.getUserId();
        User usr = [Select id, name, alias from User where id=:uid];
        
        
        List<Episys_User__c> eusr = [SELECT id, alias__c, Assigned_Branch__c,Episys_ID__c, Branch_Name__c,Default__c from Episys_User__c 
                                     where alias__c=:usr.alias order by Default__c desc]; 
        Set<ID> accountid = new Set<Id>();
        Id LoggedinUser = UserInfo.getUserId();
        Set<Decimal> Episys_User_ID = new Set<Decimal>(); 
        Set<String> branchnameSet = new Set<String>(); 
        Set<String> MemAccId = new Set<String>();
        
        for(Opportunity opp: newOpportunities)  {              
            accountid.Add(opp.accountid);
            MemAccId.Add(opp.Member_Account__c);
            
            if((opp.StageName == 'Closed Lost' || opp.StageName == 'Closed Won'))  {
                opp.closedate = system.today();
            }
            
            if(opp.Member_Type__c == 'Pre Member') {
                opp.IsCreatedAsMember__c = false;
            }  
            else if(opp.Member_Type__c == 'Member') {
                opp.IsCreatedAsMember__c = true;
            }         
        }
        
        //CRM-1640: Update Description for Marketing Cloud Opprtunities
        for(Opportunity opp: newOpportunities) {
            system.debug('Description=='+opp.DESCRIPTION);
            if(opp.OPPORTUNITY_SOURCE__C == 'Campaign Outreach' && opp.DESCRIPTION != null) {
                system.debug('Description1=='+opp.DESCRIPTION);
                if(opp.DESCRIPTION.containsIgnoreCase('Relevant Member Number')) {
                    opp.DESCRIPTION = opp.DESCRIPTION.replace('Relevant Member Number','\n \n Relevant Member Number');
                    system.debug('Description2=='+opp.DESCRIPTION);
                }
                if(opp.DESCRIPTION.containsIgnoreCase('Last Activity Date')){
                    opp.DESCRIPTION = opp.DESCRIPTION.replace('Last Activity Date','\n Last Activity Date');
                }
                if(opp.DESCRIPTION.containsIgnoreCase('Dormant Date')){
                    opp.DESCRIPTION = opp.DESCRIPTION.replace('Dormant Date','\n Dormant Date');
                }
                if(opp.DESCRIPTION.containsIgnoreCase('High Value/High Potential')){
                    opp.DESCRIPTION = opp.DESCRIPTION.replace('High Value/High Potential','\n High Value/High Potential');
                }
                if(opp.DESCRIPTION.containsIgnoreCase('Script Link')){
                    opp.DESCRIPTION = opp.DESCRIPTION.replace('Script Link','\n \n Script Link');
                }
            }
        }
        
        List<Account> accName = [Select Name, Id from Account where Id IN:accountid ];
        for(Opportunity opp: newOpportunities) {
            for(Account acc: accName) {
                if(opp.AccountId == acc.id ) {
                    opp.Opportunity_Name_Text__c = acc.Name;
                }
            }
        }
        
        Map<id,String> MemAccMap = new Map<id,string>();
        for(Account_Details__c ad : [select Id, Created_At_Branch1__c from Account_Details__c where id =:MemAccId AND Created_At_Branch1__c != null]){
            MemAccMap.put(ad.Id, ad.Created_At_Branch1__c);
        }
        
        List<Person_Account__c> pa =[select id,Account_Number__c,Account_Number__r.Brand__c,Person_Account__c.PersonID__c ,Account_Number__r.RecType__c
                                     from Person_Account__c where PersonID__c IN : accountid];
        List<Account> listAccountBrand = [select id,Parent_Lead__c,Parent_Lead__r.Brand__C from account where id in: accountid and Parent_Lead__c != null];
        system.debug('accountid##'+ accountid);
        system.debug('pa##'+ pa);
        system.debug('listAccountBrand##'+ listAccountBrand);
        for(Opportunity opp: newOpportunities) {
            for(Account acc : listAccountBrand) {
                if(acc.id == opp.accountid && acc.Parent_Lead__c != null) {
                    if(acc.Parent_Lead__r.Brand__C == 'CFCU'){
                        opp.Brand__c = 'Chevron';
                    } else {   
                        opp.Brand__c = acc.Parent_Lead__r.Brand__C;
                    }
                    break;
                }
            }
            boolean found = false;
            string brand = '';
            system.debug('pa: '+pa.size());
            for(Person_Account__c item : pa) {
                system.debug('PersonID__c##'+ item.PersonID__c);
                if(opp.Member_Account__c == item.Account_Number__c) {   
                    system.debug('RecType__c##'+ item.Account_Number__r.RecType__c);
                    system.debug('Brand##'+ item.Account_Number__r.Brand__c);
                    if(item.Account_Number__r.RecType__c == 'ACCT')
                    {
                        opp.Brand__c = item.Account_Number__r.Brand__c;
                        break;
                    }
                    else{
                        opp.Brand__c = item.Account_Number__r.Brand__c;
                       
                    }
                }
            }
            
            
            /* logic to get branch detail from member account detail */
            if(opp.Member_Account__c != null && MemAccMap.containsKey(opp.Member_Account__c)){
                opp.Member_Branch__c = MemAccMap.get(opp.Member_Account__c);
            }
        }
        
        for(Opportunity opp: newOpportunities) {
            if(opp.Episys_User_ID__c != null) {
                Episys_User_ID.Add(opp.Episys_User_ID__c);
            }
        }
        system.debug('Episys_User_ID###' + Episys_User_ID);
        List<Episys_User__c> episysUsers = [SELECT id, alias__c, Assigned_Branch__c,Episys_ID__c, Branch_Name__c,Default__c from Episys_User__c 
                                            where Episys_ID__c in: Episys_User_ID];
        Group OppQueue = new Group();   
        String groupName = '';           
        List<Group> listQueue = [select id,Name,Email from Group where Type = 'Queue' and (Email like '%lead.com' or Email like '%opportunity.com')];
        for(Opportunity opp: newOpportunities) {
            system.debug('Above Conditions###');
            system.debug('Ownership__c###' + opp.Ownership__c);
            
            if(opp.Ownership__c == 'Auto Assign' && (opp.Opportunity_Source__c == 'Branch Walk in' || opp.Opportunity_Source__c == 'Branch Call')  && opp.Is_Converted__c == false) {
                system.debug('opp.Episys_User_ID__c###' + opp.Episys_User_ID__c);
                system.debug('episysUsers###' + episysUsers);
                groupName = '';
                if(episysUsers.size() > 0) {
                    for(Episys_User__c episysItem: episysUsers) {
                        system.debug('episysItem.Episys_ID__c###' + episysItem.Episys_ID__c);
                        if(opp.Episys_User_ID__c == episysItem.Episys_ID__c) {
                            system.debug('Episys user matched###');
                            string BranchQueue = episysItem.Branch_Name__c.replace(' ', '_').replace('-','_').replace('/','_').toLowerCase();
                            system.debug('EBranchQueue###' + BranchQueue);
                            for(Group grp : listQueue) {
                                if(grp.Email.containsIgnoreCase(BranchQueue)) {
                                    groupName = grp.Name;
                                    break;
                                }
                            }
                            if(groupName!=null && groupName!='') {
                                
                                opp.Queue_Owner__c = groupName; 
                                opp.User_Owner__c = null;
                                opp.Ownership__c ='Keep';
                            } else {
                                system.debug('Condition Product Type###');
                                string ProductType = opp.Product_Type__c.replace(' ', '_').replace('-','_').replace('/','_').toLowerCase();
                                system.debug('ProductType###' + ProductType);
                                for(Group grp : listQueue) {
                                    if(grp.Email.containsIgnoreCase(ProductType)) {
                                        groupName = grp.Name;
                                        break;
                                    }
                                }
                                system.debug('groupName###' + groupName);
                                if(groupName!=null && groupName!='') {
                                    opp.Queue_Owner__c = groupName; 
                                    opp.User_Owner__c = null;
                                    opp.Ownership__c ='Keep';
                                }
                            }
                            break;
                        }
                    }
                } else {
                    system.debug('Condition Product Type###');
                    string ProductType = opp.Product_Type__c.replace(' ', '_').replace('-','_').replace('/','_').toLowerCase();
                    system.debug('ProductType###' + ProductType);
                    for(Group grp : listQueue) {
                        if(grp.Email.containsIgnoreCase(ProductType)) {
                            groupName = grp.Name;
                            break;
                        }
                    }
                    system.debug('groupName###' + groupName);
                    if(groupName!=null && groupName!='')
                    {
                        opp.Queue_Owner__c = groupName; 
                        opp.User_Owner__c = null;
                        opp.Ownership__c ='Keep';
                    }
                }
            } else if(opp.Ownership__c == 'Auto Assign' && opp.Opportunity_Source__c == 'Event') {
                string BranchQueue='';
                groupname='';
                if(eusr.size() > 0 && eusr[0].Default__c == true) {
                    BranchQueue = eusr[0].Branch_Name__c.replace(' ', '_').replace('-','_').replace('/','_').toLowerCase();
                }
                else if(eusr.size() > 0 && eusr[0].Default__c == false){
                    BranchQueue = eusr[0].Branch_Name__c.replace(' ', '_').replace('-','_').replace('/','_').toLowerCase();
                }
                system.debug('EBranchQueue###' + BranchQueue);
                if(BranchQueue != null && BranchQueue != '') {
                    for(Group grp : listQueue) { 
                        if(grp.Email.containsIgnoreCase(BranchQueue)) {
                            groupname = grp.Name;
                            break;
                        }
                        system.debug('groupName###' + groupname);
                    }
                }
                if(groupname != null && groupname!=''){
                    opp.Queue_Owner__c = groupName;   
                    opp.User_Owner__c = null;
                    opp.Ownership__c ='Keep';
                } else {
                    system.debug('Condition Product Type###');
                    string ProductType = opp.Product_Type__c.replace(' ', '_').replace('-','_').replace('/','_').toLowerCase();                        
                    for(Group grp : listQueue) {
                        if(grp.Email.containsIgnoreCase(ProductType)) {
                            groupname = grp.Name;
                            break;
                        }
                    }
                    system.debug('groupName###' + groupname);
                    if(groupname!=null && groupname!='') {
                        opp.Queue_Owner__c = groupName;   
                        opp.User_Owner__c = null;
                        opp.Ownership__c ='Keep';
                    }
                }
            } 
            else if(opp.Ownership__c == 'Auto Assign' && (opp.Opportunity_Source__c != 'Branch Walk in' && opp.Opportunity_Source__c != 'Branch Call')  && opp.Is_Converted__c == false) {
                system.debug('Condition Product Type###');
                string ProductType = opp.Product_Type__c.replace(' ', '_').replace('-','_').replace('/','_').toLowerCase();
                system.debug('ProductType###' + ProductType);
                for(Group grp : listQueue) {
                    if(grp.Email.containsIgnoreCase(ProductType)) {
                        groupName = grp.Name;
                        break;
                    }
                }
                system.debug('groupName###' + groupName);
                if(groupName!=null && groupName!='')
                {
                    opp.Queue_Owner__c = groupName; 
                    opp.User_Owner__c = null;
                    opp.Ownership__c ='Keep';
                }
            }
        } 
updateSLAFields(Trigger.new, null);
    }
    
    public void OnBeforeUpdate(Opportunity[] Opportunities, Map<ID, Opportunity> OpportunityNewMap, Map<ID, Opportunity> OpportunityOldMap) {
        BusinessHours stdBusinessHours = [select id from businesshours where isDefault = true];
        
        system.debug('----------------------------Limit'+Limits.getQueries());
        string uid= UserInfo.getUserId();
        User usr = [Select id,name,Profile.Name,UserRole.Name ,alias from User where id=:uid];
        
        String userrolename = usr.UserRole.Name;
        system.debug('userrolename'+userrolename);
        
        Id LoggedinUser = UserInfo.getUserId();
        String profilename = usr.Profile.Name;
        system.debug('profilename'+profilename);
        Set<Decimal> Episys_User_ID = new Set<Decimal>(); 
        Set<String> branchnameSet = new Set<String>(); 
        Group OppQueue = new Group();   
        String groupName = '';   
        List<Decimal> ListEpisysIds = new List<Decimal>();
        Set<id> QueOppId = new Set<id>();
        for(Opportunity opp: Opportunities) {
            if(opp.Queue_Owner__c != null && opp.Queue_Owner__c !=''){
                QueOppId.add(opp.id);
            }
            if(opp.Episys_User_ID__c != null) {
                ListEpisysIds.add(opp.Episys_User_ID__c);
            }
        }
        List<Episys_User__c> euser = [SELECT id,alias__c, Assigned_Branch__c,Episys_ID__c, Branch_Name__c,Default__c 
                                      from Episys_User__c where Episys_ID__c  in: ListEpisysIds];
        for(Opportunity opp: Opportunities) {
            // opp.Branch_of_Lead_creator__c =   ''; // This is commented out by Deepika for PMI2-69 fix
            for(Episys_User__c episysid : euser) {
                if(episysid.Episys_ID__c == opp.Episys_User_ID__c) {
                    opp.Branch_of_Lead_creator__c =   episysid.Branch_Name__c;
                    Episys_User_ID.Add(opp.Episys_User_ID__c);
                    break;
                }
            }
        }
        
        /* Code for CRM-1384 Begin*/
        Map<Id, Task> taskMap = new Map<Id, Task>();
        List<Task> taskList = [SELECT Id, WhatId FROM Task WHERE IsClosed=false AND WhatId IN :OpportunityNewMap.keySet()]; 
        System.debug('tskList###'+taskList);
        for(Task t : taskList) {
            taskMap.put(t.WhatId, t);
        } 
        System.debug('taskmap###'+taskMap);
        for(Opportunity oppt: Opportunities) {
            if(oppt.StageName == 'Closed Won' || oppt.StageName == 'Closed Lost') {
                if(taskMap.containsKey(oppt.Id)) {
                    oppt.addError('All tasks associated with an opportunity must be close/completed before an opportunity closed.');
                }
            }
        } 
        /* Code for CRM-1384 Ends here*/   
        
        List<Group> listQueue = [select id,Name,Email from Group where Type = 'Queue' and (Email like '%lead.com' or Email like '%opportunity.com')];
        List<Episys_User__c> episysUsers = [SELECT id, alias__c, Assigned_Branch__c,Episys_ID__c, Branch_Name__c,Default__c from Episys_User__c 
                                            where Episys_ID__c in: Episys_User_ID];
        
        system.debug('----------------'+QueOppId) ;   
        String pid = UserInfo.getProfileId();
        /*
Change by Graham Smith to allow closed opps to be re-opened if user is in metadata  Profiles_that_can_reopen_an_opportunity__mdt
*/
        Set<Id> profilesThatCanReopenOpp = new Set<Id>();
        List<Profiles_that_can_reopen_an_opportunity__mdt> profiles = Profiles_that_can_reopen_an_opportunity__mdt.getall().values();
        for(Profiles_that_can_reopen_an_opportunity__mdt profile : profiles) {
            System.debug(profile.Profile_Id__c + ' - ' + profile.DeveloperName);
            profilesThatCanReopenOpp.add(profile.Profile_Id__c);
        }
        
        Opportunity oppObject = new Opportunity();
        Schema.SObjectType objType = oppObject.getSObjectType(); 
        Map<String, Schema.SObjectField> mapFields = Schema.SObjectType.Opportunity.fields.getMap(); 
        
        for(Opportunity opp: Opportunities)  {       
            Opportunity oldOpp = OpportunityOldMap.get(opp.Id);
            
            
            Set<String> updatedFields = new Set<String>();
            for (String str : mapFields.keyset()) 
            { 
                try 
                { 
                    if(opp.get(str) != oldOpp.get(str))
                    { 
                        updatedFields.add(str);
                    } 
                } 
                catch (Exception e) 
                { 
                    System.Debug('Error: ' + e); 
                } 
            }
            
            System.debug('userRole:'+userrolename);
            System.debug('Product_Type__c:'+opp.Product_Type__c);
            System.debug('opp.Status:'+opp.StageName);
            System.debug('oldOpp.Status:'+oldOpp.StageName);
            System.debug('updatedFields:'+updatedFields);
            
            if(QueOppId.contains(opp.id) && (opp.StageName == 'Closed Won' || opp.StageName == 'Closed Lost')){
                opp.Adderror('Queue owned opportunities cannot be closed.');
            }
            
            
            if( (oldOpp.StageName == 'Closed Won' || (oldOpp.StageName == 'Closed Lost' && opp.StageName == 'Closed Lost') )&& 
            opp.Product_Type__c == 'Mortgage' && (userrolename == 'Mortgage Sales Manager 5'|| userrolename == 'Mortgage Sales Manager 7') 
                 && updatedFields.size() == 1 
               && updatedFields.contains('opportunity_source__c'))
               
               {
                   // Allow Mortgage Sales Manager to update the opportunity_source__c
               } 
               else if( (oldOpp.StageName == 'Closed Won' || oldOpp.StageName == 'Closed Lost') && 
               (userrolename == 'Mortgage Sales Manager 5'|| userrolename == 'Mortgage Sales Manager 7') &&
                opp.Product_Type__c == 'Mortgage' && updatedFields.contains('opportunity_source__c') &&   updatedFields.contains('event_source__c') &&
               ( opp.Opportunity_Source__c== 'Event' || opp.Opportunity_Source__c=='Member Intelligence') && updatedFields.size() == 2 )
               {
                   // Allow Mortgage Sales Manager to update the opportunity_source__c  when opportunity_source__c='event'
               }
            else{
                
                if( (oldOpp.StageName == 'Closed Won' || (oldOpp.StageName == 'Closed Lost'  && opp.StageName == 'Closed Lost'))&& opp.Allow_Error__c == false) {
                    if(!profilesThatCanReopenOpp.contains(pid)) {
                        opp.Adderror('Opportunity fields are read only for Closed Opportunity.');
                    }
                } 
            }
            
            
            
            
            if(opp.Product_Type__c == 'Mortgage' && opp.StageName == 'Closed Won' && String.isBlank(opp.Loan_Number__c) ) {
                opp.Adderror('Product Number is required when Product=Mortgage and Status=Closed Won');
            }
            if(opp.Is_Converted__c && oldOpp.Opportunity_Source__c != opp.Opportunity_Source__c) {
                opp.Adderror('Opportunity Source is read only for Opportunity converted from Lead.');
            }
            if(opp.Is_Converted__c && oldOpp.Brand__C != opp.Brand__C) {
                opp.Adderror('Brand is read only for Opportunity converted from Lead.');
            }
            if(oldOpp.How_did_you_hear_about_us__c != opp.How_did_you_hear_about_us__c) {
                opp.Adderror('How did you hear about us is read only for Opportunity converted from Lead.');
            }
            if(opp.Is_Converted__c && oldOpp.Event_Source__c != opp.Event_Source__c) {
                opp.Adderror('Event Source is read only for Opportunity converted from Lead.');
            }
            if(oldOpp.closedate != opp.closedate) {
                opp.Adderror('Close date is read only');
            }
            if(oldOpp.AccountId != opp.AccountId && ((oldOpp.IsMemberOpportunity__c == opp.IsMemberOpportunity__c) && opp.IsMemberOpportunity__c == false && opp.Allow_Error__c == false)) {
                opp.Adderror('Member name is read only');
            }
            if(oldOpp.Name != null && oldOpp.Name !='Name' && oldOpp.Name != opp.Name) {
                opp.Adderror('Opportunity Number is read-only');
            }
            if((opp.StageName == 'Closed Lost' || opp.StageName == 'Closed Won') && oldOpp.StageName != opp.StageName) {
                opp.closedate = system.today();
            } 
            
            
            if(opp.Product_Type__c == 'Mortgage' && (opp.StageName == 'Closed Won' || opp.StageName == 'Closed Lost') ) {
                //opp.Adderror('Product Number is required when Product=Mortgage and Status=Closed Won');
            }
     
            
            if(oldOpp.Lead_Episys_User_ID__c != opp.Lead_Episys_User_ID__c) {
                opp.Adderror('Lead Episys User Id is read only');
            }
            
            if((opp.StageName != 'Closed Lost' && opp.StageName != 'Closed Won') && oldOpp.StageName != opp.StageName) {
                opp.closedate = date.ValueOf('2048-12-31');
            }
            
            if(opp.Allow_Error__c == true){
                opp.Allow_Error__c = false;
            }
            

        }
        
        
 
updateSLAFields(Trigger.new, Trigger.old);    
    }
    /*----PRJ0011432-11432: MARS Functionality Review Changes start-----*/
    public void updateSLAFields(List<Opportunity> newOppList, List<Opportunity> oldOpportunityList){
        system.debug('newOppList'+ newOppList);
        system.debug('oldOpportunityList'+ oldOpportunityList);
        BusinessHours stdBusinessHours = [select id
                                          from businesshours
                                          where isDefault = true];

        
        Map<string, Opportunity> mapOldOpportunity = new Map<string, Opportunity>();
         
        if (trigger.isBefore){
            if (trigger.isinsert){
                if (newOppList.size() > 0){
                    for (Opportunity l : newOppList){
                        /*--------Update SLA Field------*/
                        string status = l.StageName;
                       
                         l.SLA_Business_Hours__c = getSLA(l);
                      
                        /*--------Update TimeStamp Fields------*/
                        if (status == 'New'){
                            l.TimeStamp_New_status__c = DateTime.now();
                        } else if (status == 'Outreach'){
                            l.TimeStamp_Outreach_status__c = DateTime.now();
                        }
                        else if (status == 'Considering'){
                            l.TimeStamp_Considering_status__c = DateTime.now();
                        } 
                        else if (status == 'Analyzing Needs'){
                            l.TimeStamp_Analyzing_Need_status__c = DateTime.now();
                        }
                        else if (status == 'Fulfillment'){
                            l.TimeStamp_Fulfilment_status__c = DateTime.now();
                        }
                        
                        /*----------Update Yellow and Breach TimeStamp Fields--------*/
                        if (l.SLA_Business_Hours__c != NULL && stdBusinessHours != NULL && l.StageName == 'New' && l.TimeStamp_New_status__c != null){
                            l.SLA_Yellow_Start_Time__c = BusinessHours.addgmt(stdBusinessHours.id, l.TimeStamp_New_status__c, (Long) ((l.SLA_Business_Hours__c - 1) * 3600000));
                            l.SLA_Breach_Time__c = BusinessHours.addgmt(stdBusinessHours.id, l.TimeStamp_New_status__c, (Long) ((l.SLA_Business_Hours__c) * 3600000));
                        }
                        
                        else if (l.SLA_Business_Hours__c != NULL && stdBusinessHours != NULL && l.StageName == 'Outreach' && l.TimeStamp_Outreach_status__c != null){
                            l.SLA_Yellow_Start_Time__c = BusinessHours.addgmt(stdBusinessHours.id, l.TimeStamp_Outreach_status__c, (Long) ((l.SLA_Business_Hours__c - 1) * 3600000));
                            l.SLA_Breach_Time__c = BusinessHours.addgmt(stdBusinessHours.id, l.TimeStamp_Outreach_status__c, (Long) ((l.SLA_Business_Hours__c) * 3600000));
                        }
                       
                        else{
                            l.SLA_Yellow_Start_Time__c = null;
                            l.SLA_Breach_Time__c = null;
                        }
                        
                    }
                }
            }
            
            if (trigger.isUpdate){
                
                for (Opportunity ol : oldOpportunityList){
                    mapOldOpportunity.put(ol.Id, ol);
                }
                if (newOppList.size() > 0){
                    for (Opportunity l : newOppList){
                        /*--------Update SLA Field------*/
                        string status = l.StageName;
                        Opportunity oldOpportunity = mapOldOpportunity.get(l.Id);
                        string oldStatus = oldOpportunity.StageName;
                        string oldProductType = oldOpportunity.Product_Type__c;
                        string newProductType = l.Product_Type__c;
                        string oldoppSource = oldOpportunity.Opportunity_Source__c;
                        string newoppSource = l.Opportunity_Source__c;
    
                         l.SLA_Business_Hours__c = getSLA(l);
                        /*--------Update TimeStamp Fields------*/
                        if (Status == 'New' && oldStatus != 'New'){
                            l.TimeStamp_New_status__c = DateTime.now();
                        } else if (Status == 'Outreach' && oldStatus != 'Outreach'){
                            l.TimeStamp_Outreach_status__c = DateTime.now();
                        }
                        else if (Status == 'Considering' && oldStatus != 'Considering'){
                            l.TimeStamp_Considering_status__c = DateTime.now();
                        } 
                        else if (Status == 'Analyzing Needs' && oldStatus != 'Analyzing Needs'){
                            l.TimeStamp_Analyzing_Need_status__c = DateTime.now();
                        }
                        else if (Status == 'Fulfillment' && oldStatus != 'Fulfillment'){
                            l.TimeStamp_Fulfilment_status__c = DateTime.now();
                        }
                        
                        /*----------Update Yellow and Breach TimeStamp Fields--------*/
                        if (l.SLA_Business_Hours__c != NULL && stdBusinessHours != NULL && l.StageName == 'New' && l.TimeStamp_New_status__c != null && oldStatus != 'New'){
                            l.SLA_Yellow_Start_Time__c = BusinessHours.addgmt(stdBusinessHours.id, l.TimeStamp_New_status__c, (Long) ((l.SLA_Business_Hours__c - 1) * 3600000));
                            l.SLA_Breach_Time__c = BusinessHours.addgmt(stdBusinessHours.id, l.TimeStamp_New_status__c, (Long) ((l.SLA_Business_Hours__c) * 3600000));
                            if(l.Hour_Spent_New_Status__c != 0 && l.Hour_Spent_New_Status__c != null){
                                l.SLA_Yellow_Start_Time__c = BusinessHours.addgmt(stdBusinessHours.id, l.SLA_Yellow_Start_Time__c, -(Long)(l.Hour_Spent_New_Status__c*3600000));
                                l.SLA_Breach_Time__c = BusinessHours.addgmt(stdBusinessHours.id, l.SLA_Breach_Time__c, -(Long)(l.Hour_Spent_New_Status__c*3600000));
                            }
                        }                      
                        
                        
                        else if (l.SLA_Business_Hours__c != NULL && stdBusinessHours != NULL && l.StageName == 'Outreach' && l.TimeStamp_Outreach_status__c != null && oldStatus != 'Outreach'){
                            l.SLA_Yellow_Start_Time__c = BusinessHours.addgmt(stdBusinessHours.id, l.TimeStamp_Outreach_status__c, (Long) ((l.SLA_Business_Hours__c - 1) * 3600000));
                            l.SLA_Breach_Time__c = BusinessHours.addgmt(stdBusinessHours.id, l.TimeStamp_Outreach_status__c, (Long) ((l.SLA_Business_Hours__c) * 3600000));
                            
                             if(l.Hour_Spent_Outreach_Status__c != 0 && l.Hour_Spent_Outreach_Status__c != null){
                                l.SLA_Yellow_Start_Time__c = BusinessHours.addgmt(stdBusinessHours.id, l.SLA_Yellow_Start_Time__c, -(Long)(l.Hour_Spent_Outreach_Status__c*3600000));
                                l.SLA_Breach_Time__c = BusinessHours.addgmt(stdBusinessHours.id, l.SLA_Breach_Time__c, -(Long)(l.Hour_Spent_Outreach_Status__c*3600000));
                            }
                        }
                        else if(newProductType == 'Mortgage' && oldProductType != 'Mortgage' && l.SLA_Business_Hours__c != NULL && stdBusinessHours != NULL && l.StageName == 'New' && l.TimeStamp_New_status__c != null){
                            l.SLA_Yellow_Start_Time__c = BusinessHours.addgmt(stdBusinessHours.id, l.TimeStamp_New_status__c, (Long) ((l.SLA_Business_Hours__c - 1) * 3600000));                            
                            l.SLA_Breach_Time__c = BusinessHours.addgmt(stdBusinessHours.id, l.TimeStamp_New_status__c, (Long) ((l.SLA_Business_Hours__c) * 3600000));
                            if(l.Hour_Spent_New_Status__c != 0 && l.Hour_Spent_New_Status__c != null){
                                l.SLA_Yellow_Start_Time__c = BusinessHours.addgmt(stdBusinessHours.id, l.SLA_Yellow_Start_Time__c, -(Long)(l.Hour_Spent_New_Status__c*3600000));
                                l.SLA_Breach_Time__c = BusinessHours.addgmt(stdBusinessHours.id, l.SLA_Breach_Time__c, -(Long)(l.Hour_Spent_New_Status__c*3600000));
                            }
                        }
                        
                        else if(NewOppSources.contains(newoppSource) && !NewOppSources.contains(oldoppSource) && newProductType == 'Mortgage' && l.SLA_Business_Hours__c != NULL && stdBusinessHours != NULL && l.StageName == 'New' && l.TimeStamp_New_status__c != null){
                            l.SLA_Yellow_Start_Time__c = BusinessHours.addgmt(stdBusinessHours.id, l.TimeStamp_New_status__c, (Long) ((l.SLA_Business_Hours__c - 1) * 3600000));                            
                            l.SLA_Breach_Time__c = BusinessHours.addgmt(stdBusinessHours.id, l.TimeStamp_New_status__c, (Long) ((l.SLA_Business_Hours__c) * 3600000));
                            if(l.Hour_Spent_New_Status__c != 0 && l.Hour_Spent_New_Status__c != null){
                                l.SLA_Yellow_Start_Time__c = BusinessHours.addgmt(stdBusinessHours.id, l.SLA_Yellow_Start_Time__c, -(Long)(l.Hour_Spent_New_Status__c*3600000));
                                l.SLA_Breach_Time__c = BusinessHours.addgmt(stdBusinessHours.id, l.SLA_Breach_Time__c, -(Long)(l.Hour_Spent_New_Status__c*3600000));
                            }
                        }
                        
                        /*----------Update Hours Spent Fields--------*/
                        DateTime currentTime = Datetime.now();
                        if (status != 'New' && oldStatus == 'New' && l.TimeStamp_New_status__c != null){
                            decimal TimeDiff = BusinessHours.diff(stdBusinessHours.id, l.TimeStamp_New_status__c, currentTime);
                            decimal hh = (TimeDiff / 3600000).setScale(2);
                            l.Hour_Spent_New_Status__c = l.Hour_Spent_New_Status__c != null ? l.Hour_Spent_New_Status__c + hh : hh;
                            if(oldOpportunity.isSLABreached__c == true){
                                l.SLABreached__c = true;
                            }
                        } 
                        else if (Status != 'Outreach' && oldStatus == 'Outreach' && l.TimeStamp_Outreach_status__c != null){
                            decimal TimeDiff = BusinessHours.diff(stdBusinessHours.id, l.TimeStamp_Outreach_status__c, currentTime);
                            decimal hh = (TimeDiff / 3600000).setScale(2);
                            l.Hour_Spent_Outreach_Status__c = l.Hour_Spent_Outreach_Status__c != null ? l.Hour_Spent_Outreach_Status__c + hh : hh;
                            if(oldOpportunity.isSLABreached__c == true){
                                l.SLABreached__c = true;
                            }
                        } 
                        else if (status != 'Considering' && oldStatus == 'Considering' && l.TimeStamp_Considering_status__c != null){
                            decimal TimeDiff = BusinessHours.diff(stdBusinessHours.id, l.TimeStamp_Considering_status__c, currentTime);
                            decimal hh = (TimeDiff / 3600000).setScale(2);
                            l.Hour_Spent_Considering_Status__c = l.Hour_Spent_Considering_Status__c != null ? l.Hour_Spent_Considering_Status__c + hh : hh;
                        } 
                        else if (status != 'Analyzing Needs' && oldStatus == 'Analyzing Needs' && l.TimeStamp_Analyzing_Need_status__c != null){
                            decimal TimeDiff = BusinessHours.diff(stdBusinessHours.id, l.TimeStamp_Analyzing_Need_status__c, currentTime);
                            decimal hh = (TimeDiff / 3600000).setScale(2);
                            l.Hour_Spent_Analyzing_Need_Status__c = l.Hour_Spent_Analyzing_Need_Status__c != null ? l.Hour_Spent_Analyzing_Need_Status__c + hh : hh;
                        } 
                        else if (status != 'Fulfillment' && oldStatus == 'Fulfillment' && l.TimeStamp_Fulfilment_status__c != null){
                            decimal TimeDiff = BusinessHours.diff(stdBusinessHours.id, l.TimeStamp_Fulfilment_status__c, currentTime);
                            decimal hh = (TimeDiff / 3600000).setScale(2);
                            l.Hour_Spent_Fulfilment_Status__c = l.Hour_Spent_Fulfilment_Status__c != null ? l.Hour_Spent_Fulfilment_Status__c + hh : hh;
                        }
                         
                        
                    }
                }
            }
        }
        
    }
    /*----PRJ0011432-11432: MARS Functionality Review Changes End-----*/
    
    
    
}