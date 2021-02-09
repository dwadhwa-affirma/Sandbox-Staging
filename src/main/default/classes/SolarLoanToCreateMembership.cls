public class SolarLoanToCreateMembership {
      
    public static List<Solar_Loans__c> SolarLoanToUpdate = new List<Solar_Loans__c>();
    public static string operatorid;
    public static string loanAPI;
    public static string ProductTypeDescription;
    public static string AccountNumber;
    
    //-----------------------------------------------------Membership Check------------------------------------------//

    public static HttpRequest req = new HttpRequest();
    public static HttpResponse res;
    public static Http http = new Http();
    public static string responseBody;
    public static string MembershipExist;
    
    //-----------------------------------------------------Membership Create------------------------------------------//

    public static HttpRequest req1 = new HttpRequest();
    public static HttpResponse res1;
    public static Http http1 = new Http();
    public static string responseBody1;
    public static string jsonData1;
 	
    
    @future(callout=true)
    public static void createMembership(Set<id> ids){
    
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
            
            
            //--------------------------Checking if Loan record already exist for this member number ---------------------------------//
            
            AccountNumber = sl.Member_Number__c;
            
            //req.setEndpoint(loanAPI+'/PSAuto/GetLoansSelectFields?accountNumber='+AccountNumber);
            req.setMethod('GET');
            req.setHeader('Content-Type', 'application/json');
            req.setHeader('Accept', 'application/json');
            req.setTimeout(60000);                   
            
            if(!Test.isRunningTest()){                       
                res = http.send(req);
                responseBody = res.getBody();
                System.debug('Membership Exists???::'+responseBody);    
            }
            else{
                //responseBody = '{"LoanId" : "7500","Payment" : "4500.00"}';
                responseBody = '[{"LoanId":"7500","Status":null,"Error":null,"ErrorDetails":null}]';
            }
            
            if(responseBody != '' && responseBody != null){        
                List<object> results = (List<Object>) JSON.deserializeUntyped(responseBody);      
                System.debug('Response is ....' + results);
                
                if(results.size() > 0){
                    for(Object key : results){ 
                        Map<String, Object> MembershipCheck = (Map<String, Object>)key;
                        for(String l : MembershipCheck.keyset()) {
                            if(l == 'MembershipCheck'){
                                //MembershipExist = String.valueOf(MembershipCheck.get(l));
                            }
                        }    
                    }
                }
            }
          
            if(MembershipExist == 'true'){
                
                System.debug('Membership is already exist:: '+ MembershipExist);    
            }
            else{    
                
                System.debug('Creating Membership Account');
                
                AccountNumber = sl.Member_Number__c;
                System.debug('Calling createAccount method');
                //req1.setEndpoint(loanAPI+'/EFT/createAccount');
                req1.setMethod('POST');
                req1.setHeader('Content-Type', 'application/json');
                req1.setHeader('Accept', 'application/json');
                
                jsonData1 = '{"AccountNumber":'+'\"'+AccountNumber+'\"}';
                req1.setBodyAsBlob(Blob.valueof(jsondata1)); 
                system.debug('test'+jsonData1);
                
                Http http1 = new Http();  
                req1.setTimeout(60000);
                HttpResponse res1;
                
                if(!Test.isRunningTest()){                       
                    res1 = http1.send(req1);
                    responseBody1 = res1.getBody();
                    System.debug('CreateAccount Response::'+res1.getBody());    
                }else{
                    responseBody1 = '{"Type":"3","PaymentFrequency" : "67"}';
                }
                
                if(responseBody1 != '' && responseBody1 != null){        
                    List<object> results = (List<Object>) JSON.deserializeUntyped(responseBody1);      
                    System.debug('Response is ....' + results);
                    
                    if(results.size() > 0){
                        for(Object key : results){ 
                            Map<String, Object> Membership = (Map<String, Object>)key;
                            for(String l : Membership.keyset()) {
                                if(l == 'Membership'){
                                    //Membership = String.valueOf(Membership.get(l));
                                }
                            }    
                        }
                    }
                }
            }
            
            //---------------------------Updating Solar Loan records -------------------------------------//
            
            Solar_Loans__c s = new Solar_Loans__c();          
            s.id = sl.Id;       
            SolarLoanToUpdate.add(s);  
        }
        
        if(SolarLoanToUpdate.size() > 0){
            update SolarLoanToUpdate;
        }
        
    }
}