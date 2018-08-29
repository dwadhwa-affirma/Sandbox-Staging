trigger AttachmentNameUpdate on Attachment (after update,after delete,after insert, before insert) {

    List<Approve_Attachment__c> toupdateApproveAttachment  = new List<Approve_Attachment__c>();
    
    Map<id,Attachment> attachmentDetails = new Map<id,Attachment >();
    //Map<id,Member_Comment__c> Memberlst  = new Map<id,Member_Comment__c> ();
    List<Member_Comment__c> MemberlsttoUpdate = new List<Member_Comment__c>();
    Set<id> parent = new Set<id>();
    //Parentid = CustomObject__c.sObjectType.getDescribe().getKeyPrefix()
    
    if(Trigger.isUpdate && Trigger.isAfter){   
        for(Attachment a : Trigger.New){
            attachmentDetails.put(a.id,a);
        }
    }
    if(Trigger.isDelete && Trigger.isAfter){
        for(Attachment a : Trigger.old){
            attachmentDetails.put(a.id,a);
            parent.add(a.ParentId);
        }
        
        set<Id> notClosedCaseSet = (new Map<Id,Case>([select id from case where ID IN: parent and status != 'Closed'])).keySet();
        set<Id> notClosedCaseMemberComment = (new Map<Id,Member_Comment__c>([select id from Member_Comment__c where Id IN: parent and Case__r.status != 'Closed'])).keySet();
        set<Id> attachmentIdsForOnbase = new set<Id>();
        for(Attachment a : Trigger.old){
            if(notClosedCaseSet.Contains(a.ParentId) || notClosedCaseMemberComment.Contains(a.ParentId)){
                attachmentIdsForOnbase.add(a.id);
            }
        }
        
        
        system.debug('notClosedCaseSet :: '+notClosedCaseSet);
        system.debug('attachmentIdsForOnbase :: '+attachmentIdsForOnbase);
        
        
        List<OnBase_Document__c> onbaseAttachmentsList = [select id from OnBase_Document__c where Attachment_Id__c IN : attachmentIdsForOnbase];
        system.debug('onbaseAttachmentsList :: '+onbaseAttachmentsList);
        if(!onbaseAttachmentsList.isEmpty()){
            system.debug('In If :: ');
            delete onbaseAttachmentsList;
        }
    }
    
    if(Trigger.isInsert && Trigger.isBefore){
        system.debug('Rename called');
         List<string> listAttachmentForCaseIds = new List<string>();
         List<string> listAttachmentIds = new List<string>(); 
         for(Attachment a : Trigger.New)
         {
            Schema.SObjectType objType = a.ParentId.getsobjecttype();
            if(objType == Case.sObjectType && a.CreatedBy.Profile.Name != 'Messaging center Customers')
            {
              listAttachmentForCaseIds.add(a.parentId);
            }
            
            listAttachmentIds.add(a.Id);
         }
         system.debug('Rename called 1' + listAttachmentIds);
         List<Attachment> mapValues = [SELECT Id,ParentId,Name FROM Attachment where ParentId =: listAttachmentForCaseIds and Id not in:  listAttachmentIds];
         system.debug('Rename called 2' + mapValues);
         for(Attachment a : Trigger.New)
         {
            for(Attachment caseAttachment : mapValues)
            {
                if(a.ParentId == caseAttachment.parentId && a.Name == caseAttachment.Name)
                {
                    string s = string.valueOf(system.now()).replace(' ' ,'-').replace(':','-');
                    
                    String[] arrayFileName =  a.Name.split('\\.');
                    string fileName = '';
                    system.debug('arrayFileName' + arrayFileName);
                    for (Integer i = 0; i < arrayFileName.size()-1; i++) {
                        fileName = fileName + arrayFileName[i] + '.';
                    }

                    fileName = fileName +  ' - ' + s + '.' + arrayFileName[arrayFileName.size()-1];
                    system.debug(fileName);
                    
                    
                    a.Name = fileName;
                    
                    break;
                    
                }
            }
            
         }
         
    }
    
    
    if(Trigger.isInsert && Trigger.isAfter){
        List<OnBase_Document__c> onbaseAttachmentsList  = new List<OnBase_Document__c>();   
        List<string> Caseids = new List<string>();
        List<string> memberCommentids = new List<string>();
        for(Attachment a : Trigger.New){
            attachmentDetails.put(a.id,a);
            parent.add(a.ParentId);
          
            Schema.SObjectType objType = a.ParentId.getsobjecttype();
            system.debug('a.Parent.Type12 :: '+ a.parentid.getsobjecttype());
            if(objType == Case.sObjectType || objType == Member_Comment__c.sObjectType){
                OnBase_Document__c onbaseObj = new OnBase_Document__c();
                onbaseObj.Attachment_Id__c = a.id;
                if(objType == Case.sObjectType)
                {
                onbaseObj.Case__c = a.ParentId;
                Caseids.add(a.ParentId);
                }
                else
                {
                onbaseObj.Member_Comment__c = a.ParentId;   
                memberCommentids.add(a.ParentId);
                }
                onbaseObj.IsMovedToOnBase__c = false;
                //onbaseObj.Name = a.Name;
                onbaseObj.Document_Name__c = a.Name;
                onbaseObj.Document_Type__c = null;
                onbaseObj.Attachment_Owner__c = a.OwnerId;
                onbaseObj.Attachment_Created_On__c = a.CreatedDate;
                onbaseAttachmentsList.add(onbaseObj);
            }
        }
        
        
        List<Case> listCasetoReopened = [select id from case where Status = 'Closed' and Id in: Caseids];
        
        
        
        for(Case itemCase : listCasetoReopened)
        {
            itemCase.Status = 'Re Opened';
        }
        update listCasetoReopened;
        insert (onbaseAttachmentsList);
    }
    
    
    
    List<Approve_Attachment__c> ApproveAttachment = [select id,Attachment_Name__c,Attachment_Id__c  from Approve_Attachment__c where Attachment_Id__c IN : attachmentDetails.keySet()];
    
    if(!ApproveAttachment.isEmpty()){
        if(Trigger.isUpdate && Trigger.isAfter){
            for(Approve_Attachment__c ap :  ApproveAttachment){
                if(!attachmentDetails.isEmpty()){
                  if(attachmentDetails.containsKey(ap.Attachment_Id__c)){ 
                      ap.Attachment_Name__c = attachmentDetails.get(ap.Attachment_Id__c).Name;   
                      toupdateApproveAttachment.add(ap); 
                  }
                }
            }
            if(!toupdateApproveAttachment.isEmpty()){
               update toupdateApproveAttachment;
            }
        }
        if(Trigger.isDelete && Trigger.isAfter){
            for(Approve_Attachment__c ap :  ApproveAttachment){
                toupdateApproveAttachment.add(ap);
            }
            if(!toupdateApproveAttachment.isEmpty()){
               delete toupdateApproveAttachment;
            }
        }
        
    }
    //Map<id,Member_Comment__c> MemberMap  = new Map<id,Member_Comment__c >([select id, Name from Member_Comment__c  where id IN :parent]);
    //Memberlst  = [select id,Name from Member_Comment__c where Id in: parent];
    for (Member_Comment__c mem : [select Id, Name,Attachment_Number__c,(SELECT Id FROM Attachments) ,(Select id from ContentDocumentLinks) from Member_Comment__c where Id IN :parent]) {
        //MemberMap.get(mem.Id).Attachment_Number__c = mem.Attachments.size();
        mem.Attachment_Number__c = mem.Attachments.size() + mem.ContentDocumentLinks.size();
        MemberlsttoUpdate.add(mem);
    }
    system.debug('--MemberlsttoUpdate--'+MemberlsttoUpdate);
    update MemberlsttoUpdate;
       
 
}