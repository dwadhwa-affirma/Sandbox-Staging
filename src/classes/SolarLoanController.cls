public class SolarLoanController {

    @AuraEnabled
    public static  Map<string,string> getMemberData(string SolarLoanRecordId, String CurrentStage){
    
    String SolarCurrentStage;
    system.debug('SolarLoanRecordId'+SolarLoanRecordId);     
    system.debug('CurrentStage'+CurrentStage);
    Map<string,string> strMap = new  Map<string,string>();
    List<Solar_Loans__c> SolarLoanList = [Select id,Current_Solar_Loan_Stage__c from Solar_Loans__c where id =:SolarLoanRecordId limit 1];
	
    if(SolarLoanList.size() > 0){
        SolarLoanList[0].Current_Solar_Loan_Stage__c = CurrentStage; 
        update SolarLoanList;
        SolarCurrentStage = SolarLoanList[0].Current_Solar_Loan_Stage__c;
        
    }
    system.debug('SolarCurrentStage'+SolarCurrentStage);
    strMap.put('SolarCurrentStage',SolarCurrentStage);    
    return strMap;    
    }
}