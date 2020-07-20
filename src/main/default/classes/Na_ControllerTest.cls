@isTest

public class Na_ControllerTest
{

    static testMethod void PrimaryTransition()
    {
        Test.StartTest();
        try{
        Account acc = new Account();
        acc.Name = 'Test account';

        Insert acc;
        initializeGracePeriod();
        Needs_Assesment__c na = new Needs_Assesment__c();


        //na.LEAV_CurrentLoanProvider__c = 'Bank of America';
        na.Member__c = acc.Id;
        insert na;


        ApexPages.StandardController sc = new ApexPages.StandardController(acc);
        NeedAssessmentController need = new NeedAssessmentController(sc);

        need.accId2 = acc.id;

        NA_PrimaryTransactionController NaAuto = new NA_PrimaryTransactionController();
        NaAuto.AccountC = acc;
        NaAuto.parentController = need;
        
        Needs_Assesment__c na2 = new Needs_Assesment__c();
        Na2.LEPT_Financial_Institution__c = 'Ally';
        Na2.LEPT_Deposit_rates__c = True;
        Na2.LEPT_Convenient_locations__c = True;
        Na2.LEPT_Have_financial_advisor_there__c = True;
        Na2.LEPT_Deposit_rates__c = true;
        Na2.LEPT_Convenient_locations__c = true;
        Na2.LEPT_Have_financial_advisor_there__c = true;
        Na2.LEPT_Loan_rates__c = true;
        Na2.LEPT_Online_mobile_apps__c = true;
        Na2.LEPT_Other__c = true;
        Na2.LEPT_Comments__c = 'test';
        Na2.Rec_LEOM_1__c = true;
        Na2.Rec_LEOM_2__c = true;
        Na2.Rec_LEOM_3__c = true;
        Na2.Rec_LEOM_4__c = true;
        Na2.Rec_LEOM_5__c = true;
        Na2.Rec_LEOM_6__c = true;
        Na2.Rec_LEOM_7__c = true;
        //NaAuto.lmm_New = na2;

        NaAuto.Getlmm_New();
        NaAuto.setlmm_New(Na2);


        //NaAuto.setObjects();
		NaAuto.resetscript();
        NaAuto.resetscript();
        NaAuto.SubmitFeedbackForm();
        
        }catch(exception e){
        	system.debug('error--'+e);
    	}
        Test.StopTest();

    }



    static testMethod void Housing()
    {
        Test.StartTest();
        try{
        Account acc = new Account();
        acc.Name = 'Test account';

        Insert acc;


        initializeGracePeriod();



        Needs_Assesment__c na = new Needs_Assesment__c();


        //na.LEAV_CurrentLoanProvider__c = 'Bank of America';
        na.Member__c = acc.Id;
        insert na;


        ApexPages.StandardController sc = new ApexPages.StandardController(acc);
        NeedAssessmentController need = new NeedAssessmentController(sc);

        need.accId2 = acc.id;

        Na_HousingController NaAuto = new Na_HousingController();
        NaAuto.AccountC = acc;
        NaAuto.parentController = need;

        Needs_Assesment__c na2 = new Needs_Assesment__c();
        na2.Do_you_Rent_or_Own__c = 'Own';
        na2.LEHS_Current_Lender__c = 'Chase Bank';
        na2.LEHS_Rate__c = 10;
        na2.LEHS_Current_Balance__c = 10;
        na2.Member__c = acc.id;
        na2.LEHS_End_Date__c = system.today();
        na2.LEHS_Planning_to_Purchase__c =  'Yes';
        na2.LEHS_Purchase_When__c = '3-6 months';
        na2.LEHS_Have_Realtor__c = 'Yes';
        na2.LEHS_Last_Updated_On__c   =  null;
        na2.LEHS_Comment__c = '';
        na2.LEHS_Current_Balance__c = 1000.00;
        na2.Rec_LEOM_1__c = true;
        na2.Rec_LEOM_2__c = true;
        na2.Rec_LEOM_3__c = true;
        na2.Rec_LEOM_4__c = true;
        na2.Rec_LEOM_5__c = true;
        na2.Rec_LEOM_6__c = true;
        na2.Rec_LEOM_7__c = true;
        na2.Rec_LEHS_1__c = true;
        na2.Rec_LEHS_2__c = true;
        
        //insert na2;
        //NaAuto.lmm_New = na2;

        NaAuto.getnah_New();
        NaAuto.setnah_new(Na2);


        //NaAuto.setObjects();


		NaAuto.resetscript();
        NaAuto.SubmitHousingForm();
        
        //NaAuto.resetscript();
        }catch(exception e){
			system.debug('error--'+e);
        }       
        Test.StopTest();

    }
    static testMethod void NAOtherMilestones()
    {
        Test.StartTest();
        try{
        Account acc = new Account();
        acc.Name = 'Test account';

        Insert acc;

        initializeGracePeriod();

        Needs_Assesment__c na = new Needs_Assesment__c();



        na.Member__c = acc.Id;
        insert na;



        ApexPages.StandardController sc = new ApexPages.StandardController(acc);
        NeedAssessmentController need = new NeedAssessmentController(sc);

        need.accId2 = acc.id;

        NA_Other_MilestonesController NaAuto = new NA_Other_MilestonesController();
        NaAuto.AccountC = acc;
        NaAuto.parentController = need;

        Needs_Assesment__c na2 = new Needs_Assesment__c();
        na2.Home_Improvement__c = 'Yes';

        na2.Member__c = acc.id;
        //insert na2;


        NaAuto.getnao_New();
        NaAuto.setnao_new(Na2);





		NaAuto.resetscript();
        NaAuto.SubmitOtherForm();
       
        }catch(exception e){
			system.debug('error--'+e);
        }
        Test.StopTest();

    }			


    static testMethod void NAAutoVehicleController()
    {
        Test.StartTest();
        try{
        Account acc = new Account();
        acc.Name = 'Test account';

        Insert acc;
        initializeGracePeriod();
        Needs_Assesment__c na = new Needs_Assesment__c();



        na.Member__c = acc.Id;
        insert na;

        /*   GracePeriod__c mycs = GracePeriod__c.getValues('NA Other Milestones');
          if(mycs == null) {
              mycs = new GracePeriod__c(); 
              mycs.Name= 'NA Other Milestones';
              mycs.ExpiresInDays__c = 1;
              mycs.GracePeriod__c = 1;
              insert mycs;
          }*/

        ApexPages.StandardController sc = new ApexPages.StandardController(acc);
        NeedAssessmentController need = new NeedAssessmentController(sc);

        need.accId2 = acc.id;

        NA_AutoVehicleController NaAuto = new NA_AutoVehicleController();
        NaAuto.AccountC = acc;
        NaAuto.parentController = need;

        Needs_Assesment__c na2 = new Needs_Assesment__c();
        na2.LEAV_AnticipateFinance__c = 'Yes';

        na2.Member__c = acc.id;
        //insert na2;


        NaAuto.getlnao_New();
        NaAuto.setlnao_New(Na2);





		NaAuto.resetscript();
        NaAuto.SubmitAutoVehicleForm();
        
        }catch(exception e){
			system.debug('error--'+e);
        }

        Test.StopTest();

    }

