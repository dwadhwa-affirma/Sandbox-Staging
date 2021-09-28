global class Wires_ApprovalNotificationBatch implements Database.Batchable<sObject> {
    
    global Database.QueryLocator start(Database.BatchableContext BC){    
        return DataBase.getQueryLocator([SELECT Id,Name,FromAccount__c,
                                         First_Reviewer__c,
                                         TotalFromAccount__c,
                                         WireAmount__c,
                                         Current_Reviewer__c,
                                         Current_Second_Reviewer__c,
                                         Current_Reviewer_Modified_Date__c,
                                         Approval_Status__c,
                                         Approved_by_1st_Approver__c,Source__c,
                                         Has_Additional_Documents__c
                                         FROM WIRES_Transaction__c 
                                         WHERE Source__c =: WiresConstant.Source_Branch
                                         AND Frequency__c = 'One - Time'
                                         AND (Approval_Status__c=:WiresConstant.ApprovalStatus_PendingForApproval 
                                              OR Approval_Status__c=:WiresConstant.ApprovalStatus_PendingForSecondApproval
                                              OR Approval_Status__c=:WiresConstant.ApprovalStatus_GoodFundsReview)]);    
    }
    
    global void execute(Database.BatchableContext BC,List<WIRES_Transaction__c> scopeWTIDs){
        Wires_Approval_Notification_Time_Limit__c timeLimit=Wires_Approval_Notification_Time_Limit__c.getValues('Time Limit');
        
        System.debug('Time limit configuration:'+timeLimit.Time_In_Minutes__c);
        
        string grpAName='';
        string grpBName='';
        string grpCName='';
        string grpDName='';
        string grpEName='';
        
        grpAName=WiresConstant.Branch_Group_A;
        grpBName=WiresConstant.Branch_Group_B;
        grpCName=WiresConstant.Branch_Group_C;
        grpDName=WiresConstant.Branch_Group_D;
        grpEName=WiresConstant.Branch_Group_E;
        
        Group grpA = [SELECT DeveloperName,Email,Id,Name,RelatedId,Type 
                      FROM Group WHERE DeveloperName =:grpAName Limit 1];
        
        GroupMember[] grpAmembers  = [SELECT UserOrGroupId FROM GroupMember where GroupId =: grpA.id];
        
        Group grpB = [SELECT DeveloperName,Email,Id,Name,RelatedId,Type 
                      FROM Group WHERE DeveloperName =:grpBName Limit 1];
        GroupMember[] grpBmembers  = [SELECT UserOrGroupId FROM GroupMember where GroupId =: grpB.id];
        
        Group grpC = [SELECT DeveloperName,Email,Id,Name,RelatedId,Type 
                      FROM Group WHERE DeveloperName =:grpCName Limit 1];
        GroupMember[] grpCmembers  = [SELECT UserOrGroupId FROM GroupMember where GroupId =: grpC.id];
        
        Group grpD = [SELECT DeveloperName,Email,Id,Name,RelatedId,Type 
                      FROM Group WHERE DeveloperName =:grpDName Limit 1];
        GroupMember[] grpDmembers  = [SELECT UserOrGroupId FROM GroupMember where GroupId =: grpD.id];
        
        Group grpE = [SELECT DeveloperName,Email,Id,Name,RelatedId,Type 
                      FROM Group WHERE DeveloperName =:grpEName Limit 1];
        GroupMember[] grpEmembers  = [SELECT UserOrGroupId FROM GroupMember where GroupId =: grpE.id];
        
        set<Id> groupAUsers=new Set<Id>();
        for(GroupMember member:grpAmembers){
            groupAUsers.add(member.UserOrGroupId);
        }
        
        set<Id> groupBUsers=new Set<Id>();
        for(GroupMember member:grpBmembers){
            groupBUsers.add(member.UserOrGroupId);
        }
        
        set<Id> groupCUsers=new Set<Id>();
        for(GroupMember member:grpCmembers){
            groupCUsers.add(member.UserOrGroupId);
        }
        
        set<Id> groupDUsers=new Set<Id>();
        for(GroupMember member:grpDmembers){
            groupDUsers.add(member.UserOrGroupId);
        }
        
        set<Id> groupEUsers=new Set<Id>();
        for(GroupMember member:grpEmembers){
            groupEUsers.add(member.UserOrGroupId);
        }
        
        Map<Id,User> userMap = new Map<Id,User>([SELECT Id,ManagerId,Email FROM User Where IsActive=true and Profile.Name!='Messaging center Customers']);
        
        Map<Id,User> usersWithManagerMap=new Map<Id,User>([SELECT Id,ManagerId,Email FROM User Where IsActive=true and ManagerId!=null and Profile.Name!='Messaging center Customers']);        
        
        set<Id> wiresId=new set<Id>();
        for(WIRES_Transaction__c wtc: scopeWTIDs){
            wiresId.add(wtc.Id);
        }
        
        Map<Id,WIRES_Transaction__history> firstReviewerHistoryMap=new Map<Id,WIRES_Transaction__history>([Select Id,NewValue,OldValue,Field,ParentId 
                                                                                                           From WIRES_Transaction__history 
                                                                                                           Where Field='Current_Reviewer__c' and ParentId=:wiresId]);
        
        Map<Id,WIRES_Transaction__history> secondReviewerHistoryMap=new Map<Id,WIRES_Transaction__history>([Select Id,NewValue,OldValue,Field,ParentId 
                                                                                                            From WIRES_Transaction__history 
                                                                                                            Where Field='Current_Second_Reviewer__c' and ParentId=:wiresId]);
        
        for(WIRES_Transaction__c wtc: scopeWTIDs){
            
            try{
                List<WIRES_Transaction__history> history=new List<WIRES_Transaction__history>();
                if(wtc.Approval_Status__c==WiresConstant.ApprovalStatus_PendingForSecondApproval) {
                    
                    for(WIRES_Transaction__history wtcHistory:secondReviewerHistoryMap.values()){
                        if(wtcHistory.ParentId==wtc.Id){
                            history.add(wtcHistory);
                        }
                    }
                    
                    //history=[Select Id,NewValue,OldValue,Field,ParentId 
                    //From WIRES_Transaction__history 
                    //Where Field='Current_Second_Reviewer__c' and ParentId=:wtc.Id];
                }else{
                    
                    for(WIRES_Transaction__history wtcHistory:firstReviewerHistoryMap.values()){
                        if(wtcHistory.ParentId==wtc.Id){
                            history.add(wtcHistory);
                        }
                    }
                    
                    //history=[Select Id,NewValue,OldValue,Field,ParentId 
                    //From WIRES_Transaction__history 
                    //Where Field='Current_Reviewer__c' and ParentId=:wtc.Id];
                }
                
                System.debug('history:'+history);
                set<string> currentReviewerIds=new set<string>();
                for(WIRES_Transaction__history wth:history){
                    if(wth.OldValue!=null){
                        currentReviewerIds.add(wth.OldValue.toString());
                    }
                    
                    if(wth.NewValue!=null){
                    	currentReviewerIds.add(wth.NewValue.toString());
                    }
                }
                
                Long dt1Long = DateTime.now().getTime();
                Long dt2Long = wtc.Current_Reviewer_Modified_Date__c.getTime();
                Long milliseconds =dt1Long-dt2Long;
                Long seconds = milliseconds / 1000;
                Long lapsedMinutes = seconds / 60;
                
                System.debug('Wires:'+wtc.Name+'----LapsedMinutes:'+lapsedMinutes);
                
                if(lapsedMinutes>=timeLimit.Time_In_Minutes__c){
                    System.debug('Lapse time condition match');
                    
                    User manager;
                    
                    if(wtc.Approval_Status__c==WiresConstant.ApprovalStatus_PendingForSecondApproval){
                        if(wtc.Current_Second_Reviewer__c==null){
                            manager=userMap.get(wtc.First_Reviewer__c);
                            //manager = [SELECT Id, Name, ManagerId FROM User WHERE Id =: wtc.First_Reviewer__c LIMIT 1];
                        }else{
                            manager=userMap.get(wtc.Current_Second_Reviewer__c);
                            //manager = [SELECT Id, Name, ManagerId FROM User WHERE Id =: wtc.Current_Second_Reviewer__c LIMIT 1];
                        }
                    }else{
                        if(wtc.Current_Reviewer__c==null){
                            manager=userMap.get(wtc.First_Reviewer__c);
                            //manager = [SELECT Id, Name, ManagerId FROM User WHERE Id =: wtc.First_Reviewer__c LIMIT 1];
                        }else{
                            manager=userMap.get(wtc.Current_Reviewer__c);
                            //manager = [SELECT Id, Name, ManagerId FROM User WHERE Id =: wtc.Current_Reviewer__c LIMIT 1];
                        }
                    }
                    
                    if(manager!=null && manager.ManagerId!=null){
                        TraverseApprovalNotificationTree(manager.ManagerId,wtc,userMap,usersWithManagerMap,currentReviewerIds,groupAUsers,groupBUsers,groupCUsers,groupDUsers,groupEUsers);
                    }
                }
                
            }catch(Exception ex){ 
                System.debug('Exception:'+ex);
            }
        }
    }
    
    global void finish(Database.BatchableContext BC){
        
    }
    
    private static void TraverseApprovalNotificationTree(Id managerId,WIRES_Transaction__c wtc,
                                                         Map<Id,User> userMap,
                                                         Map<Id,User> usersWithManagerMap,        
                                                         set<string> currentReviewerIds,
                                                         set<Id> groupAUsers,
                                                         set<Id> groupBUsers,set<Id> groupCUsers,
                                                         set<Id> groupDUsers,set<Id> groupEUsers){
                                                             
                                                             boolean isReviewerChange=false;
                                                             
                                                             
                                                             List<User> siblings = new List<User>(); //[SELECT Id, Name, ManagerId,Email FROM User WHERE ManagerId =: managerId and ManagerId!=null];
                                                             for(User user:  usersWithManagerMap.values()){
                                                                 if(user.ManagerId!=null && user.ManagerId==managerId){
                                                                     siblings.add(user);
                                                                 }
                                                             }	
                                                             
                                                             List<User> siblingsInWiresGrp=new List<User>();
                                                             List<string> emails=new List<string>();
                                                             for(User user: siblings){
                                                                 boolean isSiblingInTheWireApprovalGroup=false;
                                                                 if(wtc.Approval_Status__c==WiresConstant.ApprovalStatus_PendingForSecondApproval) {
                                                                     isSiblingInTheWireApprovalGroup = IsUserInTheSecondWireApprovalGroup(user.Id,wtc.WireAmount__c,groupAUsers,groupBUsers,groupCUsers,groupDUsers,groupEUsers);
                                                                 }else{
                                                                     isSiblingInTheWireApprovalGroup = IsUserInTheFirstWireApprovalGroup(user.Id,wtc.WireAmount__c,groupAUsers,groupBUsers,groupCUsers,groupDUsers,groupEUsers);
                                                                 }
                                                                 
                                                                 if(isSiblingInTheWireApprovalGroup==true){ 
                                                                     siblingsInWiresGrp.add(user);
                                                                     string currentReviewerId= getCurrentReviewer(wtc);
                                                                     if(currentReviewerId!=user.Id){
                                                                         emails.add(user.Email);
                                                                     }
                                                                 }
                                                             }
                                                             
                                                             boolean isAnySiblingWasAssignedForReview = false;
                                                             for(User user: siblingsInWiresGrp){
                                                                 if(currentReviewerIds.contains(user.Id) || wtc.First_Reviewer__c==user.Id){   
                                                                     string currentReviewerId= getCurrentReviewer(wtc);
                                                                     if(currentReviewerId!=user.Id){
                                                                         isAnySiblingWasAssignedForReview=true;
                                                                         break;
                                                                     }
                                                                 }
                                                             }
                                                             
                                                             if(isAnySiblingWasAssignedForReview==false){     
                                                                 string currentReviewerId= getCurrentReviewer(wtc);
                                                                 for(User user: siblingsInWiresGrp){
                                                                     
                                                                     boolean shouldReviewerChange= wtc.Approval_Status__c==WiresConstant.ApprovalStatus_PendingForSecondApproval ? currentReviewerId!=user.Id && user.Id!=wtc.First_Reviewer__c && user.Id!=wtc.Approved_by_1st_Approver__c : currentReviewerId!=user.Id && user.Id!=wtc.First_Reviewer__c;
                                                                     if(shouldReviewerChange==true){
                                                                         
                                                                         if(wtc.Approval_Status__c==WiresConstant.ApprovalStatus_PendingForSecondApproval){
                                                                             wtc.Current_Second_Reviewer__c=user.Id;
                                                                         }else{
                                                                             wtc.Current_Reviewer__c=user.Id;
                                                                         }
                                                                         update wtc;
                                                                         isReviewerChange=true;
                                                                         break;
                                                                     }
                                                                 }
                                                             }
                                                             
                                                             if(isReviewerChange==true){
                                                                 // call function to send an email to all siblings which are in wires group
                                                                 WiresEmailController.SendApprovalNotification(wtc.Id,emails,wtc.Name,wtc.WireAmount__c,wtc.Source__c,wtc.Has_Additional_Documents__c);
                                                                 return;
                                                             }
                                                             
                                                             if(isReviewerChange==false){
                                                                 boolean isManagerInTheWireApprovalGroup=false;
                                                                 if(wtc.Approval_Status__c==WiresConstant.ApprovalStatus_PendingForSecondApproval) {
                                                                     isManagerInTheWireApprovalGroup=IsUserInTheSecondWireApprovalGroup(managerId,wtc.WireAmount__c,groupAUsers,groupBUsers,groupCUsers,groupDUsers,groupEUsers);
                                                                 }else{
                                                                     isManagerInTheWireApprovalGroup=IsUserInTheFirstWireApprovalGroup(managerId,wtc.WireAmount__c,groupAUsers,groupBUsers,groupCUsers,groupDUsers,groupEUsers);
                                                                 }
                                                                 
                                                                 
                                                                 if(isManagerInTheWireApprovalGroup==true){
                                                                     boolean shouldReviewerChange= wtc.Approval_Status__c==WiresConstant.ApprovalStatus_PendingForSecondApproval ? !currentReviewerIds.contains(managerId) && managerId!=wtc.Approved_by_1st_Approver__c :!currentReviewerIds.contains(managerId);
                                                                     if(shouldReviewerChange==true){
                                                                         
                                                                         if(wtc.Approval_Status__c==WiresConstant.ApprovalStatus_PendingForSecondApproval){
                                                                             wtc.Current_Second_Reviewer__c=managerId;
                                                                         }else{
                                                                             wtc.Current_Reviewer__c=managerId;
                                                                         }
                                                                         update wtc;
                                                                         isReviewerChange=true;
                                                                         //User managerUser = [SELECT Id, Name, ManagerId,Email FROM User WHERE Id =: managerId LIMIT 1];
                                                                         
                                                                         User managerUser=userMap.get(managerId);
                                                                         List<string> managerEmails=new List<string>();
                                                                         managerEmails.add(managerUser.Email);
                                                                         WiresEmailController.SendApprovalNotification(wtc.Id,managerEmails,wtc.Name,wtc.WireAmount__c,wtc.Source__c,wtc.Has_Additional_Documents__c);
                                                                         return;
                                                                     }
                                                                 }
                                                             }
                                                             
                                                             if(isReviewerChange==false){
                                                                 //List<User> manager = [SELECT Id, Name, ManagerId FROM User WHERE Id =: managerId LIMIT 1];
                                                                 User manager=userMap.get(managerId);
                                                                 if(manager!=null){
                                                                     
                                                                     try{
                                                                         TraverseApprovalNotificationTree(manager.ManagerId,wtc,userMap,usersWithManagerMap,currentReviewerIds,groupAUsers,groupBUsers,groupCUsers,groupDUsers,groupEUsers);
                                                                     }catch(Exception ex){System.debug('Exception:'+ex);}
                                                                 }
                                                             }
                                                         }
    
    
    private static string getCurrentReviewer(WIRES_Transaction__c wtc){
        string currentReviewerId='';
        if(wtc.Approval_Status__c==WiresConstant.ApprovalStatus_PendingForSecondApproval){
            currentReviewerId=wtc.Current_Second_Reviewer__c==null ? wtc.First_Reviewer__c: wtc.Current_Second_Reviewer__c;
        }else{
            currentReviewerId=wtc.Current_Reviewer__c==null ? wtc.First_Reviewer__c: wtc.Current_Reviewer__c; 
        }
        
        return currentReviewerId;
    }
    
    private static boolean IsUserInTheFirstWireApprovalGroup(Id userId,decimal wireTotalAmount, 
                                                             set<Id> groupAUsers,set<Id> groupBUsers,set<Id> groupCUsers,
                                                             set<Id> groupDUsers,set<Id> groupEUsers){
                                                                 
                                                                 boolean isFound=false;  
                                                                 
                                                                 if(wireTotalAmount>0 && wireTotalAmount<=25000){
                                                                     if(groupAUsers.contains(userId) || groupBUsers.contains(userId) 
                                                                        || groupCUsers.contains(userId) || groupDUsers.contains(userId) || groupEUsers.contains(userId)){
                                                                            isFound = true;
                                                                        }else{
                                                                            isFound = false;
                                                                        }   
                                                                 }
                                                                 if(wireTotalAmount>25000 && wireTotalAmount<=100000){
                                                                     if(groupBUsers.contains(userId) 
                                                                        || groupCUsers.contains(userId) 
                                                                        || groupDUsers.contains(userId) 
                                                                        || groupEUsers.contains(userId)){
                                                                            isFound = true;
                                                                        }else{
                                                                            isFound = false;
                                                                        }   
                                                                 }
                                                                 if(wireTotalAmount>100000){   
                                                                     if(groupCUsers.contains(userId) 
                                                                        || groupDUsers.contains(userId)){
                                                                            isFound = true;
                                                                        }else{
                                                                            isFound = false;
                                                                        }   
                                                                 }
                                                                 
                                                                 return isFound;
                                                             }
    
    
    private static boolean IsUserInTheSecondWireApprovalGroup(Id userId,decimal wireTotalAmount, 
                                                              set<Id> groupAUsers,set<Id> groupBUsers,set<Id> groupCUsers,
                                                              set<Id> groupDUsers,set<Id> groupEUsers){
                                                                  
                                                                  boolean isFound=false;  
                                                                  
                                                                  if(wireTotalAmount>100000 && wireTotalAmount<=250000){
                                                                      if(groupCUsers.contains(userId) 
                                                                         || groupDUsers.contains(userId) ||  
                                                                         groupEUsers.contains(userId)){
                                                                             isFound = true;
                                                                         }else{
                                                                             isFound = false;
                                                                         }
                                                                  }
                                                                  
                                                                  if(wireTotalAmount>250000 && wireTotalAmount<=1000000){
                                                                      if(groupDUsers.contains(userId) ||  
                                                                         groupEUsers.contains(userId)){
                                                                             isFound = true;
                                                                         }else{
                                                                             isFound = false;
                                                                         }
                                                                  }
                                                                  
                                                                  if(wireTotalAmount>1000000){
                                                                      if(groupEUsers.contains(userId)){
                                                                          isFound = true;
                                                                      }else{
                                                                          isFound = false;
                                                                      }
                                                                  }
                                                                  
                                                                  return isFound;
                                                              }
    
    
}