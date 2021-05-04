trigger AttachmentNameUpdate on Attachment (after update,after delete,after insert, before insert,before delete) {

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
        
        set<Id> notClosedCaseSet = (new Map<Id,Case>([select id from case where ID IN: parent and status != 'Closed'])).keySet();
        set<Id> notClosedCaseMemberComment = (new Map<Id,Member_Comment__c>([select id from Member_Comment__c where Id IN: parent and Case__r.status != 'Closed'])).keySet();
        set<Id> attachmentIdsForOnbase = new set<Id>();
        for(Attachment a : Trigger.old){
            if(notClosedCaseSet.Contains(a.ParentId) || notClosedCaseMemberComment.Contains(a.ParentId)){
                attachmentIdsForOnbase.add(a.id);
            }
        }
        
        
        system.debug('notClosedCaseSet :: '+notClosedCaseSet);
        system.debug('attachmentIdsForOnbase :: '+attachmentIdsForOnbase);
        
        
        List<OnBase_Document__c> onbaseAttachmentsList = [select id from OnBase_Document__c where Attachment_Id__c IN : attachmentIdsForOnbase];
        system.debug('onbaseAttachmentsList :: '+onbaseAttachmentsList);
        if(!onbaseAttachmentsList.isEmpty()){
            system.debug('In If :: ');
            delete onbaseAttachmentsList;
        }
    }
    
    if(Trigger.isInsert && Trigger.isBefore){
    	
        if(!Test.isRunningTest()){
	        system.debug('Rename called');
	         List<string> listAttachmentForCaseIds = new List<string>();
	         List<string> listAttachmentIds = new List<string>(); 
	         for(Attachment a : Trigger.New)
	         {
	            Schema.SObjectType objType = a.ParentId.getsobjecttype();
	            if(objType == Case.sObjectType && a.CreatedBy.Profile.Name != 'Messaging center Customers')
	            {
	              listAttachmentForCaseIds.add(a.parentId);
	            }
	            
	            listAttachmentIds.add(a.Id);
	         }
	         system.debug('Rename called 1' + listAttachmentIds);
	         List<Attachment> mapValues = [SELECT Id,ParentId,Name FROM Attachment where ParentId =: listAttachmentForCaseIds and Id not in:  listAttachmentIds];
	         system.debug('Rename called 2' + mapValues);
	         for(Attachment a : Trigger.New)
	         {
	            for(Attachment caseAttachment : mapValues)
	            {
	                if(a.ParentId == caseAttachment.parentId && a.Name == caseAttachment.Name)
	                {
	                    string s = string.valueOf(system.now()).replace(' ' ,'-').replace(':','-');
	                    
	                    String[] arrayFileName =  a.Name.split('\\.');
	                    string fileName = '';
	                    system.debug('arrayFileName' + arrayFileName);
	                    for (Integer i = 0; i < arrayFileName.size()-1; i++) {
	                        fileName = fileName + arrayFileName[i] + '.';
	                    }
	
	                    fileName = fileName +  ' - ' + s + '.' + arrayFileName[arrayFileName.size()-1];
	                    system.debug(fileName);
	                    
	                    
	                    a.Name = fileName;
	                    
	                    break;
	                    
	                }
	            }
	            
	         }
         }
    }
    
    
    if(Trigger.isInsert && Trigger.isAfter){
    	
    	//-------------------------------Start Creating "Solar Loan Document" with appropriate "AttachmentId"--------------------//
    	
    	List<SolarLoan_Document__c> solarLoanAttachmentsList  = new List<SolarLoan_Document__c>();
    	Map<id,Solar_Loans__c> sl = new Map<id,Solar_Loans__c >();
    	Set<Id> parent = new Set<Id>();
    	List<Solar_Loans__c> slcountUpdate = new List<Solar_Loans__c>();
    	
    	for(Attachment a : Trigger.New){
        	parent.add(a.ParentId);
     	}
      
    	For(Solar_Loans__c solarLoan : [select id, Member_Number__c from Solar_Loans__c where id in: parent]){
        	sl.put(solarLoan.id, solarLoan);
        }
        
    	for(Attachment a : Trigger.New){
    		system.debug('test'+a);
            Schema.SObjectType objType = a.ParentId.getsobjecttype();
    		if(objType == Solar_Loans__c.sObjectType){
    			
    			SolarLoan_Document__c solarLoanObj = new SolarLoan_Document__c();
	            solarLoanObj.Attachment_Id__c = a.id;
	            solarLoanObj.Name = a.name;
	            solarLoanObj.Member_Number__c = sl.get(a.ParentId).Member_Number__c;
	            solarLoanObj.IsMovedToOnBase__c = false;
                
                If(a.name.contains('Member Application') || a.name.contains('Membership Application'))
                    solarLoanObj.Document_Type__c = 'Signature Cards';
                else If(a.name.contains('Government ID'))
                    solarLoanObj.Document_Type__c = 'Member Identification Documents';
                else If(a.name.contains('CCHS Application'))
                    solarLoanObj.Document_Type__c = 'Account Verification Documents';
                else
                    solarLoanObj.Document_Type__c = 'Solar Secured Loans';

	            solarLoanObj.Document_Name__c =a.name;
                solarLoanObj.Solar_Loans__c = a.ParentId;
                solarLoanObj.Attachment_Owner__c = a.OwnerId;
                solarLoanObj.Attachment_Created_On__c = a.CreatedDate;
               
            	solarLoanAttachmentsList.add(solarLoanObj);
    		}
    	}
    	
    	if(solarLoanAttachmentsList.size() > 0){
    		insert solarLoanAttachmentsList;
    	}
    	
    	for (Solar_Loans__c sl1 : [select Id, count__c ,(SELECT Id FROM Attachments)  from Solar_Loans__c where Id IN :parent]){
    	
	        Solar_Loans__c s = new Solar_Loans__c();
	        s.id = sl1.id;
	        if(sl1.count__c == null)
	        	s.count__c = String.valueof(sl1.Attachments.size());
	        else
	        	s.count__c = String.valueof(sl1.Attachments.size() + 1 ) ;
	        	
	        slcountUpdate.add(s);
        } 
    	
    	if(slcountUpdate.size() > 0)	
     		update slcountUpdate;
     	
    	//-------------------------------End Creating "Solar Loan Document" with appropriate "AttachmentId"--------------------//
    	
        List<OnBase_Document__c> onbaseAttachmentsList  = new List<OnBase_Document__c>();   
        List<string> Caseids = new List<string>();
        List<string> memberCommentids = new List<string>();
        
   
        
         List<string> listCasesComment = new List<string>(); 
         for(Attachment a : Trigger.New){
            Schema.SObjectType objType = a.ParentId.getsobjecttype();
            if(a.CreatedBy.Profile.Name != 'Messaging center Customers' && objType == Member_Comment__c.sObjectType)
            {
                listCasesComment.add(a.ParentId);
            }
         }
         
         
         //If parent document in case is indexed and approved and memeber comment is added later on
         List<Member_Comment__c> listCaseComments = [select id,Case__c from Member_Comment__c where Id in: listCasesComment];
         
         
         List<string> listCaseIds = new List<string>();
         Map<string,string> mapCaseCommentMapping = new Map<string,string>();
         for(Member_Comment__c item: listCaseComments)
         {
            listCaseIds.add(item.Case__c);
            mapCaseCommentMapping.put(item.id,item.Case__c);    
            
         }
         
         
         List<Attachment> listCaseAttachments = [select id,ParentId,Name from Attachment where ParentId in: listCaseIds and CreatedBy.Profile.Name != 'Messaging center Customers'];
         
         
         List<string> listCaseAttachmentIds = new List<string>(); 
         for(Attachment att : listCaseAttachments)
         {
            listCaseAttachmentIds.add(att.id);
         }
         
         
         List<OnBase_Document__c> listOnBase = [select id,Case__C,Document_Name__c,Member_Comment__c,Document_Type__c,IsMovedToOnBase__c from OnBase_Document__c where Attachment_Id__c in: listCaseAttachmentIds]; 
        
        for(Attachment a : Trigger.New){
            attachmentDetails.put(a.id,a);
            parent.add(a.ParentId);
          
            Schema.SObjectType objType = a.ParentId.getsobjecttype();
            system.debug('a.Parent.Type12 :: '+ a.parentid.getsobjecttype());
            if(objType == Case.sObjectType || objType == Member_Comment__c.sObjectType){
                OnBase_Document__c onbaseObj = new OnBase_Document__c();
                onbaseObj.Attachment_Id__c = a.id;
                 onbaseObj.IsMovedToOnBase__c = false;
                 onbaseObj.Document_Type__c = null;
                    onbaseObj.Document_Name__c = a.Name;
                if(objType == Case.sObjectType)
                {
                onbaseObj.Case__c = a.ParentId;
                Caseids.add(a.ParentId);
                }
                else
                {
                    onbaseObj.Member_Comment__c = a.ParentId;   
                    memberCommentids.add(a.ParentId);
                    
                    for(OnBase_Document__c item : listOnBase)
                    {
                        if(item.Case__C == mapCaseCommentMapping.get(onbaseObj.Member_Comment__c) && item.Document_Name__c == onbaseObj.Document_Name__c)
                        {
                             onbaseObj.IsMovedToOnBase__c = item.IsMovedToOnBase__c;
                             onbaseObj.Document_Type__c = item.Document_Type__c;
                             break;
                        }
                    } 
                
                
                }
               
                //onbaseObj.Name = a.Name;
             
                
                onbaseObj.Attachment_Owner__c = a.OwnerId;
                onbaseObj.Attachment_Created_On__c = a.CreatedDate;
                
                              
                
                onbaseAttachmentsList.add(onbaseObj);
            }
        }
        
        
        List<Case> listCasetoReopened = [select id,status,Count_Attachment__c from case where  Id in: Caseids];
        
        
        
        for(Case itemCase : listCasetoReopened)
        {
            if(itemCase.Status == 'Closed')
                itemCase.Status = 'Re Opened';
            if(itemCase.Count_Attachment__c == null|| itemCase.Count_Attachment__c == 0){
               itemCase.Count_Attachment__c = 1;
            }
            else{
                itemCase.Count_Attachment__c ++;
            }
        }
        update listCasetoReopened;
        insert (onbaseAttachmentsList);
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
    for (Member_Comment__c mem : [select Id, Name,Attachment_Number__c,(SELECT Id FROM Attachments) ,(Select id from ContentDocumentLinks) from Member_Comment__c where Id IN :parent]) {
        //MemberMap.get(mem.Id).Attachment_Number__c = mem.Attachments.size();
        mem.Attachment_Number__c = mem.Attachments.size() + mem.ContentDocumentLinks.size();
        MemberlsttoUpdate.add(mem);
    }
    system.debug('--MemberlsttoUpdate--'+MemberlsttoUpdate);
    update MemberlsttoUpdate;
    
       
    if(Trigger.isDelete && Trigger.isBefore){
            
        //------------------------------------------Start Decreasing Count of attachments from "Solar Loan" record--------------//
    	
    	List<Solar_Loans__c> slcountUpdate = new List<Solar_Loans__c>();
    	
    	for(Attachment a : Trigger.old){
        	parent.add(a.ParentId);
     	}
     	
    	for (Solar_Loans__c sl1 : [select Id, count__c ,(SELECT Id FROM Attachments)  from Solar_Loans__c where Id IN :parent]){
    	
	        Solar_Loans__c s = new Solar_Loans__c();
	        s.id = sl1.id;
	        if(sl1.count__c == null)
	        	s.count__c = String.valueof(sl1.Attachments.size());
	        else
	        	s.count__c = String.valueOf(Integer.valueOf(sl1.count__c) - 1) ;
	        slcountUpdate.add(s);
        } 
    	
    	if(slcountUpdate.size() > 0)	
     		update slcountUpdate;
    	
    	//-----------------------------------------End Decreasing Count of attachments from "Solar Loan" record---------------//
    	
            List<string> Caseids = new List<string>();
            for(Attachment a : Trigger.old){
                List<lead> l = new List<lead>();
                l = [select id, Status from lead where id =: a.ParentId];
                if(l.size() != 0)
                {
                    if(l[0].Status == 'Closed - Not Converted' || l[0].Status == 'Closed - Converted')
                    {
                      a.Adderror('You can not Delete files for Closed Leads');
                    }
                }     
                Schema.SObjectType objType = a.ParentId.getsobjecttype();   
                if(objType == Case.sObjectType)
                    {
                        Caseids.add(a.ParentId);
                    }
                               
                  }
                  
               List<Case> listCasetoReCount = [select id,Count_Attachment__c from case where  Id in: Caseids];
               system.debug('---------------'+listCasetoReCount);
               for(Case itemCase : listCasetoReCount)
                    {
                        
                        if(itemCase.Count_Attachment__c == null|| itemCase.Count_Attachment__c == 0){
                           itemCase.Count_Attachment__c = 0;
                        }
                        else if( itemCase.Count_Attachment__c > 0 ){
                            itemCase.Count_Attachment__c --;
                        }
                    }
                system.debug('---------------'+listCasetoReCount);
                update listCasetoReCount;
        
        
        }
      
      if(Trigger.isInsert && Trigger.isBefore){
            for(Attachment a : Trigger.New){
              List<lead> l = new List<lead>();
             l = [select id, Status from lead where id =: a.ParentId];
             if(l.size() != 0)
                  {
                    if(l[0].Status == 'Closed - Not Converted' || l[0].Status == 'Closed - Converted')
                    {
                      a.Adderror('You can not Upload files for Closed Leads');
                    }
                  }                  
          }
        }
 
        // New Attachment Notification--DR
    
     Map<id,Attachment> NewAttachmentAlert = new Map<id,Attachment>();
     Set<id> parentCase = new Set<id>();
     if(Trigger.isInsert && Trigger.isAfter){   
        for(Attachment a : Trigger.New){
         NewAttachmentAlert.put(a.id,a);
         parentCase.add(a.ParentId);
   
        }
        
        List<Case> AlertCase = [Select ID,  IsNewAttachment__c from case where id in: parentCase];
        
        for(Case c: AlertCase){
         c.IsNewAttachment__c = True;
         
        }
        
        Update AlertCase;
        
     }
   
     Set<id> parentCase1 = new Set<id>();
   
     if(Trigger.isDelete && Trigger.isAfter){   
        for(Attachment a : Trigger.old){
             parentCase1.add(a.ParentId);
         }
        
        List<Case> AlertCase1 = [Select ID,  IsNewAttachment__c from case where id in: parentCase1];
        
        for(Case c: AlertCase1){
         c.IsNewAttachment__c = False;
         
        }
        
        Update AlertCase1;
        
     }
   
   // End of alert notification

       
 
}