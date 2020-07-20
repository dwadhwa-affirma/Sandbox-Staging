@isTest(SeeAllData=True)
public class CommentsTextforMembersControllerTest {

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
        
        Account_Details__c accDetails = new Account_Details__c();
           accDetails.Name = 'test name';
           accDetails.RecType__c = 'ACCT';
        insert accDetails;
        
        Person_Account__c pa = new Person_Account__c();
           pa.Account_Number__c = accDetails.Id;
           pa.PersonID__c = acc.Id;
        insert pa;
        
        String RecTypeId2= [select Id from RecordType where (Name='Person Account') and (SobjectType='Account')].Id;
        
        List<Account> acc2 = [Select Id From Account Where RecordTypeID=:RecTypeId2 Limit 1];
        
        
        PageReference pageRef = Page.CommentsTextforMembers;
        Test.setCurrentPage(pageRef);
        CommentsTextforMembersController controller = new CommentsTextforMembersController(new ApexPages.StandardController(acc2[0]));
        controller.isTest = true;
       // CommentsTextforMembersController.warningCodeWrapper wrp=new CommentsTextforMembersController.warningCodeWrapper('test');
        
        controller.mainMethod();
    }
}