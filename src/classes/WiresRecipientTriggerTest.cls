@isTest
public class WiresRecipientTriggerTest {
	
	 static testMethod void test1(){
	 	WIRES_Recipient__c objWC = new WIRES_Recipient__c();
	 	objWC.Address1__c='Address1';
	 	objWC.Address2__c = 'Address2';
	 	objWC.BankName__c = 'Test';
	 	objWC.Chevron_AccountNumber__c ='0000000123';
	 	objWC.City__c = 'CA';
	 	objWC.AccountLocation__c = 'TestLocation';
	 	objWC.Country__c = 'USA';
	 	//objWC.ExternalID__c = 'CA';
	 	objWC.isActive__c = true;
	 	/*objWC.City__c = 'CA';
	 	objWC.City__c = 'CA';
	 	objWC.City__c = 'CA';*/
	 	insert objWC;
	 	
	 }
    
}