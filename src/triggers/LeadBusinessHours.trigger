trigger LeadBusinessHours on Lead (after insert, before insert, before update, after update) {   
    
    
      
        if(Trigger.isAfter)
        {   
           List<OpenHours__c> openHours = new List<OpenHours__c>();
           
            for(Lead lead: Trigger.new)
            {
                     if (Trigger.isInsert && Trigger.isAfter) {
                        
                        
                        OpenHours__c obj = new OpenHours__c();
                        obj.LeadId__c = lead.Id;
                        obj.Open_Hours__c = 0;
                        openHours.add(obj);
                          
                }               
                
            }
            insert openHours;
            
        }
        if(Trigger.isInsert && Trigger.isBefore)
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
             for(Lead lead: Trigger.new)
             { 
                
                    if(lead.Episys_User_ID__c != null )
                        {
                            
                                Episys_User_ID.Add(lead.Episys_User_ID__c); 
                                
                                for(Episys_User__c item : listeusr)
                                {
                                    if(item.Episys_ID__c == lead.Episys_User_ID__c)
                                    {
                                        lead.Branch_of_Lead_creator__c =   item.Branch_Name__c; 
                                        lead.Episys_Name__c = item.Episys_Name__c;
                                        break;
                                    }
                                }
                                                            
                        }       
                        else
                        {
                            if(eusr.size() > 0)
                            {
                                lead.Episys_User_ID__c = eusr[0].Episys_ID__c;
                                lead.Branch_of_Lead_creator__c =   eusr[0].Branch_Name__c; 
                                lead.Episys_Name__c = eusr[0].Episys_Name__c;
                                Episys_User_ID.Add(lead.Episys_User_ID__c); 
                            }
                            else
                            {
                                if(euser2.size() > 0)
                                {
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
    
            for(Lead lead: Trigger.new)
            {
                  
                    
                    if(lead.Status == 'New' && (lead.LeadSource == 'Branch Walk in' || lead.LeadSource == 'Branch Call') )
                    {
                        if(episysUsers.size() > 0)
                        {
                            for(Episys_User__c episysItem: episysUsers)
                            {
                                system.debug('episysItem.Episys_ID__c###' + episysItem.Episys_ID__c);
                                system.debug('---Lead------episysItem.Episys_ID__c###' + lead.Episys_User_ID__c);
                                if(lead.Episys_User_ID__c == episysItem.Episys_ID__c)
                                {
                                        system.debug('Episys user matched###');
                                        string BranchQueue = episysItem.Branch_Name__c.replace(' ', '_').replace('-','_').replace('/','_').toLowerCase();
                                        system.debug('EBranchQueue###' + BranchQueue);
                                        for(Group grp : listQueue)
                                        {
                                            
                                            if(grp.Email.containsIgnoreCase(BranchQueue))
                                            {
                                                groupName = grp.Name;
                                                groupnameid = grp.id;
                                                break;
                                            }
                                             system.debug('groupName###' + groupName);
                                        }
                                        if(groupName!=null && groupName!='')
                                        {
                                            
                                            lead.OwnerId = groupnameid; 
                                            
                                        }
                                        else
                                        {
                                             system.debug('Condition Product Type###');
                                            string ProductType = lead.Product_Type__c.replace(' ', '_').replace('-','_').replace('/','_').toLowerCase();
                                            system.debug('ProductType###' + ProductType);
                                            for(Group grp : listQueue)
                                            {
                                                
                                                if(grp.Email.containsIgnoreCase(ProductType))
                                                {
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
                            }
                        }
                        else
                        {
                                             system.debug('Condition Product Type###');
                                            string ProductType = lead.Product_Type__c.replace(' ', '_').replace('-','_').replace('/','_').toLowerCase();
                                            system.debug('ProductType###' + ProductType);
                                            for(Group grp : listQueue)
                                            {
                                                
                                                if(grp.Email.containsIgnoreCase(ProductType))
                                                {
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
                    else if(lead.Status == 'New' && (lead.LeadSource != 'Branch Walk in' && lead.LeadSource != 'Branch Call') )
                    {
                                system.debug('Condition Product Type###'+lead.Product_Type__c);
                                string ProductType = lead.Product_Type__c.replace(' ', '_').replace('-','_').replace('/','_').toLowerCase();
                                system.debug('ProductType###' + ProductType);
                                for(Group grp : listQueue)
                                {
                                    
                                    if(grp.Email.containsIgnoreCase(ProductType))
                                    {
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
                    else if(lead.Status =='Outreach' || lead.Status == 'Analyzing Needs' || lead.Status == 'Prospect Considering')
                    {
                        lead.OwnerId = uid;
                    }
                    
            }
            
}

        
        if(Trigger.isupdate && Trigger.isBefore)
        {
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
                 
            for(Lead lead: Trigger.New)
            {
                        
                  
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
                     //     update oldlead;
         
                 
                
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