public  class WiresEmailController {
	public static void SendApprovalNotification(Id WiresId,List<string> emails,string wireName, decimal wireAmount,string source){
        
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
        SendApprovalRequestEmail(WiresId,emailIds,wireName,wireAmount,source);
    }
    
    public static void SendApprovalRequestEmail(Id wiresId, List<string> emails, string wireName, decimal wireAmount, string source){
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
}