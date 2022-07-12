/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 07-11-2022
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public class GetCaseAttachments {   

    @AuraEnabled 
    public static object getCaseAttachment(string caseId)
    {
                 system.debug('CaseId####DW' + caseId);
                List<string> parentId = new List<string>();
                List<Attachment> attachments = new List<Attachment>();
                List<ListAttachment> listAttachments  = new List<ListAttachment>();
                List<string> parentIdmembercomment = new List<string>();
                Case caseDetail;
                if(caseId != null){
                caseDetail = [select status, Attachments_Are_Deleted__c, Account_Number__c from Case where Id =: caseId];
                system.debug('caseDetail.Account_Number__r :: '+caseDetail.Account_Number__c);
                }
                
                parentId.Add(caseId);
                
                List<OnBase_Document__c> onbaseList = [Select Id,Name,Attachment_Id__c,IsMovedToOnBase__c,Document_Type__c,Attachment_Created_On__c,Attachment_Owner__r.Name from OnBase_Document__c where case__c =: caseId  or Member_Comment__r.Case__C =: caseId LIMIT 49999];
               
                  system.debug('onbaseList :: '+ onbaseList[0]);

                if(caseDetail != null){
                if(caseDetail.Attachments_Are_Deleted__c == true){
                	system.debug('In If ');
                	for(OnBase_Document__c onbaseObj : onbaseList){
                    	ListAttachment la = new ListAttachment();
                    	 
                   		la.Name = onbaseObj.Name;
                        la.DocumentType = onbaseObj.Document_Type__c;
                        la.LastModifiedDate = onbaseObj.Attachment_Created_On__c.format('MM/dd/yyyy');
                        la.CreatedBy = onbaseObj.Attachment_Owner__r.Name;
                        la.isMovedToOnBase = onbaseObj.IsMovedToOnBase__c;
                        if(onbaseObj.Document_Type__c == '' || onbaseObj.Document_Type__c == 'Not For OnBase'){
                        	la.downloadLink = '/servlet/servlet.FileDownload?file='+ string.valueOf(onbaseObj.attachment_id__c) +'&operationContext=S1';
                        }else{
                        	la.downloadLink = '';
                        }
                        listAttachments.add(la);
                	}
                }
                else{
                	
                
                Map<Id,OnBase_Document__c> onbaseDocumentMap = new Map<Id,OnBase_Document__c>();
                for(OnBase_Document__c onbaseObj : onbaseList){
                    onbaseDocumentMap.put(onbaseObj.Attachment_Id__c,onbaseObj);
                }
               
                List<Member_Comment__c> membercomment = [Select Id from Member_Comment__c where case__c =: caseId];
                for(Member_Comment__c mc : membercomment)
                {
                    parentIdmembercomment.Add(mc.Id);
                                    parentId.Add(mc.Id);
                }
                 system.debug('ParentId####DW' + parentId);
                 system.debug('parentIdmembercomment####DW' + parentIdmembercomment);
                 attachments = [SELECT BodyLength,Description,Id,LastModifiedDate ,Name,OwnerId,ParentId, Owner.Name, CreatedBy.Profile.Name, Parent.Type FROM Attachment where ParentId IN: parentId];
                  system.debug('attachments1####DW' + attachments);
                  
                  
                  
                 for(Attachment att : attachments)
                    {
                        ListAttachment la = new ListAttachment();
                        system.debug('AttType ::'+att.Parent.Type);
                        if(att.CreatedBy.Profile.Name == 'Messaging center Customers' )
                        {
                            la.FromMember = true;
                        }
                        else
                        {
                            la.FromMember = false;
                            if(att.Parent.Type != 'Case'){
                            	continue;
                            }
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
                        List<Approve_Attachment__c> approved = new List<Approve_Attachment__c>();
                        approved = [select id,Case_ID__c,Attachment_Id__c, ContentDocumentLinkId__c from Approve_Attachment__c where Attachment_Id__c =: att.Id];
                        if(approved != null && approved.size()> 0)
                        {
                            la.isApproved = true;
                        }
                        else
                        {
                            la.isApproved = false;
                        }
                        la.Name = att.Name;
                        la.LastModifiedDate = att.LastModifiedDate.format('MM/dd/yyyy');
                        la.CreatedBy = att.Owner.Name;
                        la.downloadLink = '/servlet/servlet.FileDownload?file='+ string.valueOf(att.id) +'&operationContext=S1';
                        la.attachmentId = att.Id;
                        if(onbaseDocumentMap.containsKey(att.Id)){
                            OnBase_Document__c onbaseObj = onbaseDocumentMap.get(att.Id);
                            la.isMovedToOnBase = onbaseObj.IsMovedToOnBase__c;
                            la.DocumentType = onbaseObj.Document_Type__c;
                        }
                        
                        listAttachments.add(la);
                        
                     }
                     system.debug('listAttachments==='+listAttachments);
                }
                }
    
                     system.debug('listContentDocument==='+listAttachments);
                     
                     ListAttachmentWithCaseDetail response = new ListAttachmentWithCaseDetail();
                     response.attachmentList = listAttachments;
                     if(caseDetail != null){
                     response.caseDetail = caseDetail;
                     }
            return response;          
    }
    
    @AuraEnabled 
    public static void deleteAttachment(string attachmentId){
        Attachment attachmentToDelete = new Attachment();
        attachmentToDelete = [SELECT BodyLength,Description,Id,LastModifiedDate ,Name,OwnerId,ParentId FROM Attachment where Id =: attachmentId];
        delete attachmentToDelete;
    }
    
  public class ListAttachment
  {
        @AuraEnabled
        public  Boolean fromMember {get; set;} 
        @AuraEnabled  
        public  string  displaysize {get; set;} 
        @AuraEnabled
        public string name {get;set;}  
        @AuraEnabled
        public string createdBy {get;set;}
        @AuraEnabled
        public string lastModifiedDate {get;set;}
        @AuraEnabled
        public string downloadLink {get;set;}
        @AuraEnabled
        public string attachmentId {get;set;}
         @AuraEnabled
        public boolean isApproved {get;set;}
        @AuraEnabled
        public boolean isMovedToOnBase = false;
        @AuraEnabled
        public string documentType = '';
  }
   public class ListAttachmentWithCaseDetail{
        @AuraEnabled
        public List<ListAttachment> attachmentList {get;set;}
        @AuraEnabled
        public Case caseDetail{get;set;}
   }
}