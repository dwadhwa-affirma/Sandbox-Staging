@RestResource(urlMapping='/XpressRefiDocumentAPI/*')
global with sharing class XpressRefiDocumentAPI {
    @HttpGET 
      
      //---------------------------Method to push the "Xpress Refi Documents" data through RESI API-----------------------//
      
      
      global static List<XpressRefiDocumentAPIResopnse> getXpressRefiDocuments() {
            List<xPressRefi_Document__c> XpressRefiDocumentList = new List<xPressRefi_Document__c>();
            Map<ID,ID> cv = new Map<ID,ID>();
          	set<ID> listCD  = new set<ID>();
          
            XpressRefiDocumentList = [select Id, Name,Document_Name__c,Member_Number__c, xPressRefi_Document__c.xPressRefi__c,Attachment_Id__c,ContentDocumentLinkId__c,Document_Type__c,Move_To_OnBase_Date__c 
                                    from xPressRefi_Document__c where IsMovedToOnBase__c = false and Member_Number__c !=null];
            
            set<string> xpressrefiids = new set<string>();
            List<XpressRefiDocumentAPIResopnse> responseObjList = new List<XpressRefiDocumentAPIResopnse>();
            
          	for(xPressRefi_Document__c XpressRefiObj : XpressRefiDocumentList){
            	xpressrefiids.add(XpressRefiObj.xPressRefi__c);
                listCD.add(XpressRefiObj.Attachment_Id__c);
            }
                
            For(ContentVersion contentVersion : [select id,NewFile__c,ContentDocumentId from ContentVersion where ContentDocumentId in: listCD]){
        		cv.put(contentVersion.ContentDocumentId,contentVersion.id);
        	}
            
            for(xPressRefi_Document__c XpressRefiObj : XpressRefiDocumentList)
            {
                XpressRefiDocumentAPIResopnse respObj = new XpressRefiDocumentAPIResopnse();
                
                respObj.Name = (XpressRefiObj.Document_Name__c!=null)?XpressRefiObj.Document_Name__c:XpressRefiObj.Name;
                respObj.AttachmentId = cv.get(XpressRefiObj.Attachment_Id__c);
                respObj.DocumentType = XpressRefiObj.Document_Type__c;
                respObj.MemberNumber = XpressRefiObj.Member_Number__c;
                responseObjList.add(respObj);
            }
            
            return responseObjList;
      }
      
      @HttpPost
      
      //---------------------------Method to update the "Solar Loan Documents" data through RESI API-----------------------//
      
      global static string updateXpressRefiDocuments() {
        
           
            String strAttachmentIds = RestContext.request.requestBody.toString();
            List<string> IdsList = strAttachmentIds.split(',');
           	set<Id> CDList = new Set<Id>();
          
            List<xPressRefi_Document__c> XpressRefiDocumentList = new List<xPressRefi_Document__c>();
            List<xPressRefi_Document__c> UpdateXpressRefiDocumentList = new List<xPressRefi_Document__c>();
          	
          	For(ContentVersion contentVersion : [select id,NewFile__c,ContentDocumentId from ContentVersion where id in: IdsList]){
        		CDList.add(contentVersion.ContentDocumentId);
        	}
          
            system.debug('CDList##'+ CDList);
            XpressRefiDocumentList = [select Id, Name,Move_To_OnBase_Date__c,xPressRefi_Document__c.xPressRefi__c,Document_Name__c, Attachment_Id__c, IsMovedToOnBase__c from xPressRefi_Document__c 
                                    where Attachment_Id__c IN: CDList];
                                          
            for(xPressRefi_Document__c XRDoc : XpressRefiDocumentList){
                xPressRefi_Document__c NewXRDoc = new xPressRefi_Document__c();
                XRDoc.id = XRDoc.id;
                XRDoc.IsMovedToOnBase__c = true;
                XRDoc.Move_To_OnBase_Date__c = System.now();

               
                UpdateXpressRefiDocumentList.add(XRDoc);
            }
          
            update UpdateXpressRefiDocumentList;
            return 'Post Received ::' + strAttachmentIds + ' :: Counts ::' + XpressRefiDocumentList.size();
      }
      
      //---------------------------Details of "Solar Loan Document" which we are pushing through REST API---------------------//
      
        global class XpressRefiDocumentAPIResopnse{
            @AuraEnabled
            public string Name;
            @AuraEnabled
            public string AttachmentId;
            @AuraEnabled
            public string DocumentType;
            @AuraEnabled
            public string MemberNumber;
        }
}
