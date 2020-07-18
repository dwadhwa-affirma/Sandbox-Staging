/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class OpportunityOwnersControllerTest {

     @testSetup
  static void setupTestData(){
    test.startTest();
    Group	listQueue = [select id,Name,Email from Group where Type = 'Queue' and (Email like '%lead.com') limit 1];
		Account account_Obj = new Account(PersonHomePhone='', PersonHasOptedOutOfEmail = false, Name = 'MARIA BANDA');
		Insert account_Obj; 
		
    list<Opportunity> lstLead = new List<Opportunity>();
     Id currentUsersId = UserInfo.getUserId();     
    Opportunity o1 = new Opportunity(Name = 'Name', Ownerid = currentUsersId,StageName = 'Open', CloseDate = system.today(),  Is_Converted__c = true, Queue_Assigned_Id__c= listQueue.Id,  Opportunity_Source__c = 'Word of mouth', AccountId = account_Obj.id,  Ownership__c = 'Auto Assign', Episys_User_ID__c = 1);
    Opportunity o2 = new Opportunity(Name = 'Name', Ownerid = currentUsersId ,StageName = 'Open', CloseDate = system.today(),  Is_Converted__c = true, Queue_Assigned_Id__c= listQueue.Id,  Opportunity_Source__c = 'Word of mouth', AccountId = account_Obj.id,  Ownership__c = 'Keep', Episys_User_ID__c = 1);
          
   
  insert o1;
  insert o2;
  test.stopTest();
  }
  
  static testMethod void test_GetuserOpportunities_UseCase1(){
   
    OpportunityOwnersController.GetuserOpportunities();
  }
  
  static testMethod void test_saveUserOpportunities_UseCase1(){
   list<Opportunity> lstOpportunity = [select Id,Name, OwnerId from Opportunity limit 2];
    OpportunityOwnersController.QueueWrapper qw = new OpportunityOwnersController.QueueWrapper(lstOpportunity[0]);
    OpportunityOwnersController.QueueWrapper qw1 = new OpportunityOwnersController.QueueWrapper(lstOpportunity[1]);
    qw1.selected = true;
    
    List<OpportunityOwnersController.QueueWrapper> listQueue = new List<OpportunityOwnersController.QueueWrapper> ();
         
    listQueue.add(qw);
    listQueue.add(qw1);
    string dataserialize = JSON.serialize(listQueue);
    
    OpportunityOwnersController.saveUserOpportunities(dataserialize,UserInfo.getUserId(),'User');
  }
}