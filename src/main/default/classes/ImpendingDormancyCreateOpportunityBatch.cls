global class ImpendingDormancyCreateOpportunityBatch implements Database.Batchable<sObject>, Database.Stateful{
     global set<Id> AccountId;
     
    global map<string, string> accountset;
    global List<Opportunity> OpportunityList;
    global List<Account_Details__c> MemberAccountmap;
   
       global ImpendingDormancyCreateOpportunityBatch(){
            accountset = new  map<string, string> ();
            OpportunityList = new List<opportunity>();
            MemberAccountmap = new List<Account_Details__c>();
        //  ListMemberAccount = new string();
       }
    
     global Database.QueryLocator start(Database.BatchableContext BC){
         Triggered_Opportunity_Configurations__c cs = Triggered_Opportunity_Configurations__c.getValues('Primary Record');
        Integer Inactivity_Days =0, Dormant_Days=0;
        Inactivity_Days = (Integer)cs.Impending_Dormancy_Inactivity_Days__c*(-1);       
        date LastNDays = system.today().addDays(Inactivity_Days);
        
        Dormant_Days = (Integer)cs.Impending_Dormancy_Dormant_Days__c*(-1);     
        date LastNDormantDays = system.today().addDays(Dormant_Days);
         
      
      return Database.getQueryLocator('select id,Parent_Account__c,Activity_Date__c,RecType__C,Correspondence_Date__c , Assigned_Branch1__c, Created_At_Branch1__c, Current_Branch1__c, Assigned_Branch__c, Created_At_Branch__c, Current_Branch__c from Account_Details__c where (((Activity_Date__c = null or Activity_Date__c <=' + string.valueof(LastNDays).replace(' 00:00:00','') + ') and (Correspondence_Date__c =null or Correspondence_Date__c <= ' + string.valueof(LastNDays).replace(' 00:00:00','')  + '))' +
                                        ' and ((Activity_Date__c = null or Activity_Date__c > '+ string.valueof(LastNDormantDays).replace(' 00:00:00','') +') or (Correspondence_Date__c =null or Correspondence_Date__c > ' + string.valueof(LastNDormantDays).replace(' 00:00:00','') + '))) and DormancyOppCreated__c = false');
   }
    
    global void execute(Database.BatchableContext BC, List<Account_Details__c> acclist){
        system.debug('Test');
        map<id,string> branchMap = new map<id,string>();
        Set<id> listParentAccounts = new Set<id>();
        Map<id,id> mapParentAccounts = new Map<id,id>();
        List<group> queues = [select id, name, DeveloperName from group where type='queue'];
        map<string, string> episysUserBranch = new map<string, string>();
        
        List<Episys_User__c> EpisysUser = [select Assigned_Branch__c, Branch_Name__c from Episys_User__c where Assigned_Branch__c <> null];
        for(Episys_User__c eu:EpisysUser){
            episysUserBranch.put(string.valueOf(eu.Assigned_Branch__c).replace('.0',''), eu.Branch_Name__c);
            
        }
        
        List<Group> listQueue = [select id,Name,Email from Group where Type = 'Queue'];
        
        

        for(Account_Details__c item : acclist)
        {
            string Assignedbranch ='';
            string CreatedAtBranch ='';
            string Currentbranch ='';
            string finalqueue='';           
            system.debug('item=='+ item.id);
            
            if(item.Assigned_Branch__c != null){
                Assignedbranch = episysUserBranch.get(string.valueOf(item.Assigned_Branch__c).replace('.0','')); 
                finalqueue = checkifPhysicalBranch(Assignedbranch, listQueue);                          
            }
            if(item.Created_At_Branch__c != null && finalqueue == ''){
                CreatedAtBranch = episysUserBranch.get(string.valueOf(item.Created_At_Branch__c).replace('.0',''));     
                finalqueue = checkifPhysicalBranch(CreatedAtBranch, listQueue);
            }
            if(item.Current_Branch__c != null && finalqueue == ''){
                Currentbranch = episysUserBranch.get(string.valueOf(item.Current_Branch__c).replace('.0','')); 
                finalqueue = checkifPhysicalBranch(Currentbranch, listQueue);
            }
            //branch=branch.replaceAll('branch', '').trim().replaceAll(' ', '_');
            if(string.isNotBlank(finalqueue) && string.isNotEmpty(finalqueue))
            {
                
                    branchMap.put(item.id, finalqueue);
                    if(item.Parent_Account__c == null && !listParentAccounts.contains(item.id))
                    {
                        listParentAccounts.add(item.Id);
                              mapParentAccounts.put(item.id,item.Id);
                    }
                    else if(!listParentAccounts.contains(item.Parent_Account__c))
                    {
                        listParentAccounts.add(item.Parent_Account__c);
                        mapParentAccounts.put(item.id,item.Parent_Account__c);
                    }
                    
            }   
        }
        system.debug('branchMap###' + branchMap);
        List<Id> MemberWithOpp = new List<string>();
        List<Person_Account__c> listPA = [SELECT Id,Account_Number__c,PersonId__c,PersonId__r.DormancyOppCreated__c
                                            FROM Person_Account__c where Account_Number__c in: listParentAccounts and TypeTranslate__c = '0000/Primary' ];
        Map<string, string> mapParentIdAccountId = new  Map<string, string>();
        for(Person_Account__c pa : listPA)
        {
            mapParentIdAccountId.put(pa.Account_Number__c,pa.PersonId__c);
            
            if(pa.PersonId__r.DormancyOppCreated__c == true && !MemberWithOpp.contains(pa.PersonId__c))
            {
                MemberWithOpp.add(pa.PersonId__c);
            }
        }
        
        
        string ListMemberAccount ='';
        system.debug('accountset==='+accountset);
        List<Opportunity> listopptoCreate = new List<Opportunity>();
        set<Id> accountIds = new set<Id>();
        for(Account_Details__c item : acclist)
        {
             string parentAccount =  mapParentAccounts.get(item.id);
             string member = mapParentIdAccountId.get(parentAccount);
             string queuename = branchMap.get(item.id);
             if(string.isNotBlank(queuename) && string.isNotEmpty(queuename)) {
                system.debug('Member Not Found');               
                if (!accountset.containsKey(member) && !MemberWithOpp.contains(member)) {
                    system.debug('Member Not Found1');
                    if(member != null && string.isNotBlank(member) && string.isNotEmpty(member))
                    { 
                        system.debug('Member Not Found2');
                        ListMemberAccount = accountset.get(member);
                        if(ListMemberAccount != null && string.isNotBlank(ListMemberAccount) && string.isNotEmpty(ListMemberAccount)){
                            ListMemberAccount = ListMemberAccount + ',' + item.Id;
                        }
                        else
                        {
                          ListMemberAccount = item.Id;
                        }
                        accountset.put(member, ListMemberAccount);
                        
                        Opportunity opp = new Opportunity();
                        opp.Member_Account__c = item.id;
                        opp.StageName = 'New';
                        opp.AccountId = member;
                       
                        opp.Opportunity_Source__c = 'Member Intelligence';
                        opp.Product_Type__c = 'Accounts/Shares';
                        opp.Product_Sub__c = 'Membership';
                        opp.Queue_Owner__c = queuename;
                        
                        List<date> datelist = new List<date>();
                        if(item.Activity_Date__c != null)
                            datelist.add(item.Activity_Date__c);
                        if(item.Correspondence_Date__c != null)
                             datelist.add(item.Correspondence_Date__c);
                        date Futuredate, maxDate;  
                        if(datelist.size()==2){
                            datelist.sort();                
                            maxDate = datelist.get(datelist.size()-1);
                            Futuredate = maxDate.adddays(365);
                        }
                        else if(datelist.size()==1){                        
                            maxDate = datelist.get(0);
                            Futuredate = maxDate.adddays(365);
                        }

                        opp.Future_Date__c = Futuredate;
                        opp.Name = 'Test';
                        opp.CloseDate = system.today();
                        opp.Description = '(INSTRUCTIONS) \r\n TRIGGERED OPPORTUNITY \r\n Inform the member of their impending dormancy and review their options with them.';
                        opp.isTriggeredOpportunity__c =true;                
                        OpportunityList.add(opp);        
                     }           
                       
                   }
                   else{    
                    ListMemberAccount = accountset.get(member);
                      if(ListMemberAccount != null && string.isNotBlank(ListMemberAccount) && string.isNotEmpty(ListMemberAccount)){
                            ListMemberAccount = ListMemberAccount + ',' + item.Id; 
                        }
                        else
                        {
                            ListMemberAccount = item.Id;
                        }   
                         accountset.put(member, ListMemberAccount); 
                         
                         system.debug('ListMemberAccount###' + ListMemberAccount);
                         system.debug('member###' + member);
                         system.debug('item.Id###' + item.Id);
                         system.debug('accountset###' + accountset);
                         
                   }
                MemberAccountmap.add(item);
            }
        }
       
    }
     global void finish(Database.BatchableContext BC){
                
        
        system.debug('accountmap###' + accountset);
         system.debug('OpportunityList###' + OpportunityList);
         system.debug('MemberAccountmap###' + MemberAccountmap);
         
        map<id, string> MemberAccountList = new map<id, string>();
        
        List<Account> accounts = [select id, DormancyOppCreated__c,DormancyMemberAccounts__c from Account where id in: accountset.keySet()];
                for (Account acc : accounts){
                    acc.DormancyOppCreated__c=true;
                    
                    if(string.isnotBlank(acc.DormancyMemberAccounts__c) && string.isnotEmpty(acc.DormancyMemberAccounts__c))
                    {
                        acc.DormancyMemberAccounts__c = acc.DormancyMemberAccounts__c + ','  + accountset.get(acc.id); 
                    }
                    else
                    {
                        acc.DormancyMemberAccounts__c =  accountset.get(acc.id);
                    }
                }
                for (Account_Details__c acc1 : MemberAccountmap){
                    acc1.DormancyOppCreated__c=true;
                }
                
                update accounts;
                update MemberAccountmap;
                
                
                insert OpportunityList;

   }
   
   public static string checkifPhysicalBranch(string branchname, List<Group> listQueue){
        String groupName = ''; 
        system.debug('branchname==='+branchname);
        if(branchname != '' && branchname != null){
            string BranchQueue = branchname.replace(' ', '_').replace('-','_').replace('/','_').toLowerCase();
        
        for(Group grp : listQueue)
                     {
                        if(grp.Email != null && grp.Email.containsIgnoreCase(BranchQueue)){
                                            groupName = grp.Name;
                                            break;
                            }
                                        
                       }
        }
        
        return groupName;
                        
   }
}