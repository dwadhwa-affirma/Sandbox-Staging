@isTest
private class CaseTaskCountTriggerTest{
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