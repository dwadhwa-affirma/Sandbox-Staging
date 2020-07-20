@isTest
public class MemberPotentialControllerTest {
    static testmethod void testmethod1(){
     //  Account acc = [Select Id from Account Where isPersonAccount = True Limit 1];
        
        
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
        
        Account_Details__c accDetail = new Account_Details__c();
        accDetail.Name = 'Test';
        accDetail.RecType__c = 'ACCT';
        accDetail.High_Value_Flag__c = 2;
        insert accDetail;
        
        Person_Account__c pa = new Person_Account__c();
        pa.PersonID__c = acc.Id;
        pa.Account_Number__c = accDetail.Id;    
        pa.TypeTranslate__c = '0001/Joint Member';    
        insert pa;
        
        ApexPages.currentPage().getParameters().put('ID', acc.Id);
        MemberPotentialController controller = new MemberPotentialController(new ApexPages.StandardController(acc));
        //controller.acc = acc;
        Boolean xyz = controller.showData_OTP;
        String abc = controller.buttonClass;
            
        
    }
    static testmethod void testmethod2(){
     //  Account acc = [Select Id from Account Where isPersonAccount = True Limit 1];
        Account_Details__c accDetail = new Account_Details__c();
        accDetail.Name = 'Test';
        accDetail.RecType__c = 'ACCT';
        accDetail.High_Value_Flag__c = 1;
        insert accDetail;
        
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
        
        Person_Account__c pa = new Person_Account__c();
        pa.PersonID__c = acc.Id;
        pa.Account_Number__c = accDetail.Id;        
        insert pa;
        
        ApexPages.currentPage().getParameters().put('ID', acc.Id);
        MemberPotentialController controller = new MemberPotentialController(new ApexPages.StandardController(acc));
    }
}