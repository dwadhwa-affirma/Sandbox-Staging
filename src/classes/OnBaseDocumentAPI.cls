@RestResource(urlMapping='/OnBaseDocumentAPI/*')
global with sharing class OnBaseDocumentAPI {
    
      @HttpGET 
      global static List<OnBaseDocumentAPIResopnse> getOnBaseDocuemnts() {
            List<OnBase_Document__c> onbaseDocuemntList = new List<OnBase_Document__c>();
            
            onbaseDocuemntList = [select Id, Name,Document_Name__c, Attachment_Id__c,Case__c,Member_Comment__r.case__r.Account_Number__r.Name,Member_Comment__r.Case__r.CaseNumber, Case__r.CaseNumber,ContentDocumentLinkId__c,Document_Type__c,Move_To_OnBase_Date__c, Case__r.Account_Number__r.Name 
                                    from OnBase_Document__c 
                                    where IsMovedToOnBase__c = false and Document_Type__c != 'Not For OnBase' and Document_Type__c != '' 
                                    and (Case__c != null or (Member_Comment__c!=null and Member_Comment__r.CreatedBy.Profile.Name = 'Messaging center Customers'))];
            //system.debug('onbaseDocuemntList :: ' + onbaseDocuemntList[0].case__r);
            //system.debug('Account_Number__r :: ' + onbaseDocuemntList[0].case__r.Account_Number__r.Name);
                        
            List<OnBaseDocumentAPIResopnse> responseObjList = new List<OnBaseDocumentAPIResopnse>();
            List<OnBase_Supported_Extensions__c> mcs = OnBase_Supported_Extensions__c.getall().values();
            
            for(OnBase_Document__c OnBaseObj : onbaseDocuemntList)
            {
                OnBaseDocumentAPIResopnse respObj = new OnBaseDocumentAPIResopnse();
                
                respObj.Name = (OnBaseObj.Document_Name__c!=null)?OnBaseObj.Document_Name__c:OnBaseObj.Name;
                respObj.AttachmentID = OnBaseObj.Attachment_Id__c;
                if(OnBaseObj.case__c != null)
                {
                    respObj.CaseNumber = String.valueOf(Integer.valueOf(OnBaseObj.case__r.CaseNumber));
                    if(OnBaseObj.case__r.Account_Number__r!=null)
                    {
                    respObj.AccountNumber = (OnBaseObj.case__r.Account_Number__r==null)?'N/A':String.valueOf(Integer.valueOf(OnBaseObj.case__r.Account_Number__r.Name));
                                    responseObjList.add(respObj);
                    }
                }
                else
                {
                    respObj.CaseNumber = String.valueOf(Integer.valueOf(OnBaseObj.Member_Comment__r.Case__r.CaseNumber)); 
                    if(OnBaseObj.Member_Comment__r.case__r.Account_Number__r != null)
                    {      
                    respObj.AccountNumber = (OnBaseObj.Member_Comment__r.case__r.Account_Number__r== null)?'N/A':String.valueOf(Integer.valueOf(OnBaseObj.Member_Comment__r.case__r.Account_Number__r.Name));  
                                    responseObjList.add(respObj);                 
                    }
                }
                for (OnBase_Supported_Extensions__c item : mcs)
                {
                    if(OnBaseObj.Document_Name__c.toLowerCase().endsWith('.' + item.Name.toLowerCase()))
                    {
                        
                        respObj.ExtensionNumber = item.Value__c.format();
                    }
                }
                if(respObj.ExtensionNumber == null || respObj.ExtensionNumber == '')
                {
                    respObj.ExtensionNumber = 'Other';
                }
                //respObj.AccountNumber = String..valueOf(Integer.valueOf(OnBaseObj.case__r.Account_Number__r.Name));
                respObj.DocumentType = OnBaseObj.Document_Type__c;
                
                
            }
            return responseObjList;
      }
      
      @HttpPost
      global static string updateOnBaseDocuemnts() {
        
            //Map<string,string> request1  = System.currentPageReference().getParameters();
            String strAttachmentIds = RestContext.request.requestBody.toString();
            List<string> IdsList = strAttachmentIds.split(',');
            List<OnBase_Document__c> onbaseDocuemntList = new List<OnBase_Document__c>();
            List<OnBase_Document__c> memberCommentOnbaseDocuemntList = new List<OnBase_Document__c>();
            List<OnBase_Document__c> memberCommentOnbaseDocuemntListToUpdate = new List<OnBase_Document__c>();
            onbaseDocuemntList = [select Id, Name,Document_Name__c, Attachment_Id__c, IsMovedToOnBase__c, Case__c, Case__r.CaseNumber 
                                    from OnBase_Document__c 
                                    where Attachment_Id__c IN: IdsList or ContentDocumentLinkId__c IN: IdsList];
                                    
            memberCommentOnbaseDocuemntList = [select Id, Name,Document_Name__c,Member_Comment__r.Case__c 
                                    from OnBase_Document__c 
                                    where IsMovedToOnBase__c = false and Document_Type__c != 'Not For OnBase' and Document_Type__c != '' 
                                    and Member_Comment__c != null and Member_Comment__r.CreatedBy.Profile.Name != 'Messaging center Customers'];
                                    
            for(OnBase_Document__c onbaseDoc : onbaseDocuemntList){
                onbaseDoc.IsMovedToOnBase__c = true;
                
                for (OnBase_Document__c memberDocOnBase : memberCommentOnbaseDocuemntList){
                	system.debug('Checking memberDocOnBase :: '+onbaseDoc.Case__c);
                	system.debug('member comment case id::'+memberDocOnBase.Member_Comment__r.Case__c);
                	if(onbaseDoc.Case__c != null && onbaseDoc.Case__c == memberDocOnBase.Member_Comment__r.Case__c && onbaseDoc.Document_Name__c == memberDocOnBase.Document_Name__c){
                		memberDocOnBase.IsMovedToOnBase__c = true;
                		memberCommentOnbaseDocuemntListToUpdate.add(memberDocOnBase);
                		system.debug('memberDocOnBase.ID :: '+memberDocOnBase.ID);
                		break;
                	}
                }
            }
            update onbaseDocuemntList;
            update memberCommentOnbaseDocuemntListToUpdate;
            return 'Post Received ::' + strAttachmentIds + ' :: Counts ::' + onbaseDocuemntList.size();
      }
      
        global class OnBaseDocumentAPIResopnse{
            @AuraEnabled
            public string Name;
            @AuraEnabled
            public string AttachmentID;
            @AuraEnabled
            public string CaseNumber;
            @AuraEnabled
            public string AccountNumber;
            @AuraEnabled
            public string DocumentType;
            @AuraEnabled
            public string ExtensionNumber;
        }
}