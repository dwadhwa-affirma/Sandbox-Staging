@isTest
public class SearchMemberControllerTest {
    public static testMethod void testMethod1(){
        
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
        
        PageReference pageRef = Page.SearchMember;
        Test.setCurrentPage(pageRef);        
        SearchMemberController controller = new SearchMemberController();
        
        controller.firstnameQuery = 'Test';
        controller.lastnameQuery = 'Test';
        controller.SSNLast4Query = '123';
        //controller.executeSearch();
        controller.clearAll();
        
        controller.firstnameQuery = 'Test';
        controller.executeSearch();
        controller.clearAll();
        
        controller.lastnameQuery = 'Test';
        controller.executeSearch();
        controller.clearAll();
        
        controller.SSNLast4Query = '123';
        controller.executeSearch();
        controller.clearAll();
        
        controller.firstnameQuery = 'Test';
        controller.lastnameQuery = 'Test';
        controller.executeSearch();
        controller.clearAll();
        
        controller.lastnameQuery = 'Test';
        controller.SSNLast4Query = '123';
        controller.executeSearch();
        controller.clearAll();
        
        controller.firstnameQuery = 'Test';
        controller.SSNLast4Query = '123';
        controller.executeSearch();
        controller.clearAll();
        
        controller.nameQuery = 'Test';
        
        acc = null;
        controller.executeSearch();
        controller.searchMsg = true;
   
    }
    
    public static testMethod void testMethod2(){
        
        Account_Details__c acd = new Account_Details__c();
            acd.Name = '56789';
            acd.Card_Name__c = 'Test Name';
            acd.Card_Number__c = '4567890';
        insert acd;

        Folder fd = [Select Id from Folder where Name = 'Shared Documents'];
        
        Document doc = new Document();
            doc.Name = 'CFCU Logo';
            doc.FolderId = fd.Id;
        insert doc;

        PageReference pageRef = Page.SearchMember;
        Test.setCurrentPage(pageRef); 
        ApexPages.currentPage().getParameters().put('Query', acd.Id);
        SearchMemberController controller = new SearchMemberController();
   
        controller.MembernumberQuery = '567';
        controller.CardnameQuery = 'Tst';
        controller.CardnumberQuery = '456';
        controller.searchAccount();
        controller.clearAll();
        
        controller.MembernumberQuery = '567';
        controller.searchAccount();
        controller.clearAll();
        
        controller.CardnameQuery = 'Tst';
        controller.searchAccount();
        controller.clearAll();
        
        controller.CardnumberQuery = '456';
        controller.searchAccount();
        controller.clearAll();
        
        controller.MembernumberQuery = '567';
        controller.CardnameQuery = 'Tst';
        controller.searchAccount();
        controller.clearAll();
        
        controller.CardnameQuery = 'Tst';
        controller.CardnumberQuery = '456';
        controller.searchAccount();
        controller.clearAll();
        
        controller.MembernumberQuery = '567';
        controller.CardnumberQuery = '456';
        controller.searchAccount();
        controller.clearAll();
        
        acd = null;
        controller.searchAccount();
        controller.searchMsgDetails = true;

        controller.getAccountDetails();
        
        controller.getTrustAccountDetails();
        controller.getMemberAccountInfo();
    }
    
    static testMethod void testMethod3(){
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
        
        PageReference pageRef = Page.SearchMember1;
        Test.setCurrentPage(pageRef);        
        SearchMemberController2 controller = new SearchMemberController2(new ApexPages.StandardController(acc));
        
        controller.firstnameQuery = 'Test';
        controller.lastnameQuery = 'Test';
        controller.SSNLast4Query = '123';
        controller.executeSearch();
        controller.clearAll();
        
        controller.firstnameQuery = 'Test';
        controller.executeSearch();
        controller.clearAll();
        
        controller.lastnameQuery = 'Test';
        controller.executeSearch();
        controller.clearAll();
        
        controller.SSNLast4Query = '123';
        controller.executeSearch();
        controller.clearAll();
        
        controller.firstnameQuery = 'Test';
        controller.lastnameQuery = 'Test';
        controller.executeSearch();
        controller.clearAll();
        
        controller.lastnameQuery = 'Test';
        controller.SSNLast4Query = '123';
        controller.executeSearch();
        controller.clearAll();
        
        controller.firstnameQuery = 'Test';
        controller.SSNLast4Query = '123';
        controller.executeSearch();
        controller.clearAll();
        
        controller.nameQuery = 'Test';
        
        acc = null;
        controller.executeSearch();
        controller.searchMsg = true;
        
    }
    
    static testMethod void testMethod4(){
        Account_Details__c acd = new Account_Details__c();
            acd.Name = '56789';
            acd.Card_Name__c = 'Tst Name';
            acd.Card_Number__c = '4567890';
        insert acd;
  
        Folder fd = [Select Id from Folder where Name = 'Shared Documents' Limit 1];

        Document doc = new Document();
            doc.Name = 'CFCU Logo';
            doc.FolderId = fd.Id;
        insert doc;

        PageReference pageRef = Page.SearchMember1;
        Test.setCurrentPage(pageRef); 
        ApexPages.currentPage().getParameters().put('Query', acd.Id);
        SearchMemberController2 controller = new SearchMemberController2();
        
        controller.MembernumberQuery = '567';
        controller.CardnameQuery = 'Tst';
        controller.CardnumberQuery = '456';
        controller.searchAccount();
        controller.clearAll();
        
        controller.MembernumberQuery = '567';
        controller.searchAccount();
        controller.clearAll();
        
        controller.CardnameQuery = 'Tst';
        controller.searchAccount();
        controller.clearAll();
        
        controller.CardnumberQuery = '456';
        controller.searchAccount();
        controller.clearAll();
        
        controller.MembernumberQuery = '567';
        controller.CardnameQuery = 'Tst';
        controller.searchAccount();
        controller.clearAll();
        
        controller.CardnameQuery = 'Tst';
        controller.CardnumberQuery = '456';
        controller.searchAccount();
        controller.clearAll();
        
        controller.MembernumberQuery = '567';
        controller.CardnumberQuery = '456';
        controller.searchAccount();
        controller.clearAll();
        
        acd = null;
        controller.searchAccount();
        controller.searchMsgDetails = true;

        controller.getAccountDetails();
        
        controller.getTrustAccountDetails();
        controller.getMemberAccountInfo();
    }
}