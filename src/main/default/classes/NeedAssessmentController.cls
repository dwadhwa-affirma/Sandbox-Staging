public class NeedAssessmentController
{


    public NeedAssessmentController CTRL { get; set; }
    public string accId2 { get; set; }
	public boolean MemberAbove18 {get;set;}
	
	public boolean Expired { get; set; }
    public string OtherTabClass;
    public string HousingTabClass;
    public string CurrentFeedbackTabClass;
    public string MoveYourMoneyTabClass;
    public string WidthdrawalTabClass;
    public string ContactPreferenceTabClass;
    public string OtherLoanTabClass;
    public string PrimaryTransactionTabClass;
    public string MakingDepositsTabClass;
    public string SFATMNetworkTabClass;
    public string SharedBranchingTabClass;
    public string AutoVehicleTabClass;
    public string EarnMoreTabClass;
    public string ExtendBenifitsTabClass;


    public integer OtherMilestoneDuePeriod { get; set; }
    public integer HousingDuePeriod { get; set; }
    public integer CurrentFeedbackDuePeriod { get; set; }
    public integer MoveYourMOneyDuePeriod { get; set; }
    public integer WithdrawalDuePeriod { get; set; }
    public integer ContactPreferenceDuePeriod { get; set; }
    public integer OtherLoanDuePeriod { get; set; }
    public integer PrimaryTransactionDuePeriod { get; set; }
    public integer MakingDepositsDuePeriod { get; set; }
    public integer AutoVehicleDuePeriod { get; set; }
    public integer EarnMoreDuePeriod { get; set; }
	public integer ExtendBenifitsPeriod { get; set; }



    public integer SFATMNetworkDuePeriod { get; set; }
    public integer SharedBranchingDuePeriod { get; set; }

	public boolean ShowData {get;set;}
    public boolean ShowSaveButton { get; set; }
    public List<Account> account;

    public Account accountFirst;

    public Account act;
    public list<Account_Details__c> accList { get; set; }
    public Needs_Assesment__c objNeedsAssessment { get; set; }

    public boolean PrimaryAccountWithAtleastoneTrust { get; set; }
    




    public Account getaccountFirst()
    {
        if (account != null && account.size() > 0)
        {
            return account[0];
        }
        return new Account();
    }

    public NeedAssessmentController(ApexPages.StandardController crt)
    {
        CTRL = this;
        account = new List<Account>();
        act = (Account)crt.getRecord();
        accId2 = act.id;
        RefreshAccount();
        PrimaryAccountWithAtleastoneTrust = false;
        List<Person_Account__c> paList =     [SELECT Id, Account_Number__c, Account_Number__r.RecType__c, Relationship__c, Account_Number__r.TypeTranslate__c, TypeTranslate__c,
                  Account_Number__r.Name FROM Person_Account__c WHERE PersonID__c =: accId2 and Account_Number__r.RecType__c = 'ACCT'
                                         and(Account_Number__r.TypeTranslate__c != '2-TRUST' or Account_Number__r.TYPE__c != 2) and TypeTranslate__c like '%PRIMARY%' ];


        if (paList.size() > 0)
        {
            PrimaryAccountWithAtleastoneTrust = true;
        }

		MemberAbove18 = true;
		if(account[0].BIRTH_DATE__pc != null)
		{
			
			MemberAbove18 =	account[0].BIRTH_DATE__pc.addyears(18) < System.Today();
		}
		
		

        GracePeriod__c data = GracePeriod__c.getValues('NA Other Milestones');
        OtherMilestoneDuePeriod = integer.valueOf(data.ExpiresInDays__c);


        GracePeriod__c dataHosuing = GracePeriod__c.getValues('Housing');
        HousingDuePeriod = integer.valueOf(dataHosuing.ExpiresInDays__c);

        GracePeriod__c dataFeedback = GracePeriod__c.getValues('Current Feedback');
        CurrentFeedbackDuePeriod = integer.valueOf(dataFeedback.ExpiresInDays__c);

        GracePeriod__c dataMoveYourMOneyDuePeriod = GracePeriod__c.getValues('Move Your Money');
        MoveYourMOneyDuePeriod = integer.valueOf(dataMoveYourMOneyDuePeriod.ExpiresInDays__c);

        GracePeriod__c dataWithdrawal = GracePeriod__c.getValues('Withdrawal');
        WithdrawalDuePeriod = integer.valueOf(dataWithdrawal.ExpiresInDays__c);

        GracePeriod__c dataCP = GracePeriod__c.getValues('Contact Preference');
        ContactPreferenceDuePeriod = integer.valueOf(dataCP.ExpiresInDays__c);

        GracePeriod__c dataOL = GracePeriod__c.getValues('Other Loan');
        OtherLoanDuePeriod = integer.valueOf(dataOL.ExpiresInDays__c);

        GracePeriod__c dataPrimaryTransaction = GracePeriod__c.getValues('PrimaryTransaction');
        PrimaryTransactionDuePeriod = integer.valueOf(dataPrimaryTransaction.ExpiresInDays__c);

        GracePeriod__c dataMakingDeposits = GracePeriod__c.getValues('MakingDeposits');
        MakingDepositsDuePeriod = integer.valueOf(dataMakingDeposits.ExpiresInDays__c);

        GracePeriod__c dataATmNetwork = GracePeriod__c.getValues('ATM Network');
        SFATMNetworkDuePeriod = integer.valueOf(dataATmNetwork.ExpiresInDays__c);

        GracePeriod__c dataShared = GracePeriod__c.getValues('Shared Branching');
        SharedBranchingDuePeriod = integer.valueOf(dataShared.ExpiresInDays__c);
        
         GracePeriod__c dataAutoVehicle = GracePeriod__c.getValues('Auto Vehicle');
        AutoVehicleDuePeriod = integer.valueOf(dataAutoVehicle.ExpiresInDays__c);
        
        
		GracePeriod__c dataEarnMore = GracePeriod__c.getValues('Earn More');
        EarnMoreDuePeriod = integer.valueOf(dataEarnMore.ExpiresInDays__c);
        
        GracePeriod__c dataExtendBenifitsPeriod = GracePeriod__c.getValues('Extend Benifits');
        ExtendBenifitsPeriod = integer.valueOf(dataExtendBenifitsPeriod.ExpiresInDays__c);
        
        //query Need assesment to feed the NeedAssessment method that needs to be called in the controller
        List<Needs_Assesment__c> na = [select id,LEEM_Last_Updated_On__c, LEMQ_Last_Updated_On__c,LEOM_Last_Updated_On__c,LEAV_Last_Updated_On__c ,LESF_Last_Updated_On__c, LESB_Last_Updated_On__c, LEMD_Last_Updated_On__c, LECP_Last_Updated_On__c, LEHS_Last_Updated_On__c, LEOL_Last_Updated_On__c, LECF_Last_Updated_On__c, LEWS_Last_Updated_On__c, LEMP_Last_Updated_On__c, LEPT_Last_Updated_On__c  from Needs_Assesment__c where Member__c =: accId2 limit 1];
        if (na.size() > 0)
        {
            objNeedsAssessment = na[0];
        }
        
        
        CheckMembership();
        NeedAssessmentMessage();
      
    }
    
    public void CheckMembership()
    {
    	
		      //Declaring a Set as we don't want Duplicate Group Ids
			Set<Id> results = new Set<Id>();
			
			///Declaring a Map for Group with Role
			Map<Id,Id> grRoleMap = new Map<Id,Id>();
			
			//Populating the Map with RelatedID(i.e.UserRoledId) as Key
			for(Group gr : [select id,relatedid,name from Group])
			{
				grRoleMap.put(gr.relatedId,gr.id);
			}
			
			//Groups directly associated to user
			Set<Id> groupwithUser = new Set<Id>();
			
			//Populating the Group with User with GroupId we are filtering only  for Group of Type Regular,Role and RoleAndSubordinates
			for(GroupMember  u :[select groupId from GroupMember where UserOrGroupId=:UserInfo.getUserId() and (Group.Type = 'Regular' OR Group.Type='Role' OR Group.Type='RoleAndSubordinates')])
			{
				groupwithUser.add(u.groupId);
			}
			
			//Groups with Role
			for(User  u :[select UserRoleId from User where id=:UserInfo.getUserId()])
			{
				//Checking if the current User Role is part of Map or not
				if(grRoleMap.containsKey(u.UserRoleId))
				{
					results.add(grRoleMap.get(u.UserRoleId));
				}
			}
			//Combining both the Set
			results.addAll(groupwithUser);
			
			//Traversing the whole list of Groups to check any other nested Group
			Map<Id,Id> grMap = new Map<Id,Id>();
			for(GroupMember gr : [select id,UserOrGroupId,Groupid from GroupMember where
			        (Group.Type = 'Regular' OR Group.Type='Role' OR Group.Type='RoleAndSubordinates')])
			{
				grMap.put(gr.UserOrGroupId,gr.Groupid);
			}
			for(Id i :results)
			{
				if(grMap.containsKey(i))
				{
					results.add(grMap.get(i));
				}
			}
			
			
			system.debug('########' + results);
			  
        	ShowData = false;
  		
  		
		list<GroupMember> listNamegroup =	[select group.developerName from GroupMember where UserOrGroupId in: results];
		set<string> listName = new set<string>();
			for(GroupMember i :listNamegroup)
			{
				
					listName.add(i.group.developerName );
				
			}
			
			system.debug('########' + listName);
		   
		      if (listName.contains('NA_Auth')) {
		           ShowData = true;
		      }
		     
		     
		     
		     Set<String> groupNames = new Set<String>();
		   for (GroupMember gm : [select 
		                             group.name,
		                             group.DeveloperName 
		                          from GroupMember 
		                          where UserOrGroupId = :UserInfo.getUserId()]) {
		       groupNames.add(gm.group.DeveloperName);
		   }
			
			system.debug('groupNames---' + groupNames);
		   
		      if (groupNames.contains('NA_Auth')) {
		           ShowData = true;
		      }
		     
		      
		    system.debug('########1111' + results);  
		    
    }
    
    public void NeedAssessmentMessage()
    {
    	         
        Expired = false;
        if (objNeedsAssessment == null)
        {
        	Expired= true;
        	return;
        }
        if(GetTabStatus(objNeedsAssessment.LEHS_Last_Updated_On__c,account[0].NA_LEHS_Complete__c, 'Housing' ) && 
        GetTabStatus(objNeedsAssessment.LEOM_Last_Updated_On__c,account[0].NA_LEOM_Complete__c, 'NA Other Milestones')
        	&& GetTabStatus(objNeedsAssessment.LEWS_Last_Updated_On__c,account[0].NA_LEWS_Complete__c, 'Withdrawal') 
        	&& GetTabStatus(objNeedsAssessment.LEMP_Last_Updated_On__c,account[0].NA_LEMP_Complete__c, 'Move Your Money')
        	&& GetTabStatus(objNeedsAssessment.LECF_Last_Updated_On__c,account[0].NA_LECF_Complete__c, 'Current Feedback') 
        	&& GetTabStatus(objNeedsAssessment.LESF_Last_Updated_On__c,account[0].NA_LESF_Complete__c, 'ATM Network')
        	&& GetTabStatusTime(objNeedsAssessment.LESB_Last_Updated_On__c,account[0].NA_LESB_Complete__c, 'Shared Branching') 
        	&& GetTabStatus(objNeedsAssessment.LECP_Last_Updated_On__c,account[0].NA_LECP_Complete__c, 'Contact Preference')
        	&& GetTabStatus(objNeedsAssessment.LEPT_Last_Updated_On__c,account[0].NA_LEPT_Complete__c, 'PrimaryTransaction') 
        	&& GetTabStatus(objNeedsAssessment.LEMD_Last_Updated_On__c,account[0].NA_LEMD_Complete__c, 'MakingDeposits')
        	&& GetTabStatus(objNeedsAssessment.LEOL_Last_Updated_On__c,account[0].NA_LEOL_Complete__c, 'Other Loan') 
        	&& GetTabStatusTime(objNeedsAssessment.LEAV_Last_Updated_On__c,account[0].NA_LEAV_Complete__c, 'Auto Vehicle')
			&& GetTabStatus(objNeedsAssessment.LEEM_Last_Updated_On__c,account[0].NA_LEEM_Complete__c, 'Earn More') 
			&& GetTabStatusTime(objNeedsAssessment.LEMQ_Last_Updated_On__c,account[0].NA_LEMQ_Complete__c, 'Extend Benifits')
        
        	 )
        {
        	Expired = true; 
        }
    }
    
    public boolean Eligibility {get;set;}
    
    public Boolean GetEligibility()
    {
    	if(PrimaryAccountWithAtleastoneTrust && MemberAbove18)
    	{
    		Eligibility = true;
    		return true;
    	}
    	Eligibility = false;
    	return false;
    }

    public void Page_Load()
    {
        List<Needs_Assesment__c> na = [select id,LEEM_Last_Updated_On__c, LEMQ_Last_Updated_On__c,LEOM_Last_Updated_On__c,LEAV_Last_Updated_On__c ,LESF_Last_Updated_On__c, LESB_Last_Updated_On__c, LEMD_Last_Updated_On__c, LECP_Last_Updated_On__c, LEHS_Last_Updated_On__c, LEOL_Last_Updated_On__c, LECF_Last_Updated_On__c, LEWS_Last_Updated_On__c, LEMP_Last_Updated_On__c, LEPT_Last_Updated_On__c  from Needs_Assesment__c where Member__c =: accId2 limit 1];
        if (na.size() > 0)
        {
            objNeedsAssessment = na[0];
        }
        else
        {
            objNeedsAssessment = new Needs_Assesment__c();
            objNeedsAssessment.Member__c = accId2;
            //insert objNeedsAssessment; 
        } 
        GetOtherTabClass();
        GetHousingTabClass();
		
        return;
    }
    public void RefreshAccount()
    {
	List<Needs_Assesment__c> na = [select id, LEOM_Last_Updated_On__c,LEAV_Last_Updated_On__c ,LESF_Last_Updated_On__c, 
			LESB_Last_Updated_On__c, LEMD_Last_Updated_On__c, LECP_Last_Updated_On__c, LEEM_Last_Updated_On__c,
			LEHS_Last_Updated_On__c, LEOL_Last_Updated_On__c, LECF_Last_Updated_On__c, LEWS_Last_Updated_On__c, LEMQ_Last_Updated_On__c,
			LEMP_Last_Updated_On__c, LEPT_Last_Updated_On__c  from Needs_Assesment__c where Member__c =: accId2 limit 1];
        if (na.size() > 0)
        {
            objNeedsAssessment = na[0];
        }
       

        account = [select Id,BIRTH_DATE__pc, Last_NA_LEHS__c, Last_NA_LEOM__c, NA_LEHS_Complete__c, NA_LEWS_Complete__c, NA_Opt_Out_Updated__c,
                                     NA_LEMP_Complete__c, NA_LECF_Complete__c, NA_LEOM_Complete__c, NA_Opt_Out_Date__c, NA_LESF_Complete__c, NA_LESB_Complete__c,
                                     NA_LEHS_Expired__c, NA_LEOM_Expired__c, NA_Eligibility__c, NA_Opt_Out__c, NA_LECP_Complete__c, NA_LEPT_Complete__c, NA_LEMD_Complete__c,
                                     NA_LEOL_Complete__c,NA_LEAV_Complete__c,NA_LEEM_Complete__c,NA_LEMQ_Complete__c
 

                      from Account
 
                     where id =: accId2 limit 1];
                     
                     
    }


    /////// Added by JFranklin 20170614  ////////////
    public String selectedNaSection { get; set; }

    public List<SelectOption> getListNaSection()
    {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('1', 'Provide Feedback about your current experience'));
        options.add(new SelectOption('2', 'Finance your key life events'));
        options.add(new SelectOption('3', 'Optimize how you move your money'));
        options.add(new SelectOption('4', 'Earn more from your savings'));
        options.add(new SelectOption('5', 'Extend the benefits of membership'));
        return options;
    }



	/////// Added by JFranklin 20170816  ///////////////
	/////// Check to see if current user is in an authorized public group to access the Needs Assessment UI
	public String naAuth { get; set; }
    public void getNaAuth()
    {
	List<GroupMember> lstgroupmember = [Select UserOrGroupId, Group.Type, GroupId 
	                                     From GroupMember
	                                    where Group.type = 'Regular' 
	                                      AND UserOrGroupId='00G7A000001La5F' LIMIT 1];
        if (lstgroupmember.size() > 0)
        {
            naAuth = 'true';
        } else {
        	naAuth = 'false';
        }       
                     
    }


   
    private String GetResourceURL(String resourceName)
    {

        // Fetching the resource
        List<StaticResource> resourceList = [SELECT Name, NamespacePrefix, SystemModStamp FROM StaticResource WHERE Name = :resourceName];

        // Checking if the result is returned or not
        if (resourceList.size() == 1)
        {

            // Getting namespace
            String namespace = resourceList[0].NamespacePrefix;
               // Resource URL
               return '/resource/' + resourceList[0].SystemModStamp.getTime() + '/' + (namespace != null && namespace != '' ? namespace + '__' : '') + resourceName; 
            }
            else return '';
        }

