public without sharing class MemberCommentsController {
	
	@AuraEnabled
	 public static wrapperObject getBasicDetails(string caseId)
	 {	 	
	 	  List<Case> tempCase = new List<Case>();        
		  List<Account_Details__c> objAccount = new List<Account_Details__c>();
		  List<Member_Comment__c> objMemberComment = new List<Member_Comment__c>();
		  tempCase = [select id,Account_Number__c, AccountId, CreatedBy.Email,Secure_Email__c from case where id =:caseId];
		  
		  wrapperObject wrapperobj = new wrapperObject();		  
		  
		  
		    if(!Schema.sObjectType.Canned_Responses__c.isCreateable())
			{
					system.debug('Object not accessible');
					wrapperobj.isObjectAccess = true;
					//return wrapperobj;
			}	
			else
			{
				wrapperobj.isObjectAccess = true;
			}  
			
			if (Schema.sObjectType.Member_Comment__c.fields.CU_Read__c.isUpdateable()) {
   					wrapperobj.isCUReadEditable = true;
			}
			
			else
			{
				wrapperobj.isCUReadEditable = false;
			}
		  if(tempCase != null && tempCase.size()> 0)
		  {
		  		wrapperobj.memberComment = new Member_Comment__c();
		  		wrapperobj.memberComment.case__c  = caseId;
		  		wrapperobj.memberComment.Draft__c  = false;
		  		wrapperobj.memberComment.Member_Communication__c  = '';		
		  		wrapperobj.memberComment.CU_Read__c  = false;
		  		wrapperobj.isEdit = false;	
		  		
		  		
		  		objAccount =  [Select id,Brand__c, SecureEmailAddress__c FROM Account_Details__c Where ID =: tempCase[0].Account_Number__c];
		  		
		  	   
		  } 
		  else
		  {		  	
		  	   wrapperobj.memberComment = [select id, case__c, Draft__c,Member_Communication__c, Member_Comment__c, CU_Read__c from Member_Comment__c where id =:caseId];		  	  
		  	   tempCase = [select id,Account_Number__c, AccountId, CreatedBy.Email,Secure_Email__c from case where id =:wrapperobj.memberComment.case__c];		  	  	   
		  	   objAccount =  [Select id,Brand__c, SecureEmailAddress__c FROM Account_Details__c Where ID =: tempCase[0].Account_Number__c];
		  	   wrapperobj.isEdit = true; 
		  	    
		  	  
		  }		 
		  wrapperobj.Secure_Email = tempCase[0].Secure_Email__c == null? '' : tempCase[0].Secure_Email__c;
		  if(objAccount.size() > 0){
		   wrapperobj.AccObj = objAccount[0];
		  }
		  else{		  	
		  		  	wrapperobj.Secure_Email  = '';
		  }
		  
			return wrapperobj ;
	 }
	 
	
	@AuraEnabled
	public static object getAttachmentDetails(string caseId)
	{		     
		string membercommentid = '';
		List<Case> tempCase = [select id,Account_Number__c, AccountId, CreatedBy.Email from case where id =:caseId];
		if(tempCase == null || tempCase.Size() == 0)
		{
			Member_Comment__c memberComment = [select id, case__c, Draft__c from Member_Comment__c where id =:caseId];
			caseid = memberComment.case__c;
			membercommentid = memberComment.id;
		}
		
		publishMemberAttachments.caseAttachments objCaseAttach = new publishMemberAttachments.caseAttachments();
		objCaseAttach = publishMemberAttachments.getAttachmentData(caseId);		
		
		
		List<publishMemberAttachments.attachmentWrapper> objCheckedCaseAttach = new List<publishMemberAttachments.attachmentWrapper>();
		for(publishMemberAttachments.attachmentWrapper ca: objCaseAttach.attachments){
						
			if(objCaseAttach.approvalids.contains(ca.attachmentobj.id)){
				ca.checkvalue = false;
				objCheckedCaseAttach.add(ca);
			}            
        }
        if(membercommentid != '')
        {
        	List<Attachment> CaseAttachmentLst = [SELECT Id, Name,  ContentType FROM Attachment WHERE Parentid =:membercommentid AND createdby.Profile.UserLicense.LicenseDefinitionKey = 'SFDC'];
        	List<ContentDocumentLink> ContentDocumentLst = [select Id, ContentDocumentId, ContentDocument.Title, ContentDocument.FileType from ContentDocumentLink where LinkedEntityId =:membercommentid];
        	for(publishMemberAttachments.attachmentWrapper itemApproved : objCheckedCaseAttach )
        	{
        		for(Attachment commentAttachment: CaseAttachmentLst){
        			if(commentAttachment.Name == itemApproved.attachmentobj.Name)
        			{
        				itemApproved.checkvalue = true;
        				
        			}
        		}
        		for(ContentDocumentLink commentAttachment: ContentDocumentLst){
        			if(commentAttachment.ContentDocument.Title == itemApproved.attachmentobj.Name)
        			{
        				itemApproved.checkvalue = true;
        				
        			}
        		}
        		
        	}
        	
        	
        
        
        }
        
		return objCheckedCaseAttach;	
	}
	
	
	
	@AuraEnabled
	public static List<string> getPrimaryData(string brand)
	{	
			     
		List<Canned_Responses__c> primary = new List<Canned_Responses__c>();
        primary = [select id, Primary_Lookup_Text__c from Canned_Responses__c where Brand__c =:brand and Active__c = true and Primary_Lookup_Text__c != ''];
        
        set<String> uniques = new set<String>();        
        for(Canned_Responses__c c: primary){
            uniques.add(c.Primary_Lookup_Text__c);
        }            	
        
    	List<string> strData = new List<string>(); 
        for(string str : uniques)
        {
        	strData.add(str);
        }
        return strData;
	}
	
	@AuraEnabled
	public static List<string> getSecondaryData(string brand, string primaryText)
	{		     
		List<Canned_Responses__c> secondary = new List<Canned_Responses__c>();
		
		if(primaryText != null){
            secondary = [select id, Secondary_Lookup_Text__c from Canned_Responses__c where Brand__c =:brand and Active__c = true and Primary_Lookup_Text__c = :primaryText and Secondary_Lookup_Text__c != ''];                        
        }
        
        set<String> uniques = new set<String>();
        for(Canned_Responses__c c: secondary){
                uniques.add(c.Secondary_Lookup_Text__c);        
       	}
        
        List<string> strData = new List<string>(); 
        for(string str : uniques)
        {
        	strData.add(str);
        }
        return strData;
	}
	
	@AuraEnabled
	public static List<string> getTertioryData(string brand, string primaryText, string secondaryText)
	{		     
		List<Canned_Responses__c> tertiary = new List<Canned_Responses__c>();
		
		if(secondaryText != null){
            tertiary = [select id, Tertiary_Lookup_Text__c from Canned_Responses__c where Brand__c =:brand and Active__c = true and Primary_Lookup_Text__c = :primaryText and Secondary_Lookup_Text__c =:secondaryText and Tertiary_Lookup_Text__c != ''];                        
        }
        
        set<String> uniques = new set<String>();
        for(Canned_Responses__c c: tertiary){
                uniques.add(c.Tertiary_Lookup_Text__c);        
		}
        List<string> strData = new List<string>(); 
        for(string str : uniques)
        {
        	strData.add(str);
        }
        return strData;
	}
	
	@AuraEnabled
	public static List<Canned_Responses__c> getItembySearchText(string brand, string searchText)
	{		     
		List<Canned_Responses__c> output = new List<Canned_Responses__c>();
        if(brand.length()<1){  
            brand = 'Chevron';   
        }
        String queryString = 'Select id, Description__c,Canned_Response_Title__c,Brand__c from Canned_Responses__c where Active__c = true and Brand__c =\''+brand+'\''+' and (Primary_Lookup_Text__c like \'%'+searchText+'%\' OR Secondary_Lookup_Text__c like \'%'+searchText+'%\' OR Tertiary_Lookup_Text__c like \'%'+searchText+'%\' OR Canned_Response_Title__c like \'%'+searchText+'%\')';
        system.debug(querystring);
        output = Database.query(queryString);
        return output;        
	}
	
	@AuraEnabled
	public static List<Canned_Responses__c> getItembyCategories(string brand, string selectedPrimary, string selectedSecondary, string selectedTertiary)
	{		     
		List<Canned_Responses__c> output = new List<Canned_Responses__c>();        
        if(selectedPrimary != null && (selectedSecondary == null || selectedSecondary == '0') && (selectedTertiary == null || selectedTertiary == '0') && selectedPrimary != '0' ){
            system.debug('inside first if');
            output = [Select id, Description__c,Canned_Response_Title__c,Brand__c from Canned_Responses__c where Brand__c =:brand and Active__c = true and Primary_Lookup_Text__c = :selectedPrimary];
            system.debug('output...'+output);
        }
        else 
        if(selectedPrimary != null && selectedSecondary != null && (selectedTertiary == null || selectedTertiary == '0') && selectedPrimary != '0' && selectedSecondary != '0'){
            system.debug('inside second if');
            output = [Select id, Description__c,Canned_Response_Title__c,Brand__c from Canned_Responses__c where Brand__c =:brand and Active__c = true and Primary_Lookup_Text__c = :selectedPrimary and Secondary_Lookup_Text__c =:selectedSecondary];
            system.debug('output...'+output);
           }
           else{
            output = [Select id, Description__c,Canned_Response_Title__c,Brand__c from Canned_Responses__c where Brand__c = :brand and Active__c = true and Primary_Lookup_Text__c = :selectedPrimary and Secondary_Lookup_Text__c =:selectedSecondary and Tertiary_Lookup_Text__c = :selectedTertiary];
        }
        return output;
	}
	
	@AuraEnabled
	public static string getSelectedDecription(string CategoryId, string Brand)	
	{
		string chosenDescription = '';
		Canned_Responses__c c = new Canned_Responses__c(); 
		c = [Select id, Description__c,Canned_Response_Title__c,Brand__c from Canned_Responses__c where Id =: CategoryId];            
	    chosenDescription = '<p class="message_body">' + c.Description__c + '</p>';
	        
	    Canned_Message_Metadata__c cannedMessageHeader = new Canned_Message_Metadata__c();
	    cannedMessageHeader = [Select id, Chevron_Footer__c, Chevron_Header__c, Spectrum_Footer__c, Spectrum_Header__c from Canned_Message_Metadata__c limit 1];	        
	    if (cannedMessageHeader != null)
	    {	    	
	    	if (Brand == 'chevron' && cannedMessageHeader.Chevron_Header__c != '')
	    	{
	        	chosenDescription = '<span class="message_header">' +cannedMessageHeader.Chevron_Header__c.replace('\n', '<br/>') + '</span><br/>' + chosenDescription;	        	   
	        }
	        if (Brand == 'chevron' && cannedMessageHeader.Chevron_Footer__c != '')
	        {
	        	chosenDescription = chosenDescription + '<br/><span class="message_footer">' +cannedMessageHeader.Chevron_Footer__c.replace('\n', '<br/>') + '</span><br/>';   
	        }
	        if (Brand == 'spectrum' && cannedMessageHeader.Spectrum_Header__c != '')
	        {
	        	chosenDescription = '<span class="message_header">' +cannedMessageHeader.Spectrum_Header__c.replace('\n', '<br/>') + '</span><br/>' + chosenDescription;  
	        }
	        if (Brand == 'spectrum' && cannedMessageHeader.Spectrum_Footer__c != '')
	        {
	        	chosenDescription = chosenDescription + '<span class="message_footer">' +cannedMessageHeader.Spectrum_Footer__c.replace('\n', '<br/>') + '</span><br/>';  
	    	}	    	   
	    }		
        
        return chosenDescription;   
    }
    
	
	@AuraEnabled
	public static void saveComment(string MemberDescription, string CaseId, boolean Draft, string secureEmailAddress, string Attachments, boolean CURead){        
        system.debug('Method Called===');       
        List <string> aId;
        Id mid;
        List<Member_Comment__c> MemberLst; 
        boolean isEdit=false;
        Id editMemberCommentId;
        try{
        	
        	List<case> tempCase = new List<case>();        	

			tempCase = [select id,Account_Number__c, AccountId, CreatedBy.Email from case where id =:caseId];
			system.debug('tempCase===' + tempCase);
						
			if(tempCase == null || tempCase.Size() == 0)
			{
				// if member comment is in edit mode, caseid is membercommentId
				Member_Comment__c memberComment = [select id, case__c, Draft__c from Member_Comment__c where id =:caseId];
				editMemberCommentId=memberComment.id;
				tempCase = [select id,Account_Number__c, AccountId, CreatedBy.Email,Secure_Email__c from case where id =:memberComment.case__c];
				CaseId = memberComment.case__c;
				isEdit= true;
			}				
			string Email = tempCase[0].CreatedBy.Email;
			          
            system.debug('Azhar MemberDescription----'+MemberDescription);
            if(!isEdit){
                MemberLst = new List<Member_Comment__c>();         
                Member_Comment__c mbobj = new Member_Comment__c();
                mbobj.Member_Communication__c = MemberDescription;
                system.debug('Azhar Draft' + Draft);
                mbobj.Draft__c = Draft;
                mbobj.Case__c = CaseId;
                if (secureEmailAddress != null && secureEmailAddress != '')
                {
                    mbobj.Member_Email__c = secureEmailAddress;
                }
                mbobj.Case_Creator_Email__c = Email;

                    MemberLst.add(mbobj);
                    system.debug('Azhar MemberLst 1st--'+MemberLst);
                    
                    insert MemberLst;
					mid = MemberLst[0].id;
					//mid = 'a0aW0000004XUpTIAW';
                                
                
                
                List<publishMemberAttachments.attachmentWrapper> caseAttachments = (List<publishMemberAttachments.attachmentWrapper>)JSON.deserialize(Attachments, List<publishMemberAttachments.attachmentWrapper>.class);
                                
                system.debug('caseAttachments--'+caseAttachments);
                if(!caseAttachments.isEmpty()){
                	
                    for(publishMemberAttachments.attachmentWrapper a : caseAttachments)
                    {
                    	system.debug('caseattach--'+a);
                    	
                    	if(a.checkvalue)
                    	{             
                    		system.debug('a.attachmentobj'+a.attachmentobj);
                    		       		
	                        if(a.attachmentobj.isContentDocument)
	                        {	         
	                        	
	                        	list<ContentVersion> MbContentDocumentLst = new list<ContentVersion>();
          						list<ContentDocumentLink> cls = new list<ContentDocumentLink>();
          						
						        cls = [select id,ContentDocumentId,ShareType from ContentDocumentLink where Id =: a.attachmentobj.Id];						        
						        
						        set<id> ids = new set<id>();
						          for(ContentDocumentLink ls : cls)
						          {
						          		ids.add(ls.ContentDocumentId);
						          }
								
									                     
						          MbContentDocumentLst = [select versionData,title,pathOnClient  FROM ContentVersion where ContentDocumentId  IN : ids];
						           lIST<ContentVersion> listContentVersionToInsert = new lIST<ContentVersion>();
						          for (ContentVersion ac : MbContentDocumentLst) {          	              
						  			ContentVersion v = new ContentVersion();
									v.versionData = ac.versionData;
									v.title  = ac.title;
									v.pathOnClient = ac.pathOnClient;			
									listContentVersionToInsert.add(v);									
						          }
						          system.debug('listContentVersionToInsert++'+ listContentVersionToInsert);
						          insert listContentVersionToInsert;
						             lIST<ContentDocumentLink> listContentDocumentToInsert = new lIST<ContentDocumentLink>();
						          for(ContentVersion ls  :listContentVersionToInsert){
						          	  ContentDocumentLink cdList = new ContentDocumentLink();
						          	  cdList.ContentDocumentId = [SELECT Id, ContentDocumentId FROM ContentVersion WHERE Id =: ls.Id].ContentDocumentId;
										cdList.LinkedEntityId = MemberLst[0].id; // you can use objectId,GroupId etc			
										cdList.ShareType = 'V';			
										cdList.Visibility = 'AllUsers';		
										listContentDocumentToInsert.add(cdList);		
						          }
						          system.debug('listContentDocumentToInsert++'+ listContentDocumentToInsert);
						          insert listContentDocumentToInsert;
						          
						        
										
						          
	                        }
	                        else
	                        {	
	                        	Attachment oldAttachment = new Attachment();
	                        	oldAttachment = [select Id, body from Attachment where Id =: a.attachmentobj.Id limit 1];
	                        	
	                        	Attachment att = new Attachment();
		                        att.name = a.attachmentobj.name;		                        
		                        att.ContentType  = a.attachmentobj.ContentType;
		                        att.body = oldAttachment.body;
		                        att.parentid = MemberLst[0].id;
	                        	insert att;
	                        }
                    	}
                    }                    
                }
            }
            else
            {
            	//MemberLst = new List<Member_Comment__c>();         
                Member_Comment__c mbobj = [select id, case__c, Draft__c from Member_Comment__c where id =:editMemberCommentId];
                if(mbobj.Draft__c)
                {
                mbobj.Member_Communication__c = MemberDescription;                
                mbobj.Draft__c = Draft;
               // mbobj.CU_Read__c = CURead;
                //mbobj.Case__c = CaseId;
                if (secureEmailAddress != null && secureEmailAddress != '')
                {
                    mbobj.Member_Email__c = secureEmailAddress;
                }
                mbobj.Case_Creator_Email__c = Email;

                // MemberLst.add(mbobj);
                system.debug('Dhwani MemberLst 1st--'+mbobj);
                    
                update mbobj;
				mid = editMemberCommentId;
					//mid = 'a0aW0000004XUpTIAW';
                system.debug('mid' +mid);
                 
                list<ContentDocumentLink> cdls = [select id from ContentDocumentLink where LinkedEntityId =: mid];
                system.debug('ContentDocumentLink ===>>' + cdls);
				delete cdls;
				
				list<Attachment> lstattach = [select id from Attachment where parentid =: mid];
				system.debug('Attachments ===>>' + lstattach);
				
				delete lstattach;
				
                List<publishMemberAttachments.attachmentWrapper> caseAttachments = (List<publishMemberAttachments.attachmentWrapper>)JSON.deserialize(Attachments, List<publishMemberAttachments.attachmentWrapper>.class);
                                
                system.debug('caseAttachments--'+caseAttachments);
                if(!caseAttachments.isEmpty()){
                	
                    for(publishMemberAttachments.attachmentWrapper a : caseAttachments)
                    {
                    	system.debug('caseattach--'+a);
                    	
                    	if(a.checkvalue)
                    	{             
                    		system.debug('a.attachmentobj'+a.attachmentobj);
                    		       		
	                        if(a.attachmentobj.isContentDocument)
	                        {	         
	                        	
	                        	list<ContentVersion> MbContentDocumentLst = new list<ContentVersion>();
          						list<ContentDocumentLink> cls = new list<ContentDocumentLink>();
          						
						        cls = [select LinkedEntityId, ContentDocumentId,ShareType from ContentDocumentLink where Id =: a.attachmentobj.Id];						        
						        system.debug('cls' + cls);
						        set<id> ids = new set<id>();
						          for(ContentDocumentLink ls : cls)
						          {
						          	/*boolean ifExist =false;
						          	list<ContentDocumentLink> cls1 = [select id,LinkedEntityId, ContentDocumentId,ShareType from ContentDocumentLink where ContentDocumentId =: ls.ContentDocumentId];
						          	for(ContentDocumentLink ls1 : cls1){
						          		if(ls1.LinkedEntityId == mbobj.id)
						          		{
						          			ifExist=true;
						          			break;
						          		}*/
						          			ids.add(ls.ContentDocumentId);
						          	//}
						          	
						          /*	if(!ifExist){
						          		ids.add(ls.ContentDocumentId);
						          		
										ContentDocumentLink cDe = new ContentDocumentLink();
										cDe.ContentDocumentId = ls.ContentDocumentId;
										cDe.LinkedEntityId = mbobj.id; // you can use objectId,GroupId etc			
										cDe.ShareType = ls.ShareType;					
										insert cDe;		
						          	}	*/
						          }
						          
						          MbContentDocumentLst = [select versionData,title,pathOnClient  FROM ContentVersion where ContentDocumentId  IN : ids];
						           lIST<ContentVersion> listContentVersionToInsert = new lIST<ContentVersion>();
						          for (ContentVersion ac : MbContentDocumentLst) {          	              
						  			ContentVersion v = new ContentVersion();
									v.versionData = ac.versionData;
									v.title  = ac.title;
									v.pathOnClient = ac.pathOnClient;			
									listContentVersionToInsert.add(v);									
						          }
						          system.debug('listContentVersionToInsert' + listContentVersionToInsert);
						          insert listContentVersionToInsert;
						             lIST<ContentDocumentLink> listContentDocumentToInsert = new lIST<ContentDocumentLink>();
						          for(ContentVersion ls  :listContentVersionToInsert){
						          	  ContentDocumentLink cdList = new ContentDocumentLink();
						          	  cdList.ContentDocumentId = [SELECT Id, ContentDocumentId FROM ContentVersion WHERE Id =: ls.Id].ContentDocumentId;
										cdList.LinkedEntityId = mid; // you can use objectId,GroupId etc			
										cdList.ShareType = 'V';			
										   cdList.Visibility = 'AllUsers';       		
										listContentDocumentToInsert.add(cdList);		
						          }
						          system.debug('listContentDocumentToInsert' + listContentDocumentToInsert);
						          insert listContentDocumentToInsert;
	                        }
	                        else
	                        {	                        
	                        	Attachment oldAttachment = new Attachment();
	                        	oldAttachment = [select Id, body, parentid from Attachment where Id =: a.attachmentobj.Id limit 1];
	                        	system.debug('oldAttachment' + oldAttachment);
	                        	if(oldAttachment.parentid != mbobj.id){
			                        	Attachment att = new Attachment();
				                        att.name = a.attachmentobj.name;		                        
				                        att.ContentType  = a.attachmentobj.ContentType;
				                        att.body = oldAttachment.body;
				                        system.debug('mid==>>' + mid);
				                        att.parentid = mid;
			                        	insert att;
	                        	}	                        	
	                        }
                    	}
                    	/*else
                    	{
                    		if(a.attachmentobj.isContentDocument)
	                        {	         
	                        	
	                        	list<ContentVersion> MbContentDocumentLst = new list<ContentVersion>();
          						list<ContentDocumentLink> cls = new list<ContentDocumentLink>();
          						
						        cls = [select LinkedEntityId, ContentDocumentId,ShareType from ContentDocumentLink where Id =: a.attachmentobj.Id];						        
						        
						        set<id> ids = new set<id>();
						          for(ContentDocumentLink ls : cls)
						          {
						          	boolean ifExist =false;
						          	list<ContentDocumentLink> cls1 = [select id,LinkedEntityId, ContentDocumentId,ShareType from ContentDocumentLink where ContentDocumentId =: ls.ContentDocumentId];
						          	for(ContentDocumentLink ls1 : cls1){
						          		if(ls1.LinkedEntityId == mbobj.id)
						          		{
						          			ifExist=true;
						          			break;
						          		}
						          	}
						          	system.debug('ifExist'+ ifExist);
						          	
						          	if(ifExist){
						          		ids.add(ls.ContentDocumentId);
						          		ContentDocumentLink cls2 = 	[select id,LinkedEntityId, ContentDocumentId,ShareType from ContentDocumentLink where ContentDocumentId =: ls.ContentDocumentId and LinkedEntityId =: mbobj.id];
						          		delete cls2;
						          	}	
						          }
								
									                     
						         
	                        }
	                        else
	                        {	
	                        	Attachment oldAttachment = new Attachment();
	                        	oldAttachment = [select Id, body from Attachment where Id =: a.attachmentobj.Id limit 1];
	                        	if(oldAttachment.parentid == mbobj.id){
			                        	delete oldAttachment;
	                        	}	                        	
	                        }
                    	}*/
                    }                    
                } 
				}  
              else{
                    	 mbobj.CU_Read__c = CURead;
                    	 update mbobj;
                  }         	
            }
        }
        catch(exception e){
            system.debug('e---'+e);
        }       
    }
    
     public class wrapperObject
    {    	
    	@AuraEnabled
        public Account_Details__c AccObj {get; set;}
        @AuraEnabled
        public boolean isDraft {get; set;}
        @AuraEnabled
		public Member_Comment__c memberComment {get; set;}
		@AuraEnabled
		public string Secure_Email {get; set;}
		@AuraEnabled
		public boolean isEdit {get; set;}
		@AuraEnabled
		public boolean isObjectAccess {get; set;}
		@AuraEnabled
		public boolean isCUReadEditable {get;set;}		
        
    } 
    
    public class AttachmentWrapper
    {
    	public Attachment attachmentobj {get;set;}
        public Boolean checkvalue {get;set;}
    }
    
}