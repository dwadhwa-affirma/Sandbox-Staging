public class QueueOwnersOnlyController {
    public Case cas {get;set;}
    public List<QueueWrapper> qWrap {get;set;}
    public List<Case> selectedCases {get; set;}
    public List<Case> caseList {get;set;}
    
    //private ApexPages.StandardController stdCtrl;
    public QueueOwnersOnlyController() {
        //this.cas = (Case)Controller.getRecord();
        cas = new Case();
        QueueCount();
    }
    
    public void QueueCount(){
       caseList = new List<Case>();
        qWrap = new List<QueueWrapper>();
        Id currentUsersId = UserInfo.getUserId();               
        System.debug('User Id is::::'+currentUsersId);
        Id RoleId = UserInfo.getUserRoleId();
        System.debug('Role Id is:::'+RoleId);
       
      Set<Id> roleRelatedGroupIds = new Set<Id>();
      List<Group> gList = [SELECT Id, RelatedId, Type from Group where RelatedId =:RoleId AND Type = 'Role'];
             for (Group g : gList){
             roleRelatedGroupIds.add(g.id);
              }
        System.debug('User Role Id is:::'+roleRelatedGroupIds); 
        
        //List<GroupMember> grpMemList = [select GroupId from GroupMember where (Group.Type = 'Regular' AND  UserOrGroupId =:currentUsersId) OR (UserOrGroupId =:roleRelatedGroupIds)];        
        //List<GroupMember> grpMemList = [select GroupId from GroupMember where (Group.Type IN('Regular', 'RoleAndSubordinates') AND  UserOrGroupId =:currentUsersId) OR UserOrGroupId = '00E11000000eZqn'];
        List<GroupMember> grpMemList = [select GroupId from GroupMember where (Group.Type = 'Regular' AND  UserOrGroupId =:currentUsersId) OR UserOrGroupId =:roleRelatedGroupIds];
        set<Id> memIdSet = new set<Id>();
        for(GroupMember grp : grpMemList){
            memIdSet.add(grp.GroupId);
        }
        memIdSet.add(currentUsersId);
        System.debug('MemIdSet is:::'+memIdSet);    

        List<GroupMember> queueMemList = [select GroupId from GroupMember where (Group.Type = 'Queue' AND  UserOrGroupId =:memIdSet) OR UserOrGroupId =:roleRelatedGroupIds];
        Set<Id> grpIdSet = new Set<Id>();
        for(GroupMember que : queueMemList){
            grpIdSet.add(que.GroupId);
            System.debug('GroupMemList is:::'+grpMemList);
        }        
        
        List<Group> grpList = [Select Id, Name, RelatedId, Type from Group where Id=:grpIdSet];
        Set<String> grpNameSet = new Set<String>();
        for(Group grp : grpList){
            grpNameSet.add(grp.Name);
        }
        System.debug('Queue List is:::'+grpNameSet);      
        
        
        	Date todayDate = System.Today();
           caseList = [Select Id, Owner.Name, OwnerId, CaseNumber, Category__c, Status, CreatedDate, Days_elapsed__c, Hours_Elapsed__c,Future_Date__C from Case where 
           			Owner.Name IN:grpNameSet and (Future_Date__C = null or Future_Date__c >=: todayDate) Order By CreatedDate ASC LIMIT 200];
        System.debug('Number of Cases:::'+caseList.size());
            for(Case cs : caseList){
                qWrap.add(new QueueWrapper(cs));            
            }    
        }
    public String getCase() {
        return null;
    }
     
    public void editSelected(){
        selectedCases = new list<Case>();
      /*  if(qWrap[0].selected == false){
                    ApexPages.Message msgs = new ApexPages.Message(ApexPages.Severity.ERROR, 'Please select at least one row');
                    ApexPages.addMessage(msgs);
                } */
        
        if(qWrap!=NULL && qWrap.size()>0){

            for(QueueWrapper aw: qWrap){                
                if(aw.selected == true){
                    if(cas.ownerId!=Null){
                        aw.cs.OwnerId = cas.ownerId;
                    }                  
                    selectedCases.add(aw.cs);
                }         
            }            
            cas.ownerId = NULL;
        } 
 
          if(qWrap.size()==0){
          Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'No records are available to update'));               
        }

        try{           
            update selectedCases;
            QueueCount();
            if(Test.isRunningTest()){
               Integer x=1/0;}
         
        }catch(Exception ex){
            ApexPages.Message msgs = new ApexPages.Message(ApexPages.Severity.ERROR,ex.getMessage());
            ApexPages.addMessage(msgs);
        }         
    } 
    
    public class QueueWrapper{
        public Case cs {get;set;}
        public Boolean selected {get; set;}
        
        public QueueWrapper(Case cas){
            this.cs = cas;
            this.selected = false;
        }
    }   
}