    static testMethod void NaContactPreferences()
    {
        Test.StartTest();
        try{
        Account acc = new Account();
        acc.Name = 'Test account';

        Insert acc;
        initializeGracePeriod();
        Needs_Assesment__c na = new Needs_Assesment__c();



        na.Member__c = acc.Id;
        insert na;



        ApexPages.StandardController sc = new ApexPages.StandardController(acc);
        NeedAssessmentController need = new NeedAssessmentController(sc);

        need.accId2 = acc.id;

        Na_ContactPreferences NaAuto = new Na_ContactPreferences();
        NaAuto.AccountC = acc;
        NaAuto.parentController = need;

        Needs_Assesment__c na2 = new Needs_Assesment__c();
        na2.LECP_Written_Materials_Way_To_Send_Email__c = true;

        na2.Member__c = acc.id;
        //insert na2;


        NaAuto.getlmm_New();
        NaAuto.setlmm_New(Na2);





		NaAuto.resetscript();
        NaAuto.SubmitFeedbackForm();
        
        }catch(exception e){
			system.debug('error--'+e);
        }
        Test.StopTest();

    }

    static testMethod void NaCurrentFeedbackController()
    {
        Test.StartTest();
        try{
        Account acc = new Account();
        acc.Name = 'Test account';

        Insert acc;
        initializeGracePeriod();
        Needs_Assesment__c na = new Needs_Assesment__c();



        na.Member__c = acc.Id;
        insert na;



        ApexPages.StandardController sc = new ApexPages.StandardController(acc);
        NeedAssessmentController need = new NeedAssessmentController(sc);

        need.accId2 = acc.id;

        Na_CurrentFeedbackController NaAuto = new Na_CurrentFeedbackController();
        NaAuto.AccountC = acc;
        NaAuto.parentController = need;

        Needs_Assesment__c na2 = new Needs_Assesment__c();
        na2.LECF_Branch_Feedback__c = 'tes 123';

        na2.Member__c = acc.id;
        //insert na2;


        NaAuto.getlcf_New();
        NaAuto.setlcf_New(Na2);

		NaAuto.resetscript();
        NaAuto.SubmitFeedbackForm();
        
        }catch(exception e){
        	system.debug('error--'+e);
        }
        Test.StopTest();

    }




    static testMethod void NaMakingDepositeController()
    {
        Test.StartTest();
        try{
        Account acc = new Account();
        acc.Name = 'Test account';

        Insert acc;
        initializeGracePeriod();
        Needs_Assesment__c na = new Needs_Assesment__c();



        na.Member__c = acc.Id;
        insert na;



        ApexPages.StandardController sc = new ApexPages.StandardController(acc);
        NeedAssessmentController need = new NeedAssessmentController(sc);

        need.accId2 = acc.id;

        Na_MakingDepositeController NaAuto = new Na_MakingDepositeController();
        NaAuto.AccountC = acc;
        NaAuto.parentController = need;

        Needs_Assesment__c na2 = new Needs_Assesment__c();
        na2.LEMD_ATM__c = true;

        na2.Member__c = acc.id;
        //insert na2;


        NaAuto.getlmm_New();
        NaAuto.setlmm_New(Na2);
		NaAuto.resetscript();
        NaAuto.SubmitFeedbackForm();
        
        }catch(exception e){
			system.debug('error--'+e);
		}
        Test.StopTest();

    }


    static testMethod void NaMakingPaymentsController()
    {
        Test.StartTest();
        try{
        Account acc = new Account();
        acc.Name = 'Test account';

        Insert acc;
        initializeGracePeriod();
        Needs_Assesment__c na = new Needs_Assesment__c();



        na.Member__c = acc.Id;
        insert na;



        ApexPages.StandardController sc = new ApexPages.StandardController(acc);
        NeedAssessmentController need = new NeedAssessmentController(sc);

        need.accId2 = acc.id;

        Na_MakingPaymentsController NaAuto = new Na_MakingPaymentsController();
        NaAuto.AccountC = acc;
        NaAuto.parentController = need;

        Needs_Assesment__c na2 = new Needs_Assesment__c();
        na2.LEMP_Pay_Recurring_Check__c = true;

        na2.Member__c = acc.id;
        //insert na2;


        NaAuto.getmpt_New();
        NaAuto.setmpt_New(Na2);
		NaAuto.resetscript();
        NaAuto.SubmitFeedbackForm();
        
        }catch(exception e){
        	system.debug('error--'+e);
        }
        Test.StopTest();

    }

    static testMethod void NaWithdrawal()
    {
        Test.StartTest();
        try{
        Account acc = new Account();
        acc.Name = 'Test account';

        Insert acc;
        initializeGracePeriod();
        Needs_Assesment__c na = new Needs_Assesment__c();



        na.Member__c = acc.Id;
        insert na;



        ApexPages.StandardController sc = new ApexPages.StandardController(acc);
        NeedAssessmentController need = new NeedAssessmentController(sc);

        need.accId2 = acc.id;

        Na_Withdrawal NaAuto = new Na_Withdrawal();
        NaAuto.AccountC = acc;
        NaAuto.parentController = need;

        Needs_Assesment__c na2 = new Needs_Assesment__c();
        na2.LEWS_Comment__c = 'Test 123';

        na2.Member__c = acc.id;
        //insert na2;


        NaAuto.getlmm_New();
        NaAuto.setlmm_New(Na2);
		NaAuto.resetscript();
        NaAuto.SubmitFeedbackForm();
        
        }catch(exception e){
        	system.debug('error--'+e);
        }
        Test.StopTest();

    }


    static testMethod void NaLESFATM()
    {
        Test.StartTest();
        try{
        Account acc = new Account();
        acc.Name = 'Test account';

        Insert acc;
        initializeGracePeriod();
        Needs_Assesment__c na = new Needs_Assesment__c();



        na.Member__c = acc.Id;
        insert na;



        ApexPages.StandardController sc = new ApexPages.StandardController(acc);
        NeedAssessmentController need = new NeedAssessmentController(sc);

        need.accId2 = acc.id;

        Na_SFATMNetworkController Nasf = new Na_SFATMNetworkController();
        Nasf.AccountC = acc;
        Nasf.parentController = need;

        Needs_Assesment__c na2 = new Needs_Assesment__c();
        na2.LESF_Comments__c = 'Test 123';

        na2.Member__c = acc.id;
        //insert na2;


        Nasf.getlsf_New();
        Nasf.setlsf_New(Na2);
		Nasf.resetscript();
        Nasf.SubmitSFNetwordForm();
        
        }catch(exception e){
        	system.debug('error--'+e);
        }
        Test.StopTest();

    }


    static testMethod void NaSharedBranching()
    {
        Test.StartTest();
        try{
        Account acc = new Account();
        acc.Name = 'Test account';

        Insert acc;
        initializeGracePeriod();
        Needs_Assesment__c na = new Needs_Assesment__c();

        na.Member__c = acc.Id;
        insert na;



        ApexPages.StandardController sc = new ApexPages.StandardController(acc);
        NeedAssessmentController need = new NeedAssessmentController(sc);

        need.accId2 = acc.id;

        Na_SharedBranchingController Nasf = new Na_SharedBranchingController();
        Nasf.AccountC = acc;
        Nasf.parentController = need;

        Needs_Assesment__c na2 = new Needs_Assesment__c();
        na2.LESB_Aware_SharedBranching__c = 'Yes';
        na2.LESB_SharedBranching_Comments__c = 'Yes';
        na2.LESB_Aware_ConvBranching__c = 'asdfas';
        na2.Member__c = acc.id;
        //insert na2;


        Nasf.getlmm_New();
        Nasf.setlmm_New(Na2);

		Nasf.resetscript();
        Nasf.SubmitSharedBranchingForm();
        
        }catch(exception e){
        	system.debug('error--'+e);
        }
        Test.StopTest();

    }