private string GetLowestColor(Set<string> listColors)
{
    if (listColors.contains(''))
    {
        return 'naButtonGray';
    }
    if (listColors.contains('optOutTab'))
    {
        return 'naButtonGray';
    }
    if (listColors.contains('expiredTab'))
    {
        return 'naButtonRed';
    }
    if (listColors.contains('partialTab'))
    {
        return 'naButtonYellow';
    }
    if (listColors.contains('completeTab'))
    {
        return 'naButtonGreen';
    }
    return '';
}

public string GetOtherTabClass()
{

    OtherTabClass = '';
if (account[0].NA_Opt_Out__c)
    {
        OtherTabClass = 'optOutTab';
    }
	else if(objNeedsAssessment.LEOM_Last_Updated_On__c == null)
	{
		OtherTabClass = 'expiredTab';
	}
    
    else if (account[0].NA_LEOM_Complete__c && objNeedsAssessment.LEOM_Last_Updated_On__c != null && objNeedsAssessment.LEOM_Last_Updated_On__c + OtherMilestoneDuePeriod < Date.today())
    {
        OtherTabClass = 'expiredTab';
    }
    else if (account[0].NA_LEOM_Complete__c)
    {
        OtherTabClass = 'completeTab';
    }
    else if (!account[0].NA_LEOM_Complete__c)
    {
        OtherTabClass = 'partialTab';
    }


    return OtherTabClass;

}


