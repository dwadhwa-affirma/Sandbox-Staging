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
    
    List<String> stage3RequireFieldsForMembership = new List<String>();
    stage3RequireFieldsForMembership.add('mem_Primary_First_Name__c');
    //stage3RequireFieldsForMembership.add('Primary_Middle_Initial__c');
    //stage3RequireFieldsForMembership.add('mem_Maiden_Name__c');
    stage3RequireFieldsForMembership.add('mem_Primary_Last_Name__c');
    stage3RequireFieldsForMembership.add('Primary_Email__c');
    stage3RequireFieldsForMembership.add('mem_Primary_DOB__c');
    stage3RequireFieldsForMembership.add('mem_Primary_SSN__c');
    //stage3RequireFieldsForMembership.add('Primary_Cell_Phone__c');  
    //stage3RequireFieldsForMembership.add('Primary_Home_Phone__c');   
    //stage3RequireFieldsForMembership.add('Primary_Work_Phone__c');   
    stage3RequireFieldsForMembership.add('mem_Primary_Street__c');
    stage3RequireFieldsForMembership.add('mem_Primary_City__c');
    stage3RequireFieldsForMembership.add('mem_Primary_State__c');
    stage3RequireFieldsForMembership.add('mem_Primary_Zip_Code__c');
    stage3RequireFieldsForMembership.add('mem_ID_Type__c');
    stage3RequireFieldsForMembership.add('mem_ID_Number__c');
    stage3RequireFieldsForMembership.add('mem_ID_State__c');
    stage3RequireFieldsForMembership.add('mem_ID_Issue_Date__c');
    stage3RequireFieldsForMembership.add('mem_ID_Expiration_Date__c'); 
    stage3RequireFieldsForMembership.add('Employer__c');
    stage3RequireFieldsForMembership.add('Occupation__c');
    stage3RequireFieldsForMembership.add('mem_Primary_A_F_Foreign_Gov_t_Position__c');
    stage3RequireFieldsForMembership.add('mem_Primary_Foreign_Gov_t_Position__c');
    
    List<String> stage3RequireFieldsForJointMembership = new List<String>();
    stage3RequireFieldsForJointMembership.add('mem_Joint_First_Name__c');
    //stage3RequireFieldsForJointMembership.add('Joint_Middle_Initial__c');
    //stage3RequireFieldsForJointMembership.add('Joint_Maiden_Name__c');
    stage3RequireFieldsForJointMembership.add('mem_Joint_Last_Name__c');
    stage3RequireFieldsForJointMembership.add('Joint_Email__c');
    stage3RequireFieldsForJointMembership.add('mem_Joint_DOB__c');
    stage3RequireFieldsForJointMembership.add('mem_Joint_SSN__c');
    //stage3RequireFieldsForJointMembership.add('Joint_Cell_Phone__c');   
    //stage3RequireFieldsForJointMembership.add('Joint_Home_Phone__c');  
    //stage3RequireFieldsForJointMembership.add('Joint_Work_Phone__c');  
    stage3RequireFieldsForJointMembership.add('mem_Joint_Street__c');
    stage3RequireFieldsForJointMembership.add('mem_Joint_City__c');
    stage3RequireFieldsForJointMembership.add('mem_Joint_State__c');
    stage3RequireFieldsForJointMembership.add('mem_Joint_Zip_Code__c');
    //stage3RequireFieldsForJointMembership.add('mem_Joint_Extra_Address__c');
    stage3RequireFieldsForJointMembership.add('Joint_ID_Type__c');
    stage3RequireFieldsForJointMembership.add('Joint_ID_Number__c');
    stage3RequireFieldsForJointMembership.add('Joint_ID_State__c');
    stage3RequireFieldsForJointMembership.add('Joint_ID_Issue_Date__c');
    stage3RequireFieldsForJointMembership.add('Joint_ID_Expiration_Date__c');  
    stage3RequireFieldsForJointMembership.add('mem_Joint_Employer__c');
    stage3RequireFieldsForJointMembership.add('Joint_Occupation__c');
    stage3RequireFieldsForJointMembership.add('mem_Joint_Foreign_Gov_t_Position__c');
    stage3RequireFieldsForJointMembership.add('mem_Joint_A_F_Foreign_Gov_t_Position__c'); 

    List<String> stage3RequireFieldsForMailingAddress = new List<String>();
    //stage3RequireFieldsForMailingAddress.add('mem_Mailing_Extra_Address__c');
    stage3RequireFieldsForMailingAddress.add('Mailing_Street__c');
    stage3RequireFieldsForMailingAddress.add('mem_Mailing_City__c');
    stage3RequireFieldsForMailingAddress.add('mem_Mailing_State__c');
    stage3RequireFieldsForMailingAddress.add('Mailing_Zip__c');

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
    stage3RequireFields.add('County__c');
    //stage3RequireFields.add('Member_Number__c');
	
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
    String Stage2MemberCheck;
    String Stage3LoanCheck;
    String Stage5ACHCheck;
    String OnLoadCheck;
    String JurisdictionErrorCheck;
    String MultipleMembershipCheck;

    String Stage2ErrorCheck;
    String Stage2MissingDocs;
    String Stage3ErrorCheck;
    String Stage3MembershipCheck;
    String Stage3MissingFields;
    String Stage4ErrorCheck;
    String Stage5ErrorCheck;
    String Stage5MissingFields;
    String Stage6ErrorCheck;
    String Stage6MissingFields;

    String missingFields = '';
    String waitingCheck;
    Boolean ProductTypeFound;
    Integer PrimaryAge;
    Integer PrimaryAge1;
    Integer JointAge;
    Integer JointAge1;

    
    String type='Solar_Loans__c';
    Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
    Schema.SObjectType solarloan = schemaMap.get(type);
    Map<String, Schema.SObjectField> fieldMap = solarloan.getDescribe().fields.getMap();
    
    system.debug('SolarLoanRecordId'+SolarLoanRecordId); 
    Set<Id> SLIdsToCreateMem = new Set<Id>(); 
    Set<Id> SLIdsToCreateLoan = new Set<Id>();
    Set<Id> SLIdsToCreateEFT = new Set<Id>();
    Set<Id> SLIdsToFileUCC = new Set<Id>();
    List<SolarLoan_Document__c> SolarDocMemb = new List<SolarLoan_Document__c>();

    Boolean PrimaryZipCode;
    Boolean jointZipCode;
    Boolean PrimaryCellPhone;
    Boolean PrimaryHomePhone;
    Boolean PrimaryWorkPhone;
    Boolean JointCellPhone;
    Boolean JointHomePhone;
    Boolean JointWorkPhone;
    Boolean PrimaryEmail;

    system.debug('CurrentStage'+CurrentStage);
    Map<string,string> strMap = new  Map<string,string>();
  
    List<Solar_Loans__c> SolarLoanList = [SELECT id,ABA_Bank_Name__c,ACH__c,Additional_Amount__c,Application_Date__c,
            Bank_Account_Number__c,Bank_Name__c,Battery__c,Brand__c,Change_Order__c,CreatedById,CreatedDate,Member_Name__r.LastName,
            Credit_Attributes__c,Credit_Exception__c,Debt_Ratio__c,DocuSignId__c,Due_Date__c,continue__c,Member_Name__r.FirstName,
            ECOA_Code__c,Final_Payment_Amount__c,FNI__c,Go_To_Payment__c,Initial_LT_Loan_Agreement__c,Non_Solar_Amount__c,
            Installer_Number__c,Installer__c,Interest_Rate__c,Inverter__c,IsDeleted,Joint_Address_1__c,mem_Joint_SSN__c,
            Joint_Address_2__c,Joint_City__c,Joint_DOB__c,Joint_FICO_Score__c,Joint_First_Name__c,Joint_Last_Name__c,
            Joint_SSN__c,Joint_State__c,Joint_Zip_Code__c,Latest_LT_Loan_Agreement__c,Legal_Description__c,Loan_Amount__c,Loan_Pmt_Amount__c,
            Loan_Type__c,Maturity_Date__c,Account_Number__r.name,Membership_Fee__c,Member_Number__c,Module__c,Mortgage_Balance__c,Name,
            Name__c,Net_Funding_Amount__c,OID_Fee__c,OwnerId,Primary_Address_1__c,Primary_Address_2__c,Episys_Membership__c,
            Primary_City__c,Primary_DOB__c,Primary_FICO_Score__c,Primary_First_Name__c,Primary_Last_Name__c,Jurisdiction__c,
            Primary_SSN__c,Primary_State__c,Primary_Zip_Code__c,Product_Loan_Type__c,Product__c,Record_ID__c,
            Routing_Number__c,Site_UUID__c,Status__c,Symitar_Called__c,SystemModstamp,System_Size_kW__c,Term_months__c,
            Valid_ABA__c, Loan_Id__c,Loan_Name_Locator__c,Loan_Tracking_Locator__c,EftLocator__c,ITC_Rate__c,ITC_Amount__c,
            Error_EftLocator__c,Error_Loan_Locator__c,Error_Loan_Name_Locator__c,Error_Loan_Tracking_Locator__c,Approval_Date__c,
            mem_Primary_First_Name__c,Primary_Middle_Initial__c,mem_Maiden_Name__c,mem_Primary_Last_Name__c,Primary_Email__c,
            mem_Primary_DOB__c,mem_Primary_SSN__c,Primary_Cell_Phone__c,Primary_Home_Phone__c,Primary_Work_Phone__c,
            mem_Primary_Street__c,mem_Primary_City__c,mem_Primary_State__c,mem_Primary_Zip_Code__c,mem_ID_Type__c,
            mem_ID_Number__c,mem_ID_State__c,mem_ID_Issue_Date__c,mem_ID_Expiration_Date__c,Employer__c,Occupation__c,
            mem_Joint_First_Name__c,mem_Joint_Last_Name__c,Joint_Email__c,mem_Joint_DOB__c,mem_Joint_Street__c,mem_Joint_City__c,
            mem_Joint_State__c,mem_Joint_Zip_Code__c,Joint_ID_Type__c,Joint_ID_Number__c,Joint_ID_State__c,Joint_ID_Issue_Date__c,
            Joint_ID_Expiration_Date__c,mem_Joint_Employer__c,Joint_Occupation__c,Mailing_Street__c, mem_Mailing_City__c,mem_Mailing_State__c,
            Mailing_Zip__c,Joint_Cell_Phone__c,Joint_Home_Phone__c,Joint_Work_Phone__c,mem_Primary_A_F_Foreign_Gov_t_Position__c,
            mem_Primary_Foreign_Gov_t_Position__c,mem_Joint_A_F_Foreign_Gov_t_Position__c,mem_Joint_Foreign_Gov_t_Position__c,
            mem_Joint_Extra_Address__c,mem_Primary_Extra_Address__c,mem_Mailing_Extra_Address__c,
            Current_Solar_Loan_Stage__c,County__c FROM Solar_Loans__c where id =: SolarLoanRecordId limit 1];
            
    if(SolarLoanList.size() > 0){

        SolarDocMemb = [select id,Attachment_Id__c,name,Solar_Loans__r.id,Solar_Loans__c from SolarLoan_Document__c
                                         where Solar_Loans__r.id in: SolarLoanList and Document_Name__c LIKE '%Membership Application%' order by createddate desc LIMIT 1];

        /*List<SolarLoan_Document__c> SolarDocGov = [select id,Attachment_Id__c,name,Solar_Loans__r.id,Solar_Loans__c from SolarLoan_Document__c
                                         where Solar_Loans__r.id in: SolarLoanList and Document_Name__c LIKE '%Government ID%' order by createddate desc LIMIT 1];*/

        
        SolarCurrentStatus = SolarLoanList[0].Status__c;

        List<Solar_Loan_Product_Types__c> PDList = Solar_Loan_Product_Types__c.getall().values();
        for(Solar_Loan_Product_Types__c pd : PDList){ 
            if(SolarLoanList[0].Product_Loan_Type__c == pd.Name){
                    ProductTypeFound = true;    
            }
        }
       
        if(CurrentStage != null && CurrentStage != ' '){
            
            if(CurrentStage != 'Stage 2' && CurrentStage != 'Stage 4' && CurrentStage != 'Stage 3' && CurrentStage != 'Stage 5' && CurrentStage != 'Stage 7' && CurrentStage != 'Stage 8'){
                SolarLoanList[0].Current_Solar_Loan_Stage__c = CurrentStage; 
                SolarLoanList[0].continue__c = false;
                update SolarLoanList;
            }           
        }
        SolarCurrentStage = SolarLoanList[0].Current_Solar_Loan_Stage__c;
            
        
        //------------------------------------------------Stage-2 Validation Check------------------------------------------------//

        if(CurrentStage == 'Stage 2'){

            if(SolarDocMemb.size() == 0){
								
				Stage2MissingDocs = 'Membership Application Document is not avaialble.';
				Stage2ErrorCheck = 'True';
            }
            else if(SolarLoanList[0].mem_ID_Issue_Date__c == null || SolarLoanList[0].mem_ID_Expiration_Date__c == null){
								
				Stage2MissingDocs = 'Please enter Primary ID Issue/Expiration Date.';
				Stage2ErrorCheck = 'True';
            }
            else if(SolarLoanList[0].mem_ID_Issue_Date__c > SolarLoanList[0].mem_ID_Expiration_Date__c){
								
				Stage2MissingDocs = 'Primary ID Expiration Date should be greater than ID Issue Date.';
				Stage2ErrorCheck = 'True';
            }
            else if(SolarLoanList[0].mem_Joint_SSN__c != null && (SolarLoanList[0].Joint_ID_Issue_Date__c == null || SolarLoanList[0].Joint_ID_Expiration_Date__c == null)){
								
				Stage2MissingDocs = 'Please enter Joint ID Issue/Expiration Date.';
				Stage2ErrorCheck = 'True';
            }
            else if(SolarLoanList[0].mem_Joint_SSN__c != null && SolarLoanList[0].Joint_ID_Issue_Date__c > SolarLoanList[0].Joint_ID_Expiration_Date__c){

                Stage2MissingDocs = 'Joint ID Expiration Date should be greater than ID Issue Date.';
				Stage2ErrorCheck = 'True';
            }
            else if(SolarLoanList[0].mem_Primary_State__c == null || SolarLoanList[0].county__c == null){
								
				Stage2MissingDocs = 'Please enter County/State details.';
				Stage2ErrorCheck = 'True';
            }
            else{
                
                SLIdsToFileUCC.add(SolarLoanList[0].id);
                SolarLoanToFileUCC.getJurisdiction(SLIdsToFileUCC);
            }
            
        }    

        //------------------------------------Stage-3 Member and Membership Info validation-----------------------------------------//
        
        
        
        if(CurrentStage == 'Stage 3'){
            
        	//----------------------------Primary details check--------------------------------------//

            for(String fieldName : stage3RequireFieldsForMembership){
        		
				System.debug(fieldName +' - '+SolarLoanList[0].get(fieldName));
				if(SolarLoanList[0].get(fieldName) == null || SolarLoanList[0].get(fieldName) ==''){	

					missingFields += fieldMap.get(fieldName).getDescribe().getLabel() + ', ';
					Stage3ErrorCheck = 'True';
				}
	
			}

            //----------------------------Joint details check--------------------------------------//

            if(SolarLoanList[0].mem_Joint_SSN__c != null){

                for(String fieldName : stage3RequireFieldsForJointMembership){
        		
                    System.debug(fieldName +' - '+SolarLoanList[0].get(fieldName));
                    if(SolarLoanList[0].get(fieldName) == null || SolarLoanList[0].get(fieldName) ==''){	
    
                        missingFields += fieldMap.get(fieldName).getDescribe().getLabel() + ', ';
                        Stage3ErrorCheck = 'True';
                    }
        
                }

            }

            //----------------------------Mailling Address check--------------------------------------//

            if(SolarLoanList[0].Mailing_Street__c != null || SolarLoanList[0].mem_Mailing_City__c != null || 
                    SolarLoanList[0].mem_Mailing_State__c != null || SolarLoanList[0].Mailing_Zip__c != null){

                for(String fieldName : stage3RequireFieldsForMailingAddress){
        		
                    System.debug(fieldName +' - '+SolarLoanList[0].get(fieldName));
                    if(SolarLoanList[0].get(fieldName) == null || SolarLoanList[0].get(fieldName) ==''){	
    
                        missingFields += fieldMap.get(fieldName).getDescribe().getLabel() + ', ';
                        Stage3ErrorCheck = 'True';
                    }
        
                }

            }

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

            //-----------------------------------------------Age Validation --------------------------------------------//

            if(SolarLoanList[0].Primary_DOB__c != null)
                PrimaryAge = Integer.valueOf(SolarLoanList[0].Primary_DOB__c.daysBetween(Date.Today()))/365;
            
            if(SolarLoanList[0].mem_Primary_DOB__c != null)
                PrimaryAge1 = Integer.valueOf(SolarLoanList[0].mem_Primary_DOB__c.daysBetween(Date.Today()))/365;
            
            if(SolarLoanList[0].Joint_DOB__c != null)
                JointAge = Integer.valueOf(SolarLoanList[0].Joint_DOB__c.daysBetween(Date.Today()))/365;
            
            if(SolarLoanList[0].mem_Joint_DOB__c != null)
                JointAge1 = Integer.valueOf(SolarLoanList[0].mem_Joint_DOB__c.daysBetween(Date.Today()))/365;

            System.debug('PrimaryAge: '+PrimaryAge);
            System.debug('PrimaryAge1: '+PrimaryAge1);
            System.debug('JointAge: '+JointAge);
            System.debug('JointAge1: '+JointAge1);


            //---------------------------------------Primary Phone validation -------------------------------------------//
            
            if(SolarLoanList[0].Primary_Cell_Phone__c != null)
                PrimaryCellPhone = Pattern.matches('[0-9]{3}-[0-9]{3}-[0-9]{4}', SolarLoanList[0].Primary_Cell_Phone__c);
            
            if(SolarLoanList[0].Primary_Home_Phone__c != null)
                PrimaryHomePhone = Pattern.matches('[0-9]{3}-[0-9]{3}-[0-9]{4}', SolarLoanList[0].Primary_Home_Phone__c);

            if(SolarLoanList[0].Primary_Work_Phone__c != null)
                PrimaryWorkPhone = Pattern.matches('[0-9]{3}-[0-9]{3}-[0-9]{4}', SolarLoanList[0].Primary_Work_Phone__c);

            //---------------------------------------Joint Phone validation -------------------------------------------//

            if(SolarLoanList[0].Joint_Cell_Phone__c != null)
                JointCellPhone = Pattern.matches('[0-9]{3}-[0-9]{3}-[0-9]{4}', SolarLoanList[0].Joint_Cell_Phone__c);
            
            if(SolarLoanList[0].Joint_Home_Phone__c != null)
                JointHomePhone = Pattern.matches('[0-9]{3}-[0-9]{3}-[0-9]{4}', SolarLoanList[0].Joint_Home_Phone__c);

            if(SolarLoanList[0].Joint_Work_Phone__c != null)
                JointWorkPhone = Pattern.matches('[0-9]{3}-[0-9]{3}-[0-9]{4}', SolarLoanList[0].Joint_Work_Phone__c);

            if(SolarLoanList[0].Primary_Zip_Code__c != null)
            	PrimaryZipCode = Pattern.matches('^[0-9]{5}(?:-[0-9]{4})?$',SolarLoanList[0].Primary_Zip_Code__c); 
            
            if(SolarLoanList[0].Joint_Zip_Code__c != null)
                jointZipCode =  Pattern.matches('^[0-9]{5}(?:-[0-9]{4})?$',SolarLoanList[0].Joint_Zip_Code__c);

            if(SolarLoanList[0].Primary_Email__c != null)   
                PrimaryEmail = Pattern.matches('^(?=.{1,64}@)[A-Za-z0-9_-]+(\\.[A-Za-z0-9_-]+)*@[^-][A-Za-z0-9-]+(\\.[A-Za-z0-9-]+)*(\\.[A-Za-z]{2,})$',SolarLoanList[0].Primary_Email__c);

            String emailRegex = '([a-zA-Z0-9_\\-\\.]+)@((\\[a-z]{1,3}\\.[a-z]{1,3}\\.[a-z]{1,3}\\.)|(([a-zA-Z0-9\\-]+\\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})';    
            
            //------------------------------------------------validation check ------------------------------------------------------//

            if(SolarLoanList[0].Non_Solar_Amount__c == null && (SolarLoanList[0].Product_Loan_Type__c == 'Integrated Solar Shingles' ||
                                                                SolarLoanList[0].Product_Loan_Type__c == 'SolarPlus' ||
                                                                SolarLoanList[0].Product_Loan_Type__c == 'SolarPlusITC')){
								
				Stage3MissingFields = 'Please enter Non Solar Amount.';
				Stage3ErrorCheck = 'True';
				
            }
            
            else if((SolarLoanList[0].Bank_Account_Number__c != null && SolarLoanList[0].Bank_Account_Number__c == 'Review and verify' && Stage3ErrorCheck != 'True') ||
                (SolarLoanList[0].FNI__c != null && SolarLoanList[0].FNI__c == 'Review and verify' && Stage3ErrorCheck != 'True')){
								
				Stage3MissingFields = 'Please review and enter valid input for Bank Account Number or FNI.';
				Stage3ErrorCheck = 'True';
				
			}
            else if(SolarLoanList[0].Primary_SSN__c != null && SolarLoanList[0].Primary_SSN__c.length() != 9 && Stage3ErrorCheck != 'True'){
								
				Stage3MissingFields = 'The length of the member’s SSN is not correct.';
				Stage3ErrorCheck = 'True';
				
			}
            else if(SolarLoanList[0].Primary_SSN__c != null && !SolarLoanList[0].Primary_SSN__c.isNumeric()){
								
				Stage3MissingFields = 'Primary SSN should be in number.';
				Stage3ErrorCheck = 'True';
				
			}
			else if(SolarLoanList[0].ECOA_Code__c == '2' && SolarLoanList[0].Joint_SSN__c != null && SolarLoanList[0].Joint_SSN__c.length() != 9 && Stage3ErrorCheck != 'True'){
				
				Stage3MissingFields = 'The length of the member’s Joint SSN is not correct.';
                Stage3ErrorCheck = 'True';
                
			}
            else if(SolarLoanList[0].Joint_SSN__c != null && !SolarLoanList[0].Joint_SSN__c.isNumeric()){
								
				Stage3MissingFields = 'Joint SSN should be in number.';
				Stage3ErrorCheck = 'True';
				
			}
			else if(SolarLoanList[0].Primary_Zip_Code__c != null && PrimaryZipCode == false && Stage3ErrorCheck != 'True'){    
                
                Stage3MissingFields = 'Primary Zip code is not in the correct format.';
                Stage3ErrorCheck = 'True';
         		
			}
			else if(SolarLoanList[0].Joint_Zip_Code__c != null && SolarLoanList[0].ECOA_Code__c == '2' && jointZipCode == false && Stage3ErrorCheck != 'True'){
				
				Stage3MissingFields = 'Joint Zip code is not in the correct format.';
                Stage3ErrorCheck = 'True';
                
            }
            else if(ProductTypeFound != true){
                
                Stage3MissingFields = 'Please enter valid Product Loan Type';
                Stage3ErrorCheck = 'True';
            }
            else if(SolarLoanList[0].Primary_Cell_Phone__c == null && SolarLoanList[0].Primary_Home_Phone__c == null && 
                                                                    SolarLoanList[0].Primary_Work_Phone__c == null){
                
                Stage3MissingFields = 'Please enter at least one Primary Phone Number(Home, Work, Cell).';
                Stage3ErrorCheck = 'True';
            }
            else if(SolarLoanList[0].mem_Joint_SSN__c != null && SolarLoanList[0].Joint_Cell_Phone__c == null && 
                    SolarLoanList[0].Joint_Home_Phone__c == null && SolarLoanList[0].Joint_Work_Phone__c == null){
                
                Stage3MissingFields = 'Please enter at least one Joint Phone Number(Home, Work, Cell).';
                Stage3ErrorCheck = 'True';
            }
            else if(SolarLoanList[0].Primary_Cell_Phone__c != null && PrimaryCellPhone == false){

                Stage3MissingFields = 'Please enter valid Primary Cell Phone Number.';
                Stage3ErrorCheck = 'True';
            }
            else if(SolarLoanList[0].Joint_Cell_Phone__c != null && JointCellPhone == false){

                Stage3MissingFields = 'Please enter valid Joint Cell Phone Number.';
                Stage3ErrorCheck = 'True';
            }
            else if(SolarLoanList[0].Primary_Home_Phone__c != null && PrimaryHomePhone == false){

                Stage3MissingFields = 'Please enter valid Primary Home Phone Number.';
                Stage3ErrorCheck = 'True';
            }
            else if(SolarLoanList[0].Joint_Home_Phone__c != null && JointHomePhone == false){

                Stage3MissingFields = 'Please enter valid Joint Home Phone Number.';
                Stage3ErrorCheck = 'True';
            }
            else if(SolarLoanList[0].Primary_Work_Phone__c != null && PrimaryWorkPhone == false){

                Stage3MissingFields = 'Please enter valid Primary Work Phone Number';
                Stage3ErrorCheck = 'True';
            }
            else if(SolarLoanList[0].Joint_Work_Phone__c != null && JointWorkPhone == false){

                Stage3MissingFields = 'Please enter valid Joint Work Phone Number.';
                Stage3ErrorCheck = 'True';
            }
            else if(SolarLoanList[0].Primary_Email__c != null && PrimaryEmail == false){

                Stage3MissingFields = 'Please enter valid Primary Email.';
                Stage3ErrorCheck = 'True';
            }
            /*else if(system.today() > SolarLoanList[0].mem_ID_Expiration_Date__c ){

                Stage3MissingFields = 'Primary Expiration date must be future date.';
                Stage3ErrorCheck = 'True';
            }*/
            else if((system.today() - 30)< SolarLoanList[0].mem_ID_Issue_Date__c ){

                Stage3MissingFields = 'Primary Issue date must be 30 days older.';
                Stage3ErrorCheck = 'True';
            }
            /*else if(SolarLoanList[0].Joint_ID_Expiration_Date__c != null && system.today() > SolarLoanList[0].Joint_ID_Expiration_Date__c ){

                Stage3MissingFields = 'Joint Expiration date must be future date.';
                Stage3ErrorCheck = 'True';
            }*/
            else if(SolarLoanList[0].Joint_ID_Issue_Date__c != null && (system.today() - 30) < SolarLoanList[0].Joint_ID_Issue_Date__c ){

                Stage3MissingFields = 'Joint Issue date must be 30 days older.';
                Stage3ErrorCheck = 'True';
            }
            else if(SolarLoanList[0].mem_Primary_SSN__c != null && SolarLoanList[0].mem_Primary_SSN__c.length() != 9){
								
				Stage3MissingFields = 'The length of the member’s SSN is not correct.';
				Stage3ErrorCheck = 'True';
				
			}
            else if(SolarLoanList[0].mem_Primary_SSN__c != null && !SolarLoanList[0].mem_Primary_SSN__c.isNumeric()){
								
				Stage3MissingFields = 'Primary SSN should be in number.';
				Stage3ErrorCheck = 'True';
				
			}
            else if(SolarLoanList[0].mem_Joint_SSN__c != null && SolarLoanList[0].mem_Joint_SSN__c.length() != 9){
				
				Stage3MissingFields = 'The length of the member’s Joint SSN is not correct.';
                Stage3ErrorCheck = 'True';
                
			}
            else if(SolarLoanList[0].mem_Joint_SSN__c != null && !SolarLoanList[0].mem_Joint_SSN__c.isNumeric()){
								
				Stage3MissingFields = 'Joint SSN should be in number.';
				Stage3ErrorCheck = 'True';
				
			}
            else if(SolarLoanList[0].mem_ID_Number__c != null && SolarLoanList[0].mem_ID_Number__c.contains('.')){
				
				Stage3MissingFields = 'Primary ID number should not contain decimal values.';
                Stage3ErrorCheck = 'True';
                
			}
            else if(SolarLoanList[0].Joint_ID_Number__c != null && SolarLoanList[0].Joint_ID_Number__c.contains('.')){
				
				Stage3MissingFields = 'Joint ID number should not contain decimal values.';
                Stage3ErrorCheck = 'True';

          	}
            else if(SolarLoanList[0].Primary_Address_1__c != null && (SolarLoanList[0].Primary_Address_1__c.contains('Box ') ||
                                                                    SolarLoanList[0].Primary_Address_1__c.contains('P.O. Box'))){
				
				Stage3MissingFields = 'P.O. Box address is not acceptable for Residential Address.';
                Stage3ErrorCheck = 'True';

          	}
            else if(SolarLoanList[0].mem_Primary_Street__c != null && (SolarLoanList[0].mem_Primary_Street__c.contains('Box ') ||
                                                                    SolarLoanList[0].mem_Primary_Street__c.contains('P.O. Box'))){
				
				Stage3MissingFields = 'P.O. Box address is not acceptable for Residential Address.';
                Stage3ErrorCheck = 'True';
          	}
            else if(SolarLoanList[0].mem_Primary_Street__c != null && (SolarLoanList[0].mem_Primary_Street__c.contains('Box ') ||
                                                                    SolarLoanList[0].mem_Primary_Street__c.contains('P.O. Box'))){
				
				Stage3MissingFields = 'P.O. Box address is not acceptable for Residential Address.';
                Stage3ErrorCheck = 'True';
          	}    
            else if((SolarLoanList[0].Primary_DOB__c != null && PrimaryAge < 18) ||
                    (SolarLoanList[0].mem_Primary_DOB__c != null && PrimaryAge1 < 18)){
				
				Stage3MissingFields = 'Primary DOB must be 18 or over.';
                Stage3ErrorCheck = 'True';

          	}
            else if((SolarLoanList[0].Joint_DOB__c != null && JointAge < 18) ||
                    (SolarLoanList[0].mem_Joint_DOB__c != null && JointAge1 < 18)){
                
                Stage3MissingFields = 'Joint DOB must be 18 or over.';
                Stage3ErrorCheck = 'True';
            }
            else if(SolarLoanList[0].mem_Joint_Extra_Address__c != null && SolarLoanList[0].mem_Joint_Extra_Address__c.length() > 40){

                Stage3MissingFields = 'Joint ExtraAdress contains more than 40 characters.';
                Stage3ErrorCheck = 'True';
            }  
            else if(SolarLoanList[0].mem_Primary_Extra_Address__c != null && SolarLoanList[0].mem_Primary_Extra_Address__c.length() > 40){

                Stage3MissingFields = 'Primary ExtraAdress contains more than 40 characters.';
                Stage3ErrorCheck = 'True';
            }
            else if(SolarLoanList[0].mem_Mailing_Extra_Address__c != null && SolarLoanList[0].mem_Mailing_Extra_Address__c.length() > 40){

                Stage3MissingFields = 'Mailing ExtraAdress contains more than 40 characters.';
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

            SolarLoanList[0].continue__c = false;
            SolarLoanList[0].Status__c = 'Approved';
            SolarLoanList[0].Current_Solar_Loan_Stage__c = 'Stage 3';
            update SolarLoanList;
                 
        }
        
        //------------------------------------Stage-4 Creating Loan Records -----------------------------------------//
        
        
        if( CurrentStage == 'Stage 4'){
             
            SLIdsToCreateLoan.add(SolarLoanList[0].id);
            SolarLoanToCreateLoan.createSolarLoans(SLIdsToCreateLoan);
        }

        if(SolarLoanList[0].Brand__c == null || SolarLoanList[0].Brand__c == ''){
             
            SLIdsToCreateLoan.add(SolarLoanList[0].id);
            SolarLoanToCreateLoan.getMemberBrand(SLIdsToCreateLoan);
        }

        /*if(CurrentStage == ' ' && SolarLoanList[0].Current_Solar_Loan_Stage__c == 'Stage 4' && SolarLoanList[0].Episys_Membership__c == 'Already Created'){
            Stage3MembershipCheck = 'True';
        }*/
        
        //------------------------------------Stage-5 Checking if ACH = False/True------------------------------------//
        
        if(CurrentStage == 'Stage 5'){
            
                if(SolarLoanList[0].ACH__c == 'True' && (SolarLoanList[0].Routing_Number__c != null && SolarLoanList[0].Routing_Number__c != '0')
                                                        && (SolarLoanList[0].Bank_Name__c != null && SolarLoanList[0].Bank_Name__c != '0')
                                                        && (SolarLoanList[0].Bank_Account_Number__c != null && SolarLoanList[0].Bank_Account_Number__c != '0')){    	
           
                    if(SolarLoanList[0].Routing_Number__c != null && (SolarLoanList[0].Routing_Number__c.length() != 9 || (SolarLoanList[0].Routing_Number__c.substring(0,1) != '0' && 
                        SolarLoanList[0].Routing_Number__c.substring(0,1) != '1' && SolarLoanList[0].Routing_Number__c.substring(0,1) != '2' &&
                        SolarLoanList[0].Routing_Number__c.substring(0,1) != '3'))){
                        
                        Stage5MissingFields = 'Plese enter valid ABA/Routing Number.';
				        Stage5ErrorCheck = 'True';
                    }
                    else{
                     
                        Stage5ACHCheck = 'True';
                        SolarLoanList[0].Current_Solar_Loan_Stage__c = CurrentStage;
                        SolarLoanList[0].continue__c = false;
                        update SolarLoanList;
                    }    
            	}
            
            	
            	for(String fieldName : stage5RequireFields){
            
	            	System.debug(fieldName +' - '+SolarLoanList[0].get(fieldName));
	            	if(SolarLoanList[0].ACH__c == 'True' && (SolarLoanList[0].get(fieldName) == null || SolarLoanList[0].get(fieldName) =='')){
	            	
	            		missingFields += fieldMap.get(fieldName).getDescribe().getLabel() + ', ';
		            	Stage5ErrorCheck = 'True';
	            	}
                  }
                
                if(missingFields != '') {
                    
                    Stage5MissingFields = 'The following fields are required:  '+ missingFields + '.';        
                }
                if(SolarLoanList[0].ACH__c == 'False'){    	
	           
                    Stage5ACHCheck = 'False';
                }
            
        }
        
		
		//-----------------------------------Change the "Member Number" look up if the Account Number != Member Number--------//

        
        if(SolarLoanList[0].Member_Number__c != SolarLoanList[0].Account_Number__r.name){

            system.debug('Account Number '+SolarLoanList[0].Account_Number__r.name);
            SolarLoanList[0].Account_Number__c = null;
            SolarLoanList[0].Member_Name__c = null;
            update SolarLoanList;
        }
        
        
        //-------------------------------------------ACH = True/False OnLoan Check-------------------------------------------//
        
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
        
        if(CurrentStage == 'Stage 7' && (SolarLoanList[0].Brand__c == null || SolarLoanList[0].Brand__c == '')){    
                
            Stage6MissingFields = 'Please enter Brand before creating EFT record.';
            Stage6ErrorCheck = 'True';
             
        }
        else if(CurrentStage == 'Stage 7' && (SolarLoanList[0].EftLocator__c == null || SolarLoanList[0].EftLocator__c == '')){
            SLIdsToCreateEFT.add(SolarLoanList[0].id);
            SolarLoanToSymitar.insertSolarLoans(SLIdsToCreateEFT);
            
            /*PageReference PDf =  Page.UCCIntakefile;
            PDf.getParameters().put('Id',solarLoanList[0].Id);
            PDf.setRedirect(true);
            Attachment attach = new Attachment();
            Blob b ;
            b = PDf.getContent();
            attach.Body = b;
            attach.Name = 'MD Land Instrument Intake Sheet.pdf';
            attach.IsPrivate = false;
            attach.ParentId = solarLoanList[0].Id;
            insert attach;*/
        }
        
        //------------------------------------------Stage-8 Filing UCC ---------------------------------------------//

        system.debug('CurrentStage'+CurrentStage);

        if(CurrentStage == 'Stage 8'){
            SLIdsToFileUCC.add(SolarLoanList[0].id);
            SolarLoanToFileUCC.filUCC(SLIdsToFileUCC);
            SolarLoanList[0].Status__c = 'UCC Pending';
            update SolarLoanList;
        }

        //------------------------------------Skipping stages upto "Stage 8" if ACH = False-------------------------//
      
        if(Stage5ACHCheck == 'False' && Stage5ErrorCheck != 'True'){
        
            SolarCurrentStage = 'Stage 7';
            SolarLoanList[0].Current_Solar_Loan_Stage__c = 'Stage 7'; 
            SolarLoanList[0].continue__c = false;
            update SolarLoanList;
            SolarCurrentStage = SolarLoanList[0].Current_Solar_Loan_Stage__c;
        }
        
        system.debug('SolarLoanList[0].Current_Solar_Loan_Stage__c'+SolarLoanList[0].Current_Solar_Loan_Stage__c);    
        
        if(SolarLoanList[0].Current_Solar_Loan_Stage__c == 'Stage 8'){

            if(SolarLoanList[0].ACH__c == 'False'){    	
	           
                Stage5ACHCheck = 'False';
            }
            SolarCurrentStage = SolarLoanList[0].Current_Solar_Loan_Stage__c;
            SolarLoanList[0].continue__c = false;
            SolarLoanList[0].Status__c = 'Done';
            update SolarLoanList;
        }    
       
               
    }

    if(CurrentStage == ' ' && (SolarLoanList[0].Current_Solar_Loan_Stage__c == 'Stage 1' || SolarLoanList[0].Current_Solar_Loan_Stage__c == 'Stage 7')
                             && SolarLoanList[0].Jurisdiction__c == 'Not Found'){
            
        JurisdictionErrorCheck = 'True';
        update SolarLoanList;
    }
  
    if(CurrentStage == ' ' && SolarLoanList[0].Current_Solar_Loan_Stage__c == 'Stage 3' && 
                                SolarLoanList[0].Error_Loan_Locator__c == 'There are multiple membership accounts'){
            
        MultipleMembershipCheck = 'True';
    }

    if(CurrentStage == ' ' && SolarLoanList[0].Current_Solar_Loan_Stage__c == 'Stage 3' &&  Stage2MemberCheck != 'False' &&
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

    if(CurrentStage == ' ')
        Stage5ACHCheck = SolarLoanList[0].ACH__c;
        
    system.debug('SolarCurrentStage'+SolarCurrentStage);
    strMap.put('SolarCurrentStage',SolarCurrentStage);  
    strMap.put('Stage3LoanCheck',Stage3LoanCheck);
    strMap.put('Stage5ACHCheck',Stage5ACHCheck); 
    strMap.put('SolarCurrentStatus',SolarCurrentStatus);
    strMap.put('OnLoadCheck',OnLoadCheck);  
    strMap.put('Stage5ErrorCheck',Stage5ErrorCheck);
    strMap.put('Stage6ErrorCheck',Stage6ErrorCheck);
    strMap.put('Stage3ErrorCheck',Stage3ErrorCheck);
    
    strMap.put('Stage2MissingDocs',Stage2MissingDocs);
    strMap.put('Stage2ErrorCheck',Stage2ErrorCheck);
    //strMap.put('Stage3MembershipCheck',Stage3MembershipCheck);
    strMap.put('Stage3MissingFields',Stage3MissingFields);
    strMap.put('Stage5MissingFields',Stage5MissingFields);
    strMap.put('Stage6MissingFields',Stage6MissingFields);
    strMap.put('Stage4ErrorCheck',Stage4ErrorCheck);
    strMap.put('JurisdictionErrorCheck',JurisdictionErrorCheck);
    strMap.put('MultipleMembershipCheck',MultipleMembershipCheck);
    strMap.put('waitingCheck',waitingCheck);
    //strMap.put('Stage2MemberCheck',Stage2MemberCheck);
    
     
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