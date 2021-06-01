trigger ContentDocumentLinkUpdate on ContentDocumentLink (before insert,after update,after delete,after insert) {
    
    Map<id,ContentDocumentLink> ContentDocumentLinkDetails = new Map<id,ContentDocumentLink >();
    
    List<Member_Comment__c> MemberlsttoUpdate = new List<Member_Comment__c>();
    List<SolarLoan_Document__c> solarLoanAttachmentsList  = new List<SolarLoan_Document__c>();
    set<ID> listCD  = new set<ID>();
    Map<Id, ContentDocument> cs = new Map<Id, ContentDocument>(); 
    Map<id,Solar_Loans__c> sl = new Map<id,Solar_Loans__c >();
    Map<id,xPressRefi__c> xl = new Map<id,xPressRefi__c >();
    Map<ID,ID> cv = new Map<ID,ID>();
    Map<Id,ContentVersion> cvNewFile = new Map<ID,ContentVersion>();
    List<Solar_Loans__c> slcountUpdate = new List<Solar_Loans__c>();
    List<Solar_Loans__c> slSignCardUpdate = new List<Solar_Loans__c>();
    List<xPressRefi_Document__c> xPressRefiAttachmentsList  = new List<xPressRefi_Document__c>();
    
    String[] strArr;
    String FirstPart;
    String SecondPart;
    String FinalString;
    
    Set<id> parent = new Set<id>();
    
    //----- Fire validation error to upload attachments when In person signing record has been locked -----//
    //---------------------------------------START---------------------------------------------------------//
    /*if(Trigger.isInsert && Trigger.isBefore){
        List<Id> inPersonSigningIds=new List<Id>();
        for(ContentDocumentLink cdl: Trigger.new){
            if(cdl.LinkedEntityId!=null){
                String sobjectType = cdl.LinkedEntityId.getSObjectType().getDescribe().getName();
                if(sobjectType=='InPersonSigning__c'){
                    inPersonSigningIds.add(cdl.LinkedEntityId);
                }
            }
        }
        
        List<InPersonSigning__c> inPersonSignings=new List<InPersonSigning__c> ();
        inPersonSignings=[Select Id,IsLocked__c FROM InPersonSigning__c Where Id IN:inPersonSigningIds];
        
        for(InPersonSigning__c item: inPersonSignings){
            if(item.IsLocked__c==true){
                item.addError('In Person Signing record is locked. You can not upload attachments.');
            }
        }
    }*/
    //----------------------------------------END---------------------------------------------------------//
   
    
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

    For(xPressRefi__c xrefi : [select id, Member_Number__c from xPressRefi__c where id in: parent]){
        xl.put(xrefi.id, xrefi);
    }
    
    For(ContentVersion contentVersion : [select id,Title,NewFile__c,VersionData,ContentDocumentId from ContentVersion where ContentDocumentId in: listCD]){
        cv.put(contentVersion.ContentDocumentId,contentVersion.id);
        cvNewFile.put(contentVersion.ContentDocumentId,contentVersion);
    }
    system.debug('test'+cv);
    
    Map<Id,ContentDocumentLink> DocuSignMapIds = new Map<Id,ContentDocumentLink>();
    List<Attachment> AddCaseAttachmentList = new List<Attachment>();

    if(Trigger.isInsert && Trigger.isAfter)
    {
        for(ContentDocumentLink c : Trigger.New){
            Schema.SObjectType objType = c.LinkedEntityId.getsobjecttype();
            system.debug('objType'+objType);
            ContentDocumentLinkDetails.put(c.id,c);
            
            // ----------------------------Start Adding an Attachment detail in "Solar Loan Document" object--------------------------------------------------//
            
            if(objType == Solar_Loans__c.sObjectType){
                
                String Title;
                Title = cs.get(c.ContentDocumentId).title;
                SolarLoan_Document__c solarLoanObj = new SolarLoan_Document__c();
                solarLoanObj.Attachment_Id__c = cs.get(c.ContentDocumentId).id;
                if(Title.length() > 80){
                    
                    strArr = Title.split('-');
                    SecondPart = ' -'+ strArr[strArr.size() - 1];
                    FinalString = Title.left(80 - SecondPart.length());
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
                
                if(Title.contains('Member Application_Completed')){
                    Solar_Loans__c sl = new Solar_Loans__c();
                    sl.id = c.LinkedEntityId;
                    sl.Signed__c = true;
                    slSignCardUpdate.add(sl);
                }
                
                If(Title.contains('Member Application') || Title.contains('Membership Application'))
	            	solarLoanObj.Document_Type__c = 'Signature Cards';
                else If(Title.contains('Government ID'))
                    solarLoanObj.Document_Type__c = 'Member Identification Documents';
				else If(Title.contains('CCHS Application'))
					solarLoanObj.Document_Type__c = 'Account Verification Documents';
				else
					solarLoanObj.Document_Type__c = 'Solar Secured Loans';
					
                solarLoanObj.Document_Name__c = cs.get(c.ContentDocumentId).title;
                solarLoanObj.Solar_Loans__c = c.LinkedEntityId;
                solarLoanObj.Attachment_Owner__c = cs.get(c.ContentDocumentId).OwnerId;
                solarLoanObj.Attachment_Created_On__c = cs.get(c.ContentDocumentId).CreatedDate;
                solarLoanObj.NewFile__c = cvNewFile.get(c.ContentDocumentId).NewFile__c;
                
                solarLoanAttachmentsList.add(solarLoanObj);   
            }
            //-------------------------Start - LT11477-81: Adding Document to xPressRefi Document Object---------------------------------//
            if(objType == xPressRefi__c.sObjectType){
                String Title;
                Title = cs.get(c.ContentDocumentId).title;
                xPressRefi_Document__c xrefiDocumentObj = new xPressRefi_Document__c();
                xrefiDocumentObj.Attachment_Id__c = cs.get(c.ContentDocumentId).id;
                
                //system.debug(xrefiDocumentObj.Name);
                xrefiDocumentObj.Member_Number__c = xl.get(c.LinkedEntityId).Member_Number__c;
                xrefiDocumentObj.IsMovedToOnBase__c = false;
                
                
                xrefiDocumentObj.Document_Type__c = 'Xpress Refinance Docs';
                xrefiDocumentObj.Document_Name__c = cs.get(c.ContentDocumentId).title;
                xrefiDocumentObj.xPressRefi__c = c.LinkedEntityId;
                xrefiDocumentObj.Attachment_Owner__c = cs.get(c.ContentDocumentId).OwnerId;
                xrefiDocumentObj.Attachment_Created_On__c = cs.get(c.ContentDocumentId).CreatedDate;
                xrefiDocumentObj.NewFile__c = cvNewFile.get(c.ContentDocumentId).NewFile__c;
                
                xPressRefiAttachmentsList.add(xrefiDocumentObj);  
            }  
            //-------------------------Start - CRM-1929---------------------------------//

            if(objType == dsfs__DocuSign_Status__c.sObjectType){

                DocuSignMapIds.put(c.LinkedEntityId,c);
            }   
            

        }

        system.debug('DocuSignMapIds: '+DocuSignMapIds);
      
        List<dsfs__DocuSign_Status__c> DocuSignListIds = [select id,dsfs__Case__c,dsfs__Subject__c from dsfs__DocuSign_Status__c where id in :DocuSignMapIds.keyset() and dsfs__Case__c != null and dsfs__Subject__c != 'ACH Debits'];

        system.debug('DocuSignListIds: '+DocuSignListIds);

        if(DocuSignListIds.size() > 0){
            
            for(dsfs__DocuSign_Status__c ds : DocuSignListIds){
                
                Attachment anAttachment = new Attachment();
                anAttachment.Body = cvNewFile.get(DocuSignMapIds.get(ds.id).ContentDocumentId).VersionData;
                anAttachment.ContentType = 'application/pdf';
                anAttachment.Name = cvNewFile.get(DocuSignMapIds.get(ds.id).ContentDocumentId).Title;
                anAttachment.ParentId = ds.dsfs__Case__c;
                AddCaseAttachmentList.add(anAttachment);
            }
        }

        //--------------------------End - CRM-1929---------------------------------//
    }

    if(AddCaseAttachmentList.size()> 0)
        insert AddCaseAttachmentList;
    
    insert (solarLoanAttachmentsList);
    insert (xPressRefiAttachmentsList);
    
    // ----------------------------End Adding an Attachment detail in "Solar Loan Document" object--------------------------------------------------//
    
    if(Trigger.isDelete && Trigger.isAfter){
        for(ContentDocumentLink c : Trigger.old){
            system.debug('Delete======');
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
    if(slSignCardUpdate.size()>0)
        update slSignCardUpdate;
}