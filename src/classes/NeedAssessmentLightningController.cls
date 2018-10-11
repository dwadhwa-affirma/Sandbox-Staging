public class NeedAssessmentLightningController {
   

	@AuraEnabled   
    public static NeedAssessmentLightningModel FetchNeedAssessmentData(string accountid)
    {
    	 		    system.debug('accountid-----' + accountid);	
          account acc;
          Needs_Assesment__c objNeedsAssessment;
          acc = [select id,RecordType.Name,NA_Opt_Out__c,NA_LECP_Complete__c,NA_LECF_Complete__c,NA_LEHS_Complete__c,NA_LEOL_Complete__c, NA_LEOM_Complete__c, NA_LEMP_Complete__c, NA_LEMD_Complete__c, NA_LEWS_Complete__c, NA_LESB_Complete__c, NA_LESF_Complete__c, NA_LEPT_Complete__c,NA_LEEM_Complete__c, NA_LEMQ_Complete__c, NA_LEAV_Complete__c, NA_Opt_Out_Date__c, BIRTH_DATE__pc 
    	  			from account where id =: accountid limit 1];    	  
   	  
	    	NeedAssessmentLightningModel obj = new NeedAssessmentLightningModel();
	    	      	  
	    	obj.AccountDetails = acc;
	    	  
	    	obj.PrimaryAccountWithAtleastoneTrust = false;
	        List<Person_Account__c> paList =     [SELECT Id, Account_Number__c, Account_Number__r.RecType__c, Relationship__c, Account_Number__r.TypeTranslate__c, TypeTranslate__c,
	                  Account_Number__r.Name FROM Person_Account__c WHERE PersonID__c =: accountid and Account_Number__r.RecType__c = 'ACCT'
	                                         and(Account_Number__r.TypeTranslate__c != '2-TRUST' or Account_Number__r.TYPE__c != 2) and TypeTranslate__c like '%PRIMARY%' ];
	
	
	        if (paList.size() > 0)
	        {
	            obj.PrimaryAccountWithAtleastoneTrust = true;
	        }
	
			obj.MemberAbove18 = true;
			if(acc.BIRTH_DATE__pc != null)
			{			
				obj.MemberAbove18 =	acc.BIRTH_DATE__pc.addyears(18) < System.Today();
			}
		
    	 
    	  List<Needs_Assesment__c> na = [select id,LEEM_Last_Updated_On__c,LEMQ_Last_Updated_On__c,LEOM_Last_Updated_On__c,LEAV_Last_Updated_On__c ,LESF_Last_Updated_On__c, LESB_Last_Updated_On__c, LEMD_Last_Updated_On__c, LECP_Last_Updated_On__c, LEHS_Last_Updated_On__c, LEOL_Last_Updated_On__c, LECF_Last_Updated_On__c, LEWS_Last_Updated_On__c,LECP_Written_Materials_Way_To_Send_Email__c,LECP_Written_Materials_Way_To_Send_Mail__c,Do_you_Rent_or_Own__c,
    	  		LEHS_Current_Lender__c, LEHS_Type_of_Mortgage__c,LEHS_Rate__c,LEHS_Current_Balance__c,LEHS_End_Year__c,LEHS_Planning_to_Purchase__c,LEHS_Purchase_When__c, LEHS_Have_Realtor__c,
    	  		LEHS_Comment_New__c,Rec_LEHS_1__c,Rec_LEHS_2__c, LECF_800__c,LECF_Experience_Improvement_Feedback_New__c, LECF_Online_banking__c, LECF_Mobile_banking__c, LECF_ATM__c, LECF_Comment_New__c,
    	  		LEMP_Last_Updated_On__c, LEPT_Last_Updated_On__c, LECF_Branch__c,LESB_Aware_SharedBranching__c,LESB_Aware_ConvBranching__c,LESB_SharedBranching_Comments_New__c,REC_LEMD_3__c,
    	  		LEAV_Current__c, LEAV_CurrentLoanProvider__c, LEAV_CurrentRate__c, LEAV_CurrentBalance__c, LEAV_EndDateLoan__c,LEMP_Credit_Card_Usage_Reason_Comments_N__c,
    	  		LEAV_PlanningToBuy__c, LEAV_PlanDate__c, LEAV_AnticipateFinance__c, LEAV_ContactPreferences_New__c,REC_LEAV_1__c, REC_LECF_4__c, REC_LECF_3__c, REC_LECF_2__c, REC_LECF_1__c, LEWS_Comment_New__c, LEWS_InPerson__c, LEWS_Other_ATM__c, LEWS_Shared_ATM__c, LEWS_CFCU_ATM__c,    	  		
    	  		Home_Improvement__c, Home_Improvement_Timeframe__c, Home_Improvement_Plan__c, College__c, College_Timeframe__c, College_Plan__c,
				Medical__c, Medical_Timeframe__c, Medical_Plan__c, Purchase_RV_Boat__c, Purchase_RV_Boat_Timeframe__c, Purchase_RV_Boat_Plan__c, Retirement_New__c, Retirement_Timeframe__c, 
				Retirement_Plan__c, Travel__c, Travel_Timeframe__c, Travel_Plan__c, Life_Events__c, Life_Events_Timeframe__c, Life_Events_Plan__c, Other__c, Other_Timeframe__c, Other_Plan__c,
				Rec_LEOM_1__c,Rec_LEOM_2__c,Rec_LEOM_3__c,Rec_LEOM_4__c,Rec_LEOM_5__c,Rec_LEOM_6__c,LEOM_PlanUnforeseen_New__c,LEOM_Comments_New__c,LEMP_Credit_Card_You_Use_Often_New__c,
				LEOM_Home_Update__c,LEOM_College_Update__c, LEOM_Medical_Update__c, LEOM_RV_Boat_Update__c, LEOM_Retirement_Update__c, REC_LEEM_1__c,REC_LEMP_1__c, REC_LEMP_2__c, REC_LEMP_3__c, REC_LEMP_4__c, REC_LEMP_5__c, REC_LEMP_6__c, REC_LEMP_7__c, REC_LEMP_8__c,
				LEOM_Travel_Update__c,LEOM_Life_Events_Update__c, LEOM_Other_Expenses_Update__c, LEMD_CFCU_Spectrum_YesNo__c, LEMD_At_another_financial_insti_YesNo__c, LEMD_CommentsForDD_New__c, LEMD_In_person_branch__c, Needs_Assesment__c.LEMD_ATM__c, LEMD_Online__c, LEMD_Mobile__c, 
				LEMD_CommentsDC_New__c, REC_LEMD_1__c, REC_LEMD_2__c,LESF_Aware_ATM_Network_YesNo__c, LESF_ATM_Location_YesNo__c,LESF_Comments_New__c,LEMP_Credit_Card_Usage_Other_New__c,LEMP_Credit_Card_Usage_Low_Interest_Rate__c,LEMP_Credit_Card_Usage_Cash_Back__c,LEMP_Credit_Card_Usage_Rewards__c,LEMP_Credit_Card_Usage_No_Annual_Fee__c,
				LEPT_Financial_Institution__c, LEPT_Convenient_locations__c, LEPT_Deposit_rates__c, LEPT_Loan_rates__c,LEMP_Credit_Card_Usage_Comments_New__c,
				LEPT_Have_financial_advisor_there__c, LEPT_Online_mobile_apps__c,LEPT_Other__c,REC_LEPT_1__c, LEPT_Comments_New__c,LEMP_Pay_Recurring_Check__c, LEMP_Debit_Card_Usage_Comments_New__c, LEMP_International_Transfer_Comments_New__c, LEMP_Pay_Recurring_BillPay__c, LEMP_Pay_Recurring_DC__c, LEMP_Pay_Recurring_CC__c, LEMP_Pay_Recurring_ACH__c, LEMP_Pay_Recurring_A2A__c, LEMP_Pay_Recurring_Other__c, LEMP_Pay_Individuals_Check__c, LEMP_Pay_Individuals_BillPay__c, LEMP_Pay_Individuals_DC__c, LEMP_Pay_Individuals_CC__c, LEMP_Pay_Individuals_ACH__c, LEMP_Pay_Individuals_A2A__c, LEMP_Pay_Individuals_Other__c, LEMP_Pay_MoveMoney_Check__c, LEMP_Pay_MoveMoney_BillPay__c, LEMP_Pay_MoveMoney_DC__c, LEMP_Pay_MoveMoney_CC__c, LEMP_Pay_MoveMoney_ACH__c, LEMP_Pay_MoveMoney_A2A__c, LEMP_Pay_MoveMoney_Other__c, LEMP_Payment_Transfer_Comments_New__c, LEMP_Transfer_Frequency__c, LEMP_Transfer_Comments_New__c, LEMP_International_Transfer_Frequency__c, 
				LEOL_Other_Existing_Loans__c, Rec_LEOL_1__c, Rec_LEOL_2__c,LEMP_Debit_Card_Usage_Retail__c,LEMP_Carry_Credit_Card_Balance__c,
				Rec_LEMQ_1__c, LEEM_Money_In_Primary_Account__c, LEEM_Savings_For_Retirement_401__c,LEEM_Savings_For_Retirement_IRA__c,LEMP_Debit_Card_Usage_Grocries__c, LEMP_Debit_Card_Usage_Gasstation__c, LEMP_Debit_Card_Usage_Online__c, LEMP_Debit_Card_Usage_Other__c, 
				LEEM_Savings_For_Retirement_O_R_Account__c,LEEM_Savings_For_Retirement_O_Account__c,LEEM_Comments_New__c,LEEM_Deductible_Plan__c,LEEM_Health_Savings_Account__c, REC_LEEM_2__c,
				Rec_LEOM_Outcome_1__c,Rec_LEEM_Outcome_2__c, REC_LEMD_Outcome_2__c,REC_LEMD_Outcome_1__c, Rec_LEEM_Outcome_1__c, Rec_LEOM_Outcome_2__c, Rec_LEOM_Outcome_3__c, Rec_LEOM_Outcome_4__c, Rec_LEOM_Outcome_5__c, Rec_LEOM_Outcome_6__c, 
				Rec_LEOM_Outcome_7__c, Rec_LEOL_Outcome_1__c, Rec_LEOL_Outcome_2__c, REC_LEAV_Outcome_1__c, Rec_LEHS_1_Outcome__c, 
				Rec_LEHS_Outcome_2__c, Rec_LECF_Outcome_1__c, Rec_LECF_Outcome_2__c, Rec_LECF_Outcome_3__c, Rec_LECF_Outcome_4__c, 
				REC_LEMP_Outcome_1__c, REC_LEMP_Outcome_2__c, REC_LEMP_Outcome_3__c, REC_LEMP_Outcome_4__c, REC_LEMP_Outcome_5__c, 
				REC_LEMP_Outcome_6__c, REC_LEMP_Outcome_7__c, REC_LEMP_Outcome_8__c, REC_LEPT_Outcome_1__c, REC_LEMD_Outcome_3__c, 
				REC_LEMQ_Outcome_1__c, Rec_Comment__c
    	  		from Needs_Assesment__c where Member__c =: accountid limit 1];
     	  	 	    	  		
    	  if(na.size() == 0)
    	  {
    	  		objNeedsAssessment = new Needs_Assesment__c();
    	  }
    	  else
    	  {
    	  	objNeedsAssessment = na[0];
    	  }
    	  
    	  if(objNeedsAssessment.LECP_Written_Materials_Way_To_Send_Email__c == null)
    	  {
    	  	
    	  	objNeedsAssessment.LECP_Written_Materials_Way_To_Send_Email__c = false;
    	  }
    	  if(objNeedsAssessment.LECP_Written_Materials_Way_To_Send_Mail__c == null)
    	  {
    	  	
    	  	objNeedsAssessment.LECP_Written_Materials_Way_To_Send_Mail__c = false;
    	  }
    	  

    	  obj.TabButttonColors.ContactPreferenceTabClass = GetTabColor(objNeedsAssessment.LECP_Last_Updated_On__c,acc.NA_LECP_Complete__c, 
    	  				integer.valueOf(GracePeriod__c.getValues('Contact Preference').ExpiresInDays__c), acc.NA_Opt_Out__c);
    	  				
    	      	  
    	  
    	  
    	  obj.TabButttonColors.CurrentFeedbackTabClass = GetTabColor(objNeedsAssessment.LECF_Last_Updated_On__c,acc.NA_LECF_Complete__c, 
    	  				integer.valueOf(GracePeriod__c.getValues('Current Feedback').ExpiresInDays__c), acc.NA_Opt_Out__c); 
    	  
          
                        
		 Set<string> listTab = new Set<string>();
		    listTab.add(obj.TabButttonColors.ContactPreferenceTabClass);
		    listTab.add(obj.TabButttonColors.CurrentFeedbackTabClass);
            
            
		  obj.RadioButttonColors.FeedBackAboutCurrentExperience = GetTabPaelColor(listTab);
		  
		  
		  
		  obj.TabButttonColors.HousingTabClass = GetTabColor(objNeedsAssessment.LEHS_Last_Updated_On__c,acc.NA_LEHS_Complete__c, 
    	  				integer.valueOf(GracePeriod__c.getValues('Housing').ExpiresInDays__c), acc.NA_Opt_Out__c);
    	  				
    	 system.debug('Housing Tab color-----' + obj.TabButttonColors.HousingTabClass);	 				
    	  				
		  obj.TabButttonColors.OtherLoanTabClass = GetTabColor(objNeedsAssessment.LEOL_Last_Updated_On__c,acc.NA_LEOL_Complete__c, 
    	  				integer.valueOf(GracePeriod__c.getValues('Other Loan').ExpiresInDays__c), acc.NA_Opt_Out__c);
    	  				
		obj.TabButttonColors.AutoVehicleTabClass = GetTabColor(objNeedsAssessment.LEAV_Last_Updated_On__c,acc.NA_LEAV_Complete__c, 
    	  				integer.valueOf(GracePeriod__c.getValues('Auto Vehicle').ExpiresInDays__c), acc.NA_Opt_Out__c);    	  				
		  
		obj.TabButttonColors.OtherTabClass = GetTabColor(objNeedsAssessment.LEOM_Last_Updated_On__c,acc.NA_LEOM_Complete__c, 
                        integer.valueOf(GracePeriod__c.getValues('NA Other Milestones').ExpiresInDays__c), acc.NA_Opt_Out__c);
            
		  
		  listTab = new Set<string>();
		    listTab.add(obj.TabButttonColors.ContactPreferenceTabClass);
		    listTab.add(obj.TabButttonColors.HousingTabClass);
		    listTab.add(obj.TabButttonColors.OtherLoanTabClass);
            listTab.add(obj.TabButttonColors.OtherTabClass);
            listTab.add(obj.TabButttonColors.AutoVehicleTabClass);
		    
		    
            obj.RadioButttonColors.FinanceKeyFileEvent = GetTabPaelColor(listTab);
		  
		    obj.objNeedsAssessment = objNeedsAssessment;
            obj.TabButttonColors.MoveYourMoneyTabClass = GetTabColor(objNeedsAssessment.LEMP_Last_Updated_On__c,acc.NA_LEMP_Complete__c, 
                        integer.valueOf(GracePeriod__c.getValues('Move Your Money').ExpiresInDays__c), acc.NA_Opt_Out__c);
                        
           
                                    
            obj.TabButttonColors.MakingDepositsTabClass = GetTabColor(objNeedsAssessment.LEMD_Last_Updated_On__c,acc.NA_LEMD_Complete__c, 
                        integer.valueOf(GracePeriod__c.getValues('MakingDeposits').ExpiresInDays__c), acc.NA_Opt_Out__c);
                        
            obj.TabButttonColors.WidthdrawalTabClass = GetTabColor(objNeedsAssessment.LEWS_Last_Updated_On__c,acc.NA_LEWS_Complete__c, 
                        integer.valueOf(GracePeriod__c.getValues('Withdrawal').ExpiresInDays__c), acc.NA_Opt_Out__c);
                        
            system.debug('withdrawal tab color-----' + obj.TabButttonColors.WidthdrawalTabClass);	            
                      
			obj.TabButttonColors.SharedBranchingTabClass = GetTabColor(objNeedsAssessment.LESB_Last_Updated_On__c,acc.NA_LESB_Complete__c, 
                        integer.valueOf(GracePeriod__c.getValues('Shared Branching').ExpiresInDays__c), acc.NA_Opt_Out__c);
            
                        
            obj.TabButttonColors.SFATMNetworkTabClass = GetTabColor(objNeedsAssessment.LESF_Last_Updated_On__c,acc.NA_LESF_Complete__c, 
                        integer.valueOf(GracePeriod__c.getValues('ATM Network').ExpiresInDays__c), acc.NA_Opt_Out__c);
                        
            obj.TabButttonColors.PrimaryTransactionTabClass = GetTabColor(objNeedsAssessment.LEPT_Last_Updated_On__c,acc.NA_LEPT_Complete__c, 
                        integer.valueOf(GracePeriod__c.getValues('PrimaryTransaction').ExpiresInDays__c), acc.NA_Opt_Out__c);
            
            
            
            listTab = new Set<string>();
            listTab.add(obj.TabButttonColors.ContactPreferenceTabClass);
            listTab.add(obj.TabButttonColors.MoveYourMoneyTabClass);
            listTab.add(obj.TabButttonColors.MakingDepositsTabClass);
            listTab.add(obj.TabButttonColors.WidthdrawalTabClass);
            listTab.add(obj.TabButttonColors.SharedBranchingTabClass);
            listTab.add(obj.TabButttonColors.SFATMNetworkTabClass);
            listTab.add(obj.TabButttonColors.PrimaryTransactionTabClass);           
            
            obj.RadioButttonColors.OptimizeMoveYourMoney = GetTabPaelColor(listTab);
            
            
            obj.TabButttonColors.EarnMoreTabClass = GetTabColor(objNeedsAssessment.LEEM_Last_Updated_On__c,acc.NA_LEEM_Complete__c, 
                        integer.valueOf(GracePeriod__c.getValues('Earn More').ExpiresInDays__c), acc.NA_Opt_Out__c);
                        
            listTab = new Set<string>();
            listTab.add(obj.TabButttonColors.ContactPreferenceTabClass);
            listTab.add(obj.TabButttonColors.EarnMoreTabClass);
            obj.RadioButttonColors.EarnMore = GetTabPaelColor(listTab);
            

            obj.TabButttonColors.ExtendBenifitsTabClass = GetTabColor(objNeedsAssessment.LEMQ_Last_Updated_On__c,acc.NA_LEMQ_Complete__c, 
                        integer.valueOf(GracePeriod__c.getValues('Extend Benifits').ExpiresInDays__c), acc.NA_Opt_Out__c);
                        
            
            listTab = new Set<string>();
            listTab.add(obj.TabButttonColors.ContactPreferenceTabClass);
            listTab.add(obj.TabButttonColors.ExtendBenifitsTabClass);
            obj.RadioButttonColors.ExtendBenifits = GetTabPaelColor(listTab);
            
		    
		    list<NA_Other_Existing_Loans__c> otherExistingLoans = new list<NA_Other_Existing_Loans__c>();
				otherExistingLoans = [select id, Balance__c, End_Date__c, Financial_Institution__c, Needs_Assessment__c, Rate__c, Type_of_Loan__c 
                        from NA_Other_Existing_Loans__c where Needs_Assessment__c =: objNeedsAssessment.Id];
                        
           	obj.ExistingLoansDetails = otherExistingLoans;            
                        
            if(objNeedsAssessment != null && objNeedsAssessment.id != null)
            
            {
           	list<NA_Membership_Referral_Questions__c> loans = new list<NA_Membership_Referral_Questions__c>();
				loans = [select id, Age__c, Name__c, Needs_Assessment__c, Want_to_Refer_Membership__c 
                        from NA_Membership_Referral_Questions__c where Needs_Assessment__c =: objNeedsAssessment.Id];
                        
			obj.MembershipDetails = loans;
			
            }
            else
            {
            obj.MembershipDetails = new list<NA_Membership_Referral_Questions__c>();	
            	
            }
            
    	  	
    	  	list<NA_Deposit__c> deposits = new list<NA_Deposit__c>();
				deposits = [select id, Balance__c, Financial_Instituition__c, Needs_Assessment__c, Rate__c, Type__c 
                        from NA_Deposit__c where Needs_Assessment__c =: objNeedsAssessment.Id];
                        
    	  	obj.DepositDetails = deposits;
    	  	
    	  	obj.ShowData = CheckMembership();
    	  	
    	  return obj;
    }
    
    public static boolean CheckMembership()
    {
    	
    		boolean ShowData = false;
		      //Declaring a Set as we don't want Duplicate Group Ids
			Set<Id> results = new Set<Id>();
			
			///Declaring a Map for Group with Role
			Map<Id,Id> grRoleMap = new Map<Id,Id>();
			
			//Populating the Map with RelatedID(i.e.UserRoledId) as Key
			for(Group gr : [select id,relatedid,name from Group])
			{
				grRoleMap.put(gr.relatedId,gr.id);
			}
			
			//Groups directly associated to user
			Set<Id> groupwithUser = new Set<Id>();
			
			//Populating the Group with User with GroupId we are filtering only  for Group of Type Regular,Role and RoleAndSubordinates
			for(GroupMember  u :[select groupId from GroupMember where UserOrGroupId=:UserInfo.getUserId() and (Group.Type = 'Regular' OR Group.Type='Role' OR Group.Type='RoleAndSubordinates')])
			{
				groupwithUser.add(u.groupId);
			}
			
			//Groups with Role
			for(User  u :[select UserRoleId from User where id=:UserInfo.getUserId()])
			{
				//Checking if the current User Role is part of Map or not
				if(grRoleMap.containsKey(u.UserRoleId))
				{
					results.add(grRoleMap.get(u.UserRoleId));
				}
			}
			//Combining both the Set
			results.addAll(groupwithUser);
			
			//Traversing the whole list of Groups to check any other nested Group
			Map<Id,Id> grMap = new Map<Id,Id>();
			for(GroupMember gr : [select id,UserOrGroupId,Groupid from GroupMember where
			        (Group.Type = 'Regular' OR Group.Type='Role' OR Group.Type='RoleAndSubordinates')])
			{
				grMap.put(gr.UserOrGroupId,gr.Groupid);
			}
			for(Id i :results)
			{
				if(grMap.containsKey(i))
				{
					results.add(grMap.get(i));
				}
			}
			
			
			system.debug('########' + results);
			  
        	ShowData = false;
  		
  		
		list<GroupMember> listNamegroup =	[select group.developerName from GroupMember where UserOrGroupId in: results];
		set<string> listName = new set<string>();
			for(GroupMember i :listNamegroup)
			{
				
					listName.add(i.group.developerName );
				
			}
			
			system.debug('########' + listName);
		   
		      if (listName.contains('NA_Auth')) {
		           ShowData = true;
		      }
		     
		     
		     
		     Set<String> groupNames = new Set<String>();
		   for (GroupMember gm : [select 
		                             group.name,
		                             group.DeveloperName 
		                          from GroupMember 
		                          where UserOrGroupId = :UserInfo.getUserId()]) {
		       groupNames.add(gm.group.DeveloperName);
		   }
			
			system.debug('groupNames---' + groupNames);
		   
		      if (groupNames.contains('NA_Auth')) {
		           ShowData = true;
		      }
		     
		      
		    system.debug('########1111' + results);  
		    return ShowData;
    }
    
    
    
    @AuraEnabled   
    public static NeedAssessmentLightningModel SaveNeedAssessmentData(Needs_Assesment__c objNeedsAssesment, string SectionName, string accountid, string SubItems, string[] deletedItems)
    {        
    	if(SectionName == 'Housing'){
    		 Needs_Assesment__c  nah_tobeinserted = new Needs_Assesment__c();
    		 nah_tobeinserted .Id = objNeedsAssesment.Id;
                    nah_tobeinserted .Do_you_Rent_or_Own__c = objNeedsAssesment.Do_you_Rent_or_Own__c ;
                    nah_tobeinserted .LEHS_Current_Lender__c = objNeedsAssesment.LEHS_Current_Lender__c ;
                    nah_tobeinserted .LEHS_Rate__c= objNeedsAssesment.LEHS_Rate__c;
                    nah_tobeinserted .LEHS_Current_Balance__c = objNeedsAssesment.LEHS_Current_Balance__c ;
                    //nah_tobeinserted .LEHS_End_Date__c = lnah_New.LEHS_End_Date__c ;
                    nah_tobeinserted .LEHS_Planning_to_Purchase__c = objNeedsAssesment.LEHS_Planning_to_Purchase__c ;
                    nah_tobeinserted .LEHS_Purchase_When__c = objNeedsAssesment.LEHS_Purchase_When__c ;                    
                    nah_tobeinserted .LEHS_Have_Realtor__c= objNeedsAssesment.LEHS_Have_Realtor__c;
           
                    nah_tobeinserted.Rec_LEHS_1__c = objNeedsAssesment.Rec_LEHS_1__c;
                    nah_tobeinserted.Rec_LEHS_2__c = objNeedsAssesment.Rec_LEHS_2__c;
                    if(objNeedsAssesment.LEHS_End_Year__c == 0)
                    {
                    	
                    	nah_tobeinserted .LEHS_End_Year__c = null;
                    }
                    else
                    {
                    	
                    	nah_tobeinserted .LEHS_End_Year__c = objNeedsAssesment.LEHS_End_Year__c ;	
                    }
                    nah_tobeinserted .LEHS_Type_of_Mortgage__c = objNeedsAssesment.LEHS_Type_of_Mortgage__c;
                    nah_tobeinserted.LEHS_Comment_New__c = objNeedsAssesment.LEHS_Comment_New__c;
                    if(nah_tobeinserted.Id == null)
                    {
                        nah_tobeinserted.Member__c = accountid;
                    }
                    
                    nah_tobeinserted.LEHS_Last_Updated_On__c = system.today();
                    upsert  nah_tobeinserted;
    	}
    	if(SectionName == 'ContactPreference')
    	{
    		Needs_Assesment__c nao_tobeinserted = new Needs_Assesment__c();
            nao_tobeinserted.Id = objNeedsAssesment.Id;
            
            nao_tobeinserted.LECP_Written_Materials_Way_To_Send_Email__c= objNeedsAssesment.LECP_Written_Materials_Way_To_Send_Email__c;
            nao_tobeinserted.LECP_Written_Materials_Way_To_Send_Mail__c= objNeedsAssesment.LECP_Written_Materials_Way_To_Send_Mail__c;
            

            if (nao_tobeinserted.Id == null)
            {
                nao_tobeinserted.Member__c = accountid;
            }
            nao_tobeinserted.LECP_Last_Updated_On__c= system.today();           


            upsert nao_tobeinserted;
    	}
    	
    	if(SectionName == 'ATMNETWORK')
    	{   	
                 Needs_Assesment__c  nao_tobeinserted = new Needs_Assesment__c  ();
                                     nao_tobeinserted.Id = objNeedsAssesment.Id;
                    
                    nao_tobeinserted.LESF_Aware_ATM_Network_YesNo__c = objNeedsAssesment.LESF_Aware_ATM_Network_YesNo__c;
                    nao_tobeinserted.LESF_ATM_Location_YesNo__c = objNeedsAssesment.LESF_ATM_Location_YesNo__c;
                    
                    nao_tobeinserted.LESF_Comments_New__c = objNeedsAssesment.LESF_Comments_New__c;
                    nao_tobeinserted.REC_LECF_4__c = objNeedsAssesment.REC_LECF_4__c;
                                    
                   nao_tobeinserted.LESF_Last_Updated_On__c = system.today();
                   
                   	if (nao_tobeinserted.Id == null)
		            {
		                nao_tobeinserted.Member__c = accountid;
		            }
                    upsert  nao_tobeinserted;
            
    
       }
    	if(SectionName == 'AutoVehicle')
    	{
            
                 Needs_Assesment__c  nao_tobeinserted = new Needs_Assesment__c  ();
                                     nao_tobeinserted.Id = objNeedsAssesment.Id;
                    
                    nao_tobeinserted.LEAV_AnticipateFinance__c = objNeedsAssesment .LEAV_AnticipateFinance__c;
                    nao_tobeinserted.LEAV_ContactPreferences_New__c = objNeedsAssesment.LEAV_ContactPreferences_New__c;
                    
                    nao_tobeinserted.LEAV_Current__c = objNeedsAssesment .LEAV_Current__c;
                    nao_tobeinserted.LEAV_CurrentBalance__c = objNeedsAssesment.LEAV_CurrentBalance__c;
                    nao_tobeinserted.LEAV_CurrentLoanProvider__c = objNeedsAssesment.LEAV_CurrentLoanProvider__c;
                    nao_tobeinserted.LEAV_CurrentRate__c = objNeedsAssesment.LEAV_CurrentRate__c;
                    nao_tobeinserted.LEAV_EndDateLoan__c = objNeedsAssesment.LEAV_EndDateLoan__c;
                    
                    nao_tobeinserted.LEAV_PlanDate__c = objNeedsAssesment.LEAV_PlanDate__c;
                    nao_tobeinserted.LEAV_PlanningToBuy__c = objNeedsAssesment.LEAV_PlanningToBuy__c;
                    nao_tobeinserted.REC_LEAV_1__c = objNeedsAssesment.REC_LEAV_1__c;
                                       
                    if(nao_tobeinserted.Id == null)
                    {
                    	nao_tobeinserted.Member__c = accountid ;
                    }
                    nao_tobeinserted.LEAV_Last_Updated_On__c  = system.today();
                   
                    upsert  nao_tobeinserted;
            
    
       }
       if(SectionName == 'Withdrawals')
    	{
                 Needs_Assesment__c  nao_tobeinserted = new Needs_Assesment__c  ();
                                     nao_tobeinserted.Id = objNeedsAssesment.Id;
                    
                    nao_tobeinserted.LEWS_CFCU_ATM__c = objNeedsAssesment.LEWS_CFCU_ATM__c;
                    nao_tobeinserted.LEWS_Shared_ATM__c = objNeedsAssesment.LEWS_Shared_ATM__c;
                    
                    nao_tobeinserted.LEWS_Other_ATM__c = objNeedsAssesment.LEWS_Other_ATM__c;
                    nao_tobeinserted.LEWS_InPerson__c = objNeedsAssesment.LEWS_InPerson__c;
                    nao_tobeinserted.LEWS_Comment_New__c = objNeedsAssesment.LEWS_Comment_New__c;
                   
                   nao_tobeinserted.LEWS_Last_Updated_On__c = system.today();
                    
                    nao_tobeinserted.REC_LECF_4__c = objNeedsAssesment.REC_LECF_4__c;    
                    
                    if(nao_tobeinserted.Id == null)
                    {
                    	nao_tobeinserted.Member__c = accountid ;
                    }             
                   
                    upsert  nao_tobeinserted;
            
    
       }       	
        if(SectionName == 'SharedBranching')
    	{            	
                 Needs_Assesment__c  nao_tobeinserted = new Needs_Assesment__c  ();
                                     nao_tobeinserted.Id = objNeedsAssesment.Id;
                    
                    nao_tobeinserted.LESB_Aware_SharedBranching__c = objNeedsAssesment.LESB_Aware_SharedBranching__c;
                    nao_tobeinserted.LESB_Aware_ConvBranching__c = objNeedsAssesment.LESB_Aware_ConvBranching__c;
                    
                    nao_tobeinserted.LESB_SharedBranching_Comments_New__c = objNeedsAssesment.LESB_SharedBranching_Comments_New__c;
                    nao_tobeinserted.REC_LEMD_3__c = objNeedsAssesment.REC_LEMD_3__c;
                  
                    
                    nao_tobeinserted.LESB_Last_Updated_On__c  = system.today();
                    
                    if(nao_tobeinserted.Id == null)
                    {
                    	nao_tobeinserted.Member__c = accountid ;
                    }
                    
                    upsert  nao_tobeinserted;
       }
       if(SectionName == 'PaymentsTransfers')
    	{
                        Needs_Assesment__c  nao_tobeinserted = new Needs_Assesment__c  ();
                                         nao_tobeinserted.Id = objNeedsAssesment.Id;
    nao_tobeinserted.LEMP_Credit_Card_Usage_No_Annual_Fee__c = objNeedsAssesment.LEMP_Credit_Card_Usage_No_Annual_Fee__c;
          nao_tobeinserted.LEMP_Credit_Card_Usage_Rewards__c = objNeedsAssesment.LEMP_Credit_Card_Usage_Rewards__c;
        nao_tobeinserted.LEMP_Credit_Card_Usage_Cash_Back__c = objNeedsAssesment.LEMP_Credit_Card_Usage_Cash_Back__c;
nao_tobeinserted.LEMP_Credit_Card_Usage_Low_Interest_Rate__c = objNeedsAssesment.LEMP_Credit_Card_Usage_Low_Interest_Rate__c;
            nao_tobeinserted.LEMP_Credit_Card_Usage_Other_New__c = objNeedsAssesment.LEMP_Credit_Card_Usage_Other_New__c;
          nao_tobeinserted.LEMP_Carry_Credit_Card_Balance__c = objNeedsAssesment.LEMP_Carry_Credit_Card_Balance__c;
          nao_tobeinserted.LEMP_Credit_Card_You_Use_Often_New__c = objNeedsAssesment.LEMP_Credit_Card_You_Use_Often_New__c;
  nao_tobeinserted.LEMP_Credit_Card_Usage_Reason_Comments_N__c = objNeedsAssesment.LEMP_Credit_Card_Usage_Reason_Comments_N__c;
         nao_tobeinserted.LEMP_Credit_Card_Usage_Comments_New__c = objNeedsAssesment.LEMP_Credit_Card_Usage_Comments_New__c;
                              nao_tobeinserted.REC_LEMP_1__c = objNeedsAssesment.REC_LEMP_1__c;
                              nao_tobeinserted.REC_LEMP_2__c = objNeedsAssesment.REC_LEMP_2__c;
                              nao_tobeinserted.REC_LEMP_3__c = objNeedsAssesment.REC_LEMP_3__c;
                              nao_tobeinserted.REC_LEMP_4__c = objNeedsAssesment.REC_LEMP_4__c;
                              nao_tobeinserted.REC_LEMP_5__c = objNeedsAssesment.REC_LEMP_5__c;
                              nao_tobeinserted.REC_LEMP_6__c = objNeedsAssesment.REC_LEMP_6__c;
                              nao_tobeinserted.REC_LEMP_7__c = objNeedsAssesment.REC_LEMP_7__c;
                              nao_tobeinserted.REC_LEMP_8__c = objNeedsAssesment.REC_LEMP_8__c;
            nao_tobeinserted.LEMP_Debit_Card_Usage_Retail__c = objNeedsAssesment.LEMP_Debit_Card_Usage_Retail__c;
          nao_tobeinserted.LEMP_Debit_Card_Usage_Grocries__c = objNeedsAssesment.LEMP_Debit_Card_Usage_Grocries__c;
        nao_tobeinserted.LEMP_Debit_Card_Usage_Gasstation__c = objNeedsAssesment.LEMP_Debit_Card_Usage_Gasstation__c;
            nao_tobeinserted.LEMP_Debit_Card_Usage_Online__c = objNeedsAssesment.LEMP_Debit_Card_Usage_Online__c;
             nao_tobeinserted.LEMP_Debit_Card_Usage_Other__c = objNeedsAssesment.LEMP_Debit_Card_Usage_Other__c;
                nao_tobeinserted.LEMP_Pay_Recurring_Check__c = objNeedsAssesment.LEMP_Pay_Recurring_Check__c;
          nao_tobeinserted.LEMP_Debit_Card_Usage_Comments_New__c	 = objNeedsAssesment.LEMP_Debit_Card_Usage_Comments_New__c	;     
    nao_tobeinserted.LEMP_International_Transfer_Comments_New__c = objNeedsAssesment.LEMP_International_Transfer_Comments_New__c;
              nao_tobeinserted.LEMP_Pay_Recurring_BillPay__c = objNeedsAssesment.LEMP_Pay_Recurring_BillPay__c;
                   nao_tobeinserted.LEMP_Pay_Recurring_DC__c = objNeedsAssesment.LEMP_Pay_Recurring_DC__c;
                   nao_tobeinserted.LEMP_Pay_Recurring_CC__c = objNeedsAssesment.LEMP_Pay_Recurring_CC__c;
                  nao_tobeinserted.LEMP_Pay_Recurring_ACH__c = objNeedsAssesment.LEMP_Pay_Recurring_ACH__c;
                    nao_tobeinserted.LEMP_Pay_Recurring_A2A__c   = objNeedsAssesment.LEMP_Pay_Recurring_A2A__c;
                    nao_tobeinserted.LEMP_Pay_Recurring_Other__c = objNeedsAssesment.LEMP_Pay_Recurring_Other__c;
                  nao_tobeinserted.LEMP_Pay_Individuals_Check__c = objNeedsAssesment.LEMP_Pay_Individuals_Check__c;
               nao_tobeinserted.LEMP_Pay_Individuals_BillPay__c  = objNeedsAssesment.LEMP_Pay_Individuals_BillPay__c;
                    nao_tobeinserted.LEMP_Pay_Individuals_DC__c               = objNeedsAssesment.LEMP_Pay_Individuals_DC__c;
                    nao_tobeinserted.LEMP_Pay_Individuals_CC__c               = objNeedsAssesment.LEMP_Pay_Individuals_CC__c;
                 nao_tobeinserted.LEMP_Pay_Individuals_ACH__c                  = objNeedsAssesment.LEMP_Pay_Individuals_ACH__c;
                 nao_tobeinserted.LEMP_Pay_Individuals_A2A__c                  = objNeedsAssesment.LEMP_Pay_Individuals_A2A__c;
                 nao_tobeinserted.LEMP_Pay_Individuals_Other__c                  = objNeedsAssesment.LEMP_Pay_Individuals_Other__c;
                 nao_tobeinserted.LEMP_Pay_MoveMoney_Check__c                  = objNeedsAssesment.LEMP_Pay_MoveMoney_Check__c;
                 nao_tobeinserted.LEMP_Pay_MoveMoney_BillPay__c                  = objNeedsAssesment.LEMP_Pay_MoveMoney_BillPay__c;
                 nao_tobeinserted.LEMP_Pay_MoveMoney_DC__c                  = objNeedsAssesment.LEMP_Pay_MoveMoney_DC__c;
                 nao_tobeinserted.LEMP_Pay_MoveMoney_CC__c                  = objNeedsAssesment.LEMP_Pay_MoveMoney_CC__c;
                 nao_tobeinserted.LEMP_Pay_MoveMoney_ACH__c                    = objNeedsAssesment.LEMP_Pay_MoveMoney_ACH__c;
                 nao_tobeinserted.LEMP_Pay_MoveMoney_A2A__c                  = objNeedsAssesment.LEMP_Pay_MoveMoney_A2A__c;
                 nao_tobeinserted.LEMP_Pay_MoveMoney_Other__c              = objNeedsAssesment.LEMP_Pay_MoveMoney_Other__c;    
                 nao_tobeinserted.LEMP_Payment_Transfer_Comments_New__c        = objNeedsAssesment.LEMP_Payment_Transfer_Comments_New__c;
                 nao_tobeinserted.LEMP_Transfer_Frequency__c              = objNeedsAssesment.LEMP_Transfer_Frequency__c;
                 nao_tobeinserted.LEMP_Transfer_Comments_New__c              = objNeedsAssesment.LEMP_Transfer_Comments_New__c;
              nao_tobeinserted.LEMP_International_Transfer_Frequency__c= objNeedsAssesment.LEMP_International_Transfer_Frequency__c;                                 
                    nao_tobeinserted.LEMP_Last_Updated_On__c= system.today();     
                    
                    if(nao_tobeinserted.Id == null)
                    {
                        nao_tobeinserted.Member__c = accountid;
                    }
                                             
                    upsert  nao_tobeinserted;
    	}
    	
       if(SectionName == 'Deposits')
    	{
                 Needs_Assesment__c  nao_tobeinserted = new Needs_Assesment__c  ();
                                     nao_tobeinserted.Id = objNeedsAssesment.Id;
                
                    nao_tobeinserted.LEMD_CFCU_Spectrum_YesNo__c = objNeedsAssesment.LEMD_CFCU_Spectrum_YesNo__c;
       				nao_tobeinserted.LEMD_At_another_financial_insti_YesNo__c = objNeedsAssesment.LEMD_At_another_financial_insti_YesNo__c;
                    nao_tobeinserted.LEMD_CommentsForDD_New__c       = objNeedsAssesment.LEMD_CommentsForDD_New__c;
                    nao_tobeinserted.LEMD_In_person_branch__c    = objNeedsAssesment.LEMD_In_person_branch__c;
                    nao_tobeinserted.LEMD_ATM__c                 = objNeedsAssesment.LEMD_ATM__c;
                    nao_tobeinserted.LEMD_Online__c              = objNeedsAssesment.LEMD_Online__c;
                    nao_tobeinserted.LEMD_Mobile__c              = objNeedsAssesment.LEMD_Mobile__c;
                    nao_tobeinserted.LEMD_CommentsDC_New__c          = objNeedsAssesment.LEMD_CommentsDC_New__c;
                    nao_tobeinserted.REC_LEMD_1__c               = objNeedsAssesment.REC_LEMD_1__c;
                    nao_tobeinserted.REC_LEMD_2__c               = objNeedsAssesment.REC_LEMD_2__c;
                    nao_tobeinserted.REC_LEMD_3__c               = objNeedsAssesment.REC_LEMD_3__c;
                 nao_tobeinserted.REC_LECF_4__c                  = objNeedsAssesment.REC_LECF_4__c;
                 nao_tobeinserted.REC_LEEM_1__c                  = objNeedsAssesment.REC_LEEM_1__c;
                                                  
                    nao_tobeinserted.LEMD_Last_Updated_On__c= system.today();
                            
                    if(nao_tobeinserted.Id == null)
                    {
                        nao_tobeinserted.Member__c = accountid;
                    }
                                          
                    upsert  nao_tobeinserted;
    	}
       if(SectionName == 'CurrentFeedback')
       {
       		Needs_Assesment__c  nao_tobeinserted = new Needs_Assesment__c  ();
                    nao_tobeinserted.Id = objNeedsAssesment .Id;
                    
                    
                     nao_tobeinserted.LECF_Branch_Feedback__c= objNeedsAssesment.LECF_Branch_Feedback__c;
                     nao_tobeinserted.LECF_Branch__c= objNeedsAssesment.LECF_Branch__c;
                     nao_tobeinserted.LECF_800__c= objNeedsAssesment.LECF_800__c;
                     nao_tobeinserted.LECF_800_Feedback__c= objNeedsAssesment.LECF_800_Feedback__c;
                     nao_tobeinserted.LECF_Online_banking_Feedback__c= objNeedsAssesment.LECF_Online_banking_Feedback__c;
                     nao_tobeinserted.LECF_Online_banking__c= objNeedsAssesment.LECF_Online_banking__c;
                     nao_tobeinserted.LECF_ATM__c= objNeedsAssesment.LECF_ATM__c;
                     
                     
                     nao_tobeinserted.LECF_ATM_Feedback__c= objNeedsAssesment.LECF_ATM_Feedback__c;
                     nao_tobeinserted.LECF_Mobile_banking__c= objNeedsAssesment.LECF_Mobile_banking__c;
                     nao_tobeinserted.LECF_Mobile_banking_Feedback__c= objNeedsAssesment.LECF_Mobile_banking_Feedback__c;
                                          nao_tobeinserted.LECF_Experience_Improvement_Feedback_New__c = objNeedsAssesment.LECF_Experience_Improvement_Feedback_New__c;
                  nao_tobeinserted.LECF_Comment_New__c = objNeedsAssesment.LECF_Comment_New__c ;
                    
                    nao_tobeinserted.Rec_LECF_1__c = objNeedsAssesment.Rec_LECF_1__c;
                    nao_tobeinserted.Rec_LECF_2__c = objNeedsAssesment.Rec_LECF_2__c;
                    nao_tobeinserted.Rec_LECF_3__c = objNeedsAssesment.Rec_LECF_3__c;
                    nao_tobeinserted.Rec_LECF_4__c = objNeedsAssesment.Rec_LECF_4__c;
                    if(nao_tobeinserted.Id == null)
                    {
                    nao_tobeinserted.Member__c = accountid ;
                    }
                    nao_tobeinserted.LECF_Last_Updated_On__c= system.today();
                     
                   
					upsert  nao_tobeinserted;
       }
       
       
       if(SectionName == 'OtherMilestones')
       {
       		Needs_Assesment__c  nao_tobeinserted = new Needs_Assesment__c  ();
                                     nao_tobeinserted.Id = objNeedsAssesment.Id;
                    nao_tobeinserted.Home_Improvement__c = objNeedsAssesment .Home_Improvement__c;
                    nao_tobeinserted.Home_Improvement_Timeframe__c  = objNeedsAssesment .Home_Improvement_Timeframe__c;
                    nao_tobeinserted.Home_Improvement_Plan__c  = objNeedsAssesment .Home_Improvement_Plan__c;
                    nao_tobeinserted.College__c  = objNeedsAssesment .College__c ;
                    nao_tobeinserted.College_Timeframe__c  = objNeedsAssesment .College_Timeframe__c ;
                    nao_tobeinserted.College_Plan__c  = objNeedsAssesment .College_Plan__c ;
                    nao_tobeinserted.Medical__c  = objNeedsAssesment .Medical__c ;
                    nao_tobeinserted.Medical_Timeframe__c  = objNeedsAssesment .Medical_Timeframe__c ;
                    nao_tobeinserted.Medical_Plan__c  = objNeedsAssesment .Medical_Plan__c ;
                    nao_tobeinserted.Purchase_RV_Boat__c  = objNeedsAssesment .Purchase_RV_Boat__c ;
                    nao_tobeinserted.Purchase_RV_Boat_Timeframe__c  = objNeedsAssesment .Purchase_RV_Boat_Timeframe__c ;
                    nao_tobeinserted.Purchase_RV_Boat_Plan__c  = objNeedsAssesment .Purchase_RV_Boat_Plan__c ;
                    nao_tobeinserted.Travel__c  = objNeedsAssesment .Travel__c ;
                    nao_tobeinserted.Travel_Timeframe__c  = objNeedsAssesment .Travel_Timeframe__c ;
            
            
                    nao_tobeinserted.Travel_Plan__c   = objNeedsAssesment .Travel_Plan__c  ;
                    nao_tobeinserted.Life_Events__c   = objNeedsAssesment .Life_Events__c  ;
                    nao_tobeinserted.Life_Events_Timeframe__c   = objNeedsAssesment .Life_Events_Timeframe__c  ;
                    nao_tobeinserted.Life_Events_Plan__c   = objNeedsAssesment .Life_Events_Plan__c  ;
                    nao_tobeinserted.Other__c   = objNeedsAssesment .Other__c  ;
                    nao_tobeinserted.Other_Timeframe__c   = objNeedsAssesment .Other_Timeframe__c  ;
                    nao_tobeinserted.Other_Plan__c   = objNeedsAssesment .Other_Plan__c;
                  
                  	nao_tobeinserted.Retirement_New__c = objNeedsAssesment.Retirement_New__c;                  
                  	nao_tobeinserted.Retirement_Timeframe__c = objNeedsAssesment.Retirement_Timeframe__c;
                  	nao_tobeinserted.Retirement_Plan__c = objNeedsAssesment.Retirement_Plan__c;
                  
                  	nao_tobeinserted.Rec_LEOM_1__c = objNeedsAssesment.Rec_LEOM_1__c;
                    nao_tobeinserted.Rec_LEOM_2__c= objNeedsAssesment .Rec_LEOM_2__c;
                    nao_tobeinserted.Rec_LEOM_3__c= objNeedsAssesment .Rec_LEOM_3__c;
                    nao_tobeinserted.Rec_LEOM_4__c= objNeedsAssesment .Rec_LEOM_4__c;
                    nao_tobeinserted.Rec_LEOM_5__c= objNeedsAssesment .Rec_LEOM_5__c;
                    nao_tobeinserted.Rec_LEOM_6__c= objNeedsAssesment .Rec_LEOM_6__c;
                    
                    
					
                    nao_tobeinserted.LEOM_PlanUnforeseen_New__c = objNeedsAssesment.LEOM_PlanUnforeseen_New__c;
                    nao_tobeinserted.LEOM_Comments_New__c = objNeedsAssesment.LEOM_Comments_New__c;
                    if(nao_tobeinserted.Id == null)
                    {
                    	nao_tobeinserted.Member__c = accountid ;
                    }
                    nao_tobeinserted.LEOM_Last_Updated_On__c = system.today();
                   
                    upsert  nao_tobeinserted;
       }
       
       if(SectionName == 'PrimaryAccount')
       {
       		Needs_Assesment__c nao_tobeinserted = new Needs_Assesment__c();
            nao_tobeinserted.Id = objNeedsAssesment.Id;


            nao_tobeinserted.LEPT_Financial_Institution__c = objNeedsAssesment.LEPT_Financial_Institution__c;
            nao_tobeinserted.LEPT_Deposit_rates__c = objNeedsAssesment.LEPT_Deposit_rates__c;
            nao_tobeinserted.LEPT_Convenient_locations__c = objNeedsAssesment.LEPT_Convenient_locations__c;
            nao_tobeinserted.LEPT_Have_financial_advisor_there__c = objNeedsAssesment.LEPT_Have_financial_advisor_there__c;            
            nao_tobeinserted.LEPT_Loan_rates__c = objNeedsAssesment.LEPT_Loan_rates__c;
            nao_tobeinserted.LEPT_Online_mobile_apps__c = objNeedsAssesment.LEPT_Online_mobile_apps__c;
            nao_tobeinserted.LEPT_Other__c = objNeedsAssesment.LEPT_Other__c;
            nao_tobeinserted.LEPT_Comments_New__c = objNeedsAssesment.LEPT_Comments_New__c;
            

            nao_tobeinserted.Rec_LEPT_1__c = objNeedsAssesment.Rec_LEPT_1__c;
            
            

            if (nao_tobeinserted.Id == null)
            {
                nao_tobeinserted.Member__c = accountid;
            }
            nao_tobeinserted.LEPT_Last_Updated_On__c = system.today();
            
            upsert nao_tobeinserted;
       }
       
       if(SectionName == 'ExistingLoans')
       {
       		// Deserialize the list of invoices from the JSON string.
        	List<NA_Other_Existing_Loans__c> otherExistingLoans = (List<NA_Other_Existing_Loans__c>)JSON.deserialize(SubItems, List<NA_Other_Existing_Loans__c>.class);        	
        	
            Needs_Assesment__c nao_tobeinserted = new Needs_Assesment__c();
                        nao_tobeinserted.Id = objNeedsAssesment.Id;
                                    
			nao_tobeinserted.LEOL_Other_Existing_Loans__c = objNeedsAssesment.LEOL_Other_Existing_Loans__c;
			nao_tobeinserted.Rec_LEOL_1__c = objNeedsAssesment.Rec_LEOL_1__c;
			nao_tobeinserted.Rec_LEOL_2__c = objNeedsAssesment.Rec_LEOL_2__c;
			
            if (nao_tobeinserted.Id == null)
            {
                nao_tobeinserted.Member__c = accountid;
            }
            nao_tobeinserted.LEOL_Last_Updated_On__c = system.today();
 			objNeedsAssesment.LEOL_Last_Updated_On__c =nao_tobeinserted.LEOL_Last_Updated_On__c;
            
			upsert nao_tobeinserted;			
			
            system.debug('nao_tobeinserted.id----' + nao_tobeinserted.id);
            
            if(otherExistingLoans != null)
            {
            	for(NA_Other_Existing_Loans__c oEL : otherExistingLoans)
	        	{
	        		if(oEL.Needs_Assessment__c == null)
	        		{
	        			oEL.Needs_Assessment__c = nao_tobeinserted.id;
	        		}
	        	}
            }
            

            upsert otherExistingLoans;
            
            if(deletedItems != null)
            {
            	for (String Item : deletedItems) {
				    NA_Other_Existing_Loans__c existing = [select id from NA_Other_Existing_Loans__c where Id =: Item];
				    delete existing;
				}
            }
       }
       
       if(SectionName == 'Membership')
       {
       		// Deserialize the list of invoices from the JSON string.
        	List<NA_Membership_Referral_Questions__c> membershipLoans = (List<NA_Membership_Referral_Questions__c>)JSON.deserialize(SubItems, List<NA_Membership_Referral_Questions__c>.class);        	
        	
        	Needs_Assesment__c nao_tobeinserted = new Needs_Assesment__c();
           	nao_tobeinserted.Id = objNeedsAssesment.Id;
           
	        if (nao_tobeinserted.Id == null)
            {
                nao_tobeinserted.Member__c = accountid;
            }
            nao_tobeinserted.LEMQ_Last_Updated_On__c = system.today();
            nao_tobeinserted.Rec_LEMQ_1__c = objNeedsAssesment.Rec_LEMQ_1__c;
            objNeedsAssesment.LEMQ_Last_Updated_On__c =nao_tobeinserted.LEMQ_Last_Updated_On__c;
        	
            if(membershipLoans != null)
            {
            	for(NA_Membership_Referral_Questions__c oEL : membershipLoans)
	        	{
	        		if(oEL.Needs_Assessment__c == null)
	        		{
	        			oEL.Needs_Assessment__c = nao_tobeinserted.id;
	        		}
	        	}
            }

            upsert membershipLoans;
            
            if(deletedItems != null)
            {
            	for (String Item : deletedItems) {
				    NA_Membership_Referral_Questions__c existing = [select id from NA_Membership_Referral_Questions__c where Id =: Item];
				    delete existing;
				}
            }            
            
			upsert nao_tobeinserted;
	
       }
       
       if(SectionName == 'EarnMore')
       {
       		// Deserialize the list of invoices from the JSON string.
        	List<NA_Deposit__c> deposits = (List<NA_Deposit__c>)JSON.deserialize(SubItems, List<NA_Deposit__c>.class);        	
        	
        	
       		Needs_Assesment__c  nao_tobeinserted = new Needs_Assesment__c  ();
            nao_tobeinserted.Id = objNeedsAssesment .Id;
                    
                    
            nao_tobeinserted.LEEM_Health_Savings_Account__c= objNeedsAssesment .LEEM_Health_Savings_Account__c;
                     
            nao_tobeinserted.LEEM_Deductible_Plan__c= objNeedsAssesment .LEEM_Deductible_Plan__c;
                     
            nao_tobeinserted.LEEM_Comments_New__c= objNeedsAssesment .LEEM_Comments_New__c;
            nao_tobeinserted.LEEM_Savings_For_Retirement_O_Account__c= objNeedsAssesment .LEEM_Savings_For_Retirement_O_Account__c;
            nao_tobeinserted.LEEM_Savings_For_Retirement_O_R_Account__c= objNeedsAssesment .LEEM_Savings_For_Retirement_O_R_Account__c;
                    
            nao_tobeinserted.LEEM_Savings_For_Retirement_IRA__c= objNeedsAssesment .LEEM_Savings_For_Retirement_IRA__c;
            nao_tobeinserted.LEEM_Savings_For_Retirement_401__c= objNeedsAssesment .LEEM_Savings_For_Retirement_401__c;
            nao_tobeinserted.LEEM_Money_In_Primary_Account__c= objNeedsAssesment .LEEM_Money_In_Primary_Account__c;
                                          
            nao_tobeinserted.REC_LEEM_1__c = objNeedsAssesment.REC_LEEM_1__c;
            nao_tobeinserted.REC_LEEM_2__c = objNeedsAssesment.REC_LEEM_2__c;
            nao_tobeinserted.Rec_LEOM_3__c = objNeedsAssesment.Rec_LEOM_3__c;
                     
            if(nao_tobeinserted.Id == null)
            {
                    nao_tobeinserted.Member__c = accountid;
            }
            nao_tobeinserted.LEEM_Last_Updated_On__c= system.today();
            objNeedsAssesment.LEEM_Last_Updated_On__c =nao_tobeinserted.LEEM_Last_Updated_On__c;
            
			upsert  nao_tobeinserted;
            
            for(NA_Deposit__c dep : deposits) 
            {
            	if(dep.Needs_Assessment__c  == null)
                {
					dep.Needs_Assessment__c = nao_tobeinserted.id;
                }
            }

            upsert deposits;
            
            if(deletedItems != null)
            {
            	for (String Item : deletedItems) {
				    NA_Deposit__c existing = [select id from NA_Deposit__c where Id =: Item];
				    delete existing;
				}
            }
            
			upsert nao_tobeinserted;	
       }
       
        if(SectionName == 'Recommendations')
        {        	
          if(objNeedsAssesment.Rec_LEOM_Outcome_1__c == null || objNeedsAssesment.Rec_LEOM_Outcome_1__c == '')
          {
          objNeedsAssesment.Rec_LEOM_Outcome_1__c= 'Not Presented';
          }
          if(objNeedsAssesment.Rec_LEEM_Outcome_2__c == null || objNeedsAssesment.Rec_LEEM_Outcome_2__c == '')
          {
          objNeedsAssesment.Rec_LEEM_Outcome_2__c= 'Not Presented';
          }
          
          if(objNeedsAssesment.REC_LEMD_Outcome_2__c == null || objNeedsAssesment.REC_LEMD_Outcome_2__c == '')
          {
          objNeedsAssesment.REC_LEMD_Outcome_2__c= 'Not Presented';
          }
          if(objNeedsAssesment.REC_LEMD_Outcome_1__c == null || objNeedsAssesment.REC_LEMD_Outcome_1__c == '')
          {
          objNeedsAssesment.REC_LEMD_Outcome_1__c= 'Not Presented';
          }
          if(objNeedsAssesment.Rec_LEEM_Outcome_1__c== null || objNeedsAssesment.Rec_LEEM_Outcome_1__c == '')
          {
          objNeedsAssesment.Rec_LEEM_Outcome_1__c= 'Not Presented';
          }
                   
          
          if(objNeedsAssesment.Rec_LEOM_Outcome_2__c == null || objNeedsAssesment.Rec_LEOM_Outcome_2__c == '')
          {
          objNeedsAssesment.Rec_LEOM_Outcome_2__c= 'Not Presented';
          }
          if(objNeedsAssesment.Rec_LEOM_Outcome_3__c == null || objNeedsAssesment.Rec_LEOM_Outcome_3__c == '')
          {
          objNeedsAssesment.Rec_LEOM_Outcome_3__c= 'Not Presented';
          }
          if(objNeedsAssesment.Rec_LEOM_Outcome_4__c == null || objNeedsAssesment.Rec_LEOM_Outcome_4__c == '')
          {
          objNeedsAssesment.Rec_LEOM_Outcome_4__c= 'Not Presented';
          }
          if(objNeedsAssesment.Rec_LEOM_Outcome_5__c == null || objNeedsAssesment.Rec_LEOM_Outcome_5__c == '')
          {
          objNeedsAssesment.Rec_LEOM_Outcome_5__c= 'Not Presented';
          }
          if(objNeedsAssesment.Rec_LEOM_Outcome_6__c == null || objNeedsAssesment.Rec_LEOM_Outcome_6__c == '')
          {
          objNeedsAssesment.Rec_LEOM_Outcome_6__c= 'Not Presented';
          }
          if(objNeedsAssesment.Rec_LEOM_Outcome_7__c  == null || objNeedsAssesment.Rec_LEOM_Outcome_7__c  == '')
          {
          objNeedsAssesment.Rec_LEOM_Outcome_7__c = 'Not Presented';
          }
          if(objNeedsAssesment.Rec_LEOL_Outcome_1__c == null || objNeedsAssesment.Rec_LEOL_Outcome_1__c == '')
          {
          objNeedsAssesment.Rec_LEOL_Outcome_1__c= 'Not Presented';
          }
          if(objNeedsAssesment.Rec_LEOL_Outcome_2__c == null || objNeedsAssesment.Rec_LEOL_Outcome_2__c == '')
          {
          objNeedsAssesment.Rec_LEOL_Outcome_2__c= 'Not Presented';
          }
          if(objNeedsAssesment.REC_LEAV_Outcome_1__c == null || objNeedsAssesment.REC_LEAV_Outcome_1__c == '')
          {
          objNeedsAssesment.REC_LEAV_Outcome_1__c= 'Not Presented';
          }
          
          

          if(objNeedsAssesment.Rec_LEHS_1_Outcome__c == null || objNeedsAssesment.Rec_LEHS_1_Outcome__c == '')
          {
          objNeedsAssesment.Rec_LEHS_1_Outcome__c= 'Not Presented';
          }
          if(objNeedsAssesment.Rec_LEHS_Outcome_2__c == null || objNeedsAssesment.Rec_LEHS_Outcome_2__c == '')
          {
          objNeedsAssesment.Rec_LEHS_Outcome_2__c= 'Not Presented';
          }
          if(objNeedsAssesment.Rec_LECF_Outcome_1__c == null || objNeedsAssesment.Rec_LECF_Outcome_1__c == '')
          {
          objNeedsAssesment.Rec_LECF_Outcome_1__c= 'Not Presented';
          }
          if(objNeedsAssesment.Rec_LECF_Outcome_2__c == null || objNeedsAssesment.Rec_LECF_Outcome_2__c == '')
          {
          objNeedsAssesment.Rec_LECF_Outcome_2__c= 'Not Presented';
          }
          if(objNeedsAssesment.Rec_LECF_Outcome_3__c == null || objNeedsAssesment.Rec_LECF_Outcome_3__c == '')
          {
          objNeedsAssesment.Rec_LECF_Outcome_3__c= 'Not Presented';
          }
          if(objNeedsAssesment.Rec_LECF_Outcome_4__c == null || objNeedsAssesment.Rec_LECF_Outcome_4__c == '')
          {
          objNeedsAssesment.Rec_LECF_Outcome_4__c= 'Not Presented';
          }
          if(objNeedsAssesment.REC_LEMP_Outcome_1__c == null || objNeedsAssesment.REC_LEMP_Outcome_1__c == '')
          {
          objNeedsAssesment.REC_LEMP_Outcome_1__c= 'Not Presented';
          }
          if(objNeedsAssesment.REC_LEMP_Outcome_2__c == null || objNeedsAssesment.REC_LEMP_Outcome_2__c == '')
          {
          objNeedsAssesment.REC_LEMP_Outcome_2__c= 'Not Presented';
          }
          if(objNeedsAssesment.REC_LEMP_Outcome_3__c == null || objNeedsAssesment.REC_LEMP_Outcome_3__c == '')
          {
          objNeedsAssesment.REC_LEMP_Outcome_3__c= 'Not Presented';
          }
          if(objNeedsAssesment.REC_LEMP_Outcome_4__c == null || objNeedsAssesment.REC_LEMP_Outcome_4__c == '')
          {
          objNeedsAssesment.REC_LEMP_Outcome_4__c= 'Not Presented';
          }
          if(objNeedsAssesment.REC_LEMP_Outcome_5__c == null || objNeedsAssesment.REC_LEMP_Outcome_5__c == '')
          {
          objNeedsAssesment.REC_LEMP_Outcome_5__c= 'Not Presented';
          }
          if(objNeedsAssesment.REC_LEMP_Outcome_6__c == null || objNeedsAssesment.REC_LEMP_Outcome_6__c == '')
          {
          objNeedsAssesment.REC_LEMP_Outcome_6__c= 'Not Presented';
          }
          if(objNeedsAssesment.REC_LEMP_Outcome_7__c == null || objNeedsAssesment.REC_LEMP_Outcome_7__c == '')
          {
          objNeedsAssesment.REC_LEMP_Outcome_7__c= 'Not Presented';
          }
          if(objNeedsAssesment.REC_LEMP_Outcome_8__c == null || objNeedsAssesment.REC_LEMP_Outcome_8__c == '')
          {
          objNeedsAssesment.REC_LEMP_Outcome_8__c= 'Not Presented';
          }
          if(objNeedsAssesment.REC_LEPT_Outcome_1__c == null || objNeedsAssesment.REC_LEPT_Outcome_1__c == '')
          {
          objNeedsAssesment.REC_LEPT_Outcome_1__c= 'Not Presented';
          }
          if(objNeedsAssesment.REC_LEMD_Outcome_3__c == null || objNeedsAssesment.REC_LEMD_Outcome_3__c == '')
          {
          objNeedsAssesment.REC_LEMD_Outcome_3__c= 'Not Presented';
          }
          if(objNeedsAssesment.REC_LEMQ_Outcome_1__c == null || objNeedsAssesment.REC_LEMQ_Outcome_1__c == '')
          {
          objNeedsAssesment.REC_LEMQ_Outcome_1__c= 'Not Presented';
          }     
          
          if(objNeedsAssesment.Id == null)
          {
          	objNeedsAssesment.Member__c = accountid;
		  }
			upsert  objNeedsAssesment;
			   
        }
       
    	return FetchNeedAssessmentData(accountid);
    }
    
    @AuraEnabled
	public static NeedAssessmentLightningModel changeoptout(Boolean optout, String Accountid)
	{		     
		account acc;
          Needs_Assesment__c objNeedsAssessment;
          acc = [select id,NA_Opt_Out__c,NA_Opt_Out_Date__c 
    	  			from account where id =: Accountid limit 1];    	  
   	                     
		acc.NA_Opt_Out_Date__c = system.today().adddays(365);
		acc.NA_Opt_Out__c = optOut;
				
    	update acc;		
    	
    	return FetchNeedAssessmentData(Accountid);
	}
	
	
    
	public static string GetTabPaelColor(set<string> listColors)
	{
		
		 string radioColor = GetLowestColor(listColors);
		    
		 string URLButton = GetResourceURL(radioColor);
		 
		 return URLButton;
	}
	
	
	public static string GetTabColor(date Updated_On, boolean Complete, integer DuePeriod, boolean Opt_Out)
	{
	
		string tabClass = '';
		
	    if (Opt_Out)
	    {
	        tabClass = 'optOutTab';
	    }
	    else if(Updated_On == null)
		{
			tabClass = 'expiredTab';
		}
	    else if (Complete && Updated_On != null && Updated_On + DuePeriod < Date.today())
	    {
	        tabClass = 'expiredTab';
	    }
	    else if (Complete)
	    {
	        tabClass = 'completeTab';
	    }
	    else if (!Complete)
	    {
	        tabClass = 'partialTab';
	    }
	
	
	    return tabClass;
	
	}
	
    public static string GetTabColor(datetime Updated_On, boolean Complete, integer DuePeriod, boolean Opt_Out)
    {
	
	
        string tabClass = '';
	
        if (Opt_Out)
        {
            tabClass = 'optOutTab';
        }
        else if(Updated_On == null)
        {
            tabClass = 'expiredTab';
        }
        else if (Complete && Updated_On != null && Updated_On + DuePeriod < Date.today())
        {
            tabClass = 'expiredTab';
        }
        else if (Complete)
        {
            tabClass = 'completeTab';
        }
        else if (!Complete)
        {
            tabClass = 'partialTab';
        }
    
    
        return tabClass;
    
    }
    
    
    
	private static string GetLowestColor(Set<string> listColors)
	{
	    if (listColors.contains(''))
	    {
	        return 'naButtonGray';
	    }
	    if (listColors.contains('optOutTab'))
	    {
	        return 'naButtonGray';
	    }
	    if (listColors.contains('expiredTab'))
	    {
	        return 'naButtonRed';
	    }
	    if (listColors.contains('partialTab'))
	    {
	        return 'naButtonYellow';
	    }
	    if (listColors.contains('completeTab'))
	    {
	        return 'naButtonGreen';
	    }
	    return '';
	}
	
	
	private static String GetResourceURL(String resourceName)
    {

        // Fetching the resource
        List<StaticResource> resourceList = [SELECT Name, NamespacePrefix, SystemModStamp FROM StaticResource WHERE Name = :resourceName];

        // Checking if the result is returned or not
        if (resourceList.size() == 1)
        {

            // Getting namespace
            String namespace = resourceList[0].NamespacePrefix;
               // Resource URL
               return '/resource/' + resourceList[0].SystemModStamp.getTime() + '/' + (namespace != null && namespace != '' ? namespace + '__' : '') + resourceName; 
            }
            else return '';
        }
     
}