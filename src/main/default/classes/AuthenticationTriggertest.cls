@isTest
 public class AuthenticationTriggertest{

  static testMethod void testMethod5(){
  		string fid ='000099999' ;
  	     String uid = UserInfo.getUserId();
  	     RecordType recordtype =[SELECT Id,Name FROM RecordType WHERE Name='Person Account'];
         User currentUser = [SELECT LocaleSidKey, LanguageLocaleKey, TimeZoneSidKey, EmailEncodingKey FROM User WHERE Id=:uid];
  	
  	            Account acc = new Account();
            acc.Owner = currentUser;
            acc.FirstName = 'tFName';
            acc.LastName='TLName';
            acc.recordtypeid = recordtype.Id; 
            acc.PersonID__C ='V554870800';           
            acc.PersonEmail ='acctest@test.com';
            acc.Email_raw__c = 'test@test.com'; 
            insert acc;
              
             Account_Details__c ad = new Account_Details__c();
             ad.Name = fid;
             
             insert ad;
             
             Person_Account__c pa = new Person_Account__c();
             pa.Account_Number__c = ad.id;
             pa.Name_Type__c = 0;
             pa.PersonID__c = acc.Id;
             insert pa;
            
             
            
            
  	
      Authenticated_Log__c testAuth = new Authenticated_Log__c();
         testAuth.Decision__c = 'Authenticated';
        // testAuth.Member_Name__c = 'JEFF FRANKLIN';
         testAuth.IVR_Member_Number__c = fid; 
         testAuth.salesforceID__c = acc.id;
         //testAuth.CreatedbyID = '00563000000R2bE'; 
         //system.assertEquals(testAuth.First_Name__c, '');
          insert testAuth;
          Authenticated_Log__c testAuth1 = [select id, First_Name__c from Authenticated_Log__c where IVR_Member_Number__c =:fid];
        //   system.assertEquals(testAuth1.First_Name__c, 'Jeff');
 }
}