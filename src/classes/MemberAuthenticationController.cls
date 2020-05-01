public class MemberAuthenticationController{
    
    /* variables without IVR prefix will contain latest value (IVR or entered by user or changed on selection)
        variables prefixed with IVR witll contain values returned by IVR and will not be changed.
        No need for IVR copy variables
        variables with Confirm Suffix are confirmed by agent
    */
    
    /*
        1) Basic flow - verify if all parameters have succeeded (3 validations minimum) redirect to member_authenticated and log.
        2) IVR entered values + additional information asked by agent
        3) Clear all fields and values entered by agent
    */
    
  public  Integer clickcount =0;
    public String PhoneNumber{get;set;}
    public String PhoneNumberMatch{get;set;}
    public String IVRPhoneNumberMatch;
    public String ReasonCode{get;set;}
    public String HighFlag{get;set;}
    public String MemberType{get;set;}
        
    public String OTPVerified {get;set;}
    
    
    public String EnteredCardNumber{get;set;}
    private String IVREnteredCardNumber{get;set;}
    public String EnteredCardNumberLastdigits{get;set;}
    public String EnteredCardNumberFormatted{get;set;}
    
    public String CardNumberMatch{get;set;}
    private String IVRCardNumberMatch{get;set;}
    public boolean CardNumberConfirm{get;set;}{CardNumberConfirm = false;}
    
    
    public String PINMatch{get;set;}
    public String IVRGUID{get;set;}
    private String IVRPINMatch{get;set;}
    
    
    public String EnteredMemberNumber{get;set;}
    private String IVREnteredMemberNumber{get;set;}
    public String EnteredMemberNumberRetain{get;set;}
        
    public String MemberNumberMatch{get;set;}
    private String IVRMemberNumberMatch{get;set;}
    /* Valid - Verified - No Match Found*/
    public string MemberNumberMatchStatus {get;set;}
    public boolean MemberNumberConfirm{get;set;}{MemberNumberConfirm = false;}    
    
    public String EnteredSSN{get;set;}
    private String IVREnteredSSN{get;set;}
    public String SSNnumberMatch {get;set;}
    public String IVRSSNnumberMatch{get;set;}
    public boolean SSNnumberConfirm{get;set;}{SSNnumberConfirm = false;}
    
    public string SSNnumberConfirmString{get;set;}{SSNnumberConfirmString = '';}
      
    public String SalesforceID{get;set;}
    
    public string fromMarsData {get;set;}
     
    public String DOB{get;set;}
    
    public string IVRDOB{get;set;}
    public String DOBMatch{get;set;}
    public String IVRDOBMatch{get;set;}
    public boolean DOBConfirm{get;set;}{DOBConfirm = false;}
    public string DOBConfirmString {get;set;} {DOBConfirmString = '';}
    
     // DL/STATE ID/PASSPORT
    public String DLStateIdPassport{get;set;}
    public string IVRDLStateIdPassport{get;set;}
    public String DLStateIdPassportMatch{get;set;}
    public String IVRDLStateIdPassportMatch{get;set;}
    public boolean DLStateIdPassportConfirm{get;set;}{DLStateIdPassportConfirm = false;}
    public string DLStateIdPassportConfirmString {get;set;} {DLStateIdPassportConfirmString = '';}
    // DL/STATE ID/PASSPORT
    public String IdNumber{get;set;}
    public String IdNumberMatch{get;set;}
    
    public boolean IdNumberConfirm{get;set;}{IdNumberConfirm = false;}
    public string IdNumberConfirmString{get;set;}{IdNumberConfirmString = '';}
    
    public String MMN{get;set;}
    public String MMNMatch{get;set;} 
    public boolean MMNConfirm{get;set;}{MMNConfirm = false;}
    public string MMNConfirmString{get;set;}{MMNConfirmString = '';}
    
    
    public String Email{get;set;}
    public List<selectOption> LstEmail{get;set;}
    public String EmailMatch{get;set;} 
    public boolean EmailConfirm{get;set;}{EmailConfirm = false;}
    public string EmailConfirmString{get;set;}{EmailConfirmString = '';}
    
    
    public  List<Account_Details__c> MemberLoanDetails {get; set;}
    public boolean LoanDetailConfirm{get;set;} 
    
    /* stores all accounts found */
    public list<Account> NameList{get;set;}
    // constant
    public static final String CONST_TRUE = 'true';
    
    // selected member id  
    public String selectedID{get; set;}
    
    // contains member information for basic authenticated member when salesforceid is passed by IVR
    public Account Names{get;set;}
    
    // calculated variable
    public integer nameListSize{
        get
        {
            if (NameList != null)
                return NameList.size();
            else
                return 0;
        }
        
        }
        
      public String RedirectToURL{get;set;}
        
    // not sure    
    @TestVisible private String oldFieldToMatch{get; set;}
    
    // internal
    private String firstName{get; set;}
    private String lastName{get; set;}
    
    // not used
    public boolean JtMemberNameConfirm {get;set;}
    public boolean JtMemberDOBConfirm {get;set;}
    
   
    public Boolean showloantables {get
    {
        if(MemberLoanDetails != null && !MemberLoanDetails.isEmpty())
        {       
          return true;      
        }       
        else
        {       
          return false;   
        }       
                
    }}
    public boolean showErrorMsgLoanData {get
    {
        if (selectedID == '')
        {
            return false;
        }
        else if(MemberLoanDetails != null && !MemberLoanDetails.isEmpty())
        {       
          return false;      
        }       
        else
        {       
          return true;   
        }
    }
    } 
    // internal
    public List<Person_Account__c> MemberNameDobDetails {get; set;}
    
    public List<Person_Account__c> JTMemberNameDobDetails {get; set;}
    public Boolean ShowJTMembertables {get; set;} 
    public Boolean showErrorMsgJTmemberTable {get; set;} 
    // internal
    public Map <id,Person_Account__c> uniqueMembersDetail {get; set;}
    
    public List<JTMemberNameDoBWrapper> JTwrapperLst {get;set;}
    
    // internal
    public string JTSelectedID{get;set;}
    public string LoanSelectedID{get;set;}
    public String PageURL {get;set;}
    public Boolean ClearAllflag {get;set;}
    
    
    // Additional tokens internal
    public string AdditionalToken1Selection {get;set;}
    public string AdditionalToken1chk {get;set;}
    public string AdditionalToken1chkString {get;set;}{AdditionalToken1chkString='';}
    public string AdditionalToken2Selection {get;set;}
    public string AdditionalToken2chk {get;set;}
    public string AdditionalToken2chkString {get;set;}{AdditionalToken2chkString='';}
    public string AdditionalToken3Selection {get;set;}
    public string AdditionalToken3chk {get;set;}
    public string AdditionalToken3chkString {get;set;}{AdditionalToken3chkString='';}
    public string AdditionalTokenOtherText {get;set;}
    public string AdditionalTokenOtherText1 {get;set;}
    public string AdditionalTokenOtherText2 {get;set;}
    
    // internal
    public String MultipleMemberNumberAlert{get; set;}{MultipleMemberNumberAlert = '';}
    public string pinString{get; set;}{pinString = '';}
    private verifyCaller vc = new verifyCaller();
    public List<SelectOption> AdditionalTokens
    {
        get
        {
             List<SelectOption> options = new List<SelectOption>();
            options.add(new SelectOption('','Select'));
            options.add(new SelectOption('ATM/Debit Card','ATM/Debit Card'));
            options.add(new SelectOption('Birth place','Birth place'));
            //options.add(new SelectOption('Email address','Email address'));
            options.add(new SelectOption('Online banking username','Online banking username'));
            //options.add(new SelectOption('OTP','OTP'));
            options.add(new SelectOption('Password from comment flag','Password from Comment flag'));
            options.add(new SelectOption('Red Herring','Red Herring'));
            options.add(new SelectOption('Transaction history question','Transaction history question'));
            options.add(new SelectOption('Other','Other'));
            
            return options;
            
        }
    }
    
    public List<SelectOption> AdditionalTokensWithOther
    {
        get
        {
             List<SelectOption> options = new List<SelectOption>();
            options.add(new SelectOption('','Select'));
            options.add(new SelectOption('ATM/Debit Card','ATM/Debit Card'));
            options.add(new SelectOption('Birth place','Birth place'));
            //options.add(new SelectOption('Email address','Email address'));
            options.add(new SelectOption('Online banking username','Online banking username'));
            //options.add(new SelectOption('OTP','OTP'));
            options.add(new SelectOption('Password from comment flag','Password from Comment flag'));
            options.add(new SelectOption('Red Herring','Red Herring'));
            options.add(new SelectOption('Transaction history question','Transaction history question'));
            options.add(new SelectOption('Other','Other'));
            
            return options;
            
        }
    }
    
    public MemberAuthenticationController(){
       ClearAllflag = false;
       JTwrapperLst = new List<JTMemberNameDoBWrapper>();
       NameList = new list<Account>();
       showErrorMsgJTmemberTable  = false;
       JTMemberNameDobDetails = new List<Person_Account__c>();
       MemberLoanDetails = new List<Account_Details__c>();
       PageURL = ApexPages.currentPage().getUrl();
       
    }
   // method called from MemberAuthenticatedUtility page to load data based on current logged in user
   public PageReference GetCurrentUserData(){   
        
        //Current_User__c
        String CurrentUser = UserInfo.getUserId();
        Boolean IsUserSessionLoaded = true;
        Id MemberId;
        List<Authenticated_Log__c> AuthList = [Select id ,RecordType.Name , CallerPhoneNumber__c,EnteredMemberNumber__c,
        							EnteredSSN__c,IVR_SSN__c,SalesforceID__c, Current_User__c, PINMatch__c,HP_HV__c, IVR_Code__c, IVR_Sent_URL__c, IVR_GUID__c, Decision__c
        							From Authenticated_Log__c where Current_User__c =:CurrentUser and IVR_GUID__c != null and Decision__c != 'Level Achieved'  order by createddate desc Limit 1 ]; 
       system.debug('AuthList##' + AuthList);
       String IVRInteractionId;
        if(AuthList.size() > 0)
        {
        	IVRInteractionId = AuthList[0].IVR_GUID__c;
        	if(AuthList[0].IVR_Sent_URL__c == '' || AuthList[0].IVR_Sent_URL__c == null)
        	{
        		
        		
        		AuthList = [Select id ,RecordType.Name , CallerPhoneNumber__c,EnteredMemberNumber__c,
        							EnteredSSN__c,IVR_SSN__c,SalesforceID__c, Current_User__c, PINMatch__c,HP_HV__c, IVR_Code__c, IVR_Sent_URL__c, IVR_GUID__c, Decision__c
        							From Authenticated_Log__c where IVR_GUID__c =:IVRInteractionId  and Decision__c != 'Level Achieved' and RecordType.Name='IVR Authentication Log' order by createddate desc Limit 1 ]; 
        	}
        	
        	if(AuthList[0].IVR_SSN__c != null )
        	{
        		EnteredSSN = AuthList[0].IVR_SSN__c;
        	}
        	else
        	{
        		EnteredSSN = AuthList[0].EnteredSSN__c;
        	}
        	
        	EnteredMemberNumber = AuthList[0].EnteredMemberNumber__c;
        	PhoneNumber = AuthList[0].CallerPhoneNumber__c;
        	if(AuthList[0].PINMatch__c == 'Fail')
        	{
        		PINMatch = 'false';
        	}else if(AuthList[0].PINMatch__c == 'Pass')
        	{
        		PINMatch = 'true';
        	}
        	else{
        		PINMatch = AuthList[0].PINMatch__c;
        	}
        	
        	IVRGUID = AuthList[0].IVR_GUID__c;
        	ReasonCode = AuthList[0].IVR_Code__c;
        	if(AuthList[0].HP_HV__c == 'HP'){
        		HighFlag = '2';
        	}
        	else if(AuthList[0].HP_HV__c == 'HV')
        	{
        		HighFlag = '1';
        	}
        	MemberId = AuthList[0].SalesforceID__c;
        	
        	
        	
        }
        
        PageReference pageCalulated = null;        
        integer noOfVerifiedFields = 0;
        
               
        if(CONST_TRUE.equalsIgnoreCase(CardNumberMatch) && CONST_TRUE.equalsIgnoreCase(PinMatch)){
         //&& CONST_TRUE.equalsIgnoreCase(pinMatch)
            noOfVerifiedFields = noOfVerifiedFields+1;
        }
        // SSN should not be counted as valid authentication
        if(CONST_TRUE.equalsIgnoreCase(SSNnumberMatch)){
            noOfVerifiedFields = noOfVerifiedFields+1;
        }
        if(CONST_TRUE.equalsIgnoreCase(MemberNumberMatch)){
            noOfVerifiedFields = noOfVerifiedFields+1;
        }  
        //if(noOfVerifiedFields < 3){
        setConfirmationOncheckboxes();
        
        if(EnteredMemberNumber == null || EnteredMemberNumber == '')
        {
            fromMarsData = 'True';
        }
        else
        {
            fromMarsData = 'False';
        }
        
        //pageCalulated = new PageReference('/apex/verifiy');
        
       
        //pageCalulated = new PageReference('/lightning/cmp/c__LightningVerification?c__EnteredSSN='+ EnteredSSN+'&c__EnteredMemberNumber='+EnteredMemberNumber+'&c__CallersPhoneNumber='+PhoneNumber+'&c__PINMatch='+PINMatch+'&c__InteractionId='+IVRGUID+'&c__Reason=' + ReasonCode+ '&c__HighValueFlag=' + HighFlag + '&c__IsUserSessionLoaded=' + IsUserSessionLoaded +'&c__MemberId='+ MemberId);
         RedirectToURL = '/lightning/cmp/c__LightningVerification?c__EnteredSSN='+ EnteredSSN+'&c__EnteredMemberNumber='+EnteredMemberNumber+'&c__CallersPhoneNumber='+PhoneNumber+'&c__PINMatch='+PINMatch+'&c__InteractionId='+IVRGUID+'&c__Reason=' + ReasonCode+ '&c__HighValueFlag=' + HighFlag + '&c__IsUserSessionLoaded=' + IsUserSessionLoaded +'&c__MemberId='+ MemberId;
          
                
        //pageCalulated.setRedirect(true);
       // }
      
       system.debug('EnteredCardNumber##'+ EnteredCardNumber);
        if(EnteredCardNumber != null && EnteredCardNumber !='' ){
        	integer i = EnteredCardNumber.length();            
        	EnteredCardNumberLastdigits = '****_****_****_'+EnteredCardNumber.substring(i-4,i);            
        	Names = vc.getAccountByName(SalesforceID);	
        }
             
        setConfirmationOncheckboxes();
        return pageCalulated;
    }
     
    // method called from member authenticated page (basic authentication)
    public PageReference CheckIfMemberValidated(){   
        
        getQueryStringData();
               
        
        PageReference pageCalulated = null;        
        integer noOfVerifiedFields = 0;
        
               
        if(CONST_TRUE.equalsIgnoreCase(CardNumberMatch) && CONST_TRUE.equalsIgnoreCase(PinMatch)){
         //&& CONST_TRUE.equalsIgnoreCase(pinMatch)
            noOfVerifiedFields = noOfVerifiedFields+1;
        }
        // SSN should not be counted as valid authentication
        if(CONST_TRUE.equalsIgnoreCase(SSNnumberMatch)){
            noOfVerifiedFields = noOfVerifiedFields+1;
        }
        if(CONST_TRUE.equalsIgnoreCase(MemberNumberMatch)){
            noOfVerifiedFields = noOfVerifiedFields+1;
        }  
        //if(noOfVerifiedFields < 3){
        setConfirmationOncheckboxes();
        
        if(EnteredMemberNumber == null || EnteredMemberNumber == '')
        {
            fromMarsData = 'True';
        }
        else
        {
            fromMarsData = 'False';
        }
        
        //pageCalulated = new PageReference('/apex/verifiy');
        
       
        //pageCalulated = new PageReference('/lightning/cmp/c__LightningVerification?c__EnteredSSN='+ EnteredSSN + '&c__SSNnumberMatch='+SSNnumberMatch+ '&c__EnteredMemberNumber='+EnteredMemberNumber+ '&c__MemberNumberMatch='+MemberNumberMatch+ '&c__EnteredCardNumber='+EnteredCardNumber + '&c__CardNumberMatch='+CardNumberMatch+ '&c__CallersPhoneNumber='+PhoneNumber+ '&c__PhoneNumberMatch='+PhoneNumberMatch+ '&c__PINMatch='+PINMatch+'&c__InteractionId='+IVRGUID+'&c__Reason=' + ReasonCode+ '&c__HighValueFlag=' + HighFlag);
        RedirectToURL = '/lightning/cmp/c__LightningVerification?c__EnteredSSN='+ EnteredSSN + '&c__SSNnumberMatch='+SSNnumberMatch+ '&c__EnteredMemberNumber='+EnteredMemberNumber+ '&c__MemberNumberMatch='+MemberNumberMatch+ '&c__EnteredCardNumber='+EnteredCardNumber + '&c__CardNumberMatch='+CardNumberMatch+ '&c__CallersPhoneNumber='+PhoneNumber+ '&c__PhoneNumberMatch='+PhoneNumberMatch+ '&c__PINMatch='+PINMatch+'&c__InteractionId='+IVRGUID+'&c__Reason=' + ReasonCode+ '&c__HighValueFlag=' + HighFlag;
          
                
        //pageCalulated.setRedirect(true);
       // }
      
       system.debug('EnteredCardNumber##'+ EnteredCardNumber);
        if(EnteredCardNumber != null && EnteredCardNumber !='' ){
        	integer i = EnteredCardNumber.length();            
        	EnteredCardNumberLastdigits = '****_****_****_'+EnteredCardNumber.substring(i-4,i);            
        	Names = vc.getAccountByName(SalesforceID);	
        }
             
        setConfirmationOncheckboxes();
        return pageCalulated;
    }
    
    public void setConfirmationOncheckboxes(){
        if(MemberNumberMatch == 'true'){
            MemberNumberConfirm = true;
        }
        if(SSNnumberMatch == 'true'){
            SSNnumberConfirm = false;
            SSNnumberConfirmString = '';
        }
        if(DOBMatch == 'true'){
            DOBConfirm = false;
            DOBConfirmString =  '';
        }
        if(IdNumberMatch == 'true'){
            IdNumberConfirm = false;
            IdNumberConfirmString = '';
        }
        if(DLStateIdPassportMatch == 'true'){
            DLStateIdPassportConfirm = false;
            DLStateIdPassportConfirmString = '';
        }
        if(MMNMatch == 'true'){
            MMNConfirm = false;
            MMNConfirmString = '';
        }

        if(EmailMatch == 'true'){
            EmailConfirm= false;
            EmailConfirmString = '';
        }
        
        if(CardNumberMatch == 'true'){
            CardNumberConfirm = true;
        }
        if(DLStateIdPassportMatch == 'true'){
            DLStateIdPassportConfirm = false;
            DLStateIdPassportConfirmString = '';
        }
       
    }
    
    // basic flow ends
    
    // called to verify selected caller details
    public void verifySelectedCallerDetails(){
        system.debug('inside verify selected caller');
        /*DOB = '';       
        IdNumber = '';      
        MMN = '';       
        EnteredSSN = '';        
        EnteredMemberNumber = '';       
        SSNnumberConfirm = null;        
        DOBMatch = '';    
        MemberNumberMatchStatus = '';
        MultipleMemberNumberAlert = '';
        */      
        showErrorMsgJTmemberTable = false; 
        MemberLoanDetails = new List<Account_Details__c>();   
        List<Account_Details__c> MemberNameDobDetails1 = new List<Account_Details__c>();  
        MemberNameDobDetails = new List<Person_Account__c>();   
        JTMemberNameDobDetails = new List<Person_Account__c>();     
        
        for(Account selectedOne: NameList){
             
             system.debug('---NameList for 1--'+NameList);
            if(selectedOne.ID == selectedID){
            
                JTwrapperLst = new List<JTMemberNameDoBWrapper>();
                system.debug('NameList.selectedOne.ID_1_Number__pc'+selectedOne.ID_1_Number__pc);
                
                // for display
                SalesforceID = selectedID;
                Names = selectedOne;
                firstName = selectedOne.FirstName;
                lastName = selectedOne.LastName;
                
                system.debug('ID.............'+selectedID);
                  
                // get all related account details for selected member
                List<Account_Details__c> memberDetails = new List<Account_Details__c>();
                memberDetails = vc.AccountNumbersAuth(selectedOne.Id); 
                
                // get loan detals
                MemberLoanDetails = vc.MemberLoanDetails(selectedOne.Id);
                
                LoanSelectedID = '';
                for(Account_Details__c detail :MemberLoanDetails)
                {
                    if(LoanSelectedID == '')
                    {
                        LoanSelectedID = LoanSelectedID + detail.id + '# '; 
                    }
                    else
                    {
                        LoanSelectedID = LoanSelectedID + ';' + detail.id + '# ';
                        
                    }
                     
                    
                }
                
                
                // get DOB details for all related members with related accounts   
                
                MemberNameDobDetails1 = vc.MemberDetailsDOB(selectedOne.Id);
                
                if(!MemberNameDobDetails1.isEmpty()){
                    MemberNameDobDetails = vc.MemebersNameDobDetails(MemberNameDobDetails1);
                }
                
                
                // DL/STATE ID/PASSPORT     
                setIDStatus(selectedOne);   
                        
                // create related member details for UI        
                setRelatedMemberDetails(selectedOne);
                
                // set Membermatch status
                setMemberNumberMatchStatus(selectedOne, memberDetails);
                
                
                // set SSN/MMN/DOB Status
                setOtherMatch(selectedOne);
                                
                // Set Card Number Status
               setCardStatus(selectedOne);
               
               // Set Email  Status
               setEmailStatus(selectedOne); 
                
            }
        }
        
        system.debug('flags---'+DOBMatch+'--'+MMNMatch+'--'+SSNnumberMatch+'---'+IdNumberMatch + '----' + CardNumberConfirm  + '-----' + CardNumberMatch);
        
        //setConfirmationOncheckboxes();
    }
    
    
     // called on search on any field
    public pagereference NoIVRInformation(){    
        
        MemberNumberMatchStatus = '';
        MemberNumberMatch = '';
        system.debug('inside verify selected caller');
        system.debug('EnteredCardNumber= '+ EnteredCardNumber);
        system.debug('EnteredCardNumberLastdigits---'+EnteredCardNumberLastdigits);
        system.debug('DLStateIdPassport= '+ DLStateIdPassport);
        if (EnteredCardNumberFormatted != '' && EnteredCardNumberFormatted != null)
        {
            EnteredCardNumber = EnteredCardNumberFormatted;
            System.debug('system1');
        }
        
        // On member selection
        if(selectedID != null && selectedID != ''){
            verifySelectedCallerDetails();
            System.debug('system2');
        }
        else
        { 
            // without member selection
            VerifyCallerDetailsNoSelection();
            System.debug('system3');
        }
       
       return null;
    }    
    
    
    // verify details without selected member
    private void verifyCallerDetailsNoSelection()
    {
        system.debug('in else');
                    String fieldnametocheck = '';
                    verificationObject userEnteredInformation = new verificationObject();
                    system.debug(fieldnametocheck);
                    //if(PhoneNumberMatch == 'true'){
                        //userEnteredInformation.phoneNumber = PhoneNumber;
                    //}  
                    system.debug('EnteredMemberNumber--'+EnteredMemberNumber); 
                     
                    
                    if(MemberNumberMatch == 'true' || fieldnametocheck == 'MemberNumber'){
                        if(EnteredMemberNumber == null || EnteredMemberNumber == ''){ 
                            MemberNumberMatch = ''; 
                        }
                        EnteredMemberNumber = FormatMemberNumber(EnteredMemberNumber);
                        userEnteredInformation.memberNumber = EnteredMemberNumber;
                    }
                    else
                    {
                        if((MemberNumberMatch == null || MemberNumberMatch == '') && (EnteredMemberNumber != null && EnteredMemberNumber != '')){
                            EnteredMemberNumber = FormatMemberNumber(EnteredMemberNumber);
                            userEnteredInformation.memberNumber = EnteredMemberNumber;
                            fieldnametocheck = 'memberNumber';
                            system.debug('fieldnametocheck = memberNumber');
                        }else if(EnteredMemberNumber == null || EnteredMemberNumber == ''){
                            MemberNumberMatch = '';
                        }
                    }
                    if(!string.isEmpty(EnteredMemberNumber)){
                        string finalstring;
                            finalstring = EnteredMemberNumber;
                            if(EnteredMemberNumber.length() <10)
                            {
                                for(Integer i=0;i<10-EnteredMemberNumber.length();i++)
                                {
                                    finalstring = '0'+finalstring;
                                    system.debug('EnteredMemberNumber--'+EnteredMemberNumber);
                                }                                   
                            }       
                            system.debug('finalstring--'+finalstring);              
                            system.debug('fieldnametocheck = memberNumber');
                            
                            EnteredMemberNumber = finalstring;
                            userEnteredInformation.memberNumber = EnteredMemberNumber;
                            fieldnametocheck = 'memberNumber';      
                                                        
                                                                                                              
                        
                    }
                                                      
                    if(SSNnumberMatch == 'true'){
                    	if(EnteredSSN == null || EnteredSSN == ''){
                        	SSNnumberMatch = '';
                        }
                        userEnteredInformation.SSN = EnteredSSN;
                    }else{
                    	System.debug('SSNnumberMatch'+SSNnumberMatch);
                    	System.debug('EnteredSSN'+EnteredSSN);
                        if((SSNnumberMatch == null || SSNnumberMatch == '') && (EnteredSSN != null && EnteredSSN != '')){
                            userEnteredInformation.SSN = EnteredSSN;
                            System.debug('EnteredSSN'+EnteredSSN);
                            fieldnametocheck = 'SSNNumber';
                            system.debug('fieldnametocheck = SSNNumber');
                        }else if(EnteredSSN == null || EnteredSSN == ''){
                            SSNnumberMatch = '';
                        }
                    }
                    system.debug('CardNumberMatch--'+CardNumberMatch);
                    if(CardNumberMatch == 'true'){
                        if(EnteredCardNumber == null || EnteredCardNumber == ''){CardNumberMatch = '';}
                        userEnteredInformation.CardNumber = EnteredCardNumber;
                    }else{
                        system.debug('No true card number');
                        if((CardNumberMatch == null || CardNumberMatch == '') && (EnteredCardNumber != null && EnteredCardNumber != '')){
                            
                            userEnteredInformation.CardNumber = EnteredCardNumber;
                            fieldnametocheck = 'CardNumber';
                            system.debug('EnteredCardNumber--'+EnteredCardNumber);
                            system.debug('Fieldname to check'+'fieldnametocheck = CardNumber');
                        }
                        else if(EnteredCardNumber == null || EnteredCardNumber == ''){
                            //CardNumberMatch = '';
                        }
                        
                    }
                    
                    if((CardNumberMatch == null || CardNumberMatch == '') && EnteredCardNumberLastdigits != EnteredCardNumber && !string.isEmpty(EnteredCardNumberLastdigits)){
                         system.debug('EnteredCardNumber--'+EnteredCardNumber);
                         userEnteredInformation.CardNumber = EnteredCardNumberLastdigits;
                         fieldnametocheck = 'CardNumber';
                    }
                    
                    System.debug('DOBMatch-if'+DOBMatch);
                    if(DOBMatch == 'true'){ 
                        if(DOB == null || DOB == '')
                        {DOBMatch = '';}       
                         String[] dobparse = DOB.split('-');
                         userEnteredInformation.DOB = string.ValueOf(dobparse[2]) + '-'+ String.valueOf(dobparse[0])+ '-' + String.valueOf(dobparse[1]);	
                    	 System.debug('DOB---if'+DOB);
                    }else{
                            if(DOB !=null && DOB != ''){   
                            String[] dobparse = DOB.split('-');
                           	userEnteredInformation.DOB = string.ValueOf(dobparse[2]) + '-'+ String.valueOf(dobparse[0])+ '-' + String.valueOf(dobparse[1]);	             
                            //userEnteredInformation.DOB = DOB;
                            System.debug('DOB---else'+DOB);
                            fieldnametocheck = 'DOB';
                            }else if(DOB == null || DOB == ''){
                                DOBMatch = '';
                            }
                    }
                    if(PhoneNumberMatch == 'true'){ 
                        if(PhoneNumber == null || PhoneNumber == ''){PhoneNumberMatch = '';}               
                        	userEnteredInformation.PhoneNumber = PhoneNumber;
                    }else{
                            if(PhoneNumber !=null && PhoneNumber != '' && (PhoneNumberMatch == null ||PhoneNumberMatch == '')){   
                            //String[] dobparse = DOB.split('-');
                           	userEnteredInformation.PhoneNumber = PhoneNumber;	             
                            //userEnteredInformation.DOB = DOB;
                            System.debug('PhoneNumber'+PhoneNumber);
                            fieldnametocheck = 'PhoneNumber';
                            }else if(PhoneNumber == null || PhoneNumber == ''){
                                PhoneNumberMatch = '';
                            }
                    }
                    if(DLStateIdPassportMatch == 'true'){
                        if(DLStateIdPassport == null || DLStateIdPassport == ''){DLStateIdPassportMatch = '';}     
                        userEnteredInformation.ICardNumber = DLStateIdPassport;
                    }else{
                        if(DLStateIdPassport!=null && DLStateIdPassport != '' && (DLStateIdPassportMatch == null || DLStateIdPassportMatch == '')){
                            userEnteredInformation.ICardNumber = DLStateIdPassport;
                            fieldnametocheck = 'DLStateIdPassport';
                        }else if(DLStateIdPassport == null || DLStateIdPassport == ''){
                            DLStateIdPassport = '';
                        }
                    }
                    /*if(IdNumberMatch == 'true'){
                        if(IdNumber == null || IdNumber == ''){IdNumberMatch = '';}     
                        userEnteredInformation.ICardNumber = IdNumber;
                    }else{
                        if(IdNumber!=null && IdNumber != '' && (IdNumberMatch == null || IdNumberMatch == '')){
                            userEnteredInformation.ICardNumber = IdNumber;
                            fieldnametocheck = 'IdNumber';
                        }else if(IdNumber == null || IdNumber == ''){
                            IdNumberMatch = '';
                        }
                    } */
                    if(MMNMatch == 'true'){
                        if(MMN == null || MMN == ''){MMNMatch = '';} 
                        userEnteredInformation.MMN = MMN;
                    }else{
                        if(MMN !=null && MMN != '' && (MMNMatch == null || MMNMatch == '')){
                            userEnteredInformation.MMN = MMN;
                            fieldnametocheck = 'MMN';
                        }else if(MMN == null || MMN == ''){
                            MMNMatch = '';
                        }
                    }
                    //Krunal
                    if(EmailMatch == 'true'){
                        if(Email == null || Email== ''){EmailMatch = '';LstEmail = new List<SelectOption>(); } 
                        userEnteredInformation.Email = Email;
                    }else{
                        if(Email !=null && Email != '' && (EmailMatch == null || EmailMatch == '')){
                            userEnteredInformation.Email = Email;
                            fieldnametocheck = 'Email';
                        }else if(Email == null || Email == ''){
                            EmailMatch = '';
                        }
                    }
                    system.debug('EnteredCardNumber---'+EnteredCardNumber);
                    system.debug('EnteredCardNumber---'+EnteredCardNumber);
                    String exceptionPoint = '';
                    list<Account> NameListTemp = new List<Account>();  
                    try{
                        if(fieldnametocheck == '' && oldFieldToMatch != ''){
                            if(oldFieldToMatch == 'CardNumber'){   
                                system.debug('oldFieldToMatch ---'+oldFieldToMatch );                 
                                userEnteredInformation.CardNumber = EnteredCardNumber;
                                system.debug('EnteredCardNumber---'+EnteredCardNumber);
                                fieldnametocheck = oldFieldToMatch;
                            }
                             system.debug('EnteredCardNumber---'+EnteredCardNumber);
                            if(oldFieldToMatch == 'SSNNumber'){
                                userEnteredInformation.SSN = EnteredSSN;
                                fieldnametocheck = oldFieldToMatch;
                            }
                            if(oldFieldToMatch == 'memberNumber'){
                                userEnteredInformation.memberNumber = EnteredMemberNumber;
                                fieldnametocheck = oldFieldToMatch;
                            }
                            if(oldFieldToMatch == 'DOB'){
                                userEnteredInformation.DOB = DOB;
                                fieldnametocheck = oldFieldToMatch;
                            }
                            if(oldFieldToMatch == 'PhoneNumber'){
                                userEnteredInformation.PhoneNumber = PhoneNumber;
                                fieldnametocheck = oldFieldToMatch;
                            }
                            if(oldFieldToMatch == 'IdNumber'){
                                userEnteredInformation.ICardNumber = IdNumber;
                                fieldnametocheck = oldFieldToMatch;
                            }
                            if(oldFieldToMatch == 'DLStateIdPassport'){
                                userEnteredInformation.ICardNumber = DLStateIdPassport;
                                fieldnametocheck = oldFieldToMatch;
                            }
                            if(oldFieldToMatch == 'MMN'){
                                userEnteredInformation.MMN = MMN;
                                fieldnametocheck = oldFieldToMatch;
                            }
                            if(oldFieldToMatch == 'Email'){
                                userEnteredInformation.Email= Email;
                                fieldnametocheck = oldFieldToMatch;
                            }                    
                        }else{
                            userEnteredInformation.fieldnametocheck = fieldnametocheck;    
                        }  
                        system.debug('userEnteredInformation---'+userEnteredInformation);          
                        NameList = vc.queryByParametersAvailable(userEnteredInformation, false);        
                        system.debug('NameList myyyyy'+NameList);        
                        oldFieldToMatch = fieldnametocheck;
                        //--------checks();
                        system.debug(fieldnametocheck);
                        system.debug('NameList size'+NameList.size());
                        system.debug('NameList'+NameList);
                        
                        // verify if member number is valid
                        if (userEnteredInformation.memberNumber != '' && userEnteredInformation.memberNumber != null)
                        {
                            boolean memberNumberValidated = vc.validateMemberNumber(userEnteredInformation.memberNumber);
                            if (memberNumberValidated == true)
                            {
                                MemberNumberMatchStatus = 'Valid';
                                MemberNumberMatch = 'true';
                            }
                            else
                            {
                                MemberNumberMatchStatus = 'No Match Found';
                                MemberNumberMatch = 'false';
                            }
                        }
                        else
                        {
                            MemberNumberMatchStatus = '';
                            MemberNumberMatch = '';
                        }
                        system.debug(MemberNumberMatch);
                        system.debug(MemberNumberMatchStatus);
                        if(NameList.size()>0){
                            
                            system.debug('NameList size.....'+NameList.size());                    
                            if(fieldnametocheck == 'CardNumber'){
                                if(EnteredCardNumber != ''){  
                                                              
                                   // CardNumberMatch = 'true';
                                    
                                }
                                if(!string.isEmpty(EnteredCardNumberLastdigits)){
                                    system.debug('EnteredCardNumberLastdigits---'+EnteredCardNumberLastdigits);
                                    
                                    
                                }
                                fieldnametocheck = '';
                            }
                            if(fieldnametocheck == 'SSNNumber'){
                                if(EnteredSSN != ''){
                                    SSNnumberMatch = 'true';
                                }
                                
                                fieldnametocheck = '';
                            }
                            if(fieldnametocheck == 'memberNumber'){
                                if(EnteredMemberNumber != ''){                            
                                    MemberNumberMatch = 'true';
                                }
                                fieldnametocheck = '';
                            }
                            if(fieldnametocheck == 'DOB'){
                                if(DOB != ''){
                                    DOBMatch = 'true';
                                }
                                fieldnametocheck = '';
                            }
                            if(fieldnametocheck == 'IdNumber'){
                                if(IdNumber != ''){
                                    IdNumberMatch = 'true';
                                }                        
                                fieldnametocheck = '';
                            }
                            if(fieldnametocheck == 'DLStateIdPassport'){
                                if(DLStateIdPassport != ''){
                                    DLStateIdPassportMatch = 'true';
                                }                        
                                fieldnametocheck = '';
                            }
                            if(fieldnametocheck == 'MMN'){
                                if(MMN != ''){
                                    MMNMatch = 'true';
                                }
                                fieldnametocheck = '';
                            }
                            if(fieldnametocheck == 'Email'){
                                if(Email != ''){
                                    EmailMatch = 'true';
                                }
                                fieldnametocheck = '';
                            }
                        }
                        else{
                            system.debug(NameList);
                            NameList = null;
                            /*if(fieldnametocheck == 'CardNumber'){
                                if(EnteredCardNumber != ''){ 
                                    CardNumberMatch = 'false';
                                }else{ 
                                    CardNumberMatch = '';
                                }
                                fieldnametocheck = '';
                            }*/
                            if(fieldnametocheck == 'SSNNumber'){
                                if(EnteredSSN != ''){ 
                                    SSNnumberMatch = 'false';
                                }else{ 
                                    SSNnumberMatch = '';
                                }
                                fieldnametocheck = '';
                            }
                            if(fieldnametocheck == 'memberNumber'){
                                if(EnteredMemberNumber != ''){                            
                                   // MemberNumberMatch = 'false';
                                }else{
                                   // MemberNumberMatch = '';
                                }
                                fieldnametocheck = '';
                            }
                            if(fieldnametocheck == 'DOB'){
                                if(DOB != ''){
                                    DOBMatch = 'false';
                                }else{
                                    DOBMatch = '';                            
                                }
                                fieldnametocheck = '';
                            }
                            if(fieldnametocheck == 'IdNumber'){
                                if(IdNumber != ''){
                                    IdNumberMatch = 'false';
                                }else{
                                    IdNumberMatch = '';
                                }
                                fieldnametocheck = '';
                            }
                            if(fieldnametocheck == 'DLStateIdPassport'){
                                if(DLStateIdPassport != ''){
                                    DLStateIdPassportMatch = 'false';
                                }else{
                                    DLStateIdPassportMatch = '';
                                }
                                fieldnametocheck = '';
                            }
                            if(fieldnametocheck == 'MMN'){
                                if(MMN != ''){
                                    MMNMatch = 'true';
                                }else{
                                    MMNMatch = '';
                                }
                                fieldnametocheck = '';
                            }
                            if(fieldnametocheck == 'Email'){
                                if(Email != ''){
                                    EmailMatch = 'true';
                                }else{
                                    EmailMatch = '';
                                }
                                fieldnametocheck = '';
                            }
                            
                        } 
                        
                       
                        if(PhoneNumberMatch == 'true'){
                            userEnteredInformation.phoneNumber = PhoneNumber;     
                            userEnteredInformation.fieldnametocheck = '';               
                            NameList = vc.queryByParametersAvailable(userEnteredInformation, false);
                        }
                        setConfirmationOncheckboxes();
                        
                        
                    }
                
            catch(exception e){
                    NameList = null;
            }
    
    }
    
    private void setCardStatus(Account selectedOne)
    {
        
        /*
         if(EnteredCardNumber != null && EnteredCardNumber != '' && EnteredCardNumber.length() > 4)
                {
                    //CardNumberMatch = 'false';
                    system.debug('Inside Card Number verfiy');
                    List<Account_Details__c> cardDetails = new List<Account_Details__c>();
                    cardDetails = vc.CardNumbersAuth(selectedOne.Id);
                    for(Account_Details__c pc : cardDetails)
                    {
                        if(EnteredCardNumber == pc.Card_Number__c){
                      //      CardNumberMatch = 'true';
                            if (IVRCardNumberMatch == 'true')
                            {
                                //CardNumberConfirm = true;
                                //system.debug('Setting CardNumber confirm to true');
                                //break;
                            }
                        }
                    }
                }
                else
                {
                  //  CardNumberMatch = null;
                    
                    if(EnteredCardNumberLastdigits != null && EnteredCardNumberLastdigits != '' && EnteredCardNumber.length() == 4)
                    {
                        CardNumberMatch = 'false';
                        system.debug('Inside Card Number verfiy 2');
                        List<Account_Details__c> cardDetails = new List<Account_Details__c>();
                        cardDetails = vc.CardNumbersAuth(selectedOne.Id);
                        for(Account_Details__c pc : cardDetails)
                        {
                            system.debug('LAst 4 diggits 2 :' + pc.Card_Number_Last_4_Digits__c);
                            if(EnteredCardNumberLastdigits == pc.Card_Number_Last_4_Digits__c){
                                CardNumberMatch = 'true';
                                if (IVRCardNumberMatch == 'true')
                                {
                                    CardNumberConfirm = true;
                                    system.debug('Setting CardNumber confirm to true');
                                    //break;
                                }
                            }
                        }
                    }
                    else 
                    {
                        
                        //CardNumberMatch = null;
                        
                    }
                }
                
                */
    }
    private void setOtherMatch(Account selectedOne)
    {
        // Set SSN number status
                
                if (ClearAllFlag == true)
                {
                    if (selectedOne.SSN_Last_4__pc == null || selectedOne.SSN_Last_4__pc == '')
                    {
                        EnteredSSN = '';
                        SSNNumberMatch = '';
                    }
                    else
                    {
                        EnteredSSN = selectedOne.SSN_Last_4__pc;
                        SSNnumberMatch = 'true';
                        System.debug('SSNRJ' + EnteredSSN);
                    }
                    
                    
                }
                else
                {
                    if (selectedOne.SSN_Last_4__pc == null || selectedOne.SSN_Last_4__pc == '')
                    {
                        EnteredSSN = '';
                        SSNNumberMatch = '';
                    }
                    else
                    {
                        EnteredSSN = selectedOne.SSN_Last_4__pc;
                        SSNnumberMatch = 'true';
                        System.debug('SSNRJ1' + EnteredSSN);
                    }
                    /*
                    // if information recieved from IVR - keep same
                    if (IVREnteredSSN != null && IVREnteredSSN != '')
                    {
                        EnteredSSN = IVREnteredSSN;
                        SSNnumberMatch =  IVRSSNnumberMatch;
                        if (IVRSSNnumberMatch == 'true')
                        {
                            SSNnumberConfirm = true;
                        }
                    }
                    else
                    {
                        if (selectedOne.SSN_Last_4__pc == null || selectedOne.SSN_Last_4__pc == '')
                        {
                            EnteredSSN = '';
                            SSNNumberMatch = '';
                        }
                        else
                        {
                            EnteredSSN = selectedOne.SSN_Last_4__pc;
                            SSNnumberMatch = 'true';
                        }
                        
                    }
                    */
                }
                
                
                // Set DOB status
                if (ClearAllFlag == true)
                {
                    if (selectedOne.BIRTH_DATE__pc == null )
                    {
                        DOB = '';
                        DOBMatch = '';
                    }
                    else
                    {
                        Dob = DateTime.newInstance(selectedOne.BIRTH_DATE__pc.year(),selectedOne.BIRTH_DATE__pc.month(),selectedOne.BIRTH_DATE__pc.day()).format('MM-dd-YYYY');
                        //DOB = String.valueof(selectedOne.BIRTH_DATE__pc);
                        DOBMatch = 'true';
                    }
                    
                }
                else
                {
                    if (selectedOne.BIRTH_DATE__pc == null )
                    {
                        DOB = '';
                        DOBMatch = '';
                    }
                    else
                    {
                        //DOB = String.valueof(selectedOne.BIRTH_DATE__pc);
                        Dob = DateTime.newInstance(selectedOne.BIRTH_DATE__pc.year(),selectedOne.BIRTH_DATE__pc.month(),selectedOne.BIRTH_DATE__pc.day()).format('MM-dd-YYYY');
                        DOBMatch = 'true';
                    }
                    /*
                    // if information recieved from IVR - keep same
                    if (IVRDOB != null && IVRDOB != '')
                    {
                        DOB = IVRDOB;
                        DOBMatch =  IVRDOBMatch;
                        if (IVRDOBMatch == 'true')
                        {
                            DOBConfirm = true;
                        }
                    }
                    else
                    {
                        if (selectedOne.BIRTH_DATE__pc == null )
                        {
                            DOB = '';
                            DOBMatch = '';
                        }
                        else
                        {
                            DOB = String.valueof(selectedOne.BIRTH_DATE__pc);
                            DOBMatch = 'true';
                        }
                        
                    }*/
                    
                }
             
                
                // Set MMN status
                
                 if (ClearAllFlag == true)
                {
                    if (selectedOne.Mothers_Maiden_Name__pc == null || selectedOne.Mothers_Maiden_Name__pc == '')
                    {
                        MMN = '';
                        MMNMatch = '';
                    }
                    else
                    {
                        MMN = selectedOne.Mothers_Maiden_Name__pc;
                        MMNMatch = 'true';
                    }
                    
                    
                }
                else
                {
                    if (selectedOne.Mothers_Maiden_Name__pc == null || selectedOne.Mothers_Maiden_Name__pc == '')
                    {
                        MMN = '';
                        MMNMatch = '';
                    }
                    else
                    {
                        MMN = selectedOne.Mothers_Maiden_Name__pc;
                        MMNMatch = 'true';
                    }
                    
                    
                }
                
    }
    
    private void setEmailStatus(Account selectedOne)
    {
                        //Set Email Status
                 if (ClearAllFlag == true)
                {
                    if (selectedOne.PersonEmail == null || selectedOne.PersonEmail == '')
                    {
                        Email = '';
                        LstEmail = new List<SelectOption>();
                        EmailMatch = '';
                    }
                    else
                    {
                        Email = selectedOne.PersonEmail;
                        GetEmailLst(selectedOne.id);
                        EmailMatch = 'true';
                    }
                    
                    
                }
                else
                {
                    if (selectedOne.PersonEmail == null || selectedOne.PersonEmail == '')
                    {
                        Email = '';
                        LstEmail = new List<SelectOption>();
                        EmailMatch = '';
                    }
                    else
                    {
                        Email = selectedOne.PersonEmail;                        
                        GetEmailLst(selectedOne.id);
                        EmailMatch = 'true';
                    }
                    
                    
                }
                
        
    }
    public void GetEmailLst(string accountid){
        LstEmail = new List<SelectOption>();
        MemberVerification mv = new MemberVerification();
        mv.accId = accountid;
        mv.GetRelatedAccountsPopulated();
        List<string> acclstid = mv.allRelatedAccounts;
        List<Account> listAccount = [select Id,Member_Verification_OTP_Invalid_Attempt__c,FirstName,LastName,PersonEmail,Alternate_Email__pc from Account where ID in :acclstid and (PersonEmail != null OR Alternate_Email__pc != null)];
        List<accounthistory> listhistory = [Select accountid,field,OldValue, NewValue, CreatedDate From accounthistory where accountid in :acclstid and ( field = 'PersonEmail' or field = 'Alternate_Email__pc') Order by CreatedDate DESC Limit 1];
  		set<string> listContacts = new set<string>();
        boolean flag = false;
            for(Account acc:listAccount){
                for(accounthistory ah : listhistory ){
                    if(acc.id == ah.accountid && ah.field == 'PersonEmail' && acc.PersonEmail !=null){
                        LstEmail.add(new SelectOption(acc.PersonEmail,acc.PersonEmail, false)); 
                        Email = acc.PersonEmail;
                        flag = true;
                    }
                    if(acc.id == ah.accountid && ah.field == 'Alternate_Email__pc' && acc.Alternate_Email__pc !=null){
                        LstEmail.add(new SelectOption(acc.Alternate_Email__pc,acc.Alternate_Email__pc, false));  
                        Email = acc.Alternate_Email__pc;
                        flag = true;
                    }
                }
            }
        if(flag){
            for(Account acc:listAccount){
                	if(Email != acc.PersonEmail && acc.PersonEmail != null && acc.PersonEmail != ''){
                            LstEmail.add(new SelectOption(acc.PersonEmail,acc.PersonEmail, false));    
                        }
                        if(Email != acc.Alternate_Email__pc && acc.Alternate_Email__pc != null && acc.Alternate_Email__pc != ''){
                            LstEmail.add(new SelectOption(acc.Alternate_Email__pc,acc.Alternate_Email__pc, false));    
                        }  
                    }
        }
        else{
             for(Account acc:listAccount){              
                     if(acc.PersonEmail != null && acc.PersonEmail != ''){
                            LstEmail.add(new SelectOption(acc.PersonEmail,acc.PersonEmail, false));    
                        }
                        if( acc.Alternate_Email__pc != null && acc.Alternate_Email__pc != ''){
                            LstEmail.add(new SelectOption(acc.Alternate_Email__pc,acc.Alternate_Email__pc, false));    
                        }  
            }
            
        }
                
    }
   
    private void setMemberNumberMatchStatus(Account selectedOne, List<Account_Details__c> memberDetails)
    {
        Set<String> memberDetailsNames = new Set<String>();
        // CLEAR ALL FLAG
        if (clearAllFlag == true)
        {
                
                // SEARCH BASED ON other fields than member number  
                if(EnteredMemberNumber == null || EnteredMemberNumber == '')
                {
                     
                    MemberNumberMatch = null;
                    for(Account_Details__c acctD : memberDetails)
                    {
                        memberDetailsNames.add(acctD.Name); 
                        System.Debug(acctD);                       
                    }
                    system.debug('memberDetails.size()....'+memberDetails.size());
                    system.debug('memberDetailsNames....'+memberDetailsNames.size());                               
                    
                    integer i = memberDetailsNames.size();
                    
                    if(i == 1)
                    { 
                        MemberNumberMatchStatus = 'Verified';
                        EnteredMemberNumber = memberDetails[0].Name;
                    }
                    else if (i > 1)
                    {
                        EnteredMemberNumber = memberDetails[0].Name;
                        MemberNumberMatchStatus = 'Verified';
                        MultipleMemberNumberAlert = 'This person is related to more than one member number';    
                    }
                    else if(i == 0)
                    {
                        MemberNumberMatchStatus = '';
                        MultipleMemberNumberAlert = 'This person is not related to any member number';
                    }
                                    
                }
                else
                {
                    // SEARCH BASED ON member number
                    
                    MultipleMemberNumberAlert = '';
                    //MemberNumberMatchStatus = '';
                    MemberNumberMatch = 'false';
                    EnteredMemberNumber = FormatMemberNumber(EnteredMemberNumber);
                    
                    for(Account_Details__c pc : memberDetails){
                        memberDetailsNames.add(pc.Name); 
                        if(EnteredMemberNumber == pc.Name){
                            MemberNumberMatch = 'true';
                            
                        }
                    }
                    
                    integer i = memberDetailsNames.size();
                    
                    if(i == 1)
                    { 
                        MemberNumberMatchStatus = 'Verified';
                        //EnteredMemberNumber = memberDetails[0].Name;
                    }
                    else if (i > 1)
                    {
                        //EnteredMemberNumber = memberDetails[0].Name;
                        MemberNumberMatchStatus = 'Verified';
                        MultipleMemberNumberAlert = 'This person is related to more than one member number';    
                    }
                    else if(i == 0)
                    {
                        MemberNumberMatchStatus = '';
                        MultipleMemberNumberAlert = 'This person is not related to any member number';
                    }
                                        
                }
            
        }
        else
        { // Information from IVR (not clear all)
                System.debug(EnteredMemberNumber);
                if(EnteredMemberNumber == null || EnteredMemberNumber == '')
                { 
                    MemberNumberMatch = null;        
                    for(Account_Details__c acctD : memberDetails){
                        memberDetailsNames.add(acctD.Name); 
                        System.Debug(acctD);                       
                    }
                    system.debug('memberDetails.size()....'+memberDetails.size());
                    system.debug('memberDetailsNames....'+memberDetailsNames.size());                               
                    
                    integer i = memberDetailsNames.size();
                    if(i == 1){
                        MultipleMemberNumberAlert = '';
                        EnteredMemberNumber = memberDetails[0].Name;
                        MemberNumberMatch = 'true';  
                        if (selectedOne.SSN_Last_4__pc != null && selectedOne.SSN_Last_4__pc != '')
                        {
                            MemberNumberMatchStatus = 'Verified';
                        }
                        else
                        {
                            MemberNumberMatchStatus = 'Verified';
                        }
                    }
                    else if(i > 1)
                    { 
                                                
                        EnteredMemberNumber = memberDetails[0].Name;
                        MemberNumberMatchStatus = 'Verified';
                        MultipleMemberNumberAlert = 'This person is related to more than one member number';
                    }
                    else if(i == 0)
                    {
                        
                        MemberNumberMatchStatus = '';
                        MultipleMemberNumberAlert = 'This person is not related to any member number';
                    }
                                    
                }
                else
                {
                    boolean found = false;
                    MultipleMemberNumberAlert = '';
                    MemberNumberMatchStatus = 'Verified';
                    //MemberNumberMatch = 'false';
                    EnteredMemberNumber = FormatMemberNumber(EnteredMemberNumber);
                    
                    for(Account_Details__c pc : memberDetails){
                         memberDetailsNames.add(pc.Name); 
                        if(FormatMemberNumber(IVREnteredMemberNumber) == pc.Name){
                            //MemberNumberMatch = 'true';
                           found = true;
                        }
                    }
                    
                    // when member number is not same as entered by IVR- member selected matched phone number entered
                    if (memberDetailsNames.size() > 0)
                    {
                        EnteredMemberNumber = memberDetails[0].Name;
                        MemberNumberMatch = 'true';
                    }
                    
                    integer i = memberDetailsNames.size();
                    system.debug(memberDetailsNames);
                    if(i == 1){
                        MultipleMemberNumberAlert = '';
                        if (selectedOne.SSN_Last_4__pc != null && selectedOne.SSN_Last_4__pc != '' && found == true)
                        {
                            MemberNumberMatchStatus = 'Verified';
                        }
                        else
                        {
                            MemberNumberMatchStatus = 'Verified';
                        }
                        
                        if (EnteredMemberNumber != FormatMemberNumber(IVREnteredMemberNumber))
                        {
                            MemberNumberMatchStatus = 'Valid';
                        }
                    }
                    else if(i > 1)
                    { 
                        // mima-67
                        for (string mid : memberDetailsNames)
                        {
                            if (mid == IVREnteredMemberNumber)
                            {
                                EnteredMemberNumber = FormatMemberNumber(IVREnteredMemberNumber);
                            }
                        }
                        MemberNumberMatchStatus = 'Verified';
                        MultipleMemberNumberAlert = 'This person is related to more than one member number';
                        
                        if (!found)
                        {
                            MemberNumberMatchStatus = 'Valid';
                        }
                    }
                    else if (i == 0)
                    {
                        //EnteredMemberNumber = '';
                        MemberNumberMatchStatus = '';
                    }
                    
                    
                                        
                }
        }
        
        // Get member number detail and set member match status
            
    }
    private void setRelatedMemberDetails(Account selectedOne)
    {
        if(!MemberNameDobDetails.isEmpty())
        {                        
                          
                   string Thisvalue = 'Primary';        
                   Set<id> personId = new Set<id>(); 
                   set<id> personId1 = new Set<id>();        
                        
                   uniqueMembersDetail = new Map <id,Person_Account__c>();      
                   for(Person_Account__c mem : MemberNameDobDetails){  
                        
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
                                       JTMemberNameDobDetails.add(mem);
                                    }             
                               }                                                                
                           }        
                      }     
            
                   }    
                          
                           JTSelectedID = '';
                   if(!JTMemberNameDobDetails.isEmpty()){ 
                        JTMemberNameDoBWrapper JTW;
                        system.debug('Not null');
                        for(Person_Account__c pc : JTMemberNameDobDetails){ 
                            JTW = new JTMemberNameDoBWrapper();
                            JTW.Jtname  = pc.PersonID__r.Name;
                            JTW.DT  = pc.PersonID__r.BIRTH_DATE__pc ;
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
                                                                                                                                
                       ShowJTMembertables = true;       
                            
                   }        
                   else{        
                       ShowJTMembertables = false;      
                       showErrorMsgJTmemberTable = true;        
                   }        
                            
                   system.debug('uniqueMembersDetail---'+uniqueMembersDetail);                      
                   system.debug('ShowJTMembertables ---'+ShowJTMembertables);   
                   system.debug('JTMemberNameDobDetails'+JTMemberNameDobDetails);    
                                         
                        
                }
    }
    private void setIDStatus(Account selectedOne)
    {
        
            /*if(!string.isEmpty(selectedOne.ID_1_Number__pc))
            {
                IdNumber = selectedOne.ID_1_Number__pc;
            }
            if(!string.isEmpty(selectedOne.ID_2_Number__pc)){
                
                if (string.isEmpty(IDNumber))
                {
                    IdNumber = selectedOne.ID_2_Number__pc;
                }
                else
                {
                    IdNumber += ', ' + selectedOne.ID_2_Number__pc;
                }
            } 
            if(!string.isEmpty(selectedOne.ID_3_Number__pc)){
                
                if (string.isEmpty(IDNumber))
                {
                    IdNumber = selectedOne.ID_3_Number__pc;
                }
                else
                {
                    IdNumber += ', ' + selectedOne.ID_3_Number__pc;
                }
                
            }*/
            
            string IDNumberToMatch = '';
           /* IDNumberToMatch = string.isEmpty(selectedOne.ID_1_Number__pc) ? '' : selectedOne.ID_1_Number__pc;
            if (string.isempty(IDNumberToMatch))
            {
            IDNumberToMatch += string.isEmpty(selectedOne.ID_2_Number__pc) ? '' : selectedOne.ID_2_Number__pc;
            }
            else
            {
             IDNumberToMatch += string.isEmpty(selectedOne.ID_2_Number__pc) ? '' : ', ' + selectedOne.ID_2_Number__pc;
            }
            if (string.isempty(IDNumberToMatch))
            {
            IDNumberToMatch += string.isEmpty(selectedOne.ID_3_Number__pc) ? '' : selectedOne.ID_3_Number__pc;
            }
            else
            {
             IDNumberToMatch += string.isEmpty(selectedOne.ID_3_Number__pc) ? '' : ', ' + selectedOne.ID_3_Number__pc;
            }*/
          //  string IDTypeToMatch = '';
            string DLStateIdPassportToMatch='';
          /*  if(selectedOne.ID_1_Type__c != null){
                DLStateIdPassportToMatch = selectedOne.ID_1_Type__c + ' ' + (selectedOne.ID_1_Number__pc == null? '' : string.valueof(selectedOne.ID_1_Number__pc)) + ' ' + (selectedOne.ID_1_Expiration_Date__pc == null? '' : string.valueof(selectedOne.ID_1_Expiration_Date__pc));              
            }
            if(selectedOne.ID_2_Type__c != null){
                DLStateIdPassportToMatch = DLStateIdPassportToMatch + ', ' + (selectedOne.ID_2_Type__c + ' ' + (selectedOne.ID_2_Number__pc == null? '' : string.valueof(selectedOne.ID_2_Number__pc)) + ' ' + (selectedOne.ID_2_Expiration_Date__pc == null? '' : string.valueof(selectedOne.ID_2_Expiration_Date__pc)));              
            }
            if(selectedOne.ID_3_Type__c != null){
                DLStateIdPassportToMatch = DLStateIdPassportToMatch + ', ' + (selectedOne.ID_3_Type__c + ' ' + (selectedOne.ID_3_Number__pc == null? '' : string.valueof(selectedOne.ID_3_Number__pc)) + ' ' + (selectedOne.ID_3_Expiration_Date__pc == null? '' : string.valueof(selectedOne.ID_3_Expiration_Date__pc)));              
            }*/
           
            //IDTypeToMatch = string.isEmpty(selectedOne.ID_1_Type__pc) ? (string.isEmpty(selectedOne.ID_2_Type__pc) ? selectedOne.ID_3_Type__pc : selectedOne.ID_2_Type__pc) :selectedOne.ID_1_Type__pc ;
            if(string.isEmpty(DLStateIdPassport)){
            	system.debug('test');
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
                        
                        DLStateIdPassportToMatch = ((ID_1_Type == '' || ID_1_Type == null) ? '' : string.valueof(ID_1_Type) + ' | ') + selectedOne.ID_2_Description__pc	 + '' + (selectedOne.ID_2_Number__pc == null? '' : string.valueof(selectedOne.ID_2_Number__pc)+ ' | ') + '' + (selectedOne.ID_2_Expiration_Date__pc == null? '' : string.valueof(selectedOne.ID_2_Expiration_Date__pc.date()));
                        
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
                        
                        DLStateIdPassportToMatch = ((ID_1_Type == '' || ID_1_Type == null) ? '' : string.valueof(ID_1_Type) + ' | ') + selectedOne.ID_3_Description__pc	 + '' + (selectedOne.ID_3_Number__pc == null? '' : string.valueOf(selectedOne.ID_3_Number__pc) +' | ') + '' + (selectedOne.ID_3_Expiration_Date__pc == null? '' : string.valueof(selectedOne.ID_3_Expiration_Date__pc.date()));
                        
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
            }
            else
            {
                if(selectedOne.ID_1_Number__pc == DLStateIdPassport)
                {
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
                        else if(selectedOne.ID_1_Type__pc == 4 || selectedOne.ID_1_Type__pc == 5)
                        {
                            ID_1_Type = 'PSPT'; 
                        }
                    
                    selectedOne.ID_1_Description__pc = (selectedOne.ID_1_Description__pc == '' || selectedOne.ID_1_Description__pc == null) ? '' : string.valueof(selectedOne.ID_1_Description__pc) + ' | ';
                    
                    DLStateIdPassportToMatch = ((ID_1_Type == '' || ID_1_Type == null) ? '' : string.valueof(ID_1_Type) + ' | ') + selectedOne.ID_1_Description__pc	 + '' + (selectedOne.ID_1_Number__pc == null? '' : string.valueof(selectedOne.ID_1_Number__pc)+ ' | ') + '' + (selectedOne.ID_1_Expiration_Date__pc == null? '' : string.valueof(selectedOne.ID_1_Expiration_Date__pc.date()));
                    
                    if(DLStateIdPassportToMatch.endsWith(' | '))
					{
						DLStateIdPassportToMatch = DLStateIdPassportToMatch.substring(0,DLStateIdPassportToMatch.lastIndexOf(' | '));
					}
                }
                else if(selectedOne.ID_2_Number__pc == DLStateIdPassport){
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
                    selectedOne.ID_2_Description__pc = (selectedOne.ID_2_Description__pc == '' || selectedOne.ID_2_Description__pc == null) ? '' : string.valueof(selectedOne.ID_2_Description__pc) + ' | ';
                    
                    DLStateIdPassportToMatch = ((ID_1_Type == '' || ID_1_Type == null) ? '' : string.valueof(ID_1_Type) + ' | ') + selectedOne.ID_2_Description__pc	 + '' + (selectedOne.ID_2_Number__pc == null? '' : string.valueOf(selectedOne.ID_2_Number__pc) + ' | ') + '' + (selectedOne.ID_2_Expiration_Date__pc == null? '' : string.valueof(selectedOne.ID_2_Expiration_Date__pc.date()));
                    
                    if(DLStateIdPassportToMatch.endsWith(' | '))
					{
						DLStateIdPassportToMatch = DLStateIdPassportToMatch.substring(0,DLStateIdPassportToMatch.lastIndexOf(' | '));
					}
                }
                else if(selectedOne.ID_3_Number__pc == DLStateIdPassport){
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
                    
                    DLStateIdPassportToMatch = ((ID_1_Type == '' || ID_1_Type == null) ? '' : string.valueof(ID_1_Type) + ' | ') + selectedOne.ID_3_Description__pc	 + '' + (selectedOne.ID_3_Number__pc == null? '' : string.valueOf(selectedOne.ID_3_Number__pc) + ' | ' ) + '' + (selectedOne.ID_3_Expiration_Date__pc == null? '' : string.valueof(selectedOne.ID_3_Expiration_Date__pc.date()));
                    
                    if(DLStateIdPassportToMatch.endsWith(' | '))
					{
						DLStateIdPassportToMatch = DLStateIdPassportToMatch.substring(0,DLStateIdPassportToMatch.lastIndexOf(' | '));
					}
                }
            }
            // Set ID Number Status
            system.debug('IdNumber---'+DLStateIdPassportToMatch);
            
            if (DLStateIdPassportToMatch != '')
           {
                DLStateIdPassport = DLStateIdPassportToMatch;
                system.debug('ttt'+DLStateIdPassport);
                DLStateIdPassportMatch = 'true';
           }
           else
           {
                DLStateIdPassport = '';
                DLStateIdPassportMatch= '';
           
           }
                    
        /*   if (IDNumberToMatch != '')
           {
                IdNumber = IDNumberToMatch;
                IdNumberMatch = 'true';
           }
           else
           {
                IdNumber = '';
                IdNumberMatch= '';
           
           }*/
            
    }
    
    // called on page load for verify page 
    public void VerifyCallerDetails(){
        system.debug('VerifyCallerDeatils called');
        verificationObject verificationObject = new verificationObject();
        if (SalesforceID != null && SalesforceID != '')
        {
            Account A = vc.getAccountByName(SalesforceId);
            firstName = A.firstName;
            lastname = A.LastName;
        }
        
        if(CardNumberMatch == 'true' && MemberNumberMatch == 'true' && SSNnumberMatch == 'true')
        {
                //mtitle = 'test';
                verificationObject.phoneNumber = PhoneNumber;
                verificationObject.CardNumber = EnteredCardNumber;
                verificationObject.memberNumber = EnteredMemberNumber;
                verificationObject.SSN = EnteredSSN;
                //EnteredCardNumberLastdigits
                NameList = vc.queryByParametersAvailable(verificationObject, true);
                
        }
        else
        {
            if(CardNumberMatch == 'true' || MemberNumberMatch == 'true' || SSNnumberMatch == 'true'){
                //mtitle = 'Verification Required';
                if(PhoneNumberMatch == 'true'){                    
                    verificationObject.phoneNumber = PhoneNumber;
                }
                if(CardNumberMatch == 'true'){
                    
                    verificationObject.CardNumber = EnteredCardNumber;
                }
                if(MemberNumberMatch == 'true'){
                    
                    verificationObject.memberNumber = EnteredMemberNumber;
                }
                if(SSNnumberMatch == 'true'){
                    
                    verificationObject.SSN = EnteredSSN;
                }
                NameList = vc.queryByParametersAvailable(verificationObject, true);
                
            }
            else
            {
                if(PhoneNumberMatch == 'true'){                    
                    NameList = vc.ValidatePhoneNumber(PhoneNumber);
                }
               
            }            
        }
        
        if (EnteredMemberNumber != '' && EnteredMemberNumber != null)
        {
            boolean memberNumberValidated = vc.validateMemberNumber(verificationObject.memberNumber);
            
            if (memberNumberValidated == true)
            {
                MemberNumberMatchStatus = 'Valid';
                
            }
            else
            {
                MemberNumberMatchStatus = 'No Match Found';
                MemberNumberMatch = 'false';
            }
        }
        else
        {
            MemberNumberMatchStatus = '';
            MemberNumberMatch = '';
        }
        
        
        System.debug(NameList);
        setConfirmationOncheckboxes();
        //collaboration();
        
        
        try{ 
            system.debug('time to go check for size');
            if(!(NameList.size()>0)){
                
                NameList = null;
            }else{
                system.debug('time to go check for size'+NameList.size());
                
            }
        } 
        catch(System.NullPointerException e){NameList = null;}  
     }
     
    
    
    
    public PageReference homePage(){
        logDecision('Not Authenticated');
        return(homePage1());
    }
    
    public PageReference homePage1(){
        PageReference pageCalulated = null;
        pageCalulated = new PageReference('/');
        pageCalulated.setRedirect(true);
        return pageCalulated;
    }
    
    public PageReference NewLeadPage(){
        PageReference pageCalulated = null;
        pageCalulated = new PageReference('/00Q/e?ent=Lead');        
        pageCalulated.setRedirect(true);
        return pageCalulated;
    }
    public PageReference DetailsPage(){
        logDecision('Authenticated');
        PageReference Account = new PageReference('/'+SalesforceID);
        Account.setRedirect(true);
        return Account;
    }
    
   /* public PageReference AlternateAutheticationPageAction(){        
        logDecision('Alternate Authentication');
        return(homePage1());
    }*/
    
    public PageReference clearFields(){    
            system.debug('called');    
            ClearAllflag = true; 
            clickcount ++;
            NameList = new list<Account>();       
            MemberLoanDetails = new List<Account_Details__c>();     
            MemberNameDobDetails = new List<Person_Account__c>();       
            JTMemberNameDobDetails = new List<Person_Account__c>();     
            
       
            EnteredSSN = '';
            SSNnumberMatch = ''; 
            SSNnumberConfirmString = '';
            SSNnumberConfirm = false;
            pinString = '';
            PINMatch = 'false';
        
            DOB = '';
            DOBMatch = ''; 
            PhoneNumber = '';
            PhoneNumberMatch='';
            DOBMatch = '';
            DOBConfirm = false;
            DOBConfirmString =  '';
            IdNumber = '';
            IdNumberMatch = ''; 
            IdNumberConfirm = false;
            IdNumberConfirmString = '';
            MMN = '';
            MMNMatch = ''; 
            MMNConfirm = false;
            MMNConfirmString = '';
            Email = '';
            LstEmail = new List<SelectOption>();
            EmailMatch = ''; 
            EmailConfirm = false;
            EmailConfirmString = '';
            //PhoneNumber ='';
            PhoneNumberMatch = '';
            
            EnteredMemberNumber = '';
            
            DLStateIdPassport ='';
            DLStateIdPassportMatch='';
            DLStateIdPassportConfirm =false;
            DLStateIdPassportConfirmString='';
            
            
                       
            EnteredMemberNumber = '';
            MemberNumberMatch = ''; 
            MemberNumberConfirm = false;
            MultipleMemberNumberAlert = '';
            MemberNumberMatchStatus = '';
            
            if(selectedID != null){
                MemberLoanDetails.clear();              
                MemberNameDobDetails.clear();
                JTMemberNameDobDetails.clear();
                
                
                showErrorMsgJTmemberTable = false;
                
                selectedID = '';
                
            }
            
            else{
                //NoIVRInformation();
            }
            
            CardNumberMatch = '';
            PINMatch = '';
            pinString = '';
            EnteredCardNumberFormatted = '';
            EnteredCardNumber = '';
            EnteredCardNumberLastdigits = '';
            
             AdditionalToken1Selection =  '';
             AdditionalToken1chk ='';
             AdditionalToken2Selection=''; 
             AdditionalToken2chk ='';
             AdditionalToken3Selection=''; 
             AdditionalToken3chk ='';
             
             AdditionalTokenOtherText='';
             AdditionalTokenOtherText1='';
             AdditionalTokenOtherText2='';
             
             AdditionalToken3chkString='';
             AdditionalToken2chkString='';
             AdditionalToken1chkString=''; 
        
              if(fromMarsData == 'True')
              {
                fromMarsData  = 'False';
              }
           
            return null;
    }
    
    public String logDecision(String decision){
        
        system.Debug('JTwrapperLst====' + JTwrapperLst);
        
        Authenticated_Log__c log = new Authenticated_Log__c();
        log.IVR_Sent_URL__c = substring(PageUrl, 1000);
        log.CallerPhoneNumber__c = substring(PhoneNumber, 16);
        log.EnteredCardNumber__c = substring(EnteredCardNumber, 16);
        log.EnteredMemberNumber__c = substring(EnteredMemberNumber, 15);
        log.EnteredSSN__c = substring(EnteredSSN, 4);
        log.DOB__c = substring(DOB, 50);
        log.ICardNumber__c = substring(IdNumber, 20);
        log.MMN__c = substring(MMN, 50);
        System.debug(substring(Email,50));
        log.Email__c = substring(Email, 50);
        log.EmailMatch__c = substring(EmailMatch,5);
        log.HP_HV__c = substring(HighFlag,5);
        log.IVR_Code__c = substring(ReasonCode,44);
        
        //log.MMN__c = substring(MMN, 50);
        system.debug('Names object----' + Names);
        system.debug('firstname---' + firstname);
        system.debug('lastname...' + lastname);
        
        if (Names != null)
        {
            log.First_Name__c = substring(Names.firstName, 100);
            log.Last_Name__c = substring(Names.lastName, 100);
        }
        else
        {
            log.First_Name__c = substring(firstName, 100);
            log.Last_Name__c = substring(lastName, 100);
        }
        
        log.PhoneNumberMatch__c = substring(IVRPhoneNumberMatch,5) ;
        log.PINMatch__c = substring(IVRPINMatch,5); 
        
        log.IVR_Card_Match__c = substring(IVRCardNumberMatch,5);
        log.IVR_Card_Number__c = substring(IVREnteredCardNumber,4);
        log.IVR_Member_Number__c = substring(IVREnteredMemberNumber,10);
        log.IVR_Member_Number_Match__c = substring(IVRMemberNumberMatch,5);
        log.IVR_Pin_Match__c = substring(IVRPINMatch,5);
        log.IVR_SSN__c = substring(IVREnteredSSN,10);
        log.IVR_SSN_Match__c = substring(IVRSSNnumberMatch,5);
           
        RecordType s =[select Id,Name,SobjectType from RecordType where name ='IVR Authentication Log' and SobjectType='Authenticated_Log__c'];
        log.RecordTypeId= s.id;    
        log.Log_Clear_All_Field__c = clickcount;
        if(ClearAllflag){
            if(MemberNumberConfirm){
                log.MemberNumberMatch__c = 'true';
                
                system.debug('clickcount========' +  clickcount);
            }if(!MemberNumberConfirm){
                log.MemberNumberMatch__c = 'false';
            }                   
            /*if(SSNnumberConfirm){
                log.SSNnumberMatch__c = 'true';
            }if(!SSNnumberConfirm){
                log.SSNnumberMatch__c = 'false';
            }*/
            log.SSNnumberMatch__c = substring(SSNnumberConfirmString,5);
            if(CardNumberConfirm){
                log.CardNumberMatch__c = 'true';
            }if(!CardNumberConfirm){
                log.CardNumberMatch__c = 'false';
            }   
        }
        else {
            if(MemberNumberConfirm || IVRMemberNumberMatch == 'true'){
                log.MemberNumberMatch__c = 'true';
            }else{
                log.MemberNumberMatch__c = 'false';
            }   
            
            //if(SSNnumberConfirm || IVRSSNnumberMatch == 'true'){
            if(SSNnumberConfirmString == 'Pass' || IVRSSNnumberMatch == 'true'){
                log.SSNnumberMatch__c = substring(SSNnumberConfirmString,5);
            }else{
                log.SSNnumberMatch__c = substring(SSNnumberConfirmString,5);
            }
            if(CardNumberConfirm || IVRCardNumberMatch == 'true'){
                log.CardNumberMatch__c = 'true';
            }else{
                log.CardNumberMatch__c = 'false';
            }
            
        }
        
        //system.debug('DOBConfirm...'+DOBConfirm);
        /*if(  DOBConfirmString ==  'Pass'){
            log.DOBMatch__c = 'true';
        }if(!DOBConfirm){
            log.DOBMatch__c = 'false';
        }*/
         log.DOBMatch__c  = substring(DOBConfirmString,5);
                     
       /* if(IdNumberConfirm){
            log.IdNumberMatch__c = 'true';
        }if(!IdNumberConfirm){
            log.IdNumberMatch__c = 'false';
        }*/
        log.IdNumberMatch__c =substring(IdNumberConfirmString,5);
        
        /*if(MMNConfirm){
            log.MMNMatch__c = 'true';
        }if(!MMNConfirm){
            log.MMNMatch__c = 'false';
        }*/
        
        log.MMNMatch__c = substring(MMNConfirmString,5);

        /*if(EmailConfirm){
            log.EmailMatch__c = 'true';
        }if(!EmailConfirm){
            log.EmailMatch__c = 'false';
        }*/
        log.EmailMatch__c = substring(EmailConfirmString,5);
        
        if(!MemberLoanDetails.isEmpty()){   
            string LoanDeatil = '';       
            for(Account_Details__c ac : MemberLoanDetails){      
                  String[] LoanIds = LoanSelectedID.split(';');

                    if (LoanSelectedID != '')
                    {       
                            system.debug(' #### LoanIds' + LoanIds);
                            system.debug(' #### ac.Id' + ac.Id);
                             for (string lid : LoanIds)
                             {         
                                 
                                 if(lid.split('#')[0] == (string)ac.Id && lid.split('#')[1] != ' ')   
                                 {    
                                    
                                    LoanDeatil += 'Account Number - ' + ac.Name + ',';
                                    LoanDeatil += 'Loan Type - ' + ac.TypeTranslate__c + ',';
                                    LoanDeatil += 'Current Balance - ' + ac.Balance__c + ',' ;
                                    LoanDeatil += 'Close/Maturity Date - ' + ac.Close_Date__c + ',' ;
                                    LoanDeatil += 'Monthly Payment - ' + ac.PAYMENT__c + ',';
                                    LoanDeatil += 'Match - ' + lid.split('#')[1] + '\r\n\n';
                                 }
                             }              
                    }
            }
            system.debug('LoanDeatil #' + LoanDeatil);
            log.Member_Loan_Detail__c = LoanDeatil;
        
            if(LoanDetailConfirm){
                log.Loan_Detail_Match__c = 'true';
            }
            if(!LoanDetailConfirm){
                log.Loan_Detail_Match__c = 'false';
            }
        }
        
         if(!JTMemberNameDobDetails.isEmpty()){   
            string JTDeatil = '';       
            String[] JTIds = JTSelectedID.split(';'); 
            if (JTSelectedID != '')
            {
                log.Related_Persons_Match__c = true;
                for(Person_Account__c pc : JTMemberNameDobDetails){ 
                    
                  for (string jid : JTIds)
                  {         
                    string[] jidSLIPTED =  jid.split('#');
                    if(jidSLIPTED[0] == (string)pc.PersonID__c && (jidSLIPTED[1] != ' ' || jidSLIPTED[2] != ' '))
                    {                        
                        JTDeatil += 'Member Name - ' + pc.PersonID__r.Name + ' - ' + jidSLIPTED[1] +  ', ';
                        JTDeatil += 'Relationship type - ' + pc.TypeTranslate__c + ', ';
                        JTDeatil += ' DoB - ' + pc.PersonID__r.BIRTH_DATE__pc + ' ' + jidSLIPTED[2] + '\r\n\n';
                    }
                  }            
                }
            }
         
         
             log.Related_Persons__c  = JTDeatil;
             
         
         }
         
         
         
         
         System.debug('AdditionalToken1chk---' + AdditionalToken1chk );
          System.debug('AdditionalToken2chk---' + AdditionalToken2chk );
         System.debug('AdditionalToken3chk---' + AdditionalToken3chk );
         System.debug('SalesforceID---' + SalesforceID );
           /*if (AdditionalToken1chk == 'true')
           {
                log.Additional_Token_Option1__c = substring(AdditionalToken1Selection,255);
           }
           if (AdditionalToken2chk == 'true')
           {
                log.Additional_Token_Option2__c = substring(AdditionalToken2Selection,255);
           }
           if (AdditionalToken3chk == 'true')
           {
                log.Additional_Token_Option3__c = substring(AdditionalToken3Selection,255);
           }*/
           
           log.Additional_Token_Option1_Match__c = substring(AdditionalToken1chkString,5);
           log.Additional_Token_Option2_Match__c = substring(AdditionalToken2chkString,5);
           log.Additional_Token_Option3_Match__c = substring(AdditionalToken3chkString,5);
           
           if (AdditionalToken1Selection != null && AdditionalToken1Selection != '')
           {
                log.Additional_Token_Option1__c = substring(AdditionalToken1Selection,255);
           }
           if (AdditionalToken2Selection != null && AdditionalToken2Selection != '')
           {
                log.Additional_Token_Option2__c = substring(AdditionalToken2Selection,255);
           }
           if (AdditionalToken3Selection != null && AdditionalToken3Selection != '')
           {
                log.Additional_Token_Option3__c = substring(AdditionalToken3Selection,255);
           }
           
           log.Additional_Token_Other_Text__c = substring(AdditionalTokenOtherText,255);
           log.Additional_Token_Other_Text1__c = substring(AdditionalTokenOtherText1,255);
           log.Additional_Token_Other_Text2__c = substring(AdditionalTokenOtherText2,255);
            
              
        log.SalesforceID__c = SalesforceID;
        log.Member__c = SalesforceID;
        log.Decision__c = substring(decision,100);
        //OTPVerified
        if(OTPVerified != '' && OTPVerified != null)
        {
            log.IVR_OTP_Result__c = OTPVerified;
            Datetime createddate = System.now().addminutes(-5);
            List<Authenticated_Log__c> listOTPLog = [select id, OTP_Email__c, OTP_Phone__c from Authenticated_Log__c where SalesforceID__c =: SalesforceID and CreatedDate >: createddate order by CreatedDate desc limit 1 ];
            if(listOTPLog.size() > 0)
            {
                log.OTP_Email__c =listOTPLog[0].OTP_Email__c;
                log.OTP_Phone__c =listOTPLog[0].OTP_Phone__c;
            }

        }
        system.debug('log ###' + log);       
        insert log;
        return SalesforceID;
    }
    
     public class JTMemberNameDoBWrapper{
        //public Person_Account__c PJT {get; set;}
      //  public Person_Account__c PB {get; set;}
        public string AccountNumber {get;set;}
        public string RelationShip {get;set;}
        public string Jtname {get; set;}
        public DateTime DT {get; set;}
        public Boolean ckJtMemberNameConfirm {get;set;}
        public Boolean ckJtMemberDOBConfirm {get;set;}
        public Id ID {get;set;}
      //  public Boolean ckBenificiaryNameConfirm {get;set;}
     //   public Boolean ckBenificiaryDOBConfirm {get;set;}
      }
 
 // utility functions
 
 public String FormatMemberNumber(String MemberNumber){
        String addZeros = '';
        if(MemberNumber.length()>0){
        Integer a = MemberNumber.length(); 
        if(a<10){
            for(integer i=0;i<10-a;i++){
                addZeros = addZeros+'0';
            }
        }
        }
        return addZeros+MemberNumber;
    }
     public List<SelectOption> getNameList_Options (){
      List<SelectOption> options = new List<SelectOption>();    
            for(Account a : NameList){
                if(string.isEmpty(a.FirstName)){          
                  a.FirstName= '';                          
                }     
                if(string.isEmpty(a.LastName)){       
                  a.LastName = '';      
                }
              options.add(new SelectOption(a.ID,a.FirstName+' '+a.LastName));
             }
      return options;
    }
    
     private void getQueryStringData()
    {
        // Member Number
        PhoneNumber = ApexPages.currentPage().getParameters().get('CallersPhoneNumber');
        EnteredMemberNumber = ApexPages.currentPage().getParameters().get('EnteredMemberNumber');
        IVREnteredMemberNumber = EnteredMemberNumber;
        ReasonCode = ApexPages.currentPage().getParameters().get('Reason');
        HighFlag = ApexPages.currentPage().getParameters().get('HighValueFlag');
        MemberType = ApexPages.currentPage().getParameters().get('MemberType');        
        
        
        if(ReasonCode == null || ReasonCode == '')
        {
            ReasonCode = 'Unknown';
        }
        
        // special validation for users entering 4# and null
        if(EnteredMemberNumber == null || EnteredMemberNumber == '')
        {
            return;
        }
        
        string truncatedMNumber = removeInitialZero(EnteredMemberNumber);
        if (truncatedMNumber.length() < 2 ||  EnteredMemberNumber == 'NULL')
        {
            EnteredMemberNumber = '';
        }
        else
        {
            EnteredMemberNumber = FormatMemberNumber(EnteredMemberNumber);
            
        }
        // format member number
        EnteredMemberNumber = FormatMemberNumber(EnteredMemberNumber);
        IVRMemberNumberMatch = ApexPages.currentPage().getParameters().get('MemberNumberMatch');
        
        if(EnteredMemberNumber != null && EnteredMemberNumber != ''){
            MemberNumberMatch = ApexPages.currentPage().getParameters().get('MemberNumberMatch');
            
        }
        else{
            MemberNumberMatch = null;
        }
        
        // card and Pin
        
        EnteredCardNumber = ApexPages.currentPage().getParameters().get('EnteredCardNumber');
        IVREnteredCardNumber = EnteredCardNumber;
        if (EnteredCardNumber == 'NULL' || (EnteredCardNumber.length() != 16 && EnteredCardNumber.length() != 4)   )
        {
            EnteredCardNumber = '';
            PinString = '';
        }
        else
        {
            PinString = '****';
        }
        
         if(EnteredCardNumber != null && EnteredCardNumber != ''){
            system.debug('Entered card not null');
            if(string.isEmpty(EnteredCardNumberLastdigits)){
                EnteredCardNumberLastdigits = EnteredCardNumber;
                system.debug('Entered card length' + EnteredCardNumber.length() + '---' + EnteredCardNumber);
                if (EnteredCardNumber.length() > 4)
                {  
                    EnteredCardNumberFormatted = '****-****-****-' + EnteredCardNumber.right(4);
                }
                else
                {
                    EnteredCardNumberFormatted = EnteredCardNumber.right(4);
                }
                CardNumberMatch = ApexPages.currentPage().getParameters().get('CardNumberMatch');
            }
            
        }
        else{
            CardNumberMatch= null;
        } 
        
        IVRCardNumberMatch = ApexPages.currentPage().getParameters().get('CardNumberMatch');
        
        PINMatch = ApexPages.currentPage().getParameters().get('PINMatch');
        IVRPINMatch = PINMatch;
        
        IVRGUID = ApexPages.currentPage().getParameters().get('InteractionId');
      	
        
        // SSN
        
        EnteredSSN = ApexPages.currentPage().getParameters().get('EnteredSSN');
        IVREnteredSSN = EnteredSSN;
        
        if (EnteredSSN == 'NULL' || (EnteredSSN.length() != 4 && EnteredSSN.length() != 9))
        {
            EnteredSSN = '';
        }
        IVRSSNnumberMatch = ApexPages.currentPage().getParameters().get('SSNnumberMatch');
        
        if(EnteredSSN != null && EnteredSSN != ''){
            SSNnumberMatch = ApexPages.currentPage().getParameters().get('SSNnumberMatch');
        }
        else{
            SSNnumberMatch = null;
        }
        
        // Salesforce ID
        SalesforceID = ApexPages.currentPage().getParameters().get('SalesforceID');          
        
        // Phone Number
        PhoneNumberMatch= ApexPages.currentPage().getParameters().get('PhoneNumberMatch');  
        IVRPhoneNumberMatch = PhoneNumberMatch;
       
        // DOB
        DOB = ApexPages.currentPage().getParameters().get('DOB');  
        IVRDOB = DOB;
        
        if(DOB != null && DOB != ''){       
            DOBMatch =  ApexPages.currentPage().getParameters().get('DOBMatch');        
        }       
        else{       
            IVRDOBMatch = null;       
        }
    }
    public string removeInitialZero(string a)
    {
        
        string[] b = a.split('');
        string joineda = '';
        boolean f = false;
        for(string singlea : b)
        {
        
            if (singlea == '0' && f == false)
                {
                    continue;
                }
            else
            {
                f = true;
            }
        
            joineda += singlea;
        }
        return joineda;
    }   
    
    public static string substring(string val, integer length)
    {
        if(val != null && val != '')
        {
            return val.left(length);
        }   
        return val;
    
    }
    
}