public class VisualAlertsController{
   public Case cs{get;set;}
   
 public Boolean commentAlert; 
 public Boolean attachAlert;
 public Boolean memberCommentAlrt;
 
 
 public VisualAlertsController(ApexPages.StandardController controller) {
          cs = [SELECT Id, isNewCaseComment__c, IsNewAttachment__c, isNewMemberComment__c FROM Case

                   WHERE Id = :ApexPages.currentPage().getParameters().get('id')];
    }

 
 // new Case comment alert flag 
 
 public boolean getCaseComment(){
  commentAlert = cs.isNewCaseComment__c;
  return commentAlert;
 }
 
 public PageReference removeCaseComment(){
     cs.isNewCaseComment__c = false;
   commentAlert = false;
   update cs;
   return null;
   }
  
  
  // new Attachment alert flag

 public Boolean getAttach(){
  attachAlert = cs.isNewAttachment__c;
  return attachAlert;
 }
 
  public PageReference RemoveAttach(){
     cs.isNewAttachment__c = false;
   attachAlert = false;
   update cs;
   return null;
 }
 
  // New Member comment alert flag
   
   public boolean getMemberComment(){
  memberCommentAlrt = cs.isNewMemberComment__c;
  return memberCommentAlrt;
 }
 
 public PageReference removeMemberComment(){
     cs.isNewMemberComment__c = false;
   memberCommentAlrt = false;
   update cs;
   return null;
 }

}