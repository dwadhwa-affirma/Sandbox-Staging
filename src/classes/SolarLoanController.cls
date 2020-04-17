public class SolarLoanController {

    @AuraEnabled
    public static  Map<string,string> getMemberData(string SolarLoanRecordId, String CurrentStage){
    
    String SolarCurrentStage;
    String Stage3LoanCheck;
    String Stage4ACHCheck;
    
    system.debug('SolarLoanRecordId'+SolarLoanRecordId);     
    system.debug('CurrentStage'+CurrentStage);
    Map<string,string> strMap = new  Map<string,string>();
  
	List<Solar_Loans__c> SolarLoanList = [SELECT id,ABA_Bank_Name__c,ACH__c,Additional_Amount__c,Application_Date__c,
    		Bank_Account_Number__c,Bank_Name__c,Battery__c,Brand__c,Change_Order__c,CreatedById,CreatedDate,
        	Credit_Attributes__c,Credit_Exception__c,Debt_Ratio__c,DocuSignId__c,Due_Date__c,
        	ECOA_Code__c,Final_Payment_Amount__c,FNI__c,Go_To_Payment__c,Initial_LT_Loan_Agreement__c,
        	Installer_Number__c,Installer__c,Interest_Rate__c,Inverter__c,IsDeleted,Joint_Address_1__c,
            Joint_Address_2__c,Joint_City__c,Joint_DOB__c,Joint_FICO_Score__c,Joint_First_Name__c,Joint_Last_Name__c,
        	Joint_SSN__c,Joint_State__c,Joint_Zip_Code__c,Latest_LT_Loan_Agreement__c,Legal_Description__c,Loan_Amount__c,Loan_Pmt_Amount__c,
        	Loan_Type__c,Maturity_Date__c,Account_Number__r.name,Membership_Fee__c,Member_Number__c,Module__c,Mortgage_Balance__c,Name,
        	Name__c,Net_Funding_Amount__c,OID_Fee__c,OwnerId,Primary_Address_1__c,Primary_Address_2__c,
        	Primary_City__c,Primary_DOB__c,Primary_FICO_Score__c,Primary_First_Name__c,Primary_Last_Name__c,
        	Primary_SSN__c,Primary_State__c,Primary_Zip_Code__c,Product_Loan_Type__c,Product__c,Record_ID__c,
        	Routing_Number__c,Site_UUID__c,Status__c,Symitar_Called__c,SystemModstamp,System_Size_kW__c,Term_months__c,
        	Valid_ABA__c, Loan_Id__c,Loan_Name_Locator__c,Loan_Tracking_Locator__c,EftLocator__c,
        	Error_EftLocator__c,Error_Loan_Locator__c,Error_Loan_Name_Locator__c,Error_Loan_Tracking_Locator__c,
        	Current_Solar_Loan_Stage__c FROM Solar_Loans__c where id =: SolarLoanRecordId limit 1];
        	
    if(SolarLoanList.size() > 0){
    	
    	if(CurrentStage != null && CurrentStage != ' '){
            SolarLoanList[0].Current_Solar_Loan_Stage__c = CurrentStage; 
            update SolarLoanList;
    	}
    	if(SolarLoanList[0].Loan_Id__c == null || SolarLoanList[0].Loan_Id__c == ''){
    		Stage3LoanCheck = 'True';
    	}
    	//------------------------------------Checking if ACH = False/True------------------------------------------//
    	
	    if(solarLoanList[0].Current_Solar_Loan_Stage__c == 'Stage 4'){
	    	
	    	if((SolarLoanList[0].ACH__c != null || SolarLoanList[0].ACH__c == 'True' || SolarLoanList[0].ACH__c == 'true') && 
	    		(SolarLoanList[0].ACH__c != 'false' || SolarLoanList[0].ACH__c != 'False')){
	    		Stage4ACHCheck = 'True';
	    	}
	    	else{
	    		Stage4ACHCheck = 'False';
	    	}
	    }
	    
    	//------------------------------------Skipping stages upto "Stage 7" if ACH = False------------------------//
    	
    	if(Stage4ACHCheck == 'False'){
    	
    		SolarCurrentStage = 'Stage 7';
    		SolarLoanList[0].Current_Solar_Loan_Stage__c = 'Stage 7'; 
            update SolarLoanList;
    	}
        else
        	SolarCurrentStage = SolarLoanList[0].Current_Solar_Loan_Stage__c;
        
    }
    
    system.debug('SolarCurrentStage'+SolarCurrentStage);
    strMap.put('SolarCurrentStage',SolarCurrentStage);  
    strMap.put('Stage3LoanCheck',Stage3LoanCheck);
    strMap.put('Stage4ACHCheck',Stage4ACHCheck);    
    return strMap;  
      
    }
}