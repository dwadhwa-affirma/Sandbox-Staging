@isTest 
public class UpdateAccountMemberBranchTest
{
    static testMethod void testMethod1() 
    {
        Account acc = new Account();
        acc.name = 'Test';
        insert acc;
        
        List<Account_Details__c> listAD = new List<Account_Details__c>();
        for(Integer i=0 ;i <200;i++)
        {
            Account_Details__c accDetail = new Account_Details__c();
            accDetail.Name='Number'+i;
            accDetail.Current_Branch__c = 15;
            accDetail.RecType__c = 'ACCT';
            listAD.add(accDetail);
        }
        
        insert listAD;
        
        Person_Account__c PA = new Person_Account__c();
        PA.Account_Number__c = listAD[0].Id;
        PA.AccountID__c = acc.Id;
        
        insert PA;
        
        Test.startTest();

            UpdateAccountMemberBranch  updateBranch = new UpdateAccountMemberBranch ();
            DataBase.executeBatch(updateBranch); 
            
        Test.stopTest();
    }
}