public class EDSAlertSendEmailQueueable implements Queueable, Database.AllowsCallouts{
    private List<EDS_Member_Alerts__c> EDSRecords;
    private Map<String, String> accountEmail;
    private Map<string, string> accountMemberBranch;
    private Map<String, String> fnameFromEmail;
    private Map<String, String> lnameFromEmail;


    public EDSAlertSendEmailQueueable(List<EDS_Member_Alerts__c> EDSRecordsC, Map<String, String> accountEmailC, Map<string, string> accountMemberBranchC, Map<String, String> fnameFromEmailC, Map<String, String> lnameFromEmailC){
        this.EDSRecords = EDSRecordsC;
        this.accountEmail = accountEmailC;
        this.accountMemberBranch = accountMemberBranchC;
        this.fnameFromEmail = fnameFromEmailC;
        this.lnameFromEmail = lnameFromEmailC;
    }

    public void execute(QueueableContext context){
        system.debug('accountEmail: ' + accountEmail);
        SendLimitChangeEmail(accountEmail, fnameFromEmail, lnameFromEmail, EDSRecords);
    }

    private void SendLimitChangeEmail(Map<String, String> accountEmail, Map<String, String> fnameFromEmail, Map<String, String> lnameFromEmail, List<EDS_Member_Alerts__c> validEDS){
        string ToEmail;
        string emailadd;
        string EmailToSend;
        string TemplateName;
        string body;
        string Firstname, Lastname;
        string WXRefNumber;
        List<EDS_Member_Alert_Log__c> listToInsertLogs = new List<EDS_Member_Alert_Log__c>();
        Map<String, EmailTemplate> EmailTemplateMap = new Map<String, EmailTemplate>();
        Map<String, OrgWideEmailAddress> OrgWideEmailMap = new Map<String, OrgWideEmailAddress>();

        List<String> sendTo = new List<String>();
        String userName = UserInfo.getUserName();
        User activeUser = [Select Email
                           From User
                           where Username = :userName
                           limit 1];
        String userEmail = activeUser.Email;

        //Custom Setting to determine if code is executed from Production or Sandbox
        Wires_Notification_EmailTo__c sde = Wires_Notification_EmailTo__c.getValues('Email For Testing');
        if (sde.Emails__c != null){
            EmailToSend = sde.Emails__c;
        }

        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();

        //To Get Email Template Details
        List<EmailTemplate> listEmailTemplate = [select Id, Name, Body, Subject, HtmlValue
                                                 from EmailTemplate];

        for (EmailTemplate e : listEmailTemplate){
            EmailTemplateMap.put(e.Name, e);
        }

        //To Get Org Wide Email Address
        List<OrgWideEmailAddress> listAdd = [select Id, Address, DisplayName
                                             from OrgWideEmailAddress];
        for (OrgWideEmailAddress e : listAdd){
            OrgWideEmailMap.put(e.Address, e);
        }

        
        String emailRegex = '([a-zA-Z0-9_\\-\\.]+)@((\\[a-z]{1,3}\\.[a-z]{1,3}\\.[a-z]{1,3}\\.)|(([a-zA-Z0-9\\-]+\\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})';
        Pattern MyPattern = Pattern.compile(emailRegex);

        //Prepare Email data
        for (EDS_Member_Alerts__c EDS : EDSRecords){
            system.debug('EDS.Account_Number__c: ' + EDS.Account_Number__c);
            string AllEmails = accountEmail.get(EDS.Account_Number__c);
            List<String> lstEmails = AllEmails.split(',');
            Set<String> sEmails = new Set<String>(lstEmails);

            string brand = accountMemberBranch.get(EDS.Account_Number__c);

            if (EDS.Event_Id__c != null){
                WXRefNumber = EDS.Event_Id__c;
            }

            string Action = EDS.Event_Action__c;

            for (string e : sEmails){
                if (e == null || !MyPattern.matcher(e).matches() || string.isBlank(e)){

                    EDS_Member_Alert_Log__c objLog = new EDS_Member_Alert_Log__c();
                    objLog.ODS_Key__c = EDS.OdsKey__c;
                    objLog.Account_Number__c = EDS.Account_Number__c;
                    if (EDS.Email__c == null){
                        objLog.Email_Message__c = 'NULL';
                    } else{
                        objLog.Email_Message__c = 'Invalid email ' + EDS.Email__c;
                    }
                    listToInsertLogs.add(objLog);
                } else{
                    ToEmail = e;
                    Firstname = fnameFromEmail.get(e);
                    Lastname = lnameFromEmail.get(e);

                    Firstname = FirstName.subString(0, 1).ToUpperCase() + FirstName.subString(1).ToLowerCase();
                    Lastname = Lastname.subString(0, 1).ToUpperCase() + Lastname.subString(1).ToLowerCase();

                    system.debug('ToEmail: ' + ToEmail);
                    system.debug('FName: ' + Firstname);
                    system.debug('LName: ' + Lastname);
                    system.debug('WXRefNumber: ' + WXRefNumber);
                    System.debug('Action: ' + Action);
                    System.debug('Brand: ' + Brand);

                    if (EmailToSend != null && EmailToSend.ToLowerCase() != 'production'){
                        ToEmail = userEmail;
                    }

                    system.debug('ToEmail: ' + ToEmail);
                    sendTo.add(ToEmail);
                    mail.setToAddresses(sendTo);

                    //'W' indicates Withdrawal Event and 'D' indicates Deposit Event
                    if (Action == 'W'){
                        TemplateName = 'Wires Notification (W) ' + Brand;
                    } else{
                        TemplateName = 'Wires Notification (D) ' + Brand;
                    }

                    system.debug('TemplateName: ' + TemplateName);
                    

                    mail.setSubject((EmailTemplateMap.get(TemplateName)).Subject);


                    if (Brand == 'Spectrum'){
                        emailadd = 'noreply@spectrumcu.org';
                    } else{
                        emailadd = 'noreply@chevronfcu.org';
                    }


                    if (Action == 'W'){
                        body = '<module name="preheader" label="Preheader"><div style="display: none; max-height: 0px; overflow: hidden;"><editable name="preheader">If you did not initiate this request, please contact us immediately</editable>&nbsp;&zwnj;&nbsp;&zwnj;&nbsp;&zwnj;&nbsp;&zwnj;&nbsp;&zwnj;&nbsp;&zwnj;&nbsp;&zwnj;&nbsp;&zwnj;&nbsp;&zwnj;&nbsp;&zwnj;&nbsp;&zwnj;&nbsp;&zwnj;&nbsp;&zwnj;&nbsp;</div></module>';
                    }
                    if (Action == 'D'){
                        body = '<module name="preheader" label="Preheader"><div style="display: none; max-height: 0px; overflow: hidden;"><editable name="preheader">If you were not expecting these funds, please contact us immediately</editable>&nbsp;&zwnj;&nbsp;&zwnj;&nbsp;&zwnj;&nbsp;&zwnj;&nbsp;&zwnj;&nbsp;&zwnj;&nbsp;&zwnj;&nbsp;&zwnj;&nbsp;&zwnj;&nbsp;&zwnj;&nbsp;&zwnj;&nbsp;&zwnj;&nbsp;&zwnj;&nbsp;</div></module>';
                    }
                    //system.debug('listEmailTemplate[0].HtmlValue: ' + listEmailTemplate[0].HtmlValue);
                    body = body + (EmailTemplateMap.get(TemplateName)).HtmlValue.replace('{FirstName}', Firstname);
                    body = body.replace('{LastName}', Lastname);
                    body = body.replace('{WXRefNumber}', '(' + WXRefNumber + ')');
                    mail.setHtmlBody(body);
                    mail.setOrgWideEmailAddressId(OrgWideEmailMap.get(emailadd).Id);
                    mails.add(mail);
                }
            }
        }

        if (listToInsertLogs.size() > 0){
            insert listToInsertLogs;
        }

        //Send Email
        Messaging.sendEmail(mails);
    }
}