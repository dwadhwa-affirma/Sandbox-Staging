public class NA_Other_MilestonesController
{
    public NA_Other_MilestonesController(){
    
    }

    public string script{get;set;}
    public Decimal OtherMilestoneDuePeriod {get;set;}
    public Account AccountC{get;set;}
    
    public string NA_id {get;set;}
    public string accId2 { get; set; }

    public NeedAssessmentController parentController {get;set;}

    public boolean IsExpired {get;set;}
    //public Needs_Assesment__c ExpiredValue {get;set;}

    Needs_Assesment__c  lnao_New;
    
     public Needs_Assesment__c  getnao_New(){
         
     
           setObjects();
     
        
        return lnao_New;
    }
    
    
   
    public void setnao_new(Needs_Assesment__c  val){
        lnao_New = val;
    }
    

    public void setObjects(){
        GracePeriod__c data = GracePeriod__c.getValues('NA Other Milestones');
        OtherMilestoneDuePeriod =   data.ExpiresInDays__c;
        
        //IsExpired = false;    
        accId2 = AccountC.Id;
       
        list<Needs_Assesment__c> naother = [select id,LEOM_Last_Updated_On__c ,Home_Improvement__c, Home_Improvement_Timeframe__c, Home_Improvement_Plan__c,College__c, College_Timeframe__c,  College_Plan__c,Medical__c, Medical_Timeframe__c, Medical_Plan__c,Purchase_RV_Boat__c, Purchase_RV_Boat_Timeframe__c, Purchase_RV_Boat_Plan__c, Travel__c, Travel_Timeframe__c,Travel_Plan__c,Life_Events__c,Life_Events_Timeframe__c,Life_Events_Plan__c,Other__c,Other_Timeframe__c,Other_Plan__c,
        Retirement_New__c,Retirement_Timeframe__c,Retirement_Plan__c,
        LEOM_College_Update__c, LEOM_Home_Update__c, LEOM_Life_Events_Update__c, LEOM_Medical_Update__c,
        LEOM_Other_Expenses_Update__c, LEOM_Retirement_Update__c, LEOM_RV_Boat_Update__c, LEOM_Travel_Update__c,Rec_LEEM_2__c,
        Rec_LEOM_1__c,Rec_LEOM_2__c,Rec_LEOM_3__c,Rec_LEOM_4__c,Rec_LEOM_5__c,Rec_LEOM_6__c,Rec_LEOM_7__c,LEOM_PlanUnforeseen__c,LEOM_Comments__c from Needs_Assesment__c where 
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
    
    
    
    
 
    public void SubmitOtherForm()
    {

     
        //If(lnao_New.Home_Improvement__c != null || lnao_New.Home_Improvement_Timeframe__c != null || lnao_New.Home_Improvement_Plan__c != null || lnao_New.College__c != null || lnao_New.College_Timeframe__c != null || lnao_New.College_Plan__c != null || lnao_New.Medical__c != null || lnao_New.Medical_Timeframe__c != null || lnao_New.Medical_Plan__c != null || lnao_New.Purchase_RV_Boat__c != null || lnao_New.Purchase_RV_Boat_Timeframe__c != null || lnao_New.Purchase_RV_Boat_Plan__c != null || lnao_New.Travel__c != null || lnao_New.Travel_Timeframe__c != null || lnao_New.Travel_Plan__c != null || lnao_New.Life_Events__c != null || lnao_New.Life_Events_Timeframe__c != null || lnao_New.Life_Events_Plan__c != null || lnao_New.Other_Timeframe__c != null || lnao_New.Other_Plan__c != null || lnao_New.Rec_LEOM_1__c|| lnao_New.Rec_LEOM_2__c|| lnao_New.Rec_LEOM_3__c|| lnao_New.Rec_LEOM_4__c|| lnao_New.Rec_LEOM_5__c|| lnao_New.Rec_LEOM_6__c|| lnao_New.Rec_LEOM_7__c || lnao_New.Retirement_Plan__c != null || lnao_New.Retirement_Timeframe__c != null || lnao_New.Retirement__c != null || lnao_New.LEOM_Comments__c != null || lnao_New.LEOM_PlanUnforeseen__c != null)               
        {
            
                 Needs_Assesment__c  nao_tobeinserted = new Needs_Assesment__c  ();
                                     nao_tobeinserted.Id = lnao_New.Id;
                    nao_tobeinserted.Home_Improvement__c = lnao_New .Home_Improvement__c;
                    nao_tobeinserted.Home_Improvement_Timeframe__c  = lnao_New .Home_Improvement_Timeframe__c;
                    nao_tobeinserted.Home_Improvement_Plan__c  = lnao_New .Home_Improvement_Plan__c;
                    nao_tobeinserted.College__c  = lnao_New .College__c ;
                    nao_tobeinserted.College_Timeframe__c  = lnao_New .College_Timeframe__c ;
                    nao_tobeinserted.College_Plan__c  = lnao_New .College_Plan__c ;
                    nao_tobeinserted.Medical__c  = lnao_New .Medical__c ;
                    nao_tobeinserted.Medical_Timeframe__c  = lnao_New .Medical_Timeframe__c ;
                    nao_tobeinserted.Medical_Plan__c  = lnao_New .Medical_Plan__c ;
                    nao_tobeinserted.Purchase_RV_Boat__c  = lnao_New .Purchase_RV_Boat__c ;
                    nao_tobeinserted.Purchase_RV_Boat_Timeframe__c  = lnao_New .Purchase_RV_Boat_Timeframe__c ;
                    nao_tobeinserted.Purchase_RV_Boat_Plan__c  = lnao_New .Purchase_RV_Boat_Plan__c ;
                    nao_tobeinserted.Travel__c  = lnao_New .Travel__c ;
                    nao_tobeinserted.Travel_Timeframe__c  = lnao_New .Travel_Timeframe__c ;
            
            
                    nao_tobeinserted.Travel_Plan__c   = lnao_New .Travel_Plan__c  ;
                    nao_tobeinserted.Life_Events__c   = lnao_New .Life_Events__c  ;
                    nao_tobeinserted.Life_Events_Timeframe__c   = lnao_New .Life_Events_Timeframe__c  ;
                    nao_tobeinserted.Life_Events_Plan__c   = lnao_New .Life_Events_Plan__c  ;
                    nao_tobeinserted.Other__c   = lnao_New .Other__c  ;
                    nao_tobeinserted.Other_Timeframe__c   = lnao_New .Other_Timeframe__c  ;
                    nao_tobeinserted.Other_Plan__c   = lnao_New .Other_Plan__c;
                  nao_tobeinserted.Rec_LEOM_1__c= lnao_New .Rec_LEOM_1__c;
                  nao_tobeinserted.Retirement_New__c = lnao_New.Retirement_New__c;
                  
                  nao_tobeinserted.Retirement_Timeframe__c = lnao_New.Retirement_Timeframe__c;
                  nao_tobeinserted.Retirement_Plan__c = lnao_New.Retirement_Plan__c;
                  nao_tobeinserted.Rec_LEEM_2__c = lnao_New.Rec_LEEM_2__c;
                    nao_tobeinserted.Rec_LEOM_2__c= lnao_New .Rec_LEOM_2__c;
                    nao_tobeinserted.Rec_LEOM_3__c= lnao_New .Rec_LEOM_3__c;
                    nao_tobeinserted.Rec_LEOM_4__c= lnao_New .Rec_LEOM_4__c;
                    nao_tobeinserted.Rec_LEOM_5__c= lnao_New .Rec_LEOM_5__c;
                    nao_tobeinserted.Rec_LEOM_6__c= lnao_New .Rec_LEOM_6__c;
                    nao_tobeinserted.Rec_LEOM_7__c= lnao_New .Rec_LEOM_7__c;
                    nao_tobeinserted.LEOM_PlanUnforeseen__c = lnao_New.LEOM_PlanUnforeseen__c;
                    nao_tobeinserted.LEOM_Comments__c = lnao_New.LEOM_Comments__c;
                    if(nao_tobeinserted.Id == null)
                    {
                    nao_tobeinserted.Member__c = accId2 ;
                    }
                    nao_tobeinserted.LEOM_Last_Updated_On__c = system.today();
                   
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
         


           parentController.GetOtherTabClass();
     }
    
   }