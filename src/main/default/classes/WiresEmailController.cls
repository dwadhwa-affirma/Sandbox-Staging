public  class WiresEmailController {
    public static void SendApprovalNotification(Id WiresId,List<string> emails,
                                                string wireName, decimal wireAmount,string source,boolean HasAdditionalDocuments){
                                                    
                                                    System.debug('Emails:'+emails);
                                                    List<string> emailIds=new List<string>();
                                                    
                                                    String EmailToSend='';
                                                    Wires_Progress_Email_Test__c testEmail=Wires_Progress_Email_Test__c.getValues('Test');
                                                    
                                                    String userEmail = testEmail.Email__c;
                                                    
                                                    Wires_Docusign_Emails__c wde = Wires_Docusign_Emails__c.getValues('Email For Testing');
                                                    if(wde.Emails__c != null){
                                                        EmailToSend = wde.Emails__c;
                                                    }
                                                    
                                                    if(EmailToSend == 'Production' || EmailToSend == 'production'){
                                                        emailIds=emails;
                                                    }
                                                    
                                                    if(EmailToSend != 'Production' || EmailToSend != 'production'){
                                                        emailIds.add(userEmail);
                                                    }
                                                    
                                                    System.debug('Actual send Emails:'+emailIds);
                                                    SendApprovalRequestEmail(WiresId,emailIds,wireName,wireAmount,source,HasAdditionalDocuments);
                                                }
    
    public static void SendApprovalRequestEmail(Id wiresId, List<string> emails, 
                                                string wireName, decimal wireAmount, string source, boolean HasAdditionalDocuments){
                                                    Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
                                                    //message.setTargetObjectId('005190000039XfxAAE'); 
                                                    //message.setSenderDisplayName(‘Company Support’); 
                                                    message.setReplyTo('no-reply@company.com');
                                                    message.setUseSignature(false); 
                                                    message.setBccSender(false); 
                                                    message.setSaveAsActivity(false); 
                                                    EmailTemplate emailTemplate = [Select Id,Subject,Description,HtmlValue,DeveloperName,Body from EmailTemplate 
                                                                                   where name = 'Wire Approval Notification'];
                                                    
                                                    message.setSubject(emailTemplate.Subject);
                                                    message.setTemplateID(emailTemplate.Id); 
                                                    message.setWhatId(wiresId); //This is important for the merge fields in template to work
                                                    //message.setHtmlBody(emailTemplate.Body);
                                                    System.debug('HtmlValue:'+emailTemplate.HtmlValue);
                                                    
                                                    string body=emailTemplate.HtmlValue;    
                                                    body=body.replace('{wireId}',wiresId);
                                                    body=body.replace('{wirename}',wireName);
                                                    if(wireAmount <=100000){
                                                        body=body.replace('{##}','');
                                                    }else{
                                                        body=body.replace('{##}',' prior to escalation to the next approval group');
                                                    }
                                                    body=body.replace('{Amount}',wireAmount.toPlainString());
                                                    body=body.replace('{Source}',source);
                                                    
                                                    if(HasAdditionalDocuments==true){
                                                        body=body.replace('{**}','Also additional documents have been attached to the Wire transaction.');
                                                    }else{
                                                        body=body.replace('{**}','');
                                                    }
                                                    
                                                    message.setHtmlBody(body);
                                                    message.toAddresses = emails;
                                                    Messaging.SingleEmailMessage[] messages = new List<Messaging.SingleEmailMessage> {message};
                                                        Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
                                                    
                                                    if (results[0].success) 
                                                    {
                                                        System.debug('The email was sent successfully.');
                                                    } else {
                                                        System.debug('The email failed to send:' +  results[0].errors[0].message);
                                                    }
                                                }
    
    public static void SendAdditionalDocumentsNotification(Id WiresId,List<string> emails,string wireName, decimal wireAmount,string source){
        
        System.debug('Emails:'+emails);
        List<string> emailIds=new List<string>();
        
        String EmailToSend='';
        Wires_Progress_Email_Test__c testEmail=Wires_Progress_Email_Test__c.getValues('Test');
        
        String userEmail = testEmail.Email__c;
        
        Wires_Docusign_Emails__c wde = Wires_Docusign_Emails__c.getValues('Email For Testing');
        if(wde.Emails__c != null){
            EmailToSend = wde.Emails__c;
        }
        
        if(EmailToSend == 'Production' || EmailToSend == 'production'){
            emailIds=emails;
        }
        
        if(EmailToSend != 'Production' || EmailToSend != 'production'){
            emailIds.add(userEmail);
        }
        
        System.debug('Actual send Emails:'+emailIds);
        SendAdditionalDocumentsEmail(WiresId,emailIds,wireName,wireAmount,source);
    }
    
    public static void SendAdditionalDocumentsEmail(Id wiresId, List<string> emails, string wireName, decimal wireAmount, string source){
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        //message.setTargetObjectId('005190000039XfxAAE'); 
        //message.setSenderDisplayName(‘Company Support’); 
        message.setReplyTo('no-reply@company.com');
        message.setUseSignature(false); 
        message.setBccSender(false); 
        message.setSaveAsActivity(false); 
        EmailTemplate emailTemplate = [Select Id,Subject,Description,HtmlValue,DeveloperName,Body from EmailTemplate 
                                       where name = 'Wire Transaction Additional Documents'];
        
        message.setSubject(emailTemplate.Subject);
        message.setTemplateID(emailTemplate.Id); 
        message.setWhatId(wiresId); //This is important for the merge fields in template to work
        //message.setHtmlBody(emailTemplate.Body);
        System.debug('HtmlValue:'+emailTemplate.HtmlValue);
        
        string body=emailTemplate.HtmlValue;    
        body=body.replace('{wireId}',wiresId);
        body=body.replace('{wirename}',wireName);
        body=body.replace('{Amount}',wireAmount.toPlainString());
        body=body.replace('{Source}',source);
        
        message.setHtmlBody(body);
        message.toAddresses = emails;
        Messaging.SingleEmailMessage[] messages = new List<Messaging.SingleEmailMessage> {message};
            Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
        
        if (results[0].success) 
        {
            System.debug('The email was sent successfully.');
        } else {
            System.debug('The email failed to send:' +  results[0].errors[0].message);
        }
    }
    
    public static void SendBranchWireCancelledOrRejectEmailNotification(Set<Id> id,boolean isCancelled){
        
        System.debug('In SendBranchWireCancelledOrRejectected Email Notification');
        System.debug('Id:'+Id);
        String EmailToSend='';
        
        Wires_Progress_Email_Test__c testEmail=Wires_Progress_Email_Test__c.getValues('Test');
        String userEmail = testEmail.Email__c;
        
        Wires_Docusign_Emails__c wde = Wires_Docusign_Emails__c.getValues('Email For Testing');
        if(wde.Emails__c != null){
            EmailToSend = wde.Emails__c;
        }
        
        List<WIRES_Transaction__c> WiresTrans = [SELECT Id,Member_Email__c,CreatedBy.Email, LaunchByUserId__r.Email
                                                 FROM WIRES_Transaction__c WHERE id =: id LIMIT 1];
        
        if(EmailToSend == 'Production' || EmailToSend == 'production'){
            EmailToSend = WiresTrans[0].LaunchByUserId__r.Email;     
        }
        
        if(EmailToSend != 'Production' || EmailToSend != 'production'){
            EmailToSend = userEmail;
        }
        
        SendBranchWireCancelledOrRejectedEmail(id,EmailToSend,isCancelled);
    }
    
    // --------------------- Send Branch Wire Rejected Email..................//   
    
    private static void SendBranchWireCancelledOrRejectedEmail(Set<Id> id,string ToEmail, boolean isCancelled)
    {
        List<WIRES_Transaction__c> wireTransactions = [SELECT id,Approval_Status__c,ToAccountName__c,ToAccoutId__c,
                                                       Status__c, FromAccount__c,TotalFromAccount__c,WireAmount__c,
                                                       ToAccoutId__r.Recipient_AccountNumber__c,
                                                       ToAccoutId__r.BankName__c,Member_Name__c,
                                                       Cancel_Reason__c,First_Approval_Comment__c,
                                                       LaunchByUserId__r.Email
                                                       from WIRES_Transaction__c where id=:id];
        
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        
        for(WIRES_Transaction__c wt:wireTransactions){
            
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
                                           WHERE Account_Number__r.Name =: wt.FromAccount__c 
                                           and TypeTranslate__c  like '%Primary%' limit 1];
            
            Account_Details__c accDetail=[SELECT Id,Name, Brand__c FROM Account_Details__c 
                                          WHERE Name=:wt.FromAccount__c  AND RecType__c = 'ACCT' LIMIT 1];
            
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            List<String> sendTo = new List<String>();
            sendTo.add(ToEmail);
            
            mail.setToAddresses(sendTo);
            
            System.debug('Send To:'+sendTo);
            
            string templatenAME;
            
            if(isCancelled==true){
                if(accDetail.Brand__c=='Spectrum'){
                    templatenAME='Wires Cancelled Email Spctrum';
                }
                if(accDetail.Brand__c=='Chevron'){
                    templatenAME='Wires Cancelled Email Chevron';
                }
            }else{
                if(accDetail.Brand__c=='Spectrum'){
                    templatenAME='Wires Rejected Email Spctrum';
                }
                if(accDetail.Brand__c=='Chevron'){
                    templatenAME='Wires Rejected Email Chevron';
                }
            }
            
            List<EmailTemplate> listEmailTemplate =  [select Id,Name,Body,Subject,HtmlValue from EmailTemplate where Name =: templatenAME];
            mail.setSubject(listEmailTemplate[0].Subject);
            
            
            string emailadd;
            
            emailadd = 'noreply@chevronfcu.org';
            
            
            List<OrgWideEmailAddress> listAdd = [select Id,Address,DisplayName  from OrgWideEmailAddress where Address =: emailadd];
            
            if(!Test.isRunningTest()){            
                string body = listEmailTemplate[0].HtmlValue;
                body=body.replace('{Name}', wt.Member_Name__c);
                body=body.replace('{BankName__c}', wt.ToAccoutId__r.BankName__c);
                body=body.replace('{TotalFromAccount__c}',string.valueOf(wt.WireAmount__c));
                if(isCancelled==true){
                    body=body.replace('{Reason}',wt.Cancel_Reason__c);
                }else{
                    body=body.replace('{Reason}',wt.First_Approval_Comment__c);
                }
                mail.setHtmlBody(body);
                mail.setOrgWideEmailAddressId(listAdd[0].Id);
                mails.add(mail);
            }
        }
        
        
        Messaging.sendEmail(mails);
        
    }
    
    // --------------------- Send Branch Wire Rejected Email ..................//  
    
    
}