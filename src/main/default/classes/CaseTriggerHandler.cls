/* Created by Dhwani Bhavsar to send Travel Notification Emails/SMS if it is created from Boomi Flow*/
public class CaseTriggerHandler {

	public void AfterUpdateMCSendNotification(Case[] newCases)
	{
			system.debug('Handler Called###');
			List<MasterCard_Travel_Confirmation__c> mctcList = new List<MasterCard_Travel_Confirmation__c>();
			map<id,id> AccountIds = new map<Id,Id>();
			map<id,id> MemberIds = new map<Id,Id>();
			set<id> CaseIds = new set<id>();
			set<id> setEmailconfirmation = new set<id>();
			set<id> setSMSconfirmation = new set<id>();
			
			for(case c: newCases){
				system.debug('CaseID=='+c.id);
				AccountIds.put(c.id,c.Account_Number__c);
				MemberIds.put(c.id,c.AccountId);
				CaseIds.add(c.id);			
			}
			
			List<MasterCard_Travel_Confirmation__c> mctcEmail= new List<MasterCard_Travel_Confirmation__c>();
			List<MasterCard_Travel_Confirmation__c> mctcSMS= new List<MasterCard_Travel_Confirmation__c>();
			mctcEmail = [SELECT id, Case__c from MasterCard_Travel_Confirmation__c where Case__c in: CaseIds and Message__c = 'Email'];
			mctcSMS = [SELECT id, Case__c from MasterCard_Travel_Confirmation__c where Case__c in: CaseIds and Message__c = 'SMS'];
			
			for(MasterCard_Travel_Confirmation__c mce: mctcEmail){
				setEmailconfirmation.add(mce.Case__c);			
			}
			
			for(MasterCard_Travel_Confirmation__c mcs: mctcSMS){
				setSMSconfirmation.add(mcs.Case__c);			
			}
			
			AggregateResult[] groupedResults = [SELECT case__c, min(Departure_Date__c)minDate, max(Return_Date__c)maxDate, IsEmailPreferred__c, Email__c, IsPhonePreferred__c, US_Mobile_Number__c
			      FROM Mastercard_Travel__c where case__c in: CaseIds and isPlacedFromBoomi__c =: true
			      GROUP BY case__c, IsEmailPreferred__c, Email__c, IsPhonePreferred__c, US_Mobile_Number__c];
			system.debug(groupedResults);
			
		    for(AggregateResult ar: groupedResults){
		    	if(Boolean.valueOf(ar.get('IsEmailPreferred__c')) && !String.isBlank(String.valueOf(ar.get('Email__c'))) && !setEmailconfirmation.contains(String.valueOf(ar.get('case__c')))){
		    		SendTravelNotificationEmail(MemberIds.get(String.valueOf(ar.get('case__c'))), Date.valueOf(ar.get('minDate')), Date.valueOf(ar.get('maxDate')),AccountIds.get(String.valueOf(ar.get('case__c'))), String.valueOf(ar.get('Email__c')), String.valueOf(ar.get('case__c')));
		    	}
		    	if(Boolean.valueOf(ar.get('IsPhonePreferred__c')) && !String.isBlank(String.valueOf(ar.get('US_Mobile_Number__c'))) && !setSMSconfirmation.contains(String.valueOf(ar.get('case__c')))){
		    		SendTravelNotificationSMS(MemberIds.get(String.valueOf(ar.get('case__c'))), Date.valueOf(ar.get('minDate')), Date.valueOf(ar.get('maxDate')),AccountIds.get(String.valueOf(ar.get('case__c'))), String.valueOf(ar.get('US_Mobile_Number__c')), String.valueOf(ar.get('case__c')));
		    	}
		    }
				
	}
    
