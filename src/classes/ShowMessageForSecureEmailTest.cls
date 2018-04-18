@isTest
public class ShowMessageForSecureEmailTest{

    @IsTest 
  
       public static void UnitTest()
      {
          Test.startTest();

           Case cs = new Case();
              cs.Brand__c = 'CFCU';
        //      cs.SecureEmail__c ='';
            insert cs;
            
            Case cs1 = new Case();
              cs1.Brand__c = 'CFCU';
             // cs1.SecureEmail__c ='test@test.com';
                insert cs1;
                
             
		//	ApexPages.StandardController sc = new ApexPages.standardController(cs1); 
		PageReference pageRef = Page.ShowMessageForSecureEmail;
		Test.setCurrentPage(pageRef); 
		 ApexPages.currentPage().getParameters().put('ID', cs1.Id);
		  
    		ShowMessageForSecureEmail controller = new ShowMessageForSecureEmail(new ApexPages.standardController(cs1)); 
    		
    		ApexPages.currentPage().getParameters().put('ID', cs.Id);
		  
    		controller = new ShowMessageForSecureEmail(new ApexPages.standardController(cs)); 
              
         Test.stopTest();
  
      }
 }