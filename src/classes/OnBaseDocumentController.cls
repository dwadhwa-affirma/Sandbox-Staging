public with sharing class OnBaseDocumentController {
    @AuraEnabled
	public static caseAttachments getAttachmentData(String caseId)
	{	      
		List<OnBase_Supported_Extensions__c> supportedExtSetting = OnBase_Supported_Extensions__c.getall().values();
		set<string> supportedFileExtSet = new set<string>();
		for(OnBase_Supported_Extensions__c extObj : supportedExtSetting){
			supportedFileExtSet.Add(extObj.Name);
		}
		
		//system.debug('supportedFileExtList::'+supportedFileExtSet);  
		List<Attachment> CaseAttachmentLst = new List<Attachment>();
		List<ContentDocumentLink> ContentDocumentLst = new List<ContentDocumentLink>(); 
		List<OnBaseAttachments> onbaseDocumentList = new List<OnBaseAttachments>();
		Boolean IsInValidDocumentAvailable = false;
		string caseNum = '';
        If(caseId != null){        
            Case c = [select CaseNumber from case where id =: caseId limit 1];            
            caseNum = c.caseNumber;            
            CaseAttachmentLst = [SELECT Id, Name,  ContentType FROM Attachment WHERE Parentid =:caseId AND createdby.Profile.UserLicense.LicenseDefinitionKey = 'SFDC'];
          
            List<OnBase_Document__c> documentList = [select Id, Name, Attachment_Id__c,Document_Type__c,IsMovedToOnBase__c,Attachment_Created_On__c from OnBase_Document__c where (Case__c =:caseId or Member_Comment__r.Case__C =: caseId) and IsMovedToOnBase__c =: false];
            for(OnBase_Document__c onbaseAttch : documentList){            	
            	OnBaseAttachments obj = new OnBaseAttachments();
            	obj.Id = onbaseAttch.Id;
            	obj.Name = onbaseAttch.Name;
            	obj.DocumentType = onbaseAttch.Document_Type__c;
            	obj.IsMovedToOnBase = onbaseAttch.IsMovedToOnBase__c;
            	obj.downloadLink = '/servlet/servlet.FileDownload?file='+ string.valueOf(onbaseAttch.Attachment_Id__c) +'&operationContext=S1';
            	obj.LastModifiedDate = onbaseAttch.Attachment_Created_On__c.format('MM/dd/yyyy');
            	if(supportedFileExtSet.contains(onbaseAttch.Name.substringAfterLast('.').toLowerCase()) || supportedFileExtSet.contains(onbaseAttch.Name.substringAfterLast('.').toUpperCase())){
            		obj.IsOnBaseSupportedFile = true;
            	}else{
            		obj.IsOnBaseSupportedFile = false;
            	}
            	//system.debug('IsOnBaseSupportedFile :: '+obj.IsOnBaseSupportedFile);
            	if(IsInValidDocumentAvailable == false && obj.IsOnBaseSupportedFile == false){
            		IsInValidDocumentAvailable = true;
            	}
            	onbaseDocumentList.add(obj);            	           	
            }
            
        }
        
    
		caseAttachments objCaseAttach = new caseAttachments();
		//objCaseAttach.attachments = wrapperLst;
		objCaseAttach.caseNumber = caseNum;
		//objCaseAttach.approvalids = approvalIds;
		objCaseAttach.onbaseDocuments = onbaseDocumentList;
		objCaseAttach.IsInValidDocumentAvailable = IsInValidDocumentAvailable;
        //system.debug('10 ===' + objCaseAttach);
       // objCaseAttach.supportedFileExtList = supportedFileExtSet;
		return objCaseAttach;
	}
	
    @AuraEnabled
	public static void saveAttachments(string wrapperString, string caseId,List<string> approvalids){
		system.debug('ApprovalIDs :: '+approvalids);
		List<OnBaseAttachments> onbaseAttachList = (List<OnBaseAttachments>)JSON.deserialize(wrapperString, List<OnBaseAttachments>.class);		
       
        
        //Map<Id,OnBaseAttachments> onbaseWrapperMap = new Map<Id,OnBaseAttachments>();
        List<OnBase_Document__c> onbaseListToInsert = new List<OnBase_Document__c>();
        //set <Id> aIdchecked = new set <Id>();
        //set <string> unchecked = new set <string>();
        
        if(onbaseAttachList.size () > 0 && onbaseAttachList != null){
	        
	        for(OnBaseAttachments onbaseObj : onbaseAttachList){  
	        	system.debug('DocumentType :: '+onbaseObj.DocumentType);              	
	            //if(onbaseObj.DocumentType != ''){  
                    //system.debug('In If :: ');              	
	                //onbaseWrapperMap.put(onbaseObj.id,onbaseObj);
                    OnBase_Document__c onbaseDocObj = new OnBase_Document__c();
                    onbaseDocObj.Id = onbaseObj.id;
                    onbaseDocObj.Document_Type__c = onbaseObj.DocumentType;
                    onbaseDocObj.Move_To_OnBase_Date__c = system.now();
                    
                    onbaseListToInsert.add(onbaseDocObj);
	                //attachmentDetails.put(wrap.attachmentobj.id,wrap.attachmentobj);
	           // }
	            //else{        
	            //    //unchecked.add(wrap.attachmentobj.id);
	            //}
    		}
            system.debug('onbaseListToInsert :: '+onbaseListToInsert);              	
            update onbaseListToInsert;
         
         }
                
    } 
    
    public class OnBaseAttachments{
		@AuraEnabled
        public string Id {get;set;}
        @AuraEnabled         
        public string Name {get;set;}
        @AuraEnabled         
        public string DocumentType {get;set;}        
        @AuraEnabled         
        public boolean IsMovedToOnBase {get;set;}
        @AuraEnabled
        public string downloadLink{get;set;}
        @AuraEnabled
		public string LastModifiedDate;
		@AuraEnabled
		public boolean IsOnBaseSupportedFile {get;set;}
    } 
   
    
    public class caseAttachments{
        @AuraEnabled         
        public List<OnBaseAttachments> onbaseDocuments {get;set;}
        @AuraEnabled                
        public String caseNumber {get;set;}
        @AuraEnabled         
        public set<id> approvalids {get;set;}
        @AuraEnabled         
        public Boolean IsInValidDocumentAvailable {get;set;}
    }
    
    @AuraEnabled
	public static Map<String, Map<String, List<String>>> getPicklistValues(String objpicklistFieldsMap)
	{
        //System.Debug('objpicklistFieldsMap Value' + objpicklistFieldsMap);
		Map<String, List<String>> objPickmap = (Map<String, List<String>>)JSON.deserialize(objpicklistFieldsMap, Map<String, List<String>>.class);
		//system.debug('objpickmap ' + objPickmap);
		 
		Map<String, Map<String, List<String>>> objFieldPicklistMap = new Map<String, Map<String, List<String>>>();
		List<String> sobjectslist = new List<String>(objPickmap.keySet());
		Schema.DescribeSobjectResult[] results = Schema.describeSObjects(sobjectslist);
		Map<String, List<String>> fieldOptionsMap;
		//system.debug('results---' + results);
		for(Schema.DescribeSObjectResult result : results)
		{
			fieldOptionsMap = new Map<String, List<String>>();
			 //system.debug('result123---' + result);
			Schema.sObjectType objType = result.getSObjectType();
			 
			Schema.DescribeSObjectResult objDescribe = objType.getDescribe();
			map<String, Schema.SObjectField> fieldMap = objDescribe.fields.getMap();
			List<String> objFieldlist = objPickmap.get(result.getName());
			//system.debug('objname ' + result.getName());
			//system.debug('list of fields ' + objFieldlist);
			for(String fld : objFieldlist)
			{
				//system.debug('fields ' + fld);
				List<String > allOpts = new list<String>();
				list<Schema.PicklistEntry> values =
				fieldMap.get(fld).getDescribe().getPickListValues();
				 
				for (Schema.PicklistEntry a : values)
				{
					allOpts.add(a.getValue());
				}
				fieldOptionsMap.put(fld, allOpts);
			}
			
			objFieldPicklistMap.put(result.getName(), fieldOptionsMap);
		}
		return objFieldPicklistMap;
	}
}