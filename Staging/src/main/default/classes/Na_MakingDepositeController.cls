public class Na_MakingDepositeController
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

        list<Needs_Assesment__c> naother = [select id, LEMD_No__c , LEMD_At_another_financial_institution__c, LEMD_CFCU_Spectrum__c, LEMD_At_another_financial_insti_YesNo__c,LEMD_ATM__c,LEMD_CFCU_Spectrum_YesNo__c,LEMD_CommentsDC__c,LEMD_CommentsForDD__c,
                         LEMD_In_person_branch__c,LEMD_Last_Updated_On__c,  LEMD_Mobile__c,LEMD_Online__c,
                         Rec_LEOM_1__c, Rec_LEOM_2__c, Rec_LEOM_3__c,
                         Rec_LEOM_4__c, Rec_LEOM_5__c, Rec_LEOM_6__c, Rec_LEOM_7__c,
                         REC_LEMD_1__c,REC_LEMD_2__c,REC_LEMD_3__c,REC_LECF_4__c,REC_LEEM_1__c
                         from Needs_Assesment__c
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


        //if(lmm_New.LEMD_At_another_financial_insti_YesNo__c != null || lmm_New.LEMD_ATM__c != null || lmm_New.LEMD_CFCU_Spectrum_YesNo__c != null || lmm_New.LEMD_CommentsDC__c != null ||  lmm_New.LEMD_CommentsForDD__c != null || lmm_New.LEMD_In_person_branch__c != null || lmm_New.LEMD_Mobile__c != null || lmm_New.LEMD_Online__c != null || lmm_New.Rec_LEOM_1__c || lmm_New.Rec_LEOM_2__c ||  lmm_New.Rec_LEOM_3__c || lmm_New.Rec_LEOM_4__c || lmm_New.Rec_LEOM_5__c || lmm_New.Rec_LEOM_6__c || lmm_New.Rec_LECF_4__c) 



        {

          

            Needs_Assesment__c nao_tobeinserted = new Needs_Assesment__c();
            nao_tobeinserted.Id = lmm_New.Id;

            nao_tobeinserted.LEMD_At_another_financial_insti_YesNo__c = lmm_New.LEMD_At_another_financial_insti_YesNo__c;
            nao_tobeinserted.LEMD_ATM__c = lmm_New.LEMD_ATM__c;
            nao_tobeinserted.LEMD_No__c = lmm_New.LEMD_No__c;
            
            nao_tobeinserted.LEMD_CFCU_Spectrum_YesNo__c = lmm_New.LEMD_CFCU_Spectrum_YesNo__c;
            
            nao_tobeinserted.LEMD_At_another_financial_institution__c = lmm_New.LEMD_At_another_financial_institution__c;
            
            nao_tobeinserted.LEMD_CommentsDC__c = lmm_New.LEMD_CommentsDC__c;            
            nao_tobeinserted.LEMD_CommentsForDD__c = lmm_New.LEMD_CommentsForDD__c;
            nao_tobeinserted.LEMD_In_person_branch__c = lmm_New.LEMD_In_person_branch__c;
            nao_tobeinserted.LEMD_Mobile__c = lmm_New.LEMD_Mobile__c;
               
            nao_tobeinserted.LEMD_Online__c = lmm_New.LEMD_Online__c; 
            

            nao_tobeinserted.Rec_LEOM_1__c = lmm_New.Rec_LEOM_1__c;
            nao_tobeinserted.Rec_LEOM_2__c = lmm_New.Rec_LEOM_2__c;
            nao_tobeinserted.Rec_LEOM_3__c = lmm_New.Rec_LEOM_3__c;
            nao_tobeinserted.Rec_LEOM_4__c = lmm_New.Rec_LEOM_4__c;
            nao_tobeinserted.Rec_LEOM_5__c = lmm_New.Rec_LEOM_5__c;
            nao_tobeinserted.Rec_LEOM_6__c = lmm_New.Rec_LEOM_6__c;
            nao_tobeinserted.Rec_LEOM_7__c = lmm_New.Rec_LEOM_7__c;
            
            nao_tobeinserted.REC_LEMD_1__c = lmm_New.REC_LEMD_1__c;
            nao_tobeinserted.REC_LEMD_2__c = lmm_New.REC_LEMD_2__c;
            nao_tobeinserted.REC_LEMD_3__c = lmm_New.REC_LEMD_3__c;
            nao_tobeinserted.REC_LECF_4__c = lmm_New.REC_LECF_4__c;
            nao_tobeinserted.REC_LEEM_1__c = lmm_New.REC_LEEM_1__c;

            if (nao_tobeinserted.Id == null)
            {
                nao_tobeinserted.Member__c = accId2;
            }
            nao_tobeinserted.LEMD_Last_Updated_On__c = system.today();
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




        parentController.GetMakingDepositsTabClass();
    }




}