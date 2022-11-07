@IsTest
public with sharing class CreateLocationControllerTest {
    @testSetup
    static void setupTestData(){
        
		string strrecord = [SELECT Id,Name FROM RecordType 
                                   WHERE sObjectType='Account' and Name='SubAccount'].id;

        Account acc1 = new Account(Email_raw__c = 'test@test.com', Name='MARIA BANDA', PersonHasOptedOutOfEmail = false,
                                NA_Eligibility__c = false, NA_LEAV_Complete__c = true, NA_LECF_Complete__c = true, NA_LECP_Complete__c = false, NA_LEEM_Complete__c = true,
                                NA_LEHS_Complete__c = true, NA_LEMD_Complete__c = false, NA_LEMP_Complete__c = false, NA_LEMQ_Complete__c = true, NA_LEOL_Complete__c = true, 
                                NA_LEOM_Complete__c = true, NA_LEPT_Complete__c = true,RecordTypeID=strrecord,
       							NA_LESB_Complete__c = false, NA_LESF_Complete__c = true, NA_LEWS_Complete__c = true, NA_Opt_Out__c = false, Location_Name__c='test location1');
       	insert acc1;
        Account acc2 = new Account(Name='NARIA BANDA',Email_raw__c = 'test1@test.com', PersonHasOptedOutOfEmail = false,
                                   NA_Eligibility__c = false, NA_LEAV_Complete__c = true, NA_LECF_Complete__c = true, NA_LECP_Complete__c = false, NA_LEEM_Complete__c = true,
                                   NA_LEHS_Complete__c = true, NA_LEMD_Complete__c = false, NA_LEMP_Complete__c = false, NA_LEMQ_Complete__c = true, NA_LEOL_Complete__c = true,
                                   NA_LEOM_Complete__c = true, NA_LEPT_Complete__c = true,RecordTypeID=strrecord,
        NA_LESB_Complete__c = false, NA_LESF_Complete__c = true, NA_LEWS_Complete__c = true, NA_Opt_Out__c = false, Location_Name__c='test location');
       
        insert acc2;       
        
    }
 
    @IsTest
    static void testFetchData(){
        Account acc1 = [Select id, Name, FirstName,LastName,Email_raw__c, PersonEmail, Location_Name__c from Account where Name= 'MARIA BANDA' Limit 1 ];       
        Map<string, object> accMap = CreateLocationController.FetchData(acc1.id);
        system.assertEquals(acc1.Name , 'MARIA BANDA','' );
    }
  
    @IsTest
    static void testLocationInsertUpdate(){
        
        Account acc1 = [Select id,parentid, Name, Email_raw__c, PersonEmail, Location_Name__c from Account where Name='MARIA BANDA' Limit 1 ];
        Account acc2 = [Select id,parentid, Name, Email_raw__c, PersonEmail, Location_Name__c from Account where Name= 'NARIA BANDA' Limit 1 ];
        string accid = CreateLocationController.LocationInsertUpdate(acc2.parentid,acc1);
        system.assertEquals(acc2.Name , 'NARIA BANDA','' );
    }
}