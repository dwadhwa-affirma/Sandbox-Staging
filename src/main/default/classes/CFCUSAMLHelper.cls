//This class provides logic for inbound just-in-time provisioning of single sign-on users in your Salesforce organization.
global class CFCUSAMLHelper implements Auth.SamlJitHandler {
    private class JitException extends Exception{}

    @TestVisible private void handleUser(boolean create, User u, Map<String, String> attributes,
        String federationIdentifier, boolean isStandard, Account account, string Brand, string EmailAddress) 
       {
       	
        if(create) 
        {
        	
        	
        	if (Brand == 'Chevron')
        	{
            	u.Username = federationIdentifier + '@mars.chevronfcu.org';
        	}
        	else
        	{
        		u.Username = federationIdentifier + '@mars.spectrumcu.org';
        	}
            u.FederationIdentifier = federationIdentifier;
           	if(EmailAddress !='')
            {
        		u.Email = EmailAddress;
            }
            else if (account.PersonEmail != null && account.PersonEmail != '')
            {
            	u.Email = account.PersonEmail;
            }
            else
            {
            		u.Email = u.Username;
            
            }
            
            u.FirstName = account.FirstName;
            u.LastName = account.LastName;
            if(attributes.get('KEEP_ALIVE_URL')!= null && attributes.get('KEEP_ALIVE_URL')!='')
            {
        		u.KEEP_ALIVE_URL__c = attributes.get('KEEP_ALIVE_URL');
            }
        	String uid = UserInfo.getUserId();
        	User currentUser = 
            	[SELECT LocaleSidKey, LanguageLocaleKey, TimeZoneSidKey, EmailEncodingKey FROM User WHERE Id=:uid];
        	
            	u.LocaleSidKey = currentUser.LocaleSidKey;
        
        
            u.LanguageLocaleKey = currentUser.LanguageLocaleKey;
                
            String alias = '';
            if(u.FirstName == null) 
            {
                alias = u.LastName;
            }
            else
            {
                alias = u.FirstName.charAt(0) + u.LastName;
            }
            
            if(alias.length() > 5) 
            {
                alias = alias.substring(0, 5);
            }
            u.Alias = alias;
            u.TimeZoneSidKey = currentUser.TimeZoneSidKey;
            u.EmailEncodingKey = currentUser.EmailEncodingKey;
            if(u.profileid == null)
            {
            List <SecureEmailSetting__c> ses = SecureEmailSetting__c.getall().values();
			string profileid = ses[0].ProfileId__c;
            u.ProfileId = profileid;
            }
        }
        else
        {
        	if(EmailAddress !='')
            {
        		u.Email = EmailAddress;
            }
            else if (account.PersonEmail != null && account.PersonEmail != '')
            {
            	u.Email = account.PersonEmail;
            }
            else
            {
            //	u.Email = u.Username;
            
            }
        	 if(attributes.get('KEEP_ALIVE_URL')!= null && attributes.get('KEEP_ALIVE_URL')!='')
            {
        		u.KEEP_ALIVE_URL__c = attributes.get('KEEP_ALIVE_URL');
            }
            
        }
           
    }

	@TestVisible private Account handleAccount(string AccountName, string Brand,Boolean Create,string FederationId)
	{
		if(Create)
		{
		string recordTypeid = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId();
		Account a = new Account();
			a.recordTypeId = recordTypeId;
			//a.Name = AccountName + ' - ' + Brand;
			a.Name = federationId + '-' + Brand;
			insert a;
			return a;
		}
		else
		{
			string acName  = federationID + '-' + Brand;
			
			try
			{
				Account a = [SELECT Id,Name FROM Account WHERE Name=:acName];
				return a;
			}catch(exception e)
			{
				string recordTypeid = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId();
				Account a1 = new Account();
				a1.recordTypeId = recordTypeId;
				//a.Name = AccountName + ' - ' + Brand;
				a1.Name = federationId + '-' + Brand;
				insert a1;
				return a1;
			}
			
		}	
		
	}
    @TestVisible private void handleContact(boolean create, Account account, Account userBusinessAccount, User u, Map<String, String> attributes) {
        if (create)
        {
	        Contact c = new Contact();
	        Contact pc = [SELECT Id, LastName, FirstName FROM Contact WHERE AccountId=:account.Id];
	        c.LastName = pc.LastName;
	        c.FirstName = pc.FirstName;
	        c.AccountId = userBusinessAccount.Id;
	        
	        insert c;
	        u.ContactId = c.Id;
        }
        
    }

   

    @TestVisible private void handleJit(boolean create, User u, Id samlSsoProviderId, Id communityId, Id portalId,
        String federationIdentifier, Map<String, String> attributes, String assertion) {
        	System.debug(attributes);
        	System.debug(assertion);
        	system.debug(attributes.get('XML_DATA'));
       	Account userAccount = null;
       	Account userBusinessAccount = null;
       	Account_Details__c  accountdetails =null;
       	Person_Account__c personaccount = null;
        String AccountName = federationIdentifier;
        if(communityId != null || portalId != null) {
            //String account = handleAccount(create, u, attributes);
            string Brand = '';
            System.Debug('CID-' + CommunityId);
            System.Debug ('fid-' + federationIdentifier);
            Integer  l = federationIdentifier.length();
            
            if (l <10)
            {
            	Integer  zerotoadd = 10-l;
            	string prepend='';
            	for (Integer  i=0; i<zerotoadd; i++)
            	{
            		prepend = '0' + prepend;
            		
            	}
            	
            	AccountName = prepend + federationIdentifier;
            }
            
            System.Debug ('AccountName-' + AccountName);
 
            System.Debug('uid-' + attributes.get('User.Username'));
            String account = ''; 
             
           	accountdetails = [SELECT AccountID__c,Id,Name,Parent_Account__c, Brand__c, SecureEmailAddress__c FROM Account_Details__c Where Name =:AccountName and Parent_Account__c = null];
           
           	personaccount = [Select AccountID__c, Account_Number__c, Name_Type__c,  Id, PersonAccount__c, PersonID__c, Person_ID_Number__c FROM Person_Account__c Where Account_Number__c =: accountdetails.id and Name_Type__c = 0];
           
          	userAccount = [Select Id, PersonID__C, Name,PersonEmail,FirstName, LastName from Account WHERE Id =: personaccount.PersonID__c];
          	
            //userAccount = [SELECT Id, Name, FirstName, LastName, PersonEmail FROM Account WHERE PersonId__c=:federationIdentifier];
            Brand = accountdetails.Brand__c;
            userBusinessAccount = handleAccount(userAccount.FirstName + ' ' + userAccount.LastName, Brand,create,federationIdentifier);
            handleContact(create, userAccount, userBusinessAccount, u, attributes);
            
            string emailAddress = '';
            if (accountdetails.secureEmailAddress__C != null && accountdetails.secureEmailAddress__C != '')
            {
            	emailAddress = accountdetails.SecureEmailAddress__c;
            }
            
            handleUser(create, u, attributes, federationIdentifier, false, userAccount, Brand,  emailAddress);
        } else {
            throw new JitException('This class only handles communities site.');
        }
    }


    global User createUser(Id samlSsoProviderId, Id communityId, Id portalId,
        String federationIdentifier, Map<String, String> attributes, String assertion) {
            
            
        System.Debug(federationIdentifier + '-FID');    
            
            User u = new User();
        if(Test.isRunningTest()){
				Profile profile = [SELECT Id,Name FROM Profile where Name ='Customer Community Login User' ];
				u.profileid = profile.id;
			}
        
        handleJit(true, u, samlSsoProviderId, communityId, portalId,
            federationIdentifier, attributes, assertion);
        return u;
    }

    global void updateUser(Id userId, Id samlSsoProviderId, Id communityId, Id portalId,
        String federationIdentifier, Map<String, String> attributes, String assertion) {
            
            System.Debug(federationIdentifier + '-FID');
            System.Debug(userId + '-uid');
        User u = [SELECT Id, FirstName, ContactId, Email FROM User WHERE Id=:userId];
        system.debug('U===' + u);
        handleJit(false, u, samlSsoProviderId, communityId, portalId,
            federationIdentifier, attributes, assertion);
           	update u;
        
        
        
    }
   
}