public class MemberAuthenticationControllerLightning{
    
    
    @AuraEnabled
    public static RecordType GetRecordTypeData(string sobjecttype, string RecordTypeName )
    {
        RecordType rec = [Select id, Name, sobjecttype from RecordType where sobjecttype=: sobjecttype and Name=:RecordTypeName];
        return rec;
    }
    @AuraEnabled
    public static List<Authenticated_Log__c> GetDataForMasterAuthenticationLog(string IVRGuid, Id RecordTypeId )
    {
        system.debug('IVRGuid##' + IVRGuid);
        system.debug('RecordTypeId##' + RecordTypeId);
        List<Authenticated_Log__c> AuthLog = [Select Id, Name, RecordTypeId, IVR_Sent_URL__c,CallerPhoneNumber__c,EnteredMemberNumber__c,EnteredSSN__c, Failed_Desired_Level__c,
        EnteredCardNumber__c,CardNumberMatch__c,PhoneNumberMatch__c, MemberNumberMatch__c, SSNnumberMatch__c,
     IVR_SSN__c,IVR_Card_Number__c,IVR_Member_Number__c,IVR_Member_Number_Match__c,IVR_SSN_Match__c,IVR_Card_Match__c,
     IVR_Pin_Match__c,PINMatch__c,HP_HV__c,IVR_Code__c,
        Override_Request_Supervisor__c,Override_Supervisor__c,Override_Request_Type__c,Manager_Override_Case__c,
        OOW_Status__c,OOW_Member_Number__c,OOW_Reason__c,OOW_Notes__c,First_Name__c,Last_Name__c,
        Public_Wallet_Status__c,DOBMatch__c,IdNumberMatch__c,MMNMatch__c,EmailMatch__c,Additional_Token_Option3_Match__c,
        CFCU_Wallet_Status__c,BeneficiaryDetailMatch__c,Joint_OwnerDetailsMatch__c,Additional_Token_Option1_Match__c,Additional_Token_Option2_Match__c,Loan_Detail_Match__c,
        Decision__c,SalesforceID__c,Member__c,Member_Number__c,Staff_Name__c,Current_User__c,GUID__c,IVR_GUID__c,Last_Achievable_Level__c from Authenticated_Log__c where IVR_GUID__c= :IVRGuid and RecordTypeId=:RecordTypeId];
        return AuthLog;
    } 
    
    @AuraEnabled(cacheable = false )
    
    public static  Map<string,object> getMemberSearchData(string PhoneNumber, string MemberNumber, string SSNNumber,string IVRGUIDFromUrl, boolean IsUserSessionLoaded, String SSNMatch)
    {
        /*This method brings member data based on values passed in url and also based on values pass during manual search for member */
        Boolean visible;
        Boolean OOW;
        Boolean OTP;
        Boolean PubCFCU;
        Map<string,object> result = new  Map<string,object>();
        Id profileId=userinfo.getProfileId();
        Id CurrentUser = userinfo.getUserId();
        Profile UserProfile = [Select Id,Name from Profile where Id=:profileId];
        system.debug('ProfileName'+UserProfile);
        
        List<Member_Authentication_Level_Model__c> LevelModel = new List<Member_Authentication_Level_Model__c>();
        verificationObject userEnteredInformation = new verificationObject();
        
        
        verifyCaller vc = new verifyCaller();
        list<Account> NameList = new List<Account>();  
        
        userEnteredInformation.phoneNumber = PhoneNumber;
        userEnteredInformation.memberNumber = MemberNumber;
        userEnteredInformation.SSN = SSNNumber;
        userEnteredInformation.SSNMatch = SSNMatch;
        /*NameList contains Member data entered by user*/
        NameList = vc.queryByParametersAvailable(userEnteredInformation, false); 
        
       
        
        result.put('Account', NameList);
        /*GetMemberAuthenticationLevel() function bring data from custom setting*/
        LevelModel = GetMemberAuthenticationLevel();
        result.put('Profile',UserProfile);
        
        Blob b = Crypto.GenerateAESKey(128);
        String h = EncodingUtil.ConvertTohex(b);
        String guid = h.SubString(0,8)+ '-' + h.SubString(8,12) + '-' + h.SubString(12,16) + '-' + h.SubString(16,20) + '-' + h.substring(20);
        system.debug(guid);
        result.put('GUID',guid);

        //-----------Code for ReLoad Begin------------------------------------------------------------------
        
        integer minutes = GetMemberAuthenticationSessionTime();
        List<Authenticated_Log__c> AuthLog = new List<Authenticated_Log__c>();
        system.debug('IVRGUIDFromUrl##'+ IVRGUIDFromUrl);
        
        
        
        if(IsUserSessionLoaded == true)
        {
            AuthLog = [Select id ,Current_User__c, Guid__c, SalesforceID__c, IVR_GUID__c from Authenticated_Log__c where IVR_GUID__c =: IVRGUIDFromUrl and Recordtype.name!='Master Authentication Log'  order by createddate desc Limit 1] ;
            system.debug('AuthLogSize##'+ AuthLog.size());
            if(AuthLog.size() > 0 ){
                result.put('AuthLog', AuthLog);
                result.put('ReLoadRequired', false);
            }
            
        }
        else
        {
            if(IVRGUIDFromUrl != null && IVRGUIDFromUrl !=''){            
                
                AuthLog = [Select id ,Current_User__c, Guid__c, SalesforceID__c, IVR_GUID__c from Authenticated_Log__c where IVR_GUID__c =: IVRGUIDFromUrl and Recordtype.name!='Master Authentication Log'and createddate >=: Datetime.now().addMinutes(minutes) Limit 1] ;
                system.debug('AuthLogSize##'+ AuthLog.size());
                
                if(AuthLog.size() > 0 ){
                    
                    result.put('ReLoadRequired', true);
                    result.put('AuthLog', AuthLog);
                }
                else{
                    result.put('ReLoadRequired', false);
                }
            }
        }
        
        //-----------Code for ReLoad End------------------------------------------------------------------
        
        
        return result;
    }
    
    @AuraEnabled
    public static Map<string,string> GetAccountNumber(string accdetailid)
    {
        /* This method is for  OOW tab which returns AccountNumber, MemberName , read flow url from customsetting and Accountid */
        string AccountNumber;
        string MemberName;
        string FlowURL;
        string AccountId;
        OOW_Flow_URL__c oowf = OOW_Flow_URL__c.getValues('OOW Boomi Flow URL');
        
        if(oowf.URL__c != null){
            FlowURL = oowf.URL__C;
        }
        
        Map<string,string> strMap = new  Map<string,string>();
        List<Person_Account__c> p = [SELECT Id, Account_Number__c,PersonID__r.Name, PersonID__r.FirstName,PersonID__r.LastName, PersonID__c, Account_Number__r.RecType__c, TypeTranslate__c, Account_Number__r.Name
                                     FROM Person_Account__c where PersonID__c =:accdetailid limit 1];
        if(p.size() > 0)
        {    
            AccountNumber = p[0].Account_Number__r.Name;
            MemberName =  p[0].PersonID__r.Name;
            AccountId = p[0].Account_Number__c;
        }
        
        strMap.put('AccountNumber',AccountNumber);
        strMap.put('MemberName',MemberName);
        strMap.put('FlowURL',FlowURL);
        strMap.put('AccountId',AccountId);
        return strMap;
        
        
        
    }
    
    @AuraEnabled
    public static void SaveOOWLogData(string status, string MemberNumber, string MemberId, string reason, string notes, string GUID, string name, string Error, string IVRGUIDFromUrl)/*This is to save OOW log*/
    {
        /*This methos save OOW log data in MAAP Log object*/
        RecordType rec = GetRecordTypeData('Authenticated_Log__c', 'OOW Execution Log');
        
        String[] sp2 ;
        if(name != null && name != '' ){
            sp2 = name.split(' ');}
        
        Authenticated_Log__c log = new Authenticated_Log__c();
        log.RecordTypeId= rec.id;
        If(status == 'failed'){
            log.OOW_Status__c = 'Fail';
        }else if(status == 'passed'){
            log.OOW_Status__c = 'Pass';  
        }else{
            log.OOW_Status__c = status;  
        }
        
        log.OOW_Member_Number__c = MemberNumber;
        if(reason == '')
        {
            log.OOW_Reason__c = 'N/A';
        }
        else
        {
            log.OOW_Reason__c = reason;
        }
        if(Error != null && Error != '')
        {
            log.OOW_Notes__c = notes + ' Error:' + Error;
        }
        else
        {
            log.OOW_Notes__c = notes;
        }
        
        log.SalesforceID__c = MemberId;
        log.Member__c = MemberId;
        log.Staff_Name__c = UserInfo.getName();
        log.Current_User__c = Userinfo.getuserid();
        log.Member_Number__c = MemberNumber;
        log.GUID__c = GUID;
        log.IVR_GUID__c = IVRGUIDFromUrl;
        If(status == 'failed'){
            log.Decision__c = 'Fail';
        }else If(status == 'passed'){
            log.Decision__c = 'Pass';
        }else{
            log.Decision__c = status;   
        }
        system.debug('sp2##'+ sp2);
        if(sp2.size() > 0)log.First_Name__c = sp2[0];
        if(sp2.size() > 2) log.Last_Name__c = sp2[2];
        else if(sp2.size() > 0)log.Last_Name__c = sp2[1];
        
        insert log;
        
        system.debug('log##'+ log);
        
        
        /* The below code is to create or update Master log data*/
        
        RecordType rec1 = GetRecordTypeData('Authenticated_Log__c', 'Master Authentication Log');
       
        List<Authenticated_Log__c> MasterAuthenticationLog = GetDataForMasterAuthenticationLog(IVRGUIDFromUrl, rec1.id);
        if(MasterAuthenticationLog.size() == 0)
        {
            
            Authenticated_Log__c log2 = new Authenticated_Log__c();
            log2.RecordTypeId= rec1.id;
            If(status == 'failed'){
                log2.OOW_Status__c = 'Fail';
            }else if(status == 'passed'){
                log2.OOW_Status__c = 'Pass';  
            }else{
                log2.OOW_Status__c = status;  
            }
            log2.OOW_Member_Number__c = MemberNumber;
            if(reason == ''){
                log2.OOW_Reason__c = 'N/A';
            }else{
                log2.OOW_Reason__c = reason;
            }
            if(Error != null && Error != ''){
                log2.OOW_Notes__c = notes + ' Error:' + Error;
            }
            else{
                log2.OOW_Notes__c = notes;
            }            
            
            log2.SalesforceID__c = MemberId;
            log2.Member__c = MemberId;
            log2.Staff_Name__c = UserInfo.getName();
            log2.Current_User__c = Userinfo.getuserid();
            log2.Member_Number__c = MemberNumber;
            log2.GUID__c = GUID;
            log2.IVR_GUID__c = IVRGUIDFromUrl;
            If(status == 'failed'){
                log2.Decision__c = 'Fail';
            }else If(status == 'passed'){
                log2.Decision__c = 'Pass';
            }else{
                log2.Decision__c = status;   
            }
            system.debug('sp2##'+ sp2);
            if(sp2.size() > 0)log2.First_Name__c = sp2[0];
            if(sp2.size() > 2) log2.Last_Name__c = sp2[2];
            else if(sp2.size() > 0)log2.Last_Name__c = sp2[1];
            
            insert log2;
            
            system.debug('log2##'+ log2);
        }else{
            
            
            
            If(status == 'failed'){
                MasterAuthenticationLog[0].OOW_Status__c = 'Fail';
            }else If(status == 'passed'){
                MasterAuthenticationLog[0].OOW_Status__c = 'Pass';  
            }else {
                MasterAuthenticationLog[0].OOW_Status__c = status;
            }
            MasterAuthenticationLog[0].OOW_Member_Number__c = MemberNumber;
            if(reason == ''){
                MasterAuthenticationLog[0].OOW_Reason__c = 'N/A';
            }else{
                MasterAuthenticationLog[0].OOW_Reason__c = reason;
            }
            if(Error != null && Error != ''){
                MasterAuthenticationLog[0].OOW_Notes__c = notes + ' Error:' + Error;
            }
            else{
                MasterAuthenticationLog[0].OOW_Notes__c = notes;
            }            
            
            MasterAuthenticationLog[0].SalesforceID__c = MemberId;
            MasterAuthenticationLog[0].Member__c = MemberId;
            MasterAuthenticationLog[0].Staff_Name__c = UserInfo.getName();
            MasterAuthenticationLog[0].Current_User__c = Userinfo.getuserid();
            MasterAuthenticationLog[0].Member_Number__c = MemberNumber;
            MasterAuthenticationLog[0].GUID__c = GUID;
            If(status == 'failed'){  
                MasterAuthenticationLog[0].Decision__c = 'Fail';
            }else If(status == 'passed'){
                MasterAuthenticationLog[0].Decision__c = 'Pass';
            }else{
                MasterAuthenticationLog[0].Decision__c = status;
            }
            system.debug('sp2##'+ sp2);
            if(sp2.size() > 0)MasterAuthenticationLog[0].First_Name__c = sp2[0];
            if(sp2.size() > 2) MasterAuthenticationLog[0].Last_Name__c = sp2[2];
            else if(sp2.size() > 0)MasterAuthenticationLog[0].Last_Name__c = sp2[1];
            
            update MasterAuthenticationLog[0];
            
            
        }
        
        
    }
    
    @AuraEnabled
    
    public static void KYMSaveLogData(string MemberId, string reason, string otherReason, string GUID, string SecureEmailCase, string IVRGUIDFromUrl, string DriverLicenseNo, string WorkBadgeNo)/*This is to save OOW log*/
    {
        /*This method save KYM log data in MAAP Log object*/
        RecordType rec = GetRecordTypeData('Authenticated_Log__c', 'KYM Log'); 
        string  AccountNumber;
        List<Person_Account__c> p = [SELECT Id, Account_Number__c,  PersonID__c, Account_Number__r.RecType__c, TypeTranslate__c, Account_Number__r.Name
                                     FROM Person_Account__c where PersonID__c =:MemberId limit 1];
        if(p.size() > 0)
        {
            AccountNumber = p[0].Account_Number__r.Name;
        }
        
        
        
        Authenticated_Log__c log = new Authenticated_Log__c();
        log.RecordTypeId= rec.id;
        log.KYM_Reason__c = reason;
        log.KYM_Member_Number__c = AccountNumber;
        log.KYM_Other_Reason__c = otherReason;
        log.KYM_Secure_Email_Case_Number__c = SecureEmailCase;
        log.KYM_Driver_License_Number__c = DriverLicenseNo;
        log.KYM_Work_Badge_Number__c = WorkBadgeNo;
        log.SalesforceID__c = MemberId;
        log.Member__c = MemberId;
        log.Staff_Name__c = UserInfo.getName();
        log.Current_User__c = Userinfo.getuserid();
        log.Member_Number__c = AccountNumber;
        log.Member__c = MemberId;
        log.GUID__c = GUID;
        log.Decision__c = reason;
        insert log;
        
        system.debug('log##'+ log);

        RecordType rec1 = GetRecordTypeData('Authenticated_Log__c', 'Master Authentication Log');
        List<Authenticated_Log__c> MasterAuthenticationLog = GetDataForMasterAuthenticationLog(IVRGUIDFromUrl, rec1.id);
        system.debug('MasterAuthenticationLog##'+ MasterAuthenticationLog);
        if(MasterAuthenticationLog.size() == 0)
        {
            Authenticated_Log__c log2 = new Authenticated_Log__c();
            log2.RecordTypeId= rec1.id;
            log2.KYM_Reason__c = reason;
            log2.KYM_Member_Number__c = AccountNumber;
            log2.KYM_Other_Reason__c = otherReason;
            log2.KYM_Secure_Email_Case_Number__c = SecureEmailCase;
            log2.KYM_Driver_License_Number__c = DriverLicenseNo;
            log2.KYM_Work_Badge_Number__c = WorkBadgeNo;
            log2.SalesforceID__c = MemberId;
            log2.Member__c = MemberId;
            log2.Staff_Name__c = UserInfo.getName();
            log2.Current_User__c = Userinfo.getuserid();
            log2.Member_Number__c = AccountNumber;
            log2.Member__c = MemberId;
            log2.GUID__c = GUID;
            log2.Decision__c = reason;
            log2.IVR_GUID__c = IVRGUIDFromUrl;         
            
            insert log2;
        }
        else{       
            MasterAuthenticationLog[0].RecordTypeId= rec1.id;
            MasterAuthenticationLog[0].KYM_Reason__c = reason;
            MasterAuthenticationLog[0].KYM_Member_Number__c = AccountNumber;
            MasterAuthenticationLog[0].KYM_Other_Reason__c = otherReason;
            MasterAuthenticationLog[0].KYM_Secure_Email_Case_Number__c = SecureEmailCase;
            MasterAuthenticationLog[0].KYM_Driver_License_Number__c = DriverLicenseNo;
            MasterAuthenticationLog[0].KYM_Work_Badge_Number__c = WorkBadgeNo;
            MasterAuthenticationLog[0].SalesforceID__c = MemberId;
            MasterAuthenticationLog[0].Member__c = MemberId;
            MasterAuthenticationLog[0].Staff_Name__c = UserInfo.getName();
            MasterAuthenticationLog[0].Current_User__c = Userinfo.getuserid();
            MasterAuthenticationLog[0].Member_Number__c = AccountNumber;
            MasterAuthenticationLog[0].Member__c = MemberId;
            MasterAuthenticationLog[0].GUID__c = GUID;
            MasterAuthenticationLog[0].Decision__c = reason;
            MasterAuthenticationLog[0].IVR_GUID__c = IVRGUIDFromUrl;       
            update MasterAuthenticationLog[0];
        }
        
    }
    
    @AuraEnabled
    public static void PublicWalletSaveLogData(string MemberId, string Status, string GUID, string DOBMatch, string IdNumberMatch, String MMNMatch, string EmailMatch, string AdditionalTokenOption3Match, string IVRGUIDFromUrl, string DOB,string IdNumber,string MMN, string Email, string AdditionalTokenOption3, string MemberNumber, string AdditionalTokenOption4, string AdditionalTokenOption4Match)
    {
        /*This method save Public Wallet log data in MAAP Log object*/
        system.debug('Email##' + Email );
        system.debug('AdditionalTokenOption4##' + AdditionalTokenOption4 );
        system.debug('AdditionalTokenOption4Match##' + AdditionalTokenOption4Match );
        RecordType rec = GetRecordTypeData('Authenticated_Log__c', 'Public Wallet Log');         
        Authenticated_Log__c log = new Authenticated_Log__c();
        log.RecordTypeId= rec.id;
        log.Public_Wallet_Status__c = status;
        log.SalesforceID__c = MemberId;
        log.Member__c = MemberId;
        log.Staff_Name__c = UserInfo.getName();
        log.Current_User__c = Userinfo.getuserid();
        log.Decision__c = status;
        log.Member_Number__c = MemberNumber;
        log.GUID__c = GUID;
        log.IVR_GUID__c = IVRGUIDFromUrl;
        log.DOBMatch__c = DOBMatch ;
        log.IdNumberMatch__c =  IdNumberMatch ;
        log.MMNMatch__c = MMNMatch ;
        log.EmailMatch__c = EmailMatch ;
        log.Additional_Token_Option3_Match__c = AdditionalTokenOption3Match ;
        log.DOB__c = DOB;
        log.ICardNumber__c = IdNumber;
        log.MMN__c = MMN;
        log.PW_Email__c = Email;
        log.Additional_Token_Option3__c = AdditionalTokenOption3;   
        
        log.Additional_Token_Option4_Match__c = AdditionalTokenOption4Match;
        log.Additional_Token_Option4__c = AdditionalTokenOption4;

        insert log;
        system.debug('log##'+ log);
        /* The below code is to create or update Master log data*/
        RecordType rec1 = GetRecordTypeData('Authenticated_Log__c', 'Master Authentication Log');
        
        List<Authenticated_Log__c> MasterAuthenticationLog = GetDataForMasterAuthenticationLog(IVRGUIDFromUrl, rec1.id);
        if(MasterAuthenticationLog.size() == 0)
        {
            Authenticated_Log__c log2 = new Authenticated_Log__c();
            log2.RecordTypeId= rec1.id;
            log2.Public_Wallet_Status__c = status;
            log2.SalesforceID__c = MemberId;
            log2.Member__c = MemberId;
            log2.Staff_Name__c = UserInfo.getName();
            log2.Current_User__c = Userinfo.getuserid();
            log2.Decision__c = status;
            log2.Member_Number__c = MemberNumber;
            log2.GUID__c = GUID;
            log2.IVR_GUID__c = IVRGUIDFromUrl;
            log2.DOBMatch__c = DOBMatch ;
            log2.IdNumberMatch__c =  IdNumberMatch ;
            log2.MMNMatch__c = MMNMatch ;
            log2.EmailMatch__c = EmailMatch ;
            log2.Additional_Token_Option3_Match__c = AdditionalTokenOption3Match ;
            log2.DOB__c = DOB;
            log2.ICardNumber__c = IdNumber;
            log2.MMN__c = MMN;
            log2.PW_Email__c = Email;
            log2.Additional_Token_Option3__c = AdditionalTokenOption3;

            log2.Additional_Token_Option4_Match__c = AdditionalTokenOption4Match;
            log2.Additional_Token_Option4__c = AdditionalTokenOption4;
                                  
            insert log2;
            system.debug('log2##'+ log2);
        }
        else{
            
            MasterAuthenticationLog[0].Public_Wallet_Status__c = status;
            MasterAuthenticationLog[0].SalesforceID__c = MemberId;
            MasterAuthenticationLog[0].Member__c = MemberId;
            MasterAuthenticationLog[0].Staff_Name__c = UserInfo.getName();
            MasterAuthenticationLog[0].Current_User__c = Userinfo.getuserid();
            MasterAuthenticationLog[0].Decision__c = status;
            MasterAuthenticationLog[0].Member_Number__c = MemberNumber;
            MasterAuthenticationLog[0].GUID__c = GUID;
            MasterAuthenticationLog[0].DOBMatch__c = DOBMatch ;
            MasterAuthenticationLog[0].IdNumberMatch__c =  IdNumberMatch ;
            MasterAuthenticationLog[0].MMNMatch__c = MMNMatch ;
            MasterAuthenticationLog[0].EmailMatch__c = EmailMatch ;
            MasterAuthenticationLog[0].Additional_Token_Option3_Match__c = AdditionalTokenOption3Match ;
            MasterAuthenticationLog[0].DOB__c = DOB;
            MasterAuthenticationLog[0].ICardNumber__c = IdNumber;
            MasterAuthenticationLog[0].MMN__c = MMN;
            MasterAuthenticationLog[0].PW_Email__c = Email;
            MasterAuthenticationLog[0].Additional_Token_Option3__c = AdditionalTokenOption3;
            
            MasterAuthenticationLog[0].Additional_Token_Option4_Match__c = AdditionalTokenOption4Match;
            MasterAuthenticationLog[0].Additional_Token_Option4__c = AdditionalTokenOption4;

            update MasterAuthenticationLog[0];  
        }
        
    }
    
    @AuraEnabled
    public static void CFCUWalletSaveLogData(string MemberId, string Status, string GUID, string BeneficiaryDetailMatch, string JointOwnerDetailMatch, string CardNumberMatch, string AdditionalTokenOption1Match,
    string AdditionalTokenOption2Match, string LoanDetailMatch, string IVRGUIDFromUrl, List<object> BeneficiaryAccount, List<object> JointAccount, List<object> LoanAccount,  List<object> Card, string AdditionalTokenOption1, string AdditionalTokenOption2, string MemberNumber, string AdditionalTokenOption3, string AdditionalTokenOption3Match, string AdditionalTokenOption4, string AdditionalTokenOption4Match)
    {
        /*This method save CFCU Wallet log data in MAAP Log object*/
        string BA = '';
        string JA = '';
        string LA = '';
        string CardDetail = '';
        RecordType rec = GetRecordTypeData('Authenticated_Log__c', 'CFCU Wallet Log');
        
        Authenticated_Log__c log = new Authenticated_Log__c();
        log.RecordTypeId= rec.id;
        log.CFCU_Wallet_Status__c = status;
        log.SalesforceID__c = MemberId;
        log.Member__c = MemberId;
        log.Decision__c = status;
        log.Staff_Name__c = UserInfo.getName();
        log.Current_User__c = Userinfo.getuserid();
        log.Member_Number__c = MemberNumber;
        log.GUID__c = GUID;
        log.IVR_GUID__c = IVRGUIDFromUrl;
        log.BeneficiaryDetailMatch__c = BeneficiaryDetailMatch;
        log.Joint_OwnerDetailsMatch__c = JointOwnerDetailMatch;
        log.CardNumberMatch__c = CardNumberMatch;
        log.Additional_Token_Option1_Match__c = AdditionalTokenOption1Match;
        log.Additional_Token_Option2_Match__c = AdditionalTokenOption2Match;

        log.Additional_Token_Option5_Match__c = AdditionalTokenOption3Match;
        log.Additional_Token_Option6_Match__c = AdditionalTokenOption4Match;
               
        log.Loan_Detail_Match__c = LoanDetailMatch;
        if(BeneficiaryAccount.size() > 0){
            for(object obj :BeneficiaryAccount)
            {
                BA = BA + obj + ',';
            }  
            log.Beneficiary_Details__c = BA;
        }
        
        if(JointAccount.size() > 0){
            for(object obj1 :JointAccount)
            {
                JA = JA + obj1 + ',';
            }  
            log.JointOwner_Details__c = JA;
        }
        
        if(LoanAccount.size() > 0){
            for(object obj2 :LoanAccount)
            {
                LA = LA + obj2 + ',';
            }  
            log.Member_Loan_Detail__c = LA;
        }
        
        if(Card.size() > 0){
            for(object obj3 :Card)
            {
                CardDetail = CardDetail + obj3 + ',';
            }  
            log.CFCU_Card_Number__c = CardDetail;
        }
        log.Additional_Token_Option1__c = AdditionalTokenOption1;
        log.Additional_Token_Option2__c = AdditionalTokenOption2;

        log.Additional_Token_Option5__c = AdditionalTokenOption3;
        log.Additional_Token_Option6__c = AdditionalTokenOption4;
       
        insert log;
        
        /* The below code is to create or update Master log data*/
        RecordType rec1 = GetRecordTypeData('Authenticated_Log__c', 'Master Authentication Log');
        
        List<Authenticated_Log__c> MasterAuthenticationLog = GetDataForMasterAuthenticationLog(IVRGUIDFromUrl, rec1.id);
        if(MasterAuthenticationLog.size() == 0)
        {
            Authenticated_Log__c log2 = new Authenticated_Log__c();
            log2.RecordTypeId= rec1.id;
            log2.CFCU_Wallet_Status__c = status;
            log2.SalesforceID__c = MemberId;
            log2.Member__c = MemberId;
            log2.Decision__c = status;
            log2.Staff_Name__c = UserInfo.getName();
            log2.Current_User__c = Userinfo.getuserid();
            log2.Member_Number__c = MemberNumber;
            log2.GUID__c = GUID;
            log2.IVR_GUID__c = IVRGUIDFromUrl;
            log2.BeneficiaryDetailMatch__c = BeneficiaryDetailMatch;
            log2.Joint_OwnerDetailsMatch__c = JointOwnerDetailMatch;
            log2.CardNumberMatch__c = CardNumberMatch;
            log2.Additional_Token_Option1_Match__c = AdditionalTokenOption1Match;
            log2.Additional_Token_Option2_Match__c = AdditionalTokenOption2Match;

            log2.Additional_Token_Option5_Match__c = AdditionalTokenOption3Match;
            log2.Additional_Token_Option6_Match__c = AdditionalTokenOption4Match;
            
            log2.Loan_Detail_Match__c = LoanDetailMatch;
            if(BeneficiaryAccount.size() > 0){
                for(object obj :BeneficiaryAccount)
                {
                    BA = BA + obj + ',';
                }  
                log2.Beneficiary_Details__c = BA;
            }
            if(JointAccount.size() > 0){
                for(object obj1 :JointAccount)
                {
                    JA = JA + obj1 + ',';
                }  
                log2.JointOwner_Details__c = JA;
            }
            
            if(LoanAccount.size() > 0){
                for(object obj2 :LoanAccount)
                {
                    LA = LA + obj2 + ',';
                }  
                log2.Member_Loan_Detail__c = LA;
            }
            
            if(Card.size() > 0){
                for(object obj3 :Card)
                {
                    CardDetail = CardDetail + obj3 + ',';
                }  
                log2.CFCU_Card_Number__c = CardDetail;
            }
            log2.Additional_Token_Option1__c = AdditionalTokenOption1;
            log2.Additional_Token_Option2__c = AdditionalTokenOption2;

            log2.Additional_Token_Option5__c = AdditionalTokenOption3;
            log2.Additional_Token_Option6__c = AdditionalTokenOption4;
           
            insert log2;
        }
        else{  BA = '';
             JA ='';  
             LA = '';
             CardDetail ='';
             MasterAuthenticationLog[0].CFCU_Wallet_Status__c = status;
             MasterAuthenticationLog[0].SalesforceID__c = MemberId;
             MasterAuthenticationLog[0].Member__c = MemberId;
             MasterAuthenticationLog[0].Decision__c = status;
             MasterAuthenticationLog[0].Staff_Name__c = UserInfo.getName();
             MasterAuthenticationLog[0].Current_User__c = Userinfo.getuserid();
             MasterAuthenticationLog[0].Member_Number__c = MemberNumber;
             MasterAuthenticationLog[0].GUID__c = GUID;
             MasterAuthenticationLog[0].IVR_GUID__c = IVRGUIDFromUrl;
             MasterAuthenticationLog[0].BeneficiaryDetailMatch__c = BeneficiaryDetailMatch;
             MasterAuthenticationLog[0].Joint_OwnerDetailsMatch__c = JointOwnerDetailMatch;
             MasterAuthenticationLog[0].CardNumberMatch__c = CardNumberMatch;
             MasterAuthenticationLog[0].Additional_Token_Option1_Match__c = AdditionalTokenOption1Match;
             MasterAuthenticationLog[0].Additional_Token_Option2_Match__c = AdditionalTokenOption2Match;
             
             MasterAuthenticationLog[0].Additional_Token_Option5_Match__c = AdditionalTokenOption3Match;
             MasterAuthenticationLog[0].Additional_Token_Option6_Match__c = AdditionalTokenOption4Match;
                        
             MasterAuthenticationLog[0].Loan_Detail_Match__c = LoanDetailMatch;
             if(BeneficiaryAccount.size() > 0){
                 for(object obj :BeneficiaryAccount)
                 {
                     BA = BA + obj + ',';
                 }  
                 MasterAuthenticationLog[0].Beneficiary_Details__c = BA;
             }
             
             if(JointAccount.size() > 0){
                 for(object obj1 :JointAccount)
                 {
                     JA = JA + obj1 + ',';
                 }  
                 MasterAuthenticationLog[0].JointOwner_Details__c = JA;
             }
             
             if(LoanAccount.size() > 0){
                 for(object obj2 :LoanAccount)
                 {
                     LA = LA + obj2 + ',';
                 }  
                 MasterAuthenticationLog[0].Member_Loan_Detail__c = LA;
             }
             
             if(Card.size() > 0){
                 for(object obj3 :Card)
                 {
                     CardDetail = CardDetail + obj3 + ',';
                 }  
                 MasterAuthenticationLog[0].CFCU_Card_Number__c = CardDetail;
             }
             MasterAuthenticationLog[0].Additional_Token_Option1__c = AdditionalTokenOption1;
             MasterAuthenticationLog[0].Additional_Token_Option2__c = AdditionalTokenOption2;            
             
             MasterAuthenticationLog[0].Additional_Token_Option5__c = AdditionalTokenOption3;
             MasterAuthenticationLog[0].Additional_Token_Option6__c = AdditionalTokenOption4;
             
             update MasterAuthenticationLog[0];
             
            }
    }
    
