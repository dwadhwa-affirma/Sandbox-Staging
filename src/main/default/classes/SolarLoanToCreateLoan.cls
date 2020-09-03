public class SolarLoanToCreateLoan {

    
    public static List<Solar_Loans__c> SolarLoanToUpdate = new List<Solar_Loans__c>();  
    public static String ErrorLoanLocator;
    public static String ErrorLoanNameLocator;
    public static String ErrorLoanTrackingLocator;
    public static String loanAPI;
    
    //------------------------------------------------System is online/offline-----------------------------------------------------//

    public static HttpRequest req10 = new HttpRequest();
    public static HttpResponse res10;
    public static Http http10 = new Http();
    public static string responseBody10;
    public static boolean mode;
   
    //------------------------------------------------Existing Solar Loan Parameters-----------------------------------------------------//

    public static HttpRequest req0 = new HttpRequest();
    public static HttpResponse res0;
    public static Http http0 = new Http();
    public static string responseBody0;
    public static String ExistingLoanId;

    //------------------------------------------------Solar Loan Parameters-----------------------------------------------------//
    public static String Type;
    public static String Branch;
    public static String CreatedAtBranch;
    public static String PurposeCode;
    public static String CollateralCode;
    public static String ApprovalCode;
    public static String OriginalBalance;
    public static String ApprovalDate;
    public static String MaturityDate;
    public static String DueDate;
    public static String FirstPaymentDate;
    public static String DueDay1;
    public static String Payment;
    public static Boolean PaymentMatched;
    public static String CouponCode;
    public static String PaymentMethod;
    public static String Description;
    public static String InterestRate;
    public static String UserAmount1;
    public static String ECOACode;
    public static String CreditScore;
    public static String PaymentCount;
    public static String PaymentFrequency;
    public static String AccountNumber;
    public static string OriginalDate;
    public static Integer Month;
    public static Integer Amount;
    public static String ApplicationFundedBy;
    public static String ApplicationLoadedBy;
    public static String operatorid;
    
    public static String jsonData;
    public static HttpRequest req = new HttpRequest();
    public static String result;
    
    //------------------------------------------------Solar Loan Name Parameters------------------------------------------------//
    public static String Last;
    public static String First;
    public static String Street;
    public static String ExtraAddress;
    public static String City;
    public static String State;
    public static String ZipCode;
    public static String BirthDate;
    public static String SSN;
    public static String LoanId;
    public static String jsonData1;
    public static HttpRequest req1 = new HttpRequest();
    public static String result1;
    
    //------------------------------------------------Solar Loan Tracking Parameters---------------------------------------------//
    
    public static String UserChar11;
    public static String UserChar1;
    public static String UserChar2;
    public static String UserChar3;
    public static String UserChar4;
    public static String UserChar5;
    public static String UserChar10;
    public static String UserChar20;
    public static String UserAmount2;
    public static String UserAmount3;
    public static String UserAmount11;
    public static String UserAmount12;
    public static String UserAmount13;
    public static String UserAmount14;  
    public static String UserCode1;
    public static String UserRate1;
    public static string UserCode11;
    public static string UserDate11;
    public static String UserChar7;
    public static string UserChar6;
    
    public static String jsonData2;
    public static HttpRequest req2 = new HttpRequest();
    public static String result2;
    
    public static String jsonData3;
    public static HttpRequest req3 = new HttpRequest();
    public static String result3;
    
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
    
            for(Solar_Loans__c sl : solarloans){

                //-----------Fetching API URL from custom setting to create Loan, LoanName, Loan Tracking and Fund record ---------------//

                SolarLoan_To_Episys_API_Details__c api = SolarLoan_To_Episys_API_Details__c.getValues('ProductionURL');
                
                if(api.URL__c != null){
                    loanAPI = api.URL__c;
                }

                System.debug('Chceking if the system is online!');
                req10.setEndpoint(loanAPI+'/EFT/GetGeneralEpisysInformation');
                req10.setMethod('GET');
                req10.setHeader('Content-Type', 'application/json');
                req10.setHeader('Accept', 'application/json');
                req10.setTimeout(60000);                   
                
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
                }
                
                system.debug('mode'+mode);
                if(mode == false){

                    //--------------------------Checking if Loan record already exist for this member number ---------------------------------//
                    
                    System.debug('Yes! System is online!');

                    AccountNumber = sl.Member_Number__c;

                    if(sl.Loan_Pmt_Amount__c != null)
                        Payment = string.valueof(sl.Loan_Pmt_Amount__c);
                        
                    req0.setEndpoint(loanAPI+'/PSAuto/GetLoansSelectFields?accountNumber='+AccountNumber);
                    req0.setMethod('GET');
                    req0.setHeader('Content-Type', 'application/json');
                    req0.setHeader('Accept', 'application/json');
                    req0.setTimeout(60000);                   
                    
                    if(!Test.isRunningTest()){                       
                        res0 = http0.send(req0);
                        responseBody0 = res0.getBody();
                        System.debug('Existing solar loan::'+responseBody0);    
                    }
                        
                    if(responseBody0 != '' && responseBody0 != null){        
                        List<object> results = (List<Object>) JSON.deserializeUntyped(responseBody0);      
                        System.debug('Response is ....' + results);
                        
                        if(results.size() > 0){
                            for(Object key : results){ 
                                Map<String, Object> loanids = (Map<String, Object>)key;
                                for(String l : loanids.keyset()) {
                                    if(l == 'LoanId'){
                                        ExistingLoanId = String.valueOf(loanids.get(l));
                                    }
                                    if(l == 'Payment'){
                                        if(Payment == String.valueOf(loanids.get(l))) {
                                            PaymentMatched = true;
                                        }
                                    }  
                                }    
                            }
                        }
                    }
                    system.debug('PaymentMatched'+PaymentMatched);
                    System.debug('ExistingLoanId'+ExistingLoanId);
                
                    if(ExistingLoanId != '0' && PaymentMatched == true){
                        
                        System.debug('Picking existing Loan Record with LoanId '+ ExistingLoanId);    
                        result = ExistingLoanId;
                    }
                    else{    

                        System.debug('Going to Create New Loan record');
                    
                        Type = '75';
                        Branch = '96';
                        CreatedAtBranch = '96';
                        PurposeCode = '16';
                        CollateralCode = '4';
                        ApprovalCode = '9002';
                        if(sl.Loan_Amount__c != null)
                            OriginalBalance = string.valueOf(sl.Loan_Amount__c);
                        else
                            OriginalBalance = '0.00';
                        if(sl.Approval_Date__c != null){
                            ApprovalDate = string.valueof(sl.Approval_Date__c);
                        }
                        
                        //-------------------------------------- Maturity Date------------------------------------//
                        
                        sl.Due_Date__c = System.Today() + 60;
                        
                        if(sl.Term_months__c != null){
                            Month = Integer.Valueof(sl.Term_months__c) - 1;
                            sl.Maturity_Date__c = sl.Due_Date__c.addMonths(Month);
                        }
                        MaturityDate = string.valueOf(sl.Maturity_Date__c);
                        
                        
                        DueDate = string.valueOf(System.Today()+ 60);
                        FirstPaymentDate = string.valueOf(System.Today() + 60);
                                    
                        if(sl.Due_Date__c != null){
                            DueDay1 = String.valueof(sl.Due_Date__c.day());
                        }
                        else{
                            DueDay1 = '15';
                        }
                        
                        //-------------------------------------- Payment -----------------------------------//

                        if(sl.Loan_Pmt_Amount__c != null)
                            Payment = string.valueof(sl.Loan_Pmt_Amount__c);
                    
                        CouponCode = '1';
                        PaymentMethod = '1';
                        Description = 'SECURED SOLAR';
                        InterestRate = string.valueof(sl.Interest_Rate__c);
                        UserAmount1 = string.valueof(sl.Debt_Ratio__c);
                        ECOACode = sl.ECOA_Code__c;
                        CreditScore = String.valueOf(sl.Primary_FICO_Score__c);
                        PaymentCount = String.valueOf(sl.Term_months__c);
                        PaymentFrequency = '04';
                        AccountNumber = sl.Member_Number__c;
                        OriginalDate = string.valueOf(System.Today());
                        
                        ApplicationFundedBy = operatorid;
                        ApplicationLoadedBy = operatorid;
                        
                        System.debug('CreateLoan method called');
                        req.setEndpoint(loanAPI+'/EFT/CreateLoan');
                        //req.setClientCertificateName('brscmcapi');
                        req.setMethod('POST');
                        req.setHeader('Content-Type', 'application/json');
                        req.setHeader('Accept', 'application/json');
                        
                        jsonData = '{"UserChar4":' + '\"'+ ApplicationLoadedBy +'\"'+',"UserChar3":' + '\"'+ ApplicationFundedBy +'\"'+',"OriginalDate":' + '\"'+ OriginalDate +'\"'+',"Type":' + '\"'+ Type +'\"'+',"Branch":' + '\"'+ Branch +'\"'+',"CreatedAtBranch":'+'\"'+ CreatedAtBranch +'\"'+',"PurposeCode":'+'\"' + PurposeCode + '\"'+',"CollateralCode":'+'\"'+CollateralCode+'\"'+',"ApprovalCode":'+'\"'+ApprovalCode+'\"'+',"OriginalBalance":'+'\"'+OriginalBalance+'\"'+',"ApprovalDate":'+'\"'+ApprovalDate+'\"'+',"MaturityDate":'+'\"'+MaturityDate+'\"'+',"DueDate":'+'\"'+DueDate+'\"'+',"FirstPaymentDate":'+'\"'+FirstPaymentDate+'\"'+',"DueDay1":'+'\"'+DueDay1+'\"'+',"Payment":'+'\"'+Payment+'\"'+',"CouponCode":'+'\"'+CouponCode+'\"'+',"PaymentMethod":'+'\"'+PaymentMethod+'\"'+',"Description":'+'\"'+Description+'\"'+',"InterestRate":'+'\"'+InterestRate+'\"'+',"UserAmount1":'+'\"'+UserAmount1+'\"'+',"ECOACode":'+'\"'+ECOACode+'\"'+',"CreditScore":'+'\"'+CreditScore+'\"'+',"PaymentCount":'+'\"'+PaymentCount+'\"'+',"PaymentFrequency":'+'\"'+PaymentFrequency+'\"'+',"AccountNumber":'+'\"'+AccountNumber+'\"}';
                        req.setBodyAsBlob(Blob.valueof(jsondata)); 
                        system.debug('test'+jsonData);
                        
                        Http http = new Http();  
                        req.setTimeout(60000);
                        HttpResponse res;
                        String responseBody;
                        if(!Test.isRunningTest()){                       
                            res = http.send(req);
                            responseBody = res.getBody();
                            System.debug('Response Body Solar Loan::'+res.getBody());    
                        }else{
                            responseBody = '{"Type":"3","Branch":"27","CreatedAtBranch":"1","PurposeCode":"1","CollateralCode":"100","ApprovalCode":"4","OriginalBalance":"1","ApprovalDate":"01-01-2019","MaturityDate":"01-01-2019","DueDate":"01-01-2019","FirstPaymentDate":"01-01-2019","DueDay1":"1","Payment":"1234","CouponCode":"123", "PaymentMethod" : "PaymentMethod", "Description" : "Description", "InterestRate" : "2.00", "UserAmount1" : "200.00", "ECOACode" : "778", "CreditScore" : "15", "PaymentCount" : "12", "PaymentFrequency" : "67"}';
                        }
                        
                        // JSon parse for Id                            
                        JSONParser parser = JSON.createParser(responseBody);
                        result = String.valueOf(responseBody).substringAfter('LoanId":"');
                        result = String.valueOf(result).substringBefore('",');
                        
                        System.debug('LoanId' + result);
                        if(result == null || result == ''){
                            
                            ErrorLoanLocator = String.valueOf(responseBody).substringAfter('[MessageId=TESTING] ');
                            ErrorLoanLocator = String.valueOf(ErrorLoanLocator).substringBefore('","ErrorDetails"');
                            system.debug('ErrorLoanLocator' + ErrorLoanLocator);
                        }
                    }
                
                    
    //----------------------------------------------------Create Loan Name--------------------------------------------------//                
                    if(sl.Joint_SSN__c != null){
                        
                        Type = '1';
                        Last = sl.Joint_Last_Name__c;
                        First = sl.Joint_First_Name__c;

                        if(sl.Joint_Address_1__c != null){
                            Street = sl.Joint_Address_1__c;
                            if(Street.contains('&') == true){
                                Street = Street.replace('&', '&#38;');
                            }
                        }
                    
                        if(sl.Joint_Address_2__c != null){
                            ExtraAddress = sl.Joint_Address_2__c;
                            if(ExtraAddress.contains('&') == true){
                                ExtraAddress = ExtraAddress.replace('&', '&#38;');
                            }
                        }

                        City = sl.Joint_City__c;
                        State = sl.Joint_State__c;
                        ZipCode = sl.Joint_Zip_Code__c;
                        if(sl.Joint_DOB__c != null){
                            BirthDate =  String.valueOf(sl.Joint_DOB__c);   
                        }
                        else{
                            BirthDate =  ' ';
                        }
                        
                        SSN = sl.Joint_SSN__c;
                    
                        if(sl.ECOA_Code__c != null){
                            ECOACode = sl.ECOA_Code__c;
                        }
                        else{
                            ECOACode = '0';
                        }
                    
                        LoanId = result;
                        AccountNumber = sl.Member_Number__c;
                        
                        System.debug('CreateLoanName method called');
                        req1.setEndpoint(loanAPI+'/EFT/CreateLoanName');
                    
                        req1.setMethod('POST');
                        req1.setHeader('Content-Type', 'application/json');
                        req1.setHeader('Accept', 'application/json');
                        
                        jsonData1 = '{"EcoaCode":'+'\"'+ECOACode+'\"'+',"Type":' + '\"'+ Type +'\"'+',"Last":' + '\"'+ Last +'\"'+',"First":'+'\"'+ First +'\"'+',"Street":'+'\"' + Street + '\"'+',"ExtraAddress":'+'\"'+ExtraAddress+'\"'+',"City":'+'\"'+City+'\"'+',"State":'+'\"'+State+'\"'+',"ZipCode":'+'\"'+ZipCode+'\"'+',"BirthDate":'+'\"'+BirthDate+'\"'+',"SSN":'+'\"'+SSN+'\"'+',"LoanId":'+'\"'+LoanId+'\"'+',"AccountNumber":'+'\"'+AccountNumber+'\"}';
                        req1.setBodyAsBlob(Blob.valueof(jsondata1)); 
                    //system.debug('test'+jsonData);
                        
                        Http http1 = new Http();  
                        req1.setTimeout(60000);
                        HttpResponse res1;
                        String responseBody1;
                        if(!Test.isRunningTest()){                       
                            res1 = http1.send(req1);
                            responseBody1 = res1.getBody();
                            System.debug('Response Body SolarLoan Name::'+res1.getBody());    
                        }else{
                            responseBody1 = '{"Type":"3","Last":"27","First":"1","Street":"1","ExtraAddress":"100","City":"Chicago","State":"IL","ZipCode":"0012345,"BirthDate":"01-01-2019","SSN":"1345","LoanId":"322271627","AccountNumber":"00000123456"}';
                            
                        }
                        // JSon parse for Id                            
                        JSONParser parser1 = JSON.createParser(responseBody1);
                        result1 = String.valueOf(responseBody1).substringAfter('LoanNameLocator":"');
                        result1 = String.valueOf(result1).substringBefore('",');
                        System.debug('LoanName' + result1);
                        
                        if(result1 == null || result1 == ''){
                            
                            ErrorLoanNameLocator = String.valueOf(responseBody1).substringAfter('Error",');
                            ErrorLoanNameLocator = String.valueOf(ErrorLoanNameLocator).substringBefore('","ErrorDetails"');
                            system.debug('ErrorLoanNameLocator' + ErrorLoanNameLocator);
                        }
                    }
    //-----------------------------------------------Create Loan Tracking---------------------------------------------------//        
                
                    Type = '33';
                    UserChar11 = sl.FNI__c;
                    
                    if(sl.Installer__c != null){
                        UserChar1 = sl.Installer__c;
                        if(UserChar1.contains('&') == true){
                            UserChar1 = UserChar1.replace('&', '&#38;');
                        }
                    }

                    UserChar2 = sl.Installer_Number__c;
                    UserChar3 = sl.Product__c;
                
                    if(sl.Module__c != null){
                        UserChar4 = sl.Module__c;
                        if(UserChar4.contains('&') == true){
                            UserChar4 = UserChar4.replace('&', '&#38;');
                        }
                    }
                    
                    if(sl.Inverter__c != null){
                        UserChar5 = sl.Inverter__c;
                        if(UserChar5.contains('&') == true){
                            UserChar5 = UserChar5.replace('&', '&#38;');
                        }
                        if(UserChar5.length() > 40){
                            UserChar5 = UserChar5.left(39);
                        }
                    }
                    system.debug('UserChar5'+UserChar5);
                    
                    UserChar10 = sl.Credit_Attributes__c;
                    UserChar20 = sl.Site_UUID__c;
                    if(sl.Loan_Amount__c != null)
                        UserAmount1 = String.ValueOf(sl.Loan_Amount__c);
                    else
                        UserAmount1 = '0';
                        
                    if(sl.OID_Fee__c != null)   
                        UserAmount2 = string.ValueOF(sl.OID_Fee__c);
                    else
                        UserAmount2 = '0';
                        
                    if(sl.Membership_Fee__c != null)    
                        UserAmount3 = string.ValueOF(sl.Membership_Fee__c);
                    else
                        UserAmount3 = '0';
                            
                    if(sl.Mortgage_Balance__c != null)  
                        UserAmount11 = string.ValueOF(sl.Mortgage_Balance__c);
                    else
                        UserAmount11 = '0';
                        
                    
                    if(sl.Go_To_Payment__c != null)
                        UserAmount12 = string.ValueOF(sl.Go_To_Payment__c);
                    else
                        UserAmount12 = '0';
                        
                    if(sl.Final_Payment_Amount__c != null)  
                        UserAmount13 = string.ValueOF(sl.Final_Payment_Amount__c);
                    else
                        UserAmount13 = '0';
                        
                    if(sl.ITC_Amount__c != null)    
                        UserAmount14 = String.ValueOF(sl.ITC_Amount__c);
                    else
                        UserAmount14 = '0'; 
                        
                    if(sl.Joint_FICO_Score__c != null)  
                        UserCode1 = string.ValueOF(sl.Joint_FICO_Score__c);
                    else
                        UserCode1 = '0';
                        
                    if(sl.ITC_Rate__c != null)  
                        UserRate1 = string.ValueOF(sl.ITC_Rate__c);
                    else
                        UserRate1 = '0';    
                    
                    if(sl.ACH_Discount__c == true)  
                        UserCode11 = '1';
                    else
                        UserCode11 = ' ';
                    
                    if(sl.ACH_Discount__c == true)  
                        UserDate11 = string.ValueOf(System.today());
                    else
                        UserDate11 = '';
                    
                    if(sl.Product_Loan_Type__c != null)  
                        UserChar6  = string.ValueOf(sl.Product_Loan_Type__c);
                    else
                        UserChar6  = ' ';    
                    
                    if(sl.Credit_Exception__c != null)  
                        UserChar7   = String.ValueOf(sl.Credit_Exception__c);
                    else
                        UserChar7   = null;

                    LoanId = result; 
                    AccountNumber = sl.Member_Number__c;
                    
                    System.debug('CreateLoanTracking method called');
                    req2.setEndpoint(loanAPI+'/EFT/CreateLoanTracking');
                    //req2.setClientCertificateName('brscmcapi');
                    req2.setMethod('POST');
                    req2.setHeader('Content-Type', 'application/json');
                    req2.setHeader('Accept', 'application/json');
                    
                    jsonData2 = '{"UserChar6":' + '\"'+ UserChar6 +'\"'+',"UserChar7":' + '\"'+ UserChar7 +'\"'+',"UserCode11":' + '\"'+ UserCode11 +'\"'+',"UserDate11":' + '\"'+ UserDate11 +'\"'+',"Type":' + '\"'+ Type +'\"'+',"UserChar11":' + '\"'+ UserChar11 +'\"'+',"UserChar1":'+'\"'+ UserChar1 +'\"'+',"UserChar2":'+'\"' + UserChar2 + '\"'+',"UserChar3":'+'\"'+UserChar3+'\"'+',"UserChar4":'+'\"'+UserChar4+'\"'+',"UserChar5":'+'\"'+UserChar5+'\"'+',"UserAmount14":'+'\"'+UserAmount14+'\"'+',"UserRate1":'+'\"'+UserRate1+'\"'+',"UserChar10":'+'\"'+UserChar10+'\"'+',"UserChar20":'+'\"'+UserChar20+'\"'+',"UserAmount1":'+'\"'+UserAmount1+'\"'+',"UserAmount2":'+'\"'+UserAmount2+'\"'+',"UserAmount3":'+'\"'+UserAmount3+'\"'+',"UserAmount11":'+'\"'+UserAmount11+'\"'+',"UserAmount12":'+'\"'+UserAmount12+'\"'+',"UserAmount13":'+'\"'+UserAmount13+'\"'+',"UserCode1":'+'\"'+UserCode1+'\"'+',"UserRate1":'+'\"'+UserRate1+'\"'+',"LoanId":'+'\"'+LoanId+'\"'+',"AccountNumber":'+'\"'+AccountNumber+'\"}';
                    req2.setBodyAsBlob(Blob.valueof(jsondata2)); 
                    system.debug('test'+jsonData2);
                    
                    Http http2 = new Http();  
                    req2.setTimeout(60000);
                    HttpResponse res2;
                    String responseBody2;
                    if(!Test.isRunningTest()){                       
                        res2 = http2.send(req2);
                        responseBody2 = res2.getBody();
                        System.debug('Response Body SolarLoan Tracking::'+res2.getBody());    
                    }else{
                        responseBody2 = '{"Type":"3","UserChar11":"27","UserChar1":"1","UserChar2":"1","UserChar3":"100","UserChar4":"4","UserChar5":"1","UserChar10":"01-01-2019","UserChar20":"01-01-2019","UserAmount1":"100.00","UserAmount2":"322271627","UserAmount3":"42006986568","UserAmount11":"BANK OF AMERICA","UserAmount12":"123","UserAmount13" : "UserAmount13","UserCode1" : "UserCode1", "LoanId" : "LoanId", "AccountNumber" : "AccountNumber"}';
                    }
                    // JSon parse for Id                            
                    JSONParser parser2 = JSON.createParser(responseBody2);
                    result2 = String.valueOf(responseBody2).substringAfter('LoanTrackingLocator":"');
                    result2 = String.valueOf(result2).substringBefore('",');
                    System.debug('LoanName Tracking' + result2);
                    
                    if(result2 == null || result2 == ''){
                            
                        ErrorLoanTrackingLocator = String.valueOf(responseBody2).substringAfter('Error",');
                        ErrorLoanTrackingLocator = String.valueOf(ErrorLoanTrackingLocator).substringBefore('","ErrorDetails"');
                        system.debug('ErrorLoanTrackingLocator' + ErrorLoanTrackingLocator);
                    }

    //----------------------------------------------------Creat Loan Funding-------------------------------------------------//                
                    
                    if(result2 != null && result != null){
                        
                        LoanId = result;
                        
                        if(sl.Loan_Amount__c != null)
                            Amount = Integer.valueOf(sl.Loan_Amount__c);
                        else
                            Amount = 0;
                            
                        AccountNumber = sl.Member_Number__c;
                        
                        System.debug('Funding method called');
                        req3.setEndpoint(loanAPI+'/Wires/FundLoan?accountNumber='+AccountNumber+'&loanId='+LoanId+'&amount='+Amount);
                        //req3.setClientCertificateName('brscmcapi');
                        req3.setMethod('GET');
                        req3.setHeader('Content-Type', 'application/json');
                        req3.setHeader('Accept', 'application/json');
                        
                        system.debug('test'+req3);
                        
                        Http http3 = new Http();  
                        req3.setTimeout(60000);
                        HttpResponse res3;
                        String responseBody3;
                        if(!Test.isRunningTest()){                       
                            res3 = http3.send(req3);
                            responseBody3 = res3.getBody();
                            System.debug('Response Body for Fund::'+res3.getBody());    
                        }else{
                            responseBody3 = '{"Type":"3","Last":"27","First":"1","Street":"1","ExtraAddress":"100","City":"Chicago","State":"IL","ZipCode":"0012345,"BirthDate":"01-01-2019","SSN":"1345","LoanId":"322271627","AccountNumber":"00000123456"}';
                            
                        }
                        // JSon parse for Id                            
                        /*JSONParser parser3 = JSON.createParser(responseBody3);
                        result3 = String.valueOf(responseBody3).substringAfter('LoanNameLocator":"');
                        result3 = String.valueOf(result3).substringBefore('",');
                        System.debug('LoanFund' + result3);
                        
                        if(result3 == null || result3 == ''){
                            
                            ErrorLoanNameLocator = String.valueOf(responseBody1).substringAfter('[MessageId=TESTING] ');
                            ErrorLoanNameLocator = String.valueOf(ErrorLoanNameLocator).substringBefore('","ErrorDetails"');
                            system.debug('ErrorLoanNameLocator' + ErrorLoanNameLocator);
                        }*/
                    }  
                                        
    //-------------------------------------------------Updating Solar Loan records -----------------------------------------//
                    
                    Solar_Loans__c s = new Solar_Loans__c();          
                    if(result != null && result != '')
                        s.Loan_Id__c = result;
                        
                    if(result1 != null && result1 != '')    
                        s.Loan_Name_Locator__c = result1;
                        
                    if(result2 != null && result2 != '')
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
                        Month = Integer.Valueof(sl.Term_months__c) - 1;
                        s.Maturity_Date__c = s.Due_Date__c.addMonths(Month);
                    }
                    system.debug('s.Maturity_Date__c'+s.Maturity_Date__c);
                    SolarLoanToUpdate.add(s);  
                }
                else{
                    
                    Solar_Loans__c s = new Solar_Loans__c();
                    s.id = sl.Id; 
                    s.Error_Loan_Locator__c = 'System is ofline';
                    SolarLoanToUpdate.add(s); 

                }
            }
            
        if(SolarLoanToUpdate.size() > 0){
            update SolarLoanToUpdate;
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

                SSN = sl.Primary_SSN__c;

                System.debug('GetMemberNumber method called');
               
                req1.setEndpoint(loanAPI+'/EFT/GetAccountBySSN?ssn='+SSN);
                req1.setMethod('GET');
                req1.setHeader('Content-Type', 'application/json');
                req1.setHeader('Accept', 'application/json');
                
                Http http1 = new Http();  
                req1.setTimeout(60000);
                HttpResponse res1;
                String responseBody1;
                if(!Test.isRunningTest()){                       
                    res1 = http1.send(req1);
                    responseBody1 = res1.getBody();
                    System.debug('Response Body SolarLoan:'+res1.getBody());    
                }else{
                    responseBody1 = '{"Type":"3","Last":"27","First":"1","Street":"1","ExtraAddress":"100","City":"Chicago","State":"IL","ZipCode":"0012345,"BirthDate":"01-01-2019","SSN":"1345","LoanId":"322271627","AccountNumber":"00000123456"}';
                    
                }
                
                JSONParser parser = JSON.createParser(responseBody1);
                result = String.valueOf(responseBody1).substringAfter('AccountNumber":"');
                result = String.valueOf(result).substringBefore('",');
                System.debug('Member Number' + result);

                if(result != null){
                    Solar_Loans__c s = new Solar_Loans__c(); 
                    s.id = sl.Id;       
                    s.Member_Number__c = result;
                    s.continue__c = false;
                    
                    SolarLoanToUpdate.add(s); 
                }

            }
            if(SolarLoanToUpdate.size() > 0){
                update SolarLoanToUpdate;
            }

    }    
}