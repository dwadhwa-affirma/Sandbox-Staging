@isTest
public class SetRecordTypeStandAloneCaseCtrlTest {

    static testmethod void testmethod1(){

        RecordType recTpe = [Select Id, Name from RecordType where SobjectType='Case' AND Name = 'Account Servicing' Limit 1];
  
        CaseRecordType__c crt = new CaseRecordType__c();
        crt.RecordTypeId__c = recTpe.Id;
        crt.Primary_Category__c = 'test1';
        crt.Secondary_Category__c = 'test2';
        crt.Teritiary_Category__c = 'test3';
        crt.Name = '000';
        insert crt; 
      test.startTest();
        Case cRec = new Case();
           cRec.Brand__c = 'CFCU';
           cRec.CaseComments__c = 'test comments';
        insert cRec;
        
        CaseComment cc = new CaseComment();
           cc.ParentId = cRec.Id;
        insert cc;
        
        PageReference pageRef = Page.SetRecordTypeStandAloneCase;
        Test.setCurrentPage(pageRef);      
        SetRecordTypeStandAloneCaseController controller = new SetRecordTypeStandAloneCaseController(new ApexPages.StandardController(cRec)); 

        //controller.pcOptions();
        //controller.pcValue = 'test1';
//        controller.scOptions();
       // controller.scValue = 'test2';
       // controller.tcOptions();
       // controller.tcValue = 'test3';
       // controller.change();
       // controller.nextPage();
         
        Attachment attach=new Attachment();    
        attach.Name='Unit Test Attachment';
        Blob file = Blob.valueOf('Unit Test Attachment Body');
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attach.body=bodyBlob;
        attach.parentId= cRec.id;
        insert attach;
        controller.process();
        test.stopTest();
    }
   
    
  /*  static testmethod void testmethod2(){
        
        Case cRec = new Case();
        
        PageReference pageRef = Page.SetRecordTypeStandAloneCase;
        Test.setCurrentPage(pageRef);     
        SetRecordTypeStandAloneCaseController controller = new SetRecordTypeStandAloneCaseController(new ApexPages.StandardController(cRec));       

        controller.pcValue = 'test1';
       
        controller.scOptions();        
        controller.process1();
        System.assertEquals(ApexPages.getMessages()[0].getSummary(), 'Please select Secondary Category') ;
    }
    */
   /* static testMethod void testMethod3(){

       Case cRec = new Case();
       
       PageReference pageRef = Page.SetRecordTypeStandAloneCase;
       Test.setCurrentPage(pageRef);       
       SetRecordTypeStandAloneCaseController controller = new SetRecordTypeStandAloneCaseController(new ApexPages.StandardController(cRec)); 

       controller.pcValue = 'test1';
       controller.scOptions();
       controller.scValue = 'test2';
       controller.tcOptions();
       controller.process1();
       System.assertEquals(ApexPages.getMessages()[0].getSummary(), 'Please select Tertiary Category');
    } */
    
   /* static testMethod void testMethod4(){

       Case cRec = new Case();
       
       PageReference pageRef = Page.SetRecordTypeStandAloneCase;
       Test.setCurrentPage(pageRef);        
       SetRecordTypeStandAloneCaseController controller = new SetRecordTypeStandAloneCaseController(new ApexPages.StandardController(cRec));       

       controller.pcOptions();
       controller.process1();
       System.assertEquals(ApexPages.getMessages()[0].getSummary(), 'Please select Primary Category');        
    } 
    */
    static testmethod void testmethod6(){

        Case cRec = new Case();
        
        PageReference pageRef = Page.SetRecordTypeStandAloneCase;
        Test.setCurrentPage(pageRef);       
        SetRecordTypeStandAloneCaseController controller = new SetRecordTypeStandAloneCaseController(new ApexPages.StandardController(cRec));        

        controller.pcValue = 'test1';
        controller.scOptions();        
        controller.nextPage();
        System.assertEquals(ApexPages.getMessages()[0].getSummary(), 'Please select Secondary Category') ;
    }
    
     static testMethod void testMethod8(){

       Case cRec = new Case();
       
       PageReference pageRef = Page.SetRecordTypeStandAloneCase;
       Test.setCurrentPage(pageRef);        
       SetRecordTypeStandAloneCaseController controller = new SetRecordTypeStandAloneCaseController(new ApexPages.StandardController(cRec));         

       controller.pcOptions();
       controller.nextPage();
       System.assertEquals(ApexPages.getMessages()[0].getSummary(), 'Please select Primary Category');      
    }
    
