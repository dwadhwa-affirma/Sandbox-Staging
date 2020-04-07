public class SolarLoanToCreateLoan {

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
    
    public static String jsonData;
    public static HttpRequest req = new HttpRequest();
    
    @future(callout=true)
    public static void insertSolarLoans(List<id> ids){
    	
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
        	Valid_ABA__c FROM Solar_Loans__c where id =: ids];
    
    		for(Solar_Loans__c sl : solarloans){
                
            	Type = '75';
                Branch = '96';
                CreatedAtBranch = '96';
                PurposeCode = '16';
                CollateralCode = '4';
                ApprovalCode = '9002';
                OriginalBalance = string.valueOf(sl.Net_Funding_Amount__c);
                ApprovalDate = 'APPROVAL DATE';
                if(sl.Maturity_Date__c != null){
                	MaturityDate = String.valueOf(sl.Maturity_Date__c);
                }
                else{
                	MaturityDate = null;
                }
               //----------------------------------------------------------------// 
                if(sl.Due_Date__c != null){
                	
                    DueDate = string.valueof(sl.Due_Date__c + 1);
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
            		DueDay1 = '0';
            	}
            	
                Payment = 'TempPayAmt';
                CouponCode = 'LoanCouponCode';
                PaymentMethod = 'LoanPayMethod';
                Description = 'SECURED SOLAR';
                InterestRate = string.valueof(sl.Interest_Rate__c);
                UserAmount1 = string.valueof(sl.Debt_Ratio__c);
                ECOACode = sl.ECOA_Code__c;
                CreditScore = String.valueOf(sl.Primary_FICO_Score__c);
                PaymentCount = String.valueOf(sl.Term_months__c);
                PaymentFrequency = '04';
                
                
                 req.setEndpoint('https://brscsymx.ctxcu.org/dev/EFT/CreateLoanName');
                //req.setEndpoint('https://symxapi.chevronfcu.org/dev/EFT/CreateEft');
                req.setClientCertificateName('brscmcapi');
                req.setMethod('POST');
                req.setHeader('Content-Type', 'application/json');
                req.setHeader('Accept', 'application/json');
                
                jsonData = '{"Type":' + '\"'+ Type +'\"'+',"Branch":' + '\"'+ Branch +'\"'+',"CreatedAtBranch":'+'\"'+ CreatedAtBranch +'\"'+',"PurposeCode":'+'\"' + PurposeCode + '\"'+',"CollateralCode":'+'\"'+CollateralCode+'\"'+',"ApprovalCode":'+'\"'+ApprovalCode+'\"'+',"OriginalBalance":'+'\"'+OriginalBalance+'\"'+',"ApprovalDate":'+'\"'+ApprovalDate+'\"'+',"MaturityDate":'+'\"'+MaturityDate+'\"'+',"DueDate":'+'\"'+DueDate+'\"'+',"FirstPaymentDate":'+'\"'+FirstPaymentDate+'\"'+',"DueDay1":'+'\"'+DueDay1+'\"'+',"Payment":'+'\"'+Payment+'\"'+',"CouponCode":'+'\"'+CouponCode+'\"'+',"PaymentMethod":'+'\"'+PaymentMethod+'\"'+',"Description":'+'\"'+Description+'\"'+',"InterestRate":'+'\"'+InterestRate+'\"'+',"UserAmount1":'+'\"'+UserAmount1+'\"'+',"ECOACode":'+'\"'+ECOACode+'\"'+',"CreditScore":'+'\"'+CreditScore+'\"'+',"PaymentCount":'+'\"'+PaymentCount+'\"'+',"PaymentFrequency":'+'\"'+PaymentFrequency+'\"}';
                
                
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
                
            }
    
	}
}