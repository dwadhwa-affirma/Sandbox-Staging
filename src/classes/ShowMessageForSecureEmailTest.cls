@isTest
public class ShowMessageForSecureEmailTest{

    @IsTest 
  
       public static void UnitTest()
      {
           Case cs = new Case();
              cs.Brand__c = 'CFCU';
              cs.SecureEmail__c ='';
            insert cs;
            
            Case cs1 = new Case();
              cs1.Brand__c = 'CFCU';
              cs1.SecureEmail__c ='test@test.com';
            insert cs1;
            
            ShowMessageForSecureEmail scs = new ShowMessageForSecureEmail(new ApexPages.StandardController(cs));
            
      }
 }