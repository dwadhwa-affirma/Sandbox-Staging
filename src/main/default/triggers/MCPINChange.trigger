trigger MCPINChange on MC_PIN_Change__c (after insert) {
    
    list<string> listString = new list<string>();  
    for(MC_PIN_Change__c objMCPIN: trigger.New)
    {
    	String memberemail = objMCPIN.Email__c;
	      	string phone = objMCPIN.Mobile_Phone__c;
			String emailRegex = '([a-zA-Z0-9_\\-\\.]+)@((\\[a-z]{1,3}\\.[a-z]{1,3}\\.[a-z]{1,3}\\.)|(([a-zA-Z0-9\\-]+\\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})';
			Pattern MyPattern = Pattern.compile(emailRegex);
			
			string accountNumber =  objMCPIN.Member_Number__c;
			Account_Details__c obj =	[select id,Brand__c from Account_Details__c where Name =: accountNumber limit 1];
			
			
			if(obj != null)
			{
				
				
				if (memberemail == null || !MyPattern.matcher(memberemail).matches()) {
					
					MC_PIN_Change_Log__c objLog =  new MC_PIN_Change_Log__c();
					objLog.ODS_Key__c = objMCPIN.OdsKey__c;
					if(memberemail == null)
					{
						memberemail = 'NULL';
					}
					objLog.Email_Message__c = 'Invalid email ' + memberemail;
					insert objLog;
				}
				else
				{
					
					SendOTPEmail(memberemail, obj.Brand__c, objMCPIN.Card_Number__c);
					
				}
				
				if(phone != null)
				{
						SendSMS(phone, obj.Brand__c, objMCPIN.Card_Number__c);
					
				}
				else
				{
					MC_PIN_Change_Log__c objLog =  new MC_PIN_Change_Log__c();
					objLog.ODS_Key__c = objMCPIN.OdsKey__c;
					if(phone == null)
					{
						phone = 'NULL';
					}
					objLog.Phone_Message__c = phone;
					insert objLog;
				}
				
	      	

    	}
    }
    
 
    
    
    
    
   
    private void SendOTPEmail(string ToEmail, string Brand, string cardnumber)
    {
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        List<String> sendTo = new List<String>();
        sendTo.add(ToEmail);
        
        	
        mail.setToAddresses(sendTo);
        string templatenAME = 'MC PIN Change ' + Brand;
        List<EmailTemplate> listEmailTemplate =  [select Id,Name,Body,Subject,HtmlValue from EmailTemplate where Name =: templatenAME];
        
        mail.setSubject(listEmailTemplate[0].Subject);
        
        
        string emailadd;
        if(Brand == 'Spectrum')
        {
        	emailadd = 'noreply@spectrumcu.org';
        }
        else
        {
        	emailadd = 'noreply@chevronfcu.org';
        }
        
        List<OrgWideEmailAddress> listAdd = [select Id,Address,DisplayName  from OrgWideEmailAddress where Address =: emailadd];
        
        string body = listEmailTemplate[0].HtmlValue.replace('ending in','ending in ' +cardnumber);
        mail.setHtmlBody(body);
        mail.setOrgWideEmailAddressId(listAdd[0].Id);
        mails.add(mail);
        
        Messaging.sendEmail(mails);
        
    }
   
    
    private void SendSMS(string phone, string Brand, string cardnumber)
    {
        List<smagicinteract__smsmagic__c> smsObjectList = new List<smagicinteract__smsmagic__c>();
        String senderId = 'CreditUnion';
        smagicinteract__smsMagic__c smsObject = new smagicinteract__smsMagic__c();
        smsObject.smagicinteract__SenderId__c = 'CreditUnion';
        string emailadd;
       
       system.debug('UserInfo.getName()###' + UserInfo.getName());
        
        emailadd = Brand + ' MC PIN Change';
        list<smagicinteract__SMS_Template__c> listTemplate =  [select Id, smagicinteract__Text__c from smagicinteract__SMS_Template__c where smagicinteract__Name__c =: emailadd];

        smsObject.smagicinteract__PhoneNumber__c = phone;
        smsObject.smagicinteract__Name__c = 'SMS - User'; // records name
     //   smsObject.smagicinteract__ObjectType__c = 'Contact'; // record type
        smsObject.smagicinteract__disableSMSOnTrigger__c = 0; // this field either be 0 or 1, if you specify the value as 1 then sms will not get send but entry of sms will get create under SMS History object
        smsObject.smagicinteract__external_field__c = smagicinteract.ApexAPI.generateUniqueKey();
        if (listTemplate.size() > 0)
        {
            smsObject.smagicinteract__SMSText__c = listTemplate[0].smagicinteract__Text__c.replace('XXXX', cardnumber);
        }
        smsObjectList.add(smsObject);
        Database.insert(smsObjectList, false);
       // LastOTPSent = System.Now();

    }
 
    
    
    
}