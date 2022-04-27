public class MemberInfoController {
    
    @AuraEnabled
    public static AccountViewModel GetMemberInfomation(Id accountId){
        System.debug('accountId:'+accountId);
        Account acc = [SELECT Id,Employee_Restricted_Access__c,Name,BIRTH_DATE__pc,Email_raw__c, PersonEmail, 
                       Mobile_Phone__pc,MemberType__c,CreatedDate
                       FROM Account WHERE 
                       Id=:accountId];
        
        List<Person_Account__c> personAccounts=new List<Person_Account__c>();
        personAccounts= [SELECT Id,PersonID__c,Account_Number__c,TypeTranslate__c,
                         Account_Number__r.OPEN_DATE__c,Account_Number__r.Open_Date_PST__c,
                         Account_Number__r.RecType__c
                         FROM Person_Account__c 
                         WHERE PersonID__c=: accountId and Account_Number__r.RecType__c='ACCT' and TypeTranslate__c!='0004/Beneficiary'
                         Order By Account_Number__r.OPEN_DATE__c
                         Limit 1];
        
        DateTime openDate;
        if(personAccounts.size()>0){
            openDate=personAccounts[0].Account_Number__r.Open_Date_PST__c;
        }
        
        Integer joiningDaysDiff =0;
        Integer joiningDaysDiff2 =0;
        Integer joiningDaysDiff1 =0;
        
        if(openDate!=null){
            joiningDaysDiff = date.newinstance(openDate.year(), openDate.month(), openDate.day()).daysBetween(Date.today());
            joiningDaysDiff2 = date.newinstance(openDate.year(), openDate.month(), openDate.day()).monthsBetween(Date.today());
            joiningDaysDiff1=joiningDaysDiff2/12;
            if(joiningDaysDiff<=365)
            {
                system.debug('joiningDaysDiff'+joiningDaysDiff);
            }
            else if(joiningDaysDiff>365){
                system.debug('joiningDaysDiff'+joiningDaysDiff1);
            }
        }
        Integer daysDiffBetwBirthAndToday=0;
        Integer daysDiffBetwThisYearBirthAndBirthDate=0;
        Integer birthDaysDiff= 0;
        if(acc.BIRTH_DATE__pc!=null){
            daysDiffBetwBirthAndToday = date.newinstance(acc.BIRTH_DATE__pc.year(), acc.BIRTH_DATE__pc.month(), acc.BIRTH_DATE__pc.day()).daysBetween(Date.today());
            daysDiffBetwThisYearBirthAndBirthDate = date.newinstance(acc.BIRTH_DATE__pc.year(), acc.BIRTH_DATE__pc.month(), acc.BIRTH_DATE__pc.day()).daysBetween(date.newinstance(Date.today().year(), acc.BIRTH_DATE__pc.month(), acc.BIRTH_DATE__pc.day()));
            birthDaysDiff = daysDiffBetwThisYearBirthAndBirthDate - daysDiffBetwBirthAndToday;
        }
        
        AccountViewModel accViewModel = new AccountViewModel();
        accViewModel.Name = acc.Name;
        accViewModel.BirthDate = acc.BIRTH_DATE__pc;
        accViewModel.Email = acc.PersonEmail;
        accViewModel.MobilePhone = acc.Mobile_Phone__pc;
        accViewModel.MemberType = acc.MemberType__c;
        accViewModel.JoiningDaysDiff = joiningDaysDiff;
        accViewModel.JoiningDaysDiff1 = joiningDaysDiff1;
        accViewModel.EmployeeRestrictedAccess=acc.Employee_Restricted_Access__c;
        accViewModel.BirthDaysDiff = birthDaysDiff;  
        
        return accViewModel;
    }
    
    @AuraEnabled
    public static List<Opportunity> GetAvailableOpportunity(Id accountId){
        List<Opportunity> oppList=new List<Opportunity>();
        oppList=[SELECT Id,Name FROM Opportunity WHERE AccountId=:accountId 
                 and (StageName='New' or StageName='Outreach' or StageName='Analyzing Needs' or StageName='Considering' or StageName='Fulfillment')
                 ORDER BY CreatedDate DESC];        
        return oppList;
    }
    
    @AuraEnabled
    public static String GetPromocode(Id accountId){
        
        System.debug('In Promocode ');
        String promoCodes='';
        List<Person_Account__c> personAccounts=new List<Person_Account__c>();
        
        
        personAccounts=[SELECT Id,PersonID__c,Account_Number__c,Account_Number__r.Name,Account_Number__r.PROMO_REPORT_CODE__c 
                        FROM Person_Account__c WHERE PersonID__c=:accountId];
        
        set<string> accountNumbers=new set<string>();
        for(Person_Account__c pc : personAccounts){
            accountNumbers.add(pc.Account_Number__r.Name);
        }
        
        List<Account_Details__c> accountDetails=[SELECT Id,Name,PROMO_REPORT_CODE__c 
                                                 FROM Account_Details__c WHERE PROMO_REPORT_CODE__c<>null 
                                                 AND Name IN: accountNumbers];
        
        System.debug('accountDetails:'+accountDetails);
        
        if(accountDetails.size()==1){
            promoCodes = accountDetails[0].PROMO_REPORT_CODE__c;
        }
        else if(accountDetails.size() > 1){
            personAccounts= [SELECT Id,PersonID__c,Account_Number__c,Account_Number__r.PROMO_REPORT_CODE__c
                             FROM Person_Account__c WHERE Account_Number__r.Name IN : accountNumbers and
                             Account_Number__r.PROMO_REPORT_CODE__c <> null AND TypeTranslate__c  Like '%Primary%' Limit 1];
            
            System.debug('personAccounts:'+personAccounts);
            if(personAccounts.size() > 0){
                promoCodes = personAccounts[0].Account_Number__r.PROMO_REPORT_CODE__c;
            }else{
                promoCodes = accountDetails[0].PROMO_REPORT_CODE__c;
            }
            
        }
        
        return promoCodes;   
        
    }
    
    @AuraEnabled
    public static MaritzCX__Survey_Response__c GetSurveyScore(Id accountId){
        List<MaritzCX__Survey_Response__c> maritzCX = new List<MaritzCX__Survey_Response__c>();
        maritzCX=[SELECT Id,MaritzCX__Key_Metric_1_Bar__c 
                  FROM MaritzCX__Survey_Response__c 
                  WHERE MaritzCX__Account__c=:accountId 
                  Order by CreatedDate DESC LIMIT 1];
        if(maritzCX.size()>0) {
            return maritzCX[0]; 
        }else{
            return null;
        }
    }
    
    @AuraEnabled
    public static List<Case> GetFraudWarnings(Id accountId){
        List<Case> cases=new List<Case>();
        cases=[SELECT Id
               FROM Case 
               WHERE Primary_Category__c='Account Maintenance' 
               and Secondary_Category__c='Special Situations' 
               and Tertiary_Category__c='Unusual Activity' 
               and AccountId=:accountId and Status!='Closed']; 
        
        return cases;
    }
    
    @AuraEnabled
    public static List<WarningsViewModel> GetMemberInfoWarnings(Id accountId) { 
        list<Person_Account__c> paList = [SELECT Id,Account_Number__c, 
                                          Account_Number__r.RecType__c, Account_Number__r.Name 
                                          FROM Person_Account__c 
                                          WHERE PersonID__c =:accountId and TypeTranslate__c !=: '0004/Beneficiary'];
        
        System.debug('pa list'+paList);
        set<String> accountNumberSet = new set<String>();
        set<Id> accIdset = new set<Id>();
        set<String> acctypeSet = new set<String>();
        for(Person_Account__c var: paList){
            accountNumberSet.add(var.Account_Number__r.Name);
            acctypeSet.add(var.Account_Number__r.RecType__c);
            accIdSet.add(var.Account_Number__c);
        }
        list<Account_Details__c> accList = new list<Account_Details__c>();
        if(acctypeSet.contains('ACCT')){
            System.debug('Reached in if condition only');
            accList = [SELECT Id,
                       Name,
                       RecType__c,
                       TypeTranslate__c,
                       ID1__c,
                       Balance__c,
                       WARNING_01_CODE__c,
                       WARNING_02_CODE__c,
                       WARNING_03_CODE__c,
                       WARNING_04_CODE__c,
                       WARNING_05_CODE__c,
                       WARNING_06_CODE__c,
                       WARNING_07_CODE__c,
                       WARNING_08_CODE__c,
                       WARNING_09_CODE__c,
                       WARNING_10_CODE__c,
                       WARNING_11_CODE__c,
                       WARNING_12_CODE__c,
                       WARNING_13_CODE__c,
                       WARNING_14_CODE__c,
                       WARNING_15_CODE__c,
                       WARNING_16_CODE__c,
                       WARNING_17_CODE__c,
                       WARNING_18_CODE__c,
                       WARNING_19_CODE__c,
                       WARNING_20_CODE__c,
                       Combined_Account_ID__c FROM Account_Details__c Where Name IN:accountNumberSet];
        }else{
            accList = [SELECT Id,
                       Name,
                       RecType__c,
                       TypeTranslate__c,
                       ID1__c,
                       Balance__c,
                       WARNING_01_CODE__c,
                       WARNING_02_CODE__c,
                       WARNING_03_CODE__c,
                       WARNING_04_CODE__c,
                       WARNING_05_CODE__c,
                       WARNING_06_CODE__c,
                       WARNING_07_CODE__c,
                       WARNING_08_CODE__c,
                       WARNING_09_CODE__c,
                       WARNING_10_CODE__c,
                       WARNING_11_CODE__c,
                       WARNING_12_CODE__c,
                       WARNING_13_CODE__c,
                       WARNING_14_CODE__c,
                       WARNING_15_CODE__c,
                       WARNING_16_CODE__c,
                       WARNING_17_CODE__c,
                       WARNING_18_CODE__c,
                       WARNING_19_CODE__c,
                       WARNING_20_CODE__c,
                       Combined_Account_ID__c FROM Account_Details__c Where Id IN:accIdSet];
        }
        
        List<WarningsViewModel> wcwList = new List<WarningsViewModel>();
        for(Account_Details__c var: accList){
            if(var.WARNING_01_CODE__c != NULL || var.WARNING_01_CODE__c !='' || var.WARNING_01_CODE__c != '000-NONE' || var.WARNING_01_CODE__c != '0-NONE'){
                WarningsViewModel wcw1 =new WarningsViewModel(var.WARNING_01_CODE__c);
                if(wcw1.isNull != true) {
                    wcwList.add(wcw1);
                }
            }
            if(var.WARNING_02_CODE__c != NULL || var.WARNING_02_CODE__c !='' || var.WARNING_02_CODE__c != '000-NONE' || var.WARNING_02_CODE__c != '0-NONE'){
                WarningsViewModel wcw2 =new WarningsViewModel(var.WARNING_02_CODE__c);
                if(wcw2.isNull != true) {
                    wcwList.add(wcw2);
                }
            }
            if(var.WARNING_03_CODE__c != NULL || var.WARNING_03_CODE__c !='' || var.WARNING_03_CODE__c != '000-NONE' || var.WARNING_03_CODE__c != '0-NONE'){
                WarningsViewModel wcw3 =new WarningsViewModel(var.WARNING_03_CODE__c);
                if(wcw3.isNull != true) {
                    wcwList.add(wcw3);
                }
            }            
            if(var.WARNING_04_CODE__c != NULL || var.WARNING_04_CODE__c !='' || var.WARNING_04_CODE__c != '000-NONE' || var.WARNING_04_CODE__c != '0-NONE'){
                WarningsViewModel wcw4 =new WarningsViewModel(var.WARNING_04_CODE__c);
                if(wcw4.isNull != true) {
                    wcwList.add(wcw4);
                }
            }
            if(var.WARNING_05_CODE__c != NULL || var.WARNING_05_CODE__c !='' || var.WARNING_05_CODE__c != '000-NONE' || var.WARNING_05_CODE__c != '0-NONE'){
                WarningsViewModel wcw5 =new WarningsViewModel(var.WARNING_05_CODE__c);                
                if(wcw5.isNull != true) {
                    wcwList.add(wcw5);  
                }
            }
            if(var.WARNING_06_CODE__c != NULL || var.WARNING_06_CODE__c !='' || var.WARNING_06_CODE__c != '000-NONE' || var.WARNING_06_CODE__c != '0-NONE'){
                WarningsViewModel wcw6 =new WarningsViewModel(var.WARNING_06_CODE__c);              
                if(wcw6.isNull != true) {
                    wcwList.add(wcw6); 
                }
            }
            if(var.WARNING_07_CODE__c != NULL || var.WARNING_07_CODE__c !='' || var.WARNING_07_CODE__c != '000-NONE' || var.WARNING_07_CODE__c != '0-NONE'){
                WarningsViewModel wcw7 =new WarningsViewModel(var.WARNING_07_CODE__c);               
                if(wcw7.isNull != true) {
                    wcwList.add(wcw7); 
                }
            }
            if(var.WARNING_08_CODE__c != NULL || var.WARNING_08_CODE__c !='' || var.WARNING_08_CODE__c != '000-NONE' || var.WARNING_08_CODE__c != '0-NONE'){
                WarningsViewModel wcw8 =new WarningsViewModel(var.WARNING_08_CODE__c);               
                if(wcw8.isNull != true) {
                    wcwList.add(wcw8); 
                }
            }
            if(var.WARNING_09_CODE__c != NULL || var.WARNING_09_CODE__c !='' || var.WARNING_09_CODE__c != '000-NONE' || var.WARNING_09_CODE__c != '0-NONE'){
                WarningsViewModel wcw9 =new WarningsViewModel(var.WARNING_09_CODE__c);                
                if(wcw9.isNull != true) {
                    wcwList.add(wcw9); 
                }
            }
            if(var.WARNING_10_CODE__c != NULL || var.WARNING_10_CODE__c !='' || var.WARNING_10_CODE__c != '000-NONE' || var.WARNING_10_CODE__c != '0-NONE'){
                WarningsViewModel wcw10 =new WarningsViewModel(var.WARNING_10_CODE__c);               
                if(wcw10.isNull != true) {
                    wcwList.add(wcw10);
                }
            }
            if(var.WARNING_11_CODE__c != NULL || var.WARNING_11_CODE__c !='' || var.WARNING_11_CODE__c != '000-NONE' || var.WARNING_11_CODE__c != '0-NONE'){
                WarningsViewModel wcw11 =new WarningsViewModel(var.WARNING_11_CODE__c);               
                if(wcw11.isNull != true) {
                    wcwList.add(wcw11);     
                }
            }
            if(var.WARNING_12_CODE__c != NULL || var.WARNING_12_CODE__c !='' || var.WARNING_12_CODE__c != '000-NONE' || var.WARNING_12_CODE__c != '0-NONE'){
                WarningsViewModel wcw12 =new WarningsViewModel(var.WARNING_12_CODE__c);               
                if(wcw12.isNull != true) {
                    wcwList.add(wcw12);
                }
            }
            if(var.WARNING_13_CODE__c != NULL || var.WARNING_13_CODE__c !='' || var.WARNING_13_CODE__c != '000-NONE' || var.WARNING_13_CODE__c != '0-NONE'){
                WarningsViewModel wcw13 =new WarningsViewModel(var.WARNING_13_CODE__c);
                if(wcw13.isNull != true) {
                    wcwList.add(wcw13);
                }
            }
            if(var.WARNING_14_CODE__c != NULL || var.WARNING_14_CODE__c !='' || var.WARNING_14_CODE__c != '000-NONE' || var.WARNING_14_CODE__c != '0-NONE'){
                WarningsViewModel wcw14 =new WarningsViewModel(var.WARNING_14_CODE__c);
                if(wcw14.isNull != true) {
                    wcwList.add(wcw14);
                }
            }
            if(var.WARNING_15_CODE__c != NULL || var.WARNING_15_CODE__c !='' || var.WARNING_15_CODE__c != '000-NONE' || var.WARNING_15_CODE__c != '0-NONE'){
                WarningsViewModel wcw15 =new WarningsViewModel(var.WARNING_15_CODE__c);
                if(wcw15.isNull != true) {
                    wcwList.add(wcw15);
                }
            }
            if(var.WARNING_16_CODE__c != NULL || var.WARNING_16_CODE__c !='' || var.WARNING_16_CODE__c != '000-NONE' || var.WARNING_16_CODE__c != '0-NONE'){
                WarningsViewModel wcw16 =new WarningsViewModel(var.WARNING_16_CODE__c);
                if(wcw16.isNull != true) {
                    wcwList.add(wcw16);
                }
            }
            if(var.WARNING_17_CODE__c != NULL || var.WARNING_17_CODE__c !='' || var.WARNING_17_CODE__c != '000-NONE' || var.WARNING_17_CODE__c != '0-NONE'){
                WarningsViewModel wcw17 =new WarningsViewModel(var.WARNING_17_CODE__c);
                if(wcw17.isNull != true) {
                    wcwList.add(wcw17);
                }
            }
            if(var.WARNING_18_CODE__c != NULL || var.WARNING_18_CODE__c !='' || var.WARNING_18_CODE__c != '000-NONE' || var.WARNING_18_CODE__c != '0-NONE'){
                WarningsViewModel wcw18 =new WarningsViewModel(var.WARNING_18_CODE__c);
                if(wcw18.isNull != true) {
                    wcwList.add(wcw18);
                }
            }
            if(var.WARNING_19_CODE__c != NULL || var.WARNING_19_CODE__c !='' || var.WARNING_19_CODE__c != '000-NONE' || var.WARNING_19_CODE__c != '0-NONE'){
                WarningsViewModel wcw19 =new WarningsViewModel(var.WARNING_19_CODE__c);
                if(wcw19.isNull != true) {
                    wcwList.add(wcw19);
                }
            }
            if(var.WARNING_20_CODE__c != NULL || var.WARNING_20_CODE__c !='' || var.WARNING_20_CODE__c != '000-NONE' || var.WARNING_20_CODE__c != '0-NONE'){
                WarningsViewModel wcw20 =new WarningsViewModel(var.WARNING_20_CODE__c);
                if(wcw20.isNull != true) {
                    wcwList.add(wcw20);
                }
            }
            
        }        
        
        return wcwList;
    }
    
    public class AccountViewModel {
        @AuraEnabled public string Name;
        @AuraEnabled public Date BirthDate;
        @AuraEnabled public string Email;
        @AuraEnabled public string MobilePhone;
        @AuraEnabled public string MemberType;
        @AuraEnabled public Integer JoiningDaysDiff;
        @AuraEnabled public Integer JoiningDaysDiff1;
        @AuraEnabled public Integer BirthDaysDiff;
        @AuraEnabled public decimal EmployeeRestrictedAccess;
    }
    
    public class WarningsViewModel {
        @AuraEnabled public string Code;
        @AuraEnabled public string Description;
        @AuraEnabled public boolean isNull {get;set;}    
        public WarningsViewModel(string val){
            if(String.isNotBlank(val) && String.isNotEmpty(val)) {
                string[] splitted = val.split('-');
                if(splitted.size()==2){
                    this.Code=splitted[0];
                    this.Description=splitted[1];
                    this.isNull=false;
                }else{
                    this.isNull = true;
                }
            }else{
                this.isNull = true;
            }
        }
    }
    
    
    @AuraEnabled
    public static Map<string,object> getLevel(string accoutid)
    { 
        Map<string,object> result = new  Map<string,object>();
        
        List<Authenticated_Log__c> LastLog = [SELECT Id,KYM_Member_Number__c,KYM_Other_Reason__c,KYM_Reason__c,Member_Name__c,Member__c,Name,Staff_Name__c,Member_Number__c,
                                              Last_Achievable_Level__c,OOW_Member_Number__c,OOW_Notes__c,OOW_Reason__c,OOW_Status__c,OTP_Status__c,SalesforceID__c,Public_Wallet_Status__c,
                                              CreatedDate,RecordType.Name,IVR_Sent_URL__c,CallerPhoneNumber__c,Failed_Desired_Level__c,Override_Request_Type__c,Override_Request_Supervisor__c,
                                              GUID__c FROM Authenticated_Log__c where SalesforceID__c =:accoutid AND CreatedDate = Today AND Last_Achievable_Level__c != null and recordtype.name !='Master Authentication Log' order by CreatedDate desc LIMIT 1];    
        
        if(LastLog.size() > 0){
            result.put('Level',LastLog[0].Last_Achievable_Level__c);
        }
        
        return result;
    }
    
    @AuraEnabled
    public static Authenticated_Log__c getReason(string ivrguid)
    { 
        Return [SELECT Id, IVR_GUID__c ,GUID__c, IVR_ID__c, Member__r.name,IVR_Code__c 
                FROM Authenticated_Log__c 
                WHERE IVR_GUID__c=:ivrguid
                ORDER BY Createddate Desc LIMIT 1];
    }
    
    private static boolean IsShowData()
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
        
        boolean ShowData = false;
        
        
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
        return ShowData;
    }
    
    
    private static boolean IsExpired(string actId, Account acc)
    {
        Needs_Assesment__c objNeedsAssessment;
        //query Need assesment to feed the NeedAssessment method that needs to be called in the controller
        List<Needs_Assesment__c> na = [select id,LEEM_Last_Updated_On__c, LEMQ_Last_Updated_On__c,LEOM_Last_Updated_On__c,LEAV_Last_Updated_On__c ,LESF_Last_Updated_On__c, LESB_Last_Updated_On__c, LEMD_Last_Updated_On__c, LECP_Last_Updated_On__c, LEHS_Last_Updated_On__c, LEOL_Last_Updated_On__c, LECF_Last_Updated_On__c, LEWS_Last_Updated_On__c, LEMP_Last_Updated_On__c, LEPT_Last_Updated_On__c  from Needs_Assesment__c where Member__c =: actId limit 1];
        if (na.size() > 0)
        {
            objNeedsAssessment = na[0];
        }
        
        boolean Expired = false;
        if (objNeedsAssessment == null)
        {
            Expired= true;
            return Expired;
        }
        if(GetTabStatus(objNeedsAssessment.LEHS_Last_Updated_On__c,acc.NA_LEHS_Complete__c, 'Housing', acc ) && 
           GetTabStatus(objNeedsAssessment.LEOM_Last_Updated_On__c,acc.NA_LEOM_Complete__c, 'NA Other Milestones', acc)
           && GetTabStatus(objNeedsAssessment.LEWS_Last_Updated_On__c,acc.NA_LEWS_Complete__c, 'Withdrawal', acc) 
           && GetTabStatus(objNeedsAssessment.LEMP_Last_Updated_On__c,acc.NA_LEMP_Complete__c, 'Move Your Money', acc)
           && GetTabStatus(objNeedsAssessment.LECF_Last_Updated_On__c,acc.NA_LECF_Complete__c, 'Current Feedback', acc) 
           && GetTabStatus(objNeedsAssessment.LESF_Last_Updated_On__c,acc.NA_LESF_Complete__c, 'ATM Network', acc)
           && GetTabStatusTime(objNeedsAssessment.LESB_Last_Updated_On__c,acc.NA_LESB_Complete__c, 'Shared Branching', acc) 
           && GetTabStatus(objNeedsAssessment.LECP_Last_Updated_On__c,acc.NA_LECP_Complete__c, 'Contact Preference', acc)
           && GetTabStatus(objNeedsAssessment.LEPT_Last_Updated_On__c,acc.NA_LEPT_Complete__c, 'PrimaryTransaction', acc) 
           && GetTabStatus(objNeedsAssessment.LEMD_Last_Updated_On__c,acc.NA_LEMD_Complete__c, 'MakingDeposits', acc)
           && GetTabStatus(objNeedsAssessment.LEOL_Last_Updated_On__c,acc.NA_LEOL_Complete__c, 'Other Loan', acc) 
           && GetTabStatusTime(objNeedsAssessment.LEAV_Last_Updated_On__c,acc.NA_LEAV_Complete__c, 'Auto Vehicle', acc)
           && GetTabStatus(objNeedsAssessment.LEEM_Last_Updated_On__c,acc.NA_LEEM_Complete__c, 'Earn More', acc) 
           && GetTabStatusTime(objNeedsAssessment.LEMQ_Last_Updated_On__c,acc.NA_LEMQ_Complete__c, 'Extend Benifits', acc)
           
          )
        {
            Expired = true; 
        }
        
        return Expired;
    }
    
    
    public static boolean GetTabStatus(Date updatedDate, boolean complete, string due, account acc)
    {
        GracePeriod__c dataHosuing = GracePeriod__c.getValues(due);
        
        integer HousingDuePeriod = integer.valueOf(dataHosuing.ExpiresInDays__c);
        
        boolean TabExpired = false;
        if (acc.NA_Opt_Out__c)
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
    
    public static boolean GetTabStatusTime(DateTime updatedDate, boolean complete, string due, Account acc)
    {
        GracePeriod__c dataHosuing = GracePeriod__c.getValues(due);
        integer  HousingDuePeriod = integer.valueOf(dataHosuing.ExpiresInDays__c);
        
        boolean TabExpired = false;
        if (acc.NA_Opt_Out__c)
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
    
    @AuraEnabled
    public static Map<string, string> accountDetails(string actId)
    {
        list<Person_Account__c> paList = new list<Person_Account__c>();
        paList = [SELECT Id,Account_Number__c,Account_Number__r.RecType__c, Account_Number__r.Name FROM Person_Account__c WHERE PersonID__c =:actId and TypeTranslate__c in ('0001/Joint Member','0000/Primary')];
        List<Account>	account = [select Id,RecordType.name,BIRTH_DATE__pc,NA_Complete__c,Last_NA_LEHS__c, Last_NA_LEOM__c, NA_LEHS_Complete__c, NA_LEWS_Complete__c, NA_Opt_Out_Updated__c,
                                   NA_LEMP_Complete__c, NA_LECF_Complete__c, NA_LEOM_Complete__c, NA_Opt_Out_Date__c, NA_LESF_Complete__c, NA_LESB_Complete__c,
                                   NA_LEHS_Expired__c, NA_LEOM_Expired__c, NA_Eligibility__c, NA_Opt_Out__c, NA_LECP_Complete__c, NA_LEPT_Complete__c, NA_LEMD_Complete__c,
                                   NA_LEOL_Complete__c,NA_LEAV_Complete__c,NA_LEEM_Complete__c,NA_LEMQ_Complete__c, Member_Verification_OTP_Invalid_Attempt__c,EStatements__c,DirectDeposit__c from Account where id =: actId limit 1];
        Map<string, string> m = new Map<string, string>();
        
        m.put('EStatements',account[0].EStatements__c);
        m.put('DirectDeposit',account[0].DirectDeposit__c);
        
        List<Needs_Assesment__c> na = [select id,Is_Member_Connect_Year_Old__c,LEEM_Last_Updated_On__c, LEMQ_Last_Updated_On__c,LEOM_Last_Updated_On__c,LEAV_Last_Updated_On__c ,LESF_Last_Updated_On__c, LESB_Last_Updated_On__c, LEMD_Last_Updated_On__c, LECP_Last_Updated_On__c, LEHS_Last_Updated_On__c, LEOL_Last_Updated_On__c, LECF_Last_Updated_On__c, LEWS_Last_Updated_On__c, LEMP_Last_Updated_On__c, LEPT_Last_Updated_On__c  from Needs_Assesment__c where Member__c =: actId limit 1];
        
        if (na.size()>0)
            System.debug('test'+na[0]);
        
        Boolean PrimaryAccountWithAtleastoneTrust = false;
        ///////////////////////
        
        
        PrimaryAccountWithAtleastoneTrust = false;
        List<Person_Account__c> paList1 =     [SELECT Id, Account_Number__c, Account_Number__r.RecType__c, Relationship__c, Account_Number__r.TypeTranslate__c, TypeTranslate__c,
                                               Account_Number__r.Name FROM Person_Account__c WHERE PersonID__c =: actId and Account_Number__r.RecType__c = 'ACCT'
                                               and(Account_Number__r.TypeTranslate__c != '2-TRUST' or Account_Number__r.TYPE__c != 2) and TypeTranslate__c like '%PRIMARY%' ];
        
        
        if (paList1.size() > 0)
        {
            PrimaryAccountWithAtleastoneTrust = true;           
        }
        
        
        system.debug('Before condition--0');
        boolean MemberAbove18 = true;
        if(account[0].BIRTH_DATE__pc != null)
        {
            
            MemberAbove18 =	account[0].BIRTH_DATE__pc.addyears(18) < System.Today();
        }
        boolean IsShowData = IsShowData();
        boolean IsExpired = IsExpired(actId, account[0]);
        
        m.put('Memberisunder18',string.valueof(MemberAbove18 == false));
        m.put('Memberisnotprimary',string.valueof(MemberAbove18 && PrimaryAccountWithAtleastoneTrust == false));
        system.debug('Memberhaspartiallycompleted condition--1');
        m.put('Memberhaspartiallycompleted', string.valueof(MemberAbove18 == TRUE && PrimaryAccountWithAtleastoneTrust == TRUE && account[0].NA_Opt_Out__c == FALSE && IsExpired == FALSE && account[0].NA_Complete__c == FALSE));
        system.debug('MemberAssessmentHasCompleted condition--1');
        m.put('MemberAssessmentHasCompleted', string.valueof(MemberAbove18 == TRUE && PrimaryAccountWithAtleastoneTrust == TRUE && IsExpired == FALSE && account[0].NA_Complete__c == TRUE));
        system.debug('Before condition--1');
        m.put('AMemberAssessmentisdue', string.valueof(MemberAbove18 == TRUE && PrimaryAccountWithAtleastoneTrust == TRUE && account[0].NA_Opt_Out__c == FALSE && IsExpired == True));
        system.debug('Before condition--2');
        m.put('MemberOptOut', string.valueof(account[0].NA_Opt_Out_Date__c != NULL && account[0].NA_Opt_Out_Date__c > system.today()));
        system.debug('Before condition--3');
        if (na.size()>0)
            m.put('MemberRefreshNeeded',string.valueof(na[0].Is_Member_Connect_Year_Old__c == True && MemberAbove18 == TRUE && PrimaryAccountWithAtleastoneTrust == TRUE && account[0].NA_Opt_Out__c == FALSE && IsExpired == FALSE));
        else
            m.put('MemberRefreshNeeded', 'false');
        system.debug('account[0].NA_Opt_Out_Date__c' + account[0].NA_Opt_Out_Date__c);
        if(account[0].NA_Opt_Out_Date__c != null)
        {
            Datetime dtTIme = datetime.newInstance( account[0].NA_Opt_Out_Date__c.year(),account[0].NA_Opt_Out_Date__c.month(),account[0].NA_Opt_Out_Date__c.day(), 0,0,0);
            
            string Opt_Out_Date = dtTIme.format('MMMM d ,  yyyy');
            m.put('Opt_Out_Date',Opt_Out_Date);
        }
        else
        {
            m.put('Opt_Out_Date','');
        }
        system.debug('Before condition--4');	
        m.put('ShowData',string.valueof(IsShowData));
        
        
        
        
        system.debug('paList...'+paList);
        set<String> accountNumberSet = new set<String>();
        set<Id> accIdset = new set<Id>();
        set<String> acctypeSet = new set<String>();
        for(Person_Account__c var: paList){
            
            accountNumberSet.add(var.Account_Number__r.Name);
            acctypeSet.add(var.Account_Number__r.RecType__c);
            accIdSet.add(var.Account_Number__c);
        }
        system.debug('acctypeSet ---  '  + acctypeSet);
        list<Account_Details__c> accList = new list<Account_Details__c>();
        boolean  Highpotentialflag = false;
        boolean	Highvalueflag = false;
        if(acctypeSet.contains('ACCT')){
            accList = [SELECT Id,Name,RecType__c,High_Value_Flag__c	FROM Account_Details__c WHERE Name IN:accountNumberSet AND High_Value_Flag__c  != null ORDER BY High_Value_Flag__c DESC];
            if(!accList.isEmpty() && accList.size() > 0 ){
                
                system.debug('accList[0].High_Value_Flag__c ---  '  + accList[0].High_Value_Flag__c );
                
                for (Account_Details__c acc : accList) {
                    
                    if(acc.High_Value_Flag__c == 1)
                    {
                        Highpotentialflag = false;
                        Highvalueflag = true;
                        break;
                    }
                    else if(acc.High_Value_Flag__c == 2){
                        Highpotentialflag = true;
                        Highvalueflag = false;
                    }						
                }	
                
            }
            
        }
        system.debug('accList ---  '  + accList);
        
        m.put('Highpotentialflag',string.valueof(Highpotentialflag));
        m.put('Highvalueflag',string.valueof(Highvalueflag));
        
        if(account[0].Member_Verification_OTP_Invalid_Attempt__c == null)
        {
            m.put('ShowOTPInvalidAttempt','false');
            m.put('OTPNextAttemptValidAfterHours','0');
        }
        else
        {
            Long milliseconds = System.Now().getTime() - account[0].Member_Verification_OTP_Invalid_Attempt__c.getTime() ;
            Long hours = milliseconds / (1000 * 60 * 60);
            OTPSettings__c data = OTPSettings__c.getValues('Member Verification');
            Integer OTPExpiresAfterSeconds = integer.valueOf(data.OTPExpirationSeconds__c);
            
            system.debug('hours---' + hours);            
            Integer OTPNextAttemptValidAfterHours = integer.valueOf(data.OTPNextAttemptValidAfterHours__c);
            system.debug('OTPNextAttemptValidAfterHours---' + OTPNextAttemptValidAfterHours);
            if(OTPNextAttemptValidAfterHours > hours){
                m.put('ShowOTPInvalidAttempt','true');
                m.put('OTPNextAttemptValidAfterHours', string.valueOf(OTPNextAttemptValidAfterHours));
            }
            else
            {
                m.put('ShowOTPInvalidAttempt','false');
                m.put('OTPNextAttemptValidAfterHours','0');
            }
        }
        
        boolean IsShowOTPButton = showData_OTP();
        m.put('IsShowOTPButton',string.valueOf(IsShowOTPButton));
        m.put('RecordTypeName',account[0].RecordType.name);
        return m;
    }
    
    private static boolean showData_OTP(){
        
        
        boolean showData1 = false;
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
        
        showData1 = false;
        
        
        list<GroupMember> listNamegroup =	[select group.developerName from GroupMember where UserOrGroupId in: results];
        set<string> listName = new set<string>();
        for(GroupMember i :listNamegroup)
        {
            
            listName.add(i.group.developerName );
            
        }
        
        system.debug('########' + listName);
        
        if (listName.contains('OTP_Auth')) {
            showData1 = true;
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
        
        if (groupNames.contains('OTP_Auth')) {
            showData1 = true;
        }	     
        
        return showData1;   	
    }
}