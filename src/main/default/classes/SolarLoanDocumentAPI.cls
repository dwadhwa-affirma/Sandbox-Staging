@RestResource(urlMapping='/SolarLoanDocumentAPI/*')
global with sharing class SolarLoanDocumentAPI {
    
      @HttpGET 
      
      //---------------------------Method to push the "Solar Loan Documents" data through RESI API-----------------------//
      
      
      global static List<SolarLoanDocumentAPIResopnse> getSolarLoanDocuemnts() {
            List<SolarLoan_Document__c> SolarLoanDocumentList = new List<SolarLoan_Document__c>();
            Map<ID,ID> cv = new Map<ID,ID>();
          	set<ID> listCD  = new set<ID>();
          
            SolarLoanDocumentList = [select Id, Name,Document_Name__c,Member_Number__c, SolarLoan_Document__c.Solar_Loans__c,Solar_Loans__r.Status__c,Attachment_Id__c,ContentDocumentLinkId__c,Document_Type__c,Move_To_OnBase_Date__c,Solar_Loans__r.Current_Solar_Loan_Stage__c 
                                    from SolarLoan_Document__c where IsMovedToOnBase__c = false and Member_Number__c !=null and (Solar_Loans__r.Current_Solar_Loan_Stage__c = 'Stage 7' OR Solar_Loans__r.Current_Solar_Loan_Stage__c = 'Stage 8')];
            
            set<string> solarids = new set<string>();
            List<SolarLoanDocumentAPIResopnse> responseObjList = new List<SolarLoanDocumentAPIResopnse>();
            
          	for(SolarLoan_Document__c SolarLoanObj : SolarLoanDocumentList){
            	solarids.add(SolarLoanObj.Solar_Loans__c );
                listCD.add(SolarLoanObj.Attachment_Id__c);
            }
                
            For(ContentVersion contentVersion : [select id,NewFile__c,ContentDocumentId from ContentVersion where ContentDocumentId in: listCD]){
        		cv.put(contentVersion.ContentDocumentId,contentVersion.id);
        	}
            
            for(SolarLoan_Document__c SolarLoanObj : SolarLoanDocumentList)
            {
                SolarLoanDocumentAPIResopnse respObj = new SolarLoanDocumentAPIResopnse();
                
                respObj.Name = (SolarLoanObj.Document_Name__c!=null)?SolarLoanObj.Document_Name__c:SolarLoanObj.Name;
                
                if(SolarLoanObj.Attachment_Id__c.startsWith('00P')){
                	respObj.AttachmentID = SolarLoanObj.Attachment_Id__c;    
                }
                else{
                	respObj.AttachmentID = cv.get(SolarLoanObj.Attachment_Id__c);    
                }
                
                respObj.DocumentType = SolarLoanObj.Document_Type__c;
                respObj.MemberNumber = SolarLoanObj.Member_Number__c;
                responseObjList.add(respObj);
            }
            
            return responseObjList;
      }
      
      @HttpPost
      
      //---------------------------Method to update the "Solar Loan Documents" data through RESI API-----------------------//
      
      global static string updateSolarLoanDocuemnts() {
        
           
            String strAttachmentIds = RestContext.request.requestBody.toString();
            List<string> IdsList = strAttachmentIds.split(',');
            set<Id> CDList = new Set<Id>();
            Datetime dt;
            Timezone tz = Timezone.getTimeZone('America/Los_Angeles');
            dt = DateTime.newInstance(System.now().getTime() + tz.getOffset(System.now()));
            List<SolarLoan_Document__c> SolarLoanDocumentList = new List<SolarLoan_Document__c>();
            List<SolarLoan_Document__c> UpdateSolarLoanDocumentList = new List<SolarLoan_Document__c>();
          	
          	For(ContentVersion contentVersion : [select id,NewFile__c,ContentDocumentId from ContentVersion where id in: IdsList]){
        		CDList.add(contentVersion.ContentDocumentId);
        	}
          
          	For(Attachment a : [select id from Attachment where id in: IdsList]){
        		CDList.add(a.id);
        	}
          
            system.debug('CDList##'+ CDList);
            SolarLoanDocumentList = [select Id, Name,Move_To_OnBase_Date__c,SolarLoan_Document__c.Solar_Loans__c,Document_Name__c, Attachment_Id__c, IsMovedToOnBase__c from SolarLoan_Document__c 
                                    where Attachment_Id__c IN: CDList];
                                          
            for(SolarLoan_Document__c SLDoc : SolarLoanDocumentList){
                SolarLoan_Document__c NewSLDoc = new SolarLoan_Document__c();
                NewSLDoc.id = SLDoc.id;
                NewSLDoc.IsMovedToOnBase__c = true;
                NewSLDoc.Move_To_OnBase_Date__c = dt;

               
                UpdateSolarLoanDocumentList.add(NewSLDoc);
            }
          
            update UpdateSolarLoanDocumentList;
            return 'Post Received ::' + strAttachmentIds + ' :: Counts ::' + SolarLoanDocumentList.size();
      }
      
      //---------------------------Details of "Solar Loan Document" which we are pushing through REST API---------------------//
      
        global class SolarLoanDocumentAPIResopnse{
            @AuraEnabled
            public string Name;
            @AuraEnabled
            public string AttachmentID;
            @AuraEnabled
            public string DocumentType;
            @AuraEnabled
            public string MemberNumber;
        }
}