@isTest
public class SetRecordTypeAccountDetailsCtrlTest {
    
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
        
        Account_Details__c accDetails = new Account_Details__c();
            accDetails.Name = 'testname';
        insert accDetails; 
        
        Person_Account__c pa = new Person_Account__c();
            pa.Account_Number__c = accDetails.Id;
            pa.PersonID__c = acc.Id;
        insert pa;

        RecordType recTpe = [Select Id, Name from RecordType where SobjectType='Case' AND Name = 'Account Servicing' Limit 1];
 
        CaseRecordType__c crt = new CaseRecordType__c();
        crt.RecordTypeId__c = recTpe.Id;
        crt.Primary_Category__c = 'test1';
        crt.Secondary_Category__c = 'test2';
        crt.Teritiary_Category__c = 'test3';
        crt.Name = '000';
        insert crt; 
        
        Case cRec = new Case();
           cRec.Brand__c = 'CFCU';
           cRec.CaseComments__c = 'test comments';
        insert cRec;
        
        CaseComment cc = new CaseComment();
           cc.ParentId = cRec.Id;
        insert cc;
        
        test.starttest();
        PageReference pageRef = Page.SetRecordTypeAccountDetails;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('firstPage', 'true');
        ApexPages.currentPage().getParameters().put('acctId', accDetails.Id);        
        SetRecordTypeAccountDetailsController controller = new SetRecordTypeAccountDetailsController(new ApexPages.StandardController(cRec)); 
        
