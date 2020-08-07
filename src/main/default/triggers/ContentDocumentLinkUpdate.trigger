trigger ContentDocumentLinkUpdate on ContentDocumentLink (after update,after delete,after insert) {
	
    Map<id,ContentDocumentLink> ContentDocumentLinkDetails = new Map<id,ContentDocumentLink >();
     
    List<Member_Comment__c> MemberlsttoUpdate = new List<Member_Comment__c>();
    List<SolarLoan_Document__c> solarLoanAttachmentsList  = new List<SolarLoan_Document__c>();
    set<ID> listCD  = new set<ID>();
    Map<Id, ContentDocument> cs = new Map<Id, ContentDocument>(); 
    Map<id,Solar_Loans__c> sl = new Map<id,Solar_Loans__c >();
    Map<ID,ID> cv = new Map<ID,ID>();
    Map<Id,ContentVersion> cvNewFile = new Map<ID,ContentVersion>();
    List<Solar_Loans__c> slcountUpdate = new List<Solar_Loans__c>();
     
    String[] strArr;
    String FirstPart;
    String SecondPart;
    String FinalString;
     
    Set<id> parent = new Set<id>();
    
        if(Trigger.isUpdate && Trigger.isAfter)
        {   
            for(ContentDocumentLink c : Trigger.New){
                ContentDocumentLinkDetails.put(c.id,c);
            }
        }
        
        if(Trigger.isInsert && Trigger.isAfter)
        {
         	for(ContentDocumentLink c : Trigger.New){
         		listCD.add(c.ContentDocumentId);
         		parent.add(c.LinkedEntityId);
         	}
        }
              
        For(ContentDocument cd : [select id,title,CreatedDate,OwnerId from ContentDocument where id in: listCD]){
        	cs.put(cd.id,cd);
        }
        
        For(Solar_Loans__c solarLoan : [select id, Member_Number__c from Solar_Loans__c where id in: parent]){
        	sl.put(solarLoan.id, solarLoan);
        }
        
        For(ContentVersion contentVersion : [select id,NewFile__c,ContentDocumentId from ContentVersion where ContentDocumentId in: listCD]){
        	cv.put(contentVersion.ContentDocumentId,contentVersion.id);
        	cvNewFile.put(contentVersion.ContentDocumentId,contentVersion);
        }
        system.debug('test'+cv);
        
        if(Trigger.isInsert && Trigger.isAfter)
        {
            for(ContentDocumentLink c : Trigger.New){
                Schema.SObjectType objType = c.LinkedEntityId.getsobjecttype();
                ContentDocumentLinkDetails.put(c.id,c);
               
                // ----------------------------Start Adding an Attachment detail in "Solar Loan Document" object--------------------------------------------------//
                
                if(objType == Solar_Loans__c.sObjectType){
	            
		            String Title;
		            Title = cs.get(c.ContentDocumentId).title;
		            SolarLoan_Document__c solarLoanObj = new SolarLoan_Document__c();
		            solarLoanObj.Attachment_Id__c = cs.get(c.ContentDocumentId).id;
		            if(Title.length() > 80){
                     
                        strArr = Title.split('-');
                        FirstPart = strArr[0] + '-'+ strArr[1];
                        SecondPart = ' -'+ strArr[2];
                        FinalString = FirstPart.left(80 - SecondPart.length());
                        FinalString = FinalString + SecondPart;
                        solarLoanObj.Name = FinalString;
                        system.debug('FinalString '+FinalString);
                        system.debug('Length '+FinalString.length());

		            }else{
		            	solarLoanObj.Name = cs.get(c.ContentDocumentId).title;	
		            }
		            system.debug(solarLoanObj.Name);
		            solarLoanObj.Member_Number__c = sl.get(c.LinkedEntityId).Member_Number__c;
		            solarLoanObj.IsMovedToOnBase__c = false;
		            solarLoanObj.Document_Type__c = 'Solar Loan';
		            solarLoanObj.Document_Name__c = cs.get(c.ContentDocumentId).title;
	                solarLoanObj.Solar_Loans__c = c.LinkedEntityId;
	                solarLoanObj.Attachment_Owner__c = cs.get(c.ContentDocumentId).OwnerId;
	                solarLoanObj.Attachment_Created_On__c = cs.get(c.ContentDocumentId).CreatedDate;
	                solarLoanObj.NewFile__c = cvNewFile.get(c.ContentDocumentId).NewFile__c;
	            	
	            	solarLoanAttachmentsList.add(solarLoanObj);
	            	
	        	}
            }
    	}
    	
    	insert (solarLoanAttachmentsList);
    	
        		// ----------------------------End Adding an Attachment detail in "Solar Loan Document" object--------------------------------------------------//
        		
        if(Trigger.isDelete && Trigger.isAfter){
            for(ContentDocumentLink c : Trigger.old){
                ContentDocumentLinkDetails.put(c.id,c);
                parent.add(c.LinkedEntityId);
            }
        }
      
	for (Member_Comment__c mem : [select Id, Name,Attachment_Number__c,(SELECT Id FROM Attachments),(SELECT Id FROM ContentDocumentLinks)  from Member_Comment__c where Id IN :parent])
    {
    	system.debug('ContentDocumentLinks size=' + mem.ContentDocumentLinks.size());
        mem.Attachment_Number__c = mem.ContentDocumentLinks.size() + mem.Attachments.size();
        MemberlsttoUpdate.add(mem);
       
    }
    
    // ----------------------------Start Counting number Attachments for Solar Loan record--------------------------------------//
    
    for (Solar_Loans__c sl : [select Id, count__c ,(SELECT Id FROM SolarLoan_Documents__r)  from Solar_Loans__c where Id IN :parent])
    {
        Solar_Loans__c s = new Solar_Loans__c();
        s.id = sl.id;
        s.count__c = String.valueof(sl.SolarLoan_Documents__r.size());
    	slcountUpdate.add(s);
       
    }    
     if(MemberlsttoUpdate.size() > 0)
     	update MemberlsttoUpdate;
     if(slcountUpdate.size() > 0)	
     	update slcountUpdate;
}