public class SolarLoanToCreateLoan {

    public static List<Solar_Loans__c> SolarLoanToUpdate = new List<Solar_Loans__c>();
    public static MAP<Id,Solar_Loans__c> solarMap = new MAP<Id,Solar_Loans__c>();

    public static string operatorid;
    public static string loanAPI;
    public static string ProductTypeDescription;
    public static string AccountNumber;
    public static string Logs;
    
    //-------------------------------------------------------Brand-----------------------------------------------------//

    public static HttpRequest req = new HttpRequest();
    public static HttpResponse res;
    public static Http http = new Http();
    public static string responseBody;
    public static string Brand;
    public static string BrandCode; 

    //------------------------------------------------System is online/offline-----------------------------------------------------//

    public static HttpRequest req16 = new HttpRequest();
    public static HttpResponse res16;
    public static Http http16 = new Http();
    public static string responseBody16;
    public static boolean mode = false;

    //-----------------------------------------------------Membership Check------------------------------------------//

    public static HttpRequest req1 = new HttpRequest();
    public static HttpResponse res1;
    public static Http http1 = new Http();
    public static string responseBody1;
    public static string MembershipExist;
    public static string jsonData1;
    public static Integer TotalPrimaryAccount;
    
    //-----------------------------------------------------Membership Create------------------------------------------//

    public static HttpRequest req2 = new HttpRequest();
    public static HttpResponse res2;
    public static Http http2 = new Http();
    public static string responseBody2;
    public static string jsonData2;
    public static string MembershipccountStatus;

    public static string BRANCH;
    public static string CREATEDATBRANCH;
    public static string CREATEDBYUSER;
    public static string MEMBERGROUP;
    public static string REFERENCE;
    public static string RELATIONSHIPCODE;
    public static string RELATIONSHIPOVERRIDE;
    public static string TYPE;
    public static string WARNINGCODE;
    public static string WARNINGEXPIRATION;  
	
    public static string BIRTHDATE;
    public static string CITY;
    public static string EMAIL;
    public static string EMPLOYERNAME;
    public static string EXTRAADDRESS;
    public static string FIRST;
    public static string HOMEPHONE;
    public static Integer IDENTDOCFLAG;
    public static Integer IDENTDOCFLAG3;
    public static string IDENTIDDESCRIPTION;
    public static string IDENTIDDESCRIPTION3;
    public static string IDENTIDEXPIREDATE;
    public static string IDENTIDISSUEDATE;
    public static string IDENTIDNUMBER;
    public static Integer IDENTIDTYPE;
    public static string LAST;
    public static string MIDDLE;
    public static string MOBILEPHONE;
    public static string MOTHERSMAIDENNAME;
    public static string OCCUPATION;
    public static string SSN;
    public static string STATE;
    public static string STREET;
    public static string SUFFIX;
    public static string WORKPHONE;
    public static string ZIPCODE;
    public static string PRIMARYUSERCHAR1;

    public static string LASTACCESSCHANGEDATE;
    public static string AUDIOACCESS;
    public static string LASTHBPWCHANGEDATE;
    public static string HBPASSWORD;
    public static string AUDIOENABLE;
    public static string HBENABLE;

    //-------------------------------------------------------- Existing Solar Loan --------------------------------------------------//

    public static String Payment;
    public static HttpRequest req0 = new HttpRequest();
    public static HttpResponse res0;
    public static Http http0 = new Http();
    public static string responseBody0;
    public static String ExistingLoanId;
    public static String TrackingRecord;
    public static String result;
   
    //---------------------------------------------------------- New Solar Loan -------------------------------------------------------//

    public static HttpRequest req12 = new HttpRequest();
    public static HttpResponse res12;
    public static Http http12 = new Http();
    public static string responseBody12;
    public static string jsonData12;

    public static String SLType;
    public static String SLBranch;
    public static String SLCreatedAtBranch;
    public static String SLPurposeCode;
    public static String SLCollateralCode;
    public static String SLApprovalCode;
    public static String SLOriginalBalance;
    public static String SLApprovalDate;
    public static String SLMaturityDate;
    public static String SLDueDate;
    public static String SLFirstPaymentDate;
    public static String SLDueDay1;
    public static String SLPayment;
    public static Boolean SLPaymentMatched = false;
    public static Boolean ApprovalDate = false;
    public static String SLCouponCode;
    public static String SLPaymentMethod;
    public static String SLDescription;
    public static String SLInterestRate;
    public static String SLUserAmount1;
    public static String SLECOACode;
    public static String SLCreditScore;
    public static String SLPaymentCount;
    public static String SLPaymentFrequency;
    public static String SLAccountNumber;
    public static string SLOriginalDate;
    public static Integer SLMonth;
    public static Integer SLAmount;
    public static String SLApplicationFundedBy;
    public static String SLApplicationLoadedBy;
    public static String SLProductTypeDescription = 'SECURED SOLAR';
    public static String ErrorLoanLocator;

    public static HttpRequest req15 = new HttpRequest();
    public static HttpResponse res15;
    public static Http http15 = new Http();
    public static string responseBody15;
    public static string jsonData15;

    //----------------------------------------------------------Solar Loan Primary---------------------------------------------------//
    
    public static String SLLast;
    public static String SLFirst;
    public static String SLStreet;
    public static String SLExtraAddress;
    public static String SLCity;
    public static String SLState;
    public static String SLZipCode;
    public static String SLBirthDate;
    public static String SLSSN;
    public static String LoanId;

    public static String jsonData13;
    public static HttpRequest req13 = new HttpRequest();
    public static String result1;
    public static string ErrorLoanNameLocator;

    //------------------------------------------------Solar Loan Tracking Parameters---------------------------------------------//
    
    public static String SLUserChar11;
    public static String SLUserChar1;
    public static String SLUserChar2;
    public static String SLUserChar3;
    public static String SLUserChar4;
    public static String SLUserChar5;
    public static String SLUserChar10;
    public static String SLUserChar20;
    public static String SLUserAmount2;
    public static String SLUserAmount3;
    public static String SLUserAmount11;
    public static String SLUserAmount12;
    public static String SLUserAmount13;
    public static String SLUserAmount14;  
    public static String SLUserCode1;
    public static String SLUserRate1;
    public static string SLUserCode11;
    public static string SLUserDate11;
    public static String SLUserChar7;
    public static string SLUserChar6;

    public static HttpRequest req14 = new HttpRequest();
    public static HttpResponse res14;
    public static Http http14 = new Http();
    public static string responseBody14;
    public static string jsonData14;
    public static String result2;
    public static string ErrorLoanTrackingLocator;

    //------------------------------------------------------------- Joint Name---------------------------------------------------------//

    public static HttpRequest req4 = new HttpRequest();
    public static HttpResponse res4;
    public static Http http4 = new Http();
    public static string responseBody4;
    public static string jsonData4;
    public static Boolean hasJoint;

    public static string JOINTBIRTHDATE;
    public static string JOINTCITY;
    public static string JOINTEMAIL;
    public static string JOINTEMPLOYERNAME;
    public static string JOINTEXTRAADDRESS;
    public static string JOINTFIRST;
    public static string JOINTHOMEPHONE;
    public static Integer JOINTIDENTDOCFLAG;
    public static Integer JOINTIDENTDOCFLAG3;
    public static string JOINTIDENTIDDESCRIPTION;
    public static string JOINTIDENTIDDESCRIPTION3;
    public static string JOINTIDENTIDEXPIREDATE;
    public static string JOINTIDENTIDISSUEDATE;
    public static string JOINTIDENTIDNUMBER;
    public static Integer JOINTIDENTIDTYPE;
    public static string JOINTLAST;
    public static string JOINTMIDDLE;
    public static string JOINTMOBILEPHONE;
    public static string JOINTMOTHERSMAIDENNAME;
    public static string JOINTOCCUPATION;
    public static string JOINTSSN;
    public static string JOINTSTATE;
    public static string JOINTSTREET;
    public static string JOINTSUFFIX;
    public static string JOINTWORKPHONE;
    public static string JOINTZIPCODE;
    public static string UserChar3;
    public static string JOINTUSERCHAR1;
    //------------------------------------------------------- Mail Name-------------------------------------------------------//

    public static HttpRequest req5 = new HttpRequest();
    public static HttpResponse res5;
    public static Http http5 = new Http();
    public static string responseBody5;
    public static string jsonData5;
    public static Boolean hasMail;

    public static string MAILFIRST;
    public static string MAILLAST;
    public static string MAILMIDDLE;
    public static string MAILEXTRAADDRESS;
    public static string MAILOVERRIDE;
    public static string MAILSTATE;
    public static string MAILCITY;
    public static string MAILSTREET;
    public static string MAILSUFFIX;
    public static string MAILZIPCODE;
    
    //------------------------------------------------------- Create Comment-------------------------------------------------------//

    public static HttpRequest req6 = new HttpRequest();
    public static HttpResponse res6;
    public static Http http6 = new Http();
    public static string responseBody6;
    public static string jsonData6;

    public static string COMMENT;
    public static string COMMNETTYPE;

    //------------------------------------------------------- Tracking 35 Record---------------------------------------------------//

    public static HttpRequest req7 = new HttpRequest();
    public static HttpResponse res7;
    public static Http http7 = new Http();
    public static string responseBody7;
    public static string jsonData7;

    public static string TRACKINGTYPE;
    public static string Tracking35;
    public static string TrackingLocator;
    
    //--------------------------------------------------------- Get Preference  Record------------------------------------------------//

    public static HttpRequest req10 = new HttpRequest();
    public static HttpResponse res10;
    public static Http http10 = new Http();
    public static string responseBody10;
    public static string jsonData10;
    public static String PreferenceLocator;

    //-------------------------------------------------------- Create Preference Record------------------------------------------------//

    public static HttpRequest req8 = new HttpRequest();
    public static HttpResponse res8;
    public static Http http8 = new Http();
    public static string responseBody8;
    public static string jsonData8;
    public static string PreferenceAccessLocator;
    public static string ACCESSTYPE;
    
     //------------------------------------------------------------ Share Record-----------------------------------------------------//

    public static HttpRequest req9 = new HttpRequest();
    public static HttpResponse res9;
    public static Http http9 = new Http();
    public static string responseBody9;
    public static string jsonData9;
    public static string RGlines;

    public static string SHAREBRANCH;
    public static string SHARECREATEDATBRANCH;
    public static string SHARECREATEDBYUSER;
    public static string SHAREMINIMUMBALANCE;
    public static string SHARETYPE;
    public static string SHAREID;

    //-------------------------------------------------------------- PowerOn Record--------------------------------------------------//

    public static HttpRequest req11 = new HttpRequest();
    public static HttpResponse res11;
    public static Http http11 = new Http();
    public static string responseBody11;
    public static string jsonData11;

    public static string RGSession;
    public static string RGUserChr1;
    public static string RGUserChr2;


