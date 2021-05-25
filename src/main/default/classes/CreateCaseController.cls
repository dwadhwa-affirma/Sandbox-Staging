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

	public CreateCaseController(){
		AccountNames = new List<selectOption>();
		accountNumberSet = new Set<String>();
	}

	public PageReference PageLoad(){
		getCategory();
		getMembership();

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
		CFCUAccount userAccount = new CFCUAccount();
		userAccount.personAccount = new Person_Account__c();
		string LoggedinUser = UserInfo.getUserId();
		List<User> u = [SELECT Name, ContactId, FederationIdentifier, Contact.Email
		                from User
		                Where ID = :LoggedinUser];
		system.debug('u: ' + u[0]);
		userAccount.CurrentUser = u[0];
		userAccount.fedid = u[0].FederationIdentifier;
		List<contact> c = [SELECT AccountId, FirstName, MiddleName, LastName, Email
		                   FROM Contact
		                   WHERE Id = :u[0].ContactId];
		system.debug('c: ' + c);

        
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
            if(c[0].Email == null && personaccounts.size() > 0){
                c[0].Email = personaccounts[0].PersonID__r.Email_raw__c;
                update c[0];
            }
			userAccount.userBusinessContact = c[0];
		}
       
		List<Account_Details__c> ad = [Select Brand__c
		                               FROM Account_Details__c
		                               Where ID = :userAccount.AccountNumber];
		if (ad.size() > 0){
			userAccount.Brand = ad[0].Brand__c;
		}

		System.Debug('DeviceType====' + DeviceType);

		System.Debug('UserAccount:-' + userAccount);
		System.Debug('userBusinessContact:-' + userAccount.userBusinessContact);
		System.Debug('userAccount.AccountId:-' + userAccount.AccountId);

		/* common code ends */
		PageReference resultcase = null;
		Case ca = new Case();
		ca.Subject = csubject;
		ca.Description = cdescription;
		ca.Account_Number__c = userAccount.AccountNumber;        
		//c.Account_Number__c = 'a0L630000008scXEAQ';
		ca.AccountID = userAccount.AccountId;
		ca.Primary_Category__c = primaryCategory;
		ca.Origin = 'Portal';
		ca.Status = 'Open';
		ca.Device_Type__c = DeviceType;
		ca.IsMarkRead__c = true;
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

		/*CFCUAccount userAccount = new CFCUAccount();
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

		list<Person_Account__c> PrimaryPAList = [Select id, Account_Number__r.name, Typetranslate__c, PersonID__c
		                                         from Person_Account__c
		                                         where Typetranslate__c like '%Primary%' and PersonID__c = :userAccount.AccountId];

		if (PrimaryPAList.size() > 0){
			for (Person_Account__c pa : PrimaryPAList){
				options.add(new SelectOption(pa.Account_Number__r.name, pa.Account_Number__r.name));
			}
		}

		if (PrimaryPAList.size() == 1){
			selectedAccount = PrimaryPAList[0].Account_Number__r.name;
		}*/
		
        List<SelectOption> options = new List<SelectOption>();
        
        CFCUAccount userAccount = new CFCUAccount();
        userAccount.personAccount = new Person_Account__c();
        string LoggedinUser = UserInfo.getUserId();
        List<User> u = [SELECT Name, ContactId, FederationIdentifier from User Where ID = :LoggedinUser];
        userAccount.CurrentUser = u[0];
        userAccount.fedid = u[0].FederationIdentifier;
        userAccount.fedid = userAccount.Get10DigitFid(userAccount.fedid);
        
        List<Person_Account__c> personaccounts = [SELECT Account_Number__c, Id, Name, PersonID__c
                                                  FROM Person_Account__c
                                                  Where Name_Type__c = 0 and Account_Number__r.Name = :userAccount.fedid];        
        
        List<Account_Details__c> ad = [Select name,Brand__c FROM Account_Details__c Where name = :userAccount.fedid LIMIT 1];
        if (ad.size() > 0){
            userAccount.Brand = ad[0].Brand__c;
        }
        
        string acName  = userAccount.fedid + '-' + userAccount.Brand;
        String AccString;
        List<String> AccList = new List<String>();
        
        List<Account> aList = [SELECT Id,Name,Description FROM Account WHERE Name=:acName Limit 1];
        
        if(aList.size()>0){
            if(aList[0].Description != null){
                
                AccString = aList[0].Description.replaceAll('[()]', '');
            	system.debug('AccString: '+AccString);
                
                if(AccString != null){
                    AccList = AccString.split(',');
                }
                if(AccList.contains(userAccount.fedid) == false){
                    options.add(new SelectOption(userAccount.fedid, userAccount.fedid));
                }
                for(String s : AccList){
                    options.add(new SelectOption(s, s));
                }
            }
            else{
                options.add(new SelectOption(userAccount.fedid, userAccount.fedid));
                selectedAccount = userAccount.fedid;
            }
        }
        
		return options;
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
}