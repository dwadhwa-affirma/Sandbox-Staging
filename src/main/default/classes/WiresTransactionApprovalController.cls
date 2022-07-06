public class WiresTransactionApprovalController {
    
    @AuraEnabled
    public static  Map<string,object> getWiresData(string WiresRecordId){
        
        decimal minGoodFundAmountCheck=0;        
        Wires_Good_Fund_Limit__c goodFundLimit = Wires_Good_Fund_Limit__c.getValues('Min');
        
        if(goodFundLimit.Amount__c!=null){
            minGoodFundAmountCheck=goodFundLimit.Amount__c;
        }
        
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
                                          First_Approval_Comment__c,Second_Approval_Comment__c, Docusign_Review__c, Docusign_IDV_Failure__c, Frequency__c
                                          FROM WIRES_Transaction__c WHERE Id=:WiresRecordId limit 1];
        
        string isApprovalVisible='false';
        
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
        System.debug('Source'+WiresList.Source__c);
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
                   
                   if(WiresList.WireAmount__c>0 && WiresList.WireAmount__c<=25000){
                       
                       if(grpAmembers.size()>0 || grpBmembers.size()>0 || grpCmembers.size()>0 || grpDmembers.size()>0 || grpEmembers.size()>0){
                           isApprovalVisible = 'true';
                       }else{
                           isApprovalVisible = 'false';
                       }   
                   }
                   
                   if(WiresList.WireAmount__c>25000 && WiresList.WireAmount__c<=100000){
                       
                       if(grpBmembers.size()>0 || grpCmembers.size()>0 || grpDmembers.size()>0 || grpEmembers.size()>0){
                           isApprovalVisible = 'true';
                       }else{
                           isApprovalVisible = 'false';
                       }   
                   }
                   
                   if(WiresList.WireAmount__c>100000 && WiresList.WireAmount__c<=250000){
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
                   
                   if(WiresList.WireAmount__c>250000 && WiresList.WireAmount__c<=1000000){
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
                   
                   if(WiresList.WireAmount__c>1000000){
                       
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
                   
                   if(WiresList.WireAmount__c>0 && WiresList.WireAmount__c<=10000){
                       isApprovalVisible = 'true';
                   }
                   
                   if(WiresList.WireAmount__c>10000 && WiresList.WireAmount__c<=50000){
                       if(grpAmembers.size()>0 || grpBmembers.size()>0 || grpCmembers.size()>0 
                          || grpDmembers.size()>0){
                              isApprovalVisible = 'true';
                          }else{
                              isApprovalVisible = 'false';
                          }
                   }
                   
                   if(WiresList.WireAmount__c>50000 && WiresList.WireAmount__c<=100000){
                       if(grpBmembers.size()>0 || grpCmembers.size()>0 || grpDmembers.size()>0){
                           isApprovalVisible = 'true';
                       }else{
                           isApprovalVisible = 'false';
                       }
                   }
                   
                   if(WiresList.WireAmount__c>100000 && WiresList.WireAmount__c<=250000){
                       if(grpCmembers.size()>0 || grpDmembers.size()>0 || grpEmembers.size()>0){
                           isApprovalVisible = 'true';
                       }else{
                           isApprovalVisible = 'false';
                       }
                   }
                   
                   if(WiresList.WireAmount__c>250000 && WiresList.WireAmount__c<=500000){
                       if(grpCmembers.size()>0 || grpDmembers.size()>0 || grpEmembers.size()>0){
                           isApprovalVisible = 'true';
                       }else{
                           isApprovalVisible = 'false';
                       }
                   }
                   
                   if(WiresList.WireAmount__c>500000 && WiresList.WireAmount__c<=1500000){
                       if(grpDmembers.size()>0 || grpEmembers.size()>0){
                           isApprovalVisible = 'true';
                       }else{
                           isApprovalVisible = 'false';
                       }
                   }
                   
                   if(WiresList.WireAmount__c>1500000){
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
        strMap.put('MinGoodFundAmountCheck',minGoodFundAmountCheck);
        
        
        
        string goodFundStatus= WiresList.Good_Funds_Check__c!=null ? WiresList.Good_Funds_Check__c.Split('\\---')[0]:'';
        
        System.debug('Status of goodfund:'+goodFundStatus);
        if((WiresList.Approval_Status__c==WiresConstant.ApprovalStatus_PendingForApproval 
            || WiresList.Approval_Status__c==WiresConstant.ApprovalStatus_PendingForSecondApproval
            || WiresList.Approval_Status__c==WiresConstant.ApprovalStatus_GoodFundsReview) 
           && (goodFundStatus=='' || goodFundStatus!='PASS')) {    
               
               Map<String,Object> checkWiresFundsResult=checkWiresFunds(WiresList.FromAccount__c, WiresList.Share_ID__c,WiresList.WireAmount__c);
               
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
    public static void ChangeOwner(string wiresId){
        WIRES_Transaction__c Wires = [SELECT id,Approval_Status__c, FromAccount__c,
                                      Share_ID__c,Source__c,TotalFromAccount__c,
                                      WireAmount__c, Description__c, 
                                      IsAccountOpenfor45Days__c, Member_Name__c,OwnerId
                                      From WIRES_Transaction__c where Id=:wiresId 
                                      Limit 1];
        
        Wires.OwnerId = UserInfo.getUserId();
        update Wires;
    }
    
    @AuraEnabled
    public static void CancelTransaction(string WiresRecordId, string Reason){
        
        WIRES_Transaction__c Wires = [SELECT id,Approval_Status__c, FromAccount__c,Share_ID__c,Source__c,TotalFromAccount__c,
                                      WireAmount__c, Description__c, IsAccountOpenfor45Days__c, Member_Name__c, 
                                      Identity_Verification_Used__c, IsEmailStable__c, IsHomePhoneStable__c, IsMobilePhoneStable__c, IsWorkPhoneStable__c,                                          
                                      AccountStableReview__c,Available_Balance_Review__c, EmailStableReview__c,Review_Reason__c,
                                      Home_Phone_Stable_Review__c,ID_Verification_Review__c, Mobile_Phone_Stable_Review__c, 
                                      Previous_Wires_Review__c, Work_Phone_Stable_Review__c, FlagAccountOpenfor45Days__c,member__c, member__r.personemail,
                                      FlagEmailStablefor30Days__c, FlagHomePhoneStablefor30Days__c, FlagMobilePhoneStablefor30Days__c, FlagWorkPhoneStablefor30Days__c 
                                      from WIRES_Transaction__c where id=:WiresRecordId limit 1];
        
        Wires.Approval_Status__c = WiresConstant.ApprovalStatus_Cancelled;
        Wires.Cancel_Reason__c = Reason;
        Wires.Cancelled_By__c=UserInfo.getUserId();
        Wires.Cancelled_On__c=DateTime.now();
        
        List<Group> listQueue = [select id,Name,Email, developername from Group where Type = 'Queue' and developername = 'Wires_Online_Operations' limit 1];       
        
        if(listQueue.size() > 0){
                Wires.ownerId = listQueue[0].Id;
         }
                
        update Wires;
        
        set<id> wiresId=new Set<id>();
        wiresId.add(Wires.Id);
        if(Wires.member__c != null && Wires.member__r.personemail != null){
            WiresEmailController.SendBranchWireCancelledOrRejectEmailNotification(wiresId,true);
        }
        
    }
    
    @AuraEnabled
public static boolean ApproveTransaction(string WiresRecordId, string Action, string wiresdetails){

    System.debug('Call function ApproveTransaction');
    Boolean isAlreadyApproved = false;
    
    WIRES_Transaction__c WiresObject = (WIRES_Transaction__c)JSON.deserialize(wiresdetails, WIRES_Transaction__c.class);

    WIRES_Transaction__c Wires = [SELECT id, Approval_Status__c, FromAccount__c, Share_ID__c, Source__c, TotalFromAccount__c, WireAmount__c, Description__c, IsAccountOpenfor45Days__c, Member_Name__c, Identity_Verification_Used__c, IsEmailStable__c, IsHomePhoneStable__c, IsMobilePhoneStable__c, IsWorkPhoneStable__c, AccountStableReview__c, Available_Balance_Review__c, EmailStableReview__c, Review_Reason__c, Home_Phone_Stable_Review__c, ID_Verification_Review__c, Mobile_Phone_Stable_Review__c, Previous_Wires_Review__c, Work_Phone_Stable_Review__c, FlagAccountOpenfor45Days__c, FlagEmailStablefor30Days__c, FlagHomePhoneStablefor30Days__c, FlagMobilePhoneStablefor30Days__c, FlagWorkPhoneStablefor30Days__c, Docusign_Review__c, First_Approval_Comment__c, Second_Approval_Comment__c, Approved_by_1st_Approver__c
                                  from WIRES_Transaction__c
                                  where id = :WiresRecordId
                                  limit 1 FOR UPDATE];

    if (Action == 'Reject'){
        Wires.Approval_Status__c = WiresConstant.ApprovalStatus_Rejected;
        Wires.Rejected_By__c = UserInfo.getUserId();
        Wires.Rejected_On__c = DateTime.now();
        Wires.First_Approval_Comment__c = WiresObject.First_Approval_Comment__c;
    }

    if (Action == 'Good Funds Review'){
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
        Wires.Docusign_Review__c = WiresObject.Docusign_Review__c;


        if (WiresObject.Approval_Status__c == WiresConstant.ApprovalStatus_FraudReview){
            Wires.Fraud_Approver__c = UserInfo.getUserId();
        }
    } 
    
    else if ((Wires.Approval_Status__c == WiresConstant.ApprovalStatus_PendingForApproval || Wires.Approval_Status__c == WiresConstant.ApprovalStatus_PendingForSecondApproval || Wires.Approval_Status__c == WiresConstant.ApprovalStatus_FraudReview || Wires.Approval_Status__c == WiresConstant.ApprovalStatus_GoodFundsReview)){

        if (Wires.Source__c == WiresConstant.Source_Branch){
            system.debug('Wires.Approval_Status__c'+Wires.Approval_Status__c);
            system.debug('Wires.Approved_by_1st_Approver__c'+Wires.Approved_by_1st_Approver__c);
            if(Wires.Approval_Status__c == WiresConstant.ApprovalStatus_PendingForSecondApproval && Wires.Approved_by_1st_Approver__c != null){
                
                isAlreadyApproved = true;
                return isAlreadyApproved;
            }

            if (Wires.WireAmount__c > 100000 && Wires.Approval_Status__c != WiresConstant.ApprovalStatus_PendingForSecondApproval){

                Wires.Approval_Status__c = WiresConstant.ApprovalStatus_PendingForSecondApproval;

                if (WiresObject.Approval_Status__c == WiresConstant.ApprovalStatus_FraudReview){
                    Wires.Fraud_Approver__c = UserInfo.getUserId();
                }

                Wires.Approved_by_1st_Approver__c = UserInfo.getUserId();
                Wires.Available_Balance_Review__c = WiresObject.Available_Balance_Review__c;
                Wires.Previous_Wires_Review__c = WiresObject.Previous_Wires_Review__c;
            } 
            else{
                Wires.Available_Balance2_Review__c = WiresObject.Available_Balance_Review__c;
                Wires.Previous_Wires2_Review__c = WiresObject.Previous_Wires_Review__c;
                Wires.ApprovedDate__c = System.now();

                if (Wires.WireAmount__c > 100000 && Wires.Approval_Status__c == WiresConstant.ApprovalStatus_PendingForSecondApproval){
                   // Wires.Approved_by_2nd_Approver__c = UserInfo.getUserId();
                } 
                else{

                    if (WiresObject.Approval_Status__c == WiresConstant.ApprovalStatus_FraudReview){
                        Wires.Fraud_Approver__c = UserInfo.getUserId();
                    }

                    Wires.Approved_by_1st_Approver__c = UserInfo.getUserId();
                }

                Wires.Approval_Status__c = WiresConstant.ApprovalStatus_Approved;
            }
        } else{
            Wires.Approval_Status__c = WiresConstant.ApprovalStatus_Approved;
            Wires.Available_Balance_Review__c = WiresObject.Available_Balance_Review__c;
            Wires.Previous_Wires_Review__c = WiresObject.Previous_Wires_Review__c;

            if (WiresObject.Approval_Status__c == WiresConstant.ApprovalStatus_FraudReview){
                Wires.Fraud_Approver__c = UserInfo.getUserId();
            } else{
                wires.Approved_by_1st_Approver__c = UserInfo.getUserId();
                wires.ApprovedDate__c = System.now();
            }

        }

        Wires.AccountStableReview__c = WiresObject.AccountStableReview__c;
        Wires.Review_Reason__c = WiresObject.Review_Reason__c;
        Wires.EmailStableReview__c = WiresObject.EmailStableReview__c;
        Wires.Home_Phone_Stable_Review__c = WiresObject.Home_Phone_Stable_Review__c;
        Wires.ID_Verification_Review__c = WiresObject.ID_Verification_Review__c;
        Wires.Mobile_Phone_Stable_Review__c = WiresObject.Mobile_Phone_Stable_Review__c;
        Wires.Work_Phone_Stable_Review__c = WiresObject.Work_Phone_Stable_Review__c;
        Wires.Docusign_Review__c = WiresObject.Docusign_Review__c;
    }

    if (Action == 'Pending for Approval'){
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
        Wires.Docusign_Review__c = WiresObject.Docusign_Review__c;
    }

    Wires.Second_Approval_Comment__c = WiresObject.Second_Approval_Comment__c;
    Wires.First_Approval_Comment__c = WiresObject.First_Approval_Comment__c;

    update Wires;

    return isAlreadyApproved;
}

@AuraEnabled
public static boolean ApproveTransactionSecondApproval(string WiresRecordId, string Action, string wiresdetails){

    System.debug('Call function ApproveTransaction Second Approval');
    Boolean isAlreadyApproved = false;
    WIRES_Transaction__c WiresObject = (WIRES_Transaction__c)JSON.deserialize(wiresdetails, WIRES_Transaction__c.class);

    WIRES_Transaction__c Wires = [SELECT id, Approval_Status__c, FromAccount__c, Share_ID__c, Source__c, TotalFromAccount__c, WireAmount__c, Description__c, IsAccountOpenfor45Days__c, Member_Name__c, Identity_Verification_Used__c, IsEmailStable__c, IsHomePhoneStable__c, IsMobilePhoneStable__c, IsWorkPhoneStable__c, AccountStableReview__c, Available_Balance_Review__c, EmailStableReview__c, Review_Reason__c, Home_Phone_Stable_Review__c, ID_Verification_Review__c, Mobile_Phone_Stable_Review__c, Previous_Wires_Review__c, Work_Phone_Stable_Review__c, FlagAccountOpenfor45Days__c, FlagEmailStablefor30Days__c, FlagHomePhoneStablefor30Days__c, FlagMobilePhoneStablefor30Days__c, FlagWorkPhoneStablefor30Days__c, Docusign_Review__c, First_Approval_Comment__c, Second_Approval_Comment__c, Approved_by_2nd_Approver__c
                                  from WIRES_Transaction__c
                                  where id = :WiresRecordId
                                  limit 1 FOR UPDATE]; 

        
    if ((Wires.Approval_Status__c == WiresConstant.ApprovalStatus_PendingForSecondApproval)){

        if (Wires.Source__c == WiresConstant.Source_Branch){

            if(Wires.Approval_Status__c == WiresConstant.ApprovalStatus_Approved && Wires.Approved_by_2nd_Approver__c != null){
                isAlreadyApproved = true;
                return isAlreadyApproved;
            }

             
            else{
                Wires.Available_Balance2_Review__c = WiresObject.Available_Balance_Review__c;
                Wires.Previous_Wires2_Review__c = WiresObject.Previous_Wires_Review__c;
                Wires.ApprovedDate__c = System.now();

                if (Wires.WireAmount__c > 100000 && Wires.Approval_Status__c == WiresConstant.ApprovalStatus_PendingForSecondApproval){
                    Wires.Approved_by_2nd_Approver__c = UserInfo.getUserId();
                }                 

                Wires.Approval_Status__c = WiresConstant.ApprovalStatus_Approved;
            }
        } else{
            Wires.Approval_Status__c = WiresConstant.ApprovalStatus_Approved;
            Wires.Available_Balance_Review__c = WiresObject.Available_Balance_Review__c;
            Wires.Previous_Wires_Review__c = WiresObject.Previous_Wires_Review__c;

            if (WiresObject.Approval_Status__c == WiresConstant.ApprovalStatus_FraudReview){
                Wires.Fraud_Approver__c = UserInfo.getUserId();
            } else{
                wires.Approved_by_1st_Approver__c = UserInfo.getUserId();
                wires.ApprovedDate__c = System.now();
            }

        }

        Wires.AccountStableReview__c = WiresObject.AccountStableReview__c;
        Wires.Review_Reason__c = WiresObject.Review_Reason__c;
        Wires.EmailStableReview__c = WiresObject.EmailStableReview__c;
        Wires.Home_Phone_Stable_Review__c = WiresObject.Home_Phone_Stable_Review__c;
        Wires.ID_Verification_Review__c = WiresObject.ID_Verification_Review__c;
        Wires.Mobile_Phone_Stable_Review__c = WiresObject.Mobile_Phone_Stable_Review__c;
        Wires.Work_Phone_Stable_Review__c = WiresObject.Work_Phone_Stable_Review__c;
        Wires.Docusign_Review__c = WiresObject.Docusign_Review__c;
    }
    
    Wires.Second_Approval_Comment__c = WiresObject.Second_Approval_Comment__c;
    Wires.First_Approval_Comment__c = WiresObject.First_Approval_Comment__c;

    update Wires;

    return isAlreadyApproved;
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
        
        List<WIRES_Transaction__c> WiresTrans = [SELECT Id,Member_Email__c, Member__c,Member__r.PersonEmail
                                                 FROM WIRES_Transaction__c WHERE id =: id LIMIT 1];
        
        if(EmailToSend == 'Production' || EmailToSend == 'production'){
            EmailToSend = WiresTrans[0].Member__r.PersonEmail;     
        } else {
          EmailToSend = userEmail;
        }
        
        if(!String.isBlank(EmailToSend)) {
          SendEmail(id,EmailToSend);
        }
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
        
        List<WIRES_Transaction__c> WiresTrans = [SELECT Id,Member_Email__c, Member__c,Member__r.PersonEmail
                                                 FROM WIRES_Transaction__c WHERE id =: id LIMIT 1];
        
        if(EmailToSend == 'Production' || EmailToSend == 'production'){
            EmailToSend = WiresTrans[0].Member__r.PersonEmail;     
        }
        
        else if(EmailToSend != 'Production'){
            EmailToSend = userEmail;
        }
        
        if(!String.isBlank(EmailToSend)) {
          SendReleasedToWireXchangeEmail(id,EmailToSend);
        }

    }
    
    
    public static void SetIdentityVerificationUsed(Set<Id> id){
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
        
        for(WIRES_Transaction__c wt:wireTransactions){  
            if(wt.WireAmount__c>50000){
                wt.Identity_Verification_Used__c='Docusign ID Verification';
                wiresToUpdate.add(wt);
            }
        }
        
        update wiresToUpdate;
    }
    
    public static void SetWiresStatusToDSDeclined(Set<Id> id){
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
        
        List<Group> listQueue = [select id,Name,Email, developername from Group where Type = 'Queue' and developername = 'Wires_Online_Operations' limit 1];
        
        for(WIRES_Transaction__c wt:wireTransactions){  
                wt.Approval_Status__c=WiresConstant.ApprovalStatus_DSDeclined;
            if(listQueue.size() > 0){
                wt.ownerId = listQueue[0].Id;
            }
                wiresToUpdate.add(wt);
        }
        
        update wiresToUpdate;
    }
    
    @future(callout=true)
    public static void CheckRedFlgsAndUpdateStatus(Set<Id> id){

		decimal minGoodFundAmountCheck=0;        
        Wires_Good_Fund_Limit__c goodFundLimit = Wires_Good_Fund_Limit__c.getValues('Min');
        
        if(goodFundLimit.Amount__c!=null){
            minGoodFundAmountCheck=goodFundLimit.Amount__c;
        }
        
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
                                                       FlagWorkPhoneStablefor30Days__c,Share_ID__c, Docusign_IDV_Failure__c
                                                       FROM WIRES_Transaction__c WHERE id=:id];
        
        List<WIRES_Transaction__c> wiresToUpdate=new List<WIRES_Transaction__c>();
        
        List<Case> fraudCases=new List<Case>();
        for(WIRES_Transaction__c wt:wireTransactions){
            
            if(wt.WireAmount__c>250000){
                String bankName;
                if(wt.ToAccoutId__r!=null) {
                  if(String.isNotBlank(wt.ToAccoutId__r.BankName__c)) {
                    bankName = wt.ToAccoutId__r.BankName__c;
                  }
                }

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
                    +'Send On Date: '+String.valueof(wt.SendOn__c).removeEnd(' 00:00:00')+'\n'
                    +'Source: '+wt.Source__c+'\n'
                    +'Recipient Bank Name: '+ bankName +'\n'
                    +'Recipient Bank ABA Number: '+wt.ToAccoutId__r.RoutingNumber__c+'\n'
                    +'ID Verification Used: '+wt.Identity_Verification_Used__c+'\n'
                    +'Approval Status: '+wt.Approval_Status__c+'\n'
                    +'Member Name: '+wt.Member_Name__c;
                
                if(listAccountDetails.size()>0){
                    case1.Account_Number__c=listAccountDetails[0].Id;
                }
                //insert case1;
                //wt.Case__c=case1.Id;
                
                wiresToUpdate.add(wt);
            }else{
                System.debug('In less than 25k');
                integer statusCode=0;
                Object statusMsg='';
                boolean isGoodFundCheck=false;
                Map<String,Object> results = new Map<String,Object>();
                if(wt.WireAmount__c>minGoodFundAmountCheck){
                    Map<String,Object> checkWiresFundsResult=checkWiresFunds(wt.FromAccount__c, wt.Share_ID__c,wt.WireAmount__c);
                    if(checkWiresFundsResult.size() > 0){
                        isGoodFundCheck=true;
                        System.debug('checkWiresFundsResult');
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
                   && wt.FlagWorkPhoneStablefor30Days__c && !wt.Docusign_IDV_Failure__c){
                        System.debug('isGoodFundCheck');
                       if(isGoodFundCheck==true && statusCode<=0){
                           System.debug('isGoodFundCheck==true');
                           wt.Approval_Status__c = WiresConstant.ApprovalStatus_PendingForApproval;
                           wt.Good_Funds_Check__c='FAIL---'+statusMsg.toString();
                           wiresToUpdate.add(wt);
                       }else if(isGoodFundCheck==true && statusCode>0 && wt.WireAmount__c>250000 ){
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
            Map<String,Object> checkWiresFundsResult=checkWiresFunds(wt.FromAccount__c, wt.Share_ID__c,wt.WireAmount__c);
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
                wt.Approval_Status__c = WiresConstant.ApprovalStatus_PendingForApproval;
                wt.Current_Reviewer_Modified_Date__c=DateTime.now();
                wt.Current_Reviewer__c=wt.First_Reviewer__c;
                wiresToUpdate.add(wt);
                
                List<User> users=[Select Id,Name,Email From User Where Id=:wt.First_Reviewer__c];
                List<string> emails=new List<string>();
                if(users.size()>0){
                    emails.add(users[0].Email);
                }
                WiresEmailController.SendApprovalNotification(wt.Id,emails,wt.Name,wt.WireAmount__c,wt.Source__c,wt.Has_Additional_Documents__c);
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
                WiresEmailController.SendApprovalNotification(wt.Id,emails,wt.Name,wt.WireAmount__c,wt.Source__c,wt.Has_Additional_Documents__c);
            }
            
        }
        
        if(wiresToUpdate.size()>0){
            update wiresToUpdate;
        }
    }
    
    @AuraEnabled
    public static void SendToFraud(Id id , string Reason){
        system.debug('Reason:'+ Reason);
        WIRES_Transaction__c wireTransaction = [SELECT id,Approval_Status__c                                
                                                FROM WIRES_Transaction__c WHERE id=:id limit 1];
        
        wireTransaction.Approval_Status__c=WiresConstant.ApprovalStatus_FraudRejected;
        wireTransaction.First_Approval_Comment__c = Reason; 
		wireTransaction.Rejected_By__c=UserInfo.getUserId();
        wireTransaction.Rejected_On__c=DateTime.now();
            
        
        update wireTransaction;
        
        set<Id> rejectedWiresIds = new set<Id>();
        rejectedWiresIds.add(id);
        WiresEmailController.SendBranchWireCancelledOrRejectEmailNotification(rejectedWiresIds,false);
    }
    
    @AuraEnabled
    public static void SendToGoodFundCheckFailed(Id id){
        WIRES_Transaction__c wireTransaction = [SELECT id,Approval_Status__c                                
                                                FROM WIRES_Transaction__c WHERE id=:id limit 1];
        wireTransaction.Approval_Status__c=WiresConstant.ApprovalStatus_PendingForApproval;
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
                                                       ToAccoutId__r.BankName__c,Source__c, FormattedTotalAmount__c, FormattedWireAmount__c
                                                       from WIRES_Transaction__c where id=:id];
        
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        
        for(WIRES_Transaction__c wt:wireTransactions){
            
            Wires_Progress_Email_Test__c testEmail=Wires_Progress_Email_Test__c.getValues('Test');
            String userEmail = testEmail.Email__c;
            
            WiresCutoffTimings__c wiresCutoffTimings;
            if(wt.Source__c==WiresConstant.Source_Branch)
            	wiresCutoffTimings=WiresCutoffTimings__c.getValues('Branch');
            else
            	wiresCutoffTimings=WiresCutoffTimings__c.getValues('Online');
            
            string cutoffTime='';
            if(wiresCutoffTimings!=null){
            	cutoffTime=getCutoffTimeIn12HourAMPMFormat(string.valueOf(wiresCutoffTimings.CutoffTime__c));
            }
            
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
            
            String personName = '', bankName = '', formattedWireAmount = '';
            if(!Test.isRunningTest()){      
              if(paPrimary.PersonID__r != null) {
                if(String.isNotBlank(paPrimary.PersonID__r.Name)) {
                  personName = paPrimary.PersonID__r.Name;
                }
              }
              if(wt.ToAccoutId__r!=null) {
                if(String.isNotBlank(wt.ToAccoutId__r.BankName__c)) {
                  bankName = wt.ToAccoutId__r.BankName__c;
                }
              }
              if(String.isNotBlank(wt.FormattedWireAmount__c)) {
                formattedWireAmount = wt.FormattedWireAmount__c;
              }
              string body = listEmailTemplate[0].HtmlValue;
              body=body.replace('{Name}',        personName);
              body=body.replace('{BankName__c}', bankName);
              body=body.replace('{TotalFromAccount__c}', formattedWireAmount);
              //body=body.replace('{TotalFromAccount__c}',string.valueOf(wt.WireAmount__c));
              body=body.replace('{cutofftime}',cutoffTime);
                
              mail.setHtmlBody(body);
              mail.setOrgWideEmailAddressId(listAdd[0].Id);
              mails.add(mail);
            }
        }
        
        if(mails.size() > 0) {
          Messaging.sendEmail(mails);
        }
        
    }
    
    // --------------------- Send Email Notification..................//  
    
    
    // --------------------- Send Released to WireXchange Email Notification..................//   
    private static void SendReleasedToWireXchangeEmail(Set<Id> id,string ToEmail)
    {
        List<WIRES_Transaction__c> wireTransactions = [SELECT id,Approval_Status__c,ToAccountName__c,ToAccoutId__c,
                                                       Status__c, FromAccount__c,TotalFromAccount__c,WireAmount__c,
                                                       ToAccoutId__r.Recipient_AccountNumber__c,ToAccoutId__r.RoutingNumber__c,
                                                       ToAccoutId__r.BankName__c, FormattedTotalAmount__c, FormattedWireAmount__c
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
                                  
            String bankName = '';
            if(!Test.isRunningTest()){            
                string body = listEmailTemplate[0].HtmlValue;
                body=body.replace('{Name}', paPrimary.PersonID__r.Name);
                if(wt.ToAccoutId__r != null){
                  if(String.isNotBlank(wt.ToAccoutId__r.BankName__c)) {
                    bankName = wt.ToAccoutId__r.BankName__c;
                  }
                  body=body.replace('{BankName__c}', bankName);
                }
                else{
                    /*String RoutingNumber = wt.ToAccoutId__r.RoutingNumber__c;
                    string BankName = '';
                    if(String.isNotBlank(RoutingNumber)){
                       	BankName = GetABADetailsWebService.GetBankName(RoutingNumber); 
                        if(BankName == 'FAIL'){
                            BankName = '';
                        }
                    }*/
                    body=body.replace('to {BankName__c}', '');
                }
                body=body.replace('{TotalFromAccount__c}',wt.FormattedWireAmount__c);//string.valueOf(wt.FormattedTotalAmount__c)
                
                mail.setHtmlBody(body);
                mail.setOrgWideEmailAddressId(listAdd[0].Id);
                mails.add(mail);
            }
        }
        
        
        Messaging.sendEmail(mails);
        
    }
    
    // --------------------- Send Released to WireXchange Email Notification..................//   
    
    
    
    // --------------------- Send SMS Notification..................//   
    
    public static void SendSMS(string phone)
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
        requestparam.setTimeout(10000);
        
        httpResponse response;
        String strStatus='';
        String strBody='';
        
        http httpParam = new http();
        if (!Test.isRunningTest()){
           response  = httpParam.send(requestparam);
            strStatus = response.getStatus();
       		strBody = response.getBody();
           }
        else {
            strBody = '{"StatusMessage": "" , "StatusCode": "0"}';
        }
        
        
        System.debug('Service response is ....' + strStatus);
        System.debug('Service response is ....' + strBody);
        
        if(strBody!=''){        
            results = (Map<String,Object>) JSON.deserializeUntyped(strBody);      
            System.debug('Service response is ....' + results);              
        }
        return results;
    }
    
    public static string getCutoffTimeIn12HourAMPMFormat(string cutofftime) {
    	    cutofftime=cutofftime.replace('.',':');
        	List<String> cutoffTimesList =cutofftime.split(':');
        	List<String> result=new List<string>();
        	if (cutoffTimesList.size() > 1) { // If time format correct
    				string param0 =string.valueOf(math.mod(integer.valueOf(cutoffTimesList[0]),12)); // Adjust hours
					result.add(param0);
                	string param1=':';
                	result.add(param1);
                    string param2=cutoffTimesList[1];
                	result.add(param2);
                	string param3=integer.valueOf(cutoffTimesList[0]) < 12 ? ' AM' : ' PM'; // Set AM/PM
                	result.add(param3);
  			}

			cutofftime= String.join(result,'');
        	return cutofftime;
    }
    
    @AuraEnabled
    public static map<string, object> GetFailedIDVDetails(string WiresId){
        map<string,object> resultMap = new map<string,object>();
        List<WIRES_Transaction__c> WireTransaction = [SELECT id,Approval_Status__c, FromAccount__c,
                                        Share_ID__c,Source__c, Member__c, 
                                        Member__r.ID_1_Type__pc, Member__r.ID_1_Type__c, 
                                        Member__r.ID_1_Number__pc, Member__r.ID_1_Issuance_Date__pc, Member__r.ID_1_Expiration_Date__pc,
                                        Member__r.ID_2_Type__pc, Member__r.ID_2_Type__c, 
                                        Member__r.ID_2_Number__pc, Member__r.ID_2_Issuance_Date__pc, Member__r.ID_2_Expiration_Date__pc,
                                        Member__r.ID_3_Type__pc, Member__r.ID_3_Type__c, 
                                        Member__r.ID_3_Number__pc, Member__r.ID_3_Issuance_Date__pc, Member__r.ID_3_Expiration_Date__pc,
                                        Member__r.Emp_Birth_Date__c , 
                                        Member__r.Residential_Street__pc, Member__r.Residential_Extra_Address__pc, Member__r.Residential_City__pc, Member__r.Residential_State__pc, Member__r.Residential_Zipocde__pc, Member__r.Residential_Country__pc,
                                        Member__r.FirstName, Member__r.MiddleName, Member__r.LastName, Member__r.BIRTH_DATE__pc          
                                        FROM WIRES_Transaction__c where Id=:WiresId 
                                        AND Source__c = 'Online Banking'
                                        Limit 1];        
       
        map<string,object> DocusignIDVFailureDetailsMap = WiresDocusignIDV.docusignIDVAPICall(WiresId);
        WiresDocusignIDV.DocusignIDVFailureWrapperObject DocusignIDVFailureDetails = (WiresDocusignIDV.DocusignIDVFailureWrapperObject)DocusignIDVFailureDetailsMap.get('DocusignIDVFailureDetails');

        resultMap.put('DocusignIDVFailureDetails',DocusignIDVFailureDetails);
        system.debug('DocusignIDVFailureDetails='+DocusignIDVFailureDetails);
        
        FraudReviewMARSDetailsWrapperObject MARSDetails = new FraudReviewMARSDetailsWrapperObject(); 
        if(WireTransaction.size() > 0 && DocusignIDVFailureDetails != null){
            string DocusignIdNumber = DocusignIDVFailureDetails.IdNumber;
            if(DocusignIdNumber == WireTransaction[0].Member__r.ID_1_Number__pc){
                MARSDetails.IdNumber = WireTransaction[0].Member__r.ID_1_Number__pc;
                MARSDetails.TypeOfId = WireTransaction[0].Member__r.ID_1_Type__c;
                MARSDetails.IssuanceDate = WireTransaction[0].Member__r.ID_1_Issuance_Date__pc;
                MARSDetails.ExpirationDate = WireTransaction[0].Member__r.ID_1_Expiration_Date__pc;
            }
            else if(DocusignIdNumber == WireTransaction[0].Member__r.ID_2_Number__pc){
                MARSDetails.IdNumber = WireTransaction[0].Member__r.ID_2_Number__pc;
                MARSDetails.TypeOfId = WireTransaction[0].Member__r.ID_2_Type__c;
                MARSDetails.IssuanceDate = WireTransaction[0].Member__r.ID_2_Issuance_Date__pc;
                MARSDetails.ExpirationDate = WireTransaction[0].Member__r.ID_2_Expiration_Date__pc;
            }
            else if(DocusignIdNumber == WireTransaction[0].Member__r.ID_3_Number__pc){
                MARSDetails.IdNumber = WireTransaction[0].Member__r.ID_3_Number__pc;
                MARSDetails.TypeOfId = WireTransaction[0].Member__r.ID_3_Type__c;
                MARSDetails.IssuanceDate = WireTransaction[0].Member__r.ID_3_Issuance_Date__pc;
                MARSDetails.ExpirationDate = WireTransaction[0].Member__r.ID_3_Expiration_Date__pc;
            }
            else{
                MARSDetails.IdNumber = '';
                MARSDetails.TypeOfId = '';
                MARSDetails.IssuanceDate = null;
                MARSDetails.ExpirationDate = null;
            }
            string extraaddress = String.isNotBlank(WireTransaction[0].Member__r.Residential_Extra_Address__pc) == true ? ' ' + WireTransaction[0].Member__r.Residential_Extra_Address__pc : '';
            string street = String.isNotBlank(WireTransaction[0].Member__r.Residential_Street__pc) == true ? WireTransaction[0].Member__r.Residential_Street__pc : '';
            string city = String.isNotBlank(WireTransaction[0].Member__r.Residential_City__pc) == true ? + ' - '+ WireTransaction[0].Member__r.Residential_City__pc : '';
            string state = String.isNotBlank(WireTransaction[0].Member__r.Residential_State__pc) == true ? ' - ' +WireTransaction[0].Member__r.Residential_State__pc : '';
            string zip = String.isNotBlank(WireTransaction[0].Member__r.Residential_Zipocde__pc) == true ? ' - ' +WireTransaction[0].Member__r.Residential_Zipocde__pc : '';
            string country = String.isNotBlank(WireTransaction[0].Member__r.Residential_Country__pc) == true ? ' - ' + WireTransaction[0].Member__r.Residential_Country__pc : '';
            string ResidentialAddress = street + extraaddress + city + state + zip + country;
            MARSDetails.DateOfBirth = WireTransaction[0].Member__r.BIRTH_DATE__pc;
            MARSDetails.ResidentialAddress = ResidentialAddress;
            MARSDetails.FirstNames = WireTransaction[0].Member__r.FirstName;
            MARSDetails.MiddleNames = WireTransaction[0].Member__r.MiddleName;
            MARSDetails.LastNames = WireTransaction[0].Member__r.LastName;
        }
    
        resultMap.put('MARSDetails',MARSDetails);

        return resultMap;
    }
    
    
    @AuraEnabled
    public static map<string,Object> GetPastWires(string WiresId){
        List<WIRES_Transaction__c> PastWireTransactions = new List<WIRES_Transaction__c>();
        map<string,Object> resultPastWiresMap = new map<string,Object>();
        List<WIRES_Transaction__c> WireTransaction = [SELECT id,Approval_Status__c, FromAccount__c,
                                        Share_ID__c,Source__c, Member__c, Frequency__c,
                                        Member__r.ID_1_Type__pc, Member__r.ID_1_Type__c, 
                                        Member__r.ID_1_Number__pc, Member__r.ID_1_Issuance_Date__pc, Member__r.ID_1_Expiration_Date__pc,
                                        Member__r.ID_2_Type__pc, Member__r.ID_2_Type__c, 
                                        Member__r.ID_2_Number__pc, Member__r.ID_2_Issuance_Date__pc, Member__r.ID_2_Expiration_Date__pc,
                                        Member__r.ID_3_Type__pc, Member__r.ID_3_Type__c, 
                                        Member__r.ID_3_Number__pc, Member__r.ID_3_Issuance_Date__pc, Member__r.ID_3_Expiration_Date__pc,
                                        Member__r.Emp_Birth_Date__c , 
                                        Member__r.Residential_Street__pc, Member__r.Residential_Extra_Address__pc, Member__r.Residential_City__pc, Member__r.Residential_State__pc, Member__r.Residential_Zipocde__pc, Member__r.Residential_Country__pc,
                                        Member__r.FirstName, Member__r.MiddleName, Member__r.LastName, Member__r.BIRTH_DATE__pc          
                                        FROM WIRES_Transaction__c where Id=:WiresId                                        
                                        Limit 1];  
        string MemberSSN = '';
        string loanAPI;
        string AuthrorizedAccountString = '';
        if(WireTransaction.size() > 0){
            List<Account> WireMember = [SELECT id, name, personid__c FROM Account where id =: WireTransaction[0].Member__c limit 1];
            if(WireMember.size() > 0){
                MemberSSN = WireMember[0].personid__c.substring(1);
                
                ACH_To_Episys_API_Details__c api = ACH_To_Episys_API_Details__c.getValues('ProductionURL');
                
                if(api.URL__c != null){
                    loanAPI = api.URL__c;
				}

                httpRequest requestparam = new httpRequest();
                requestparam.setEndpoint(loanAPI + '/MemberAuthorization/GetAuthorizedAccounts?ssn=' + MemberSSN);
                requestparam.setMethod('GET');
                
                http httpParam = new http();
                httpResponse response;
                String strStatus, strBody;
                if (!Test.isRunningTest()){
                    response = httpParam.send(requestparam);        
                    strStatus = response.getStatus();
                    strBody = response.getBody();
                    system.debug('strBody #1160=='+strBody);
                } else{
                	strBody = '{"Accounts":"0000000123,0000000256"}';
                }
                
                if(strBody != ''){
                    map<string, object> jsonParsed = (map<string, object>)JSON.deserializeUntyped(strBody);
                    system.debug('jsonParsed=='+jsonParsed);
                    AuthrorizedAccountString = (string)jsonParsed.get('Accounts');
                }
                
                List<String> lstAccounts = AuthrorizedAccountString.split(',');
                Set<String> setAccounts = new Set<String>(lstAccounts);
                
                PastWireTransactions = [SELECT id,Approval_Status__c, FromAccount__c,
                                        Share_ID__c,Source__c, Member__c, 
                                        Name, SendOn__c , ToAccoutId__r.Recipient_AccountNumber__c,
                                        ToAccoutId__r.Name, WireAmount__c
                                        FROM WIRES_Transaction__c where FromAccount__c In: setAccounts                            
                                        AND Frequency__c =: WireTransaction[0].Frequency__c//'One - Time'
                                        AND SendOn__c < TODAY ORDER BY SendOn__c DESC]; 
                
                List<PastWiresWrapper> resultList = new List<PastWiresWrapper>(); 
                for(WIRES_Transaction__c wt: PastWireTransactions){
                    PastWiresWrapper pw = new PastWiresWrapper();
                    pw.WireNumber = wt.Name;
                    pw.SentDate = wt.SendOn__c;
                    pw.FromAccount = wt.FromAccount__c;
                    pw.RecipientAccount = wt.ToAccoutId__r.Recipient_AccountNumber__c;
                    pw.Recipient = wt.ToAccoutId__r.Name;
                    pw.Amount = wt.WireAmount__c;
                    resultList.add(pw);
                }
                resultPastWiresMap.put('PastWireTransactions', resultList);
            }
        }
        return resultPastWiresMap;
    }
    
    
    public static set<string> GetAuthorizedAccounts(string SSN){
        	string loanAPI;
        	string AuthrorizedAccountString = '';
             ACH_To_Episys_API_Details__c api = ACH_To_Episys_API_Details__c.getValues('ProductionURL');
                
                if(api.URL__c != null){
                    loanAPI = api.URL__c;
				}

                httpRequest requestparam = new httpRequest();
                requestparam.setEndpoint(loanAPI + '/MemberAuthorization/GetAuthorizedAccounts?ssn=' + SSN);
                requestparam.setMethod('GET');
                
                http httpParam = new http();
                httpResponse response;
                String strStatus, strBody;
                if (!Test.isRunningTest()){
                    response = httpParam.send(requestparam);        
                    strStatus = response.getStatus();
                    strBody = response.getBody();
                    system.debug('strBody #1160=='+strBody);
                } else{
                	strBody = '{"Accounts":"abc","bcd"}';
                }
                
                if(strBody != ''){
                    map<string, object> jsonParsed = (map<string, object>)JSON.deserializeUntyped(strBody);
                    system.debug('jsonParsed=='+jsonParsed);
                    AuthrorizedAccountString = (string)jsonParsed.get('Accounts');
                }
                
                List<String> lstAccounts = AuthrorizedAccountString.split(',');
                Set<String> setAccounts = new Set<String>(lstAccounts);          
   				return setAccounts;
    }
    
    public static void SetWiresStatusToDSExpired(Set<Id> id){
        List<WIRES_Transaction__c> wireTransactions = [SELECT Id,Name,Approval_Status__c,ToAccountName__c,ToAccoutId__c,
                                                       Status__c, FromAccount__c,TotalFromAccount__c,WireAmount__c,FormattedTotalAmount__c,
                                                       ToAccoutId__r.Recipient_AccountNumber__c,SendOn__c,Source__c,
                                                       ToAccoutId__r.BankName__c,ToAccoutId__r.RoutingNumber__c,
                                                       AccountStableReview__c,EmailStableReview__c,Member_Name__c,
                                                       Identity_Verification_Used__c,Home_Phone_Stable_Review__c,
                                                       Mobile_Phone_Stable_Review__c,Work_Phone_Stable_Review__c,
                                                       FlagAccountOpenfor45Days__c,FlagEmailStablefor30Days__c,
                                                       FlagHomePhoneStablefor30Days__c,FlagMobilePhoneStablefor30Days__c,Description__c, Frequency__C,
                                                       FlagWorkPhoneStablefor30Days__c,Share_ID__c, Member__c, FormattedWireAmount__c, Fees__c
                                                       FROM WIRES_Transaction__c WHERE id=:id];       
        
        
       /* list<CaseRecordType__c> scList = [SELECT Id,
                                          Primary_Category__c,
                                          Secondary_Category__c,
                                          Teritiary_Category__c,
                                          Record_Type_Name__c,
                                          SLA__c,
                                          RecordTypeId__c 
                                          FROM CaseRecordType__c 
                                          WHERE Primary_Category__c = 'Account Maintenance'
                                          AND Secondary_Category__c='Special Situations'
                                          AND Teritiary_Category__c='Potential Fraud' 
                                          LIMIT 1];*/
        
        List<WIRES_Transaction__c> onetimeWireObjs = new List<WIRES_Transaction__c>();
        List<Case> cases = new List<Case>();
        for(WIRES_Transaction__c wtc: wireTransactions){
            wtc.Approval_Status__c = WiresConstant.ApprovalStatus_DSExpired;
            onetimeWireObjs.add(wtc);           
           
           /* Account_Details__c accDetail=[SELECT Id,Name, Brand__c 
                                          FROM Account_Details__c 
                                          WHERE Name=:wtc.FromAccount__c 
                                          AND RecType__c = 'ACCT' LIMIT 1];   
            
            case cs = new case();
            for(CaseRecordType__c crt : scList){
                cs.RecordTypeId = scList[0].RecordTypeId__c;
                cs.Primary_Category__c = scList[0].Primary_Category__c;
                cs.Secondary_Category__c = scList[0].Secondary_Category__c;
                cs.Tertiary_Category__c = scList[0].Teritiary_Category__c;
                cs.Sla__c = scList[0].SLA__c;
            }    
            cs.Status = 'Open';
            cs.AccountId=wtc.Member__c;
            cs.Subject = 'Wires DocuSign Expiration';
            cs.ownerid = UserInfo.getUserId();
            if(accDetail != null){
                cs.Account_Number__c = accDetail.Id;
            }
            
            Datetime dt = datetime.newInstance(Date.valueOf(wtc.SendOn__c).year(), Date.valueOf(wtc.SendOn__c).month(), Date.valueOf(wtc.SendOn__c).day());
            string caseDesc=+'Wire Name: '+ wtc.Name +'\n'
                                    +'Type of wire: '+ 'Domestic' +'\n'
                                    +'Account#: '+ wtc.FromAccount__c +'\n'
                                    +'Share ID: '+ wtc.Share_ID__c +'\n'
                                    +'Amount of Wire: $'+ wtc.FormattedWireAmount__c +'\n'
                                    +'Wire Fee: $'+ wtc.Fees__c +'\n'
                                    +'Total Amount to be debited from account: $'+ wtc.FormattedTotalAmount__c +'\n'
                                    +'Recipient Name: '+ wtc.ToAccountName__c +'\n'
                                    +'Recipient Account Number: '+ wtc.ToAccoutId__c +'\n'
                                    +'Financial Institution Name: '+ Wtc.ToAccoutId__r.BankName__c +'\n'
                                    +'Special Instructions: '+ wtc.Description__c +'\n'
                                    +'Frequency: '+ wtc.Frequency__c +'\n'
                                    +'Send On: '+ dt.format('MM/dd/yyyy') +'\n';
            
            
            cs.Description=caseDesc;
            cases.add(cs);
            insert cs;
            wtc.Case__c=cs.Id;*/
        }
        
        update onetimeWireObjs;       

    }
    
    public class FraudReviewMARSDetailsWrapperObject{
		
		@AuraEnabled
		public string ResidentialAddress {get; set;}

		@AuraEnabled
		public string IdNumber {get; set;}

		@AuraEnabled
		public datetime ExpirationDate {get; set;}

		@AuraEnabled
		public datetime IssuanceDate {get; set;}

		@AuraEnabled
		public string IssuingCountry {get; set;}

		@AuraEnabled
		public string TypeOfId {get; set;}

		@AuraEnabled
		public Date DateOfBirth {get; set;}

		@AuraEnabled
		public string Sex {get; set;}

		@AuraEnabled
		public string FirstNames {get; set;}

		@AuraEnabled
		public string MiddleNames {get; set;}

		@AuraEnabled
		public string LastNames {get; set;}

		@AuraEnabled
		public string FullName {get; set;}
	

	}
    
    public class PastWiresWrapper {
        @AuraEnabled
        public String WireNumber { get; set; }
        @AuraEnabled
        public Date SentDate { get; set; }
        @AuraEnabled
        public String FromAccount { get; set; }
        @AuraEnabled
        public String RecipientAccount { get; set; }
        @AuraEnabled
        public String Recipient { get; set; }
        @AuraEnabled
        public decimal Amount { get; set; }        
    }


}