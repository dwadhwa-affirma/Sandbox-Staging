@isTest
public class CustomEditOnLeadControllerTest {
public static testmethod void testmethod1(){
       // Account acc = [Select Id from Account Where isPersonAccount = True Limit 1];
      /*  Account acc = new Account();
               acc.LastName = 'Test Last Name';
               acc.FirstName = 'Test First Name';
               acc.SSN_Last_4__pc = '1234';
             insert acc; */
    
      test.startTest();
		    Group g1 = new Group(Name='Branch 14 - 1600 Smith Queue', type='Queue');
		    insert g1;
		  Episys_User__c eu = new Episys_User__c();
		  eu.Episys_ID__c = 1;
		  eu.Episys_Name__c = 'test';
		  eu.Assigned_Branch__c =14;
		  insert eu;
		            
		    Lead led = new Lead(LastName = 'LastName268', Status = 'New', HasOptedOutOfEmail = false, IsConverted = false, IsUnreadByOwner = false, CreatedDate = DateTime.now(), //CreatedById = acc.id,
		                       LastModifiedDate = DateTime.now(), smagicinteract__SMSOptOut__c = false, Escalated__c = false, Membership_Required_old__c = false, Keep__c = false, 
		                       et4ae5__HasOptedOutOfMobile__c = false, Episys_User_ID__c =1, Product_Type__c ='Cards', Product_Subtype__c ='Credit Cards',Episys_Flag__c = false, temp__c = false, LeadSource='PTM');
		    Insert led; 
    test.stopTest();
    
        PageReference pageRef = Page.CustomEditOnLead;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('ID', led.Id); 
        CustomEditOnLeadController controller = new CustomEditOnLeadController(new ApexPages.StandardController(led));
        controller.updateLead();
    }
    
}