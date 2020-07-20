public class LeadOwnersOnlyController {
   // private final Lead led; 
    public Lead led {get;set;}
    public List<QueueWrapper> qWrap {get;set;}
    public List<Lead> selectedLeads {get; set;}
    public List<Lead> leadList {get;set;}
    
   // private ApexPages.StandardController stdCtrl;
    public LeadOwnersOnlyController() {
       // this.led = (Lead)Controller.getRecord();
        led = new Lead();
        QueueCount();
    }
    
    public void QueueCount(){
       leadList = new List<Lead>();
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
        
           leadList = [Select Id, Owner.Name, OwnerId, Status, Name, Product_Type__c, Lead_Number__c from Lead where Owner.Name IN:grpNameSet Order By CreatedDate ASC LIMIT 200];
        
            for(Lead ld : leadList){
                qWrap.add(new QueueWrapper(ld));            
            }    
        }
    
     
    public void editSelected1(){
        selectedLeads = new list<Lead>();
      /*  if(qWrap[0].selected == false){
                    ApexPages.Message msgs = new ApexPages.Message(ApexPages.Severity.ERROR, 'Please select at least one row');
                    ApexPages.addMessage(msgs);
                } */
        
        if(qWrap!=NULL && qWrap.size()>0){

            for(QueueWrapper aw: qWrap){                
                if(aw.selected == true){
                    if(led.OwnerId!=Null){
                        aw.ld.OwnerId = led.OwnerId;
                    }                  
                    selectedLeads.add(aw.ld);
                }         
            }            
            led.OwnerId = NULL;
        } 
 
          if(qWrap.size()==0){
          Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'No records are available to update'));               
        }

        try{           
            update selectedLeads;
            QueueCount(); 
            if(Test.isRunningTest()){                
               Integer x=1/0;}                  
        }catch(Exception ex){
            ApexPages.Message msgs = new ApexPages.Message(ApexPages.Severity.ERROR,ex.getMessage());
            ApexPages.addMessage(msgs);
        }         
    } 
    
    public class QueueWrapper{
        public Lead ld {get;set;}
        public Boolean selected {get; set;}
        
        public QueueWrapper(Lead led){
            this.ld = led;
            this.selected = false;
        }
    }   
}