    static testMethod void NaOtherExistingLoans()
    {
        Test.StartTest();
        try{
        Account acc = new Account();
        acc.NA_Opt_Out__c = true;
        acc.NA_LEOM_Complete__c = true;
        acc.NA_LECP_Complete__c = true;
        
        acc.Name = 'Test account';

        Insert acc;
        initializeGracePeriod();
        Needs_Assesment__c na = new Needs_Assesment__c();



        na.Member__c = acc.Id;
        insert na;


        ApexPages.StandardController sc = new ApexPages.StandardController(acc);
        NeedAssessmentController need = new NeedAssessmentController(sc);

        need.accId2 = acc.id;

        Na_OtherExistingLoans Nasf = new Na_OtherExistingLoans();
        Nasf.AccountC = acc;
        Nasf.parentController = need;

        Needs_Assesment__c na2 = new Needs_Assesment__c();
        na2.Rec_LEOM_1__c = true;

        na2.Member__c = acc.id;
        //insert na2;


        Nasf.getlmm_New();
        Nasf.setlmm_New(Na2);

		NAsf.setotherExistingLoans(Nasf.otherExistingLoans);
        NAsf.addOtherExistingLoan();
        NAsf.GetotherExistingLoans();        
        NAsf.deleteOtherExistingLoan();


		Nasf.resetscript();
        Nasf.SubmitFeedbackForm();
        
		}catch(exception e){
        	system.debug('error--'+e);
        }
        Test.StopTest();

    }
    
    static testMethod void Na_Earn_More()
    {
        Test.StartTest();
        try{
        Account acc = new Account();       
        acc.Name = 'Test account';

        Insert acc;
        initializeGracePeriod();

        ApexPages.StandardController sc = new ApexPages.StandardController(acc);
        NeedAssessmentController need = new NeedAssessmentController(sc);

        need.accId2 = acc.id;

        Na_Earn_MoreController  Nasf = new Na_Earn_MoreController();
        Nasf.AccountC = acc;
        
        Nasf.parentController = need;

        Needs_Assesment__c na2 = new Needs_Assesment__c();
        na2.REC_LEEM_1__c = true;
        na2.Member__c = acc.id;
        insert na2;
        
        NA_Deposit__c nd = new NA_Deposit__c();
        nd.Needs_Assessment__c  = na2.id;
        insert nd;
		
		List<NA_Deposit__c> NdLst = new List<NA_Deposit__c>();
		NdLst.add(nd);
		
        Nasf.getlcf_New();
        Nasf.setlcf_New(Na2);		      
        Nasf.resetscript();
		Nasf.Getdeposits();
		Nasf.addDeposit();
		Nasf.setdeposits(NdLst);
		Nasf.deletedeposits();
		
		}catch(exception e){
        	system.debug('error--'+e);
        }
        Test.StopTest();

    }
    static testMethod void Na_Earn_More2()
    {
        Test.StartTest();
        try{
        Account acc = new Account();       
        acc.Name = 'Test account';

        Insert acc;
        initializeGracePeriod();



        ApexPages.StandardController sc = new ApexPages.StandardController(acc);
        NeedAssessmentController need = new NeedAssessmentController(sc);

        need.accId2 = acc.id;

        Na_Earn_MoreController  Nasf = new Na_Earn_MoreController();
        Nasf.AccountC = acc;
        Nasf.parentController = need;

        Needs_Assesment__c na2 = new Needs_Assesment__c();
        na2.REC_LEEM_1__c = true;

        na2.Member__c = acc.id;
        //insert na2;


        Nasf.getlcf_New();
        Nasf.setlcf_New(Na2);
		Nasf.SubmitEarnMoreForm();       
  
        
		}catch(exception e){
        	system.debug('error--'+e);
        }
        Test.StopTest();

    }
    
    static testMethod void Na_EarnMoreRecommendation()
    {
        Test.StartTest();
        try{
        Account acc = new Account();       
        acc.Name = 'Test account';

        Insert acc;

        NA_Earn_More_RecommendationController  Naer = new NA_Earn_More_RecommendationController();
       
        Needs_Assesment__c na2 = new Needs_Assesment__c();
        na2.Member__c = acc.id;
        insert na2;
        
        NA_Deposit__c nd = new NA_Deposit__c();
        nd.Needs_Assessment__c  = na2.id;
        insert nd;
        
		Naer.nao_Page = na2;
		List<NA_Deposit__c> InsertDep = new List<NA_Deposit__c>();
		InsertDep.add(nd);
		
		List<NA_Deposit__c> LstDeposite  = Naer.otherDeposits;
		
		}catch(exception e){
        	system.debug('error--'+e);
        }
        Test.StopTest();

    }
    
    
    static testMethod void Na_ReferralQuestions ()
    {
        Test.StartTest();
        try{
        Account acc = new Account();      
        acc.Name = 'Test account';

        Insert acc;
        initializeGracePeriod();
        
        Needs_Assesment__c na = new Needs_Assesment__c();
        na.Member__c = acc.Id;
        insert na;


        ApexPages.StandardController sc = new ApexPages.StandardController(acc);
        NeedAssessmentController need = new NeedAssessmentController(sc);

        need.accId2 = acc.id;

        Na_ReferralQuestionsController Nasf = new Na_ReferralQuestionsController();
        Nasf.AccountC = acc;
        Nasf.parentController = need;

        Needs_Assesment__c na2 = new Needs_Assesment__c();
        na2.Rec_LEOM_1__c = true;

        na2.Member__c = acc.id;
        //insert na2;


        Nasf.getlmm_New();
        Nasf.setlmm_New(Na2);

		NAsf.setotherExistingLoans(Nasf.otherExistingLoans);
        NAsf.addOtherExistingLoan();
        NAsf.GetotherExistingLoans();        
        NAsf.deleteOtherExistingLoan();

        Nasf.resetscript();
		Nasf.SubmitFeedbackForm();
		
        need.getListNASection();
        string teststring = 'thisvalue';
		need.setselectedNaSection(teststring);
        need.GetOptimizeMoveYourMoney();
        need.GetFinanceKeyFileEvent();
        need.GetFeedBackAboutCurrentExperience();
		need.GetEarnMore();
        need.Page_Load();
        need.getaccountFirst();
        need.GetEligibility();
        need.GetExtendBenifits();
		}catch(exception e){
        	system.debug('error--'+e);
        }
        
        Test.StopTest();

    }
    
