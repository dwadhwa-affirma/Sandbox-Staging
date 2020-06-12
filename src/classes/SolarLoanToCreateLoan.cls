public class SolarLoanToCreateLoan {

    
    public static List<Solar_Loans__c> SolarLoanToUpdate = new List<Solar_Loans__c>();  
    public static String ErrorLoanLocator;
    public static String ErrorLoanNameLocator;
    public static String ErrorLoanTrackingLocator;
    
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
    public static Integer Month;
  
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
    
    public static String jsonData2;
    public static HttpRequest req2 = new HttpRequest();
    public static String result2;
    
    @future(callout=true)
    public static void createSolarLoans(Set<id> ids){
        
    List<Solar_Loans__c> Solanloanlist = new List<Solar_Loans__c>();         
    List<Solar_Loans__c> solarloans = [SELECT id,ABA_Bank_Name__c,ACH__c,Additional_Amount__c,Application_Date__c,
            Bank_Account_Number__c,Bank_Name__c,Battery__c,Brand__c,Change_Order__c,CreatedById,CreatedDate,
            Credit_Attributes__c,Credit_Exception__c,Debt_Ratio__c,DocuSignId__c,Due_Date__c,
            ECOA_Code__c,Final_Payment_Amount__c,FNI__c,Go_To_Payment__c,Initial_LT_Loan_Agreement__c,
            Installer_Number__c,Installer__c,Interest_Rate__c,Inverter__c,IsDeleted,Joint_Address_1__c,
            Joint_Address_2__c,Joint_City__c,Joint_DOB__c,Joint_FICO_Score__c,Joint_First_Name__c,Joint_Last_Name__c,
            Joint_SSN__c,Joint_State__c,Joint_Zip_Code__c,Latest_LT_Loan_Agreement__c,Legal_Description__c,Loan_Amount__c,Loan_Pmt_Amount__c,
            Loan_Type__c,Maturity_Date__c,Account_Number__r.name,Membership_Fee__c,Member_Number__c,Module__c,Mortgage_Balance__c,Name,
            Name__c,Net_Funding_Amount__c,OID_Fee__c,OwnerId,Primary_Address_1__c,Primary_Address_2__c,
            Primary_City__c,Primary_DOB__c,Primary_FICO_Score__c,Primary_First_Name__c,Primary_Last_Name__c,
            Primary_SSN__c,Primary_State__c,Primary_Zip_Code__c,Product_Loan_Type__c,Product__c,Record_ID__c,
            Routing_Number__c,Site_UUID__c,Status__c,Symitar_Called__c,SystemModstamp,System_Size_kW__c,Term_months__c,
            Valid_ABA__c, Loan_Id__c,Loan_Name_Locator__c,Loan_Tracking_Locator__c,EftLocator__c,
            Error_EftLocator__c,Error_Loan_Locator__c,Error_Loan_Name_Locator__c,Error_Loan_Tracking_Locator__c,
            ITC_Amount__c, ITC_Rate__c
            FROM Solar_Loans__c where id =: ids];
    
            for(Solar_Loans__c sl : solarloans){
                
                Type = '75';
                Branch = '96';
                CreatedAtBranch = '96';
                PurposeCode = '16';
                CollateralCode = '4';
                ApprovalCode = '9002';
                if(sl.Net_Funding_Amount__c != null)
                    OriginalBalance = string.valueOf(sl.Net_Funding_Amount__c);
                else
                    OriginalBalance = '0.00';
                ApprovalDate = string.valueof(sl.Application_Date__c);
                if(sl.Maturity_Date__c != null){
                    MaturityDate = String.valueOf(sl.Maturity_Date__c);
                }
                else{
                    MaturityDate = null;
                }
               //----------------------------------------------------------------// 
                if(sl.Due_Date__c != null){
                    
                    DueDate = string.valueof(sl.Due_Date__c);
                    FirstPaymentDate = string.valueof(sl.Due_Date__c + 1);
                }
                else{
                    DueDate = null;
                    FirstPaymentDate = null;
                }
                //----------------------------------------------------------------//
                if(sl.Due_Date__c != null){
                    DueDay1 = String.valueof(sl.Due_Date__c.day());
                }
                else{
                    DueDay1 = '15';
                }
                
                Payment = string.valueof(sl.Loan_Pmt_Amount__c);
                CouponCode = '1';
                
                PaymentMethod = '0';
                
                Description = 'SECURED SOLAR';
                InterestRate = string.valueof(sl.Interest_Rate__c);
                UserAmount1 = string.valueof(sl.Debt_Ratio__c);
                ECOACode = sl.ECOA_Code__c;
                CreditScore = String.valueOf(sl.Primary_FICO_Score__c);
                PaymentCount = String.valueOf(sl.Term_months__c);
                PaymentFrequency = '04';
                AccountNumber = sl.Account_Number__r.name;
                
                
                //req.setEndpoint('https://brscsymx.ctxcu.org/dev/EFT/CreateLoan');
                req.setEndpoint('https://symxapi.chevronfcu.org/devclient/EFT/CreateLoan');
                req.setClientCertificateName('brscmcapi');
                req.setMethod('POST');
                req.setHeader('Content-Type', 'application/json');
                req.setHeader('Accept', 'application/json');
                
                jsonData = '{"Type":' + '\"'+ Type +'\"'+',"Branch":' + '\"'+ Branch +'\"'+',"CreatedAtBranch":'+'\"'+ CreatedAtBranch +'\"'+',"PurposeCode":'+'\"' + PurposeCode + '\"'+',"CollateralCode":'+'\"'+CollateralCode+'\"'+',"ApprovalCode":'+'\"'+ApprovalCode+'\"'+',"OriginalBalance":'+'\"'+OriginalBalance+'\"'+',"ApprovalDate":'+'\"'+ApprovalDate+'\"'+',"MaturityDate":'+'\"'+MaturityDate+'\"'+',"DueDate":'+'\"'+DueDate+'\"'+',"FirstPaymentDate":'+'\"'+FirstPaymentDate+'\"'+',"DueDay1":'+'\"'+DueDay1+'\"'+',"Payment":'+'\"'+Payment+'\"'+',"CouponCode":'+'\"'+CouponCode+'\"'+',"PaymentMethod":'+'\"'+PaymentMethod+'\"'+',"Description":'+'\"'+Description+'\"'+',"InterestRate":'+'\"'+InterestRate+'\"'+',"UserAmount1":'+'\"'+UserAmount1+'\"'+',"ECOACode":'+'\"'+ECOACode+'\"'+',"CreditScore":'+'\"'+CreditScore+'\"'+',"PaymentCount":'+'\"'+PaymentCount+'\"'+',"PaymentFrequency":'+'\"'+PaymentFrequency+'\"'+',"AccountNumber":'+'\"'+AccountNumber+'\"}';
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
                
//--------------------------------------------------------------------------------------------------------------------------------//                
                if(sl.Joint_SSN__c != null){
                    
                    Type = '1';
                    Last = sl.Joint_Last_Name__c;
                    First = sl.Joint_First_Name__c;
                    Street = sl.Joint_Address_1__c;
                    ExtraAddress = sl.Joint_Address_2__c;
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
                    LoanId = result;
                    AccountNumber = sl.Account_Number__r.name;
                    
                    req1.setEndpoint('https://symxapi.chevronfcu.org/devclient/EFT/CreateLoanName');
                    req1.setClientCertificateName('brscmcapi');
                    req1.setMethod('POST');
                    req1.setHeader('Content-Type', 'application/json');
                    req1.setHeader('Accept', 'application/json');
                    
                    jsonData1 = '{"Type":' + '\"'+ Type +'\"'+',"Last":' + '\"'+ Last +'\"'+',"First":'+'\"'+ First +'\"'+',"Street":'+'\"' + Street + '\"'+',"ExtraAddress":'+'\"'+ExtraAddress+'\"'+',"City":'+'\"'+City+'\"'+',"State":'+'\"'+State+'\"'+',"ZipCode":'+'\"'+ZipCode+'\"'+',"BirthDate":'+'\"'+BirthDate+'\"'+',"SSN":'+'\"'+SSN+'\"'+',"LoanId":'+'\"'+LoanId+'\"'+',"AccountNumber":'+'\"'+AccountNumber+'\"}';
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
                        
                        ErrorLoanNameLocator = String.valueOf(responseBody1).substringAfter('[MessageId=TESTING] ');
                        ErrorLoanNameLocator = String.valueOf(ErrorLoanNameLocator).substringBefore('","ErrorDetails"');
                        system.debug('ErrorLoanNameLocator' + ErrorLoanNameLocator);
                    }
                }
//--------------------------------------------------------------------------------------------------------------------------------//        
            
                Type = '33';
                UserChar11 = sl.FNI__c;
                UserChar1 = sl.Installer__c;
                UserChar2 = sl.Installer_Number__c;
                UserChar3 = sl.Product__c;
                UserChar4 = sl.Module__c;
                
                if(sl.Inverter__c != null){
                    UserChar5 = sl.Inverter__c;
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
                        
                LoanId = result;
                AccountNumber = sl.Account_Number__r.name;
                
                req2.setEndpoint('https://symxapi.chevronfcu.org/devclient/EFT/CreateLoanTracking');
                req2.setClientCertificateName('brscmcapi');
                req2.setMethod('POST');
                req2.setHeader('Content-Type', 'application/json');
                req2.setHeader('Accept', 'application/json');
                
                jsonData2 = '{"Type":' + '\"'+ Type +'\"'+',"UserChar11":' + '\"'+ UserChar11 +'\"'+',"UserChar1":'+'\"'+ UserChar1 +'\"'+',"UserChar2":'+'\"' + UserChar2 + '\"'+',"UserChar3":'+'\"'+UserChar3+'\"'+',"UserChar4":'+'\"'+UserChar4+'\"'+',"UserChar5":'+'\"'+UserChar5+'\"'+',"UserAmount14":'+'\"'+UserAmount14+'\"'+',"UserRate1":'+'\"'+UserRate1+'\"'+',"UserChar10":'+'\"'+UserChar10+'\"'+',"UserChar20":'+'\"'+UserChar20+'\"'+',"UserAmount1":'+'\"'+UserAmount1+'\"'+',"UserAmount2":'+'\"'+UserAmount2+'\"'+',"UserAmount3":'+'\"'+UserAmount3+'\"'+',"UserAmount11":'+'\"'+UserAmount11+'\"'+',"UserAmount12":'+'\"'+UserAmount12+'\"'+',"UserAmount13":'+'\"'+UserAmount13+'\"'+',"UserCode1":'+'\"'+UserCode1+'\"'+',"UserRate1":'+'\"'+UserRate1+'\"'+',"LoanId":'+'\"'+LoanId+'\"'+',"AccountNumber":'+'\"'+AccountNumber+'\"}';
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
                        
                    ErrorLoanTrackingLocator = String.valueOf(responseBody2).substringAfter('[MessageId=TESTING] ');
                    ErrorLoanTrackingLocator = String.valueOf(ErrorLoanTrackingLocator).substringBefore('","ErrorDetails"');
                    system.debug('ErrorLoanTrackingLocator' + ErrorLoanTrackingLocator);
                }
                    
                
                Solar_Loans__c s = new Solar_Loans__c();         
                if(result != null && result != '')
                    s.Loan_Id__c = result;
                    
                if(result1 != null && result1 != '')    
                    s.Loan_Name_Locator__c = result1;
                    
                if(result2 != null && result2 != '')
                    s.Loan_Tracking_Locator__c = result2;
                      
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
                
                if(sl.Term_months__c != null){
                	Month = Integer.Valueof(sl.Term_months__c) - 1;
                	s.Maturity_Date__c = s.Due_Date__c.addMonths(Month);
                }
                system.debug('s.Maturity_Date__c'+s.Maturity_Date__c);
                SolarLoanToUpdate.add(s);  
                
            }
            
        if(SolarLoanToUpdate.size() > 0){
            update SolarLoanToUpdate;
        }
    }
}