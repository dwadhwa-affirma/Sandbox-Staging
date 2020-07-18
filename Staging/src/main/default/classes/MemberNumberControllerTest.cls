@isTest
public class MemberNumberControllerTest {
    
    static testMethod void testMethod1(){
    
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
        
        Account_Details__c acd = new Account_Details__c();
            acd.Name = '56789';
        insert acd;
        
        Person_Account__c pa = new Person_Account__c();
            pa.PersonID__c = acc.Id;
            pa.Account_Number__c = acd.Id;
        insert pa;

        Folder fd = [Select Id from Folder where Name = 'Shared Documents'];
        
        Document doc = new Document();
            doc.Name = 'CFCU Logo';
            doc.FolderId = fd.Id;
        insert doc;
        
    PageReference pageRef = Page.MemberNumber;
    Test.setCurrentPage(pageRef);        
    MemberNumberController controller = new MemberNumberController();
        
        controller.getMemberAccountInfo();
        controller.clearAll();
        controller.MembernumberQuery = 'test';
        controller.searchAccount();
   }
}