    @AuraEnabled
    public static void InsertLogData(string MemberId, string Decision, string FDL, string PhoneNumber, string EnteredSSN, string PageUrl, string OverrideType, String OverrideSupervisor, String ManagerCallbackComments, string GUID, string IVRGUIDFromUrl)
    {
        /*This method save log data in MAAP Log object*/
        string  AccountNumber;
        string AccountId;
        
        RecordType rec = GetRecordTypeData('Authenticated_Log__c', 'IVR Authentication Log'); 
        List<Person_Account__c> p = [SELECT Id, Account_Number__c,  PersonID__c, Account_Number__r.RecType__c, TypeTranslate__c, Account_Number__r.Name
                                     FROM Person_Account__c where PersonID__c =:MemberId  limit 1];
        if(p.size() > 0)
        {
            AccountNumber = p[0].Account_Number__r.Name;
            AccountId = p[0].Account_Number__c;
        }
        system.debug('test'+MemberId);
        
        
        //--------------------------------------------Start Aut-205 (Manager CallBack)--------------------------------------------------------------------//
        
        Authenticated_Log__c log = new Authenticated_Log__c();
        log.RecordTypeId= rec.id;
        //log.IVR_Sent_URL__c = substring(PageUrl, 1000);
        log.CallerPhoneNumber__c = substring(PhoneNumber, 16);
        log.EnteredMemberNumber__c = substring(AccountNumber, 15);
        log.EnteredSSN__c = substring(EnteredSSN, 4);
        log.SalesforceID__c = MemberId;
        log.Decision__c = Decision;
        //  log.Failed_Desired_Level__c= FDL;
        if(OverrideSupervisor != null && OverrideSupervisor != 'Select'){
            User u = [select id, name from user where name =:OverrideSupervisor limit 1];
            log.Override_Request_Supervisor__c = OverrideSupervisor;
            log.Override_Supervisor__c = u.id;
        }
        if(OverrideType != null){  
            log.Override_Request_Type__c = OverrideType;
        }
        log.Member__c = MemberId;
        log.Staff_Name__c =UserInfo.getName();
        log.Current_User__c = Userinfo.getuserid();
        log.Member_Number__c = AccountNumber;
        log.GUID__c = GUID;
        log.IVR_GUID__c = IVRGUIDFromUrl;
        
        insert log;
        
        list<CaseRecordType__c> scList = [SELECT Id,Primary_Category__c,
                                          Secondary_Category__c,
                                          Teritiary_Category__c,
                                          Record_Type_Name__c,
                                          SLA__c,
                                          RecordTypeId__c FROM CaseRecordType__c WHERE Primary_Category__c = 'Account Maintenance' AND Secondary_Category__c='Account Services' AND Teritiary_Category__c='Authentication Failed' LIMIT 1];
        
        Group gp = [select Id, Name from Group where  Type = 'Queue' AND DeveloperName = 'Manager_Call_Center'];
        case cs = new case();
        for(CaseRecordType__c crt : scList){
            cs.RecordTypeId = scList[0].RecordTypeId__c;
            cs.Primary_Category__c = scList[0].Primary_Category__c;
            cs.Secondary_Category__c = scList[0].Secondary_Category__c;
            cs.Tertiary_Category__c = scList[0].Teritiary_Category__c;
            cs.Sla__c = scList[0].SLA__c;
            
        }    
        cs.AccountId = MemberId;
        cs.Status = 'Open';
        cs.Subject = 'Manager Callback - Override Requested';
        cs.ownerid = gp.id;
        cs.CaseComments__c = ManagerCallbackComments;
        cs.Account_Number__c = AccountId;
        cs.MAAP_Log__c = log.id;
        insert cs;
        
        if(cs != null){
            CaseComment cc = new CaseComment();
            cc.ParentId = cs.id;
            cc.CommentBody =  ManagerCallbackComments;
            insert cc;  
        }   
        
        log.Manager_Override_Case__c = cs.id;
        update log;
        //--------------------------------------------End Aut-205 (Manager CallBack)--------------------------------------------------------------------//
        
        
        /* The below code is to create or update Master log data*/
        
        RecordType rec1 = GetRecordTypeData('Authenticated_Log__c', 'Master Authentication Log');       
        List<Authenticated_Log__c> MasterAuthenticationLog = GetDataForMasterAuthenticationLog(IVRGUIDFromUrl, rec1.id);
        if(MasterAuthenticationLog.size() == 0)
        {
            
            Authenticated_Log__c log2 = new Authenticated_Log__c();
            log2.RecordTypeId= rec1.id;
            //  log2.IVR_Sent_URL__c = substring(PageUrl, 1000);
            log2.CallerPhoneNumber__c = substring(PhoneNumber, 16);
            log2.EnteredMemberNumber__c = substring(AccountNumber, 15);
            log2.EnteredSSN__c = substring(EnteredSSN, 4);
            log2.SalesforceID__c = MemberId;
            log2.Decision__c = Decision;
            //   log2.Failed_Desired_Level__c= FDL;
            if(OverrideSupervisor != null && OverrideSupervisor != 'Select'){
                User u = [select id, name from user where name =:OverrideSupervisor limit 1];
                log2.Override_Request_Supervisor__c = OverrideSupervisor;
                log2.Override_Supervisor__c = u.id;
            }
            if(OverrideType != null){  
                log2.Override_Request_Type__c = OverrideType;
            }
            log2.Member__c = MemberId;
            log2.Staff_Name__c =UserInfo.getName();
            log2.Current_User__c = Userinfo.getuserid();
            log2.Member_Number__c = AccountNumber;
            log2.GUID__c = GUID;
            log2.IVR_GUID__c = IVRGUIDFromUrl;
            log2.Manager_Override_Case__c = cs.id;
            insert log2;
        }else{
            //MasterAuthenticationLog[0].IVR_Sent_URL__c = substring(PageUrl, 1000);
            MasterAuthenticationLog[0].CallerPhoneNumber__c = substring(PhoneNumber, 16);
            MasterAuthenticationLog[0].EnteredMemberNumber__c = substring(AccountNumber, 15);
            MasterAuthenticationLog[0].EnteredSSN__c = substring(EnteredSSN, 4);
            MasterAuthenticationLog[0].SalesforceID__c = MemberId;
            MasterAuthenticationLog[0].Decision__c = Decision;
            //   MasterAuthenticationLog[0].Failed_Desired_Level__c= FDL;
            if(OverrideSupervisor != null && OverrideSupervisor != 'Select'){
                User u = [select id, name from user where name =:OverrideSupervisor limit 1];
                MasterAuthenticationLog[0].Override_Request_Supervisor__c = OverrideSupervisor;
                MasterAuthenticationLog[0].Override_Supervisor__c = u.id;
            }
            if(OverrideType != null){  
                MasterAuthenticationLog[0].Override_Request_Type__c = OverrideType;
            }
            MasterAuthenticationLog[0].Member__c = MemberId;
            MasterAuthenticationLog[0].Staff_Name__c =UserInfo.getName();
            MasterAuthenticationLog[0].Current_User__c = Userinfo.getuserid();
            MasterAuthenticationLog[0].Member_Number__c = AccountNumber;
            MasterAuthenticationLog[0].GUID__c = GUID;
            MasterAuthenticationLog[0].Manager_Override_Case__c = cs.id;
            update MasterAuthenticationLog[0];
        }
    }
    
    //--- Created string function-------------//   
    public static string substring(string val, integer length)
    {
        if(val != null && val != '')
        {
            return val.left(length);
        }   
        return val;
    }
    
    @AuraEnabled    
    public static Map<string,List<object>> GetCFCUWalletInfo(String selectedID, string IVRGUIDFromUrl)
    {
        /*--------------------------When Same member data is reloded we need to maintain the state of  CFCU Wallet Tab. 
This function read data from MAAP log object and display accordingly  -----*/
        system.debug('GetCFCUWalletInfo Called##');
        Map<string,List<object>> resultmap = new Map<string,List<object>>();
        Map <id,Person_Account__c> uniqueMembersDetail = new  Map <id,Person_Account__c>();
        List<Account_Details__c> MemberNumberLoanDetail = new List<Account_Details__c>();
        List<Person_Account__c> JTMemberNameDobDetails = new List<Person_Account__c>();
        List<Account_Details__c> cardDetails = new List<Account_Details__c>();
        verifyCaller vc = new verifyCaller();
        
        string JTSelectedID;
        List<JointMemberRelationshipWrapper> JTwrapperLst = new List<JointMemberRelationshipWrapper>();
        List<Account_Details__c> MemberAccountDetail = new List<Account_Details__c>();
        List<Person_Account__c> RelatedPerson = new List<Person_Account__c>();
        // do not query for beneficiary as we don't want information to be displayed for selected user who is a beneficiary.
        RelatedPerson = [select Account_Number__c from Person_Account__c where TypeTranslate__C != '0004/Beneficiary' and PersonID__c =:selectedID];
        List<id> relatedIds = new List<Id>();
        for(Person_Account__c p : relatedPerson ){
            relatedIds.add(p.Account_Number__c);
        }
        system.debug('relatedIds---'+relatedIds);
        MemberAccountDetail  = [Select Name, id,TypeTranslate__c,Balance__c,OPEN_DATE__c ,Close_Date__c,PAYMENT__c from  Account_Details__c where (Parent_Account__c in :relatedIds Or id in :relatedIds)];
        system.debug('MemberNumberDOBDetail----'+MemberAccountDetail );
        set<String> accName = new Set<String>();
        for(Account_Details__c var: MemberAccountDetail){
            accName.add(var.Name);
        }
        List<Person_Account__c> relatedPerson1 = new List<Person_Account__c>();
        relatedPerson1 = [Select Id,personId__c,Account_Number__c,TypeTranslate__c,Account_Type__c,
                          Relationship__c,PersonID__r.SSN_Last_4__pc,Open_Date__c,PersonID__r.BIRTH_DATE__pc,
                          Account_Number__r.Name,Account_Number__r.TypeTranslate__c, PersonID__r.FirstName, PersonID__r.LastName,Person_Account__c.Name ,PersonID__r.Name 
                          from Person_Account__c where 
                          Account_Number__r.Name IN :accName ];
        system.debug('relatedPersonLoan---'+relatedPerson1); 
        
        if(!relatedPerson1.isEmpty())
        {                        
            
            string Thisvalue = 'Primary';        
            Set<id> personId = new Set<id>(); 
            set<id> personId1 = new Set<id>();        
            
            uniqueMembersDetail = new Map <id,Person_Account__c>();      
            for(Person_Account__c mem : relatedPerson1){  
                
                if(!string.isEmpty(mem.TypeTranslate__c)){       
                    
                    if(mem.TypeTranslate__c.contains('Joint Owner') || mem.TypeTranslate__c.contains('Joint Member') || mem.TypeTranslate__c.contains('Member') 
                       || mem.TypeTranslate__c.contains('Beneficiary') || mem.TypeTranslate__C.contains('Authorized Signer')
                       || mem.TypeTranslate__C.contains('Trustee') || mem.TypeTranslate__C.contains('Custodian') || mem.TypeTranslate__C.contains('Primary')
                       || mem.TypeTranslate__c.contains('Representative Payee')
                      )
                    {      
                        system.debug('###  ### 1 - personId ' + personId);
                        system.debug('###  ### 2 - personId ' + mem.personId__c); 
                        system.debug('###  ### 2 - personId ' + selectedID);  
                        if(!personId.contains(mem.personId__c) ){
                            if (selectedID != mem.personId__c)
                            {     
                                personId.add(mem.personId__c);       
                                system.debug('not primary');  
                                system.debug('mem##'+ mem);
                                JTMemberNameDobDetails.add(mem);
                            }             
                        }                                                                
                    }        
                }     
                
            }    
            
            JTSelectedID = '';
            if(!JTMemberNameDobDetails.isEmpty()){ 
                JointMemberRelationshipWrapper JTW;
                system.debug('Not null');
                for(Person_Account__c pc : JTMemberNameDobDetails){ 
                    JTW = new JointMemberRelationshipWrapper();
                    JTW.JointMembername  = pc.PersonID__r.Name;
                    JTW.ID = pc.PersonID__c;
                    JTW.RelationShip = pc.TypeTranslate__c;
                    JTW.AccountNumber = pc.Account_Number__r.Name;
                    JTwrapperLst.add(JTW);
                    
                    if(JTSelectedID == '')
                    {
                        JTSelectedID = JTW.ID + '# # ';
                    }
                    else
                    {
                        
                        JTSelectedID = JTSelectedID + ';' + JTW.ID + '# # ';
                    }
                } 
                
                
                
            }        
            
            
            system.debug('uniqueMembersDetail---'+uniqueMembersDetail);                      
            
            system.debug('JTMemberNameDobDetails'+JTMemberNameDobDetails); 
            system.debug('JTwrapperLst---'+JTwrapperLst); 
        }
        
        resultmap.put('RelationshipData',JTwrapperLst);
        cardDetails = GetCardDetails(selectedID);//vc.CardNumbersAuth(selectedID);
        system.debug('cardDetails'+cardDetails);
        MemberNumberLoanDetail  = [Select Name, id,TypeTranslate__c,Balance__c,OPEN_DATE__c ,Close_Date__c,PAYMENT__c from  Account_Details__c
                                   where (RecType__c = 'LOAN' or RecType__c = 'MORT' or RecType__c = 'SHAR' or RecType__c = 'STDL') AND (Parent_Account__c in :relatedIds Or id in :relatedIds)];
        resultmap.put('LoanData',MemberNumberLoanDetail);
        resultmap.put('CardDetails',cardDetails);
        //--------------------------Code to maintain state of Pass/ Fail Button within a day------------------------------------
        
        /*authlog List is to maintain the state of button when user comes multiple times within same day.We need to maintain Fail state within same businessday if user is coming multiple times. 

This query is working for Relaunch MAAP feature as well*/
        RecordType rec = GetRecordTypeData('Authenticated_Log__c', 'CFCU Wallet Log');
        List<Authenticated_Log__c> authlog = new List<Authenticated_Log__c>();  
        authlog = [Select Id,SalesforceID__c,Current_User__c,Member__c,Decision__c,CFCU_Wallet_Status__c,Staff_Name__c,GUID__c,BeneficiaryDetailMatch__c,Joint_OwnerDetailsMatch__c,
        CardNumberMatch__c,Additional_Token_Option1_Match__c,Additional_Token_Option2_Match__c,Additional_Token_Option5_Match__c, Additional_Token_Option6_Match__c,Loan_Detail_Match__c, Additional_Token_Option1__c,Additional_Token_Option2__c,Additional_Token_Option5__c,Additional_Token_Option6__c
        From Authenticated_Log__c where createddate = Today and RecordTypeId= : rec.id and SalesforceID__c = : selectedID and IVR_GUID__c = :IVRGUIDFromUrl order by createddate desc Limit 1];          
        system.debug('authlog##' + authlog);
        if(authlog.size() == 0){
            authlog = [Select Id,SalesforceID__c,Current_User__c,Member__c,Decision__c,CFCU_Wallet_Status__c,Staff_Name__c,GUID__c,BeneficiaryDetailMatch__c,Joint_OwnerDetailsMatch__c,
            CardNumberMatch__c,Additional_Token_Option1_Match__c,Additional_Token_Option2_Match__c,Additional_Token_Option5_Match__c, Additional_Token_Option6_Match__c,Loan_Detail_Match__c, Additional_Token_Option1__c,Additional_Token_Option2__c,Additional_Token_Option5__c,Additional_Token_Option6__c
            From Authenticated_Log__c where createddate = Today and RecordTypeId= : rec.id and SalesforceID__c = : selectedID and IVR_GUID__c != :IVRGUIDFromUrl  order by createddate desc Limit 1];
            if(authlog.size() > 0){
                
                if(authlog[0].CFCU_Wallet_Status__c == 'Fail'){
                    resultmap.put('CFCULastSessionInfo',authlog);
                }
                
            }
        }
        else{
            resultmap.put('CFCULastSessionInfo',authlog);
        }
        
        
        
        //--------------------------Code to maintain state of Pass/ Fail Button within a day-----------------------------------
        //--------------------------Code to maintain state of Pass/ Fail Button on Reload------------------------------------
        integer minutes = GetMemberAuthenticationSessionTime();
        
        List<Authenticated_Log__c> ReLoadAuthlog = new List<Authenticated_Log__c>();
        List<Authenticated_Log__c> ReLoadManualSession = new List<Authenticated_Log__c>();    
        system.debug('IVRGUIDFromUrl##' + IVRGUIDFromUrl);
        system.debug('selectedID##' + selectedID);
        system.debug('Recordid##' + rec.Id);
        system.debug('minutes##' + minutes);
        Datetime cd = Datetime.now().addMinutes(minutes);
        system.debug('CD##' + cd);
        system.debug('Now##' + Datetime.now());
        
        /*ReLoadAuthlog List is for reload functinality (or call transfer functionality) when we need to maintain the state of buttons as per the minutes mention in our custom setting.*/
        
        ReLoadAuthlog = [Select Id,SalesforceID__c,Member__c,Decision__c,CFCU_Wallet_Status__c,Staff_Name__c,GUID__c,BeneficiaryDetailMatch__c,Joint_OwnerDetailsMatch__c,
        CardNumberMatch__c,Additional_Token_Option1_Match__c,Additional_Token_Option2_Match__c,Additional_Token_Option5_Match__c, Additional_Token_Option6_Match__c,Loan_Detail_Match__c, Additional_Token_Option1__c,Additional_Token_Option2__c,Additional_Token_Option5__c,Additional_Token_Option6__c
          From Authenticated_Log__c where createddate = Today and RecordTypeId= : rec.id and SalesforceID__c = : selectedID AND CreatedDate >=: Datetime.now().addMinutes(minutes) and IVR_GUID__c =:IVRGUIDFromUrl  order by createddate desc Limit 1];
        
        if(ReLoadAuthlog.size() > 0)
        {
            resultmap.put('CFCUReloadInfo',ReLoadAuthlog);
        }else{
            ReLoadAuthlog = [Select Id,SalesforceID__c,Member__c,Decision__c,CFCU_Wallet_Status__c,Staff_Name__c,GUID__c,BeneficiaryDetailMatch__c,Joint_OwnerDetailsMatch__c,
            CardNumberMatch__c,Additional_Token_Option1_Match__c,Additional_Token_Option2_Match__c,Additional_Token_Option5_Match__c, Additional_Token_Option6_Match__c,Loan_Detail_Match__c, Additional_Token_Option1__c,Additional_Token_Option2__c,Additional_Token_Option5__c,Additional_Token_Option6__c
              From Authenticated_Log__c where createddate = Today and RecordTypeId= : rec.id and SalesforceID__c = : selectedID AND CreatedDate >=: Datetime.now().addMinutes(minutes)   order by createddate desc Limit 1];
            if(ReLoadAuthlog.size() > 0)
            {
                resultmap.put('CFCUReloadInfo',ReLoadAuthlog);
            }  
        }
        
        /*ReLoadManualSession list is to load data when user is doing manual search, in first query we have given the intervel of 2 minuts on tab switch for Status = Pass.
within same day on tab switch as we don't need to maintain state of buttons when for "Pass" entry within 24 days.

*/
        ReLoadManualSession = [Select Id,SalesforceID__c,Member__c,Decision__c,CFCU_Wallet_Status__c,Staff_Name__c,GUID__c,BeneficiaryDetailMatch__c,Joint_OwnerDetailsMatch__c,
        CardNumberMatch__c,Additional_Token_Option1_Match__c,Additional_Token_Option2_Match__c,Loan_Detail_Match__c
          From Authenticated_Log__c where createddate = Today and CFCU_Wallet_Status__c='Pass' and RecordTypeId= : rec.id and SalesforceID__c = : selectedID AND CreatedDate >=: Datetime.now().addMinutes(-2)  order by createddate desc Limit 1];
        /*
ReLoadManualSession list is to load data when user is doing manual search if the result of above query is blank, we are searching data for Status ="Fail" as we need to maintain state of buttons within same day for Fail state

*/
        if(ReLoadManualSession.size() == 0)
        {
            ReLoadManualSession = [Select Id,SalesforceID__c,Member__c,Decision__c,CFCU_Wallet_Status__c,Staff_Name__c,GUID__c,BeneficiaryDetailMatch__c,Joint_OwnerDetailsMatch__c,
            CardNumberMatch__c,Additional_Token_Option1_Match__c,Additional_Token_Option2_Match__c,Loan_Detail_Match__c
              From Authenticated_Log__c where createddate = Today and CFCU_Wallet_Status__c='Fail' and RecordTypeId= : rec.id and SalesforceID__c = : selectedID AND CreatedDate >=: Datetime.now().addMinutes(minutes) order by createddate desc Limit 1];
            
            
            resultmap.put('CFCUReloadManulSessionInfo',ReLoadManualSession);
        }
        else{
            resultmap.put('CFCUReloadManulSessionInfo',ReLoadManualSession);
        }
        
        
        
        
        
        //--------------------------Code to maintain state of Pass/ Fail Button on Reload-----------------------------------
        system.debug('resultmap##' + resultmap);
        return resultmap;
        
    }
    
