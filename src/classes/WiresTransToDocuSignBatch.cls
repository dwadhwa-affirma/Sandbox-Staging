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
            
            
            myRecipient = dfsle.Recipient.fromSource(Name,MemberEmail,null,'Signer 1',new dfsle.Entity(scopeWTIDs.get(i).Id));
            
            myTemplateId = dfsle.UUID.parse('5bef4974-2731-4d8b-8f72-4868a961dd60');
            myDocument =dfsle.Document.fromTemplate(myTemplateId,'Wires Template');
            Depositary = new dfsle.CustomField('text','##SFWIRES_Transaction__c',scopeWTIDs.get(i).Id, null,true, true);
            Auth = new dfsle.Recipient.Authentication('',true,null);
            myRecipient = myRecipient.withAuthentication(Auth);
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