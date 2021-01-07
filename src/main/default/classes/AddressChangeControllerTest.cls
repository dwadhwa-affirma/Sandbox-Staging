@isTest 
public class AddressChangeControllerTest {
    static testMethod void GetAllData(){
        AddressChangeConfigurations__c cs = new AddressChangeConfigurations__c();	 	
		cs.SendEmail__c = false;	
		cs.Name = 'Primary'; 
		cs.SendSMS__c = true;	
        cs.FlowURL__c='https://flow.boomi.com/205f8437-a72f-4b9a-9dbd-f9df4a2346b3/play/ChangeRequestPlayer?flow-id=32853ba9-fabc-4943-99f7-344c8e187b0d';
        insert cs;
        
        Account acc = new Account();
		    	//acc.RecordTypeID=rtId;
		    	acc.FirstName='Test FName';
		        acc.LastName='Test LName';    
		        acc.Mobile_Phone__pc='309-310-1173'; 
		        acc.Email_raw__c='dbhavsar@affirma.com'; 	
        insert acc;
        
        AddressChangeController.GetAllData(acc.Id);
    }
}