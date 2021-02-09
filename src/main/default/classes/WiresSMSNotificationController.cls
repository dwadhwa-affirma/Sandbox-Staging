public class WiresSMSNotificationController {
    public static void SendSMS(string phone, string templateName){
        List<smagicinteract__smsmagic__c> smsObjectList = new List<smagicinteract__smsmagic__c>();
        String senderId = 'CreditUnion';
        smagicinteract__smsMagic__c smsObject = new smagicinteract__smsMagic__c();
        smsObject.smagicinteract__SenderId__c = 'CreditUnion';
        string emailadd;
        
        system.debug('UserInfo.getName()###' + UserInfo.getName());
        
        emailadd = templateName;
        list<smagicinteract__SMS_Template__c> listTemplate = [select Id, smagicinteract__Text__c
                                                              from smagicinteract__SMS_Template__c
                                                              where smagicinteract__Name__c = :emailadd];
        
        if(listTemplate.size() > 0 ) {
            smsObject.smagicinteract__SMSText__c = listTemplate[0].smagicinteract__Text__c;
        }
        
        Wires_Progress_Email_Test__c testEmail=Wires_Progress_Email_Test__c.getValues('Test');
        String userPhone = testEmail.Phone__c;
        
        String notificationToSend;
        Wires_Docusign_Emails__c wde = Wires_Docusign_Emails__c.getValues('Email For Testing');
        if(wde.Emails__c != null){
            notificationToSend = wde.Emails__c;
        }
        
        if(notificationToSend != 'Production' || notificationToSend != 'production'){
            phone=userPhone;
        }else{
            phone=phone;     
        }
        
        smsObject.smagicinteract__PhoneNumber__c = phone;
        smsObject.smagicinteract__Name__c = 'SMS - User'; // records name
        //   smsObject.smagicinteract__ObjectType__c = 'Contact'; // record type
        smsObject.smagicinteract__disableSMSOnTrigger__c = 1; // this field either be 0 or 1, if you specify the value as 1 then sms will not get send but entry of sms will get create under SMS History object
        smsObject.smagicinteract__external_field__c = smagicinteract.ApexAPI.generateUniqueKey();
        
        smsObjectList.add(smsObject);
        Database.insert(smsObjectList, false);
        // LastOTPSent = System.Now();
    }
    
    public static void SendProgressSMSNotification(Set<Id> id){
        
         List<WIRES_Transaction__c> wireTransactions = [SELECT id,Approval_Status__c,ToAccountName__c,ToAccoutId__c,
                                                       Status__c, FromAccount__c,TotalFromAccount__c,WireAmount__c,
                                                       ToAccoutId__r.Recipient_AccountNumber__c,
                                                       ToAccoutId__r.BankName__c
                                                       from WIRES_Transaction__c where id=:id];
        
        for(WIRES_Transaction__c c: wireTransactions){
            
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
                                           WHERE Account_Number__r.Name =: c.FromAccount__c 
                                           and TypeTranslate__c  like '%Primary%' limit 1];
            
            Account_Details__c accDetail=[SELECT Id,Name, Brand__c FROM Account_Details__c 
                                          WHERE Name=:c.FromAccount__c  AND RecType__c = 'ACCT' LIMIT 1];
            
            if(accDetail.Brand__c=='Spectrum'){
                SendSMS(paPrimary.PersonID__r.Mobile_Phone__pc,'Wires Progress Alert Spectrum');
            }
            
            if(accDetail.Brand__c=='Chevron'){
                SendSMS(paPrimary.PersonID__r.Mobile_Phone__pc,'Wires Progress Alert Chevron');
            }
            
        }
    }
    
    public static void ReleasedToWireXchangeSMSNotification(Set<Id> id){
        
         List<WIRES_Transaction__c> wireTransactions = [SELECT id,Approval_Status__c,ToAccountName__c,ToAccoutId__c,
                                                       Status__c, FromAccount__c,TotalFromAccount__c,WireAmount__c,
                                                       ToAccoutId__r.Recipient_AccountNumber__c,
                                                       ToAccoutId__r.BankName__c
                                                       from WIRES_Transaction__c where id=:id];
        
        for(WIRES_Transaction__c c: wireTransactions){
            
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
                                           WHERE Account_Number__r.Name =: c.FromAccount__c 
                                           and TypeTranslate__c  like '%Primary%' limit 1];
            
            Account_Details__c accDetail=[SELECT Id,Name, Brand__c FROM Account_Details__c 
                                          WHERE Name=:c.FromAccount__c  AND RecType__c = 'ACCT' LIMIT 1];
            
            if(accDetail.Brand__c=='Spectrum'){
                SendSMS(paPrimary.PersonID__r.Mobile_Phone__pc,'Wires Transfer Release Alert Spectrum');
            }
            
            if(accDetail.Brand__c=='Chevron'){
                SendSMS(paPrimary.PersonID__r.Mobile_Phone__pc,'Wires Transfer Release Alert Chevron');
            }
            
        }
    }
}