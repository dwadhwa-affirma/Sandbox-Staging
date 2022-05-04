public class EDSAlertSendEmailQueueable implements Queueable, Database.AllowsCallouts {

    private string ToEmail;
    private string Brand;
    private String Firstname;
    private String Lastname;
    private String WXRefNumber;
    private String Action;


    public EDSAlertSendEmailQueueable(string ToEmailC, string BrandC,String FirstnameC,String LastnameC, String WXRefNumberC, String ActionC){
        this.ToEmail = ToEmailC;
        this.Brand = BrandC;
        this.Firstname = FirstnameC;
        this.Lastname = LastnameC;
        this.WXRefNumber = WXRefNumberC;
        this.Action = ActionC;
    }

    public void execute(QueueableContext context) {
        SendLimitChangeEmail(ToEmail,Brand,Firstname, Lastname, WXRefNumber, Action);
    }

    private void SendLimitChangeEmail(string ToEmail, string Brand,String Firstname,String Lastname, String WXRefNumber, String Action){
        
        Wires_Notification_EmailTo__c sde = Wires_Notification_EmailTo__c.getValues('Email For Testing');
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
