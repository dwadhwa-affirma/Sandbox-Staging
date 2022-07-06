public class EDSAlertSendEmailQueueable implements Queueable, Database.AllowsCallouts{
    private List<EDS_Member_Alerts__c> eDSRecords;
    private Map<String, String> accountEmail;
    private Map<string, string> accountMemberBranch;
    private Map<String, String> fnameFromEmail;
    private Map<String, String> lnameFromEmail;


    public EDSAlertSendEmailQueueable(List<EDS_Member_Alerts__c> eDSRecordsC, Map<String, String> accountEmailC, Map<string, string> accountMemberBranchC, Map<String, String> fnameFromEmailC, Map<String, String> lnameFromEmailC){
        this.eDSRecords = eDSRecordsC;
        this.accountEmail = accountEmailC;
        this.accountMemberBranch = accountMemberBranchC;
        this.fnameFromEmail = fnameFromEmailC;
        this.lnameFromEmail = lnameFromEmailC;
    }

    public void execute(QueueableContext context){
        system.debug('accountEmail: ' + accountEmail);
        sendLimitChangeEmail(accountEmail, fnameFromEmail, lnameFromEmail, eDSRecords);
    }

    private void sendLimitChangeEmail(Map<String, String> accountEmail, Map<String, String> fnameFromEmail, Map<String, String> lnameFromEmail, List<EDS_Member_Alerts__c> eDSRecords){
        string toEmail;
        string emailadd;
        string emailToSend;
        string templateName;
        string body;
        string firstname;
        string lastname;
        string wXRefNumber;
        List<EDS_Member_Alert_Log__c> listToInsertLogs = new List<EDS_Member_Alert_Log__c>();
        Map<String, EmailTemplate> emailTemplateMap = new Map<String, EmailTemplate>();
        Map<String, OrgWideEmailAddress> orgWideEmailMap = new Map<String, OrgWideEmailAddress>();
        set<String> eDSIdstoUpdate = new set<String>();

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
            emailToSend = sde.Emails__c;
        }

        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        

        //To Get Email Template Details
        List<EmailTemplate> listEmailTemplate = [select Id, Name, Body, Subject, HtmlValue
                                                 from EmailTemplate];

        for (EmailTemplate e : listEmailTemplate){
            emailTemplateMap.put(e.Name, e);
        }

        //To Get Org Wide Email Address
        List<OrgWideEmailAddress> listAdd = [select Id, Address, DisplayName
                                             from OrgWideEmailAddress];
        for (OrgWideEmailAddress e : listAdd){
            orgWideEmailMap.put(e.Address, e);
        }

        
        String emailRegex = '([a-zA-Z0-9_\\-\\.]+)@((\\[a-z]{1,3}\\.[a-z]{1,3}\\.[a-z]{1,3}\\.)|(([a-zA-Z0-9\\-]+\\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})';
        Pattern myPattern = Pattern.compile(emailRegex);

        //Prepare Email data
        for (EDS_Member_Alerts__c eds : eDSRecords){
            system.debug('eds.Account_Number__c: ' + eds.Account_Number__c);            
            string allEmails = accountEmail.get(eds.Account_Number__c); 
            List<String> lstEmails = new List<String>();
            Set<String> sEmails = new Set<String>();
            if(allEmails != null) {          
                lstEmails = allEmails.split(',');
                sEmails = new Set<String>(lstEmails);
            }    
            string brand = accountMemberBranch.get(eds.Account_Number__c);

            if (eds.Event_Id__c != null){
                wXRefNumber = EDS.Event_Id__c;
            }

            string action = eds.Event_Action__c;

            for (string e : sEmails){
                if (e == null || !myPattern.matcher(e).matches() || string.isBlank(e)){

                    EDS_Member_Alert_Log__c objLog = new EDS_Member_Alert_Log__c();
                    objLog.ODS_Key__c = eds.OdsKey__c;
                    objLog.Account_Number__c = eds.Account_Number__c;
                    if (eds.Email__c == null){
                        objLog.Email_Message__c = 'NULL';
                    } else{
                        objLog.Email_Message__c = 'Invalid email ' + eds.Email__c;
                    }
                    listToInsertLogs.add(objLog);
                } else{
                    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                    toEmail = e;
                    firstname = fnameFromEmail.get(e);
                    lastname = lnameFromEmail.get(e);

                    if(firstname != null){
                        firstname = firstname.subString(0, 1).ToUpperCase() + firstname.subString(1).ToLowerCase();
                    }
                    else{
                        firstname= '';
                    }
                    if(lastname != null){
                        lastname = lastname.subString(0, 1).ToUpperCase() + lastname.subString(1).ToLowerCase();
                    }
                    else{
                        lastname = '';
                    }
                    

                    system.debug('toEmail: ' + toEmail);
                    system.debug('FName: ' + firstname);
                    system.debug('LName: ' + lastname);
                    system.debug('wXRefNumber: ' + wXRefNumber);
                    System.debug('Action: ' + action);
                    System.debug('Brand: ' + Brand);

                    if (emailToSend != null && emailToSend.ToLowerCase() != 'production'){
                        toEmail = userEmail;
                    }

                    system.debug('toEmail: ' + toEmail);
                    sendTo.add(toEmail);
                    mail.setToAddresses(sendTo);

                    //'W' indicates Withdrawal Event and 'D' indicates Deposit Event
                    if (action == 'W'){
                        templateName = 'Wires Notification (W) ' + Brand;
                    } else{
                        templateName = 'Wires Notification (D) ' + Brand;
                    }

                    system.debug('templateName: ' + templateName);
                    

                    mail.setSubject((emailTemplateMap.get(templateName)).Subject);


                    if (Brand == 'Spectrum'){
                        emailadd = 'noreply@spectrumcu.org';
                    } else{
                        emailadd = 'noreply@chevronfcu.org';
                    }


                    if (action == 'W'){
                        body = '<module name="preheader" label="Preheader"><div style="display: none; max-height: 0px; overflow: hidden;"><editable name="preheader">If you did not initiate this request, please contact us immediately</editable>&nbsp;&zwnj;&nbsp;&zwnj;&nbsp;&zwnj;&nbsp;&zwnj;&nbsp;&zwnj;&nbsp;&zwnj;&nbsp;&zwnj;&nbsp;&zwnj;&nbsp;&zwnj;&nbsp;&zwnj;&nbsp;&zwnj;&nbsp;&zwnj;&nbsp;&zwnj;&nbsp;</div></module>';
                    }
                    if (action == 'D'){
                        body = '<module name="preheader" label="Preheader"><div style="display: none; max-height: 0px; overflow: hidden;"><editable name="preheader">If you were not expecting these funds, please contact us immediately</editable>&nbsp;&zwnj;&nbsp;&zwnj;&nbsp;&zwnj;&nbsp;&zwnj;&nbsp;&zwnj;&nbsp;&zwnj;&nbsp;&zwnj;&nbsp;&zwnj;&nbsp;&zwnj;&nbsp;&zwnj;&nbsp;&zwnj;&nbsp;&zwnj;&nbsp;&zwnj;&nbsp;</div></module>';
                    }
                    //system.debug('listEmailTemplate[0].HtmlValue: ' + listEmailTemplate[0].HtmlValue);
                    body = body + (emailTemplateMap.get(templateName)).HtmlValue.replace('{FirstName}', firstname);
                    body = body.replace('{LastName}', lastname);
                    body = body.replace('{WXRefNumber}', '(' + wXRefNumber + ')');
                    mail.setHtmlBody(body);
                    mail.setOrgWideEmailAddressId(orgWideEmailMap.get(emailadd).Id);
                    mails.add(mail);

                    eDSIdstoUpdate.add(eds.id);
                }
            }
        }

        if (listToInsertLogs.size() > 0){
            insert listToInsertLogs;
        }

        //STRY0012157: Update Email Field
        if (eDSIdstoUpdate.size() > 0){
           List<EDS_Member_Alerts__c> eDSListUpdate = new List<EDS_Member_Alerts__c>();
           eDSListUpdate = [SELECT Id, Account_Number__c, Email__c from EDS_Member_Alerts__c where Id in: eDSIdstoUpdate];          

           for(EDS_Member_Alerts__c eds:eDSListUpdate){
               string accountNo = eds.Account_Number__c;
               eds.Email__c = accountEmail.get(accountNo);              
           }

           update EDSListUpdate;
        }

        //Send Email
        Messaging.sendEmail(mails);
    }
}