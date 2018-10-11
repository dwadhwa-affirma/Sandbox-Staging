trigger MasterCardTravelTrigger on Mastercard_Travel__c (before delete, after update, after delete) {
	
     if(Trigger.isDelete && Trigger.isBefore){
     	system.debug('2');
		for(Mastercard_Travel__c m: Trigger.old){
			List<Mastercard_Travel__c> mcobj = [select id, CardId__c,Case__c,Country__c,Departure_Date__c, Destination__c,Email__c, Return_Date__c, Name,IsEmailPreferred__c, IsPhonePreferred__c, State__c,StateList__c,US_Mobile_Number__c,  CardId__r.Card_Number_Last_4_Digits__c,CardId__r.TypeTranslate__c,Timezone__c, CardId__r.Card_Number__c from Mastercard_Travel__c where case__c =: m.Case__c];
			if(mcobj.size() == 1){
				system.debug('1');
				List<case> tempCase = [Select id from Case where id =: m.Case__c and Status <> 'Closed'];
				if(tempCase.size() > 0){
						tempCase[0].OwnerId = '005j000000DCwXHAA1';
						tempCase[0].Status = 'Closed';
       		 			update tempCase;
				}
			}	
			Account_Details__c ac = [Select Id, Name, Card_Number_Last_4_Digits__c, TypeTranslate__c from Account_Details__c where Id=: m.CardId__c];
			string cardString = '', description = '';
			if(ac != null){	            		
		            	
			            	string cardtype= ac.TypeTranslate__c.substring(0, 2);
				        	if(cardtype == '11' || cardtype == '12'){
				        		cardString = 'ATM';
				        	}
				        	else if(cardtype == '13' || cardtype =='14' || cardtype =='15'){
				        		cardString = 'DEBIT';
				        	}
				        	else if(cardtype == '16' || cardtype =='17'){
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
		       casetoUpdate.Description = description;
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
				        	if(cardtype == '11' || cardtype == '12'){
				        		cardString = 'ATM';
				        	}
				        	else if(cardtype == '13' || cardtype =='14' || cardtype =='15'){
				        		cardString = 'DEBIT';
				        	}
				        	else if(cardtype == '16' || cardtype =='17'){
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
		       tempCase.Description = description;
		       update tempCase;
		      
			
			/*Mastercard_Travel__c oldobj = Trigger.oldMap.get(m.Id);
			string oldDescription='', newDescription='';
			 string cardString = '';
			Account_Details__c ac = [Select Id, Name, Card_Number_Last_4_Digits__c, TypeTranslate__c from Account_Details__c where Id=: m.CardId__c];
		     if(ac != null){	            		
		            	
			            	string cardtype= ac.TypeTranslate__c.substring(0, 2);
				        	if(cardtype == '11' || cardtype == '12'){
				        		cardString = 'ATM';
				        	}
				        	else if(cardtype == '13' || cardtype =='14' || cardtype =='15'){
				        		cardString = 'DEBIT';
				        	}
				        	else if(cardtype == '16' || cardtype =='17'){
				    	   		cardString = 'HSA';
				        	}  
				        	cardString = cardString + ' - ' +  (ac.Card_Number_Last_4_Digits__c);
		            	}
		            	
		       			datetime ddate= Datetime.valueof(oldobj.Departure_Date__c + ' 00:00:00');
	            		datetime rdate= Datetime.valueof(oldobj.Return_Date__c + ' 00:00:00');
    					
	            		oldDescription = oldDescription + (ddate.format('MMM dd, yyyy')) + ' ' + (rdate.format('MMM dd, yyyy'));
	            		if(oldobj.Destination__c == 'Domestic')
	             	 		{
	             	 			oldDescription = oldDescription + ' ' + oldobj.State__c;
	             	 		}
	             	 		else
	             	 		{
	             	 			oldDescription = oldDescription + ' ' + oldobj.Country__c;
	             	 		}
	        oldDescription = oldDescription + ' America/Los_Angeles ' + cardString + '\n';
	        
	        system.debug('oldDescription==='+oldDescription);
	        
	        datetime ddate1= Datetime.valueof(m.Departure_Date__c + ' 00:00:00');
	            		datetime rdate1= Datetime.valueof(m.Return_Date__c + ' 00:00:00');
    					
	            		newDescription = newDescription + (ddate1.format('MMM dd, yyyy')) + ' ' + (rdate1.format('MMM dd, yyyy'));
	            		if(m.Destination__c == 'Domestic')
	             	 		{
	             	 			newDescription = newDescription + ' ' + m.State__c;
	             	 		}
	             	 		else
	             	 		{
	             	 			newDescription = newDescription + ' ' + m.Country__c;
	             	 		}
	        newDescription = newDescription + ' America/Los_Angeles ' + cardString + '\n';
	        system.debug('newDescription==='+newDescription);
	      
	       
			case tempCase = [Select id, Description from Case where id =: m.Case__c];
			  system.debug('tempCase==='+tempCase);
			if(tempCase != null){
				system.debug('tempCase Update loop');
				string Description = tempCase.Description;
				string finaldesc='';
				system.debug('tempCase Description::' +Description);
				Description = Description.replaceAll('\n','aaa');				
				system.debug('aaa Description::' +Description);
				Description = Description.replaceAll(oldDescription, newDescription);
				Description = Description.replaceAll('aaa','\n ');
				
				system.debug('new Description::' +Description);
				 tempCase.Description = Description;
				 system.debug('case Description::' +tempCase.Description);				 
				 update tempCase;
				 
			}*/
			
			
			
		}
		
	}
}