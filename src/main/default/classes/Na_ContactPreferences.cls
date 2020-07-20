public class Na_ContactPreferences
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

        list<Needs_Assesment__c> naother = [select id, LECP_Written_Materials_Way_To_Send_Email__c,
                        LECP_Written_Materials_Way_To_Send_Mail__c,
                        LECP_ContactPhone_Yes__c,
                        LECP_ContactPhone_No__c,
                        LECP_Comments__c,
                        LECP_Last_Updated_On__c,
                        Rec_LEOM_1__c,
                        Rec_LEOM_2__c,
                        Rec_LEOM_3__c,
                        Rec_LEOM_4__c,
                        Rec_LEOM_5__c,
                        Rec_LEOM_6__c,
                        Rec_LEOM_7__c
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


        //if(lmm_New.LECP_Written_Materials_Way_To_Send_Email__c != null ||  lmm_New.LECP_ContactPhone_No__c!= null || lmm_New.LECP_Written_Materials_Way_To_Send_Mail__c!= null || lmm_New.LECP_ContactPhone_Yes__c != null || lmm_New.LECP_Comments__c != null || lmm_New.Rec_LEOM_1__c || lmm_New.Rec_LEOM_2__c || lmm_New.Rec_LEOM_3__c || lmm_New.Rec_LEOM_4__c || lmm_New.Rec_LEOM_5__c || lmm_New.Rec_LEOM_6__c ||lmm_New.Rec_LEOM_7__c)



        {

          

            Needs_Assesment__c nao_tobeinserted = new Needs_Assesment__c();
            nao_tobeinserted.Id = lmm_New.Id;


            nao_tobeinserted.LECP_Written_Materials_Way_To_Send_Email__c= lmm_New.LECP_Written_Materials_Way_To_Send_Email__c;
            nao_tobeinserted.LECP_Written_Materials_Way_To_Send_Mail__c= lmm_New.LECP_Written_Materials_Way_To_Send_Mail__c;
            nao_tobeinserted.LECP_ContactPhone_Yes__c= lmm_New.LECP_ContactPhone_Yes__c;
            nao_tobeinserted.LECP_ContactPhone_No__c= lmm_New.LECP_ContactPhone_No__c;
            nao_tobeinserted.LECP_Comments__c= lmm_New.LECP_Comments__c;

            nao_tobeinserted.Rec_LEOM_1__c = lmm_New.Rec_LEOM_1__c;
            nao_tobeinserted.Rec_LEOM_2__c = lmm_New.Rec_LEOM_2__c;
            nao_tobeinserted.Rec_LEOM_3__c = lmm_New.Rec_LEOM_3__c;
            nao_tobeinserted.Rec_LEOM_4__c = lmm_New.Rec_LEOM_4__c;
            nao_tobeinserted.Rec_LEOM_5__c = lmm_New.Rec_LEOM_5__c;
            nao_tobeinserted.Rec_LEOM_6__c = lmm_New.Rec_LEOM_6__c;
            nao_tobeinserted.Rec_LEOM_7__c = lmm_New.Rec_LEOM_7__c;

            if (nao_tobeinserted.Id == null)
            {
                nao_tobeinserted.Member__c = accId2;
            }
            nao_tobeinserted.LECP_Last_Updated_On__c= system.today();
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




        parentController.GetContactPreferenceTabClass();
    }




}