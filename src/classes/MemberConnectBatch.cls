global class MemberConnectBatch implements Database.Batchable<SObject>{
    global Iterable<SObject> start(Database.BatchableContext BC)
    {
        String query = 'select id, name, role_name__c, lastmodifieddate, createddate,lastmodifiedByid, createdByid, createdby.Name, LastModifiedby.Name,LastModifiedby.UserRole.Name'+ 
            ' from Needs_Assesment__c where CreatedDate = LAST_N_DAYS:60 or lastmodifieddate = LAST_N_DAYS:60';
        system.debug('--'+query);
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<Needs_Assesment__c> scope)
    {
        List<Count_Member_Connect__c> countlst = new List<Count_Member_Connect__c>();
        system.debug('-----------'+scope);
        for(Needs_Assesment__c Na : scope)
        {	 
            boolean flag = false;
            for(integer i = 0 ; i < countlst.size(); i++){
                if( na.CreatedById == countlst[i].UserId__c){
                    countlst[i].Total_Count__c+= 1; 
                    flag=true;
                }
            }
            if(!flag){                	
                countlst.add(new Count_Member_Connect__c(Branch_Name__c=na.role_name__c,Total_Count__c=1,User_Name__c=na.CreatedBy.name,
                                                         UserId__c=na.CreatedById,date__c = system.today()));
            }
            if(na.CreatedById != na.LastModifiedById){
                boolean flag1 = false;
               for(integer i = 0 ; i < countlst.size(); i++){
                    if( na.LastModifiedById == countlst[i].UserId__c){
                        countlst[i].Total_Count__c+= 1; 
                        flag1=true;
                    }
                }   
                if(!flag1){                	
                        countlst.add(new Count_Member_Connect__c(Branch_Name__c=na.LastModifiedBy.UserRole.name,Total_Count__c=1,User_Name__c=na.LastModifiedBy.name,
                                                                 UserId__c=na.LastModifiedById,date__c = system.today()));
                    }
            }
        }
        system.debug('-----------'+countlst);
        if(countlst.size() > 0){
            delete [select id from Count_Member_Connect__c];
        }
        insert countlst;
    }  
    global void finish(Database.BatchableContext BC)
    {
    }
}