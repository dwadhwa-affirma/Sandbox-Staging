public with sharing class PersonAccountTriggerHandler {

  public static void createCase(map<Id,Person_Account__c> newMap){
     string optyCase = 'test';   
    list<Person_Account__c> paList = new list<Person_Account__c>();
    list<Person_Account__c> OnboardPAList = new list<Person_Account__c>();
	 map<Id,Person_Account__c> PrimaryPAMap = new map<Id,Person_Account__c>();
     list<Person_Account__c> paListOutbound = new list<Person_Account__c>();   
    
	set<Id> personIds = new set<Id>();
    Set<Id> PersonAccountIdSet = new Set<Id>();
    set<Id> accDetailIds = new set<Id>();
    map<Id,Account> personMap = new map<Id,Account>();
    map<Id,Account_Details__c> accDetailMap = new map<Id,Account_Details__c>();
    
    List<String> MemberNumberList = new List<String>();
        
    list<Case> caseList = new list<Case>();
   // list<opportunity> opptyList = new list<opportunity>();
    //  map<double,Id> userMap = new map<double,Id>();
    map<String,Id> userMap1 = new map<String,Id>();
    map<String,Id> userAliasMap = new map<String,Id>();
    map<String,Id> eBranchUserAliasMap = new map<String,Id>();
    map<String,Id> eBranchUserMap = new map<String,Id>();
      
    BusinessHours bh = [SELECT Id FROM BusinessHours WHERE Name = 'Default' and isActive = true];
        
    for(Person_Account__c pa: newMap.values()) {
      if(pa.Name_Type__c == 0){
        //CRM-1090 only add person whose open date is within 7 days
        if ((pa.Open_Date__c != null && pa.Open_Date__c.daysBetween(date.today()) <= 7) ) {
          System.debug('adding person account with open date..' + pa.Open_Date__c);
          System.debug('adding person account with Account ID..' + pa.AccountID__c);
            paList.add(pa); 
            personIds.add(pa.PersonID__c);
            accDetailIds.add(pa.Account_Number__c);
            PersonAccountIdSet.add(pa.id);
        } else    {
          System.debug('Not adding person account with open date..' + pa.Open_Date__c);
          System.debug('Not adding person account with Account ID..' + pa.AccountID__c);
        }                
      }
    }
       
    list<Account> personList = [SELECT Id,firstname, Lastname, PersonHomePhone, 
                                PersonEmail, Residential_Street__pc, Residential_City__pc, 
                                Residential_State__pc, Residential_Zipocde__pc FROM Account WHERE Id IN: personIds];
    Set<Id> perId = new Set<Id>();
    for(Account pl: personList){
      personMap.put(pl.Id, pl);
      perId.add(pl.Id);
    }
        
    list<Account_Details__c> accDetailList = [SELECT Id, name,Open_Date__c, Created_By_User__c,Created_At_Branch1__c, OnBoarded__c, Created_By_User_Text__c,
                                              Created_By_User_Alias__c,RecType__c, TypeTranslate__c FROM Account_Details__c
                                              WHERE Id IN: accDetailIds];
    for(Account_Details__c adl: accDetailList){
      accDetailMap.put(adl.Id, adl);
			MemberNumberList.add(adl.name);
    }

		system.debug('accDetailMap: '+accDetailMap);
		system.debug('PersonAccountIdSet: '+PersonAccountIdSet);
		system.debug('MemberNumberList: '+MemberNumberList);

    // Need to filter out Joint Member's ACCT records
   	OnboardPAList = [SELECT AccountID__c,Account_Number__c,Account_Type__c,Id,Name,PersonAccount__c,PersonID__c,Person_ID_Number__c,
                     Relationship__c, Account_Number__r.OnBoarded__c, Account_Number__r.RecType__c, Account_Number__r.Created_At_Branch1__c FROM Person_Account__c WHERE
                     Account_Number__r.OnBoarded__c = true and Account_Number__r.RecType__c = 'ACCT' and Id IN : PersonAccountIdSet];
		
		//--------------------------------------------------Creating a List and Map for the member account with "Loan" ----------------//
		List<Account_Details__c> MemAccList = [SELECT Id,name,ID1__c ,Open_Date__c, Created_By_User__c, OnBoarded__c,
                                               Created_By_User_Text__c, Created_By_User_Alias__c, RecType__c, TypeTranslate__c, Created_At_Branch1__c
                                               FROM Account_Details__c WHERE name IN: MemberNumberList and ID1__c like '%75%'];
		Map<String,Account_Details__c> MemAccLoanList = new Map<String,Account_Details__c>();
		for(Account_Details__c ac : MemAccList){
			MemAccLoanList.put(ac.name,ac);
		}
		system.debug('MemAccLoanList: '+MemAccLoanList);
		System.debug('MemAccList: '+MemAccList);

		Set<Id> PersonId = new Set<Id>();
	if(OnboardPAList.size() > 0)	{  
      for(Person_Account__c pa : OnboardPAList)  {
       	PersonId.add(pa.PersonID__c);
      }
	        
      if(PersonId.size() > 0) {
       	List<Person_Account__c> PrimaryPAList = [Select id, Typetranslate__c,PersonID__c from Person_Account__c where 
                                                 Typetranslate__c like '%Primary%' and PersonID__c IN : PersonId and Id not IN : PersonAccountIdSet];
       	for(Person_Account__c pa: PrimaryPAList)	{
	      	PrimaryPAMap.put(pa.PersonID__c, pa);
	      }
			}
		} 
		system.debug('PrimaryPAMap: '+PrimaryPAMap);
		List<Contact> con = [Select Id, Name, AccountId from Contact where Contact.AccountId =:perId];
		Map<Id,Id> conMap = new Map<Id,Id>();
		for(Contact ct : con){
			conMap.put(ct.AccountId, ct.Id);
		}

		Id CallCenterSolarOnboardingQueueId = [SELECT Id FROM Group WHERE Type='Queue' AND DeveloperName= 'Call_Center_Solar_Onboarding_Queue'].Id;
    // Id queueGroupId = [SELECT Id FROM Group WHERE Type='Queue' AND Name= 'Operations-Memberships Queue'].Id;
    Id queueGroupId = [SELECT Id FROM Group WHERE Type='Queue' AND DeveloperName= 'eBranch_Queue'].Id;
        
    //list<User> userList = [SELECT Id, Name, Alias, IsActive FROM User where IsActive = true];
        
    list<User> userList = [SELECT Id, Name, Alias, IsActive FROM User
      where (Profile.Name !='Messaging center Customers') and (isActive = True)];
        
    /*---------------------- CRM-1687: eBranch Onboarding Queue ----------------------------------*/
    Id onboardingQueueGroupId = [SELECT Id FROM Group WHERE Type='Queue' AND DeveloperName= 'eBranch_Onboarding_Queue'].Id;
    
      String outboundQueue = [SELECT Name FROM Group WHERE Type='Queue' AND DeveloperName= 'Outbound_Connection_Queue'].Name;
      Id outboundQueueId = [SELECT Id FROM Group WHERE Type='Queue' AND DeveloperName= 'Outbound_Connection_Queue'].Id;
      String CallCenterSolarOnboardingQueue = [SELECT Name FROM Group WHERE Type='Queue' AND DeveloperName= 'Call_Center_Solar_Onboarding_Queue'].Name;
      
      list<User> eBranchUserList = [SELECT Id, Name, Alias, IsActive FROM User
                                where (Profile.Name ='eBranch') and (isActive = True)];
        
    List<Episys_User__c> episysUserList = [select id,Name, Alias__c, Episys_ID__c from Episys_User__c];
    map<decimal,Episys_User__c> episysUserMap = new map<decimal,Episys_User__c>();
    for(User u: userList){
      userMap1.put(u.Name.toupperCase(), u.Id);
      userAliasMap.put(u.Alias.toupperCase(), u.Id);
    } 
        
    for(User u: eBranchUserList){
      eBranchUserMap.put(u.Name.toupperCase(), u.Id);
      eBranchUserAliasMap.put(u.Alias.toupperCase(), u.Id);
    }
        
    for(Episys_User__c u: episysUserList){
      episysUserMap.put(u.Episys_ID__c, u);
    }
        
    // THIS MAKES NO SENSE TO ME, it's the equivilent of || TRUE - COMMENTING OUT - GS 12/3/211
    // list<User> userList1 = [SELECT Id, Name, Alias, IsActive FROM User where IsActive = false];
    // Set<Id> uList = new Set<Id>();
    // for(User u : userList1){
    //   uList.add(u.Id);
    // } 
    // 
    // IT WAS USED BELOW THUS: 
    // if(userAliasMap.get(accDetailMap.get(var.Account_Number__c).Created_By_User_Alias__c) == null ||
		//				accDetailMap.get(var.Account_Number__c).Created_By_User__c == NULL || uList != NULL){

    Boolean ownerSet;
    Account_Details__c accDetailRec;
    User userAliasRec, eBranchUserAliasRec;
    Episys_User__c episysUserRec;
    String eBranchUserId,userAliasId;

    for(Person_Account__c var: paList){
     	if(PrimaryPAMap.containsKey(var.PersonID__c)== true) {
     		System.debug('Donot create case for Primary');
     	}
     	else if(PrimaryPAMap.containsKey(var.PersonID__c)== false) {
     		system.debug('create case for Ben/Joint');

        if(accDetailMap.containsKey(var.Account_Number__c)) {
          accDetailRec = accDetailMap.get(var.Account_Number__c);
          if(accDetailRec.OnBoarded__c) {
     		    Case c = new Case();
                
                 Person_Account__c paOutbound = new Person_Account__c();
		        c.RecordTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get('Onboarding').getRecordTypeId();
		        c.Primary_Category__c = 'Account Maintenance';
		        c.Secondary_Category__c = 'OnBoarding';
		        c.Tertiary_Category__c = 'None';
		        c.Status = 'Open';
		        c.Account_Number__c = var.Account_Number__c;
		        c.AccountId = var.PersonID__c;
		        if(c.ContactId == NULL) {
		          c.ContactId = conMap.get(var.PersonID__c);
		        }
		        c.First_Name__c = personMap.get(var.PersonID__c).firstname;
		        c.Last_Name__c = personMap.get(var.PersonID__c).lastname;
		        c.Phone_Number__c = personMap.get(var.PersonID__c).PersonHomePhone;
		        c.Email_Address__c = personMap.get(var.PersonID__c).PersonEmail;
		        c.Street_Address_1__c = personMap.get(var.PersonID__c).Residential_Street__pc;
		        c.City__c = personMap.get(var.PersonID__c).Residential_City__pc;
		        c.State__c = personMap.get(var.PersonID__c).Residential_State__pc;
		        c.Zip_Code__c = personMap.get(var.PersonID__c).Residential_Zipocde__pc;
		        c.Membership_account_created_date__c = accDetailMap.get(var.Account_Number__c).OPEN_DATE__c;
		        
		        system.debug('accdetailmap ..' + accDetailMap);
		        system.debug('var.accounnumber ' + var.Account_Number__c);
            /*---------------------- CRM-1687: eBranch Onboarding Queue ----------------------------------*/
  				  system.debug('CallCenterSolarOnboardingQueueId: '+CallCenterSolarOnboardingQueueId);

            if(MemAccLoanList.size() > 0 && (MemAccLoanList.get(accDetailMap.get(var.Account_Number__c).name).ID1__c).startsWith('75')){
              system.debug('Inside assigning Call Center Solar Onboarding Queue');
             
                paOutbound.Oppty_Owner__c = CallCenterSolarOnboardingQueue;
                paOutbound.id= var.id;
              
                optyCase = 'opty';
                system.debug('CallCenterSolarOnboardingQueueId: '+'opty');
            }
            else if(episysUserMap.get((accDetailMap.get(var.Account_Number__c).Created_By_User__c)).Alias__c != null
              && eBranchUserAliasMap.get(episysUserMap.get((accDetailMap.get(var.Account_Number__c).Created_By_User__c)).Alias__c.toupperCase()) != null){
              //c.OwnerId = onboardingQueueGroupId;
               
                  //if(accDetailRec.Created_At_Branch1__c=='299' || accDetailRec.Created_At_Branch1__c=='99'){
                paOutbound.Oppty_Owner__c = outboundQueue;
                paOutbound.id= var.id;
              
                optyCase = 'opty';
                     // }
            }
            else if(episysUserMap.get(accDetailMap.get(var.Account_Number__c).Created_By_User__c).Episys_ID__c == 807){
              system.debug('Inside assigning eBranch - Membership onboarding queue for 807');
              //c.OwnerId = onboardingQueueGroupId;
               
               paOutbound.Oppty_Owner__c = outboundQueue;
                paOutbound.id= var.id;
               optyCase = 'opty';
            }                         
            else if(userAliasMap.get(accDetailMap.get(var.Account_Number__c).Created_By_User_Alias__c)!= null){
              system.debug('###Inside  assigning owner' + userAliasMap.get(accDetailMap.get(var.Account_Number__c).Created_By_User_Alias__c));
              c.OwnerId = userAliasMap.get((accDetailMap.get(var.Account_Number__c).Created_By_User_Alias__c).toupperCase());
               
              optyCase = 'case';
              
            }
            else if(userAliasMap.get(accDetailMap.get(var.Account_Number__c).Created_By_User_Alias__c) == null ||
              accDetailMap.get(var.Account_Number__c).Created_By_User__c == NULL){
              system.debug('Inside assigning eBranch queue');
             // c.OwnerId = queueGroupId;
             
               paOutbound.Oppty_Owner__c = outboundQueue;
                  paOutbound.id = var.id;
               optyCase = 'opty';
            }
            
              if(optyCase=='opty'){
                  paListOutbound.add(paOutbound);
              }
              else if(optyCase=='case') {
                  caseList.add(c);
              }
            //caseList.add(c);
			//opptyList.add(o); 
             
          }
         	
	     	}
     	}
	  }            
        
    try{
        
        if(caseList.size()>0){
      insert caseList;
      System.debug('Case is:::'+caseList);
            }
        if(paListOutbound.size()>0){
         update paListOutbound;
      System.debug('opty is:::'+paListOutbound);
        }
    }catch(Exception e){
      System.debug('An error was encountered :'+e);
    }
    
    for(Account_Details__c ad : accDetailList){
      ad.OnBoarded__c = false;
    }
    update accDetailList;
  }
  
  public static void UpdateAccountBranch(List<Person_Account__c> personAcc){
  	set<Id> accDetailIds = new set<Id>();
   	set<Id> personIds = new set<Id>();
   	List<Account_Details__c> accDetailMap = new List<Account_Details__c>();
   	list<Person_Account__c> paList = new list<Person_Account__c>();
   	Map<Id,string> accountMemberBranch = new Map<Id,string>();
   	Map<string,string> listMemberBranch = new Map<string,string>();
   	
   	for(Person_Account__c pa: personAcc){	
   		paList.add(pa);
   		accDetailIds.add(pa.Account_Number__c);
   		personIds.add(pa.PersonID__c);    			
   	}
    	
   	accDetailMap = [select id,RecType__c,Current_Branch1__c,Current_Branch__c from Account_Details__c where ID in : accDetailIds];
    	
   	for(Account_Details__c acc : accDetailMap){
     	if(acc.RecType__C == 'ACCT'){
     		accountMemberBranch.put(acc.id,acc.Current_Branch1__c);
     	}
  	} 
    	
   	for(Person_Account__c pa: personAcc){	
  		string branch = accountMemberBranch.get(pa.Account_Number__c);
    	listMemberBranch.put(pa.PersonId__c, branch);
   	}
    	
   	list<Account> personList = [SELECT Id, Member_Branch__c FROM Account WHERE Id IN: personIds];
   	List<Valid_Branch__c> branchList = [select id,Name from Valid_Branch__c];
		Set<String> existingBranch = new Set<String>();
	 	for(Account acc: personList) {
			string memberBranch = listMemberBranch.get(acc.id);
			existingBranch.add(listMemberBranch.get(acc.id));
			for(Integer i=0;i<branchList.size();i++) {
				String branchName = branchList[i].Name;
				if (existingBranch.contains(branchName)) {
       		acc.Member_Branch__c = memberBranch;
     		}
    	}		
		}
		update personList;
  }
    
  public static void UpdateAccountEpisysUser(List<Person_Account__c> personAcc){
   	
   	set<Id> accDetailIds = new set<Id>();
   	set<Id> personIds = new set<Id>();
   	List<Account_Details__c> accDetailMap = new List<Account_Details__c>();
   	list<Person_Account__c> paList = new list<Person_Account__c>();
   	Map<Id,string> accountMemberEpisysUser = new Map<Id,string>();
   	Map<string,string> listMemberEpisysUser = new Map<string,string>();
    	
   	for(Person_Account__c pa: personAcc){	
   		paList.add(pa);
   		accDetailIds.add(pa.Account_Number__c);
   		personIds.add(pa.PersonID__c);    			
   	}
    	
   	accDetailMap = [select id,Created_By_User_Alias__c, RecType__c from Account_Details__c where ID in : accDetailIds];
    	
   	for(Account_Details__c acc : accDetailMap){
     	if(acc.RecType__C == 'ACCT'){
     		accountMemberEpisysUser.put(acc.id,acc.Created_By_User_Alias__c);
     	}
   	} 
    	
   	for(Person_Account__c pa: personAcc){	
   		string episysUser = accountMemberEpisysUser.get(pa.Account_Number__c);
    	listMemberEpisysUser.put(pa.PersonId__c, episysUser);
   	}
      	
   	list<Account> personList = [SELECT Id, Created_By_Episys_User_Alias__c FROM Account WHERE Id IN: personIds];
   	List<Episys_User__c> episysUserList = [select id,Name, Alias__c from Episys_User__c];
		Set<String> existingUsers = new Set<String>();
	  if(personList.size() > 0)	{
    	for(Account acc: personList) {
  			string memberUser = listMemberEpisysUser.get(acc.id);
	  		existingUsers.add(listMemberEpisysUser.get(acc.id));
		  	if(episysUserList.size() > 0)	{
				  for(Integer i=0;i<episysUserList.size();i++)	{
					  String userAlias = episysUserList[i].Alias__c;
					  if (existingUsers.contains(userAlias)) {
        		  acc.Created_By_Episys_User_Alias__c = memberUser;
	     		  }
	    	  }
			  }		
		  }
		  update personList;
    }
  }	

}