    static testMethod void Recomendation()
    {
        Test.StartTest();
        try{
        
        //initializeGracePeriod();
        
        RecomendationController  Nasf = new RecomendationController();
        
        Account acc = new Account();      
        acc.Name = 'Test account';
        Insert acc;
        
        Needs_Assesment__c na = new Needs_Assesment__c();
        na.Member__c = acc.Id;
       
        insert na;
        
        Nasf.AccountC  = acc;
        //Nasf.parentController = need;

        Nasf.getnao();
        Nasf.setnao(na);

        //Nasf.SubmitOtherForm();
        }catch(exception e){
        	system.debug('error--'+e);
        }
        Test.StopTest();

    }
    static testMethod void Recomendation2()
    {
        Test.StartTest();
        try{
        
        //initializeGracePeriod();
        
        RecomendationController  Nasf = new RecomendationController();
        
        Account acc = new Account();      
        acc.Name = 'Test account';
        Insert acc;
        
        /*Needs_Assesment__c na = new Needs_Assesment__c();
        na.Member__c = acc.Id;
        na.Home_Improvement__c = 'Yes';
        na.Home_Improvement_Timeframe__c = 'Less than 3 months';
        na.Home_Improvement_Plan__c = 'Savings';
        na.College__c = 'Yes';
        na.College_Plan__c = 'Savings';
        na.College_Timeframe__c = 'Less than 3 months';
        na.Medical__c = 'yes';
        na.Medical_Timeframe__c = 'Less than 3 months';
        na.Medical_Plan__c = 'Savings';
        na.Purchase_RV_Boat__c = 'Yes';
        na.Purchase_RV_Boat_Timeframe__c = 'Less than 3 months';
        na.Purchase_RV_Boat_Plan__c = 'Savings';
        na.Retirement_Plan__c = 'Finance';
        na.Retirement_Timeframe__c = 'Less than 3 months';
        na.Retirement__c = 'Yes';
        na.Travel__c = 'Yes';
        na.Travel_Plan__c = 'Savings';
        na.Travel_Timeframe__c = 'Less than 3 months';
        na.Life_Events__c = 'Yes';
        na.Life_Events_Timeframe__c = 'Less than 3 months';
        na.Life_Events_Plan__c = 'Savings';
        na.LEOM_Comments__c = 'test';
        na.LEOM_PlanUnforeseen__c = 'test';
        na.Other__c = 'Yes';
        na.Other_Timeframe__c =  'Less than 3 months';
        na.Other_Plan__c = 'Savings';
        na.Do_you_Rent_or_Own__c = 'Own';
        na.LEHS_Current_Lender__c = 'Bank of America';
        na.LEHS_Rate__c = 10.20;
        na.LEHS_Current_Balance__c  = 1000.20;
        na.LEHS_Planning_to_Purchase__c = 'Yes';
        na.LEHS_Purchase_When__c = 'Less than 3 months';
        na.LEHS_Have_Realtor__c = 'yes';
        na.LEHS_Comment__c = 'hello';
        na.LECF_Branch_Feedback__c = 'hello';
        na.LECF_Branch__c  = true;
        na.LECF_800_Feedback__c = 'hello';
        na.LECF_800__c = true;
        na.LECF_Online_banking_Feedback__c = 'hello';
        na.LECF_Online_banking__c  = true;
        na.LECF_ATM_Feedback__c = 'test';
        na.LECF_ATM__c  = true;
        na.LECF_Mobile_banking_Feedback__c = 'test';
        na.LECF_Mobile_banking__c  = true;
        na.LECF_Comment__c = 'test';
        na.LECF_Experience_Improvement_Feedback__c = 'test';
        na.LEWS_CFCU_ATM__c  = true;
        na.LEWS_InPerson__c  = true;
        na.LEWS_Other_ATM__c  = true;
        na.LEWS_Shared_ATM__c  = true;
        na.LEWS_Comment__c = 'test';
        na.LEMP_Carry_Credit_Card_Balance__c = 'Yes';
        na.LEMP_Credit_Card_Usage_Cash_Back__c  = true;
        na.LEMP_Credit_Card_Usage_Comments__c = 'test';
        na.LEMP_Credit_Card_Usage_Low_Interest_Rate__c  = true;
        na.LEMP_Credit_Card_Usage_No_Annual_Fee__c  = true;
        na.LEMP_Credit_Card_Usage_Other__c = 'test';
        na.LEMP_Credit_Card_Usage_Reason_Comments__c = 'test';
        na.LEMP_Credit_Card_Usage_Rewards__c  = true;
        na.LEMP_Credit_Card_You_Use_Often__c = 'test';
        na.LEMP_Debit_Card_Usage_Comments__c = 'test';
        na.LEMP_Debit_Card_Usage_Gasstation__c  = true;
        na.LEMP_Debit_Card_Usage_Grocries__c  = true;
        na.LEMP_Debit_Card_Usage_Online__c  = true;
        na.LEMP_Debit_Card_Usage_Other__c  = true;
        na.LEMP_Debit_Card_Usage_Retail__c  = true;
        na.LEMP_International_Transfer_Comments__c = 'test';
        na.LEMP_International_Transfer_Frequency__c = 'Frequently, on a one-time basis';
        na.LEMP_Pay_Individuals_A2A__c  = true;
        na.LEMP_Pay_Individuals_ACH__c  = true;
        na.LEMP_Pay_Individuals_BillPay__c  = true;
        na.LEMP_Pay_Individuals_CC__c  = true;
        na.LEMP_Pay_Individuals_Check__c  = true;
        na.LEMP_Pay_Individuals_DC__c  = true;
        na.LEMP_Pay_Individuals_Other__c  = true;
        na.LEMP_Pay_MoveMoney_A2A__c  = true;
        na.LEMP_Pay_MoveMoney_ACH__c  = true;
        na.LEMP_Pay_MoveMoney_BillPay__c  = true;
        na.LEMP_Pay_MoveMoney_CC__c  = true;
        na.LEMP_Pay_MoveMoney_Check__c = true;
        na.LEMP_Pay_MoveMoney_DC__c  = true;
        na.LEMP_Pay_MoveMoney_Other__c = true;
        na.LEMP_Pay_Recurring_A2A__c = true;
        na.LEMP_Pay_Recurring_ACH__c  = true;
        na.LEMP_Pay_Recurring_BillPay__c = true;
        na.LEMP_Pay_Recurring_CC__c = true;
        na.LEMP_Pay_Recurring_Check__c  = true;
        na.LEMP_Pay_Recurring_DC__c  = true;
        na.LEMP_Pay_Recurring_Other__c  = true;
        na.LEMP_Payment_Transfer_Comments__c = 'test';
        na.LEMP_Transfer_Comments__c = 'test';
        na.LEMP_Transfer_Frequency__c = 'Rarely';
        insert na;*/
        
        Nasf.AccountC  = acc;
        //Nasf.parentController = need;

        Nasf.getnao();
        //Nasf.setnao(na);

        Nasf.SubmitOtherForm();
        }catch(exception e){
        	system.debug('error--'+e);
        }
        Test.StopTest();

    }
    
