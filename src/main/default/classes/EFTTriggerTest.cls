@isTest
public class EFTTriggerTest {
    static testMethod void test1(){
        EFT__c objEFT= new EFT__c();
        objEFT.Stage__c =  'Status';
            objEFT.Share_Loan_Id__c =  '5103';
            objEFT.Share_Loan_Type__c =  'USED AUTO';
            objEFT.Share_Loan_Description__c =  '2014 CADILLAC ATS';
            objEFT.EFT_ID_Type__c =  'Loan';
            objEFT.Routing_Number__c =  '122105155';
            objEFT.Bank_Name__c =  'US BANK NA';
            objEFT.Account_Number__c =  'a0Oj0000009UeyVEAS';
            objEFT.Type__c  =  'Checking';
            objEFT.Alternate_Amount__c  =  20.0;
            objEFT.Payment_Amount__c  =  200.0;
            objEFT.Frequency__c  =  'Monthly';
            objEFT.Effective_Date__c  =  Date.newInstance(2020, 12, 06);
            objEFT.Day_of_Month__c  =  '6';
            objEFT.Action_Type__c  =  'Create';
            //objEFT.Update_DocuSignId__c  =  '';
            //objEFT.Update_Docusign_Status__c  =  '';
      		
        	insert objEFT;
        	
        	objEFT.Day_of_Month__c = '7' ;
        	objEFT.Status__c = 'Completed';
        	update objEFT;
        
        	//objEFT.Day_of_Month__c = '7' ;
        	//objEFT.Update_Docusign_Status__c = 'Completed';
        	//update objEFT;
        
        	//objEFT.Expired__c = true;
        	//update objEFT;
        	
        
    }
	
}