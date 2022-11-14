public class SolarLoanSigCardController {
    public Solar_loans__c solarLoan;
    private ApexPages.StandardController standardController;
    public boolean validation {get;set;}
    public boolean morethanone {get;set;}
    public boolean signed {get;set;}
    public boolean notready {get;set;}
    
    public SolarLoanSigCardController(ApexPages.StandardController standardController){
        validation = true;
        morethanone = true;
        signed = true;
        notready = true;
        
        // Returns all selected records
        solarLoan = (Solar_Loans__c)standardController.getRecord();
        
        if(solarLoan == null){
            validation = false;
        }else
        {
            List<Solar_Loans__c> SolarLoanToProcess = [select id,name,Name__c,Member_number__c,Current_Solar_Loan_Stage__c,
                                                       Count__c,Signed__c from Solar_loans__c where id=:solarLoan.Id];    
            
            List<SolarLoan_Document__c> sd = [select id,Attachment_Id__c	,name,Solar_Loans__r.id,Solar_Loans__c 
                                              from SolarLoan_Document__c 
                                              where Solar_Loans__r.id in: SolarLoanToProcess and Document_Name__c LIKE '%Membership Application%' 
                                              order by createddate desc LIMIT 1];
            
            System.debug('SolarLoan Doc: '+sd.size());
            system.debug(SolarLoanToProcess[0].Signed__c);
            
            system.debug('Number: '+SolarLoanToProcess[0].Member_number__c);
            system.debug('Name: '+SolarLoanToProcess[0].Name__c);
            system.debug('Docs: '+SolarLoanToProcess[0].Count__c);
            system.debug('Stage: '+SolarLoanToProcess[0].Current_Solar_Loan_Stage__c);
            System.debug('SolarLoanToProcess[0].Member_number__c:'+SolarLoanToProcess[0].Member_number__c);
            System.debug('SolarLoanToProcess[0].Name__c:'+SolarLoanToProcess[0].Name__c );
            System.debug('SolarLoanToProcess[0].Count__c:'+SolarLoanToProcess[0].Count__c);
            
            if(SolarLoanToProcess[0].Signed__c == true){
                validation = true;
                morethanone = true;
                signed = false;    
            }
            else if(sd.size() == 0 || SolarLoanToProcess[0].Member_number__c == null || SolarLoanToProcess[0].Name__c == null || 
                    SolarLoanToProcess[0].Count__c == '0' || 
                    (SolarLoanToProcess[0].Current_Solar_Loan_Stage__c != 'Stage 2.5')){  
                        System.debug('In second else if');
                        validation = true;
                        morethanone = true;
                        signed = true;
                        notready = false;       
                    }
            else{
                validation = true;
                morethanone = true;
                signed = true;
                notready = true;
            }            
        }
        
        this.standardController = standardController;
        system.debug('tttt'+solarLoan);
        system.debug('validation'+validation);
        system.debug('morethanone'+morethanone);
        system.debug('notready'+notready);
        
    }
    
    public PageReference ExecuteSignatureMethod(){
        SolarLoanToSignCardHelper.SetCustomFieldFalse();
        solarLoan = (Solar_Loans__c)standardController.getRecord();
        Set<Id> ids = new set<Id>();
        ids.add(solarLoan.id);
        System.debug('ids: '+ids);
        return SolarLoanToSignCardHelper.ExecuteSignatureMethod(ids);      
    }
}