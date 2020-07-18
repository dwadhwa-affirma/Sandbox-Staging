public class NA_AutoVehicleController
{
    public NA_AutoVehicleController(){
    
    }

    public string script{get;set;}
    public Account AccountC{get;set;}
    
    public string NA_id {get;set;}
    public string accId2 { get; set; }

    public NeedAssessmentController parentController {get;set;}

    
    //public Needs_Assesment__c ExpiredValue {get;set;}

    Needs_Assesment__c  lnao_New;
    
     public Needs_Assesment__c  getlnao_New(){
         
     
           setObjects();
     
        
        return lnao_New;
    }
    
    
   
    public void setlnao_New(Needs_Assesment__c  val){
        lnao_New = val;
    }
    

    public void setObjects(){
        
        
        
        //IsExpired = false;    
        accId2 = AccountC.Id;
       
        list<Needs_Assesment__c> naother = [select id,LEAV_AnticipateFinance__c,    
                                            LEAV_ContactPreferences__c,
                                            LEAV_Current__c,
                                            LEAV_CurrentBalance__c,
                                            LEAV_CurrentLoanProvider__c,
                                            LEAV_CurrentRate__c,
                                            LEAV_EndDateLoan__c,
                                            LEAV_PlanDate__c,
                                            LEAV_PlanningToBuy__c,
                                            LEAV_Last_Updated_On__c,
                                            REC_LEAV_1__c 
                                            from Needs_Assesment__c where 
                                            member__c =:accId2 ORDER by LastModifiedDate desc];
        if (naother.size() > 0)
        {
            NA_id = naother[0].Id;
            lnao_New = naother [0];

        }
        else
        {
  
            lnao_New = new Needs_Assesment__c();
            //ExpiredValue = new Needs_Assesment__c();
        }
    }
    
    
    
    
 
    public void SubmitAutoVehicleForm()
    {

     
        //If(lnao_New.LEAV_AnticipateFinance__c != null || lnao_New.LEAV_ContactPreferences__c != null || lnao_New.LEAV_Current__c != null ||     lnao_New.LEAV_CurrentBalance__c != null || lnao_New.LEAV_CurrentLoanProvider__c != null || lnao_New.LEAV_CurrentLoanProvider__c != null || lnao_New.LEAV_CurrentRate__c != null || lnao_New.LEAV_EndDateLoan__c != null || lnao_New.LEAV_PlanDate__c != null || lnao_New.LEAV_PlanningToBuy__c != null || lnao_New.REC_LEAV_1__c != null   )
                
        {
            
                 Needs_Assesment__c  nao_tobeinserted = new Needs_Assesment__c  ();
                                     nao_tobeinserted.Id = lnao_New.Id;
                    
                    nao_tobeinserted.LEAV_AnticipateFinance__c = lnao_New .LEAV_AnticipateFinance__c;
                    nao_tobeinserted.LEAV_ContactPreferences__c = lnao_New.LEAV_ContactPreferences__c;
                    
                    nao_tobeinserted.LEAV_Current__c = lnao_New .LEAV_Current__c;
                    nao_tobeinserted.LEAV_CurrentBalance__c = lnao_New.LEAV_CurrentBalance__c;
                    nao_tobeinserted.LEAV_CurrentLoanProvider__c = lnao_New.LEAV_CurrentLoanProvider__c;
                    nao_tobeinserted.LEAV_CurrentRate__c = lnao_New.LEAV_CurrentRate__c;
                    nao_tobeinserted.LEAV_EndDateLoan__c = lnao_New.LEAV_EndDateLoan__c;
                    
                    nao_tobeinserted.LEAV_PlanDate__c = lnao_New.LEAV_PlanDate__c;
                    nao_tobeinserted.LEAV_PlanningToBuy__c = lnao_New.LEAV_PlanningToBuy__c;
                    nao_tobeinserted.REC_LEAV_1__c = lnao_New.REC_LEAV_1__c;
                    
                    

                    if(nao_tobeinserted.Id == null)
                    {
                    nao_tobeinserted.Member__c = accId2 ;
                    }
                    nao_tobeinserted.LEAV_Last_Updated_On__c  = system.today();
                   
                        upsert  nao_tobeinserted;
                        
                        script = '1';
            
    
       }
                RefreshParent();
    }
    
   
    
     public void resetscript()
     {
        script = '';
     }
  
     public void RefreshParent(){
             
        
           
           parentController.RefreshAccount();
         


           parentController.GetAutoVehicleTabClass();
     }
    
   }