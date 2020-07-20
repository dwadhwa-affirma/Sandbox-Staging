public class LeadOwnersController {
	@AuraEnabled
    public static list<QueueWrapper> GetuserLeads()
    {
    	List<Lead> leadlist = new List<Lead>();
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
              
        
        leadList = [Select Id, Owner.Name, OwnerId, Status, Name, Product_Type__c, Lead_Number__c  from Lead where Owner.Name IN:grpNameSet Order By CreatedDate ASC LIMIT 200];
        System.debug('Number of leads:::'+leadlist.size());
        for(Lead ld : leadlist){
                qWrap.add(new QueueWrapper(ld));            
        }   
        
        return qWrap;    
    }
    
    @AuraEnabled
    public static list<QueueWrapper> saveUserLeads(string qWrapstr, string OwnerId)
    {    	
    	
        list<Lead> selectedLeads = new list<Lead>();
        
        list<QueueWrapper> qWrap = (list<QueueWrapper>)JSON.deserialize(qWrapstr, list<QueueWrapper>.class);
               
        
                     
        if(qWrap!=NULL && qWrap.size()>0){

            for(QueueWrapper aw: qWrap){                
                if(aw.selected == true){
                    if(aw.LeadModel.ownerId!=Null){
                        aw.LeadModel.OwnerId = OwnerId;
                    }
                    
                    selectedLeads.add(aw.LeadModel);
                }         
            }     
            
                  
            //aw.CaseModel.ownerId = NULL;
        } 

        try{           
        	
            update selectedLeads;
            
        }
        catch(Exception ex){
        	            
        }         
        
        return  GetuserLeads();
    }
    
    
    public class QueueWrapper{
    	@AuraEnabled
        public Lead LeadModel {get;set;}
        @AuraEnabled
        public Boolean selected {get; set;}
        
        public QueueWrapper(Lead lea){
            this.LeadModel = lea;
            this.selected = false;
        }
    }
}