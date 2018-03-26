public class Na_OtherExistingLoans
{
    public string script { get; set; }
    public Account AccountC { get; set; }
    public string NA_id { get; set; }

    public string accId2 { get; set; }
    public NeedAssessmentController parentController { get; set; }
    public Needs_Assesment__c lmm_New;
    public integer loanid { get; set; }
    public list<NA_Other_Existing_Loans__c> otherExistingLoans;
public boolean  firsttime = true;



    public Needs_Assesment__c getlmm_New()
    {
        if(lmm_New == null)
        {
        setObjects();
}
        return lmm_New;
    }
    public void setlmm_New(Needs_Assesment__c val)
    {
        lmm_New = val;
    }



    public void setObjects()
    {

        accId2 = parentController.account[0].Id;

        list<Needs_Assesment__c> naother = [select id,
                        Rec_LEOM_1__c,
                        Rec_LEOM_2__c,
                        Rec_LEOM_3__c,
                        Rec_LEOM_4__c,
                        Rec_LEOM_5__c,
                        Rec_LEOM_6__c,
                        Rec_LEOM_7__c,Rec_LEOL_1__c,Rec_LEOL_2__c,
                        LEOL_Last_Updated_On__c,LEOL_Other_Existing_Loans__c
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
        
                otherExistingLoans = [select id, Balance__c, End_Date__c, Financial_Institution__c, Needs_Assessment__c, Rate__c, Type_of_Loan__c 
                        from NA_Other_Existing_Loans__c where Needs_Assessment__c =: lmm_New.ID];
        
                       
    }

    public list<NA_Other_Existing_Loans__c> GetotherExistingLoans()
    {
        if (otherExistingLoans == null)
        {
            otherExistingLoans = new list<NA_Other_Existing_Loans__c>();
        }


        return otherExistingLoans;
    }


    public void setotherExistingLoans(list<NA_Other_Existing_Loans__c> value)
    {
       
            otherExistingLoans = value;
       



    }
    public void addOtherExistingLoan()
    {

        NA_Other_Existing_Loans__c obj = new NA_Other_Existing_Loans__c();
        //obj.Needs_Assessment__c = NA_id;
        otherExistingLoans.add(obj);

    }


    public void deleteOtherExistingLoan()
    {
        system.debug('System-----' + loanid);



        for (integer i = 0; i < otherExistingLoans.size(); i++)
        {
            if (loanid == i)
            {

                if (!string.isEmpty(otherExistingLoans[i].id))
                {
                    delete otherExistingLoans[i];
                }


                otherExistingLoans.remove(i);
                
                break;
            }
        }




    }


    public PageReference SubmitFeedbackForm()
    {

    



            Needs_Assesment__c nao_tobeinserted = new Needs_Assesment__c();
                        nao_tobeinserted.Id = lmm_New.Id;
            nao_tobeinserted.Rec_LEOM_1__c = lmm_New.Rec_LEOM_1__c;
            nao_tobeinserted.Rec_LEOM_2__c = lmm_New.Rec_LEOM_2__c;
            nao_tobeinserted.Rec_LEOM_3__c = lmm_New.Rec_LEOM_3__c;
            nao_tobeinserted.Rec_LEOM_4__c = lmm_New.Rec_LEOM_4__c;
            nao_tobeinserted.Rec_LEOM_5__c = lmm_New.Rec_LEOM_5__c;
            nao_tobeinserted.Rec_LEOM_6__c = lmm_New.Rec_LEOM_6__c;
            nao_tobeinserted.Rec_LEOM_7__c = lmm_New.Rec_LEOM_7__c;
			nao_tobeinserted.REC_LEOL_1__c = lmm_New.REC_LEOL_1__c;
			nao_tobeinserted.REC_LEOL_2__c = lmm_New.REC_LEOL_2__c;
			nao_tobeinserted.LEOL_Other_Existing_Loans__c = lmm_New.LEOL_Other_Existing_Loans__c;


            if (nao_tobeinserted.Id == null)
            {
                nao_tobeinserted.Member__c = accId2;
            }
            nao_tobeinserted.LEOL_Last_Updated_On__c = system.today();
            
            
 			lmm_New.LEOL_Last_Updated_On__c =nao_tobeinserted.LEOL_Last_Updated_On__c;           
            script = '1';

upsert nao_tobeinserted;

            	lmm_New.id = nao_tobeinserted.id;
            
              for (integer i = 0; i < otherExistingLoans.size(); i++)
        				{
        					if(otherExistingLoans[i].Needs_Assessment__c == null)
        					{
        					otherExistingLoans[i].Needs_Assessment__c = nao_tobeinserted.id;
        					}
        				}

            upsert otherExistingLoans;


	
        
        
        
        RefreshParent();
        
        return null;
    }



    public void resetscript()
    {
        script = '';
    }

    public void RefreshParent()
    {



        parentController.RefreshAccount();




        parentController.GetOtherLoanTabClass();
    }




}