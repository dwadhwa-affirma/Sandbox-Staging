trigger WiresBeneficiaryOTP on Wires_Beneficiary_OTP__c (before insert) {
    
    list<string> listString = new list<string>();     
    List<Wires_Beneficiary_OTP__c> objUpdateOTP = new List<Wires_Beneficiary_OTP__c>();
    
    
    for(Wires_Beneficiary_OTP__c objWiresBeneficiaryotp: trigger.New)
    {
        
        
        string accountNumber =  objWiresBeneficiaryotp.Member_Number__c;
        system.debug('accountNumber=='+ accountNumber);
        Account_Details__c obj =  [select id,Brand__c from Account_Details__c where Name =: accountNumber limit 1];    
        
        string memberemail = objWiresBeneficiaryotp.Email__c;
        string phone = objWiresBeneficiaryotp.Mobile_Phone__c;
        String emailRegex = '([a-zA-Z0-9_\\-\\.]+)@((\\[a-z]{1,3}\\.[a-z]{1,3}\\.[a-z]{1,3}\\.)|(([a-zA-Z0-9\\-]+\\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})';
        Pattern MyPattern = Pattern.compile(emailRegex); 
        
        
        string RandomNumber;
        RandomNumber =String.valueOf(Math.random());
        RandomNumber= RandomNumber.substring(2,8);
        objWiresBeneficiaryotp.OTP1__c = RandomNumber;
        
        
        if(obj != null)
        {
            
            
            if (memberemail == null || !MyPattern.matcher(memberemail).matches()) {
                
            }
            else
            {
                system.debug('memberemail=='+memberemail);
                SendOTPEmail(memberemail, obj.Brand__c, RandomNumber, accountNumber);
                //objUpdateOTP.add(objWiresBeneficiaryotp);
                
            }
            
            if(phone != null)
            {
                SendSMS(phone, obj.Brand__c, RandomNumber);
                //objUpdateOTP.add(objWiresBeneficiaryotp);
            }
            else
            {
                
            }
            
            
            
        }
    }
    
    //  update objUpdateOTP;
    
    
    
    
    
    
    private void SendOTPEmail(string ToEmail, string Brand, string otp, string accountNumber)
    {
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        List<String> sendTo = new List<String>();
        sendTo.add(ToEmail);
        
        
        mail.setToAddresses(sendTo);
        string templatenAME;
        string emailadd;
        if(Brand == 'Spectrum'){
            templateNAME = 'Wires One Time Passcode Spectrum';//'Spectrum WIRES Beneficiary OTP';
            emailadd = 'noreply@spectrumcu.org';
        }
        else 
        {
            templatenAME = 'Wires One Time Passcode Chevron';//'Chevron WIRES Beneficiary OTP';
            emailadd = 'noreply@chevronfcu.org';
        }
        
        //templatenAME = 'WIRES Beneficiary OTP';
        List<EmailTemplate> listEmailTemplate =  [select Id,Name,Body,Subject,HtmlValue from EmailTemplate where Name =: templatenAME];
        
        if(listEmailTemplate.size()>0){
        mail.setSubject(listEmailTemplate[0].Subject);        
        }else{
            mail.setSubject('Test');        
        }
        
        List<OrgWideEmailAddress> listAdd = [select Id,Address,DisplayName  from OrgWideEmailAddress where Address =: emailadd];
        string body='';
        
        List<Person_Account__c> paPrimary = [SELECT Id,PersonID__c,
                                           Account_Number__c, Account_Number__r.RecType__c,
                                           TypeTranslate__c, Account_Number__r.Name, 
                                           PersonID__r.Home_Phone__pc,
                                           PersonID__r.Mobile_Phone__pc,
                                           PersonID__r.Residential_City__pc,
                                           PersonID__r.Residential_State__pc, 
                                           PersonID__r.Residential_Street__pc, 
                                           PersonID__r.Residential_Zipocde__pc, 
                                           PersonID__r.Name, 
                                           PersonID__r.Email_raw__c 
                                           FROM Person_Account__c 
                                           WHERE Account_Number__r.Name =: accountNumber 
                                           and TypeTranslate__c  like '%Primary%' limit 1];
        
        if(listEmailTemplate.size()>0){
        	body = listEmailTemplate[0].HtmlValue.replace('{WIRESOTP}', otp);
            if(paPrimary.size() > 0)
            	body = body.replace('{Name}', paPrimary[0].PersonID__r.Name);
            else
                body = body.replace('{Name}', 'Member');
        }
        mail.setHtmlBody(body);
        mail.setOrgWideEmailAddressId(listAdd[0].Id);
        mails.add(mail);
        
        Messaging.sendEmail(mails);
        
    }
    
    
    private void SendSMS(string phone, string Brand, string otp)
    {
        List<smagicinteract__smsmagic__c> smsObjectList = new List<smagicinteract__smsmagic__c>();
        String senderId = 'CreditUnion';
        smagicinteract__smsMagic__c smsObject = new smagicinteract__smsMagic__c();
        smsObject.smagicinteract__SenderId__c = 'CreditUnion';
        string emailadd;
        
        system.debug('UserInfo.getName()###' + UserInfo.getName());
        
        if(Brand == 'Spectrum'){        
            emailadd = 'Spectrum WIRES Transaction OTP';
        }
        else
        {        
            emailadd = 'Chevron WIRES Transaction OTP';
        }
        
        //emailadd = 'WIRES Transaction OTP';
        list<smagicinteract__SMS_Template__c> listTemplate =  [select Id, smagicinteract__Text__c from smagicinteract__SMS_Template__c where smagicinteract__Name__c =: emailadd];
        
        smsObject.smagicinteract__PhoneNumber__c = phone;
        smsObject.smagicinteract__Name__c = 'SMS - User'; // records name
        smsObject.smagicinteract__ObjectType__c = 'Contact'; // record type
        smsObject.smagicinteract__disableSMSOnTrigger__c = 0; // this field either be 0 or 1, if you specify the value as 1 then sms will not get send but entry of sms will get create under SMS History object
        smsObject.smagicinteract__external_field__c = smagicinteract.ApexAPI.generateUniqueKey();
        if (listTemplate.size() > 0)
        {
            smsObject.smagicinteract__SMSText__c = listTemplate[0].smagicinteract__Text__c.replace('{WIRESOTP}', otp);
        }
        smsObjectList.add(smsObject);
        Database.insert(smsObjectList, false);
        // LastOTPSent = System.Now();
    }
    
    
}