    @AuraEnabled        
    public static Map<string,string> getPublicWalletInfo(String MemberId, string IVRGUIDFromUrl )
    {
        /*--------------------------When Same member data is reloded we need to maintain the state of  Public  Wallet Tab. 
This function read data from MAAP log object and display accordingly  -----*/
        string IDNumberToMatch = '';
        string DLStateIdPassportToMatch='';
        String[] dobparse;
        
        Map<string,string> result = new  Map<string,string>();
        String DLcode;
        String birthDate;
        String ZipCode;
        String MothersMaidenName;
        String EmailList = '';
        Set<String> EmailSet = new Set<String>();
        Set<Id> NonBenificiaryIdSet = new Set<Id>(); 
        List<Account> ListofNonBenificiaryAccount = new List<Account>(); 
        List<Account> listAccount;
        List<accounthistory> listhistory;
        listAccount = [select Id, FirstName, LastName, Email_raw__c, Alternate_Email__pc, PersonEmail from Account where ID =:MemberId];
        list<string> AllRelatedAccounts = GetRelatedAccountsPopulated(MemberId,listAccount[0] );
        system.debug('RelatedAccounts##' + AllRelatedAccounts); 
        String DefaultEmailInList='';
        /*-------------------------------------------Aut-196 implementaion begin----------------------------------------------*/
        //---------------this is to bring all email address including related members in 360 view---------------------------------------------
        if (AllRelatedAccounts != null && AllRelatedAccounts.size() > 0)
        {
            
            listAccount = [select Id, Member_Verification_OTP_Invalid_Attempt__c, Home_Phone__pc, FirstName, LastName, Mobile_Phone__pc, Work_Phone__pc, PersonEmail, Alternate_Email__pc, Email_raw__c,Alt_Email_Raw__c  from Account where ID in :allRelatedAccounts];
            listhistory = [Select accountid,field,OldValue, NewValue, CreatedDate From accounthistory where accountid in :AllRelatedAccounts and field in('PersonEmail','Alternate_Email__pc','Email_raw__c','Alt_Email_Raw__c') order by CreatedDate desc Limit 1];
            if(listhistory.size() > 0){
                if(listhistory[0].NewValue != null){
                    DefaultEmailInList = String.valueof(listhistory[0].NewValue);  
                    EmailSet.add(DefaultEmailInList.toLowercase());
                }
                
            }
            
            if(listAccount.size() > 0)
            {
                for(Account acc: listAccount)
                {
                    if(acc.PersonEmail != null){
                        
                        EmailSet.add(acc.PersonEmail.toLowercase());
                        
                    }
                    if(acc.Alternate_Email__pc != null){
                        
                        EmailSet.add(acc.Alternate_Email__pc.toLowercase());
                    }
                    
                    if(acc.Email_raw__c  != null){
                        
                        EmailSet.add(acc.Email_raw__c.toLowercase());
                    }
                    if(acc.Alt_Email_Raw__c  != null){
                        
                        EmailSet.add(acc.Alt_Email_Raw__c.toLowercase());
                    }
                }
                
                
            }
            
            
            system.debug('EmailSet'+EmailSet);
            
            if(EmailSet.size() > 0){
                for(String s : EmailSet){
                    
                    if(EmailList != ''){
                        EmailList = EmailList + ' , ' + s;
                    }
                    else{
                        EmailList = s;
                    }
                }  
            }
            
            result.put('DefaultEmailInList', DefaultEmailInList);
            result.put('Emails',EmailList);
            
            system.debug('EmailList##' +EmailList);
        }
        
        /*-------------------------------------------Aut-196 implementaion Ends----------------------------------------------*/  
        
        
        
        
        for(Account selectedOne : [select Name,FirstName ,Email_raw__c , Alternate_Email__pc,Residential_Zipocde__pc,  LastName , ID, SSN_Last_4__pc, BIRTH_DATE__pc,Mothers_Maiden_Name__pc, PersonEmail,  ID_1_Description__pc,ID_2_Description__pc,ID_3_Description__pc, ID_1_Number__pc ,ID_2_Number__pc, ID_3_Number__pc, ID_1_Type__pc, ID_2_Type__pc, ID_3_Type__pc, ID_1_Expiration_Date__pc, ID_2_Expiration_Date__pc, ID_3_Expiration_Date__pc, ID_1_Type__c, ID_2_Type__c, ID_3_Type__c from Account where id =:MemberId]){   
            
            if(selectedOne.BIRTH_DATE__pc != null){
                
                dobparse = string.ValueOf(selectedOne.BIRTH_DATE__pc).split('-');
                birthDate = string.ValueOf(dobparse[1]) + '-'+ String.valueOf(dobparse[2])+ '-' + String.valueOf(dobparse[0]);
                result.put('BDate',birthDate);
            }
            else
            {
                
                result.put('BDate','');
            }
            
            if(selectedOne.Residential_Zipocde__pc != null){
                
                ZipCode = selectedOne.Residential_Zipocde__pc;
                result.put('ZCode',ZipCode);
            }
            else
            {
                result.put('ZCode','');
            }
            if(selectedOne.Mothers_Maiden_Name__pc != null){
                MothersMaidenName = selectedOne.Mothers_Maiden_Name__pc;
                result.put('MothersMaidenName',MothersMaidenName);
            }
            else
            {
                result.put('MothersMaidenName','');
            }
            
            
            
            if(selectedOne.ID_1_Type__c == null){ 
                if(selectedOne.ID_2_Type__c != null){
                    string ID_1_Type = '';
                    if(selectedOne.ID_2_Type__pc == null)
                    {
                        ID_1_Type = null;
                    }
                    if(selectedOne.ID_2_Type__pc == 2)
                    {
                        ID_1_Type = 'DL';
                    }
                    else if(selectedOne.ID_2_Type__pc == 3)
                    {
                        ID_1_Type = 'SID';
                    }
                    else if(selectedOne.ID_2_Type__pc == 4 || selectedOne.ID_2_Type__pc == 5)
                    {
                        ID_1_Type = 'PSPT'; 
                    }
                    
                    List<String> valuesToJoin = new List<String>();
                    
                    
                    selectedOne.ID_2_Description__pc = (selectedOne.ID_2_Description__pc == '' || selectedOne.ID_2_Description__pc == null) ? '' : string.valueof(selectedOne.ID_2_Description__pc) + ' | ';
                    
                    DLStateIdPassportToMatch = ((ID_1_Type == '' || ID_1_Type == null) ? '' : string.valueof(ID_1_Type) + ' | ') + selectedOne.ID_2_Description__pc   + '' + (selectedOne.ID_2_Number__pc == null? '' : string.valueof(selectedOne.ID_2_Number__pc)+ ' | ') + '' + (selectedOne.ID_2_Expiration_Date__pc == null? '' : string.valueof(selectedOne.ID_2_Expiration_Date__pc.date()));
                    
                    if(DLStateIdPassportToMatch.endsWith(' | '))
                    {
                        DLStateIdPassportToMatch = DLStateIdPassportToMatch.substring(0,DLStateIdPassportToMatch.lastIndexOf(' | '));
                    }                        
                }
                else
                {
                    string ID_1_Type = '';
                    if(selectedOne.ID_3_Type__pc == null)
                    {
                        ID_1_Type = null;
                    }
                    if(selectedOne.ID_3_Type__pc == 2)
                    {
                        ID_1_Type = 'DL';
                    }
                    else if(selectedOne.ID_3_Type__pc == 3)
                    {
                        ID_1_Type = 'SID';
                    }
                    else if(selectedOne.ID_3_Type__pc == 4 || selectedOne.ID_3_Type__pc == 5)
                    {
                        ID_1_Type = 'PSPT'; 
                    }
                    
                    selectedOne.ID_3_Description__pc = (selectedOne.ID_3_Description__pc == '' || selectedOne.ID_3_Description__pc == null) ? '' : string.valueof(selectedOne.ID_3_Description__pc) + ' | ';
                    
                    DLStateIdPassportToMatch = ((ID_1_Type == '' || ID_1_Type == null) ? '' : string.valueof(ID_1_Type) + ' | ') + selectedOne.ID_3_Description__pc   + '' + (selectedOne.ID_3_Number__pc == null? '' : string.valueOf(selectedOne.ID_3_Number__pc) +' | ') + '' + (selectedOne.ID_3_Expiration_Date__pc == null? '' : string.valueof(selectedOne.ID_3_Expiration_Date__pc.date()));
                    
                    if(DLStateIdPassportToMatch.endsWith(' | '))
                    {
                        DLStateIdPassportToMatch = DLStateIdPassportToMatch.substring(0,DLStateIdPassportToMatch.lastIndexOf(' | '));
                    }
                }
            }
            else{
                string ID_1_Type = '';
                if(selectedOne.ID_1_Type__pc == null)
                {
                    ID_1_Type = null;
                }
                if(selectedOne.ID_1_Type__pc == 2)
                {
                    ID_1_Type = 'DL';
                }
                else if(selectedOne.ID_1_Type__pc == 3)
                {
                    ID_1_Type = 'SID';
                }
                else if(selectedOne.ID_1_Type__pc == 4|| selectedOne.ID_1_Type__pc == 5)
                {
                    ID_1_Type = 'PSPT'; 
                }
                
                selectedOne.ID_1_Description__pc = (selectedOne.ID_1_Description__pc == '' || selectedOne.ID_1_Description__pc == null) ? '' : string.valueof(selectedOne.ID_1_Description__pc) + ' | ';
                
                DLStateIdPassportToMatch =  ((ID_1_Type == '' || ID_1_Type == null) ? '' : string.valueof(ID_1_Type) + ' | ') + selectedOne.ID_1_Description__pc  +''+ (selectedOne.ID_1_Number__pc == null ? '' : string.valueof(selectedOne.ID_1_Number__pc) + ' | ') + '' + (selectedOne.ID_1_Expiration_Date__pc == null? '' : string.valueof(selectedOne.ID_1_Expiration_Date__pc.date()));
                
                if(DLStateIdPassportToMatch.endsWith(' | '))
                {
                    DLStateIdPassportToMatch = DLStateIdPassportToMatch.substring(0,DLStateIdPassportToMatch.lastIndexOf(' | '));
                }
            }
            
            // Set ID Number Status 
            system.debug('IdNumber---'+DLStateIdPassportToMatch);
            
            if (DLStateIdPassportToMatch != '')
            {
                DLcode = DLStateIdPassportToMatch;
                result.put('DLcode', DLcode);
            }
            //--------------------------Code to maintain state of Pass/ Fail Button within a day------------------------------------
            RecordType rec = GetRecordTypeData('Authenticated_Log__c', 'Public Wallet Log');
            List<Authenticated_Log__c> authlog = new List<Authenticated_Log__c>();  
            authlog = [Select Id,SalesforceID__c,Current_User__c,Member__c,Public_Wallet_Status__c,DOBMatch__c,IdNumberMatch__c,MMNMatch__c,EmailMatch__c,Additional_Token_Option3_Match__c, Additional_Token_Option3__c, Additional_Token_Option4__c,Additional_Token_Option4_Match__c
            From Authenticated_Log__c where createddate = Today and RecordTypeId= : rec.id and SalesforceID__c = : MemberId order by createddate desc Limit 1];          
            if(authlog.size() > 0)
            {
                result.put('PublicWalletStatus',authlog[0].Public_Wallet_Status__c);
                result.put('DOBMatch',authlog[0].DOBMatch__c);
                result.put('IdNumberMatch',authlog[0].IdNumberMatch__c);
                result.put('MMNMatch',authlog[0].MMNMatch__c);
                result.put('EmailMatch',authlog[0].EmailMatch__c);
                result.put('AdditionalTokenMatch',authlog[0].Additional_Token_Option3_Match__c);
                result.put('Additional_Token_Option3__c',authlog[0].Additional_Token_Option3__c);
                result.put('AdditionalToken4Match',authlog[0].Additional_Token_Option4_Match__c);
                result.put('Additional_Token_Option4__c',authlog[0].Additional_Token_Option4__c);                
            }
            //--------------------------Code to maintain state of Pass/ Fail Button within a day-----------------------------------
            
            //--------------------------Code to maintain state of Pass/ Fail Button on Reload------------------------------------
            integer minutes = GetMemberAuthenticationSessionTime();
            
            List<Authenticated_Log__c> ReLoadAuthlog = new List<Authenticated_Log__c>();  
            ReLoadAuthlog = [Select Id,SalesforceID__c,Current_User__c,Member__c,Public_Wallet_Status__c,DOBMatch__c,IdNumberMatch__c,MMNMatch__c,EmailMatch__c,Additional_Token_Option3_Match__c
            From Authenticated_Log__c where createddate = Today and RecordTypeId= : rec.id and SalesforceID__c = : MemberId AND CreatedDate >=: Datetime.now().addMinutes(minutes) and IVR_GUID__c =:IVRGUIDFromUrl];          
            if(ReLoadAuthlog.size() > 0)
            {
                result.put('RePublicWalletStatus',ReLoadAuthlog[0].Public_Wallet_Status__c);
                result.put('ReDOBMatch',ReLoadAuthlog[0].DOBMatch__c);
                result.put('ReIdNumberMatch',ReLoadAuthlog[0].IdNumberMatch__c);
                result.put('ReMMNMatch',ReLoadAuthlog[0].MMNMatch__c);
                result.put('ReEmailMatch',ReLoadAuthlog[0].EmailMatch__c);
                result.put('ReAdditionalTokenMatch',ReLoadAuthlog[0].Additional_Token_Option3_Match__c);
                
            }
            //--------------------------Code to maintain state of Pass/ Fail Button on Reload-----------------------------------
            
        }  
        return result;
    }
    
    @AuraEnabled
    public static Map<string,object> GetFailedDesiredLevelLog(string MemberId)
    {
        /* This method is to display count of 'Failed desired level Within 7 days' warning */
        Boolean IsFailedDesiredLevel;
        Map<string,object> result = new  Map<string,object>();
        List<Authenticated_Log__c> authlog = new List<Authenticated_Log__c>();  
        authlog = [select id,createddate ,Decision__c from Authenticated_Log__c where createddate = Last_n_days:7 
                   and SalesforceID__c =:MemberId and RecordType.name = 'IVR Authentication Log' and Decision__c='Failed Desired Level'];
        
        if(authlog.size() > 0){
            IsFailedDesiredLevel = true;
        }
        else{
            IsFailedDesiredLevel = false;
        }
        result.put('Visible',IsFailedDesiredLevel);
        result.put('Count',authlog.size());
        return result;
        
    }
    @AuraEnabled
    
