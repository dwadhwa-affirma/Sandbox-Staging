public class CannedResponseAttachmentController {
	
	 @AuraEnabled 
    public static object GetCaseAttachments(string RecordId)
    {
                 system.debug('RecordId' + RecordId);
                List<string> parentId = new List<string>();
                List<Attachment> attachments = new List<Attachment>();
                List<ListAttachment> listAttachments  = new List<ListAttachment>();
                List<string> parentIdmembercomment = new List<string>();
                
                Canned_Responses__c CRDetail = [select id, Name, Active__c from Canned_Responses__c where Id =: RecordId];             
               
                //parentId.Add(RecordId);            
            
                 attachments = [SELECT BodyLength,Description,Id,LastModifiedDate ,Name,OwnerId,ParentId, Owner.Name, CreatedBy.Profile.Name, Parent.Type FROM Attachment where ParentId =: RecordId];
              
                  system.debug('attachments1####DW' + attachments);
               
                  
                 for(Attachment att : attachments)
                    {
                        ListAttachment la = new ListAttachment();
                        system.debug('AttType ::'+att.Parent.Type);
                       
                        
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
                        la.LastModifiedDate = att.LastModifiedDate.format('MM/dd/yyyy');
                        la.CreatedBy = att.Owner.Name;
                        la.downloadLink = '/servlet/servlet.FileDownload?file='+ string.valueOf(att.id) +'&operationContext=S1';
                        la.attachmentId = att.Id;
                                                
                        listAttachments.add(la);
                        
                     }
                     system.debug('listAttachments==='+listAttachments);
                
    
                
                     
                     system.debug('listContentDocument==='+listAttachments);
                     
                     ListAttachmentWithCaseDetail response = new ListAttachmentWithCaseDetail();
                     response.attachmentList = listAttachments;
                     response.CRDetail = CRDetail;
            return response;          
    }
    
    @AuraEnabled 
    public static void DeleteAttachment(string attachmentId){
        Attachment attachmentToDelete = new Attachment();
        attachmentToDelete = [SELECT BodyLength,Description,Id,LastModifiedDate ,Name,OwnerId,ParentId FROM Attachment where Id =: attachmentId];
        delete attachmentToDelete;
    }
    
  public class ListAttachment
  {
       
        @AuraEnabled  
        public  string  displaysize {get; set;} 
        @AuraEnabled
        public string Name {get;set;}  
        @AuraEnabled
        public string CreatedBy {get;set;}
        @AuraEnabled
        public string LastModifiedDate {get;set;}
        @AuraEnabled
        public string downloadLink {get;set;}
        @AuraEnabled
        public string attachmentId {get;set;}         
        @AuraEnabled
        public string DocumentType = '';
  }
   public class ListAttachmentWithCaseDetail{
        @AuraEnabled
        public List<ListAttachment> attachmentList {get;set;}
        @AuraEnabled
        public Canned_Responses__c CRDetail{get;set;}
   }
    
}