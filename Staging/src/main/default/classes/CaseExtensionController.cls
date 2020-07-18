public class CaseExtensionController {
 private final Id CaseId;
 public List<CaseComment> casecommentlist { get; set; }
 public list<Member_Comment__c> membercommentlist {get;set;}
 public CaseExtensionController(ApexPages.StandardController stdController)
    {
        CaseId = stdController.getId();
        casecommentlist = [SELECT CommentBody,Id,ParentId,createddate, CreatedBy.Name FROM CaseComment where parentid=:CaseId  order by createddate desc];
        membercommentlist = [SELECT Case__c,Member_Communication__c, Createddate, Createdby.Name FROM Member_Comment__c where case__c = :CaseId order by createddate desc]; 
    }
}