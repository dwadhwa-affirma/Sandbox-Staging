trigger LeadBusinessHours on Lead (after insert,after update, before insert, before update) {   
    
    Id profileId=userinfo.getProfileId();
    String ProfileName=[Select Id,Name from Profile where Id=:profileId].Name;
    Map<ID,Schema.RecordTypeInfo> rt_Map = Lead.sObjectType.getDescribe().getRecordTypeInfosById();
    Id taskRT = Schema.SObjectType.Task.getRecordTypeInfosByName().get('SEG').getRecordTypeId();
    Id LeadRT = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Company Lead').getRecordTypeId();
    //Group BizDev = [Select Id,name from Group where Type = 'Queue' and Name = 'BIZ DEV' LIMIT 1];
    system.debug('ProfileName'+ProfileName);
    List<Task> lTask = new List<Task>();
    List<Lead> leadList = new List<Lead>();
                 
    if(Trigger.isAfter){
        
        List<OpenHours__c> openHours = new List<OpenHours__c>();
        for(Lead lead: Trigger.new){
                    
            if (Trigger.isInsert && Trigger.isAfter){
                OpenHours__c obj = new OpenHours__c();
                obj.LeadId__c = lead.Id;
                obj.Open_Hours__c = 0;
                openHours.add(obj);
            }
        }
        
        insert openHours;
        
        //------------------------------------------Task Creation on "Company Lead"--------------------------------//
        
        if(Trigger.isInsert){
            
            for(Lead lead: Trigger.new){
            
                if(rt_map.get(lead.recordTypeID).getName().containsIgnoreCase('Company Lead')){
                    
                    Task t = new Task(); 
                    t.ActivityDate = Date.valueOf(lead.CreatedDate) + 200;
                    t.Activity_Date_Time__c = lead.CreatedDate + 200;
                    t.OwnerId = lead.OwnerId;
                    t.Priority = 'Normal';
                    t.RecordTypeId = taskRT;
                    t.Status = 'Open';
                    t.Subject = 'Email'  + ' ' + lead.FirstName + ' '  + lead.LastName;
                    t.WhoId = lead.id;
                    lTask.add(t);

                    Task t1 = new Task(); 
                    t1.ActivityDate = Date.valueOf(lead.CreatedDate) + 200;
                    t1.Activity_Date_Time__c = lead.CreatedDate + 200;
                    t1.OwnerId = lead.OwnerId;
                    t1.Priority = 'Normal';
                    t1.RecordTypeId = taskRT;
                    t1.Status = 'Open';
                    t1.Subject = 'LinkedIn'  + ' ' + lead.FirstName + ' '  + lead.LastName;
                    t1.WhoId = lead.id;
                    lTask.add(t1);   
                    
                    Task t2 = new Task(); 
                    t2.ActivityDate = Date.valueOf(lead.CreatedDate) + 200;
                    t2.Activity_Date_Time__c = lead.CreatedDate + 200;
                    t2.OwnerId = lead.OwnerId;
                    t2.Priority = 'Normal';
                    t2.RecordTypeId = taskRT;
                    t2.Status = 'Open';
                    t2.Subject = 'Email'  + ' ' + lead.FirstName + ' '  + lead.LastName;
                    t2.WhoId = lead.id;
                    lTask.add(t2);
                    
                    Task t3 = new Task(); 
                    t3.ActivityDate = Date.valueOf(lead.CreatedDate) + 200;
                    t3.Activity_Date_Time__c = lead.CreatedDate + 200;
                    t3.OwnerId = lead.OwnerId;
                    t3.Priority = 'Normal';
                    t3.RecordTypeId = taskRT;
                    t3.Status = 'Open';
                    t3.Subject = 'Email'  + ' ' + lead.FirstName + ' '  + lead.LastName;
                    t3.WhoId = lead.id;
                    lTask.add(t3);
                    
                    Task t4 = new Task(); 
                    t4.ActivityDate = Date.valueOf(lead.CreatedDate) + 200;
                    t4.Activity_Date_Time__c = lead.CreatedDate + 200;
                    t4.OwnerId = lead.OwnerId;
                    t4.Priority = 'Normal';
                    t4.RecordTypeId = taskRT;
                    t4.Status = 'Open';
                    t4.Subject = 'Call / Voice Message'  + ' ' + lead.FirstName + ' '  + lead.LastName;
                    t4.WhoId = lead.id;
                    lTask.add(t4);
                    
                    Task t5 = new Task(); 
                    t5.ActivityDate = Date.valueOf(lead.CreatedDate) + 200;
                    t5.Activity_Date_Time__c = lead.CreatedDate + 200;
                    t5.OwnerId = lead.OwnerId;
                    t5.Priority = 'Normal';
                    t5.RecordTypeId = taskRT;
                    t5.Status = 'Open';
                    t5.Subject = 'Call / Voice Message'  + ' ' + lead.FirstName + ' '  + lead.LastName;
                    t5.WhoId = lead.id;
                    lTask.add(t5);
                    
                    Task t6 = new Task(); 
                    t6.ActivityDate = Date.valueOf(lead.CreatedDate) + 200;
                    t6.Activity_Date_Time__c = lead.CreatedDate + 200;
                    t6.OwnerId = lead.OwnerId;
                    t6.Priority = 'Normal';
                    t6.RecordTypeId = taskRT;
                    t6.Status = 'Open';
                    t6.Subject = 'Call'  + ' ' + lead.FirstName + ' '  + lead.LastName;
                    t6.WhoId = lead.id;
                    lTask.add(t6);
                    
                    Task t7 = new Task(); 
                    t7.ActivityDate = Date.valueOf(lead.CreatedDate) + 200;
                    t7.Activity_Date_Time__c = lead.CreatedDate + 200;
                    t7.OwnerId = lead.OwnerId;
                    t7.Priority = 'Normal';
                    t7.RecordTypeId = taskRT;
                    t7.Status = 'Open';
                    t7.Subject = 'Call / Voice Message'  + ' ' + lead.FirstName + ' '  + lead.LastName;
                    t7.WhoId = lead.id;
                    lTask.add(t7);
                }    
            }
            if(!lTask.IsEmpty())
                insert lTask;
        }
        
        //------------------------------------------Task Update on "Outreach"--------------------------------//
        
        List<Id> companyLeadIds = new List<Id>();
        List<Lead> companyLeads = new List<Lead>();
        
        if(Trigger.isUpdate){
            
            for(Lead lead: Trigger.new){
                Lead oldLead = Trigger.oldMap.get(lead.Id);
                if(rt_map.get(lead.recordTypeID).getName().containsIgnoreCase('Company Lead') && 
                   	oldLead.Status != lead.Status && lead.Status == 'Outreach'){
                    companyLeadIds.add(lead.id);
                    companyLeads.add(lead);
                }
            }
            System.debug('companyLeadIds'+companyLeadIds);
            System.debug('companyLeads'+companyLeads);
            
            List<task> tasklist = [select whoId,status from task where ActivityDate != null and whoId in :companyLeadIds];
            
            if(tasklist.size() > 0){
                delete tasklist;
            }
            
            if(companyLeads.size() > 0){
            
                for(Lead lead: companyLeads){
                
                    Task t = new Task(); 
                    t.ActivityDate = Date.valueOf(system.now()) + 1;
                    t.Activity_Date_Time__c = system.now() + 1;
                    t.OwnerId = lead.OwnerId;
                    t.Priority = 'Normal';
                    t.RecordTypeId = taskRT;
                    t.Status = 'Open';
                    t.Subject = 'Email'  + ' ' + lead.FirstName + ' '  + lead.LastName;
                    t.WhoId = lead.id;
                    lTask.add(t);
                    
                    Task t1 = new Task(); 
                    t1.ActivityDate = Date.valueOf(system.now()) + 7;
                    t1.Activity_Date_Time__c = system.now() + 7;
                    t1.OwnerId = lead.OwnerId;
                    t1.Priority = 'Normal';
                    t1.RecordTypeId = taskRT;
                    t1.Status = 'Open';
                    t1.Subject = 'LinkedIn'  + ' ' + lead.FirstName + ' '  + lead.LastName;
                    t1.WhoId = lead.id;
                    lTask.add(t1);   
                    
                    Task t2 = new Task(); 
                    t2.ActivityDate = Date.valueOf(system.now()) + 14;
                    t2.Activity_Date_Time__c = system.now() + 14;
                    t2.OwnerId = lead.OwnerId;
                    t2.Priority = 'Normal';
                    t2.RecordTypeId = taskRT;
                    t2.Status = 'Open';
                    t2.Subject = 'Email'  + ' ' + lead.FirstName + ' '  + lead.LastName;
                    t2.WhoId = lead.id;
                    lTask.add(t2);
                    
                    Task t3 = new Task(); 
                    t3.ActivityDate = Date.valueOf(system.now()) + 30;
                    t3.Activity_Date_Time__c = system.now() + 30;
                    t3.OwnerId = lead.OwnerId;
                    t3.Priority = 'Normal';
                    t3.RecordTypeId = taskRT;
                    t3.Status = 'Open';
                    t3.Subject = 'Email'  + ' ' + lead.FirstName + ' '  + lead.LastName;
                    t3.WhoId = lead.id;
                    lTask.add(t3);
                    
                    Task t4 = new Task(); 
                    t4.ActivityDate = Date.valueOf(system.now()) + 45;
                    t4.Activity_Date_Time__c = system.now() + 45;
                    t4.OwnerId = lead.OwnerId;
                    t4.Priority = 'Normal';
                    t4.RecordTypeId = taskRT;
                    t4.Status = 'Open';
                    t4.Subject = 'Call / Voice Message'  + ' ' + lead.FirstName + ' '  + lead.LastName;
                    t4.WhoId = lead.id;
                    lTask.add(t4);
                    
                    Task t5 = new Task(); 
                    t5.ActivityDate = Date.valueOf(system.now()) + 100;
                    t5.Activity_Date_Time__c = system.now() + 100;
                    t5.OwnerId = lead.OwnerId;
                    t5.Priority = 'Normal';
                    t5.RecordTypeId = taskRT;
                    t5.Status = 'Open';
                    t5.Subject = 'Call / Voice Message'  + ' ' + lead.FirstName + ' '  + lead.LastName;
                    t5.WhoId = lead.id;
                    lTask.add(t5);
                    
                    Task t6 = new Task(); 
                    t6.ActivityDate = Date.valueOf(system.now()) + 120;
                    t6.Activity_Date_Time__c = system.now() + 120;
                    t6.OwnerId = lead.OwnerId;
                    t6.Priority = 'Normal';
                    t6.RecordTypeId = taskRT;
                    t6.Status = 'Open';
                    t6.Subject = 'Call'  + ' ' + lead.FirstName + ' '  + lead.LastName;
                    t6.WhoId = lead.id;
                    lTask.add(t6);
                    
                    Task t7 = new Task(); 
                    t7.ActivityDate = Date.valueOf(system.now()) + 14;
                    t7.Activity_Date_Time__c = system.now() + 14;
                    t7.OwnerId = lead.OwnerId;
                    t7.Priority = 'Normal';
                    t7.RecordTypeId = taskRT;
                    t7.Status = 'Open';
                    t7.Subject = 'Call / Voice Message'  + ' ' + lead.FirstName + ' '  + lead.LastName;
                    t7.WhoId = lead.id;
                    lTask.add(t7);
                }
            }
            if(!lTask.IsEmpty())
                insert lTask;
        }
        
    }
    
    
    if(Trigger.isInsert && Trigger.isBefore){
                    
        string uid= UserInfo.getUserId();
        User usr = [Select id, name, alias from User where id=:uid];
        List<Episys_User__c> eusr =  new List<Episys_User__c>(); 
        List<Episys_User__c> eusr1 = new List<Episys_User__c>();
        List<Lead> assignqueue = new List<Lead>();
        Set<Id> LeadIdSet = new Set<Id>();                                  
        Set<Decimal> Episys_User_ID = new Set<Decimal>(); 
        Map<Decimal,String> epsMap = new Map<Decimal,String>();
        Map<String,String> BranchMap = new Map<String,String>();
        List<Group> LeadBranchQueue = new List<Group>();
        List<Episys_User__c> euser2 = new List<Episys_User__c>();
        // List<Lead_Queue__c> LeadQueueNameList = new  List<Lead_Queue__c>();  
        List<Group> LeadQueueNameList = new List<Group>();
        Set<String> LeadQueueNameSet = new  Set<String>();
        Set<String> branchnameSet = new Set<String>();
        eusr = [SELECT id, alias__c, Assigned_Branch__c,Episys_ID__c,Episys_Name__c, Branch_Name__c,Default__c from Episys_User__c 
                where alias__c=:usr.alias AND Default__c =: true order by Default__c desc limit 1]; 
        
        euser2 = [SELECT id, alias__c, Assigned_Branch__c,Episys_ID__c,Episys_Name__c, Branch_Name__c,Default__c from Episys_User__c 
                  where alias__c=:usr.alias order by Default__c desc limit 1];
        
        List<Episys_User__c>   listeusr = [SELECT id, alias__c,Episys_Name__c, Assigned_Branch__c,Episys_ID__c, Branch_Name__c,Default__c from Episys_User__c];      
        
        if(eusr.size() >0 ){
            Episys_User_ID.Add(eusr[0].Episys_ID__c);
        }                   
                                
        // code for assigning queue starts from here  
        for(Lead lead: Trigger.new){
            
            if(lead.Episys_User_ID__c != null ){
                
                Episys_User_ID.Add(lead.Episys_User_ID__c); 
                for(Episys_User__c item : listeusr){
                
                    if(item.Episys_ID__c == lead.Episys_User_ID__c){
                    
                        lead.Branch_of_Lead_creator__c =   item.Branch_Name__c; 
                        lead.Episys_Name__c = item.Episys_Name__c;
                        break;
                    }
                }
            }       
            else{
                if(eusr.size() > 0){
                    lead.Episys_User_ID__c = eusr[0].Episys_ID__c;
                    lead.Branch_of_Lead_creator__c =   eusr[0].Branch_Name__c; 
                    lead.Episys_Name__c = eusr[0].Episys_Name__c;
                    Episys_User_ID.Add(lead.Episys_User_ID__c); 
                }
                else{
                    if(euser2.size() > 0){
                        lead.Episys_User_ID__c = euser2[0].Episys_ID__c;
                        lead.Branch_of_Lead_creator__c =   euser2[0].Branch_Name__c; 
                        lead.Episys_Name__c = euser2[0].Episys_Name__c;
                        Episys_User_ID.Add(lead.Episys_User_ID__c);
                    }
                }
            }
        }
        
        List<Episys_User__c> episysUsers = [SELECT id, alias__c, Assigned_Branch__c,Episys_ID__c, Branch_Name__c,Default__c from Episys_User__c 
                                            where Episys_ID__c in: Episys_User_ID];
        Group OppQueue = new Group();   
        String groupName ;  
        Id groupnameid;         
        List<Group> listQueue = [select id,Name,Email from Group where Type = 'Queue' and (Email like '%lead.com' or Email like '%opportunity.com')];
        
        
        system.debug('Episys_User_ID##'+ Episys_User_ID);
        system.debug('episysUsers##' + episysUsers);
            
        for(Lead lead: Trigger.new){
        
            system.debug('Episys_User_ID##'+ lead.Episys_User_ID__c); 
            
            if(lead.Status == 'New' && lead.Episys_User_ID__c != 7002 &&
               !rt_map.get(lead.recordTypeID).getName().containsIgnoreCase('Company Lead') && 
               (lead.LeadSource == 'Branch Walk in' || lead.LeadSource == 'Branch Call')){
                System.debug('1111');
                if(episysUsers.size() > 0){
                
                    for(Episys_User__c episysItem: episysUsers){
                    
                        system.debug('episysItem.Episys_ID__c###' + episysItem.Episys_ID__c);
                        system.debug('---Lead------episysItem.Episys_ID__c###' + lead.Episys_User_ID__c);
                        if(lead.Episys_User_ID__c == episysItem.Episys_ID__c){
                        
                            system.debug('Episys user matched###');
                            string BranchQueue = episysItem.Branch_Name__c.replace(' ', '_').replace('-','_').replace('/','_').toLowerCase();
                            system.debug('EBranchQueue###' + BranchQueue);
                            for(Group grp : listQueue){
                                
                                if(grp.Email.containsIgnoreCase(BranchQueue)){
                                
                                    groupName = grp.Name;
                                    groupnameid = grp.id;
                                    break;
                                }
                                system.debug('groupName###' + groupName);
                            }
                            if(groupName!=null && groupName!=''){
                            
                                lead.OwnerId = groupnameid; 
                            }
                            else{
                            
                                system.debug('Condition Product Type###');
                                string ProductType = lead.Product_Type__c.replace(' ', '_').replace('-','_').replace('/','_').toLowerCase();
                                system.debug('ProductType###' + ProductType);
                                for(Group grp : listQueue){
                                
                                    if(grp.Email.containsIgnoreCase(ProductType)){
                                    
                                        groupName = grp.Name;
                                        groupnameid = grp.id;
                                        break;
                                    }
                                }
                                system.debug('groupName###' + groupName);
                                if(groupName!=null && groupName!=''){
                                
                                    lead.OwnerId = groupnameid; 
                                }
                            }
                        }
                    }
                }
                else{
                    system.debug('Condition Product Type###');
                    string ProductType = lead.Product_Type__c.replace(' ', '_').replace('-','_').replace('/','_').toLowerCase();
                    system.debug('ProductType###' + ProductType);
                    for(Group grp : listQueue){
                        
                        if(grp.Email.containsIgnoreCase(ProductType)){
                            groupName = grp.Name;
                            groupnameid = grp.id;
                            break;
                        }
                    }
                    system.debug('groupName###' + groupName);
                    if(groupName!=null && groupName!='')
                    {
                        lead.OwnerId = groupnameid; 
                    }
                }
            }
            else if(lead.Status == 'New' && lead.Episys_User_ID__c != 7002 &&
                    !rt_map.get(lead.recordTypeID).getName().containsIgnoreCase('Company Lead') && 
                    lead.LeadSource == 'Event' ){
            		System.debug('2222');
                    string BranchQueue ='';
                    if(eusr.size() > 0 ){
                        BranchQueue = eusr[0].Branch_Name__c.replace(' ', '_').replace('-','_').replace('/','_').toLowerCase();
                    }
                    else if(euser2.size() > 0){
                        BranchQueue = euser2[0].Branch_Name__c.replace(' ', '_').replace('-','_').replace('/','_').toLowerCase();
                    }
                    
                    system.debug('EBranchQueue###' + BranchQueue);
                    if(BranchQueue != null && BranchQueue !=''){
                        for(Group grp : listQueue){
                        
                            if(grp.Email.containsIgnoreCase(BranchQueue)){
                            
                                groupName = grp.Name;
                                groupnameid = grp.id;
                                break;
                            }
                            system.debug('groupName###' + groupName);
                        }
                    }
                    if(groupnameid != null){
                        lead.OwnerId = groupnameid;
                    }
                    else{
                        system.debug('Condition Product Type###');
                        string ProductType = lead.Product_Type__c.replace(' ', '_').replace('-','_').replace('/','_').toLowerCase();
                        system.debug('ProductType###' + ProductType);
                        for(Group grp : listQueue){
                        
                            if(grp.Email.containsIgnoreCase(ProductType)){
                            
                                groupName = grp.Name;
                                groupnameid = grp.id;
                                break;
                            }
                        }
                        system.debug('groupName###' + groupName);
                        if(groupName!=null && groupName!=''){
                        
                            lead.OwnerId = groupnameid; 
                        }
                    }
                }
                else if(lead.Status == 'New' && lead.Episys_User_ID__c != 7002 &&
                         !rt_map.get(lead.recordTypeID).getName().containsIgnoreCase('Company Lead') && 
                        (lead.LeadSource != 'Branch Walk in' && lead.LeadSource != 'Branch Call')){
               		System.debug('3333');
                    system.debug('Condition Product Type###');
                    string ProductType = lead.Product_Type__c.replace(' ', '_').replace('-','_').replace('/','_').toLowerCase();
                    system.debug('ProductType###' + ProductType);
                    for(Group grp : listQueue){
                        
                        if(grp.Email.containsIgnoreCase(ProductType)){
                            groupName = grp.Name;
                            groupnameid = grp.id;
                            break;
                        }
                    }
                    system.debug('groupName###' + groupName);
                    if(groupName!=null && groupName!=''){
                    
                        lead.OwnerId = groupnameid;
                    }       
                    
                }
                else if(!rt_map.get(lead.recordTypeID).getName().containsIgnoreCase('Company Lead') && 
                         lead.Episys_User_ID__c != 7002 && 
                        (lead.Status =='Outreach' || lead.Status == 'Analyzing Needs' || lead.Status == 'Prospect Considering')){
                	System.debug('4444');
                    lead.OwnerId = uid;
                }        
        }   
    }
        
    if(Trigger.isupdate && Trigger.isBefore){
        
        //Map<id,Lead> MapLead = new Map<id,Lead>([select id,Owner.Id,Owner.Type from Lead where Owner.Type = 'Queue' and id =: trigger.New.id]);
        set<id> setlead = new Set<id>();
        for(Lead ld1 : [select id,Name from lead where Owner.Type = 'Queue' and id IN : trigger.New]){
            
            SetLead.add(ld1.id);
        }
        system.debug('--------------'+setlead);
        for(Lead ld: trigger.New){
            Lead oldlead = trigger.oldMap.get(ld.Id);
            if(SetLead.contains(ld.id) && ld.Status == 'Closed - Not Converted'){
                ld.Adderror('Queue owned leads cannot be closed.');
            }
            if(oldlead.Status == 'Closed - Converted' || (oldlead.Status == 'Closed - Not Converted' && ld.Status == 'Closed - Not Converted'))
            {
                
                ld.Adderror('Lead fields are read only for Closed Leads.');
            }
        }
        
        for(Lead lead: Trigger.New){
            if(lead.Episys_User_ID__c != null){
                List<Episys_User__c> euser = [SELECT id,alias__c, Assigned_Branch__c,Episys_Name__c,Episys_ID__c, Branch_Name__c,Default__c from Episys_User__c where Episys_ID__c =:lead.Episys_User_ID__c];
                if(euser.size() > 0){
                    lead.Branch_of_Lead_creator__c =   euser[0].Branch_Name__c; 
                    lead.Episys_Name__c =euser[0].Episys_Name__c;
                }
            }
            else{
                lead.Branch_of_Lead_creator__c='';
                lead.Episys_Name__c='';
            }
           
            //--------------------------------Company Lead--------------------------------------------------//
            
            if(lead.Company != '' && lead.Company != null){
                system.debug('Company Lead');
                lead.RecordTypeId = LeadRT;
            }
        }
    }
}

