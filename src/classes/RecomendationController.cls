public class RecomendationController
{
  public Account act; 
  public string accId2 { get; set; } 
    
    Needs_Assesment__c lnao;
  
    public Account AccountC {get;set;}
    
    public List<NA_Other_Existing_Loans__c> otherExistingLoans {get;set;}
    
    public List<NA_Membership_Referral_Questions__c> otherMembers {get;set;}
        
     public List<NA_Deposit__c> otherDeposits {get {
      system.debug('otherDeposits---');
          List<NA_Deposit__c>  list1  = [select Id,Type__C,Financial_Instituition__c,Balance__c,Rate__c 
          from NA_Deposit__c where Needs_Assessment__c =: lnao.Id];
          
          
          
          return list1;
  } set;}
        
    
    public Needs_Assesment__c  getnao(){
          //Member__c is not in prod 
          list<Needs_Assesment__c> naother = [select Id,Member__c,Rec_LEOM_1__c,Rec_LEOM_2__c,Rec_LEOM_3__c,Rec_LEOM_4__c,Rec_LEOM_5__c,Rec_LEOM_6__c,Rec_LEOM_7__c,Rec_LEOM_Outcome_1__c,Rec_LEOM_Outcome_2__c,Rec_LEOM_Outcome_3__c,Rec_LEOM_Outcome_4__c,Rec_LEOM_Outcome_5__c,Rec_LEOM_Outcome_6__c,Rec_LEOM_Outcome_7__c,Rec_LEOL_1__c,Rec_LEOL_Outcome_1__c,REC_LEAV_Outcome_1__c,REC_LEAV_1__c,Rec_LEHS_1_Outcome__c,Rec_LEHS_1__c,Rec_LEHS_Outcome_2__c,Rec_LEHS_2__c,Rec_LECF_Outcome_1__c,Rec_LECF_Outcome_2__c,Rec_LECF_Outcome_3__c,Rec_LECF_Outcome_4__c,Rec_LECF_1__c,Rec_LECF_2__c,Rec_LECF_3__c,Rec_LECF_4__c,REC_LEMP_Outcome_1__c,Rec_LEMP_1__c,REC_LEMP_Outcome_2__c,Rec_LEMP_2__c,REC_LEMP_Outcome_3__c,Rec_LEMP_3__c,REC_LEMP_Outcome_4__c, Rec_LEMP_4__c,REC_LEMP_Outcome_5__c,Rec_LEMP_5__c,REC_LEMP_Outcome_6__c,Rec_LEMP_6__c,REC_LEMP_Outcome_7__c, Rec_LEMP_7__c,REC_LEMP_Outcome_8__c,Rec_LEMP_8__c,REC_LEPT_Outcome_1__c,Rec_LEPT_1__c,REC_LEMD_Outcome_3__c,REC_LEMD_2__c,REC_LEMD_Outcome_2__c,REC_LEMD_1__c,REC_LEMD_Outcome_1__c,LESB_Aware_SharedBranching__c,LESB_Aware_ConvBranching__c,LESB_SharedBranching_Comments__c,REC_LEMD_3__c,Do_you_Rent_or_Own__c,LEHS_Current_Lender__c,LEHS_Rate__c,LEHS_Current_Balance__c,LEHS_End_Year__c,LEHS_Type_of_Mortgage__c,LEHS_Planning_to_Purchase__c,LEHS_Purchase_When__c,LEHS_Have_Realtor__c,LEHS_Comment__c,LECF_Comment__c,LECF_Experience_Improvement_Feedback__c,LECF_Branch__c,LECF_800__c ,LECF_Online_banking__c,LECF_Mobile_banking__c,LECF_ATM__c,LEMD_CFCU_Spectrum__c,LEMD_At_another_financial_institution__c,LEMD_No__c,LEMD_CommentsForDD__c,LEMD_In_person_branch__c,LEMD_ATM__c,LEMD_Online__c,LEMD_Mobile__c,LEMD_CommentsDC__c,LEWS_CFCU_ATM__c,LEWS_Shared_ATM__c,LEWS_Other_ATM__c,LEWS_InPerson__c,LEWS_Comment__c,LEMP_Payment_Transfer_Comments__c,LEMP_Transfer_Comments__c,LEMP_International_Transfer_Comments__c,LEMP_Debit_Card_Usage_Comments__c,LEMP_Credit_Card_Usage_Reason_Comments__c,LEMP_Credit_Card_You_Use_Often__c,LEMP_Carry_Credit_Card_Balance__c,LEMP_Credit_Card_Usage_Comments__c,LEMP_Pay_Individuals_ACH__c,LEMP_Pay_Recurring_ACH__c,LEMP_Pay_MoveMoney_ACH__c,Rec_LEOL_2__c,Rec_LEOL_Outcome_2__c,
LESF_Aware_ATM_Netword__c,LESF_ATM_Location__c,LESF_Comments__c,LEAV_Current__c,LEAV_CurrentLoanProvider__c,LEAV_CurrentRate__c,LEAV_CurrentBalance__c,LEAV_EndDateLoan__c,LEAV_PlanningToBuy__c,LEAV_PlanDate__c,LEAV_AnticipateFinance__c,LEPT_Convenient_locations__c,LEPT_Deposit_rates__c,LEPT_Loan_rates__c,LEPT_Online_mobile_apps__c,LEPT_Have_financial_advisor_there__c,LEPT_Other__c,LEPT_Comments__c,LEPT_Financial_Institution__c,LEAV_ContactPreferences__c,Home_Improvement__c,Home_Improvement_Timeframe__c,Home_Improvement_Plan__c,Other__c,Other_Timeframe__c,Other_Plan__c,LEMP_Pay_Individuals_DC__c,LEOM_PlanUnforeseen__c,Rec_LEEM_1__C,Rec_LEEM_2__c,Rec_LEEM_Outcome_2__c,Rec_LEEM_Outcome_1__c,LEEM_Savings_For_Retirement_401__c,LEEM_Savings_For_Retirement_IRA__c,LEEM_Savings_For_Retirement_O_R_Account__c,LEEM_Savings_For_Retirement_O_Account__c,LEEM_Health_Savings_Account__c,LEEM_Deductible_Plan__c,Travel__c,LEEM_Comments__c,Rec_Comment__c,LEMD_CFCU_Spectrum_YesNo__c,LEMD_At_another_financial_insti_YesNo__c,LESF_ATM_Location_YesNo__c,LESF_Aware_ATM_Network_YesNo__c,Travel_Timeframe__c,Travel_Plan__c,Life_Events__c,Life_Events_Timeframe__c,Life_Events_Plan__c,Purchase_RV_Boat__c,Purchase_RV_Boat_Timeframe__c,Purchase_RV_Boat_Plan__c,Retirement_New__c,Retirement_Timeframe__c,Retirement_Plan__c,Medical__c,Medical_Timeframe__c,Medical_Plan__c,College__c,LEMP_Pay_Recurring_Check__c,LEMP_Pay_Recurring_BillPay__c,LEMP_Pay_Recurring_DC__c,LEMP_Pay_Recurring_CC__c,LEMP_Pay_Recurring_A2A__c,LEMP_Pay_Recurring_Other__c,LEMP_Pay_Individuals_Check__c,LEMP_Pay_Individuals_BillPay__c,LEMP_Pay_Individuals_CC__c,LEMP_Pay_Individuals_A2A__c,LEMP_Pay_Individuals_Other__c,LEMP_Pay_MoveMoney_Check__c,LEMP_Pay_MoveMoney_BillPay__c,LEMP_Pay_MoveMoney_DC__c,LEMP_Pay_MoveMoney_CC__c,LEMP_Pay_MoveMoney_A2A__c,LEMP_Pay_MoveMoney_Other__c,LEMP_Transfer_Frequency__c,LEMP_International_Transfer_Frequency__c,LEEM_Money_In_Primary_Account__c,LEMP_Debit_Card_Usage_Retail__c,LEMP_Debit_Card_Usage_Grocries__c,LEMP_Debit_Card_Usage_Gasstation__c,LEMP_Debit_Card_Usage_Online__c,LEMP_Debit_Card_Usage_Other__c,LEMP_Credit_Card_Usage_No_Annual_Fee__c,LEMP_Credit_Card_Usage_Rewards__c,LEMP_Credit_Card_Usage_Cash_Back__c,LEMP_Credit_Card_Usage_Low_Interest_Rate__c,LEMP_Credit_Card_Usage_Other__c,LEOL_Other_Existing_Loans__c ,College_Timeframe__c,Rec_LEMQ_1__c,REC_LEMQ_Outcome_1__c from Needs_Assesment__c where member__c =:AccountC.id  ORDER by LastModifiedDate desc limit 1];
          if(naother.size() == 0)
          {
              otherExistingLoans = new List<NA_Other_Existing_Loans__c>();
              lnao = new Needs_Assesment__c();
              lnao.Rec_LEOM_1__c = false;
              lnao.Rec_LEOM_2__c = false;
              lnao.Rec_LEOM_3__c = false;
              lnao.Rec_LEOM_4__c = false;
              lnao.Rec_LEOM_5__c = false;
              lnao.Rec_LEOM_6__c = false;
              lnao.Rec_LEOM_7__c = false;
              lnao.Rec_LEOL_1__c = false;
              lnao.Rec_LEOL_2__c = false;
              lnao.Rec_LEAV_1__c = false;
              lnao.Rec_LEHS_2__c = false;
              
              lnao.Rec_LEHS_1__c = false;
              lnao.Rec_LECF_1__c = false;
              lnao.Rec_LECF_2__c = false;
              lnao.Rec_LECF_3__c = false;
              lnao.Rec_LECF_4__c = false;
              
              
              
              
              lnao.Rec_LEMP_1__c = false;
              lnao.Rec_LEMP_2__c = false;
              lnao.Rec_LEMP_3__c = false;
              lnao.Rec_LEMP_4__c = false;
              lnao.Rec_LEMP_5__c = false;
              lnao.Rec_LEMP_6__c = false;
              lnao.Rec_LEMP_7__c = false;
              lnao.Rec_LEMP_8__c = false;
              lnao.Rec_LEPT_1__c = false;
              
              lnao.Rec_LEOM_Outcome_1__c = 'Not Presented';
              lnao.Rec_LEOM_Outcome_2__c = 'Not Presented';
              lnao.Rec_LEOM_Outcome_3__c = 'Not Presented';
              lnao.Rec_LEOM_Outcome_4__c = 'Not Presented';
              lnao.Rec_LEOM_Outcome_5__c = 'Not Presented';
              lnao.Rec_LEOM_Outcome_6__c = 'Not Presented';
              
              lnao.Rec_LEOM_Outcome_7__c = 'Not Presented';
              lnao.Rec_LEOL_Outcome_1__c = 'Not Presented';
              lnao.REC_LEAV_Outcome_1__c = 'Not Presented';
              lnao.Rec_LEHS_Outcome_2__c = 'Not Presented';
              lnao.Rec_LEHS_1_Outcome__c = 'Not Presented';
              
              lnao.REC_LECF_Outcome_1__c= 'Not Presented';
              lnao.REC_LECF_Outcome_2__c= 'Not Presented';
              lnao.REC_LECF_Outcome_3__c= 'Not Presented';
              lnao.REC_LECF_Outcome_4__c= 'Not Presented';
              
        lnao.REC_LEMP_Outcome_1__c = 'Not Presented';
        lnao.REC_LEMP_Outcome_2__c = 'Not Presented';
        lnao.REC_LEMP_Outcome_3__c = 'Not Presented';
        lnao.REC_LEMP_Outcome_4__c = 'Not Presented';
        lnao.REC_LEMP_Outcome_5__c = 'Not Presented';
        lnao.REC_LEMP_Outcome_6__c = 'Not Presented';
        lnao.REC_LEMP_Outcome_7__c = 'Not Presented';
        lnao.REC_LEMP_Outcome_8__c = 'Not Presented';
        lnao.REC_LEPT_Outcome_1__c = 'Not Presented';
          }
          else
          {
              lnao  = naother[0];
              
               if(lnao.Rec_LEOM_Outcome_1__c == null || lnao.Rec_LEOM_Outcome_1__c == '')
          {
          lnao.Rec_LEOM_Outcome_1__c= 'Not Presented';
          }
          if(lnao.Rec_LEEM_Outcome_2__c == null || lnao.Rec_LEEM_Outcome_2__c == '')
          {
          lnao.Rec_LEEM_Outcome_2__c= 'Not Presented';
          }
          
          if(lnao.REC_LEMD_Outcome_2__c == null || lnao.REC_LEMD_Outcome_2__c == '')
          {
          lnao.REC_LEMD_Outcome_2__c= 'Not Presented';
          }
          if(lnao.REC_LEMD_Outcome_1__c == null || lnao.REC_LEMD_Outcome_1__c == '')
          {
          lnao.REC_LEMD_Outcome_1__c= 'Not Presented';
          }
          if(lnao.Rec_LEEM_Outcome_1__c== null || lnao.Rec_LEEM_Outcome_1__c == '')
          {
          lnao.Rec_LEEM_Outcome_1__c= 'Not Presented';
          }
          
          
          
          if(lnao.Rec_LEOM_Outcome_2__c == null || lnao.Rec_LEOM_Outcome_2__c == '')
          {
          lnao.Rec_LEOM_Outcome_2__c= 'Not Presented';
          }
          if(lnao.Rec_LEOM_Outcome_3__c == null || lnao.Rec_LEOM_Outcome_3__c == '')
          {
          lnao.Rec_LEOM_Outcome_3__c= 'Not Presented';
          }
          if(lnao.Rec_LEOM_Outcome_4__c == null || lnao.Rec_LEOM_Outcome_4__c == '')
          {
          lnao.Rec_LEOM_Outcome_4__c= 'Not Presented';
          }
          if(lnao.Rec_LEOM_Outcome_5__c == null || lnao.Rec_LEOM_Outcome_5__c == '')
          {
          lnao.Rec_LEOM_Outcome_5__c= 'Not Presented';
          }
          if(lnao.Rec_LEOM_Outcome_6__c == null || lnao.Rec_LEOM_Outcome_6__c == '')
          {
          lnao.Rec_LEOM_Outcome_6__c= 'Not Presented';
          }
          if(lnao.Rec_LEOM_Outcome_7__c  == null || lnao.Rec_LEOM_Outcome_7__c  == '')
          {
          lnao.Rec_LEOM_Outcome_7__c = 'Not Presented';
          }
          if(lnao.Rec_LEOL_Outcome_1__c == null || lnao.Rec_LEOL_Outcome_1__c == '')
          {
          lnao.Rec_LEOL_Outcome_1__c= 'Not Presented';
          }
          if(lnao.Rec_LEOL_Outcome_2__c == null || lnao.Rec_LEOL_Outcome_2__c == '')
          {
          lnao.Rec_LEOL_Outcome_2__c= 'Not Presented';
          }
          if(lnao.REC_LEAV_Outcome_1__c == null || lnao.REC_LEAV_Outcome_1__c == '')
          {
          lnao.REC_LEAV_Outcome_1__c= 'Not Presented';
          }
          
          

          if(lnao.Rec_LEHS_1_Outcome__c == null || lnao.Rec_LEHS_1_Outcome__c == '')
          {
          lnao.Rec_LEHS_1_Outcome__c= 'Not Presented';
          }
          if(lnao.Rec_LEHS_Outcome_2__c == null || lnao.Rec_LEHS_Outcome_2__c == '')
          {
          lnao.Rec_LEHS_Outcome_2__c= 'Not Presented';
          }
          if(lnao.Rec_LECF_Outcome_1__c == null || lnao.Rec_LECF_Outcome_1__c == '')
          {
          lnao.Rec_LECF_Outcome_1__c= 'Not Presented';
          }
          if(lnao.Rec_LECF_Outcome_2__c == null || lnao.Rec_LECF_Outcome_2__c == '')
          {
          lnao.Rec_LECF_Outcome_2__c= 'Not Presented';
          }
          if(lnao.Rec_LECF_Outcome_3__c == null || lnao.Rec_LECF_Outcome_3__c == '')
          {
          lnao.Rec_LECF_Outcome_3__c= 'Not Presented';
          }
          if(lnao.Rec_LECF_Outcome_4__c == null || lnao.Rec_LECF_Outcome_4__c == '')
          {
          lnao.Rec_LECF_Outcome_4__c= 'Not Presented';
          }
          if(lnao.REC_LEMP_Outcome_1__c == null || lnao.REC_LEMP_Outcome_1__c == '')
          {
          lnao.REC_LEMP_Outcome_1__c= 'Not Presented';
          }
          if(lnao.REC_LEMP_Outcome_2__c == null || lnao.REC_LEMP_Outcome_2__c == '')
          {
          lnao.REC_LEMP_Outcome_2__c= 'Not Presented';
          }
          if(lnao.REC_LEMP_Outcome_3__c == null || lnao.REC_LEMP_Outcome_3__c == '')
          {
          lnao.REC_LEMP_Outcome_3__c= 'Not Presented';
          }
          if(lnao.REC_LEMP_Outcome_4__c == null || lnao.REC_LEMP_Outcome_4__c == '')
          {
          lnao.REC_LEMP_Outcome_4__c= 'Not Presented';
          }
          if(lnao.REC_LEMP_Outcome_5__c == null || lnao.REC_LEMP_Outcome_5__c == '')
          {
          lnao.REC_LEMP_Outcome_5__c= 'Not Presented';
          }
          if(lnao.REC_LEMP_Outcome_6__c == null || lnao.REC_LEMP_Outcome_6__c == '')
          {
          lnao.REC_LEMP_Outcome_6__c= 'Not Presented';
          }
          if(lnao.REC_LEMP_Outcome_7__c == null || lnao.REC_LEMP_Outcome_7__c == '')
          {
          lnao.REC_LEMP_Outcome_7__c= 'Not Presented';
          }
          if(lnao.REC_LEMP_Outcome_8__c == null || lnao.REC_LEMP_Outcome_8__c == '')
          {
          lnao.REC_LEMP_Outcome_8__c= 'Not Presented';
          }
          if(lnao.REC_LEPT_Outcome_1__c == null || lnao.REC_LEPT_Outcome_1__c == '')
          {
          lnao.REC_LEPT_Outcome_1__c= 'Not Presented';
          }
          if(lnao.REC_LEMD_Outcome_3__c == null || lnao.REC_LEMD_Outcome_3__c == '')
          {
          lnao.REC_LEMD_Outcome_3__c= 'Not Presented';
          }
          if(lnao.REC_LEMQ_Outcome_1__c == null || lnao.REC_LEMQ_Outcome_1__c == '')
          {
          lnao.REC_LEMQ_Outcome_1__c= 'Not Presented';
          }
          
          otherExistingLoans = [select Id,Balance__c,End_Date__c,Financial_Institution__c,Needs_Assessment__c,Rate__c,Type_of_Loan__c from NA_Other_Existing_Loans__c where Needs_Assessment__c =: lnao.Id];
          otherMembers = [select Id,Age__c,Name__c,Want_to_Refer_Membership__c from NA_Membership_Referral_Questions__c where Needs_Assessment__c =: lnao.Id];
          }
        
          system.debug('lnao----' +  lnao);
          return lnao;
    }
    public void setnao(Needs_Assesment__c value) {
        lnao = value;
    }
    public void SubmitOtherForm(){
            //If condition is not in prod
           if(lnao.Member__c == null)
           {
            lnao.Member__c = accId2;
           }
            upsert lnao; 
    }
    
    
}