@isTest

private class NeedAssessmentLightningModelTest
{
//Initial Test Data
//Add Logic to Create data required
static NeedAssessmentLightningModel instance = null;
static void SetUp(){
test.StartTest();
instance = new NeedAssessmentLightningModel();

}
//Tear Down 
//Add Logic to delete data that has been created
static void TearDown(){
test.StopTest();
}

public static testmethod void Test_AllContructors(){
SetUp();
NeedAssessmentLightningModel instance1 = new NeedAssessmentLightningModel();

TearDown();
}
public static testmethod void Test_AllProperties(){
SetUp();
// Test Property: objNeedsAssessment
instance.objNeedsAssessment = new Needs_Assesment__c();
System.Assert(instance.objNeedsAssessment != null);

// Test Property: AccountDetails
instance.AccountDetails = new account();
System.Assert(instance.AccountDetails != null);

// Test Property: ExistingLoansDetails
instance.ExistingLoansDetails = new list<NA_Other_Existing_Loans__c>();
System.Assert(instance.ExistingLoansDetails != null);

// Test Property: MembershipDetails
instance.MembershipDetails = new list<NA_Membership_Referral_Questions__c>();
System.Assert(instance.MembershipDetails != null);

// Test Property: DepositDetails
instance.DepositDetails = new list<NA_Deposit__c>();
System.Assert(instance.DepositDetails != null);

// Test Property: TabButttonColors
//instance.TabButttonColors = new TabButtonColorModel();
System.Assert(instance.TabButttonColors != null);

// Test Property: RadioButttonColors
//instance.RadioButttonColors = new RadioButtonColorModel();
System.Assert(instance.RadioButttonColors != null);
   string str = new  NeedAssessmentLightningModel.TabButtonColorModel().ContactPreferenceTabClass;
  string str1 = new  NeedAssessmentLightningModel.TabButtonColorModel().CurrentFeedbackTabClass;
    string str2 = new  NeedAssessmentLightningModel.TabButtonColorModel().HousingTabClass;
    string str3 = new  NeedAssessmentLightningModel.TabButtonColorModel().OtherLoanTabClass;
    string str4 = new  NeedAssessmentLightningModel.TabButtonColorModel().OtherTabClass;
    string str5 = new  NeedAssessmentLightningModel.TabButtonColorModel().MoveYourMoneyTabClass;
  string str6 = new  NeedAssessmentLightningModel.TabButtonColorModel().MakingDepositsTabClass;
    string str7 = new  NeedAssessmentLightningModel.TabButtonColorModel().WidthdrawalTabClass;
    string str8 = new  NeedAssessmentLightningModel.TabButtonColorModel().SharedBranchingTabClass;
    string str9 = new  NeedAssessmentLightningModel.TabButtonColorModel().SFATMNetworkTabClass;
    
    string str10 = new  NeedAssessmentLightningModel.TabButtonColorModel().PrimaryTransactionTabClass;
    string str11 = new  NeedAssessmentLightningModel.TabButtonColorModel().EarnMoreTabClass;
    string str12 = new  NeedAssessmentLightningModel.TabButtonColorModel().ExtendBenifitsTabClass;
    string str13 = new  NeedAssessmentLightningModel.TabButtonColorModel().AutoVehicleTabClass;
    
    
     str10 = new  NeedAssessmentLightningModel.RadioButtonColorModel().FeedBackAboutCurrentExperience;
     str11 = new  NeedAssessmentLightningModel.RadioButtonColorModel().FinanceKeyFileEvent;
     str12 = new  NeedAssessmentLightningModel.RadioButtonColorModel().OptimizeMoveYourMoney;
     str13 = new  NeedAssessmentLightningModel.RadioButtonColorModel().EarnMore;
     str13 = new  NeedAssessmentLightningModel.RadioButtonColorModel().ExtendBenifits;
    
    
    
TearDown();
}
}