trigger MasterCardTravelTrigger on Mastercard_Travel__c (before delete, after update, after delete) {
	 public static Master_Card_Configurations__c csATM = Master_Card_Configurations__c.getValues('ATM');
  	public static Master_Card_Configurations__c csDebit = Master_Card_Configurations__c.getValues('DEBIT');
  	public static Master_Card_Configurations__c csHSA = Master_Card_Configurations__c.getValues('HSA');
  	
  				string validTypesATM = csATM.Card_Type__c;
        		 List<string> validcardtypesATM =  validTypesATM.split(',');	
         
		          string validTypesDebit = csDebit.Card_Type__c;
		         List<string> validcardtypesDebit =  validTypesDebit.split(',');	
		         
		          string validTypesHSA = csHSA.Card_Type__c;
		         List<string> validcardtypesHSA =  validTypesHSA.split(',');
		         
     if(Trigger.isDelete && Trigger.isBefore){
     	system.debug('2');
		for(Mastercard_Travel__c m: Trigger.old){
			List<Mastercard_Travel__c> mcobj = [select id, CardId__c,Case__c,Country__c,Departure_Date__c, Destination__c,Email__c, Return_Date__c, Name,IsEmailPreferred__c, IsPhonePreferred__c, State__c,StateList__c,US_Mobile_Number__c,  CardId__r.Card_Number_Last_4_Digits__c,CardId__r.TypeTranslate__c,Timezone__c, CardId__r.Card_Number__c from Mastercard_Travel__c where case__c =: m.Case__c];
			if(mcobj.size() == 1){				
				List<case> tempCase = [Select id from Case where id =: m.Case__c and Status <> 'Closed'];
				
				if(tempCase.size() > 0){
					List<OnBase_Document__c> pendingAttachCases = [select case__c, document_type__c from OnBase_Document__c where ((case__c =:tempCase[0].id or Member_Comment__r.Case__C =:tempCase[0].id) and document_type__c = '')];
					if(pendingAttachCases.size() >= 1){
						for(OnBase_Document__c o:pendingAttachCases){
							o.document_type__c = '	Not For OnBase';
						}
						update pendingAttachCases;
					}	
						tempCase[0].OwnerId = '005j000000DCwXHAA1';
						tempCase[0].Status = 'Closed';
       		 			update tempCase;
				}
			}	
			Account_Details__c ac = [Select Id, Name, Card_Number_Last_4_Digits__c, TypeTranslate__c from Account_Details__c where Id=: m.CardId__c];
			string cardString = '', description = '';
			if(ac != null){	            		
		            	
			            	string cardtype= ac.TypeTranslate__c.substring(0, 2);
				        	if(validcardtypesATM.contains(cardtype)){
				        		cardString = 'ATM';
				        	}
				        	else if(validcardtypesDebit.contains(cardtype)){
				        		cardString = 'DEBIT';
				        	}
				        	else if(validcardtypesHSA.contains(cardtype)){
				    	   		cardString = 'HSA';
				        	}  
				        	cardString = cardString + ' - ' +  (ac.Card_Number_Last_4_Digits__c);
		            	}
		      for(Mastercard_Travel__c mc :mcobj){
		      	datetime ddate= Datetime.valueof(mc.Departure_Date__c + ' 00:00:00');
	            datetime rdate= Datetime.valueof(mc.Return_Date__c + ' 00:00:00');
    					
	            		description = description + (ddate.format('MMM dd, yyyy')) + ' ' + (rdate.format('MMM dd, yyyy'));
	            		if(mc.Destination__c == 'Domestic')
	             	 		{
	             	 			description = description + ' ' + mc.State__c;
	             	 		}
	             	 		else
	             	 		{
	             	 			description = description + ' ' + mc.Country__c;
	             	 		}
	        	description = description + ' America/Los_Angeles ' + cardString;
	        	system.debug('mc==='+mc);
	        	system.debug('m==='+m);
	        	if((mc.Departure_Date__c == m.Departure_Date__c) && (mc.Return_Date__c == m.Return_Date__c) && ((mc.State__c == m.State__c) || (mc.Country__c == m.Country__c))){
	        		system.debug('Entered');
	        		description = description + '- Deleted \n';
	        	}
	        	else
	        	{
	        		description = description + '\n';
	        	}
		      	
		      }
		      system.debug('description==='+description);
		      case casetoUpdate = [Select id, Description from Case where id =: m.Case__c];
		      string finaldesc = description;
		      if(casetoUpdate.Description != null && casetoUpdate.Description != ''){
			      string[] SplitDesc = casetoUpdate.Description.split('Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec');
				  system.debug(SplitDesc[0]);
				  string originaldesc =SplitDesc[0];
				  finaldesc = SplitDesc[0] + description;
					system.debug(finaldesc); 
		      }
		       casetoUpdate.Description = finaldesc;
		       update casetoUpdate;
	
			
						
		}
	}
	
	if(Trigger.isDelete && Trigger.isAfter){
	
	}
	if(Trigger.isUpdate && Trigger.isAfter){
		
		for(Mastercard_Travel__c m: Trigger.new){
			List<Mastercard_Travel__c> mcobj = [select id, CardId__c,Case__c,Country__c,Departure_Date__c, Destination__c,Email__c, Return_Date__c, Name,IsEmailPreferred__c, IsPhonePreferred__c, State__c,StateList__c,US_Mobile_Number__c,  CardId__r.Card_Number_Last_4_Digits__c,CardId__r.TypeTranslate__c,Timezone__c, CardId__r.Card_Number__c from Mastercard_Travel__c where case__c =: m.Case__c];
			Account_Details__c ac = [Select Id, Name, Card_Number_Last_4_Digits__c, TypeTranslate__c from Account_Details__c where Id=: m.CardId__c];
			string cardString = '', description = '';
			if(ac != null){	            		
		            	
			            	string cardtype= ac.TypeTranslate__c.substring(0, 2);
				        	if(validcardtypesATM.contains(cardtype)){
				        		cardString = 'ATM';
				        	}
				        	else if(validcardtypesDebit.contains(cardtype)){
				        		cardString = 'DEBIT';
				        	}
				        	else if(validcardtypesHSA.contains(cardtype)){
				    	   		cardString = 'HSA';
				        	}  
				        	cardString = cardString + ' - ' +  (ac.Card_Number_Last_4_Digits__c);
		            	}
		      for(Mastercard_Travel__c mc :mcobj){
		      	datetime ddate= Datetime.valueof(mc.Departure_Date__c + ' 00:00:00');
	            datetime rdate= Datetime.valueof(mc.Return_Date__c + ' 00:00:00');
    					
	            		description = description + (ddate.format('MMM dd, yyyy')) + ' ' + (rdate.format('MMM dd, yyyy'));
	            		if(mc.Destination__c == 'Domestic')
	             	 		{
	             	 			description = description + ' ' + mc.State__c;
	             	 		}
	             	 		else
	             	 		{
	             	 			description = description + ' ' + mc.Country__c;
	             	 		}
	        	description = description + ' America/Los_Angeles ' + cardString + '\n';
		      	
		      }
		      system.debug('description==='+description);
		      case tempCase = [Select id, Description from Case where id =: m.Case__c];
		      string finaldesc = description;
		      if(tempCase.Description != null && tempCase.Description != ''){
			      string[] SplitDesc = tempCase.Description.split('Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec');
				  system.debug(SplitDesc[0]);
				  string originaldesc =SplitDesc[0];
				  finaldesc = SplitDesc[0] + description;
					system.debug(finaldesc); 
		      }
		       tempCase.Description = finaldesc;
		       update tempCase;
		  
			
			
		}
		
	}
}