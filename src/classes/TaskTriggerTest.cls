@isTest
public class TaskTriggerTest{
     
  public static testMethod void testInsert(){
  String ProfileId = UserInfo.getProfileId(); 
  String UserId = UserInfo.getUserId();
    List<Profile> profiles = [Select id from Profile where name = 'CFCU Admin'];
  case cs = new case();
  cs.Status = 'inProcess';
  cs.Ownership__c = 'Keep';
  cs.OwnerId = UserId;
  cs.Primary_category__c = 'Account Maintenance';
  cs.Secondary_category__c = 'Account Services';
  cs.Tertiary_category__c = 'Check Orders';
  cs.Subject = 'testcase for task @@';
  cs.Brand__c = 'Chevron';
  insert cs;
 // List<case> cs1 = [Select id, status from case where Subject =:'testcase for task @@']; 
   Task nt = new Task();
     nt.Subject = 'Call';
     nt.Status = 'Open';
     nt.Priority = 'Normal';
     nt.whatId = cs.ID;
     insert nt;
     
     List<Task> tk =[select id, status from Task where whatId =:cs.ID];
     
     try{
     
        if(ProfileId==profiles[0].Id){
     delete nt;
       }
     }
     catch (DmlException ex) {
            System.assertEquals('You are not allowed to delete a Task. Please contact your System Administrator for assistance.', ex.getDmlMessage(0));  
     }
     //else{ nt.Status='Complete';}
     
     
     for(integer i =0; i<tk.size(); i++){
       tk[i].Status = 'Complete';
     } 
     
     
    try{
           cs.Status='Closed';
            Update cs;
    
       Task nt1 = new Task();
        nt1.Subject = 'Call';
        nt1.Status = 'Open';
        nt1.Priority = 'Normal';
        nt1.whatId = cs.ID;
        insert nt1; 
        }catch (DmlException ex) {
            System.assertEquals('You can not create a new Task on a Closed case. Please ReOpen the case to create a new one.', ex.getDmlMessage(0));   
        }
    } 
     
     
  }