@isTest(SeeAllData=True)
public class warningCodeIconControllerTest {
    public static testMethod void testMethod1(){
        
        String RecTypeId= [select Id from RecordType where (Name='Person Account') and (SobjectType='Account')].Id;
        
        List<Account> acc = [Select Id From Account Where RecordTypeID=:RecTypeId Limit 1];
      
     /*   Account acc = new Account();
            acc.LastName = 'test name';
        insert acc;
        
        Account_Details__c accDetail = new Account_Details__c();
           accDetail.Name = 'test';
           accDetail.RecType__c = 'ACCT';
           accDetail.WARNING_01_CODE__c = 'test1';
        insert accDetail; */
        
        //Account_Details__c accDetail = [Select Id, Name from Account_Details__c where RecType__c = 'ACCT' Limit 1]; 
        if(acc.size()>0){
        PageReference pageRef = Page.warningCodeIcon;
        Test.setCurrentPage(pageRef);     
        ApexPages.currentPage().getParameters().put('ID', acc[0].Id);
        warningCodeIconController controller = new warningCodeIconController(new ApexPages.StandardController(acc[0]));
        }
    }
}