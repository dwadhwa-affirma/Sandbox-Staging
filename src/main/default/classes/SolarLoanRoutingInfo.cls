public class SolarLoanRoutingInfo {

public static List<Solar_Loans__c> SolarLoanToUpdate = new List<Solar_Loans__c>();  
public static String jsonData;  
public static HttpRequest req = new HttpRequest();
public static String BankName;
public static Integer Code;    
public static String RoutingNumber;  
public static String responseBody;    
    
    @future(callout=true)
    public static void getABABankName(Set<id> ids){
        
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
        	Error_EftLocator__c,Error_Loan_Locator__c,Error_Loan_Name_Locator__c,Error_Loan_Tracking_Locator__c
        	FROM Solar_Loans__c where id =: ids];
        
       	for(Solar_Loans__c sl : solarloans){        
        
    		RoutingNumber = sl.Routing_Number__c;
    	
    		req.setEndpoint('https://www.routingnumbers.info/api/data.json?rn='+RoutingNumber);
        	req.setMethod('POST');
        	req.setHeader('Content-Type', 'application/json');
        	req.setHeader('Accept', 'application/json');
        
        	Http http = new Http();  
        	req.setTimeout(60000);
        	HttpResponse res;
        	
        	if(!Test.isRunningTest()){                       
            	res = http.send(req);
            	responseBody = res.getBody();
            	System.debug('Response Body::'+res.getBody());    
      	  	}else{
       	    	responseBody = '{"office_code": "O", "telephone": "800-937-6310", "change_date": "061109", "rn": "122105155", "state": "MN", "zip": "55107-1419", "data_view_code": "1", "message": "OK", "address": "EP-MN-WN1A", "customer_name": "US BANK NA", "city": "ST. PAUL"}';
	      	}
        
        	if(responseBody!=''){        
       			Map<String,Object> results = (Map<String,Object>) JSON.deserializeUntyped(responseBody);      
         		System.debug('Service response is ....' + results);
                if(results.size() > 0){
                	
                   for(String key : results.keySet()){                   			
                       	if(key == 'customer_name'){
                       		BankName = (string)results.get(key);
                       	}
                       	if(key == 'code'){
                       		Code = (Integer)results.get(key);
                       	}
       				}
                }
            }
        	System.debug('Bank Name:' + BankName);
            
            Solar_Loans__c s = new Solar_Loans__c();
            s.id = sl.id;
            if(BankName != null && BankName != '')
            	s.ABA_Bank_Name__c = BankName;
            system.debug('Code'+Code);	
            if(Code == 404)
            	s.ABA_Bank_Name__c = 'Bank name not found';
            		
            SolarLoanToUpdate.add(s);
        }
        if(SolarLoanToUpdate.size() > 0){
            update SolarLoanToUpdate;
        }		
    }
}