    public static Map<string,object> MemberVerificationAttemptsCheck(string MemberId, string GUID, string DebitCardStatus, String SSNFromURL, String MemberNumberFromURL,String PhoneFromURL, String PageURL, string IVRGUIDFromUrl, boolean ReLoadRequired, string ReasonCodeFromURL, string HighFlagFromUrl, integer PointsObtained, boolean IsOOWTabVisible, boolean IsUserSessionLoaded, string EnteredCardNumber, string CardNumberMatch, string PhoneNumberMatch, string MemberNumberMatch, string SSNnumberMatch, string PINMatch, string CardOwnerSSNFromURL)
    {
        /* 1. This method calls when member is selected from radio button
2. For reload of same window based on IVRGUID and time set under custom setting with ReLoadRequired flag
3. For reload of data based on current logged in user with IsUserSessionLoaded flag value   
*/
        system.debug('MemberVerificationAttemptsCheck Called-------');
        system.debug('SSNFromURL##' + SSNFromURL);
        system.debug('DebitCardStatus##'+ DebitCardStatus);
        system.debug('PhoneFromURL##' + PhoneFromURL);
        system.debug('MemberNumberFromURL##' + MemberNumberFromURL);
        system.debug('PageURL##' + PageURL);
        system.debug('IVRGUIDFromUrl##' + IVRGUIDFromUrl);
        system.debug('ReLoadRequired##' + ReLoadRequired);
        system.debug('PointsObtained##' + PointsObtained);
        system.debug('IsOOWTabVisible##' + IsOOWTabVisible);
        system.debug('EnteredCardNumber##' + EnteredCardNumber);
        system.debug('CardNumberMatch##' + CardNumberMatch);
        system.debug('PhoneNumberMatch##' + PhoneNumberMatch);
        system.debug('MemberNumberMatch##' + MemberNumberMatch);
        system.debug('SSNnumberMatch##' + SSNnumberMatch);
        system.debug('PINMatch##' + PINMatch);
        system.debug('IsUserSessionLoaded##' + IsUserSessionLoaded);
        system.debug('CardOwnerSSNFromURL##' + CardOwnerSSNFromURL);
        
        Boolean visible;
        Double attempt=0;
        Boolean OOW = true;
        Boolean OTP = true;
        Boolean PublicWallet = true;
        Boolean CFCUWallet = true;
        string PWColor ='Grey' ;
        string CWColor ='Grey' ;
        string OOWColor ='Grey';
        string OTPColor ='Grey';
        Map<string,object> result = new  Map<string,object>();
        Boolean FailedDesiredLevelCount;
        List<MC_PIN_Change__c> PC = new List<MC_PIN_Change__c>();
        List<Authenticated_Log__c> FDLog = new List<Authenticated_Log__c>();
        boolean IsPinChanged;
        string  AccountNumber;
        Integer MemberHighFlagValue =0 ;
        Boolean IsCardOwnerSSNMatch=true;
        
        set<string> typeList = new set<string>();
        for(Member360_TypeTranslate__c t : Member360_TypeTranslate__c.getAll().values()){
            typeList.add(t.name);  
        }
        List<Person_Account__c> PAccount = [SELECT Id,  Account_Number__c, PersonID__r.Name, PersonID__c, Account_Number__r.RecType__c, TypeTranslate__c, Account_Number__r.Name 
                                            FROM Person_Account__c where PersonID__c =:MemberId and TypeTranslate__c IN:typeList order by TypeTranslate__c asc];
        system.debug('MemberNumberFromURL##'+ MemberNumberFromURL);
        Set<String> AccountNumberSet = new Set<String>();
        if(PAccount.size() > 0)
        {
            for(Person_Account__c pa: PAccount)
            {
                AccountNumberSet.add(pa.Account_Number__r.Name);
            }
            if(AccountNumberSet.contains(MemberNumberFromURL))
            {
                AccountNumber = MemberNumberFromURL;
            }
            else
            {
                AccountNumber = PAccount[0].Account_Number__r.Name;
            }
            pc = [select id,Transmission_Date__c,CreatedDate,Member_Number__c,Function__c from MC_PIN_Change__c where Member_Number__c =: AccountNumber and CreatedDate = LAST_N_DAYS:30 and Function__c = 'PIN Change'];
            if(pc.size() > 0){
                IsPinChanged = true;
                result.put('PINChange',IsPinChanged);
            }
            else{
                IsPinChanged = false;
                result.put('PINChange',IsPinChanged);
            }
        }
        system.debug('AccountNumber##'+ AccountNumber);
        system.debug('IsPinChanged##'+ IsPinChanged);
        FDLog = [select id,createddate ,Decision__c from Authenticated_Log__c where createddate = yesterday 
                 and SalesforceID__c =:MemberId and RecordType.name = 'IVR Authentication Log' and Decision__c='Failed Desired Level'];
        
        if(FDLog.size() > 0){
            
            result.put('FDLogPreviousDay',true);
        }
        else{
            result.put('FDLogPreviousDay',false);
        }       
        system.debug('FDLog##'+ FDLog);
        List<Account> accList = [select id, PersonID__c,PersonID__pc from Account where id= : MemberId];
        string PersonID;
        string MemberType;
        
        system.debug('accList##'+ accList);
        if(accList.size()> 0)
        {
            PersonID = accList[0].PersonID__c;
            
        }
        if(PersonID!= null && PersonID.startsWith('C'))
        {
            MemberType ='Foreign';
        }
        else
        {
            MemberType ='Domestic';
        }
        system.debug('MemberType##'+ MemberType);
        result.put('MemberType',MemberType);
        
        string MemberSSN;
        if (accList[0].PersonID__pc != null) {
            MemberSSN=accList[0].PersonID__pc.substring(1,accList[0].PersonID__pc.length());
        }
        
        if(CardOwnerSSNFromURL != null && MemberSSN == CardOwnerSSNFromURL){
            IsCardOwnerSSNMatch=true;
        }
        else{
            IsCardOwnerSSNMatch=false;
        }
        
        system.debug('MemberSSN'+MemberSSN)  ;
        system.debug('IsCardOwnerSSNMatch'+IsCardOwnerSSNMatch)  ;
        //------------------------ Code for  # Of Calls Same Member/KYM Today Begin-----------------------------------------------------//
        
        List<Member_Verification_Attempt__c> mt = [Select id,Member_Name__c, Member_Salesforce_Id__c, Number_of_Attempts__c, IVR_GUID__C from Member_Verification_Attempt__c where Member_Salesforce_Id__c =:MemberId and Authentication_Type__c != 'OTP' and CreatedDate = Today];
        Set<String> EnderedGUIDSet = new Set<String>();
        system.debug('IVRGUIDFromURL##'+ IVRGUIDFromURL);
        if(mt.size() > 0){
            
            for(Member_Verification_Attempt__c mva : mt)
            {
                EnderedGUIDSet.add(mva.IVR_GUID__C);
                system.debug('EnderedGUIDSet##'+ EnderedGUIDSet);
            }
            
            if(EnderedGUIDSet.contains(IVRGUIDFromURL))
            {
                attempt = mt.size();
                system.debug('attempt##'+ attempt);
            }else{
                System.debug('Member_Verification_Attempt__c called');
                Member_Verification_Attempt__c mva = new Member_Verification_Attempt__c();
                mva.Member_Salesforce_Id__c = MemberId;
                mva.Member_Name__c = AccountNumber;
                mva.Number_of_Attempts__c = 1;
                mva.IVR_GUID__C = IVRGUIDFromURL;
                
                insert mva;
                system.debug('mva##'+ mva);  
                attempt = mt.size() + 1;
                
            }
            
            
        }else if(mt.size() == 0 && ReLoadRequired == false){
            System.debug('Member_Verification_Attempt__c called');
            Member_Verification_Attempt__c mva = new Member_Verification_Attempt__c();
            mva.Member_Salesforce_Id__c = MemberId;
            mva.Member_Name__c = AccountNumber;
            mva.Number_of_Attempts__c = 1;
            mva.IVR_GUID__C = IVRGUIDFromURL;
            attempt = 1;
            insert mva;
            system.debug('mva##'+ mva);  
            
            
        }

         /*CRM-1742: Unusual Activity Warning*/

	  List<Case> CaseListUnusualActivity= [Select id from Case where Category__c = 'Account Maintenance / Special Situations / Unusual Activity' and AccountId =: MemberId and (status != 'Closed' OR (status = 'Closed' and ClosedDate = Last_N_Days:7))];
	  if(CaseListUnusualActivity.size() > 0)
	  {
		result.put('UnusualActivity',true);
	  }
	  else{
		result.put('UnusualActivity',false);
	  }
        
      
        
        // //------------------------ Code for  # Of Calls Same Member/KYM Today End -----------------------------------------------------//
        //--------------------------------------------- Identify OTP Tab color  ----------------------------------------------------------------//
        
        String OTPStatus;
        String OOWStatus;
        string PWStatus;
        string CFCUStatus;
        if(IsUserSessionLoaded == true)
        {  
           
            for(Authenticated_Log__c OTPlog : [select id,createddate, GUID__c,Decision__c,OOW_Status__c,OTP_Status__c,CFCU_Wallet_Status__c,Public_Wallet_Status__c,Member__c, RecordType.name from Authenticated_Log__c where createddate = Today and  OTP_Status__c != null and SalesforceID__c =:MemberId and RecordType.name = 'OTP Authentication Log'  order by RecordType.name, createddate desc limit 1]){
                OTPStatus = OTPlog.OTP_Status__c;
            }
            if(OTPStatus == 'Fail'){
                OTP = false;
                OTPColor ='Red';
            }
            if(OTPStatus == 'Pass'){
                for(Authenticated_Log__c OTPPasslog : [select id,createddate, GUID__c,Decision__c,OOW_Status__c,OTP_Status__c,CFCU_Wallet_Status__c,Public_Wallet_Status__c,Member__c, RecordType.name from Authenticated_Log__c where createddate = Today and  OTP_Status__c != null and SalesforceID__c =:MemberId and RecordType.name = 'OTP Authentication Log' and IVR_GUID__c = : IVRGUIDFromUrl order by RecordType.name, createddate desc limit 1]){
                    if(OTPPasslog.OTP_Status__c == 'Pass'){
                        OTPColor = 'Green';
                    }
                }
            }
            
        }else{
            
            for(Authenticated_Log__c OTPlog : [select id,createddate, GUID__c,Decision__c,OOW_Status__c,OTP_Status__c,CFCU_Wallet_Status__c,Public_Wallet_Status__c,Member__c, RecordType.name from Authenticated_Log__c where createddate = Today and  OTP_Status__c != null and SalesforceID__c =:MemberId and RecordType.name = 'OTP Authentication Log' order by RecordType.name, createddate desc limit 1]){
                
                if(OTPlog.OTP_Status__c == 'Fail' ){
                    OTP = false;
                    OTPColor ='Red';
                    OTPStatus = 'Fail';
                }
                if(OTPlog.OTP_Status__c == 'Pass' ){
                    OTPColor ='Grey';
                    OTPStatus = 'Pass';
                   
                }
            }
            
        }
        
        
        system.debug('OTPColor##'+ OTPColor);
        result.put('OTPColor', OTPColor);
        
        
        
        //--------------------------------------------- Identify OOW Tab color ----------------------------------------------------------------//
        
        if(IsUserSessionLoaded == true)
        {      
           
            for(Authenticated_Log__c OOWlog : [select id,createddate ,GUID__c, Decision__c,OOW_Status__c,OTP_Status__c,CFCU_Wallet_Status__c,Public_Wallet_Status__c,Member__c, RecordType.name from Authenticated_Log__c where createddate = Today and SalesforceID__c =:MemberId and RecordType.name = 'OOW Execution Log'  order by RecordType.name, createddate desc limit 1]){
                OOWStatus = OOWlog.OOW_Status__c;
                
            }
            if(OOWStatus == 'Fail'){
                OOW = false;
                OOWColor = 'Red';
            }
            if(OOWStatus == 'Pass'){
                for(Authenticated_Log__c OOWPasslog : [select id,createddate ,GUID__c, Decision__c,OOW_Status__c,OTP_Status__c,CFCU_Wallet_Status__c,Public_Wallet_Status__c,Member__c, RecordType.name from Authenticated_Log__c where createddate = Today and SalesforceID__c =:MemberId and RecordType.name = 'OOW Execution Log' and IVR_GUID__c = : IVRGUIDFromUrl order by RecordType.name, createddate desc limit 1]){
                    if(OOWPasslog.OOW_Status__c == 'Pass'){
                        OOWColor ='Green';
                    }
                }
                
            }
            
        }else{
            
            for(Authenticated_Log__c OOWlog : [select id,createddate ,GUID__c, Decision__c,OOW_Status__c,OTP_Status__c,CFCU_Wallet_Status__c,Public_Wallet_Status__c,Member__c, RecordType.name from Authenticated_Log__c where createddate = Today and SalesforceID__c =:MemberId and RecordType.name = 'OOW Execution Log'  order by RecordType.name, createddate desc limit 1]){
                
                if(OOWlog.OOW_Status__c == 'Fail'){
                    OOW = false;
                    OOWColor ='Red';
                    OOWStatus = 'Fail';
                }
                
                if(OOWlog.OOW_Status__c == 'Pass'){
                    OOWColor ='Grey';
                    OOWStatus = 'Pass';
                }
            }
            
        }
        
        
        result.put('OOWColor', OOWColor);
        system.debug('OOWColor##'+ OOWColor);
        //--------------------------------------------- Identify Public Wallet Tab color ----------------------------------------------------------------//
        
        if(IsUserSessionLoaded == true)
        {        
           
            for(Authenticated_Log__c Publiclog : [select id,createddate ,GUID__c, Decision__c,OOW_Status__c,OTP_Status__c,CFCU_Wallet_Status__c,Public_Wallet_Status__c,Member__c, RecordType.name from Authenticated_Log__c where createddate = Today and SalesforceID__c =:MemberId and RecordType.name = 'Public Wallet Log' order by RecordType.name, createddate desc limit 1]){
                PWStatus = Publiclog.Public_Wallet_Status__c;
            }
            if(PWStatus == 'Fail'){
                PublicWallet = false;
                PWColor ='Red';
               
            }
            if(PWStatus == 'Pass'){
                for(Authenticated_Log__c PublicPasslog : [select id,createddate ,GUID__c, Decision__c,OOW_Status__c,OTP_Status__c,CFCU_Wallet_Status__c,Public_Wallet_Status__c,Member__c, RecordType.name from Authenticated_Log__c where createddate = Today and SalesforceID__c =:MemberId and RecordType.name = 'Public Wallet Log' and IVR_GUID__c = : IVRGUIDFromUrl order by RecordType.name, createddate desc limit 1]){
                    if(PublicPasslog.Public_Wallet_Status__c =='Pass'){
                        PWColor ='Green';
                    }
                }
            }
            
        }else{
            for(Authenticated_Log__c Publiclog : [select id,createddate ,GUID__c, Decision__c,OOW_Status__c,OTP_Status__c,CFCU_Wallet_Status__c,Public_Wallet_Status__c,Member__c, RecordType.name from Authenticated_Log__c where createddate = Today and SalesforceID__c =:MemberId and RecordType.name = 'Public Wallet Log'  order by RecordType.name, createddate desc limit 1]){
                if(Publiclog.Public_Wallet_Status__c == 'Fail'){
                    PublicWallet = false;
                    PWColor ='Red';
                    PWStatus = 'Fail';
                }
                if(Publiclog.Public_Wallet_Status__c == 'Pass'){
                    PWColor ='Grey';
                    PWStatus = 'Pass';
                }
            }
        }
        
        
        
        system.debug('PWColor##'+ PWColor); 
        result.put('PWColor', PWColor);
        
        //--------------------------------------------- Identify CFCU Wallet Tab color ----------------------------------------------------------------//
        if(IsUserSessionLoaded == true)
        {
          
            for(Authenticated_Log__c CFCUlog : [select id,createddate ,GUID__c, Decision__c,OOW_Status__c,OTP_Status__c,CFCU_Wallet_Status__c,Public_Wallet_Status__c,Member__c, RecordType.name from Authenticated_Log__c where createddate = Today and SalesforceID__c =:MemberId and RecordType.name = 'CFCU Wallet Log' order by RecordType.name, createddate desc limit 1]){
                CFCUStatus = CFCUlog.CFCU_Wallet_Status__c;
            }
            if(CFCUStatus == 'Fail'){
                CFCUWallet = false;
                CWColor ='Red';
            }
            if(CFCUStatus == 'Pass'){
                for(Authenticated_Log__c CFCUPasslog : [select id,createddate ,GUID__c, Decision__c,OOW_Status__c,OTP_Status__c,CFCU_Wallet_Status__c,Public_Wallet_Status__c,Member__c, RecordType.name from Authenticated_Log__c where createddate = Today and SalesforceID__c =:MemberId and RecordType.name = 'CFCU Wallet Log' and IVR_GUID__c = : IVRGUIDFromUrl order by RecordType.name, createddate desc limit 1]){
                    if(CFCUPasslog.CFCU_Wallet_Status__c == 'Pass')
                    {
                        CWColor ='Green';
                    }
                }
            }
        }else{
            
            for(Authenticated_Log__c CFCUlog : [select id,createddate ,GUID__c, Decision__c,OOW_Status__c,OTP_Status__c,CFCU_Wallet_Status__c,Public_Wallet_Status__c,Member__c, RecordType.name from Authenticated_Log__c where createddate = Today and SalesforceID__c =:MemberId and RecordType.name = 'CFCU Wallet Log'  order by RecordType.name, createddate desc limit 1]){
                if(CFCUlog.CFCU_Wallet_Status__c == 'Fail'){
                    CFCUWallet = false;
                    CWColor ='Red';
                    CFCUStatus = 'Fail';
                }
                if(CFCUlog.CFCU_Wallet_Status__c == 'Pass'){
                    CWColor ='Grey';
                    CFCUStatus = 'Pass';
                }
            }
        }
        
        
        system.debug('CWColor##'+ CWColor);
        result.put('CWColor', CWColor);
          
        system.debug('ttt'+visible)  ;
        result.put('Visible',visible); 
        result.put('Attempts',attempt);
        result.put('OOWStatusForDay',OOW);
        result.put('OTPStatusForDay',OTP);
        result.put('PublicWalletStatusForDay',PublicWallet) ;
        result.put('CFCUWalletStatusForDay',CFCUWallet);
        result.put('AccountNumber',AccountNumber);
        result.put('IsCardOwnerSSNMatch',IsCardOwnerSSNMatch);
        List<Authenticated_Log__c> authlog = new List<Authenticated_Log__c>();  
        authlog = [select id,createddate ,Decision__c from Authenticated_Log__c where createddate = Last_n_days:7 
                   and SalesforceID__c =:MemberId and RecordType.name = 'IVR Authentication Log' and Decision__c='Failed Desired Level'];
        
        if(authlog.size() > 0){
            FailedDesiredLevelCount = true;
        }
        else{
            FailedDesiredLevelCount = false;
        }
        result.put('Show Failed Desired Level',authlog.size());
        
        // Implementation to achieve level of authentication based on Open tab
        
        List<Member_Authentication_Level_Model__c> LevelModel = new List<Member_Authentication_Level_Model__c>();
        
        List<Member_Authentication_Scoring_Model__c> ScoringModel = new List<Member_Authentication_Scoring_Model__c>();
        
        LevelModel = GetMemberAuthenticationLevel();
        ScoringModel = GetScoringModelData(MemberType);
        
        Double TotalScore=0;
        
        map<string,Integer> scoremap = new map<string,Integer>();
        set<Integer> scoreset = new set<Integer>();
        double ScoreRequired;
        // check for KYM tab
        Boolean IsKYMAvailable = false;
        Id profileId=userinfo.getProfileId();
        Profile UserProfile = [Select Id,Name from Profile where Id=:profileId];
        system.debug('ProfileName'+UserProfile);
        if(UserProfile.Name == 'Branch'){
            IsKYMAvailable = true;
            
        }
        else{
            IsKYMAvailable = false;
        }
        
        
        // check for OPT tab based on cancelled attempt
        Boolean IsOTPAvailable = true;
        
        
        //  check based on Debit card 
        
        Boolean IsDebitPinAvailable = false;
        if(DebitCardStatus == 'true'){
            IsDebitPinAvailable = true;
        }else{
            IsDebitPinAvailable = false;
        }  
        
        // check based on combination of OOW/OTP/Public and CFCU Wallet
        
        Boolean IsPublicWalletAvailable = false;
        Boolean IsOOWAvailable = false;
        Boolean IsCFCUWalletAvailable = false;
        
        if(PublicWallet == true )
        {
            IsPublicWalletAvailable = true;
        }
        if(CFCUWallet == true )
        {
            IsCFCUWalletAvailable = true;
        }
        system.debug('test1');
        if(OOW == true)
        {
            IsOOWAvailable = true;
            system.debug('test1');
        }
        string DebitPinStatus='';
        if(DebitCardStatus =='true' && IsCardOwnerSSNMatch == true){
            DebitPinStatus ='Pass';
        }
        else if(DebitCardStatus =='false' && IsCardOwnerSSNMatch == false){
            DebitPinStatus ='Fail';
        }
        system.debug('IsUserSessionLoaded##' + IsUserSessionLoaded);
        system.debug('DebitPinStatus##' + DebitPinStatus);
        
        if(ReLoadRequired == true && IsUserSessionLoaded == false)
        {
            system.debug('MemberVerificationAttemptsCheck getDataForReload Called for ReLoadRequired == true && IsUserSessionLoaded == false-------');
            system.debug('getDataForReload Parameters##'+ IVRGUIDFromUrl + '#' +  DebitPinStatus + '#' + '#' + IsUserSessionLoaded +  AccountNumber );
            Map<string,object> AutLogDataMap =  getDataForReload(memberid, GUID, IVRGUIDFromUrl,DebitPinStatus, IsUserSessionLoaded, AccountNumber);
            if(AutLogDataMap.get('IsOOWAvailable') == true)
            {
                OOW = true;
            }
            else
            {
                OOW = false;
            }
            if(AutLogDataMap.get('IsPublicWalletAvailable') == true)
            {
                PublicWallet = true;
            }
            else
            {
                PublicWallet = false;
            }
            if(AutLogDataMap.get('IsCFCUWalletAvailable') == true)
            {
                CFCUWallet = true;
            }
            else
            {
                CFCUWallet = false;
            }
            if(AutLogDataMap.get('IsOTPAvailable') == true)
            {
                OTP = true;
                
            }
            else
            {
                OTP = false;
                IsOTPAvailable = false;
            }           
            
            
            result.put('NextTabLevel2', AutLogDataMap.get('NextTabLevel2'));
            result.put('NextTabLevel3', AutLogDataMap.get('NextTabLevel3'));
            result.put('IsLevel1Achieved', AutLogDataMap.get('IsLevel1Achieved'));
            result.put('IsLevel2Achieved', AutLogDataMap.get('IsLevel2Achieved'));
            result.put('IsLevel3Achieved', AutLogDataMap.get('IsLevel3Achieved'));           
            
            
        }
        
        
        // calculation for total score available   
        if(IsKYMAvailable == true)
        {
            for(Member_Authentication_Scoring_Model__c sm: ScoringModel)
            {
                if(sm.Authentication_Type__c == 'KYM')
                {
                    TotalScore = TotalScore + sm.Positive_Point_Value__c;
                    scoremap.put(sm.Authentication_Type__c,sm.Positive_Point_Value__c.intValue());
                    scoreset.add(sm.Positive_Point_Value__c.intValue());
                }
                else
                {
                    TotalScore = TotalScore;
                }
            }
        }
        
        system.debug('KYM' + IsKYMAvailable);
        system.debug('TotalScore KYM' + TotalScore);
        if(OTP == true)
        {
            for(Member_Authentication_Scoring_Model__c sm: ScoringModel)
            {
                if(sm.Authentication_Type__c == 'OTP')
                {
                    TotalScore = TotalScore + sm.Positive_Point_Value__c;
                    scoremap.put(sm.Authentication_Type__c,sm.Positive_Point_Value__c.intValue());
                    scoreset.add(sm.Positive_Point_Value__c.intValue());
                }
                else
                {
                    TotalScore = TotalScore;
                }
            }
        }
        system.debug('OTP' + IsOTPAvailable);
        system.debug('TotalScore OTP' + TotalScore);
        double DebitPinScore =0;
        if(DebitCardStatus == 'true'){
            for(Member_Authentication_Scoring_Model__c sm: ScoringModel)
            {
                if(sm.Authentication_Type__c == 'Debit Pin')
                {
                    DebitPinScore =  sm.Positive_Point_Value__c;
                    
                }
                
            }
        }
        
        system.debug('DEBIT PIN' + IsDebitPinAvailable);
        system.debug('TotalScore Debit' + TotalScore);
        
        if(MemberType =='Foreign')
        {
            IsOOWTabVisible = false;
            IsOOWAvailable = false;
        }
        else
        {
            IsOOWTabVisible = true;
            IsOOWAvailable = true;
        }
        
        if(OOW == true){
            for(Member_Authentication_Scoring_Model__c sm: ScoringModel)
            {
                if(sm.Authentication_Type__c == 'OOW')
                {
                    TotalScore = TotalScore + sm.Positive_Point_Value__c;
                    scoremap.put(sm.Authentication_Type__c,sm.Positive_Point_Value__c.intValue());
                    scoreset.add(sm.Positive_Point_Value__c.intValue());
                }
                else
                {
                    TotalScore = TotalScore;
                }
            }
        }
        
        system.debug('OOW' + IsOOWAvailable);
        system.debug('TotalScore OOW' + TotalScore);
        
        if(PublicWallet == true){
            for(Member_Authentication_Scoring_Model__c sm: ScoringModel)
            {
                if(sm.Authentication_Type__c == 'Public Wallet')
                {
                    TotalScore = TotalScore + sm.Positive_Point_Value__c;
                    scoremap.put(sm.Authentication_Type__c,sm.Positive_Point_Value__c.intValue());
                    scoreset.add(sm.Positive_Point_Value__c.intValue());
                }
                else
                {
                    TotalScore = TotalScore;
                }
            }
        }
        
        system.debug('Public' + IsPublicWalletAvailable);
        system.debug('TotalScore Public' + TotalScore);
        
        
        if(CFCUWallet == true){
            for(Member_Authentication_Scoring_Model__c sm: ScoringModel)
            {
                if(sm.Authentication_Type__c == 'CFCU Wallet')
                {
                    TotalScore = TotalScore + sm.Positive_Point_Value__c;
                    scoremap.put(sm.Authentication_Type__c,sm.Positive_Point_Value__c.intValue());
                    scoreset.add(sm.Positive_Point_Value__c.intValue());
                }
                else
                {
                    TotalScore = TotalScore;
                }
            }
        }
        system.debug('Cfcu' + IsCFCUWalletAvailable );
        system.debug('TotalScore Public' + TotalScore);
        
        
        List<Integer> scorelist = new list<Integer>(scoreset);
        scorelist.sort();
        List<Integer> finalList = new List<Integer>();
        for(Integer i = scorelist.size()-1; i>=0;i--)
        {
            finalList.add(scorelist.get(i));
        }
        
        
        system.debug('Size##'+ scorelist.size());
        system.debug('scorelist##'+ scorelist);
        system.debug('finalList##'+ finalList);
        
        
        // ------------------Inserting log while user came from URL ----------------------------------//
        
        if(ReLoadRequired == false && IsUserSessionLoaded == false){
            system.debug('PageURL' + PageURL);
            if(PageURL == ' '){
                Account_Details__c acc_Detail = [SELECT Id,Name,RecType__c,High_Value_Flag__c  FROM Account_Details__c WHERE Name =:AccountNumber AND RecType__c= 'ACCT'];
                if(acc_Detail.High_Value_Flag__c != null)
                    MemberHighFlagValue = acc_Detail.High_Value_Flag__c.intValue();  
                result.put('MemberHighFlagValue',MemberHighFlagValue);  
            }  
            if(PageURL != null || PageURL != ' '){
                RecordType rec = GetRecordTypeData('Authenticated_Log__c', 'IVR Authentication Log');
                Authenticated_Log__c log = new Authenticated_Log__c();
                log.IVR_Sent_URL__c = PageURL;
                log.CallerPhoneNumber__c = PhoneFromURL;
                log.EnteredMemberNumber__c = MemberNumberFromURL;
                log.EnteredCardNumber__c = EnteredCardNumber;
                //   log.CardNumberMatch__c = CardNumberMatch;
                log.PhoneNumberMatch__c = PhoneNumberMatch;
                log.MemberNumberMatch__c = MemberNumberMatch;
                log.SSNnumberMatch__c = SSNnumberMatch;
                
                if(SSNFromURL.length() > 4){
                    log.EnteredSSN__c = SSNFromURL.right(4);
                    log.IVR_SSN__c = SSNFromURL;
                }
                else
                {
                    log.EnteredSSN__c = SSNFromURL;
                    log.IVR_SSN__c = SSNFromURL;
                }
                log.IVR_Card_Number__c = EnteredCardNumber;
                log.IVR_Member_Number__c = MemberNumberFromURL;
                log.IVR_Member_Number_Match__c = MemberNumberMatch;
                log.IVR_SSN_Match__c = SSNnumberMatch;
                log.IVR_Card_Match__c = CardNumberMatch;
                
                if(DebitCardStatus == 'true')
                    log.IVR_Pin_Match__c = 'Pass';
                if(DebitCardStatus == 'false')
                    log.IVR_Pin_Match__c = 'Fail';
                
                log.Staff_Name__c = UserInfo.getName();
                log.Current_User__c = Userinfo.getuserid();
                log.Member_Number__c = AccountNumber;
                log.GUID__c = GUID;
                log.IVR_GUID__c = IVRGUIDFromUrl;
                log.PINMatch__c = PINMatch;
                log.RecordtypeId = rec.Id; 
                log.SalesforceID__c = MemberId;
                log.Member__c = MemberId;
                log.HP_HV__c = HighFlagFromUrl;
                log.IVR_Code__c = ReasonCodeFromURL;
                log.CardOwnerSSN__c = CardOwnerSSNFromURL;
                insert log;
                
                system.debug('log##' + log);
                
                RecordType rec1 = GetRecordTypeData('Authenticated_Log__c', 'Debit PIN Log');
                Authenticated_Log__c log1 = new Authenticated_Log__c();
                log1.IVR_Sent_URL__c = PageURL;
                if(DebitCardStatus == 'true'){
                    log1.IVR_Pin_Match__c = 'Pass';
                    log1.PINMatch__c = 'Pass';
                    log1.Decision__c = 'Pass';
                }
                if(DebitCardStatus == 'false'){
                    log1.IVR_Pin_Match__c = 'Fail';
                    log1.PINMatch__c = 'Fail';
                    log1.Decision__c = 'Fail';
                }
                log1.GUID__c = GUID;
                log1.Staff_Name__c = UserInfo.getName();
                log1.Member_Number__c = AccountNumber;
                log1.RecordtypeId = rec1.Id; 
                log1.SalesforceID__c = MemberId;
                log1.Member__c = MemberId;
                log1.IVR_GUID__c = IVRGUIDFromUrl;
                log1.Staff_Name__c = UserInfo.getName();
                log1.Current_User__c = Userinfo.getuserid();      
                insert log1;
                system.debug('log1##' + log1);
                
                /* The below code is to create or update Master log data*/
                RecordType rec2 = GetRecordTypeData('Authenticated_Log__c', 'Master Authentication Log');       
                List<Authenticated_Log__c> MasterAuthenticationLog = GetDataForMasterAuthenticationLog(IVRGUIDFromUrl, rec2.id);
                if(MasterAuthenticationLog.size() == 0)
                {
                    
                    Authenticated_Log__c log2 = new Authenticated_Log__c();
                    log2.IVR_Sent_URL__c = PageURL;
                    log2.CallerPhoneNumber__c = PhoneFromURL;
                    log2.EnteredMemberNumber__c = MemberNumberFromURL;
                    log2.EnteredCardNumber__c = EnteredCardNumber;
                    // log2.CardNumberMatch__c = CardNumberMatch;
                    log2.PhoneNumberMatch__c = PhoneNumberMatch;
                    log2.MemberNumberMatch__c = MemberNumberMatch;
                    log2.SSNnumberMatch__c = SSNnumberMatch;
                    
                    if(SSNFromURL.length() > 4){
                        log2.EnteredSSN__c = SSNFromURL.right(4);
                        log2.IVR_SSN__c = SSNFromURL;
                    }
                    else
                    {
                        log2.EnteredSSN__c = SSNFromURL;
                        log2.IVR_SSN__c = SSNFromURL;
                    }
                    log2.IVR_Card_Number__c = EnteredCardNumber;
                    log2.IVR_Member_Number__c = MemberNumberFromURL;
                    log2.IVR_Member_Number_Match__c = MemberNumberMatch;
                    log2.IVR_SSN_Match__c = SSNnumberMatch;
                    log2.IVR_Card_Match__c = CardNumberMatch;
                    
                    if(DebitCardStatus == 'true')
                        log.IVR_Pin_Match__c = 'Pass';
                    if(DebitCardStatus == 'false')
                        log.IVR_Pin_Match__c = 'Fail';
                    
                    log2.Staff_Name__c = UserInfo.getName();
                    log2.Current_User__c = Userinfo.getuserid();
                    log2.Member_Number__c = AccountNumber;
                    log2.GUID__c = GUID;
                    log2.IVR_GUID__c = IVRGUIDFromUrl;
                    log2.PINMatch__c = PINMatch;
                    log2.RecordtypeId = rec.Id; 
                    log2.SalesforceID__c = MemberId;
                    log2.Member__c = MemberId;
                    log2.HP_HV__c = HighFlagFromUrl;
                    log2.IVR_Code__c = ReasonCodeFromURL;
                    if(DebitCardStatus == 'true'){
                        log2.IVR_Pin_Match__c = 'Pass';
                        log2.PINMatch__c = 'Pass';
                        log2.Decision__c = 'Pass';
                    }
                    if(DebitCardStatus == 'false'){
                        log2.IVR_Pin_Match__c = 'Fail';
                        log2.PINMatch__c = 'Fail';
                        log2.Decision__c = 'Fail';
                    }
                    log2.RecordtypeId = rec2.Id; 
                    log2.CardOwnerSSN__c = CardOwnerSSNFromURL;
                    insert log2;
                    system.debug('log1##' + log2);
                    
                    
                }else{
                    
                    MasterAuthenticationLog[0].IVR_Sent_URL__c = PageURL;
                    MasterAuthenticationLog[0].CallerPhoneNumber__c = PhoneFromURL;
                    MasterAuthenticationLog[0].EnteredMemberNumber__c = MemberNumberFromURL;
                    MasterAuthenticationLog[0].EnteredCardNumber__c = EnteredCardNumber;
                    //MasterAuthenticationLog[0].CardNumberMatch__c = CardNumberMatch;
                    MasterAuthenticationLog[0].PhoneNumberMatch__c = PhoneNumberMatch;
                    MasterAuthenticationLog[0].MemberNumberMatch__c = MemberNumberMatch;
                    MasterAuthenticationLog[0].SSNnumberMatch__c = SSNnumberMatch;
                    
                    if(SSNFromURL.length() > 4){
                        MasterAuthenticationLog[0].EnteredSSN__c = SSNFromURL.right(4);
                        MasterAuthenticationLog[0].IVR_SSN__c = SSNFromURL;
                    }
                    else
                    {
                        MasterAuthenticationLog[0].EnteredSSN__c = SSNFromURL;
                        MasterAuthenticationLog[0].IVR_SSN__c = SSNFromURL;
                    }
                    MasterAuthenticationLog[0].IVR_Card_Number__c = EnteredCardNumber;
                    MasterAuthenticationLog[0].IVR_Member_Number__c = MemberNumberFromURL;
                    MasterAuthenticationLog[0].IVR_Member_Number_Match__c = MemberNumberMatch;
                    MasterAuthenticationLog[0].IVR_SSN_Match__c = SSNnumberMatch;
                    MasterAuthenticationLog[0].IVR_Card_Match__c = CardNumberMatch;
                    
                    if(DebitCardStatus == 'true')
                        MasterAuthenticationLog[0].IVR_Pin_Match__c = 'Pass';
                    if(DebitCardStatus == 'false')
                        MasterAuthenticationLog[0].IVR_Pin_Match__c = 'Fail';
                    
                    MasterAuthenticationLog[0].Staff_Name__c = UserInfo.getName();
                    MasterAuthenticationLog[0].Current_User__c = Userinfo.getuserid();
                    MasterAuthenticationLog[0].Member_Number__c = AccountNumber;
                    MasterAuthenticationLog[0].GUID__c = GUID;
                    MasterAuthenticationLog[0].IVR_GUID__c = IVRGUIDFromUrl;
                    MasterAuthenticationLog[0].PINMatch__c = PINMatch;
                    MasterAuthenticationLog[0].RecordtypeId = rec.Id; 
                    MasterAuthenticationLog[0].SalesforceID__c = MemberId;
                    MasterAuthenticationLog[0].Member__c = MemberId;
                    MasterAuthenticationLog[0].HP_HV__c = HighFlagFromUrl;
                    MasterAuthenticationLog[0].IVR_Code__c = ReasonCodeFromURL;
                    if(DebitCardStatus == 'true'){
                        MasterAuthenticationLog[0].IVR_Pin_Match__c = 'Pass';
                        MasterAuthenticationLog[0].PINMatch__c = 'Pass';
                        MasterAuthenticationLog[0].Decision__c = 'Pass';
                    }
                    if(DebitCardStatus == 'false'){
                        MasterAuthenticationLog[0].IVR_Pin_Match__c = 'Fail';
                        MasterAuthenticationLog[0].PINMatch__c = 'Fail';
                        MasterAuthenticationLog[0].Decision__c = 'Fail';
                    }
                    MasterAuthenticationLog[0].RecordtypeId = rec2.Id; 
                    MasterAuthenticationLog[0].CardOwnerSSN__c = CardOwnerSSNFromURL;
                    update MasterAuthenticationLog[0];
                }
                
                
            }
        }
        // ------------------Inserting log while user came from URL Ends----------------------------------//
        
        //------------------- Fetching Auth Logs for last 30 days achievable level--------------------//
        
        List<Authenticated_Log__c> LastAchieveLogs = new List<Authenticated_Log__c>();
        LastAchieveLogs = [select id,Last_Achievable_Level__c, GUID__c from Authenticated_Log__c where createdDate = Last_n_days:30 and SalesforceID__c =:MemberId and RecordType.name = 'IVR Authentication Log' and Last_Achievable_Level__c != null order by CreatedDate desc Limit 1];
        String level = ' ';
        if(LastAchieveLogs.size() > 0){
            result.put('LastAchievableLevel',LastAchieveLogs[0].Last_Achievable_Level__c);
        }
        
        //------------------- Fetching Auth Logs for last 30 days achievable level ends here--------------------//
        
        //---------------------To Get Which level is achieved on load and what would be the next achievable level based on Debitcard status begin--------------------------//
        //Aut-190 implementation starts here
        if(ReLoadRequired == false && IsUserSessionLoaded == false)
        {
            system.debug('MemberVerificationAttemptsCheck GetTabsToAchieveNextLevel Called for ReLoadRequired == false && IsUserSessionLoaded == false-------');
            
            integer OTPAvailable = 0;
            integer PublicWalletAvailable = 0;
            integer CFCUWalletAvailable = 0;
            integer OOWAvailable = 0;
            integer CurrentScore = 0;
            boolean IsLevel1Achieved = false;
            boolean IsLevel2Achieved = false;
            boolean IsLevel3Achieved = false;
            system.debug('OOWStatus##' +  OOWStatus);
			system.debug('PWStatus##' +  PWStatus);
			system.debug('CFCUStatus##' +  CFCUStatus);
			system.debug('OTPStatus##' +  OTPStatus);
            if(OTP == true){OTPAvailable=1;}
            if(PublicWallet == true){PublicWalletAvailable=1;}
            if(CFCUWallet == true){CFCUWalletAvailable=1;}
            if(IsOOWTabVisible == true){
                if(OOW == true){
                    OOWAvailable=1;
                }
                else
                {
                    OOWAvailable=0;
                }
            }
            else
            {
                OOWAvailable=0;
            }
            Decimal DebitPinPositiveScore;
            Decimal DebitPinNegativeScore;
            Decimal PINChangeNegativeScore;
            Decimal PINChangePositiveScore;
            system.debug('IsOOWTabVisible#'+ IsOOWTabVisible);
            system.debug('PublicWalletAvailable#'+ PublicWalletAvailable);
            system.debug('CFCUWalletAvailable#'+ CFCUWalletAvailable);
            system.debug('OOWAvailable#'+ OOWAvailable);
            system.debug('DebitPinStatus##'+ DebitPinStatus);  
            system.debug('CurrentScorePre##'+ CurrentScore);
            system.debug('DebitPinNegativeScore##'+ DebitPinNegativeScore);

            for(Member_Authentication_Scoring_Model__c sm : ScoringModel  )
            {
                
                if(sm.Authentication_Type__c == 'Debit Pin' )
                {
                    system.debug('sm.Negative_Point_Value__c##'+ sm.Negative_Point_Value__c);
                    DebitPinPositiveScore = sm.Positive_Point_Value__c;
                    DebitPinNegativeScore = sm.Negative_Point_Value__c;
                }
                if(sm.Authentication_Type__c == 'PIN Change'){
                    
                    PINChangeNegativeScore = sm.Negative_Point_Value__c;
                    PINChangePositiveScore = sm.Positive_Point_Value__c;        
                }
               
                if(sm.Authentication_Type__c == 'Public Wallet' &&  PWStatus == 'Pass' && PWColor == 'Green' ){
                    CurrentScore = CurrentScore + sm.Positive_Point_Value__c.intValue();
                }
                if(sm.Authentication_Type__c =='Public Wallet' &&  PWStatus == 'Fail' && PWColor == 'Red'){
                    CurrentScore = CurrentScore - sm.Negative_Point_Value__c.intValue();
                }
                if(sm.Authentication_Type__c == 'CFCU Wallet' &&  CFCUStatus == 'Pass' && CWColor == 'Green' ){
                    CurrentScore = CurrentScore + sm.Positive_Point_Value__c.intValue();
                }
                if(sm.Authentication_Type__c == 'CFCU Wallet' &&  CFCUStatus == 'Fail' && CWColor == 'Red'){
                    CurrentScore = CurrentScore - sm.Negative_Point_Value__c.intValue();
                }
                if(sm.Authentication_Type__c == 'OOW' &&  OOWStatus == 'Pass' && OOWColor == 'Green'){
                    CurrentScore = CurrentScore + sm.Positive_Point_Value__c.intValue();
                }
                if(sm.Authentication_Type__c == 'OOW' &&  OOWStatus == 'Fail' && OOWColor == 'Red'){
                    CurrentScore = CurrentScore - sm.Negative_Point_Value__c.intValue();

                }
                if(sm.Authentication_Type__c == 'OTP' &&  OTPStatus == 'Pass' && OTPColor == 'Green'){
                    CurrentScore = CurrentScore + sm.Positive_Point_Value__c.intValue();
                }
                if(sm.Authentication_Type__c == 'OTP' &&  OTPStatus == 'Fail' && OTPColor == 'Red'){
                    CurrentScore = CurrentScore - sm.Negative_Point_Value__c.intValue();

                }
                
                
            }
            if(DebitPinStatus == 'Fail' || DebitPinStatus =='false'){
                CurrentScore = CurrentScore - DebitPinNegativeScore.intValue();
            }
            else if(DebitPinStatus == 'Pass' || DebitPinStatus =='true')
            {
                CurrentScore = CurrentScore + DebitPinPositiveScore.intValue();
            }
            system.debug('CurrentScorePost1##' + CurrentScore);
            system.debug('IsPinChanged##' + IsPinChanged);
            if(IsPinChanged == true ){
                CurrentScore = CurrentScore - PINChangeNegativeScore.intValue();
                
            }
            else if(IsPinChanged == false ){
                
                CurrentScore = CurrentScore + PINChangePositiveScore.intValue();
            }
            system.debug('CurrentScorePost2##' + CurrentScore);
            
            result.put('CurrentScore', CurrentScore);
            //----Added by Deepika on Aug-20-2020 if user click on relaunch MAAP button before save and goto member page (crm-1839) -----------------------------------//
            list<Member_Verification_Attempt__c> mva = new List<Member_Verification_Attempt__c>();          
            mva =  [Select id, IVR_GUID__c, Member_Salesforce_Id__c, Points_Obtained__c, Maximum_Points_Available__c, Current_Authentication_Level__c, Highest_Achievable_Level__c, Next_Level__c from Member_Verification_Attempt__c where IVR_GUID__c=:IVRGUIDFromUrl and Member_Salesforce_Id__c =: memberid order by createddate desc limit 1];
            if(mva.size() > 0){
                System.debug('Member_Verification_Attempt__c called');
                mva[0].Points_Obtained__c = CurrentScore;
                mva[0].Maximum_Points_Available__c = TotalScore;
                update mva;
            }
            //----Added by Deepika on Aug-20-2020 if user click on relaunch MAAP button before save and goto member page (crm-1839)   Ends Here-----------------------------------//
            system.debug('GetTabsToAchieveNextLevel Parameters##'+ MemberType + 'DebitPinStatus#' +  DebitPinStatus + 'IsPinChanged#' + IsPinChanged + 'OTPAvailable#' + OTPAvailable + 'PublicWalletAvailable#' + PublicWalletAvailable + 'CFCUWalletAvailable#'+ CFCUWalletAvailable + 'OOWAvailable#' + OOWAvailable + 'CurrentScore#'+ CurrentScore);
            map<string, List<string>> NextTabToAchieveLevelMap =  GetTabsToAchieveNextLevel(LevelModel, ScoringModel, MemberType, DebitPinStatus, IsPinChanged, OTPAvailable, PublicWalletAvailable, CFCUWalletAvailable,OOWAvailable, CurrentScore);
            List<string>  NextTabLevel2 = NextTabToAchieveLevelMap.get('NextTabLevel2');
            List<string>  NextTabLevel3 = NextTabToAchieveLevelMap.get('NextTabLevel3');
            List<string> EachLevelStatus = NextTabToAchieveLevelMap.get('EachLevelStatus');
            
            
            if(NextTabLevel2.size() > 0)
            {
                string NextTabLevel2LastString = NextTabLevel2.get(NextTabLevel2.size()-1);
                NextTabLevel2LastString = NextTabLevel2LastString.removeEnd('or');
                NextTabLevel2.remove((NextTabLevel2.size()-1));
                NextTabLevel2.add(NextTabLevel2LastString);
                system.debug('NextTabLevel2LastString#'+ NextTabLevel2LastString);
            }
            if(NextTabLevel3.size() > 0){
                string NextTabLevel3LastString = NextTabLevel3.get(NextTabLevel3.size()-1);      
                NextTabLevel3LastString = NextTabLevel3LastString.removeEnd('or');      
                NextTabLevel3.remove((NextTabLevel3.size()-1));      
                NextTabLevel3.add(NextTabLevel3LastString);
                system.debug('NextTabLevel3LastString#'+ NextTabLevel3LastString);
            }
            
            system.debug('NextTabLevel2List#'+ NextTabLevel2);
            system.debug('NextTabLevel3List#'+ NextTabLevel3);
            
            if(EachLevelStatus.size() >0)
            {
                for(string s: EachLevelStatus){
                    
                    if(s == 'Level 2 Achieved'){
                        IsLevel2Achieved = true;
                    }
                    if(s == 'Level 3 Achieved'){
                        IsLevel3Achieved = true;
                    }
                }
            }
            
            
            if(IsLevel2Achieved == true){
                result.put('NextTabLevel2', 'Level Reached');
            }
            else if(IsLevel2Achieved == false && NextTabLevel2.size()==0){
                result.put('NextTabLevel2', 'Not Achievable');
                
            }
            else if(IsLevel2Achieved == false && NextTabLevel2.size()> 0){
                result.put('NextTabLevel2', NextTabLevel2);
            }
            if(IsLevel3Achieved == true){
                result.put('NextTabLevel3', 'Level Reached');
            }
            else if(IsLevel3Achieved == false && NextTabLevel3.size()==0){
                result.put('NextTabLevel3', 'Not Achievable');
                
            }
            else if(IsLevel3Achieved == false && NextTabLevel3.size()> 0){
                result.put('NextTabLevel3', NextTabLevel3);
            }
           
            result.put('IsLevel1Achieved',IsLevel1Achieved);
            result.put('IsLevel2Achieved',IsLevel2Achieved);
            result.put('IsLevel3Achieved',IsLevel3Achieved);
            
            system.debug('NextTabLevel2List#'+ NextTabLevel2);
            system.debug('NextTabLevel3List#'+ NextTabLevel3);
        }
        
        
        
        //----------------------To Get Which level is achieved on load and what would be the next achievable level based on Debitcard status ends----------------------------------------------------//
        
        /* Code for Aut-267 begin to display message on member number search when one member is associated with multiple member account*/
        verifyCaller vc = new verifyCaller();
        List<Account_Details__c> memberDetails = new List<Account_Details__c>();
        Set<String> memberDetailsNames = new Set<String>();
        string MultipleMemberNumberAlert='';
        memberDetails = vc.AccountNumbersAuth(MemberId);
        System.Debug('memberDetails##'+ memberDetails);   
        if(MemberNumberFromURL != null || MemberNumberFromURL != '')
        {
            
            
            for(Account_Details__c acctD : memberDetails)
            {
                memberDetailsNames.add(acctD.Name); 
                System.Debug('accD##' + acctD);                       
            }
            system.debug('memberDetails.size()....'+memberDetails.size());
            system.debug('memberDetailsNames....'+memberDetailsNames.size());                               
            system.debug('memberDetailsNames##'+ memberDetailsNames);
            integer i = memberDetailsNames.size();                   
            if (i > 1)
            {
                MultipleMemberNumberAlert = 'This person is related to more than one member number';    
            }
            else if(i == 0)
            {
                MultipleMemberNumberAlert = 'This person is not related to any member number';
            }
            
        }
        else if(SSNFromURL != null ||  SSNFromURL !='')
        {
            for(Account_Details__c acctD : memberDetails)
            {
                memberDetailsNames.add(acctD.Name); 
                System.Debug('accD##' + acctD);                       
            }
            system.debug('memberDetails.size()....'+memberDetails.size());
            system.debug('memberDetailsNames....'+memberDetailsNames.size());                               
            system.debug('memberDetailsNames##'+ memberDetailsNames);
            integer i = memberDetailsNames.size();                   
            if (i > 1)
            {
                MultipleMemberNumberAlert = 'This person is related to more than one member number';    
            }
            else if(i == 0)
            {
                MultipleMemberNumberAlert = 'This person is not related to any member number';
            }
        }
        
        //This will get Warning Code for Member
        list<string> rwcwList = new list<string>();
        rwcwList = GetMemberWarningCodes(MemberId);

        result.put('MultipleMemberNumberAlert', MultipleMemberNumberAlert);
        
        
        
        result.put('IsKYMAvailable',IsKYMAvailable);
        result.put('IsOTPAvailable',IsOTPAvailable);
        result.put('IsDebitPinAvailable',IsDebitPinAvailable);
        result.put('IsOOWAvailable',IsOOWAvailable);
        result.put('IsPublicWalletAvailable',IsPublicWalletAvailable);
        result.put('IsCFCUWalletAvailable',IsCFCUWalletAvailable);
        
        result.put('MaximumPointsAvailable',TotalScore);
        result.put('LevelModel', LevelModel);
        result.put('ScoringModel', ScoringModel);

        
        result.put('WarningCodes',rwcwList);
        system.debug('result##' + result);
        return result;
    }
    
    
    @AuraEnabled
    