    static testMethod void NeedAssesment()
    {
        Test.StartTest();
		
        Account acc = new Account();
        acc.Name = 'Test account';
		acc.NA_Opt_Out__c = true;
		acc.NA_LECP_Complete__c = false;
		acc.NA_LEWS_Complete__c = true;
		acc.NA_LEOM_Complete__c = true;
		acc.NA_LEEM_Complete__c = true;
		acc.NA_LEAV_Complete__c = true;
		acc.NA_LEHS_Complete__c = true;
		acc.NA_LECF_Complete__c = true;
		acc.NA_LEMP_Complete__c = true;
		acc.NA_LEWS_Complete__c = true;
		acc.NA_LECP_Complete__c = true;
		acc.NA_LEOL_Complete__c = true;
		acc.NA_LEPT_Complete__c = true;
		acc.NA_LEMD_Complete__c = true;
		acc.NA_LESF_Complete__c = true;
		acc.NA_LESB_Complete__c = true;
		acc.NA_LEMQ_Complete__c = true;
		
        Insert acc;
        system.debug('acc--'+acc);
        initializeGracePeriod();


        /*
        

        need.accId2 = acc.id;

        Na_OtherExistingLoans Nasf = new Na_OtherExistingLoans();
        Nasf.AccountC = acc;
        Nasf.parentController = need;*/
        ApexPages.StandardController sc = new ApexPages.StandardController(acc);
		NeedAssessmentController need = new NeedAssessmentController(sc);
        
        Needs_Assesment__c na2 = new Needs_Assesment__c();
        na2.Rec_LEOM_1__c = true;
		na2.LECP_Written_Materials_Way_To_Send_Email__c = false;
		na2.LECP_Written_Materials_Way_To_Send_Mail__c = false;
        na2.Member__c = acc.id;
        na2.LEOM_Last_Updated_On__c = system.today();
        na2.LEAV_Last_Updated_On__c = system.today();
        na2.LESF_Last_Updated_On__c = system.today();
        na2.LESB_Last_Updated_On__c = system.today();
        na2.LEMD_Last_Updated_On__c = system.today();
        na2.LECP_Last_Updated_On__c = system.today();
        na2.LEHS_Last_Updated_On__c = system.today();
        na2.LEOL_Last_Updated_On__c = system.today();
        na2.LECF_Last_Updated_On__c = system.today();
        na2.LEWS_Last_Updated_On__c = system.today();
        na2.LEMP_Last_Updated_On__c = system.today();
        na2.LEPT_Last_Updated_On__c = system.today();
        
        insert na2;

        /*need.objNeedsAssessment.LEOM_Last_Updated_On__c = system.today();
        need.objNeedsAssessment.LEAV_Last_Updated_On__c = system.today();
        need.objNeedsAssessment.LESF_Last_Updated_On__c = system.today();
        need.objNeedsAssessment.LESB_Last_Updated_On__c = system.today();
        need.objNeedsAssessment.LEMD_Last_Updated_On__c = system.today();
        need.objNeedsAssessment.LECP_Last_Updated_On__c = system.today();
        need.objNeedsAssessment.LEHS_Last_Updated_On__c = system.today();
        need.objNeedsAssessment.LEOL_Last_Updated_On__c = system.today();
        need.objNeedsAssessment.LECF_Last_Updated_On__c = system.today();
        need.objNeedsAssessment.LEWS_Last_Updated_On__c = system.today();
        need.objNeedsAssessment.LEMP_Last_Updated_On__c = system.today();
        need.objNeedsAssessment.LEPT_Last_Updated_On__c = system.today();*/
		
		need.Page_Load();

        need.GetOptimizeMoveYourMoney();
        need.GetFinanceKeyFileEvent();
        need.GetFeedBackAboutCurrentExperience();
        need.getaccountFirst();
        need.getEligibility();
        need.getnaAuth();
        
        NeedAssessmentHistoryController objNeedAssessmentHistoryController = new NeedAssessmentHistoryController();
        objNeedAssessmentHistoryController.getFormattedDAte();
        objNeedAssessmentHistoryController.getFormattedValue();
        objNeedAssessmentHistoryController.NA_ID = na2.Id;
        objNeedAssessmentHistoryController.HistoryFieldName = 'Rec_LEOM_1__c';
        objNeedAssessmentHistoryController.InsertDataHistoryTable(string.ValueOf( na2.Rec_LEOM_1__c), string.ValueOf(na2.Rec_LEOM_1__c), 'Rec_LEOM_1__c', '' + na2.Id);
        objNeedAssessmentHistoryController.getFormattedDAte();
        objNeedAssessmentHistoryController.getFormattedValue();
        objNeedAssessmentHistoryController.getFormattedValue();
        objNeedAssessmentHistoryController.InsertDataHistoryTable(string.ValueOf( na2.Rec_LEOM_1__c), string.ValueOf(na2.Rec_LEOM_1__c), 'Rec_LEOM_1__c', '' + na2.Id);
        objNeedAssessmentHistoryController.getFormattedDAte();
        objNeedAssessmentHistoryController.getFormattedValue();
        objNeedAssessmentHistoryController.InsertDataHistoryTable(string.ValueOf( na2.Rec_LEOM_1__c), string.ValueOf(na2.Rec_LEOM_1__c), 'Rec_LEOM_1__c', '' + na2.Id);
        objNeedAssessmentHistoryController.getFormattedDAte();
        objNeedAssessmentHistoryController.getFormattedValue();
        
		
        Test.StopTest();

    }
    static testMethod void NeedAssesment2()
    {
        Test.StartTest();
		
        Account acc = new Account();
        acc.Name = 'Test account';
		//acc.NA_Opt_Out__c = true;
		acc.NA_LECP_Complete__c = true;
		acc.NA_LEWS_Complete__c = true;
		acc.NA_LEOM_Complete__c = true;
		acc.NA_LEEM_Complete__c = true;
		acc.NA_LEAV_Complete__c = true;
		acc.NA_LEHS_Complete__c = true;
		acc.NA_LECF_Complete__c = true;
		acc.NA_LEMP_Complete__c = true;
		acc.NA_LEWS_Complete__c = true;
		acc.NA_LECP_Complete__c = true;
		acc.NA_LEOL_Complete__c = true;
		acc.NA_LEPT_Complete__c = true;
		acc.NA_LEMD_Complete__c = true;
		acc.NA_LESF_Complete__c = true;
		acc.NA_LESB_Complete__c = true;
		acc.NA_LEMQ_Complete__c = true;

		
        Insert acc;
        system.debug('acc--'+acc);
        initializeGracePeriod();


        /*
        

        need.accId2 = acc.id;

        Na_OtherExistingLoans Nasf = new Na_OtherExistingLoans();
        Nasf.AccountC = acc;
        Nasf.parentController = need;*/
        ApexPages.StandardController sc = new ApexPages.StandardController(acc);
		NeedAssessmentController need = new NeedAssessmentController(sc);
        
        Needs_Assesment__c na2 = new Needs_Assesment__c();
        na2.Rec_LEOM_1__c = true;
		na2.LECP_Written_Materials_Way_To_Send_Email__c = false;
		na2.LECP_Written_Materials_Way_To_Send_Mail__c = false;
        na2.Member__c = acc.id;
        na2.LEOM_Last_Updated_On__c = system.today();
        na2.LEAV_Last_Updated_On__c = system.today();
        na2.LESF_Last_Updated_On__c = system.today();
        na2.LESB_Last_Updated_On__c = system.today();
        na2.LEMD_Last_Updated_On__c = system.today();
        na2.LECP_Last_Updated_On__c = system.today();
        na2.LEHS_Last_Updated_On__c = system.today();
        na2.LEOL_Last_Updated_On__c = system.today();
        na2.LECF_Last_Updated_On__c = system.today();
        na2.LEWS_Last_Updated_On__c = system.today();
        na2.LEMP_Last_Updated_On__c = system.today();
        na2.LEPT_Last_Updated_On__c = system.today();
        na2.LEEM_Last_Updated_On__c = system.today();
        
        insert na2;

        /*need.objNeedsAssessment.LEOM_Last_Updated_On__c = system.today();
        need.objNeedsAssessment.LEAV_Last_Updated_On__c = system.today();
        need.objNeedsAssessment.LESF_Last_Updated_On__c = system.today();
        need.objNeedsAssessment.LESB_Last_Updated_On__c = system.today();
        need.objNeedsAssessment.LEMD_Last_Updated_On__c = system.today();
        need.objNeedsAssessment.LECP_Last_Updated_On__c = system.today();
        need.objNeedsAssessment.LEHS_Last_Updated_On__c = system.today();
        need.objNeedsAssessment.LEOL_Last_Updated_On__c = system.today();
        need.objNeedsAssessment.LECF_Last_Updated_On__c = system.today();
        need.objNeedsAssessment.LEWS_Last_Updated_On__c = system.today();
        need.objNeedsAssessment.LEMP_Last_Updated_On__c = system.today();
        need.objNeedsAssessment.LEPT_Last_Updated_On__c = system.today();*/
		need.Page_Load();
        need.getListNaSection();
        need.GetOtherTabClass();
        need.GetEarnMoreTabClass();
        need.GetAutoVehicleTabClass();
        need.GetHousingTabClass();
        need.GetCurrentFeedbackTabClass();
        need.GetMoveYourMoneyTabClass();
        need.GetWidthdrawalTabClass();
        need.GetContactPreferenceTabClass();
        need.GetOtherLoanTabClass();
        need.GetPrimaryTransactionTabClass();
        need.GetMakingDepositsTabClass();
        need.GetSFATMNetworkTabClass();
        need.GetSharedBranchingTabClass();
        need.GetExtendBenifitsTabClass();

        need.GetOptimizeMoveYourMoney();
        need.GetFinanceKeyFileEvent();
        need.GetFeedBackAboutCurrentExperience();
        
        NeedAssessmentHistoryController objNeedAssessmentHistoryController = new NeedAssessmentHistoryController();
        objNeedAssessmentHistoryController.getFormattedDAte();
        objNeedAssessmentHistoryController.getFormattedValue();
        objNeedAssessmentHistoryController.NA_ID = na2.Id;
        objNeedAssessmentHistoryController.HistoryFieldName = 'Rec_LEOM_1__c';
        objNeedAssessmentHistoryController.InsertDataHistoryTable(string.ValueOf( na2.Rec_LEOM_1__c), string.ValueOf(na2.Rec_LEOM_1__c), 'Rec_LEOM_1__c', '' + na2.Id);
        objNeedAssessmentHistoryController.getFormattedDAte();
        objNeedAssessmentHistoryController.getFormattedValue();
        objNeedAssessmentHistoryController.getFormattedValue();
        objNeedAssessmentHistoryController.InsertDataHistoryTable(string.ValueOf( na2.Rec_LEOM_1__c), string.ValueOf(na2.Rec_LEOM_1__c), 'Rec_LEOM_1__c', '' + na2.Id);
        objNeedAssessmentHistoryController.getFormattedDAte();
        objNeedAssessmentHistoryController.getFormattedValue();
        objNeedAssessmentHistoryController.InsertDataHistoryTable(string.ValueOf( na2.Rec_LEOM_1__c), string.ValueOf(na2.Rec_LEOM_1__c), 'Rec_LEOM_1__c', '' + na2.Id);
        objNeedAssessmentHistoryController.getFormattedDAte();
        objNeedAssessmentHistoryController.getFormattedValue();
        
		
        Test.StopTest();

    }
    static testMethod void NeedAssesment3()
    {
        Test.StartTest();
		
        Account acc = new Account();
        acc.Name = 'Test account';
		//acc.NA_Opt_Out__c = true;
		acc.NA_LECP_Complete__c = false;
		acc.NA_LEWS_Complete__c = false;
		acc.NA_LEOM_Complete__c = false;
		acc.NA_LEEM_Complete__c = false;
		acc.NA_LEAV_Complete__c = false;
		acc.NA_LEHS_Complete__c = false;
		acc.NA_LECF_Complete__c = false;
		acc.NA_LEMP_Complete__c = false;
		acc.NA_LEWS_Complete__c = false;
		acc.NA_LECP_Complete__c = false;
		acc.NA_LEOL_Complete__c = false;
		acc.NA_LEPT_Complete__c = false;
		acc.NA_LEMD_Complete__c = false;
		acc.NA_LESF_Complete__c = false;
		acc.NA_LESB_Complete__c = false;
		acc.NA_LEMQ_Complete__c = false;
		
        Insert acc;
        system.debug('acc--'+acc);
        initializeGracePeriod();


        /*
        

        need.accId2 = acc.id;

        Na_OtherExistingLoans Nasf = new Na_OtherExistingLoans();
        Nasf.AccountC = acc;
        Nasf.parentController = need;*/
        ApexPages.StandardController sc = new ApexPages.StandardController(acc);
		NeedAssessmentController need = new NeedAssessmentController(sc);
        
        Needs_Assesment__c na2 = new Needs_Assesment__c();
        na2.Rec_LEOM_1__c = true;
		na2.LECP_Written_Materials_Way_To_Send_Email__c = false;
		na2.LECP_Written_Materials_Way_To_Send_Mail__c = false;
        na2.Member__c = acc.id;
        na2.LEOM_Last_Updated_On__c = system.today();
        na2.LEAV_Last_Updated_On__c = system.today();
        na2.LESF_Last_Updated_On__c = system.today();
        na2.LESB_Last_Updated_On__c = system.today();
        na2.LEMD_Last_Updated_On__c = system.today();
        na2.LECP_Last_Updated_On__c = system.today();
        na2.LEHS_Last_Updated_On__c = system.today();
        na2.LEOL_Last_Updated_On__c = system.today();
        na2.LECF_Last_Updated_On__c = system.today();
        na2.LEWS_Last_Updated_On__c = system.today();
        na2.LEMP_Last_Updated_On__c = system.today();
        na2.LEPT_Last_Updated_On__c = system.today();
        na2.LEEM_Last_Updated_On__c = system.today();
        
        insert na2;

        /*need.objNeedsAssessment.LEOM_Last_Updated_On__c = system.today();
        need.objNeedsAssessment.LEAV_Last_Updated_On__c = system.today();
        need.objNeedsAssessment.LESF_Last_Updated_On__c = system.today();
        need.objNeedsAssessment.LESB_Last_Updated_On__c = system.today();
        need.objNeedsAssessment.LEMD_Last_Updated_On__c = system.today();
        need.objNeedsAssessment.LECP_Last_Updated_On__c = system.today();
        need.objNeedsAssessment.LEHS_Last_Updated_On__c = system.today();
        need.objNeedsAssessment.LEOL_Last_Updated_On__c = system.today();
        need.objNeedsAssessment.LECF_Last_Updated_On__c = system.today();
        need.objNeedsAssessment.LEWS_Last_Updated_On__c = system.today();
        need.objNeedsAssessment.LEMP_Last_Updated_On__c = system.today();
        need.objNeedsAssessment.LEPT_Last_Updated_On__c = system.today();*/
		need.Page_Load();
        need.getListNaSection();
        need.GetOtherTabClass();
        need.GetEarnMoreTabClass();
        need.GetAutoVehicleTabClass();
        need.GetHousingTabClass();
        need.GetCurrentFeedbackTabClass();
        need.GetMoveYourMoneyTabClass();
        need.GetWidthdrawalTabClass();
        need.GetContactPreferenceTabClass();
        need.GetOtherLoanTabClass();
        need.GetPrimaryTransactionTabClass();
        need.GetMakingDepositsTabClass();
        need.GetSFATMNetworkTabClass();
        need.GetSharedBranchingTabClass();
        need.GetExtendBenifitsTabClass();
         
        need.setselectedNaSection('test');

        need.GetOptimizeMoveYourMoney();
        need.GetFinanceKeyFileEvent();
        need.GetFeedBackAboutCurrentExperience();
        
        NeedAssessmentHistoryController objNeedAssessmentHistoryController = new NeedAssessmentHistoryController();
        objNeedAssessmentHistoryController.getFormattedDAte();
        objNeedAssessmentHistoryController.getFormattedValue();
        objNeedAssessmentHistoryController.NA_ID = na2.Id;
        objNeedAssessmentHistoryController.HistoryFieldName = 'Rec_LEOM_1__c';
        objNeedAssessmentHistoryController.InsertDataHistoryTable(string.ValueOf( na2.Rec_LEOM_1__c), string.ValueOf(na2.Rec_LEOM_1__c), 'Rec_LEOM_1__c', '' + na2.Id);
        objNeedAssessmentHistoryController.getFormattedDAte();
        objNeedAssessmentHistoryController.getFormattedValue();
        objNeedAssessmentHistoryController.getFormattedValue();
        objNeedAssessmentHistoryController.InsertDataHistoryTable(string.ValueOf( na2.Rec_LEOM_1__c), string.ValueOf(na2.Rec_LEOM_1__c), 'Rec_LEOM_1__c', '' + na2.Id);
        objNeedAssessmentHistoryController.getFormattedDAte();
        objNeedAssessmentHistoryController.getFormattedValue();
        objNeedAssessmentHistoryController.InsertDataHistoryTable(string.ValueOf( na2.Rec_LEOM_1__c), string.ValueOf(na2.Rec_LEOM_1__c), 'Rec_LEOM_1__c', '' + na2.Id);
        objNeedAssessmentHistoryController.getFormattedDAte();
        objNeedAssessmentHistoryController.getFormattedValue();
        
		
        Test.StopTest();

    }
    
