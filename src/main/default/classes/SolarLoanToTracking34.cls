public class SolarLoanToTracking34 {

    public static List<Solar_Loans__c> SolarLoanToUpdate = new List<Solar_Loans__c>();
    public static string loanAPI;
    public static string operatorid;
    public static string AccountNumber;
    
    //--------------------------------------------Create Tracking 34 -------------------------------------------//
    
    public static HttpRequest req = new HttpRequest();
    public static HttpResponse res;
    public static Http http = new Http();
    public static string responseBody;
    public static string jsonData1;
    public static string Type;
    public static string UserChar1;
    public static string UserChar20;
    public static string UserDate1;
    
    
    //---------------------------------------------Update Tracking 34-------------------------------------------//

    public static HttpRequest req1 = new HttpRequest();
    public static HttpResponse res1;
    public static Http http1 = new Http();
    public static string responseBody1;
    
    @future(callout=true)
    public static void createTracking34(Set<id> ids){
    	
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
                                        Application_Date__c,Approval_Date__c,Bank_Account_Number__c,Bank_Name__c,Battery__c,
                                        Block__c,Book__c,Brand__c,Change_Order__c,Citizenship__c,Continue__c,County__c,Count__c,
                                        CreatedById,CreatedDate,Created_Date__c,Credit_Attributes__c,Credit_Exception__c,
                                        Current_Solar_Loan_Stage__c,Debt_Ratio__c,DocuSignId__c,DocuSign_Document_Status__c,Due_Date__c,
                                        Dummy__c,ECOA_Code__c,EftLocator__c,Employer__c,Error_EftLocator__c,Error_Loan_Locator__c,
                                        Error_Loan_Name_Locator__c,Error_Loan_Tracking_Locator__c,Final_Payment_Amount__c,FNI__c,
                                        Go_To_Payment__c,Id,Initial_LT_Loan_Agreement__c,Installer_Number__c,Installer__c,
                                        Interest_Rate__c,Inverter__c,IsDeleted,ITC_Amount__c,ITC_Rate__c,Joint_Address_1__c,
                                        Joint_Address_2__c,Joint_Cell_Phone__c,Joint_Citizenship__c,Joint_City__c,Joint_DOB__c,
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
    	
            SolarLoan_To_Episys_API_Details__c api = SolarLoan_To_Episys_API_Details__c.getValues('ProductionURL');
            
            if(api.URL__c != null){
                loanAPI = api.URL__c;
            }
            
            //-------------------------------------Creating Tracking 34--------------------------------------//
            
            AccountNumber = sl.Member_Number__c;
            Type = '34';
            UserChar1 = 'Submitted';
            UserChar20 = 'CA';
            UserDate1 = string.valueOf(System.Today());
                
            //req.setEndpoint(loanAPI+'/PSAuto/GetAccountBrand?accountNumber='+AccountNumber);
            req.setMethod('POST');
            req.setHeader('Content-Type', 'application/json');
            req.setHeader('Accept', 'application/json');
            req.setTimeout(60000); 
            jsonData1 = '{"AccountNumber":'+'\"'+AccountNumber+'\"}';
            req1.setBodyAsBlob(Blob.valueof(jsondata1)); 
            
            if(!Test.isRunningTest()){                       
                res = http.send(req);
                responseBody = res.getBody();
                System.debug('Brand ::'+res.getBody());    
            }else{
                responseBody = '{"Reference" : "BC01"}';
            }
            if(responseBody !=''){        
                
            }
            
 			Solar_Loans__c s = new Solar_Loans__c();          
            s.id = sl.Id;  
            SolarLoanToUpdate.add(s);
        }
    	
        if(SolarLoanToUpdate.size() > 0){
            update SolarLoanToUpdate;
        }
        
    }
    
    @future(callout=true)
    public static void updateTracking34(Set<id> ids){
    	
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
                                        Application_Date__c,Approval_Date__c,Bank_Account_Number__c,Bank_Name__c,Battery__c,
                                        Block__c,Book__c,Brand__c,Change_Order__c,Citizenship__c,Continue__c,County__c,Count__c,
                                        CreatedById,CreatedDate,Created_Date__c,Credit_Attributes__c,Credit_Exception__c,
                                        Current_Solar_Loan_Stage__c,Debt_Ratio__c,DocuSignId__c,DocuSign_Document_Status__c,Due_Date__c,
                                        Dummy__c,ECOA_Code__c,EftLocator__c,Employer__c,Error_EftLocator__c,Error_Loan_Locator__c,
                                        Error_Loan_Name_Locator__c,Error_Loan_Tracking_Locator__c,Final_Payment_Amount__c,FNI__c,
                                        Go_To_Payment__c,Id,Initial_LT_Loan_Agreement__c,Installer_Number__c,Installer__c,
                                        Interest_Rate__c,Inverter__c,IsDeleted,ITC_Amount__c,ITC_Rate__c,Joint_Address_1__c,
                                        Joint_Address_2__c,Joint_Cell_Phone__c,Joint_Citizenship__c,Joint_City__c,Joint_DOB__c,
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
    	
            SolarLoan_To_Episys_API_Details__c api = SolarLoan_To_Episys_API_Details__c.getValues('ProductionURL');
            
            if(api.URL__c != null){
                loanAPI = api.URL__c;
            }
            
            //-------------------------------------Updating Tracking 34--------------------------------------//
            
            AccountNumber = sl.Member_Number__c;
            Type = '34';
            UserChar1 = 'Submitted';
            UserChar20 = 'CA';
            UserDate1 = string.valueOf(System.Today());
                
            //req.setEndpoint(loanAPI+'/PSAuto/GetAccountBrand?accountNumber='+AccountNumber);
            req.setMethod('POST');
            req.setHeader('Content-Type', 'application/json');
            req.setHeader('Accept', 'application/json');
            req.setTimeout(60000); 
            jsonData1 = '{"AccountNumber":'+'\"'+AccountNumber+'\"}';
            req1.setBodyAsBlob(Blob.valueof(jsondata1)); 
            
            if(!Test.isRunningTest()){                       
                res = http.send(req);
                responseBody = res.getBody();
                System.debug('Brand ::'+res.getBody());    
            }else{
                responseBody = '{"Reference" : "BC01"}';
            }
            if(responseBody !=''){        
                
            }
            
 			Solar_Loans__c s = new Solar_Loans__c();          
            s.id = sl.Id;  
            SolarLoanToUpdate.add(s);
        }
    	
        if(SolarLoanToUpdate.size() > 0){
            update SolarLoanToUpdate;
        }
        
    } 
}