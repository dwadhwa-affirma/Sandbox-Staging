@isTest
public class UpdateCaseCommentCountBatchTest {
	static testMethod void testMethod1(){
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