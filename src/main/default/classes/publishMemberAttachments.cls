public without sharing class publishMemberAttachments {
	
    @AuraEnabled
	public static caseAttachments getAttachmentData(String caseId)
	{	        
		
	
			List<Attachment> CaseAttachmentLst = new List<Attachment>();
			//List<ContentDocumentLink> ContentDocumentLst = new List<ContentDocumentLink>(); 
			List<combinedAttachments> combinedAttachmentsLst = new List<combinedAttachments>(); 
			string caseNum = '';
	        If(caseId != null){        
	            Case c = [select CaseNumber from case where id =: caseId limit 1];            
	            caseNum = c.caseNumber;            
	            CaseAttachmentLst = [SELECT Id, Name,  ContentType FROM Attachment WHERE Parentid =:caseId AND createdby.Profile.UserLicense.LicenseDefinitionKey = 'SFDC'];
	             system.debug('CaseAttachmentLst ===' + CaseAttachmentLst);
	            for(Attachment attach : CaseAttachmentLst){            	
	            	combinedAttachments obj = new combinedAttachments();
	            	obj.Id = attach.id;
	            	obj.Name = attach.Name;
	            	obj.ContentType = attach.ContentType;
	            	obj.isContentDocument = false;
	            	obj.downloadLink = '/servlet/servlet.FileDownload?file='+ string.valueOf(attach.id) +'&operationContext=S1';
	            	combinedAttachmentsLst.add(obj);            	           	
	            }            
	            
	          /*  ContentDocumentLst = [select Id, ContentDocumentId, ContentDocument.Title, ContentDocument.FileType from ContentDocumentLink where LinkedEntityId =:caseId];
	            
	            for(ContentDocumentLink attachContent : ContentDocumentLst){            	
	            	combinedAttachments obj = new combinedAttachments();
	            	obj.Id = attachContent.id;
	            	obj.Name = attachContent.ContentDocument.Title;
	            	obj.ContentType = attachContent.ContentDocument.FileType;
	            	obj.isContentDocument = true;
	            	obj.downloadLink = '/sfc/servlet.shepherd/document/download/'+ string.valueOf(attachContent.ContentDocumentId);
	            	combinedAttachmentsLst.add(obj);            	           	
	            }*/
	            
	        }
	        
	        List<attachmentWrapper> wrapperLst = new List<attachmentWrapper>();
	        set<id> approvalids = new set<id>();
	                
	        if(combinedAttachmentsLst != null && combinedAttachmentsLst.size() > 0 ){            
	            
	            List<Approve_Attachment__c> approvedLst = new List<Approve_Attachment__c>();
	            approvedLst = [select id,Case_ID__c,Attachment_Id__c, ContentDocumentLinkId__c from Approve_Attachment__c where Case_ID__c = : caseId AND (Attachment_Id__c  != Null OR ContentDocumentLinkId__c != null)];
	            
	            if(approvedLst.size() > 0 && approvedLst != null){              
	                for(Approve_Attachment__c ap: approvedLst){
	                	if(ap.Attachment_Id__c != null)
	                	{
	                		try{
	                			approvalids.add(ap.Attachment_Id__c);
	                		}
	                		catch(exception ex)
	                		{
	                			
	                		}
	                	}
	                	else
	                	{
	                		try{
	                			approvalids.add(ap.ContentDocumentLinkId__c);
	                		}
	                		catch(exception ex)
	                		{
	                			
	                		}
	                	}                    
	                }
	            }
	            
	            for(combinedAttachments c : combinedAttachmentsLst){
	                attachmentWrapper wrapobj = new attachmentWrapper(); 
	                wrapobj.attachmentobj = c;
	                
	                if(!approvalIds.isEmpty()){
	                    if(approvalids.contains(c.id)){                                            
	                        wrapobj.checkvalue = true;
	                    }
	                }
	                else if(!approvalids.contains(c.id)){                    
	                    wrapobj.checkvalue = false;                    
	                }          
	                wrapperLst.add(wrapobj);
	            }  
			}
			
			caseAttachments objCaseAttach = new caseAttachments();
			objCaseAttach.attachments = wrapperLst;
			objCaseAttach.caseNumber = caseNum;
			objCaseAttach.approvalids = approvalIds;
	        system.debug('10 ===' + objCaseAttach);
	        return objCaseAttach;
		
	}
	
    @AuraEnabled
	public static void saveAttachments(string wrapperString, string caseId,List<string> approvalids){
		
	List<attachmentWrapper> wrapperLst =	(List<attachmentWrapper>)JSON.deserialize(wrapperString, List<attachmentWrapper>.class);		
        set<string> Setapprovalids = new set<string> (); 
        for(string str: approvalids)
        {
        	Setapprovalids.add(str);
        	
        }
        
        Map<Id,combinedAttachments> attachmentDetails = new Map<Id,combinedAttachments>();
          
        //set <Id> aIdchecked = new set <Id>();
        set <string> unchecked = new set <string>();
            if(wrapperLst.size () > 0 && wrapperLst != null){
                for(attachmentWrapper wrap : wrapperLst){                	
                    if(wrap.checkvalue == true){  
                        attachmentDetails.put(wrap.attachmentobj.id,wrap.attachmentobj);
                    }
                    else{        
                        unchecked.add(wrap.attachmentobj.id);
                    }
                }
                
                
                if(!attachmentDetails.isEmpty()){
                    List<Approve_Attachment__c> listToInsert  = new List<Approve_Attachment__c>();
                    for(Id s : attachmentDetails.keySet()){  
                        if(!Setapprovalids.contains(s)){ // if checked in page and not found in exisiting then only insert
                            Approve_Attachment__c obj = new Approve_Attachment__c();
                            obj.Case_ID__c = caseId;
                            combinedAttachments objCombined = new combinedAttachments();
                            objCombined = attachmentDetails.get(s);
                            if(objCombined.isContentDocument)
                            {
                            	obj.ContentDocumentLinkId__c = objCombined.Id;
                            }
                            else
                            {
                            	obj.Attachment_Id__c = objCombined.Id;
                            }                            
                            
                            obj.Approved_By__c = UserInfo.getUserId();
                            
                            obj.Attachment_Name__c = objCombined.Name;                            
                            obj.Approved_Date_Time__c = system.now();
                            
                            listToInsert.add(obj);                            
                        }
                    }
                    if(!listToInsert.isEmpty()){
                        insert listToInsert;
                    }
                }
                
                if(!unchecked.isEmpty()){
                Set<Id> attToDelete = new Set<Id>();                
                    for(string s : unchecked){
                    	system.debug('6=== '+approvalids);
                        if(Setapprovalids.contains(s)){ // if unchecked in page and exist in object then delete                        	
                            attToDelete.add(s);
                        }
                    }
                    system.debug('7=== '+attToDelete);
                    if(!attToDelete.isEmpty()){
                        List<Approve_Attachment__c> listToDelete = [select id,Case_ID__c,Attachment_Id__c from Approve_Attachment__c where Attachment_Id__c IN : attToDelete or ContentDocumentLinkId__c IN :attToDelete];
                            if(!listToDelete.isEmpty()){
                                DELETE listToDelete;
                            }                   
                    }            
                }           
             }
        
                
    } 
    
    public class combinedAttachments{
		@AuraEnabled
        public string Id {get;set;}
        @AuraEnabled         
        public string Name {get;set;}
        @AuraEnabled         
        public string ContentType {get;set;}        
        @AuraEnabled         
        public boolean isContentDocument {get;set;}
        @AuraEnabled
        public string downloadLink{get;set;}
    } 
	
	public class attachmentWrapper{
		@AuraEnabled
        public combinedAttachments attachmentobj {get;set;}
        @AuraEnabled         
        public Boolean checkvalue {get;set;}        
    }
    
    public class caseAttachments{
    	@AuraEnabled         
        public List<attachmentWrapper> attachments {get;set;}
        @AuraEnabled                
        public String caseNumber {get;set;}
        @AuraEnabled         
        public set<id> approvalids {get;set;}
    }
}