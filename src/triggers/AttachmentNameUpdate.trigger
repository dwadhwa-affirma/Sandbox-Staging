trigger AttachmentNameUpdate on Attachment (after update,after delete,after insert) {

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
    }
    if(Trigger.isInsert && Trigger.isAfter){
        for(Attachment a : Trigger.New){
            attachmentDetails.put(a.id,a);
            parent.add(a.ParentId);
        }
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
    for (Member_Comment__c mem : [select Id, Name,Attachment_Number__c,(SELECT Id FROM Attachments)  from Member_Comment__c where Id IN :parent]) {
        //MemberMap.get(mem.Id).Attachment_Number__c = mem.Attachments.size();
        mem.Attachment_Number__c = mem.Attachments.size();
        MemberlsttoUpdate.add(mem);
    }
    system.debug('--MemberlsttoUpdate--'+MemberlsttoUpdate);
    update MemberlsttoUpdate;
       
 
}