public class cloneCaseController {
	
	@AuraEnabled
    public static String cloneCaseInsertUpdate(string recordId, boolean Subject, boolean Description, boolean Device_Type, boolean Status, boolean Category,boolean MemberComment, boolean CaseComment, boolean Attachment)
    {    	    	  
    	List<Case> listc = [select Subject,Description,OwnerID,Status,LTK__c,Device_Type__c,
                                 AccountID,Account_Number__c,Brand__c, 
                                 Primary_Category__c,Tertiary_Category__c,Secondary_Category__c 
                            from Case 
                           where ID = :recordId];
      
      Case c = new Case();
      
      c.AccountID = listc[0].AccountID;
      c.OwnerID= listc[0].OwnerID;
      C.Brand__c = listc[0].Brand__c;
      c.Account_Number__c = listc[0].Account_Number__c;
      if(Subject)
      {
          c.Subject = listc[0].Subject;
      }
      if(Description)
      {
          c.Description= listc[0].Description;
      }      
      if(Status)
      {
          c.Status= listc[0].Status;
      }
      //if(LTK)
      //{
          //c.LTK__c= listc[0].LTK__c;
      //}
      if(Device_Type)
      {
          c.Device_Type__c = listc[0].Device_Type__c;
      }
      if(Category)
      {
          c.Primary_Category__c= listc[0].Primary_Category__c;
          c.Secondary_Category__c= listc[0].Secondary_Category__c;
          c.Tertiary_Category__c= listc[0].Tertiary_Category__c;
      }
      
      

      insert c;
      if(MemberComment)
      {
          List<Member_Comment__c> listComment = [
          select Draft__c,Case_Creator_Email__c,Device_Type__c,IsRead__c,
          //Status__c,
          Member_Comment__c,
                 Member_Communication__c,Member_Email__c,IsMarkRead__c 
            from Member_Comment__c 
           where Case__c= :recordId];

            for (Member_Comment__c i : listComment ) {
                 Member_Comment__c obj = new Member_Comment__c();
                obj.Case__c = c.Id;
                obj.Case_Creator_Email__c = i.Case_Creator_Email__c;
                //obj.Status__c = i.Status__c;
                obj.Member_Comment__c= i.Member_Comment__c;
                obj.Member_Communication__c= i.Member_Communication__c;
                obj.Member_Email__c= i.Member_Email__c;
                obj.IsMarkRead__c = i.IsMarkRead__c ;
                obj.Device_Type__c = i.Device_Type__c;
                obj.IsRead__c = i.IsRead__c;
                obj.Draft__c = i.Draft__c;
                CopyAttachment(i.Id, obj.Id);                
                insert obj;                
            }

        }
        if(CaseComment)
        {
            List<CaseComment> listCaseComment = [Select Id, ParentId, IsPublished, CommentBody, CreatedById, CreatedDate, SystemModstamp, LastModifiedDate, LastModifiedById, IsDeleted From CaseComment where ParentId = :recordId and IsDeleted = false];

              for (CaseComment l : listCaseComment ) {
                 CaseComment com = new CaseComment ();
                 com.ParentId = c.Id;
                 com.IsPublished = l.IsPublished;
                 com.CommentBody= l.CommentBody;
    			 CopyAttachment(l.Id, com.Id);    
                 insert com;
              }             
        }
        
        if(Attachment)
        {
           CopyAttachment(recordId, c.Id);
        }
        
        
        return c.Id;
    	     
    }
    
    public static void CopyAttachment(string Old_Id, string New_Id)
    {
      system.debug('Azhar start ---' + Old_Id);
      system.debug('Azhar start ---' + New_Id);
       List<Attachment> listAttachment =  new List<Attachment>();
       listAttachment = [SELECT   Id,Name,Body,ContentType,Description,OwnerId,ParentId FROM Attachment where ParentId = :Old_Id];
       List<Attachment> listAttachmentNew = new List<Attachment>();
              
        for (Attachment a : listAttachment) {
             Attachment att = new Attachment();
             att.ParentId = New_Id;
             att.Body= a.Body;
             att.ContentType= a.ContentType;
             att.Description= a.Description;
             att.OwnerId = a.OwnerId;
             att.Name = a.Name;         

             listAttachmentNew.add(att);
          }
          
          insert listAttachmentNew ;
            
                 
          list<ContentVersion> MbContentDocumentLst = new list<ContentVersion>();
          
          list<ContentDocumentLink> cls = [ select ContentDocumentId,ShareType from ContentDocumentLink where LinkedEntityId =:Old_Id];
          system.debug('Azhar cls ---' + cls);
          
          set<id> ids = new set<id>();
          for(ContentDocumentLink ls : cls)
          {
          		ids.add(ls.ContentDocumentId);
          		
          		//Create ContentDocumentLink
				ContentDocumentLink cDe = new ContentDocumentLink();
				cDe.ContentDocumentId = ls.ContentDocumentId;
				cDe.LinkedEntityId = New_Id; // you can use objectId,GroupId etc			
				cDe.ShareType = ls.ShareType;					
				insert cDe;			
          }
		
		  
			                     
          MbContentDocumentLst = [select versionData,title,pathOnClient  FROM ContentVersion where ContentDocumentId  IN : ids];
               
          for (ContentVersion a : MbContentDocumentLst) {          	              
  			ContentVersion v = new ContentVersion();
			v.versionData = a.versionData;
			v.title  = a.title;
			v.pathOnClient = a.pathOnClient;			
			insert v;
			
          }       
          
    }    
}