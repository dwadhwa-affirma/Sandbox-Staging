@isTest
public class BatchClassTest {

    static testMethod void testMethod1(){
        List<Account_Details__c> accDetails = new List<Account_Details__c>();
            for(integer i = 0; i<200; i++){
                 Account_Details__c a = new Account_Details__c();
                 a.Name = 'test name'+'i';
                 accDetails.add(a);
               }
        insert accDetails;

     Test.StartTest();           
        id batchinstanceid = database.executeBatch(new BatchClass('Select Id,Name,Parent_Account__r.Name FROM Account_Details__c where RecType__c != \'ACCT\' AND Parent_Account__c = \'\''));
     Test.StopTest();
    }
}