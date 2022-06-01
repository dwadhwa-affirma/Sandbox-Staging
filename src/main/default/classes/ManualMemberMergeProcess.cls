public without sharing class ManualMemberMergeProcess{
	@AuraEnabled
	public static List<object> GetMemberList(String membertype){
		//checking the User to find the type of member
		user gurs = [Select UserRoleId, Email, ForecastEnabled, Alias, Managerid
		             from user
		             where id = :UserInfo.getUserId()
		             LIMIT 1];
		List<User> userlist = new List<User>();
		Set<String> useridSet = new Set<String>();

		If (membertype == 'My Members'){
			userlist.add(gurs);
		} else if (membertype == 'My Team Members'){
			if (gurs.Managerid != null){

				userlist = [SELECT id, ManagerId, Name, Alias
				            FROM User
				            where (managerid = :gurs.Managerid or managerid = :gurs.id or id = :gurs.Managerid or id = :gurs.id) and isactive = true];

			} else{

				userlist = [SELECT id, ManagerId, Name, Alias
				            FROM User
				            where (managerid = :gurs.id or id = :gurs.id) and isactive = true];

			}
		}

		If (userlist.Size() > 0){
			for (User u : userlist){
				useridSet.Add(u.Alias);

			}
		} else{
			userlist.Add(gurs);
		}


		//Getting values from custom setting name MemberConversionSetting__c
		List<object> listObj = new List<object>();
		MemberConversionSetting__c mcs = MemberConversionSetting__c.getValues('PrimaryRecord');
		Date cutoffdate = mcs.Member_Matching_Cut_off_Date__c;

		if (cutoffdate == null){
			cutoffdate = system.today().adddays(-1000);
		}

		Integer Days_Manual = 0;
		Days_Manual = (Integer) mcs.Manual__c;
		Integer Days_ManualPreMember = 0;
		Days_ManualPreMember = (Integer) mcs.ManualPreMember__c;

		Days_Manual = (Days_Manual) * ( - 1);
		Days_ManualPreMember = (Days_ManualPreMember) * ( - 1);
		date LastNDays = system.today().addDays(Days_Manual);//from custom setting field Manual__c i.e 7 days
		date LastNDaysPreMem = system.today().addDays(Days_ManualPreMember);//from custom setting field ManualPreMember__c i.e 7 days
		Boolean IsMatching = false;
		List<Account> accounts = new List<Account>();

		Map<ID, Account> accounts_Filter = new Map<ID, Account>([SELECT Id, FirstName, LastName, Name
		                                                         FROM Account
		                                                         where RecordType.Name = 'Person Account' and createddate > :LastNDays and IsConverted__c = false
		                                                         order by createddate]);
		Set<ID> listAccountIds = accounts_Filter.keySet();
		Set<ID> listAccountIds_ToFilter = accounts_Filter.keySet();
		list<string> listPAIds = new List<string>();
		boolean userGroup = CheckMembership();

		List<Person_account__c> listOfAllNonBenificaries = new List<Person_account__c>();
		List<Person_account__c> listOfAllPrimaries = new List<Person_account__c>();

		Set<Id> listAccountId_Qualified1 = new Set<Id>();
		Set<Id> listAccountId_Qualified2 = new Set<Id>();
		Set<Id> listAccountId_Qualified3 = new Set<Id>();


		if (userGroup && membertype == 'All Members'){

			// ------------------------------------------------ Checking Beneficiary ------------------------------------------------------------//

			listOfAllNonBenificaries = [SELECT PersonID__c
			                            FROM Person_Account__c
			                            WHERE PersonID__c in:listAccountIds_ToFilter and ( not TypeTranslate__c like '%Beneficiary%')
			                            order by Account_Number__r.RecType__c];
			for (Person_Account__c item : listOfAllNonBenificaries){

				if (!listAccountId_Qualified1.contains(item.PersonId__c)){
					listAccountId_Qualified1.add(item.PersonId__c);
				}
			}

			// ------------------------------------------------ Checking Primary ------------------------------------------------------------//

			listOfAllPrimaries = [SELECT PersonID__c
			                      FROM Person_Account__c
			                      WHERE PersonID__c in:listAccountIds_ToFilter and TypeTranslate__c like '%Primary%'
			                      order by Account_Number__r.RecType__c];

			for (Person_Account__c item1 : listOfAllPrimaries){

				if (!listAccountId_Qualified2.contains(item1.PersonId__c)){
					listAccountId_Qualified2.add(item1.PersonId__c);
				}
			}

			// -------------------------------------------------Comparing both list ---------------------------------------------------------//

			for (ID id1 : listAccountId_Qualified1){

				if (!listAccountId_Qualified2.contains(id1)){
					listAccountId_Qualified3.add(id1);
				}
			}


		} else{
			// ------------------------------------------------ Checking Beneficiary ------------------------------------------------------------//

			listOfAllNonBenificaries = [SELECT PersonID__c
			                            FROM Person_Account__c
			                            WHERE PersonID__c in:listAccountIds_ToFilter and ( not TypeTranslate__c like '%Beneficiary%') and Account_Number__r.Created_By_User_Alias__c in:useridSet
			                            order by Account_Number__r.RecType__c];
			for (Person_Account__c item : listOfAllNonBenificaries){

				if (!listAccountId_Qualified1.contains(item.PersonId__c)){
					listAccountId_Qualified1.add(item.PersonId__c);
				}
			}

			// ------------------------------------------------ Checking Primary ------------------------------------------------------------//

			listOfAllPrimaries = [SELECT PersonID__c
			                      FROM Person_Account__c
			                      WHERE PersonID__c in:listAccountIds_ToFilter and TypeTranslate__c like '%Primary%' and Account_Number__r.Created_By_User_Alias__c in:useridSet
			                      order by Account_Number__r.RecType__c];

			for (Person_Account__c item1 : listOfAllPrimaries){

				if (!listAccountId_Qualified2.contains(item1.PersonId__c)){
					listAccountId_Qualified2.add(item1.PersonId__c);
				}
			}

			// -------------------------------------------------Comparing both list ---------------------------------------------------------//

			for (ID id1 : listAccountId_Qualified1){

				if (!listAccountId_Qualified2.contains(id1)){
					listAccountId_Qualified3.add(id1);
				}
			}
		}

		//---Left Nav of getting the primary account-----//
		accounts = [SELECT Id, FirstName, LastName, Name
		            FROM Account
		            where id in:listAccountId_Qualified2 and createddate > :LastNDays
		            order by createddate];
		listObj.Add(accounts);
		//----Right Nav Getting the PreMemberAccount---//
		List<Account> PreMemberAccount = new List<Account>();
		PreMemberAccount = [SELECT Id, PersonEmail, Email_raw__c, Alt_Email_Raw__c, FirstName, MiddleName, LastName, Name, Salutation, Suffix, Mobile_Phone__pc, Home_Phone__pc, Alternate_Email__pc, Phone_Check__c, Residential_Street__pc, RecordType.Name, Residential_City__pc, Residential_State__pc, Residential_Zipocde__pc, Residential_Extra_Address__pc, createddate
		                    FROM Account
		                    where RecordType.Name = 'Pre Member' and createddate > :LastNDaysPreMem and IsConverted__c = false];//return the records of Pre member and created on last no. of days in Days_ManualPreMember

		listObj.Add(PreMemberAccount);

		listObj.Add(userGroup);
		return listObj;
	}

	@AuraEnabled
	public static List<object> GetMemberAccountDetail(Id id){
		List<object> listObj = new List<object>();
		Account ma = new Account();

		ma = [SELECT Id, PersonEmail, Work_Phone__pc, FirstName, MiddleName, LastName, Salutation, Name, Suffix, Phone_Check__c, Residential_Street__pc, RecordType.Name, Residential_Zipocde__pc, Alternate_Email__pc, Alt_Email_Raw__c, AnnualRevenue, Bad_Email__c, BillingCity, BillingCountry, BillingCountryCode, BillingGeocodeAccuracy, BillingLatitude, BillingLongitude, BillingPostalCode, BillingState, BillingStateCode, BillingStreet, BIRTH_DATE__pc, IsCustomerPortal, Death_Date__pc, Description, Email_raw__c, Employee_Restricted_Access__c, NumberOfEmployees, Employer_Occupation__pc, Extended_Name__pc, Fax, Home_Phone__pc, AccountNumber, Site, AccountSource, Member_Verification_OTP_Invalid_Attempt__c, et4ae5__Mobile_Country_Code__pc, et4ae5__HasOptedOutOfMobile__pc, Mobile_Phone__pc, Mothers_Maiden_Name__pc, Multi_Name__pc, MultiAddress__pc, MultiDOB__pc, MultiMMN__pc, MultiSSN__pc, Occupation__pc, Onbase_Drivers_License__c, Ownership, PersonID__pc, Phone, Phone_Type__pc, Rating, Residential_City__pc, Residential_Country__pc, Residential_Country_Code__pc, Residential_Extra_Address__pc, Residential_State__pc
		      FROM Account
		      where Id = :id];


		// for Pre member
		listObj.Add(ma);
		Boolean IsMatching = false;
		string SortField = '';
		Set<ID> Eligibleprememberset = new Set<Id>();
		List<Account> PreMemberAccount = new List<Account>();
		List<Account> PreMemberAccountreturn = new List<Account>();
		List<Account> FinalPreMemberAccountListToReturn = new List<Account>();


		PreMemberAccount = [SELECT Id, PersonEmail, Email_raw__c, Alt_Email_Raw__c, Alternate_Email__pc, FirstName, MiddleName, LastName, Name, Salutation, Suffix, Phone_Check__c, Mobile_Phone__pc, Home_Phone__pc, Work_Phone__pc, Residential_Street__pc, RecordType.Name, Residential_City__pc, Residential_State__pc, Residential_Zipocde__pc, Residential_Extra_Address__pc, createddate
		                    FROM Account
		                    where RecordType.Name = 'Pre Member' and IsConverted__c = false
		                    order by LastName];
		List<Account> listEmailMatched = new List<Account>();
		List<Account> listLastNameMatched = new List<Account>();
		List<Account> listFirstNameMatched = new List<Account>();
		List<Account> listInitialNameMatched = new List<Account>();
		List<Account> listStreetAddressMatched = new List<Account>();
		List<Account> listZipMatched = new List<Account>();
		List<Account> listPhoneMatched = new List<Account>();
		List<Account> listNotMatched = new List<Account>();
		Map<Account, Integer> finalList = new Map<Account, Integer>();

		for (Account preMembers : PreMemberAccount){
			boolean isadded = false;
			Integer counter = 0;
			boolean isphonematched = false;
			String ma_email_check = '';

			if (!string.isBlank(ma.Alternate_Email__pc)){
				ma_email_check = ma_email_check + ma.Alternate_Email__pc.toUpperCase() + ',';
			}
			if (!string.isBlank(ma.Alt_Email_Raw__c)){
				ma_email_check = ma_email_check + ma.Alt_Email_Raw__c.toUpperCase() + ',';
			}
			if (!string.isBlank(ma.PersonEmail)){
				ma_email_check = ma_email_check + ma.PersonEmail.toUpperCase() + ',';
			}
			if (!string.isBlank(ma.Email_raw__c)){
				ma_email_check = ma_email_check + ma.Email_raw__c.toUpperCase() + ',';
			}


			if (!string.isBlank(preMembers.LastName) && preMembers.LastName == ma.LastName){
				if (!isadded){
					listLastNameMatched.add(preMembers);
					isadded = true;
				}
				counter = counter + 1;
			}
			if (!string.isBlank(preMembers.FirstName) && preMembers.FirstName == ma.FirstName){
				if (!isadded){
					listFirstNameMatched.add(preMembers);
					isadded = true;
				}
				counter = counter + 1;
			}

			if (!string.isBlank(ma_email_check) && !string.isBlank(ma.LastName) && !string.isBlank(ma.FirstName) && !string.isBlank(preMembers.LastName) && !string.isBlank(preMembers.FirstName) && ((!string.isBlank(preMembers.Alternate_Email__pc) && ma_email_check.contains(preMembers.Alternate_Email__pc.toUpperCase())) || (!string.isBlank(preMembers.Alt_Email_Raw__c) && ma_email_check.contains(preMembers.Alt_Email_Raw__c.toUpperCase())) || (!string.isBlank(preMembers.Email_raw__c) && ma_email_check.contains(preMembers.Email_raw__c.toUpperCase())) || (!string.isBlank(preMembers.PersonEmail) && ma_email_check.contains(preMembers.PersonEmail.toUpperCase()))) && ma.LastName.toUpperCase() == preMembers.LastName.toUpperCase() && ma.FirstName.toUpperCase() == preMembers.FirstName.toUpperCase()){
				if (!isadded){
					listEmailMatched.add(preMembers);
					isadded = true;
				}
				counter = counter + 1;
			}
			if (!string.isBlank(preMembers.Residential_Street__pc) && preMembers.Residential_Street__pc == ma.Residential_Street__pc){
				if (!isadded){
					listStreetAddressMatched.add(preMembers);
					isadded = true;
				}
				counter = counter + 1;

			}
			if (!string.isBlank(preMembers.Residential_Zipocde__pc) && preMembers.Residential_Zipocde__pc == ma.Residential_Zipocde__pc){
				if (!isadded){
					listZipMatched.add(preMembers);
					isadded = true;
				}
				counter = counter + 1;

			}
			if (!string.isBlank(preMembers.Mobile_Phone__pc) && ((!string.isBlank(ma.Mobile_Phone__pc) && ConvertPreMemberToMemberSchedular.clearPhoneNumber(preMembers.Mobile_Phone__pc).contains(ConvertPreMemberToMemberSchedular.clearPhoneNumber(ma.Mobile_Phone__pc))) || (!string.isBlank(ma.Home_Phone__pc) && ConvertPreMemberToMemberSchedular.clearPhoneNumber(preMembers.Mobile_Phone__pc).contains(ConvertPreMemberToMemberSchedular.clearPhoneNumber(ma.Home_Phone__pc))) || (!string.isBlank(ma.Work_Phone__pc) && ConvertPreMemberToMemberSchedular.clearPhoneNumber(preMembers.Mobile_Phone__pc).contains(ConvertPreMemberToMemberSchedular.clearPhoneNumber(ma.Work_Phone__pc))))){
				isphonematched = true;
				if (!isadded){
					listPhoneMatched.add(preMembers);
					isadded = true;
				}
				counter = counter + 1;

			}
			if (!isphonematched && !string.isBlank(preMembers.Home_Phone__pc) && ((!string.isBlank(ma.Mobile_Phone__pc) && ConvertPreMemberToMemberSchedular.clearPhoneNumber(preMembers.Home_Phone__pc).contains(ConvertPreMemberToMemberSchedular.clearPhoneNumber(ma.Mobile_Phone__pc))) || (!string.isBlank(ma.Home_Phone__pc) && ConvertPreMemberToMemberSchedular.clearPhoneNumber(preMembers.Home_Phone__pc).contains(ConvertPreMemberToMemberSchedular.clearPhoneNumber(ma.Home_Phone__pc))) || (!string.isBlank(ma.Work_Phone__pc) && ConvertPreMemberToMemberSchedular.clearPhoneNumber(preMembers.Home_Phone__pc).contains(ConvertPreMemberToMemberSchedular.clearPhoneNumber(ma.Work_Phone__pc))))){
				isphonematched = true;
				preMembers.Mobile_Phone__pc = preMembers.Home_Phone__pc;
				if (!isadded){

					listPhoneMatched.add(preMembers);
					isadded = true;
				}
				if (!isphonematched)
					counter = counter + 1;
			}
			if (!isphonematched && !string.isBlank(preMembers.Work_Phone__pc) && ((!string.isBlank(ma.Mobile_Phone__pc) && ConvertPreMemberToMemberSchedular.clearPhoneNumber(preMembers.Work_Phone__pc).contains(ConvertPreMemberToMemberSchedular.clearPhoneNumber(ma.Mobile_Phone__pc))) || (!string.isBlank(ma.Home_Phone__pc) && ConvertPreMemberToMemberSchedular.clearPhoneNumber(preMembers.Work_Phone__pc).contains(ConvertPreMemberToMemberSchedular.clearPhoneNumber(ma.Home_Phone__pc))) || (!string.isBlank(ma.Work_Phone__pc) && ConvertPreMemberToMemberSchedular.clearPhoneNumber(preMembers.Work_Phone__pc).contains(ConvertPreMemberToMemberSchedular.clearPhoneNumber(ma.Work_Phone__pc))))){
				isphonematched = true;
				preMembers.Mobile_Phone__pc = preMembers.Work_Phone__pc;
				if (!isadded){

					listPhoneMatched.add(preMembers);
					isadded = true;
				}
				if (!isphonematched)
					counter = counter + 1;
			}


			if (!isadded){
				listNotMatched.add(preMembers);

			} else{
				finalList.put(preMembers, counter);

			}

		}

		AccountWrapper[] accountList = new AccountWrapper[0];
		for (Account key : finalList.keyset()){
			accountList.add(new AccountWrapper(key, finalList.get(key)));
		}
		accountList.sort ();
		for (Integer i = accountList.size() - 1; i >= 0; i--){
			FinalPreMemberAccountListToReturn.Add(accountList[i].account);
		}


		FinalPreMemberAccountListToReturn.AddAll(listNotMatched);


		PreMemberAccountreturn = PreMemberAccount;
		listObj.Add(FinalPreMemberAccountListToReturn);

		return listObj;
	}

	@AuraEnabled
	public static void MergeMemberAccount(Id mid, Id pmid){
		Account ma = [SELECT Id, Pre_Member_Number__c, PersonEmail, FirstName, MiddleName, LastName, Salutation, Suffix, Phone_Check__c, Residential_Street__pc, RecordType.Name, Residential_Zipocde__pc, Alternate_Email__pc, Alt_Email_Raw__c, AnnualRevenue, Bad_Email__c, BillingCity, BillingCountry, BillingCountryCode, BillingGeocodeAccuracy, BillingLatitude, BillingLongitude, BillingPostalCode, BillingState, BillingStateCode, BillingStreet, BIRTH_DATE__pc, IsCustomerPortal, Death_Date__pc, Description, Email_raw__c, Employee_Restricted_Access__c, NumberOfEmployees, Employer_Occupation__pc, Extended_Name__pc, Fax, Home_Phone_Number__c, Home_Phone__pc, ID_1_Description__pc, ID_1_Expiration_Date__pc, ID_1_Issuance_Date__pc, ID_1_Number__pc, ID_1_Type__pc, ID_1_Type__c, ID_1_Verification_Date__pc, ID_2_Description__pc, ID_2_Expiration_Date__pc, ID_2_Issuance_Date__pc, ID_2_Number__pc, ID_2_Type__pc, ID_2_Verification_Date__pc, ID_3_Description__pc, ID_3_Expiration_Date__pc, ID_3_Issuance_Date__pc, ID_3_Number__pc, ID_3_Type__pc, ID_3_Verification_Date__pc, Industry, Initial_Record__pc, LastModifiedDate__pc, AccountNumber, Site, AccountSource, Member_Verification_OTP_Invalid_Attempt__c, et4ae5__Mobile_Country_Code__pc, et4ae5__HasOptedOutOfMobile__pc, Mobile_Phone__pc, Mothers_Maiden_Name__pc, Multi_Name__pc, MultiAddress__pc, MultiDOB__pc, MultiMMN__pc, MultiSSN__pc, NA_Eligibility__c, NA_LEHS_Complete__c, NA_LEHS_Update__c, NA_LEOM_Complete__c, NA_LEOM_Update__c, NA_Opt_Out__c, NA_Opt_Out_Date__c, NA_Opt_Out_Updated__c, NA_LEAV_Complete__c, NA_LECF_Complete__c, NA_LECP_Complete__c, NA_LEEM_Complete__c, NA_LEMD_Complete__c, NA_LEMP_Complete__c, NA_LEMQ_Complete__c, NA_LEOL_Complete__c, NA_LEPT_Complete__c, NA_LESB_Complete__c, NA_LESF_Complete__c, NA_LEWS_Complete__c, Name_Format__pc, Occupation__pc, Onbase_Drivers_License__c, Onbase_Signature_Card__c, Ownership, PersonID__pc, Phone, Phone_Type__pc, Rating, Residential_City__pc, Residential_Country__pc, Residential_Country_Code__pc, Residential_Extra_Address__pc, Residential_State__pc, Sex__pc, ShippingCity, ShippingCountry, ShippingCountryCode, ShippingGeocodeAccuracy, ShippingLatitude, ShippingLongitude, ShippingPostalCode, ShippingState, ShippingStateCode, ShippingStreet, Sic, SicDesc, smagicinteract__SMSOptOut__pc, SSN_Last_4__pc, SSN_TIN_Encrypted__pc, SSN_TIN_Type__pc, TickerSymbol, Type, Website, Work_Phone_Extension__pc, Work_Phone__pc
		              FROM Account
		              where RecordType.Name = 'Person Account' and Id = :mid];
		Account pma = [SELECT Id, Pre_Member_Number__c, Name, PersonEmail, FirstName, MiddleName, LastName, Salutation, Suffix, Owner.Name, Parent_Lead__c, CreatedDate, Phone_Check__c, Residential_Street__pc, RecordType.Name, Residential_Zipocde__pc, Alternate_Email__pc, Alt_Email_Raw__c, AnnualRevenue, Bad_Email__c, BillingCity, BillingCountry, BillingCountryCode, BillingGeocodeAccuracy, BillingLatitude, BillingLongitude, BillingPostalCode, BillingState, BillingStateCode, BillingStreet, BIRTH_DATE__pc, IsCustomerPortal, Death_Date__pc, Description, Email_raw__c, Employee_Restricted_Access__c, NumberOfEmployees, Employer_Occupation__pc, Extended_Name__pc, Fax, Home_Phone_Number__c, Home_Phone__pc, ID_1_Description__pc, ID_1_Expiration_Date__pc, ID_1_Issuance_Date__pc, ID_1_Number__pc, ID_1_Type__pc, ID_1_Type__c, ID_1_Verification_Date__pc, ID_2_Description__pc, ID_2_Expiration_Date__pc, ID_2_Issuance_Date__pc, ID_2_Number__pc, ID_2_Type__pc, ID_2_Verification_Date__pc, ID_3_Description__pc, ID_3_Expiration_Date__pc, ID_3_Issuance_Date__pc, ID_3_Number__pc, ID_3_Type__pc, ID_3_Verification_Date__pc, Industry, Initial_Record__pc, LastModifiedDate__pc, AccountNumber, Site, AccountSource, Member_Verification_OTP_Invalid_Attempt__c, et4ae5__Mobile_Country_Code__pc, et4ae5__HasOptedOutOfMobile__pc, Mobile_Phone__pc, Mothers_Maiden_Name__pc, Multi_Name__pc, MultiAddress__pc, MultiDOB__pc, MultiMMN__pc, MultiSSN__pc, NA_Eligibility__c, NA_LEHS_Complete__c, NA_LEHS_Update__c, NA_LEOM_Complete__c, NA_LEOM_Update__c, NA_Opt_Out__c, NA_Opt_Out_Date__c, NA_Opt_Out_Updated__c, NA_LEAV_Complete__c, NA_LECF_Complete__c, NA_LECP_Complete__c, NA_LEEM_Complete__c, NA_LEMD_Complete__c, NA_LEMP_Complete__c, NA_LEMQ_Complete__c, NA_LEOL_Complete__c, NA_LEPT_Complete__c, NA_LESB_Complete__c, NA_LESF_Complete__c, NA_LEWS_Complete__c, Name_Format__pc, Occupation__pc, Onbase_Drivers_License__c, Onbase_Signature_Card__c, Ownership, PersonID__pc, Phone, Phone_Type__pc, Rating, Residential_City__pc, Residential_Country__pc, Residential_Country_Code__pc, Residential_Extra_Address__pc, Residential_State__pc, Sex__pc, ShippingCity, ShippingCountry, ShippingCountryCode, ShippingGeocodeAccuracy, ShippingLatitude, ShippingLongitude, ShippingPostalCode, ShippingState, ShippingStateCode, ShippingStreet, Employer_Name__pc, PersonMobilePhone, PersonOtherPhone, PersonLeadSource, Last_NA__c, Last_NA_LEHS__c, Converted_On__c, IsConverted__c, PersonDepartment, PersonLastCURequestDate, PersonLastCUUpdateDate, PersonAssistantName, PersonAssistantPhone, PersonBirthdate, PersonDoNotCall, PersonHasOptedOutOfEmail, PersonHasOptedOutOfFax, Sic, SicDesc, smagicinteract__SMSOptOut__pc, SSN_Last_4__pc, SSN_TIN_Encrypted__pc, SSN_TIN_Type__pc, TickerSymbol, Type, Website, Work_Phone_Extension__pc, Work_Phone__pc
		               FROM Account
		               where RecordType.Name = 'Pre Member' and IsConverted__c = false and Id = :pmid];
		//Committing Code as we are deleting Premember record

		ma.IsConverted__c = true;
		ma.Member__c = pma.Id;
		ma.Converted_On__c = system.now();
		update ma;

		Converted_PreMember__c cpm = new Converted_PreMember__c();
		cpm.Member__c = ma.Id;
		cpm.Pre_Member_Number__c = pma.Pre_Member_Number__c;
		cpm.Parent_Lead__c = pma.Parent_Lead__c;
		cpm.Alt_E_Mail_Address__c = pma.Alternate_Email__pc;
		cpm.Alternate_Email__c = pma.Alt_Email_Raw__c;
		cpm.Annual_Revenue__c = pma.AnnualRevenue;
		cpm.Assistant__c = pma.PersonAssistantName;
		cpm.Asst_Phone__c = pma.PersonAssistantPhone;
		cpm.Birthdate__c = pma.PersonBirthdate;
		cpm.Birth_Date__c = pma.BIRTH_DATE__pc;
		cpm.Death_Date__c = pma.Death_Date__pc;
		cpm.Department__c = pma.PersonDepartment;
		cpm.Description__c = pma.Description;
		cpm.Do_Not_Call__c = pma.PersonDoNotCall;
		cpm.Email_Opt_Out__c = pma.PersonHasOptedOutOfEmail;
		cpm.Email_raw__c = pma.Email_raw__c;
		cpm.Employees__c = pma.NumberOfEmployees;
		cpm.Employee_Restricted_Access__c = pma.Employee_Restricted_Access__c;
		cpm.Employer_Name__c = pma.Employer_Name__pc;
		cpm.Employer_Occupation__c = pma.Employer_Occupation__pc;
		cpm.Extended_Name__c = pma.Extended_Name__pc;
		cpm.E_Mail_Address__c = pma.Email_raw__c;
		cpm.Fax_Opt_Out__c = pma.PersonHasOptedOutOfFax;
		cpm.Fax__c = pma.Fax;
		cpm.Home_Phone_Number__c = pma.Home_Phone_Number__c;
		cpm.Home_Phone__c = pma.Home_Phone__pc;
		cpm.ID_1_Description__c = pma.ID_1_Description__pc;
		cpm.ID_1_Expiration_Date__c = pma.ID_1_Expiration_Date__pc;
		cpm.ID_1_Issuance_Date__c = pma.ID_1_Issuance_Date__pc;
		cpm.ID_1_Number__c = pma.ID_1_Number__pc;
		cpm.ID_1_Verification_Date__c = pma.ID_1_Verification_Date__pc;
		cpm.ID_2_Description__c = pma.ID_2_Description__pc;
		cpm.ID_2_Expiration_Date__c = pma.ID_2_Expiration_Date__pc;
		cpm.ID_2_Issuance_Date__c = pma.ID_2_Issuance_Date__pc;
		cpm.ID_2_Number__c = pma.ID_2_Number__pc;
		cpm.ID_2_Type__c = pma.ID_2_Type__Pc;
		cpm.ID_1_Type__c = pma.ID_1_Type__Pc;
		cpm.ID_2_Verification_Date__c = pma.ID_2_Verification_Date__pc;
		cpm.ID_3_Description__c = pma.ID_3_Description__pc;
		cpm.ID_3_Expiration_Date__c = pma.ID_3_Expiration_Date__pc;
		cpm.ID_3_Issuance_Date__c = pma.ID_3_Issuance_Date__pc;
		cpm.ID_3_Number__c = pma.ID_3_Number__pc;
		cpm.ID_3_Type__c = pma.ID_3_Type__pc;
		cpm.ID_3_Verification_Date__c = pma.ID_3_Verification_Date__pc;
		cpm.Industry__c = pma.Industry;
		cpm.Initial_Record__c = pma.Initial_Record__pc;
		cpm.IsConverted__c = pma.IsConverted__c;
		cpm.Last_NA_LEHS__c = pma.Last_NA_LEHS__c;
		cpm.Last_NA__c = pma.Last_NA__c;
		cpm.Last_Stay_in_Touch_Request_Date__c = pma.PersonLastCURequestDate;
		cpm.Last_Stay_in_Touch_Save_Date__c = pma.PersonLastCUUpdateDate;
		cpm.Lead_Source__c = pma.PersonLeadSource;
		cpm.Member_Number__c = pma.AccountNumber;
		cpm.Member_Record_Type__c = pma.RecordTypeId;
		cpm.Member_Site__c = pma.Site;
		cpm.Member_Source__c = pma.AccountSource;
		cpm.Member_Verification_OTP_Invalid_Attempt__c = pma.Member_Verification_OTP_Invalid_Attempt__c;
		cpm.Name__c = pma.Name;
		cpm.Pre_Member_Number__c = pma.Pre_Member_Number__c;
		cpm.NA_Eligibility__c = pma.NA_Eligibility__c;
		cpm.NA_LEHS_Complete__c = pma.NA_LEHS_Complete__c;
		cpm.NA_LEHS_Update__c = pma.NA_LEHS_Update__c;
		cpm.NA_LEOM_Complete__c = pma.NA_LEOM_Complete__c;
		cpm.NA_LEOM_Update__c = pma.NA_LEOM_Update__c;
		cpm.NA_Opt_Out__c = pma.NA_Opt_Out__c;
		cpm.NA_Opt_Out_Date__c = pma.NA_Opt_Out_Date__c;
		cpm.NA_Opt_Out_Updated__c = pma.NA_Opt_Out_Updated__c;
		cpm.NA_LEAV_Complete__c = pma.NA_LEAV_Complete__c;
		cpm.NA_LECF_Complete__c = pma.NA_LECF_Complete__c;
		cpm.NA_LECP_Complete__c = pma.NA_LECP_Complete__c;
		cpm.NA_LEEM_Complete__c = pma.NA_LEEM_Complete__c;
		cpm.NA_LEMD_Complete__c = pma.NA_LEMD_Complete__c;
		cpm.NA_LEMP_Complete__c = pma.NA_LEMP_Complete__c;
		cpm.NA_LEMQ_Complete__c = pma.NA_LEMQ_Complete__c;
		cpm.NA_LEOL_Complete__c = pma.NA_LEOL_Complete__c;
		cpm.NA_LEPT_Complete__c = pma.NA_LEPT_Complete__c;
		cpm.NA_LESB_Complete__c = pma.NA_LESB_Complete__c;
		cpm.NA_LESF_Complete__c = pma.NA_LESF_Complete__c;
		cpm.NA_LEWS_Complete__c = pma.NA_LEWS_Complete__c;
		cpm.Last_Name__c = pma.LastName;
		cpm.First_Name__c = pma.FirstName;
		cpm.Middle_Name__c = pma.MiddleName;
		cpm.Work_Phone__c = pma.PersonOtherPhone;
		cpm.Work_Phone_Extension__c = pma.Work_Phone_Extension__pc;
		cpm.Work_Phone_Number__c = pma.Work_Phone__pc;
		cpm.Mobile__c = pma.PersonMobilePhone;
		cpm.Mobile_Country_Code__c = pma.et4ae5__Mobile_Country_Code__pc;
		cpm.Mobile_Opt_Out__c = pma.et4ae5__HasOptedOutOfMobile__pc;
		cpm.Mobile_Phone_Number__c = pma.Mobile_Phone__pc;
		cpm.Mothers_Maiden_Name__c = pma.Mothers_Maiden_Name__pc;
		cpm.Occupation__c = pma.Occupation__pc;
		cpm.Residential_City__c = pma.Residential_City__pc;
		cpm.Residential_Country__c = pma.Residential_Country__pc;
		cpm.Residential_Country_Code__c = pma.Residential_Country_Code__pc;
		cpm.Residential_Extra_Address__c = pma.Residential_Extra_Address__pc;
		cpm.Residential_State__c = pma.Residential_State__pc;
		cpm.Residential_Street__c = pma.Residential_Street__pc;
		cpm.Residential_Zipcode__c = pma.Residential_Zipocde__pc;
		insert cpm;

		List<Task> TaskForCPM = new List<Task>();
		List<Event> EventForCPM = new List<Event>();
		List<Case> casesForCPM = new List<Case>();
		List<Opportunity> OpportunityForCPM = new List<Opportunity>();
		List<Needs_Assesment__c> NAForCPM = new List<Needs_Assesment__c>();
		List<Needs_Assesment__c> NAForCMember = new List<Needs_Assesment__c>();
		List<Note> NoteForCPM = new List<Note>();

		List<Task> TaskForPM = new List<Task>();
		List<Event> EventForPM = new List<Event>();
		List<Case> casesForPM = new List<Case>();
		List<Opportunity> OpportunityForPM = new List<Opportunity>();
		List<Needs_Assesment__c> NAForPM = new List<Needs_Assesment__c>();
		List<Needs_Assesment__c> NAForMember = new List<Needs_Assesment__c>();
		List<Note> NoteForPM = new List<Note>();

		TaskForPM = [SELECT AccountId, Id, Status, Subject, Type, WhatId, WhoId
		             FROM Task
		             where WhoId = :pmid];
		EventForPM = [SELECT AccountId, Id, WhatId, WhoId
		              FROM Event
		              where WhoId = :pmid];
		casesForPM = [SELECT AccountId, Id
		              FROM Case
		              where AccountId = :pmid];
		OpportunityForPM = [Select Id, AccountId, IsMemberOpportunity__c, StageName, Product_Type__c, Product_Sub__c, Brand__c
		                    from opportunity
		                    where AccountId = :pmid];
		NAForPM = [SELECT Rec_Comment_New__c, LEWS_Comment_New__c, LESF_Comments_New__c, LESB_SharedBranching_Comments_New__c, LEPT_Comments_New__c, LEOM_PlanUnforeseen_New__c, LEOM_Comments_New__c, LEMP_Transfer_Comments_New__c, LEMP_Payment_Transfer_Comments_New__c, LEMP_International_Transfer_Comments_New__c, LEMP_Debit_Card_Usage_Comments_New__c, LEMP_Credit_Card_You_Use_Often_New__c, LEMP_Credit_Card_Usage_Reason_Comments_N__c, LEMP_Credit_Card_Usage_Other_New__c, LEMP_Credit_Card_Usage_Comments_New__c, LEMD_CommentsForDD_New__c, LEMD_CommentsDC_New__c, LEHS_Comment_New__c, LEEM_Comments_New__c, LEAV_ContactPreferences_New__c, LECF_Comment_New__c, LECF_Experience_Improvement_Feedback_New__c, Member__r.BIRTH_DATE__pc, CDs__c, College_Plan__c, College_Timeframe__c, College__c, Complete_PFCE__c, CreatedById, CreatedDate, Do_you_Rent_or_Own__c, EBMS_Complete__c, EMYS_Complete__c, Home_Improvement_Plan__c, Home_Improvement_Timeframe__c, Home_Improvement__c, Housing_Last_Updated_On__c, Id, IsDeleted, LastModifiedById, LastModifiedDate, LastReferencedDate, LastViewedDate, Last_LEHS__c, Last_LEOM__c, LEAV_AnticipateFinance__c, LEAV_ContactPreferences__c, LEAV_CurrentBalance__c, LEAV_CurrentLoanProvider__c, LEAV_CurrentRate__c, LEAV_Current__c, LEAV_EndDateLoan__c, LEAV_Last_Updated_On__c, LEAV_PlanDate__c, LEAV_PlanningToBuy__c, LECF_800_Feedback__c, LECF_800__c, LECF_ATM_Feedback__c, LECF_ATM__c, LECF_Branch_Feedback__c, LECF_Branch__c, LECF_Comment__c, LECF_Experience_Improvement_Feedback__c, LECF_Last_Updated_On__c, LECF_Member_Feedback__c, LECF_Mobile_banking_Feedback__c, LECF_Mobile_banking__c, LECF_Online_banking_Feedback__c, LECF_Online_banking__c, LECP_Comments__c, LECP_ContactPhone_No__c, LECP_ContactPhone_Yes__c, LECP_Last_Updated_On__c, LECP_Written_Materials_Way_To_Send_Email__c, LECP_Written_Materials_Way_To_Send_Mail__c, LEEM_Comments__c, LEEM_Deductible_Plan_No__c, LEEM_Deductible_Plan_Yes__c, LEEM_Deductible_Plan__c, LEEM_Health_Savings_Account_No__c, LEEM_Health_Savings_Account_Yes__c, LEEM_Health_Savings_Account__c, LEEM_Last_Updated_On__c, LEEM_Money_In_Primary_Account__c, LEEM_Retirement_Savings_Accounts_Comment__c, LEEM_Savings_For_Retirement_401__c, LEEM_Savings_For_Retirement_IRA__c, LEEM_Savings_For_Retirement_O_Account__c, LEEM_Savings_For_Retirement_O_R_Account__c, LEHS_1_Status__c, LEHS_2_Status__c, LEHS_Comment__c, LEHS_Complete__c, LEHS_Current_Balance__c, LEHS_Current_Lender__c, LEHS_End_Date__c, LEHS_End_Year__c, LEHS_Have_Realtor__c, LEHS_Last_Updated_On__c, LEHS_Planning_to_Purchase__c, LEHS_Purchase_When__c, LEHS_Rate__c, LEHS_Type_of_Mortgage__c, LEMD_ATM__c, LEMD_At_another_financial_institution__c, LEMD_At_another_financial_insti_YesNo__c, LEMD_CFCU_Spectrum_YesNo__c, LEMD_CFCU_Spectrum__c, LEMD_CommentsDC__c, LEMD_CommentsForDD__c, LEMD_In_person_branch__c, LEMD_Last_Updated_On__c, LEMD_Mobile__c, LEMD_No__c, LEMD_Online__c, LEMP_Carry_Credit_Card_Balance__c, LEMP_Credit_Card_Usage_Cash_Back__c, LEMP_Credit_Card_Usage_Comments__c, LEMP_Credit_Card_Usage_Low_Interest_Rate__c, LEMP_Credit_Card_Usage_No_Annual_Fee__c, LEMP_Credit_Card_Usage_Other__c, LEMP_Credit_Card_Usage_Reason_Comments__c, LEMP_Credit_Card_Usage_Rewards__c, LEMP_Credit_Card_You_Use_Often__c, LEMP_Debit_Card_Usage_Comments__c, LEMP_Debit_Card_Usage_Gasstation__c, LEMP_Debit_Card_Usage_Grocries__c, LEMP_Debit_Card_Usage_Online__c, LEMP_Debit_Card_Usage_Other__c, LEMP_Debit_Card_Usage_Retail__c, LEMP_International_Transfer_Comments__c, LEMP_International_Transfer_Frequency__c, LEMP_Last_Updated_On__c, LEMP_Payment_Transfer_Comments__c, LEMP_Pay_Individuals_A2A__c, LEMP_Pay_Individuals_ACH__c, LEMP_Pay_Individuals_BillPay__c, LEMP_Pay_Individuals_CC__c, LEMP_Pay_Individuals_Check__c, LEMP_Pay_Individuals_DC__c, LEMP_Pay_Individuals_Other__c, LEMP_Pay_MoveMoney_A2A__c, LEMP_Pay_MoveMoney_ACH__c, LEMP_Pay_MoveMoney_BillPay__c, LEMP_Pay_MoveMoney_CC__c, LEMP_Pay_MoveMoney_Check__c, LEMP_Pay_MoveMoney_DC__c, LEMP_Pay_MoveMoney_Other__c, LEMP_Pay_Recurring_A2A__c, LEMP_Pay_Recurring_ACH__c, LEMP_Pay_Recurring_BillPay__c, LEMP_Pay_Recurring_CC__c, LEMP_Pay_Recurring_Check__c, LEMP_Pay_Recurring_DC__c, LEMP_Pay_Recurring_Other__c, LEMP_Transfer_Comments__c, LEMP_Transfer_Frequency__c, LEMQ_Last_Updated_On__c, LEOL_Last_Updated_On__c, LEOL_Other_Existing_Loans__c, LEOM_1_Status__c, LEOM_2_Status__c, LEOM_3_Status__c, LEOM_4_Status__c, LEOM_5_Status__c, LEOM_6_Status__c, LEOM_7_Status__c, LEOM_College_Update__c, LEOM_Comments__c, LEOM_Complete__c, LEOM_Home_Update__c, LEOM_Last_Updated_On__c, LEOM_Life_Events_Update__c, LEOM_Medical_Update__c, LEOM_Other_Expenses_Update__c, LEOM_PlanUnforeseen__c, LEOM_Retirement_Update__c, LEOM_RV_Boat_Update__c, LEOM_Travel_Update__c, LEPT_Comments__c, LEPT_Convenient_locations__c, LEPT_Deposit_rates__c, LEPT_Financial_Institution__c, LEPT_Have_financial_advisor_there__c, LEPT_Last_Response_Date_for_Comments__c, LEPT_Last_Response_Date_For_FI__c, LEPT_Last_Updated_On__c, LEPT_Loan_rates__c, LEPT_Online_mobile_apps__c, LEPT_Other__c, LESB_Aware_ConvBranching__c, LESB_Aware_SharedBranching__c, LESB_Last_Updated_On__c, LESB_SharedBranching_Comments__c, LESF_ATM_Location_YesNo__c, LESF_ATM_Location__c, LESF_Aware_ATM_Netword__c, LESF_Aware_ATM_Network_YesNo__c, LESF_Comments__c, LESF_Last_Updated_On__c, LEWS_CFCU_ATM__c, LEWS_Comment__c, LEWS_InPerson__c, LEWS_Last_Updated_On__c, LEWS_Other_ATM__c, LEWS_Shared_ATM__c, Life_Events_Plan__c, Life_Events_Timeframe__c, Life_Events__c, Medical_Plan__c, Medical_Timeframe__c, Medical__c, Member__c, Modification_Period__c, Name, Other_Plan__c, Other_Timeframe__c, Other__c, Purchase_RV_Boat_Plan__c, Purchase_RV_Boat_Timeframe__c, Purchase_RV_Boat__c, Rec_Comment__c, REC_LEAV_1__c, REC_LEAV_Outcome_1__c, REC_LECF_1__c, REC_LECF_2__c, REC_LECF_3__c, REC_LECF_4__c, REC_LECF_Outcome_1__c, REC_LECF_Outcome_2__c, REC_LECF_Outcome_3__c, REC_LECF_Outcome_4__c, REC_LEEM_1__c, REC_LEEM_2__c, Rec_LEEM_Outcome_1__c, Rec_LEEM_Outcome_2__c, Rec_LEHS_1_Outcome__c, Rec_LEHS_1__c, Rec_LEHS_2__c, Rec_LEHS_3__c, Rec_LEHS_Outcome_2__c, Rec_LEHS_Outcome_3__c, REC_LEMD_1__c, REC_LEMD_2__c, REC_LEMD_3__c, REC_LEMD_Outcome_1__c, REC_LEMD_Outcome_2__c, REC_LEMD_Outcome_3__c, REC_LEMP_1__c, REC_LEMP_2__c, REC_LEMP_3__c, REC_LEMP_4__c, REC_LEMP_5__c, REC_LEMP_6__c, REC_LEMP_7__c, REC_LEMP_8__c, REC_LEMP_Outcome_1__c, REC_LEMP_Outcome_2__c, REC_LEMP_Outcome_3__c, REC_LEMP_Outcome_4__c, REC_LEMP_Outcome_5__c, REC_LEMP_Outcome_6__c, REC_LEMP_Outcome_7__c, REC_LEMP_Outcome_8__c, Rec_LEMQ_1__c, REC_LEMQ_Outcome_1__c, Rec_LEOL_1__c, Rec_LEOL_2__c, Rec_LEOL_Outcome_1__c, Rec_LEOL_Outcome_2__c, Rec_LEOM_1__c, Rec_LEOM_2__c, Rec_LEOM_3__c, Rec_LEOM_4__c, Rec_LEOM_5__c, Rec_LEOM_6__c, Rec_LEOM_7__c, Rec_LEOM_Outcome_1__c, Rec_LEOM_Outcome_2__c, Rec_LEOM_Outcome_3__c, Rec_LEOM_Outcome_4__c, Rec_LEOM_Outcome_5__c, Rec_LEOM_Outcome_6__c, Rec_LEOM_Outcome_7__c, REC_LEPT_1__c, REC_LEPT_Outcome_1__c, Retirement_New__c, Retirement_Plan__c, Retirement_Timeframe__c, Retirement__c, Role_Name__c, SystemModstamp, Travel_Plan__c, Travel_Timeframe__c, Travel__c
		           FROM Needs_Assesment__c
		           where Member__c = :pmid];

		NAForMember = [SELECT Rec_Comment_New__c, LEWS_Comment_New__c, LESF_Comments_New__c, LESB_SharedBranching_Comments_New__c, LEPT_Comments_New__c, LEOM_PlanUnforeseen_New__c, LEOM_Comments_New__c, LEMP_Transfer_Comments_New__c, LEMP_Payment_Transfer_Comments_New__c, LEMP_International_Transfer_Comments_New__c, LEMP_Debit_Card_Usage_Comments_New__c, LEMP_Credit_Card_You_Use_Often_New__c, LEMP_Credit_Card_Usage_Reason_Comments_N__c, LEMP_Credit_Card_Usage_Other_New__c, LEMP_Credit_Card_Usage_Comments_New__c, LEMD_CommentsForDD_New__c, LEMD_CommentsDC_New__c, LEHS_Comment_New__c, LEEM_Comments_New__c, LEAV_ContactPreferences_New__c, LECF_Comment_New__c, LECF_Experience_Improvement_Feedback_New__c, Member__r.BIRTH_DATE__pc, CDs__c, College_Plan__c, College_Timeframe__c, College__c, Complete_PFCE__c, CreatedById, CreatedDate, Do_you_Rent_or_Own__c, EBMS_Complete__c, EMYS_Complete__c, Home_Improvement_Plan__c, Home_Improvement_Timeframe__c, Home_Improvement__c, Housing_Last_Updated_On__c, Id, IsDeleted, LastModifiedById, LastModifiedDate, LastReferencedDate, LastViewedDate, Last_LEHS__c, Last_LEOM__c, LEAV_AnticipateFinance__c, LEAV_ContactPreferences__c, LEAV_CurrentBalance__c, LEAV_CurrentLoanProvider__c, LEAV_CurrentRate__c, LEAV_Current__c, LEAV_EndDateLoan__c, LEAV_Last_Updated_On__c, LEAV_PlanDate__c, LEAV_PlanningToBuy__c, LECF_800_Feedback__c, LECF_800__c, LECF_ATM_Feedback__c, LECF_ATM__c, LECF_Branch_Feedback__c, LECF_Branch__c, LECF_Comment__c, LECF_Experience_Improvement_Feedback__c, LECF_Last_Updated_On__c, LECF_Member_Feedback__c, LECF_Mobile_banking_Feedback__c, LECF_Mobile_banking__c, LECF_Online_banking_Feedback__c, LECF_Online_banking__c, LECP_Comments__c, LECP_ContactPhone_No__c, LECP_ContactPhone_Yes__c, LECP_Last_Updated_On__c, LECP_Written_Materials_Way_To_Send_Email__c, LECP_Written_Materials_Way_To_Send_Mail__c, LEEM_Comments__c, LEEM_Deductible_Plan_No__c, LEEM_Deductible_Plan_Yes__c, LEEM_Deductible_Plan__c, LEEM_Health_Savings_Account_No__c, LEEM_Health_Savings_Account_Yes__c, LEEM_Health_Savings_Account__c, LEEM_Last_Updated_On__c, LEEM_Money_In_Primary_Account__c, LEEM_Retirement_Savings_Accounts_Comment__c, LEEM_Savings_For_Retirement_401__c, LEEM_Savings_For_Retirement_IRA__c, LEEM_Savings_For_Retirement_O_Account__c, LEEM_Savings_For_Retirement_O_R_Account__c, LEHS_1_Status__c, LEHS_2_Status__c, LEHS_Comment__c, LEHS_Complete__c, LEHS_Current_Balance__c, LEHS_Current_Lender__c, LEHS_End_Date__c, LEHS_End_Year__c, LEHS_Have_Realtor__c, LEHS_Last_Updated_On__c, LEHS_Planning_to_Purchase__c, LEHS_Purchase_When__c, LEHS_Rate__c, LEHS_Type_of_Mortgage__c, LEMD_ATM__c, LEMD_At_another_financial_institution__c, LEMD_At_another_financial_insti_YesNo__c, LEMD_CFCU_Spectrum_YesNo__c, LEMD_CFCU_Spectrum__c, LEMD_CommentsDC__c, LEMD_CommentsForDD__c, LEMD_In_person_branch__c, LEMD_Last_Updated_On__c, LEMD_Mobile__c, LEMD_No__c, LEMD_Online__c, LEMP_Carry_Credit_Card_Balance__c, LEMP_Credit_Card_Usage_Cash_Back__c, LEMP_Credit_Card_Usage_Comments__c, LEMP_Credit_Card_Usage_Low_Interest_Rate__c, LEMP_Credit_Card_Usage_No_Annual_Fee__c, LEMP_Credit_Card_Usage_Other__c, LEMP_Credit_Card_Usage_Reason_Comments__c, LEMP_Credit_Card_Usage_Rewards__c, LEMP_Credit_Card_You_Use_Often__c, LEMP_Debit_Card_Usage_Comments__c, LEMP_Debit_Card_Usage_Gasstation__c, LEMP_Debit_Card_Usage_Grocries__c, LEMP_Debit_Card_Usage_Online__c, LEMP_Debit_Card_Usage_Other__c, LEMP_Debit_Card_Usage_Retail__c, LEMP_International_Transfer_Comments__c, LEMP_International_Transfer_Frequency__c, LEMP_Last_Updated_On__c, LEMP_Payment_Transfer_Comments__c, LEMP_Pay_Individuals_A2A__c, LEMP_Pay_Individuals_ACH__c, LEMP_Pay_Individuals_BillPay__c, LEMP_Pay_Individuals_CC__c, LEMP_Pay_Individuals_Check__c, LEMP_Pay_Individuals_DC__c, LEMP_Pay_Individuals_Other__c, LEMP_Pay_MoveMoney_A2A__c, LEMP_Pay_MoveMoney_ACH__c, LEMP_Pay_MoveMoney_BillPay__c, LEMP_Pay_MoveMoney_CC__c, LEMP_Pay_MoveMoney_Check__c, LEMP_Pay_MoveMoney_DC__c, LEMP_Pay_MoveMoney_Other__c, LEMP_Pay_Recurring_A2A__c, LEMP_Pay_Recurring_ACH__c, LEMP_Pay_Recurring_BillPay__c, LEMP_Pay_Recurring_CC__c, LEMP_Pay_Recurring_Check__c, LEMP_Pay_Recurring_DC__c, LEMP_Pay_Recurring_Other__c, LEMP_Transfer_Comments__c, LEMP_Transfer_Frequency__c, LEMQ_Last_Updated_On__c, LEOL_Last_Updated_On__c, LEOL_Other_Existing_Loans__c, LEOM_1_Status__c, LEOM_2_Status__c, LEOM_3_Status__c, LEOM_4_Status__c, LEOM_5_Status__c, LEOM_6_Status__c, LEOM_7_Status__c, LEOM_College_Update__c, LEOM_Comments__c, LEOM_Complete__c, LEOM_Home_Update__c, LEOM_Last_Updated_On__c, LEOM_Life_Events_Update__c, LEOM_Medical_Update__c, LEOM_Other_Expenses_Update__c, LEOM_PlanUnforeseen__c, LEOM_Retirement_Update__c, LEOM_RV_Boat_Update__c, LEOM_Travel_Update__c, LEPT_Comments__c, LEPT_Convenient_locations__c, LEPT_Deposit_rates__c, LEPT_Financial_Institution__c, LEPT_Have_financial_advisor_there__c, LEPT_Last_Response_Date_for_Comments__c, LEPT_Last_Response_Date_For_FI__c, LEPT_Last_Updated_On__c, LEPT_Loan_rates__c, LEPT_Online_mobile_apps__c, LEPT_Other__c, LESB_Aware_ConvBranching__c, LESB_Aware_SharedBranching__c, LESB_Last_Updated_On__c, LESB_SharedBranching_Comments__c, LESF_ATM_Location_YesNo__c, LESF_ATM_Location__c, LESF_Aware_ATM_Netword__c, LESF_Aware_ATM_Network_YesNo__c, LESF_Comments__c, LESF_Last_Updated_On__c, LEWS_CFCU_ATM__c, LEWS_Comment__c, LEWS_InPerson__c, LEWS_Last_Updated_On__c, LEWS_Other_ATM__c, LEWS_Shared_ATM__c, Life_Events_Plan__c, Life_Events_Timeframe__c, Life_Events__c, Medical_Plan__c, Medical_Timeframe__c, Medical__c, Member__c, Modification_Period__c, Name, Other_Plan__c, Other_Timeframe__c, Other__c, Purchase_RV_Boat_Plan__c, Purchase_RV_Boat_Timeframe__c, Purchase_RV_Boat__c, Rec_Comment__c, REC_LEAV_1__c, REC_LEAV_Outcome_1__c, REC_LECF_1__c, REC_LECF_2__c, REC_LECF_3__c, REC_LECF_4__c, REC_LECF_Outcome_1__c, REC_LECF_Outcome_2__c, REC_LECF_Outcome_3__c, REC_LECF_Outcome_4__c, REC_LEEM_1__c, REC_LEEM_2__c, Rec_LEEM_Outcome_1__c, Rec_LEEM_Outcome_2__c, Rec_LEHS_1_Outcome__c, Rec_LEHS_1__c, Rec_LEHS_2__c, Rec_LEHS_3__c, Rec_LEHS_Outcome_2__c, Rec_LEHS_Outcome_3__c, REC_LEMD_1__c, REC_LEMD_2__c, REC_LEMD_3__c, REC_LEMD_Outcome_1__c, REC_LEMD_Outcome_2__c, REC_LEMD_Outcome_3__c, REC_LEMP_1__c, REC_LEMP_2__c, REC_LEMP_3__c, REC_LEMP_4__c, REC_LEMP_5__c, REC_LEMP_6__c, REC_LEMP_7__c, REC_LEMP_8__c, REC_LEMP_Outcome_1__c, REC_LEMP_Outcome_2__c, REC_LEMP_Outcome_3__c, REC_LEMP_Outcome_4__c, REC_LEMP_Outcome_5__c, REC_LEMP_Outcome_6__c, REC_LEMP_Outcome_7__c, REC_LEMP_Outcome_8__c, Rec_LEMQ_1__c, REC_LEMQ_Outcome_1__c, Rec_LEOL_1__c, Rec_LEOL_2__c, Rec_LEOL_Outcome_1__c, Rec_LEOL_Outcome_2__c, Rec_LEOM_1__c, Rec_LEOM_2__c, Rec_LEOM_3__c, Rec_LEOM_4__c, Rec_LEOM_5__c, Rec_LEOM_6__c, Rec_LEOM_7__c, Rec_LEOM_Outcome_1__c, Rec_LEOM_Outcome_2__c, Rec_LEOM_Outcome_3__c, Rec_LEOM_Outcome_4__c, Rec_LEOM_Outcome_5__c, Rec_LEOM_Outcome_6__c, Rec_LEOM_Outcome_7__c, REC_LEPT_1__c, REC_LEPT_Outcome_1__c, Retirement_New__c, Retirement_Plan__c, Retirement_Timeframe__c, Retirement__c, Role_Name__c, SystemModstamp, Travel_Plan__c, Travel_Timeframe__c, Travel__c
		               FROM Needs_Assesment__c
		               where Member__c = :mid];

		NoteForPm = [SELECT Id, ParentId
		             FROM Note
		             where ParentId = :pmid];
		List<Task> updatetask = new List<Task>();
		List<Event> updateEvent = new List<Event>();
		List<Opportunity> updateopp = new List<Opportunity>();
		List<Case> updatecase = new List<Case>();
		List<Needs_Assesment__c> updateNA = new List<Needs_Assesment__c>();
		List<Note> updatenote = new List<Note>();
		ID memberid;
		Set<Id> AssessmentId = new Set<Id>();
		for (Needs_Assesment__c na : NAForPM){
			AssessmentId.Add(na.Id);
		}
		list<NA_Other_Existing_Loans__c> otherExistingLoans = new list<NA_Other_Existing_Loans__c>();
		otherExistingLoans = [Select Balance__c, CreatedById, CreatedDate, End_Date__c, Financial_Institution__c, Id, IsDeleted, LastModifiedById, LastModifiedDate, Name, Needs_Assessment__c, Rate__c, SystemModstamp, Type_of_Loan__c
		                      from NA_Other_Existing_Loans__c
		                      where Needs_Assessment__c IN:AssessmentId];

		list<NA_Membership_Referral_Questions__c> loans = new list<NA_Membership_Referral_Questions__c>();
		loans = [SELECT Age__c, CreatedById, CreatedDate, Id, IsDeleted, LastModifiedById, LastModifiedDate, Name, Name__c, Needs_Assessment__c, OwnerId, SystemModstamp, Want_to_Refer_Membership__c
		         from NA_Membership_Referral_Questions__c
		         where Needs_Assessment__c = :AssessmentId];

		list<NA_Deposit__c> deposits = new list<NA_Deposit__c>();
		deposits = [SELECT Balance__c, CreatedById, CreatedDate, Financial_Instituition__c, Id, IsDeleted, LastModifiedById, LastModifiedDate, Name, Needs_Assessment__c, Rate__c, SystemModstamp, Type__c
		            from NA_Deposit__c
		            where Needs_Assessment__c = :AssessmentId];

		list<NA_Other_Existing_Loans__c> InsertotherExistingLoans = new list<NA_Other_Existing_Loans__c>();
		list<NA_Membership_Referral_Questions__c> Insertloans = new list<NA_Membership_Referral_Questions__c>();
		list<NA_Deposit__c> Insertdeposits = new list<NA_Deposit__c>();

		Boolean MemberAbove18 = true;
		Boolean PrimaryAccountWithAtleastoneTrust = false;
		Boolean Eligibility = false;
		List<Person_Account__c> paList = [SELECT Id, Account_Number__c, Account_Number__r.RecType__c, Relationship__c, Account_Number__r.TypeTranslate__c, TypeTranslate__c, Account_Number__r.Name
		                                  FROM Person_Account__c
		                                  WHERE PersonID__c = :mid and Account_Number__r.RecType__c = 'ACCT' and (Account_Number__r.TypeTranslate__c != '2-TRUST' or Account_Number__r.TYPE__c != 2) and TypeTranslate__c like '%PRIMARY%'];
		if (paList.size() > 0){
			PrimaryAccountWithAtleastoneTrust = true;
		}

		if (TaskForPM.Size() > 0){
			for (Task t : TaskForPM){

				t.WhoId = mid;
				updatetask.Add(t);
			}
			update updatetask;
		}

		if (EventForPM.Size() > 0){
			for (Event e : EventForPM){

				e.WhoId = mid;
				updateEvent.Add(e);
			}

			update updateEvent;
		}

		if (casesForPM.Size() > 0){
			for (Case c : casesForPM){
				c.AccountId = mid;
				updatecase.Add(c);
			}

			update updatecase;
		}


		if (OpportunityForPM.Size() > 0){
			for (Opportunity opp : OpportunityForPM){

				opp.AccountId = mid;
				opp.Allow_Error__c = true;
				if (opp.Product_Type__c == 'Accounts/Shares' && opp.Product_Sub__c == 'Membership'){
					opp.StageName = 'Closed Won';

				}

				updateopp.add(opp);

			}
			update updateopp;
		}
		if (NAForPm.Size() > 0){
			for (Needs_Assesment__c na : NAForPM){
				if (na.Member__r.BIRTH_DATE__pc != null){
					MemberAbove18 = na.Member__r.BIRTH_DATE__pc.addyears(18) < System.Today();
				}

				if (PrimaryAccountWithAtleastoneTrust && MemberAbove18){
					Eligibility = true;
				}

				if (Eligibility == false){
					delete na;
				} else{
					if (NAForMember.size() == 0){
						Id naid;
						na.id = null;
						na.Member__c = mid;
						insert na;
						naid = na.id;
						if (otherExistingLoans.size() > 0){
							for (NA_Other_Existing_Loans__c exloan : otherExistingLoans){
								exloan.id = null;
								exloan.Needs_Assessment__c = naid;
								InsertotherExistingLoans.add(exloan);

							}

							insert InsertotherExistingLoans;
						}

						if (loans.size() > 0){
							for (NA_Membership_Referral_Questions__c refques : loans){
								refques.id = null;
								refques.Needs_Assessment__c = naid;
								Insertloans.Add(refques);
							}

							insert Insertloans;
						}

						if (deposits.size() > 0){
							for (NA_Deposit__c dep : deposits){
								dep.id = null;
								dep.Needs_Assessment__c = naid;
								Insertdeposits.Add(dep);
							}

							insert Insertdeposits;
						}
						ma.NA_Eligibility__c = pma.NA_Eligibility__c;
						ma.NA_LEHS_Complete__c = pma.NA_LEHS_Complete__c;
						ma.NA_LEHS_Update__c = pma.NA_LEHS_Update__c;
						ma.NA_LEOM_Complete__c = pma.NA_LEOM_Complete__c;
						ma.NA_LEOM_Update__c = pma.NA_LEOM_Update__c;
						ma.NA_Opt_Out__c = pma.NA_Opt_Out__c;
						ma.NA_Opt_Out_Date__c = pma.NA_Opt_Out_Date__c;
						ma.NA_Opt_Out_Updated__c = pma.NA_Opt_Out_Updated__c;
						ma.NA_LEAV_Complete__c = pma.NA_LEAV_Complete__c;
						ma.NA_LECF_Complete__c = pma.NA_LECF_Complete__c;
						ma.NA_LECP_Complete__c = pma.NA_LECP_Complete__c;
						ma.NA_LEEM_Complete__c = pma.NA_LEEM_Complete__c;
						ma.NA_LEMD_Complete__c = pma.NA_LEMD_Complete__c;
						ma.NA_LEMP_Complete__c = pma.NA_LEMP_Complete__c;
						ma.NA_LEMQ_Complete__c = pma.NA_LEMQ_Complete__c;
						ma.NA_LEOL_Complete__c = pma.NA_LEOL_Complete__c;
						ma.NA_LEPT_Complete__c = pma.NA_LEPT_Complete__c;
						ma.NA_LESB_Complete__c = pma.NA_LESB_Complete__c;
						ma.NA_LESF_Complete__c = pma.NA_LESF_Complete__c;
						ma.NA_LEWS_Complete__c = pma.NA_LEWS_Complete__c;


					}
				}

			}

			update ma;

		}
		List<id> lst = new List<id>();
		lst.add(mid);
		ManualMemberMergeProcess.SetOppBranch(lst);

		if (NoteForPM.size() > 0){
			for (Note n : NoteForPM){
				n.ParentId = mid;
				updatenote.Add(n);
			}
			update updatenote;
		}


		Logs__c logs = new Logs__c();

		logs.Converted_Date__c = system.now();
		logs.Pre_Member_Owner__c = pma.Owner.Name;
		logs.Lead_Number__c = pma.Pre_Member_Number__c;
		logs.Pre_Member_Created_Date__c = pma.CreatedDate;
		logs.Pre_Member_ID__c = pma.id;

		insert logs;
		SetMergerReportData(ma, pma);
		//Deleting Premember after conversion
		delete pma;
	}

	public class AccountWrapper implements Comparable{
		public Account account;
		public Integer counter;
		public AccountWrapper(Account account, Integer counter){
			this.account = account;
			this.counter = counter;
		}

		public Integer compareTo(Object other){
			return counter - ((AccountWrapper)other).counter;
		}

	}

	public static void SetOppBranch(List<Id> MemId){

		Map<id, Person_Account__c> MapPA = new Map<id, Person_Account__c>();
		set<id> PersonId = new Set<id>();
		For (Person_Account__c PA : [select id, PersonID__c, Account_Number__r.RecType__c, Account_Number__r.Created_At_Branch1__c, Account_Number__c
		                             from Person_Account__c
		                             where PersonID__c in:MemId and Account_Number__r.RecType__c = 'ACCT'
		                             ORDER BY Account_Number__r.RecType__c]){
			if (!PersonId.contains(PA.Account_Number__c)){
				PersonId.add(PA.PersonID__c);
				MapPA.put(PA.PersonID__c, PA);

			}
		}
		list<Opportunity> LstOpp = New List<Opportunity>();
		List<Opportunity> CloseOpp = new List<Opportunity>();
		for (Opportunity op : [select id, Member_Account__c, Member_Branch__c, AccountId, StageName, Sub_Status__c
		                       from Opportunity
		                       where IsMemberOpportunity__c = :false and AccountId = :MemId]){
			if (MapPA.containsKey(op.AccountId)){
				op.Member_Account__c = MapPA.get(op.AccountId).Account_Number__c;
				op.Member_Branch__c = MapPA.get(op.AccountId).Account_Number__r.Created_At_Branch1__c;
			}
			op.IsMemberOpportunity__c = true;
			op.Allow_Error__c = true;
			LstOpp.add(op);
		}

		update LstOpp;
	}

	public static boolean CheckMembership(){

		//Declaring a Set as we don't want Duplicate Group Ids
		Set<Id> results = new Set<Id>();

		///Declaring a Map for Group with Role
		Map<Id, Id> grRoleMap = new Map<Id, Id>();

		//Populating the Map with RelatedID(i.e.UserRoledId) as Key
		for (Group gr : [select id, relatedid, name
		                 from Group]){
			grRoleMap.put(gr.relatedId, gr.id);
		}

		//Groups directly associated to user
		Set<Id> groupwithUser = new Set<Id>();

		//Populating the Group with User with GroupId we are filtering only  for Group of Type Regular,Role and RoleAndSubordinates
		for (GroupMember u : [select groupId
		                      from GroupMember
		                      where UserOrGroupId = :UserInfo.getUserId() and (Group.Type = 'Regular' OR Group.Type = 'Role' OR Group.Type = 'RoleAndSubordinates')]){
			groupwithUser.add(u.groupId);
		}

		//Groups with Role
		for (User u : [select UserRoleId
		               from User
		               where id = :UserInfo.getUserId()]){
			//Checking if the current User Role is part of Map or not
			if (grRoleMap.containsKey(u.UserRoleId)){
				results.add(grRoleMap.get(u.UserRoleId));
			}
		}
		//Combining both the Set
		results.addAll(groupwithUser);

		//Traversing the whole list of Groups to check any other nested Group
		Map<Id, Id> grMap = new Map<Id, Id>();
		for (GroupMember gr : [select id, UserOrGroupId, Groupid
		                       from GroupMember
		                       where (Group.Type = 'Regular' OR Group.Type = 'Role' OR Group.Type = 'RoleAndSubordinates')]){
			grMap.put(gr.UserOrGroupId, gr.Groupid);
		}
		for (Id i : results){
			if (grMap.containsKey(i)){
				results.add(grMap.get(i));
			}
		}

		boolean ShowData = false;

		list<GroupMember> listNamegroup = [select group.developerName
		                                   from GroupMember
		                                   where UserOrGroupId in:results];
		set<string> listName = new set<string>();
		for (GroupMember i : listNamegroup){

			listName.add(i.group.developerName);

		}

		if (listName.contains('ManualMember_Merge_Process_Admin')){
			ShowData = true;
		}

		Set<String> groupNames = new Set<String>();
		for (GroupMember gm : [select group.name, group.DeveloperName
		                       from GroupMember
		                       where UserOrGroupId = :UserInfo.getUserId()]){
			groupNames.add(gm.group.DeveloperName);
		}

		if (groupNames.contains('ManualMember_Merge_Process_Admin')){
			ShowData = true;
		}

		return showdata;
	}

	public static void SetMergerReportData(Account ma, Account pma){
		Boolean IsMatching = false;
		Boolean IsPhoneMatching = false;
		Boolean IsEmailMatching = false;
		Boolean IsStreetMatching = false;
		Boolean IsCityMatching = false;
		Boolean IsStateMatching = false;
		Boolean IsZipcodeMatching = false;
		Boolean IsFirstNameMatching = false;
		Boolean IsLastNameMatching = false;
		String FirstName;
		String LastName;
		String ma_email_check = '';
		if (!string.isBlank(ma.Alternate_Email__pc)){
			ma_email_check = ma_email_check + ma.Alternate_Email__pc.toUpperCase() + ',';
		}
		if (!string.isBlank(ma.Alt_Email_Raw__c)){
			ma_email_check = ma_email_check + ma.Alt_Email_Raw__c.toUpperCase() + ',';
		}
		if (!string.isBlank(ma.PersonEmail)){
			ma_email_check = ma_email_check + ma.PersonEmail.toUpperCase() + ',';
		}
		if (!string.isBlank(ma.Email_raw__c)){
			ma_email_check = ma_email_check + ma.Email_raw__c.toUpperCase() + ',';
		}

		if (!string.isBlank(ma_email_check) && !string.isBlank(ma.LastName) && !string.isBlank(ma.FirstName) && !string.isBlank(pma.LastName) && !string.isBlank(pma.FirstName) && ((!string.isBlank(pma.Alternate_Email__pc) && ma_email_check.contains(pma.Alternate_Email__pc.toUpperCase())) || (!string.isBlank(pma.Alt_Email_Raw__c) && ma_email_check.contains(pma.Alt_Email_Raw__c.toUpperCase())) || (!string.isBlank(pma.Email_raw__c) && ma_email_check.contains(pma.Email_raw__c.toUpperCase())) || (!string.isBlank(pma.PersonEmail) && ma_email_check.contains(pma.PersonEmail.toUpperCase()))) && ma.LastName.toUpperCase() == pma.LastName.toUpperCase() && ma.FirstName.toUpperCase() == pma.FirstName.toUpperCase()){

			IsEmailMatching = true;


		}

		if (!string.isBlank(ma.LastName) && !string.isBlank(ma.FirstName) && !string.isBlank(ma.Phone_Check__c) && !string.isBlank(pma.LastName) && !string.isBlank(pma.FirstName) && !string.isBlank(pma.Phone_Check__c) && ma.LastName == pma.LastName && ma.FirstName == pma.FirstName && ((!string.isBlank(pma.Home_Phone__pc) && ma.Phone_Check__c.Contains(ConvertPreMemberToMemberSchedular.clearPhoneNumber(pma.Home_Phone__pc))) || (!string.isBlank(pma.Work_Phone__pc) && ma.Phone_Check__c.Contains(ConvertPreMemberToMemberSchedular.clearPhoneNumber(pma.Work_Phone__pc))) || (!string.isBlank(pma.Mobile_Phone__pc) && ma.Phone_Check__c.Contains(ConvertPreMemberToMemberSchedular.clearPhoneNumber(pma.Mobile_Phone__pc))))){

			IsPhoneMatching = true;

		}
		if (!string.isBlank(ma.LastName) && !string.isBlank(ma.FirstName) && !string.isBlank(ma.Residential_Street__pc) && !string.isBlank(pma.LastName) && !string.isBlank(pma.FirstName) && !string.isBlank(pma.Residential_Street__pc) && (ma.LastName == pma.LastName) && (ma.FirstName == pma.FirstName) && (ma.Residential_Street__pc == pma.Residential_Street__pc)){

			IsStreetMatching = true;

		}
		if (!string.isBlank(ma.LastName) && !string.isBlank(ma.Residential_Street__pc) && !string.isBlank(ma.Residential_Zipocde__pc) && !string.isBlank(pma.LastName) && !string.isBlank(pma.Residential_Street__pc) && !string.isBlank(pma.Residential_Zipocde__pc) && (ma.FirstName == pma.FirstName) && (ma.Residential_Street__pc == pma.Residential_Street__pc) && (ma.Residential_Zipocde__pc == pma.Residential_Zipocde__pc)){

			IsStreetMatching = true;
			IsZipcodeMatching = true;

		}

		if (!string.isBlank(ma.LastName) && !string.isBlank(ma.FirstName) && !string.isBlank(ma.Residential_Zipocde__pc) && !string.isBlank(pma.LastName) && !string.isBlank(pma.FirstName) && !string.isBlank(pma.Residential_Zipocde__pc) && (ma.LastName == pma.LastName) && (ma.FirstName == pma.FirstName) && (ma.Residential_Zipocde__pc == pma.Residential_Zipocde__pc)){

			IsZipcodeMatching = true;

		}
		if (!string.isBlank(ma.Residential_City__pc) && !string.isBlank(pma.Residential_City__pc) && (ma.Residential_City__pc == pma.Residential_City__pc)){

			IsCityMatching = true;

		}
		if (!string.isBlank(ma.Residential_State__pc) && !string.isBlank(pma.Residential_State__pc) && (ma.Residential_State__pc == pma.Residential_State__pc)){

			IsStateMatching = true;

		}
		if (!string.isBlank(ma.FirstName) && !string.isBlank(pma.FirstName) && (ma.FirstName == pma.FirstName)){

			IsFirstNameMatching = true;

		}
		if (!string.isBlank(ma.LastName) && !string.isBlank(pma.LastName) && (ma.LastName == pma.LastName)){

			IsLastNameMatching = true;

		}
		FirstName = ma.FirstName;
		LastName = ma.LastName;
		List<Person_Account__c> pa = [SELECT Id, PersonID__c, Account_Number__r.Parent_Account__c, Account_Number__c, Account_Number__r.RecType__c, Account_Number__r.Name, Account_Number__r.Id, PersonId__r.Createddate, Account_Number__r.Created_By_User__c, Account_Number__r.Created_By_User_Alias__c, Account_Number__r.Created_By_Episys_User__c, Account_Number__r.Created_By_User_Text__c
		                              FROM Person_Account__c
		                              WHERE PersonID__c = :ma.id
		                              order by Account_Number__r.RecType__c
		                              LIMIT 1];


		Member_Conversion_Report__c report = new Member_Conversion_Report__c();
		report.IsMatching__c = true;
		report.Process_Type__c = 'Manual';
		report.Is_Phone_Matching__c = IsPhoneMatching;
		report.Is_Email_Matching__c = IsEmailMatching;
		report.Is_Street_Matching__c = IsStreetMatching;
		report.Is_City_Matching__c = IsCityMatching;
		report.Is_State_Matching__c = IsStateMatching;
		report.Is_Zipcode_Matching__c = IsZipcodeMatching;
		report.First_Name__c = FirstName;
		report.Last_Name__c = LastName;
		report.Is_First_Name_Matching__c = IsFirstNameMatching;
		report.Is_Last_Name_Matching__c = IsLastNameMatching;
		if (pa.size() > 0){

			report.Member__c = pa[0].PersonID__c;
			report.Member_Episys_Alias__c = pa[0].Account_Number__r.Created_By_User_Alias__c;
			report.Member_Episys_Id__c = pa[0].Account_Number__r.Created_By_User__c;
			report.User_Name__c = pa[0].Account_Number__r.Created_By_User_Text__c;
			report.Member_Account__c = pa[0].Account_Number__r.id;
		}

		insert report;
	}

}