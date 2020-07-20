global class Wires_ProcessRecurrenceTransactionBatch implements Database.Batchable<sObject>{    
	
	
     global Database.QueryLocator start(Database.BatchableContext BC){
     		 return DataBase.getQueryLocator([SELECT Id, FromAccount__c, WireAmount__c,Fees__c,Description__c,Chevron_Account_Number__c,SendOn__c,
     		 									ToAccountName__c, ToAccoutId__c, Share_ID__c,Frequency__c FROM WIRES_Transaction__c WHERE Frequency__c = 'Recurring'
     	 																		AND	TransactionStatus__c = 'Pending' AND Recurrence_Pattern__c = 'Monthly'	
     	 																		AND StartDate__c <=: Date.today() and RecurrenceEndDate__c >=: Date.today()
     	 																		AND RecurrenceDay__c = : Date.today().day() ]);    
     }
     
      global void execute(Database.BatchableContext BC,List<WIRES_Transaction__c> scopeWTIDs){
      	List<WIRES_Transaction__c> onetimeWireObjs = new List<WIRES_Transaction__c>();
      		for(WIRES_Transaction__c wtc: scopeWTIDs){
      			WIRES_Transaction__c objWTC = new WIRES_Transaction__c();
      			objWTC.FromAccount__c = wtc.FromAccount__c;
      			objWTC.WireAmount__c =wtc.WireAmount__c;
      			objWTC.Fees__c =wtc.Fees__c;
      			objWTC.Description__c=wtc.Description__c;
      			objWTC.Chevron_Account_Number__c=wtc.Chevron_Account_Number__c;
      			objWTC.SendOn__c=Date.today();
      			objWTC.ToAccountName__c=wtc.ToAccountName__c;
      			objWTC.ToAccoutId__c=wtc.ToAccoutId__c;
      			objWTC.Share_ID__c=wtc.Share_ID__c;
      			objWTC.Frequency__c='One - Time'; 
      			objWTC.ParentTransaction__c = wtc.id;
      			objWTC.Approval_Status__c = 'Pending for Approval';
      			onetimeWireObjs.add(objWTC);		
      		}
      	insert onetimeWireObjs;
      }
      
       global void finish(Database.BatchableContext BC){
        
       }
        
}