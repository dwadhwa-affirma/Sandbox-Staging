@isTest
public class ShowMessageForSecureEmailTest{

    @IsTest 
  
       public static void UnitTest()
      {
          Create_SLA__c cl = new Create_SLA__c();
        cl.Status__c = 'Open';
        cl.Name = 'Open';
        cl.hours__c = 8;
        insert cl;
        
        Create_SLA__c cl1 = new Create_SLA__c();
        cl1.Status__c = 'In Process';
        cl1.Name = 'In Process';
        cl1.hours__c = 20;
        insert cl1;
        
        Create_SLA__c cl2 = new Create_SLA__c();
        cl2.Status__c = 'Resolution';
        cl2.Name = 'Resolution';
        cl2.hours__c = 20;
        insert cl2;
          
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