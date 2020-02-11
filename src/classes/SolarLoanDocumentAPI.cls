@RestResource(urlMapping='/SolarLoanDocumentAPI/*')
global with sharing class SolarLoanDocumentAPI {
    
      @HttpGET 
      global static List<SolarLoanDocumentAPIResopnse> getSolarLoanDocuemnts() {
            List<SolarLoan_Document__c> SolarLoanDocumentList = new List<SolarLoan_Document__c>();
            
            SolarLoanDocumentList = [select Id, Name,Document_Name__c, SolarLoan_Document__c.Solar_Loans__c,Attachment_Id__c,ContentDocumentLinkId__c,Document_Type__c,Move_To_OnBase_Date__c 
                                    from SolarLoan_Document__c where IsMovedToOnBase__c = false];
            
            set<string> solarids = new set<string>();
            List<SolarLoanDocumentAPIResopnse> responseObjList = new List<SolarLoanDocumentAPIResopnse>();
            
          	for(SolarLoan_Document__c SolarLoanObj : SolarLoanDocumentList){
            	solarids.add(SolarLoanObj.Solar_Loans__c );
            }
            
            for(SolarLoan_Document__c SolarLoanObj : SolarLoanDocumentList)
            {
                SolarLoanDocumentAPIResopnse respObj = new SolarLoanDocumentAPIResopnse();
                
                respObj.Name = (SolarLoanObj.Document_Name__c!=null)?SolarLoanObj.Document_Name__c:SolarLoanObj.Name;
                respObj.AttachmentID = SolarLoanObj.Attachment_Id__c;
                respObj.DocumentType = SolarLoanObj.Document_Type__c;
                responseObjList.add(respObj);
            }
            
            return responseObjList;
      }
      
      @HttpPost
      global static string updateSolarLoanDocuemnts() {
        
           
            String strAttachmentIds = RestContext.request.requestBody.toString();
            List<string> IdsList = strAttachmentIds.split(',');
            List<SolarLoan_Document__c> SolarLoanDocumentList = new List<SolarLoan_Document__c>();
            List<SolarLoan_Document__c> UpdateSolarLoanDocumentList = new List<SolarLoan_Document__c>();
          
            system.debug('IdsList##'+ IdsList);
            SolarLoanDocumentList = [select Id, Name,SolarLoan_Document__c.Solar_Loans__c,Document_Name__c, Attachment_Id__c, IsMovedToOnBase__c from SolarLoan_Document__c 
                                    where Attachment_Id__c IN: IdsList or ContentDocumentLinkId__c IN: IdsList];
                                          
            for(SolarLoan_Document__c SLDoc : SolarLoanDocumentList){
                SolarLoan_Document__c NewSLDoc = new SolarLoan_Document__c();
                NewSLDoc.id = SLDoc.id;
                NewSLDoc.IsMovedToOnBase__c = true;
               
                UpdateSolarLoanDocumentList.add(NewSLDoc);
            }
          
            update UpdateSolarLoanDocumentList;
            return 'Post Received ::' + strAttachmentIds + ' :: Counts ::' + SolarLoanDocumentList.size();
      }
      
        global class SolarLoanDocumentAPIResopnse{
            @AuraEnabled
            public string Name;
            @AuraEnabled
            public string AttachmentID;
            @AuraEnabled
            public string DocumentType;
        }
}