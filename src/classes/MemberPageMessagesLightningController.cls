public class MemberPageMessagesLightningController {
	
    
    
   
    
   
    
    
    private static boolean IsShowData()
    {
    	
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
			  
        	boolean ShowData = false;
  		
  		
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
    
    
    private static boolean IsExpired(string actId, Account acc)
    {
    	Needs_Assesment__c objNeedsAssessment;
    	//query Need assesment to feed the NeedAssessment method that needs to be called in the controller
        List<Needs_Assesment__c> na = [select id,LEEM_Last_Updated_On__c, LEMQ_Last_Updated_On__c,LEOM_Last_Updated_On__c,LEAV_Last_Updated_On__c ,LESF_Last_Updated_On__c, LESB_Last_Updated_On__c, LEMD_Last_Updated_On__c, LECP_Last_Updated_On__c, LEHS_Last_Updated_On__c, LEOL_Last_Updated_On__c, LECF_Last_Updated_On__c, LEWS_Last_Updated_On__c, LEMP_Last_Updated_On__c, LEPT_Last_Updated_On__c  from Needs_Assesment__c where Member__c =: actId limit 1];
        if (na.size() > 0)
        {
            objNeedsAssessment = na[0];
        }
        
       boolean Expired = false;
        if (objNeedsAssessment == null)
        {
        	Expired= true;
        	return Expired;
        }
        if(GetTabStatus(objNeedsAssessment.LEHS_Last_Updated_On__c,acc.NA_LEHS_Complete__c, 'Housing', acc ) && 
        GetTabStatus(objNeedsAssessment.LEOM_Last_Updated_On__c,acc.NA_LEOM_Complete__c, 'NA Other Milestones', acc)
        	&& GetTabStatus(objNeedsAssessment.LEWS_Last_Updated_On__c,acc.NA_LEWS_Complete__c, 'Withdrawal', acc) 
        	&& GetTabStatus(objNeedsAssessment.LEMP_Last_Updated_On__c,acc.NA_LEMP_Complete__c, 'Move Your Money', acc)
        	&& GetTabStatus(objNeedsAssessment.LECF_Last_Updated_On__c,acc.NA_LECF_Complete__c, 'Current Feedback', acc) 
        	&& GetTabStatus(objNeedsAssessment.LESF_Last_Updated_On__c,acc.NA_LESF_Complete__c, 'ATM Network', acc)
        	&& GetTabStatusTime(objNeedsAssessment.LESB_Last_Updated_On__c,acc.NA_LESB_Complete__c, 'Shared Branching', acc) 
        	&& GetTabStatus(objNeedsAssessment.LECP_Last_Updated_On__c,acc.NA_LECP_Complete__c, 'Contact Preference', acc)
        	&& GetTabStatus(objNeedsAssessment.LEPT_Last_Updated_On__c,acc.NA_LEPT_Complete__c, 'PrimaryTransaction', acc) 
        	&& GetTabStatus(objNeedsAssessment.LEMD_Last_Updated_On__c,acc.NA_LEMD_Complete__c, 'MakingDeposits', acc)
        	&& GetTabStatus(objNeedsAssessment.LEOL_Last_Updated_On__c,acc.NA_LEOL_Complete__c, 'Other Loan', acc) 
        	&& GetTabStatusTime(objNeedsAssessment.LEAV_Last_Updated_On__c,acc.NA_LEAV_Complete__c, 'Auto Vehicle', acc)
			&& GetTabStatus(objNeedsAssessment.LEEM_Last_Updated_On__c,acc.NA_LEEM_Complete__c, 'Earn More', acc) 
			&& GetTabStatusTime(objNeedsAssessment.LEMQ_Last_Updated_On__c,acc.NA_LEMQ_Complete__c, 'Extend Benifits', acc)
        
        	 )
        {
        	Expired = true; 
        }
        
        return Expired;
    }
    
    
    public static boolean GetTabStatus(Date updatedDate, boolean complete, string due, account acc)
	{
		GracePeriod__c dataHosuing = GracePeriod__c.getValues(due);
		
       integer HousingDuePeriod = integer.valueOf(dataHosuing.ExpiresInDays__c);
		
	    boolean TabExpired = false;
		if (acc.NA_Opt_Out__c)
	    {
	        TabExpired = false;
	    }
		else if(updatedDate == null)
		{
			TabExpired = true;
		}
	    
	    else if (complete && updatedDate != null && updatedDate + HousingDuePeriod < Date.today())
	    {
	        TabExpired = true;
	    }
	 	system.debug('due---' + due);
	 	system.debug('TabExpired---' + TabExpired);
		return TabExpired;

	}
	
	public static boolean GetTabStatusTime(DateTime updatedDate, boolean complete, string due, Account acc)
	{
		GracePeriod__c dataHosuing = GracePeriod__c.getValues(due);
      integer  HousingDuePeriod = integer.valueOf(dataHosuing.ExpiresInDays__c);
		
	    boolean TabExpired = false;
		if (acc.NA_Opt_Out__c)
	    {
	        TabExpired = false;
	    }
		else if(updatedDate == null)
		{
			TabExpired = true;
		}
	    
	    else if (complete && updatedDate != null && updatedDate + HousingDuePeriod < Date.today())
	    {
	        TabExpired = true;
	    }
	 
		return TabExpired;	    

	}
	
	@AuraEnabled
	public static Map<string, string> accountDetails(string actId)
	{
			list<Person_Account__c> paList = new list<Person_Account__c>();
        	paList = [SELECT Id,Account_Number__c,Account_Number__r.RecType__c, Account_Number__r.Name FROM Person_Account__c WHERE PersonID__c =:actId and TypeTranslate__c in ('0001/Joint Member','0000/Primary')];
        	List<Account>	account = [select Id,RecordType.name,BIRTH_DATE__pc,NA_Complete__c,Last_NA_LEHS__c, Last_NA_LEOM__c, NA_LEHS_Complete__c, NA_LEWS_Complete__c, NA_Opt_Out_Updated__c,
                                     NA_LEMP_Complete__c, NA_LECF_Complete__c, NA_LEOM_Complete__c, NA_Opt_Out_Date__c, NA_LESF_Complete__c, NA_LESB_Complete__c,
                                     NA_LEHS_Expired__c, NA_LEOM_Expired__c, NA_Eligibility__c, NA_Opt_Out__c, NA_LECP_Complete__c, NA_LEPT_Complete__c, NA_LEMD_Complete__c,
                                     NA_LEOL_Complete__c,NA_LEAV_Complete__c,NA_LEEM_Complete__c,NA_LEMQ_Complete__c, Member_Verification_OTP_Invalid_Attempt__c from Account where id =: actId limit 1];
        	Map<string, string> m = new Map<string, string>();
        	
        	
        	Boolean PrimaryAccountWithAtleastoneTrust = false;
        	///////////////////////
        	
        	
    
    	 
        
        PrimaryAccountWithAtleastoneTrust = false;
        List<Person_Account__c> paList1 =     [SELECT Id, Account_Number__c, Account_Number__r.RecType__c, Relationship__c, Account_Number__r.TypeTranslate__c, TypeTranslate__c,
                  Account_Number__r.Name FROM Person_Account__c WHERE PersonID__c =: actId and Account_Number__r.RecType__c = 'ACCT'
                                         and(Account_Number__r.TypeTranslate__c != '2-TRUST' or Account_Number__r.TYPE__c != 2) and TypeTranslate__c like '%PRIMARY%' ];


        if (paList1.size() > 0)
        {
            PrimaryAccountWithAtleastoneTrust = true;           
        }
        
		
		system.debug('Before condition--0');
		boolean MemberAbove18 = true;
		if(account[0].BIRTH_DATE__pc != null)
		{
			
			MemberAbove18 =	account[0].BIRTH_DATE__pc.addyears(18) < System.Today();
		}
		boolean IsShowData = IsShowData();
        boolean IsExpired = IsExpired(actId, account[0]);
		m.put('Memberisunder18',string.valueof( MemberAbove18 == false));
		m.put('Memberisnotprimary',string.valueof(MemberAbove18 && PrimaryAccountWithAtleastoneTrust == false));
		system.debug('Memberhaspartiallycompleted condition--1');
		m.put('Memberhaspartiallycompleted', string.valueof(MemberAbove18 == TRUE && PrimaryAccountWithAtleastoneTrust == TRUE && account[0].NA_Opt_Out__c == FALSE && IsExpired == FALSE && account[0].NA_Complete__c == FALSE));
		system.debug('Before condition--1');
		m.put('AMemberAssessmentisdue', string.valueof(MemberAbove18 == TRUE && PrimaryAccountWithAtleastoneTrust == TRUE && account[0].NA_Opt_Out__c == FALSE && IsExpired == True));
		system.debug('Before condition--2');
		m.put('MemberOptOut', string.valueof(account[0].NA_Opt_Out_Date__c != NULL && account[0].NA_Opt_Out_Date__c > system.today()));
        system.debug('Before condition--3');
        	system.debug('account[0].NA_Opt_Out_Date__c' + account[0].NA_Opt_Out_Date__c);
        if(account[0].NA_Opt_Out_Date__c != null)
        {
        	Datetime dtTIme = datetime.newInstance( account[0].NA_Opt_Out_Date__c.year(),account[0].NA_Opt_Out_Date__c.month(),account[0].NA_Opt_Out_Date__c.day(), 0,0,0);
        	
        	string Opt_Out_Date = dtTIme.format('MMMM d ,  yyyy');
        	m.put('Opt_Out_Date',Opt_Out_Date);
        }
        else
        {
        	m.put('Opt_Out_Date','');
        }
        system.debug('Before condition--4');	
        m.put('ShowData',string.valueof(IsShowData));
        
      
        	
        	
        	system.debug('paList...'+paList);
		    set<String> accountNumberSet = new set<String>();
		    set<Id> accIdset = new set<Id>();
		    set<String> acctypeSet = new set<String>();
		    for(Person_Account__c var: paList){
		    	
		        accountNumberSet.add(var.Account_Number__r.Name);
		        acctypeSet.add(var.Account_Number__r.RecType__c);
		        accIdSet.add(var.Account_Number__c);
		    }
		    system.debug('acctypeSet ---  '  + acctypeSet);
		    list<Account_Details__c> accList = new list<Account_Details__c>();
		  boolean  Highpotentialflag = false;
		boolean	Highvalueflag = false;
		    if(acctypeSet.contains('ACCT')){
		        accList = [SELECT Id,Name,RecType__c,High_Value_Flag__c	FROM Account_Details__c WHERE Name IN:accountNumberSet AND High_Value_Flag__c  != null ORDER BY High_Value_Flag__c DESC];
		    	 if(!accList.isEmpty() && accList.size() > 0 ){
    	 		 	
    	 		 		system.debug('accList[0].High_Value_Flag__c ---  '  + accList[0].High_Value_Flag__c );
    	 		 		
    	 		 		for (Account_Details__c acc : accList) {

						  if(acc.High_Value_Flag__c == 1)
						  {
						  	Highpotentialflag = false;
    	 		 			Highvalueflag = true;
    	 		 			break;
						  }
						  else if(acc.High_Value_Flag__c == 2){
	    	 		 			Highpotentialflag = true;
	    	 		 			Highvalueflag = false;
    	 		 		  }						
						}	
    	 		 					    	 				    	 						    	 	
		    	 }
		    
		    }
		   system.debug('accList ---  '  + accList);
		   
		   m.put('Highpotentialflag',string.valueof(Highpotentialflag));
		   m.put('Highvalueflag',string.valueof(Highvalueflag));
		   
		   if(account[0].Member_Verification_OTP_Invalid_Attempt__c == null)
            {
            	 m.put('ShowOTPInvalidAttempt','false');
            	 m.put('OTPNextAttemptValidAfterHours','0');
            }
		   else
		   {
			   Long milliseconds = System.Now().getTime() - account[0].Member_Verification_OTP_Invalid_Attempt__c.getTime() ;
	           Long hours = milliseconds / (1000 * 60 * 60);
	           OTPSettings__c data = OTPSettings__c.getValues('Member Verification');
	           Integer OTPExpiresAfterSeconds = integer.valueOf(data.OTPExpirationSeconds__c);
	            
	            system.debug('hours---' + hours);            
	            Integer OTPNextAttemptValidAfterHours = integer.valueOf(data.OTPNextAttemptValidAfterHours__c);
	            system.debug('OTPNextAttemptValidAfterHours---' + OTPNextAttemptValidAfterHours);
	            if(OTPNextAttemptValidAfterHours > hours){
	                m.put('ShowOTPInvalidAttempt','true');
	                m.put('OTPNextAttemptValidAfterHours', string.valueOf(OTPNextAttemptValidAfterHours));
	            }
	            else
	            {
	            	m.put('ShowOTPInvalidAttempt','false');
	            	m.put('OTPNextAttemptValidAfterHours','0');
	            }
		   }
		   
		   boolean IsShowOTPButton = showData_OTP();
		   m.put('IsShowOTPButton',string.valueOf(IsShowOTPButton));
		    m.put('RecordTypeName',account[0].RecordType.name);
		   return m;
       }
       
       private static boolean showData_OTP(){
   
    	
    		boolean showData1 = false;
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
			  
        	showData1 = false;
  		
  		
		list<GroupMember> listNamegroup =	[select group.developerName from GroupMember where UserOrGroupId in: results];
		set<string> listName = new set<string>();
			for(GroupMember i :listNamegroup)
			{
				
					listName.add(i.group.developerName );
				
			}
			
			system.debug('########' + listName);
		   
		      if (listName.contains('OTP_Auth')) {
		           showData1 = true;
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
		   
		      if (groupNames.contains('OTP_Auth')) {
		           showData1 = true;
		      }	     
		      
		    return showData1;   	
    }
}