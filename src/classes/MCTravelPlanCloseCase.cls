global class MCTravelPlanCloseCase implements Schedulable {
	
	  global void execute(SchedulableContext ctx) {
	  		  List<Mastercard_Travel__c> ListMastercardObj = [select id, CardId__c,Case__c,Country__c,Departure_Date__c, Destination__c,Email__c, Return_Date__c, Name,IsEmailPreferred__c, IsPhonePreferred__c, State__c,StateList__c,US_Mobile_Number__c,  CardId__r.Card_Number_Last_4_Digits__c,CardId__r.TypeTranslate__c,Timezone__c, CardId__r.Card_Number__c from Mastercard_Travel__c where Return_Date__c <=: (System.today() - 1)];
	  		  List<String> CaseIds = new List<String>();
	  		  Set<String> FinalCaseIds = new Set<String>();
	  		   List<Case> CasetoUpdate = new List<Case>();
	  		   for(Mastercard_Travel__c mc : ListMastercardObj){        	
		        	CaseIds.add(mc.Case__c);      	
       		 	}
       		 	for(string cid:CaseIds){
       		 		Boolean removeCase=false;
       		 		List<Mastercard_Travel__c> mcobj = [select id, CardId__c,Case__c,Country__c,Departure_Date__c, Destination__c,Email__c, Return_Date__c, Name,IsEmailPreferred__c, IsPhonePreferred__c, State__c,StateList__c,US_Mobile_Number__c,  CardId__r.Card_Number_Last_4_Digits__c,CardId__r.TypeTranslate__c,Timezone__c, CardId__r.Card_Number__c from Mastercard_Travel__c where case__c =: cid];
       		 		if(mcobj.size() > 1){       		 			
       		 			for(Mastercard_Travel__c mc:mcobj){
       		 				if(mc.Return_Date__c > (System.today() - 1)){
       		 					removeCase =true;
       		 				}
       		 			}
       		 			if(!removeCase){
       		 				FinalCaseIds.add(cid);
       		 			}
       		 		}
       		 		else
       		 		{
       		 			FinalCaseIds.add(cid);
       		 		}
       		 	}
       		 	for(string c : FinalCaseIds){
       		 		List<case> tempCase = [Select id from Case where id =: c and Status <> 'Closed'];
       		 		if(tempCase.size() > 0){
       		 			CasetoUpdate.add(tempCase[0]);       		 			
       		 		}
       		 	}
       		 	for(Case c : CasetoUpdate){
       		 		   c.OwnerId = '005j000000DCwXHAA1';
       		 			c.Status = 'Closed';       		 		
       		 	}
       		 
       		  	update CasetoUpdate;
	  }
    
}