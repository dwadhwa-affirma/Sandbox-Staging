public class WiresTransactionApprovalController {
    
@AuraEnabled
    public static  Map<string,object> getWiresData(string WiresRecordId){
         Map<string,object> strMap = new  Map<string,object>();
         WIRES_Transaction__c WiresList = [SELECT id,Approval_Status__c, FromAccount__c,Share_ID__c,Source__c,TotalFromAccount__c,
                                           WireAmount__c, Description__c, IsAccountOpenfor45Days__c, Member_Name__c, 
                                           Identity_Verification_Used__c, IsEmailStable__c, IsHomePhoneStable__c, IsMobilePhoneStable__c, IsWorkPhoneStable__c,                                          
                                           AccountStableReview__c,Review_Reason__c,Available_Balance_Review__c, EmailStableReview__c,
                                           Home_Phone_Stable_Review__c,ID_Verification_Review__c, Mobile_Phone_Stable_Review__c, 
                                           Previous_Wires_Review__c, Work_Phone_Stable_Review__c, FlagAccountOpenfor45Days__c,
                                           FlagEmailStablefor30Days__c, FlagHomePhoneStablefor30Days__c, FlagMobilePhoneStablefor30Days__c, FlagWorkPhoneStablefor30Days__c,
                                           Account_Stable_2nd_Review__c, Available_Balance_2nd_Review__c, Email_Stable_2nd_Review__c, Home_Phone_Stable_2nd_Review__c, ID_Verification_2nd_Review__c,
                                           Mobile_Phone_Stable_2nd_Review__c, Previous_Wires_2nd_Review__c, Second_Approval_Review_Reason__c, Work_Phone_Stable_2nd_Review__c                                           
                                           from WIRES_Transaction__c where id=:WiresRecordId limit 1];
        
        List<string> ListFirstApproverGroups = new List<string>();
        List<string> ListSecondApproverGroups = new List<string>();
      	List<Wires_Limit_Configurations__c> mcs = Wires_Limit_Configurations__c.getall().values();
    
        boolean secondApprovalRequired = false;
        string firstApproverGroup, secondApproverGroup;
      //  if(WiresList.Source__c == 'Branch'){
            for(Wires_Limit_Configurations__c ws: mcs){              
               system.debug('ws.Minimum_Amount__c==='+ws.Minimum_Amount__c); 
                system.debug('ws.Maximum_Amount__c==='+ws.Maximum_Amount__c); 
                if(WiresList.WireAmount__c >= ws.Minimum_Amount__c && (WiresList.WireAmount__c <= ws.Maximum_Amount__c || ws.Maximum_Amount__c == null)){                   
                    if(ws.Number_of_Approvals__c == 1.0){                        
                        secondApprovalRequired = false;
                        if(ws.First_Approvers__c.contains(','))
                            ListFirstApproverGroups = ws.First_Approvers__c.split(',');
                        else
                            ListFirstApproverGroups.add(ws.First_Approvers__c);
                    }
                    else if(ws.Number_of_Approvals__c == 2.0){
                        system.debug('ws==='+ws.Number_of_Approvals__c); 
                        system.debug('2nd ==='); 
                        secondApprovalRequired = true;
                        if(ws.First_Approvers__c.contains(','))
                            ListFirstApproverGroups = ws.First_Approvers__c.split(',');
                        else
                            ListFirstApproverGroups.add(ws.First_Approvers__c);
                        if(ws.Second_Approver__c.contains(','))
                            ListSecondApproverGroups = ws.Second_Approver__c.split(',');
                        else
                            ListSecondApproverGroups.add(ws.Second_Approver__c);                    
                    }
                }
            }
  //  }
   
        system.debug('ListFirstApproverGroups=='+ListFirstApproverGroups);
       	string isApprovalVisible;     
        set<string> GroupIds = new set<string>();
      
        
        
        if(!secondApprovalRequired && WiresList.Approval_Status__c == 'Pending for Approval'){                          
                List<Group> grp = [SELECT DeveloperName,Email,Id,Name,RelatedId,Type FROM Group where DeveloperName IN: ListFirstApproverGroups]; 	
		 		system.debug('grp=='+grp);
            	for(Group g:grp){
            		GroupIds.add(g.id);
        		}
            	system.debug('GroupIds=='+GroupIds);
            
            	GroupMember[] gm  = [SELECT GroupId,Id,UserOrGroupId FROM GroupMember where GroupId IN: GroupIds and UserOrGroupId =: UserInfo.getUserId() ];
                system.debug('gm=='+gm);
            	if(gm.size() > 0){
		 			isApprovalVisible = 'true';

		 		}
                else{
                    isApprovalVisible = 'false';
                     system.debug('1');
                }                 
             
        }
        
        if(secondApprovalRequired  && (WiresList.Approval_Status__c == 'Pending for Approval' || WiresList.Approval_Status__c == 'Pending for Second Approval')){                          
            List<Group> grp;
            if(WiresList.Approval_Status__c == 'Pending for Approval') {
                 grp = [SELECT DeveloperName,Email,Id,Name,RelatedId,Type FROM Group where DeveloperName IN: ListFirstApproverGroups]; 
            }else{
                grp = [SELECT DeveloperName,Email,Id,Name,RelatedId,Type FROM Group where DeveloperName IN: ListSecondApproverGroups]; 
            }
            
            for(Group g:grp){
            		GroupIds.add(g.id);
        		}
		 		GroupMember[] gm  = [SELECT GroupId,Id,UserOrGroupId FROM GroupMember where GroupId IN:GroupIds and UserOrGroupId =: UserInfo.getUserId() ];
                if(gm.size() > 0){
		 			isApprovalVisible = 'true';
                    system.debug('2');
		 		}
                else{
                    isApprovalVisible = 'false';
                     system.debug('2');
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
        else if(Wires.Approval_Status__c == 'Pending for Approval' && (Wires.WireAmount__c >=0 && Wires.WireAmount__c <= 100000)){
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
        }
        else if(Wires.Approval_Status__c == 'Pending for Approval' && (Wires.WireAmount__c >=100001)){
            Wires.Approval_Status__c = 'Pending for Second Approval';
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
        }
        else if(Wires.Approval_Status__c == 'Pending for Second Approval'){
            Wires.Approval_Status__c = 'Approved';
            Wires.AccountStableReview__c = WiresObject.Account_Stable_2nd_Review__c;
            Wires.Available_Balance_Review__c = WiresObject.Available_Balance_2nd_Review__c;
            Wires.Review_Reason__c = WiresObject.Second_Approval_Review_Reason__c;
            Wires.EmailStableReview__c = WiresObject.Email_Stable_2nd_Review__c;
            Wires.Home_Phone_Stable_Review__c = WiresObject.Home_Phone_Stable_2nd_Review__c;
            Wires.ID_Verification_Review__c = WiresObject.ID_Verification_2nd_Review__c	;
            Wires.Mobile_Phone_Stable_Review__c = WiresObject.Mobile_Phone_Stable_2nd_Review__c;
            Wires.Previous_Wires_Review__c = WiresObject.Previous_Wires_2nd_Review__c;
            Wires.Work_Phone_Stable_Review__c = WiresObject.Work_Phone_Stable_2nd_Review__c;
            Wires.Approved_by_2nd_approver__c = UserInfo.getUserId(); 
        }
        system.debug('Wires=='+Wires);
        update Wires;
    }
    
    
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