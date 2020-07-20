@isTest
private class LeadOwnersControllerTest{
  @testSetup
  static void setupTestData(){
    test.startTest();
    list<Lead> lstLead = new List<Lead>();
    
    Lead l1 = new Lead(LastName = 'LastName268', Status = 'Open', HasOptedOutOfEmail = false,OwnerId = UserInfo.getUserId(), IsConverted = false, IsUnreadByOwner = false, Keep__c = false);
     Lead l2 = new Lead(LastName = 'LastName2682', Status = 'Open', HasOptedOutOfEmail = false, IsConverted = false, IsUnreadByOwner = false, Keep__c = false,OwnerId = UserInfo.getUserId());
    
       
   
  insert l1;
  insert l2;
    test.stopTest();
  }
  static testMethod void test_GetuserLeads_UseCase1(){
   
    LeadOwnersController.GetuserLeads();
  }
  static testMethod void test_saveUserLeads_UseCase1(){
   list<Lead> lstlead = [select Id,LastName, OwnerId from Lead limit 2];
    LeadOwnersController.QueueWrapper qw = new LeadOwnersController.QueueWrapper(lstlead[0]);
    LeadOwnersController.QueueWrapper qw1 = new LeadOwnersController.QueueWrapper(lstlead[1]);
    qw1.selected = true;
    
    List<LeadOwnersController.QueueWrapper> listQueue = new List<LeadOwnersController.QueueWrapper> ();
         
    listQueue.add(qw);
    listQueue.add(qw1);
    string dataserialize = JSON.serialize(listQueue);
    
    LeadOwnersController.saveUserLeads(dataserialize,UserInfo.getUserId());
  }

}