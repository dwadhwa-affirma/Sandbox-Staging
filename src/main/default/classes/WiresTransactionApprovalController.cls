public class WiresTransactionApprovalController {
    
    @AuraEnabled
    public static  Map<string,object> getWiresData(string WiresRecordId){
        Map<string,object> strMap = new  Map<string,object>();
        WIRES_Transaction__c WiresList = [SELECT id,Approval_Status__c,DocuSign_Status1__c,
                                          Status__c, FromAccount__c,Share_ID__c,Source__c,TotalFromAccount__c,
                                          WireAmount__c, Description__c, IsAccountOpenfor45Days__c, Member_Name__c, 
                                          Identity_Verification_Used__c, IsEmailStable__c, IsHomePhoneStable__c, IsMobilePhoneStable__c, IsWorkPhoneStable__c,                                          
                                          AccountStableReview__c,Review_Reason__c,Available_Balance_Review__c, EmailStableReview__c,
                                          Home_Phone_Stable_Review__c,ID_Verification_Review__c, Mobile_Phone_Stable_Review__c, 
                                          Previous_Wires_Review__c, Work_Phone_Stable_Review__c, FlagAccountOpenfor45Days__c,
                                          FlagEmailStablefor30Days__c, FlagHomePhoneStablefor30Days__c, FlagMobilePhoneStablefor30Days__c, FlagWorkPhoneStablefor30Days__c,
                                          Second_Approval_Review_Reason__c                                           
                                          from WIRES_Transaction__c where id=:WiresRecordId limit 1];
        
        string isApprovalVisible;
        
        if(WiresList.Approval_Status__c=='Fraud Review'){
            Group grp = [SELECT DeveloperName,Email,Id,Name,RelatedId,Type 
                         FROM Group WHERE DeveloperName ='Wires_Fraud_Review' Limit 1];
            GroupMember[] gm  = [SELECT GroupId,Id,UserOrGroupId FROM GroupMember where GroupId =: grp.id and UserOrGroupId =: UserInfo.getUserId() ];
            
            if(gm.size()>0){
                isApprovalVisible = 'true';
            }else{
                isApprovalVisible = 'false';
            }
        }
        System.debug('Status'+WiresList.Approval_Status__c);
        if(WiresList.Approval_Status__c=='Good Funds Check Failed' 
           || (WiresList.Approval_Status__c=='Pending for Approval')){
            
            Group grpA = [SELECT DeveloperName,Email,Id,Name,RelatedId,Type 
                          FROM Group WHERE DeveloperName ='Branch_Group_A' Limit 1];
            GroupMember[] grpAmembers  = [SELECT GroupId,Id,UserOrGroupId FROM GroupMember where GroupId =: grpA.id and UserOrGroupId =: UserInfo.getUserId()];
            
            Group grpB = [SELECT DeveloperName,Email,Id,Name,RelatedId,Type 
                          FROM Group WHERE DeveloperName ='Branch_Group_B' Limit 1];
            GroupMember[] grpBmembers  = [SELECT GroupId,Id,UserOrGroupId FROM GroupMember where GroupId =: grpB.id and UserOrGroupId =: UserInfo.getUserId()];
            
            Group grpC = [SELECT DeveloperName,Email,Id,Name,RelatedId,Type 
                          FROM Group WHERE DeveloperName ='Branch_Group_C' Limit 1];
            GroupMember[] grpCmembers  = [SELECT GroupId,Id,UserOrGroupId FROM GroupMember where GroupId =: grpC.id and UserOrGroupId =: UserInfo.getUserId()];
            
            Group grpD = [SELECT DeveloperName,Email,Id,Name,RelatedId,Type 
                          FROM Group WHERE DeveloperName ='Branch_Group_D' Limit 1];
            GroupMember[] grpDmembers  = [SELECT GroupId,Id,UserOrGroupId FROM GroupMember where GroupId =: grpD.id and UserOrGroupId =: UserInfo.getUserId()];
            
            Group grpE = [SELECT DeveloperName,Email,Id,Name,RelatedId,Type 
                          FROM Group WHERE DeveloperName ='Branch_Group_E' Limit 1];
            GroupMember[] grpEmembers  = [SELECT GroupId,Id,UserOrGroupId FROM GroupMember where GroupId =: grpE.id and UserOrGroupId =: UserInfo.getUserId()];
            
           	if(WiresList.TotalFromAccount__c>0 && WiresList.TotalFromAccount__c<=10000){
                isApprovalVisible = 'true';
            }
               
            if(WiresList.TotalFromAccount__c>10000 && WiresList.TotalFromAccount__c<=50000){
                if(grpAmembers.size()>0 || grpBmembers.size()>0 || grpCmembers.size()>0 || grpDmembers.size()>0){
                    isApprovalVisible = 'true';
                }else{
                    isApprovalVisible = 'false';
                }
            }
            
            if(WiresList.TotalFromAccount__c>50000 && WiresList.TotalFromAccount__c<=100000){
                if(grpBmembers.size()>0 || grpCmembers.size()>0 || grpDmembers.size()>0){
                    isApprovalVisible = 'true';
                }else{
                    isApprovalVisible = 'false';
                }
            }
            
            if(WiresList.TotalFromAccount__c>100000 && WiresList.TotalFromAccount__c<=250000){
                if(grpCmembers.size()>0 || grpDmembers.size()>0 || grpEmembers.size()>0){
                    isApprovalVisible = 'true';
                }else{
                    isApprovalVisible = 'false';
                }
            }
            
            if(WiresList.TotalFromAccount__c>250000 && WiresList.TotalFromAccount__c<=500000){
                if(grpCmembers.size()>0 || grpDmembers.size()>0 || grpEmembers.size()>0){
                    isApprovalVisible = 'true';
                }else{
                    isApprovalVisible = 'false';
                }
            }
            
            if(WiresList.TotalFromAccount__c>500000 && WiresList.TotalFromAccount__c<=1500000){
                if(grpDmembers.size()>0 || grpEmembers.size()>0){
                    isApprovalVisible = 'true';
                }else{
                    isApprovalVisible = 'false';
                }
            }
            
            if(WiresList.TotalFromAccount__c>1500000){
                if(grpEmembers.size()>0){
                    isApprovalVisible = 'true';
                }else{
                    isApprovalVisible = 'false';
                }
            }
            
        }
        
        strMap.put('isApprovalVisible',isApprovalVisible);   
        strMap.put('ApprovalStatus',WiresList.Approval_Status__c); 
        strMap.put('WiresList',WiresList);  
        strMap.put('WiresBalance','TBD');
        strMap.put('WiresBalance',checkWiresFunds(WiresList.FromAccount__c, WiresList.Share_ID__c,WiresList.TotalFromAccount__c));
        
        List<WIRES_Transaction__c> Wires = [SELECT id,Approval_Status__c, FromAccount__c,Share_ID__c,
                                            WireAmount__c, Description__c, IsAccountOpenfor45Days__c, Member_Name__c 
                                            from WIRES_Transaction__c where Member_Name__c=: WiresList.Member_Name__c and id !=: WiresList.id];
        
        strMap.put('WiresCount',String.valueOf(Wires.size()));
        // strMap.put('IdentificationUsed',WiresList.Identity_Verification_Used__c);
        
        system.debug('WiresList.Identity_Verification_Used__c=='+WiresList.Identity_Verification_Used__c);
        return strMap;
        
    }
    
    @AuraEnabled
    public static void ApproveTransaction(string WiresRecordId, string Action, string wiresdetails){
        system.debug('WiresObject=='+wiresdetails);
        WIRES_Transaction__c WiresObject = (WIRES_Transaction__c)JSON.deserialize(wiresdetails, WIRES_Transaction__c.class);
        system.debug('wiresdetails=='+WiresObject.AccountStableReview__c);
        WIRES_Transaction__c Wires = [SELECT id,Approval_Status__c, FromAccount__c,Share_ID__c,Source__c,
                                      WireAmount__c, Description__c, IsAccountOpenfor45Days__c, Member_Name__c, 
                                      Identity_Verification_Used__c, IsEmailStable__c, IsHomePhoneStable__c, IsMobilePhoneStable__c, IsWorkPhoneStable__c,                                          
                                      AccountStableReview__c,Review_Reason__c,Available_Balance_Review__c, EmailStableReview__c,
                                      Home_Phone_Stable_Review__c,ID_Verification_Review__c, Mobile_Phone_Stable_Review__c, 
                                      Previous_Wires_Review__c, Work_Phone_Stable_Review__c, FlagAccountOpenfor45Days__c,
                                      FlagEmailStablefor30Days__c, FlagHomePhoneStablefor30Days__c, FlagMobilePhoneStablefor30Days__c, FlagWorkPhoneStablefor30Days__c 
                                      from WIRES_Transaction__c where id=:WiresRecordId limit 1];
        if(Action == 'Reject'){
            Wires.Approval_Status__c = 'Rejected'; 
        }
        if(Action=='Pending for Approval'){
            Wires.Approval_Status__c = 'Pending for Approval'; 
        }
        if(Action == 'Good Funds Check Failed'){
            Wires.Approval_Status__c = 'Good Funds Check Failed';
            Wires.AccountStableReview__c = WiresObject.AccountStableReview__c;
            Wires.Available_Balance_Review__c = WiresObject.Available_Balance_Review__c;
            Wires.Review_Reason__c = WiresObject.Review_Reason__c;
            Wires.EmailStableReview__c = WiresObject.EmailStableReview__c;
            Wires.Home_Phone_Stable_Review__c = WiresObject.Home_Phone_Stable_Review__c;
            Wires.ID_Verification_Review__c = WiresObject.ID_Verification_Review__c;
            Wires.Mobile_Phone_Stable_Review__c = WiresObject.Mobile_Phone_Stable_Review__c;
            Wires.Previous_Wires_Review__c = WiresObject.Previous_Wires_Review__c;
            Wires.Work_Phone_Stable_Review__c = WiresObject.Work_Phone_Stable_Review__c;
        }
        else if((Wires.Approval_Status__c == 'Pending for Approval'|| Wires.Approval_Status__c == 'Fraud Review'
                || Wires.Approval_Status__c == 'Good Funds Check Failed')){
            Wires.Approval_Status__c = 'Approved';
            Wires.AccountStableReview__c = WiresObject.AccountStableReview__c;
            Wires.Available_Balance_Review__c = WiresObject.Available_Balance_Review__c;
            Wires.Review_Reason__c = WiresObject.Review_Reason__c;
            Wires.EmailStableReview__c = WiresObject.EmailStableReview__c;
            Wires.Home_Phone_Stable_Review__c = WiresObject.Home_Phone_Stable_Review__c;
            Wires.ID_Verification_Review__c = WiresObject.ID_Verification_Review__c;
            Wires.Mobile_Phone_Stable_Review__c = WiresObject.Mobile_Phone_Stable_Review__c;
            Wires.Previous_Wires_Review__c = WiresObject.Previous_Wires_Review__c;
            Wires.Work_Phone_Stable_Review__c = WiresObject.Work_Phone_Stable_Review__c;
            wires.Approved_by_1st_Approver__c = UserInfo.getUserId();
            wires.ApprovedDate__c=System.now();
        }
        
        system.debug('Wires=='+Wires);
        update Wires;
    }
    
    public static void SendProgressNotification(Set<Id> id){
        
        System.debug('In Progress Email Notification');
        System.debug('Id:'+Id);
        String EmailToSend='';
        Wires_Progress_Email_Test__c testEmail=Wires_Progress_Email_Test__c.getValues('Test');
        
        String userEmail = testEmail.Email__c;
        
        Wires_Docusign_Emails__c wde = Wires_Docusign_Emails__c.getValues('Email For Testing');
        if(wde.Emails__c != null){
            EmailToSend = wde.Emails__c;
        }
        
        List<WIRES_Transaction__c> WiresTrans = [SELECT Id,Member_Email__c
                                                 FROM WIRES_Transaction__c WHERE id =: id LIMIT 1];
        
        if(EmailToSend == 'Production' || EmailToSend == 'production'){
            EmailToSend = WiresTrans[0].Member_Email__c;     
        }
        
        if(EmailToSend != 'Production' || EmailToSend != 'production'){
            EmailToSend = userEmail;
        }
        
        SendEmail(id,EmailToSend);
    }
    
    @future(callout=true)
    public static void CheckRedFlgsAndUpdateStatus(Set<Id> id){
        
        System.debug('Id:'+Id);
        List<WIRES_Transaction__c> wireTransactions = [SELECT Id,Approval_Status__c,ToAccountName__c,ToAccoutId__c,
                                                       Status__c, FromAccount__c,TotalFromAccount__c,WireAmount__c,
                                                       ToAccoutId__r.Recipient_AccountNumber__c,
                                                       ToAccoutId__r.BankName__c,AccountStableReview__c,
                                                       EmailStableReview__c,Home_Phone_Stable_Review__c,
                                                       Mobile_Phone_Stable_Review__c,Work_Phone_Stable_Review__c,
                                                       FlagAccountOpenfor45Days__c,FlagEmailStablefor30Days__c,
                                                       FlagHomePhoneStablefor30Days__c,FlagMobilePhoneStablefor30Days__c,
                                                       FlagWorkPhoneStablefor30Days__c,Share_ID__c
                                                       FROM WIRES_Transaction__c WHERE id=:id];
        
        List<WIRES_Transaction__c> wiresToUpdate=new List<WIRES_Transaction__c>();
        
        List<Case> fraudCases=new List<Case>();
        for(WIRES_Transaction__c wt:wireTransactions){
            
            if(wt.TotalFromAccount__c>250000){
                  wt.Approval_Status__c='Fraud Review';
                  wiresToUpdate.add(wt);
                
                List<Account_Details__c> listAccountDetails = [select id,Brand__c,ID1__c,OPEN_DATE__c from Account_Details__c where Name =: wt.FromAccount__c and RecType__c='ACCT' LIMIT 1];
                Case case1 =new Case();
                case1.Subject='WIRES Fraud Review';
                case1.Primary_Category__c='Account Maintenance';
                case1.Secondary_Category__c=' Special Situations';
                case1.Tertiary_Category__c='Potential Fraud';
                if(listAccountDetails.size()>0){
                	case1.Account_Number__c=listAccountDetails[0].Id;
                }
                
                fraudCases.add(case1);
            }else{
            integer statusCode=0;
            boolean isGoodFundCheck=false;
            if(wt.TotalFromAccount__c>10000){
                //Map<string,object> results = checkWiresFunds(wt.FromAccount__c, wt.Share_ID__c,wt.TotalFromAccount__c);
                
                decimal amount=wt.TotalFromAccount__c;
                String AccountNumber=wt.FromAccount__c;
                String ShareID=wt.Share_ID__c;
                
                Map<String,Object> results = new Map<String,Object>();
                httpRequest requestparam = new httpRequest(); 
                system.debug('amount=='+amount);
                requestparam.setEndpoint('https://symxapi.chevronfcu.org/devclient/Wires/WiresFundsCheck?amount=' + amount +'&accountNumber=' + AccountNumber + '&shareId=' + ShareID);
                requestparam.setMethod('GET');      
                
                
                http httpParam = new http();
                httpResponse response = httpParam.send(requestparam);
                
                String strStatus = response.getStatus();
                String strBody = response.getBody();
                
                System.debug('Service response is ....' + strStatus);
                System.debug('Service response is ....' + strBody);
                
                if(strBody!=''){        
                    results = (Map<String,Object>) JSON.deserializeUntyped(response.getBody());      
                    System.debug('Service response is ....' + results);              
                }
                
                if(results.size() > 0){
                    for(String key : results.keySet()){                             
                        if(key == 'StatusCode'){
                            statusCode = integer.valueOf(results.get(key));
                            isGoodFundCheck=true;
                        }
                    }
                }
            }
            
            if(wt.FlagAccountOpenfor45Days__c && wt.FlagEmailStablefor30Days__c
               && wt.FlagHomePhoneStablefor30Days__c && wt.FlagMobilePhoneStablefor30Days__c
               && wt.FlagWorkPhoneStablefor30Days__c){
                   if(isGoodFundCheck==true && statusCode<=0){
                       wt.Approval_Status__c = 'Good Funds Check Failed';
                       wiresToUpdate.add(wt);
                   }else if(isGoodFundCheck==true && statusCode>0 && wt.TotalFromAccount__c>250000 ){
                       wt.Approval_Status__c = 'Pending for Approval';
                       wiresToUpdate.add(wt);
                   }
                   else{
                       wt.Approval_Status__c = 'Approved';
                       wt.Approved_by_1st_Approver__c = UserInfo.getUserId();
                       wiresToUpdate.add(wt);
                   }
               }else{
                   wt.Approval_Status__c='Fraud Review';
                   wiresToUpdate.add(wt);
               }
            }
        }
        
        if(fraudCases.size()>0){
            insert fraudCases;
        }
        if(wiresToUpdate.size()>0){
            update wiresToUpdate;
        }
    }
    
    @AuraEnabled
    public static void SendToFraud(Id id){
        WIRES_Transaction__c wireTransaction = [SELECT id,Approval_Status__c                                
                                                FROM WIRES_Transaction__c WHERE id=:id limit 1];
        wireTransaction.Approval_Status__c='Fraud Review';
        update wireTransaction;
    }
    
    @AuraEnabled
    public static void SendToGoodFundCheckFailed(Id id){
        WIRES_Transaction__c wireTransaction = [SELECT id,Approval_Status__c                                
                                                FROM WIRES_Transaction__c WHERE id=:id limit 1];
        wireTransaction.Approval_Status__c='Good Funds Check Failed';
        update wireTransaction;
    }
    
    @AuraEnabled
    public static void SendDocusignEmail(Id id){
        
        System.debug('Recived id in ctrl'+id);
        Set<ID> ids=new Set<ID>();
        ids.add(id);
        System.debug('In contorller Ids'+ids);
        WiresTransToDocuSign.docusignAPIcall(ids);    	    
    }
    
    
    // --------------------- Send Email Notification..................//   
    
    private static void SendEmail(Set<Id> id,string ToEmail)
    {
        List<WIRES_Transaction__c> wireTransactions = [SELECT id,Approval_Status__c,ToAccountName__c,ToAccoutId__c,
                                                       Status__c, FromAccount__c,TotalFromAccount__c,WireAmount__c,
                                                       ToAccoutId__r.Recipient_AccountNumber__c,
                                                       ToAccoutId__r.BankName__c
                                                       from WIRES_Transaction__c where id=:id];
        
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        
        for(WIRES_Transaction__c wt:wireTransactions){
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            List<String> sendTo = new List<String>();
            sendTo.add(ToEmail);
            
            
            mail.setToAddresses(sendTo);
            string templatenAME = 'Wires Progress Email';
            List<EmailTemplate> listEmailTemplate =  [select Id,Name,Body,Subject,HtmlValue from EmailTemplate where Name =: templatenAME];
            
            mail.setSubject(listEmailTemplate[0].Subject);
            
            
            string emailadd;
            
            emailadd = 'noreply@chevronfcu.org';
            
            
            List<OrgWideEmailAddress> listAdd = [select Id,Address,DisplayName  from OrgWideEmailAddress where Address =: emailadd];
			
            if(!Test.isRunningTest()){            
                string body = listEmailTemplate[0].Body;
                body=body.replace('{BankName__c}', wt.ToAccoutId__r.BankName__c);
                body=body.replace('{TotalFromAccount__c}',string.valueOf(wt.TotalFromAccount__c));
                body=body.replace('{ToAccoutId__c}', wt.ToAccoutId__r.Recipient_AccountNumber__c);
                body=body.replace('{FromAccount__c}', wt.FromAccount__c);
                mail.setPlainTextBody(body);
                mail.setOrgWideEmailAddressId(listAdd[0].Id);
                mails.add(mail);
            }
        }
        
        
        Messaging.sendEmail(mails);
        
    }
    // --------------------- Send Email Notification..................//   
    
    // --------------------- Send SMS Notification..................//   
    
    private static void SendSMS(string phone)
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
    }
    
    // --------------------- Send SMS Notification..................//   
    
    private static Map<String,Object> checkWiresFunds(string AccountNumber, string ShareID, decimal amount){
        Map<String,Object> results = new Map<String,Object>();
        httpRequest requestparam = new httpRequest(); 
        system.debug('amount=='+amount);
        requestparam.setEndpoint('https://symxapi.chevronfcu.org/devclient/Wires/WiresFundsCheck?amount=' + amount +'&accountNumber=' + AccountNumber + '&shareId=' + ShareID);
        requestparam.setMethod('GET');      
        
        
        http httpParam = new http();
        httpResponse response = httpParam.send(requestparam);
        
        String strStatus = response.getStatus();
        String strBody = response.getBody();
        
        System.debug('Service response is ....' + strStatus);
        System.debug('Service response is ....' + strBody);
        
        if(strBody!=''){        
            results = (Map<String,Object>) JSON.deserializeUntyped(response.getBody());      
            System.debug('Service response is ....' + results);              
        }
        return results;
    }
}