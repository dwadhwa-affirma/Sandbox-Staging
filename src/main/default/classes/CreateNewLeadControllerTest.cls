@isTest
public class CreateNewLeadControllerTest
{
    static testmethod void testmethod1(){
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
        
        Episys_User__c euc = new Episys_User__c();
        String uid = UserInfo.getUserId();
        User usr = [Select id, name, alias from User where id=:uid]; 
        euc.Alias__c =  usr.alias;
        euc.Assigned_Branch__c = 105;
        euc.Default__c = true;
        euc.Episys_ID__c = 1111;
        euc.Episys_Name__c = 'Test';

        insert euc;
        
        Account_Details__c accDetails = new Account_Details__c();
        accDetails.Name = 'test';
        accDetails.SecureEmailAddress__c = 'sample@sample.com';
        accDetails.Created_By_User__c = 1;
        accDetails.RecType__c = 'ACCT';
        insert accDetails;
        
        PageReference pageRef = Page.CreateNewLead;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('accountid', acc.id);
        Lead l = new Lead();
        CreateNewLeadController controller = new CreateNewLeadController(new ApexPages.StandardController(l));     
        controller.save();       
        controller.leadObject.Product_Type__c = 'Cards';
        controller.save();
        controller.leadObject.Brand__c = 'CFCU';
        controller.SetEpsisUserID();
        controller.currentBranch(accDetails.id);
        controller.save();
    }
}