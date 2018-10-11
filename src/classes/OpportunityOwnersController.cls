public class OpportunityOwnersController {
	
	@AuraEnabled
    public static list<QueueWrapper> GetuserOpportunities()
    {
    	system.debug('Opportunity');
    	List<Opportunity> Opportunitylist = new List<Opportunity>();
        List<QueueWrapper> qWrap = new List<QueueWrapper>();
        Id currentUsersId = UserInfo.getUserId();               
        
        Id RoleId = UserInfo.getUserRoleId();
        
       
      	Set<Id> roleRelatedGroupIds = new Set<Id>();
      List<Group> gList = [SELECT Id, RelatedId, Type from Group where RelatedId =:RoleId AND Type = 'Role'];
             for (Group g : gList){
             roleRelatedGroupIds.add(g.id);
              }
         
        
        //List<GroupMember> grpMemList = [select GroupId from GroupMember where (Group.Type = 'Regular' AND  UserOrGroupId =:currentUsersId) OR (UserOrGroupId =:roleRelatedGroupIds)];        
        //List<GroupMember> grpMemList = [select GroupId from GroupMember where (Group.Type IN('Regular', 'RoleAndSubordinates') AND  UserOrGroupId =:currentUsersId) OR UserOrGroupId = '00E11000000eZqn'];
        List<GroupMember> grpMemList = [select GroupId from GroupMember where (Group.Type = 'Regular' AND  UserOrGroupId =:currentUsersId) OR UserOrGroupId =:roleRelatedGroupIds];
        set<Id> memIdSet = new set<Id>();
        for(GroupMember grp : grpMemList){
            memIdSet.add(grp.GroupId);
        }
        memIdSet.add(currentUsersId);
            

        List<GroupMember> queueMemList = [select GroupId from GroupMember where (Group.Type = 'Queue' AND  UserOrGroupId =:memIdSet) OR UserOrGroupId =:roleRelatedGroupIds];
        Set<Id> grpIdSet = new Set<Id>();
        for(GroupMember que : queueMemList){
            grpIdSet.add(que.GroupId);
            
        }        
        
        List<Group> grpList = [Select Id, Name, RelatedId, Type from Group where Id=:grpIdSet];
        Set<String> grpNameSet = new Set<String>();
        for(Group grp : grpList){
            grpNameSet.add(grp.Name);
        }
              
        System.debug('grpNameSet'+ grpNameSet);
        OpportunityList = [Select Id, Owner.Name, OwnerId, StageName, Name, Account.Name, AccountId, Product_Type__c, Opportunity_Number__c, Queue_Owner__c, User_Owner__c  from Opportunity where Queue_Owner__c IN:grpNameSet Order By CreatedDate ASC LIMIT 200];
        System.debug('Number of Opportunities:::'+Opportunitylist.size());
        for(Opportunity op : Opportunitylist){
                qWrap.add(new QueueWrapper(op));            
        }   
        
        return qWrap;    
    }
    
    @AuraEnabled
    public static list<QueueWrapper> saveUserOpportunities(string qWrapstr, string OwnerId, string ownertype)
    {    	
    	
        list<Opportunity> selectedOpportunities = new list<Opportunity>();
        Set<Id> oppid = new Set<Id>();
        system.debug('qwrap string'+ qWrapstr.replace('\\"','"'));
        list<QueueWrapper> qWrap = (list<QueueWrapper>)JSON.deserialize(qWrapstr.replace('\\"','"'), list<QueueWrapper>.class);
               
         system.debug('after qwrap string'+ qWrap);
                     
        if(qWrap!=NULL && qWrap.size()>0){

            for(QueueWrapper aw: qWrap){                
                if(aw.selected == true){
                  oppid.Add(aw.OpportunityModel.Id);
                }
            } 
                
                List <Opportunity> opplist = [Select Id, User_Owner__c, Queue_Owner__c, Queue_Assigned_Id__c, Ownership__c from Opportunity where id IN :oppid];
                
                if(opplist.size() > 0)
                {  
                	system.debug('Ownertype'+ ownertype);
                	system.debug('ownerId'+ OwnerId);
                	for(Opportunity opp :opplist )
                	{
	                	  if(ownertype == 'User' )
	                    {
	                        opp.User_Owner__c = OwnerId;
	                        opp.Queue_Owner__c = null;
	                    
	                    	selectedOpportunities.add(opp);
	                	}
	                	else
	                	{
	                		opp.Queue_Owner__c = OwnerId;
	                        opp.User_Owner__c = null;
	                    
	                    	selectedOpportunities.add(opp);
	                	}
                	}
                         
                } 
            
                 system.debug('selectedOpportunities'+ selectedOpportunities); 
            //aw.CaseModel.ownerId = NULL;
        	 
        }

        try{           
        	
            update selectedOpportunities;
            
        }
        catch(Exception ex){
        	            
        }         
        
        return  GetuserOpportunities();
    
    }
    
    
    public class QueueWrapper{
    	@AuraEnabled
        public Opportunity OpportunityModel {get;set;}
        @AuraEnabled
        public Boolean selected {get; set;}
        
        public QueueWrapper(Opportunity opp){
            this.OpportunityModel = opp;
            this.selected = false;
        }
    }
    
    @AuraEnabled   
    public static List<Group> GetQueueName()
    {
    	List<Group> listQueue = new List<Group>();
    	    	
    	listQueue = [select id,Name,Email from Group where Type = 'Queue' and (Email like '%lead.com' or Email like '%opportunity.com')];
    	return listQueue;
    }
    
}