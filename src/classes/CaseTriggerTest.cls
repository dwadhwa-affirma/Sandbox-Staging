@isTest
public class CaseTriggerTest {
    
    static testMethod void testMethod1(){
             
        RecordType recTpe = [Select Id, Name from RecordType where Name='Brand Details' Limit 1];
        
        Mapping__c mapg = new Mapping__c();
          mapg.RecordTypeId = recTpe.Id;
          mapg.Object_Name__c = 'Case';
          mapg.Brand_Code__c = 'BC01';
          mapg.Brand_Abbreviation__c = 'CFCU';
          mapg.Credit_Union_Name__c = 'Chevron Federal';
          mapg.Image_URL__c = 'xyz';
          mapg.Support_Contact_Details__c = 'test details';       
        insert mapg;   
 
        Case cs = new Case();
          cs.Brand__c = 'CFCU';
        insert cs;
        
        cs.Brand__c = 'Spectrum';
        update cs;   
  
    }
    
    static testMethod void testMethod2(){
        
        Case cs = new Case();
           cs.Brand__c = 'CFCU';
           cs.Primary_Category__c = 'Shared Branch';
        insert cs;
        
        Task tk = new task();
          tk.Status = 'Open';
        insert tk;
        
        try{
            cs.Status = 'Closed';
            update cs;
        }catch (DmlException ex) {
            System.assertEquals('All Tasks associated with a Case must be close/completed before the Case can be closed.', ex.getDmlMessage(0));   
        }
    } 
    
  
    static testMethod void testMethod3(){
        
        Account_Details__c accDetail = new Account_Details__c();
          accDetail.Name = 'Test';
          accDetail.RecType__c = 'ACCT';
          accDetail.Reference__c = 'BC01';
        insert accDetail;
        
        Case cs = new Case();
          cs.Account_Number__c = accDetail.Id;
        insert cs;
    } 
    
    static testMethod void testMethod4(){
        
        Case cs = new Case();
          cs.Brand__c = '';
       //   cs.Account_Number__c = '';
        
        Test.startTest();
        try {
        insert cs;
       }
        catch (DmlException ex) {
            System.assertEquals('Please select either an "Account Number" OR a "Brand" to proceed further', ex.getDmlMessage(0));   
    }
        Test.stopTest();
  } 
    
    
  /*  static testMethod void testMethod5(){

        Case_Type_Decisiong__c cd = new Case_Type_Decisiong__c();
           cd.Case_Type__c = 'test1 - test2 - test3';
           cd.Case_text__c = 'this is for test';
           cd.Name = 'abc1';
        insert cd;
        
         Case cs = new Case();
          cs.Brand__c = 'CFCU';
          cs.Primary_Category__c = 'test1';
          cs.Secondary_Category__c = 'test2';
          cs.Tertiary_Category__c = 'test3';
          cs.Case_type__c = 'this is for test';
        insert cs;
   }  */
    
    
    static testMethod void testMethod6(){
   		
   		
   
        Account_Details__c accDetail = new Account_Details__c();
        accDetail.Name = 'Test';
        accDetail.RecType__c = 'ACCT';
        insert accDetail;
        
        Account_Details__c accDetail1 = new Account_Details__c();
        accDetail1.Name = 'Test';
        accDetail1.RecType__c = 'CARD';
        insert accDetail1; 
 
        Case cs1 = new Case();
          cs1.Account_Number__c = accDetail.Id;
         
        insert cs1;
        
        cs1.Account_Number__c = accDetail1.Id;
        update cs1; 
    } 
    
    static testMethod void testMethod7(){
        
        Profile[] p1 = [select Id from Profile where Name = 'System Administrator' limit 1];
        
        User user1 = new User(alias = 'u1',lastname='test999', languagelocalekey='en_US', 
                              email='User1@avfg.com', emailencodingkey='UTF-8', 
                              localesidkey='en_US', profileId = p1[0].id, timezonesidkey='America/Los_Angeles', 
                              username='test9991'+'@avfg.com',
                              Mortgage_Loan_Officer__c = true);
        
        insert user1;

        Case cs = new Case();
           cs.Status = 'Closed';
           cs.Brand__c = 'Specturm';
        insert cs;
        
       cs.OwnerId = user1.Id; 
       update cs;
      
    } 
    
    static testMethod void testMethod8(){
        
        RecordType recTpe = [Select Id, Name from RecordType where Name='Brand Details' Limit 1];
        
        Mapping__c mapg = new Mapping__c();
          mapg.RecordTypeId = recTpe.Id;
          mapg.Object_Name__c = 'Case';
          mapg.Brand_Code__c = 'BC01';
          mapg.Brand_Abbreviation__c = 'CFCU';
          mapg.Credit_Union_Name__c = 'Chevron Federal';
          mapg.Image_URL__c = 'xyz';
          mapg.Support_Contact_Details__c = 'test details';       
        insert mapg; 
        
         Account_Details__c accDetail = new Account_Details__c();
          accDetail.Name = 'Test';
          accDetail.RecType__c = 'ACCT';
          accDetail.Reference__c = 'BC01';
        insert accDetail;
        
        Case cs = new Case();
          cs.Account_Number__c = accDetail.Id;
        insert cs;
        
    }
    
    static testMethod void testMethod9(){
        
        Profile[] p1 = [select Id from Profile where Name = 'CFCU Admin' limit 1];
        
        User user1 = new User(alias = 'u1',lastname='test999', languagelocalekey='en_US', 
                              email='User1@avfg.com', emailencodingkey='UTF-8', 
                              localesidkey='en_US', profileId = p1[0].id, timezonesidkey='America/Los_Angeles', 
                              username='test9991'+'@avfg.com',
                              Mortgage_Loan_Officer__c = true);
        
        insert user1;
        
        Case cs = new Case();
           cs.Status = 'Open';
           cs.Brand__c = 'Specturm';
        insert cs;
       
       cs.Status = 'Closed';
       cs.OwnerId = user1.Id; 
       update cs;     
    }  
    
    static testMethod void testMethod10(){

CaseRecordType__c crt = new CaseRecordType__c();
   		crt.Primary_Category__c = 'AAA';
   		crt.Secondary_Category__c = 'BBB';
   		crt.Teritiary_Category__c = 'CCC';
   		crt.Name = 'AAA';
   		crt.SLA__c = 50;
   		insert crt;
   		
        Account_Details__c accDetail = new Account_Details__c();
        accDetail.Name = 'Test123';
        accDetail.RecType__c = 'ACCT';
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
        pa.Name_Type__c = 0;
        insert pa;

        Case cs = new Case();
        cs.Brand__c = 'Specturm';
        cs.Origin = 'Email';
        cs.Subject = '1234 testing tet sdf asdfa';
         cs.Primary_Category__c = 'AAA';
          cs.Secondary_Category__c = 'BBB';
          cs.Tertiary_Category__c = 'CCC';
          cs.Origin = 'BoomiBulk';
        cs.Account_Number__c = accDetail.Id;
        cs.Member_Number__c = 'Test123';
        cs.AccountId = acc.Id;       
        insert cs;
        
        cs.Origin = 'Email';
        
        update cs;
    }
    
    static testMethod void testMethod11(){

        Case cs = new Case();
          cs.Brand__c = 'Specturm';
          cs.Origin = 'Email';
          cs.Subject = '';          
        insert cs;
    }
    
    static testMethod void testMethod12(){

        Case cs = new Case();
          cs.Brand__c = 'Specturm';
          cs.Origin = 'Email';
          cs.Subject = '1   ';          
        insert cs;       
    }
}