 /* ------------- Send Email Notification ------------------------*/   
    public void SendTravelNotificationEmail(Id accId, date FromDate, date ToDate, string MemberAccountIdforEmail, string Email, string CaseId){
    	system.debug('Inside SendTravelNotificationEmail');
    	system.debug('FromDate:'+ FromDate);
    	system.debug('accId:'+ accId);
    	system.debug('ToDate:'+ ToDate);
    	system.debug('MemberAccountIdforEmail:'+ MemberAccountIdforEmail);
    	  Account acc = [select id, FirstName, LastName from account where id =: accId];
    	  string body='';
	      try{
		        list<Person_Account__c> paList = [SELECT Id,Brand__c,
		                               Account_Number__c, Account_Number__r.RecType__c,TypeTranslate__c, Account_Number__r.Name FROM Person_Account__c WHERE PersonID__c =:acc.Id and TypeTranslate__c like '%Primary%'];
		         
		        Account_Details__c memberaccount = new Account_Details__c();                      
		        if(MemberAccountIdforEmail != '' && MemberAccountIdforEmail != null){
		        	memberaccount = [select id, Brand__c from Account_Details__c where id =: MemberAccountIdforEmail];
		      } 
	                             
          List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
          Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
          List<String> sendTo = new List<String>();         
          sendTo.add(Email);
          mail.setToAddresses(sendTo);
          string templatenAME = '';
          if(memberaccount != null){
          	if(memberaccount.Brand__c == 'Spectrum'){
          		templatenAME ='Spectrum Travel Notification';
          	}
          	else
          	{
          		templatenAME ='CFCU Travel Notification';
          	}
          }
          else{
          	templatenAME ='CFCU Travel Notification';
          }       
          List<EmailTemplate> listEmailTemplate =  [select Id,Name,Body,Subject from EmailTemplate where Name =: templatenAME];
          
          mail.setSubject(listEmailTemplate[0].Subject);
          
          
          string emailadd;
          if(memberaccount != null){
          	if(memberaccount.Brand__c == 'Spectrum'){
          		emailadd ='noreply@spectrumcu.org';
          	}
          	else
          	{
          		emailadd ='noreply@chevronfcu.org';
          	}
          }
          else{
          	templatenAME ='CFCU Travel Notification';
          }         
          
          List<OrgWideEmailAddress> listAdd = [select Id,Address,DisplayName  from OrgWideEmailAddress where Address =: emailadd];
          Datetime fdt = datetime.newInstance(FromDate.year(), FromDate.month(),FromDate.day());
          String fdateStr =  fdt.format('MM/dd/yy');
          Datetime tdt = datetime.newInstance(ToDate.year(), ToDate.month(),ToDate.day());
          String tdateStr =  tdt.format('MM/dd/yy') ;
          body = listEmailTemplate[0].body.replace('$MemberName', acc.FirstName + ' '  + acc.LastName).replace('$StartDate', fdateStr).replace('$EndDate', tdateStr);
  
          mail.setPlainTextBody(body);
          mail.setOrgWideEmailAddressId(listAdd[0].Id);
          mails.add(mail);
          
          Messaging.sendEmail(mails);
          
          addTravelNotificationConfirmation(CaseId, 'Email', body, true);        
        
      }
      catch(exception e){
       	addTravelNotificationConfirmation(CaseId, 'Email', body, false); 
      }
    
    }
    
    
     /* ------------- Send SMS Notification ------------------------*/   
    public void SendTravelNotificationSMS(Id accId, date FromDate, date ToDate, string MemberAccountIdforEmail, string PhoneNo, string CaseId)
    {
      string smstext='';
      Account acc = [select id, FirstName, LastName from account where id =: accId];
      try{
            List <smagicinteract__smsmagic__c> smsObjectList = new List <smagicinteract__smsmagic__c>();
            String senderId = 'CreditUnion';
            smagicinteract__smsMagic__c smsObject = new smagicinteract__smsMagic__c();
            smsObject.smagicinteract__SenderId__c = 'CreditUnion';
            string emailadd;
            list<Person_Account__c> paList = [SELECT Id,Brand__c,
                             Account_Number__c, Account_Number__r.RecType__c,TypeTranslate__c, Account_Number__r.Name FROM Person_Account__c WHERE PersonID__c =:acc.Id];
           Account_Details__c memberaccount = new Account_Details__c();                      
	        if(MemberAccountIdforEmail != '' && MemberAccountIdforEmail != null){
	        	memberaccount = [select id, Brand__c from Account_Details__c where id =: MemberAccountIdforEmail];
	        } 
	        if(memberaccount != null){
	        	if(memberaccount.Brand__c == 'Spectrum'){
	        		emailadd ='SpectrumTravelNoticeSMS';
	        	}
	        	else
	        	{
	        		emailadd ='CFCUTravelNoticeSMS';
	        	}
	        }
	        else{
	        	emailadd ='CFCUTravelNoticeSMS';
	        }	    
          Datetime fdt = datetime.newInstance(FromDate.year(), FromDate.month(),FromDate.day());
          String fdateStr =  fdt.format('MM/dd/yy');
          Datetime tdt = datetime.newInstance(ToDate.year(), ToDate.month(),ToDate.day());
          String tdateStr =  tdt.format('MM/dd/yy') ;
          list<smagicinteract__SMS_Template__c> listTemplate =  [select Id,smagicinteract__Text__c from smagicinteract__SMS_Template__c where smagicinteract__Name__c =: emailadd];
          
            smsObject.smagicinteract__PhoneNumber__c = PhoneNo;
            smsObject.smagicinteract__Name__c = 'SMS - User'; // records name
            smsObject.smagicinteract__ObjectType__c = 'Contact'; // record type
            smsObject.smagicinteract__disableSMSOnTrigger__c = 0; // this field either be 0 or 1, if you specify the value as 1 then sms will not get send but entry of sms will get create under SMS History object
            smsObject.smagicinteract__external_field__c = smagicinteract.ApexAPI.generateUniqueKey();
            if(listTemplate.size() > 0 ) {
                 smsObject.smagicinteract__SMSText__c = listTemplate[0].smagicinteract__Text__c.replace('$StartDate',fdateStr).replace('$EndDate',tdateStr);
                 smstext = listTemplate[0].smagicinteract__Text__c.replace('$StartDate',fdateStr).replace('$EndDate',tdateStr);
            }
            smsObjectList.add(smsObject); 
            Database.insert(smsObjectList,false);    
             
             addTravelNotificationConfirmation(CaseId, 'SMS', smstext, true);      
            
      }
      catch(Exception ex){
       		addTravelNotificationConfirmation(CaseId, 'SMS', smstext, false);          
      }     
    }
    
    
     /* ------------- Get Travel Dates' range to append in Notification Email/SMS ------------------------*/   
    public map<string,date> getStartEndDates(List<Mastercard_Travel__c> listMCObj){
    	map<string, date> returnDateMap = new map<string,date>();
    	date minFromdate, maxTodate;
    	if(listMCObj.size() > 0){	              
	              minFromdate = listMCObj[0].Departure_Date__c;
	              maxTodate = listMCObj[0].Return_Date__c;
	              for(Mastercard_Travel__c mc:listMCObj){                
	                if(mc.Departure_Date__c < minFromdate){
	                  minFromdate = mc.Departure_Date__c;
	                }
	                if(mc.Return_Date__c > maxTodate){
	                  maxTodate = mc.Return_Date__c;
	                }             
	              }
	             returnDateMap.put('minDate',minFromdate);
	             returnDateMap.put('maxDate',maxTodate);
    		}
    	return returnDateMap;
    }
    
    
     /* ------------- Add Notification Confirmation------------------------*/   
    public void addTravelNotificationConfirmation(string CaseId, string Message, string MessageBody, boolean isSuccess){
     	List<Mastercard_Travel__c> listMCObj = [SELECT ID, CardId__c, Case__c, Email__c, US_Mobile_Number__c, IsEmailPreferred__c,IsPhonePreferred__c  from Mastercard_Travel__c where case__c  =: CaseId];
     	
     	 List<MasterCard_Travel_Confirmation__c> mctcList = new List<MasterCard_Travel_Confirmation__c>();
         map<string, string> accIds = new map<string, string>();
          for(Mastercard_Travel__c mc: listMCObj){
            Account_Details__c ac1 =[select id, Card_Number__c from Account_Details__c where id =: mc.CardId__c limit 1]; 
            accIds.put(ac1.Card_Number__c, mc.Case__c);
          }
          
          for(string s: accIds.keySet()){
	            	MasterCard_Travel_Confirmation__c mctc = new MasterCard_Travel_Confirmation__c();
	            	mctc.Case__c = accIds.get(s);  
	            	if(Message == 'Email'){
	            		mctc.isSuccessEmail__c = isSuccess;
	            		 mctc.Message_SentTo__c = listMCObj[0].Email__c;              
               		}     
               		if(Message == 'SMS'){
            			mctc.isSuccessPhone__c = isSuccess;
            			 mctc.Message_SentTo__c = listMCObj[0].US_Mobile_Number__c;              
               		}  
	               mctc.Card_Number__c = s; 
	               mctc.Message__c = Message;	              
	               mctc.Message_Text__c = MessageBody;    
	               mctcList.add(mctc);  
          }                 
         
             insert mctcList;
     }
}