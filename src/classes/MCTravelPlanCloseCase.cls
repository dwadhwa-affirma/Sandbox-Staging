global class MCTravelPlanCloseCase implements Schedulable {
	
	  global void execute(SchedulableContext ctx) {
	  		  List<Mastercard_Travel__c> ListMastercardObj = [select id, CardId__c,Case__c,Country__c,Departure_Date__c, Destination__c,Email__c, Return_Date__c, Name,IsEmailPreferred__c, IsPhonePreferred__c, State__c,StateList__c,US_Mobile_Number__c,  CardId__r.Card_Number_Last_4_Digits__c,CardId__r.TypeTranslate__c,Timezone__c, CardId__r.Card_Number__c from Mastercard_Travel__c where Return_Date__c <=: (System.today() - 1) and case__r.Status != 'Closed'];
	  		  
	  		  Set<String> CaseIds = new Set<String>();
	  		  Set<String> FutureCaseIds = new Set<String>();
	  		  Set<String> FinalCaseIds = new Set<String>();
	  		   List<Case> CasetoUpdate = new List<Case>();
	  		   for(Mastercard_Travel__c mc : ListMastercardObj){        	
		        	CaseIds.add(mc.Case__c);      	
       		 	}
       		 	
       		 	List<Mastercard_Travel__c> mcListFuture = [select id, CardId__c,Case__c,Country__c,Departure_Date__c, Destination__c,Email__c, Return_Date__c, Name,IsEmailPreferred__c, IsPhonePreferred__c, State__c,StateList__c,US_Mobile_Number__c,  CardId__r.Card_Number_Last_4_Digits__c,CardId__r.TypeTranslate__c,Timezone__c, CardId__r.Card_Number__c from Mastercard_Travel__c where case__c In: CaseIds and Return_Date__c >: (System.today() - 1)];
       		 	for(Mastercard_Travel__c mc : mcListFuture){        	
		        	FutureCaseIds.add(mc.Case__c);      	
       		 	}
       		 	
       		 	/*for(string orinicalCaseId: CaseIds){
       		 		boolean isFuture = false;
       		 		for(string futureCaseId: FutureCaseIds){
       		 			if(orinicalCaseId == futureCaseId){
       		 				isFuture = true;
       		 			}
       		 		}
       		 		if(!isFuture){
       		 			FinalCaseIds.add(orinicalCaseId);
       		 		}
       		 	}*/
       		 	
       		 	for(string mc : CaseIds){
       		 		if(!FutureCaseIds.contains(mc)){
       		 			FinalCaseIds.add(mc);
       		 		}      		 		
       		 	}	 	
       		 	
       		 	system.debug('FinalCaseIds=='+FinalCaseIds);
       		 	
       		 	MCTravelPlanCloseCaseBatch obj1 = new MCTravelPlanCloseCaseBatch(FinalCaseIds);
        		Database.executeBatch(obj1, 20);
        	
       		 	/*CasetoUpdate = [Select id, OwnerId, Status from Case where id in: FinalCaseIds];
       		 	List<OnBase_Document__c> pendingAttachCases = [select case__c, document_type__c from OnBase_Document__c where ((case__c in: FinalCaseIds or Member_Comment__r.Case__C in: FinalCaseIds) and document_type__c = '')];
       		 	if(pendingAttachCases.size() >= 1){
						for(OnBase_Document__c o:pendingAttachCases){
							o.document_type__c = '	Not For OnBase';
						}
						update pendingAttachCases;
					}	
       		 	for(Case c : CasetoUpdate){
       		 		   c.OwnerId = '005j000000DCwXHAA1';
       		 			c.Status = 'Closed';       		 		
       		 	}
       		 
       		  	update CasetoUpdate;*/
	  }
    
}