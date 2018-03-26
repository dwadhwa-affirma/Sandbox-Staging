public class Na_CurrentFeedbackController
{

public string script{get;set;}
    public Account AccountC{get;set;}
    public string NA_id {get;set;}
    
    public string accId2 { get; set; }
    public NeedAssessmentController parentController {get;set;}
      public Needs_Assesment__c  lcf_New;
       
       
        public Needs_Assesment__c  getlcf_New(){
       
           setObjects();
        
        return lcf_New;
    }
    public void setlcf_New(Needs_Assesment__c  val){
        lcf_New = val;
    }
    

    public void setObjects(){
        
        accId2 = parentController.account[0].Id;
        list<Needs_Assesment__c> naother = [select id,LECF_Branch_Feedback__c,LECF_Branch__c,LECF_800__c,LECF_800_Feedback__c,
                    LECF_Online_banking_Feedback__c,LECF_Online_banking__c,LECF_ATM__c,LECF_ATM_Feedback__c,LECF_Mobile_banking__c,
                    LECF_Mobile_banking_Feedback__c ,LECF_Comment__c,LECF_Last_Updated_On__c,
                    Rec_LEOM_1__c,Rec_LEOM_2__c,Rec_LEOM_3__c,LECF_Experience_Improvement_Feedback__c,
                    Rec_LEOM_4__c,Rec_LEOM_5__c,Rec_LEOM_6__c,Rec_LEOM_7__c,
                    Rec_LECF_Outcome_1__c,Rec_LECF_Outcome_2__c,Rec_LECF_Outcome_3__c,Rec_LECF_Outcome_4__c,
                    Rec_LECF_1__c,Rec_LECF_2__c,Rec_LECF_3__c,Rec_LECF_4__c
                    from Needs_Assesment__c
                    where member__c =:accId2 ORDER by LastModifiedDate desc];
        if (naother.size() > 0)
        {
            NA_id = naother[0].Id;
            
            if(AccountC.NA_LEOM_Expired__c)
            {
                 lcf_New = new Needs_Assesment__c();
                 lcf_New .ID = NA_id;
                 

            }
            else
            {
                 lcf_New = naother [0];
            }
        }
        else
        {
  
            lcf_New = new Needs_Assesment__c();
            
        }
    }

 

   public void SubmitFeedbackForm()
    {
        /*If(       lcf_New .LECF_Branch_Feedback__c                != null || 
                  lcf_New .LECF_800__c                            != null || 
                  lcf_New .LECF_800_Feedback__c                   != null || 
                  lcf_New .LECF_Branch__c                         != null ||
                  lcf_New .LECF_Online_banking_Feedback__c        != null || 
                  lcf_New .LECF_Online_banking__c                 != null ||         
                  lcf_New .LECF_ATM__c                            != null ||        
                  lcf_New .LECF_ATM_Feedback__c                   != null ||        
                  lcf_New .LECF_Mobile_banking_Feedback__c        != null ||        
                  lcf_New .LECF_Mobile_banking__c                 != null ||   
                  lcf_New.LECF_Experience_Improvement_Feedback__c != null ||     
                  lcf_New .Rec_LEOM_1__c ||
                  lcf_New .Rec_LEOM_2__c || 
                  lcf_New .Rec_LEOM_3__c || 
                  lcf_New .Rec_LEOM_4__c || 
                  lcf_New .Rec_LEOM_5__c ||
                  lcf_New .Rec_LEOM_6__c || 
                  lcf_New .Rec_LEOM_7__c || 
                  lcf_New.Rec_LECF_1__c  || 
                  lcf_New.Rec_LECF_2__c  || 
                  lcf_New.Rec_LECF_3__c  || 
                  lcf_New.Rec_LECF_4__c        )*/           
        {
        
             system.debug('test2 --- ');
            
                 Needs_Assesment__c  nao_tobeinserted = new Needs_Assesment__c  ();
                    nao_tobeinserted.Id = lcf_New .Id;
                    
                    
                     nao_tobeinserted.LECF_Branch_Feedback__c= lcf_New .LECF_Branch_Feedback__c;
                     nao_tobeinserted.LECF_Branch__c= lcf_New .LECF_Branch__c;
                     nao_tobeinserted.LECF_800__c= lcf_New .LECF_800__c;
                     nao_tobeinserted.LECF_800_Feedback__c= lcf_New .LECF_800_Feedback__c;
                     nao_tobeinserted.LECF_Online_banking_Feedback__c= lcf_New .LECF_Online_banking_Feedback__c;
                     nao_tobeinserted.LECF_Online_banking__c= lcf_New .LECF_Online_banking__c;
                     nao_tobeinserted.LECF_ATM__c= lcf_New .LECF_ATM__c;
                     
                     
                     nao_tobeinserted.LECF_ATM_Feedback__c= lcf_New .LECF_ATM_Feedback__c;
                     nao_tobeinserted.LECF_Mobile_banking__c= lcf_New .LECF_Mobile_banking__c;
                     nao_tobeinserted.LECF_Mobile_banking_Feedback__c= lcf_New .LECF_Mobile_banking_Feedback__c;
                                          nao_tobeinserted.LECF_Experience_Improvement_Feedback__c = lcf_New .LECF_Experience_Improvement_Feedback__c;
                  nao_tobeinserted.LECF_Comment__c = lcf_New.LECF_Comment__c ;
                    nao_tobeinserted.Rec_LEOM_2__c= lcf_New .Rec_LEOM_2__c;
                    nao_tobeinserted.Rec_LEOM_3__c= lcf_New .Rec_LEOM_3__c;
                    nao_tobeinserted.Rec_LEOM_4__c= lcf_New .Rec_LEOM_4__c;
                    nao_tobeinserted.Rec_LEOM_5__c= lcf_New .Rec_LEOM_5__c;
                    nao_tobeinserted.Rec_LEOM_6__c= lcf_New .Rec_LEOM_6__c;
                    nao_tobeinserted.Rec_LEOM_7__c= lcf_New .Rec_LEOM_7__c;
                    nao_tobeinserted.Rec_LECF_1__c = lcf_New.Rec_LECF_1__c;
                    nao_tobeinserted.Rec_LECF_2__c = lcf_New.Rec_LECF_2__c;
                    nao_tobeinserted.Rec_LECF_3__c = lcf_New.Rec_LECF_3__c;
                    nao_tobeinserted.Rec_LECF_4__c = lcf_New.Rec_LECF_4__c;
                    if(nao_tobeinserted.Id == null)
                    {
                    nao_tobeinserted.Member__c = accId2 ;
                    }
                    nao_tobeinserted.LECF_Last_Updated_On__c= system.today();
                     script = '1';
             
                     
                        upsert  nao_tobeinserted;
                        

            
    
       }
                RefreshParent();
    }
    
   
    
     public void resetscript()
     {
        script = '';
     }
  
     public void RefreshParent(){
             
        
           
           parentController.RefreshAccount();
         



           parentController.GetCurrentFeedbackTabClass();
     }

}