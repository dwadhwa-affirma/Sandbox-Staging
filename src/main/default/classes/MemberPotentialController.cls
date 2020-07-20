public class MemberPotentialController {
	 public string accId;
	 public list<Account_Details__c> accList{get;set;}
	 public boolean Highpotentialflag {get;set;}
	 public boolean Highvalueflag {get;set;}
	     public integer OTPExpiresAfterSeconds {get;set;}
    public integer OTPNextAttemptValidAfterHours {get;set;}
    public Account acc {get;set;}
    public string IsIneligibleLocal {get;set;}
    
	public MemberPotentialController(ApexPages.StandardController controller){
		accId = System.currentPageReference().getParameters().get('Id');     
		system.debug('account say person id....'+accID);		
		if(accId != NULL || accId != ''){
            personAccounts(accId);
            
        }      	
	}
	public void personAccounts(string accId){
        list<Person_Account__c> paList = new list<Person_Account__c>();
        paList = [SELECT Id,Account_Number__c,Account_Number__r.RecType__c, Account_Number__r.Name FROM Person_Account__c WHERE PersonID__c =:accId and TypeTranslate__c in ('0001/Joint Member','0000/Primary')];
        system.debug('paList...'+paList);		
        accountDetails(paList); 
    }  
    
    public boolean showData_OTP{
     get {
    	
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
    
    
    
     public void accountDetails(list<Person_Account__c> paList){
		    set<String> accountNumberSet = new set<String>();
		    set<Id> accIdset = new set<Id>();
		    set<String> acctypeSet = new set<String>();
		    for(Person_Account__c var: paList){
		    	
		        accountNumberSet.add(var.Account_Number__r.Name);
		        acctypeSet.add(var.Account_Number__r.RecType__c);
		        accIdSet.add(var.Account_Number__c);
		    }
		    system.debug('acctypeSet ---  '  + acctypeSet);
		    accList = new list<Account_Details__c>();
		    Highpotentialflag = false;
			Highvalueflag = false;
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
		   
       } 
       
       
        public string buttonClass{
        get
        {
            
            List<Account> listAccount; 
            if(acc == null)
            {
              listAccount = [select Id,Member_Verification_OTP_Invalid_Attempt__c,FirstName,LastName,PersonHomePhone,Mobile_Phone__pc,Work_Phone__pc,PersonEmail,Alternate_Email__pc from Account where ID =:accID ];
              if(listAccount.size() > 0)
              {
                acc = listAccount[0];
              }
            }
            if(acc == null || acc.Member_Verification_OTP_Invalid_Attempt__c == null)
            {
                return 'btn-primary';
            }
            Long milliseconds = System.Now().getTime() - acc.Member_Verification_OTP_Invalid_Attempt__c.getTime() ;
            Long hours = milliseconds / (1000 * 60 * 60);
            OTPSettings__c data = OTPSettings__c.getValues('Member Verification');
            OTPExpiresAfterSeconds = integer.valueOf(data.OTPExpirationSeconds__c);
            
            system.debug('hours---' + hours);
            system.debug('OTPNextAttemptValidAfterHours---' + OTPNextAttemptValidAfterHours);
            OTPNextAttemptValidAfterHours = integer.valueOf(data.OTPNextAttemptValidAfterHours__c);
            
            if(OTPNextAttemptValidAfterHours > hours){
                return 'btn-danger';
            }
            return 'btn-primary';
            
        }
    }
    
    
       
       
     
}