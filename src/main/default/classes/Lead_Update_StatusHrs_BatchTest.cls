@IsTest
public class Lead_Update_StatusHrs_BatchTest {
     public static testMethod void testMethod1() 
    {
    
    SLA_Status_Manager__c sla = new SLA_Status_Manager__c();    
    sla.Name = 'Lead';
    sla.Status__c = 'New';    
    insert sla; 
  	
     Id currentUsersId = UserInfo.getUserId();     
          Id LeadRT = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Non-Member Lead').getRecordTypeId();
        Lead newlead4 = new Lead(Brand__c='CFCU',FirstName = 'FirstName270',LastName = 'LastName270', Status = 'New',company = 'c', RecordTypeId = LeadRT,
                   OwnerId = currentUsersId,Lead_Type__c='Individual', 
                      LeadSource = 'Branch Walk in', Product_Type__c ='Mortgage', TimeStamp_New_status__c = DateTime.now(), SLA_New__c = 3.00, Hour_Spent_New_Status__c = 1.15);
        insert newlead4;
        Test.startTest();
        	
      
        system.debug('lead inserted'+newlead4);
       
        
       Lead_Update_StatusHrs_Batch obj = new Lead_Update_StatusHrs_Batch();
        DataBase.executeBatch(obj); 
            update newlead4;
       Test.stopTest();
      
   
    }
    /*@isTest
    public static void getTimeDifferencetest() 
    {
        BusinessHours stdBusinessHours = [select id
                                          from businesshours
                                          where isDefault = true];
        
        
        
    }*/


}