    @future(callout=true)
    public static void createSolarLoans(Set<id> ids){
    
        String userName = UserInfo.getUserName();
        User activeUser = [Select Email,Alias From User where Username = : userName and Alias != null limit 1];
    
        List<Episys_User__c> epu =  [select id,Alias__c,Episys_ID__c,Episys_Name__c from Episys_User__c where Alias__c =: activeUser.Alias];
        system.debug('Episys User' + epu);
        if(epu != null){
            if(epu.size() > 1){
                for(Episys_User__c eu : epu){
                    if(eu.Alias__c != null){
                        operatorid = string.ValueOf(epu[0].Episys_ID__c);
                        system.debug('operatorid'+operatorid);
                    }
                }
            
            }
            if(epu.size() == 1){
                operatorid = string.ValueOf(epu[0].Episys_ID__c);
                system.debug('operatorid'+operatorid);
            }
        }
            
        List<Solar_Loans__c> Solanloanlist = new List<Solar_Loans__c>();         
        List<Solar_Loans__c> solarloans = [SELECT ABA_Bank_Name__c,Account_Number__c,ACH_Discount__c,ACH__c,Additional_Amount__c,APN__c,
                                        Application_Date__c,Approval_Date__c,Bank_Account_Number__c,Bank_Name__c,Battery__c,Membership_confirmation__c,
                                        Block__c,Book__c,Brand__c,Change_Order__c,Citizenship__c,Continue__c,County__c,Count__c,
                                        CreatedById,CreatedDate,Created_Date__c,Credit_Attributes__c,Credit_Exception__c,Episys_Membership__c,
                                        Current_Solar_Loan_Stage__c,Debt_Ratio__c,DocuSignId__c,DocuSign_Document_Status__c,Due_Date__c,
                                        Dummy__c,ECOA_Code__c,EftLocator__c,Employer__c,Error_EftLocator__c,Error_Loan_Locator__c,
                                        Error_Loan_Name_Locator__c,Error_Loan_Tracking_Locator__c,Final_Payment_Amount__c,FNI__c,
                                        Go_To_Payment__c,Id,Initial_LT_Loan_Agreement__c,Installer_Number__c,Installer__c,Preference_Locator__c,
                                        Interest_Rate__c,Inverter__c,IsDeleted,ITC_Amount__c,ITC_Rate__c,Joint_Address_1__c,Tracking_Record_34__c,
                                        Joint_Address_2__c,Joint_Cell_Phone__c,Joint_Citizenship__c,Joint_City__c,Joint_DOB__c,Tracking_Record_35__c,
                                        Joint_Email__c,Joint_FICO_Score__c,Joint_First_Name__c,Joint_Home_Phone__c,Joint_ID_Expiration_Date__c,
                                        Joint_ID_Issue_Date__c,Joint_ID_Number__c,Joint_ID_State__c,Joint_ID_Type__c,Joint_Last_Name__c,
                                        Joint_Maiden_Name__c,Joint_Middle_Initial__c,Joint_Occupation__c,Joint_SSN__c,Joint_State__c,Joint_Work_Phone__c,
                                        Joint_Zip_Code__c,LastComment1__c,LastModifiedDate,Last_Comment__c,Latest_LT_Loan_Agreement__c,
                                        Legal_Description__c,Load_Count__c,Load_Date__c,Loan_Amount__c,Loan_Id__c,Loan_Name_Locator__c,Loan_Pmt_Amount__c,
                                        Loan_Tracking_Locator__c,Loan_Type__c,Lot__c,Mailing_Street__c,Mailing_Zip__c,Map__c,Maturity_Date__c,
                                        Membership_Fee__c,Member_Name__c,Member_Number__c,mem_ID_Number__c,mem_ID_Expiration_Date__c,mem_ID_Issue_Date__c,
                                        mem_ID_State__c,mem_ID_Type__c,mem_Joint_A_F_Foreign_Gov_t_Position__c,mem_Joint_City__c,mem_Joint_DOB__c,
                                        mem_Joint_Employer__c,mem_Joint_Extra_Address__c,mem_Joint_First_Name__c,mem_Joint_Foreign_Gov_t_Position__c
                                        ,mem_Joint_Last_Name__c,mem_Joint_SSN__c,mem_Joint_State__c,mem_Joint_Street__c,mem_Joint_Zip_Code__c,
                                        mem_Maiden_Name__c,mem_Mailing_City__c,mem_Mailing_Extra_Address__c,mem_Mailing_State__c,
                                        mem_Primary_A_F_Foreign_Gov_t_Position__c,mem_Primary_City__c,mem_Primary_DOB__c,mem_Primary_Extra_Address__c,
                                        mem_Primary_First_Name__c,mem_Primary_Foreign_Gov_t_Position__c,mem_Primary_Last_Name__c,mem_Primary_SSN__c,
                                        mem_Primary_State__c,mem_Primary_Street__c,mem_Primary_Zip_Code__c,Module__c,Mortgage_Balance__c,Name,Name__c,
                                        Net_Funding_Amount__c,Net_Funding_Amt__c,NewDoc__c,New_Comment__c,New__c,Non_Solar_Amount__c,Note__c,Occupation__c,
                                        OID_Fee_Funding_Request__c,OID_Fee__c,OwnerId,Owner__c,Page__c,Primary_Address_1__c,Primary_Address_2__c,
                                        Primary_Cell_Phone__c,Primary_City__c,Primary_DOB__c,Primary_Email__c,Primary_FICO_Score__c,Primary_First_Name__c,
                                        Primary_Home_Phone__c,Primary_Last_Name__c,Primary_Middle_Initial__c,Primary_SSN_Length__c,Primary_SSN__c,
                                        Primary_State__c,Primary_Work_Phone__c,Primary_Zip_Code__c,Product_Loan_Type__c,Product__c,Record_ID__c,
                                        Review_needed__c,Routing_Number__c,Section__c,Site_UUID__c,Status__c,Subdivision__c,Sunlight_Update__c,
                                        Symitar_Called__c,SystemModstamp,System_Size_kW__c,Term_months__c,Tracking_Record_33__c,Tract__c,UCC_Extraction__c,
                                        UCC_Id__c,Valid_ABA__c FROM Solar_Loans__c where id =: ids];
    
        for(Solar_Loans__c sl : solarloans){

            //--------------------------Fetching API URL from custom setting to create --------------------------//
            
            SolarLoan_To_Episys_API_Details__c api = SolarLoan_To_Episys_API_Details__c.getValues('ProductionURL');
            
            if(api.URL__c != null){
                loanAPI = api.URL__c;
            }
            
            List<Solar_Loan_Product_Types__c> PDList = Solar_Loan_Product_Types__c.getall().values();
            for(Solar_Loan_Product_Types__c pd : PDList){ 
                if(sl.Product_Loan_Type__c == pd.Name){
                    ProductTypeDescription = pd.Description__c;
                }
            }
            
            //-------------------------------------Checking if the membership has been created already for this member ------------------//
            
            AccountNumber = sl.Member_Number__c;
            
            SSN = sl.mem_Primary_SSN__c;
            System.debug('----------------------------Checking existing membership-----------------------------');
            req1.setEndpoint(loanAPI+'/SolarLoan/CheckSSNPrimaryAccount');
            req1.setMethod('POST');
            req1.setHeader('Content-Type', 'application/json');
            req1.setHeader('Accept', 'application/json');
            req1.setTimeout(120000);                   
            
            jsonData1 = '{"SSN":'+'\"'+SSN+'\"}';
            req1.setBodyAsBlob(Blob.valueof(jsondata1)); 
            system.debug('test'+jsonData1);
            if(!Test.isRunningTest()){                       
                res1 = http1.send(req1);
                responseBody1 = res1.getBody();
                System.debug('Membership Exists???::'+responseBody1);    
            }
            //else{
               
                //responseBody1 = '{"HasPrimaryAccount":"false","TotalPrimaryAccount" : "1"}';
            //}
            
            if(responseBody1 != '' && responseBody1 != null){        
                Map<string,object> results = (Map<String,Object>) JSON.deserializeUntyped(responseBody1);      
                System.debug('Response is ....' + results);
                
                if(results.size() > 0){
                    for(string key : results.keyset()){ 
                        if(key == 'HasPrimaryAccount'){
                            MembershipExist = String.valueOf(results.get(key));
                        }
                        if(key == 'TotalPrimaryAccount'){
                            TotalPrimaryAccount = Integer.valueOf(results.get(key));
                        }    
                    }
                }
            }
            if(logs == null)
                logs = responseBody1;
            else
                logs = logs +'\n'+ responseBody1;

            system.debug('MembershipExist: '+MembershipExist);
            system.debug('TotalPrimaryAccount: '+TotalPrimaryAccount);
          
            if(MembershipExist == 'true'){
                
                System.debug('Membership is already exist:: '+ MembershipExist);   

                if(AccountNumber == null || AccountNumber == ''){

                    System.debug('----------------------------Gettimg Member number-----------------------------');

                    req16.setEndpoint(loanAPI+'/EFT/GetAccountBySSN?ssn='+SSN);
                    req16.setMethod('GET');
                    req16.setHeader('Content-Type', 'application/json');
                    req16.setHeader('Accept', 'application/json');
                    
                    req16.setTimeout(120000);
                    
                    if(!Test.isRunningTest()){                       
                        res16 = http16.send(req16);
                        responseBody16 = res16.getBody();
                        System.debug('Response Body SolarLoan:'+res16.getBody());    
                    }else{
                        responseBody16 = '{"Type":"3","Last":"27","First":"1","Street":"1","ExtraAddress":"100","City":"Chicago","State":"IL","ZipCode":"0012345,"BirthDate":"01-01-2019","SSN":"1345","LoanId":"322271627","AccountNumber":"00000123456"}';
                        
                    }
                    
                    JSONParser parser = JSON.createParser(responseBody16);
                    AccountNumber = String.valueOf(responseBody16).substringAfter('AccountNumber":"');
                    AccountNumber = String.valueOf(AccountNumber).substringBefore('",');
                    System.debug('Member Number' + AccountNumber);

                }
                
                System.debug('AccountNumber: ' + AccountNumber);
                if(TotalPrimaryAccount == 1 || sl.Membership_confirmation__c == true){

                    //--------------------------Checking if Loan record already exist for this member number ---------------------------------//

                   
                    if(sl.Loan_Pmt_Amount__c != null)
                        Payment = string.valueof(sl.Loan_Pmt_Amount__c);

                    req0.setEndpoint(loanAPI+'/PSAuto/GetLoansSelectFields?accountNumber='+AccountNumber);
                    req0.setMethod('GET');
                    req0.setHeader('Content-Type', 'application/json');
                    req0.setHeader('Accept', 'application/json');
                    req0.setTimeout(120000);                   
                    
                    if(!Test.isRunningTest()){                       
                        res0 = http0.send(req0);
                        responseBody0 = res0.getBody();
                        System.debug('Existing solar loan::'+responseBody0);    
                    }
                    else{
                        //responseBody11 = '{"LoanId" : "7500","Payment" : "4500.00"}';
                        responseBody0 = '[{"LoanId":"7501","Payment":"4500.00","CloseDate":"","CardOwner":null,"Locator":"33","Status":null,"Error":null,"ErrorDetails":null}]';
                    }
                    
                    if(responseBody0 != '' && responseBody0 != null){        
                        List<object> results = (List<Object>) JSON.deserializeUntyped(responseBody0);      
                        System.debug('Response is ....' + results);
                        
                        if(results.size() > 0){
                            for(Object key : results){ 
                                System.debug('Loan Record ...' + key);
                                Map<String, Object> loanids = (Map<String, Object>)key;
                                for(String l : loanids.keyset()) {
                                    System.debug('parameter...' + l);
                                    System.debug('value ...' + String.valueOf(loanids.get(l)));
                                    if(l == 'LoanId' && ApprovalDate == false){
                                        ExistingLoanId = String.valueOf(loanids.get(l));
                                    }
                                    /*if(l == 'Payment' && SLPaymentMatched == false){
                                        if(Payment == String.valueOf(loanids.get(l))) {
                                            SLPaymentMatched = true;
                                        }
                                    }*/
                                    if(l == 'ApprovalDate' && ApprovalDate == false){
                                        if(string.valueof(sl.Approval_Date__c) == string.valueOf(loanids.get(l))) {
                                            ApprovalDate = true;
                                        }
                                    }
                                }    
                            }
                        }
                    }

                    System.debug('ApprovalDate'+ApprovalDate);
                    //System.debug('PaymentMatched'+SLPaymentMatched);
                    System.debug('ExistingLoanId'+ExistingLoanId);

                    if(ExistingLoanId != '0' && ApprovalDate == true){
                            
                        System.debug('Picking existing Loan Record with LoanId 7500');    
                        result = ExistingLoanId;
                        TrackingRecord = 'IsFound';
                    }
                    else{    

                        System.debug('Going to Create New Loan record');
                    
                        SLType = '75';
                        SLBranch = '96';
                        SLCreatedAtBranch = '96';
                        SLPurposeCode = '16';
                        SLCollateralCode = '4';
                        SLApprovalCode = '9002';
                        if(sl.Loan_Amount__c != null)
                            SLOriginalBalance = string.valueOf(sl.Loan_Amount__c);
                        else
                            SLOriginalBalance = '0.00';
                        if(sl.Approval_Date__c != null){
                            SLApprovalDate = string.valueof(sl.Approval_Date__c);
                        }
                        
                        //-------------------------------------- Maturity Date------------------------------------//
                        
                        sl.Due_Date__c = System.Today() + 60;
                        
                        if(sl.Term_months__c != null){
                            SLMonth = Integer.Valueof(sl.Term_months__c) - 1;
                            sl.Maturity_Date__c = sl.Due_Date__c.addMonths(SLMonth);
                        }
                        SLMaturityDate = string.valueOf(sl.Maturity_Date__c);
                        
                        
                        SLDueDate = string.valueOf(System.Today()+ 60);
                        SLFirstPaymentDate = string.valueOf(System.Today() + 60);
                                    
                        if(sl.Due_Date__c != null){
                            SLDueDay1 = String.valueof(sl.Due_Date__c.day());
                        }
                        else{
                            SLDueDay1 = '15';
                        }
                        
                        //-------------------------------------- Payment -----------------------------------//

                        if(sl.Loan_Pmt_Amount__c != null)
                            SLPayment = string.valueof(sl.Loan_Pmt_Amount__c);
                    
                        SLCouponCode = '1';
                        SLPaymentMethod = '1';
                        SLDescription = ProductTypeDescription;
                        SLInterestRate = string.valueof(sl.Interest_Rate__c);
                        SLUserAmount1 = string.valueof(sl.Debt_Ratio__c);
                        SLECOACode = sl.ECOA_Code__c;
                        SLCreditScore = String.valueOf(sl.Primary_FICO_Score__c);
                        SLPaymentCount = String.valueOf(sl.Term_months__c);
                        SLPaymentFrequency = '04';
                        //AccountNumber = sl.Member_Number__c;
                        SLOriginalDate = string.valueOf(System.Today());
                        
                        SLApplicationFundedBy = operatorid;
                        SLApplicationLoadedBy = operatorid;
                        
                        System.debug('CreateLoan method called');
                        req12.setEndpoint(loanAPI+'/EFT/CreateLoan');
                        req12.setMethod('POST');
                        req12.setHeader('Content-Type', 'application/json');
                        req12.setHeader('Accept', 'application/json');
                        
                        jsonData12 = '{"EpisysId":'+'\"'+operatorid+'\"'+',"Description":'+'\"'+SLDescription+'\"'+',"UserChar4":' + '\"'+ SLApplicationLoadedBy +'\"'+',"UserChar3":' + '\"'+ SLApplicationFundedBy +'\"'+',"OriginalDate":' + '\"'+ SLOriginalDate +'\"'+',"Type":' + '\"'+ SLType +'\"'+',"Branch":' + '\"'+ SLBranch +'\"'+',"CreatedAtBranch":'+'\"'+ SLCreatedAtBranch +'\"'+',"PurposeCode":'+'\"' + SLPurposeCode + '\"'+',"CollateralCode":'+'\"'+SLCollateralCode+'\"'+',"ApprovalCode":'+'\"'+SLApprovalCode+'\"'+',"OriginalBalance":'+'\"'+SLOriginalBalance+'\"'+',"ApprovalDate":'+'\"'+SLApprovalDate+'\"'+',"MaturityDate":'+'\"'+SLMaturityDate+'\"'+',"DueDate":'+'\"'+SLDueDate+'\"'+',"FirstPaymentDate":'+'\"'+SLFirstPaymentDate+'\"'+',"DueDay1":'+'\"'+SLDueDay1+'\"'+',"Payment":'+'\"'+SLPayment+'\"'+',"CouponCode":'+'\"'+SLCouponCode+'\"'+',"PaymentMethod":'+'\"'+SLPaymentMethod+'\"'+',"InterestRate":'+'\"'+SLInterestRate+'\"'+',"UserAmount1":'+'\"'+SLUserAmount1+'\"'+',"ECOACode":'+'\"'+SLECOACode+'\"'+',"CreditScore":'+'\"'+SLCreditScore+'\"'+',"PaymentCount":'+'\"'+SLPaymentCount+'\"'+',"PaymentFrequency":'+'\"'+SLPaymentFrequency+'\"'+',"AccountNumber":'+'\"'+AccountNumber+'\"}';
                        req12.setBodyAsBlob(Blob.valueof(jsondata12)); 
                        system.debug('test'+jsonData12);
                        
                        req12.setTimeout(120000);
                        
                        if(!Test.isRunningTest()){                       
                            res12 = http12.send(req12);
                            responseBody12 = res12.getBody();
                            System.debug('Response Body Solar Loan::'+res12.getBody());    
                        }else{
                            responseBody12 = '{"Type":"3","Branch":"27","CreatedAtBranch":"1","PurposeCode":"1","CollateralCode":"100","ApprovalCode":"4","OriginalBalance":"1","ApprovalDate":"01-01-2019","MaturityDate":"01-01-2019","DueDate":"01-01-2019","FirstPaymentDate":"01-01-2019","DueDay1":"1","Payment":"1234","CouponCode":"123", "PaymentMethod" : "PaymentMethod", "Description" : "Description", "InterestRate" : "2.00", "UserAmount1" : "200.00", "ECOACode" : "778", "CreditScore" : "15", "PaymentCount" : "12", "PaymentFrequency" : "67"}';
                        }
                        
                        // JSon parse for Id                            
                        JSONParser parser = JSON.createParser(responseBody12);
                        result = String.valueOf(responseBody12).substringAfter('LoanId":"');
                        result = String.valueOf(result).substringBefore('",');
                        
                        System.debug('LoanId' + result);
                        if(result == null || result == ''){
                            
                            ErrorLoanLocator = String.valueOf(responseBody12).substringAfter('[MessageId=TESTING] ');
                            ErrorLoanLocator = String.valueOf(ErrorLoanLocator).substringBefore('","ErrorDetails"');
                            system.debug('ErrorLoanLocator' + ErrorLoanLocator);
                        }
                    }
                    
                    //----------------------------------------------------Create Loan Name--------------------------------------------------//

                    if(sl.Joint_SSN__c != null && TrackingRecord != 'IsFound'){
                            
                        SLType = '1';
                        SLLast = sl.Joint_Last_Name__c;
                        SLFirst = sl.Joint_First_Name__c;

                        if(sl.Joint_Address_1__c != null){
                            SLStreet = sl.Joint_Address_1__c;
                            if(SLStreet.contains('&') == true){
                                SLStreet = SLStreet.replace('&', '&#38;');
                            }
                        }
                    
                        if(sl.Joint_Address_2__c != null){
                            SLExtraAddress = sl.Joint_Address_2__c;
                            if(SLExtraAddress.contains('&') == true){
                                SLExtraAddress = SLExtraAddress.replace('&', '&#38;');
                            }
                        }

                        SLCity = sl.Joint_City__c;
                        SLState = sl.Joint_State__c;
                        SLZipCode = sl.Joint_Zip_Code__c;
                        if(sl.Joint_DOB__c != null){
                            SLBirthDate =  String.valueOf(sl.Joint_DOB__c);   
                        }
                        else{
                            SLBirthDate =  ' ';
                        }
                        
                        SLSSN = sl.Joint_SSN__c;
                    
                        if(sl.ECOA_Code__c != null){
                            SLECOACode = sl.ECOA_Code__c;
                        }
                        else{
                            SLECOACode = '0';
                        }
                    
                        LoanId = result;
                        //AccountNumber = sl.Member_Number__c;
                        
                        System.debug('CreateLoanName method called');
                        req13.setEndpoint(loanAPI+'/EFT/CreateLoanName');
                    
                        req13.setMethod('POST');
                        req13.setHeader('Content-Type', 'application/json');
                        req13.setHeader('Accept', 'application/json');
                        
                        jsonData13 = '{"EcoaCode":'+'\"'+SLECOACode+'\"'+',"Type":' + '\"'+ SLType +'\"'+',"Last":' + '\"'+ SLLast +'\"'+',"First":'+'\"'+ SLFirst +'\"'+',"Street":'+'\"' + SLStreet + '\"'+',"ExtraAddress":'+'\"'+SLExtraAddress+'\"'+',"City":'+'\"'+SLCity+'\"'+',"State":'+'\"'+SLState+'\"'+',"ZipCode":'+'\"'+SLZipCode+'\"'+',"BirthDate":'+'\"'+SLBirthDate+'\"'+',"SSN":'+'\"'+SLSSN+'\"'+',"LoanId":'+'\"'+LoanId+'\"'+',"AccountNumber":'+'\"'+AccountNumber+'\"}';
                        req13.setBodyAsBlob(Blob.valueof(jsonData13)); 
                        //system.debug('test'+jsonData13);
                        
                        Http http13 = new Http();  
                        req13.setTimeout(120000);
                        HttpResponse res13;
                        String responseBody13;
                        if(!Test.isRunningTest()){                       
                            res13 = http13.send(req13);
                            responseBody13 = res13.getBody();
                            System.debug('Response Body SolarLoan Name::'+res13.getBody());    
                        }else{
                            responseBody13 = '{"Type":"3","Last":"27","First":"1","Street":"1","ExtraAddress":"100","City":"Chicago","State":"IL","ZipCode":"0012345,"BirthDate":"01-01-2019","SSN":"1345","LoanId":"322271627","AccountNumber":"00000123456"}';
                            
                        }
                        // JSon parse for Id                            
                        JSONParser parser1 = JSON.createParser(responseBody13);
                        result1 = String.valueOf(responseBody13).substringAfter('LoanNameLocator":"');
                        result1 = String.valueOf(result1).substringBefore('",');
                        System.debug('LoanName' + result1);
                        
                        if(result1 == null || result1 == ''){
                            
                            ErrorLoanNameLocator = String.valueOf(responseBody13).substringAfter('Error",');
                            ErrorLoanNameLocator = String.valueOf(ErrorLoanNameLocator).substringBefore('","ErrorDetails"');
                            system.debug('ErrorLoanNameLocator' + ErrorLoanNameLocator);
                        }
                    }

                    //-----------------------------------------------Create Loan Tracking---------------------------------------------------//        

                    if(TrackingRecord != 'IsFound'){

                        System.debug('Creating New Tracking Record');

                        SLType = '33';
                        SLUserChar11 = sl.FNI__c;
                        
                        if(sl.Installer__c != null){
                            SLUserChar1 = sl.Installer__c;
                            if(SLUserChar1.contains('&') == true){
                                SLUserChar1 = SLUserChar1.replace('&', '&#38;');
                            }
                        }

                        SLUserChar2 = sl.Installer_Number__c;
                        SLUserChar3 = sl.Product__c;
                    
                        if(sl.Module__c != null){
                            SLUserChar4 = sl.Module__c;
                            if(SLUserChar4.contains('&') == true){
                                SLUserChar4 = SLUserChar4.replace('&', '&#38;');
                            }
                        }
                        
                        if(sl.Inverter__c != null){
                            SLUserChar5 = sl.Inverter__c;
                            if(SLUserChar5.contains('&') == true){
                                SLUserChar5 = SLUserChar5.replace('&', '&#38;');
                            }
                            if(SLUserChar5.length() > 40){
                                SLUserChar5 = SLUserChar5.left(39);
                            }
                        }
                        system.debug('UserChar5'+SLUserChar5);
                        
                        SLUserChar10 = sl.Credit_Attributes__c;
                        SLUserChar20 = sl.Site_UUID__c;
                        if(sl.Loan_Amount__c != null)
                            SLUserAmount1 = String.ValueOf(sl.Loan_Amount__c);
                        else
                            SLUserAmount1 = '0';
                            
                        if(sl.OID_Fee__c != null)   
                            SLUserAmount2 = string.ValueOF(sl.OID_Fee__c);
                        else
                            SLUserAmount2 = '0';
                            
                        if(sl.Membership_Fee__c != null)    
                            SLUserAmount3 = string.ValueOF(sl.Membership_Fee__c);
                        else
                            SLUserAmount3 = '0';
                                
                        if(sl.Mortgage_Balance__c != null)  
                            SLUserAmount11 = string.ValueOF(sl.Mortgage_Balance__c);
                        else
                            SLUserAmount11 = '0';
                            
                        if(sl.Go_To_Payment__c != null)
                            SLUserAmount12 = string.ValueOF(sl.Go_To_Payment__c);
                        else
                            SLUserAmount12 = '0';
                            
                        if(sl.Final_Payment_Amount__c != null)  
                            SLUserAmount13 = string.ValueOF(sl.Final_Payment_Amount__c);
                        else
                            SLUserAmount13 = '0';
                            
                        if(sl.ITC_Amount__c != null)    
                            SLUserAmount14 = String.ValueOF(sl.ITC_Amount__c);
                        else
                            SLUserAmount14 = '0'; 
                            
                        if(sl.Joint_FICO_Score__c != null)  
                            SLUserCode1 = string.ValueOF(sl.Joint_FICO_Score__c);
                        else
                            SLUserCode1 = '0';
                            
                        if(sl.ITC_Rate__c != null)  
                            SLUserRate1 = string.ValueOF(sl.ITC_Rate__c);
                        else
                            SLUserRate1 = '0';    
                        
                        if(sl.ACH_Discount__c == true)  
                            SLUserCode11 = '1';
                        else
                            SLUserCode11 = ' ';
                        
                        if(sl.ACH_Discount__c == true)  
                            SLUserDate11 = string.ValueOf(System.today());
                        else
                            SLUserDate11 = '';
                        
                        if(sl.Product_Loan_Type__c != null)  
                            SLUserChar6  = string.ValueOf(sl.Product_Loan_Type__c);
                        else
                            SLUserChar6  = ' ';    
                        
                        if(sl.Credit_Exception__c != null)  
                            SLUserChar7   = String.ValueOf(sl.Credit_Exception__c);
                        else
                            SLUserChar7   = null;

                        LoanId = result; 
                        //AccountNumber = sl.Member_Number__c;
                        
                        System.debug('CreateLoanTracking method called');
                        req14.setEndpoint(loanAPI+'/EFT/CreateLoanTracking');
                    
                        req14.setMethod('POST');
                        req14.setHeader('Content-Type', 'application/json');
                        req14.setHeader('Accept', 'application/json');
                        
                        jsonData14 = '{"EpisysId":'+'\"'+operatorid+'\"'+',"UserChar6":' + '\"'+ SLUserChar6 +'\"'+',"UserChar7":' + '\"'+ SLUserChar7 +'\"'+',"UserCode11":' + '\"'+ SLUserCode11 +'\"'+',"UserDate11":' + '\"'+ SLUserDate11 +'\"'+',"Type":' + '\"'+ SLType +'\"'+',"UserChar11":' + '\"'+ SLUserChar11 +'\"'+',"UserChar1":'+'\"'+ SLUserChar1 +'\"'+',"UserChar2":'+'\"' + SLUserChar2 + '\"'+',"UserChar3":'+'\"'+SLUserChar3+'\"'+',"UserChar4":'+'\"'+SLUserChar4+'\"'+',"UserChar5":'+'\"'+SLUserChar5+'\"'+',"UserAmount14":'+'\"'+SLUserAmount14+'\"'+',"UserRate1":'+'\"'+SLUserRate1+'\"'+',"UserChar10":'+'\"'+SLUserChar10+'\"'+',"UserChar20":'+'\"'+SLUserChar20+'\"'+',"UserAmount1":'+'\"'+SLUserAmount1+'\"'+',"UserAmount2":'+'\"'+SLUserAmount2+'\"'+',"UserAmount3":'+'\"'+SLUserAmount3+'\"'+',"UserAmount11":'+'\"'+SLUserAmount11+'\"'+',"UserAmount12":'+'\"'+SLUserAmount12+'\"'+',"UserAmount13":'+'\"'+SLUserAmount13+'\"'+',"UserCode1":'+'\"'+SLUserCode1+'\"'+',"UserRate1":'+'\"'+SLUserRate1+'\"'+',"LoanId":'+'\"'+LoanId+'\"'+',"AccountNumber":'+'\"'+AccountNumber+'\"}';
                        req14.setBodyAsBlob(Blob.valueof(jsondata14)); 
                        system.debug('test'+jsonData14);
                        
                        req14.setTimeout(120000);
                    
                        if(!Test.isRunningTest()){                       
                            res14 = http14.send(req14);
                            responseBody14 = res14.getBody();
                            System.debug('Response Body SolarLoan Tracking::'+res14.getBody());    
                        }else{
                            responseBody14 = '{"Type":"3","UserChar11":"27","UserChar1":"1","UserChar2":"1","UserChar3":"100","UserChar4":"4","UserChar5":"1","UserChar10":"01-01-2019","UserChar20":"01-01-2019","UserAmount1":"100.00","UserAmount2":"322271627","UserAmount3":"42006986568","UserAmount11":"BANK OF AMERICA","UserAmount12":"123","UserAmount13" : "UserAmount13","UserCode1" : "UserCode1", "LoanId" : "LoanId", "AccountNumber" : "AccountNumber"}';
                        }
                        // JSon parse for Id                            
                        JSONParser parser2 = JSON.createParser(responseBody14);
                        result2 = String.valueOf(responseBody14).substringAfter('LoanTrackingLocator":"');
                        result2 = String.valueOf(result2).substringBefore('",');
                        System.debug('LoanName Tracking' + result2);
                        
                        if(result2 == null || result2 == ''){
                                
                            ErrorLoanTrackingLocator = String.valueOf(responseBody14).substringAfter('Error",');
                            ErrorLoanTrackingLocator = String.valueOf(ErrorLoanTrackingLocator).substringBefore('","ErrorDetails"');
                            system.debug('ErrorLoanTrackingLocator' + ErrorLoanTrackingLocator);
                        }
                    }
                    else{
                        System.debug('No need to create New Tracking Record');
                    }

                    //----------------------------------------------------Creat Loan Funding-------------------------------------------------//

                    system.debug('result2: '+result2);
                    system.debug('result: '+result);

                    if(result2 != null && result != null){
                            
                        LoanId = result;
                        
                        if(sl.Loan_Amount__c != null)
                            SLAmount = Integer.valueOf(sl.Loan_Amount__c);
                        else
                            SLAmount = 0;
                            
                        //AccountNumber = sl.Member_Number__c;
                        
                        System.debug('Funding method called');
                        req15.setEndpoint(loanAPI+'/Wires/FundLoan?accountNumber='+AccountNumber+'&loanId='+LoanId+'&amount='+SLAmount);
                        
                        req15.setMethod('GET');
                        req15.setHeader('Content-Type', 'application/json');
                        req15.setHeader('Accept', 'application/json');
                        
                        system.debug('test'+req15);
                        
                        req15.setTimeout(120000);
                        
                        if(!Test.isRunningTest()){                       
                            res15 = http15.send(req15);
                            responseBody15 = res15.getBody();
                            System.debug('Response Body for Fund::'+res15.getBody());    
                        }else{
                            responseBody15 = '{"Type":"3","Last":"27","First":"1","Street":"1","ExtraAddress":"100","City":"Chicago","State":"IL","ZipCode":"0012345,"BirthDate":"01-01-2019","SSN":"1345","LoanId":"322271627","AccountNumber":"00000123456"}';
                            
                        }
                    } 

                    //-------------------------------------------------Updating Solar Loan records -----------------------------------------//

                    Solar_Loans__c s = new Solar_Loans__c();          
                    if(result != null && result != '')
                        s.Loan_Id__c = result;
                       
                    system.debug('result1: '+result1);    
                    if(result1 != null && result1 != '')    
                        s.Loan_Name_Locator__c = result1;
                        
                    if((result2 != null && result2 != '') || (TrackingRecord == 'IsFound'))
                        s.Tracking_Record_33__c = 'Created';

                    if(s.Loan_Id__c != null || s.Loan_Name_Locator__c != null || s.Tracking_Record_33__c != null ){
                        s.Status__c = 'Loan Funded';
                        s.Current_Solar_Loan_Stage__c = 'Stage 4';
                    }    
                        
                    if(ErrorLoanLocator != null && ErrorLoanLocator != '')
                        s.Error_Loan_Locator__c = ErrorLoanLocator;
                    else
                        s.Error_Loan_Locator__c = '';
                        
                    if(ErrorLoanNameLocator != null && ErrorLoanNameLocator != '')
                        s.Error_Loan_Name_Locator__c = ErrorLoanNameLocator;
                    else
                        s.Error_Loan_Name_Locator__c = '';
                            
                    if(ErrorLoanTrackingLocator != null && ErrorLoanTrackingLocator != '')
                        s.Error_Loan_Tracking_Locator__c = ErrorLoanTrackingLocator;
                    else
                        s.Error_Loan_Tracking_Locator__c = '';
                    
                                
                    s.id = sl.Id;       
                    s.Due_Date__c = System.Today() + 60;
                    s.continue__c = false;
                    
                    if(sl.Term_months__c != null){
                        SLMonth = Integer.Valueof(sl.Term_months__c) - 1;
                        s.Maturity_Date__c = s.Due_Date__c.addMonths(SLMonth);
                    }
                    
                    if(s.Member_Number__c == null)
                        s.Member_Number__c = AccountNumber;

                    s.Episys_Membership__c = 'Membership already exists, new membership not created';
                    system.debug('s.Maturity_Date__c'+s.Maturity_Date__c);
                    SolarLoanToUpdate.add(s);
                }
                else{

                    Solar_Loans__c s = new Solar_Loans__c();
                    s.id = sl.Id;       
                    s.Error_Loan_Locator__c = 'There are multiple membership accounts';
                    
                    SolarLoanToUpdate.add(s);

                }
                
            }
            else{    
                
                System.debug('Creating New Membership Account');
                
                //----------------------------------------------------Creating Membership Account ---------------------------------------//

                BRANCH = '299';
                CREATEDATBRANCH = '299';
                CREATEDBYUSER = operatorid;
                MEMBERGROUP = '6161';
                REFERENCE = 'BC02';
                RELATIONSHIPCODE = '20';
                RELATIONSHIPOVERRIDE = '20';
                TYPE = '1';
                WARNINGCODE = '3';
                WARNINGEXPIRATION = string.valueOf(System.Today()+ 30);

                if(sl.mem_Primary_DOB__c != null)
                    BIRTHDATE = string.valueOf(sl.mem_Primary_DOB__c);
                else
                    BIRTHDATE = '';

                if(sl.mem_Primary_City__c != null)
                    CITY = string.valueOf(sl.mem_Primary_City__c).toUpperCase();    
                else
                    CITY = '';

                if(sl.Primary_Email__c != null)
                    EMAIL = string.valueOf(sl.Primary_Email__c);    
                else
                    EMAIL = '';

                if(sl.Employer__c != null){
                    
                    EMPLOYERNAME = string.valueOf(sl.Employer__c).toUpperCase();    
                    if(EMPLOYERNAME.contains('&') == true){
                        EMPLOYERNAME = EMPLOYERNAME.replace('&', '&#38;');
                    }
                }
                    
                else
                    EMPLOYERNAME = '';

                    
                if(sl.mem_Primary_Extra_Address__c != null)
                    EXTRAADDRESS = string.valueOf(sl.mem_Primary_Extra_Address__c).toUpperCase(); 
                else
                    EXTRAADDRESS = '';

                if(sl.mem_Primary_First_Name__c != null)
                    FIRST = string.valueOf(sl.mem_Primary_First_Name__c).toUpperCase();
                else
                    FIRST = '';

                if(sl.Primary_Home_Phone__c != null)
                    HOMEPHONE = string.valueOf(sl.Primary_Home_Phone__c);
                else
                    HOMEPHONE = '';       

                IDENTDOCFLAG = 1;
                IDENTDOCFLAG3 = 0;

                if(sl.mem_ID_State__c != null)
                    IDENTIDDESCRIPTION = string.valueOf(sl.mem_ID_State__c).toUpperCase();
                else
                    IDENTIDDESCRIPTION = '';

                if((sl.mem_Primary_Foreign_Gov_t_Position__c == null || sl.mem_Primary_Foreign_Gov_t_Position__c == '') &&
                    (sl.mem_Primary_A_F_Foreign_Gov_t_Position__c == null || sl.mem_Primary_A_F_Foreign_Gov_t_Position__c == '')){
                        
                    IDENTIDDESCRIPTION3 = '';
                }
                else if((sl.mem_Primary_Foreign_Gov_t_Position__c == 'Yes' || sl.mem_Primary_Foreign_Gov_t_Position__c == 'yes') &&
                    (sl.mem_Primary_A_F_Foreign_Gov_t_Position__c == 'Yes' || sl.mem_Primary_A_F_Foreign_Gov_t_Position__c == 'yes')){
                        
                    IDENTIDDESCRIPTION3 = 'Y Y';
                }
                else if((sl.mem_Primary_Foreign_Gov_t_Position__c == 'No' || sl.mem_Primary_Foreign_Gov_t_Position__c == 'no') &&
                    (sl.mem_Primary_A_F_Foreign_Gov_t_Position__c == 'Yes' || sl.mem_Primary_A_F_Foreign_Gov_t_Position__c == 'yes')){
                        
                    IDENTIDDESCRIPTION3 = 'N Y';
                }
                else if((sl.mem_Primary_Foreign_Gov_t_Position__c == 'Yes' || sl.mem_Primary_Foreign_Gov_t_Position__c == 'yes') &&
                    (sl.mem_Primary_A_F_Foreign_Gov_t_Position__c == 'No' || sl.mem_Primary_A_F_Foreign_Gov_t_Position__c == 'no')){
                        
                    IDENTIDDESCRIPTION3 = 'Y N';
                }
                else if((sl.mem_Primary_Foreign_Gov_t_Position__c == 'No' || sl.mem_Primary_Foreign_Gov_t_Position__c == 'no') &&
                    (sl.mem_Primary_A_F_Foreign_Gov_t_Position__c == 'No' || sl.mem_Primary_A_F_Foreign_Gov_t_Position__c == 'no')){
                        
                    IDENTIDDESCRIPTION3 = 'N N';
                }

                if(sl.mem_ID_Expiration_Date__c != null)
                    IDENTIDEXPIREDATE = string.valueOf(sl.mem_ID_Expiration_Date__c);
                else
                    IDENTIDEXPIREDATE = '';

                if(sl.mem_ID_Issue_Date__c != null)
                    IDENTIDISSUEDATE = string.valueOf(sl.mem_ID_Issue_Date__c); 
                else
                    IDENTIDISSUEDATE = '';

                if(sl.mem_ID_Number__c!= null)
                    IDENTIDNUMBER = string.valueOf(sl.mem_ID_Number__c).toUpperCase();
                else
                    IDENTIDNUMBER = '';
            
                if(sl.mem_ID_Type__c == 'DL (DMV)')
                    IDENTIDTYPE = 2;
                else if(sl.mem_ID_Type__c == 'Passport')
                    IDENTIDTYPE = 4;
                else if(sl.mem_ID_Type__c == 'Military ID')
                    IDENTIDTYPE = 6;
                else
                    IDENTIDTYPE = 0;

                if(sl.mem_Primary_Last_Name__c	 != null)
                    LAST = string.valueOf(sl.mem_Primary_Last_Name__c).toUpperCase();
                else
                    LAST = '';

                if(sl.Primary_Middle_Initial__c != null)
                    MIDDLE = string.valueOf(sl.Primary_Middle_Initial__c).toUpperCase();
                else
                    MIDDLE = '';

                if(sl.Primary_Cell_Phone__c != null)
                    MOBILEPHONE = string.valueOf(sl.Primary_Cell_Phone__c);
                else
                    MOBILEPHONE = '';

                if(sl.mem_Maiden_Name__c != null)
                    MOTHERSMAIDENNAME = string.valueOf(sl.mem_Maiden_Name__c).toUpperCase();
                else
                    MOTHERSMAIDENNAME = '';

                if(MOTHERSMAIDENNAME.length() > 20){
                    MOTHERSMAIDENNAME = MOTHERSMAIDENNAME.substring(0,20);
                }    

                if(sl.Occupation__c != null)
                    OCCUPATION = string.valueOf(sl.Occupation__c).toUpperCase();
                else
                    OCCUPATION = '';

                if(sl.mem_Primary_SSN__c	 != null)
                    SSN = string.valueOf(sl.mem_Primary_SSN__c);

                if(sl.mem_Primary_State__c	 != null)
                    STATE = string.valueOf(sl.mem_Primary_State__c).toUpperCase();
                else
                    STATE = '';

                if(sl.mem_Primary_Street__c	 != null)
                    STREET = string.valueOf(sl.mem_Primary_Street__c).toUpperCase();    
                else
                    STREET = '';

                SUFFIX = ' ';

                if(sl.Primary_Work_Phone__c != null)
                    WORKPHONE = string.valueOf(sl.Primary_Work_Phone__c);
                else
                    WORKPHONE = '';

                if(sl.mem_Primary_Zip_Code__c != null)
                    ZIPCODE = string.valueOf(sl.mem_Primary_Zip_Code__c);
                else
                    ZIPCODE = '';


                LASTACCESSCHANGEDATE = String.valueof(System.Today());
                AUDIOACCESS = '1234'; 
                LASTHBPWCHANGEDATE = String.valueof(System.Today());
                HBPASSWORD = string.valueOf(sl.mem_Primary_SSN__c);
                AUDIOENABLE = '2';
                HBENABLE = '2';

                PRIMARYUSERCHAR1 = '6161-'+string.valueOf(sl.name).toUpperCase();
                System.debug('PRIMARYUSERCHAR1: '+ PRIMARYUSERCHAR1);
                AccountNumber = sl.Member_Number__c;

                if(AccountNumber == null || AccountNumber == '')
                    AccountNumber = '';

                System.debug('----------------------------Calling createAccount method-----------------------------');
                req2.setEndpoint(loanAPI+'/SolarLoan/CreateAccount');
                req2.setMethod('POST');
                req2.setHeader('Content-Type', 'application/json');
                req2.setHeader('Accept', 'application/json');
                
                jsonData2 = '{"Userchar1":' + '\"'+ PRIMARYUSERCHAR1 +'\"'+',"WarningCode1":'+'\"'+WARNINGCODE+'\"'+',"WarningExpiration1":'+'\"'+WARNINGEXPIRATION+'\"'+',"Number":'+'\"'+AccountNumber+'\"'+',"Type":"0","IdentIdType":'+'\"'+IDENTIDTYPE+'\"'+',"IdentIdNumber":'+'\"'+IDENTIDNUMBER+'\"'+',"IdentIdIssueDate":'+'\"'+IDENTIDISSUEDATE+'\"'+',"IdentIdExpireDate":'+'\"'+IDENTIDEXPIREDATE+'\"'+',"IdentIdDescription":'+'\"'+IDENTIDDESCRIPTION+'\"'+',"IdentIdDescription3":'+'\"'+IDENTIDDESCRIPTION3+'\"'+',"IdentDocFlag":'+'\"'+IDENTDOCFLAG+'\"'+',"IdentDocFlag3":'+'\"'+IDENTDOCFLAG3+'\"'+',"Branch":' + '\"'+ BRANCH +'\"'+',"CreatedAtBranch":' + '\"'+ CREATEDATBRANCH +'\"'+',"CreatedByUser":' + '\"'+ CREATEDBYUSER +'\"'+',"MemberGroup":' + '\"'+ MEMBERGROUP +'\"'+',"Reference":' + '\"'+ REFERENCE +'\"'+',"RelationshipCode":' + '\"'+ RELATIONSHIPCODE +'\"'+',"RelationshipOverride":' + '\"'+ RELATIONSHIPOVERRIDE +'\"'+',"Type":' + '\"'+ TYPE +'\"'+',"Email":' + '\"'+ EMAIL +'\"'+',"BirthDate":' + '\"'+ BIRTHDATE +'\"'+',"City":' + '\"'+ CITY +'\"'+',"EmployerName":' + '\"'+ EMPLOYERNAME +'\"'+',"ExtraAddress":' + '\"'+ EXTRAADDRESS +'\"'+',"First":' + '\"'+ FIRST +'\"'+',"HomePhone":' + '\"'+ HOMEPHONE +'\"'+',"Last":' + '\"'+ LAST +'\"'+',"Middle":' + '\"'+ MIDDLE +'\"'+',"MobilePhone":' + '\"'+ MOBILEPHONE +'\"'+',"MothersMaidenName":' + '\"'+ MOTHERSMAIDENNAME +'\"'+',"Occupation":' + '\"'+ OCCUPATION +'\"'+',"Ssn":' + '\"'+ SSN +'\"'+',"State":' + '\"'+ STATE +'\"'+',"Street":' + '\"'+ STREET +'\"'+',"Suffix":' + '\"'+ SUFFIX +'\"'+',"WorkPhone":' + '\"'+ WORKPHONE +'\"'+',"HBENABLE":' + '\"'+ HBENABLE +'\"'+',"AUDIOENABLE":' + '\"'+ AUDIOENABLE +'\"'+',"HBPASSWORD":' + '\"'+ HBPASSWORD +'\"'+',"LASTHBPWCHANGEDATE":' + '\"'+ LASTHBPWCHANGEDATE +'\"'+',"AUDIOACCESS":' + '\"'+ AUDIOACCESS +'\"'+',"LASTACCESSCHANGEDATE":' + '\"'+ LASTACCESSCHANGEDATE +'\"'+',"ZipCode":' + '\"'+ ZIPCODE +'\"}';

                req2.setBodyAsBlob(Blob.valueof(jsondata2)); 
                system.debug('test'+jsonData2);
                
                Http http2 = new Http();  
                req2.setTimeout(120000);
                HttpResponse res2;
                
                if(!Test.isRunningTest()){                       
                    res2 = http2.send(req2);
                    responseBody2 = res2.getBody();
                    System.debug('CreateAccount Response::'+res2.getBody());    
                }else{
                    responseBody2 = '{"Type":"3","PaymentFrequency" : "67"}';
                }
                
                if(logs == null)
                    logs = responseBody2;
                else
                    logs = logs +'\n'+ responseBody2;
                
                    if(responseBody2 != '' && responseBody2 != null){        
                    Map<String,Object> results = (Map<String,Object>) JSON.deserializeUntyped(responseBody2);
                    System.debug('Response is ....' + results);
                    
                    if(results.size() > 0){
                        for(String l : results.keyset()) {
                            if(l == 'AccountNumber'){
                                AccountNumber = String.valueOf(results.get(l));
                            }
                            if(l == 'Status'){
                                MembershipccountStatus = String.valueOf(results.get(l));
                            }
                        }    
                    }
                }

                System.debug('MembershipccountStatus: '+MembershipccountStatus);
                System.debug('AccountNumber: '+AccountNumber);
               
                //---------------------------------------------------Creating Solar Loan------------------------------------------------//

                System.debug('Going to Create New Loan record');

                SLType = '75';
                SLBranch = '96';
                CreatedAtBranch = '96';
                SLPurposeCode = '16';
                SLCollateralCode = '4';
                SLApprovalCode = '9002';
                if(sl.Loan_Amount__c != null)
                    SLOriginalBalance = string.valueOf(sl.Loan_Amount__c);
                else
                    SLOriginalBalance = '0.00';
                if(sl.Approval_Date__c != null){
                    SLApprovalDate = string.valueof(sl.Approval_Date__c);
                }
                
                //-------------------------------------- Maturity Date------------------------------------//
                
                sl.Due_Date__c = System.Today() + 60;
                
                if(sl.Term_months__c != null){
                    SLMonth = Integer.Valueof(sl.Term_months__c) - 1;
                    sl.Maturity_Date__c = sl.Due_Date__c.addMonths(SLMonth);
                }
                SLMaturityDate = string.valueOf(sl.Maturity_Date__c);
                
                
                SLDueDate = string.valueOf(System.Today()+ 60);
                SLFirstPaymentDate = string.valueOf(System.Today() + 60);
                            
                if(sl.Due_Date__c != null){
                    SLDueDay1 = String.valueof(sl.Due_Date__c.day());
                }
                else{
                    SLDueDay1 = '15';
                }
                
                //-------------------------------------- Payment -----------------------------------//

                if(sl.Loan_Pmt_Amount__c != null)
                    SLPayment = string.valueof(sl.Loan_Pmt_Amount__c);
            
                SLCouponCode = '1';
                SLPaymentMethod = '1';
                SLDescription = ProductTypeDescription;
                SLInterestRate = string.valueof(sl.Interest_Rate__c);
                SLUserAmount1 = string.valueof(sl.Debt_Ratio__c);
                SLECOACode = sl.ECOA_Code__c;
                SLCreditScore = String.valueOf(sl.Primary_FICO_Score__c);
                SLPaymentCount = String.valueOf(sl.Term_months__c);
                SLPaymentFrequency = '04';
                //AccountNumber = sl.Member_Number__c;
                SLOriginalDate = string.valueOf(System.Today());
                
                SLApplicationFundedBy = operatorid;
                SLApplicationLoadedBy = operatorid;
                
                System.debug('CreateLoan method called');
                req12.setEndpoint(loanAPI+'/EFT/CreateLoan');
                req12.setMethod('POST');
                req12.setHeader('Content-Type', 'application/json');
                req12.setHeader('Accept', 'application/json');
                
                jsonData12 = '{"EpisysId":'+'\"'+operatorid+'\"'+',"Description":'+'\"'+SLDescription+'\"'+',"UserChar4":' + '\"'+ SLApplicationLoadedBy +'\"'+',"UserChar3":' + '\"'+ SLApplicationFundedBy +'\"'+',"OriginalDate":' + '\"'+ SLOriginalDate +'\"'+',"Type":' + '\"'+ SLType +'\"'+',"Branch":' + '\"'+ SLBranch +'\"'+',"CreatedAtBranch":'+'\"'+ SLCreatedAtBranch +'\"'+',"PurposeCode":'+'\"' + SLPurposeCode + '\"'+',"CollateralCode":'+'\"'+SLCollateralCode+'\"'+',"ApprovalCode":'+'\"'+SLApprovalCode+'\"'+',"OriginalBalance":'+'\"'+SLOriginalBalance+'\"'+',"ApprovalDate":'+'\"'+SLApprovalDate+'\"'+',"MaturityDate":'+'\"'+SLMaturityDate+'\"'+',"DueDate":'+'\"'+SLDueDate+'\"'+',"FirstPaymentDate":'+'\"'+SLFirstPaymentDate+'\"'+',"DueDay1":'+'\"'+SLDueDay1+'\"'+',"Payment":'+'\"'+SLPayment+'\"'+',"CouponCode":'+'\"'+SLCouponCode+'\"'+',"PaymentMethod":'+'\"'+SLPaymentMethod+'\"'+',"InterestRate":'+'\"'+SLInterestRate+'\"'+',"UserAmount1":'+'\"'+SLUserAmount1+'\"'+',"ECOACode":'+'\"'+SLECOACode+'\"'+',"CreditScore":'+'\"'+SLCreditScore+'\"'+',"PaymentCount":'+'\"'+SLPaymentCount+'\"'+',"PaymentFrequency":'+'\"'+SLPaymentFrequency+'\"'+',"AccountNumber":'+'\"'+AccountNumber+'\"}';
                req12.setBodyAsBlob(Blob.valueof(jsondata12)); 
                system.debug('test'+jsonData12);
                
                req12.setTimeout(120000);
                
                if(!Test.isRunningTest()){                       
                    res12 = http12.send(req12);
                    responseBody12 = res12.getBody();
                    System.debug('Response Body Solar Loan::'+res12.getBody());    
                }else{
                    responseBody12 = '{"Type":"3","Branch":"27","CreatedAtBranch":"1","PurposeCode":"1","CollateralCode":"100","ApprovalCode":"4","OriginalBalance":"1","ApprovalDate":"01-01-2019","MaturityDate":"01-01-2019","DueDate":"01-01-2019","FirstPaymentDate":"01-01-2019","DueDay1":"1","Payment":"1234","CouponCode":"123", "PaymentMethod" : "PaymentMethod", "Description" : "Description", "InterestRate" : "2.00", "UserAmount1" : "200.00", "ECOACode" : "778", "CreditScore" : "15", "PaymentCount" : "12", "PaymentFrequency" : "67"}';
                }
                
                // JSon parse for Id                            

                if(logs == null)
                    logs = responseBody12;
                else
                    logs = logs +'\n'+ responseBody12;

                JSONParser parser = JSON.createParser(responseBody12);
                result = String.valueOf(responseBody12).substringAfter('LoanId":"');
                result = String.valueOf(result).substringBefore('",');
                
                System.debug('LoanId' + result);
                if(result == null || result == ''){
                    
                    ErrorLoanLocator = String.valueOf(responseBody12).substringAfter('[MessageId=TESTING] ');
                    ErrorLoanLocator = String.valueOf(ErrorLoanLocator).substringBefore('","ErrorDetails"');
                    system.debug('ErrorLoanLocator' + ErrorLoanLocator);
                }

                //----------------------------------------------------Create Loan Name--------------------------------------------------//

                if(sl.Joint_SSN__c != null){
                        
                    SLType = '1';
                    SLLast = sl.Joint_Last_Name__c;
                    SLFirst = sl.Joint_First_Name__c;

                    if(sl.Joint_Address_1__c != null){
                        SLStreet = sl.Joint_Address_1__c;
                        if(SLStreet.contains('&') == true){
                            SLStreet = SLStreet.replace('&', '&#38;');
                        }
                    }
                
                    if(sl.Joint_Address_2__c != null){
                        SLExtraAddress = sl.Joint_Address_2__c;
                        if(SLExtraAddress.contains('&') == true){
                            SLExtraAddress = SLExtraAddress.replace('&', '&#38;');
                        }
                    }

                    SLCity = sl.Joint_City__c;
                    SLState = sl.Joint_State__c;
                    SLZipCode = sl.Joint_Zip_Code__c;
                    if(sl.Joint_DOB__c != null){
                        SLBirthDate =  String.valueOf(sl.Joint_DOB__c);   
                    }
                    else{
                        SLBirthDate =  ' ';
                    }
                    
                    SLSSN = sl.Joint_SSN__c;
                
                    if(sl.ECOA_Code__c != null){
                        SLECOACode = sl.ECOA_Code__c;
                    }
                    else{
                        SLECOACode = '0';
                    }
                
                    LoanId = result;
                    //AccountNumber = sl.Member_Number__c;
                    
                    System.debug('CreateLoanName method called');
                    req13.setEndpoint(loanAPI+'/EFT/CreateLoanName');
                
                    req13.setMethod('POST');
                    req13.setHeader('Content-Type', 'application/json');
                    req13.setHeader('Accept', 'application/json');
                    
                    jsonData13 = '{"EcoaCode":'+'\"'+SLECOACode+'\"'+',"Type":' + '\"'+ SLType +'\"'+',"Last":' + '\"'+ SLLast +'\"'+',"First":'+'\"'+ SLFirst +'\"'+',"Street":'+'\"' + SLStreet + '\"'+',"ExtraAddress":'+'\"'+SLExtraAddress+'\"'+',"City":'+'\"'+SLCity+'\"'+',"State":'+'\"'+SLState+'\"'+',"ZipCode":'+'\"'+SLZipCode+'\"'+',"BirthDate":'+'\"'+SLBirthDate+'\"'+',"SSN":'+'\"'+SLSSN+'\"'+',"LoanId":'+'\"'+LoanId+'\"'+',"AccountNumber":'+'\"'+AccountNumber+'\"}';
                    req13.setBodyAsBlob(Blob.valueof(jsondata13)); 
                    system.debug('test'+jsonData13);
                    
                    Http http13 = new Http();  
                    req13.setTimeout(120000);
                    HttpResponse res13;
                    String responseBody13;
                    if(!Test.isRunningTest()){                       
                        res13 = http13.send(req13);
                        responseBody13 = res13.getBody();
                        System.debug('Response Body SolarLoan Name::'+res13.getBody());    
                    }else{
                        responseBody13 = '{"Type":"3","Last":"27","First":"1","Street":"1","ExtraAddress":"100","City":"Chicago","State":"IL","ZipCode":"0012345,"BirthDate":"01-01-2019","SSN":"1345","LoanId":"322271627","AccountNumber":"00000123456"}';
                        
                    }
                    // JSon parse for Id                            
                    JSONParser parser1 = JSON.createParser(responseBody13);
                    result1 = String.valueOf(responseBody13).substringAfter('LoanNameLocator":"');
                    result1 = String.valueOf(result1).substringBefore('",');
                    System.debug('LoanName' + result1);
                    
                    if(logs == null)
                        logs = responseBody13;
                    else
                        logs = logs +'\n'+ responseBody13;

                    if(result1 == null || result1 == ''){
                        
                        ErrorLoanNameLocator = String.valueOf(responseBody13).substringAfter('Error",');
                        ErrorLoanNameLocator = String.valueOf(ErrorLoanNameLocator).substringBefore('","ErrorDetails"');
                        system.debug('ErrorLoanNameLocator' + ErrorLoanNameLocator);
                    }
                }
                
                //-----------------------------------------------Create Loan Tracking---------------------------------------------------//        

                System.debug('Creating New Tracking Record');

                SLType = '33';
                SLUserChar11 = sl.FNI__c;
                
                if(sl.Installer__c != null){
                    SLUserChar1 = sl.Installer__c;
                    if(SLUserChar1.contains('&') == true){
                        SLUserChar1 = SLUserChar1.replace('&', '&#38;');
                    }
                }

                SLUserChar2 = sl.Installer_Number__c;
                SLUserChar3 = sl.Product__c;
            
                if(sl.Module__c != null){
                    SLUserChar4 = sl.Module__c;
                    if(SLUserChar4.contains('&') == true){
                        SLUserChar4 = SLUserChar4.replace('&', '&#38;');
                    }
                }
                
                if(sl.Inverter__c != null){
                    SLUserChar5 = sl.Inverter__c;
                    if(SLUserChar5.contains('&') == true){
                        SLUserChar5 = SLUserChar5.replace('&', '&#38;');
                    }
                    if(SLUserChar5.length() > 40){
                        SLUserChar5 = SLUserChar5.left(39);
                    }
                }
                system.debug('UserChar5'+SLUserChar5);
                
                SLUserChar10 = sl.Credit_Attributes__c;
                SLUserChar20 = sl.Site_UUID__c;
                if(sl.Loan_Amount__c != null)
                    SLUserAmount1 = String.ValueOf(sl.Loan_Amount__c);
                else
                    SLUserAmount1 = '0';
                    
                if(sl.OID_Fee__c != null)   
                    SLUserAmount2 = string.ValueOF(sl.OID_Fee__c);
                else
                    SLUserAmount2 = '0';
                    
                if(sl.Membership_Fee__c != null)    
                    SLUserAmount3 = string.ValueOF(sl.Membership_Fee__c);
                else
                    SLUserAmount3 = '0';
                        
                if(sl.Mortgage_Balance__c != null)  
                    SLUserAmount11 = string.ValueOF(sl.Mortgage_Balance__c);
                else
                    SLUserAmount11 = '0';
                    
                if(sl.Go_To_Payment__c != null)
                    SLUserAmount12 = string.ValueOF(sl.Go_To_Payment__c);
                else
                    SLUserAmount12 = '0';
                    
                if(sl.Final_Payment_Amount__c != null)  
                    SLUserAmount13 = string.ValueOF(sl.Final_Payment_Amount__c);
                else
                    SLUserAmount13 = '0';
                    
                if(sl.ITC_Amount__c != null)    
                    SLUserAmount14 = String.ValueOF(sl.ITC_Amount__c);
                else
                    SLUserAmount14 = '0'; 
                    
                if(sl.Joint_FICO_Score__c != null)  
                    SLUserCode1 = string.ValueOF(sl.Joint_FICO_Score__c);
                else
                    SLUserCode1 = '0';
                    
                if(sl.ITC_Rate__c != null)  
                    SLUserRate1 = string.ValueOF(sl.ITC_Rate__c);
                else
                    SLUserRate1 = '0';    
                
                if(sl.ACH_Discount__c == true)  
                    SLUserCode11 = '1';
                else
                    SLUserCode11 = ' ';
                
                if(sl.ACH_Discount__c == true)  
                    SLUserDate11 = string.ValueOf(System.today());
                else
                    SLUserDate11 = '';
                
                if(sl.Product_Loan_Type__c != null)  
                    SLUserChar6  = string.ValueOf(sl.Product_Loan_Type__c);
                else
                    SLUserChar6  = ' ';    
                
                if(sl.Credit_Exception__c != null)  
                    SLUserChar7   = String.ValueOf(sl.Credit_Exception__c);
                else
                    SLUserChar7   = null;

                LoanId = result; 
                //AccountNumber = sl.Member_Number__c;
                
                System.debug('CreateLoanTracking method called');
                req14.setEndpoint(loanAPI+'/EFT/CreateLoanTracking');
                
                req14.setMethod('POST');
                req14.setHeader('Content-Type', 'application/json');
                req14.setHeader('Accept', 'application/json');
                
                jsonData14 = '{"EpisysId":'+'\"'+operatorid+'\"'+',"UserChar6":' + '\"'+ SLUserChar6 +'\"'+',"UserChar7":' + '\"'+ SLUserChar7 +'\"'+',"UserCode11":' + '\"'+ SLUserCode11 +'\"'+',"UserDate11":' + '\"'+ SLUserDate11 +'\"'+',"Type":' + '\"'+ SLType +'\"'+',"UserChar11":' + '\"'+ SLUserChar11 +'\"'+',"UserChar1":'+'\"'+ SLUserChar1 +'\"'+',"UserChar2":'+'\"' + SLUserChar2 + '\"'+',"UserChar3":'+'\"'+SLUserChar3+'\"'+',"UserChar4":'+'\"'+SLUserChar4+'\"'+',"UserChar5":'+'\"'+SLUserChar5+'\"'+',"UserAmount14":'+'\"'+SLUserAmount14+'\"'+',"UserRate1":'+'\"'+SLUserRate1+'\"'+',"UserChar10":'+'\"'+SLUserChar10+'\"'+',"UserChar20":'+'\"'+SLUserChar20+'\"'+',"UserAmount1":'+'\"'+SLUserAmount1+'\"'+',"UserAmount2":'+'\"'+SLUserAmount2+'\"'+',"UserAmount3":'+'\"'+SLUserAmount3+'\"'+',"UserAmount11":'+'\"'+SLUserAmount11+'\"'+',"UserAmount12":'+'\"'+SLUserAmount12+'\"'+',"UserAmount13":'+'\"'+SLUserAmount13+'\"'+',"UserCode1":'+'\"'+SLUserCode1+'\"'+',"UserRate1":'+'\"'+SLUserRate1+'\"'+',"LoanId":'+'\"'+LoanId+'\"'+',"AccountNumber":'+'\"'+AccountNumber+'\"}';
                req14.setBodyAsBlob(Blob.valueof(jsondata14)); 
                system.debug('test'+jsonData14);
                
                req14.setTimeout(120000);
                
                if(!Test.isRunningTest()){                       
                    res14 = http14.send(req14);
                    responseBody14 = res14.getBody();
                    System.debug('Response Body SolarLoan Tracking::'+res14.getBody());    
                }else{
                    responseBody14 = '{"Type":"3","UserChar11":"27","UserChar1":"1","UserChar2":"1","UserChar3":"100","UserChar4":"4","UserChar5":"1","UserChar10":"01-01-2019","UserChar20":"01-01-2019","UserAmount1":"100.00","UserAmount2":"322271627","UserAmount3":"42006986568","UserAmount11":"BANK OF AMERICA","UserAmount12":"123","UserAmount13" : "UserAmount13","UserCode1" : "UserCode1", "LoanId" : "LoanId", "AccountNumber" : "AccountNumber"}';
                }
                // JSon parse for Id                            

                if(logs == null)
                    logs = responseBody14;
                else
                    logs = logs +'\n'+ responseBody14;

                JSONParser parser2 = JSON.createParser(responseBody14);
                result2 = String.valueOf(responseBody14).substringAfter('LoanTrackingLocator":"');
                result2 = String.valueOf(result2).substringBefore('",');
                System.debug('LoanName Tracking' + result2);
                
                if(result2 == null || result2 == ''){
                        
                    ErrorLoanTrackingLocator = String.valueOf(responseBody14).substringAfter('Error",');
                    ErrorLoanTrackingLocator = String.valueOf(ErrorLoanTrackingLocator).substringBefore('","ErrorDetails"');
                    system.debug('ErrorLoanTrackingLocator' + ErrorLoanTrackingLocator);
                }

                //----------------------------------------------------Creat Loan Funding-------------------------------------------------//

                system.debug('result2: '+result2);
                system.debug('result: '+result);

                if(result2 != null && result != null){
                        
                    LoanId = result;
                    
                    if(sl.Loan_Amount__c != null)
                        SLAmount = Integer.valueOf(sl.Loan_Amount__c);
                    else
                        SLAmount = 0;
                        
                    //AccountNumber = sl.Member_Number__c;
                    
                    System.debug('Funding method called');
                    req15.setEndpoint(loanAPI+'/Wires/FundLoan?accountNumber='+AccountNumber+'&loanId='+LoanId+'&amount='+SLAmount);
                    
                    req15.setMethod('GET');
                    req15.setHeader('Content-Type', 'application/json');
                    req15.setHeader('Accept', 'application/json');
                    
                    system.debug('test'+req15);
                    
                    req15.setTimeout(120000);
                    
                    if(!Test.isRunningTest()){                       
                        res15 = http15.send(req15);
                        responseBody15 = res15.getBody();
                        System.debug('Response Body for Fund::'+res15.getBody());    
                    }else{
                        responseBody15 = '{"Type":"3","Last":"27","First":"1","Street":"1","ExtraAddress":"100","City":"Chicago","State":"IL","ZipCode":"0012345,"BirthDate":"01-01-2019","SSN":"1345","LoanId":"322271627","AccountNumber":"00000123456"}';
                        
                    }

                    if(logs == null)
                    logs = responseBody15;
                else
                    logs = logs +'\n'+ responseBody15;
                }

                //------------------------------------------------Creating Joint Name Record--------------------------------------------//

                if(sl.mem_Joint_SSN__c != null){

                    hasJoint = true;
                    if(sl.mem_Joint_DOB__c != null)
                        JOINTBIRTHDATE = string.valueOf(sl.mem_Joint_DOB__c);
                    else
                        JOINTBIRTHDATE = '';

                    if(sl.mem_Joint_City__c != null)
                        JOINTCITY = string.valueOf(sl.mem_Joint_City__c).toUpperCase();    
                    else
                        JOINTCITY = '';

                    if(sl.Joint_Email__c != null)
                        JOINTEMAIL = string.valueOf(sl.Joint_Email__c);    
                    else
                        JOINTEMAIL = '';

                    if(sl.mem_Joint_Employer__c != null){
                        
                        JOINTEMPLOYERNAME = string.valueOf(sl.mem_Joint_Employer__c).toUpperCase();    
                        if(JOINTEMPLOYERNAME.contains('&') == true){
                            JOINTEMPLOYERNAME = JOINTEMPLOYERNAME.replace('&', '&#38;');
                        }
                    }    
                    else
                        JOINTEMPLOYERNAME = '';

                    if(sl.mem_Joint_Extra_Address__c != null)
                        JOINTEXTRAADDRESS = string.valueOf(sl.mem_Joint_Extra_Address__c).toUpperCase();
                    else
                        JOINTEXTRAADDRESS = '';

                    if(sl.mem_Joint_First_Name__c != null)
                        JOINTFIRST = string.valueOf(sl.mem_Joint_First_Name__c).toUpperCase();
                    else
                        JOINTFIRST = '';

                    if(sl.Joint_Home_Phone__c != null)
                        JOINTHOMEPHONE = string.valueOf(sl.Joint_Home_Phone__c);
                    else
                        JOINTHOMEPHONE = '';

                    JOINTIDENTDOCFLAG = 1;
                    JOINTIDENTDOCFLAG3 = 0;

                    if(sl.Joint_ID_State__c != null)
                        JOINTIDENTIDDESCRIPTION = string.valueOf(sl.Joint_ID_State__c).toUpperCase();
                    else
                        JOINTIDENTIDDESCRIPTION = '';

                    
                    if((sl.mem_Joint_Foreign_Gov_t_Position__c == null || sl.mem_Joint_Foreign_Gov_t_Position__c == '') &&
                        (sl.mem_Joint_A_F_Foreign_Gov_t_Position__c == null || sl.mem_Joint_A_F_Foreign_Gov_t_Position__c == '')){
                            
                        JOINTIDENTIDDESCRIPTION3 = '';
                    }
                    else if((sl.mem_Joint_Foreign_Gov_t_Position__c == 'Yes' || sl.mem_Joint_Foreign_Gov_t_Position__c == 'yes') &&
                        (sl.mem_Joint_A_F_Foreign_Gov_t_Position__c == 'Yes' || sl.mem_Joint_A_F_Foreign_Gov_t_Position__c == 'yes')){
                            
                        JOINTIDENTIDDESCRIPTION3 = 'Y Y';
                    }
                    else if((sl.mem_Joint_Foreign_Gov_t_Position__c == 'No' || sl.mem_Joint_Foreign_Gov_t_Position__c == 'no') &&
                        (sl.mem_Joint_A_F_Foreign_Gov_t_Position__c == 'Yes' || sl.mem_Joint_A_F_Foreign_Gov_t_Position__c == 'yes')){
                            
                        JOINTIDENTIDDESCRIPTION3 = 'N Y';
                    }
                    else if((sl.mem_Joint_Foreign_Gov_t_Position__c == 'Yes' || sl.mem_Joint_Foreign_Gov_t_Position__c == 'yes') &&
                        (sl.mem_Joint_A_F_Foreign_Gov_t_Position__c == 'No' || sl.mem_Joint_A_F_Foreign_Gov_t_Position__c == 'no')){
                            
                        JOINTIDENTIDDESCRIPTION3 = 'Y N';
                    }
                    else if((sl.mem_Joint_Foreign_Gov_t_Position__c == 'No' || sl.mem_Joint_Foreign_Gov_t_Position__c == 'no') &&
                        (sl.mem_Joint_A_F_Foreign_Gov_t_Position__c == 'No' || sl.mem_Joint_A_F_Foreign_Gov_t_Position__c == 'no')){
                            
                        JOINTIDENTIDDESCRIPTION3 = 'N N';
                    }


                    if(sl.Joint_ID_Expiration_Date__c != null)
                        JOINTIDENTIDEXPIREDATE = string.valueOf(sl.Joint_ID_Expiration_Date__c);
                    else
                        JOINTIDENTIDEXPIREDATE = '';

                    if(sl.Joint_ID_Issue_Date__c != null)
                        JOINTIDENTIDISSUEDATE = string.valueOf(sl.Joint_ID_Issue_Date__c);
                    else
                        JOINTIDENTIDISSUEDATE = '';

                    if(sl.Joint_ID_Number__c != null)
                        JOINTIDENTIDNUMBER = string.valueOf(sl.Joint_ID_Number__c).toUpperCase();
                    else
                        JOINTIDENTIDNUMBER = '';
                
                    if(sl.Joint_ID_Type__c == 'DL (DMV)')
                        JOINTIDENTIDTYPE = 2;
                    else if(sl.Joint_ID_Type__c == 'Passport')
                        JOINTIDENTIDTYPE = 4;
                    else if(sl.Joint_ID_Type__c == 'Military ID')
                        JOINTIDENTIDTYPE = 6;
                    else
                        JOINTIDENTIDTYPE = 0;
                  
                    if(sl.mem_Joint_Last_Name__c != null)
                        JOINTLAST = string.valueOf(sl.mem_Joint_Last_Name__c).toUpperCase();
                    else
                        JOINTLAST = '';

                    if(sl.Joint_Middle_Initial__c != null)
                        JOINTMIDDLE = string.valueOf(sl.Joint_Middle_Initial__c).toUpperCase();
                    else
                        JOINTMIDDLE = '';

                    if(sl.Joint_Cell_Phone__c != null)
                        JOINTMOBILEPHONE = string.valueOf(sl.Joint_Cell_Phone__c);
                    else
                        JOINTMOBILEPHONE = '';

                    if(sl.Joint_Maiden_Name__c != null)
                        JOINTMOTHERSMAIDENNAME = string.valueOf(sl.Joint_Maiden_Name__c).toUpperCase();
                    else
                        JOINTMOTHERSMAIDENNAME = '';
                    
                    if(JOINTMOTHERSMAIDENNAME.length() > 20){
                        JOINTMOTHERSMAIDENNAME = JOINTMOTHERSMAIDENNAME.substring(0,20);
                    }

                    if(sl.Joint_Occupation__c != null)
                        JOINTOCCUPATION = string.valueOf(sl.Joint_Occupation__c).toUpperCase();
                    else
                        JOINTOCCUPATION = '';                      

                    if(sl.mem_Joint_SSN__c	 != null)
                        JOINTSSN = string.valueOf(sl.mem_Joint_SSN__c);
                    else
                        JOINTSSN = '';

                    if(sl.mem_Joint_State__c != null)
                        JOINTSTATE = string.valueOf(sl.mem_Joint_State__c).toUpperCase();
                    else
                        JOINTSTATE = '';

                    if(sl.mem_Joint_Street__c != null)
                        JOINTSTREET = string.valueOf(sl.mem_Joint_Street__c).toUpperCase();
                    else
                        JOINTSTREET = '';
                    JOINTSUFFIX = ' ';

                    if(sl.Joint_Work_Phone__c != null)
                        JOINTWORKPHONE = string.valueOf(sl.Joint_Work_Phone__c);
                    else
                        JOINTWORKPHONE = '';

                    if(sl.mem_Joint_Zip_Code__c != null)
                        JOINTZIPCODE = string.valueOf(sl.mem_Joint_Zip_Code__c);
                    else
                        JOINTZIPCODE = '';
                    
                    UserChar3 = string.valueOf(sl.mem_Primary_First_Name__c) +' '+string.valueOf(sl.mem_Primary_Last_Name__c);
                   
                    JOINTUSERCHAR1 = '0016-'+string.valueOf(sl.name).toUpperCase();
                    System.debug('JOINTUSERCHAR1: '+ JOINTUSERCHAR1);
                    system.debug('UserChar3 '+UserChar3);

                    System.debug('--------------------------------Calling Joint Name method-------------------------------');
                    req4.setEndpoint(loanAPI+'/SolarLoan/CreateJointName');
                    req4.setMethod('POST');
                    req4.setHeader('Content-Type', 'application/json');
                    req4.setHeader('Accept', 'application/json');
                   
                    jsonData4 = '{"Userchar1":' + '\"'+ JOINTUSERCHAR1 +'\"'+',"Email":' + '\"'+ JOINTEMAIL +'\"'+',"Type":"1","IdentIdType":'+'\"'+JOINTIDENTIDTYPE+'\"'+',"IdentIdNumber":'+'\"'+JOINTIDENTIDNUMBER+'\"'+',"IdentIdIssueDate":'+'\"'+JOINTIDENTIDISSUEDATE+'\"'+',"IdentIdExpireDate":'+'\"'+JOINTIDENTIDEXPIREDATE+'\"'+',"IdentIdDescription":'+'\"'+JOINTIDENTIDDESCRIPTION+'\"'+',"IdentIdDescription3":'+'\"'+JOINTIDENTIDDESCRIPTION3+'\"'+',"IdentDocFlag":'+'\"'+JOINTIDENTDOCFLAG+'\"'+',"IdentDocFlag3":'+'\"'+JOINTIDENTDOCFLAG3+'\"'+',"UserChar3":'+'\"'+UserChar3+'\"'+',"AccountNumber":'+'\"'+AccountNumber+'\"'+',"BirthDate":' + '\"'+ JOINTBIRTHDATE +'\"'+',"City":' + '\"'+ JOINTCITY +'\"'+',"EmployerName":' + '\"'+ JOINTEMPLOYERNAME +'\"'+',"ExtraAddress":' + '\"'+ JOINTEXTRAADDRESS +'\"'+',"First":' + '\"'+ JOINTFIRST +'\"'+',"HomePhone":' + '\"'+ JOINTHOMEPHONE +'\"'+',"Last":' + '\"'+ JOINTLAST +'\"'+',"Middle":' + '\"'+ JOINTMIDDLE +'\"'+',"MobilePhone":' + '\"'+ JOINTMOBILEPHONE +'\"'+',"MothersMaidenName":' + '\"'+ JOINTMOTHERSMAIDENNAME +'\"'+',"Occupation":' + '\"'+ JOINTOCCUPATION +'\"'+',"Ssn":' + '\"'+ JOINTSSN +'\"'+',"State":' + '\"'+ JOINTSTATE +'\"'+',"Street":' + '\"'+ JOINTSTREET +'\"'+',"Suffix":' + '\"'+ JOINTSUFFIX +'\"'+',"Workphone":' + '\"'+ JOINTWORKPHONE +'\"'+',"ZipCode":' + '\"'+ JOINTZIPCODE +'\"}';
                    
                    req4.setBodyAsBlob(Blob.valueof(jsondata4)); 
                    system.debug('test'+jsonData4);
                    
                    Http http4 = new Http();  
                    req4.setTimeout(120000);
                    HttpResponse res4;
                    
                    if(!Test.isRunningTest()){                       
                        res4 = http4.send(req4);
                        responseBody4 = res4.getBody();
                        System.debug('Create Joint Name record Response::'+res4.getBody());    
                    }else{
                        responseBody4 = '{"Type":"3","PaymentFrequency" : "67"}';
                    } 

                }
                if(logs == null)
                    logs = responseBody4;
                else
                    logs = logs +'\n'+ responseBody4;
                //------------------------------------------------------Creating Mail Record--------------------------------------------//

                if(sl.Mailing_Street__c != null && sl.mem_Mailing_State__c != null){

                    hasMail = true;
                    if(sl.mem_Primary_First_Name__c != null && sl.mem_Primary_First_Name__c != '')
                        MAILFIRST = string.valueOf(sl.mem_Primary_First_Name__c);
                    else
                        MAILFIRST = '';

                    if(sl.mem_Primary_Last_Name__c != null && sl.mem_Primary_Last_Name__c != '')
                        MAILLAST = string.valueOf(sl.mem_Primary_Last_Name__c);
                    else
                        MAILLAST = '';

                    if(sl.mem_Mailing_Extra_Address__c != null && sl.mem_Mailing_Extra_Address__c != '')
                        MAILEXTRAADDRESS = string.valueOf(sl.mem_Mailing_Extra_Address__c).toUpperCase();
                    else
                        MAILEXTRAADDRESS = '';
                    
                    if(sl.Primary_Middle_Initial__c != null && sl.Primary_Middle_Initial__c != '')
                        MAILMIDDLE = string.valueOf(sl.Primary_Middle_Initial__c);
                    else
                        MAILMIDDLE = '';
                    
                    MAILOVERRIDE = '1';

                    if(sl.mem_Mailing_State__c != null && sl.mem_Mailing_State__c != '')
                        MAILSTATE = string.valueOf(sl.mem_Mailing_State__c).toUpperCase();
                    else
                        MAILSTATE = '';

                    if(sl.mem_Mailing_City__c != null && sl.mem_Mailing_City__c != '')
                        MAILCITY = string.valueOf(sl.mem_Mailing_City__c).toUpperCase();
                    else
                        MAILCITY = '';

                    if(sl.Mailing_Street__c	 != null && sl.Mailing_Street__c != '')
                        MAILSTREET = string.valueOf(sl.Mailing_Street__c).toUpperCase();
                    else
                        MAILSTREET = '';

                    if(sl.Mailing_Zip__c != null && sl.Mailing_Zip__c != '')
                        MAILZIPCODE = string.valueOf(sl.Mailing_Zip__c);
                    else
                        MAILZIPCODE = '';

                    MAILSUFFIX = '' ;
                   
                    System.debug('-----------------------------------Calling Mail Name method----------------------------');
                    req5.setEndpoint(loanAPI+'/SolarLoan/CreateMailName');
                    req5.setMethod('POST');
                    req5.setHeader('Content-Type', 'application/json');
                    req5.setHeader('Accept', 'application/json');
                    
                    jsonData5 = '{"AccountNumber":'+'\"'+AccountNumber+'\"'+',"First":' + '\"'+ MAILFIRST +'\"'+',"Last":' + '\"'+ MAILLAST +'\"'+',"ExtraAddress":' + '\"'+ MAILEXTRAADDRESS +'\"'+',"Middle":' + '\"'+ MAILMIDDLE +'\"'+',"MailOverride":' + '\"'+ MAILOVERRIDE +'\"'+',"State":' + '\"'+ MAILSTATE +'\"'+',"City":' + '\"'+ MAILCITY +'\"'+',"Street":' + '\"'+ MAILSTREET +'\"'+',"Suffix":' + '\"'+ MAILSUFFIX +'\"'+',"Type": "2","ZipCode":' + '\"'+ MAILZIPCODE +'\"}';
                    req5.setBodyAsBlob(Blob.valueof(jsondata5)); 
                    system.debug('test'+jsonData5);
                    
                    Http http5 = new Http();  
                    req5.setTimeout(120000);
                    HttpResponse res5;
                    
                    if(!Test.isRunningTest()){                       
                        res5 = http5.send(req5);
                        responseBody5 = res5.getBody();
                        System.debug('Create Mail Name record Response::'+res5.getBody());    
                    }else{
                        responseBody5 = '{"Type":"3","PaymentFrequency" : "67"}';
                    }

                }
                
                if(logs == null)
                    logs = responseBody5;
                else
                    logs = logs +'\n'+ responseBody5;
                //------------------------------------------------Creating Comment Record--------------------------------------------//

                COMMENT = 'SPECTRUM CREDIT UNION';
                COMMNETTYPE = '1';
               
                System.debug('-------------------------Calling comment method------------------------------');
                req6.setEndpoint(loanAPI+'/SolarLoan/CreateComment');
                req6.setMethod('POST');
                req6.setHeader('Content-Type', 'application/json');
                req6.setHeader('Accept', 'application/json');
                
                jsonData6 = '{"EpisysId":'+'\"'+operatorid+'\"'+',"AccountNumber":'+'\"'+AccountNumber+'\"'+',"Text":' + '\"'+ COMMENT +'\"'+',"Type":' + '\"'+ COMMNETTYPE +'\"}';
                req6.setBodyAsBlob(Blob.valueof(jsondata6)); 
                system.debug('test'+jsonData6);
                
                Http http6 = new Http();  
                req6.setTimeout(120000);
                HttpResponse res6;
                
                if(!Test.isRunningTest()){                       
                    res6 = http6.send(req6);
                    responseBody6 = res6.getBody();
                    System.debug('Create Comment record Response::'+res6.getBody());    
                }else{
                    responseBody6 = '{"Type":"3","PaymentFrequency" : "67"}';
                }

                if(logs == null)
                    logs = res6.getBody();
                else
                    logs = logs +'\n'+ responseBody6;

                //------------------------------------------------Creating Tracking 35 Record--------------------------------------------//

                TRACKINGTYPE = '35';
               
                System.debug('-------------------------Calling Tracking 35 method-------------------------');
                req7.setEndpoint(loanAPI+'/SolarLoan/CreateTracking35');
                req7.setMethod('POST');
                req7.setHeader('Content-Type', 'application/json');
                req7.setHeader('Accept', 'application/json');
                
                jsonData7 = '{"EpisysId":'+'\"'+operatorid+'\"'+',"AccountNumber":'+'\"'+AccountNumber+'\"'+',"Type":' + '\"'+ TRACKINGTYPE +'\"}';
                req7.setBodyAsBlob(Blob.valueof(jsondata7)); 
                system.debug('test'+jsonData7);
                
                Http http7 = new Http();  
                req7.setTimeout(120000);
                HttpResponse res7;
                
                if(!Test.isRunningTest()){                       
                    res7 = http7.send(req7);
                    responseBody7 = res7.getBody();
                    System.debug('Create Tracking Locator Response::'+res7.getBody());    
                }else{
                    responseBody7 = '{"Type":"3","TrackingLocator" : "67"}';
                }
                
                if(logs == null)
                    logs = res7.getBody();
                else
                    logs = logs +'\n'+ responseBody7;
                
                if(responseBody7 != '' && responseBody7 != null){        
                    Map<String,Object> results = (Map<String,Object>) JSON.deserializeUntyped(responseBody7);
                    System.debug('Response is ....' + results);
                    
                    if(results.size() > 0){
                        for(String l : results.keyset()) {
                            if(l == 'TrackingLocator'){
                                TrackingLocator = String.valueOf(results.get(l));
                            }
                        }    
                    }
                }
                system.debug('TrackingLocator '+TrackingLocator);
                
                //------------------------------------------------Getting Preference Locator -------------------------------------//

                
                System.debug('-------------------------Getting Preference Locator -------------------------');
                req10.setEndpoint(loanAPI+'/SolarLoan/GetPreferenceListSelectFields?accountNumber='+AccountNumber);
                req10.setMethod('GET');
                req10.setHeader('Content-Type', 'application/json');
                req10.setHeader('Accept', 'application/json');
                req10.setTimeout(120000);

                //jsonData10 = '{"AccountNumber":' + '\"'+ AccountNumber +'\"}';
                //req10.setBodyAsBlob(Blob.valueof(jsonData10)); 
                //system.debug('test'+jsonData10);
            
                if(!Test.isRunningTest()){                       
                    res10 = http10.send(req10);
                    responseBody10 = res10.getBody();
                    System.debug('Getting Preference Locator Response::'+res10.getBody());    
                }else{
                    responseBody10 = '{"Type":"3","PreferenceLocator" : "2"}';
                } 

                if(logs == null)
                    logs = responseBody10;
                else
                    logs = logs +'\n'+ responseBody10;

                PreferenceLocator = String.valueOf(responseBody10).substringAfter('"Locator":["');
                PreferenceLocator = String.valueOf(PreferenceLocator).substringBefore('"],"Status"');
                
                System.debug('PreferenceLocator....' + PreferenceLocator);

                //------------------------------------------------Creating Preference Access Record--------------------------------------------//

                ACCESSTYPE = '3';
               
                System.debug('------------------Creating Preference Access Record--------------------');
                req8.setEndpoint(loanAPI+'/SolarLoan/CreatePreferenceAccess');
                req8.setMethod('POST');
                req8.setHeader('Content-Type', 'application/json');
                req8.setHeader('Accept', 'application/json');
                req8.setTimeout(120000);

                jsonData8 = '{"PreferenceLocator":'+'\"'+PreferenceLocator+'\"'+',"EpisysId":'+'\"'+operatorid+'\"'+',"AccountNumber":'+'\"'+AccountNumber+'\"'+',"AccessType":' + '\"'+ ACCESSTYPE +'\"}';
                req8.setBodyAsBlob(Blob.valueof(jsondata8)); 
                system.debug('test'+jsonData8);
                
                Http http8 = new Http();  
                HttpResponse res8;
                
                if(!Test.isRunningTest()){                       
                    res8 = http8.send(req8);
                    responseBody8 = res8.getBody();
                    System.debug('Create Preference Record Response::'+res8.getBody());    
                }else{
                    responseBody8 = '{"Type":"3","PreferenceAccessLocator" : "6"}';
                }

                if(responseBody8 != '' && responseBody8 != null){        
                    Map<String,Object> results = (Map<String,Object>) JSON.deserializeUntyped(responseBody8);
                    System.debug('Response is ....' + results);
                    
                    if(results.size() > 0){
                        for(String l : results.keyset()) {
                            if(l == 'PreferenceAccessLocator'){
                                PreferenceAccessLocator = String.valueOf(results.get(l));
                            }
                        }    
                    }
                }
                system.debug('PreferenceAccessLocator '+PreferenceAccessLocator);

                
                if(logs == null)
                    logs = responseBody8;
                else
                    logs = logs +'\n'+ responseBody8;

                //---------------------------------------------------Creating Share Record--------------------------------------------------//

                SHAREBRANCH = '299';
                SHARECREATEDATBRANCH = '299';
                SHARECREATEDBYUSER = operatorid;

                if(hasJoint == true)
                    SHAREMINIMUMBALANCE = '50.00';
                else
                    SHAREMINIMUMBALANCE = '25.00';

                SHARETYPE = '1';
                SHAREID = '0100';
               
                System.debug('----------------------------Calling Share record-----------------------------');
                System.debug('Creating Share Record');
                req9.setEndpoint(loanAPI+'/SolarLoan/CreateShare');
                req9.setMethod('POST');
                req9.setHeader('Content-Type', 'application/json');
                req9.setHeader('Accept', 'application/json');
                
                jsonData9 = '{"MinimumBalance":' + '\"'+ SHAREMINIMUMBALANCE +'\"'+',"EpisysId":'+'\"'+operatorid+'\"'+',"AccountNumber":'+'\"'+AccountNumber+'\"'+',"Branch":' + '\"'+ SHAREBRANCH +'\"'+',"CreatedAtBranch":' + '\"'+ SHARECREATEDATBRANCH +'\"'+',"CreatedByUser":' + '\"'+ SHARECREATEDBYUSER +'\"'+',"Type":' + '\"'+ SHARETYPE +'\"'+',"Id":' + '\"'+ SHAREID +'\"}';
                req9.setBodyAsBlob(Blob.valueof(jsondata9)); 
                system.debug('test'+jsonData9);
                
                Http http9 = new Http();  
                req9.setTimeout(120000);
                
                if(!Test.isRunningTest()){                       
                    res9 = http9.send(req9);
                    responseBody9 = res9.getBody();
                    System.debug('Create Share record Response::'+res9.getBody());    
                }else{
                    responseBody9 = '{"Type":"3","PaymentFrequency" : "67"}';
                } 

                if(logs == null)
                    logs = responseBody9;
                else
                    logs = logs +'\n'+ jsonData9 + '\n' + responseBody9;

                //---------------------------------------------------Creating PowerOn Record--------------------------------------------------//
                
                RGSession = '1';
                RGUserChr1 = sl.Member_Number__c;
                RGUserChr2 = 'SOLAR';
                
                System.debug('----------------------------Calling PowerOn record-----------------------------');
                System.debug('Creating PowerOn Record');
                req11.setEndpoint(loanAPI+'/SolarLoan/PromoPowerOn');
                req11.setMethod('POST');
                req11.setHeader('Content-Type', 'application/json');
                req11.setHeader('Accept', 'application/json');
                
                jsonData11 = '{"EpisysId":'+'\"'+operatorid+'\"'+',"RGSession":'+'\"'+RGSession+'\"'+',"RGUserChr1":' + '\"'+ RGUserChr1 +'\"'+',"RGUserChr2":' + '\"'+ RGUserChr2 +'\"}';
                req11.setBodyAsBlob(Blob.valueof(jsondata11)); 
                system.debug('test'+jsonData11);
                
                Http http11 = new Http();  
                req11.setTimeout(120000);
                             
                if(!Test.isRunningTest()){                       
                    res11 = http11.send(req11);
                    responseBody11 = res11.getBody();
                    System.debug('Create PowerOn record Response::'+res11.getBody());    
                }else{
                    responseBody11 = '{"Type":"3","PaymentFrequency" : "67"}';
                }

                if(logs == null)
                    logs = responseBody11;
                else
                    logs = logs +'\n'+ responseBody11;

                if(responseBody11 !=''){        
                    Map<String,Object> results = (Map<String,Object>) JSON.deserializeUntyped(responseBody11);      
                    System.debug('Poweron response is....' + results);
                    if(results.size() > 0){
                        for(String key : results.keySet()){                   			
                            if(key == 'RGlines'){
                                PreferenceLocator = String.valueOf(results.get(key));
                            }
                        }
                    }
                }

                System.debug('RGLines: '+ RGLines);
                System.debug('logs: '+ logs);
           
                //---------------------------------------------------Updating Solar Loan records -------------------------------------------//
            
                Solar_Loans__c s = new Solar_Loans__c();  
        
                if(result != null && result != '')
                    s.Loan_Id__c = result;
                    
                if(result1 != null && result1 != '')    
                    s.Loan_Name_Locator__c = result1;
                    
                if((result2 != null && result2 != '') || (TrackingRecord == 'IsFound'))
                    s.Tracking_Record_33__c = 'Created';

                if(s.Loan_Id__c != null || s.Loan_Name_Locator__c != null || s.Tracking_Record_33__c != null ){
                    s.Status__c = 'Loan Funded';
                    s.Current_Solar_Loan_Stage__c = 'Stage 4';
                }    
                    
                if(ErrorLoanLocator != null && ErrorLoanLocator != '')
                    s.Error_Loan_Locator__c = ErrorLoanLocator;
                else
                    s.Error_Loan_Locator__c = '';
                    
                if(ErrorLoanNameLocator != null && ErrorLoanNameLocator != '')
                    s.Error_Loan_Name_Locator__c = ErrorLoanNameLocator;
                else
                    s.Error_Loan_Name_Locator__c = '';
                        
                if(ErrorLoanTrackingLocator != null && ErrorLoanTrackingLocator != '')
                    s.Error_Loan_Tracking_Locator__c = ErrorLoanTrackingLocator;
                else
                    s.Error_Loan_Tracking_Locator__c = '';

                            
                s.id = sl.Id;       
                s.Due_Date__c = System.Today() + 60;
                s.continue__c = false;
                s.Brand__c = 'Spectrum'; 

                if(sl.Term_months__c != null){
                    SLMonth = Integer.Valueof(sl.Term_months__c) - 1;
                    s.Maturity_Date__c = s.Due_Date__c.addMonths(SLMonth);
                }
                s.Episys_Membership__c = 'Membership already exists, new membership not created';
                system.debug('s.Maturity_Date__c'+s.Maturity_Date__c);

                if(MembershipccountStatus == 'OK')
                    s.Episys_Membership__c = 'Created';
                    
                if(AccountNumber != null || AccountNumber != '')
                    s.Member_Number__c = AccountNumber;

                if(TrackingLocator != null)
                    s.Tracking_Record_35__c = 'Created';
                    
                if(logs != null)
                    s.Membership_Logs__c = logs;
                    
                SolarLoanToUpdate.add(s);
            }        
        
        }
        
        solarMap.putall(SolarLoanToUpdate);
        if(solarMap.size() > 0){
            update solarMap.values();
        }
        
    }

