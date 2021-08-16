public class WiresTransactionApprovalController {
    
    @AuraEnabled
    public static  Map<string,object> getWiresData(string WiresRecordId){
        Map<string,object> strMap = new  Map<string,object>();
        WIRES_Transaction__c WiresList = [SELECT id,Approval_Status__c,DocuSign_Status1__c,
                                          Status__c, FromAccount__c,Share_ID__c,Source__c,TotalFromAccount__c,
                                          WireAmount__c, Description__c, IsAccountOpenfor45Days__c, Member_Name__c, 
                                          Identity_Verification_Used__c, IsEmailStable__c, IsHomePhoneStable__c, IsMobilePhoneStable__c, IsWorkPhoneStable__c,                                          
                                          AccountStableReview__c,Available_Balance_Review__c, EmailStableReview__c,
                                          Home_Phone_Stable_Review__c,ID_Verification_Review__c, Mobile_Phone_Stable_Review__c, 
                                          Previous_Wires_Review__c, Work_Phone_Stable_Review__c, FlagAccountOpenfor45Days__c,
                                          FlagEmailStablefor30Days__c, FlagHomePhoneStablefor30Days__c, FlagMobilePhoneStablefor30Days__c, FlagWorkPhoneStablefor30Days__c,
                                          Review_Reason__c,Second_Approval_Review_Reason__c,Available_Balance2_Review__c,
                                          Previous_Wires2_Review__c,Approved_by_1st_Approver__c,CreatedById,
                                          Good_Funds_Check__c,BalanceRGLines__c,BalanceStatusCode__c,
                                          First_Approval_Comment__c,Second_Approval_Comment__c
                                          from WIRES_Transaction__c where id=:WiresRecordId limit 1];
        
        string isApprovalVisible;
        
        if(WiresList.Approval_Status__c==WiresConstant.ApprovalStatus_FraudReview){
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
        if(WiresList.Approval_Status__c==WiresConstant.ApprovalStatus_GoodFundsReview 
           || (WiresList.Approval_Status__c==WiresConstant.ApprovalStatus_PendingForApproval)
           || (WiresList.Approval_Status__c==WiresConstant.ApprovalStatus_PendingForSecondApproval)){
               
               
               string grpAName='';
               string grpBName='';
               string grpCName='';
               string grpDName='';
               string grpEName='';
               
               if(WiresList.Source__c==WiresConstant.Source_Branch){
                   grpAName=WiresConstant.Branch_Group_A;
                   grpBName=WiresConstant.Branch_Group_B;
                   grpCName=WiresConstant.Branch_Group_C;
                   grpDName=WiresConstant.Branch_Group_D;
                   grpEName=WiresConstant.Branch_Group_E;
               }else{
                   grpAName=WiresConstant.Online_Group_A;
                   grpBName=WiresConstant.Online_Group_B;
                   grpCName=WiresConstant.Online_Group_C;
                   grpDName=WiresConstant.Online_Group_D;
                   grpEName=WiresConstant.Online_Group_E;
               }
               
               Group grpA = [SELECT DeveloperName,Email,Id,Name,RelatedId,Type 
                             FROM Group WHERE DeveloperName =:grpAName Limit 1];
               GroupMember[] grpAmembers  = [SELECT GroupId,Id,UserOrGroupId FROM GroupMember where GroupId =: grpA.id and UserOrGroupId =: UserInfo.getUserId()];
               
               Group grpB = [SELECT DeveloperName,Email,Id,Name,RelatedId,Type 
                             FROM Group WHERE DeveloperName =:grpBName Limit 1];
               GroupMember[] grpBmembers  = [SELECT GroupId,Id,UserOrGroupId FROM GroupMember where GroupId =: grpB.id and UserOrGroupId =: UserInfo.getUserId()];
               
               Group grpC = [SELECT DeveloperName,Email,Id,Name,RelatedId,Type 
                             FROM Group WHERE DeveloperName =:grpCName Limit 1];
               GroupMember[] grpCmembers  = [SELECT GroupId,Id,UserOrGroupId FROM GroupMember where GroupId =: grpC.id and UserOrGroupId =: UserInfo.getUserId()];
               
               Group grpD = [SELECT DeveloperName,Email,Id,Name,RelatedId,Type 
                             FROM Group WHERE DeveloperName =:grpDName Limit 1];
               GroupMember[] grpDmembers  = [SELECT GroupId,Id,UserOrGroupId FROM GroupMember where GroupId =: grpD.id and UserOrGroupId =: UserInfo.getUserId()];
               
               Group grpE = [SELECT DeveloperName,Email,Id,Name,RelatedId,Type 
                             FROM Group WHERE DeveloperName =:grpEName Limit 1];
               GroupMember[] grpEmembers  = [SELECT GroupId,Id,UserOrGroupId FROM GroupMember where GroupId =: grpE.id and UserOrGroupId =: UserInfo.getUserId()];
               
               if(WiresList.Source__c==WiresConstant.Source_Branch){
                   
                   if(WiresList.TotalFromAccount__c>0 && WiresList.TotalFromAccount__c<=25000){
                       
                       if(grpAmembers.size()>0 || grpBmembers.size()>0 || grpCmembers.size()>0 || grpDmembers.size()>0 || grpEmembers.size()>0){
                           isApprovalVisible = 'true';
                       }else{
                           isApprovalVisible = 'false';
                       }   
                   }
                   
                   if(WiresList.TotalFromAccount__c>25000 && WiresList.TotalFromAccount__c<=100000){
                       
                       if(grpBmembers.size()>0 || grpCmembers.size()>0 || grpDmembers.size()>0 || grpEmembers.size()>0){
                           isApprovalVisible = 'true';
                       }else{
                           isApprovalVisible = 'false';
                       }   
                   }
                   
                   if(WiresList.TotalFromAccount__c>100000 && WiresList.TotalFromAccount__c<=250000){
                       if(WiresList.Approval_Status__c==WiresConstant.ApprovalStatus_PendingForSecondApproval){
                           if(grpCmembers.size()>0 || grpDmembers.size()>0 || grpEmembers.size()>0){
                               isApprovalVisible = 'true';
                           }else{
                               isApprovalVisible = 'false';
                           }   
                       }else{
                           if(grpCmembers.size()>0 || grpDmembers.size()>0){
                               isApprovalVisible = 'true';
                           }else{
                               isApprovalVisible = 'false';
                           }   
                       }
                   }
                   
                   if(WiresList.TotalFromAccount__c>250000 && WiresList.TotalFromAccount__c<=1000000){
                       if(WiresList.Approval_Status__c==WiresConstant.ApprovalStatus_PendingForSecondApproval){
                           
                           if(grpDmembers.size()>0 || grpEmembers.size()>0){
                               isApprovalVisible = 'true';
                           }else{
                               isApprovalVisible = 'false';
                           }  
                           
                       }else{
                           if(grpCmembers.size()>0 || grpDmembers.size()>0){
                               isApprovalVisible = 'true';
                           }else{
                               isApprovalVisible = 'false';
                           }   
                       }
                   }
                   
                   if(WiresList.TotalFromAccount__c>1000000){
                       
                       if(WiresList.Approval_Status__c==WiresConstant.ApprovalStatus_PendingForSecondApproval){
                           if(grpEmembers.size()>0){
                               isApprovalVisible = 'true';
                           }else{
                               isApprovalVisible = 'false';
                           }  
                       }else{
                           if(grpCmembers.size()>0 || grpDmembers.size()>0){
                               isApprovalVisible = 'true';
                           }else{
                               isApprovalVisible = 'false';
                           }   
                       }
                   }
                   
                   if(isApprovalVisible=='true'){
                       
                       System.debug('WiresList.Approval_Status__c: '+WiresList.Approval_Status__c);
                       System.debug('Constant: '+WiresConstant.ApprovalStatus_PendingForSecondApproval);
                       System.debug('WiresList.Approved_by_1st_Approver__c: '+WiresList.Approved_by_1st_Approver__c);
                       System.debug('UserInfo.getUserId(): '+UserInfo.getUserId());
                       if(WiresList.Approval_Status__c==WiresConstant.ApprovalStatus_PendingForSecondApproval 
                          && WiresList.Approved_by_1st_Approver__c== UserInfo.getUserId()){
                              isApprovalVisible = 'false';
                          }
                   }
                   
                   //The person/user that submitted the wire should not be able to approve the same wire even if user/person is in the approval group
                   if(WiresList.CreatedById==UserInfo.getUserId()){
                       isApprovalVisible='false';
                   }
                   
               }else{
                   
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
           }
        
        strMap.put('Source',WiresList.Source__c); 
        
        strMap.put('isApprovalVisible',isApprovalVisible);   
        strMap.put('ApprovalStatus',WiresList.Approval_Status__c); 
        strMap.put('WiresList',WiresList);  
        strMap.put('WiresBalance','TBD');
        
        string goodFundStatus= WiresList.Good_Funds_Check__c!=null ? WiresList.Good_Funds_Check__c.Split('\\---')[0]:'';
        
        System.debug('Status of goodfund:'+goodFundStatus);
        if((WiresList.Approval_Status__c==WiresConstant.ApprovalStatus_PendingForApproval 
            || WiresList.Approval_Status__c==WiresConstant.ApprovalStatus_PendingForSecondApproval
            || WiresList.Approval_Status__c==WiresConstant.ApprovalStatus_GoodFundsReview) 
           && (goodFundStatus=='' || goodFundStatus!='PASS')) {    
               
               Map<String,Object> checkWiresFundsResult=checkWiresFunds(WiresList.FromAccount__c, WiresList.Share_ID__c,WiresList.TotalFromAccount__c);
               
               Object statusCode=checkWiresFundsResult.get('StatusCode');
               Object statusMsg=checkWiresFundsResult.get('StatusMessage');
               
               if(WiresList.Approval_Status__c!=WiresConstant.ApprovalStatus_PendingForMemberReview){
                   if(Integer.valueOf(statusCode)<=0){
                       WiresList.Good_Funds_Check__c='FAIL---'+statusMsg.toString();
                   }else{
                       WiresList.Good_Funds_Check__c='PASS---'+statusMsg.toString();
                   }
                   
                   WiresList.BalanceRGLines__c=statusMsg.toString();
                   WiresList.BalanceStatusCode__c=statusCode.toString();
                   
                   update WiresList;
               }
               
               strMap.put('BalanceRGLines',statusMsg);
               strMap.put('BalanceStatusCode',statusCode);
           }else{
               strMap.put('BalanceRGLines',WiresList.BalanceRGLines__c);
               strMap.put('BalanceStatusCode',WiresList.BalanceStatusCode__c);
           }
        
        List<WIRES_Transaction__c> Wires = [SELECT id,Approval_Status__c, FromAccount__c,Share_ID__c,
                                            WireAmount__c, Description__c, IsAccountOpenfor45Days__c, Member_Name__c 
                                            from WIRES_Transaction__c where Member_Name__c=: WiresList.Member_Name__c and id !=: WiresList.id];
        
        strMap.put('WiresCount',String.valueOf(Wires.size()));
        
        system.debug('WiresList.Identity_Verification_Used__c=='+WiresList.Identity_Verification_Used__c);
        return strMap;
        
    }
    
    @AuraEnabled
    public static void CancelTransaction(string WiresRecordId, string Reason){
        
        WIRES_Transaction__c Wires = [SELECT id,Approval_Status__c, FromAccount__c,Share_ID__c,Source__c,TotalFromAccount__c,
                                      WireAmount__c, Description__c, IsAccountOpenfor45Days__c, Member_Name__c, 
                                      Identity_Verification_Used__c, IsEmailStable__c, IsHomePhoneStable__c, IsMobilePhoneStable__c, IsWorkPhoneStable__c,                                          
                                      AccountStableReview__c,Available_Balance_Review__c, EmailStableReview__c,Review_Reason__c,
                                      Home_Phone_Stable_Review__c,ID_Verification_Review__c, Mobile_Phone_Stable_Review__c, 
                                      Previous_Wires_Review__c, Work_Phone_Stable_Review__c, FlagAccountOpenfor45Days__c,
                                      FlagEmailStablefor30Days__c, FlagHomePhoneStablefor30Days__c, FlagMobilePhoneStablefor30Days__c, FlagWorkPhoneStablefor30Days__c 
                                      from WIRES_Transaction__c where id=:WiresRecordId limit 1];
        
        Wires.Approval_Status__c = WiresConstant.ApprovalStatus_Cancelled;
        Wires.Cancel_Reason__c = Reason;
        Wires.Cancelled_By__c=UserInfo.getUserId();
        Wires.Cancelled_On__c=DateTime.now();
        
        update Wires;
        
        set<id> wiresId=new Set<id>();
        wiresId.add(Wires.Id);
        WiresEmailController.SendBranchWireCancelledOrRejectEmailNotification(wiresId,true);
    }
    
    @AuraEnabled
    public static void ApproveTransaction(string WiresRecordId, string Action, string wiresdetails){
        WIRES_Transaction__c WiresObject = (WIRES_Transaction__c)JSON.deserialize(wiresdetails, WIRES_Transaction__c.class);
        
        WIRES_Transaction__c Wires = [SELECT id,Approval_Status__c, FromAccount__c,Share_ID__c,Source__c,TotalFromAccount__c,
                                      WireAmount__c, Description__c, IsAccountOpenfor45Days__c, Member_Name__c, 
                                      Identity_Verification_Used__c, IsEmailStable__c, IsHomePhoneStable__c, IsMobilePhoneStable__c, IsWorkPhoneStable__c,                                          
                                      AccountStableReview__c,Available_Balance_Review__c, EmailStableReview__c,Review_Reason__c,
                                      Home_Phone_Stable_Review__c,ID_Verification_Review__c, Mobile_Phone_Stable_Review__c, 
                                      Previous_Wires_Review__c, Work_Phone_Stable_Review__c, FlagAccountOpenfor45Days__c,
                                      FlagEmailStablefor30Days__c, FlagHomePhoneStablefor30Days__c, FlagMobilePhoneStablefor30Days__c, FlagWorkPhoneStablefor30Days__c ,
                                      First_Approval_Comment__c,Second_Approval_Comment__c
                                      from WIRES_Transaction__c where id=:WiresRecordId limit 1];
        if(Action == 'Reject'){
            Wires.Approval_Status__c = WiresConstant.ApprovalStatus_Rejected; 
            Wires.Rejected_By__c=UserInfo.getUserId();
            Wires.Rejected_On__c=DateTime.now();
            Wires.First_Approval_Comment__c=WiresObject.First_Approval_Comment__c;
        }
        
        if(Action == 'Good Funds Review'){
            Wires.Approval_Status__c = WiresConstant.ApprovalStatus_GoodFundsReview;
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
        else if((Wires.Approval_Status__c == WiresConstant.ApprovalStatus_PendingForApproval 
                 || Wires.Approval_Status__c == WiresConstant.ApprovalStatus_PendingForSecondApproval
                 || Wires.Approval_Status__c == WiresConstant.ApprovalStatus_FraudReview
                 || Wires.Approval_Status__c == WiresConstant.ApprovalStatus_GoodFundsReview)){
                     
                     if(Wires.Source__c==WiresConstant.Source_Branch){
                         
                         if(Wires.TotalFromAccount__c>100000 
                            && Wires.Approval_Status__c != WiresConstant.ApprovalStatus_PendingForSecondApproval){
                                
                                Wires.Approval_Status__c = WiresConstant.ApprovalStatus_PendingForSecondApproval;
                                
                                Wires.Approved_by_1st_Approver__c = UserInfo.getUserId();
                                Wires.Available_Balance_Review__c = WiresObject.Available_Balance_Review__c;
                                Wires.Previous_Wires_Review__c = WiresObject.Previous_Wires_Review__c;
                            }
                         else
                         {
                             Wires.Available_Balance2_Review__c = WiresObject.Available_Balance_Review__c;
                             Wires.Previous_Wires2_Review__c = WiresObject.Previous_Wires_Review__c;
                             Wires.ApprovedDate__c=System.now();
                             
                             System.debug('In else');
                             System.debug('Wires.Approval_Status__c:'+Wires.Approval_Status__c);
                             if(Wires.TotalFromAccount__c>100000 
                                && Wires.Approval_Status__c == WiresConstant.ApprovalStatus_PendingForSecondApproval){
                                    
                                    System.debug('In second arrpoval');
                                    Wires.Approved_by_2nd_Approver__c = UserInfo.getUserId();
                                }else{
                                    
                                    System.debug('In fisrt approval');
                                    Wires.Approved_by_1st_Approver__c = UserInfo.getUserId();
                                }
                             
                             Wires.Approval_Status__c = WiresConstant.ApprovalStatus_Approved;
                         }
                     }else{
                         Wires.Approval_Status__c = WiresConstant.ApprovalStatus_Approved;  
                         wires.ApprovedDate__c=System.now();
                         Wires.Available_Balance_Review__c = WiresObject.Available_Balance_Review__c;
                         Wires.Previous_Wires_Review__c = WiresObject.Previous_Wires_Review__c;
                         wires.Approved_by_1st_Approver__c = UserInfo.getUserId();
                     }
                     
                     
                     Wires.AccountStableReview__c = WiresObject.AccountStableReview__c;
                     Wires.Review_Reason__c = WiresObject.Review_Reason__c;
                     Wires.EmailStableReview__c = WiresObject.EmailStableReview__c;
                     Wires.Home_Phone_Stable_Review__c = WiresObject.Home_Phone_Stable_Review__c;
                     Wires.ID_Verification_Review__c = WiresObject.ID_Verification_Review__c;
                     Wires.Mobile_Phone_Stable_Review__c = WiresObject.Mobile_Phone_Stable_Review__c;
                     Wires.Work_Phone_Stable_Review__c = WiresObject.Work_Phone_Stable_Review__c;
                 }
        
        if(Action=='Pending for Approval'){
            Wires.Approval_Status__c = WiresConstant.ApprovalStatus_PendingForApproval;
            
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
        
        Wires.Second_Approval_Comment__c = WiresObject.Second_Approval_Comment__c;
        Wires.First_Approval_Comment__c = WiresObject.First_Approval_Comment__c;
        
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
    
    
    
    public static void ReleasedToWireXchangeEmailNotification(Set<Id> id){
        
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
        
        SendReleasedToWireXchangeEmail(id,EmailToSend);
    }
    
    
    @future(callout=true)
    public static void CheckRedFlgsAndUpdateStatus(Set<Id> id){
        
        System.debug('In CheckRedFlgsAndUpdateStatus');
        string apiURL='';
        SolarLoan_To_Episys_API_Details__c api = SolarLoan_To_Episys_API_Details__c.getValues('ProductionURL');
        
        if(api.URL__c != null){
            apiURL = api.URL__c;
        }
        
        List<WIRES_Transaction__c> wireTransactions = [SELECT Id,Name,Approval_Status__c,ToAccountName__c,ToAccoutId__c,
                                                       Status__c, FromAccount__c,TotalFromAccount__c,WireAmount__c,
                                                       ToAccoutId__r.Recipient_AccountNumber__c,SendOn__c,Source__c,
                                                       ToAccoutId__r.BankName__c,ToAccoutId__r.RoutingNumber__c,
                                                       AccountStableReview__c,EmailStableReview__c,Member_Name__c,
                                                       Identity_Verification_Used__c,Home_Phone_Stable_Review__c,
                                                       Mobile_Phone_Stable_Review__c,Work_Phone_Stable_Review__c,
                                                       FlagAccountOpenfor45Days__c,FlagEmailStablefor30Days__c,
                                                       FlagHomePhoneStablefor30Days__c,FlagMobilePhoneStablefor30Days__c,
                                                       FlagWorkPhoneStablefor30Days__c,Share_ID__c
                                                       FROM WIRES_Transaction__c WHERE id=:id];
        
        List<WIRES_Transaction__c> wiresToUpdate=new List<WIRES_Transaction__c>();
        
        List<Case> fraudCases=new List<Case>();
        for(WIRES_Transaction__c wt:wireTransactions){
            
            if(wt.TotalFromAccount__c>250000){
                
                System.debug('In Greater than 25k');
                wt.Approval_Status__c=WiresConstant.ApprovalStatus_FraudReview;
                
                List<Account_Details__c> listAccountDetails = [select id,Brand__c,ID1__c,OPEN_DATE__c from Account_Details__c where Name =: wt.FromAccount__c and RecType__c='ACCT' LIMIT 1];
                Case case1 =new Case();
                case1.Subject='WIRES Fraud Review';
                case1.Primary_Category__c='Account Maintenance';
                case1.Secondary_Category__c='Special Situations';
                case1.Tertiary_Category__c='Potential Fraud';
                case1.Description= 'Wire Name: '+wt.Name+'\n'
                    +'Wire Amount: '+wt.WireAmount__c+'\n'
                    +'Send On date: '+String.valueof(wt.SendOn__c).removeEnd(' 00:00:00')+'\n'
                    +'Source: '+wt.Source__c+'\n'
                    +'Recipient Bank Name: '+wt.ToAccoutId__r.BankName__c+'\n'
                    +'Recipient Bank ABA Number: '+wt.ToAccoutId__r.RoutingNumber__c+'\n'
                    +'ID Verification Used: '+wt.Identity_Verification_Used__c+'\n'
                    +'Approval Status: '+wt.Approval_Status__c+'\n'
                    +'Member Name: '+wt.Member_Name__c;
                
                    if(listAccountDetails.size()>0){
                        case1.Account_Number__c=listAccountDetails[0].Id;
                    }
                insert case1;
                System.debug('Case1 Id:'+case1.Id);
                wt.Case__c=case1.Id;
                
                wiresToUpdate.add(wt);
            }else{
                System.debug('In less than 25k');
                integer statusCode=0;
                Object statusMsg='';
                boolean isGoodFundCheck=false;
                Map<String,Object> results = new Map<String,Object>();
                if(wt.TotalFromAccount__c>10000){
                    Map<String,Object> checkWiresFundsResult=checkWiresFunds(wt.FromAccount__c, wt.Share_ID__c,wt.TotalFromAccount__c);
                    if(checkWiresFundsResult.size() > 0){
                        isGoodFundCheck=true;
                        
                        Object statusMsg1=checkWiresFundsResult.get('StatusMessage');
                        statusCode = integer.valueOf(checkWiresFundsResult.get('StatusCode'));
                        
                        if(statusCode<=0){
                            wt.Good_Funds_Check__c='FAIL---'+statusMsg1.toString();
                        }else{
                            wt.Good_Funds_Check__c='PASS---'+statusMsg1.toString();
                        }    
                        
                        wt.BalanceStatusCode__c=String.valueOf(statusCode);
                        wt.BalanceRGLines__c=String.valueOf(statusMsg1);
                    }
                }
                
                if(wt.FlagAccountOpenfor45Days__c && wt.FlagEmailStablefor30Days__c
                   && wt.FlagHomePhoneStablefor30Days__c && wt.FlagMobilePhoneStablefor30Days__c
                   && wt.FlagWorkPhoneStablefor30Days__c){
                       
                       if(isGoodFundCheck==true && statusCode<=0){
                           wt.Approval_Status__c = WiresConstant.ApprovalStatus_GoodFundsReview;
                           wt.Good_Funds_Check__c='FAIL---'+statusMsg.toString();
                           wiresToUpdate.add(wt);
                       }else if(isGoodFundCheck==true && statusCode>0 && wt.TotalFromAccount__c>250000 ){
                           wt.Approval_Status__c = WiresConstant.ApprovalStatus_PendingForApproval;
                           wt.Good_Funds_Check__c='PASS---'+statusMsg.toString();
                           wiresToUpdate.add(wt);
                       }
                       else{
                           wt.Approval_Status__c = WiresConstant.ApprovalStatus_Approved;
                           wt.Approved_by_1st_Approver__c = UserInfo.getUserId();
                           wiresToUpdate.add(wt);
                       }
                   }else{
                       wt.Approval_Status__c=WiresConstant.ApprovalStatus_FraudReview;
                       wiresToUpdate.add(wt);
                   }
            }
        }
        
        if(wiresToUpdate.size()>0){
            update wiresToUpdate;
        }
    }
    
    @future(callout=true)
    public static void CheckGoodFundAndUpdateStatus(Set<Id> id){
        System.debug('THIS Id:'+Id);
        
        integer statusCode=0;
        string statusMessage='';
        
        boolean isGoodFundCheck=false;
        
        List<WIRES_Transaction__c> wireTransactions = [SELECT Id,Approval_Status__c,ToAccountName__c,ToAccoutId__c,First_Reviewer__c,Name,
                                                       Status__c, FromAccount__c,TotalFromAccount__c,WireAmount__c,
                                                       ToAccoutId__r.Recipient_AccountNumber__c,
                                                       ToAccoutId__r.BankName__c,AccountStableReview__c,
                                                       EmailStableReview__c,Home_Phone_Stable_Review__c,
                                                       Mobile_Phone_Stable_Review__c,Work_Phone_Stable_Review__c,
                                                       FlagAccountOpenfor45Days__c,FlagEmailStablefor30Days__c,
                                                       FlagHomePhoneStablefor30Days__c,FlagMobilePhoneStablefor30Days__c,
                                                       FlagWorkPhoneStablefor30Days__c,Share_ID__c,Source__c,Has_Additional_Documents__c
                                                       FROM WIRES_Transaction__c WHERE id=:id];
        
        List<WIRES_Transaction__c> wiresToUpdate=new List<WIRES_Transaction__c>();
        
        for(WIRES_Transaction__c wt:wireTransactions){
            Map<String,Object> checkWiresFundsResult=checkWiresFunds(wt.FromAccount__c, wt.Share_ID__c,wt.TotalFromAccount__c);
            if(checkWiresFundsResult.size() > 0){
                isGoodFundCheck=true;
                
                Object statusMsg=checkWiresFundsResult.get('StatusMessage');
                statusCode = integer.valueOf(checkWiresFundsResult.get('StatusCode'));
                
                if(statusCode<=0){
                    wt.Good_Funds_Check__c='FAIL---'+statusMsg.toString();
                }else{
                    wt.Good_Funds_Check__c='PASS---'+statusMsg.toString();
                }    
                
                wt.BalanceStatusCode__c=String.valueOf(statusCode);
                wt.BalanceRGLines__c=String.valueOf(statusMsg);
            }
            
            if(isGoodFundCheck==true && (statusCode<=0 || statusCode==null)){
                wt.Approval_Status__c = WiresConstant.ApprovalStatus_GoodFundsReview;
                wt.Current_Reviewer_Modified_Date__c=DateTime.now();
                wt.Current_Reviewer__c=wt.First_Reviewer__c;
                wiresToUpdate.add(wt);
                
                List<User> users=[Select Id,Name,Email From User Where Id=:wt.First_Reviewer__c];
                List<string> emails=new List<string>();
                if(users.size()>0){
                    emails.add(users[0].Email);
                }
                WiresEmailController.SendApprovalNotification(wt.Id,emails,wt.Name,wt.TotalFromAccount__c,wt.Source__c,wt.Has_Additional_Documents__c);
            }else if(isGoodFundCheck==true && statusCode>0){
                wt.Approval_Status__c = WiresConstant.ApprovalStatus_PendingForApproval;
                wt.Current_Reviewer_Modified_Date__c=DateTime.now();
                wt.Current_Reviewer__c=wt.First_Reviewer__c;
                wiresToUpdate.add(wt);
                
                List<User> users=[Select Id,Name,Email From User Where Id=:wt.First_Reviewer__c];
                List<string> emails=new List<string>();
                if(users.size()>0){
                    emails.add(users[0].Email);
                }
                WiresEmailController.SendApprovalNotification(wt.Id,emails,wt.Name,wt.TotalFromAccount__c,wt.Source__c,wt.Has_Additional_Documents__c);
            }
            
        }
        
        if(wiresToUpdate.size()>0){
            update wiresToUpdate;
        }
    }
    
    @AuraEnabled
    public static void SendToFraud(Id id){
        WIRES_Transaction__c wireTransaction = [SELECT id,Approval_Status__c                                
                                                FROM WIRES_Transaction__c WHERE id=:id limit 1];
        wireTransaction.Approval_Status__c=WiresConstant.ApprovalStatus_FraudReview;
        update wireTransaction;
    }
    
    @AuraEnabled
    public static void SendToGoodFundCheckFailed(Id id){
        WIRES_Transaction__c wireTransaction = [SELECT id,Approval_Status__c                                
                                                FROM WIRES_Transaction__c WHERE id=:id limit 1];
        wireTransaction.Approval_Status__c=WiresConstant.ApprovalStatus_GoodFundsReview;
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
            string templatenAME;
            
            if(accDetail.Brand__c=='Spectrum'){
                templatenAME='Wires Progress Email Spctrum';
            }
            if(accDetail.Brand__c=='Chevron'){
                templatenAME='Wires Progress Email Chevron';
            }
            
            List<EmailTemplate> listEmailTemplate =  [select Id,Name,Body,Subject,HtmlValue from EmailTemplate where Name =: templatenAME];
            mail.setSubject(listEmailTemplate[0].Subject);
            
            
            string emailadd;
            
            emailadd = 'noreply@chevronfcu.org';
            
            
            List<OrgWideEmailAddress> listAdd = [select Id,Address,DisplayName  from OrgWideEmailAddress where Address =: emailadd];
            
            if(!Test.isRunningTest()){            
                string body = listEmailTemplate[0].HtmlValue;
                body=body.replace('{Name}', paPrimary.PersonID__r.Name);
                body=body.replace('{BankName__c}', wt.ToAccoutId__r.BankName__c);
                body=body.replace('{TotalFromAccount__c}',string.valueOf(wt.TotalFromAccount__c));
                
                mail.setHtmlBody(body);
                mail.setOrgWideEmailAddressId(listAdd[0].Id);
                mails.add(mail);
            }
        }
        
        
        Messaging.sendEmail(mails);
        
    }
    
    // --------------------- Send Email Notification..................//  
    
    
    // --------------------- Send Released to WireXchange Email Notification..................//   
    private static void SendReleasedToWireXchangeEmail(Set<Id> id,string ToEmail)
    {
        List<WIRES_Transaction__c> wireTransactions = [SELECT id,Approval_Status__c,ToAccountName__c,ToAccoutId__c,
                                                       Status__c, FromAccount__c,TotalFromAccount__c,WireAmount__c,
                                                       ToAccoutId__r.Recipient_AccountNumber__c,
                                                       ToAccoutId__r.BankName__c
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
            string templatenAME;
            
            if(accDetail.Brand__c=='Spectrum'){
                templatenAME='Wires Transfer Release Alert Spectrum';
            }
            
            if(accDetail.Brand__c=='Chevron'){
                templatenAME='Wires Transfer Release Alert Chevron';
            }
            
            List<EmailTemplate> listEmailTemplate =  [select Id,Name,Body,Subject,HtmlValue 
                                                      from EmailTemplate where Name =: templatenAME];
            
            mail.setSubject(listEmailTemplate[0].Subject);
            
            
            string emailadd;
            
            emailadd = 'noreply@chevronfcu.org';
            
            
            List<OrgWideEmailAddress> listAdd = [select Id,Address,DisplayName  
                                                 from OrgWideEmailAddress where Address =: emailadd];
            
            if(!Test.isRunningTest()){            
                string body = listEmailTemplate[0].HtmlValue;
                body=body.replace('{Name}', paPrimary.PersonID__r.Name);
                body=body.replace('{BankName__c}', wt.ToAccoutId__r.BankName__c);
                body=body.replace('{TotalFromAccount__c}',string.valueOf(wt.TotalFromAccount__c));
                
                mail.setHtmlBody(body);
                mail.setOrgWideEmailAddressId(listAdd[0].Id);
                mails.add(mail);
            }
        }
        
        
        Messaging.sendEmail(mails);
        
    }
    
    // --------------------- Send Released to WireXchange Email Notification..................//   
    
    
    
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
        string apiURL='';
        SolarLoan_To_Episys_API_Details__c api = SolarLoan_To_Episys_API_Details__c.getValues('ProductionURL');
        
        if(api.URL__c != null){
            apiURL = api.URL__c;
        }
        
        Map<String,Object> results = new Map<String,Object>();
        httpRequest requestparam = new httpRequest(); 
        system.debug('amount=='+amount);
        requestparam.setEndpoint(apiURL+'/Wires/WiresFundsCheck?amount=' + amount +'&accountNumber=' + AccountNumber + '&shareId=' + ShareID);
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