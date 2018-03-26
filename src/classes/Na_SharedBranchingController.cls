public class Na_SharedBranchingController
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

        list<Needs_Assesment__c> naother = [select id,LESB_Last_Updated_On__c,REC_LEMD_3__c,LESB_Aware_ConvBranching__c,LESB_Aware_SharedBranching__c,LESB_SharedBranching_Comments__c from Needs_Assesment__c


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




    public void SubmitSharedBranchingForm()
    {


        //if( lmm_New.LESB_Aware_SharedBranching__c != null || lmm_New.LESB_SharedBranching_Comments__c != null || lmm_New.LESB_Aware_ConvBranching__c != null || lmm_New.REC_LEMD_3__c)
        {
            Needs_Assesment__c nao_tobeinserted = new Needs_Assesment__c();
            nao_tobeinserted.Id = lmm_New.Id;
     
            nao_tobeinserted.REC_LEMD_3__c	= lmm_New.REC_LEMD_3__c;
            nao_tobeinserted.LESB_Aware_SharedBranching__c = lmm_New.LESB_Aware_SharedBranching__c;
            nao_tobeinserted.LESB_SharedBranching_Comments__c = lmm_New.LESB_SharedBranching_Comments__c;
			nao_tobeinserted.LESB_Aware_ConvBranching__c = lmm_New.LESB_Aware_ConvBranching__c;                        
         
         

            if (nao_tobeinserted.Id == null)
            {
                nao_tobeinserted.Member__c = accId2;
            }
            nao_tobeinserted.LESB_Last_Updated_On__c = system.today();
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




        parentController.GetSharedBranchingTabClass();
    }




}