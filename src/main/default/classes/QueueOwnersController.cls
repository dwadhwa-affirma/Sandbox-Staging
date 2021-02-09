public class QueueOwnersController {
	@AuraEnabled
        public static list<QueueWrapper> GetuserCases()
    {
    	List<Case> caseList = new List<Case>();
        List<QueueWrapper> qWrap = new List<QueueWrapper>();
        Id currentUsersId = UserInfo.getUserId();               
        //System.debug('User Id is::::'+currentUsersId);
        Id RoleId = UserInfo.getUserRoleId();
        //System.debug('Role Id is:::'+RoleId);
       
      	Set<Id> roleRelatedGroupIds = new Set<Id>();
      List<Group> gList = [SELECT Id, RelatedId, Type from Group where RelatedId =:RoleId AND Type = 'Role'];
             for (Group g : gList){
             roleRelatedGroupIds.add(g.id);
              }
        //System.debug('User Role Id is:::'+roleRelatedGroupIds); 
        
        //List<GroupMember> grpMemList = [select GroupId from GroupMember where (Group.Type = 'Regular' AND  UserOrGroupId =:currentUsersId) OR (UserOrGroupId =:roleRelatedGroupIds)];        
        //List<GroupMember> grpMemList = [select GroupId from GroupMember where (Group.Type IN('Regular', 'RoleAndSubordinates') AND  UserOrGroupId =:currentUsersId) OR UserOrGroupId = '00E11000000eZqn'];
        List<GroupMember> grpMemList = [select GroupId from GroupMember where (Group.Type = 'Regular' AND  UserOrGroupId =:currentUsersId) OR UserOrGroupId =:roleRelatedGroupIds];
        set<Id> memIdSet = new set<Id>();
        for(GroupMember grp : grpMemList){
            memIdSet.add(grp.GroupId);
        }
        memIdSet.add(currentUsersId);
        //System.debug('MemIdSet is:::'+memIdSet);    

        List<GroupMember> queueMemList = [select GroupId from GroupMember where (Group.Type = 'Queue' AND  UserOrGroupId =:memIdSet  and  group.name != 'Call Center Solar Onboarding Queue') OR UserOrGroupId =:roleRelatedGroupIds];
        Set<Id> grpIdSet = new Set<Id>();
        for(GroupMember que : queueMemList){
            grpIdSet.add(que.GroupId);
            //System.debug('GroupMemList is:::'+grpMemList);
        }        
        
        List<Group> grpList = [Select Id, Name, RelatedId, Type from Group where Id=:grpIdSet];
        Set<String> grpNameSet = new Set<String>();
        for(Group grp : grpList){
            grpNameSet.add(grp.Name);
        }
        //System.debug('Queue List is:::'+grpNameSet);      
        
           caseList = [Select Id, Owner.Name, OwnerId, CaseNumber, Category__c, Status, CreatedDate, Days_elapsed__c, Hours_Elapsed__c, future_date__c from Case where Owner.Name IN:grpNameSet Order By CreatedDate ASC LIMIT 200];
        //System.debug('Number of Cases:::'+caseList.size());
            for(Case cs : caseList){
                qWrap.add(new QueueWrapper(cs));            
            }   
        
        return qWrap;    
    }
    
    @AuraEnabled
    public static list<QueueWrapper> saveUserCases(string qWrapstr, string OwnerId)
    {    	
    	//system.debug('Azhar  Start qWrapstr' + qWrapstr);
        List<Case> selectedCases = new list<Case>();
        
        list<QueueWrapper> qWrap = (list<QueueWrapper>)JSON.deserialize(qWrapstr, list<QueueWrapper>.class);
        //system.debug('Azhar  qWrap' + qWrap);        
        
        //system.debug('Azhar  qWrap.size()'  + qWrap.size());             
        if(qWrap!=NULL && qWrap.size()>0){

            for(QueueWrapper aw: qWrap){                
                if(aw.selected == true){
                    if(aw.CaseModel.ownerId!=Null){
                        aw.CaseModel.OwnerId = OwnerId;
                    }
                    
                    selectedCases.add(aw.CaseModel);
                }         
            }     
            
            //system.debug('Azhar  selectedCases'  + selectedCases);       
            //aw.CaseModel.ownerId = NULL;
        } 

        try{           
        	//system.debug('Azhar  Update Start' );
            update selectedCases;
            //system.debug('Azhar  Update end' );
        }
        catch(Exception ex){
        	            
        }         
        
        return  GetuserCases();
    }
    
    
    public class QueueWrapper{
    	@AuraEnabled
        public Case CaseModel {get;set;}
        @AuraEnabled
        public Boolean selected {get; set;}
        
        public QueueWrapper(Case cas){
            this.CaseModel = cas;
            this.selected = false;
        }
    }
}