global class SolarLoansToDocuSignBatch implements Database.Batchable<sObject>,Database.AllowsCallouts{    

    Set<Id> SLIdsToSend = new Set<Id>();
   
    global SolarLoansToDocuSignBatch(Set<Id> SLIds){
    	SLIdsToSend = SLIds;
    }
	
    global Database.QueryLocator start(Database.BatchableContext BC){
        
        return DataBase.getQueryLocator([SELECT Id,Name,Product_Loan_Type__c,Routing_Number__c,Member_Number__c,Primary_First_Name__c,Primary_Last_Name__c FROM Solar_Loans__c WHERE Id IN: SLIdsToSend]);
    }
    
    global void execute(Database.BatchableContext BC,List<Solar_Loans__c> scopeSLIDs){
        
  		List<Solar_Loans__c> SolarLoansToUpdate = new List<Solar_Loans__c>();
        
        for(Integer i=0;i<scopeSLIDs.size();i++){
        	
            dfsle.Recipient myRecipient;
            dfsle.UUID myTemplateId;
            dfsle.Document myDocument;
            dfsle.CustomField Depositary;
            dfsle.Envelope myEnvelope;
            Account MemberEmail;
			String Name;
            String DocuSignId;
            
            if(scopeSLIDs.get(i).Primary_First_Name__c != null){
            	Name = scopeSLIDs.get(i).Primary_First_Name__c +' '+scopeSLIDs.get(i).Primary_Last_Name__c;
            }
            else if(scopeSLIDs.get(i).Primary_Last_Name__c != null){
            	Name = scopeSLIDs.get(i).Primary_Last_Name__c;
            }
            if(Name != null){
            	MemberEmail = [select id, name, PersonEmail from account where name =:Name Limit 1];
            }
            
            if(MemberEmail.PersonEmail != null){
            	myRecipient = dfsle.Recipient.fromSource(Name,MemberEmail.PersonEmail,null,'Signer 1',new dfsle.Entity(scopeSLIDs.get(i).Id));
            }
            myTemplateId = dfsle.UUID.parse('1b9f716c-1fbe-4e69-be6a-5162f91f39d2');
            myDocument =dfsle.Document.fromTemplate(myTemplateId,'Authorization');
            Depositary = new dfsle.CustomField('text','##SFSolar_Loans__c',scopeSLIDs.get(i).Id, null,true, true);
            myEnvelope = new dfsle.Envelope(null,null, null,null,new List<dfsle.Document> { myDocument },null,new List<dfsle.CustomField> { Depositary },null,
															'ACH Debits',
															'My Message',null,null);
            
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