    static testMethod void testMethod9(){

       Case cRec = new Case();
              
       PageReference pageRef = Page.SetRecordTypeStandAloneCase;
       Test.setCurrentPage(pageRef);       
       SetRecordTypeStandAloneCaseController controller = new SetRecordTypeStandAloneCaseController(new ApexPages.StandardController(cRec)); 
        
       controller.pcValue = 'test1';
       controller.scOptions();
       controller.scValue = 'test2';
       controller.tcOptions();
       controller.nextPage();
       System.assertEquals(ApexPages.getMessages()[0].getSummary(), 'Please select Tertiary Category');
    } 
    
    static testmethod void testmethod10(){

        List<RecordType> recTpe = [Select Id, Name from RecordType where SobjectType='Case' AND Name = 'Account Servicing'];
        if(recTpe.size()>0){
        CaseRecordType__c crt = new CaseRecordType__c();
        crt.RecordTypeId__c = recTpe[0].Id;
        crt.Primary_Category__c = 'test1';
        crt.Secondary_Category__c = 'test2';
        crt.Teritiary_Category__c = 'test3';
        crt.Name = '000';
        insert crt; 
        }
        test.startTest();
        Case cRec = new Case();
           cRec.Brand__c = 'CFCU';
           cRec.CaseComments__c = 'test comments';
        insert cRec;
        
        CaseComment cc = new CaseComment();
           cc.ParentId = cRec.Id;
        insert cc;
        
        PageReference pageRef = Page.SetRecordTypeStandAloneCase;
        Test.setCurrentPage(pageRef);     
        SetRecordTypeStandAloneCaseController controller = new SetRecordTypeStandAloneCaseController(new ApexPages.StandardController(cRec));  
      
        controller.pcOptions();
        controller.pcValue = 'test1';
        controller.scOptions();
        controller.scValue = 'test2';
        controller.tcOptions();
        controller.tcValue = 'test3';
        //controller.process1();
        
        controller.pcOptions();
        controller.pcValue = '-None-';
        controller.scOptions();
        controller.scValue = '-None-';
        controller.tcOptions();
        controller.tcValue = '-None-';
        controller.process1();
        test.stopTest();
    }
    
    static testMethod void testMethod11(){

        RecordType recTpe = [Select Id, Name from RecordType where SobjectType='Case' AND Name = 'Account Servicing' Limit 1];
 
        CaseRecordType__c crt = new CaseRecordType__c();
        crt.RecordTypeId__c = recTpe.Id;
        crt.Primary_Category__c = 'test1';
        crt.Secondary_Category__c = 'test2';
        crt.Teritiary_Category__c = 'test3';
        crt.Name = '000';
        insert crt; 
        
        Case cRec = new Case();
        
        PageReference pageRef = Page.SetRecordTypeStandAloneCase;
        Test.setCurrentPage(pageRef);      
        SetRecordTypeStandAloneCaseController controller = new SetRecordTypeStandAloneCaseController(new ApexPages.StandardController(cRec)); 
        
        controller.doCancel();
    }
    
    static testMethod void testMethod12(){
        
        Case c = new Case();
           c.Brand__c = 'CFCU';
        insert c;

        PageReference pageRef = Page.InputFilePage;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('caseId', c.Id); 
        SetRecordTypeStandAloneCaseController controller = new SetRecordTypeStandAloneCaseController(new ApexPages.StandardController(c));
    }
    
    static testMethod void TestMethodSearchTertiary()
    {
    	Case c = new Case();
        c.Brand__c = 'CFCU';
        insert c;
    	SetRecordTypeStandAloneCaseController controller = new SetRecordTypeStandAloneCaseController(new ApexPages.StandardController(c));
    	controller.SearchTertiary();
    	
    
    }
    
    static testMethod void TestMethodChangeCategories()
    {
    	 RecordType recTpe = [Select Id, Name from RecordType where SobjectType='Case' AND Name = 'Account Servicing' Limit 1];
 
        CaseRecordType__c crt = new CaseRecordType__c();
        crt.RecordTypeId__c = recTpe.Id;
        crt.Primary_Category__c = 'test1';
        crt.Secondary_Category__c = 'test2';
        crt.Teritiary_Category__c = 'test3';
        crt.Name = '000';
        insert crt; 
    	Case c = new Case();
        c.Brand__c = 'CFCU';
        insert c;
    	SetRecordTypeStandAloneCaseController controller = new SetRecordTypeStandAloneCaseController(new ApexPages.StandardController(c));
    	controller.pcOptions();
        controller.pcValue = 'test1';
        controller.scOptions();
        controller.scValue = 'test2';
        controller.tcOptions();
        controller.tcValue = 'test3';
        controller.change();
        controller.nextPage();
        controller.process1();
    	//controller.ChangeCategories();
    
    }
}