public class Na_PrimaryTransactionController
{
    public string script { get; set; }
    public Account AccountC { get; set; }
    public string NA_id { get; set; }

    public string accId2 { get; set; }
    public NeedAssessmentController parentController { get; set; }
    public Needs_Assesment__c lmm_New;


    public Needs_Assesment__c getlmm_New()
    {

        setObjects();

        return lmm_New;
    }
    public void setlmm_New(Needs_Assesment__c val)
    {
        lmm_New = val;
    }


    public void setObjects()
    {

        accId2 = parentController.account[0].Id;

        list<Needs_Assesment__c> naother = [select id, LEPT_Financial_Institution__c , LEPT_Deposit_rates__c, LEPT_Convenient_locations__c , LEPT_Have_financial_advisor_there__c,
                         LEPT_Last_Updated_On__c, LEPT_Loan_rates__c,LEPT_Online_mobile_apps__c,LEPT_Other__c,
                         Rec_LEOM_1__c, Rec_LEOM_2__c, Rec_LEOM_3__c,LEPT_Comments__c,LEPT_Last_Response_Date_For_FI__c,LEPT_Last_Response_Date_for_Comments__c,
                         Rec_LEOM_4__c, Rec_LEOM_5__c, Rec_LEOM_6__c, Rec_LEOM_7__c,REC_LEPT_1__c from Needs_Assesment__c


                           where member__c =:accId2 ORDER by LastModifiedDate desc];

        if (naother.size() > 0)
        {
            NA_id = naother[0].Id;

            if (AccountC.NA_LEOM_Expired__c)
            {
                lmm_New = new Needs_Assesment__c();
                lmm_New.ID = NA_id;


            }
            else
            {
                lmm_New = naother[0];
            }
        }
        else
        {

            lmm_New = new Needs_Assesment__c();

        }
    }




    public void SubmitFeedbackForm()
    {


        if( lmm_New.LEPT_Financial_Institution__c != null || lmm_New.LEPT_Convenient_locations__c != null || lmm_New.LEPT_Have_financial_advisor_there__c != null || lmm_New.LEPT_Loan_rates__c != null || lmm_New.LEPT_Online_mobile_apps__c != null || lmm_New.LEPT_Other__c != null || lmm_New.LEPT_Comments__c != null || lmm_New.Rec_LEOM_1__c || lmm_New.Rec_LEOM_2__c || lmm_New.Rec_LEOM_3__c || lmm_New.Rec_LEOM_4__c || lmm_New.Rec_LEOM_5__c || lmm_New.Rec_LEOM_6__c || lmm_New.Rec_LEOM_7__c)



        {

          

            Needs_Assesment__c nao_tobeinserted = new Needs_Assesment__c();
            nao_tobeinserted.Id = lmm_New.Id;


            nao_tobeinserted.LEPT_Financial_Institution__c = lmm_New.LEPT_Financial_Institution__c;
            nao_tobeinserted.LEPT_Deposit_rates__c = lmm_New.LEPT_Deposit_rates__c;
            nao_tobeinserted.LEPT_Convenient_locations__c = lmm_New.LEPT_Convenient_locations__c;
            nao_tobeinserted.LEPT_Have_financial_advisor_there__c = lmm_New.LEPT_Have_financial_advisor_there__c;            
            nao_tobeinserted.LEPT_Loan_rates__c = lmm_New.LEPT_Loan_rates__c;
            nao_tobeinserted.LEPT_Online_mobile_apps__c = lmm_New.LEPT_Online_mobile_apps__c;
            nao_tobeinserted.LEPT_Other__c = lmm_New.LEPT_Other__c;
            nao_tobeinserted.LEPT_Comments__c = lmm_New.LEPT_Comments__c;
            

            nao_tobeinserted.Rec_LEOM_1__c = lmm_New.Rec_LEOM_1__c;
            nao_tobeinserted.Rec_LEOM_2__c = lmm_New.Rec_LEOM_2__c;
            nao_tobeinserted.Rec_LEOM_3__c = lmm_New.Rec_LEOM_3__c;
            nao_tobeinserted.Rec_LEOM_4__c = lmm_New.Rec_LEOM_4__c;
            nao_tobeinserted.Rec_LEOM_5__c = lmm_New.Rec_LEOM_5__c;
            nao_tobeinserted.Rec_LEOM_6__c = lmm_New.Rec_LEOM_6__c;
            nao_tobeinserted.Rec_LEOM_7__c = lmm_New.Rec_LEOM_7__c;
            
            nao_tobeinserted.Rec_LEPT_1__c = lmm_New.Rec_LEPT_1__c;
            
            

            if (nao_tobeinserted.Id == null)
            {
                nao_tobeinserted.Member__c = accId2;
            }
            nao_tobeinserted.LEPT_Last_Updated_On__c = system.today();
            script = '1';


            upsert nao_tobeinserted;




        }
        RefreshParent();
    }



    public void resetscript()
    {
        script = '';
    }

    public void RefreshParent()
    {



        parentController.RefreshAccount();




        parentController.GetPrimaryTransactionTabClass();
    }




}