public string GetEarnMoreTabClass()
{

    EarnMoreTabClass = '';
if (account[0].NA_Opt_Out__c)
    {
        EarnMoreTabClass = 'optOutTab';
    }
	else if(objNeedsAssessment.LEEM_Last_Updated_On__c == null)
	{
		EarnMoreTabClass = 'expiredTab';
	}
    
    else if (account[0].NA_LEEM_Complete__c && objNeedsAssessment.LEEM_Last_Updated_On__c != null && objNeedsAssessment.LEEM_Last_Updated_On__c + EarnMoreDuePeriod < Date.today())
    {
        EarnMoreTabClass = 'expiredTab';
    }
    else if (account[0].NA_LEEM_Complete__c)
    {
        EarnMoreTabClass = 'completeTab';
    }
    else if (!account[0].NA_LEEM_Complete__c)
    {
        EarnMoreTabClass = 'partialTab';
    }


    return EarnMoreTabClass;

}

      
        
        
        
        
public string GetAutoVehicleTabClass()
{

    AutoVehicleTabClass = '';

	
    if (account[0].NA_Opt_Out__c)
    {
        AutoVehicleTabClass = 'optOutTab';
    }
    else if(objNeedsAssessment.LEAV_Last_Updated_On__c == null)
	{
		AutoVehicleTabClass = 'expiredTab';
	}
    else if (account[0].NA_LEAV_Complete__c && objNeedsAssessment.LEAV_Last_Updated_On__c != null && objNeedsAssessment.LEAV_Last_Updated_On__c + AutoVehicleDuePeriod < Date.today())
    {
        AutoVehicleTabClass = 'expiredTab';
    }
    else if (account[0].NA_LEAV_Complete__c)
    {
        AutoVehicleTabClass = 'completeTab';
    }
    else if (!account[0].NA_LEAV_Complete__c)
    {
        AutoVehicleTabClass = 'partialTab';
    }


    return AutoVehicleTabClass;

}
        

