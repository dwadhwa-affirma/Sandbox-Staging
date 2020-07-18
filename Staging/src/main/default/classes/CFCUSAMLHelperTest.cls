@IsTest public class CFCUSAMLHelperTest {
        
    @IsTest
     public static void testhandleContact()
    {  
    	SecureEmailSetting__c customsetting;
    	customsetting = new SecureEmailSetting__c();
        customsetting.Name ='Secure Email Setting';
        customsetting.url_redirection_enabled__c = true;
        customsetting.spectrum_url__c = 'https://securemail.spectrumcu.org';
        customsetting.chevron_url__c = 'https://securemail.chevronfcu.org';
        customsetting.ProfileId__c = '00e63000000QHSa';
        customsetting.Chevron_KB__c = 'https://securemail.spectrumcu.org';
        customsetting.Spectrum_KB__c = 'https://securemail.spectrumcu.org';
        customsetting.List_of_Blocked_Extensions__c = 'css';
        insert customsetting;
    	  string fid ='0000999999'   ;     
    	  
         String uid = UserInfo.getUserId();
         Profile profile = [SELECT Id,Name FROM Profile where Name ='Customer Community Login User' ];
         RecordType recordtype =[SELECT Id,Name FROM RecordType WHERE Name='Person Account'];
         User currentUser = [SELECT LocaleSidKey, LanguageLocaleKey, TimeZoneSidKey, EmailEncodingKey FROM User WHERE Id=:uid];
         Site communityid = [SELECT Id FROM Site where Name ='customer_messaging_center'];
         SamlSsoConfig samlSsoProviderId = [Select Id from SamlSsoConfig where DeveloperName='DI_SAML' ];
         
         Boolean Create = true;
        
            
            // Creating  Account  
           
            //List<Account> accounts = new List<Account>();
            Account acc = new Account();
            acc.Owner = currentUser;
            acc.FirstName = 'tFName';
            acc.LastName='TLName';
            acc.recordtypeid = recordtype.Id;
            acc.PersonID__C ='V554870800';
            
            acc.PersonEmail ='acctest@test.com';
            insert acc;
            
            Account acc2 = new Account();
            acc2.Owner = currentUser;
            acc2.FirstName = 'tFNametest';
            acc2.LastName='TLNametet';
            acc2.recordtypeid = recordtype.Id;
            acc2.PersonID__C ='V554870801';
            
            acc2.PersonEmail ='acctest12345@test.com';
            insert acc2;
              Account acc3 = new Account();
            acc3.Owner = currentUser;
            acc3.FirstName = 'tFNametest1';
            acc3.LastName='TLNametet1';
            acc3.recordtypeid = recordtype.Id;
            acc3.PersonID__C ='V554870802';
            
            acc3.PersonEmail ='';
            insert acc3;
                     
            Contact c = [SELECT Id FROM Contact WHERE AccountId=:acc.Id];
            Contact c3 = [SELECT Id FROM Contact WHERE AccountId=:acc3.Id];
            system.debug('c--'+c);
        	
            Map<String, String> attributes = new Map<String, String>();
            attributes.put('Member.Id',acc.id);
            attributes.put('EmailAddress','abc@test.com');
            
            // Creating new user
            List<User> users = new List<User>();
            User u = new User();
            
            
            
            
            u.Username = 'testUserName@test.com' ;
            u.FederationIdentifier =fid ;
            if(attributes.get('EmailAddress')!= null || attributes.get('EmailAddress')!='')
            {
        		u.Email = attributes.get('EmailAddress');
            }
            else
            {
            	if (acc.PersonEmail == '')
            	{
            		u.Email = attributes.get('EmailAddress');
            	}
            	else
            	{
            		u.Email = acc.PersonEmail;
            	}
           	  u.Email ='test@test.com' ;
            }
           
            u.FirstName ='tFirstName' ;
            u.LastName ='tLastName' ;
            u.ProfileId = profile.Id;
            u.Alias ='tAlias';
           
            u.LocaleSidKey = currentUser.LocaleSidKey;
            u.LanguageLocaleKey = currentUser.LanguageLocaleKey; 
            u.TimeZoneSidKey = currentUser.TimeZoneSidKey; 
            u.EmailEncodingKey = currentUser.EmailEncodingKey;
            u.ContactId = c.Id;
            users.add(u);
            //insert users;
            
           // Creating Account_Details__c
            List<Account_Details__c> Account_Details = new List<Account_Details__c>();
            Account_Details__c ad = new Account_Details__c();
            ad.Name = fid;
            ad.SecureEmailAddress__C = 'a@a.com';
            Account_Details.add(ad);
            insert Account_Details;
           // Creating  Person_Account__c
            
             //List<Person_Account__c> Person_Account = new List<Person_Account__c>();
             Person_Account__c pa = new Person_Account__c();
             pa.Account_Number__c = ad.id;
             pa.Name_Type__c = 0;
             pa.PersonID__c = acc.Id;
             insert pa;
             
             
            String assertion='';
            string federationIdentifier = u.federationIdentifier;
            string brand = 'Chevron';
            string brand1 = 'Spectrum';
            
            
          
            Test.startTest();
                //List<User> users = new List<User>();
            System.runAs ( currentUser ) {
                User u1 = new User();
            u1.Username = 'testUserName@test.com' ;
            u1.FederationIdentifier =fid ;
            if(attributes.get('EmailAddress')!= null || attributes.get('EmailAddress')!='')
            {
        		u1.Email = attributes.get('EmailAddress');
            }
            else
            {
           	  u1.Email ='test@test.com' ;
            }
           // u1.Email ='test@test.com' ;
            u1.FirstName ='tFirstName' ;
            u1.LastName ='tLastName' ;
            u1.ProfileId = profile.Id;
            u1.Alias ='tAlias';
           
            u1.LocaleSidKey = currentUser.LocaleSidKey;
            u1.LanguageLocaleKey = currentUser.LanguageLocaleKey; 
            u1.TimeZoneSidKey = currentUser.TimeZoneSidKey; 
            u1.EmailEncodingKey = currentUser.EmailEncodingKey;
            u1.ContactId = c.Id;
            insert u1;
             
             User u2 = new User();
            u2.Username = 'testUserName1@test.com' ;
            u2.FederationIdentifier =fid ;
            if(attributes.get('EmailAddress')!= null || attributes.get('EmailAddress')!='')
            {
        		u2.Email = attributes.get('EmailAddress');
            }
            else
            {
           	  u2.Email ='test111@test.com' ;
            }
           // u1.Email ='test@test.com' ;
            u2.FirstName ='t11FirstName' ;
            u2.LastName ='t11LastName' ;
            u2.ProfileId =null;
            u2.Alias ='t11Alias';
           
            u2.LocaleSidKey = currentUser.LocaleSidKey;
            u2.LanguageLocaleKey = currentUser.LanguageLocaleKey; 
            u2.TimeZoneSidKey = currentUser.TimeZoneSidKey; 
            u2.EmailEncodingKey = currentUser.EmailEncodingKey;
            u2.ContactId = c3.Id;
             users.add(u2);   
             
            
                CFCUSAMLHelper helper = new CFCUSAMLHelper();
                //helper.handleContact(Create, acc, acc2 , u, attributes);
                helper.handleUser(create, u, attributes, federationIdentifier, false, acc,brand, 'a@a.com');
                helper.handleUser(create, u, attributes, federationIdentifier, false, acc,brand1 , 'a1@a.com');
                helper.handleUser(create, u2, attributes, federationIdentifier, false, acc3,brand1, 'a2@a.com');
                helper.handleJit(true, u, samlSsoProviderId.Id, communityId.Id, null,federationIdentifier, attributes, assertion);
                
                helper.handleJit(false, u, samlSsoProviderId.Id, communityId.Id, null,federationIdentifier, attributes, assertion);
                
                u = helper.createUser(samlSsoProviderId.Id, communityId.Id, communityId.Id,federationIdentifier,attributes, assertion);
                
              
	        if(!create) {

	            helper.updateUser(u.id, samlSsoProviderId.Id,communityId.Id,communityId.Id,federationIdentifier, attributes, assertion);

	        } 
           //     helper.updateUser(u1.id, samlSsoProviderId.Id,communityId.Id,communityId.Id,federationIdentifier, attributes, assertion);
               // helper.updateUser(u);
                
            Test.stopTest();
            }
         
            
         } // end of testhandleContact method
   
}// end of CFCUSAMLHelperTest class