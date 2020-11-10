/* ---------------------This trigger will be executed before insert of address change log.
 It creates a case with addresschange details in description field.
 It also sends Email and SMS notifications.................*/
trigger AddressChangeLogTrigger on AddressChangeLog__c(before insert ){

	string intakemethod = '';
	string IdentificationMethod = '';
	string Description = '';
	string Subject = '';
	Id caseid;
	string IdentificationMethodInfo = '';


	if (trigger.isbefore && trigger.isInsert){
		set<string> setMemberId = new set<string>();
		for (AddressChangeLog__c objAddressChange : trigger.New){
			setMemberId.add(objAddressChange.Member__c);
		}
		Map<Id, Account> objMap = new Map<Id, Account>([SELECT Id, Name
		                                                FROM Account
		                                                WHERE Id IN :setMemberId]);
		for (AddressChangeLog__c objAddressChange : trigger.New){
			string memberemail = objAddressChange.Email__c;
			string phone = objAddressChange.MobilePhone__c;
			boolean SendEmail = false, SendSMS = false;

			String emailRegex = '([a-zA-Z0-9_\\-\\.]+)@((\\[a-z]{1,3}\\.[a-z]{1,3}\\.[a-z]{1,3}\\.)|(([a-zA-Z0-9\\-]+\\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})';
			Pattern MyPattern = Pattern.compile(emailRegex);

			// ---------------------Send Email/SMS Notifications..................//
			AddressChangeConfigurations__c accf = AddressChangeConfigurations__c.getValues('Primary');

			SendEmail = accf.SendEmail__c;
			SendSMS = accf.SendSMS__c;
			List<string> EmailList = new List<String>();
			if (memberemail != null && (MyPattern.matcher(memberemail).matches()))
				EmailList.add(memberemail);
			if (SendEmail && EmailList.size() > 0){
				SendEmailNotifications(EmailList, 'Address Change', objAddressChange.Member__c);
			}
			if (SendSMS && phone != null){
				system.debug('memberPhone==' + phone);
				//SendSMS(phone);
			}

			String accountstring = objAddressChange.AccountNumbersString__c;
			List<String> listAccountNumber = new List<String>();
			if (accountstring.contains(',')){
				listAccountNumber = accountstring.split('\\,');
			} else{
				listAccountNumber.add(accountstring);
			}

			set<string> setAccountNumbers = new set<string>();
			map<string, id> mapAccountNumber = new map<string, id>();


			for (String s : listAccountNumber){
				if (!String.isEmpty(s)){
					setAccountNumbers.add(s);
				}
			}

			List<Account_Details__c> listAccounts = [select id, name
			                                         from Account_Details__c
			                                         where name IN :setAccountNumbers and parent_account__c = null];
			for (Account_Details__c acc : listAccounts){
				mapAccountNumber.put(acc.name, acc.id);
			}


			if (objAddressChange.Clean_Up_Intake_Method__c == 'Clean Up - Report Date'){
				Datetime dt = datetime.newInstance(Date.valueOf(objAddressChange.Clean_Up_Report_Date__c).year(), Date.valueOf(objAddressChange.Clean_Up_Report_Date__c).month(), Date.valueOf(objAddressChange.Clean_Up_Report_Date__c).day());
				intakemethod = 'Intake Method:' + objAddressChange.Clean_Up_Intake_Method__c + '\n' + 
								'Clean Up Report Date:' + dt.format('MM/dd/yyyy')+'\n';
			} else{
				intakemethod = 'Intake Method:' + objAddressChange.Clean_Up_Intake_Method__c + '\n';
			}

			
			IdentificationMethod = 'Identification Method:' + objAddressChange.Identification_Method__c + '\n';
			if(objAddressChange.Identification_Method__c =='Company Badge' || objAddressChange.Identification_Method__c =='DL/ID/Other' || objAddressChange.Identification_Method__c =='Passport'){
				IdentificationMethodInfo = objAddressChange.Identification_Method_Information__c;
			}

			if(IdentificationMethodInfo != '' && IdentificationMethodInfo != null){
				IdentificationMethod = IdentificationMethod + 'Identification Method Information:' + IdentificationMethodInfo + '\n';
			}
			String MemberName = objMap.get(objAddressChange.Member__c).Name;

			if ((objAddressChange.Address_New__c == '' || objAddressChange.Address_New__c == null) && objAddressChange.Address2_New__c != '' && objAddressChange.Address2_New__c != null){
				objAddressChange.Address_New__c = objAddressChange.Address2_New__c;
				objAddressChange.Address2_New__c = '';
			}
			if (objAddressChange.Address2_New__c != null && objAddressChange.Address2_New__c != ''){
				if (objAddressChange.Address_New__c.toUpperCase().Contains('STE') || objAddressChange.Address_New__c.toUpperCase().Contains('SUITE') || objAddressChange.Address_New__c.toUpperCase().Contains('RM') || objAddressChange.Address_New__c.toUpperCase().Contains('DEPT') || objAddressChange.Address_New__c.toUpperCase().Contains('APT') || objAddressChange.Address_New__c.toUpperCase().Contains('APARTMENT')){
					string temp = objAddressChange.Address_New__c;
					objAddressChange.Address_New__c = objAddressChange.Address2_New__c;
					objAddressChange.Address2_New__c = temp;
				}
			}

			if(objAddressChange.Zip_New__c != null && objAddressChange.Zip_New__c.Contains('-')){
				List<string> ZipCodes = objAddressChange.Zip_New__c.split('-');
				objAddressChange.Zip_New__c = ZipCodes[0];
				if(ZipCodes.size() > 1)
					objAddressChange.Zip4_New__c = ZipCodes[1];
			}

			if(objAddressChange.Zip_Old__c != null && objAddressChange.Zip_Old__c.Contains('-')){
				List<string> ZipCodes1 = objAddressChange.Zip_Old__c.split('-');
				objAddressChange.Zip_Old__c = ZipCodes1[0];
				if(ZipCodes1.size() > 1)
					objAddressChange.Zip4_Old__c = ZipCodes1[1];
			}

			if (objAddressChange.Update_Type__c == 'Residential Address'){
				Description = intakemethod + IdentificationMethod + 'Update Type:' + objAddressChange.Update_Type__c + '\n' + 'Member Name:' + MemberName + '\n' + 'Old Address1:' + (objAddressChange.Address_Old__c == null ? '' : objAddressChange.Address_Old__c)+'\n' + 'New Address1:' + (objAddressChange.Address_New__c == null ? '' : objAddressChange.Address_New__c)+'\n' + 
													'Old Address2:' + (objAddressChange.Address2_Old__c == null ? '' : objAddressChange.Address2_Old__c)+'\n' + 'New Address2:' + (objAddressChange.Address2_New__c == null ? '' : objAddressChange.Address2_New__c)+'\n' + 'Old City:' + (objAddressChange.City_Old__c == null ? '' : objAddressChange.City_Old__c)+'\n' + 'New City:' + (objAddressChange.City_New__c == null ? '' : objAddressChange.City_New__c)+'\n' + 'Old State:' + (objAddressChange.State_Old__c == null ? '' : objAddressChange.State_Old__c)+'\n' + 'New State:' + (objAddressChange.State_New__c == null ? '' : objAddressChange.State_New__c)+'\n' + 
													'Old Zip:' + (objAddressChange.Zip_Old__c == null ? '' : objAddressChange.Zip_Old__c)+'\n' + 'New Zip:' + (objAddressChange.Zip_New__c == null ? '' : objAddressChange.Zip_New__c)+'\n' + 
													'Old Zip +4:' + (objAddressChange.Zip4_Old__c == null ? '' : objAddressChange.Zip4_Old__c)+'\n' + 'New Zip +4:' + (objAddressChange.Zip4_New__c == null ? '' : objAddressChange.Zip4_New__c)+'\n' + 
													'Record Type Updated:' + 'Name Records' + '\n' + 
													'Names:' + objAddressChange.Names__c;
				if (objAddressChange.Is_Temp_Mail_Expired__c && objAddressChange.Expired_Temp_Mail_Details__c != null){
					List<string> TempMailList = objAddressChange.Expired_Temp_Mail_Details__c.split(',');
					Description = Description + '\n' + '\n' + 'Expired Active Mail Record Details:' ;
					for(string s: TempMailList){
						if(s != '' && s != null){
							string accno, add1, add2, city, state, zip;
							List<string> AddressDetailsList = s.split('\\|');
							accno = AddressDetailsList[0];
							add1 = AddressDetailsList[1];
							if(AddressDetailsList[2] != '' && AddressDetailsList[2] != null)
								add2 = AddressDetailsList[2];
							if(AddressDetailsList[3] != '' && AddressDetailsList[3] != null)
								city = AddressDetailsList[3];
							if(AddressDetailsList[4] != '' && AddressDetailsList[4] != null)
								state = AddressDetailsList[4];
							if(AddressDetailsList[5] != '' && AddressDetailsList[5] != null)
								zip = AddressDetailsList[5]; 
							Description = Description + '\n' +'Account Number:' + accno + '\n' + 'Address1:' + add1 + '\n' + 'Address2:' + add2 + '\n' + 'City:' + city + '\n' + 'State:' + state + '\n' + 'ZipCode:' + zip + '\n' + '\n';
						}
					}
					/*Description = Description + '\n' + '\n' + 'Expired Active Mail Record Details:' + 
												'\n' + 'Account Number:' + objAddressChange.Expire_Temp_Mail_Account_Number__c + '\n' + 'Address1:' + objAddressChange.Expire_Temp_Mail_Address1__c + '\n' + 'Address2:' + objAddressChange.Expire_Temp_Mail_Address2__c + '\n' + 'City:' + objAddressChange.Expire_Temp_Mail_City__c + '\n' + 'State:' + objAddressChange.Expire_Temp_Mail_State__c + '\n' + 'ZipCode:' + objAddressChange.Expire_Temp_Mail_Zip5__c;*/
				}
			} else if (objAddressChange.Update_Type__c == 'Contact Info'){
				Description = intakemethod + IdentificationMethod + 'Update Type:' + objAddressChange.Update_Type__c + '\n' + 'Member Name:' + MemberName + '\n' + 'Old HomePhone:' + (objAddressChange.HomePhone_Old__c == null ? '' : objAddressChange.HomePhone_Old__c)+'\n' + 
												'New HomePhone:' + (objAddressChange.HomePhone_New__c == null ? '' : objAddressChange.HomePhone_New__c)+'\n' + 
												'Old MobilePhone:' + (objAddressChange.MobilePhone_Old__c == null ? '' : objAddressChange.MobilePhone_Old__c)+'\n' + 
												'New MobilePhone:' + (objAddressChange.MobilePhone_New__c == null ? '' : objAddressChange.MobilePhone_New__c)+'\n' + 
												'Old WorkPhone:' + (objAddressChange.WorkPhone_Old__c == null ? '' : objAddressChange.WorkPhone_Old__c)+'\n' + 
												'New Workphone:' + (objAddressChange.WorkPhone_New__c == null ? '' : objAddressChange.WorkPhone_New__c)+'\n' + 
												'Old WorkExtension:' + (objAddressChange.WorkExtension_Old__c == null ? '' : objAddressChange.WorkExtension_Old__c)+'\n' + 
												'New WorkExtension:' + (objAddressChange.WorkExtension_New__c == null ? '' : objAddressChange.WorkExtension_New__c)+'\n' + 
												'Old Email:' + (objAddressChange.Email_Old__c == null ? '' : objAddressChange.Email_Old__c)+'\n' + 
												'New Email:' + (objAddressChange.Email_New__c == null ? '' : objAddressChange.Email_New__c)+'\n' + +'Old AlternateEmail:' + (objAddressChange.AlternateEmail_Old__c == null ? '' : objAddressChange.AlternateEmail_Old__c)+'\n' + 
												'New AlternateEmail:' + (objAddressChange.AlternateEmail_New__c == null ? '' : objAddressChange.AlternateEmail_New__c)+'\n' + 
												'Record Type Updated:' + 'Name Records' + '\n' + 
												'Names:' + objAddressChange.Names__c;
			} else if (objAddressChange.Update_Type__c == 'Mailing Address'){
				Description = intakemethod + IdentificationMethod + 'Update Type:' + (objAddressChange.Update_Type__c + ' - Update')+'\n' + 'Member Name:' + MemberName + '\n' + 'Old Address:' + (objAddressChange.Address_Old__c == null ? '' : objAddressChange.Address_Old__c)+'\n' + 'New Address:' + (objAddressChange.Address_New__c == null ? '' : objAddressChange.Address_New__c)+'\n' + 
												'Old City:' + (objAddressChange.City_Old__c == null ? '' : objAddressChange.City_Old__c)+'\n' + 'New City:' + (objAddressChange.City_New__c == null ? '' : objAddressChange.City_New__c)+'\n' + 'Old State:' + (objAddressChange.State_Old__c == null ? '' : objAddressChange.State_Old__c)+'\n' + 'New State:' + (objAddressChange.State_New__c == null ? '' : objAddressChange.State_New__c)+'\n' + 
												'Old Zip:' + (objAddressChange.Zip_Old__c == null ? '' : objAddressChange.Zip_Old__c)+'\n' + 'New Zip:' + (objAddressChange.Zip_New__c == null ? '' : objAddressChange.Zip_New__c)+'\n' + 
												'Old Expiration Date:' + objAddressChange.ExpirationDate_Old__c + '\n' + 'New Expiration Date:' + objAddressChange.ExpirationDate_New__c + '\n' + 'Old Active Flag:' + objAddressChange.isActive_Old__c + '\n' + 'New Active Flag:' + objAddressChange.isActive_New__c + '\n' + 
												'Record Type Updated:' + 'Mail only Records' + '\n' + 
												'Locator:' + objAddressChange.Temp_Mail_Locators__c + '\n' + 
												'Names:' + objAddressChange.Temp_Mail_Account_Names__c;
			} else if (objAddressChange.Update_Type__c == 'Temp Mailing Address - New'){
				Description = intakemethod + IdentificationMethod + 'Update Type:' + 'Mailing Address - New' + '\n' + 'Member Name:' + MemberName + '\n' + 'New Address:' + (objAddressChange.Address_New__c == null ? '' : objAddressChange.Address_New__c)+'\n' + 
												'New City:' + (objAddressChange.City_New__c == null ? '' : objAddressChange.City_New__c)+'\n' + 'New State:' + (objAddressChange.State_New__c == null ? '' : objAddressChange.State_New__c)+'\n' + 
												'New Zip:' + (objAddressChange.Zip_New__c == null ? '' : objAddressChange.Zip_New__c)+'\n' + 'New Expiration Date:' + objAddressChange.ExpirationDate_New__c + '\n' + 'New Active Flag:' + objAddressChange.isActive_New__c + '\n' + 
												'Record Type Updated:' + 'Mail only Records' + '\n' + 
												'Locator:' + objAddressChange.Temp_Mail_Locators__c + '\n' + 
												'Names:' + objAddressChange.Temp_Mail_Account_Names__c;
			}

			// --------------------- Check if Case exists..................//

			List<Address_Contact_Change_Case_Categories__c> accList = [SELECT id, name, Category__c
			                                                           FROM Address_Contact_Change_Case_Categories__c];

			Set<String> Categories = new set<String>();
			for (Address_Contact_Change_Case_Categories__c a : accList){
				Categories.add(a.Category__c);
			}

			List<Case> CaseList = [SELECT id, Account_Number__c, Account_Number__r.Name, Description
			                       from Case
			                       where Account_Number__r.Name IN :listAccountNumber AND status<>'Closed' AND category__c IN :Categories];

			if (CaseList.size() > 0){
				for (Case c : CaseList){
					string tempdesc = c.Description;
					if (tempdesc != null)
						Description = tempdesc + '\n' + Description;					
					c.OwnerId = objAddressChange.Updated_By__c;
					//c.Status = 'Closed';
					c.Description = Description;
				}
				update CaseList;
				for (Case c : CaseList){					
					c.Status = 'Closed';				
				}
				update CaseList;
				objAddressChange.CaseId__c = CaseList[0].Id;
				caseid = CaseList[0].Id;
			}

			//Create Case for AddressChange if Case does not exist//

			else if (CaseList.size() <= 0){
				list<CaseRecordType__c> scList = [SELECT Id, Primary_Category__c, Secondary_Category__c, Teritiary_Category__c, Record_Type_Name__c, RecordTypeId__c
				                                  FROM CaseRecordType__c
				                                  WHERE Primary_Category__c = 'Account Maintenance' AND Secondary_Category__c = 'Memberships' AND Teritiary_Category__c = 'Address/Contact Updates'
				                                  LIMIT 1];

				Case caseobj = new Case();

				caseobj.Account_Number__c = listAccounts[0].id;
				caseobj.Status = 'Closed';
				caseobj.AccountId = objAddressChange.Member__c;
				caseobj.RecordTypeId = scList[0].RecordTypeId__c;
				caseobj.Primary_Category__c = scList[0].Primary_Category__c;
				caseobj.Secondary_Category__c = scList[0].Secondary_Category__c;
				caseobj.Tertiary_Category__c = scList[0].Teritiary_Category__c;
				system.debug('user++++' + objAddressChange.Updated_By__c);
				caseobj.CreatedById = objAddressChange.Updated_By__c;
				caseobj.OwnerId = objAddressChange.Updated_By__c;

				if (!String.IsBlank(objAddressChange.Address2_New__c) && String.IsBlank(objAddressChange.Address_New__c)){
					objAddressChange.Address_New__c = objAddressChange.Address2_New__c;
					objAddressChange.Address2_New__c = '';
				}


				if (objAddressChange.Update_Type__c == 'Residential Address'){
					objAddressChange.Email_Old__c = '';
					objAddressChange.MobilePhone_Old__c = '';
					caseobj.Subject = 'Address Change';
					caseobj.Description = Description;
				} else if (objAddressChange.Update_Type__c == 'Contact Info'){
					caseobj.Subject = 'Contact Info Change';
					caseobj.Description = Description;
				} else if (objAddressChange.Update_Type__c == 'Mailing Address'){
					caseobj.Subject = 'Mailing Address Update';
					caseobj.Description = Description;
				} else if (objAddressChange.Update_Type__c == 'Temp Mailing Address - New'){
					caseobj.Subject = 'Mailing Address Update';
					caseobj.Description = Description;
				}

				
				try{
					insert caseobj;
					caseid = caseobj.id;
					objAddressChange.CaseId__c = caseid;
					System.debug('Case created :' + caseobj.Id);

					
				} catch (exception e){
					System.debug('An error occured while inserting case :' + e);
				}


			}

			// --------------------- Attach multiple Accounts with case..................//
			list<CaseAccountMemberDetail__c> listac = new List<CaseAccountMemberDetail__c>();

			for (String s : setAccountNumbers){
				CaseAccountMemberDetail__c obj = new CaseAccountMemberDetail__c();
				obj.Account_Name__c = s;
				obj.Case__c = caseid;
				obj.MemberAccountid__c = mapAccountNumber.get(s);
				listac.add(obj);

			}

			insert listac;

			/*if (objAddressChange.Update_Type__c == 'Residential Address' && objAddressChange.EmailNotificationJSONString__c != null){
			 string decodedJson = objAddressChange.EmailNotificationJSONString__c.unescapeHtml4().unescapeHtml4();
			 EmailNotificationDetails(decodedJson);
			 }*/
		}
	}

	// --------------------- Send SMS Notification..................//

	private void SendSMS(string phone){
		List<smagicinteract__smsmagic__c> smsObjectList = new List<smagicinteract__smsmagic__c>();
		String senderId = 'CreditUnion';
		smagicinteract__smsMagic__c smsObject = new smagicinteract__smsMagic__c();
		smsObject.smagicinteract__SenderId__c = 'CreditUnion';
		string emailadd;

		system.debug('UserInfo.getName()###' + UserInfo.getName());

		emailadd = 'Address Change';
		list<smagicinteract__SMS_Template__c> listTemplate = [select Id, smagicinteract__Text__c
		                                                      from smagicinteract__SMS_Template__c
		                                                      where smagicinteract__Name__c = :emailadd];

		smsObject.smagicinteract__PhoneNumber__c = phone;
		smsObject.smagicinteract__Name__c = 'SMS - User'; // records name
		//   smsObject.smagicinteract__ObjectType__c = 'Contact'; // record type
		smsObject.smagicinteract__disableSMSOnTrigger__c = 0; // this field either be 0 or 1, if you specify the value as 1 then sms will not get send but entry of sms will get create under SMS History object
		smsObject.smagicinteract__external_field__c = smagicinteract.ApexAPI.generateUniqueKey();

		smsObjectList.add(smsObject);
		Database.insert(smsObjectList, false);
		// LastOTPSent = System.Now();
	}

	public void SendEmailNotifications(List<string> EmailIdsList, string templatenAME, string accountNumber){
		List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
		Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();


		mail.setToAddresses(EmailIdsList);
		List<EmailTemplate> listEmailTemplate = [select Id, Name, Body, Subject, HtmlValue
		                                         from EmailTemplate
		                                         where Name = :templatenAME];

		mail.setSubject(listEmailTemplate[0].Subject);
		string emailadd;
		emailadd = 'noreply@chevronfcu.org';
		List<OrgWideEmailAddress> listAdd = [select Id, Address, DisplayName
		                                     from OrgWideEmailAddress
		                                     where Address = :emailadd];

		string body = listEmailTemplate[0].Body.replace('{AccountNumber}', accountNumber);
		mail.setPlainTextBody(body);
		mail.setOrgWideEmailAddressId(listAdd[0].Id);
		mails.add(mail);

		Messaging.sendEmail(mails);
	}

	public class EmailNotificationStatusList{
		@AuraEnabled
		public string accountNumber{ get; set; }

		@AuraEnabled
		public boolean IRACheck{ get; set; }

		@AuraEnabled
		public boolean RECheck{ get; set; }
	}
}