public string GetHousingTabClass()
{

    HousingTabClass = '';
    if (account[0].NA_Opt_Out__c)
    {
        HousingTabClass = 'optOutTab';
    }
	
    else  if(objNeedsAssessment.LEHS_Last_Updated_On__c == null)
	{
		HousingTabClass = 'expiredTab';
	}
    else if (account[0].NA_LEHS_Complete__c && objNeedsAssessment.LEHS_Last_Updated_On__c != null && objNeedsAssessment.LEHS_Last_Updated_On__c + HousingDuePeriod < Date.today())
    {
        HousingTabClass = 'expiredTab';
    }
    else if (account[0].NA_LEHS_Complete__c)
    {
        HousingTabClass = 'completeTab';
    }
    else if (!account[0].NA_LEHS_Complete__c)
    {
        HousingTabClass = 'partialTab';
    }


    return HousingTabClass;

}

public string GetCurrentFeedbackTabClass()
{

    CurrentFeedbackTabClass = '';
    if (account[0].NA_Opt_Out__c)
    {
        CurrentFeedbackTabClass = 'optOutTab';
    }
	
    else if(objNeedsAssessment.LECF_Last_Updated_On__c == null)
	{
		CurrentFeedbackTabClass = 'expiredTab';
	} 
    else if (account[0].NA_LECF_Complete__c && objNeedsAssessment.LECF_Last_Updated_On__c != null && objNeedsAssessment.LECF_Last_Updated_On__c + CurrentFeedbackDuePeriod < Date.today())
    {
        CurrentFeedbackTabClass = 'expiredTab';
    }
    else if (account[0].NA_LECF_Complete__c)
    {
        CurrentFeedbackTabClass = 'completeTab';
    }
    else if (!account[0].NA_LECF_Complete__c)
    {
        CurrentFeedbackTabClass = 'partialTab';
    }


    return CurrentFeedbackTabClass;

}



