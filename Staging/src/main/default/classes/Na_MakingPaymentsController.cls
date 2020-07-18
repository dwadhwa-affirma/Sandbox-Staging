public class Na_MakingPaymentsController
{

    public string script { get; set; }
    public Account AccountC { get; set; }
    public string NA_id { get; set; }

    public string accId2 { get; set; }
    public NeedAssessmentController parentController { get; set; }
    public Needs_Assesment__c mpt_New;


    public Needs_Assesment__c getmpt_New()
    {

        setObjects();

        return mpt_New;
    }
    public void setmpt_New(Needs_Assesment__c val)
    {
        mpt_New = val;
    }


    public void setObjects()
    {

        accId2 = parentController.account[0].Id;
        list<Needs_Assesment__c> naother = [select id, LEMP_Pay_Recurring_Check__c,
                    LEMP_Pay_Recurring_BillPay__c, LEMP_Pay_Recurring_CC__c, LEMP_Pay_Recurring_ACH__c,
                    LEMP_Pay_Recurring_A2A__c, LEMP_Pay_Recurring_Other__c, LEMP_Pay_Individuals_Check__c,
                    LEMP_Pay_Individuals_BillPay__c, LEMP_Pay_Individuals_CC__c, LEMP_Pay_Individuals_ACH__c,
                    LEMP_Pay_Individuals_A2A__c, LEMP_Pay_Individuals_Other__c, LEMP_Pay_MoveMoney_Check__c,
                    LEMP_Pay_MoveMoney_BillPay__c, LEMP_Pay_MoveMoney_CC__c, LEMP_Pay_MoveMoney_ACH__c,
                    LEMP_Pay_MoveMoney_A2A__c, LEMP_Pay_MoveMoney_Other__c,
                    LEMP_Pay_Individuals_DC__c, LEMP_Pay_MoveMoney_DC__c, LEMP_Pay_Recurring_DC__c,

                    LEMP_Payment_Transfer_Comments__c, LEMP_Transfer_Frequency__c, LEMP_Transfer_Comments__c,
                    LEMP_International_Transfer_Frequency__c, LEMP_International_Transfer_Comments__c, LEMP_Last_Updated_On__c,
                    LEMP_Debit_Card_Usage_Retail__c, LEMP_Debit_Card_Usage_Grocries__c, LEMP_Debit_Card_Usage_Gasstation__c,
                    LEMP_Debit_Card_Usage_Online__c, LEMP_Debit_Card_Usage_Other__c, LEMP_Debit_Card_Usage_Comments__c,
                    LEMP_Credit_Card_Usage_No_Annual_Fee__c, LEMP_Credit_Card_Usage_Rewards__c, LEMP_Credit_Card_Usage_Cash_Back__c,
                    LEMP_Credit_Card_Usage_Low_Interest_Rate__c, LEMP_Credit_Card_Usage_Other__c, LEMP_Carry_Credit_Card_Balance__c,
                    LEMP_Credit_Card_You_Use_Often__c, LEMP_Credit_Card_Usage_Comments__c, LEMP_Credit_Card_Usage_Reason_Comments__c,
                    Rec_LEOM_1__c, Rec_LEOM_2__c, Rec_LEOM_3__c,
                    Rec_LEOM_4__c, Rec_LEOM_5__c, Rec_LEOM_6__c, Rec_LEOM_7__c,
                    REC_LEMP_1__c,REC_LEMP_2__c,REC_LEMP_3__c,REC_LEMP_4__c,
                    REC_LEMP_5__c,REC_LEMP_6__c,REC_LEMP_7__c,REC_LEMP_8__c				
                    from Needs_Assesment__c
                    where member__c =:accId2 ORDER by LastModifiedDate desc];
        if (naother.size() > 0)
        {
            NA_id = naother[0].Id;

            if (AccountC.NA_LEOM_Expired__c)
            {
                mpt_New = new Needs_Assesment__c();
                mpt_New.ID = NA_id;


            }
            else
            {
                mpt_New = naother[0];
            }
        }
        else
        {

            mpt_New = new Needs_Assesment__c();

        }
    }



    public void SubmitFeedbackForm()
    {


        //If( mpt_New.LEMP_Pay_Recurring_Check__c != null || mpt_New.LEMP_Pay_Recurring_BillPay__c != null || mpt_New.LEMP_Pay_Recurring_CC__c != null || mpt_New.LEMP_Pay_Recurring_ACH__c != null || mpt_New.LEMP_Pay_Recurring_A2A__c != null || mpt_New.LEMP_Pay_Recurring_Other__c != null || mpt_New.LEMP_Pay_Individuals_Check__c != null || mpt_New.LEMP_Pay_Individuals_BillPay__c != null || mpt_New.LEMP_Pay_Individuals_CC__c != null || mpt_New.LEMP_Pay_Individuals_ACH__c != null || mpt_New.LEMP_Pay_Individuals_A2A__c != null || mpt_New.LEMP_Pay_Individuals_Other__c != null || mpt_New.LEMP_Pay_MoveMoney_Check__c != null || mpt_New.LEMP_Pay_MoveMoney_BillPay__c != null || mpt_New.LEMP_Pay_MoveMoney_CC__c != null || mpt_New.LEMP_Pay_MoveMoney_ACH__c != null || mpt_New.LEMP_Pay_MoveMoney_A2A__c != null || mpt_New.LEMP_Pay_MoveMoney_Other__c != null || mpt_New.LEMP_Payment_Transfer_Comments__c != null || mpt_New.LEMP_Transfer_Frequency__c != null || mpt_New.LEMP_Transfer_Comments__c != null || mpt_New.LEMP_International_Transfer_Frequency__c != null || mpt_New.LEMP_International_Transfer_Comments__c != null || mpt_New.LEMP_Debit_Card_Usage_Retail__c != null || mpt_New.LEMP_Debit_Card_Usage_Grocries__c != null || mpt_New.LEMP_Debit_Card_Usage_Gasstation__c != null|| mpt_New.LEMP_Debit_Card_Usage_Online__c != null || mpt_New.LEMP_Debit_Card_Usage_Other__c != null || mpt_New.LEMP_Debit_Card_Usage_Comments__c != null || mpt_New.LEMP_Credit_Card_Usage_No_Annual_Fee__c != null ||  mpt_New.LEMP_Credit_Card_Usage_Rewards__c != null || mpt_New.LEMP_Credit_Card_Usage_Cash_Back__c != null || mpt_New.LEMP_Credit_Card_Usage_Low_Interest_Rate__c != null || mpt_New.LEMP_Credit_Card_Usage_Other__c != null || mpt_New.LEMP_Carry_Credit_Card_Balance__c != null || mpt_New.LEMP_Credit_Card_You_Use_Often__c != null || mpt_New.LEMP_Credit_Card_Usage_Comments__c != null || mpt_New.LEMP_Credit_Card_Usage_Reason_Comments__c != null || mpt_New.LEMP_Pay_Individuals_DC__c != null || mpt_New.LEMP_Pay_Recurring_DC__c != null || mpt_New.LEMP_Pay_MoveMoney_DC__c != null || mpt_New.Rec_LEOM_1__c != null || mpt_New.Rec_LEOM_2__c != null || mpt_New.Rec_LEOM_3__c != null || mpt_New.Rec_LEOM_4__c != null || mpt_New.Rec_LEOM_5__c != null || mpt_New.Rec_LEOM_6__c != null || mpt_New.Rec_LEOM_7__c != null)
 

        {

            system.debug('test2 --- ');

            Needs_Assesment__c nao_tobeinserted = new Needs_Assesment__c();
            nao_tobeinserted.Id = mpt_New.Id;
            nao_tobeinserted.LEMP_Pay_Recurring_Check__c = mpt_New.LEMP_Pay_Recurring_Check__c;
            nao_tobeinserted.LEMP_Pay_Recurring_BillPay__c = mpt_New.LEMP_Pay_Recurring_BillPay__c;
            nao_tobeinserted.LEMP_Pay_Recurring_CC__c = mpt_New.LEMP_Pay_Recurring_CC__c;
            nao_tobeinserted.LEMP_Pay_Recurring_ACH__c = mpt_New.LEMP_Pay_Recurring_ACH__c;
            nao_tobeinserted.LEMP_Pay_Recurring_A2A__c = mpt_New.LEMP_Pay_Recurring_A2A__c;
            nao_tobeinserted.LEMP_Pay_Recurring_Other__c = mpt_New.LEMP_Pay_Recurring_Other__c;
            nao_tobeinserted.LEMP_Pay_Individuals_Check__c = mpt_New.LEMP_Pay_Individuals_Check__c;
            nao_tobeinserted.LEMP_Pay_Individuals_BillPay__c = mpt_New.LEMP_Pay_Individuals_BillPay__c;
            nao_tobeinserted.LEMP_Pay_Individuals_CC__c = mpt_New.LEMP_Pay_Individuals_CC__c;
            nao_tobeinserted.LEMP_Pay_Individuals_ACH__c = mpt_New.LEMP_Pay_Individuals_ACH__c;
            nao_tobeinserted.LEMP_Pay_Individuals_A2A__c = mpt_New.LEMP_Pay_Individuals_A2A__c;
            nao_tobeinserted.LEMP_Pay_Individuals_Other__c = mpt_New.LEMP_Pay_Individuals_Other__c;
            nao_tobeinserted.LEMP_Pay_MoveMoney_Check__c = mpt_New.LEMP_Pay_MoveMoney_Check__c;
            nao_tobeinserted.LEMP_Pay_MoveMoney_BillPay__c = mpt_New.LEMP_Pay_MoveMoney_BillPay__c;
            nao_tobeinserted.LEMP_Pay_MoveMoney_CC__c = mpt_New.LEMP_Pay_MoveMoney_CC__c;
            nao_tobeinserted.LEMP_Pay_MoveMoney_ACH__c = mpt_New.LEMP_Pay_MoveMoney_ACH__c;
            nao_tobeinserted.LEMP_Pay_MoveMoney_A2A__c = mpt_New.LEMP_Pay_MoveMoney_A2A__c;
            nao_tobeinserted.LEMP_Pay_MoveMoney_Other__c = mpt_New.LEMP_Pay_MoveMoney_Other__c;
            nao_tobeinserted.LEMP_Payment_Transfer_Comments__c = mpt_New.LEMP_Payment_Transfer_Comments__c;
            nao_tobeinserted.LEMP_Transfer_Frequency__c = mpt_New.LEMP_Transfer_Frequency__c;
            nao_tobeinserted.LEMP_Transfer_Comments__c = mpt_New.LEMP_Transfer_Comments__c;
            nao_tobeinserted.LEMP_International_Transfer_Frequency__c = mpt_New.LEMP_International_Transfer_Frequency__c;
            nao_tobeinserted.LEMP_International_Transfer_Comments__c = mpt_New.LEMP_International_Transfer_Comments__c;

            nao_tobeinserted.LEMP_Debit_Card_Usage_Retail__c = mpt_New.LEMP_Debit_Card_Usage_Retail__c;
            nao_tobeinserted.LEMP_Debit_Card_Usage_Grocries__c = mpt_New.LEMP_Debit_Card_Usage_Grocries__c;
            nao_tobeinserted.LEMP_Debit_Card_Usage_Gasstation__c = mpt_New.LEMP_Debit_Card_Usage_Gasstation__c;
            nao_tobeinserted.LEMP_Debit_Card_Usage_Online__c = mpt_New.LEMP_Debit_Card_Usage_Online__c;
            nao_tobeinserted.LEMP_Debit_Card_Usage_Other__c = mpt_New.LEMP_Debit_Card_Usage_Other__c;
            nao_tobeinserted.LEMP_Debit_Card_Usage_Comments__c = mpt_New.LEMP_Debit_Card_Usage_Comments__c;
            nao_tobeinserted.LEMP_Credit_Card_Usage_No_Annual_Fee__c = mpt_New.LEMP_Credit_Card_Usage_No_Annual_Fee__c;
            nao_tobeinserted.LEMP_Credit_Card_Usage_Rewards__c = mpt_New.LEMP_Credit_Card_Usage_Rewards__c;
            nao_tobeinserted.LEMP_Credit_Card_Usage_Cash_Back__c = mpt_New.LEMP_Credit_Card_Usage_Cash_Back__c;
            nao_tobeinserted.LEMP_Credit_Card_Usage_Low_Interest_Rate__c = mpt_New.LEMP_Credit_Card_Usage_Low_Interest_Rate__c;
            nao_tobeinserted.LEMP_Credit_Card_Usage_Other__c = mpt_New.LEMP_Credit_Card_Usage_Other__c;
            nao_tobeinserted.LEMP_Carry_Credit_Card_Balance__c = mpt_New.LEMP_Carry_Credit_Card_Balance__c;
            nao_tobeinserted.LEMP_Credit_Card_You_Use_Often__c = mpt_New.LEMP_Credit_Card_You_Use_Often__c;
            nao_tobeinserted.LEMP_Credit_Card_Usage_Comments__c = mpt_New.LEMP_Credit_Card_Usage_Comments__c;
            nao_tobeinserted.LEMP_Credit_Card_Usage_Reason_Comments__c = mpt_New.LEMP_Credit_Card_Usage_Reason_Comments__c;


            nao_tobeinserted.LEMP_Pay_Individuals_DC__c = mpt_New.LEMP_Pay_Individuals_DC__c;
            nao_tobeinserted.LEMP_Pay_MoveMoney_DC__c = mpt_New.LEMP_Pay_MoveMoney_DC__c;
            nao_tobeinserted.LEMP_Pay_Recurring_DC__c = mpt_New.LEMP_Pay_Recurring_DC__c;

            nao_tobeinserted.Rec_LEOM_1__c = mpt_New.Rec_LEOM_1__c;
            nao_tobeinserted.Rec_LEOM_2__c = mpt_New.Rec_LEOM_2__c;
            nao_tobeinserted.Rec_LEOM_3__c = mpt_New.Rec_LEOM_3__c;
            nao_tobeinserted.Rec_LEOM_4__c = mpt_New.Rec_LEOM_4__c;
            nao_tobeinserted.Rec_LEOM_5__c = mpt_New.Rec_LEOM_5__c;
            nao_tobeinserted.Rec_LEOM_6__c = mpt_New.Rec_LEOM_6__c;
            nao_tobeinserted.Rec_LEOM_7__c = mpt_New.Rec_LEOM_7__c;
            
            nao_tobeinserted.REC_LEMP_1__c = mpt_New.REC_LEMP_1__c;
			nao_tobeinserted.REC_LEMP_2__c = mpt_New.REC_LEMP_2__c;
			nao_tobeinserted.REC_LEMP_3__c = mpt_New.REC_LEMP_3__c;
			nao_tobeinserted.REC_LEMP_4__c = mpt_New.REC_LEMP_4__c;
			nao_tobeinserted.REC_LEMP_5__c = mpt_New.REC_LEMP_5__c;
			nao_tobeinserted.REC_LEMP_6__c = mpt_New.REC_LEMP_6__c;
			nao_tobeinserted.REC_LEMP_7__c = mpt_New.REC_LEMP_7__c;
			nao_tobeinserted.REC_LEMP_8__c = mpt_New.REC_LEMP_8__c;

            if (nao_tobeinserted.Id == null)
            {
                nao_tobeinserted.Member__c = accId2;
            }
            nao_tobeinserted.LEMP_Last_Updated_On__c = system.today();
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




        parentController.GetMoveYourMoneyTabClass();
    }

}