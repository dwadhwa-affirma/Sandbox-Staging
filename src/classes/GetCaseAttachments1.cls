public class GetCaseAttachments1 {

    public  String CaseId {get; set;} 
    public Set<Id> parentId = new Set<Id>();
    public List<Attachment> attachments {get; set;}
    
    public  List<ListAttachment> listAttachments {get; set;}
    public GetCaseAttachments1 (ApexPages.StandardController controller)
    {
        
                CaseId = System.currentPageReference().getParameters().get('id');
                parentId.Add(CaseId);
                system.debug('CaseId####DW' + CaseId);
                List<Member_Comment__c> membercomment = [Select Id from Member_Comment__c where case__c =: CaseId];
                for(Member_Comment__c mc : membercomment)
                {
                    parentId.Add(mc.Id);
                }
                 system.debug('ParentId####DW' + parentId);
                 attachments = [SELECT BodyLength,Description,Id,LastModifiedDate ,Name,OwnerId,ParentId, Owner.Name, CreatedBy.Profile.Name FROM Attachment where ParentId IN: parentId];
                  system.debug('attachments1####DW' + attachments);
                  
                  listAttachments = new List<ListAttachment>();
                 for(Attachment att : attachments)
                    {
                        ListAttachment la = new ListAttachment();
                        
                        if(att.CreatedBy.Profile.Name == 'Messaging center Customers' )
                        {
                            la.FromMember = true;
                        }
                        else
                        {
                            la.FromMember = false;
                        }
                        
                        if(att.BodyLength < 1000)
                        {
                            la.displaySize = att.BodyLength + ' Bytes';
                                  
                        }                               
                        else if(att.BodyLength > 1000 && att.BodyLength < 1000000)
                        {
                              la.displaySize = Math.floor(att.BodyLength/1000) + ' KB';
                        }
                        else
                        {
                            la.displaySize  = Math.round((att.BodyLength / 1000000)*10)/10 + ' MB';
                        }
                        
                        la.Name = att.Name;
                        la.LastModifiedDate = att.LastModifiedDate;
                        la.CreatedBy = att.Owner.Name;
                        listAttachments.add(la);
                     }
                     
                      
    }
    
  public class ListAttachment
  {
        public  Boolean FromMember {get; set;}   
        public  string  displaysize {get; set;} 
        public string Name {get;set;}  
         
        public string CreatedBy {get;set;}
        public datetime LastModifiedDate {get;set;}
  }
        
  }