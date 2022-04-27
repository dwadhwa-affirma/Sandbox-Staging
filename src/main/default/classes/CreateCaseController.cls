global with sharing class CreateCaseController{
	public string csubject{ get; set; }

	public string cdescription{ get; set; }

	public Contact contact;
	public Account member;
	public Person_Account__c personaccount;
	public Account_Details__c accList;
	public Case cases;
	public string Category;
	public List<string> CategoryList;
	public string LoggedinUser = UserInfo.getUserId();
	public string contactid;

	public List<selectOption> AccountNames{ get; set; }

	public set<String> accountNumberSet{ get; set; }

	public string selectedAccount{ get; set; }

	public string caseid{ get; set; }

	public string primaryCategory{ get; set; }

	public string AccountNumber{ get; set; }

	public string BrandName{ get; set; }

	public string ImgName{ get; set; }

	public Integer messagecount{ get; set; }

	public string AccountId{ get; set; }

	public string Stylesheet{ get; set; }

	public string Sidebar{ get; set; }

	public string UserName{ get; set; }

	public string CopyRights{ get; set; }

	public string Brand_Help{ get; set; }

	public string Extension{ get; set; }

	public string Responsivecss{ get; set; }

	public string DeviceType{ get; set; }
	
    public Boolean isTyfone;
    
    public String tyfoneSSN;
    
    public String AuthorizedAccounts;
    
	public CreateCaseController(){
		AccountNames = new List<selectOption>();
		accountNumberSet = new Set<String>();
	}

	public PageReference PageLoad(){
		getMembership();
        getCategory();
		

		/* common code starts */
		List<SecureEmailSetting__c> ses = SecureEmailSetting__c.getall().values();

		Extension = ses[0].List_of_Allowed_Extensions__c;

		CFCUAccount userAccount = new CFCUAccount();
		userAccount.personAccount = new Person_Account__c();
		string LoggedinUser = UserInfo.getUserId();
		List<User> u = [SELECT Name, ContactId, FederationIdentifier
		                from User
		                Where ID = :LoggedinUser];
		userAccount.CurrentUser = u[0];
		userAccount.fedid = u[0].FederationIdentifier;
		UserName = userAccount.CurrentUser.Name;
		List<contact> c = [SELECT AccountId, FirstName, MiddleName, LastName
		                   FROM Contact
		                   WHERE Id = :u[0].ContactId];

		if (c.size() > 0){
			userAccount.userBusinessContact = c[0];
		}

		userAccount.fedid = userAccount.Get10DigitFid(userAccount.fedid);
		List<Person_Account__c> personaccounts = [SELECT Account_Number__c, Id, Name, PersonID__c
		                                          FROM Person_Account__c
		                                          Where Name_Type__c = 0 and Account_Number__r.Name = :userAccount.fedid];


		if (personaccounts.size() > 0){
			userAccount.personAccount = personaccounts[0];
			userAccount.AccountId = userAccount.personaccount.PersonID__c;
			userAccount.AccountNumber = userAccount.personaccount.Account_Number__c;
		}

		List<Account_Details__c> ad = [Select Brand__c
		                               FROM Account_Details__c
		                               Where ID = :userAccount.AccountNumber];
		if (ad.size() > 0){
			userAccount.Brand = ad[0].Brand__c;
		}


		System.Debug('UserAccount:-' + userAccount);
		/* common code ends */
		if (userAccount.Brand == 'Chevron'){
			ImgName = 'logoorig.png';
			Stylesheet = 'main.css';
			Sidebar = 'SidebarSubmitPage.css';
			CopyRights = 'Chevron Federal Credit Union. All Rights Reserved';
			Responsivecss = 'Responsive_Chevron.css';
			Brand_Help = ses[0].Chevron_KB__c;
		} else{
			ImgName = 'spectrum_logo.jpg';
			Stylesheet = 'spectrumcss.css';
			Sidebar = 'SidebarSubmitPageSpectrum.css';
			CopyRights = 'Spectrum Credit Union. All Rights Reserved';
			Responsivecss = 'Responsive_Spectrum.css';
			Brand_Help = ses[0].Spectrum_KB__c;
		}


		List<Case> cases = null;
		List<Case> casesCreatedBySupport = null;
		Set<Id> parentcaseId = new Set<Id>();
		List<Member_Comment__c> CommentsbySupport = null;
		List<Member_Comment__c> comments = null;
		integer i;
		casesCreatedBySupport = [SELECT Id, CaseNumber, Primary_Category__c, Description, Priority, Status, Subject, CreatedDate, IsMarkRead__c, contactid, createdbyId
		                         from Case
		                         where Account_Number__r.Name = :userAccount.fedid and createdbyId != :userAccount.LoggedinUser and IsMarkDeleted__c = false and IsMarkSaved__c = false and MemberCommentCount__c > 0 and CreatedDate >= LAST_N_MONTHS:18];

		for (i = 0; i < casesCreatedBySupport.size(); i++){
			parentcaseId.Add(casesCreatedBySupport[i].Id);
		}
		CommentsbySupport = [SELECT Case__r.Id, CreatedDate, Id, Member_Comment__c, Name
		                     FROM Member_Comment__c
		                     Where CreatedById != :userAccount.LoggedinUser and case__r.Account_Number__r.Name = :userAccount.fedid];
		if (CommentsbySupport.size() > 0){
			for (i = 0; i < CommentsbySupport.size(); i++){
				parentcaseId.Add(CommentsbySupport[i].Case__r.Id);
			}
		}
		cases = [SELECT Id, CaseNumber, Primary_Category__c, Description, Priority, Status, Subject, CreatedDate, IsMarkRead__c, contactid, createdbyId
		         from Case
		         where Id IN :parentcaseId and IsMarkDeleted__c = false and IsMarkSaved__c = false and CreatedDate >= LAST_N_MONTHS:18];

		comments = [SELECT Case__r.Id, CreatedDate, Id, Member_Comment__c, Name
		            FROM Member_Comment__c
		            Where Case__r.Id IN :parentcaseId
		            order by CreatedDate desc];
		messagecount = [Select count()
		                from Case
		                where Id IN :parentcaseId and IsMarkDeleted__c = false and IsMarkSaved__c = false and IsMarkRead__c = false and CreatedDate >= LAST_N_MONTHS:18];

		system.debug('parentcaseId' + parentcaseId);
		system.debug('messagecount' + messagecount);

		return null;
	}

	@TestVisible
	public void SaveCase(){

		/* common code starts */
        List<Person_Account__c> paPrimary = new List<Person_Account__c>();
        sTRING strSSn='';
		CFCUAccount userAccount = new CFCUAccount();
		userAccount.personAccount = new Person_Account__c();
        String strNumber;
		string LoggedinUser = UserInfo.getUserId();
		List<User> u = [SELECT Name, ContactId, FederationIdentifier, Contact.Email
		                from User
		                Where ID = :LoggedinUser];
		system.debug('u: ' + u[0]);
        system.debug('username: ' + u[0].Name);
        system.debug('FederationIdentifier: ' + u[0].FederationIdentifier);
        
		userAccount.CurrentUser = u[0];
		userAccount.fedid = u[0].FederationIdentifier;
		List<contact> c = [SELECT AccountId, FirstName, MiddleName, LastName, Email
		                   FROM Contact
		                   WHERE Id = :u[0].ContactId];
      
		system.debug('c: ' + c);
		strNumber = '%'+userAccount.fedid;
        
        List<Person_Account__c> pa = [SELECT Account_Number__c,Account_Number__r.name, Id, Name, PersonID__c, PersonID__r.Email_raw__C
		                                          FROM Person_Account__c
		                                          Where  TypeTranslate__c like '%Primary%' and Account_Number__r.Name like :strNumber];
        
        System.debug('Account ID: '+pa[0].PersonID__c);
		system.debug('selectedAccount: ' + selectedAccount);
		List<Person_Account__c> personaccounts = [SELECT Account_Number__c, Id, Name, PersonID__c, PersonID__r.Email_raw__C
		                                          FROM Person_Account__c
		                                          Where Name_Type__c = 0 and Account_Number__r.Name = :selectedAccount];


		if (personaccounts.size() > 0){
			userAccount.personAccount = personaccounts[0];
			userAccount.AccountId = userAccount.personaccount.PersonID__c;
			userAccount.AccountNumber = userAccount.personaccount.Account_Number__c;
		}        
        
		if (c.size() > 0){
            if(c[0].Email == null && personaccounts.size() > 0){//c[0].Email == null && personaccounts.size() > 0
                c[0].Email = personaccounts[0].PersonID__r.Email_raw__c;
               // update c[0];
            }
			userAccount.userBusinessContact = c[0];
		}
       
		List<Account_Details__c> ad = [Select Brand__c
		                               FROM Account_Details__c
		                               Where ID = :userAccount.AccountNumber];
		if (ad.size() > 0){
			userAccount.Brand = ad[0].Brand__c;
		}
        If(tyfoneSSN != null){
            system.debug('-------------------Webservice for Authorized Members---------------');
            
            HttpRequest req2 = new HttpRequest();
            HttpResponse res2;
            Http http2 = new Http();
            string responseBody2;
            Set<String> setAuthorizedTypesList = new Set<String>();
            string loanAPI;
        
            ACH_To_Episys_API_Details__c api = ACH_To_Episys_API_Details__c.getValues('ProductionURL');
                    
            if(api.URL__c != null){
                loanAPI = api.URL__c;
            }
        
            req2.setEndpoint(loanAPI + '/MemberAuthorization/GetAuthorizedMemeber?accountNumber=' + selectedAccount);
            req2.setMethod('GET');
            //req1.setTimeout(1200000);
            
            if(!Test.isRunningTest()){                       
                res2 = http2.send(req2);
                responseBody2 = res2.getBody();                
            }
            else{
                responseBody2 = '[{"AddressType":"0","type":0,"accounttype":null,"accountnumber":"0000000123"},{"AddressType":"0","type":1,"accounttype":null,"accountnumber":"0000000123"}]';
            }
        
            system.debug('responseBody2: '+responseBody2);
            
            if(responseBody2 != ''){
                List<Object> jsonParsed = (List<Object>)JSON.deserializeUntyped(responseBody2);
                system.debug('jsonParsed=='+jsonParsed);
                for (Object obj : jsonParsed){
                        Map<String, Object> objItem = (Map<String, Object>)obj;
                        system.debug(String.valueof(objItem.get('type')));
                    	string type = String.valueof(objItem.get('type'));
                    	setAuthorizedTypesList.add(type.trim().leftPad(4, '0')+'%');                    	
                }               
            }
            system.debug('setAuthorizedTypesList: '+setAuthorizedTypesList);
        	strSSN = '%' + tyfoneSSN;
        	
            if(setAuthorizedTypesList.size() > 0){
                paPrimary = [SELECT Id, Account_Number__c,  PersonID__c, Account_Number__r.RecType__c, TypeTranslate__c, 
                                       Account_Number__r.Name,PersonID__r.PersonID__c,PersonID__r.Name, PersonID__r.PersonEmail	
                                       FROM Person_Account__c 
                                       where PersonID__r.PersonID__c like :strSSN 
                         			   and TypeTranslate__c like : setAuthorizedTypesList 
                         			   and Account_Number__r.Name =: selectedAccount LIMIT 1];
            }
            else{
                paPrimary = [SELECT Id, Account_Number__c,  PersonID__c, Account_Number__r.RecType__c, TypeTranslate__c, 
                                       Account_Number__r.Name,PersonID__r.PersonID__c,PersonID__r.Name, PersonID__r.PersonEmail	
                                       FROM Person_Account__c 
                                       where PersonID__r.PersonID__c like :strSSN                         			   
                         			   and Account_Number__r.Name =: selectedAccount LIMIT 1];
            }        
         
        	system.debug('paPrimary: '+paPrimary);
        }
        
        List<Contact> conList = [Select Id, Name from Contact where PersonId__c like :strSSN limit 1];
        
        system.debug('paPrimary: '+paPrimary);
        system.debug('isTyfone: '+isTyfone);
		System.Debug('DeviceType====' + DeviceType);
		System.Debug('UserAccount:-' + userAccount);
		System.Debug('userBusinessContact:-' + userAccount.userBusinessContact);
		System.Debug('userAccount.AccountId:-' + userAccount.AccountId);
		system.debug('conList: '+conList);
        
		/* common code ends */
		PageReference resultcase = null;
		Case ca = new Case();
		ca.Subject = csubject;
		ca.Description = cdescription;
		ca.Account_Number__c = userAccount.AccountNumber;
        if(tyfoneSSN != null){
            ca.Tyfone_SSN__c = tyfoneSSN;
        }        
		//c.Account_Number__c = 'a0L630000008scXEAQ';
        if(isTyfone == false){
        	ca.AccountID = userAccount.AccountId;
        }
        else{
            if(paPrimary.size() > 0)
            	ca.AccountID = paPrimary[0].PersonID__c;//pa[0].PersonId__C;
            else
                ca.AccountID = pa[0].PersonId__C;
        }
        if(paPrimary.size() > 0){
            ca.Tyfone_Member_Name__c = paPrimary[0].PersonID__c;
            if(string.isNotBlank(paPrimary[0].PersonID__r.PersonEmail))
            	ca.Tyfone_Member_Email__c = paPrimary[0].PersonID__r.PersonEmail;
        }
		ca.Primary_Category__c = primaryCategory;
		ca.Origin = 'Portal';
		ca.Status = 'Open';
		ca.Device_Type__c = DeviceType;
		ca.IsMarkRead__c = true;
        if(conList.size() > 0){
             ca.ContactId =  conList[0].id;
            system.debug('ca.ContactId: '+ca.ContactId);
        }   
        
		insert ca;
		caseid = ca.Id;
		cdescription = '';
		cSubject = '';
	}

	public List<SelectOption> getCategory(){

		//---------------------------- Exculde from Portal ----------------------------------//

		Excluded_Categories_in_Portal__c ecp = Excluded_Categories_in_Portal__c.getValues('Primary');

		if (ecp.Categories__c != null){
			Category = ecp.Categories__c;
		}

		CategoryList = Category.split(',');


		//---------------------------- Exculde from Portal ----------------------------------//

		List<SelectOption> options = new List<SelectOption>();
		Schema.Describefieldresult primaryCategory = Case.Primary_Category__c.getDescribe();


		//    Schema.DescribeFieldResult fieldResult = Schema.sObjectType.cases.fields.Primary_Category__c.getDescribe();
		List<Schema.PicklistEntry> ple = primaryCategory.getPicklistValues();
		
		for (Schema.PicklistEntry f : ple){
			for (String s : CategoryList){

				if (s != f.getvalue()){
					options.add(new SelectOption(f.getValue(), f.getLabel()));
				}
			}

		}
		return options;
	}

	public List<SelectOption> getMembership(){
		system.debug('AuthorizedAccounts: '+AuthorizedAccounts);
        List<SelectOption> options = new List<SelectOption>();
        List<SelectOption> finalOptions = new List<SelectOption>();
        
        CFCUAccount userAccount = new CFCUAccount();
        userAccount.personAccount = new Person_Account__c();
        string LoggedinUser = UserInfo.getUserId();
        List<User> u = [SELECT Name, ContactId, FederationIdentifier from User Where ID = :LoggedinUser];
        system.debug('Loggedin Id: '+u[0].Id);
        system.debug('Loggedin UserName: '+u[0].Name);
        system.debug('Loggedin user FID: '+u[0].FederationIdentifier);
        if(string.isblank(AuthorizedAccounts)){
            AuthorizedAccounts = getAuthorizedAccounts(tyfoneSSN); 
        }               
        List<string> listAuthorizedAccounts = AuthorizedAccounts.split(',');
        Set<String> setAuthorizedAccounts = new Set<String>(listAuthorizedAccounts);
        
        userAccount.CurrentUser = u[0];
        userAccount.fedid = u[0].FederationIdentifier;
        userAccount.fedid = userAccount.Get10DigitFid(userAccount.fedid);
        
        List<Person_Account__c> personaccounts = [SELECT Account_Number__c, Id, Name, PersonID__c,Account_Number__r.name
                                                  FROM Person_Account__c
                                                  Where Name_Type__c = 0 and Account_Number__r.Name = :userAccount.fedid];        
        
        System.debug(personaccounts[0].Account_Number__r.name);
        system.debug(userAccount.fedid);
        system.debug(u[0].name);
        
        List<Account_Details__c> ad = [Select name,Brand__c FROM Account_Details__c Where name = :userAccount.fedid LIMIT 1];
        if (ad.size() > 0){
            userAccount.Brand = ad[0].Brand__c;
        }
        
        string acName  = userAccount.fedid + '-' + userAccount.Brand;
        string acName2 = u[0].FederationIdentifier + '-' + userAccount.Brand;
            
        String AccString;
        List<String> AccList = new List<String>();
        List<String> AccDisList = new List<String>();
        set<String> CloseAccountsList = new set<String>();
        
        system.debug(acName);
        system.debug(acName2);
        List<Account> aList = [SELECT Id,Name,Description FROM Account WHERE Name=:acName OR Name =:acName2 order by lastmodifieddate desc Limit 1];
        system.debug('aList: '+aList[0].id);
        
        if(aList.size()>0){
            if(aList[0].Description != null){
                
                AccString = aList[0].Description.replaceAll('[()]', '');
            	system.debug('AccString: '+AccString);
                AccDisList.add(userAccount.fedid);
               
                if(AccString != null){
                    AccList = AccString.split(',');
                }
                system.debug('AccList: '+AccList);
                List<Account_Details__c> listCloseAccounts = [Select id, Name from Account_Details__c where (name in:AccList OR Name =: userAccount.fedid) AND Close_Date__c <> null and RecType__c = 'ACCT'];
                system.debug('listCloseAccounts: '+listCloseAccounts);
                
                if(listCloseAccounts.size() > 0){
                    for(Account_Details__c lca: listCloseAccounts){
                        CloseAccountsList.add(lca.name);
                    }                    
                }
                 system.debug('CloseAccountsList: '+CloseAccountsList);
                    if(AccList.size() != 1){
                	options.add(new SelectOption(' ', 'Select Account'));
                        if(!CloseAccountsList.contains(userAccount.fedid) && setAuthorizedAccounts.contains(userAccount.fedid)){
                            options.add(new SelectOption(userAccount.fedid, maskAccountNumber(userAccount.fedid)));
                        }                    
                                           
                        if(String.isblank(selectedAccount)){
                           // selectedAccount = userAccount.fedid;
                        }
                    
                    tyfoneSSN =(AccList[AccList.size()-1]).right(9);
                    
                    AccList.remove(AccList.size()-1);     
                    system.debug('AccList: '+AccList);
                	
                    for(String s : AccList){
                        if(!CloseAccountsList.contains(s.trim()) && setAuthorizedAccounts.contains(s.trim())){
                            options.add(new SelectOption(s.trim(), maskAccountNumber(s.trim())));
                        	AccDisList.add(s.trim());
                        }                        
                        isTyfone = true;
                    }
                    
                    system.debug('tyfoneSSN: '+tyfoneSSN);
                    system.debug('isTyfone: '+isTyfone);
                    system.debug('AccDisList'+AccDisList);
                    
                    for(Account_Details__c ar : [select id,name,createddate from Account_Details__c where name LIKE: AccDisList and RecType__c = 'ACCT' order by createddate asc]){
                        finalOptions.add(new SelectOption(ar.name,maskAccountNumber(ar.name)));
                    }      
                                  
                }
                else if(AccList.size() == 1){
                    
                    tyfoneSSN =(AccList[AccList.size()-1]).right(9);
                    isTyfone = true;
                    system.debug('tyfoneSSN: '+tyfoneSSN);
                    system.debug('isTyfone: '+isTyfone);
                    if(!CloseAccountsList.contains(userAccount.fedid) && setAuthorizedAccounts.contains(userAccount.fedid)){
                        options.add(new SelectOption(userAccount.fedid, maskAccountNumber(userAccount.fedid)));
                    	selectedAccount = userAccount.fedid;
                    }                    
                }
            }
            else{
                if(!CloseAccountsList.contains(userAccount.fedid) && setAuthorizedAccounts.contains(userAccount.fedid)){
					options.add(new SelectOption(userAccount.fedid, maskAccountNumber(userAccount.fedid)));                    
                }                
                selectedAccount = userAccount.fedid;
            }            
        }
        system.debug('tyfoneSSN: '+tyfoneSSN);
		return options;
	}
    
    public string maskAccountNumber(string AccountNumber){
        		String valueToMask = AccountNumber.substring(0, 8);
                String mask = '*'.repeat(valueToMask.length());
                String masked = AccountNumber.replaceFirst(valueToMask, mask);
                system.debug('Masked:'+masked);
        		return masked;
    }

	@RemoteAction
	global static String attachBlob(String parentId, String attachmentId, String fileName, String contentType, String base64BlobValue){
		/*
		 parentId: The sfdc object Id this file will be attached to
		 attachmentId: The record of the current Attachment file being processed
		 fileName: Name of the attachment
		 contentTye: Content Type of the file being attached
		 base64BlobValue: Base64 encoded string of the file piece currently processing
		 */

		//If recordId is blank this is the first part of a multi piece upload
		if (attachmentId == '' || attachmentId == null){
			Attachment att = new Attachment(ParentId = parentId, Body = EncodingUtil.Base64Decode(base64BlobValue), Name = fileName, ContentType = contentType);
			insert att;

			//Return the new attachment Id
			return att.Id;

		} else{
			for (Attachment atm : [select Id, Body
			                       from Attachment
			                       where Id = :attachmentId]){
				//Take the body of the current attachment, convert to base64 string, append base64 value sent from page, then convert back to binary for the body
				update new Attachment(Id = attachmentId, Body = EncodingUtil.Base64Decode(EncodingUtil.Base64Encode(atm.Body)+base64BlobValue));
			}

			//Return the Id of the attachment we are currently processing
			return attachmentId;
		}
	}
    
    public string getAuthorizedAccounts(string SSN){
        system.Debug('SSN: '+SSN);
        string AuthrorizedAccountString='';
        string loanAPI;
        
        ACH_To_Episys_API_Details__c api = ACH_To_Episys_API_Details__c.getValues('ProductionURL');
                
        if(api.URL__c != null){
            loanAPI = api.URL__c;
        }
            system.debug('-------------------Webservice for Member Authorization---------------');
            
            HttpRequest req1 = new HttpRequest();
            HttpResponse res1;
            Http http1 = new Http();
            string responseBody1;            
        
            req1.setEndpoint(loanAPI + '/MemberAuthorization/GetAuthorizedAccounts?ssn=' + SSN);
            req1.setMethod('GET');
            //req1.setTimeout(1200000);
            
            if(!Test.isRunningTest()){                       
                res1 = http1.send(req1);
                responseBody1 = res1.getBody();                
            }
            else{
                responseBody1 = '{"Accounts":"0000000123,0000000256"}';
            }
        
            system.debug('responseBody1: '+responseBody1);
        
            if(responseBody1 != ''){
                map<string, object> jsonParsed = (map<string, object>)JSON.deserializeUntyped(responseBody1);
                system.debug('jsonParsed=='+jsonParsed);
                AuthrorizedAccountString = (string)jsonParsed.get('Accounts');
            }
        return AuthrorizedAccountString;
    }
}