    static testMethod void UpdateHistoryObject()
    {
    	try{
        Test.StartTest();
        Account acc = new Account();       
        acc.Name = 'Test account';

        Insert acc;
        //initializeGracePeriod();
        
        Needs_Assesment__c na = new Needs_Assesment__c();
        na.Member__c = acc.Id;
        insert na;
        
        na.Home_Improvement__c = 'Yes';
        na.Home_Improvement_Timeframe__c = 'Less than 3 months';
        na.Home_Improvement_Plan__c = 'Savings';
        na.College__c = 'Yes';
        na.College_Plan__c = 'Savings';
        na.College_Timeframe__c = 'Less than 3 months';
        na.Medical__c = 'yes';
        na.Medical_Timeframe__c = 'Less than 3 months';
        na.Medical_Plan__c = 'Savings';
        na.Purchase_RV_Boat__c = 'Yes';
        na.Purchase_RV_Boat_Timeframe__c = 'Less than 3 months';
        na.Purchase_RV_Boat_Plan__c = 'Savings';
        na.Retirement_Plan__c = 'Finance';
        na.Retirement_Timeframe__c = 'Less than 3 months';
        na.Retirement__c = 'Yes';
        na.Travel__c = 'Yes';
        na.Travel_Plan__c = 'Savings';
        na.Travel_Timeframe__c = 'Less than 3 months';
        na.Life_Events__c = 'Yes';
        na.Life_Events_Timeframe__c = 'Less than 3 months';
        na.Life_Events_Plan__c = 'Savings';
        na.LEOM_Comments__c = 'test';
        na.LEOM_PlanUnforeseen__c = 'test';
        na.Other__c = 'Yes';
        na.Other_Timeframe__c =  'Less than 3 months';
        na.Other_Plan__c = 'Savings';
        na.Do_you_Rent_or_Own__c = 'Own';
        na.LEHS_Current_Lender__c = 'Bank of America';
        na.LEHS_Rate__c = 10.20;
        na.LEHS_Current_Balance__c  = 1000.20;
        na.LEHS_Planning_to_Purchase__c = 'Yes';
        na.LEHS_Purchase_When__c = 'Less than 3 months';
        na.LEHS_Have_Realtor__c = 'yes';
        na.LEHS_Comment__c = 'hello';
        na.LECF_Branch_Feedback__c = 'hello';
        na.LECF_Branch__c  = true;
        na.LECF_800_Feedback__c = 'hello';
        na.LECF_800__c = true;
        na.LECF_Online_banking_Feedback__c = 'hello';
        na.LECF_Online_banking__c  = true;
        na.LECF_ATM_Feedback__c = 'test';
        na.LECF_ATM__c  = true;
        na.LECF_Mobile_banking_Feedback__c = 'test';
        na.LECF_Mobile_banking__c  = true;
        na.LECF_Comment__c = 'test';
        na.LECF_Experience_Improvement_Feedback__c = 'test';
        na.LEWS_CFCU_ATM__c  = true;
        na.LEWS_InPerson__c  = true;
        na.LEWS_Other_ATM__c  = true;
        na.LEWS_Shared_ATM__c  = true;
        na.LEWS_Comment__c = 'test';
        na.LEMP_Carry_Credit_Card_Balance__c = 'Yes';
        na.LEMP_Credit_Card_Usage_Cash_Back__c  = true;
        na.LEMP_Credit_Card_Usage_Comments__c = 'test';
        na.LEMP_Credit_Card_Usage_Low_Interest_Rate__c  = true;
        na.LEMP_Credit_Card_Usage_No_Annual_Fee__c  = true;
        na.LEMP_Credit_Card_Usage_Other__c = 'test';
        na.LEMP_Credit_Card_Usage_Reason_Comments__c = 'test';
        na.LEMP_Credit_Card_Usage_Rewards__c  = true;
        na.LEMP_Credit_Card_You_Use_Often__c = 'test';
        na.LEMP_Debit_Card_Usage_Comments__c = 'test';
        na.LEMP_Debit_Card_Usage_Gasstation__c  = true;
        na.LEMP_Debit_Card_Usage_Grocries__c  = true;
        na.LEMP_Debit_Card_Usage_Online__c  = true;
        na.LEMP_Debit_Card_Usage_Other__c  = true;
        na.LEMP_Debit_Card_Usage_Retail__c  = true;
        na.LEMP_International_Transfer_Comments__c = 'test';
        na.LEMP_International_Transfer_Frequency__c = 'Frequently, on a one-time basis';
        na.LEMP_Pay_Individuals_A2A__c  = true;
        na.LEMP_Pay_Individuals_ACH__c  = true;
        na.LEMP_Pay_Individuals_BillPay__c  = true;
        na.LEMP_Pay_Individuals_CC__c  = true;
        na.LEMP_Pay_Individuals_Check__c  = true;
        na.LEMP_Pay_Individuals_DC__c  = true;
        na.LEMP_Pay_Individuals_Other__c  = true;
        na.LEMP_Pay_MoveMoney_A2A__c  = true;
        na.LEMP_Pay_MoveMoney_ACH__c  = true;
        na.LEMP_Pay_MoveMoney_BillPay__c  = true;
        na.LEMP_Pay_MoveMoney_CC__c  = true;
        na.LEMP_Pay_MoveMoney_Check__c = true;
        na.LEMP_Pay_MoveMoney_DC__c  = true;
        na.LEMP_Pay_MoveMoney_Other__c = true;
        na.LEMP_Pay_Recurring_A2A__c = true;
        na.LEMP_Pay_Recurring_ACH__c  = true;
        na.LEMP_Pay_Recurring_BillPay__c = true;
        na.LEMP_Pay_Recurring_CC__c = true;
        na.LEMP_Pay_Recurring_Check__c  = true;
        na.LEMP_Pay_Recurring_DC__c  = true;
        na.LEMP_Pay_Recurring_Other__c  = true;
        na.LEMP_Payment_Transfer_Comments__c = 'test';
        na.LEMP_Transfer_Comments__c = 'test';
        na.LEMP_Transfer_Frequency__c = 'Rarely';
        na.LEPT_Loan_rates__c = true;
        na.LECP_Written_Materials_Way_To_Send_Mail__c = true;
        na.LECP_ContactPhone_Yes__c = true;
        na.LECP_ContactPhone_No__c = true;
        na.LECP_ContactPhone_Yes__c = true;
        na.LECP_Comments__c = 'hi';
        na.LEOL_Other_Existing_Loans__c = 'Yes';
        na.LEAV_Current__c = 'Yes';
        na.LEAV_CurrentLoanProvider__c = 'Bank of America';
        na.LEAV_CurrentRate__c = 10.20;
        na.LEAV_CurrentBalance__c = 1000.30;
        na.LEAV_EndDateLoan__c = system.today();
        na.LEAV_PlanningToBuy__c = 'Yes';
        na.LEAV_PlanDate__c = system.today();
        na.LEAV_AnticipateFinance__c = 'Yes';
        na.LEAV_ContactPreferences__c = 'Test';
        na.LEPT_Financial_Institution__c = 'Bank of America';
    
        update na;
        
		}catch(exception e){
        	system.debug('error--'+e);
        }
        Test.StopTest();

    }
    