public string GetMoveYourMoneyTabClass()
{

    MoveYourMoneyTabClass = '';
    if (account[0].NA_Opt_Out__c)
    {
        MoveYourMoneyTabClass = 'optOutTab';
    }
	else if(objNeedsAssessment.LEMP_Last_Updated_On__c == null)
	{
		MoveYourMoneyTabClass = 'expiredTab';
	}
     
    else if (account[0].NA_LEMP_Complete__c && objNeedsAssessment.LEMP_Last_Updated_On__c != null && objNeedsAssessment.LEMP_Last_Updated_On__c + MoveYourMOneyDuePeriod < Date.today())
    {
        MoveYourMoneyTabClass = 'expiredTab';
    }
    else if (account[0].NA_LEMP_Complete__c)
    {
        MoveYourMoneyTabClass = 'completeTab';
    }
    else if (!account[0].NA_LEMP_Complete__c)
    {
        MoveYourMoneyTabClass = 'partialTab';
    }


    return MoveYourMoneyTabClass;

}

public string GetWidthdrawalTabClass()
{

    WidthdrawalTabClass = '';
    if (account[0].NA_Opt_Out__c)
    {
        WidthdrawalTabClass = 'optOutTab';
    }
	else if(objNeedsAssessment.LEWS_Last_Updated_On__c == null)
	{
		WidthdrawalTabClass = 'expiredTab';
	}
    
    else if (account[0].NA_LEWS_Complete__c && objNeedsAssessment.LEWS_Last_Updated_On__c != null && objNeedsAssessment.LEWS_Last_Updated_On__c + WithdrawalDuePeriod < Date.today())
    {
        WidthdrawalTabClass = 'expiredTab';
    }
    else if (account[0].NA_LEWS_Complete__c)
    {
        WidthdrawalTabClass = 'completeTab';
    }
    else if (!account[0].NA_LEWS_Complete__c)
    {
        WidthdrawalTabClass = 'partialTab';
    }


    return WidthdrawalTabClass;

}



