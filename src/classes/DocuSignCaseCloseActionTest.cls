@isTest
public class DocuSignCaseCloseActionTest {
    
    static testMethod void testMethod1(){
        Profile[] p1 = [select Id from Profile where Name = 'CFCU Admin' limit 1];
        
        User user1 = new User(alias = 'u1',lastname='test999', languagelocalekey='en_US', 
                              email='User1@avfg.com', emailencodingkey='UTF-8', 
                              localesidkey='en_US', profileId = p1[0].id, timezonesidkey='America/Los_Angeles', 
                              username='test9991'+'@avfg.com');
        
        insert user1;
        list<id> lstid = new List<id>();
        Case cs = new Case();
        cs.Brand__c = 'Chevron';
        cs.Previous_Owner__c = user1.Id;
        
        insert cs;
        lstid.add(cs.id);
        Test.startTest();
        
        
       
        DocuSignCaseCloseAction.CheckCondition(lstid);
        
        cs.Origin = 'Portal';
        update cs;
        
        DocuSignCaseCloseAction.CheckCondition(lstid);
        
        Test.stopTest();   
    }
}