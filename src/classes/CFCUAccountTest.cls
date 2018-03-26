@IsTest
 public with sharing class CFCUAccountTest {
     
     @IsTest   
     public static void  CFCUAccountMethodTest(){
         
         string fid ='000099999' ;       
         String uid = UserInfo.getUserId();
         Profile profile = [SELECT Id,Name FROM Profile where Name ='Customer Community Login User' ];
         RecordType recordtype =[SELECT Id,Name FROM RecordType WHERE Name='Person Account'];
         User currentUser = [SELECT LocaleSidKey, LanguageLocaleKey, TimeZoneSidKey, EmailEncodingKey FROM User WHERE Id=:uid];
         Site communityid = [SELECT Id FROM Site where Name ='customer_messaging_center'];
         SamlSsoConfig samlSsoProviderId = [Select Id from SamlSsoConfig where DeveloperName='DI_SAML' ];
         Boolean Create = true;
         
         List<Account> accounts = new List<Account>();
            Account acc = new Account();
            acc.Owner = currentUser;
            acc.FirstName = 'tFName';
            acc.LastName='TLName';
            acc.recordtypeid = recordtype.Id;
            acc.PersonID__C ='V554870800';           
            acc.PersonEmail ='acctest@test.com';
            
            accounts.add(acc);
            insert accounts;
                     
             Contact c = [SELECT Id, AccountId FROM Contact WHERE AccountId=:acc.Id];

            // Creating new user
            List<User> users = new List<User>();
            user u = new user();
            u.Username = 'testUserName@test.com' ;
            u.FederationIdentifier =fid ;
            u.Email ='test@test.com' ;
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
            insert users;
            
             List<Account_Details__c> Account_Details = new List<Account_Details__c>();
             Account_Details__c ad = new Account_Details__c();
             ad.Name = fid;
             Account_Details.add(ad);
             insert Account_Details;
            
             List<Person_Account__c> Person_Account = new List<Person_Account__c>();
             Person_Account__c pa = new Person_Account__c();
             pa.Account_Number__c = ad.id;
             pa.Name_Type__c = 0;
             pa.PersonID__c = acc.Id;
             Person_Account.add(pa);
             insert Person_Account;
                
             Case cas1 = new Case();
             cas1.Subject = 'Test Subject Online Banking';
             cas1.Description = 'Test Description Online Banking';
             cas1.Account_Number__c = pa.Account_Number__c;
             cas1.AccountID = c.AccountId;
             cas1.Primary_Category__c = 'Online Banking';
             cas1.Status ='Open';
             cas1.IsMarkDeleted__c = true;
             insert cas1;
             
             
            system.runas(u)
            {
                 CFCUAccount userAccount = new CFCUAccount();
                 userAccount.AccountId = acc.id;
                 userAccount.userPersonContact = c;
                 userAccount.Get10DigitFid(fid);
                 userAccount.CFCUAccount();
         //userAccount.fedid = u1[0].FederationIdentifier;
             }
     
        }
 
 
 }