public string GetContactPreferenceTabClass()
{

    ContactPreferenceTabClass = '';
	
    if (account[0].NA_Opt_Out__c)
    {
        ContactPreferenceTabClass = 'optOutTab';
    }
    else if(objNeedsAssessment.LECP_Last_Updated_On__c == null)
	{
		ContactPreferenceTabClass = 'expiredTab';
	}
    else if (account[0].NA_LECP_Complete__c && objNeedsAssessment.LECP_Last_Updated_On__c != null && objNeedsAssessment.LECP_Last_Updated_On__c + ContactPreferenceDuePeriod < Date.today())
    {
        ContactPreferenceTabClass = 'expiredTab';
    }
    else if (account[0].NA_LECP_Complete__c)
    {
        ContactPreferenceTabClass = 'completeTab';
    }
    else if (!account[0].NA_LECP_Complete__c)
    {
        ContactPreferenceTabClass = 'partialTab';
    }


    return ContactPreferenceTabClass;

}


public string GetOtherLoanTabClass()
{

    OtherLoanTabClass = '';
    if (account[0].NA_Opt_Out__c)
    {
        OtherLoanTabClass = 'optOutTab';
    }
    
	else if(objNeedsAssessment.LEOL_Last_Updated_On__c == null)
	{
		OtherLoanTabClass = 'expiredTab';
	}
         else if (account[0].NA_LEOL_Complete__c && objNeedsAssessment.LEOL_Last_Updated_On__c != null && objNeedsAssessment.LEOL_Last_Updated_On__c + OtherLoanDuePeriod < Date.today())
    {
        OtherLoanTabClass = 'expiredTab';
    }
    else if (account[0].NA_LEOL_Complete__c)
    {
        OtherLoanTabClass = 'completeTab';
    }
    else if (!account[0].NA_LEOL_Complete__c)
    {
        OtherLoanTabClass = 'partialTab';
    }

system.debug('OtherLoanTabClass--------' + OtherLoanTabClass);
    return OtherLoanTabClass;

}
public string GetPrimaryTransactionTabClass()
{

    PrimaryTransactionTabClass = '';
	
	system.debug('GetPrimaryTransactionTabClass---NA_LEPT_Complete__c' + account[0].NA_LEPT_Complete__c);
	system.debug('GetPrimaryTransactionTabClass---LEPT_Last_Updated_On__c' + objNeedsAssessment.LEPT_Last_Updated_On__c);
	system.debug('GetPrimaryTransactionTabClass---PrimaryTransactionDuePeriod' + PrimaryTransactionDuePeriod);
	
     if (account[0].NA_Opt_Out__c)
    {
        PrimaryTransactionTabClass = 'optOutTab';
    }
    else if(objNeedsAssessment.LEPT_Last_Updated_On__c == null)
	{
		PrimaryTransactionTabClass = 'expiredTab';
	}
    else if (account[0].NA_LEPT_Complete__c && objNeedsAssessment.LEPT_Last_Updated_On__c != null && objNeedsAssessment.LEPT_Last_Updated_On__c + PrimaryTransactionDuePeriod < Date.today())
    {
        PrimaryTransactionTabClass = 'expiredTab';
    }
    else if (account[0].NA_LEPT_Complete__c)
    {
        PrimaryTransactionTabClass = 'completeTab';
    }
    else if (!account[0].NA_LEPT_Complete__c)
    {
        PrimaryTransactionTabClass = 'partialTab';
    }


    return PrimaryTransactionTabClass;

}
public string GetMakingDepositsTabClass()
{

    MakingDepositsTabClass = '';
	
     if (account[0].NA_Opt_Out__c)
    {
        MakingDepositsTabClass = 'optOutTab';
    }
    else if(objNeedsAssessment.LEMD_Last_Updated_On__c == null)
	{
		MakingDepositsTabClass = 'expiredTab';
	}
    else if (account[0].NA_LEMD_Complete__c && objNeedsAssessment.LEMD_Last_Updated_On__c != null && objNeedsAssessment.LEMD_Last_Updated_On__c + MakingDepositsDuePeriod < Date.today())
    {
        MakingDepositsTabClass = 'expiredTab';
    }
    else if (account[0].NA_LEMD_Complete__c)
    {
        MakingDepositsTabClass = 'completeTab';
    }
    else if (!account[0].NA_LEMD_Complete__c)
    {
        MakingDepositsTabClass = 'partialTab';
    }


    return MakingDepositsTabClass;

}