/*if(Trigger.isInsert && Trigger.isBefore)
{
     string uid= UserInfo.getUserId();
    User usr = [Select id, name, alias from User where id=:uid];
    List<Episys_User__c> eusr =  new List<Episys_User__c>(); 
     List<Episys_User__c> eusr1 = new List<Episys_User__c>();
     List<Lead> assignqueue = new List<Lead>();
     Set<Id> LeadIdSet = new Set<Id>();                                 
     Set<Decimal> Episys_User_ID = new Set<Decimal>(); 
     Map<Decimal,String> epsMap = new Map<Decimal,String>();
      Map<String,String> BranchMap = new Map<String,String>();
     List<Group> LeadBranchQueue = new List<Group>();
     List<Lead_Queue__c> LeadQueueNameList = new  List<Lead_Queue__c>();    
     Set<String> LeadQueueNameSet = new  Set<String>();
     Set<String> branchnameSet = new Set<String>();
    
    // code for assigning queue starts from here  
     for(Lead lead: Trigger.new)
     {
         if (Trigger.isInsert && Trigger.isBefore)
         {
            if((lead.LeadSource == 'Branch Walk in' || lead.LeadSource == 'Branch Call') && lead.Episys_User_ID__c !=null )
                {
                        Episys_User_ID.Add(lead.Episys_User_ID__c);
                        LeadIdSet.Add(lead.Id);
                        
                }
             else if((lead.LeadSource == 'Branch Walk in' || lead.LeadSource == 'Branch Call') && lead.Episys_User_ID__c == null)
             {
                 eusr = [SELECT id, alias__c, Assigned_Branch__c,Episys_ID__c, Branch_Name__c,Default__c from Episys_User__c 
                                    where alias__c=:usr.alias order by Default__c desc];
                if(eusr.size() > 0)
                {
                     for(Episys_User__c item : eusr)  
                     {
                        Episys_User_ID.Add(item.Episys_ID__c);
                     }
                }
               
                                    
                
             }
                
                
         }
     }
    
     system.debug('Episys_User_ID##'+ Episys_User_ID);
     if (Trigger.isInsert)
         {
            if(Episys_User_ID.size() > 0)
            {
                eusr1 = [select id,Episys_ID__c,Assigned_Branch__c,Branch_Name__c,Episys_Name__c,DefaultValue__c from Episys_User__c  where Episys_ID__c IN :Episys_User_ID];
            }
            system.debug('eusr1#' + eusr1);
            if(eusr1.size() > 0)
            {
                //string branchname;
                
                for(Episys_User__c eu : eusr1)
                {
                    //branchname = 'Branch ' + eu.Branch_Name__c.split(' ')[0] + ' - ' +eu.Branch_Name__c.split(' ')[1] + '%'; 
                    branchnameSet.Add(eu.Branch_Name__c);
                    epsMap.put(eu.Episys_ID__c, eu.Branch_Name__c);
                
                }
                system.debug('branchnameSet##' + branchnameSet);
                 LeadQueueNameList =[Select Id, Episys_User_Branch_Name__c, Lead_Queue_Name__c from Lead_Queue__c where Episys_User_Branch_Name__c IN:branchnameSet];
                system.debug('LeadQueueNameList##' + LeadQueueNameList);
                if(LeadQueueNameList.size() > 0)
                {
                    for(Lead_Queue__c lqnl: LeadQueueNameList )
                    {
                        LeadQueueNameSet.Add(lqnl.Lead_Queue_Name__c);
                        BranchMap.put(lqnl.Episys_User_Branch_Name__c,lqnl.Lead_Queue_Name__c);
                    }
                }
                
                LeadBranchQueue  = [Select Id,Name from Group where Type= 'Queue' and  Name IN:LeadQueueNameSet]  ;
                 system.debug('LeadBranchQueue' + LeadBranchQueue);
            }
                    system.debug('LeadIdSet##' + LeadIdSet);
                    for(Lead lead: Trigger.new)
                         {
                                 system.debug('epsMap##'+ epsMap);
                                 string brancheps;
                                 if(lead.Episys_User_ID__c != null  && epsMap.containsKey(lead.Episys_User_ID__c))
                                 {
                                            
                                            brancheps = epsMap.get(lead.Episys_User_ID__c);
                                            
                                 }
                                else if(eusr.size() > 0 && epsMap.containsKey(eusr[0].Episys_ID__c))
                                 {
                                  
                                    brancheps = epsMap.get(eusr[0].Episys_ID__c);
                                 
                                 }
                                 
                                 system.debug('brancheps##'+ brancheps);
                                if(BranchMap.containsKey(brancheps))
                                  {
                                        string branchqueue = BranchMap.get(brancheps);
                                        for(Group lbq :LeadBranchQueue)
                                        {
                                          string groupname = lbq.Name;
                                          system.debug('groupname##'+ groupname);
                                          if(groupname.equals(branchqueue))
                                            {                                                   
                                                lead.OwnerId = lbq.Id;
                                                system.debug('finalexecution##'+ lbq.Id);
                                            }
                                            else
                                              {
                                                system.debug('currentuserid##'+ uid);
                                                lead.OwnerId = uid;
                                              }
                                        }
                                                
                                  }
                                 else
                                  {
                                    system.debug('uid##'+ uid);
                                    lead.OwnerId = uid;
                                  }
                                  
                             
                                
                                
                        
                         }
            
         }
}*/
 // ends here