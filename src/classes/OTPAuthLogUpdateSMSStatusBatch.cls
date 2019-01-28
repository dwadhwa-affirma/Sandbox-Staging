global class OTPAuthLogUpdateSMSStatusBatch implements Database.Batchable<sObject>{
     global Database.QueryLocator start(Database.BatchableContext BC){
     String Query='Select Id, OTP_Phone__c, created_del1__c, OTP_Status__c from Authenticated_Log__c where OTP_Phone__c != null and OTP_Status__c = null';
      return Database.getQueryLocator(Query);
      
   }

   global void execute(Database.BatchableContext BC, List<Authenticated_Log__c> scope){
   		set<string> setPhoneNumber = new set<string>();   	
		set<string> setFormattedPhoneNumber = new set<string>();   	
   		map<id, string> mapFinalStatus=new map<id, string>();
   		
   		for(Authenticated_Log__c al: scope){
   			setFormattedPhoneNumber.add(al.OTP_Phone__c.replace('-',''));	
            setPhoneNumber.add(al.OTP_Phone__c);	
   		}
    	List<smagicinteract__smsMagic__c> smsHistoryList=[select id, smagicinteract__sentStatus__c, smagicinteract__PhoneNumber__c, smagicinteract__CreatedOn__c
    														from smagicinteract__smsMagic__c where (smagicinteract__PhoneNumber__c in: setPhoneNumber or smagicinteract__PhoneNumber__c in: setFormattedPhoneNumber)];
    	system.debug('smsHistoryList###'+smsHistoryList);													
    	List<Authenticated_Log__c> authenticationLogFinalList= new List<Authenticated_Log__c>();
    	
    	for(Authenticated_Log__c al: scope){	
    		datetime createddatetocheckUpper = al.created_del1__c.addMinutes(3);	
            datetime createddatetocheckLower = al.created_del1__c.addMinutes(-1);	
           // system.debug('createddatetocheck==' + createddatetocheck);
        	for(smagicinteract__smsMagic__c sms: smsHistoryList){     
            //    system.debug('sms.smagicinteract__CreatedOn__c=='+sms.smagicinteract__CreatedOn__c);
        		if(al.OTP_Phone__c.replace('-','') == sms.smagicinteract__PhoneNumber__c.replace('-','') && sms.smagicinteract__CreatedOn__c >= al.created_del1__c){
        		//(sms.smagicinteract__CreatedOn__c >= createddatetocheckLower && sms.smagicinteract__CreatedOn__c <= createddatetocheckUpper)){                   
        			if(sms.smagicinteract__sentStatus__c == 'Submitted'){
        				al.OTP_Status__c ='Success';                       
                        break;
        			}
        			else
        			{
        				al.OTP_Status__c ='Failure';  
                        break;
        			}
        		}
        	}
        	if(al.OTP_Status__c == null){
        		al.OTP_Status__c = 'Failure';
        	}
        	authenticationLogFinalList.add(al);
        }
        system.debug('authenticationLogFinalList###'+authenticationLogFinalList);
        
        update authenticationLogFinalList;
        
    
    }

   global void finish(Database.BatchableContext BC){
   }
}