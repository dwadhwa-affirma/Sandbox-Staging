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
}