    static void initializeGracePeriod()
    {
        GracePeriod__c mycs = GracePeriod__c.getValues('Housing');

        if (mycs == null)
        {
            mycs = new GracePeriod__c();
            mycs.Name = 'Housing';
            mycs.ExpiresInDays__c = 1;
            mycs.GracePeriod__c = 1;
            insert mycs;
        }
        mycs = GracePeriod__c.getValues('NA Other Milestones');
        if (mycs == null)
        {
            mycs = new GracePeriod__c();
            mycs.Name = 'NA Other Milestones';
            mycs.ExpiresInDays__c = 1;
            mycs.GracePeriod__c = 1;
            insert mycs;
        }
        mycs = GracePeriod__c.getValues('PrimaryTransaction');

        if (mycs == null)
        {
            mycs = new GracePeriod__c();
            mycs.Name = 'PrimaryTransaction';
            mycs.ExpiresInDays__c = 1;
            mycs.GracePeriod__c = 1;
            insert mycs;

        }
        mycs = GracePeriod__c.getValues('NA Other Milestones');
        if (mycs == null)
        {
            mycs = new GracePeriod__c();
            mycs.Name = 'NA Other Milestones';
            mycs.ExpiresInDays__c = 1;
            mycs.GracePeriod__c = 1;
            insert mycs;
        }

        mycs = GracePeriod__c.getValues('Contact Preference');
        if (mycs == null)
        {
            mycs = new GracePeriod__c();
            mycs.Name = 'Contact Preference';
            mycs.ExpiresInDays__c = 1;
            mycs.GracePeriod__c = 1;
            insert mycs;
        }
        mycs = GracePeriod__c.getValues('Current Feedback');
        if (mycs == null)
        {
            mycs = new GracePeriod__c();
            mycs.Name = 'Current Feedback';
            mycs.ExpiresInDays__c = 1;
            mycs.GracePeriod__c = 1;
            insert mycs;
        }
        mycs = GracePeriod__c.getValues('MakingDeposits');
        if (mycs == null)
        {
            mycs = new GracePeriod__c();
            mycs.Name = 'MakingDeposits';
            mycs.ExpiresInDays__c = 1;
            mycs.GracePeriod__c = 1;
            insert mycs;
        }
        mycs = GracePeriod__c.getValues('Move Your Money');
        if (mycs == null)
        {
            mycs = new GracePeriod__c();
            mycs.Name = 'Move Your Money';
            mycs.ExpiresInDays__c = 1;
            mycs.GracePeriod__c = 1;
            insert mycs;
        }
        mycs = GracePeriod__c.getValues('Withdrawal');
        if (mycs == null)
        {
            mycs = new GracePeriod__c();
            mycs.Name = 'Withdrawal';
            mycs.ExpiresInDays__c = 1;
            mycs.GracePeriod__c = 1;
            insert mycs;
        }
        mycs = GracePeriod__c.getValues('ATM Network');
        if (mycs == null)
        {
            mycs = new GracePeriod__c();
            mycs.Name = 'ATM Network';
            mycs.ExpiresInDays__c = 1;
            mycs.GracePeriod__c = 1;
            insert mycs;

        }

        mycs = GracePeriod__c.getValues('Shared Branching');
        if (mycs == null)
        {
            mycs = new GracePeriod__c();
            mycs.Name = 'Shared Branching';
            mycs.ExpiresInDays__c = 1;
            mycs.GracePeriod__c = 1;
            insert mycs;
        }
        mycs = GracePeriod__c.getValues('Other Loan');
        if (mycs == null)
        {
            mycs = new GracePeriod__c();
            mycs.Name = 'Other Loan';
            mycs.ExpiresInDays__c = 1;
            mycs.GracePeriod__c = 1;
            insert mycs;
        }
        mycs = GracePeriod__c.getValues('Auto Vehicle');
        if (mycs == null)
        {
            mycs = new GracePeriod__c();
            mycs.Name = 'Auto Vehicle';
            mycs.ExpiresInDays__c = 1;
            mycs.GracePeriod__c = 1;
            insert mycs;
        }
          mycs = GracePeriod__c.getValues('Earn More');
        if (mycs == null)
        {
            mycs = new GracePeriod__c();
            mycs.Name = 'Earn More';
            mycs.ExpiresInDays__c = 1;
            mycs.GracePeriod__c = 1;
            insert mycs;
        }
        mycs = GracePeriod__c.getValues('Extend Benifits');
        if (mycs == null)
        {
            mycs = new GracePeriod__c();
            mycs.Name = 'Extend Benifits';
            mycs.ExpiresInDays__c = 1;
            mycs.GracePeriod__c = 1;
            insert mycs;
        }
        
    }

}