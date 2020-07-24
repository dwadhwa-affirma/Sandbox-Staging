public class SolarLoanToSymitar {
    
    public static String EFTType;
    public static String AmountCode;
    public static String GroupNumber;
    public static String IDType;
    public static String ID;
    public static String Frequency;
    public static String Day1;
    public static String NextDate;
    public static String EffectiveDate;
    public static String PostAmount;
    public static String Payee;
    public static String Reference;
    public static String MatchID3;
    public static String AccountNumber;
    public static String ErrorEFTLocator;
    public static String loanAPI;
    
    
    public static String PaymentMethod;
    
    public static String jsonData;
    public static String jsonData1;  
    public static HttpRequest req = new HttpRequest();
    public static HttpRequest req1 = new HttpRequest();
    public static String result;
    public static List<Solar_Loans__c> SolarLoanToUpdate = new List<Solar_Loans__c>();
    
    @future(callout=true)
    public static void insertSolarLoans(Set<id> ids){
        
    List<Solar_Loans__c> Solanloanlist = new List<Solar_Loans__c>();         
    List<Solar_Loans__c> solarloans = [SELECT id,ABA_Bank_Name__c,ACH__c,Additional_Amount__c,Application_Date__c,
            Bank_Account_Number__c,Bank_Name__c,Battery__c,Brand__c,Change_Order__c,CreatedById,CreatedDate,
            Credit_Attributes__c,Credit_Exception__c,Debt_Ratio__c,DocuSignId__c,Due_Date__c,
            ECOA_Code__c,Final_Payment_Amount__c,FNI__c,Go_To_Payment__c,Initial_LT_Loan_Agreement__c,
            Installer_Number__c,Installer__c,Interest_Rate__c,Inverter__c,IsDeleted,Joint_Address_1__c,
            Joint_Address_2__c,Joint_City__c,Joint_DOB__c,Joint_FICO_Score__c,Joint_First_Name__c,Joint_Last_Name__c,
            Joint_SSN__c,Joint_State__c,Joint_Zip_Code__c,Latest_LT_Loan_Agreement__c,Legal_Description__c,Loan_Amount__c,Loan_Pmt_Amount__c,
            Loan_Type__c,Maturity_Date__c,Membership_Fee__c,Member_Number__c,Module__c,Mortgage_Balance__c,Name,
            Name__c,Net_Funding_Amount__c,OID_Fee__c,OwnerId,Primary_Address_1__c,Primary_Address_2__c,
            Primary_City__c,Primary_DOB__c,Primary_FICO_Score__c,Primary_First_Name__c,Primary_Last_Name__c,
            Primary_SSN__c,Primary_State__c,Primary_Zip_Code__c,Product_Loan_Type__c,Product__c,Record_ID__c,
            Routing_Number__c,Site_UUID__c,Status__c,Symitar_Called__c,SystemModstamp,System_Size_kW__c,Term_months__c,
            Valid_ABA__c,Loan_Id__c,Account_Number__r.name,Loan_Name_Locator__c,Loan_Tracking_Locator__c, 
            Error_EftLocator__c,Error_Loan_Locator__c,Error_Loan_Name_Locator__c,Error_Loan_Tracking_Locator__c,
            EftLocator__c FROM Solar_Loans__c where id =: ids];
    
            for(Solar_Loans__c sl : solarloans){
                
                //--------------------------------Fetching API URL from custom setting to create EFT record--------------------------//

                SolarLoan_To_Episys_API_Details__c api = SolarLoan_To_Episys_API_Details__c.getValues('ProductionURL');
                
                if(api.URL__c != null){
                    loanAPI = api.URL__c;
                }

                EFTType = '3';
                if(sl.Loan_Type__c == 'Savings Account')
                    AmountCode = '37' ;
               //   else if(sl.Loan_Type__c == 'Checking Account')
               //       AmountCode = '27';
                else
                    AmountCode = '27';
                    
                if(sl.Brand__c == 'Spectrum')
                    GroupNumber = '000006' ;
                else if(sl.Brand__c == 'Chevron')
                    GroupNumber = '000001';
                else
                    GroupNumber = ' ';
               
                IDType = '1';
                ID = sl.Loan_Id__C;
                Frequency = '4';
                
                if(sl.Due_Date__c != null){
                    Day1 = '0'; //String.valueof(sl.Due_Date__c.day());
                }
                else{
                    Day1 = '0';
                }   
                if(sl.Due_Date__c != null){
                    
                    NextDate = string.valueof(sl.Due_Date__c + 1);
                    EffectiveDate = string.valueof(sl.Due_Date__c + 1);
                }
                else{
                    NextDate = null;
                    EffectiveDate = null;
                }
                
                if(sl.Additional_Amount__c != null)
                    PostAmount = String.ValueOf(sl.Additional_Amount__c);
                else
                    PostAmount = '0.00';
                Payee = sl.Routing_Number__c;
                Reference = sl.Bank_Account_Number__c ;
                if(sl.ABA_Bank_Name__c != null){
                    MatchID3 = sl.ABA_Bank_Name__c;
                    if(MatchID3.length() > 22){
                        MatchID3 = MatchID3.left(21);
                    }
                }
                
                system.debug('MatchID3'+MatchID3);    
                AccountNumber = sl.Account_Number__r.name;
                
                //req.setEndpoint('https://brscsymx.ctxcu.org/dev/EFT/CreateEft');
                req.setEndpoint(loanAPI+'/EFT/CreateEft');
                req.setClientCertificateName('brscmcapi');
                req.setMethod('POST');
                req.setHeader('Content-Type', 'application/json');
                req.setHeader('Accept', 'application/json');
                
                jsonData = '{"EFTType":' + '\"'+ EFTType +'\"'+',"AmountCode":' + '\"'+ AmountCode +'\"'+',"GroupNumber":'+'\"'+ GroupNumber +'\"'+',"IdType":'+'\"' + IDType + '\"'+',"ID":'+'\"'+ID+'\"'+',"Frequency":'+'\"'+Frequency+'\"'+',"Day1":'+'\"'+Day1+'\"'+',"NextDate":'+'\"'+NextDate+'\"'+',"EffectiveDate":'+'\"'+EffectiveDate+'\"'+',"PostAmount":'+'\"'+PostAmount+'\"'+',"Payee":'+'\"'+Payee+'\"'+',"Reference":'+'\"'+Reference+'\"'+',"MatchId3":'+'\"'+MatchID3+'\"'+',"AccountNumber":'+'\"'+AccountNumber+'\"}';
                //jsonData = '{"EFTType": 3,"AmountCode": 27,"GroupNumber": "000001","IdType": 0, "ID": "0100", "Frequency": 4,"Day1": 0,"NextDate": "2019-01-08","EffectiveDate": "2019-01-09","PostAmount": "100.00", "Payee": "0322271627","Reference": "42006986568","MatchId3": "BANK OF AMERICA, N.A.","AccountNumber": "123"}';
                req.setBodyAsBlob(Blob.valueof(jsondata)); 
                system.debug('test'+jsonData);
                
                Http http = new Http();  
                req.setTimeout(60000);
                HttpResponse res;
                String responseBody;
                if(!Test.isRunningTest()){                       
                    res = http.send(req);
                    responseBody = res.getBody();
                    System.debug('Response Body::'+res.getBody());    
                }else{
                    responseBody = '{"EFTType":"3","AmountCode":"27","GroupNumber":"1","IdType":"1","ID":"100","Frequency":"4","Day1":"1","NextDate":"01-01-2019","EffectiveDate":"01-01-2019","PostAmount":"100.00","Payee":"322271627","Reference":"42006986568","MatchId3":"BANK OF AMERICA","AccountNumber":"123"}';
                }
                
                String result;
    
                // JSon parse for Id                            
                JSONParser parser = JSON.createParser(responseBody);    
                result = String.valueOf(responseBody).substringAfter('EftLocator":"');
                result = String.valueOf(result).substringBefore('",');
                System.debug('EFTLocator' + result);
                
                if(result == null || result == ''){
                        
                    ErrorEFTLocator = String.valueOf(responseBody).substringAfter('[MessageId=TESTING] ');
                    ErrorEFTLocator = String.valueOf(ErrorEFTLocator).substringBefore('","ErrorDetails"');
                    system.debug('ErrorEFTLocator' + ErrorEFTLocator);
                }
                if(result != null && result != '' && sl.ACH__c == 'True'){
                	
                	PaymentMethod = '5';
                	req1.setEndpoint('https://symxapi.chevronfcu.org/devclient/EFT/UpdateLoanById');
	                req1.setClientCertificateName('brscmcapi');
	                req1.setMethod('POST');
	                req1.setHeader('Content-Type', 'application/json');
	                req1.setHeader('Accept', 'application/json');
	                
	                jsonData1 = '{"AccountNumber":'+'\"'+AccountNumber+'\","LoanId":' + '\"'+ ID +'\"'+',"PaymentMethod":'+'\"'+PaymentMethod+'\"}';
	                req1.setBodyAsBlob(Blob.valueof(jsondata1)); 
	                system.debug('test'+jsonData1);
	                
	                Http http1 = new Http();  
	                req1.setTimeout(60000);
	                HttpResponse res1;
	                String responseBody1;
	                if(!Test.isRunningTest()){                       
	                    res1 = http1.send(req1);
	                    responseBody1 = res1.getBody();
	                    System.debug('Response Body Solar Loan::'+res1.getBody());    
	                }else{
	                    responseBody1 = '{"Type":"3","Branch":"27","CreatedAtBranch":"1","PurposeCode":"1","CollateralCode":"100","ApprovalCode":"4","OriginalBalance":"1","ApprovalDate":"01-01-2019","MaturityDate":"01-01-2019","DueDate":"01-01-2019","FirstPaymentDate":"01-01-2019","DueDay1":"1","Payment":"1234","CouponCode":"123", "PaymentMethod" : "PaymentMethod", "Description" : "Description", "InterestRate" : "2.00", "UserAmount1" : "200.00", "ECOACode" : "778", "CreditScore" : "15", "PaymentCount" : "12", "PaymentFrequency" : "67"}';
	                }
                }
                
                Solar_Loans__c s = new Solar_Loans__c();         
                
                if(result != null && result != '')
                    s.EftLocator__c = result;
                
                if(ErrorEFTLocator != null && ErrorEFTLocator != '')
                    s.Error_EftLocator__c = ErrorEFTLocator;
                else
                    s.Error_EftLocator__c = ''; 
                s.id = sl.Id;                      
                SolarLoanToUpdate.add(s);  
                
                
            }
        if(SolarLoanToUpdate.size() > 0){
            update SolarLoanToUpdate;
        }
    }
}