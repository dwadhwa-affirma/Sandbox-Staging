public class GetCaseAttachments {	

    @AuraEnabled 
    public static object GetCaseAttachments(string CaseId)
    {
    			 system.debug('CaseId####DW' + CaseId);
    			List<string> parentId = new List<string>();
        		List<Attachment> attachments = new List<Attachment>();
        		List<ListAttachment> listAttachments  = new List<ListAttachment>();
        		
               // CaseId = System.currentPageReference().getParameters().get('id');
                parentId.Add(CaseId);
               
                List<Member_Comment__c> membercomment = [Select Id from Member_Comment__c where case__c =: CaseId];
                for(Member_Comment__c mc : membercomment)
                {
                    parentId.Add(mc.Id);
                }
                 system.debug('ParentId####DW' + parentId);
                 attachments = [SELECT BodyLength,Description,Id,LastModifiedDate ,Name,OwnerId,ParentId, Owner.Name, CreatedBy.Profile.Name FROM Attachment where ParentId IN: parentId];
                 List<ContentDocumentLink> ContentDocumentLst = [select Id, ContentDocumentId, ContentDocument.Title, ContentDocument.FileType, ContentDocument.ContentSize, ContentDocument.OwnerId, ContentDocument.ContentModifiedDate, ContentDocument.CreatedBy.Name, ContentDocument.CreatedBy.Profile.Name from ContentDocumentLink where LinkedEntityId IN: parentId];
                  system.debug('attachments1####DW' + attachments);
                  
                   system.debug('ContentDocumentLst####DW' + ContentDocumentLst);
                  
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
                     
                    for(ContentDocumentLink cd : ContentDocumentLst)
                    {
                        ListAttachment la = new ListAttachment();
                        
                       if(cd.ContentDocument.CreatedBy.Profile.Name == 'Messaging center Customers' )
                        {
                            la.FromMember = true;
                        }
                        else
                        {
                            la.FromMember = false;
                        }
                        
                        if(cd.ContentDocument.ContentSize < 1000)
                        {
                            la.displaySize = cd.ContentDocument.ContentSize + ' Bytes';
                                  
                        }                               
                        else if(cd.ContentDocument.ContentSize > 1000 && cd.ContentDocument.ContentSize < 1000000)
                        {
                              la.displaySize = Math.floor(cd.ContentDocument.ContentSize/1000) + ' KB';
                        }
                        else
                        {
                            la.displaySize  = Math.round((cd.ContentDocument.ContentSize / 1000000)*10)/10 + ' MB';
                        }
                        
                        la.Name = cd.ContentDocument.Title;
                        la.LastModifiedDate = cd.ContentDocument.ContentModifiedDate;
                        la.CreatedBy = cd.ContentDocument.CreatedBy.Name;
                        listAttachments.add(la);
                     }
            return listAttachments;          
    }
    
  public class ListAttachment
  {
  		@AuraEnabled
        public  Boolean FromMember {get; set;} 
        @AuraEnabled  
        public  string  displaysize {get; set;} 
        @AuraEnabled
        public string Name {get;set;}  
        @AuraEnabled
        public string CreatedBy {get;set;}
        @AuraEnabled
        public datetime LastModifiedDate {get;set;}
  }
    
}