    public static map<string, List<string>> GetTabsToAchieveNextLevel(List<Member_Authentication_Level_Model__c> LevelModel, List<Member_Authentication_Scoring_Model__c> ScoringModel, string MemberType, string DebitPinStatus, boolean IsPinChanged, integer IsOTPAvailable, integer IsPublicWalletAvailable,integer IsCFCUWalletAvailable,integer IsOOWAvailable, integer CurrentScore)
    {
        /* This method tells the journey path*/ 
        system.debug('GetTabsToAchieveNextLevel Param received##'+ MemberType + 'DebitPinStatus#' + DebitPinStatus + 'IsPinChanged#' + IsPinChanged + 'IsOTPAvailable#' + IsOTPAvailable +  'IsPublicWalletAvailable#' + IsPublicWalletAvailable + 'IsCFCUWalletAvailable#' +IsCFCUWalletAvailable +  'IsOOWAvailable' + IsOOWAvailable +  'CurrentScore#'+ CurrentScore );
        system.debug('CurrentScore##'+ CurrentScore);
        map<string, List<string>> resultMap = new map<string, List<string>>();
        Decimal DebitPinPositiveScore;
        Decimal DebitPinNegativeScore;
        Decimal PINChangeNegativeScore;
        Decimal PINChangePositiveScore;
        Decimal PublicWalletScore;
        Decimal CFCUWalletScore;
        Decimal OTPScore;
        Decimal OOWScore;
        Decimal Level2Limit;
        Decimal Level3Limit;
        List<string>  NextTabLevel2 = new List<string>();
        List<string>  NextTabLevel3 = new List<string>();
        List<string>  EachLevelStatus = new List<string>();
        system.debug('ScoringModel##'+ ScoringModel);
        // reading the data from custom setting and assining points value into variables begin-----------------
        for(Member_Authentication_Scoring_Model__c sm : ScoringModel  )
        {
            if(sm.Authentication_Type__c == 'Public Wallet')
            {
                PublicWalletScore = sm.Positive_Point_Value__c;
            }
            if(sm.Authentication_Type__c == 'CFCU Wallet'){
                
                CFCUWalletScore = sm.Positive_Point_Value__c;        
            }
            if(sm.Authentication_Type__c == 'OTP'){
                
                OTPScore = sm.Positive_Point_Value__c;        
            }
            if(sm.Authentication_Type__c == 'OOW'){
                
                OOWScore = sm.Positive_Point_Value__c;        
            }
            if(sm.Authentication_Type__c == 'Debit Pin' )
            {
                system.debug('sm.Negative_Point_Value__c##'+ sm.Negative_Point_Value__c);
                DebitPinPositiveScore = sm.Positive_Point_Value__c;
                DebitPinNegativeScore = sm.Negative_Point_Value__c;
            }
            if(sm.Authentication_Type__c == 'PIN Change'){
                
                PINChangeNegativeScore = sm.Negative_Point_Value__c;
                PINChangePositiveScore = sm.Positive_Point_Value__c;        
            }
            
        }
        
        /*system.debug('DebitPinStatus##'+ DebitPinStatus);  
system.debug('CurrentScorePre##'+ CurrentScore);
system.debug('DebitPinNegativeScore##'+ DebitPinNegativeScore);
if(DebitPinStatus == 'Fail' || DebitPinStatus =='false'){
CurrentScore = CurrentScore - DebitPinNegativeScore.intValue();
}
else if(DebitPinStatus == 'Pass' || DebitPinStatus =='true')
{
CurrentScore = CurrentScore + DebitPinPositiveScore.intValue();
}
system.debug('CurrentScorePost1##' + CurrentScore);
system.debug('IsPinChanged##' + IsPinChanged);
if(IsPinChanged == true ){
CurrentScore = CurrentScore - PINChangeNegativeScore.intValue();

}
else if(IsPinChanged == false ){

CurrentScore = CurrentScore + PINChangePositiveScore.intValue();
}
system.debug('CurrentScorePost2##' + CurrentScore);
*/
        // reading the data from custom setting and assining points value into variables Ends-----------------
        
        // reading the data from custom setting for level and assining start range value of levels into variables begins-----------------
        for(Member_Authentication_Level_Model__c lm :LevelModel )
        {
            
            if(lm.Tiers__c == 'Level 2' )
            {
                Level2Limit = lm.Range_Start__c;
                if(CurrentScore > = lm.Range_Start__c){
                    
                    EachLevelStatus.add('Level 2 Achieved');
                }
            }
            if(lm.Tiers__c == 'Level 3' )
            {
                Level3Limit = lm.Range_Start__c;
                if(CurrentScore > = lm.Range_Start__c){
                    
                    EachLevelStatus.add('Level 3 Achieved');
                }            
            }
        }
        system.debug('EachLevelStatus#' + EachLevelStatus);
        system.debug('Level2Limit#' + Level2Limit);
        system.debug('PublicWalletScore#' + PublicWalletScore);
        system.debug('CFCUWalletScore#' + CFCUWalletScore);
        system.debug('OTPScore#' + OTPScore);
        system.debug('OOWScore#' + OOWScore);
        // reading the data from custom setting for level and assining start range value of levels into variables Ends-----------------
        
        // Calculation logic is written below to get the journey path-----------------------------------------
        
        /*-------------------------------------------------------------------Level 2 combination of 1 Tab-------------------------------------------------------------------------------------------*/
        If(IsPublicWalletAvailable == 1 && Level2Limit > CurrentScore && (((IsPublicWalletAvailable * PublicWalletScore) + CurrentScore) >= Level2Limit)){
            
            NextTabLevel2.add('Pub Wallet or');
            
        }
        
        If(IsCFCUWalletAvailable == 1 && Level2Limit > CurrentScore && (((IsCFCUWalletAvailable * CFCUWalletScore) + CurrentScore) >= Level2Limit)){
            
            NextTabLevel2.add('CFCU Wallet or');
            
        }
        system.debug('IsOTPAvailable##' + IsOTPAvailable);
        system.debug('Level2Limit##' + Level2Limit);
        system.debug('CurrentScore##' + CurrentScore);
        system.debug('OTPScore##' + OTPScore);
        If(IsOTPAvailable == 1 && Level2Limit > CurrentScore && (((IsOTPAvailable * OTPScore) + CurrentScore) >= Level2Limit)){
            
            NextTabLevel2.add('OTP or');
            
        }
        system.debug('IsOOWAvailable##' + IsOOWAvailable);
        system.debug('CurrentScore##' + CurrentScore);
        system.debug('OOWScore##' + OOWScore);
        system.debug('Level2Limit##' + Level2Limit);
        If(IsOOWAvailable == 1 && Level2Limit > CurrentScore && (((IsOOWAvailable * OOWScore) + CurrentScore) >= Level2Limit)){
            
            NextTabLevel2.add('OOW or');
            
        }
        
        /*-------------------------------------------------------------------Level 2 combination of 2 Tabs-------------------------------------------------------------------------------------------*/
        system.debug('IsPublicWalletAvailable##'+ IsPublicWalletAvailable);
        system.debug('IsCFCUWalletAvailable##'+ IsCFCUWalletAvailable);
        system.debug('CFCUWalletScore##'+ CFCUWalletScore);
        system.debug('PublicWalletScore##'+ PublicWalletScore);
        
        if((CurrentScore < Level2Limit) &&  (((IsPublicWalletAvailable * IsCFCUWalletAvailable) *  (PublicWalletScore + CFCUWalletScore + CurrentScore)) >= Level2Limit) && 
           ((CFCUWalletScore + CurrentScore ) < Level2Limit ) &&
           ((PublicWalletScore + CurrentScore ) < Level2Limit )
          )
        {
            
            NextTabLevel2.add('(Public Wallet + CFCU Wallet) or');
        }
        
        if((CurrentScore < Level2Limit) &&  (((IsPublicWalletAvailable * IsOOWAvailable) *  (PublicWalletScore + OOWScore + CurrentScore)) >= Level2Limit) && 
           ((OOWScore + CurrentScore ) < Level2Limit ) &&
           ((PublicWalletScore + CurrentScore ) < Level2Limit )
          )
        {
            
            NextTabLevel2.add('(Public Wallet + OOW) or');
        }
        
        if((CurrentScore < Level2Limit) &&  (((IsPublicWalletAvailable * IsOTPAvailable) *  (PublicWalletScore + OTPScore + CurrentScore)) >= Level2Limit) && 
           ((OTPScore + CurrentScore ) < Level2Limit ) &&
           ((PublicWalletScore + CurrentScore ) < Level2Limit )
          )
        {
            
            NextTabLevel2.add('(Public Wallet + OTP) or');
        }
        
        if((CurrentScore < Level2Limit) &&  (((IsCFCUWalletAvailable * IsOOWAvailable) *  (CFCUWalletScore + OOWScore + CurrentScore)) >= Level2Limit) && 
           ((OOWScore + CurrentScore ) < Level2Limit ) &&
           ((CFCUWalletScore + CurrentScore ) < Level2Limit )
          )
        {
            
            NextTabLevel2.add('(CFCU Wallet + OOW) or');
        }
        
        if((CurrentScore < Level2Limit) &&  (((IsCFCUWalletAvailable * IsOTPAvailable) *  (CFCUWalletScore + OTPScore + CurrentScore)) >= Level2Limit) && 
           ((OTPScore + CurrentScore ) < Level2Limit ) &&
           ((CFCUWalletScore + CurrentScore ) < Level2Limit )
          )
        {          
            NextTabLevel2.add('(CFCU Wallet + OTP) or');
        }
        
        if((CurrentScore < Level2Limit) &&  (((IsOOWAvailable * IsOTPAvailable) *  (OOWScore + OTPScore + CurrentScore)) >= Level2Limit) && 
           ((OTPScore + CurrentScore ) < Level2Limit ) &&
           ((OOWScore + CurrentScore ) < Level2Limit )
          )
        {          
            NextTabLevel2.add('(OOW + OTP) or');
        }
        /*--------------------------------------------------------------------Level 2 Combination of 3------------------------------------------------------------------------------------------*/
        if((CurrentScore < Level2Limit) &&  (((IsCFCUWalletAvailable * IsOOWAvailable * IsOTPAvailable) *  (CFCUWalletScore + OOWScore +OTPScore + CurrentScore)) >= Level2Limit) && 
           ((OOWScore + CurrentScore ) < Level2Limit ) &&
           ((OTPScore + CurrentScore ) < Level2Limit ) &&
           ((CFCUWalletScore + CurrentScore ) < Level2Limit ) && 
           ((OTPScore + OOWScore + CFCUWalletScore +  CurrentScore) >= Level2Limit) &&   
           ((CFCUWalletScore + OTPScore + CurrentScore ) < Level2Limit) &&
           ((CFCUWalletScore + OOWScore + CurrentScore ) < Level2Limit) &&
           ((OOWScore + OTPScore + CurrentScore ) < Level2Limit) 
           
          )
        {
            
            NextTabLevel2.add('(CFCU Wallet + OOW + OTP) or');
        }
        if((CurrentScore < Level2Limit) &&  (((IsPublicWalletAvailable * IsOOWAvailable * IsOTPAvailable) *  (PublicWalletScore + OOWScore +OTPScore + CurrentScore)) >= Level2Limit) && 
           ((OOWScore + CurrentScore ) < Level2Limit ) &&
           ((OTPScore + CurrentScore ) < Level2Limit ) &&
           ((PublicWalletScore + CurrentScore ) < Level2Limit ) && 
           ((OTPScore + OOWScore + PublicWalletScore +  CurrentScore) >= Level2Limit) &&   
           ((PublicWalletScore + OTPScore + CurrentScore ) < Level2Limit) &&
           ((PublicWalletScore + OOWScore + CurrentScore ) < Level2Limit) &&
           ((OOWScore + OTPScore + CurrentScore ) < Level2Limit) 
           
          )
        {
            
            NextTabLevel2.add('(Public Wallet + OOW + OTP) or');
        }
        if((CurrentScore < Level2Limit) &&  (((IsPublicWalletAvailable * IsCFCUWalletAvailable * IsOOWAvailable ) *  (PublicWalletScore + CFCUWalletScore + OOWScore + CurrentScore)) >= Level2Limit) && 
           ((OOWScore + CurrentScore ) < Level2Limit ) &&
           ((CFCUWalletScore + CurrentScore ) < Level2Limit ) &&
           ((PublicWalletScore + CurrentScore ) < Level2Limit ) && 
           ((CFCUWalletScore + OOWScore + PublicWalletScore +  CurrentScore) >= Level2Limit) &&   
           ((PublicWalletScore + CFCUWalletScore + CurrentScore ) < Level2Limit) &&
           ((PublicWalletScore + OOWScore + CurrentScore ) < Level2Limit) &&
           ((OOWScore + CFCUWalletScore + CurrentScore ) < Level2Limit) 
           
          )
        {
            
            NextTabLevel2.add('(Public Wallet + CFCU Wallet + OOW) or');
        }
        if((CurrentScore < Level2Limit) &&  (((IsPublicWalletAvailable * IsCFCUWalletAvailable * IsOTPAvailable ) *  (PublicWalletScore + CFCUWalletScore + OTPScore + CurrentScore)) >= Level2Limit) && 
           ((OTPScore + CurrentScore ) < Level2Limit ) &&
           ((CFCUWalletScore + CurrentScore ) < Level2Limit ) &&
           ((PublicWalletScore + CurrentScore ) < Level2Limit ) && 
           ((CFCUWalletScore + OTPScore + PublicWalletScore +  CurrentScore) >= Level2Limit) &&   
           ((PublicWalletScore + CFCUWalletScore + CurrentScore ) < Level2Limit) &&
           ((PublicWalletScore + OTPScore + CurrentScore ) < Level2Limit) &&
           ((OTPScore + CFCUWalletScore + CurrentScore ) < Level2Limit) 
           
          )
        {
            
            NextTabLevel2.add('(Public Wallet + CFCU Wallet + OTP) or');
        }
        system.debug('Next Tab#'+ NextTabLevel2);
        resultMap.put('NextTabLevel2', NextTabLevel2);
        
        
        /*---------------------------------------------------------------Level 3 for 1 Tab----------------------------------------------------------------------------------------------------*/
        If(IsPublicWalletAvailable == 1 && Level3Limit > CurrentScore && (((IsPublicWalletAvailable * PublicWalletScore) + CurrentScore) >= Level3Limit)){
            
            NextTabLevel3.add('Pub Wallet or');
            
        }
        
        If(IsCFCUWalletAvailable == 1 && Level3Limit > CurrentScore && (((IsCFCUWalletAvailable * CFCUWalletScore) + CurrentScore) >= Level3Limit)){
            
            NextTabLevel3.add('CFCU Wallet or');
            
        }
        
        If(IsOTPAvailable == 1 && Level3Limit > CurrentScore && (((IsOTPAvailable * OTPScore) + CurrentScore) >= Level3Limit)){
            
            NextTabLevel3.add('OTP or');
            
        }
        
        If(IsOOWAvailable == 1 && Level3Limit > CurrentScore && (((IsOOWAvailable * OOWScore) + CurrentScore) >= Level3Limit)){
            
            NextTabLevel3.add('OOW or');
            
        }
        
        /*--------------------------------------------------------------------Level 3 for Combination of 2 Tabs------------------------------------------------------------------------------------------*/
        if((CurrentScore < Level3Limit) &&  (((IsPublicWalletAvailable * IsCFCUWalletAvailable) *  (PublicWalletScore + CFCUWalletScore + CurrentScore)) >= Level3Limit) && 
           ((CFCUWalletScore + CurrentScore ) < Level3Limit ) &&
           ((PublicWalletScore + CurrentScore ) < Level3Limit )
          )
        {
            
            NextTabLevel3.add('(Public Wallet + CFCU Wallet) or');
        } 
        
        
        if((CurrentScore < Level3Limit) &&  (((IsPublicWalletAvailable * IsOOWAvailable) *  (PublicWalletScore + OOWScore + CurrentScore)) >= Level3Limit) && 
           ((OOWScore + CurrentScore ) < Level3Limit ) &&
           ((PublicWalletScore + CurrentScore ) < Level3Limit )
          )
        {
            
            NextTabLevel3.add('(Public Wallet + OOW) or');
        }
        
        
        if((CurrentScore < Level3Limit) &&  (((IsPublicWalletAvailable * IsOTPAvailable) *  (PublicWalletScore + OTPScore + CurrentScore)) >= Level3Limit) && 
           ((OTPScore + CurrentScore ) < Level3Limit ) &&
           ((PublicWalletScore + CurrentScore ) < Level3Limit )
          )
        {
            
            NextTabLevel3.add('(Public Wallet + OTP) or');
        }
        
        
        if((CurrentScore < Level3Limit) &&  (((IsCFCUWalletAvailable * IsOOWAvailable) *  (CFCUWalletScore + OOWScore + CurrentScore)) >= Level3Limit) && 
           ((OOWScore + CurrentScore ) < Level3Limit ) &&
           ((CFCUWalletScore + CurrentScore ) < Level3Limit )
          )
        {
            
            NextTabLevel3.add('(CFCU Wallet + OOW) or');
        } 
        
        
        if((CurrentScore < Level3Limit) &&  (((IsCFCUWalletAvailable * IsOTPAvailable) *  (CFCUWalletScore + OTPScore + CurrentScore)) >= Level3Limit) && 
           ((OTPScore + CurrentScore ) < Level3Limit ) &&
           ((CFCUWalletScore + CurrentScore ) < Level3Limit )
          )
        {          
            NextTabLevel3.add('(CFCU Wallet + OTP) or');
        }
        
        if((CurrentScore < Level3Limit) &&  (((IsOOWAvailable * IsOTPAvailable) *  (OOWScore + OTPScore + CurrentScore)) >= Level3Limit) && 
           ((OTPScore + CurrentScore ) < Level3Limit ) &&
           ((OOWScore + CurrentScore ) < Level3Limit )
          )
        {          
            NextTabLevel3.add('(OOW + OTP) or');
        }
        
        /*----------------------------------------------------------------------------------Level 3 for Combination of 3 Tabs----------------------------------------------------------------------------*/
        if((CurrentScore < Level3Limit) &&  (((IsCFCUWalletAvailable * IsOOWAvailable * IsOTPAvailable) *  (CFCUWalletScore + OOWScore +OTPScore + CurrentScore)) >= Level3Limit) && 
           ((OOWScore + CurrentScore ) < Level3Limit ) &&
           ((OTPScore + CurrentScore ) < Level3Limit ) &&
           ((CFCUWalletScore + CurrentScore ) < Level3Limit ) && 
           ((OTPScore + OOWScore + CFCUWalletScore +  CurrentScore) >= Level3Limit) &&   
           ((CFCUWalletScore + OTPScore + CurrentScore ) < Level3Limit) &&
           ((CFCUWalletScore + OOWScore + CurrentScore ) < Level3Limit) &&
           ((OOWScore + OTPScore + CurrentScore ) < Level3Limit) 
           
          )
        {
            
            NextTabLevel3.add('(CFCU Wallet + OOW + OTP) or');
        }
        
        if((CurrentScore < Level3Limit) &&  (((IsPublicWalletAvailable * IsOOWAvailable * IsOTPAvailable) *  (PublicWalletScore + OOWScore +OTPScore + CurrentScore)) >= Level3Limit) && 
           ((OOWScore + CurrentScore ) < Level3Limit ) &&
           ((OTPScore + CurrentScore ) < Level3Limit ) &&
           ((PublicWalletScore + CurrentScore ) < Level3Limit ) && 
           ((OTPScore + OOWScore + PublicWalletScore +  CurrentScore) >= Level3Limit) &&   
           ((PublicWalletScore + OTPScore + CurrentScore ) < Level3Limit) &&
           ((PublicWalletScore + OOWScore + CurrentScore ) < Level3Limit) &&
           ((OOWScore + OTPScore + CurrentScore ) < Level3Limit) 
           
          )
        {
            
            NextTabLevel3.add('(Public Wallet + OOW + OTP) or');
        }
        
        if((CurrentScore < Level3Limit) &&  (((IsPublicWalletAvailable * IsCFCUWalletAvailable * IsOOWAvailable ) *  (PublicWalletScore + CFCUWalletScore + OOWScore + CurrentScore)) >= Level3Limit) && 
           ((OOWScore + CurrentScore ) < Level3Limit ) &&
           ((CFCUWalletScore + CurrentScore ) < Level3Limit ) &&
           ((PublicWalletScore + CurrentScore ) < Level3Limit ) && 
           ((CFCUWalletScore + OOWScore + PublicWalletScore +  CurrentScore) >= Level3Limit) &&   
           ((PublicWalletScore + CFCUWalletScore + CurrentScore ) < Level3Limit) &&
           ((PublicWalletScore + OOWScore + CurrentScore ) < Level3Limit) &&
           ((OOWScore + CFCUWalletScore + CurrentScore ) < Level3Limit) 
           
          )
        {
            
            NextTabLevel3.add('(Public Wallet + CFCU Wallet + OOW) or');
        }
        
        if((CurrentScore < Level3Limit) &&  (((IsPublicWalletAvailable * IsCFCUWalletAvailable * IsOTPAvailable ) *  (PublicWalletScore + CFCUWalletScore + OTPScore + CurrentScore)) >= Level3Limit) && 
           ((OTPScore + CurrentScore ) < Level3Limit ) &&
           ((CFCUWalletScore + CurrentScore ) < Level3Limit ) &&
           ((PublicWalletScore + CurrentScore ) < Level3Limit ) && 
           ((CFCUWalletScore + OTPScore + PublicWalletScore +  CurrentScore) >= Level3Limit) &&   
           ((PublicWalletScore + CFCUWalletScore + CurrentScore ) < Level3Limit) &&
           ((PublicWalletScore + OTPScore + CurrentScore ) < Level3Limit) &&
           ((OTPScore + CFCUWalletScore + CurrentScore ) < Level3Limit) 
           
          )
        {
            
            NextTabLevel3.add('(Public Wallet + CFCU Wallet + OTP) or');
        }
        
        system.debug('Next Tab level 3#'+ NextTabLevel3);
        
        resultMap.put('NextTabLevel3', NextTabLevel3);
        resultMap.put('EachLevelStatus', EachLevelStatus);
        system.debug('resultMap#'+ resultMap);
        return resultMap;
    }
    
