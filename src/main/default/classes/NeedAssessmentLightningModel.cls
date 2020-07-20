public class NeedAssessmentLightningModel {
	
	
	public NeedAssessmentLightningModel()
	{
		TabButttonColors = new TabButtonColorModel();
		RadioButttonColors = new RadioButtonColorModel();
	}
	@AuraEnabled
	public Needs_Assesment__c objNeedsAssessment  {get;set;}
	
	@AuraEnabled
	public boolean MemberAbove18  {get;set;}
	
	@AuraEnabled
	public boolean PrimaryAccountWithAtleastoneTrust  {get;set;}
	
	@AuraEnabled
	public boolean ShowData  {get;set;}
	
	@AuraEnabled
	public account AccountDetails  {get;set;}
	
	@AuraEnabled
	public list<NA_Other_Existing_Loans__c> ExistingLoansDetails  {get;set;}
	
	@AuraEnabled
	public list<NA_Membership_Referral_Questions__c> MembershipDetails  {get;set;}
	
	@AuraEnabled
	public list<NA_Deposit__c> DepositDetails  {get;set;}
	
 	@AuraEnabled
 	public TabButtonColorModel TabButttonColors  {get;set;}
 	
 	@AuraEnabled
 	public RadioButtonColorModel RadioButttonColors  {get;set;}
 	
 	
	public class TabButtonColorModel
	{		
		@AuraEnabled
	 	public string ContactPreferenceTabClass {get;set;}
	 	
	 	@AuraEnabled
	 	public string CurrentFeedbackTabClass {get;set;}
	 	
	 	@AuraEnabled	 	
	 	public string HousingTabClass {get;set;}
	 	
	 	
	 	@AuraEnabled
	 	public string OtherLoanTabClass {get;set;}
	 	
	 	@AuraEnabled
	 	public string OtherTabClass {get;set;}
	 	
	 	@AuraEnabled
	 	public string MoveYourMoneyTabClass {get;set;}
	 	
	 	@AuraEnabled
	 	public string MakingDepositsTabClass {get;set;}
	 	
	 	@AuraEnabled
	 	public string WidthdrawalTabClass {get;set;}	 	
	 	
	 	@AuraEnabled
	 	public string SharedBranchingTabClass {get;set;}
	 	
	 	@AuraEnabled
	 	public string SFATMNetworkTabClass {get;set;}
	 	
	 	@AuraEnabled
	 	public string PrimaryTransactionTabClass {get;set;}
	 	
	 	@AuraEnabled
	 	public string EarnMoreTabClass {get;set;}	 
	 	
	 	@AuraEnabled
	 	public string ExtendBenifitsTabClass {get;set;}	 
	 	
	 	@AuraEnabled
	 	public string AutoVehicleTabClass {get;set;}
	 		
	 	
	}
 	public class RadioButtonColorModel
	{
		
		 @AuraEnabled
	 	public string FeedBackAboutCurrentExperience {get;set;}
	 	
	 	@AuraEnabled
	 	public string FinanceKeyFileEvent {get;set;}
	 	
	 	@AuraEnabled
	 	public string OptimizeMoveYourMoney {get;set;}
	 	
	 	@AuraEnabled
	 	public string EarnMore {get;set;}	 	
	 	
	 	@AuraEnabled
	 	public string ExtendBenifits {get;set;}	 	
	 	
	}
}