    @future(callout=true)
    public static void getMemberNumber(Set<id> ids){

        List<Solar_Loans__c> Solanloanlist = new List<Solar_Loans__c>();         
        List<Solar_Loans__c> solarloans = [SELECT id,ABA_Bank_Name__c,ACH__c,Additional_Amount__c,Application_Date__c,
            Bank_Account_Number__c,Bank_Name__c,Battery__c,Brand__c,Change_Order__c,CreatedById,CreatedDate,
            Credit_Attributes__c,Credit_Exception__c,Debt_Ratio__c,DocuSignId__c,Due_Date__c,Tracking_Record_33__c,
            ECOA_Code__c,Final_Payment_Amount__c,FNI__c,Go_To_Payment__c,Initial_LT_Loan_Agreement__c,
            Installer_Number__c,Installer__c,Interest_Rate__c,Inverter__c,IsDeleted,Joint_Address_1__c,
            Joint_Address_2__c,Joint_City__c,Joint_DOB__c,Joint_FICO_Score__c,Joint_First_Name__c,Joint_Last_Name__c,
            Joint_SSN__c,Joint_State__c,Joint_Zip_Code__c,Latest_LT_Loan_Agreement__c,Legal_Description__c,Loan_Amount__c,Loan_Pmt_Amount__c,
            Loan_Type__c,Maturity_Date__c,Account_Number__r.name,Membership_Fee__c,Member_Number__c,Module__c,Mortgage_Balance__c,Name,
            Name__c,Net_Funding_Amount__c,OID_Fee__c,OwnerId,Primary_Address_1__c,Primary_Address_2__c,
            Primary_City__c,Primary_DOB__c,Primary_FICO_Score__c,Primary_First_Name__c,Primary_Last_Name__c,
            Primary_SSN__c,Primary_State__c,Primary_Zip_Code__c,Product_Loan_Type__c,Product__c,Record_ID__c,
            Routing_Number__c,Site_UUID__c,Status__c,Symitar_Called__c,SystemModstamp,System_Size_kW__c,Term_months__c,
            Valid_ABA__c, Loan_Id__c,Loan_Name_Locator__c,Loan_Tracking_Locator__c,EftLocator__c,Approval_Date__c,
            Error_EftLocator__c,Error_Loan_Locator__c,Error_Loan_Name_Locator__c,Error_Loan_Tracking_Locator__c,
            ITC_Amount__c, ITC_Rate__c,ACH_Discount__c
            FROM Solar_Loans__c where id =: ids];

            SolarLoan_To_Episys_API_Details__c api = SolarLoan_To_Episys_API_Details__c.getValues('ProductionURL');
                
            if(api.URL__c != null){
                loanAPI = api.URL__c;
            }
    
            for(Solar_Loans__c sl : solarloans){
                
                
                /*System.debug('Chceking if the system is online!');
                req10.setEndpoint(loanAPI+'/EFT/GetGeneralEpisysInformation');
                req10.setMethod('GET');
                req10.setHeader('Content-Type', 'application/json');
                req10.setHeader('Accept', 'application/json');
                req10.setTimeout(120000);                   
                
                if(!Test.isRunningTest()){                       
                    res10 = http10.send(req10);
                    responseBody10 = res10.getBody();
                    System.debug('EpisysInformation::'+responseBody10);    
                }
                else{
                    responseBody10 = '{"SymNumber": "415","InMemoMode": "false","Status": "null","Error": "null","ErrorDetails": "null"}';
                }
                
                if(responseBody10!=''){        
                    Map<String,Object> results = (Map<String,Object>) JSON.deserializeUntyped(responseBody10);      
                    System.debug('Service response is ....' + results);
                    
                    
                    if(results.size() > 0){
                        
                        for(String key : results.keySet()){                   			
                            if(key == 'InMemoMode'){
                                mode = boolean.valueOf(results.get(key));
                            }
                        }
                    }
                }*/
                
                system.debug('mode'+mode);
                if(mode == false){

                    SSN = sl.Primary_SSN__c;

                    System.debug('GetMemberNumber method called');
                
                    req16.setEndpoint(loanAPI+'/EFT/GetAccountBySSN?ssn='+SSN);
                    req16.setMethod('GET');
                    req16.setHeader('Content-Type', 'application/json');
                    req16.setHeader('Accept', 'application/json');
                    
                    req16.setTimeout(120000);
                    
                    if(!Test.isRunningTest()){                       
                        res16 = http16.send(req16);
                        responseBody16 = res16.getBody();
                        System.debug('Response Body SolarLoan:'+res16.getBody());    
                    }else{
                        responseBody16 = '{"Type":"3","Last":"27","First":"1","Street":"1","ExtraAddress":"100","City":"Chicago","State":"IL","ZipCode":"0012345,"BirthDate":"01-01-2019","SSN":"1345","LoanId":"322271627","AccountNumber":"00000123456"}';
                        
                    }
                    
                    JSONParser parser = JSON.createParser(responseBody16);
                    result = String.valueOf(responseBody16).substringAfter('AccountNumber":"');
                    result = String.valueOf(result).substringBefore('",');
                    System.debug('Member Number' + result);

                    if(result != null && result != ''){
                        Solar_Loans__c s = new Solar_Loans__c(); 
                        s.id = sl.Id;       
                        s.Member_Number__c = result;
                        s.Status__c = 'Approved';
                        s.Current_Solar_Loan_Stage__c = 'Stage 3';
                        s.continue__c = false;
                        
                        SolarLoanToUpdate.add(s); 
                    }
                }
                /*else{
                    
                    Solar_Loans__c s = new Solar_Loans__c();
                    s.id = sl.Id; 
                    s.Error_Loan_Locator__c = 'System is ofline';
                    SolarLoanToUpdate.add(s);
                }*/

            }
            solarMap.putall(SolarLoanToUpdate);
            if(solarMap.size() > 0){
                update solarMap.values();
            }

    }
    