    @AuraEnabled    
    public static List<Member_Authentication_Level_Model__c> GetMemberAuthenticationLevel()
    {
        // Bringing data from custom setting for Levels 
        
        List<Member_Authentication_Level_Model__c> LevelModel = new List<Member_Authentication_Level_Model__c>();
        LevelModel = [Select id, Name, Tiers__c, Description__c,Range_Start__c, Range_End__c from Member_Authentication_Level_Model__c order by Name];
        
        return LevelModel;
    }
    @AuraEnabled    
    public static List<Member_Authentication_Scoring_Model__c> GetScoringModelData(string MemberType)
    {
        // Bringing data from custom setting for Score vlues 
        List<Member_Authentication_Scoring_Model__c> ScoringModel = new List<Member_Authentication_Scoring_Model__c>();
        
        if(MemberType!= null)
        {
            if(MemberType == 'Foreign'){
                
                ScoringModel =[select id, Name, Authentication_Type__c,Foreign_Domestic_Flag__c,IsDomestic__c,IsForeign__c,IsPass__c,Negative_Point_Value__c,Positive_Point_Value__c
                               from Member_Authentication_Scoring_Model__c where IsForeign__c =true];
            }
            else if(MemberType == 'Domestic')
            {
                ScoringModel =[select id, Name, Authentication_Type__c,Foreign_Domestic_Flag__c,IsDomestic__c,IsForeign__c,IsPass__c,Negative_Point_Value__c,Positive_Point_Value__c
                               from Member_Authentication_Scoring_Model__c where IsDomestic__c =true];
            }
            
        }
        
        return ScoringModel;
    }
    
    @AuraEnabled
    public static Map<string,object> GetNextAuthenticationType(string MemberId, string MemberType, Integer MaximumPointsAvailable,Integer PointsObtained, boolean IsKYMAvailable, boolean IsOTPAvailable, string IsDebitPinAvailable, boolean IsOOWAvailable, boolean IsPublicWalletAvailable, boolean IsCFCUWalletAvailable, string IVRGUIDFromUrl, string AccountNumberInput, integer currentScore)
    {
        
        //---------------------------------Aut-190 implementation starts here------------------------------------------------------------------------
        System.debug('GetNextAuthenticationType method called-------------------');
        system.debug('GetNextAuthenticationType param received' + 'PointsObtained##'+ PointsObtained + 'MemberType#' + MemberType + 'MaximumPointsAvailable#' + MaximumPointsAvailable + 'IsOTPAvailable#' + IsOTPAvailable + 'IsKYMAvailable#' + IsKYMAvailable + 'IsDebitPinAvailable#' + IsDebitPinAvailable + 'IsOOWAvailable#' + IsOOWAvailable + 'IsPublicWalletAvailable#' + IsPublicWalletAvailable + 'IsCFCUWalletAvailable#' + IsCFCUWalletAvailable + 'AccountNumberInput#' + AccountNumberInput + 'currentScore##' + currentScore );
        if(PointsObtained == null){
            PointsObtained = 0;
            
        }
        
        boolean IsLevel1Achieved = false;
        boolean IsLevel2Achieved = false;
        boolean IsLevel3Achieved = false;
        Decimal DebitPinPositiveScore;
        Decimal DebitPinNegativeScore;
        Decimal PINChangeNegativeScore;
        Decimal PINChangePositiveScore;
        Map<string,object> result = new  Map<string,object>();
        List<Member_Authentication_Level_Model__c> LevelModel = new List<Member_Authentication_Level_Model__c>();
        List<Member_Authentication_Scoring_Model__c> ScoringModel = new List<Member_Authentication_Scoring_Model__c>();
        
        
        LevelModel = GetMemberAuthenticationLevel();
        ScoringModel = GetScoringModelData(MemberType);
        
        
        
        List<MC_PIN_Change__c> PC = new List<MC_PIN_Change__c>();
        List<Authenticated_Log__c> FDLog = new List<Authenticated_Log__c>();
        boolean IsPinChanged;
        string  AccountNumber;
        List<Person_Account__c> p = [SELECT Id, Account_Number__c, PersonID__r.Name, PersonID__c, Account_Number__r.RecType__c, TypeTranslate__c, Account_Number__r.Name
                                     FROM Person_Account__c where PersonID__c =:MemberId limit 1];
        AccountNumber =  AccountNumberInput;
        if(p.size() > 0) {
            
            //AccountNumber = p[0].Account_Number__r.Name;
            pc = [select id,Transmission_Date__c,CreatedDate,Member_Number__c,Function__c from MC_PIN_Change__c where Member_Number__c =: AccountNumber and CreatedDate = LAST_N_DAYS:30 and Function__c = 'PIN Change'];
            if(pc.size() > 0){
                IsPinChanged = true;
                result.put('PINChange',IsPinChanged);
            }
            else{
                IsPinChanged = false;
                result.put('PINChange',IsPinChanged);
            }
        }
        
        integer OTPAvailable = 0;
        integer PublicWalletAvailable = 0;
        integer CFCUWalletAvailable = 0;
        integer OOWAvailable = 0;
        //Integer CurrentScore = 0;
        string DebitCardStatus = '';
        if(IsOTPAvailable == true){OTPAvailable=1;}
        if(IsPublicWalletAvailable == true){PublicWalletAvailable=1;}
        if(IsCFCUWalletAvailable == true){CFCUWalletAvailable=1;}
        if(IsOOWAvailable == true){OOWAvailable=1;}
        if(IsDebitPinAvailable == 'true' ){
            DebitCardStatus = 'Pass';
        }else if(IsDebitPinAvailable == 'false'){
            DebitCardStatus = 'Fail';
        }
        
        system.debug('PointsObtained1##'+ PointsObtained);
        system.debug('OOWAvailable##'+ OOWAvailable);
        system.debug('OTPAvailable##'+ OTPAvailable);
        system.debug('PublicWalletAvailable##'+ PublicWalletAvailable);
        
        for(Member_Authentication_Scoring_Model__c sm : ScoringModel  )
        {
            
            if(sm.Authentication_Type__c == 'Debit Pin' )
            {
                system.debug('sm.Negative_Point_Value__c##'+ sm.Negative_Point_Value__c);
                DebitPinPositiveScore = sm.Positive_Point_Value__c;
                DebitPinNegativeScore = sm.Negative_Point_Value__c;
            }
            if(sm.Authentication_Type__c == 'PIN Change'){
                
                PINChangeNegativeScore = sm.Negative_Point_Value__c;
                PINChangePositiveScore = sm.Positive_Point_Value__c;        
            }
            
        }
        if(DebitCardStatus == 'Fail' || DebitCardStatus =='false'){
            CurrentScore = CurrentScore - DebitPinNegativeScore.intValue();
        }
        else if(DebitCardStatus == 'Pass' || DebitCardStatus =='true')
        {
            CurrentScore = CurrentScore + DebitPinPositiveScore.intValue();
        }
        system.debug('CurrentScorePost1##' + CurrentScore);
        system.debug('IsPinChanged##' + IsPinChanged);
        if(IsPinChanged == true ){
            CurrentScore = CurrentScore - PINChangeNegativeScore.intValue();
            
        }
        else if(IsPinChanged == false ){
            
            CurrentScore = CurrentScore + PINChangePositiveScore.intValue();
        }
        system.debug('CurrentScorePost2##' + CurrentScore);
        
        result.put('CurrentScore', CurrentScore);  
        
        map<string, List<string>> NextTabToAchieveLevelMap =  GetTabsToAchieveNextLevel(LevelModel, ScoringModel, MemberType, DebitCardStatus, IsPinChanged, OTPAvailable, PublicWalletAvailable, CFCUWalletAvailable,OOWAvailable, currentScore);
        List<string>  NextTabLevel2 = NextTabToAchieveLevelMap.get('NextTabLevel2');
        List<string>  NextTabLevel3 = NextTabToAchieveLevelMap.get('NextTabLevel3');
        List<string> EachLevelStatus = NextTabToAchieveLevelMap.get('EachLevelStatus');
        
        if(NextTabLevel2.size() > 0)
        {
            string NextTabLevel2LastString = NextTabLevel2.get(NextTabLevel2.size()-1);
            NextTabLevel2LastString = NextTabLevel2LastString.removeEnd('or');
            NextTabLevel2.remove((NextTabLevel2.size()-1));
            NextTabLevel2.add(NextTabLevel2LastString);
            system.debug('NextTabLevel2LastString#'+ NextTabLevel2LastString);
        }
        if(NextTabLevel3.size() > 0){
            string NextTabLevel3LastString = NextTabLevel3.get(NextTabLevel3.size()-1);      
            NextTabLevel3LastString = NextTabLevel3LastString.removeEnd('or');      
            NextTabLevel3.remove((NextTabLevel3.size()-1));      
            NextTabLevel3.add(NextTabLevel3LastString);
            system.debug('NextTabLevel3LastString#'+ NextTabLevel3LastString);
        }
        
        
        
        system.debug('NextTabLevel2List#'+ NextTabLevel2);
        system.debug('NextTabLevel3List#'+ NextTabLevel3);
        if(EachLevelStatus.size() >0)
        {
            for(string s: EachLevelStatus){
                
                if(s == 'Level 2 Achieved'){
                    IsLevel2Achieved = true;
                }
                if(s == 'Level 3 Achieved'){
                    IsLevel3Achieved = true;
                }
            }
        }
        
        if(IsLevel2Achieved == true){
            result.put('NextTabLevel2', 'Level Reached');
        }
        else if(IsLevel2Achieved == false && NextTabLevel2.size()==0){
            result.put('NextTabLevel2', 'Not Achievable');
            
        }
        else if(IsLevel2Achieved == false && NextTabLevel2.size()> 0){
            result.put('NextTabLevel2', NextTabLevel2);
        }
        if(IsLevel3Achieved == true){
            result.put('NextTabLevel3', 'Level Reached');
        }
        else if(IsLevel3Achieved == false && NextTabLevel3.size()==0){
            result.put('NextTabLevel3', 'Not Achievable');
            
        }
        else if(IsLevel3Achieved == false && NextTabLevel3.size()> 0){
            result.put('NextTabLevel3', NextTabLevel3);
        }
        
        result.put('IsLevel1Achieved',IsLevel1Achieved);
        result.put('IsLevel2Achieved',IsLevel2Achieved);
        result.put('IsLevel3Achieved',IsLevel3Achieved);
        
        //---------------------------------Aut-190 implementation Ends here------------------------------------------------------------------------
        
        string CurrentAuthenticationLevel;
        string LevelofAuthentication;
        for(Member_Authentication_Level_Model__c lm :LevelModel )
        {
            if(lm.Tiers__c == 'Level 1' && MaximumPointsAvailable >= lm.Range_Start__c && MaximumPointsAvailable <= lm.Range_End__c )
            {
                LevelofAuthentication = lm.Tiers__c;
                
            }
            else if(lm.Tiers__c == 'Level 2' && MaximumPointsAvailable >= lm.Range_Start__c && MaximumPointsAvailable <= lm.Range_End__c)
            {
                LevelofAuthentication = lm.Tiers__c;
                
            }
            else if(lm.Tiers__c == 'Level 3' && MaximumPointsAvailable >= lm.Range_Start__c)
            {
                LevelofAuthentication = lm.Tiers__c;
                
            }
            
        }
        
        for(Member_Authentication_Level_Model__c lm :LevelModel )
        {
            if(lm.Tiers__c == 'Level 1' && PointsObtained >= lm.Range_Start__c && PointsObtained <= lm.Range_End__c )
            {
                system.debug('stage1');
                CurrentAuthenticationLevel = lm.Tiers__c;
            }
            else if(lm.Tiers__c == 'Level 2' && PointsObtained >= lm.Range_Start__c && PointsObtained <= lm.Range_End__c)
            {
                system.debug('stage2');
                CurrentAuthenticationLevel = lm.Tiers__c;
                
            }
            else if(lm.Tiers__c == 'Level 3' && PointsObtained >= lm.Range_Start__c)
            {
                system.debug('stage3');
                CurrentAuthenticationLevel = lm.Tiers__c;
                
            }
            
        }
        
        if(IVRGUIDFromUrl !='' && IVRGUIDFromUrl !=null ){
            integer minutes = GetMemberAuthenticationSessionTime();
            list<Member_Verification_Attempt__c> mva = new List<Member_Verification_Attempt__c>();
            mva = [Select id, IVR_GUID__c, Member_Salesforce_Id__c, Points_Obtained__c, Maximum_Points_Available__c,Current_Authentication_Level__c,Highest_Achievable_Level__c, Next_Level__c from Member_Verification_Attempt__c where IVR_GUID__c=:IVRGUIDFromUrl and Member_Salesforce_Id__c =: memberid AND CreatedDate >=: Datetime.now().addMinutes(minutes) limit 1];
            if(mva.size() > 0)
            {
                System.debug('Member_Verification_Attempt__c called');
                mva[0].Current_Authentication_Level__c = CurrentAuthenticationLevel; 
                mva[0].Highest_Achievable_Level__c = LevelofAuthentication; 
                //mva[0].Next_Level__c = ToGetHighestLevel; 
                mva[0].Points_Obtained__c = currentScore;
                mva[0].Maximum_Points_Available__c = MaximumPointsAvailable;
                update mva;
            }else if(mva.size() == 0)
            {
                System.debug('Member_Verification_Attempt__c called');
                Member_Verification_Attempt__c mv = new Member_Verification_Attempt__c();
                mv.Member_Salesforce_Id__c = memberid;
                mv.IVR_GUID__c = IVRGUIDFromUrl;
                mv.Current_Authentication_Level__c = CurrentAuthenticationLevel;
                mv.Highest_Achievable_Level__c = LevelofAuthentication;
                //mv.Next_Level__c = ToGetHighestLevel;
                mv.Points_Obtained__c = currentScore;
                mv.Maximum_Points_Available__c = MaximumPointsAvailable;
                insert mv;  
                
            }
        }
        system.debug('result##' + result);
        return result;
    }
    
    
    @AuraEnabled
    public static void SaveOTPCancelledAttempt(string MemberId, string GUID, string IVRGUIDFromUrl)
    {
        string  AccountNumber;
        List<Person_Account__c> p = [SELECT Id, Account_Number__c, PersonID__r.Name, PersonID__c, Account_Number__r.RecType__c, TypeTranslate__c, Account_Number__r.Name
                                     FROM Person_Account__c where PersonID__c =:MemberId limit 1];
        if(p.size() > 0)
        {
            AccountNumber = p[0].Account_Number__r.Name;
        }
        
        RecordType rec = GetRecordTypeData('Authenticated_Log__c', 'OTP Authentication Log');
        Authenticated_Log__c log = new Authenticated_Log__c();
        log.RecordTypeId= rec.id;
        log.SalesforceID__c = MemberId;
        log.Decision__c = 'OTP - Cancelled';
        log.OTP_Decision__c = 'OTP - Cancelled';
        log.Member__c = MemberId;
        log.Staff_Name__c = UserInfo.getName();
        log.Current_User__c = Userinfo.getuserid();
        log.Member_Number__c = AccountNumber;
        log.GUID__c = GUID;
        log.IVR_GUID__c = IVRGUIDFromUrl;
        insert log;
        system.debug('OTP-Log##' + log.Id);
        /* The below code is to create or update Master log data*/
        RecordType rec1 = GetRecordTypeData('Authenticated_Log__c', 'Master Authentication Log');
        
        List<Authenticated_Log__c> MasterAuthenticationLog = GetDataForMasterAuthenticationLog(IVRGUIDFromUrl, rec1.id);
        if(MasterAuthenticationLog.size() == 0)
        {
            Authenticated_Log__c log2 = new Authenticated_Log__c();
            log2.RecordTypeId= rec.id;
            log2.SalesforceID__c = MemberId;
            log2.Decision__c = 'OTP - Cancelled';
            log2.OTP_Decision__c = 'OTP - Cancelled';
            log2.Member__c = MemberId;
            log2.Staff_Name__c = UserInfo.getName();
            log2.Current_User__c = Userinfo.getuserid();
            log2.Member_Number__c = AccountNumber;
            log2.GUID__c = GUID;
            log2.IVR_GUID__c = IVRGUIDFromUrl;
            insert log2;
        }
        else{
            
            MasterAuthenticationLog[0].SalesforceID__c = MemberId;
            MasterAuthenticationLog[0].Decision__c = 'OTP - Cancelled';
            MasterAuthenticationLog[0].OTP_Decision__c = 'OTP - Cancelled';
            MasterAuthenticationLog[0].Member__c = MemberId;
            MasterAuthenticationLog[0].Staff_Name__c = UserInfo.getName();
            MasterAuthenticationLog[0].Current_User__c = Userinfo.getuserid();
            MasterAuthenticationLog[0].Member_Number__c = AccountNumber;
            MasterAuthenticationLog[0].GUID__c = GUID;
            update MasterAuthenticationLog[0];
            
        }
        
        
    }
    
    @AuraEnabled
    public static void SaveLastAchievableLevelLogs(string MemberId, string GUID, String LastLevel, string IVRGUIDFromUrl,string PhoneFromURL, String MemberNumberFromURL,String EnteredCardNumber, string CardNumberMatch, string PhoneNumberMatch,string MemberNumberMatch, string SSNnumberMatch, string HighFlagFromUrl,string ReasonCodeFromURL, string PINMatch, string SSNFromURL,string DebitCardStatus, integer MaximumPointsAvailable,integer PointsObtained, string CardOwnerSSNFromURL)
    {
        integer minutes = GetMemberAuthenticationSessionTime();
        list<Member_Verification_Attempt__c> mva = new List<Member_Verification_Attempt__c>();
        mva = [Select id, IVR_GUID__c, Member_Salesforce_Id__c, Points_Obtained__c, Maximum_Points_Available__c,Current_Authentication_Level__c,Highest_Achievable_Level__c, Next_Level__c from Member_Verification_Attempt__c where IVR_GUID__c=:IVRGUIDFromUrl and Member_Salesforce_Id__c =: memberid AND CreatedDate >=: Datetime.now().addMinutes(minutes) limit 1];
        if(mva.size() > 0)
        {
            System.debug('Member_Verification_Attempt__c called');
            mva[0].Current_Authentication_Level__c = LastLevel; 
            mva[0].Points_Obtained__c = PointsObtained;
            mva[0].Maximum_Points_Available__c = MaximumPointsAvailable;
            update mva;
        }else if(mva.size() == 0)
        {
            System.debug('Member_Verification_Attempt__c called');
            Member_Verification_Attempt__c mv = new Member_Verification_Attempt__c();
            mv.Member_Salesforce_Id__c = memberid;
            mv.IVR_GUID__c = IVRGUIDFromUrl;
            mv.Current_Authentication_Level__c = LastLevel;      
            mv.Points_Obtained__c = PointsObtained;
            mv.Maximum_Points_Available__c = MaximumPointsAvailable;
            insert mv;  
            
        }
        
        RecordType rec = GetRecordTypeData('Authenticated_Log__c', 'IVR Authentication Log');
        Authenticated_Log__c log = new Authenticated_Log__c();
        log.CallerPhoneNumber__c = PhoneFromURL;
        log.EnteredMemberNumber__c = MemberNumberFromURL;
        log.EnteredCardNumber__c = EnteredCardNumber;
        //log.CardNumberMatch__c = CardNumberMatch;
        log.PhoneNumberMatch__c = PhoneNumberMatch;
        log.MemberNumberMatch__c = MemberNumberMatch;
        log.SSNnumberMatch__c = SSNnumberMatch;
        log.HP_HV__c = HighFlagFromUrl;
        log.IVR_Code__c = ReasonCodeFromURL;
        log.PINMatch__c = PINMatch;
        system.debug('SSNFromURL##'+ SSNFromURL);
        if(SSNFromURL != 'null' && SSNFromURL != null ){
            if(SSNFromURL.length() > 4){
                log.EnteredSSN__c = SSNFromURL.right(4);
                log.IVR_SSN__c = SSNFromURL;
            }
            else{
                log.EnteredSSN__c = SSNFromURL;
                log.IVR_SSN__c = SSNFromURL;
            }
        }
        
        
        log.IVR_Card_Number__c = EnteredCardNumber;
        log.IVR_Member_Number__c = MemberNumberFromURL;
        log.IVR_Member_Number_Match__c = MemberNumberMatch;
        log.IVR_SSN_Match__c = SSNnumberMatch;
        log.IVR_Card_Match__c = CardNumberMatch;
        
        
        if(DebitCardStatus == 'true')
            log.IVR_Pin_Match__c = 'Pass';
        if(DebitCardStatus == 'false')
            log.IVR_Pin_Match__c = 'Fail'; 
        
        log.RecordTypeId= rec.id;
        log.SalesforceID__c = MemberId;
        log.Last_Achievable_Level__c = LastLevel;
        log.Member__c = MemberId;
        log.Member_Number__c = MemberNumberFromURL;
        log.Staff_Name__c = UserInfo.getName();
        log.Current_User__c = Userinfo.getuserid();
        log.GUID__c = GUID;
        log.IVR_GUID__c = IVRGUIDFromUrl;
        log.Decision__c = 'Level Achieved';
        log.CardOwnerSSN__c = CardOwnerSSNFromURL;
        insert log;
        system.debug('log##' + log);
        /* The below code is to create or update Master log data*/
        RecordType rec1 = GetRecordTypeData('Authenticated_Log__c', 'Master Authentication Log');
        
        List<Authenticated_Log__c> MasterAuthenticationLog = GetDataForMasterAuthenticationLog(IVRGUIDFromUrl, rec1.id);
        if(MasterAuthenticationLog.size() == 0)
        {
            Authenticated_Log__c log2 = new Authenticated_Log__c();
            log2.CallerPhoneNumber__c = PhoneFromURL;
            log2.EnteredMemberNumber__c = MemberNumberFromURL;
            log2.EnteredCardNumber__c = EnteredCardNumber;
            //      log2.CardNumberMatch__c = CardNumberMatch;
            log2.PhoneNumberMatch__c = PhoneNumberMatch;
            log2.MemberNumberMatch__c = MemberNumberMatch;
            log2.SSNnumberMatch__c = SSNnumberMatch;
            log2.HP_HV__c = HighFlagFromUrl;
            log2.IVR_Code__c = ReasonCodeFromURL;
            log2.PINMatch__c = PINMatch;
            
            if(SSNFromURL != 'null' && SSNFromURL != null ){
                if(SSNFromURL.length() > 4){
                    log.EnteredSSN__c = SSNFromURL.right(4);
                    log.IVR_SSN__c = SSNFromURL;
                }
                else{
                    log.EnteredSSN__c = SSNFromURL;
                    log.IVR_SSN__c = SSNFromURL;
                }
            }
            
            log2.IVR_Card_Number__c = EnteredCardNumber;
            log2.IVR_Member_Number__c = MemberNumberFromURL;
            log2.IVR_Member_Number_Match__c = MemberNumberMatch;
            log2.IVR_SSN_Match__c = SSNnumberMatch;
            log2.IVR_Card_Match__c = CardNumberMatch;
            
            
            if(DebitCardStatus == 'true')
                log2.IVR_Pin_Match__c = 'Pass';
            if(DebitCardStatus == 'false')
                log2.IVR_Pin_Match__c = 'Fail'; 
            
            log2.RecordTypeId= rec1.id;
            log2.SalesforceID__c = MemberId;
            log2.Last_Achievable_Level__c = LastLevel;
            log2.Member__c = MemberId;
            log2.Member_Number__c = MemberNumberFromURL;
            log2.Staff_Name__c = UserInfo.getName();
            log2.Current_User__c = Userinfo.getuserid();
            log2.GUID__c = GUID;
            log2.Decision__c = 'Level Achieved';
            log2.CardOwnerSSN__c = CardOwnerSSNFromURL;
            insert log2;
            
        }else
        {
            
            MasterAuthenticationLog[0].CallerPhoneNumber__c = PhoneFromURL;
            MasterAuthenticationLog[0].EnteredMemberNumber__c = MemberNumberFromURL;
            MasterAuthenticationLog[0].EnteredCardNumber__c = EnteredCardNumber;
            //    MasterAuthenticationLog[0].CardNumberMatch__c = CardNumberMatch;
            MasterAuthenticationLog[0].PhoneNumberMatch__c = PhoneNumberMatch;
            MasterAuthenticationLog[0].MemberNumberMatch__c = MemberNumberMatch;
            MasterAuthenticationLog[0].SSNnumberMatch__c = SSNnumberMatch;
            MasterAuthenticationLog[0].HP_HV__c = HighFlagFromUrl;
            MasterAuthenticationLog[0].IVR_Code__c = ReasonCodeFromURL;
            MasterAuthenticationLog[0].PINMatch__c = PINMatch;
            
            if(SSNFromURL != 'null' && SSNFromURL != null ){
                if(SSNFromURL.length() > 4){
                    log.EnteredSSN__c = SSNFromURL.right(4);
                    log.IVR_SSN__c = SSNFromURL;
                }
                else{
                    log.EnteredSSN__c = SSNFromURL;
                    log.IVR_SSN__c = SSNFromURL;
                }
            }
            
            MasterAuthenticationLog[0].IVR_Card_Number__c = EnteredCardNumber;
            MasterAuthenticationLog[0].IVR_Member_Number__c = MemberNumberFromURL;
            MasterAuthenticationLog[0].IVR_Member_Number_Match__c = MemberNumberMatch;
            MasterAuthenticationLog[0].IVR_SSN_Match__c = SSNnumberMatch;
            MasterAuthenticationLog[0].IVR_Card_Match__c = CardNumberMatch;
            
            
            if(DebitCardStatus == 'true')
                MasterAuthenticationLog[0].IVR_Pin_Match__c = 'Pass';
            if(DebitCardStatus == 'false')
                MasterAuthenticationLog[0].IVR_Pin_Match__c = 'Fail'; 
            
            MasterAuthenticationLog[0].SalesforceID__c = MemberId;
            MasterAuthenticationLog[0].Last_Achievable_Level__c = LastLevel;
            MasterAuthenticationLog[0].Member__c = MemberId;
            MasterAuthenticationLog[0].Member_Number__c = MemberNumberFromURL;
            MasterAuthenticationLog[0].Staff_Name__c = UserInfo.getName();
            MasterAuthenticationLog[0].Current_User__c = Userinfo.getuserid();
            MasterAuthenticationLog[0].GUID__c = GUID;
            MasterAuthenticationLog[0].Decision__c = 'Level Achieved';
            MasterAuthenticationLog[0].CardOwnerSSN__c = CardOwnerSSNFromURL;
            update MasterAuthenticationLog[0];
        }
        
        
        
        
        
        
    }
    
