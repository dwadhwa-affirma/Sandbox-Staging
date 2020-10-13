@isTest
public class AccountDetailsTriggerTest {
    
    static testMethod void testMethod1(){
        
        String uid = UserInfo.getUserId();
        RecordType recordtype =[SELECT Id,Name FROM RecordType WHERE Name='Person Account'];
        User currentUser = [SELECT LocaleSidKey, Alias, LanguageLocaleKey, TimeZoneSidKey, EmailEncodingKey FROM User WHERE Id=:uid];    
        
        Account_Details__c accDetails = new Account_Details__c();
        accDetails.Name = 'test';
        accDetails.SecureEmailAddress__c = 'sample@sample.com';
        accDetails.Created_By_User__c = 1;
        accDetails.RecType__c = 'ACCT';
        accDetails.Created_By_User_Alias__c = currentUser.Alias;
        insert accDetails;
        
        Episys_User__c eu = new Episys_User__c();
        eu.Episys_ID__c = 1;
        eu.Episys_Name__c = 'testname';
        eu.Alias__c = currentUser.Alias;
        accDetails.SecureEmailAddress__c = 'sample@sample.com';
        insert eu;

        accDetails.SecureEmailAddress__c = 'sample@sample2.com';
        accDetails.Created_By_User_Text__c = 'testnameUpdate';
        accDetails.Balance__c = 100;
        update accDetails;
        
        WarningCodeMapping__c wm = new WarningCodeMapping__c();
        wm.Name = 'Rec001';
        wm.Warning_Code_Number__c = '001';
        wm.Warning_Code_Text__c = '001-NO BATCH POSTING ALLOWED';
        insert wm;
        
        accDetails.WARNING_01_CODE__c = '001-NO BATCH POSTING ALLOWED...';
        accDetails.SecureEmailAddress__c = 'sample@sample3.com';
        accDetails.Balance__c = 200;
        update accDetails;        

		Account_Details__c accDetails2 = [Select Id,SecureEmailAddress__c from Account_Details__c where Name = 'test' limit 1];
        accDetails2.SecureEmailAddress__c = 'sample@sample3.com';
        update accDetails2;     
        
        Account acc = new Account();
        acc.Owner = currentUser;
        acc.FirstName = 'testname';
        acc.LastName='testname';
        acc.recordtypeid = recordtype.Id;
        acc.PersonID__C ='V554870800';
        acc.PersonEmail ='acctest@test.com';
        insert acc;
        
        Person_Account__c pa = new Person_Account__c();
        pa.Account_Number__c = accDetails.id;
        pa.Name_Type__c = 0;
        pa.PersonID__c = acc.Id;
        insert pa;
        
		Test.startTest();
        UpdateAccountCreatebyEpisysUser c = new UpdateAccountCreatebyEpisysUser();
        Database.executeBatch(c);
        Test.stopTest();
    }
    
    static testMethod void testMethod2(){
        
        String uid = UserInfo.getUserId();
        RecordType recordtype =[SELECT Id,Name FROM RecordType WHERE Name='Person Account'];
        User currentUser = [SELECT LocaleSidKey, Alias, LanguageLocaleKey, TimeZoneSidKey, EmailEncodingKey FROM User WHERE Id=:uid];    
        
        Account_Details__c accDetails = new Account_Details__c();
        accDetails.Name = 'test';
        accDetails.SecureEmailAddress__c = 'sample@sample.com';
        accDetails.Created_By_User__c = 1;
        accDetails.RecType__c = 'SHAR';
        accDetails.Created_By_User_Alias__c = currentUser.Alias;
        insert accDetails;
        
        Episys_User__c eu = new Episys_User__c();
        eu.Episys_ID__c = 1;
        eu.Episys_Name__c = 'testname';
        eu.Alias__c = currentUser.Alias;
        accDetails.SecureEmailAddress__c = 'sample@sample.com';
        insert eu;

        accDetails.SecureEmailAddress__c = 'sample@sample2.com';
        accDetails.Created_By_User_Text__c = 'testnameUpdate';
        accDetails.Balance__c = 100;
        update accDetails;
        
        WarningCodeMapping__c wm = new WarningCodeMapping__c();
        wm.Name = 'Rec001';
        wm.Warning_Code_Number__c = '001';
        wm.Warning_Code_Text__c = '001-NO BATCH POSTING ALLOWED';
        insert wm;
        
        accDetails.WARNING_01_CODE__c = '001-NO BATCH POSTING ALLOWED...';
        accDetails.SecureEmailAddress__c = 'sample@sample3.com';
        accDetails.Balance__c = 200;
        update accDetails;        

		Account_Details__c accDetails2 = [Select Id,SecureEmailAddress__c from Account_Details__c where Name = 'test' limit 1];
        accDetails2.SecureEmailAddress__c = 'sample@sample3.com';
        update accDetails2;     
        
        Account acc = new Account();
        acc.Owner = currentUser;
        acc.FirstName = 'testname';
        acc.LastName='testname';
        acc.recordtypeid = recordtype.Id;
        acc.PersonID__C ='V554870800';
        acc.PersonEmail ='acctest@test.com';
        insert acc;
        
        Person_Account__c pa = new Person_Account__c();
        pa.Account_Number__c = accDetails.id;
        pa.Name_Type__c = 0;
        pa.PersonID__c = acc.Id;
        insert pa;
        
		Test.startTest();
        UpdateAccountCreatebyEpisysUser c = new UpdateAccountCreatebyEpisysUser();
        Database.executeBatch(c);
        Test.stopTest();
    }
}