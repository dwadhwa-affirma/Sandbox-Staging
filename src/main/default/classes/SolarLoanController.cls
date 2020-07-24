public class SolarLoanController {

    @AuraEnabled
    public static void waitingForResponse(string SolarLoanRecordId, String status){
    
    List<Solar_Loans__c> SolarLoanList = [SELECT id,ABA_Bank_Name__c,ACH__c,Additional_Amount__c,Application_Date__c,
            Bank_Account_Number__c,Bank_Name__c,Battery__c,Brand__c,Change_Order__c,CreatedById,CreatedDate,
            Credit_Attributes__c,Credit_Exception__c,Debt_Ratio__c,DocuSignId__c,Due_Date__c,continue__c,
            ECOA_Code__c,Final_Payment_Amount__c,FNI__c,Go_To_Payment__c,Initial_LT_Loan_Agreement__c,
            Installer_Number__c,Installer__c,Interest_Rate__c,Inverter__c,IsDeleted,Joint_Address_1__c,
            Joint_Address_2__c,Joint_City__c,Joint_DOB__c,Joint_FICO_Score__c,Joint_First_Name__c,Joint_Last_Name__c,
            Joint_SSN__c,Joint_State__c,Joint_Zip_Code__c,Latest_LT_Loan_Agreement__c,Legal_Description__c,Loan_Amount__c,Loan_Pmt_Amount__c,
            Loan_Type__c,Maturity_Date__c,Account_Number__r.name,Membership_Fee__c,Member_Number__c,Module__c,Mortgage_Balance__c,Name,
            Name__c,Net_Funding_Amount__c,OID_Fee__c,OwnerId,Primary_Address_1__c,Primary_Address_2__c,Approval_Date__c,
            Primary_City__c,Primary_DOB__c,Primary_FICO_Score__c,Primary_First_Name__c,Primary_Last_Name__c,
            Primary_SSN__c,Primary_State__c,Primary_Zip_Code__c,Product_Loan_Type__c,Product__c,Record_ID__c,
            Routing_Number__c,Site_UUID__c,Status__c,Symitar_Called__c,SystemModstamp,System_Size_kW__c,Term_months__c,
            Valid_ABA__c, Loan_Id__c,Loan_Name_Locator__c,Loan_Tracking_Locator__c,EftLocator__c,ITC_Rate__c,ITC_Amount__c,
            Error_EftLocator__c,Error_Loan_Locator__c,Error_Loan_Name_Locator__c,Error_Loan_Tracking_Locator__c,
            Current_Solar_Loan_Stage__c FROM Solar_Loans__c where id =: SolarLoanRecordId limit 1];	
    	
            SolarLoanList[0].Status__c = status;
            if(SolarLoanList[0].Status__c != 'Waiting for Response')
                SolarLoanList[0].continue__c = True; 

            update SolarLoanList; 	
    	
    }
    
    @AuraEnabled
    public static  Map<string,string> getMemberData(string SolarLoanRecordId, String CurrentStage){
    
    List<String> stage3RequireFields = new List<String>();
    stage3RequireFields.add('Primary_First_Name__c');
    stage3RequireFields.add('Primary_Last_Name__c');
    stage3RequireFields.add('Primary_DOB__c');
    stage3RequireFields.add('Primary_SSN__c');
    stage3RequireFields.add('Primary_Address_1__c');
    stage3RequireFields.add('Primary_FICO_Score__c');
    stage3RequireFields.add('Primary_City__c');
    stage3RequireFields.add('Primary_State__c');
    stage3RequireFields.add('Primary_Zip_Code__c');
    stage3RequireFields.add('Legal_Description__c');
    stage3RequireFields.add('Product__c');
    stage3RequireFields.add('Module__c');
    stage3RequireFields.add('Installer_Number__c');
    stage3RequireFields.add('Inverter__c');
    stage3RequireFields.add('System_Size_kW__c');
    stage3RequireFields.add('Battery__c');
    stage3RequireFields.add('Installer__c');
    stage3RequireFields.add('Application_Date__c');
    stage3RequireFields.add('Mortgage_Balance__c');
    stage3RequireFields.add('Final_Payment_Amount__c');
    stage3RequireFields.add('Go_To_Payment__c');
    stage3RequireFields.add('Membership_Fee__c');
    stage3RequireFields.add('Net_Funding_Amount__c');
    stage3RequireFields.add('Loan_Amount__c');
    stage3RequireFields.add('Loan_Pmt_Amount__c');
   // stage3RequireFields.add('Credit_Exception__c');
    stage3RequireFields.add('ITC_Rate__c');
    stage3RequireFields.add('ITC_Amount__c');
    stage3RequireFields.add('Term_months__c');
    stage3RequireFields.add('OID_Fee__c');
    stage3RequireFields.add('Approval_Date__c');
    stage3RequireFields.add('Name__c');
    stage3RequireFields.add('ECOA_Code__c');
    stage3RequireFields.add('Site_UUID__c');
    stage3RequireFields.add('FNI__c');
    stage3RequireFields.add('Member_Number__c');
	
	List<String> stage3ECOARequireFields = new List<String>();
	stage3ECOARequireFields.add('Joint_First_Name__c');
	stage3ECOARequireFields.add('Joint_Last_Name__c');
	stage3ECOARequireFields.add('Joint_DOB__c');
	stage3ECOARequireFields.add('Joint_SSN__c');
	//stage3ECOARequireFields.add('Joint_Address_1__c');
	stage3ECOARequireFields.add('Joint_FICO_Score__c');
	stage3ECOARequireFields.add('Joint_City__c');
	stage3ECOARequireFields.add('Joint_State__c');
	stage3ECOARequireFields.add('Joint_Zip_Code__c');
	
    List<String> stage5RequireFields = new List<String>();
	stage5RequireFields.add('Routing_Number__c');
	stage5RequireFields.add('Bank_Name__c');
	stage5RequireFields.add('Bank_Account_Number__c');

    String SolarCurrentStage;
    String SolarCurrentStatus;
    String Stage3LoanCheck;
    String Stage5ACHCheck;
    String OnLoadCheck;
    String Stage3ErrorCheck;
    String Stage3MissingFields;
    String Stage4ErrorCheck;
    String Stage5ErrorCheck;
    String Stage5MissingFields;
    String missingFields = '';
    String waitingCheck;
    
    String type='Solar_Loans__c';
    Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
    Schema.SObjectType solarloan = schemaMap.get(type);
    Map<String, Schema.SObjectField> fieldMap = solarloan.getDescribe().fields.getMap();
    
    system.debug('SolarLoanRecordId'+SolarLoanRecordId); 
    Set<Id> SLIdsToCreateLoan = new Set<Id>();
    

    system.debug('CurrentStage'+CurrentStage);
    Map<string,string> strMap = new  Map<string,string>();
  
    List<Solar_Loans__c> SolarLoanList = [SELECT id,ABA_Bank_Name__c,ACH__c,Additional_Amount__c,Application_Date__c,
            Bank_Account_Number__c,Bank_Name__c,Battery__c,Brand__c,Change_Order__c,CreatedById,CreatedDate,
            Credit_Attributes__c,Credit_Exception__c,Debt_Ratio__c,DocuSignId__c,Due_Date__c,continue__c,
            ECOA_Code__c,Final_Payment_Amount__c,FNI__c,Go_To_Payment__c,Initial_LT_Loan_Agreement__c,
            Installer_Number__c,Installer__c,Interest_Rate__c,Inverter__c,IsDeleted,Joint_Address_1__c,
            Joint_Address_2__c,Joint_City__c,Joint_DOB__c,Joint_FICO_Score__c,Joint_First_Name__c,Joint_Last_Name__c,
            Joint_SSN__c,Joint_State__c,Joint_Zip_Code__c,Latest_LT_Loan_Agreement__c,Legal_Description__c,Loan_Amount__c,Loan_Pmt_Amount__c,
            Loan_Type__c,Maturity_Date__c,Account_Number__r.name,Membership_Fee__c,Member_Number__c,Module__c,Mortgage_Balance__c,Name,
            Name__c,Net_Funding_Amount__c,OID_Fee__c,OwnerId,Primary_Address_1__c,Primary_Address_2__c,
            Primary_City__c,Primary_DOB__c,Primary_FICO_Score__c,Primary_First_Name__c,Primary_Last_Name__c,
            Primary_SSN__c,Primary_State__c,Primary_Zip_Code__c,Product_Loan_Type__c,Product__c,Record_ID__c,
            Routing_Number__c,Site_UUID__c,Status__c,Symitar_Called__c,SystemModstamp,System_Size_kW__c,Term_months__c,
            Valid_ABA__c, Loan_Id__c,Loan_Name_Locator__c,Loan_Tracking_Locator__c,EftLocator__c,ITC_Rate__c,ITC_Amount__c,
            Error_EftLocator__c,Error_Loan_Locator__c,Error_Loan_Name_Locator__c,Error_Loan_Tracking_Locator__c,Approval_Date__c,
            Current_Solar_Loan_Stage__c FROM Solar_Loans__c where id =: SolarLoanRecordId limit 1];
            
    if(SolarLoanList.size() > 0){
        
        SolarCurrentStatus = SolarLoanList[0].Status__c;
       
        if(CurrentStage != null && CurrentStage != ' '){
            
            if(CurrentStage != 'Stage 4' && CurrentStage != 'Stage 3' && CurrentStage != 'Stage 5' && CurrentStage != 'Stage 7'){
                SolarLoanList[0].Current_Solar_Loan_Stage__c = CurrentStage; 
                SolarLoanList[0].continue__c = false;
                update SolarLoanList;
            }           
        }
        SolarCurrentStage = SolarLoanList[0].Current_Solar_Loan_Stage__c;
            
        
        //------------------------------------Stage-2 Member Info validation-----------------------------------------//
        
        
        
        if(CurrentStage == 'Stage 3'){
            
        	for(String fieldName : stage3RequireFields){
        		
				System.debug(fieldName +' - '+SolarLoanList[0].get(fieldName));
				if(SolarLoanList[0].get(fieldName) == null || SolarLoanList[0].get(fieldName) ==''){	

					missingFields += fieldMap.get(fieldName).getDescribe().getLabel() + ', ';
					Stage3ErrorCheck = 'True';
				}
	
			}
			if(SolarLoanList[0].ECOA_Code__c == '2'){	

				for(String jointField : stage3ECOARequireFields){

					System.debug(jointField +' - '+SolarLoanList[0].get(jointField));
					if(SolarLoanList[0].get(jointField) == null || SolarLoanList[0].get(jointField) ==''){	

						missingFields += fieldMap.get(jointField).getDescribe().getLabel() + ', ';
						Stage3ErrorCheck = 'True';

					}
				}
	
            }
            if(solarLoanList[0].ACH__c == 'True'){

                for(String fieldName : stage5RequireFields){
                
                    System.debug(fieldName +' - '+SolarLoanList[0].get(fieldName));
                    if(SolarLoanList[0].ACH__c == 'True' && (SolarLoanList[0].get(fieldName) == null || 
                        SolarLoanList[0].get(fieldName) == '' || SolarLoanList[0].get(fieldName) == '0')){
	            	
	            		missingFields += fieldMap.get(fieldName).getDescribe().getLabel() + ', ';
		            	Stage3ErrorCheck = 'True';
	            	}

                }
            }
			
			if(SolarLoanList[0].Primary_SSN__c != null && SolarLoanList[0].Primary_SSN__c.length() != 9 && Stage3ErrorCheck != 'True'){
								
				Stage3MissingFields = 'The length of the member’s SSN is not correct';
				Stage3ErrorCheck = 'True';
				
			}
			else if(SolarLoanList[0].ECOA_Code__c == '2' && SolarLoanList[0].Joint_SSN__c != null && SolarLoanList[0].Joint_SSN__c.length() != 9 && Stage3ErrorCheck != 'True'){
				
				Stage3MissingFields = 'The length of the member’s Joint SSN is not correct';
				Stage3ErrorCheck = 'True';
			}
			else{
	
				Stage3MissingFields = 'The following fields are required:  '+ missingFields + '.';	
			}
			
        	if(Stage3ErrorCheck != 'True'){
        		Stage3ErrorCheck = 'False';
        	}
        	
        	
	        
        }
        
        system.debug('Stage3MissingFields'+Stage3MissingFields);
        if(Stage3ErrorCheck == 'False'){
            SolarLoanList[0].Current_Solar_Loan_Stage__c = CurrentStage;
            solarLoanList[0].Status__c = 'Approved'; 
            SolarLoanList[0].continue__c = false;
            update SolarLoanList;
            
        }
        
        //------------------------------------Stage-4  Creating Loan Records -----------------------------------------//
        
        if(CurrentStage == 'Stage 4'){
            
            SLIdsToCreateLoan.add(SolarLoanList[0].id);
            SolarLoanToCreateLoan.createSolarLoans(SLIdsToCreateLoan);
        }
        
        //------------------------------------Stage-5 Checking if ACH = False/True------------------------------------//
        
        if(CurrentStage == 'Stage 5'){
            
                   if(SolarLoanList[0].ACH__c == 'True' && (SolarLoanList[0].Routing_Number__c != null && SolarLoanList[0].Routing_Number__c != '0')
                                                        && (SolarLoanList[0].Bank_Name__c != null && SolarLoanList[0].Bank_Name__c != '0')
                                                        && (SolarLoanList[0].Bank_Account_Number__c != null && SolarLoanList[0].Bank_Account_Number__c != '0')){    	
           
                	Stage5ACHCheck = 'True';
                    SolarLoanList[0].Current_Solar_Loan_Stage__c = CurrentStage;
                    SolarLoanList[0].continue__c = false;
                	update SolarLoanList;
              
            	}
            
            	
            	for(String fieldName : stage5RequireFields){
            
	            	System.debug(fieldName +' - '+SolarLoanList[0].get(fieldName));
	            	if(SolarLoanList[0].ACH__c == 'True' && (SolarLoanList[0].get(fieldName) == null || SolarLoanList[0].get(fieldName) =='')){
	            	
	            		missingFields += fieldMap.get(fieldName).getDescribe().getLabel() + ', ';
		            	Stage5ErrorCheck = 'True';
	            	}
	          	}
            
	            if(SolarLoanList[0].ACH__c == 'False'){    	
	           
	                Stage5ACHCheck = 'False';
	            }
            
            Stage5MissingFields = 'The following fields are required:  '+ missingFields + '.';
        }
        
        //----------------------------------ACH = True/False OnLoan Check---------------------------------------------//
        
        if(SolarLoanList[0].ACH__c == 'True' && SolarLoanList[0].Routing_Number__c != null &&
         	SolarLoanList[0].Bank_Name__c != null && SolarLoanList[0].Bank_Account_Number__c != null){
        	OnLoadCheck = 'True';    		
    	}
        if(solarLoanList[0].Current_Solar_Loan_Stage__c == 'Stage 5' && (CurrentStage == null || CurrentStage == ' ')){
            SolarCurrentStage = SolarLoanList[0].Current_Solar_Loan_Stage__c;
        }
        
        
        //------------------------------------Stage-6 Chaging status to "ACH Pending----------------------------------//
        
        if(CurrentStage == 'Stage 6'){
            solarLoanList[0].Status__c = 'ACH Pending';
            SolarLoanList[0].continue__c = false;
            update SolarLoanList;
        
        }
        
        if(SolarLoanList[0].Current_Solar_Loan_Stage__c == 'Stage 6')
            SolarCurrentStage = SolarLoanList[0].Current_Solar_Loan_Stage__c;
        
        //------------------------------------Stage-7 Chaging status to "EFT Record Created"-------------------------//
        
        if(CurrentStage == 'Stage 7'){
            solarLoanList[0].Status__c = 'Completed';
            SolarLoanList[0].continue__c = false;
            update SolarLoanList;
            
        }
        
        //------------------------------------Skipping stages upto "Stage 7" if ACH = False-------------------------//
      
        if(Stage5ACHCheck == 'False' && Stage5ErrorCheck != 'True'){
        
            SolarCurrentStage = 'Stage 7';
            SolarLoanList[0].Current_Solar_Loan_Stage__c = 'Stage 7'; 
            SolarLoanList[0].continue__c = false;
            update SolarLoanList;
            SolarCurrentStage = SolarLoanList[0].Current_Solar_Loan_Stage__c;
        }
        system.debug('SolarLoanList[0].Current_Solar_Loan_Stage__c'+SolarLoanList[0].Current_Solar_Loan_Stage__c);    
        if(SolarLoanList[0].Current_Solar_Loan_Stage__c == 'Stage 7'){
            SolarCurrentStage = SolarLoanList[0].Current_Solar_Loan_Stage__c;
            SolarLoanList[0].continue__c = false;
            SolarLoanList[0].Status__c = 'Done';
            update SolarLoanList;
        }    
        if(SolarLoanList[0].Current_Solar_Loan_Stage__c == 'Stage 8'){
            SolarCurrentStage = SolarLoanList[0].Current_Solar_Loan_Stage__c;
            SolarLoanList[0].Status__c = 'Done';
            update SolarLoanList;
        }   
               
    }

    if(CurrentStage == ' ' && SolarLoanList[0].Current_Solar_Loan_Stage__c == 'Stage 3' &&
            (SolarLoanList[0].Error_Loan_Locator__c != null || SolarLoanList[0].Error_Loan_Name_Locator__c != null || 
             SolarLoanList[0].Error_Loan_Tracking_Locator__c != null)){
            
        if(SolarLoanList[0].Loan_Id__c == null || SolarLoanList[0].Loan_Id__c == ''){

            Stage4ErrorCheck = 'True';
            update SolarLoanList;
        }
    }

    if(CurrentStage == ' ' && SolarLoanList[0].Status__c == 'Waiting for Response' ){
            
        waitingCheck = 'True';
    }
    system.debug('SolarCurrentStage'+SolarCurrentStage);
    strMap.put('SolarCurrentStage',SolarCurrentStage);  
    strMap.put('Stage3LoanCheck',Stage3LoanCheck);
    strMap.put('Stage5ACHCheck',Stage5ACHCheck); 
    strMap.put('SolarCurrentStatus',SolarCurrentStatus);
    strMap.put('OnLoadCheck',OnLoadCheck);  
    strMap.put('Stage5ErrorCheck',Stage5ErrorCheck);
    strMap.put('Stage3ErrorCheck',Stage3ErrorCheck);
    strMap.put('Stage3MissingFields',Stage3MissingFields);
    strMap.put('Stage5MissingFields',Stage5MissingFields);
    strMap.put('Stage4ErrorCheck',Stage4ErrorCheck);
    strMap.put('waitingCheck',waitingCheck);
    
    
     
    return strMap;  
      
    }
    
    //-------------------------------Getting BankName from Entered Routing No-----------------------------------------------//
    
    @AuraEnabled
    public static string routingInfo(String RoutingNumber){
        system.debug('RoutingNumber=='+RoutingNumber);
        String jsonData;  
        Integer Code; 
        HttpRequest req = new HttpRequest();
        String BankName;
        //String RoutingNum = '122105155';
        
        req.setEndpoint('https://www.routingnumbers.info/api/data.json?rn='+RoutingNumber);
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/json');
        req.setHeader('Accept', 'application/json');
        
        Http http = new Http();  
        req.setTimeout(60000);
        HttpResponse res;
        String responseBody;
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
        if(Code == 404 || Code == 400){
            BankName = 'Bank name not found';   
        }
                            
        return BankName; 
    }
    
    
    
    //---------------------------------------------Saving Routing Info------------------------------------------//
    
    @AuraEnabled
    public static void saveRoutingInfo(string SolarLoanRecordId, String RoutingNumber, String BankName) {
        
        List<Solar_Loans__c> SolarLoanList = [SELECT id,ABA_Bank_Name__c,ACH__c,Additional_Amount__c,Application_Date__c,
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
                Current_Solar_Loan_Stage__c FROM Solar_Loans__c where id =: SolarLoanRecordId limit 1];     
     
        if(SolarLoanList.size() > 0){
        
            SolarLoanList[0].Routing_Number__c = RoutingNumber;
            SolarLoanList[0].ABA_Bank_Name__c = BankName;
            system.debug('SolarLoanList'+SolarLoanList);        
            update SolarLoanList;
        }   
     
    }
}