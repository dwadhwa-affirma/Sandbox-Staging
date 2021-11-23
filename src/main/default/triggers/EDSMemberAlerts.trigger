trigger EDSMemberAlerts on EDS_Member_Alerts__c (after insert) {
    
    list<string> listString = new list<string>();  
    List<string> accDetailName = new List<string>();
   
    List<EDS_Member_Alerts__c> EDSRecords = new List<EDS_Member_Alerts__c>();
    List<Account_Details__c> accDetailMap = new List<Account_Details__c>();
    
    List<EDS_Member_Alert_Log__c> listToInsertLogs = new List<EDS_Member_Alert_Log__c>();
    List<Person_Account__c> palist = new List<Person_Account__c>();
    
    List<Id> AccList = new List<Id>();
    Set<String> AccNum = new Set<String>();
    
    Map<string,string> accountMemberBranch = new Map<string,string>();
    String emailRegex = '([a-zA-Z0-9_\\-\\.]+)@((\\[a-z]{1,3}\\.[a-z]{1,3}\\.[a-z]{1,3}\\.)|(([a-zA-Z0-9\\-]+\\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})';
    Pattern MyPattern = Pattern.compile(emailRegex);    
    Map<String,String> fnameFromEmail = new Map<String,String>();
    Map<String,String> lnameFromEmail = new Map<String,String>();
    string Firstname, Lastname;
    string WXRefNumber;
    
    for(EDS_Member_Alerts__c objEDS: trigger.New){
        
        accDetailName.add(objEDS.Account_Number__c);          
        EDSRecords.add(objEDS); 
    }
    
    if(accDetailName.size() > 0){
        
        System.debug('Set: '+accDetailName);
        accDetailMap = [select id,Brand__c, Name from Account_Details__c where Name In :accDetailName];
                
        /*palist = [select id,TypeTranslate__c,Account_Number__r.name,PersonId__r.Firstname,PersonId__r.Lastname,PersonId__c,PersonId__r.Email_raw__c from Person_Account__c where Account_Number__r.name in: accDetailName and TypeTranslate__c = '0000/Primary'];

		for(Person_Account__c p2: [select id,Account_Number__r.name,Account_Number__c,PersonId__c,PersonId__r.Email_raw__c from Person_Account__c where PersonId__c in: AccList]){
            
            AccNum.add(p2.Account_Number__r.name);
        }
        
        system.debug(AccNum);*/
        
        for(Person_Account__c p3 : [select id,TypeTranslate__c,Account_Number__r.name,PersonId__r.Firstname,PersonId__r.Lastname,PersonId__c,PersonId__r.Email_raw__c from Person_Account__c where Account_Number__r.name in: accDetailName]){
            
            if(p3.PersonId__r.Email_raw__c != null){
            	fnameFromEmail.put(p3.PersonId__r.Email_raw__c,p3.PersonId__r.Firstname);
            	lnameFromEmail.put(p3.PersonId__r.Email_raw__c,p3.PersonId__r.Lastname);  
            }
        }
        
        
        /*for(Person_Account__c p: palist){
            fnameFromEmail.put(p.Account_Number__r.name,p.PersonId__r.Firstname);
            lnameFromEmail.put(p.Account_Number__r.name,p.PersonId__r.Lastname);
        }*/
		
        system.debug('fnameFromEmail: '+fnameFromEmail);
        system.debug('lnameFromEmail: '+lnameFromEmail);
        
        for(Account_Details__c acc : accDetailMap){
            if(!accountMemberBranch.containsKey(acc.Name)){
                accountMemberBranch.put(acc.Name,acc.Brand__c);
            }   
        }
       
        for(EDS_Member_Alerts__c EDS: EDSRecords){
            
            string brand = accountMemberBranch.get(EDS.Account_Number__c);
            
            if(EDS.Email__c != null){
                Firstname = fnameFromEmail.get(EDS.Email__c);
                Lastname = lnameFromEmail.get(EDS.Email__c);
            }
            
            System.debug('Brand' + brand);
            System.debug('Firstname' + Firstname);
            System.debug('Lastname' + Lastname);
          	
            if(Firstname == null || Lastname == null){            	
                for(Person_Account__c p1: [select id,TypeTranslate__c,Account_Number__r.name,PersonId__r.Firstname,PersonId__r.Lastname,PersonId__c,PersonId__r.Email_raw__c from Person_Account__c where Account_Number__r.name in: accDetailName and TypeTranslate__c = '0000/Primary']){
                    Firstname = p1.PersonID__r.Firstname;
                    Lastname = p1.PersonID__r.Lastname;
                }                
            }
            
            System.debug('Firstname' + Firstname);
            System.debug('Lastname' + Lastname);
            
            if(EDS.Event_Id__c  != null){
                WXRefNumber = EDS.Event_Id__c;    
            }
            
            if (EDS.Email__c == null || !MyPattern.matcher(EDS.Email__c).matches()) {
                
                EDS_Member_Alert_Log__c objLog =  new EDS_Member_Alert_Log__c();
                objLog.ODS_Key__c = EDS.OdsKey__c;
                objLog.Account_Number__c = EDS.Account_Number__c;
                if(EDS.Email__c == null)
                {
                    objLog.Email_Message__c = 'NULL';
                }
                else{
                    objLog.Email_Message__c = 'Invalid email ' + EDS.Email__c;
                }
                listToInsertLogs.add(objLog);
            }
            else{
                SendLimitChangeEmail(EDS.Email__c, brand, Firstname, Lastname, WXRefNumber, EDS.Event_Action__c);            
            } 
                        
        }
        if(listToInsertLogs.size()>0){
            insert listToInsertLogs;
        }
    }
    
    private void SendLimitChangeEmail(string ToEmail, string Brand,String Firstname,String Lastname, String WXRefNumber, String Action){
        
        SolarLoan_Docusign_Emails__c sde = SolarLoan_Docusign_Emails__c.getValues('Email For Testing');
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        List<String> sendTo = new List<String>();
        string emailadd;
        string EmailToSend;
        string templatenAME;
        string body;
        String userName = UserInfo.getUserName();
        User activeUser = [Select Email From User where Username = : userName limit 1];
        String userEmail = activeUser.Email;
        
        if(sde.Emails__c != null){
            EmailToSend = sde.Emails__c;
        }

        Firstname = FirstName.subString(0 ,1).ToUpperCase() + FirstName.subString(1).ToLowerCase();
        Lastname = Lastname.subString(0 ,1).ToUpperCase() + Lastname.subString(1).ToLowerCase();
       
        system.debug('ToEmail: '+ToEmail);
        system.debug('FName: '+Firstname);
        system.debug('LName: '+Lastname);
        system.debug('WXRefNumber: '+WXRefNumber);
        System.debug('Action: '+Action);
        System.debug('Brand: '+Brand);
        
        if(EmailToSend != 'Production' || EmailToSend != 'production'){
            ToEmail = userEmail;
        }
        
        system.debug('ToEmail: '+ToEmail);
        sendTo.add(ToEmail);
        mail.setToAddresses(sendTo);
        if(Action == 'W'){
        	templatenAME = 'Wires Notification (W) ' + Brand;
        }
        else{
            templatenAME = 'Wires Notification (D) ' + Brand;
        }
                
        system.debug('templatenAME: '+templatenAME);
        List<EmailTemplate> listEmailTemplate =  [select Id,Name,Body,Subject,HtmlValue from EmailTemplate where Name =: templatenAME];
        mail.setSubject(listEmailTemplate[0].Subject);
        
        
        if(Brand == 'Spectrum'){
            emailadd = 'noreply@spectrumcu.org';
        }
        else{
            emailadd = 'noreply@chevronfcu.org';
        }               
        
        List<OrgWideEmailAddress> listAdd = [select Id,Address,DisplayName  from OrgWideEmailAddress where Address =: emailadd];
        if(Action == 'W'){
        	body = '<module name="preheader" label="Preheader"><div style="display: none; max-height: 0px; overflow: hidden;"><editable name="preheader">If you did not initiate this request, please contact us immediately</editable>&nbsp;&zwnj;&nbsp;&zwnj;&nbsp;&zwnj;&nbsp;&zwnj;&nbsp;&zwnj;&nbsp;&zwnj;&nbsp;&zwnj;&nbsp;&zwnj;&nbsp;&zwnj;&nbsp;&zwnj;&nbsp;&zwnj;&nbsp;&zwnj;&nbsp;&zwnj;&nbsp;</div></module>';
        }
        if(Action == 'D'){
        	body = '<module name="preheader" label="Preheader"><div style="display: none; max-height: 0px; overflow: hidden;"><editable name="preheader">If you were not expecting these funds, please contact us immediately</editable>&nbsp;&zwnj;&nbsp;&zwnj;&nbsp;&zwnj;&nbsp;&zwnj;&nbsp;&zwnj;&nbsp;&zwnj;&nbsp;&zwnj;&nbsp;&zwnj;&nbsp;&zwnj;&nbsp;&zwnj;&nbsp;&zwnj;&nbsp;&zwnj;&nbsp;&zwnj;&nbsp;</div></module>';
        }
        system.debug('listEmailTemplate[0].HtmlValue: '+listEmailTemplate[0].HtmlValue);
        body = body + listEmailTemplate[0].HtmlValue.replace('{FirstName}',Firstname);
        body = body.replace('{LastName}',Lastname);
        body = body.replace('{WXRefNumber}','('+WXRefNumber+')');
        mail.setHtmlBody(body);
        mail.setOrgWideEmailAddressId(listAdd[0].Id);
        mails.add(mail);
       
        Messaging.sendEmail(mails);
    }
}