    @AuraEnabled
    public static void SaveCaseWithLogData(string MemberId, string AccountNumber, string casecomment, string AccountId, string GUID, string IVRGUIDFromUrl)
    {
        list<CaseRecordType__c> scList = [SELECT Id,
                                          Primary_Category__c,
                                          Secondary_Category__c,
                                          Teritiary_Category__c,
                                          Record_Type_Name__c,
                                          SLA__c,
                                          RecordTypeId__c FROM CaseRecordType__c WHERE Primary_Category__c = 'Account Maintenance' AND Secondary_Category__c='Special Situations' AND Teritiary_Category__c='Unusual Activity' LIMIT 1];
        
        //Group gp = [select Id, Name from Group where  Type = 'Queue' AND NAME = 'Authentication Failed – Unusual Activity'];
        Group gp = [select Id, Name from Group where  Type = 'Queue' AND DeveloperName = 'Fraud_Analyst'];

        case cs = new case();
        for(CaseRecordType__c crt : scList){
            cs.RecordTypeId = scList[0].RecordTypeId__c;
            cs.Primary_Category__c = scList[0].Primary_Category__c;
            cs.Secondary_Category__c = scList[0].Secondary_Category__c;
            cs.Tertiary_Category__c = scList[0].Teritiary_Category__c;
            cs.Sla__c = scList[0].SLA__c;
            
        }    
        cs.AccountId = MemberId;
        cs.Status = 'Open';
        cs.Subject = 'Authentication Failed – Unusual Activity';
        cs.ownerid = gp.id;
        cs.CaseComments__c = casecomment;
        cs.Account_Number__c = AccountId;
        insert cs;
        
        if(cs != null){
            CaseComment cc = new CaseComment();
            cc.ParentId = cs.id;
            cc.CommentBody =  casecomment;
            insert cc;  
        }
        RecordType rec = GetRecordTypeData('Authenticated_Log__c', 'IVR Authentication Log');      
        
        Authenticated_Log__c log = new Authenticated_Log__c();
        log.RecordTypeId= rec.id;
        log.SalesforceID__c = MemberId;
        log.Decision__c = 'Unusual Activity-Authentication Failed';
        log.Member__c = MemberId;
        log.Staff_Name__c = UserInfo.getName();
        log.Current_User__c = Userinfo.getuserid();
        log.Member_Number__c = AccountNumber;
        log.Case__c = cs.id;
        log.GUID__c = GUID;
        log.IVR_GUID__c = IVRGUIDFromUrl;
        insert log;
        /* The below code is to create or update Master log data*/
        RecordType rec1 = GetRecordTypeData('Authenticated_Log__c', 'Master Authentication Log');
        
        List<Authenticated_Log__c> MasterAuthenticationLog = GetDataForMasterAuthenticationLog(IVRGUIDFromUrl, rec1.id);
        if(MasterAuthenticationLog.size() == 0)
        {
            Authenticated_Log__c log2 = new Authenticated_Log__c();
            log2.RecordTypeId= rec1.id;
            log2.SalesforceID__c = MemberId;
            log2.Decision__c = 'Unusual Activity-Authentication Failed';
            log2.Member__c = MemberId;
            log2.Staff_Name__c = UserInfo.getName();
            log2.Current_User__c = Userinfo.getuserid();
            log2.Member_Number__c = AccountNumber;
            log2.Case__c = cs.id;
            log2.GUID__c = GUID;
            log2.IVR_GUID__c = IVRGUIDFromUrl;
            insert log2;
        }
        else{
            
            MasterAuthenticationLog[0].SalesforceID__c = MemberId;
            MasterAuthenticationLog[0].Decision__c = 'Unusual Activity-Authentication Failed';
            MasterAuthenticationLog[0].Member__c = MemberId;
            MasterAuthenticationLog[0].Staff_Name__c = UserInfo.getName();
            MasterAuthenticationLog[0].Current_User__c = Userinfo.getuserid();
            MasterAuthenticationLog[0].Member_Number__c = AccountNumber;
            MasterAuthenticationLog[0].Case__c = cs.id;
            MasterAuthenticationLog[0].GUID__c = GUID;
            MasterAuthenticationLog[0].IVR_GUID__c = IVRGUIDFromUrl;
            update MasterAuthenticationLog[0];
            
        }
        
    }
    
    @AuraEnabled
    public static List<AuthenticationLogWrapper> GetLogHistoryDetailData(string MemberId, string GUID, string IVRGUIDFromUrl)
    {
        // this is to bring detail data on the view History screen on click of expand button 
        system.debug('MemberId#'+ MemberId);
        system.debug('GUID#'+ GUID);
        String rec = 'Master Authentication Log';
        Timezone tz = Timezone.getTimeZone('America/Los_Angeles');
        List<AuthenticationLogWrapper> logWrapper =  new List<AuthenticationLogWrapper>();
        string SOQLQuery = '';
        SOQLQuery = 'SELECT ' +
            'CFCU_Wallet_Status__c, ' + 
            'Decision__c, ' + 
            'Id, ' + 
            'PINMatch__c, ' + 
            'KYM_Member_Number__c, ' + 
            'KYM_Other_Reason__c, ' + 
            'KYM_Reason__c,' + 
            'Member_Name__c, '+ 
            'Member__c,' + 
            'Name,' + 
            'Staff_Name__c,'+
            'Member_Number__c, ' + 
            'Case__r.CaseNumber , ' +
            'Case__r.CaseComments__c , ' +
            'OOW_Member_Number__c, ' + 
            'OOW_Notes__c,' + 
            'OOW_Reason__c, '+
            'OOW_Status__c, ' +
            'OTP_Status__c, ' + 
            'SalesforceID__c,' + 
            'Public_Wallet_Status__c,' + 
            'CreatedDate,' +
            'RecordType.Name, ' + 
            'Current_User__c, ' +
            'IVR_Sent_URL__c, ' +
            'CallerPhoneNumber__c, ' + 
            'Failed_Desired_Level__c, '+
            'Override_Request_Type__c, ' +
            'Last_Achievable_Level__c, ' +
            'Override_Request_Supervisor__c, ' +
            'GUID__c, '  + 
            'StaffName__c' +
            ' FROM Authenticated_Log__c where SalesforceID__c =  \'' +  MemberId  +  '\''  +
            ' and RecordType.Name != \'' + rec  +  '\''  + ' and   GUID__c = \'' +  GUID  +  '\'  order by createddate asc'  ;
        
        
        
        
        system.debug('SOQLQuery##'+ SOQLQuery);                                    
        List<Authenticated_Log__c> LogList= Database.query(SOQLQuery);
        system.debug('LogList#'+ LogList);
        system.debug('LogListSize#'+ LogList.size());
        if(LogList.size() > 0)
        {
            for(Authenticated_Log__c log: LogList)
            {
                Datetime dt;
                AuthenticationLogWrapper lw = new AuthenticationLogWrapper();
                lw.GUID = log.GUID__c;
                log.IVR_GUID__c = IVRGUIDFromUrl;
                lw.DebitPin = log.PinMatch__c;
                //lw.CreatedDate = log.CreatedDate.formatGMT('MM-dd-yyyy HH:mm:ss');
                dt = DateTime.newInstance(log.CreatedDate.getTime() + tz.getOffset(log.CreatedDate));
                lw.CreatedDate = dt.formatGMT('MM-dd-yyyy HH:mm:ss');
                lw.LogNumber = log.Name;
                lw.UserName = log.StaffName__c;
                lw.MemberNumber = log.Member_Number__c;
                lw.PhoneNumber= log.CallerPhoneNumber__c;
                if(log.RecordType.Name == 'IVR Authentication Log'){
                    lw.AuthenticationType = 'MAAP Authentication Log';
                }
                else{            
                    lw.AuthenticationType = log.RecordType.Name;
                }
                lw.Decision= log.Decision__c;
                lw.CaseNumber= log.Case__r.CaseNumber;
                if(log.KYM_Other_Reason__c != null || log.KYM_Other_Reason__c !='' && log.RecordType.Name == 'KYM Log')
                {
                    lw.CaseComment = log.KYM_Other_Reason__c;
                }
                else{
                    lw.CaseComment = log.Case__r.CaseComments__c;
                }
                lw.OverrideRequestType= log.Override_Request_Type__c;
                lw.OverrideRequestedSupervisor = log.Override_Request_Supervisor__c;
                if(log.Failed_Desired_Level__c =='Level 1' || log.Last_Achievable_Level__c =='Level 1'){
                    lw.FDL = 'Level 1';
                }
                else if(log.Failed_Desired_Level__c =='Level 2' || log.Last_Achievable_Level__c =='Level 2'){
                    lw.FDL = 'Level 2';
                }
                else if(log.Failed_Desired_Level__c =='Level 3' || log.Last_Achievable_Level__c =='Level 3'){
                    lw.FDL = 'Level 3';
                }
                else{
                    
                    lw.FDL = '';
                }
                logWrapper.add(lw);
                
                system.debug('log##' + lw);
                
            }
        }
        system.debug('logWrapper##' + logWrapper);
        return logWrapper;
        
    }
    
    @AuraEnabled
    public static List<AuthenticationLogWrapper> GetLogHistoryData(string MemberId, Integer Days, string GUID)
    {
        // this is to bring data on the click of view History button 
        Timezone tz = Timezone.getTimeZone('America/Los_Angeles');
        List<AuthenticationLogWrapper> logWrapper =  new List<AuthenticationLogWrapper>();
        String rec = 'Master Authentication Log';
        string SOQLQuery = '';
        SOQLQuery = 'SELECT ' +
            'CFCU_Wallet_Status__c, ' + 
            'Decision__c, ' + 
            'Id, ' + 
            'PINMatch__c, ' + 
            'KYM_Member_Number__c, ' + 
            'KYM_Other_Reason__c, ' + 
            'KYM_Reason__c,' + 
            'Member_Name__c, '+ 
            'Member__c,' + 
            'Name,' + 
            'Staff_Name__c,'+
            'Member_Number__c, ' + 
            'Case__r.CaseNumber , ' +
            'Case__r.CaseComments__c , ' +
            'OOW_Member_Number__c, ' + 
            'OOW_Notes__c,' + 
            'Current_User__c, ' +
            'OOW_Reason__c, '+
            'OOW_Status__c, ' +
            'OTP_Status__c, ' + 
            'SalesforceID__c,' + 
            'Public_Wallet_Status__c,' + 
            'CreatedDate,' +
            'RecordType.Name, ' + 
            'IVR_Sent_URL__c, ' +
            'CallerPhoneNumber__c, ' + 
            'Failed_Desired_Level__c, '+
            'Override_Request_Type__c, ' +
            'Last_Achievable_Level__c, ' +
            'Override_Request_Supervisor__c, ' +
            'GUID__c, '  + 
            'StaffName__c' +
            ' FROM Authenticated_Log__c where SalesforceID__c =  \'' +  MemberId  +  '\''  +
            ' and RecordType.Name != \'' + rec  +  '\''  +   'and createddate = LAST_N_DAYS:' + Days + ' order by createddate desc , RecordType.Name' ;
        
        
        
        
        system.debug('SOQLQuery##'+ SOQLQuery);                                    
        List<Authenticated_Log__c> LogList= Database.query(SOQLQuery);
        
        map<string,Authenticated_Log__c> guidmap = new map<string,Authenticated_Log__c>();
        
        if(LogList.size()> 0)
        {
            for(Authenticated_Log__c log:LogList)
            {
                
                guidmap.put(log.Guid__c, log);
                
                
                
            }
        }
        system.debug('guidmap#'+ guidmap);
        if(guidmap.size() > 0)
        {
            for(Authenticated_Log__c log:guidmap.values())
            {
                Datetime dt;
                AuthenticationLogWrapper lw = new AuthenticationLogWrapper();
                lw.GUID = log.GUID__c;
                lw.DebitPin = log.PinMatch__c;
                
                //lw.CreatedDate = log.CreatedDate.formatGMT('MM-dd-yyyy HH:mm:ss');
                dt = DateTime.newInstance(log.CreatedDate.getTime() + tz.getOffset(log.CreatedDate));
                lw.CreatedDate = dt.formatGMT('MM-dd-yyyy HH:mm:ss');
                lw.LogNumber = log.Name;
                lw.UserName = log.StaffName__c;
                lw.MemberNumber = log.Member_Number__c;
                lw.PhoneNumber= log.CallerPhoneNumber__c;
                if(log.RecordType.Name == 'IVR Authentication Log'){
                    lw.AuthenticationType = 'MAAP Authentication Log';
                }
                else{            
                    lw.AuthenticationType = log.RecordType.Name;
                }
                lw.Decision= log.Decision__c;
                lw.CaseNumber= log.Case__r.CaseNumber;
                lw.CaseComment = log.Case__r.CaseComments__c;
                lw.OverrideRequestType= log.Override_Request_Type__c;
                lw.OverrideRequestedSupervisor = log.Override_Request_Supervisor__c;
                
                if(log.Failed_Desired_Level__c =='Level 1' || log.Last_Achievable_Level__c =='Level 1'){
                    lw.FDL = 'Level 1';
                }
                else if(log.Failed_Desired_Level__c =='Level 2' || log.Last_Achievable_Level__c =='Level 2'){
                    lw.FDL = 'Level 2';
                }
                else if(log.Failed_Desired_Level__c =='Level 3' || log.Last_Achievable_Level__c =='Level 3'){
                    lw.FDL = 'Level 3';
                }
                else{
                    
                    lw.FDL = '';
                }
                
                
                
                guidmap.put(log.Guid__c, log);
                logWrapper.add(lw);
                
                system.debug('log##' + lw);
            }
        }
        
        
        
        
        return logWrapper;    
    }
    
    @AuraEnabled
    public static List<User> GetSupervisor(string MemberId, Integer Days, string GUID)
    {
        // This is to bring list of supervisor from public group 'Manager Override Supervisor'
        set<ID> UserIdSet = new set<ID>();
        List<User> UserList = new List<User>();
        List<Group> grp = [select Id, Name from Group where Name = 'Manager Override Supervisor'];
        List<GroupMember> grpMember = [SELECT Id, group.name, group.type, UserOrGroupId FROM GroupMember where group.id =: grp[0].Id];
        if(grpMember.size() > 0)
        {
            for(GroupMember gm : grpMember )
            {
                UserIdSet.add(gm.UserOrGroupId);
            }
        }
        
        if(UserIdSet.size() > 0)
        {
            UserList = [Select Id, Name from User where Id IN:UserIdSet];
        }
        
        
        return UserList;
    }
    
    @AuraEnabled
    public static Map<string,object> getLevel(string accoutid)
    { 
        Map<string,object> result = new  Map<string,object>();
        
        List<Authenticated_Log__c> LastLog = [SELECT CFCU_Wallet_Status__c, Decision__c, Id,KYM_Member_Number__c,KYM_Other_Reason__c,KYM_Reason__c,Member_Name__c,Member__c,Name,Staff_Name__c,Member_Number__c,
                                              Last_Achievable_Level__c,OOW_Member_Number__c,OOW_Notes__c,OOW_Reason__c,OOW_Status__c,OTP_Status__c,SalesforceID__c,Public_Wallet_Status__c,
                                              CreatedDate,RecordType.Name,IVR_Sent_URL__c,CallerPhoneNumber__c,Failed_Desired_Level__c,Override_Request_Type__c,Override_Request_Supervisor__c,
                                              GUID__c FROM Authenticated_Log__c where SalesforceID__c =:accoutid AND CreatedDate = Today AND Last_Achievable_Level__c != null and recordtype.name !='Master Authentication Log' order by CreatedDate desc LIMIT 1];    
        
        if(LastLog.size() > 0){
            result.put('Level',LastLog[0].Last_Achievable_Level__c);
        }
        
        List<Case> CaseListUnusualActivity= [Select id from Case where Category__c = 'Account Maintenance / Special Situations / Unusual Activity' and AccountId =: accoutid and (status != 'Closed' OR (status = 'Closed' and ClosedDate = Last_N_Days:7))];
        if(CaseListUnusualActivity.size() > 0)
        {
          result.put('IsUnusualActivity',true);
        }
        else{
          result.put('IsUnusualActivity',false);
        } 
        
        return result;
    }
    
    @AuraEnabled    
    public static void SaveFailedDesiredLevelLog(string MemberId,string Decision, string FDL, string GUID, string IVRGUIDFromUrl)
    {      
        List<Person_Account__c> p = [SELECT Id, Account_Number__c,  PersonID__c, Account_Number__r.RecType__c, TypeTranslate__c, Account_Number__r.Name
                                     FROM Person_Account__c where PersonID__c =:MemberId  limit 1];
        string AccountNumber;     
        if(p.size() > 0){
            AccountNumber = p[0].Account_Number__r.Name;
        }
        
        RecordType rec = GetRecordTypeData('Authenticated_Log__c', 'IVR Authentication Log');  
        Authenticated_Log__c log = new Authenticated_Log__c();
        log.RecordTypeId= rec.id;
        log.SalesforceID__c = MemberId;
        log.Decision__c = Decision;
        log.Failed_Desired_Level__c= FDL;
        log.Member__c = MemberId;
        log.Member_Number__c = AccountNumber;
        log.Staff_Name__c =UserInfo.getName();
        log.Current_User__c = Userinfo.getuserid();
        log.GUID__c = GUID;
        log.IVR_GUID__c = IVRGUIDFromUrl;
        insert log;
        RecordType rec1 = GetRecordTypeData('Authenticated_Log__c', 'Master Authentication Log');
        
        List<Authenticated_Log__c> MasterAuthenticationLog = GetDataForMasterAuthenticationLog(IVRGUIDFromUrl, rec1.id);
        if(MasterAuthenticationLog.size() == 0)
        {
            system.debug('FDL##'+ FDL);
            Authenticated_Log__c log2 = new Authenticated_Log__c();
            log2.RecordTypeId= rec1.id;
            log2.SalesforceID__c = MemberId;
            log2.Decision__c = Decision;
            log2.Failed_Desired_Level__c= FDL;
            log2.Member__c = MemberId;
            log2.Member_Number__c = AccountNumber;
            log2.Staff_Name__c =UserInfo.getName();
            log2.Current_User__c = Userinfo.getuserid();
            log2.GUID__c = GUID;
            log2.IVR_GUID__c = IVRGUIDFromUrl;
            insert log2;
        }else{
            system.debug('FDL2##'+ FDL);
            MasterAuthenticationLog[0].RecordTypeId= rec1.id;
            MasterAuthenticationLog[0].SalesforceID__c = MemberId;
            MasterAuthenticationLog[0].Decision__c = Decision;
            MasterAuthenticationLog[0].Failed_Desired_Level__c= FDL;
            MasterAuthenticationLog[0].Member__c = MemberId;
            MasterAuthenticationLog[0].Member_Number__c = AccountNumber;
            MasterAuthenticationLog[0].Staff_Name__c =UserInfo.getName();
            MasterAuthenticationLog[0].Current_User__c = Userinfo.getuserid();
            MasterAuthenticationLog[0].GUID__c = GUID;
            update MasterAuthenticationLog[0];
            
            
        }
        
        
    }
    
    @AuraEnabled
    public static Map<string,object> getDataForReload(string memberid, string GUID, string IVRGUIDFromUrl, string DebitCardStatus,  boolean IsUserSessionLoaded, string AccountNumberInput )
    { 
        /* This function is to reload user data. 
If 'IsUserSessionLoaded' parameter value is false its brings the data based on time value mentioned in custom setting 
If 'IsUserSessionLoaded' parameter value is true its brings the data based on the current user loggedin and its last ivr interaction Id, THis is for our new button on utility bar  
*/
        system.debug('getDataForReload  called-------##' );
        system.debug('IsUserSessionLoaded##' + IsUserSessionLoaded);
        system.debug('memberid##' + memberid);
         system.debug('AccountNumberInput##' + AccountNumberInput);
        String CurrentUser = UserInfo.getUserId();
        integer OTPAvailable = 0;
        integer PublicWalletAvailable = 0;
        integer CFCUWalletAvailable = 0;
        integer OOWAvailable = 0;
        integer CurrentScore = 0;
        boolean IsPinChanged;
        string  AccountNumber;
        Integer MemberHighFlagValue=0;
        boolean IsLevel1Achieved = false;
        boolean IsLevel2Achieved = false;
        boolean IsLevel3Achieved = false;
        List<Authenticated_Log__c> OOWLogData = new List<Authenticated_Log__c> ();
        List<Authenticated_Log__c> PublicLogData = new  List<Authenticated_Log__c>();
        List<Authenticated_Log__c> CFCULogData = new List<Authenticated_Log__c>();  
        List<Authenticated_Log__c> OTPLogData = new List<Authenticated_Log__c>();
        List<MC_PIN_Change__c> PC = new List<MC_PIN_Change__c>();
        List<Member_Authentication_Level_Model__c> LevelModel = new List<Member_Authentication_Level_Model__c>();    
        List<Member_Authentication_Scoring_Model__c> ScoringModel = new List<Member_Authentication_Scoring_Model__c>();
        Map<string,object> AuthLogMap = new  Map<string,object>();
        Decimal DebitPinPositiveScore;
        Decimal DebitPinNegativeScore;
        Decimal PINChangeNegativeScore;
        Decimal PINChangePositiveScore;
        integer minutes = GetMemberAuthenticationSessionTime();
        LevelModel = GetMemberAuthenticationLevel();
        List<Account> accList = [select id, PersonID__c from Account where id= : MemberId];
        string PersonID;
        string MemberType;
        if(accList.size()> 0)
        {
            PersonID = accList[0].PersonID__c;
        }
        if(PersonID.startsWith('C'))
        {
            MemberType ='Foreign';
        }
        else
        {
            MemberType ='Domestic';
        }
        
        system.debug('MemberType##'+ MemberType);
        ScoringModel = GetScoringModelData(MemberType);
        system.debug('ScoringModel##'+ ScoringModel);
        if(String.isNotBlank(AccountNumberInput)){
            Account_Details__c acc_Detail = [SELECT Id,Name,RecType__c,High_Value_Flag__c  FROM Account_Details__c WHERE Name =:AccountNumberInput AND RecType__c= 'ACCT'];       
            MemberHighFlagValue = acc_Detail.High_Value_Flag__c.intValue();       
        	AuthLogMap.put('MemberHighFlagValue',MemberHighFlagValue); 
        }
             
        
        RecordType OOWRec = GetRecordTypeData('Authenticated_Log__c', 'OOW Execution Log');  
        if(IsUserSessionLoaded == true){
            
            OOWLogData = [SELECT ID, Decision__c, Member_Name__c,Member__c,Name,Staff_Name__c,Member_Number__c,
                          OOW_Member_Number__c,OOW_Notes__c,OOW_Reason__c,OOW_Status__c,IVR_GUID__c,GUID__c
                          FROM Authenticated_Log__c where SalesforceID__c =:memberid and  IVR_GUID__c =:IVRGUIDFromUrl  and RecordTypeId=: OOWRec.Id order by CreatedDate desc];
        } else if(IsUserSessionLoaded == false){
            
            OOWLogData = [SELECT ID, Decision__c, Member_Name__c,Member__c,Name,Staff_Name__c,Member_Number__c,
                          OOW_Member_Number__c,OOW_Notes__c,OOW_Reason__c,OOW_Status__c,IVR_GUID__c,GUID__c
                          FROM Authenticated_Log__c where SalesforceID__c =:memberid AND CreatedDate >=: Datetime.now().addMinutes(minutes) and IVR_GUID__c =:IVRGUIDFromUrl and RecordTypeId=: OOWRec.Id ];
        } 
        // system.debug('IsOOWTabVisible##' + IsOOWTabVisible); 
        system.debug(' OOWLogData.size()##' +  OOWLogData.size());     
        
        if(MemberType =='Domestic'){
            if(OOWLogData.size() > 0){
                AuthLogMap.put('OOWLogData',OOWLogData);
                AuthLogMap.put('IsOOWAvailable',false);
            }
            else{            
                OOWLogData = [SELECT ID, Decision__c, Member_Name__c,Member__c,Name,Staff_Name__c,Member_Number__c,
                              OOW_Member_Number__c,OOW_Notes__c,OOW_Reason__c,OOW_Status__c,IVR_GUID__c,GUID__c
                              FROM Authenticated_Log__c where SalesforceID__c =:memberid  and RecordTypeId=: OOWRec.Id and createddate = Today and Decision__c ='Fail'];
                if(OOWLogData.size() > 0)
                {
                    AuthLogMap.put('OOWLogData',OOWLogData);
                    AuthLogMap.put('IsOOWAvailable',false);
                }else{
                    AuthLogMap.put('IsOOWAvailable',true);
                    OOWAvailable = 1;
                }
                
                
            }
        }
        system.debug('OOWAvailable##' +  OOWAvailable);    
        
        RecordType PublicRec = GetRecordTypeData('Authenticated_Log__c', 'Public Wallet Log');  
        if(IsUserSessionLoaded == true){
            
            PublicLogData = [Select Id,SalesforceID__c,Member__c,Public_Wallet_Status__c,DOBMatch__c,IdNumberMatch__c,MMNMatch__c,EmailMatch__c,Additional_Token_Option3_Match__c
                             From Authenticated_Log__c where RecordTypeId= : PublicRec.id and SalesforceID__c = : MemberId  and IVR_GUID__c =:IVRGUIDFromUrl order by CreatedDate desc];
            
        }else if(IsUserSessionLoaded == false){
            PublicLogData = [Select Id,SalesforceID__c,Member__c,Public_Wallet_Status__c,DOBMatch__c,IdNumberMatch__c,MMNMatch__c,EmailMatch__c,Additional_Token_Option3_Match__c
                             From Authenticated_Log__c where createddate = Today and RecordTypeId= : PublicRec.id and SalesforceID__c = : MemberId AND CreatedDate >=: Datetime.now().addMinutes(minutes) and IVR_GUID__c =:IVRGUIDFromUrl];
        }
        system.debug('PublicLogData##' + PublicLogData);
        if(PublicLogData.size() > 0){
            AuthLogMap.put('PublicLogData',PublicLogData);
            AuthLogMap.put('IsPublicWalletAvailable',false);
        }
        else{
            PublicLogData = [Select Id,SalesforceID__c,Member__c,Public_Wallet_Status__c,DOBMatch__c,IdNumberMatch__c,MMNMatch__c,EmailMatch__c,Additional_Token_Option3_Match__c
                             From Authenticated_Log__c where createddate = Today and RecordTypeId= : PublicRec.id and SalesforceID__c = : MemberId and Decision__c ='Fail'];
            system.debug('PublicLogData1##' + PublicLogData);
            if(PublicLogData.size() > 0)
            {
                system.debug('PublicLogData2##' + PublicLogData);
                AuthLogMap.put('PublicLogData',PublicLogData);
                AuthLogMap.put('IsPublicWalletAvailable',false);
            }
            else
            {
                AuthLogMap.put('IsPublicWalletAvailable',true);
                PublicWalletAvailable = 1;
            }
        }
        
        RecordType CFCURec = GetRecordTypeData('Authenticated_Log__c', 'CFCU Wallet Log');
        if(IsUserSessionLoaded == true){
            CFCULogData = [Select Id,SalesforceID__c,Member__c,CFCU_Wallet_Status__c,BeneficiaryDetailMatch__c,Joint_OwnerDetailsMatch__c,CardNumberMatch__c,Additional_Token_Option1_Match__c,Additional_Token_Option2_Match__c, Loan_Detail_Match__c
            From Authenticated_Log__c where  RecordTypeId= : CFCURec.id and SalesforceID__c = : MemberId  and IVR_GUID__c =:IVRGUIDFromUrl order by CreatedDate desc];
        }
        else if(IsUserSessionLoaded == false){
            CFCULogData = [Select Id,SalesforceID__c,Member__c,CFCU_Wallet_Status__c,BeneficiaryDetailMatch__c,Joint_OwnerDetailsMatch__c,CardNumberMatch__c,Additional_Token_Option1_Match__c,Additional_Token_Option2_Match__c, Loan_Detail_Match__c
            From Authenticated_Log__c where createddate = Today and RecordTypeId= : CFCURec.id and SalesforceID__c = : MemberId AND CreatedDate >=: Datetime.now().addMinutes(minutes) and IVR_GUID__c =:IVRGUIDFromUrl];
        }
        system.debug('CFCULogData##' + CFCULogData);
        if(CFCULogData.size() > 0){
            AuthLogMap.put('CFCULogData',CFCULogData);
            AuthLogMap.put('IsCFCUWalletAvailable',false);
        }
        else{
            CFCULogData = [Select Id,SalesforceID__c,Member__c,CFCU_Wallet_Status__c,BeneficiaryDetailMatch__c,Joint_OwnerDetailsMatch__c,CardNumberMatch__c,Additional_Token_Option1_Match__c,Additional_Token_Option2_Match__c, Loan_Detail_Match__c
            From Authenticated_Log__c where createddate = Today and RecordTypeId= : CFCURec.id and SalesforceID__c = : MemberId and Decision__c ='Fail' ];
            if(CFCULogData.size() > 0){
                AuthLogMap.put('CFCULogData',CFCULogData);
                AuthLogMap.put('IsCFCUWalletAvailable',false);
            }
            else{
                AuthLogMap.put('IsCFCUWalletAvailable',true);
                CFCUWalletAvailable = 1;
            }
        }
        
        RecordType OTPRec = GetRecordTypeData('Authenticated_Log__c', 'OTP Authentication Log');
        if(IsUserSessionLoaded == true){
            OTPLogData = [SELECT ID, Decision__c, OTP_Email__c,OTP_Phone__c,OTP_Status__c
                          FROM Authenticated_Log__c where OTP_Status__c != null and  SalesforceID__c =:memberid and IVR_GUID__c =:IVRGUIDFromUrl and RecordTypeId=: OTPRec.Id order by CreatedDate desc limit 1];
        } else if(IsUserSessionLoaded == false){       
            OTPLogData = [SELECT ID, Decision__c, OTP_Email__c,OTP_Phone__c,OTP_Status__c
                          FROM Authenticated_Log__c where OTP_Status__c != null and  SalesforceID__c =:memberid AND CreatedDate >=: Datetime.now().addMinutes(minutes) and IVR_GUID__c =:IVRGUIDFromUrl and RecordTypeId=: OTPRec.Id limit 1];
        }
        if(OTPLogData.size() > 0 && IsUserSessionLoaded == true){
            AuthLogMap.put('OTPLogData',OTPLogData);
            if(OTPLogData[0].OTP_Status__c == 'Fail')
            {
                AuthLogMap.put('IsOTPAvailable',false);
                OTPAvailable = 0;
            }
            else if(OTPLogData[0].OTP_Status__c == 'Pass'){
                AuthLogMap.put('IsOTPAvailable',false);
                OTPAvailable = 0;
            }
        }
        else
        {
            OTPLogData = [SELECT ID, Decision__c, OTP_Email__c,OTP_Phone__c,OTP_Status__c
                          FROM Authenticated_Log__c where OTP_Status__c != null and  SalesforceID__c =:memberid and  createddate = Today and RecordTypeId=: OTPRec.Id and Decision__c = 'OTP – Code Failed' limit 1 ];
            if(OTPLogData.size() > 0){
                AuthLogMap.put('OTPLogData',OTPLogData);
                if(OTPLogData[0].OTP_Status__c == 'Fail')
                {
                    AuthLogMap.put('IsOTPAvailable',false);
                }
                else{
                    AuthLogMap.put('IsOTPAvailable',true);
                    OTPAvailable = 1;
                }
            }else{
                
                AuthLogMap.put('IsOTPAvailable',true);      
                OTPAvailable = 1;
                
            }
            
            
        }
        
        list<Member_Verification_Attempt__c> mva = new List<Member_Verification_Attempt__c>();
        if(IsUserSessionLoaded == true){
            mva =  [Select id, IVR_GUID__c, Member_Salesforce_Id__c, Points_Obtained__c, Maximum_Points_Available__c, Current_Authentication_Level__c, Highest_Achievable_Level__c, Next_Level__c from Member_Verification_Attempt__c where IVR_GUID__c=:IVRGUIDFromUrl and Member_Salesforce_Id__c =: memberid order by createddate desc limit 1];
            
        }else if(IsUserSessionLoaded == false){
            mva = [Select id, IVR_GUID__c, Member_Salesforce_Id__c, Points_Obtained__c, Maximum_Points_Available__c, Current_Authentication_Level__c, Highest_Achievable_Level__c, Next_Level__c from Member_Verification_Attempt__c where IVR_GUID__c=:IVRGUIDFromUrl and Member_Salesforce_Id__c =: memberid AND CreatedDate >=: Datetime.now().addMinutes(minutes) limit 1];
        }
        system.debug('mva##'+ mva);
        if(mva.size() > 0)
        {
            AuthLogMap.put('ScorePoints',mva);
            if(mva[0].Points_Obtained__c != null){
                CurrentScore = mva[0].Points_Obtained__c.intValue();
                
            }
            system.debug('ScorePoints##'+ mva[0]);
        }
        
        system.debug('CurrentScore##'+ CurrentScore);
        List<Person_Account__c> p = [SELECT Id, Account_Number__c, PersonID__r.Name, PersonID__c, Account_Number__r.RecType__c, TypeTranslate__c, Account_Number__r.Name
                                     FROM Person_Account__c where PersonID__c =:memberid limit 1];
        AccountNumber = AccountNumberInput;  
        system.debug('ListSize P#'+ p.size());
        if(p.size() > 0) {
            
            //AccountNumber = p[0].Account_Number__r.Name;
            system.debug('AccountNumberInput##'+ AccountNumberInput);
            system.debug('AccountNumber##'+ AccountNumber);
            pc = [select id,Transmission_Date__c,CreatedDate,Member_Number__c,Function__c from MC_PIN_Change__c where Member_Number__c =: AccountNumber and CreatedDate = LAST_N_DAYS:30 and Function__c = 'PIN Change'];
            system.debug('ListSize PC#'+ pc.size());
            if(pc.size() > 0){
                IsPinChanged = true;
                
            }
            else{
                IsPinChanged = false;
                
            }
        }
        
        
        system.debug('CurrentScore##' + CurrentScore);
        system.debug('OOWAvailable##'+ OOWAvailable);
        map<string, List<string>> NextTabToAchieveLevelMap =  GetTabsToAchieveNextLevel(LevelModel, ScoringModel, MemberType, DebitCardStatus, IsPinChanged, OTPAvailable, PublicWalletAvailable, CFCUWalletAvailable,OOWAvailable, CurrentScore);
        List<string>  NextTabLevel2 = NextTabToAchieveLevelMap.get('NextTabLevel2');
        List<string>  NextTabLevel3 = NextTabToAchieveLevelMap.get('NextTabLevel3');
        List<string> EachLevelStatus = NextTabToAchieveLevelMap.get('EachLevelStatus');
        
        if(NextTabLevel2.size() > 0)
        {
            string NextTabLevel2LastString = NextTabLevel2.get(NextTabLevel2.size()-1);
            NextTabLevel2LastString = NextTabLevel2LastString.removeEnd('or');
            NextTabLevel2.remove((NextTabLevel2.size()-1));
            NextTabLevel2.add(NextTabLevel2LastString);
            system.debug('NextTabLevel2LastString#'+ NextTabLevel2LastString);
        }
        if(NextTabLevel3.size() > 0){
            string NextTabLevel3LastString = NextTabLevel3.get(NextTabLevel3.size()-1);      
            NextTabLevel3LastString = NextTabLevel3LastString.removeEnd('or');      
            NextTabLevel3.remove((NextTabLevel3.size()-1));      
            NextTabLevel3.add(NextTabLevel3LastString);
            system.debug('NextTabLevel3LastString#'+ NextTabLevel3LastString);
        }
        
        system.debug('NextTabLevel2List#'+ NextTabLevel2);
        system.debug('NextTabLevel3List#'+ NextTabLevel3);
        
        system.debug('EachLevelStatus##'+ EachLevelStatus);
        
        if(EachLevelStatus.size() >0)
        {
            for(string s: EachLevelStatus){
                
                if(s == 'Level 2 Achieved'){
                    IsLevel2Achieved = true;
                }
                if(s == 'Level 3 Achieved'){
                    IsLevel3Achieved = true;
                }
            }
        }
        
        if(IsLevel2Achieved == true){
            AuthLogMap.put('NextTabLevel2', 'Level Reached');
        }
        else if(IsLevel2Achieved == false && NextTabLevel2.size()==0){
            AuthLogMap.put('NextTabLevel2', 'Not Achievable');
            
        }
        else if(IsLevel2Achieved == false && NextTabLevel2.size()> 0){
            AuthLogMap.put('NextTabLevel2', NextTabLevel2);
        }
        if(IsLevel3Achieved == true){
            AuthLogMap.put('NextTabLevel3', 'Level Reached');
        }
        else if(IsLevel3Achieved == false && NextTabLevel3.size()==0){
            AuthLogMap.put('NextTabLevel3', 'Not Achievable');
            
        }
        else if(IsLevel3Achieved == false && NextTabLevel3.size()> 0){
            AuthLogMap.put('NextTabLevel3', NextTabLevel3);
        }
        
        
        AuthLogMap.put('IsLevel1Achieved',IsLevel1Achieved);
        AuthLogMap.put('IsLevel2Achieved',IsLevel2Achieved);
        AuthLogMap.put('IsLevel3Achieved',IsLevel3Achieved);
        
        
        return AuthLogMap;
    }
    
    
    @AuraEnabled
    
