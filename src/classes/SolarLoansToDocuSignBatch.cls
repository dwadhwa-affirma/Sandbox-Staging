global class SolarLoansToDocuSignBatch implements Database.Batchable<sObject>,Database.AllowsCallouts{    

    Set<Id> SLIdsToSend = new Set<Id>();
   
    global SolarLoansToDocuSignBatch(Set<Id> SLIds){
    	SLIdsToSend = SLIds;
    }
	
    global Database.QueryLocator start(Database.BatchableContext BC){
        
        return DataBase.getQueryLocator([SELECT Id,Brand__c,Name,Product_Loan_Type__c, Member_Name__c,Member_Name__r.Name,Member_Name__r.PersonEmail,Routing_Number__c,Member_Number__c,Primary_First_Name__c,Primary_Last_Name__c FROM Solar_Loans__c WHERE Id IN: SLIdsToSend]);
    }
    
    global void execute(Database.BatchableContext BC,List<Solar_Loans__c> scopeSLIDs){
        
  		List<Solar_Loans__c> SolarLoansToUpdate = new List<Solar_Loans__c>();
  		String EmailToSend;
        List<string> EmailList = new List<String>();
        
        //--------------------------------Current User Email ------------------------------------------------------//
        
        String userName = UserInfo.getUserName();
		User activeUser = [Select Email From User where Username = : userName limit 1];
		String userEmail = activeUser.Email;
 
 		//--------------------------------Current User Email ------------------------------------------------------//
 		
  		SolarLoan_Docusign_Emails__c sde = SolarLoan_Docusign_Emails__c.getValues('Email For Testing');
        
        if(sde.Emails__c != null){
            EmailToSend = sde.Emails__c;
        }    
        
        for(Integer i=0;i<scopeSLIDs.size();i++){
        	
            dfsle.Recipient myRecipient;
            dfsle.UUID myTemplateId;
            dfsle.Document myDocument;
            dfsle.CustomField Depositary;
            dfsle.Envelope myEnvelope;
            Account Member;
			String MemberId;
            String DocuSignId;
            
           
            if(scopeSLIDs.get(i).Member_Name__c != null){
            	Member = [select id, name, PersonEmail from account where id =:scopeSLIDs.get(i).Member_Name__c Limit 1];
            }
	        
	        //------------------------------- Sending Docusign Email to Member directly--------------------------------//
	        
            if(EmailToSend == 'Production' || EmailToSend == 'production'){
            	
	            system.debug('Member.PersonEmail'+Member.PersonEmail);
	            
	            if(Member.PersonEmail != null){
	            	myRecipient = dfsle.Recipient.fromSource(Member.Name,Member.PersonEmail,null,'Signer 1',new dfsle.Entity(scopeSLIDs.get(i).Id));
	            }
            } 
           
            //------------------------------- Sending Docusign Email to Custom setting email---------------------------//
            
	        if(EmailToSend != null && (EmailToSend != 'Production' || EmailToSend != 'production')){
	        
	        	myRecipient = dfsle.Recipient.fromSource(Member.Name,emailToSend,null,'Signer 1',new dfsle.Entity(scopeSLIDs.get(i).Id));
	        }
	        
	        //-------------------------------Sending DocuSign Email to Current logged in user-------------------------//
	        
	        if(EmailToSend == null){
	        
	        	myRecipient = dfsle.Recipient.fromSource(Member.Name,userEmail,null,'Signer 1',new dfsle.Entity(scopeSLIDs.get(i).Id));
	        }
	        
	        	
        	if(scopeSLIDs.get(i).Brand__c == 'Spectrum'){
            	myTemplateId = dfsle.UUID.parse('dc16d8f8-571c-497e-bbf5-42d8b25d4ee1');  //Spectrum
            }
            else{
            	myTemplateId = dfsle.UUID.parse('ad01d585-ad0a-4e68-b537-7e75293f0ef8');  //Chevron	
            }
	            
            myDocument =dfsle.Document.fromTemplate(myTemplateId,'Spectrum ACH Debits');
   			Depositary = new dfsle.CustomField('text','##SFSolar_Loans__c',scopeSLIDs.get(i).Id, null,true, true);
		    myEnvelope = new dfsle.Envelope(null,null, null,null,new List<dfsle.Document> { myDocument },null,new List<dfsle.CustomField> { Depositary },null,
													'ACH Debits',
													'In order for the Credit Union to ensure your solar loan automatic payment setup is accurate, please review and sign the ACH form.' +'\n\n' +'If changes are needed or you would like to provide additional payments, please update the form and sign.' +'\n\n' + 'If you have any questions, please contact us at 800-782-8782 ext. 5200.',null,null);
			 myEnvelope = myEnvelope.withRecipients(new List<dfsle.Recipient> { myRecipient });
				 
			 if(!Test.isRunningTest()){
    			myEnvelope = dfsle.EnvelopeService.sendEnvelope(myEnvelope, true);
    		 }
	       
            
            // ---------------------------- Fetching DocusignId and inserting into Solar Loan record---------------------------------//
            
            DocuSignId = String.valueOf(myEnvelope).substringAfter('docuSignId=');
            DocuSignId = String.valueOf(DocuSignId).substringBefore(',');
            system.debug('tttt1'+DocuSignId);
            
            Solar_Loans__c s = new Solar_Loans__c();
            s.id = scopeSLIDs.get(i).Id;
            s.DocuSignId__c = DocuSignId.toUpperCase();
            
            SolarLoansToUpdate.add(s);
        }
        
        if(SolarLoansToUpdate.size() > 0){
        	update SolarLoansToUpdate;
        }
    }
    
    global void finish(Database.BatchableContext BC){
        
        
    }

}