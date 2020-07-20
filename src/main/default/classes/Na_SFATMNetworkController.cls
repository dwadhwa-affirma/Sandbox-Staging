public class Na_SFATMNetworkController
{

    public string script { get; set; }
    public Account AccountC { get; set; }
    public string NA_id { get; set; }

    public string accId2 { get; set; }
    public NeedAssessmentController parentController { get; set; }
    public Needs_Assesment__c lsf_New;


    public Needs_Assesment__c getlsf_New()
    {

        setObjects();

        return lsf_New;
    }
    public void setlsf_New(Needs_Assesment__c val)
    {
        lsf_New = val;
    }


    public void setObjects()
    {

        accId2 = parentController.account[0].Id; 
        list<Needs_Assesment__c> naother = [select id,
                    LESF_ATM_Location_YesNo__c, LESF_Aware_ATM_Network_YesNo__c, LESF_Comments__c, LESF_Last_Updated_On__c,REC_LECF_4__c
                    from Needs_Assesment__c
                    where member__c =:accId2 ORDER by LastModifiedDate desc];
        if (naother.size() > 0)
        {
            NA_id = naother[0].Id;

            if (AccountC.NA_LEOM_Expired__c)
            {
                lsf_New = new Needs_Assesment__c();
                lsf_New.ID = NA_id;


            }
            else
            {
                lsf_New = naother[0];
            }
        }
        else
        {

            lsf_New = new Needs_Assesment__c();

        }
    }



    public void SubmitSFNetwordForm()
    {


        //If(lsf_New.LESF_ATM_Location_YesNo__c != null || lsf_New.LESF_Aware_ATM_Network_YesNo__c != null || lsf_New.LESF_Comments__c != null)
        if (1==1)
        {

            Needs_Assesment__c nao_tobeinserted = new Needs_Assesment__c();
            nao_tobeinserted.Id = lsf_New.Id;


            nao_tobeinserted.LESF_ATM_Location_YesNo__c = lsf_New.LESF_ATM_Location_YesNo__c;
            nao_tobeinserted.LESF_Aware_ATM_Network_YesNo__c = lsf_New.LESF_Aware_ATM_Network_YesNo__c;
            nao_tobeinserted.LESF_Comments__c = lsf_New.LESF_Comments__c;
			nao_tobeinserted.REC_LECF_4__c = lsf_New.REC_LECF_4__c;
            
            if (nao_tobeinserted.Id == null)
            {
                nao_tobeinserted.Member__c = accId2;
            }
            nao_tobeinserted.LESF_Last_Updated_On__c = system.today();
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




        parentController.GetSFATMNetworkTabClass();
    }

}