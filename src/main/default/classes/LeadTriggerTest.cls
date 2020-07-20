@isTest
public class LeadTriggerTest {
    static testMethod void testMethod1(){
        RecordType recTpe = [Select Id, Name from RecordType where Name='Brand Details' Limit 1];
        
        Mapping__c mapg = new Mapping__c();
          mapg.RecordTypeId = recTpe.Id;
          mapg.Object_Name__c = 'Lead';
          mapg.Brand_Code__c = 'BC01';
          mapg.Brand_Abbreviation__c = 'CFCU';
          mapg.Credit_Union_Name__c = 'Chevron Federal';
          mapg.Image_URL__c = 'xyz';
          mapg.Support_Contact_Details__c = 'test details';       
        insert mapg;
        
        Lead ld = new Lead();
          ld.Brand__c = 'CFCU';
          ld.LastName = 'TestName';
        insert ld;
        
          ld.Brand__c = 'Spectrum';
        update ld;
      
    }
    
    static testMethod void testMethod2(){
        
        Lead ld = new Lead();
           ld.LastName = 'TestName';
           ld.Brand__c = '';
    
            try {
                 insert ld;
              }
               catch (DmlException ex) {
                         System.assertEquals('Please select a value!', ex.getDmlMessage(0));   
              }
        
    }
    
    static testMethod void testMethod3(){
        
        User user1 = [Select Id from User where Mortgage_Loan_Officer__c=true Limit 1];
        
        Lead ld = new Lead();   
           ld.LastName = 'testname';
           ld.Brand__c = 'CFCU';
           ld.Mortgage_Loan_Officer__c = user1.Id;
        insert ld;        
   }
    
    static testMethod void testMethod4(){
        
        User user1 = [Select Id from User where Mortgage_Loan_Officer__c=true Limit 1];
        
        Lead ld = new Lead();   
           ld.LastName = 'testname';
           ld.Brand__c = 'CFCU';       
        insert ld; 
          
           ld.Mortgage_Loan_Officer__c = user1.Id;
        update ld;         
   }
    
}