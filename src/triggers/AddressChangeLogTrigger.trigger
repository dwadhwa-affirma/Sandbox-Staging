trigger AddressChangeLogTrigger on AddressChangeLog__c (before insert, after insert) {
    
     if(trigger.isbefore && trigger.isInsert){
            for(AddressChangeLog__c objAddressChange: trigger.New)
            {
                          //string accountNumber =  objAddressChange.Member_Number__c;
           
                           
                          string memberemail = objAddressChange.Email__c;
                          string phone = objAddressChange.MobilePhone__c; 
                          
                          String emailRegex = '([a-zA-Z0-9_\\-\\.]+)@((\\[a-z]{1,3}\\.[a-z]{1,3}\\.[a-z]{1,3}\\.)|(([a-zA-Z0-9\\-]+\\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})';
                          Pattern MyPattern = Pattern.compile(emailRegex);     
        
                        
                            if (memberemail == null || !MyPattern.matcher(memberemail).matches()) {
                           
                            }
                            else
                            {
                              system.debug('memberemail=='+memberemail);
                              //SendOTPEmail(memberemail); 
                            }
                            
                            if(phone != null)
                            {
                                system.debug('memberPhone=='+phone);
                                //SendSMS(phone);                       
                            }
                            
                //string description='';
                String accountstring = objAddressChange.AccountNumbersString__c;
                List<String> listAccountNumber = new List<String>();
                if(accountstring.contains(',')){
                	listAccountNumber = accountstring.split('\\,');
                }
                else{
                	listAccountNumber.add(accountstring);
                }
                
                set<string> setAccountNumbers = new set<string>();
                 map<string,id> mapAccountNumber = new map<string,id>();
                 
                
                                
                for(String s: listAccountNumber){
                	if(!String.isEmpty(s)){
                		setAccountNumbers.add(s);             			
                	}	
                }
                
                List<Account_Details__c> listAccounts = [select id, name from Account_Details__c where name IN: setAccountNumbers and parent_account__c = null];
                for(Account_Details__c acc: listAccounts){
                	mapAccountNumber.put(acc.name, acc.id);
                }               
               
                
                 list<CaseRecordType__c> scList = [SELECT Id,
                                                   Primary_Category__c,
                                                   Secondary_Category__c,
                                                   Teritiary_Category__c,
                                                   Record_Type_Name__c,
                                                   RecordTypeId__c FROM CaseRecordType__c WHERE Primary_Category__c = 'Account Maintenance' AND Secondary_Category__c= 'Memberships' AND Teritiary_Category__c= 'Address/Contact Updates' LIMIT 1];
                                                   
                Case caseobj = new Case();
                
                caseobj.Account_Number__c = listAccounts[0].id;
                caseobj.Status = 'Closed';
                caseobj.AccountId = objAddressChange.Member__c;
                caseobj.RecordTypeId = scList[0].RecordTypeId__c;
                caseobj.Primary_Category__c = scList[0].Primary_Category__c;
                caseobj.Secondary_Category__c = scList[0].Secondary_Category__c;
                caseobj.Tertiary_Category__c = scList[0].Teritiary_Category__c; 
                
                if(objAddressChange.Update_Type__c =='Residential Address'){
                    caseobj.Subject = 'Address Change';
                caseobj.Description = 'Update Type:' + objAddressChange.Update_Type__c //+ '\n' +'Account Number:' + objAddressChange.AccountNumber__c
                 + '\n' +'Old Address1:' + (objAddressChange.Address_Old__c == null ? '' :objAddressChange.Address_Old__c) 
                 + '\n'+ 'New Address1:' + (objAddressChange.Address_New__c == null ? '' :objAddressChange.Address_New__c) + '\n'+
                  'Old Address2:' + (objAddressChange.Address2_Old__c == null ? '' :objAddressChange.Address2_Old__c) 
                 + '\n'+ 'New Address2:' + (objAddressChange.Address2_New__c == null ? '' :objAddressChange.Address2_New__c) 
                          + '\n'+ 'Old City:' + (objAddressChange.City_Old__c == null ? '' :objAddressChange.City_Old__c) 
                            + '\n'+ 'New City:' + (objAddressChange.City_New__c == null ? '' :objAddressChange.City_New__c) 
                            + '\n'+ 'Old State:' + (objAddressChange.State_Old__c == null ? '' :objAddressChange.State_Old__c)
                             + '\n'+ 'New State:' + (objAddressChange.State_New__c == null ? '' :objAddressChange.State_New__c) + '\n'+
                            'Old Zip5:' + (objAddressChange.Zip_Old__c == null ? '' :objAddressChange.Zip_Old__c)
                            + '\n'+ 'New Zip5:' + (objAddressChange.Zip_New__c == null ? '' :objAddressChange.Zip_New__c) + '\n' +
                            'Old Zip4:' + (objAddressChange.Zip4_Old__c == null ? '' :objAddressChange.Zip4_Old__c)
                            + '\n'+ 'New Zip4:' + (objAddressChange.Zip4_New__c == null ? '' :objAddressChange.Zip4_New__c) ;
                }   
                else if(objAddressChange.Update_Type__c =='Contact Info'){
                    caseobj.Subject = 'Contact Info Change';
                caseobj.Description = 'Update Type:' + objAddressChange.Update_Type__c + '\n' 
                            //'Account Number:' + objAddressChange.AccountNumber__c + '\n' 
                            +'Old HomePhone:' + (objAddressChange.HomePhone_Old__c == null ? '' :objAddressChange.HomePhone_Old__c) + '\n'
                            + 'New HomePhone:' + (objAddressChange.HomePhone_New__c == null ? '' :objAddressChange.HomePhone_New__c) + '\n'
                            +'Old MobilePhone:' + (objAddressChange.MobilePhone_Old__c == null ? '' :objAddressChange.MobilePhone_Old__c) + '\n'
                            + 'New MobilePhone:' + (objAddressChange.MobilePhone_New__c == null ? '' :objAddressChange.MobilePhone_New__c) + '\n'
                            +'Old WorkPhone:' + (objAddressChange.WorkPhone_Old__c == null ? '' :objAddressChange.WorkPhone_Old__c) + '\n'
                            + 'New Workphone:' + (objAddressChange.WorkPhone_New__c == null ? '' :objAddressChange.WorkPhone_New__c) + '\n'+
                            'Old WorkExtension:' + (objAddressChange.WorkExtension_Old__c == null ? '' :objAddressChange.WorkExtension_Old__c) + '\n'
                            + 'New WorkExtension:' + (objAddressChange.WorkExtension_New__c == null ? '' :objAddressChange.WorkExtension_New__c)+ '\n'
                            +'Old Email:' + (objAddressChange.Email_Old__c == null ? '' :objAddressChange.Email_Old__c) + '\n'
                            + 'New Email:' + (objAddressChange.Email_New__c == null ? '' :objAddressChange.Email_New__c) + '\n'+
                            +'Old AlternateEmail:' + (objAddressChange.AlternateEmail_Old__c == null ? '' :objAddressChange.AlternateEmail_Old__c) + '\n'
                            + 'New AlternateEmail:' + (objAddressChange.AlternateEmail_New__c == null ? '' :objAddressChange.AlternateEmail_New__c) + '\n';
                }  
                else if(objAddressChange.Update_Type__c =='Card Mailing Address'){
                    caseobj.Subject = 'Card Mailing Address Change';
                caseobj.Description = 'Update Type:' + objAddressChange.Update_Type__c 
                             + '\n' +'Old Address:' + (objAddressChange.Address_Old__c == null ? '' :objAddressChange.Address_Old__c) 
               				 + '\n'+ 'New Address:' + (objAddressChange.Address_New__c == null ? '' :objAddressChange.Address_New__c) + '\n'+
                            'Old City:' + (objAddressChange.City_Old__c == null ? '' :objAddressChange.City_Old__c) 
                            + '\n'+ 'New City:' + (objAddressChange.City_New__c == null ? '' :objAddressChange.City_New__c) 
                            + '\n'+ 'Old State:' + (objAddressChange.State_Old__c == null ? '' :objAddressChange.State_Old__c)
                            + '\n'+ 'New State:' + (objAddressChange.State_New__c == null ? '' :objAddressChange.State_New__c) + '\n'+
                            'Old Zip:' + (objAddressChange.Zip_Old__c == null ? '' :objAddressChange.Zip_Old__c)
                            + '\n'+ 'New Zip:' + (objAddressChange.Zip_New__c == null ? '' :objAddressChange.Zip_New__c) + '\n'
                            +'Old Country:' + (objAddressChange.Country_Old__c == null ? '' :objAddressChange.Country_Old__c)
                            + '\n'+ 'New Country:' + (objAddressChange.Country_New__c == null ? '' :objAddressChange.Country_New__c)  ;
                }   
                else if(objAddressChange.Update_Type__c =='Temp Mailing Address'){
                    caseobj.Subject = 'Temp Mailing Address Update';
                caseobj.Description = 'Update Type:' + (objAddressChange.Update_Type__c  + ' - Update') 
                             + '\n' +'Old Address:' + (objAddressChange.Address_Old__c == null ? '' :objAddressChange.Address_Old__c) 
               				 + '\n'+ 'New Address:' + (objAddressChange.Address_New__c == null ? '' :objAddressChange.Address_New__c) + '\n'+
                            'Old City:' + (objAddressChange.City_Old__c == null ? '' :objAddressChange.City_Old__c) 
                            + '\n'+ 'New City:' + (objAddressChange.City_New__c == null ? '' :objAddressChange.City_New__c) 
                            + '\n'+ 'Old State:' + (objAddressChange.State_Old__c == null ? '' :objAddressChange.State_Old__c)
                            + '\n'+ 'New State:' + (objAddressChange.State_New__c == null ? '' :objAddressChange.State_New__c) + '\n'+
                            'Old Zip:' + (objAddressChange.Zip_Old__c == null ? '' :objAddressChange.Zip_Old__c)
                            + '\n'+ 'New Zip:' + (objAddressChange.Zip_New__c == null ? '' :objAddressChange.Zip_New__c) + '\n'
                            +'Old Expiration Date:' + objAddressChange.ExpirationDate_Old__c
                            + '\n'+ 'New Expiration Date:' + objAddressChange.ExpirationDate_New__c 
                            + '\n' +'Old Active Flag:' + objAddressChange.isActive_Old__c 
                            + '\n'+ 'New Active Flag:' + objAddressChange.isActive_New__c ;
                }   
                else if(objAddressChange.Update_Type__c =='Temp Mailing Address - New'){
                    caseobj.Subject = 'Temp Mailing Address Update';
                caseobj.Description = 'Update Type:' + objAddressChange.Update_Type__c 
                             + '\n' + 'New Address:' + (objAddressChange.Address_New__c == null ? '' :objAddressChange.Address_New__c) + '\n'+                           
                            'New City:' + (objAddressChange.City_New__c == null ? '' :objAddressChange.City_New__c) 
                            + '\n'+ 'New State:' + (objAddressChange.State_New__c == null ? '' :objAddressChange.State_New__c) + '\n'
                            + 'New Zip:' + (objAddressChange.Zip_New__c == null ? '' :objAddressChange.Zip_New__c)                          
                            + '\n'+ 'New Expiration Date:' + objAddressChange.ExpirationDate_New__c                      
                            + '\n'+ 'New Active Flag:' + objAddressChange.isActive_New__c  ;
                }
                else if(objAddressChange.Update_Type__c == 'New Card Mailing Address'){
                	caseobj.Subject = 'New Card Mailing Address';
                	caseobj.Description = 'Update Type:' + objAddressChange.Update_Type__c 
                             + '\n' + 'New Address:' + (objAddressChange.Address_New__c == null ? '' :objAddressChange.Address_New__c) + '\n'+                           
                            'New City:' + (objAddressChange.City_New__c == null ? '' :objAddressChange.City_New__c) 
                            + '\n'+ 'New State:' + (objAddressChange.State_New__c == null ? '' :objAddressChange.State_New__c) + '\n'
                            + 'New Zip:' + (objAddressChange.Zip_New__c == null ? '' :objAddressChange.Zip_New__c)                          
                            + '\n'+ 'New Expiration Date:' + objAddressChange.ExpirationDate_New__c                      
                            + '\n'+ 'New Active Flag:' + objAddressChange.isActive_New__c  + '\n'+ 'New Country:' + (objAddressChange.Country_New__c == null ? '' :objAddressChange.Country_New__c);
                }
                Id caseid;          
                try{                
                       insert caseobj;
                       caseid = caseobj.id;            
                       System.debug('Case created :' + caseobj.Id);            
                   }
                 catch (exception e)  {           
                   System.debug('An error occured while inserting case :' + e);                 
                  } 
                
                 list<CaseAccountMemberDetail__c> listac = new List<CaseAccountMemberDetail__c>();  
                 objAddressChange.CaseId__c = caseid;
                
                 
               
                for(String s: setAccountNumbers){                	
                		 CaseAccountMemberDetail__c obj = new CaseAccountMemberDetail__c();
                		 obj.Account_Name__c = s; 	
                		 obj.Case__c = 	caseid;
                		 obj.MemberAccountid__c = mapAccountNumber.get(s);
                		 listac.add(obj);             	     	
                	
                }
                
                insert listac;
                     
            }
     }
     
    /* if(trigger.isafter && trigger.isInsert){
     	for(AddressChangeLog__c objAddressChange: trigger.New)
            {
            	String accountstring = objAddressChange.AccountNumbersString__c;
                List<String> listAccountNumber = accountstring.split('\\,');
                set<string> setAccountNumbers = new set<string>();
                list<Address_Change_Account__c> listac = new List<Address_Change_Account__c>();
                               
                for(String s: listAccountNumber){
                	if(!String.isEmpty(s)){
                		 Address_Change_Account__c objac =  new Address_Change_Account__c();
                		 objac.Account_Name__c = s; 	
                		 objac.AddressChangeLogId__c = 	objAddressChange.id;
                		 listac.add(objac);
                	}               	
                	
                }
                
                insert listac;
            }
     	
     }*/
    
    
    
  /*  private void SendOTPEmail(string ToEmail)
    {
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        List<String> sendTo = new List<String>();
        sendTo.add(ToEmail);
        
          
        mail.setToAddresses(sendTo);
        string templatenAME = 'Address Change';
        List<EmailTemplate> listEmailTemplate =  [select Id,Name,Body,Subject,HtmlValue from EmailTemplate where Name =: templatenAME];
        
        mail.setSubject(listEmailTemplate[0].Subject);
        
        
        string emailadd;
        
        emailadd = 'noreply@chevronfcu.org';
        
        
        List<OrgWideEmailAddress> listAdd = [select Id,Address,DisplayName  from OrgWideEmailAddress where Address =: emailadd];
        
        string body = listEmailTemplate[0].Body;
        mail.setPlainTextBody(body);
        mail.setOrgWideEmailAddressId(listAdd[0].Id);
        mails.add(mail);
        
        Messaging.sendEmail(mails);
        
    }
   
    
    private void SendSMS(string phone)
    {
        List<smagicinteract__smsmagic__c> smsObjectList = new List<smagicinteract__smsmagic__c>();
        String senderId = 'CreditUnion';
        smagicinteract__smsMagic__c smsObject = new smagicinteract__smsMagic__c();
        smsObject.smagicinteract__SenderId__c = 'CreditUnion';
        string emailadd;
       
       system.debug('UserInfo.getName()###' + UserInfo.getName());
        
        emailadd = 'Address Change';
        list<smagicinteract__SMS_Template__c> listTemplate =  [select Id, smagicinteract__Text__c from smagicinteract__SMS_Template__c where smagicinteract__Name__c =: emailadd];

        smsObject.smagicinteract__PhoneNumber__c = phone;
        smsObject.smagicinteract__Name__c = 'SMS - User'; // records name
     //   smsObject.smagicinteract__ObjectType__c = 'Contact'; // record type
        smsObject.smagicinteract__disableSMSOnTrigger__c = 0; // this field either be 0 or 1, if you specify the value as 1 then sms will not get send but entry of sms will get create under SMS History object
        smsObject.smagicinteract__external_field__c = smagicinteract.ApexAPI.generateUniqueKey();
    
        smsObjectList.add(smsObject);
        Database.insert(smsObjectList, false);
       // LastOTPSent = System.Now();
}*/
}