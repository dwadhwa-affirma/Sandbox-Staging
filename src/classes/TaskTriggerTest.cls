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
     
     
     

  @testSetup
  static void setupTestData(){
    Case case_Obj = new Case(IsEscalated = false, Additional_Documents__c = false,Brand__c='CFCU',  Primary_Category__c = 'Account Maintenance', Secondary_Category__c = 'A2A/P2P', Tertiary_Category__c = 'A2A/P2P', SLATemp__c = false);
    Insert case_Obj; 

  }
  static testMethod void test_TaskTrigger(){
   test.startTest();
    List<Case> case_Obj  =  [SELECT CaseNumber,BusinessHoursId,RecordTypeId,IsEscalated,Primary_Category__c,Secondary_Category__c,Tertiary_Category__c,SLATemp__c from Case];
    System.assertEquals(1,case_Obj.size());
    Task task_Obj = new Task(WhatId = case_Obj[0].id, Status = 'Open', Priority = 'High', IsReminderSet = false, IsRecurrence = false);
    Insert task_Obj; 
    delete task_Obj;
   test.stopTest();
  }

  static testMethod void test_UseCase1(){
   test.startTest();
    List<Case> case_Obj  =  [SELECT CaseNumber,BusinessHoursId,RecordTypeId,IsEscalated,Primary_Category__c,Secondary_Category__c,Tertiary_Category__c,SLATemp__c from Case];
    System.assertEquals(1,case_Obj.size());
    
    
    case_Obj[0].IsEscalated=false;
    case_Obj[0].Additional_Documents__c=false;
    
    
    
    case_Obj[0].Primary_Category__c='Account Maintenance';
    case_Obj[0].Secondary_Category__c='A2A/P2P';
    case_Obj[0].Tertiary_Category__c='A2A/P2P';
    case_Obj[0].SLATemp__c=false;

    Update case_Obj[0];
    
    Task task_Obj = new Task(WhatId = case_Obj[0].id, Status = 'Open', Priority = 'High', IsReminderSet = false, IsRecurrence = false);
    
Insert task_Obj; 
          
Database.executeBatch(new UpdateCaseTaskCount(),5);
    test.stopTest();
}

     
     
  }