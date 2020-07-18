@isTest
private class CaseClosedLogTest {

    static testMethod void testMethod1() {
    
        String RecTypeId= [select Id from RecordType where (Name='Person Account') and (SobjectType='Account')].Id;
        
        Account acc = new Account(
           RecordTypeID=RecTypeId,
           FirstName='Test FName',
           LastName='Test LName',
           PersonMailingStreet='test@yahoo.com',
           PersonMailingPostalCode='12345',
           PersonMailingCity='SFO',
           PersonEmail='test@yahoo.com',
           PersonHomePhone='1234567',
           PersonMobilePhone='12345678');

        
        insert acc;
        
          Account_Details__c accDetails = new Account_Details__c();
            accDetails.Name = 'testname';
        insert accDetails;       
        
    
    
    Case c1 = new Case( Status = 'New' );
  
    c1.Status = 'Open';
    c1.Account_Number__c = accDetails.id;
    c1.ownerid= UserInfo.getUserId();
    test.startTest();
      insert( c1 ); 
      
      c1.Status = 'Closed';
      
      update C1;
      
      List<user> objUser = [select id from User limit 1];
      
      system.debug('objUser---' + objUser);
      c1.OwnerId = objuser[0].id;
      
      update c1; 
       c1.OwnerId = UserInfo.getUserId();
       c1.Status = 'Open';
      
      update C1;
      
      c1.OwnerId = objuser[0].id;
       c1.Status = 'Open';
       update C1;
       
        c1.OwnerId = UserInfo.getUserId();
       c1.Status = 'Closed';
       update C1;
       
        List<Ownership_Log__c> listOwnerShip = [select Id,Case__c,Owner__c,Sequence__c from Ownership_Log__c]; 
        
        System.debug('listOwnerShip---' + listOwnerShip);
        
        test.stopTest();
 
    }
}