        controller.accountName = accDetails.Id;        
        controller.personId = acc.Id;
        controller.pcOptions();
        controller.pcValue = 'test1';
        controller.scOptions();
        controller.scValue = 'test2';
        controller.tcOptions();
        controller.tcValue = 'test3';
        controller.change();
        controller.nextPage();
        controller.process();
         test.stoptest();
    }
    
    static testmethod void testmethod2(){

        Account_Details__c accDetails = new Account_Details__c();
            accDetails.Name = 'testname';
        insert accDetails;
        
        Case cRec = new Case();
        
        PageReference pageRef = Page.SetRecordTypeAccountDetails;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('firstPage', 'true');
        ApexPages.currentPage().getParameters().put('acctId', accDetails.Id);        
        SetRecordTypeAccountDetailsController controller = new SetRecordTypeAccountDetailsController(new ApexPages.StandardController(cRec));       
        controller.accountName = accDetails.Id;
        controller.pcValue = 'test1';
        controller.scOptions();        
        controller.process1();
        System.assertEquals(ApexPages.getMessages()[0].getSummary(), 'Please select Secondary Category') ;
    }
    
    static testMethod void testMethod3(){

        Account_Details__c accDetails = new Account_Details__c();
            accDetails.Name = 'testname';
        insert accDetails;
       
       Case cRec = new Case();
       
       PageReference pageRef = Page.SetRecordTypeAccountDetails;
       Test.setCurrentPage(pageRef);
       ApexPages.currentPage().getParameters().put('firstPage', 'true');
       ApexPages.currentPage().getParameters().put('acctId', accDetails.Id);        
       SetRecordTypeAccountDetailsController controller = new SetRecordTypeAccountDetailsController(new ApexPages.StandardController(cRec)); 
       controller.accountName = accDetails.Id;
       controller.pcValue = 'test1';
       controller.scOptions();
       controller.scValue = 'test2';
       controller.tcOptions();
       controller.process1();
       System.assertEquals(ApexPages.getMessages()[0].getSummary(), 'Please select Tertiary Category');
    } 
    
    static testMethod void testMethod4(){

        Account_Details__c accDetails = new Account_Details__c();
            accDetails.Name = 'testname';
        insert accDetails;
       
       Case cRec = new Case();
       
       PageReference pageRef = Page.SetRecordTypeAccountDetails;
       Test.setCurrentPage(pageRef);
       ApexPages.currentPage().getParameters().put('firstPage', 'true');
       ApexPages.currentPage().getParameters().put('acctId', accDetails.Id);        
       SetRecordTypeAccountDetailsController controller = new SetRecordTypeAccountDetailsController(new ApexPages.StandardController(cRec));       
       controller.accountName = accDetails.Id;
       controller.pcOptions();
       controller.process1();
       System.assertEquals(ApexPages.getMessages()[0].getSummary(), 'Please select Primary Category');        
    } 
    
    static testMethod void testMethod5(){
        
       Account_Details__c accDetails = new Account_Details__c();
           accDetails.Name = 'testname';
       insert accDetails;  
        
       Case cRec = new Case();
       
       PageReference pageRef = Page.SetRecordTypeAccountDetails;
       Test.setCurrentPage(pageRef);
       ApexPages.currentPage().getParameters().put('firstPage', 'true');
       ApexPages.currentPage().getParameters().put('acctId', accDetails.Id);        
       SetRecordTypeAccountDetailsController controller = new SetRecordTypeAccountDetailsController(new ApexPages.StandardController(cRec));        
       controller.process1();
       System.assertEquals(ApexPages.getMessages()[0].getSummary(), 'Please select Member');       
    } 
    
    static testmethod void testmethod6(){

        Account_Details__c accDetails = new Account_Details__c();
            accDetails.Name = 'testname';
        insert accDetails; 

        Case cRec = new Case();
        
        PageReference pageRef = Page.SetRecordTypeAccountDetails;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('firstPage', 'true');
        ApexPages.currentPage().getParameters().put('acctId', accDetails.Id);        
        SetRecordTypeAccountDetailsController controller = new SetRecordTypeAccountDetailsController(new ApexPages.StandardController(cRec));        
        controller.accountName = accDetails.Id;
        controller.pcValue = 'test1';
        controller.scOptions();        
        controller.nextPage();
        System.assertEquals(ApexPages.getMessages()[0].getSummary(), 'Please select Secondary Category') ;
    }
    
    static testMethod void testMethod7(){
       Account_Details__c accDetails = new Account_Details__c();
           accDetails.Name = 'testname';
       insert accDetails; 
       
       Case cRec = new Case();
       
       PageReference pageRef = Page.SetRecordTypeAccountDetails;
       Test.setCurrentPage(pageRef);
       ApexPages.currentPage().getParameters().put('firstPage', 'true');
       ApexPages.currentPage().getParameters().put('acctId', accDetails.Id);        
       SetRecordTypeAccountDetailsController controller = new SetRecordTypeAccountDetailsController(new ApexPages.StandardController(cRec));         
       controller.nextPage();
       System.assertEquals(ApexPages.getMessages()[0].getSummary(), 'Please select Member');       
    }
    
     static testMethod void testMethod8(){

       Account_Details__c accDetails = new Account_Details__c();
            accDetails.Name = 'testname';
       insert accDetails; 
       
       Case cRec = new Case();
       
       PageReference pageRef = Page.SetRecordTypeAccountDetails;
       Test.setCurrentPage(pageRef);
       ApexPages.currentPage().getParameters().put('firstPage', 'true');
       ApexPages.currentPage().getParameters().put('acctId', accDetails.Id);        
       SetRecordTypeAccountDetailsController controller = new SetRecordTypeAccountDetailsController(new ApexPages.StandardController(cRec));         
       controller.accountName = accDetails.Id;
       controller.pcOptions();
       controller.nextPage();
       System.assertEquals(ApexPages.getMessages()[0].getSummary(), 'Please select Primary Category');      
    }
    
    static testMethod void testMethod9(){

       Account_Details__c accDetails = new Account_Details__c();
            accDetails.Name = 'testname';
       insert accDetails; 
       
       Case cRec = new Case();
              
       PageReference pageRef = Page.SetRecordTypeAccountDetails;
       Test.setCurrentPage(pageRef);
       ApexPages.currentPage().getParameters().put('firstPage', 'true');
       ApexPages.currentPage().getParameters().put('acctId', accDetails.Id);        
       SetRecordTypeAccountDetailsController controller = new SetRecordTypeAccountDetailsController(new ApexPages.StandardController(cRec)); 
       controller.accountName = accDetails.Id;
       controller.pcValue = 'test1';
       controller.scOptions();
       controller.scValue = 'test2';
       controller.tcOptions();
       controller.nextPage();
       System.assertEquals(ApexPages.getMessages()[0].getSummary(), 'Please select Tertiary Category');
    } 
    
    static testmethod void testmethod10(){
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
        
        Account_Details__c accDetails = new Account_Details__c();
            accDetails.Name = 'testname';
        insert accDetails; 
        
        Person_Account__c pa = new Person_Account__c();
            pa.Account_Number__c = accDetails.Id;
            pa.PersonID__c = acc.Id;
        insert pa;

        RecordType recTpe = [Select Id, Name from RecordType where SobjectType='Case' AND Name = 'Account Servicing' Limit 1];
 
        CaseRecordType__c crt = new CaseRecordType__c();
        crt.RecordTypeId__c = recTpe.Id;
        crt.Primary_Category__c = 'test1';
        crt.Secondary_Category__c = 'test2';
        crt.Teritiary_Category__c = 'test3';
        crt.Name = '000';
        insert crt; 
        
        Case cRec = new Case();
           cRec.Brand__c = 'CFCU';
           cRec.CaseComments__c = 'test comments';
        insert cRec;
        
        CaseComment cc = new CaseComment();
           cc.ParentId = cRec.Id;
        insert cc;
        
         test.starttest();
        PageReference pageRef = Page.SetRecordTypeAccountDetails;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('firstPage', 'true');
        ApexPages.currentPage().getParameters().put('acctId', accDetails.Id);        
        SetRecordTypeAccountDetailsController controller = new SetRecordTypeAccountDetailsController(new ApexPages.StandardController(cRec));  
        
        controller.accountName = accDetails.Id;        
        controller.personId = acc.Id;
        controller.pcOptions();
        controller.pcValue = 'test1';
        controller.scOptions();
        controller.scValue = 'test2';
        controller.tcOptions();
        controller.tcValue = 'test3';
        controller.process1();
         test.stoptest();
    }
    
    static testMethod void testMethod11(){
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
        
        Account_Details__c accDetails = new Account_Details__c();
            accDetails.Name = 'testname';
        insert accDetails;       

        RecordType recTpe = [Select Id, Name from RecordType where SobjectType='Case' AND Name = 'Account Servicing' Limit 1];
 
        CaseRecordType__c crt = new CaseRecordType__c();
        crt.RecordTypeId__c = recTpe.Id;
        crt.Primary_Category__c = 'test1';
        crt.Secondary_Category__c = 'test2';
        crt.Teritiary_Category__c = 'test3';
        crt.Name = '000';
        insert crt; 
        
        Case cRec = new Case();
        
        PageReference pageRef = Page.SetRecordTypeAccountDetails;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('firstPage', 'true');
        ApexPages.currentPage().getParameters().put('acctId', accDetails.Id);        
        SetRecordTypeAccountDetailsController controller = new SetRecordTypeAccountDetailsController(new ApexPages.StandardController(cRec)); 
        
        controller.doCancel();
    }
    
    static testMethod void testMethod12(){
        
        Case c = new Case();
           c.Brand__c = 'CFCU';
        insert c;

        PageReference pageRef = Page.InputFilePage;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('caseId', c.Id); 
        SetRecordTypeAccountDetailsController controller = new SetRecordTypeAccountDetailsController(new ApexPages.StandardController(c));
    }
}