trigger WiresRecipientTrigger on WIRES_Recipient__c (after insert) {
    
    set<Id> Ids = new set<Id>();
    List<EmailSMSNotification> EmailIdsList=new List<EmailSMSNotification>();
    
    if(Trigger.new.size() > 0){
        for(WIRES_Recipient__c objWIRES: trigger.New)
        {
            Ids.add(objWIRES.Id);
        }
        
    }
    List<WIRES_Recipient__c> wiresToUpdate = [select id,Chevron_AccountNumber__c from WIRES_Recipient__c where id IN: Ids];
    if(wiresToUpdate.size() > 0){
        for (WIRES_Recipient__c c : wiresToUpdate) {	
            c.ExternalID__c = c.Id;
            
            Person_Account__c paPrimary = [SELECT Id,PersonID__c,
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
                                           WHERE Account_Number__r.Name =: c.Chevron_AccountNumber__c 
                                           and TypeTranslate__c  like '%Primary%' limit 1];
            
            Account_Details__c accDetail=[SELECT Id,Name, Brand__c FROM Account_Details__c 
                                          WHERE Name=:c.Chevron_AccountNumber__c  AND RecType__c = 'ACCT' LIMIT 1];
            
            EmailSMSNotification emailSMSNotification=new EmailSMSNotification();
            emailSMSNotification.accountNumber=c.Chevron_AccountNumber__c;
            emailSMSNotification.email=paPrimary.PersonID__r.Email_raw__c;
            emailSMSNotification.name=paPrimary.PersonID__r.Name;
            emailSMSNotification.accountNumber=paPrimary.PersonID__r.Name;
            emailSMSNotification.brand=accDetail.Brand__c;
            emailSMSNotification.phone=paPrimary.PersonID__r.Mobile_Phone__pc;
            
            EmailIdsList.add(emailSMSNotification);
        }
    }
    
    if(wiresToUpdate.size() > 0){
        update wiresToUpdate;
    }
    
    if(EmailIdsList.size()>0){
        for (EmailSMSNotification emailSMSNotification : EmailIdsList) {
            if(emailSMSNotification.brand=='Spectrum'){
                SendEmailNotifications(emailSMSNotification.email,emailSMSNotification.name,'Wires Address Book Update Spectrum');
                if(!String.isBlank(emailSMSNotification.phone)){
                    WiresSMSNotificationController.SendSMS(emailSMSNotification.phone,'Wires Address Book Update Spectrum');
                }
            }
            
            if(emailSMSNotification.brand=='Chevron'){
                SendEmailNotifications(emailSMSNotification.email,emailSMSNotification.name,'Wires Address Book Update Chevron');
                if(!String.isBlank(emailSMSNotification.phone)){
                    WiresSMSNotificationController.SendSMS(emailSMSNotification.phone,'Wires Address Book Update Chevron');
                }
            }
        }
    }
    
    // --------------------- Send Email Notification..................//
    public void SendEmailNotifications(string email,string name, string templatenAME){
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        
        List<string> emails=new List<string>();
        
        Wires_Progress_Email_Test__c testEmail=Wires_Progress_Email_Test__c.getValues('Test');
        String userEmail = testEmail.Email__c;
        
        String EmailToSend;
        Wires_Docusign_Emails__c wde = Wires_Docusign_Emails__c.getValues('Email For Testing');
        if(wde.Emails__c != null){
            EmailToSend = wde.Emails__c;
        }
        
        if(EmailToSend != 'Production' || EmailToSend != 'production'){
            EmailToSend = userEmail;
            emails.add(EmailToSend);     
        }else{
            emails.add(email);     
        }
        
        mail.setToAddresses(emails);
        List<EmailTemplate> listEmailTemplate = [select Id, Name, Body, Subject, HtmlValue
                                                 from EmailTemplate
                                                 where Name = :templatenAME];
        
        mail.setSubject(listEmailTemplate[0].Subject);
        string emailadd;
        emailadd = 'noreply@chevronfcu.org';
        List<OrgWideEmailAddress> listAdd = [select Id, Address, DisplayName
                                             from OrgWideEmailAddress
                                             where Address = :emailadd];
        
        string htmlbody =listEmailTemplate[0].HtmlValue.replace('{Name}', name);
        mail.setHtmlBody(htmlbody);
        
        mail.setOrgWideEmailAddressId(listAdd[0].Id);
        mails.add(mail);
        
        Messaging.sendEmail(mails);
    }
    
    public class EmailSMSNotification{
        @AuraEnabled
        public string accountNumber{ get; set; }
        
        @AuraEnabled
        public string email{ get; set; }
        
        @AuraEnabled
        public string name{ get; set; }
        
        @AuraEnabled
        public string brand{ get; set; }
        
        @AuraEnabled
        public string phone{ get; set; }
    }
}