public string GetSFATMNetworkTabClass()
{

    SFATMNetworkTabClass = '';
	if (account[0].NA_Opt_Out__c)
    {
        SFATMNetworkTabClass = 'optOutTab';
    }
    else if(objNeedsAssessment.LESF_Last_Updated_On__c == null)
	{
		SFATMNetworkTabClass = 'expiredTab';
	}
    else if (account[0].NA_LESF_Complete__c && objNeedsAssessment.LESF_Last_Updated_On__c != null && objNeedsAssessment.LESF_Last_Updated_On__c + SFATMNetworkDuePeriod < Date.today())
    {
        SFATMNetworkTabClass = 'expiredTab';
    }
    else if (account[0].NA_LESF_Complete__c)
    {
        SFATMNetworkTabClass = 'completeTab';
    }
    else if (!account[0].NA_LESF_Complete__c)
    {
        SFATMNetworkTabClass = 'partialTab';
    }


    return SFATMNetworkTabClass;

}

public string GetSharedBranchingTabClass()
{

    SharedBranchingTabClass = '';
	
    if (account[0].NA_Opt_Out__c)
    {
        SharedBranchingTabClass = 'optOutTab';
    }
    else if(objNeedsAssessment.LESB_Last_Updated_On__c == null)
	{
		SharedBranchingTabClass = 'expiredTab';
	}
    
    else if (account[0].NA_LESB_Complete__c && objNeedsAssessment.LESB_Last_Updated_On__c != null && objNeedsAssessment.LESB_Last_Updated_On__c + SharedBranchingDuePeriod < Date.today())
    {
        SharedBranchingTabClass = 'expiredTab';
    }
    else if (account[0].NA_LESB_Complete__c)
    {
        SharedBranchingTabClass = 'completeTab';
    }
    else if (!account[0].NA_LESB_Complete__c)
    {
        SharedBranchingTabClass = 'partialTab';
    }


    return SharedBranchingTabClass;

}