    @future(callout=true)
    public static void getMemberBrand(Set<id> ids){

        List<Solar_Loans__c> Solanloanlist = new List<Solar_Loans__c>();         
        List<Solar_Loans__c> solarloans = [SELECT id,ABA_Bank_Name__c,ACH__c,Additional_Amount__c,Application_Date__c,
            Bank_Account_Number__c,Bank_Name__c,Battery__c,Brand__c,Change_Order__c,CreatedById,CreatedDate,
            Credit_Attributes__c,Credit_Exception__c,Debt_Ratio__c,DocuSignId__c,Due_Date__c,Tracking_Record_33__c,
            ECOA_Code__c,Final_Payment_Amount__c,FNI__c,Go_To_Payment__c,Initial_LT_Loan_Agreement__c,
            Installer_Number__c,Installer__c,Interest_Rate__c,Inverter__c,IsDeleted,Joint_Address_1__c,
            Joint_Address_2__c,Joint_City__c,Joint_DOB__c,Joint_FICO_Score__c,Joint_First_Name__c,Joint_Last_Name__c,
            Joint_SSN__c,Joint_State__c,Joint_Zip_Code__c,Latest_LT_Loan_Agreement__c,Legal_Description__c,Loan_Amount__c,Loan_Pmt_Amount__c,
            Loan_Type__c,Maturity_Date__c,Account_Number__r.name,Membership_Fee__c,Member_Number__c,Module__c,Mortgage_Balance__c,Name,
            Name__c,Net_Funding_Amount__c,OID_Fee__c,OwnerId,Primary_Address_1__c,Primary_Address_2__c,
            Primary_City__c,Primary_DOB__c,Primary_FICO_Score__c,Primary_First_Name__c,Primary_Last_Name__c,
            Primary_SSN__c,Primary_State__c,Primary_Zip_Code__c,Product_Loan_Type__c,Product__c,Record_ID__c,
            Routing_Number__c,Site_UUID__c,Status__c,Symitar_Called__c,SystemModstamp,System_Size_kW__c,Term_months__c,
            Valid_ABA__c, Loan_Id__c,Loan_Name_Locator__c,Loan_Tracking_Locator__c,EftLocator__c,Approval_Date__c,
            Error_EftLocator__c,Error_Loan_Locator__c,Error_Loan_Name_Locator__c,Error_Loan_Tracking_Locator__c,
            ITC_Amount__c, ITC_Rate__c,ACH_Discount__c
            FROM Solar_Loans__c where id =: ids];

            SolarLoan_To_Episys_API_Details__c api = SolarLoan_To_Episys_API_Details__c.getValues('ProductionURL');
                
            if(api.URL__c != null){
                loanAPI = api.URL__c;
            }
    
            for(Solar_Loans__c sl : solarloans){
               
                System.debug('GetAccountBrand method called');
                AccountNumber = sl.Member_Number__c;
                req11.setEndpoint(loanAPI+'/PSAuto/GetAccountBrand?accountNumber='+AccountNumber);
                req11.setMethod('GET');
                req11.setHeader('Content-Type', 'application/json');
                req11.setHeader('Accept', 'application/json');
                req11.setTimeout(120000); 
                    
                if(!Test.isRunningTest()){                       
                    res11 = http11.send(req11);
                    responseBody11 = res11.getBody();
                    System.debug('Brand ::'+res11.getBody());    
                }else{
                    responseBody11 = '{"Reference" : "BC01"}';
                }
                if(responseBody11 !=''){        
                    Map<String,Object> results = (Map<String,Object>) JSON.deserializeUntyped(responseBody11);      
                    System.debug('Brand response is....' + results);
                    if(results.size() > 0){
                        for(String key : results.keySet()){                   			
                            if(key == 'Reference'){
                                Brand = String.valueOf(results.get(key));
                            }
                        }
                    }
                }

                if(Brand == 'BC01')
                    Brand = 'Chevron';

                else if(Brand == 'BC02')
                    Brand = 'Spectrum';


                if(Brand != null && Brand != ''){
                    
                    System.debug('Brand: '+ Brand);

                    Solar_Loans__c s = new Solar_Loans__c(); 
                    s.id = sl.Id;       
                    s.Brand__c = Brand;
                    s.continue__c = false;
                    
                    SolarLoanToUpdate.add(s); 
                }
            }
              
            
            solarMap.putall(SolarLoanToUpdate);
            if(solarMap.size() > 0){
                update solarMap.values();
            }

    }
}