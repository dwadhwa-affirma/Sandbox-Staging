public class AddressChangeLogHandler {
    @future(callout = true)
	public static void SendEmailUpdateNotification(string AccountNameOldEmail, string NewEmailId, boolean SendEmail){
        set<string> OldEmailIds = new set<string>();
        set<string> SSNSet = new set<string>();
        set<string> AccountNamesWithUpdatedEmail = new set<string>();        
        map<string,string> SSNEmailIdsMap = new map<string,string>();
        set<string> AccountNumbersforBrand = new set<string>();
        map<string,string> AccountNoBrandMap = new map<string,string>();
        map<string,string> SSNFirstNameMap = new map<string,string>();
        map<string,string> SSNLastNameMap = new map<string,string>();
        
        List<string> AccountNameEmailList  = new List<string>();
        if(AccountNameOldEmail != null)
        AccountNameEmailList = AccountNameOldEmail.split(',');
        
       // string htmlTable = '<table><thead><th><td>Account Number</td></th><th><td>Name</td></th><th><td>Old Email</td></th><th><td>New Email</td></th></thead><tbody>';
       
        for(string se: AccountNameEmailList){
            if(!String.IsBlank(se)){
                List<string> tempList = se.split('\\|');
                if(tempList.size() >= 3){
                    string OldEmailId = tempList[2];
                    if(!OldEmailId.equalsIgnoreCase(NewEmailId)){
                        AccountNamesWithUpdatedEmail.add(se); 
                        if(tempList.size() >= 4)
                        	SSNSet.add(tempList[3]);
                        AccountNumbersforBrand.add(tempList[0]);
                    }                    
                }
            }  
		 }
        
        List<Person_Account__c> listMemberAccounts = [SELECT id, Account_number__r.Brand__c,TypeTranslate__c, Account_number__r.name, personid__r.personid__c, personid__r.LastName, personid__r.FirstName from Person_Account__c where Account_number__r.Name in: AccountNumbersforBrand order by Account_number__r.Name, TypeTranslate__c];
        if(listMemberAccounts.size() > 0){
            for(Person_Account__c lma: listMemberAccounts){
                if(!AccountNoBrandMap.containsKey(lma.Account_number__r.name)){
                	AccountNoBrandMap.put(lma.Account_number__r.name, lma.Account_number__r.Brand__c);
            	}
                if(!SSNFirstNameMap.containsKey(lma.personid__r.personid__c)){
                    SSNFirstNameMap.put(lma.personid__r.personid__c.substring(1), lma.personid__r.FirstName);
                }
                 if(!SSNLastNameMap.containsKey(lma.personid__r.personid__c)){
                    SSNLastNameMap.put(lma.personid__r.personid__c.substring(1), lma.personid__r.LastName);
                }
            }                        	
        }
        
        system.debug('AccountNoBrandMap=='+AccountNoBrandMap);
        system.debug('SSNFirstNameMap=='+SSNFirstNameMap);
        system.debug('SSNLastNameMap=='+SSNLastNameMap);
        
        set<string> AllEmailsIds = new set<string>();
        for(string ssn: SSNSet){
            set<string> EmailsIds = new set<string>(); 
            string Brand = '';
            string FirstName = SSNFirstNameMap.get(ssn);
            string LastName = SSNLastNameMap.get(ssn);
            EmailsIds.add(NewEmailId);

            
            String AuthorizedAccounts = getAuthorizedAccounts(ssn); 
                           
            List<string> listAuthorizedAccounts = AuthorizedAccounts.split(',');
            Set<String> setAuthorizedAccounts = new Set<String>(listAuthorizedAccounts);


            string htmlTable = '<table style="border: 1px solid black;border-collapse: collapse;width: 80%;text-align: center;"><thead style="border: 1px solid black;border-collapse: collapse;"><th style="border: 1px solid black;border-collapse: collapse;">Account Number</th><th style="border: 1px solid black;border-collapse: collapse;">Name</th><th style="border: 1px solid black;border-collapse: collapse;">Old Email</th><th style="border: 1px solid black;border-collapse: collapse;">New Email</th></thead><tbody>';
            for(string se: AccountNamesWithUpdatedEmail){
                if(!String.IsBlank(se)){
                    List<string> tempList = se.split('\\|');
                    if(tempList.size() >= 4){
                        string tssn = tempList[3];
                        string toldemail = tempList[2];
                        string taccountno = tempList[0]; 
                       
                        string tname= tempList[1];
                        if(ssn == tssn && setAuthorizedAccounts.contains(taccountno)){
                            Brand = AccountNoBrandMap.get(taccountno);
                            EmailsIds.add(toldemail);                            
                            htmlTable += '<tr><td style="border: 1px solid black;border-collapse: collapse;">'+ maskAccountNumber(taccountno) +'</td><td style="border: 1px solid black;border-collapse: collapse;">'+ tname +'</td><td style="border: 1px solid black;border-collapse: collapse;">'+ toldemail +'</td><td style="border: 1px solid black;border-collapse: collapse;">'+ NewEmailId +'</td></tr>';
                          
                        }
                    }
                }
            }
            
            htmlTable += '</tbody></table>';
            system.debug('EmailsIds=='+EmailsIds);
            system.debug('htmlTable=='+htmlTable);
            string TemplateName = '';
            if(Brand == 'Spectrum'){
                TemplateName  = 'Address Change Email Update Notification - Spectrum';
            }
            else{
                TemplateName  = 'Address Change Email Update Notification - Chevron';
            }
            if(SendEmail){
                SendEmailNotifications(EmailsIds,htmlTable, TemplateName, FirstName, LastName, Brand);
            }
            
        }  
    }

    // --------------------- Send Email Notification..................//
    public static void SendEmailNotifications(Set<string> EmailIdsSet, string html, string templateName, string FirstName, string LastName, string Brand){
        system.debug('In SendEmailNotifications');
        system.debug('EmailIdsSet' + EmailIdsSet);
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
             
        String Environment='';
        
        List<String> EmailIdsList = new List<String>();
        String userEmail;
        
        Address_Change_Email_Notifiations__c ade = Address_Change_Email_Notifiations__c.getValues('Primary');
        if(ade.Environment__c != null){
            Environment = ade.Environment__c;
            userEmail = ade.TestEmailId__c;
        }
        
        if(Environment == 'Production' || Environment == 'production'){
            EmailIdsList.addAll(EmailIdsSet);
        }        
        else if(Environment != 'Production'){
            EmailIdsList.add(userEmail);
        }   
        
        system.debug('EmailIdsList=='+EmailIdsList);
        
        mail.setToAddresses(EmailIdsList);
        List<EmailTemplate> listEmailTemplate = [select Id, Name, Body, Subject, HtmlValue
                                                 from EmailTemplate
                                                 where Name = :templateName];
        
        mail.setSubject(listEmailTemplate[0].Subject);
        string emailadd;
        
        if (Brand == 'Spectrum'){
        	emailadd = 'noreply@spectrumcu.org';
        } 
        else{
            emailadd = 'noreply@chevronfcu.org';
        }
        //emailadd = 'noreply@chevronfcu.org';
        List<OrgWideEmailAddress> listAdd = [select Id, Address, DisplayName
                                             from OrgWideEmailAddress
                                             where Address = :emailadd];
        
        string body = listEmailTemplate[0].HtmlValue.replace('{EmailUpdateDetails}', html);
        if(String.isNotBlank(FirstName)){
            body = body.replace('{FirstName}', FirstName);
        }
        else{
            body = body.replace('{FirstName}', '');
        }
        if(String.isNotBlank(LastName)){
             body = body.replace('{LastName}', LastName);
        }
        else{
            body = body.replace('{LastName}', '');
        }
        mail.setHtmlBody(body);
        mail.setOrgWideEmailAddressId(listAdd[0].Id);
        mails.add(mail);
        
        Messaging.SendEmailResult[] results = Messaging.sendEmail(mails);
        if (results[0].success) 
        {
            System.debug('The update email was sent successfully.');
        } else {
            System.debug('The update email failed to send:' +  results[0].errors[0].message);
        }
    }

    public static string maskAccountNumber(string AccountNumber){
        String valueToMask = AccountNumber.substring(0, 8);
        String mask = '*'.repeat(valueToMask.length());
        String masked = AccountNumber.replaceFirst(valueToMask, mask);
        system.debug('Masked:'+masked);
        return masked;
    }

    public static string getAuthorizedAccounts(string SSN){
        system.Debug('SSN: '+SSN);
        string AuthrorizedAccountString='';
        string loanAPI;
        
        ACH_To_Episys_API_Details__c api = ACH_To_Episys_API_Details__c.getValues('ProductionURL');
                
        if(api.URL__c != null){
            loanAPI = api.URL__c;
        }
            system.debug('-------------------Webservice for Member Authorization---------------');
            
            HttpRequest req1 = new HttpRequest();
            HttpResponse res1;
            Http http1 = new Http();
            string responseBody1;            
        
            req1.setEndpoint(loanAPI + '/MemberAuthorization/GetAuthorizedAccounts?ssn=' + SSN);
            req1.setMethod('GET');            
            
            if(!Test.isRunningTest()){                       
                res1 = http1.send(req1);
                responseBody1 = res1.getBody();                
            }
            else{
                responseBody1 = '{"Accounts":"0000000123,0000000256"}';
            }
        
            system.debug('responseBody1: '+responseBody1);
        
            if(responseBody1 != ''){
                map<string, object> jsonParsed = (map<string, object>)JSON.deserializeUntyped(responseBody1);
                system.debug('jsonParsed=='+jsonParsed);
                AuthrorizedAccountString = (string)jsonParsed.get('Accounts');
            }
        return AuthrorizedAccountString;
    }
}