public string GetExtendBenifitsTabClass()
{

    ExtendBenifitsTabClass = '';
	
    if (account[0].NA_Opt_Out__c)
    {
        ExtendBenifitsTabClass = 'optOutTab';
    }
    else if(objNeedsAssessment.LEMQ_Last_Updated_On__c == null)
	{
		ExtendBenifitsTabClass = 'expiredTab';
	}
    
    else if (account[0].NA_LEMQ_Complete__c && objNeedsAssessment.LEMQ_Last_Updated_On__c != null && objNeedsAssessment.LEMQ_Last_Updated_On__c + ExtendBenifitsPeriod < Date.today())
    {
        ExtendBenifitsTabClass = 'expiredTab';
    }
    else if (account[0].NA_LEMQ_Complete__c)
    {
        ExtendBenifitsTabClass = 'completeTab';
    }
    else if (!account[0].NA_LEMQ_Complete__c)
    {
        ExtendBenifitsTabClass = 'partialTab';
    }


    return ExtendBenifitsTabClass;

}





public void setselectedNaSection(String selectedNaSection)
{
    this.selectedNaSection = selectedNaSection;
}

public void changeOptOut()
{




    account[0].NA_Opt_Out_Date__c = system.today().adddays(365);
    update account[0];


}
public string GetFeedBackAboutCurrentExperience()
{
    Set<string> listTab = new Set<string>();
    listTab.add(GetContactPreferenceTabClass());
    listTab.add(GetCurrentFeedbackTabClass());
    
    string radioColor = GetLowestColor(listTab);
    
    string URLButton = GetResourceURL(radioColor);
    
    return URLButton;
}

public string GetFinanceKeyFileEvent()
{
    Set<string> listTab = new Set<string>();
    listTab.add(GetContactPreferenceTabClass());
    listTab.add(GetHousingTabClass());
    listTab.add(GetOtherLoanTabClass());
    listTab.add(GetOtherTabClass());
    
    string radioColor = GetLowestColor(listTab);
    
    string URLButton = GetResourceURL(radioColor);
    
    return URLButton;
}


public string GetOptimizeMoveYourMoney()
{
    Set<string> listTab = new Set<string>();
    listTab.add(GetContactPreferenceTabClass());
    listTab.add(GetMoveYourMoneyTabClass());
    listTab.add(GetMakingDepositsTabClass());
    listTab.add(GetWidthdrawalTabClass());
    listTab.add(GetSharedBranchingTabClass());
    listTab.add(GetSFATMNetworkTabClass());
    listTab.add(GetPrimaryTransactionTabClass());
	system.debug('listTab-----' + listTab);
    string radioColor = GetLowestColor(listTab);
	system.debug('radioColor-----' + radioColor);
    string URLButton = GetResourceURL(radioColor);

    return URLButton;
}


public string GetEarnMore()
{
    Set<string> listTab = new Set<string>();
    listTab.add(GetEarnMoreTabClass());
    
	string radioColor = GetLowestColor(listTab);
    string URLButton = GetResourceURL(radioColor);

    return URLButton;
}

public string GetExtendBenifits()
{
    Set<string> listTab = new Set<string>();
    listTab.add(GetExtendBenifitsTabClass());
    
	string radioColor = GetLowestColor(listTab);
    string URLButton = GetResourceURL(radioColor);

    return URLButton;
}

public boolean GetTabStatus(Date updatedDate, boolean complete, string due)
	{
		GracePeriod__c dataHosuing = GracePeriod__c.getValues(due);
		
        HousingDuePeriod = integer.valueOf(dataHosuing.ExpiresInDays__c);
		
	    boolean TabExpired = false;
		if (account[0].NA_Opt_Out__c)
	    {
	        TabExpired = false;
	    }
		else if(updatedDate == null)
		{
			TabExpired = true;
		}
	    
	    else if (complete && updatedDate != null && updatedDate + HousingDuePeriod < Date.today())
	    {
	        TabExpired = true;
	    }
	 	system.debug('due---' + due);
	 	system.debug('TabExpired---' + TabExpired);
		return TabExpired;

	}
	
		public boolean GetTabStatusTime(DateTime updatedDate, boolean complete, string due)
	{
		GracePeriod__c dataHosuing = GracePeriod__c.getValues(due);
        HousingDuePeriod = integer.valueOf(dataHosuing.ExpiresInDays__c);
		
	    boolean TabExpired = false;
		if (account[0].NA_Opt_Out__c)
	    {
	        TabExpired = false;
	    }
		else if(updatedDate == null)
		{
			TabExpired = true;
		}
	    
	    else if (complete && updatedDate != null && updatedDate + HousingDuePeriod < Date.today())
	    {
	        TabExpired = true;
	    }
	 
		return TabExpired;
	    

	}



}