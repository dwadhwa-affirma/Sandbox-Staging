public class SolarLoanToCreateLoanTracking {

    public static String Type;
    public static String UserChar11;
    public static String UserChar1;
    public static String UserChar2;
    public static String UserChar3;
    public static String UserChar4;
    public static String UserChar5;
    public static String UserChar10;
    public static String UserChar20;
    public static String UserAmount1;
    public static String UserAmount2;
    public static String UserAmount3;
    public static String UserAmount11;
    public static String UserAmount12;
    public static String UserAmount13;
    public static String UserCode1;
    public static String LoanId;
    public static String AccountNumber; 
    
    
    public static String jsonData;
    public static HttpRequest req = new HttpRequest(); 
    
    @future(callout=true)
    public static void createSolarLoanTracking(Set<id> ids){
    	
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
        	Valid_ABA__c,Loan_Id__c FROM Solar_Loans__c where id =: ids];
    
    		for(Solar_Loans__c sl : solarloans){
                
            	Type = '0';
                UserChar11 = 'FNINUMBER';
                UserChar1 = 'Installer';
                UserChar2 = 'InstallerNum';
                UserChar3 = 'Product';
                UserChar4 = 'Module';
                UserChar5 = 'Inverter';
                UserChar10 = 'CreditAttri';
                UserChar20 = 'SiteUUID';
                UserAmount1 = 'LoanAmount';
                UserAmount2 = 'OIDFee';
                UserAmount3 = 'MEMFEE';
                UserAmount11 = 'MortBal';
                UserAmount12 = 'NewPayAmt';
                UserAmount13 = 'FinalPayAmt';
                UserCode1 = 'JointFICOScore';
                LoanId = sl.Loan_Id__c;
                AccountNumber = '123';
                
                 req.setEndpoint('https://brscsymx.ctxcu.org/dev/EFT/CreateLoanTracking');
                //req.setEndpoint('https://symxapi.chevronfcu.org/dev/EFT/CreateEft');
                req.setClientCertificateName('brscmcapi');
                req.setMethod('POST');
                req.setHeader('Content-Type', 'application/json');
                req.setHeader('Accept', 'application/json');
                
                jsonData = '{"Type":' + '\"'+ Type +'\"'+',"UserChar11":' + '\"'+ UserChar11 +'\"'+',"UserChar1":'+'\"'+ UserChar1 +'\"'+',"UserChar2":'+'\"' + UserChar2 + '\"'+',"UserChar3":'+'\"'+UserChar3+'\"'+',"UserChar4":'+'\"'+UserChar4+'\"'+',"UserChar5":'+'\"'+UserChar5+'\"'+',"UserChar10":'+'\"'+UserChar10+'\"'+',"UserChar20":'+'\"'+UserChar20+'\"'+',"UserAmount1":'+'\"'+UserAmount1+'\"'+',"UserAmount2":'+'\"'+UserAmount2+'\"'+',"UserAmount3":'+'\"'+UserAmount3+'\"'+',"UserAmount11":'+'\"'+UserAmount11+'\"'+',"UserAmount12":'+'\"'+UserAmount12+'\"'+',"UserAmount13":'+'\"'+UserAmount13+'\"'+',"UserCode1":'+'\"'+UserCode1+'\"'+',"LoanId":'+'\"'+LoanId+'\"'+',"AccountNumber":'+'\"'+AccountNumber+'\"}';
                
                
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
                    responseBody = '{"Type":"3","UserChar11":"27","UserChar1":"1","UserChar2":"1","UserChar3":"100","UserChar4":"4","UserChar5":"1","UserChar10":"01-01-2019","UserChar20":"01-01-2019","UserAmount1":"100.00","UserAmount2":"322271627","UserAmount3":"42006986568","UserAmount11":"BANK OF AMERICA","UserAmount12":"123","UserAmount13" : "UserAmount13","UserCode1" : "UserCode1", "LoanId" : "LoanId", "AccountNumber" : "AccountNumber"}';
                }
                
                String result;
    
        		// JSon parse for Id                            
        		JSONParser parser = JSON.createParser(responseBody);    
                
            }
    
	}
}