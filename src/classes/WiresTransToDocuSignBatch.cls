global class WiresTransToDocuSignBatch implements Database.Batchable<sObject>,Database.AllowsCallouts{    

    Set<Id> WTIdsToSend = new Set<Id>();
   
    global WiresTransToDocuSignBatch(Set<Id> WTIds){
    	WTIdsToSend = WTIds;
    }
	
    global Database.QueryLocator start(Database.BatchableContext BC){
        
        return DataBase.getQueryLocator([SELECT Id,Name,Member_Email__c,Member_Name__c,TotalFromAccount__c,Share_ID__c,ToAccoutId__c FROM WIRES_Transaction__c WHERE Id IN: WTIdsToSend]);
    }
    
    global void execute(Database.BatchableContext BC,List<WIRES_Transaction__c> scopeWTIDs){
        
  		List<WIRES_Transaction__c> WireTransactionToUpdate = new List<WIRES_Transaction__c>();
        String EmailToSend;
        Wires_Docusign_Emails__c wde = Wires_Docusign_Emails__c.getValues('Email For Testing');
        
        if(wde.Emails__c != null){
            EmailToSend = wde.Emails__c;
        }
        
        //--------------------------------Current User Email ------------------------------------------------------//
        
        String userName = UserInfo.getUserName();
		User activeUser = [Select Email From User where Username = : userName limit 1];
		String userEmail = activeUser.Email;
 
 		//--------------------------------Current User Email ------------------------------------------------------//
 		
        for(Integer i=0;i<scopeWTIDs.size();i++){
        	
            dfsle.Recipient myRecipient;
            dfsle.UUID myTemplateId;
            dfsle.Document myDocument;
            dfsle.CustomField Depositary;
            dfsle.Envelope myEnvelope;
            dfsle.Recipient.Authentication Auth;
            String MemberEmail;
			String Name;
            String DocuSignId;
            
            if(scopeWTIDs.get(i).Member_Email__c != null){
            	MemberEmail = scopeWTIDs.get(i).Member_Email__c;
            }
            if(scopeWTIDs.get(i).Member_Name__c != null){
            	Name = scopeWTIDs.get(i).Member_Name__c;
            }
            
            //------------------------------- Sending Docusign Email to Member email---------------------------//
            
            if(EmailToSend == 'Production' || EmailToSend == 'production'){
	        
	        	myRecipient = dfsle.Recipient.fromSource(Name,MemberEmail,null,'Signer 1',new dfsle.Entity(scopeWTIDs.get(i).Id));myRecipient = dfsle.Recipient.fromSource(Name,EmailToSend,null,'Signer 1',new dfsle.Entity(scopeWTIDs.get(i).Id));
	        }
	        
	        //-------------------------------Sending DocuSign Email to Current logged in user-------------------------//
	        
            if(EmailToSend != 'Production' || EmailToSend != 'production'){
	        
	        	myRecipient = dfsle.Recipient.fromSource(Name,userEmail,null,'Signer 1',new dfsle.Entity(scopeWTIDs.get(i).Id));
	        }
	        
            myTemplateId = dfsle.UUID.parse('9f83c1b8-23e7-49bb-a05f-fc81b6d0475c');
            myDocument =dfsle.Document.fromTemplate(myTemplateId,'Wire Transfer Authorization');
            Depositary = new dfsle.CustomField('text','##SFWIRES_Transaction__c',scopeWTIDs.get(i).Id, null,true, true);
            //Auth = new dfsle.Recipient.Authentication('',true,null);
            //myRecipient = myRecipient.withAuthentication(Auth);
            myEnvelope = new dfsle.Envelope(null,null, null,null,new List<dfsle.Document> { myDocument },null,new List<dfsle.CustomField> { Depositary },null,
															'Wire Approval',
															'My Message',null,null);
            
            myEnvelope = myEnvelope.withRecipients(new List<dfsle.Recipient> { myRecipient });
		    
            if(!Test.isRunningTest()){
            	myEnvelope = dfsle.EnvelopeService.sendEnvelope(myEnvelope, true);
            }
            // ---------------------------- Fetching DocusignId and inserting into Solar Loan record---------------------------------//
            
            DocuSignId = String.valueOf(myEnvelope).substringAfter('docuSignId=');
            DocuSignId = String.valueOf(DocuSignId).substringBefore(',');
            system.debug('tttt1'+DocuSignId);
            
            WIRES_Transaction__c w = new WIRES_Transaction__c();
            w.id = scopeWTIDs.get(i).Id;
            w.DocuSignId__c = DocuSignId.toUpperCase();
            
            WireTransactionToUpdate.add(w);
        }
        if(WireTransactionToUpdate.size() > 0){
        	update WireTransactionToUpdate;
        }
    }
    
    global void finish(Database.BatchableContext BC){
        
        
    }

}