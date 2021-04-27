public class SolarLoanToFileUCC {
    
    public static List<Solar_Loans__c> SolarLoanToUpdate = new List<Solar_Loans__c>(); 
    public static List<Attachment> SolarLoanUCCAttachment = new List<Attachment>();

    public static String token;
    public static String UCCId;
    public static String client_Id;
    public static String client_secret;
    public static String username;
    public static String password;
    public static String EndpointURL;
    public static String json;
    public static String json1;
    public static String UCCStatus;
    public static String UCCFile;
    public static string loanAPI;
    
    public static String box15;
    public static String box16;
    public static String ClientReference;  //not done 
    public static String DebtorFirstName;
    public static String DebtorLastName;
    public static String DebtorMiddleName;
    public static String DebtorStreetAddress;
    public static String DebtorCity;
    public static String DebtorState;
    public static String DebtorZipCode;
    public static String FilingState;   //not done
    public static Integer FilingJurisdiction;    
    public static String LegalDescription;
    public static String JointLastName;   //not done
    public static String JointFirstName;  //not done
    public static String JointAddress; //not done 
    public static String JointCity;    //not done
    public static String JointState;   //not done
    public static String JointZipCode; //not done 
    public static String UCCExtractDt; //not done
    public static String PrimaryOrganization; 
    public static String JointOrganization; 


    public static HttpRequest req = new HttpRequest();
    public static HttpResponse res;
    public static Http http = new Http();
    public static string responseBody;
    
    public static HttpRequest req0 = new HttpRequest();
    public static HttpResponse res0;
    public static Http http0 = new Http();
    public static string responseBody0;
    
    public static HttpRequest req1 = new HttpRequest();
    public static HttpResponse res1;
    public static Http http1 = new Http();
    public static string responseBody1;

    //-----------------------------------------------------------Tracking 34----------------------------------------------------//

    public static HttpRequest req2 = new HttpRequest();
    public static HttpResponse res2;
    public static Http http2 = new Http();
    public static string responseBody2;
    public static String jsonData2;
    public static String AccountNumber;
    public static String UserChar1;
    public static String UserChar20;
    public static String UserDate1;
    public static String LoanId;
    public static String Type;
    public static string operatorid;
    public static string TrackingLocator;

    public static HttpRequest req3 = new HttpRequest();
    public static HttpResponse res3;
    public static Http http3 = new Http();
    public static string responseBody3;
    public static String FJcounty;
    public static String FJstate;
    public static String FJstateDummy;
    public static Integer FJId;
    public static Boolean CountyMatched = false;
    public static Boolean StateMatched = false;

    public static String base64;
    public static string UCClogs;
    public static Datetime currentdatetime;

    @future(callout=true)
    public static void filUCC(Set<id> ids){
        
        currentdatetime = system.now();
        system.debug('currentdatetime: '+currentdatetime);

        SolarLoan_To_Episys_API_Details__c api = SolarLoan_To_Episys_API_Details__c.getValues('ProductionURL');
                        
        if(api.URL__c != null){
            loanAPI = api.URL__c;
        }
        
        List<Solar_UCC_User_Details__c> suudList = Solar_UCC_User_Details__c.getall().values();
        
        for(Solar_UCC_User_Details__c suud : suudList){ 
            
            if(suud.Name == 'Production'){
                EndpointURL = suud.URL__c;
                client_Id = suud.ClientId__c;
                client_secret = suud.Client_Secret__c;
                username = suud.Username__c;
                password = suud.password__c;           
            }
        }

        System.debug('EndpointURL: '+EndpointURL);
        System.debug('client_Id: '+client_Id);
        System.debug('client_secret: '+client_secret);
        System.debug('username: '+username);
        System.debug('password: '+password);

        String currentUserName = UserInfo.getUserName();
        User activeUser = [Select Email,Alias From User where Username = : currentUserName and Alias != null limit 1];
    
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

        //SolarLoan_Document__c sd = [select id,Attachment_Id__c	,name,Solar_Loans__r.id,Solar_Loans__c from SolarLoan_Document__c where Solar_Loans__r.id in: ids AND Document_Name__c LIKE '%MD Land Instrument Intake Sheet%' LIMIT 1];
        //system.debug('Solar Doc '+ sd.id);	

        //--------------------------------------Converting Loan Agreement into base64-------------------------//

        //ContentVersion cv =[select VersionData from ContentVersion where ContentDocumentId =: sd.Attachment_Id__c];
        //base64 = EncodingUtil.base64Encode(cv.versionData);
        //Document d = [select id,name,body from document where name = 'MD Land Instrument Intake Sheet'];
        //base64 = EncodingUtil.base64Encode(d.Body);
        //System.debug(base64);  
        
        List<Solar_Loans__c> Solanloanlist = new List<Solar_Loans__c>();         
    	List<Solar_Loans__c> solarloans = [SELECT ABA_Bank_Name__c,Account_Number__c,ACH_Discount__c,ACH__c,Additional_Amount__c,APN__c,
                                Application_Date__c,Approval_Date__c,Bank_Account_Number__c,Bank_Name__c,Battery__c,UCC_logs__c,
                                Block__c,Book__c,Brand__c,Change_Order__c,Citizenship__c,Continue__c,County__c,Count__c,
                                CreatedById,CreatedDate,Created_Date__c,Credit_Attributes__c,Credit_Exception__c,Jurisdiction__c,
                                Current_Solar_Loan_Stage__c,Debt_Ratio__c,DocuSignId__c,DocuSign_Document_Status__c,Due_Date__c,
                                Dummy__c,ECOA_Code__c,EftLocator__c,Employer__c,Error_EftLocator__c,Error_Loan_Locator__c,
                                Error_Loan_Name_Locator__c,Error_Loan_Tracking_Locator__c,Final_Payment_Amount__c,FNI__c,
                                Go_To_Payment__c,Id,Initial_LT_Loan_Agreement__c,Installer_Number__c,Installer__c,
                                Interest_Rate__c,Inverter__c,IsDeleted,ITC_Amount__c,ITC_Rate__c,Joint_Address_1__c,
                                Joint_Address_2__c,Joint_Cell_Phone__c,Joint_Citizenship__c,Joint_City__c,Joint_DOB__c,
                                Joint_Email__c,Joint_FICO_Score__c,Joint_First_Name__c,Joint_Home_Phone__c,Joint_ID_Expiration_Date__c,
                                Joint_ID_Issue_Date__c,Joint_ID_Number__c,Joint_ID_State__c,Joint_ID_Type__c,Joint_Last_Name__c,
                                Joint_Maiden_Name__c,Joint_Middle_Initial__c,Joint_Occupation__c,Joint_SSN__c,Joint_State__c,Joint_Work_Phone__c,
                                Joint_Zip_Code__c,Latest_LT_Loan_Agreement__c,
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
                                Net_Funding_Amount__c,Net_Funding_Amt__c,NewDoc__c,New__c,Non_Solar_Amount__c,Note__c,Occupation__c,
                                OID_Fee_Funding_Request__c,OID_Fee__c,OwnerId,Page__c,Primary_Address_1__c,Primary_Address_2__c,
                                Primary_Cell_Phone__c,Primary_City__c,Primary_DOB__c,Primary_Email__c,Primary_FICO_Score__c,Primary_First_Name__c,
                                Primary_Home_Phone__c,Primary_Last_Name__c,Primary_Middle_Initial__c,Primary_SSN_Length__c,Primary_SSN__c,
                                Primary_State__c,Primary_Work_Phone__c,Primary_Zip_Code__c,Product_Loan_Type__c,Product__c,Record_ID__c,
                                Review_needed__c,Routing_Number__c,Section__c,Site_UUID__c,Status__c,Subdivision__c,Sunlight_Update__c,
                                Symitar_Called__c,SystemModstamp,System_Size_kW__c,Term_months__c,Tracking_Record_33__c,Tract__c,UCC_Extraction__c,
                                UCC_Id__c,Valid_ABA__c FROM Solar_Loans__c where id =: ids];
    
        for(Solar_Loans__c sl : solarloans){
            
            //------------------------------------------------Fetching Token------------------------------------//
            
            if(sl.Map__c == null)
                sl.Map__c = '';

            if(sl.Book__c == null)
                sl.Book__c = '';

            if(sl.Page__c == null)
                sl.Page__c = '';

            if(sl.APN__c == null)
                sl.APN__c = '';

            if(sl.Lot__c == null)
                sl.Lot__c = '';
            
            if(sl.Block__c == null)
                sl.Block__c = '';    
            
            if(sl.Section__c == null)
                sl.Section__c = '';
                
            if(sl.Tract__c == null)
                sl.Tract__c = '';     

            if(sl.Subdivision__c == null)
                sl.Subdivision__c = '';     
                    
            box15 = sl.mem_Primary_First_Name__c +' '+ sl.mem_Primary_Last_Name__c + '\n' + sl.mem_Primary_Street__c +', '+ '\n' + sl.mem_Primary_City__c + ', '+ '\n' + sl.mem_Primary_State__c + ' - ' +  sl.mem_Primary_Zip_Code__c;
            box16 = box15 + '\n' + 'Map : '+sl.Map__c + ', Book : ' +sl.Book__c + ', Page : ' +sl.Page__c + ', APN : '+sl.APN__c + ', Lot : '+sl.Lot__c + ', Block : '+sl.Block__c + ', Section : '+ sl.Section__c + ', Tract : '+sl.Tract__c+ ', Subdivision: '+sl.Subdivision__c; 
            ClientReference = 'ClientReference';
            
            if(sl.mem_Primary_First_Name__c != null)
                DebtorFirstName = sl.mem_Primary_First_Name__c;

            if(sl.mem_Primary_Last_Name__c != null)
                DebtorLastName = sl.mem_Primary_Last_Name__c;

            if(sl.Primary_Middle_Initial__c != null)
                DebtorMiddleName = sl.Primary_Middle_Initial__c;

            if(sl.mem_Primary_Street__c != null)
                DebtorStreetAddress = sl.mem_Primary_Street__c;
                
            if(sl.mem_Primary_City__c != null)
                DebtorCity = sl.mem_Primary_City__c;

            if(sl.mem_Primary_State__c != null)
                DebtorState = sl.mem_Primary_State__c;
                
            if(sl.mem_Primary_Zip_Code__c != null)
                DebtorZipCode = sl.mem_Primary_Zip_Code__c;

            if(sl.Legal_Description__c != null)
                LegalDescription = sl.Legal_Description__c;
            
            if(sl.mem_Joint_Last_Name__c != null)
                JointLastName = sl.mem_Joint_Last_Name__c;

            if(sl.mem_Joint_First_Name__c != null)
                JointFirstName = sl.mem_Joint_First_Name__c;

            if(sl.mem_Joint_Extra_Address__c != null)    
                JointAddress = sl.mem_Joint_Extra_Address__c;

            if(sl.mem_Joint_City__c != null)
                JointCity = sl.mem_Joint_City__c;

            if(sl.mem_Joint_State__c != null)
                JointState = sl.mem_Joint_State__c;

            if(sl.mem_Joint_Zip_Code__c != null)
                JointZipCode = sl.mem_Joint_Zip_Code__c; 

            if(sl.Employer__c != null)
                PrimaryOrganization = sl.Employer__c;

            if(sl.mem_Joint_Employer__c != null)
                JointOrganization = sl.mem_Joint_Employer__c;

            req0.setEndpoint(EndpointURL+'/FCSAuthentication/core/connect/token');
            req0.setMethod('POST');
            req0.setHeader('Accept', 'application/json');
            req0.setBody('scope=FCSAuthentication.WebAPI&grant_type=password'+'&client_id='+client_Id+ '&client_secret=' + 
                         client_secret+'&username='+username+'&password='+password);                   
            
            system.debug('Token request'+req0);
            if(!Test.isRunningTest()){
                res0 = http0.send(req0);
                responseBody0 = res0.getBody();
                System.debug('Body: '+responseBody0);
            }
            else{
                responseBody0 = '{"access_token" : "akglalehawhfnawlkrnlwhwnkwk"}';
            }
            
            if(responseBody0!=''){ 
                Map<String,Object> results = (Map<String,Object>)System.JSON.deserializeUntyped(responseBody0);
                if(results.size() > 0){                     
                    for(String key : results.keySet()){                   			
                        if(key == 'access_token'){
                            token = String.valueOf(results.get(key));
                        }
                    }
                }
            }
            System.debug('token is = ' + token);
            
            //------------------------------------------------Getting Jurisdiction------------------------------------------//

            if(sl.county__c != null && sl.county__c !='')
                FJcounty = sl.county__c;
            
            if(sl.mem_Primary_State__c  != null && sl.mem_Primary_State__c  !='')
                FJstate = sl.mem_Primary_State__c;

                req3.setEndpoint(EndpointURL+'/OnlineServices/api/V2/Jurisdiction');
                req3.setMethod('GET');
                req3.setHeader('Accept', 'application/json');
                req3.setHeader('Authorization', 'Bearer ' + token);
                req3.setHeader('Content-Type', 'application/json;charset=UTF-8'); 
                
                system.debug('test3'+req3);                     
                
                if(!Test.isRunningTest()){
                    res3 = http3.send(req3);
                    responseBody3 = res3.getBody();
                    System.debug('Body: '+responseBody3);
                }
                else{
                    responseBody3 = '[{"ID":"456","Name":"TM","State":"MJ"}]';
                }

                
                /*if(UCClogs == null)
                    UCClogs = responseBody3;
                else
                    UCClogs = UCClogs +'\n'+ responseBody3; */

                if(responseBody3 != ''){        
                    List<Object> results = (List<Object>)System.JSON.deserializeUntyped(responseBody3);
                    if(results.size() > 0){
                        for(Object key : results){ 
                            //System.debug('key: '+key);   
                            Map<String, Object> Fdata = (Map<String, Object>)key;
                            for(string o: Fdata.keyset()){
                                if(StateMatched == false){
                                    if(o == 'ID'){
                                        FJId = Integer.valueOf(Fdata.get(o));
                                    }
                                    if(o == 'Name' && string.valueOf(Fdata.get(o)).equalsIgnoreCase(FJcounty)){
                                        system.debug('FJ: '+ string.valueOf(Fdata.get(o)));
                                        CountyMatched = true;
                                    }
                                   
                                    if(CountyMatched == true && o == 'State' && StateMatched == false){
                                        system.debug('State: '+ string.valueOf(Fdata.get(o)));
                                        system.debug('-------'+Fdata);
                                        FJstateDummy = string.valueOf(Fdata.get(o)).substringAfter('{Code=');
                                        FJstateDummy = String.valueOf(FJstateDummy).substringBefore(', Country=');
                                        if(FJstateDummy == FJstate){
                                            StateMatched = true;
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                
            System.debug('CountyMatched: '+CountyMatched);
            System.debug('StateMatched: '+StateMatched);    
            System.debug('FJId: '+FJId);

            if(StateMatched != true && CountyMatched != true )
                FJId = null;
              
            if(FJId != null){

                //------------------------------------------------Filling UCC------------------------------------------//
                
                req.setEndpoint(EndpointURL+'/OnlineServices/api/File/V2/Filing');
                req.setMethod('POST');
                req.setHeader('Accept', 'application/json');
                req.setHeader('Authorization', 'Bearer ' + token);
                req.setHeader('Content-Type', 'application/json;charset=UTF-8'); 
                req.setTimeout(120000);
                

                if((sl.mem_Primary_State__c == 'MD' && JointFirstName == null && JointLastName == null)){

                    System.debug('---1---');
                    //json = '{"FilingJurisdiction": "'+FJId+'",'+'"FileDate": "'+currentdatetime+'",'+'"FileNumber": "123456",'+'"IsHistoryFiling": true,'+'"Status": "Preparation",'+'"FilingType": "Initial",'+'"ClientReference": "'+ClientReference+'",'+' "FilerReference": "",'+'"Entities": ['+'{'+'"SortOrder": 1,'+'"ObjectType": "Debtor",'+'"LastName": "'+DebtorLastName+'",'+'"FirstName": "'+DebtorFirstName+'",'+'"MiddleName": "'+DebtorMiddleName+'",'+'"JurisdictionID": "'+FJId+'",'+'"OrganizationName": "'+PrimaryOrganization+'",'+'"Address": {'+'"StreetAddress": "'+DebtorStreetAddress+'",'+'"City": "'+DebtorCity+'",'+'"State": "'+DebtorState+'",'+'"PostalCode": "'+DebtorZipCode+'",'+'"Country": "USA"'+'}'+'},'+'{'+'"SortOrder": 2,'+'"ObjectType": "SecuredParty",'+'"OrganizationName": "Spectrum Credit Union",'+'"Address": {'+'"StreetAddress": "PO Box 2069",'+'"City": "Oakland",'+'"State": "CA",'+'"PostalCode": "94604",'+'"Country": "USA"'+'}'+'}'+'],'+'"Attachments": ['+'{'+'"FileBase64String": "'+base64+'",'+'"FileDate": "'+currentdatetime+'",'+'"OriginalFileName": "MD Land Instrument Intake Sheet.pdf"'+'}'+'],'+'"RealEstateInfo": {'+'"Description": "'+box16+'",'+'"Address": "'+box15+'",'+'"FixtureFiling": true,'+'"FileInRealEstate": true '+'},'+'"LoanTaxCalculatedAmount": "0.0",'+'"TNRecordingTax": "'+sl.Loan_Amount__c+'",'+'"TNRecordingTaxRequired": true'+'}';
                    json = '{"FilingJurisdiction": "'+FJId+'",'+'"FileDate": "'+currentdatetime+'",'+'"FileNumber": "123456",'+'"IsHistoryFiling": true,'+'"Status": "Preparation",'+'"FilingType": "Initial",'+'"ClientReference": "'+ClientReference+'",'+' "FilerReference": "",'+'"Entities": ['+'{'+'"SortOrder": 1,'+'"ObjectType": "Debtor",'+'"LastName": "'+DebtorLastName+'",'+'"FirstName": "'+DebtorFirstName+'",'+'"MiddleName": "'+DebtorMiddleName+'",'+'"JurisdictionID": "'+FJId+'",'+'"OrganizationName": "'+PrimaryOrganization+'",'+'"Address": {'+'"StreetAddress": "'+DebtorStreetAddress+'",'+'"City": "'+DebtorCity+'",'+'"State": "'+DebtorState+'",'+'"PostalCode": "'+DebtorZipCode+'",'+'"Country": "USA"'+'}'+'},'+'{'+'"SortOrder": 2,'+'"ObjectType": "SecuredParty",'+'"OrganizationName": "Spectrum Credit Union",'+'"Address": {'+'"StreetAddress": "PO Box 2069",'+'"City": "Oakland",'+'"State": "CA",'+'"PostalCode": "94604",'+'"Country": "USA"'+'}'+'}'+'],'+'"Collateral": {'+'"Description": "'+LegalDescription+'"'+'},'+'"RealEstateInfo": {'+'"Description": "'+box16+'",'+'"Address": "'+box15+'",'+'"FixtureFiling": true,'+'"FileInRealEstate": true '+'},'+'"LoanTaxCalculatedAmount": "0.0",'+'"TNRecordingTax": "'+sl.Loan_Amount__c+'",'+'"TNRecordingTaxRequired": true'+'}';
                    //json = '{"FilingJurisdiction": "'+FJId+'",'+'"Status": "Preparation",'+'"FilingType": "Initial",'+'"ClientReference": "'+ClientReference+'",'+' "FilerReference": "",'+'"Entities": ['+'{'+'"SortOrder": 1,'+'"ObjectType": "Debtor",'+'"LastName": "'+DebtorLastName+'",'+'"FirstName": "'+DebtorFirstName+'",'+'"MiddleName": "'+DebtorMiddleName+'",'+'"JurisdictionID": "'+FJId+'",'+'"OrganizationName": "'+PrimaryOrganization+'",'+'"Address": {'+'"StreetAddress": "'+DebtorStreetAddress+'",'+'"City": "'+DebtorCity+'",'+'"State": "'+DebtorState+'",'+'"PostalCode": "'+DebtorZipCode+'",'+'"Country": "USA"'+'}'+'},'+'{'+'"SortOrder": 2,'+'"ObjectType": "SecuredParty",'+'"OrganizationName": "Spectrum Credit Union",'+'"Address": {'+'"StreetAddress": "PO Box 2069",'+'"City": "Oakland",'+'"State": "CA",'+'"PostalCode": "94604",'+'"Country": "USA"'+'}'+'}'+'],'+'"Collateral": {'+'"Description": "'+LegalDescription+'"'+'},'+'"RealEstateInfo": {'+'"Description": "'+box16+'",'+'"Address": "'+box15+'",'+'"FixtureFiling": true,'+'"FileInRealEstate": true '+'},'+'"LoanTaxCalculatedAmount": "0.0",'+'"TNRecordingTax": "'+sl.Loan_Amount__c+'",'+'"TNRecordingTaxRequired": true'+'}';
                    
                }
                else if((sl.mem_Primary_State__c == 'MD' && JointFirstName != null && JointLastName != null)){

                    System.debug('---2---');
                    //json = '{"FilingJurisdiction": "'+FJId+'",'+'"FileDate":  "'+currentdatetime+'",'+'"FileNumber": "123456",'+'"IsHistoryFiling": true,'+'"Status": "Preparation",'+'"FilingType": "Initial",'+'"ClientReference": "'+ClientReference+'",'+' "FilerReference": "",'+'"Entities": ['+'{'+'"SortOrder": 1,'+'"ObjectType": "Debtor",'+'"LastName": "'+DebtorLastName+'",'+'"FirstName": "'+DebtorFirstName+'",'+'"MiddleName": "'+DebtorMiddleName+'",'+'"JurisdictionID": "'+FJId+'",'+'"OrganizationName": "'+PrimaryOrganization+'",'+'"Address": {'+'"StreetAddress": "'+DebtorStreetAddress+'",'+'"City": "'+DebtorCity+'",'+'"State": "'+DebtorState+'",'+'"PostalCode": "'+DebtorZipCode+'",'+'"Country": "USA"'+'}'+'},'+'{'+'"SortOrder": 2,'+'"ObjectType": "Debtor",'+'"LastName": "'+JointLastName+'",'+'"FirstName": "'+JointFirstName+'",'+'"MiddleName": " ",'+'"JurisdictionID": "'+FJId+'",'+'"OrganizationName":  "'+JointOrganization+'",'+'"Address": {'+'"StreetAddress": "'+JointAddress+'",'+'"City": "'+JointCity+'",'+'"State": "'+JointState+'",'+'"PostalCode": "'+JointZipCode+'",'+'"Country": "USA"'+'}'+'},'+'{'+'"SortOrder": 3,'+'"ObjectType": "SecuredParty",'+'"OrganizationName": "Spectrum Credit Union",'+'"Address": {'+'"StreetAddress": "PO Box 2069",'+'"City": "Oakland",'+'"State": "CA",'+'"PostalCode": "94604",'+'"Country": "USA"'+'}'+'}'+'],'+'"Attachments": ['+'{'+'"FileBase64String": "'+base64+'",'+'"FileDate": "'+currentdatetime+'",'+'"OriginalFileName": "MD Land Instrument Intake Sheet.pdf"'+'}'+'],'+'"RealEstateInfo": {'+'"Description": "'+box16+'",'+'"Address": "'+box15+'",'+'"FixtureFiling": true,'+'"FileInRealEstate": true '+'},'+'"LoanTaxCalculatedAmount": "0.0",'+'"TNRecordingTax": "'+sl.Loan_Amount__c+'",'+'"TNRecordingTaxRequired": true'+'}';
                    json = '{"FilingJurisdiction": "'+FJId+'",'+'"FileDate":  "'+currentdatetime+'",'+'"FileNumber": "123456",'+'"IsHistoryFiling": true,'+'"Status": "Preparation",'+'"FilingType": "Initial",'+'"ClientReference": "'+ClientReference+'",'+' "FilerReference": "",'+'"Entities": ['+'{'+'"SortOrder": 1,'+'"ObjectType": "Debtor",'+'"LastName": "'+DebtorLastName+'",'+'"FirstName": "'+DebtorFirstName+'",'+'"MiddleName": "'+DebtorMiddleName+'",'+'"JurisdictionID": "'+FJId+'",'+'"OrganizationName": "'+PrimaryOrganization+'",'+'"Address": {'+'"StreetAddress": "'+DebtorStreetAddress+'",'+'"City": "'+DebtorCity+'",'+'"State": "'+DebtorState+'",'+'"PostalCode": "'+DebtorZipCode+'",'+'"Country": "USA"'+'}'+'},'+'{'+'"SortOrder": 2,'+'"ObjectType": "Debtor",'+'"LastName": "'+JointLastName+'",'+'"FirstName": "'+JointFirstName+'",'+'"MiddleName": " ",'+'"JurisdictionID": "'+FJId+'",'+'"OrganizationName":  "'+JointOrganization+'",'+'"Address": {'+'"StreetAddress": "'+JointAddress+'",'+'"City": "'+JointCity+'",'+'"State": "'+JointState+'",'+'"PostalCode": "'+JointZipCode+'",'+'"Country": "USA"'+'}'+'},'+'{'+'"SortOrder": 3,'+'"ObjectType": "SecuredParty",'+'"OrganizationName": "Spectrum Credit Union",'+'"Address": {'+'"StreetAddress": "PO Box 2069",'+'"City": "Oakland",'+'"State": "CA",'+'"PostalCode": "94604",'+'"Country": "USA"'+'}'+'}'+'],'+'"Collateral": {'+'"Description": "'+LegalDescription+'"'+'},'+'"RealEstateInfo": {'+'"Description": "'+box16+'",'+'"Address": "'+box15+'",'+'"FixtureFiling": true,'+'"FileInRealEstate": true '+'},'+'"LoanTaxCalculatedAmount": "0.0",'+'"TNRecordingTax": "'+sl.Loan_Amount__c+'",'+'"TNRecordingTaxRequired": true'+'}';
                    //json = '{"FilingJurisdiction": "'+FJId+'",'+'"Status": "Preparation",'+'"FilingType": "Initial",'+'"ClientReference": "'+ClientReference+'",'+' "FilerReference": "",'+'"Entities": ['+'{'+'"SortOrder": 1,'+'"ObjectType": "Debtor",'+'"LastName": "'+DebtorLastName+'",'+'"FirstName": "'+DebtorFirstName+'",'+'"MiddleName": "'+DebtorMiddleName+'",'+'"JurisdictionID": "'+FJId+'",'+'"OrganizationName": "'+PrimaryOrganization+'",'+'"Address": {'+'"StreetAddress": "'+DebtorStreetAddress+'",'+'"City": "'+DebtorCity+'",'+'"State": "'+DebtorState+'",'+'"PostalCode": "'+DebtorZipCode+'",'+'"Country": "USA"'+'}'+'},'+'{'+'"SortOrder": 2,'+'"ObjectType": "Debtor",'+'"LastName": "'+JointLastName+'",'+'"FirstName": "'+JointFirstName+'",'+'"MiddleName": " ",'+'"JurisdictionID": "'+FJId+'",'+'"OrganizationName":  "'+JointOrganization+'",'+'"Address": {'+'"StreetAddress": "'+JointAddress+'",'+'"City": "'+JointCity+'",'+'"State": "'+JointState+'",'+'"PostalCode": "'+JointZipCode+'",'+'"Country": "USA"'+'}'+'},'+'{'+'"SortOrder": 3,'+'"ObjectType": "SecuredParty",'+'"OrganizationName": "Spectrum Credit Union",'+'"Address": {'+'"StreetAddress": "PO Box 2069",'+'"City": "Oakland",'+'"State": "CA",'+'"PostalCode": "94604",'+'"Country": "USA"'+'}'+'}'+'],'+'"Collateral": {'+'"Description": "'+LegalDescription+'"'+'},'+'"RealEstateInfo": {'+'"Description": "'+box16+'",'+'"Address": "'+box15+'",'+'"FixtureFiling": true,'+'"FileInRealEstate": true '+'},'+'"LoanTaxCalculatedAmount": "0.0",'+'"TNRecordingTax": "'+sl.Loan_Amount__c+'",'+'"TNRecordingTaxRequired": true'+'}';
                    
                }
                else if((sl.mem_Primary_State__c == 'TN' && JointFirstName == null && JointLastName == null)){

                    System.debug('---3---');
                    //json = '{"FilingJurisdiction": "'+FJId+'",'+'"FileDate": "'+currentdatetime+'",'+'"FileNumber": "123456",'+'"IsHistoryFiling": true,'+'"Status": "Preparation",'+'"FilingType": "Initial",'+'"ClientReference": "'+ClientReference+'",'+' "FilerReference": "",'+'"Entities": ['+'{'+'"SortOrder": 1,'+'"ObjectType": "Debtor",'+'"LastName": "'+DebtorLastName+'",'+'"FirstName": "'+DebtorFirstName+'",'+'"MiddleName": "'+DebtorMiddleName+'",'+'"JurisdictionID": "'+FJId+'",'+'"OrganizationName": "'+PrimaryOrganization+'",'+'"Address": {'+'"StreetAddress": "'+DebtorStreetAddress+'",'+'"City": "'+DebtorCity+'",'+'"State": "'+DebtorState+'",'+'"PostalCode": "'+DebtorZipCode+'",'+'"Country": "USA"'+'}'+'},'+'{'+'"SortOrder": 2,'+'"ObjectType": "SecuredParty",'+'"OrganizationName": "Spectrum Credit Union",'+'"Address": {'+'"StreetAddress": "PO Box 2069",'+'"City": "Oakland",'+'"State": "CA",'+'"PostalCode": "94604",'+'"Country": "USA"'+'}'+'}'+'],'+'"Attachments": ['+'{'+'"FileBase64String": "'+base64+'",'+'"FileDate": "'+currentdatetime+'",'+'"OriginalFileName": "MD Land Instrument Intake Sheet.pdf"'+'}'+'],'+'"RealEstateInfo": {'+'"Description": "'+box16+'",'+'"Address": "'+box15+'",'+'"FixtureFiling": true,'+'"FileInRealEstate": true '+'},'+'"LoanTaxCalculatedAmount": "0.0",'+'"TNRecordingTax": "'+sl.Loan_Amount__c+'",'+'"TNRecordingTaxRequired": true'+'}';
                    json = '{"FilingJurisdiction": "'+FJId+'",'+'"FileDate": "'+currentdatetime+'",'+'"FileNumber": "123456",'+'"IsHistoryFiling": true,'+'"Status": "Preparation",'+'"FilingType": "Initial",'+'"ClientReference": "'+ClientReference+'",'+' "FilerReference": "",'+'"Entities": ['+'{'+'"SortOrder": 1,'+'"ObjectType": "Debtor",'+'"LastName": "'+DebtorLastName+'",'+'"FirstName": "'+DebtorFirstName+'",'+'"MiddleName": "'+DebtorMiddleName+'",'+'"JurisdictionID": "'+FJId+'",'+'"OrganizationName": "'+PrimaryOrganization+'",'+'"Address": {'+'"StreetAddress": "'+DebtorStreetAddress+'",'+'"City": "'+DebtorCity+'",'+'"State": "'+DebtorState+'",'+'"PostalCode": "'+DebtorZipCode+'",'+'"Country": "USA"'+'}'+'},'+'{'+'"SortOrder": 2,'+'"ObjectType": "SecuredParty",'+'"OrganizationName": "Spectrum Credit Union",'+'"Address": {'+'"StreetAddress": "PO Box 2069",'+'"City": "Oakland",'+'"State": "CA",'+'"PostalCode": "94604",'+'"Country": "USA"'+'}'+'}'+'],'+'"Collateral": {'+'"Description": "'+LegalDescription+'"'+'},'+'"RealEstateInfo": {'+'"Description": "'+box16+'",'+'"Address": "'+box15+'",'+'"FixtureFiling": true,'+'"FileInRealEstate": true '+'},'+'"LoanTaxCalculatedAmount": "0.0",'+'"TNRecordingTax": "'+sl.Loan_Amount__c+'",'+'"TNRecordingTaxRequired": true'+'}';
                    //json = '{"FilingJurisdiction": "'+FJId+'",'+'"Status": "Preparation",'+'"FilingType": "Initial",'+'"ClientReference": "'+ClientReference+'",'+' "FilerReference": "",'+'"Entities": ['+'{'+'"SortOrder": 1,'+'"ObjectType": "Debtor",'+'"LastName": "'+DebtorLastName+'",'+'"FirstName": "'+DebtorFirstName+'",'+'"MiddleName": "'+DebtorMiddleName+'",'+'"JurisdictionID": "'+FJId+'",'+'"OrganizationName": "'+PrimaryOrganization+'",'+'"Address": {'+'"StreetAddress": "'+DebtorStreetAddress+'",'+'"City": "'+DebtorCity+'",'+'"State": "'+DebtorState+'",'+'"PostalCode": "'+DebtorZipCode+'",'+'"Country": "USA"'+'}'+'},'+'{'+'"SortOrder": 2,'+'"ObjectType": "SecuredParty",'+'"OrganizationName": "Spectrum Credit Union",'+'"Address": {'+'"StreetAddress": "PO Box 2069",'+'"City": "Oakland",'+'"State": "CA",'+'"PostalCode": "94604",'+'"Country": "USA"'+'}'+'}'+'],'+'"Collateral": {'+'"Description": "'+LegalDescription+'"'+'},'+'"RealEstateInfo": {'+'"Description": "'+box16+'",'+'"Address": "'+box15+'",'+'"FixtureFiling": true,'+'"FileInRealEstate": true '+'},'+'"LoanTaxCalculatedAmount": "0.0",'+'"TNRecordingTax": "'+sl.Loan_Amount__c+'",'+'"TNRecordingTaxRequired": true'+'}';
                    
                }
                else if((sl.mem_Primary_State__c == 'TN' && JointFirstName != null && JointLastName != null)){

                    System.debug('---4---');
                    //json = '{"FilingJurisdiction": "'+FJId+'",'+'"FileDate":  "'+currentdatetime+'",'+'"FileNumber": "123456",'+'"IsHistoryFiling": true,'+'"Status": "Preparation",'+'"FilingType": "Initial",'+'"ClientReference": "'+ClientReference+'",'+' "FilerReference": "",'+'"Entities": ['+'{'+'"SortOrder": 1,'+'"ObjectType": "Debtor",'+'"LastName": "'+DebtorLastName+'",'+'"FirstName": "'+DebtorFirstName+'",'+'"MiddleName": "'+DebtorMiddleName+'",'+'"JurisdictionID": "'+FJId+'",'+'"OrganizationName": "'+PrimaryOrganization+'",'+'"Address": {'+'"StreetAddress": "'+DebtorStreetAddress+'",'+'"City": "'+DebtorCity+'",'+'"State": "'+DebtorState+'",'+'"PostalCode": "'+DebtorZipCode+'",'+'"Country": "USA"'+'}'+'},'+'{'+'"SortOrder": 2,'+'"ObjectType": "Debtor",'+'"LastName": "'+JointLastName+'",'+'"FirstName": "'+JointFirstName+'",'+'"MiddleName": " ",'+'"JurisdictionID": "'+FJId+'",'+'"OrganizationName":  "'+JointOrganization+'",'+'"Address": {'+'"StreetAddress": "'+JointAddress+'",'+'"City": "'+JointCity+'",'+'"State": "'+JointState+'",'+'"PostalCode": "'+JointZipCode+'",'+'"Country": "USA"'+'}'+'},'+'{'+'"SortOrder": 3,'+'"ObjectType": "SecuredParty",'+'"OrganizationName": "Spectrum Credit Union",'+'"Address": {'+'"StreetAddress": "PO Box 2069",'+'"City": "Oakland",'+'"State": "CA",'+'"PostalCode": "94604",'+'"Country": "USA"'+'}'+'}'+'],'+'"Attachments": ['+'{'+'"FileBase64String": "'+base64+'",'+'"FileDate": "'+currentdatetime+'",'+'"OriginalFileName": "MD Land Instrument Intake Sheet.pdf"'+'}'+'],'+'"RealEstateInfo": {'+'"Description": "'+box16+'",'+'"Address": "'+box15+'",'+'"FixtureFiling": true,'+'"FileInRealEstate": true '+'},'+'"LoanTaxCalculatedAmount": "0.0",'+'"TNRecordingTax": "'+sl.Loan_Amount__c+'",'+'"TNRecordingTaxRequired": true'+'}';
                    json = '{"FilingJurisdiction": "'+FJId+'",'+'"FileDate":  "'+currentdatetime+'",'+'"FileNumber": "277080",'+'"IsHistoryFiling": true,'+'"Status": "Preparation",'+'"FilingType": "Initial",'+'"ClientReference": "'+ClientReference+'",'+' "FilerReference": "",'+'"Entities": ['+'{'+'"SortOrder": 1,'+'"ObjectType": "Debtor",'+'"LastName": "'+DebtorLastName+'",'+'"FirstName": "'+DebtorFirstName+'",'+'"MiddleName": "'+DebtorMiddleName+'",'+'"JurisdictionID": "'+FJId+'",'+'"OrganizationName": "'+PrimaryOrganization+'",'+'"Address": {'+'"StreetAddress": "'+DebtorStreetAddress+'",'+'"City": "'+DebtorCity+'",'+'"State": "'+DebtorState+'",'+'"PostalCode": "'+DebtorZipCode+'",'+'"Country": "USA"'+'}'+'},'+'{'+'"SortOrder": 2,'+'"ObjectType": "Debtor",'+'"LastName": "'+JointLastName+'",'+'"FirstName": "'+JointFirstName+'",'+'"MiddleName": " ",'+'"JurisdictionID": "'+FJId+'",'+'"OrganizationName":  "'+JointOrganization+'",'+'"Address": {'+'"StreetAddress": "'+JointAddress+'",'+'"City": "'+JointCity+'",'+'"State": "'+JointState+'",'+'"PostalCode": "'+JointZipCode+'",'+'"Country": "USA"'+'}'+'},'+'{'+'"SortOrder": 3,'+'"ObjectType": "SecuredParty",'+'"OrganizationName": "Spectrum Credit Union",'+'"Address": {'+'"StreetAddress": "PO Box 2069",'+'"City": "Oakland",'+'"State": "CA",'+'"PostalCode": "94604",'+'"Country": "USA"'+'}'+'}'+'],'+'"Collateral": {'+'"Description": "'+LegalDescription+'"'+'},'+'"RealEstateInfo": {'+'"Description": "'+box16+'",'+'"Address": "'+box15+'",'+'"FixtureFiling": true,'+'"FileInRealEstate": true '+'},'+'"LoanTaxCalculatedAmount": "0.0",'+'"TNRecordingTax": "'+sl.Loan_Amount__c+'",'+'"TNRecordingTaxRequired": true'+'}';
                    //json = '{"FilingJurisdiction": "'+FJId+'",'+'"Status": "Preparation",'+'"FilingType": "Initial",'+'"ClientReference": "'+ClientReference+'",'+' "FilerReference": "",'+'"Entities": ['+'{'+'"SortOrder": 1,'+'"ObjectType": "Debtor",'+'"LastName": "'+DebtorLastName+'",'+'"FirstName": "'+DebtorFirstName+'",'+'"MiddleName": "'+DebtorMiddleName+'",'+'"JurisdictionID": "'+FJId+'",'+'"OrganizationName": "'+PrimaryOrganization+'",'+'"Address": {'+'"StreetAddress": "'+DebtorStreetAddress+'",'+'"City": "'+DebtorCity+'",'+'"State": "'+DebtorState+'",'+'"PostalCode": "'+DebtorZipCode+'",'+'"Country": "USA"'+'}'+'},'+'{'+'"SortOrder": 2,'+'"ObjectType": "Debtor",'+'"LastName": "'+JointLastName+'",'+'"FirstName": "'+JointFirstName+'",'+'"MiddleName": " ",'+'"JurisdictionID": "'+FJId+'",'+'"OrganizationName":  "'+JointOrganization+'",'+'"Address": {'+'"StreetAddress": "'+JointAddress+'",'+'"City": "'+JointCity+'",'+'"State": "'+JointState+'",'+'"PostalCode": "'+JointZipCode+'",'+'"Country": "USA"'+'}'+'},'+'{'+'"SortOrder": 3,'+'"ObjectType": "SecuredParty",'+'"OrganizationName": "Spectrum Credit Union",'+'"Address": {'+'"StreetAddress": "PO Box 2069",'+'"City": "Oakland",'+'"State": "CA",'+'"PostalCode": "94604",'+'"Country": "USA"'+'}'+'}'+'],'+'"Collateral": {'+'"Description": "'+LegalDescription+'"'+'},'+'"RealEstateInfo": {'+'"Description": "'+box16+'",'+'"Address": "'+box15+'",'+'"FixtureFiling": true,'+'"FileInRealEstate": true '+'},'+'"LoanTaxCalculatedAmount": "0.0",'+'"TNRecordingTax": "'+sl.Loan_Amount__c+'",'+'"TNRecordingTaxRequired": true'+'}';
                    
                }
                else if(JointFirstName != null && JointLastName != null){
                    
                    System.debug('---5---');
                    json = '{"FilingJurisdiction": '+FJId+','+'"FileDate":  "'+currentdatetime+'",'+'"FileNumber": "277080",'+'"IsHistoryFiling": true,'+'"Status": "Preparation",'+'"FilingType": "Initial",'+'"ClientReference": "'+ClientReference+'",'+'  "FilerReference": "",'+'"Entities": ['+'{'+'"SortOrder": 1,'+'"ObjectType": "Debtor",'+'"LastName": "'+DebtorLastName+'",'+'"FirstName": "'+DebtorFirstName+'",'+'"MiddleName": "'+DebtorMiddleName+'",'+'"JurisdictionID": "'+FJId+'",'+'"OrganizationName": "'+PrimaryOrganization+'",'+'"Address": {'+'"StreetAddress": "'+DebtorStreetAddress+'",'+'"City": "'+DebtorCity+'",'+'"State": "'+DebtorState+'",'+'"PostalCode": "'+DebtorZipCode+'",'+'"Country": "USA"'+'}'+'},'+'{'+'"SortOrder": 2,'+'"ObjectType": "Debtor",'+'"LastName": "'+JointLastName+'",'+'"FirstName": "'+JointFirstName+'",'+'"MiddleName": " ",'+'"JurisdictionID": "'+FJId+'",'+'"OrganizationName": "'+JointOrganization+'",'+'"Address": {'+'"StreetAddress": "'+JointAddress+'",'+'"City": "'+JointCity+'",'+'"State": "'+JointState+'",'+'"PostalCode": "'+JointZipCode+'",'+'"Country": "USA"'+'}'+'},'+'{'+'"SortOrder": 3,'+'"ObjectType": "SecuredParty",'+'"OrganizationName": "Spectrum Credit Union",'+'"Address": {'+'"StreetAddress": "PO Box 2069",'+'"City": "Oakland",'+'"State": "CA",'+'"PostalCode": "94604",'+'"Country": "USA"'+'}'+'}'+'],'+'"Collateral": {'+'"Description": "'+LegalDescription+'"'+'},'+'"RealEstateInfo": {'+'"Description": "'+box16+'",'+'"Address": "'+box15+'",'+'"FixtureFiling": true,'+'"FileInRealEstate": true '+'}'+'}';
                    //json = '{"FilingJurisdiction": '+FJId+','+'"Status": "Preparation",'+'"FilingType": "Initial",'+'"ClientReference": "'+ClientReference+'",'+'  "FilerReference": "",'+'"Entities": ['+'{'+'"SortOrder": 1,'+'"ObjectType": "Debtor",'+'"LastName": "'+DebtorLastName+'",'+'"FirstName": "'+DebtorFirstName+'",'+'"MiddleName": "'+DebtorMiddleName+'",'+'"JurisdictionID": "'+FJId+'",'+'"OrganizationName": "'+PrimaryOrganization+'",'+'"Address": {'+'"StreetAddress": "'+DebtorStreetAddress+'",'+'"City": "'+DebtorCity+'",'+'"State": "'+DebtorState+'",'+'"PostalCode": "'+DebtorZipCode+'",'+'"Country": "USA"'+'}'+'},'+'{'+'"SortOrder": 2,'+'"ObjectType": "Debtor",'+'"LastName": "'+JointLastName+'",'+'"FirstName": "'+JointFirstName+'",'+'"MiddleName": " ",'+'"JurisdictionID": "'+FJId+'",'+'"OrganizationName": "'+JointOrganization+'",'+'"Address": {'+'"StreetAddress": "'+JointAddress+'",'+'"City": "'+JointCity+'",'+'"State": "'+JointState+'",'+'"PostalCode": "'+JointZipCode+'",'+'"Country": "USA"'+'}'+'},'+'{'+'"SortOrder": 3,'+'"ObjectType": "SecuredParty",'+'"OrganizationName": "Spectrum Credit Union",'+'"Address": {'+'"StreetAddress": "PO Box 2069",'+'"City": "Oakland",'+'"State": "CA",'+'"PostalCode": "94604",'+'"Country": "USA"'+'}'+'}'+'],'+'"Collateral": {'+'"Description": "'+LegalDescription+'"'+'},'+'"RealEstateInfo": {'+'"Description": "'+box16+'",'+'"Address": "'+box15+'",'+'"FixtureFiling": true,'+'"FileInRealEstate": true '+'}'+'}';
                }
                else{
                    
                    System.debug('---6---');
                    json = '{"FilingJurisdiction": "'+FJId+'",'+'"FileDate": "'+currentdatetime+'",'+'"FileNumber": "277080",'+'"IsHistoryFiling": true,'+'"Status": "Preparation",'+'"FilingType": "Initial",'+'"ClientReference": "'+ClientReference+'",'+'  "FilerReference": "",'+'"Entities": ['+'{'+'"SortOrder": 1,'+'"ObjectType": "Debtor",'+'"LastName": "'+DebtorLastName+'",'+'"FirstName": "'+DebtorFirstName+'",'+'"MiddleName": "'+DebtorMiddleName+'",'+'"JurisdictionID": "'+FJId+'",'+'"OrganizationName": "'+PrimaryOrganization+'",'+'"Address": {'+'"StreetAddress": "'+DebtorStreetAddress+'",'+'"City": "'+DebtorCity+'",'+'"State": "'+DebtorState+'",'+'"PostalCode": "'+DebtorZipCode+'",'+'"Country": "USA"'+'}'+'},'+'{'+'"SortOrder": 2,'+'"ObjectType": "SecuredParty",'+'"OrganizationName": "Spectrum Credit Union",'+'"Address": {'+'"StreetAddress": "PO Box 2069",'+'"City": "Oakland",'+'"State": "CA",'+'"PostalCode": "94604",'+'"Country": "USA"'+'}'+'}'+'],'+'"Collateral": {'+'"Description": "'+LegalDescription+'"'+'},'+'"RealEstateInfo": {'+'"Description": "'+box16+'",'+'"Address": "'+box15+'",'+'"FixtureFiling": true,'+'"FileInRealEstate": true '+'}'+'}';
                    //json = '{"FilingJurisdiction": "'+FJId+'",'+'"Status": "Preparation",'+'"FilingType": "Initial",'+'"ClientReference": "'+ClientReference+'",'+'  "FilerReference": "",'+'"Entities": ['+'{'+'"SortOrder": 1,'+'"ObjectType": "Debtor",'+'"LastName": "'+DebtorLastName+'",'+'"FirstName": "'+DebtorFirstName+'",'+'"MiddleName": "'+DebtorMiddleName+'",'+'"JurisdictionID": "'+FJId+'",'+'"OrganizationName": "'+PrimaryOrganization+'",'+'"Address": {'+'"StreetAddress": "'+DebtorStreetAddress+'",'+'"City": "'+DebtorCity+'",'+'"State": "'+DebtorState+'",'+'"PostalCode": "'+DebtorZipCode+'",'+'"Country": "USA"'+'}'+'},'+'{'+'"SortOrder": 2,'+'"ObjectType": "SecuredParty",'+'"OrganizationName": "Spectrum Credit Union",'+'"Address": {'+'"StreetAddress": "PO Box 2069",'+'"City": "Oakland",'+'"State": "CA",'+'"PostalCode": "94604",'+'"Country": "USA"'+'}'+'}'+'],'+'"Collateral": {'+'"Description": "'+LegalDescription+'"'+'},'+'"RealEstateInfo": {'+'"Description": "'+box16+'",'+'"Address": "'+box15+'",'+'"FixtureFiling": true,'+'"FileInRealEstate": true '+'}'+'}';
                }
                
                req.setBody(json);	
                
                system.debug('Fill UCC Request: '+req);   
                system.debug('test'+json);           
                if(!Test.isRunningTest()){
                    res = http.send(req);
                    responseBody = res.getBody();
                    System.debug('Body: '+responseBody);
                }
                else{
                    responseBody = '{"ID" : "9ec739d4-67fe-443b-a06d-804679c9e184"}';
                }
                
                
                UCClogs = responseBody;
            
                if(responseBody!=''){ 
                    Map<String,Object> results = (Map<String,Object>)System.JSON.deserializeUntyped(responseBody);
                    if(results.size() > 0){                     
                        for(String key : results.keySet()){                   			
                            if(key == 'ID'){
                                UCCId = String.valueOf(results.get(key));
                            }
                        }
                    }
                }
                
                System.debug('UCC ID is = ' + UCCId);
                
                
                req1.setEndpoint(EndpointURL+'/OnlineServices/api/File/V2/Filing/'+UCCId+'/GenerateImage');
                req1.setMethod('GET');
                req1.setHeader('Accept', 'application/json');
                req1.setHeader('Authorization', 'Bearer ' + token);
                req1.setHeader('Content-Type', 'application/json;charset=UTF-8');

                system.debug('test1'+req1);                     
                
                if(!Test.isRunningTest()){
                    res1 = http1.send(req1);
                    responseBody1 = res1.getBody();
                    System.debug('Body: '+responseBody1);
                }
                else{
                    responseBody1 = '{"FileBase64String" : "SSetewtewewtegsgw"}';
                }
                
                if(UCClogs == null)
                    UCClogs = responseBody1;
                else
                    UCClogs = UCClogs +'\n'+ responseBody1;

                if(responseBody1!=''){ 
                    Map<String,Object> results = (Map<String,Object>)System.JSON.deserializeUntyped(responseBody1);
                    if(results.size() > 0){                     
                        for(String key : results.keySet()){                   			
                            if(key == 'FileBase64String'){
                                UCCFile = String.valueOf(results.get(key));
                            }
                        }
                    }
                }
                System.debug('UCC File is = ' + UCCFile);

                //------------------------------------------------Creating Tracking 34 ------------------------------------------//
                
                if(sl.Member_Number__c != null)
                    AccountNumber = sl.Member_Number__c;
                
                System.debug('AccountNumber: '+AccountNumber);

                LoanId = sl.Loan_Id__c;
                Type = '34';
                UserChar1 = 'Submitted';

                if(sl.mem_Primary_State__c != null)
                    UserChar20 = string.valueOf(sl.mem_Primary_State__c).toUpperCase();

                UserDate1 = string.ValueOf(System.today());

                System.debug('-----------------------------------Creating Tracking 34 Record------------------------------------');

                req2.setEndpoint(loanAPI+'/SolarLoan/CreateLoanTracking34');
                req2.setMethod('POST');
                req2.setHeader('Content-Type', 'application/json');
                req2.setHeader('Accept', 'application/json');
                req2.setTimeout(120000);                   
                jsonData2 = '{"LoanId":'+'\"'+LoanId+'\"'+',"EpisysId":'+'\"'+operatorid+'\"'+',"AccountNumber":'+'\"'+AccountNumber+'\"'+',"Type":' + '\"'+ Type +'\"'+',"UserChar1":' + '\"'+ UserChar1 +'\"'+',"UserChar20":' + '\"'+ UserChar20+'\"'+',"UserDate1":' + '\"'+ UserDate1 +'\"}';
                req2.setBodyAsBlob(Blob.valueof(jsondata2)); 
                system.debug('Request is ....'+jsonData2);
                
                req2.setTimeout(60000);
                if(!Test.isRunningTest()){                       
                    res2 = http2.send(req2);
                    responseBody2 = res2.getBody();
                    System.debug('Response Body Tracking 34::'+res2.getBody());    
                }else{
                    responseBody2 = '{"Type":"34","UserChar1":"Submitted","TrackingLocator":"1","UserChar2":"1","UserChar3":"100","UserChar4":"4","UserChar5":"1","UserChar10":"01-01-2019","UserChar20":"01-01-2019","UserAmount1":"100.00","UserAmount2":"322271627","UserAmount3":"42006986568","UserAmount11":"BANK OF AMERICA","UserAmount12":"123","UserAmount13" : "UserAmount13","UserCode1" : "UserCode1", "LoanId" : "LoanId", "AccountNumber" : "AccountNumber"}';
                } 
                
                if(responseBody2 != '' && responseBody2 != null){        
                    Map<String,Object> results = (Map<String,Object>)System.JSON.deserializeUntyped(responseBody2);
                    System.debug('Response is ....' + results);
                    
                    if(results.size() > 0){
                        for(String l : results.keyset()) {
                            if(l == 'LoanTrackingLocator'){
                                TrackingLocator = String.valueOf(results.get(l));
                            }
                        }    
                    }
                }
                system.debug('TrackingLocator '+TrackingLocator);
                
                //-------------------------------------------------------------------------------------------------------------------------//

                if(UCClogs == null)
                    UCClogs = responseBody2;
                else
                    UCClogs = UCClogs +'\n'+ responseBody2;
            

                Attachment attach = new Attachment();
                attach.contentType = 'application/pdf';
                attach.name = 'UCC Filing document';
                attach.parentId = sl.id;
                attach.body = EncodingUtil.base64Decode(UCCFile);
                SolarLoanUCCAttachment.add(attach);

                
                Solar_Loans__c s = new Solar_Loans__c(); 
                s.id = sl.Id;
                s.UCC_Id__c = UCCId;
                s.Status__c = 'UCC Pending';
                s.Jurisdiction__c = string.valueOf(FJId);
                if(TrackingLocator != null)
                    s.Tracking_Record_34__c = TrackingLocator;
                //if(UCClogs != null)
                    //s.UCC_logs__c = UCClogs;
                SolarLoanToUpdate.add(s);
            }
            else{

                Solar_Loans__c s = new Solar_Loans__c(); 
                s.id = sl.Id;
                s.Jurisdiction__c = 'Not Found';
                SolarLoanToUpdate.add(s);

            }
        }
        
        if(SolarLoanToUpdate.size() > 0){
            update SolarLoanToUpdate;
        } 

        if(SolarLoanUCCAttachment.size() > 0){
            insert SolarLoanUCCAttachment;
        }
    }

    @future(callout=true)
    public static void getJurisdiction(Set<id> ids){
        
        List<Solar_UCC_User_Details__c> suudList = Solar_UCC_User_Details__c.getall().values();
        List<Attachment> CCCHSAttachment = new List<Attachment>();

        for(Solar_UCC_User_Details__c suud : suudList){ 
            
            if(suud.Name == 'Production'){
                EndpointURL = suud.URL__c;
                client_Id = suud.ClientId__c;
                client_secret = suud.Client_Secret__c;
                username = suud.Username__c;
                password = suud.password__c;           
            }
        }

        System.debug('EndpointURL: '+EndpointURL);
        System.debug('client_Id: '+client_Id);
        System.debug('client_secret: '+client_secret);
        System.debug('username: '+username);
        System.debug('password: '+password);
        
        List<Solar_Loans__c> Solanloanlist = new List<Solar_Loans__c>();         
    	List<Solar_Loans__c> solarloans = [SELECT ABA_Bank_Name__c,Account_Number__c,ACH_Discount__c,ACH__c,Additional_Amount__c,APN__c,
                                Application_Date__c,Approval_Date__c,Bank_Account_Number__c,Bank_Name__c,Battery__c,UCC_logs__c,
                                Block__c,Book__c,Brand__c,Change_Order__c,Citizenship__c,Continue__c,County__c,Count__c,
                                CreatedById,CreatedDate,Created_Date__c,Credit_Attributes__c,Credit_Exception__c,Jurisdiction__c,
                                Current_Solar_Loan_Stage__c,Debt_Ratio__c,DocuSignId__c,DocuSign_Document_Status__c,Due_Date__c,
                                Dummy__c,ECOA_Code__c,EftLocator__c,Employer__c,Error_EftLocator__c,Error_Loan_Locator__c,
                                Error_Loan_Name_Locator__c,Error_Loan_Tracking_Locator__c,Final_Payment_Amount__c,FNI__c,
                                Go_To_Payment__c,Id,Initial_LT_Loan_Agreement__c,Installer_Number__c,Installer__c,
                                Interest_Rate__c,Inverter__c,IsDeleted,ITC_Amount__c,ITC_Rate__c,Joint_Address_1__c,
                                Joint_Address_2__c,Joint_Cell_Phone__c,Joint_Citizenship__c,Joint_City__c,Joint_DOB__c,
                                Joint_Email__c,Joint_FICO_Score__c,Joint_First_Name__c,Joint_Home_Phone__c,Joint_ID_Expiration_Date__c,
                                Joint_ID_Issue_Date__c,Joint_ID_Number__c,Joint_ID_State__c,Joint_ID_Type__c,Joint_Last_Name__c,
                                Joint_Maiden_Name__c,Joint_Middle_Initial__c,Joint_Occupation__c,Joint_SSN__c,Joint_State__c,Joint_Work_Phone__c,
                                Joint_Zip_Code__c,Latest_LT_Loan_Agreement__c,
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
                                Net_Funding_Amount__c,Net_Funding_Amt__c,NewDoc__c,New__c,Non_Solar_Amount__c,Note__c,Occupation__c,
                                OID_Fee_Funding_Request__c,OID_Fee__c,OwnerId,Page__c,Primary_Address_1__c,Primary_Address_2__c,
                                Primary_Cell_Phone__c,Primary_City__c,Primary_DOB__c,Primary_Email__c,Primary_FICO_Score__c,Primary_First_Name__c,
                                Primary_Home_Phone__c,Primary_Last_Name__c,Primary_Middle_Initial__c,Primary_SSN_Length__c,Primary_SSN__c,
                                Primary_State__c,Primary_Work_Phone__c,Primary_Zip_Code__c,Product_Loan_Type__c,Product__c,Record_ID__c,
                                Review_needed__c,Routing_Number__c,Section__c,Site_UUID__c,Status__c,Subdivision__c,Sunlight_Update__c,
                                Symitar_Called__c,SystemModstamp,System_Size_kW__c,Term_months__c,Tracking_Record_33__c,Tract__c,UCC_Extraction__c,
                                UCC_Id__c,Valid_ABA__c FROM Solar_Loans__c where id =: ids];
        
      
        for(Solar_Loans__c sl : solarloans){
            
            //------------------------------------------------Fetching Token------------------------------------//

            req0.setEndpoint(EndpointURL+'/FCSAuthentication/core/connect/token');
            req0.setMethod('POST');
            req0.setHeader('Accept', 'application/json');
            req0.setBody('scope=FCSAuthentication.WebAPI&grant_type=password'+'&client_id='+client_Id+ '&client_secret=' + 
                         client_secret+'&username='+username+'&password='+password);                   
            
            system.debug('Token request'+req0);
            if(!Test.isRunningTest()){
                res0 = http0.send(req0);
                responseBody0 = res0.getBody();
                System.debug('Body: '+responseBody0);
            }
            else{
                responseBody0 = '{"access_token" : "akglalehawhfnawlkrnlwhwnkwk"}';
            }
            
            if(responseBody0!=''){ 
                Map<String,Object> results = (Map<String,Object>)System.JSON.deserializeUntyped(responseBody0);
                if(results.size() > 0){                     
                    for(String key : results.keySet()){                   			
                        if(key == 'access_token'){
                            token = String.valueOf(results.get(key));
                        }
                    }
                }
            }
            System.debug('token is = ' + token);
            
            //------------------------------------------------Getting Jurisdiction------------------------------------------//

            if(sl.county__c != null && sl.county__c !='')
                FJcounty = sl.county__c;
            
            if(FJcounty.contains('ST ')){
                FJcounty = FJcounty.replace('ST ', 'Saint ');
            }

            system.debug('FJcounty: '+FJcounty);
            
            if(sl.mem_Primary_State__c  != null && sl.mem_Primary_State__c  !='')
                FJstate = sl.mem_Primary_State__c;

                req3.setEndpoint(EndpointURL+'/OnlineServices/api/V2/Jurisdiction');
                req3.setMethod('GET');
                req3.setHeader('Accept', 'application/json');
                req3.setHeader('Authorization', 'Bearer ' + token);
                req3.setHeader('Content-Type', 'application/json;charset=UTF-8'); 
                req3.setTimeout(120000);
                system.debug('test3'+req3);                     
                
                if(!Test.isRunningTest()){
                    res3 = http3.send(req3);
                    responseBody3 = res3.getBody();
                    System.debug('Body: '+responseBody3);
                }
                else{
                    responseBody3 = '[{"ID":"456","Name":"TM","State":"MJ"}]';
                }

                if(responseBody3 != ''){        
                    List<Object> results = (List<Object>)System.JSON.deserializeUntyped(responseBody3);
                    if(results.size() > 0){
                        for(Object key : results){ 
                            System.debug('key: '+key);   
                            Map<String, Object> Fdata = (Map<String, Object>)key;
                            for(string o: Fdata.keyset()){
                                if(StateMatched == false){
                                    if(o == 'ID'){
                                        FJId = Integer.valueOf(Fdata.get(o));
                                    }
                                    if(o == 'Name' && string.valueOf(Fdata.get(o)).equalsIgnoreCase(FJcounty)){
                                        system.debug('FJ: '+ string.valueOf(Fdata.get(o)));
                                        CountyMatched = true;
                                    }
                                   
                                    if(CountyMatched == true && o == 'State' && StateMatched == false){
                                        system.debug('State: '+ string.valueOf(Fdata.get(o)));
                                        system.debug('-------'+Fdata);
                                        FJstateDummy = string.valueOf(Fdata.get(o)).substringAfter('{Code=');
                                        FJstateDummy = String.valueOf(FJstateDummy).substringBefore(', Country=');
                                        if(FJstateDummy == FJstate){
                                            StateMatched = true;
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            System.debug('CountyMatched: '+CountyMatched);
            System.debug('StateMatched: '+StateMatched);    
            System.debug('FJId: '+FJId);

            if(StateMatched != true && CountyMatched != true )
                FJId = null;
              
            
            //-------------------------------------------------------------------------------------------------------------------------//

            if(UCClogs == null)
                UCClogs = responseBody2;
            else
                UCClogs = UCClogs +'\n'+ responseBody2;
        
            
            if(FJId != null){ 

                Solar_Loans__c s = new Solar_Loans__c(); 
                s.id = sl.Id;
                s.Jurisdiction__c = string.valueOf(FJId);
                s.continue__c = false;
                s.Status__c = 'Approved';
                s.Current_Solar_Loan_Stage__c = 'Stage 3';
                SolarLoanToUpdate.add(s); 

            }
            else{
                Solar_Loans__c s = new Solar_Loans__c(); 
                s.id = sl.Id;
                s.Jurisdiction__c = 'Not Found';
                SolarLoanToUpdate.add(s);
            }
        }
        
        if(SolarLoanToUpdate.size() > 0){
            update SolarLoanToUpdate;
        }

    }
}