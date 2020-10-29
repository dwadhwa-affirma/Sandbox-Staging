@isTest
public class EventTaskTriggerTest {
 
    static testMethod void testMethod1(){       
        Profile[] p1 = [select Id from Profile where Name = 'CFCU Standard User' limit 1];
        
        User user1 = new User(alias = 'u1',lastname='test999', languagelocalekey='en_US', 
                              email='User1@avfg.com', emailencodingkey='UTF-8', 
                              localesidkey='en_US', profileId = p1[0].id, timezonesidkey='America/Los_Angeles', 
                              username='test9991'+'@avfg.com');
        
        insert user1;
        
     System.runAs(user1){     
        Event e = new Event();
           e.Subject = 'test';
           e.DurationInMinutes = 10;
           e.ActivityDateTime = datetime.newInstance(2015, 9, 15, 12, 30, 0);           
        insert e;
                
        try{
             delete e;
            }catch(Exception ex) {
                System.assert(ex.getMessage().contains('You are not allowed to delete an Event. Please contact your System Administrator for assistance.'));
            }
        }
    }
    
    static testMethod void testMethod2(){
        Profile[] p1 = [select Id from Profile where Name = 'CFCU Standard User' limit 1];
        
        User user1 = new User(alias = 'u1',lastname='test999', languagelocalekey='en_US', 
                              email='User1@avfg.com', emailencodingkey='UTF-8', 
                              localesidkey='en_US', profileId = p1[0].id, timezonesidkey='America/Los_Angeles', 
                              username='test9991'+'@avfg.com');
        
        insert user1;
        
      System.runAs(user1){
        Task t = new Task();
          t.Subject = 'test';
        insert t;
        
        try{
             delete t;
           }catch(Exception ex) {
               System.assert(ex.getMessage().contains('You are not allowed to delete a Task. Please contact your System Administrator for assistance.'));
           }
        }
    }
    
    static testMethod void testMethod3(){       
        
        Profile[] p1 = [select Id from Profile where Name = 'CFCU Admin' limit 1];
        
        User user1 = new User(alias = 'u1',lastname='test999', languagelocalekey='en_US', 
                              email='User1@avfg.com', emailencodingkey='UTF-8', 
                              localesidkey='en_US', profileId = p1[0].id, timezonesidkey='America/Los_Angeles', 
                              username='test9991'+'@avfg.com');
        
        insert user1;
        
        string fid ='0000999999' ;
        RecordType recordtype =[SELECT Id,Name FROM RecordType WHERE Name='Person Account'];
        
        List<Account_Details__c> Account_Details = new List<Account_Details__c>();
        Account_Details__c ad = new Account_Details__c();
        ad.Name = fid;        
        Account_Details.add(ad);
        insert Account_Details;
        
        List<Account> accounts = new List<Account>();
        Account acc = new Account();
        acc.Owner = user1;
        acc.FirstName = 'tFName';
        acc.LastName='TLName';
        acc.recordtypeid = recordtype.Id;
        acc.PersonID__C ='V554870800';       
        acc.PersonEmail ='acctest@test.com';      
        accounts.add(acc);
        insert accounts;
        
        Case cas = new Case();
        cas.Subject = 'TestCaseSubject123';
        cas.Description = 'TestCaseSubject123';
        cas.Account_Number__c = ad.id;
        cas.AccountID = acc.id;
        cas.Primary_Category__c = 'Online Banking';
        cas.Status ='Open';
        insert cas;
        
        System.runAs(user1){     
            
            Event e = new Event();
            e.Subject = 'test';
            e.DurationInMinutes = 10;
            e.whatid = cas.id;
            e.ActivityDateTime = datetime.newInstance(2015, 9, 15, 12, 30, 0);           
            insert e;
              
            delete e;
        }
    }
}