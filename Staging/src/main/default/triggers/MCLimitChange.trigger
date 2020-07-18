trigger MCLimitChange on MC_Limit_Change__c (after insert) {

	list<string> listString = new list<string>();  
	List<string> accDetailName = new List<string>();
	List<MC_Limit_Change__c> MCLimitRecords = new List<MC_Limit_Change__c>();
	List<Account_Details__c> accDetailMap = new List<Account_Details__c>();
	Map<string,string> accountMemberBranch = new Map<string,string>();
	String emailRegex = '([a-zA-Z0-9_\\-\\.]+)@((\\[a-z]{1,3}\\.[a-z]{1,3}\\.[a-z]{1,3}\\.)|(([a-zA-Z0-9\\-]+\\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})';
	Pattern MyPattern = Pattern.compile(emailRegex);
	
    for(MC_Limit_Change__c objMCLIMIT: trigger.New){
    	
    	accDetailName.add(objMCLIMIT.Member_Number__c);		
    	MCLimitRecords.add(objMCLIMIT);	
    }
    
    if(accDetailName.size() > 0){
    	
    	System.debug('Set: '+accDetailName);
    	accDetailMap = [select id,Brand__c, Name from Account_Details__c where Name In :accDetailName];
    	
    	for(Account_Details__c acc : accDetailMap){
    		if(!accountMemberBranch.containsKey(acc.Name)){
    			accountMemberBranch.put(acc.Name,acc.Brand__c);
    		}	
		}
    	
	    for(MC_Limit_Change__c MLC: MCLimitRecords){
			 
			string brand = accountMemberBranch.get(MLC.Member_Number__c);
			System.debug('Brand' + brand);
			
			if (MLC.Email__c == null || !MyPattern.matcher(MLC.Email__c).matches()) {
				
				MC_Limit_Change_Log__c objLog =  new MC_Limit_Change_Log__c();
				objLog.ODS_Key__c = MLC.OdsKey__c;
				if(MLC.Email__c == null)
				{
					objLog.Email_Message__c = 'NULL';
				}
				else{
					objLog.Email_Message__c = 'Invalid email ' + MLC.Email__c;
				}
				insert objLog;
			}
			else{
				SendLimitChangeEmail(MLC.Email__c, brand, MLC.Card_Number__c);			
			}
			
			
			if(MLC.Mobile_Phone__c != null){
				
				SendSMS(MLC.Mobile_Phone__c, brand, MLC.Card_Number__c);
			}
			else{
				
				MC_Limit_Change_Log__c objLog =  new MC_Limit_Change_Log__c();
				objLog.ODS_Key__c = MLC.OdsKey__c;
				if(MLC.Mobile_Phone__c == null)
				{
					objLog.Phone_Message__c = 'NULL';
				}else{
					
					objLog.Phone_Message__c = MLC.Mobile_Phone__c;	
				}
				insert objLog;
			}	
		
	    }
    	
    }
    
    private void SendLimitChangeEmail(string ToEmail, string Brand, string cardnumber){
    	
		List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
		Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
		List<String> sendTo = new List<String>();
		string emailadd;
		sendTo.add(ToEmail);
		mail.setToAddresses(sendTo);
		string templatenAME = 'MC Limit Change ' + Brand;
				
		List<EmailTemplate> listEmailTemplate =  [select Id,Name,Body,Subject,HtmlValue from EmailTemplate where Name =: templatenAME];
		mail.setSubject(listEmailTemplate[0].Subject);
		
		
		if(Brand == 'Spectrum'){
        	emailadd = 'noreply@spectrumcu.org';
        }
        else{
        	emailadd = 'noreply@chevronfcu.org';
        }    			
    	
    	List<OrgWideEmailAddress> listAdd = [select Id,Address,DisplayName  from OrgWideEmailAddress where Address =: emailadd];
    	string body = listEmailTemplate[0].HtmlValue.replace('ending in','ending in ' +cardnumber);
    	mail.setHtmlBody(body);
        mail.setOrgWideEmailAddressId(listAdd[0].Id);
        mails.add(mail);
       
        Messaging.sendEmail(mails);
    }
    
    private void SendSMS(string phone, string Brand, string cardnumber){
    	
    	List<smagicinteract__smsmagic__c> smsObjectList = new List<smagicinteract__smsmagic__c>();
        String senderId = 'CreditUnion';
        smagicinteract__smsMagic__c smsObject = new smagicinteract__smsMagic__c();
        smsObject.smagicinteract__SenderId__c = 'CreditUnion';
        string emailadd;
        
        emailadd = Brand + ' MC Limit Change';
        List<smagicinteract__SMS_Template__c> listTemplate =  [select Id, smagicinteract__Text__c from smagicinteract__SMS_Template__c where smagicinteract__Name__c =: emailadd];
        
        smsObject.smagicinteract__PhoneNumber__c = phone;
        smsObject.smagicinteract__Name__c = 'SMS - User';	
        
        smsObject.smagicinteract__disableSMSOnTrigger__c = 0;
        smsObject.smagicinteract__external_field__c = smagicinteract.ApexAPI.generateUniqueKey();
        if (listTemplate.size() > 0){
            smsObject.smagicinteract__SMSText__c = listTemplate[0].smagicinteract__Text__c.replace('XXXX', cardnumber);
        }
        smsObjectList.add(smsObject);
        Database.insert(smsObjectList, false);
    	
    }    
}