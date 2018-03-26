public class Na_Earn_MoreController
{
public list<NA_Deposit__c> deposits;
public string script{get;set;}

public boolean sizeExceeds {get;set;} 

    public Account AccountC{get;set;}
    public string NA_id {get;set;}
    public integer depositeid { get; set; }
    public string accId2 { get; set; }
    public NeedAssessmentController parentController {get;set;}
      public Needs_Assesment__c  lcf_New;
       
       
        public Needs_Assesment__c  getlcf_New(){
            
       if(lcf_New == null)
       {
        
           setObjects();
       }
       else
       {
       		list<Needs_Assesment__c> naother = [select id,
                    Rec_LEOM_3__c,
                    Rec_LEEM_2__c,
                    Rec_LEEM_1__c
            
                     from Needs_Assesment__c
                    where member__c =:accId2 ORDER by LastModifiedDate desc];
                    
	        if (naother.size() > 0)
	        {
	        	lcf_New.Rec_LEEM_1__c = naother[0].Rec_LEEM_1__c;
	        }     	
       }
        return lcf_New;
    }
    public void setlcf_New(Needs_Assesment__c  val){
        lcf_New = val;
    }
    

    public void setObjects(){
        
        accId2 = parentController.account[0].Id;
        list<Needs_Assesment__c> naother = [select id,LEEM_Health_Savings_Account__c,
                    
                    LEEM_Deductible_Plan__c,
                    
                    LEEM_Comments__c,
                    LEEM_Savings_For_Retirement_O_Account__c,
                    LEEM_Savings_For_Retirement_O_R_Account__c,
                    LEEM_Savings_For_Retirement_IRA__c,
                    LEEM_Savings_For_Retirement_401__c,
                    LEEM_Money_In_Primary_Account__c,
                    LEEM_Last_Updated_On__c,
                    Rec_LEOM_3__c,
                    Rec_LEEM_2__c,
                    Rec_LEEM_1__c
            
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
        
         deposits = [select id, Balance__c, Financial_Instituition__c, Needs_Assessment__c, Rate__c, Type__c
                        from NA_Deposit__c where Needs_Assessment__c =: lcf_New.ID];
    }

public list<NA_Deposit__c> Getdeposits()
    {
        
        if (deposits == null)
        {
            deposits = new list<NA_Deposit__c>();
        }


        return deposits;
    }

   public void setdeposits(list<NA_Deposit__c> value)
    {
       
            deposits = value;
       



    }

  public void addDeposit()
    {
        if(deposits.size() == 5)
        {
            sizeExceeds = true;
            return;
        }
        sizeExceeds =false;
        NA_Deposit__c obj = new NA_Deposit__c();
        //obj.Needs_Assessment__c = NA_id;
        deposits.add(obj);

    }
    
    
     public void deletedeposits()
    {
        


        sizeExceeds = false;
        for (integer i = 0; i < deposits.size(); i++)
        {
            if (depositeid == i)
            {

                if (!string.isEmpty(deposits[i].id))
                {
                    delete deposits[i];
                }


                deposits.remove(i);
                
                break;
            }
        }




    }

   public void SubmitEarnMoreForm()
    {
        sizeExceeds = false;
        //If( deposits.size() > 0 || lcf_New.LEEM_Health_Savings_Account__c != null || lcf_New.REC_LEEM_1__c || lcf_New.REC_LEEM_2__c || lcf_New.Rec_LEOM_3__c || lcf_New.LEEM_Deductible_Plan__c != null|| lcf_New.LEEM_Savings_For_Retirement_O_Account__c || lcf_New.LEEM_Savings_For_Retirement_IRA__c || lcf_New.LEEM_Savings_For_Retirement_401__c || lcf_New.LEEM_Money_In_Primary_Account__c != null ) {
        {
            
                    Needs_Assesment__c  nao_tobeinserted = new Needs_Assesment__c  ();
                    nao_tobeinserted.Id = lcf_New .Id;
                    
                    
                     nao_tobeinserted.LEEM_Health_Savings_Account__c= lcf_New .LEEM_Health_Savings_Account__c;
                     
                     nao_tobeinserted.LEEM_Deductible_Plan__c= lcf_New .LEEM_Deductible_Plan__c;
                     
                    nao_tobeinserted.LEEM_Comments__c= lcf_New .LEEM_Comments__c;
                    nao_tobeinserted.LEEM_Savings_For_Retirement_O_Account__c= lcf_New .LEEM_Savings_For_Retirement_O_Account__c;
                    nao_tobeinserted.LEEM_Savings_For_Retirement_O_R_Account__c= lcf_New .LEEM_Savings_For_Retirement_O_R_Account__c;
                    
                    nao_tobeinserted.LEEM_Savings_For_Retirement_IRA__c= lcf_New .LEEM_Savings_For_Retirement_IRA__c;
                    nao_tobeinserted.LEEM_Savings_For_Retirement_401__c= lcf_New .LEEM_Savings_For_Retirement_401__c;
                    nao_tobeinserted.LEEM_Money_In_Primary_Account__c= lcf_New .LEEM_Money_In_Primary_Account__c;
                                          
                    nao_tobeinserted.REC_LEEM_1__c = lcf_New.REC_LEEM_1__c;
                    nao_tobeinserted.REC_LEEM_2__c = lcf_New.REC_LEEM_2__c;
                    nao_tobeinserted.Rec_LEOM_3__c = lcf_New.Rec_LEOM_3__c;
                     
                    if(nao_tobeinserted.Id == null)
                    {
                    nao_tobeinserted.Member__c = accId2 ;
                    }
                    nao_tobeinserted.LEEM_Last_Updated_On__c= system.today();
                    lcf_New.LEEM_Last_Updated_On__c =nao_tobeinserted.LEEM_Last_Updated_On__c;
                    
                        script = '1';
                     
                        upsert  nao_tobeinserted;
                      lcf_New.id = nao_tobeinserted.Id;
                         for (integer i = 0; i < deposits.size(); i++)
                        {
                            if(deposits[i].Needs_Assessment__c  == null)
                            {
                                
                            deposits[i].Needs_Assessment__c = nao_tobeinserted.id;
                            }
                        }

                 upsert deposits;
    
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