    public static integer GetMemberAuthenticationSessionTime()
    {
        List<Member_Authentication_Session_Time__c> custSetting = new List<Member_Authentication_Session_Time__c>();
        custSetting = [Select id, Name, Session_Time__c from Member_Authentication_Session_Time__c];
        integer minutes=0;
        if(custSetting.size() > 0){          
            minutes =  custSetting[0].Session_Time__c.intValue();                    
        }
        minutes = minutes * (-1);
        return minutes;
    }
    
    @AuraEnabled
    public static List<Authenticated_Log__c> GetMAAPLogData(string MemberId )
    {
        List<Authenticated_Log__c> AuthLog = [Select Id, Name,CreatedDate,Created_Date__c, RecordTypeId,RecordType.Name, IVR_Sent_URL__c,CallerPhoneNumber__c,EnteredMemberNumber__c,EnteredSSN__c, Failed_Desired_Level__c,
        EnteredCardNumber__c,CardNumberMatch__c,PhoneNumberMatch__c, MemberNumberMatch__c, SSNnumberMatch__c,
     IVR_SSN__c,IVR_Card_Number__c,IVR_Member_Number__c,IVR_Member_Number_Match__c,IVR_SSN_Match__c,IVR_Card_Match__c,
     IVR_Pin_Match__c,PINMatch__c,HP_HV__c,IVR_Code__c,Last_Achievable_Level__c,
        Override_Request_Supervisor__c,Override_Supervisor__c,Override_Request_Type__c,Manager_Override_Case__c,Manager_Override_Case_Id__c,
        OOW_Status__c,OOW_Member_Number__c,OOW_Reason__c,OOW_Notes__c,First_Name__c,Last_Name__c,
        Public_Wallet_Status__c,DOBMatch__c,IdNumberMatch__c,MMNMatch__c,EmailMatch__c,Additional_Token_Option3_Match__c,Case__r.CaseNumber,Manager_Override_Case__r.CaseNumber,
        CFCU_Wallet_Status__c,BeneficiaryDetailMatch__c,Joint_OwnerDetailsMatch__c,Additional_Token_Option1_Match__c,Additional_Token_Option2_Match__c,Loan_Detail_Match__c,
        Decision__c,SalesforceID__c,Member__c,Member_Number__c,Staff_Name__c,Current_User__c,GUID__c,IVR_GUID__c,Unusual_activity__c, StaffName__c from Authenticated_Log__c where SalesforceID__c= :MemberId and Recordtype.name='Master Authentication Log' order by createddate desc];
        system.debug('AuthLog##'+ AuthLog);
        return AuthLog;
    } 
    
    @AuraEnabled
    public static List<Authenticated_Log__c> GetMasterLogData(string LogId )
    {
        List<Authenticated_Log__c> AuthLog = [Select Id, Name,CreatedDate,Created_Date__c, SalesforceID__c, RecordTypeId,RecordType.Name,
                                              CardNumberMatch__c,CFCU_Card_Number__c,Beneficiary_Details__c, BeneficiaryDetailMatch__c,JointOwner_Details__c,Joint_OwnerDetailsMatch__c,Member_Loan_Detail__c, Loan_Detail_Match__c
                                              from Authenticated_Log__c where Id= :LogId and Recordtype.name='Master Authentication Log' order by createddate desc];
        system.debug('AuthLog##'+ AuthLog);
        return AuthLog;
    } 
    
    public class AuthenticationLogWrapper{
        
        @AuraEnabled
        
        public string GUID {get;set;}
        
        @AuraEnabled
        
        public String CreatedDate {get;set;}
        @AuraEnabled
        
        public string LogNumber {get;set;}
        @AuraEnabled
        
        
        public string UserName {get;set;}
        @AuraEnabled
        
        public string MemberNumber {get; set;}        
        @AuraEnabled
        
        public string PhoneNumber {get;set;}
        @AuraEnabled
        
        public string AuthenticationType {get;set;}
        @AuraEnabled
        
        public string Decision {get;set;}
        @AuraEnabled
        
        public string FDL {get;set;}
        
        @AuraEnabled
        
        public string CaseNumber {get;set;}
        @AuraEnabled
        public string CaseComment {get;set;}
        @AuraEnabled
        
        public string OverrideRequestType {get;set;}
        @AuraEnabled
        
        public string OverrideRequestedSupervisor {get;set;}
        
        @AuraEnabled
        
        public string DebitPin {get;set;}
        
    }
    
    
    public class JointMemberRelationshipWrapper{
        
        @AuraEnabled
        public string AccountNumber {get;set;}
        
        @AuraEnabled
        public string RelationShip {get;set;}
        
        @AuraEnabled
        public string JointMembername {get; set;}
        
        @AuraEnabled
        public Id ID {get;set;}
        
    }
    
    public static list<string> GetRelatedAccountsPopulated(string accID, account acc)
    {
        
        set<string> typeList = new set<string>();
        for(Member360_TypeTranslate__c t : Member360_TypeTranslate__c.getAll().values()){
            typeList.add(t.name);  
        }
        list<string> allRelatedAccounts = new list<string>();
        allRelatedAccounts.add(accID);
        
        
        system.debug('allRelatedAccounts 1---' + allRelatedAccounts);
        
        
        
        
        
        
        list<Person_Account__c> paList = new list<Person_Account__c>();
        paList = [SELECT Id,
                  Account_Number__c, Account_Number__r.RecType__c, Account_Number__r.Name FROM Person_Account__c WHERE PersonID__c =:acc.Id and TypeTranslate__c IN:typeList];
        set<String> accountNumberSet = new set<String>();
        set<Id> accIdset = new set<Id>();
        set<String> acctypeSet = new set<String>();
        for (Person_Account__c var: paList)
        {
            accountNumberSet.add(var.Account_Number__r.Name);
            acctypeSet.add(var.Account_Number__r.RecType__c);
            accIdSet.add(var.Account_Number__c);
        }
        
        list<Account_Details__c> accList = new list<Account_Details__c>();
        if (acctypeSet.contains('ACCT'))
        {
            accList = [SELECT Id,
                       Name FROM Account_Details__c WHERE Name IN: accountNumberSet and RecType__c != 'CARD'];
        }
        else
        {
            accList = [SELECT Id,
                       Name
                       
                       FROM Account_Details__c Where Id IN: accIdSet and RecType__c != 'CARD'];
        }
        system.debug('allRelatedAccounts 2---' + allRelatedAccounts);
        
        set<String> accName = new Set<String>();
        
        for (Account_Details__c var: accList)
        {
            accName.add(var.Name);
        }
        
        list<Person_Account__c> ContactList = new list<Person_Account__c>();
        ContactList = [Select
                       
                       Account_Number__c, personId__c
                       
                       From Person_Account__c WHERE Account_Number__r.Name IN: accName and TypeTranslate__c IN:typeList]; //  and (NOT TypeTranslate__c like '%Beneficiary%')
        list<string> accids = new list<string>();
        
        for (Person_Account__c var: ContactList)
        {
            accids.add(var.Account_Number__c);
            allRelatedAccounts.add(var.personId__c);
            
        }
        system.debug('allRelatedAccounts 3---' + allRelatedAccounts);
        
        return allRelatedAccounts;
        
    }

    /*----------------This will get Warning Code for Member------------------*/
    @AuraEnabled    
    public static list<string> GetMemberWarningCodes(string accountid)
    {
        // Bringing data from custom setting for Levels 
        // system.debug('Warning Coed accountid:'+accountid);
        // list<string> rwcwList = new list<string>();
        // rwcwList = MemberWarningCodeLightningController.getData(accountid);
        
        // return rwcwList;
        list<string> rwcwList = new list<string>();
       list<Person_Account__c> paList = [SELECT Id,Account_Number__c, Account_Number__r.RecType__c, Account_Number__r.Name FROM Person_Account__c WHERE PersonID__c =:accountid and TypeTranslate__c !=: '0004/Beneficiary'];
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
        
        
        
        set<string> wcwList = new set<string>();
       
        for(Account_Details__c var: accList){
            if(var.WARNING_01_CODE__c != NULL || var.WARNING_01_CODE__c !='' || var.WARNING_01_CODE__c != '000-NONE' || var.WARNING_01_CODE__c != '0-NONE'){
               
                 wcwList.add(var.WARNING_01_CODE__c);
                
            }
            if(var.WARNING_02_CODE__c != NULL || var.WARNING_02_CODE__c !='' || var.WARNING_02_CODE__c != '000-NONE' || var.WARNING_02_CODE__c != '0-NONE'){
                
                  wcwList.add(var.WARNING_02_CODE__c);
                
            }
            if(var.WARNING_03_CODE__c != NULL || var.WARNING_03_CODE__c !='' || var.WARNING_03_CODE__c != '000-NONE' || var.WARNING_03_CODE__c != '0-NONE'){
                
                wcwList.add(var.WARNING_03_CODE__c);
                
            }            
            if(var.WARNING_04_CODE__c != NULL || var.WARNING_04_CODE__c !='' || var.WARNING_04_CODE__c != '000-NONE' || var.WARNING_04_CODE__c != '0-NONE'){
               
                wcwList.add(var.WARNING_04_CODE__c);
                
            }
            if(var.WARNING_05_CODE__c != NULL || var.WARNING_05_CODE__c !='' || var.WARNING_05_CODE__c != '000-NONE' || var.WARNING_05_CODE__c != '0-NONE'){
                
                wcwList.add(var.WARNING_05_CODE__c);
                
            }
            if(var.WARNING_06_CODE__c != NULL || var.WARNING_06_CODE__c !='' || var.WARNING_06_CODE__c != '000-NONE' || var.WARNING_06_CODE__c != '0-NONE'){
                
                wcwList.add(var.WARNING_06_CODE__c);
                
            }
            if(var.WARNING_07_CODE__c != NULL || var.WARNING_07_CODE__c !='' || var.WARNING_07_CODE__c != '000-NONE' || var.WARNING_07_CODE__c != '0-NONE'){
                
                  wcwList.add(var.WARNING_07_CODE__c);
                
            }
            if(var.WARNING_08_CODE__c != NULL || var.WARNING_08_CODE__c !='' || var.WARNING_08_CODE__c != '000-NONE' || var.WARNING_08_CODE__c != '0-NONE'){
               
                  wcwList.add(var.WARNING_08_CODE__c);
                
            }
            if(var.WARNING_09_CODE__c != NULL || var.WARNING_09_CODE__c !='' || var.WARNING_09_CODE__c != '000-NONE' || var.WARNING_09_CODE__c != '0-NONE'){
                
                  wcwList.add(var.WARNING_09_CODE__c);
                
            }
            if(var.WARNING_10_CODE__c != NULL || var.WARNING_10_CODE__c !='' || var.WARNING_10_CODE__c != '000-NONE' || var.WARNING_10_CODE__c != '0-NONE'){
                
                  wcwList.add(var.WARNING_10_CODE__c);
                
            }
            if(var.WARNING_11_CODE__c != NULL || var.WARNING_11_CODE__c !='' || var.WARNING_11_CODE__c != '000-NONE' || var.WARNING_11_CODE__c != '0-NONE'){
               
                  wcwList.add(var.WARNING_11_CODE__c);
                
            }
            if(var.WARNING_12_CODE__c != NULL || var.WARNING_12_CODE__c !='' || var.WARNING_12_CODE__c != '000-NONE' || var.WARNING_12_CODE__c != '0-NONE'){
                
                  wcwList.add(var.WARNING_12_CODE__c);
                
            }
            if(var.WARNING_13_CODE__c != NULL || var.WARNING_13_CODE__c !='' || var.WARNING_13_CODE__c != '000-NONE' || var.WARNING_13_CODE__c != '0-NONE'){
                
                  wcwList.add(var.WARNING_13_CODE__c);
                
            }
            if(var.WARNING_14_CODE__c != NULL || var.WARNING_14_CODE__c !='' || var.WARNING_14_CODE__c != '000-NONE' || var.WARNING_14_CODE__c != '0-NONE'){
               
                  wcwList.add(var.WARNING_14_CODE__c);
                
            }
            if(var.WARNING_15_CODE__c != NULL || var.WARNING_15_CODE__c !='' || var.WARNING_15_CODE__c != '000-NONE' || var.WARNING_15_CODE__c != '0-NONE'){
                
                  wcwList.add(var.WARNING_15_CODE__c);
                
            }
            if(var.WARNING_16_CODE__c != NULL || var.WARNING_16_CODE__c !='' || var.WARNING_16_CODE__c != '000-NONE' || var.WARNING_16_CODE__c != '0-NONE'){
               
                  wcwList.add(var.WARNING_16_CODE__c);
                
            }
            if(var.WARNING_17_CODE__c != NULL || var.WARNING_17_CODE__c !='' || var.WARNING_17_CODE__c != '000-NONE' || var.WARNING_17_CODE__c != '0-NONE'){
               
                  wcwList.add(var.WARNING_17_CODE__c);
                
            }
            if(var.WARNING_18_CODE__c != NULL || var.WARNING_18_CODE__c !='' || var.WARNING_18_CODE__c != '000-NONE' || var.WARNING_18_CODE__c != '0-NONE'){
                
                  wcwList.add(var.WARNING_18_CODE__c);
                
            }
            if(var.WARNING_19_CODE__c != NULL || var.WARNING_19_CODE__c !='' || var.WARNING_19_CODE__c != '000-NONE' || var.WARNING_19_CODE__c != '0-NONE'){
                
                  wcwList.add(var.WARNING_19_CODE__c);
                
            }
            if(var.WARNING_20_CODE__c != NULL || var.WARNING_20_CODE__c !='' || var.WARNING_20_CODE__c != '000-NONE' || var.WARNING_20_CODE__c != '0-NONE'){
                
                  wcwList.add(var.WARNING_20_CODE__c);
                
            }
            
        }        
      
        // set<string> wcwSet = new set<string>();
        // for(warningCodeWrapper w: wcwList){
        //     wcwSet.add(w.imgUrl);
        // }
        rwcwList.addAll(wcwList);
        return rwcwList;
    }

    public static list<Account_Details__c> GetCardDetails(string accId){
        Integer PageNo = 1,  PageSize = 50;
        list<Person_Account__c> paList = [SELECT Id,
                             Account_Number__c, Account_Number__r.RecType__c,TypeTranslate__c, Account_Number__r.Name FROM Person_Account__c WHERE PersonID__c =:accId order by TypeTranslate__c desc];
        
        set<string> typeList = new set<string>();
        for(Member360_TypeTranslate__c t : Member360_TypeTranslate__c.getAll().values()){
          typeList.add(t.name);  
        } 
        
        List<string> accountNumberSet = new List<string>();
        List<string> accIdset = new List<string>();
        List<string> acctypeSet = new List<string>();
        Map<string,string> listRelationships = new  Map<string,string>(); 
        Map<string,string> listRelationshipsexcluded = new  Map<string,string>();
        Map<string,string> listRelationshipsNameexcluded = new  Map<string,string>();  
        Map<string,string> listRelationshipsName = new  Map<string,string>();
        for(Person_Account__c var: paList){
                 accountNumberSet.add(var.Account_Number__r.Name);
               acctypeSet.add(var.Account_Number__r.RecType__c);
                 accIdSet.add(var.Account_Number__c);
                listRelationships.put(var.Account_Number__c,var.TypeTranslate__c);
                listRelationshipsName.put(var.Account_Number__r.Name,var.TypeTranslate__c);
               
               if(typeList.contains(var.TypeTranslate__c)){
                  
              }    
              else{
           
                    listRelationshipsexcluded.put(var.Account_Number__c,var.TypeTranslate__c);
                    listRelationshipsNameexcluded.put(var.Account_Number__r.Name,var.TypeTranslate__c);
                }   
             
             
            } 
       
       
       
        Map<string, object> m = new Map<string, object>();
        
        system.debug('listRelationshipsexcluded++ GetAllData++' + listRelationshipsexcluded);
        system.debug('listRelationshipsNameexcluded++ GetAllData++' + listRelationshipsNameexcluded);
        system.debug('listRelationships++ GetAllData++' + listRelationships);
        system.debug('listRelationshipsName++ GetAllData++' + listRelationshipsName);
        system.debug('acctypeSet++ GetAllData++' + acctypeSet);
        system.debug('accountNumberSet++ GetAllData++' + accountNumberSet);
        system.debug('accIdset++ GetAllData++' + accIdset);
        
        List<Account_Details__c> listACCList = [SELECT Id, Name, RecType__c, TypeTranslate__c, ID1__c, Balance__c, Combined_Account_ID__c, 
                              Brand__c, Loan_Number__c, Close_Date__c, Card_Number_Last_4_Digits__c, OPEN_DATE__c,
                              Open_Date_PST__c, Expiration_Date__c, Issue_Date__c, Emp_Balance__c, Emp_Available_Balance__c,
                              Available_Balance__c FROM Account_Details__c WHERE Name IN: accountNumberSet and RecType__c != 'CARD'];
        
        List<String> AccountListIdSet = new List<String>();
        for(Account_Details__c ac:listACCList){
            string relationshipname = listRelationshipsName.get(ac.Name);
            if(relationshipname != null && !relationshipname.contains('Beneficiary')){
                AccountListIdSet.Add(ac.Id);  
            }
        }

        List<Account_Details__c> listACCListReturn = new List<Account_Details__c>();
        if(AccountListIdSet.size() > 0)
        { 
            listACCListReturn =[SELECT Id, Name, RecType__c, TypeTranslate__c, ID1__c, Balance__c, Combined_Account_ID__c, 
                              Brand__c, Loan_Number__c, Close_Date__c, Card_Number_Last_4_Digits__c, OPEN_DATE__c,
                              Open_Date_PST__c, Expiration_Date__c, Issue_Date__c, Emp_Balance__c, Emp_Available_Balance__c,
                              Available_Balance__c FROM Account_Details__c WHERE Id IN: AccountListIdSet];
            
                for(Account_Details__c acc:listACCListReturn){
                                acc.Card_Name__c = listRelationshipsName.get(acc.Name);
                            }
                           
        }
        
        
        List<String> accountNumberSetWOBeneficiary = new List<String>();
        List<String> accIdSetWOBeneficiary = new List<String>();        
        
        for(Account_Details__c item: listACCListReturn)
        {
           
            accountNumberSetWOBeneficiary.add(item.Name);
            accIdSetWOBeneficiary.add(item.id);
        }
    system.debug('listACCList++' + listACCList);
    system.debug('accountNumberSetWOBeneficiary++' + accountNumberSetWOBeneficiary);
        system.debug('accIdSetWOBeneficiary++' + accIdSetWOBeneficiary);

        /*--------------------------------------Get Cards List--------------------------------*/
        
        List<Account_Details__c> listCardsList = New List<Account_Details__c>();
        listCardsList =[SELECT Id, Name, RecType__c, TypeTranslate__c, ID1__c, Balance__c, Combined_Account_ID__c, 
                              Brand__c, Loan_Number__c, Close_Date__c, Card_Number_Last_4_Digits__c, OPEN_DATE__c,
                              Open_Date_PST__c, Expiration_Date__c, Issue_Date__c, Emp_Balance__c, Emp_Available_Balance__c,
                              Available_Balance__c FROM Account_Details__c WHERE Name IN: accountNumberSetWOBeneficiary and RecType__c = 'CARD' and status1__c = '1 Issued'];
        return listCardsList;

    }
    
   
    
}