@RestResource(urlMapping='/OnBaseDocumentAPI/*')
global with sharing class OnBaseDocumentAPI {
    
      @HttpGET 
      global static List<OnBaseDocumentAPIResopnse> getOnBaseDocuments() {
            List<OnBase_Document__c> onbaseDocuemntList = new List<OnBase_Document__c>();
          
          DateTime dt = [select id, SelectDocumentDateTime__c from OnBase_Document_Settings__c].SelectDocumentDateTime__c;
            system.debug('cut off date is : ' + dt);          
           
          List<String> docTypeList = new List<String>{'Account Verification Documents', 'ACH Maintenance Forms', 'ACH Origination Forms', 'ACH Stop Payments',
              'Change of Address', 'Collateralized Loans', 'Correspondence', 'CTR', 'Death Certificates', 'Death Claims', 'Debit Card Dispute Forms', 
              'Declaration of Loss', 'Deletion of Owner/Member', 'Dormant Accounts and Accounts Subject to Escheatment', 'Fiduciary Accounts',
               'Inactive / Dormant Accounts', 'IRA Documents', 'Levy or Subpeona', 'Lines of Credit', 'Medallion Guarantee Documents', 'Member Identification Documents', 
              'Notice of Hold', 'Power of Attorney', 'Secured Ln', 'Signature Cards', 'Solar Secured Loans', 'Spoiled Check Letter', 'Stop Payments',
              'Trailing Documents', 'Treasury Reclamations', 'Unsecured Loans', 'W-8 and W9 Forms', 'Wire Transfers', 'Currency Transaction Reports', 'Indirect RV/Marine Loan Package'};
         
         
              onbaseDocuemntList = [select Id, Name,Document_Name__c, Attachment_Id__c,Case__c,Member_Comment__r.case__r.Account_Number__r.Name,
                                  Member_Comment__r.Case__r.CaseNumber,Case__r.CaseNumber,ContentDocumentLinkId__c,Document_Type__c,
                                  Move_To_OnBase_Date__c, Case__r.Account_Number__r.Name from OnBase_Document__c 
                                    where IsMovedToOnBase__c = false and Document_Type__c in: docTypeList and CreatedDate >: dt and
                                    (Case__c != null or (Member_Comment__c!=null and Member_Comment__r.CreatedBy.Profile.Name = 'Messaging center Customers'))];
            

            set<string> caseids = new set<string>();
            set<string> attachmentids = new set<string>();
            set<string> activeAttachmentids = new set<string>();
            map<string, OnBaseDocumentAPIResopnse> caseAccounts = new  map<string, OnBaseDocumentAPIResopnse>();
            set<string> accountsAdded = new set<string>();
           
            
             for(OnBase_Document__c onBaseObj : onbaseDocuemntList){
                 caseids.add(onBaseObj.case__c);
                 attachmentids.add(onBaseObj.Attachment_Id__c);
             }

            List<Attachment> attachmentList = [Select id, name from Attachment where Id in: Attachmentids];
            for(Attachment ac: attachmentList){
                activeAttachmentids.add(ac.id);
            }
             
             List<CaseAccountMemberDetail__c> camd = new List<CaseAccountMemberDetail__c>();
          camd = [select id,Case__c, MemberAccountid__c,  case__r.CaseNumber,case__r.OwnerId,
                case__r.Owner.Name , case__r.Status, case__r.Category__c,
                case__r.Primary_Category__c, case__r.Tertiary_Category__c,case__r.Secondary_Category__c,
                case__r.Account.Name,
                Account_Name__c, 
                case__r.Subject, case__r.Origin, case__r.ClosedDate
                 from CaseAccountMemberDetail__c where Case__c IN: caseids];
                        
            List<OnBaseDocumentAPIResopnse> responseObjList = new List<OnBaseDocumentAPIResopnse>();
            List<OnBase_Supported_Extensions__c> mcs = OnBase_Supported_Extensions__c.getall().values();
            
            for(OnBase_Document__c onBaseObj : onbaseDocuemntList)
            {
                if(ActiveAttachmentids.contains(onBaseObj.Attachment_Id__c))
                {
                    OnBaseDocumentAPIResopnse respObj = new OnBaseDocumentAPIResopnse();
                    
                    respObj.Name = (onBaseObj.Document_Name__c!=null)?onBaseObj.Document_Name__c:onBaseObj.Name;
                    respObj.AttachmentID = onBaseObj.Attachment_Id__c;
                    if(onBaseObj.case__c != null)
                    {
                        respObj.CaseNumber = String.valueOf(Integer.valueOf(onBaseObj.case__r.CaseNumber));
                        if(onBaseObj.case__r.Account_Number__r!=null)
                        {
                        respObj.AccountNumber = (onBaseObj.case__r.Account_Number__r==null)?'N/A':String.valueOf(onBaseObj.case__r.Account_Number__r.Name);
                        respObj.AccountNumber = respObj.AccountNumber.replaceFirst('^0+','');
                        system.debug('AccountNumber##'+ respObj.AccountNumber);
                                        responseObjList.add(respObj);
                                        caseAccounts.put(onBaseObj.Attachment_Id__c, respObj);
                                        accountsAdded.add(respObj.AccountNumber);
                        }
                    }
                    else
                    {
                        respObj.CaseNumber = String.valueOf(Integer.valueOf(onBaseObj.Member_Comment__r.Case__r.CaseNumber)); 
                        if(onBaseObj.Member_Comment__r.case__r.Account_Number__r != null)
                        {      
                            respObj.AccountNumber = (onBaseObj.Member_Comment__r.case__r.Account_Number__r== null)?'N/A':String.valueOf(onBaseObj.Member_Comment__r.case__r.Account_Number__r.Name);
                            respObj.AccountNumber = respObj.AccountNumber.replaceFirst('^0+','');
                            system.debug('AccountNumber##' + respObj.AccountNumber);  
                                        responseObjList.add(respObj);   
                                        caseAccounts.put(onBaseObj.Attachment_Id__c, respObj);
                                        accountsAdded.add(respObj.AccountNumber);              
                        }
                    }
                    for (OnBase_Supported_Extensions__c item : mcs)
                    {
                        if(onBaseObj.Document_Name__c.toLowerCase().endsWith('.' + item.Name.toLowerCase()))
                        {
                            
                            respObj.ExtensionNumber = item.Value__c.format();
                        }
                    }
                    if(respObj.ExtensionNumber == null || respObj.ExtensionNumber == '')
                    {
                        respObj.ExtensionNumber = 'Other';
                    }
                    //respObj.AccountNumber = String..valueOf(Integer.valueOf(OnBaseObj.case__r.Account_Number__r.Name));
                    respObj.DocumentType = onBaseObj.Document_Type__c;
                
                }
            }
            
            for(OnBase_Document__c onBaseObj : onbaseDocuemntList)
            { 
                if(ActiveAttachmentids.contains(onBaseObj.Attachment_Id__c))
                {
                    if(onBaseObj.case__c != null && onBaseObj.case__r.Account_Number__r!=null){
                    for(CaseAccountMemberDetail__c c: camd){
                            OnBaseDocumentAPIResopnse res = caseAccounts.get(onBaseObj.Attachment_Id__c);
                            system.debug('c===' + c.Account_Name__c);
                            system.debug('res.AccountNumber===' + res.AccountNumber);
                            system.debug('OnBaseObj.case__c===' + onBaseObj.case__c);
                            if(onBaseObj.case__c == c.case__c && onBaseObj.case__r.Account_Number__r.Name != c.Account_Name__c){
                                OnBaseDocumentAPIResopnse respObj = new OnBaseDocumentAPIResopnse();
                                respObj.Name = (onBaseObj.Document_Name__c!=null)?onBaseObj.Document_Name__c:onBaseObj.Name;
                                respObj.AttachmentID = onBaseObj.Attachment_Id__c;
                                respObj.CaseNumber = String.valueOf(Integer.valueOf(onBaseObj.case__r.CaseNumber));
                                respObj.AccountNumber = c.Account_Name__c;
                                respObj.AccountNumber = respObj.AccountNumber.replaceFirst('^0+','');
                                for (OnBase_Supported_Extensions__c item : mcs)
                                    {
                                        if(onBaseObj.Document_Name__c.toLowerCase().endsWith('.' + item.Name.toLowerCase()))
                                        {                                
                                            respObj.ExtensionNumber = item.Value__c.format();
                                        }
                                    }
                                    if(respObj.ExtensionNumber == null || respObj.ExtensionNumber == '')
                                    {
                                        respObj.ExtensionNumber = 'Other';
                                    }
                                respObj.DocumentType = onBaseObj.Document_Type__c;
                                responseObjList.add(respObj);
                            }
                        
                    }
                }
            }
            }
                     
            
            return responseObjList;
      }
    
     
    
    

      
      @HttpPost
      global static string updateOnBaseDocuemnts() {
        
            //Map<string,string> request1  = System.currentPageReference().getParameters();
            String strAttachmentIds = RestContext.request.requestBody.toString();
            List<string> idsList = strAttachmentIds.split(',');
            List<OnBase_Document__c> onbaseDocuemntList = new List<OnBase_Document__c>();
            List<OnBase_Document__c> memberCommentOnbaseDocuemntList = new List<OnBase_Document__c>();
            List<OnBase_Document__c> memberCommentOnbaseDocuemntListToUpdate = new List<OnBase_Document__c>();
            system.debug('idsList##'+ idsList);            
          
            DateTime dt = [select id, SelectDocumentDateTime__c from OnBase_Document_Settings__c].SelectDocumentDateTime__c;
            system.debug('cut off date is : ' + dt);          
           
            List<String> docTypeList = new List<String>{'Account Verification Documents', 'ACH Maintenance Forms', 'ACH Origination Forms', 'ACH Stop Payments',
              'Change of Address', 'Collateralized Loans', 'Correspondence', 'CTR', 'Death Certificates', 'Death Claims', 'Debit Card Dispute Forms', 
              'Declaration of Loss', 'Deletion of Owner/Member', 'Dormant Accounts and Accounts Subject to Escheatment', 'Fiduciary Accounts',
               'Inactive / Dormant Accounts', 'IRA Documents', 'Levy or Subpeona', 'Lines of Credit', 'Medallion Guarantee Documents', 'Member Identification Documents', 
              'Notice of Hold', 'Power of Attorney', 'Secured Ln', 'Signature Cards', 'Solar Secured Loans', 'Spoiled Check Letter', 'Stop Payments',
              'Trailing Documents', 'Treasury Reclamations', 'Unsecured Loans', 'W-8 and W9 Forms', 'Wire Transfers', 'Currency Transaction Reports', 'Indirect RV/Marine Loan Package'};

            onbaseDocuemntList = [select Id, Name,Document_Name__c, Attachment_Id__c, IsMovedToOnBase__c, Case__c, Case__r.CaseNumber 
                                    from OnBase_Document__c 
                                    where Attachment_Id__c IN: idsList or ContentDocumentLinkId__c IN: idsList];
                                    
            memberCommentOnbaseDocuemntList = [select Id, Name,Document_Name__c,Member_Comment__r.Case__c 
                                    from OnBase_Document__c 
                                    where IsMovedToOnBase__c = false and Document_Type__c in: docTypeList and CreatedDate >: dt
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