@isTest
public class UpdateCaseCommentCountBatchTest {
	static testMethod void testMethod1(){
		
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
        
        Case c = new Case();
        c.Status = 'Open';
        c.Brand__c='CFCU';
        insert c;
        
        CaseComment cc = new CaseComment();
        cc.CommentBody = 'Test';
        cc.ParentId = c.id;
        insert cc;
        

     Test.StartTest();
     UpdateCaseCommentCountBatch job = new UpdateCaseCommentCountBatch();
	 ID batchprocessid = Database.executeBatch(job);       
     
     delete cc; 
     Test.StopTest();
    }
    
}