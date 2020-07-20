public class Na_HousingController
{
    public Na_HousingController(){
    
    }
    public string script{get;set;}
    public Account AccountC{get;set;}
    public string NA_id {get;set;}
        
    public string accId2 { get; set; }
    public NeedAssessmentController parentController {get;set;}
    
    

    Needs_Assesment__c  lnah_New;
    
    public Needs_Assesment__c  getnah_New(){
      
           setObjects();
      
        return lnah_New;
    }
    public void setnah_new(Needs_Assesment__c  val){
        lnah_New = val;
    }
    
       
     public List<SelectOption> getdynamiclist() {
        List<SelectOption> options = new List<SelectOption>();
        
        options.add(new SelectOption('0','--None--'));
        for (Integer i = System.Today().year() + 1; i < System.Today().year() + 31; i++) 
        {
          options.add(new SelectOption(string.valueof(i),string.valueof(i)));
    }

        return options;
    }
    
    
    public void setObjects(){
        
        accId2 = parentController.account[0].Id;
        list<Needs_Assesment__c> naother = [select id,LEHS_Last_Updated_On__c  ,LEHS_Type_of_Mortgage__c  ,Do_you_Rent_or_Own__c,LEHS_Current_Lender__c,LEHS_End_Year__c,
                    LEHS_Rate__c,LEHS_Comment__c,LEHS_Current_Balance__c,LEHS_Planning_to_Purchase__c,LEHS_Purchase_When__c,
                    LEHS_Have_Realtor__c,Rec_LEOM_1__c,Rec_LEOM_2__c,Rec_LEOM_3__c,Rec_LEOM_4__c,Rec_LEOM_5__c,
                    Rec_LEOM_6__c,Rec_LEOM_7__c,Rec_LEHS_1__c,Rec_LEHS_2__c from Needs_Assesment__c where member__c =:accId2 ORDER by LastModifiedDate desc];
        if (naother.size() > 0)
        {
            NA_id = naother[0].Id;
            
            if(AccountC.NA_LEOM_Expired__c)
            {
                 lnah_New= new Needs_Assesment__c();
                 lnah_New.ID = NA_id;
                 

            }
            else
            {
                 lnah_New= naother [0];
            }
        }
        else
        {
  
            lnah_New= new Needs_Assesment__c();
            
        }
        if(lnah_New.LEHS_End_Year__c == null)
        {
        	lnah_New.LEHS_End_Year__c = 0;
        }
    }
    
    
      
    public void SubmitHousingForm()
    {

     
        //If(lnah_New.Do_you_Rent_or_Own__c != null || lnah_New.LEHS_Current_Lender__c != null || lnah_New.LEHS_Rate__c!= null || lnah_New.LEHS_Current_Balance__c != null || lnah_New.LEHS_End_Date__c != null || lnah_New.LEHS_Planning_to_Purchase__c != null || lnah_New.LEHS_Purchase_When__c != null || lnah_New.LEHS_Have_Realtor__c!= null || lnah_New.Rec_LEOM_1__c|| lnah_New.Rec_LEOM_2__c|| lnah_New.Rec_LEOM_3__c|| lnah_New.Rec_LEOM_4__c|| lnah_New.Rec_LEOM_5__c|| lnah_New.Rec_LEOM_6__c|| lnah_New.Rec_LEOM_7__c || lnah_New.Rec_LEHS_1__c || lnah_New.Rec_LEHS_2__c)
                
        {
            
                 Needs_Assesment__c  nah_tobeinserted = new Needs_Assesment__c  ();
                 nah_tobeinserted .Id = lnah_New.Id;
                    nah_tobeinserted .Do_you_Rent_or_Own__c = lnah_New.Do_you_Rent_or_Own__c ;
                    nah_tobeinserted .LEHS_Current_Lender__c = lnah_New.LEHS_Current_Lender__c ;
                    nah_tobeinserted .LEHS_Rate__c= lnah_New.LEHS_Rate__c;
                    nah_tobeinserted .LEHS_Current_Balance__c = lnah_New.LEHS_Current_Balance__c ;
                    //nah_tobeinserted .LEHS_End_Date__c = lnah_New.LEHS_End_Date__c ;
                    nah_tobeinserted .LEHS_Planning_to_Purchase__c = lnah_New.LEHS_Planning_to_Purchase__c ;
                    nah_tobeinserted .LEHS_Purchase_When__c = lnah_New.LEHS_Purchase_When__c ;
                    


                    nah_tobeinserted .LEHS_Have_Realtor__c= lnah_New.LEHS_Have_Realtor__c;
                    
                    nah_tobeinserted .Rec_LEOM_1__c= lnah_New.Rec_LEOM_1__c;
                    nah_tobeinserted .Rec_LEOM_2__c= lnah_New.Rec_LEOM_2__c;
                    nah_tobeinserted .Rec_LEOM_3__c= lnah_New.Rec_LEOM_3__c;
                    nah_tobeinserted .Rec_LEOM_4__c= lnah_New.Rec_LEOM_4__c;
                    nah_tobeinserted .Rec_LEOM_5__c= lnah_New.Rec_LEOM_5__c;
                    nah_tobeinserted .Rec_LEOM_6__c= lnah_New.Rec_LEOM_6__c;
                    nah_tobeinserted .Rec_LEOM_7__c= lnah_New.Rec_LEOM_7__c;
                    nah_tobeinserted.Rec_LEHS_1__c = lnah_New.Rec_LEHS_1__c;
                    nah_tobeinserted.Rec_LEHS_2__c = lnah_New.Rec_LEHS_2__c;
                    if(lnah_New.LEHS_End_Year__c == 0)
                    {
                    	
                    nah_tobeinserted .LEHS_End_Year__c = null;
                    }
                    else
                    {
                    	
                    nah_tobeinserted .LEHS_End_Year__c = lnah_New.LEHS_End_Year__c ;	
                    }
                    nah_tobeinserted .LEHS_Type_of_Mortgage__c = lnah_New.LEHS_Type_of_Mortgage__c ;
                    
                    
                    nah_tobeinserted.LEHS_Comment__c = lnah_New.LEHS_Comment__c;
                    if(nah_tobeinserted.Id == null)
                    {
                        nah_tobeinserted.Member__c = accId2 ;
                    }
                    
                    nah_tobeinserted.LEHS_Last_Updated_On__c     = system.today();
                    
                    
                    
                   script = '1';
                    upsert  nah_tobeinserted;
                        
                        
                        
            
    
       }
                RefreshParent();
    }
         public void resetscript()
     {
        script = '';
     }
   
    
    
    
      public void RefreshParent(){
             
        
         
           parentController.RefreshAccount();
         parentController.GetHousingTabClass();
     }
    

}