public class EFTController {  
    
    public EFT__c ACH;
    public EFT__c ACHDetail{get; set;}
    public id objParentId{get;set;}

    public Id signAttachmentId{get {
        List<Attachment> a = new List<Attachment>();
        a = [SELECT Id FROM Attachment Where ParentId=:objParentId and Name='ESignature.png' Order by CreatedDate desc LIMIT 1]; 
        if(a.size() > 0) {return a[0].Id;} 
        return null;} set;}

    public EFTController(ApexPages.StandardController stdController) {
        this.ACH = (EFT__c)stdController.getRecord();
        this.objParentId=this.ACH.Id;
        system.debug(ApexPages.currentPage().getParameters().get('id'));
        this.ACHDetail = [SELECT id, name, Member_Account__c, Stage__c, Action_Type__c, Share_Loan_Id__c, Type__c	,Share_Loan_Type__c, Share_Loan_Description__c,
                            Routing_Number__c, Bank_Name__c, Account_Number__c, Alternate_Amount__c,Effective_Date__c,
                            Frequency__c,isAlternateAmount__c, Payment_Amount__c, Day_of_Month__c,Second_Day_of_Month__c, Member_Account__r.name, Case__c, Case__r.CaseNumber, Case__r.Status	, Expired__c, Member_Name__c
                            from EFT__c  WHERE Id=:this.ACH.Id];
    }

    public List<SelectOption> getTypes(){
        Schema.sObjectType sobject_type = EFT__c.getSObjectType();
        Schema.DescribeSObjectResult sobject_describe = sobject_type.getDescribe();
        Map<String, Schema.SObjectField> field_map = sobject_describe.fields.getMap();
        System.debug('field_map=='+field_map);
        List<Schema.PicklistEntry> pick_list_values = field_map.get('Type__c').getDescribe().getPickListValues();
        List<selectOption> options = new List<selectOption>();
        for (Schema.PicklistEntry a : pick_list_values) {
                  options.add(new selectOption(a.getLabel(), a.getValue()));
        }
        return options;
    }

     //------------------------------- Getting Stage Details and Member Account Details-----------------------------------------------//
    @AuraEnabled
    public static map<string,object> getStageData(string recordId, string sObjectType){
        map<string,object> resultMap = new map<string,object>();
        
        List<EFT_Stages__c> EFTStages = new List<EFT_Stages__c>();
        EFTStages = [SELECT id, name, isActive__c, Order__c, Stage_Action__c,Stage_Action_Placeholder__c, Stage_Component__c, Stage_Label__c, StepId__c from EFT_Stages__c where isActive__c = true]; //where isActive__c = true;      //EFT_Stages__c.getall().values();
        resultMap.put('EFTStages', EFTStages);
        system.debug('sObjectType=='+sObjectType);
       
            List<EFT__c> EFTRecord = [Select id, name, Member_Account__c, Stage__c, Action_Type__c from EFT__c where Member_Account__c =:recordId limit 1];
            integer activeStageIndex = 0;
            if(EFTRecord.size() >0){               
                for(EFT_Stages__c eftstage:EFTStages){
                    if(EFTRecord[0].Stage__c == eftstage.Stage_Label__c){
                    	activeStageIndex = (integer)eftstage.Order__c;
                	}
                }
                              
                resultMap.put('EFT', EFTRecord);
                
            }
            Account_Details__c MemberAccount = [select id,name from Account_Details__c where id=:recordId limit 1];
            resultMap.put('MemberAccount', MemberAccount);
       
        return resultMap;
    }
    
    @AuraEnabled
    public static map<string,object> getMembers(string recordId){
    	list<Person_Account__c> paList = PersonNameLightningController.getData(recordId);
    	system.debug('result=='+paList);
    	map<string,object> resultmap=new map<string,object>();
    	
    	list<Person_Account__c> result = new List<Person_Account__c>();
    	
    	set<string> typeList = new set<string>();
        for(Member360_TypeTranslate__c t : Member360_TypeTranslate__c.getAll().values()){
        	typeList.add(t.name);	
        } 
        
        for(Person_Account__c var: paList){           			
		         	if(typeList.contains(var.TypeTranslate__c)){
        				result.add(var);
        			}    
        			
            }
        resultmap.put('PersonList', result);
        List<EFT__C> existingEFTs = getEFTRecordsEpisys(recordId);
        if(existingEFTs.size() > 0){
        	resultmap.put('EFTList', existingEFTs);
        }
    	return resultmap;
    }    
    
    @AuraEnabled
    public static EFT__c getEFT(EFT__c EFTRecord){
        system.debug('EFTRecord.id=='+EFTRecord.id);
        system.debug('EFTRecord.Id=='+EFTRecord.Id);
    	if(EFTRecord.id != null){
        EFT__c ResultEFTRecord = [select id, name, Member_Account__c, Stage__c, Action_Type__c, Share_Loan_Id__c, Type__c	,Share_Loan_Type__c, Share_Loan_Description__c,
                                      Routing_Number__c, Bank_Name__c, Account_Number__c, Alternate_Amount__c,Effective_Date__c,EFT_ID_Type__c,
                                      Frequency__c, Payment_Amount__c, Day_of_Month__c,Second_Day_of_Month__c, Member_Account__r.name, Case__c, Case__r.CaseNumber, Case__r.Status	, Expired__c, Member_Name__c,isAlternateAmount__c
                                      from EFT__c where id =: EFTRecord.id limit 1];
                                      return ResultEFTRecord;
    	}
        else{
        	return EFTRecord;
        }
        
        
    }
   
   
    //------------------------------- Saving EFT data to Salesforce-----------------------------------------------//
    @AuraEnabled
    public static EFT__c saveStageData(EFT__c EFTRecord){
        system.debug('EFTRecord=='+EFTRecord.Id);
        if(EFTRecord.Second_Day_of_Month__c == '0'){
        	EFTRecord.Second_Day_of_Month__c = '';
        }
        if(EFTRecord.Day_of_Month__c == '0'){
        	EFTRecord.Day_of_Month__c = (string)'0';
        }
        List<EFT__c> EFTRecordList = [Select id, name, Member_Account__c, Stage__c, Action_Type__c, EftLocator__c from EFT__c where id =:EFTRecord.id limit 1];
        
        system.debug('EFTRecordList.size=='+EFTRecordList.size());
        system.debug('EFTRecordList.MemberAccount=='+EFTRecord.Member_Account__c);
         system.debug('EFTRecordList.MemberAccount=='+EFTRecord.Member_Account__r);
        //system.debug('EFTRecordList'+EFTRecordList.size());
      //  system.debug('EFTRecord.Second_Day_of_Month__c=='+EFTRecord.Second_Day_of_Month__c);
        
        if(EFTRecordList.size() == 0){
            string MemberAccountID = EFTRecord.Member_Account__c == null ? EFTRecord.Member_Account__r.Id : EFTRecord.Member_Account__c;
        	 Account_Details__c MemberAccount = [select id,name, Parent_Account__c from Account_Details__c where id=: MemberAccountID limit 1];
        	system.debug('EFTRecord.Member_Account__r.Parent_Account__c=='+MemberAccount.Parent_Account__c);
        	Person_Account__c paPrimary = [SELECT Id,PersonID__c,
                             Account_Number__c, Account_Number__r.RecType__c,TypeTranslate__c, Account_Number__r.Name, PersonID__r.Home_Phone__pc,PersonID__r.Residential_City__pc,PersonID__r.Residential_State__pc, PersonID__r.Residential_Street__pc, PersonID__r.Residential_Zipocde__pc, PersonID__r.Name, PersonID__r.Email_raw__c FROM Person_Account__c 
                             WHERE (Account_Number__c =: MemberAccountID OR Account_Number__c =: MemberAccount.Parent_Account__c) and TypeTranslate__c  like '%Primary%' limit 1];
            
          /*  if(EFTRecord.Type__c == 'Checking'){
               EFTRecord.Docusign_Checking_Type__c = true;
               EFTRecord.Docusign_Savings_Type__c = false; 
            }
            else if(EFTRecord.Type__c == 'Savings'){
               EFTRecord.Docusign_Checking_Type__c = false;
               EFTRecord.Docusign_Savings_Type__c = true; 
            }*/
            if(EFTRecord.Alternate_Amount__c == null || EFTRecord.Alternate_Amount__c == 0){
            	EFTRecord.Docusign_is_Additional_Amount__c = false;
            }
            else{
            	EFTRecord.Docusign_is_Additional_Amount__c = true;
            }
            if(EFTRecord.Member_Account__c == null){
                EFTRecord.Member_Account__c = EFTRecord.Member_Account__r.Id;
            }
      		//EFTRecord.Member_Name__c = paPrimary.PersonID__r.Name;
            insert EFTRecord;
            return EFTRecord;
        }
        else{
        	EFTRecordList[0].Stage__c =  EFTRecord.Stage__c;
            EFTRecordList[0].Share_Loan_Id__c =  EFTRecord.Share_Loan_Id__c;
            EFTRecordList[0].Share_Loan_Type__c =  EFTRecord.Share_Loan_Type__c;
            EFTRecordList[0].Share_Loan_Description__c =  EFTRecord.Share_Loan_Description__c;
            EFTRecordList[0].EFT_ID_Type__c =  EFTRecord.EFT_ID_Type__c;
            EFTRecordList[0].Routing_Number__c =  EFTRecord.Routing_Number__c;
            EFTRecordList[0].Bank_Name__c =  EFTRecord.Bank_Name__c;
            EFTRecordList[0].Account_Number__c =  EFTRecord.Account_Number__c;
            EFTRecordList[0].Type__c  =  EFTRecord.Type__c;
            EFTRecordList[0].Alternate_Amount__c  =  EFTRecord.Alternate_Amount__c;
            EFTRecordList[0].Payment_Amount__c  =  EFTRecord.Payment_Amount__c;
            EFTRecordList[0].Frequency__c  =  EFTRecord.Frequency__c;
            EFTRecordList[0].Effective_Date__c  =  EFTRecord.Effective_Date__c;
            EFTRecordList[0].Day_of_Month__c  =  EFTRecord.Day_of_Month__c;
            EFTRecordList[0].Second_Day_of_Month__c  =  EFTRecord.Second_Day_of_Month__c;
            EFTRecordList[0].Action_Type__c  =  EFTRecord.Action_Type__c;
            EFTRecordList[0].Update_DocuSignId__c  =  '';
            EFTRecordList[0].Update_Docusign_Status__c  =  '';
            EFTRecordList[0].Member_Name__c  =  EFTRecord.Member_Name__c;
            EFTRecordList[0].Docusign_Member_Email__c  =  EFTRecord.Docusign_Member_Email__c;
            EFTRecordList[0].EftLocator__c  =  EFTRecord.EftLocator__c;
            if(EFTRecord.Type__c == 'Checking'){
               EFTRecordList[0].Docusign_Checking_Type__c = true;
               EFTRecordList[0].Docusign_Savings_Type__c = false; 
            }
            else if(EFTRecord.Type__c == 'Savings'){
               EFTRecordList[0].Docusign_Checking_Type__c = false;
               EFTRecordList[0].Docusign_Savings_Type__c = true; 
            }
            if(EFTRecord.Alternate_Amount__c == null || EFTRecord.Alternate_Amount__c == 0){
            	EFTRecord.Docusign_is_Additional_Amount__c = false;
            }
            else{
            	EFTRecord.Docusign_is_Additional_Amount__c = true;
            }
            update EFTRecordList;
            return EFTRecordList[0];
        }
          
    }
    
    @AuraEnabled
    public static EFT__c expireEFT(EFT__c EFTRecord){
    	
       // system.debug('EFTRecordString=='+EFTRecordString);
        //EFT__c EFTRecord = (EFT__c) System.JSON.deserialize(EFTRecordString, EFT__c.Class);
        system.debug('EFTRecordId=='+EFTRecord.Id);
        system.debug('EFTRecordId=='+EFTRecord.EftLocator__c);
        EFT__c EFTRecordList = new EFT__c();
        if(EFTRecord.Id != null){
        	EFTRecordList = [Select Account_Number__c,Action_Type__c,Alternate_Amount__c,Bank_Name__c,
                         CreatedById,CreatedDate,Day_of_Month__c,Second_Day_of_Month__c,DocuSignId__c,Effective_Date__c,Expiration_Date__c,
                         Frequency__c,Id,Member_Account__c,Member_Account__r.Brand__c,Member_Account__r.Name, Member__c,Name,Case__c,
                         OwnerId,Payment_Amount__c,Routing_Number__c,Share_Loan_Id__c,Stage__c,EftLocator__c,Share_Loan_Description__c,Share_Loan_Type__c,Member_Name__c,
                         Status__c,Type__c, EFT_ID_Type__c, Expired__c from EFT__c where id =:EFTRecord.Id limit 1];
	        if(EFTRecordList != null){            
	            EFTRecordList.Expired__c  =  true;
	            EFTRecordList.Action_Type__c  =  'Update';
	            EFT__c ResultEFTRecord = createCase(EFTRecordList);
	            EFTRecordList.Case__c = ResultEFTRecord.case__c;
	           // update EFTRecordList;
	        }
        }
        else{
        	 system.debug('Insert=='+EFTRecord.EftLocator__c);
            system.debug('Member_Account__c=='+EFTRecord.Member_Account__c);
            system.debug('Member_Account__r.Id=='+EFTRecord.Member_Account__r.Id);
            system.debug('Member_Account__r.Name=='+EFTRecord.Member_Account__r.Name);
            if(EFTRecord.Member_Account__c == null){
                EFTRecord.Member_Account__c = EFTRecord.Member_Account__r.Id;
            }
            insert EFTRecord;
        		EFTRecord.Expired__c  =  true;
	            EFTRecord.Action_Type__c  =  'Update';	             
	            EFT__c ResultEFTRecord = createCase(EFTRecord);
	            EFTRecord.Case__c = ResultEFTRecord.case__c;	            
	            EFTRecordList=EFTRecord;
        }
        update EFTRecordList;
        system.debug('EFTRecordList.size=='+EFTRecordList.id);
        
        
       // EFT__c EFTRecordList1 = [Select id, name, Member_Account__c, Stage__c, Action_Type__c, Expired__c, Expiration_Date__c from EFT__c where id =:EFTRecord.Id limit 1];
        
		return EFTRecordList;        
    }
    
    
     //------------------------------- Createing Case-----------------------------------------------//    
    @AuraEnabled
    public static EFT__c createCase(EFT__c EFTRecord){
        system.debug('EFTID==='+EFTRecord.id);
        system.debug('Member_Account__c==='+EFTRecord.Member_Account__c);
        system.debug('Member_Account__r==='+EFTRecord.Member_Account__r.Id);
        system.debug('Member_Name__c==='+EFTRecord.Member_Name__c);
        list<CaseRecordType__c> scList = [SELECT Id,
                                                 Primary_Category__c,
                                                 Secondary_Category__c,
                                                 Teritiary_Category__c,
                                                 Record_Type_Name__c,
                                                 SLA__c,
                                                 RecordTypeId__c FROM CaseRecordType__c WHERE Primary_Category__c = 'Account Maintenance' AND Secondary_Category__c='Account Services' AND Teritiary_Category__c='ACH - Authorization for Debit' LIMIT 1];
       
    		Group gp = [select Id, Name from Group where  Type = 'Queue' AND NAME = 'Authentication Failed – Unusual Activity'];
			case cs = new case();
			 for(CaseRecordType__c crt : scList){
		            cs.RecordTypeId = scList[0].RecordTypeId__c;
		            cs.Primary_Category__c = scList[0].Primary_Category__c;
		            cs.Secondary_Category__c = scList[0].Secondary_Category__c;
		            cs.Tertiary_Category__c = scList[0].Teritiary_Category__c;
		            cs.Sla__c = scList[0].SLA__c;
	            
             	}    
				//cs.AccountId = EFTRecord.Member_Account__c;
				cs.Status = 'Open';
				cs.Subject = 'ACH Record';
				cs.ownerid = '005j000000DCwXHAA1';
				//cs.CaseComments__c = casecomment;
				string operation='';
				if(EFTRecord.Action_Type__c == 'Create'){
					operation = 'ACH Record Created' + '\n';
				}
				else if(EFTRecord.Action_Type__c == 'Update' && !EFTRecord.Expired__c){
					operation = 'ACH Record Updated'  + '\n';
				}
				else if(EFTRecord.Action_Type__c == 'Update' && EFTRecord.Expired__c){
					
					operation = 'ACH Record Expired' + '\n' + 'Expiration Date:' + EFTRecord.Expiration_Date__c + '\n' ;
				}
				if(EFTRecord.Member_Account__c != null)
					cs.Account_Number__c = EFTRecord.Member_Account__c;
				else
					cs.Account_Number__c = EFTRecord.Member_Account__r.Id;
        		cs.Description = operation + 'Member Name:' + EFTRecord.Member_Name__c 
        							+ '\n' + 'Share/Loan:' + EFTRecord.Share_Loan_Id__c 
                                    + '\n' + 'ABA/Routing#:' + EFTRecord.Routing_Number__c 
                                     + '\n' +'Funding FI:' + EFTRecord.Bank_Name__c
                                     + '\n' +'Account Number:' + EFTRecord.Account_Number__c
                                     + '\n' +'Type:' + EFTRecord.Type__c
                                     + '\n' +'Payment Amount:' + EFTRecord.Payment_Amount__c
                                     + '\n' +'Additional Payment Amount:' + (EFTRecord.Alternate_Amount__c == null ? 0  :EFTRecord.Alternate_Amount__c)				 
                                     + '\n' +'Effective Date:' + EFTRecord.Effective_Date__c
                                     + '\n' +'Frequency:' + EFTRecord.Frequency__c
                                     + '\n' +'Day of Month:' + EFTRecord.Day_of_Month__c;
				insert cs;
        		id caseId = cs.id;
        		
        		EFTRecord.Case__c = caseId;
        		update EFTRecord;
        		
        		
        		
        		EFT__c ResultEFTRecord = [select id, name, Member_Account__c, Stage__c, Action_Type__c, Share_Loan_Id__c, Type__c	,Share_Loan_Type__c, Share_Loan_Description__c,
                                      Routing_Number__c, Bank_Name__c, Account_Number__c, Alternate_Amount__c,Effective_Date__c,EFT_ID_Type__c,EftLocator__c,
                                      Frequency__c, Payment_Amount__c, Day_of_Month__c,Second_Day_of_Month__c, Member_Account__r.name, Case__c, Case__r.CaseNumber, Case__r.Status	, Expired__c, Member_Name__c, Docusign_Member_Email__c
                                      from EFT__c where id =: EFTRecord.id limit 1];
                                      
                List<EFT__c> EFTToSendACHDoc = new List<EFT__c>();
                EFTToSendACHDoc.add(ResultEFTRecord);                      
              	//sendACHDocument(EFTToSendACHDoc);
        		
        		system.debug('Member_Account__r.name==='+ResultEFTRecord.Member_Account__r.name);
        		system.debug('Member_Account__c==='+ResultEFTRecord.Member_Account__c);
        		return ResultEFTRecord;
    }
    
    
     //-------------------------------Send ACH Document-----------------------------------------------//
    @AuraEnabled
    public static void sendACHDocument(EFT__c recordId){
        set<Id> Ids = new Set<Id>();
        Ids.add(recordId.Id);
        EFTToDocuSign.docusignAPIcall(Ids);
           
    }
    
    
     //-------------------------------Getting BankName from Entered Routing No-----------------------------------------------//
    @AuraEnabled
    public static string routingInfo(String RoutingNumber){
      	system.debug('RoutingNumber=='+RoutingNumber);
    	String jsonData;  
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
       				}
                    
                }
            }
        
		System.debug('Bank Name:' + BankName);
           	                
        return BankName; 
    }
    
    //-------------------------------Getting Share Accounts from Episys----------------------------------------------//
    @AuraEnabled
    public static Map<string,List<ShareLoanWrapperObject>> getShareLoanAccounts(string recordId){
    		system.debug('recordId=='+recordId);
        	Account_Details__c MemberAccount = [select id,name from Account_Details__c where id=:recordId limit 1];
        	String AccountNumber = MemberAccount.name;
        	List<ShareLoanWrapperObject> resultList = new List<ShareLoanWrapperObject>();
        	Map<string,List<ShareLoanWrapperObject>> resultmap = new Map<string,List<ShareLoanWrapperObject>>();
        	
        	httpRequest requestparam = new httpRequest(); 
        	//requestparam.setTimeout(10); 
	        requestparam.setEndpoint('https://symxapi.chevronfcu.org/devclient/PsAuto/GetShares?AccountNumber=' + AccountNumber + '&userchar2=abc');
	        requestparam.setMethod('GET');   
	        
	        ACH_Loan_Share_Type_Configuration__c cs = ACH_Loan_Share_Type_Configuration__c.getValues('Share');   
	       	string shareTypes= (string)cs.Type__c;
		   	system.debug('shareTypes=='+shareTypes);
			String[] arrShareTypes = shareTypes.split(',');
			 
	       try { 
	        http httpParam = new http();
	        httpResponse response = httpParam.send(requestparam);
	        
	        String strStatus = response.getStatus();
	        String strBody = response.getBody();
        	
         	System.debug('strStatus ....' + strStatus);
        	System.debug('strBody ....' + strBody);
        
        	
        	
        	if(strBody!=''){        
       			List<Object> results = (List<Object>) JSON.deserializeUntyped(response.getBody());      
         		System.debug('Service response is ....' + results);
                
               if(results != null){ 
                 for(Object t : results){
                   			ShareLoanWrapperObject temp = new ShareLoanWrapperObject();
                       		map<string, object> localAcc = (map<string, object>)t;                       		
                       		string accouttype = (string)localAcc.get('AccountType');                       		
                       		string ShareId =  accouttype.split(' ')[1].replace('#','');
       						System.debug('ShareId ....' + ShareId);
	                       if(ShareId != '0' && arrShareTypes.contains(string.valueof(ShareId).substring(0, 2))){//&& ShareId == 2800
	                               temp.ShareLoanID = ShareId; 
	                               temp.ShareLoanIDString = 'S' + ShareId;
	                               temp.Description =   (string)localAcc.get('Description');  
	                               temp.TypeTranslate =  (string)localAcc.get('Description'); 
	                               temp.Type =  'Share'; 
	                               resultList.add(temp);
	                       }
       				}
               }
       				
       				set<string> ShareIds = new set<string>();
                    map<string,string> LoanIdTypeTranslateMap = new map<string,string>();
                    for(ShareLoanWrapperObject obj: resultList){
                        ShareIds.add(obj.ShareLoanID.substring(0, 2).replaceFirst('^0+',''));
                       // system.debug('sdsf'==string.valueof(obj.ShareLoanID).substring(0, 2));                        
                    }
                    system.debug('LoanIds=='+ShareIds);
                    List<EFT_ShareLoan_TypeTranslate__c> listTT = [select name, Code__c, RecType__c, TypeTranslate__c from EFT_ShareLoan_TypeTranslate__c
                                                                  where Code__c in: ShareIds and RecType__c = 'SHAR'];
                    
                   system.debug('listTT=='+listTT);
                    for(EFT_ShareLoan_TypeTranslate__c t:listTT){
                        LoanIdTypeTranslateMap.put(t.Code__c, t.TypeTranslate__c);                        
                    }
                    
                    for(ShareLoanWrapperObject obj: resultList){
                        string typetrans = LoanIdTypeTranslateMap.get(obj.ShareLoanID.substring(0, 2).replaceFirst('^0+',''));
                        obj.TypeTranslate = typetrans;
                        System.debug('typetrans ....' + typetrans);
                    }
            }
            
            Map<string,List<ShareLoanWrapperObject>> LoanList = getLoanAccounts(AccountNumber);
            if(!LoanList.ContainsKey('Exception')){
            	resultList.addall(LoanList.get('LoanList'));
            	resultmap.put('ShareLoanList',resultList);
            	system.debug('resultList=='+resultList);
            }
            else{
            	resultmap.put('Exception',resultList);
            }            
            
	       }
	       catch(System.CalloutException e){
	       		system.debug('Exception');
	       		 resultmap.put('Exception',resultList);
	       }
            return resultmap;
      
    }
    
    //-------------------------------Getting Loan Accounts from Episys----------------------------------------------//
    public static Map<string,List<ShareLoanWrapperObject>> getLoanAccounts(string AccountNumber){
    		List<ShareLoanWrapperObject> resultList = new List<ShareLoanWrapperObject>();
    		Map<string,List<ShareLoanWrapperObject>> resultmap = new Map<string,List<ShareLoanWrapperObject>>();
    		
    	try{
    		httpRequest requestparam = new httpRequest(); 
    		//requestparam.setTimeout(10); 
	        requestparam.setEndpoint('https://symxapi.chevronfcu.org/devclient/PsAuto/GetLoansSelectFields?AccountNumber=' + AccountNumber);
	        requestparam.setMethod('GET');  
	        
	        ACH_Loan_Share_Type_Configuration__c cs = ACH_Loan_Share_Type_Configuration__c.getValues('Loan');   
	       	string loanTypes= (string)cs.Type__c;		  
			String[] arrLoanTypes = loanTypes.split(',');   
	          
	       
	        http httpParam = new http();
	        httpResponse response = httpParam.send(requestparam);
	        
	        String strStatus = response.getStatus();
	        String strBody = response.getBody();
        	
         	System.debug('strStatus1 ....' + strStatus);
        	System.debug('strBody1 ....' + strBody);
        
        	
        	
        	if(strBody!=''){        
       			List<Object> results = (List<Object>) JSON.deserializeUntyped(response.getBody());      
         		System.debug('Service response is1 ....' + results);
                
              
                if(results.size() > 0){
                	
                   for(Object t : results){
                   			ShareLoanWrapperObject temp = new ShareLoanWrapperObject();
                       		map<string, object> localAcc = (map<string, object>)t;
                       		string LoanId = string.valueof(localAcc.get('LoanId'));
       						System.debug('Service response is ....' + localAcc);
	                       if(LoanId != '0' && arrLoanTypes.contains(string.valueof(LoanId).substring(0, 2))){
	                               temp.ShareLoanID =  LoanId; 
	                               temp.ShareLoanIDString = 'L' + LoanId;
	                               temp.Description =   (string)localAcc.get('Description');  
	                               //temp.TypeTranslate =  (string)localAcc.get('Description'); 
	                               temp.Type =  'Loan'; 
	                               temp.Payment = (decimal)localAcc.get('Payment');
	                               if((string)localAcc.get('DueDate') != '')
	                               temp.EffectiveDate = Date.ValueOf((string)localAcc.get('DueDate'));
	                               temp.Day1 = (integer)localAcc.get('DueDay1');
	                               temp.Day2 = (integer)localAcc.get('DueDay2'); 
	                               resultList.add(temp);  
	                       }
       				}
                    
                    set<string> LoanIds = new set<string>();
                    map<string,string> LoanIdTypeTranslateMap = new map<string,string>();
                    for(ShareLoanWrapperObject obj: resultList){
                        LoanIds.add(string.valueof(obj.ShareLoanID).substring(0, 2));
                       // system.debug('sdsf'==string.valueof(obj.ShareLoanID).substring(0, 2));                        
                    }
                    system.debug('LoanIds=='+LoanIds);
                    List<EFT_ShareLoan_TypeTranslate__c> listTT = [select name, Code__c, RecType__c, TypeTranslate__c from EFT_ShareLoan_TypeTranslate__c
                                                                  where Code__c in: LoanIds and RecType__c = 'LOAN'];
                    
                   system.debug('listTT=='+listTT);
                    for(EFT_ShareLoan_TypeTranslate__c t:listTT){
                        LoanIdTypeTranslateMap.put(t.Code__c, t.TypeTranslate__c);                        
                    }
                    
                    for(ShareLoanWrapperObject obj: resultList){
                        string typetrans = LoanIdTypeTranslateMap.get(string.valueof(obj.ShareLoanID).substring(0, 2));
                        obj.TypeTranslate = typetrans;
                        System.debug('typetrans ....' + typetrans);
                    }
                }
            }
            resultmap.put('LoanList',resultList);
    	}
    	catch(System.CalloutException e){
    		resultmap.put('Exception',resultList);
    	}
            
        return resultmap;
    }
    
    @AuraEnabled
    public static List<EFT__c> getEFTRecordsEpisys(string recordId){
    		system.debug('recordId=='+recordId);
        	Account_Details__c MemberAccount = [select id,name from Account_Details__c where id=:recordId limit 1];
        	String AccountNumber = MemberAccount.name;
        	
        	
        	httpRequest requestparam = new httpRequest(); 
	        requestparam.setEndpoint('https://symxapi.chevronfcu.org/devclient/EFT/GetEftRecords?accountNumber=' + AccountNumber);
	        requestparam.setMethod('GET');  
	        
	         ACH_Loan_Share_Type_Configuration__c cs = ACH_Loan_Share_Type_Configuration__c.getValues('Loan');   
	       	string loanTypes= (string)cs.Type__c;		  
			String[] arrLoanTypes = loanTypes.split(',');    
			
			ACH_Loan_Share_Type_Configuration__c cs1 = ACH_Loan_Share_Type_Configuration__c.getValues('Share');   
	       	string shareTypes= (string)cs1.Type__c; 
	        String[] arrShareTypes = shareTypes.split(','); 
	       
	        http httpParam = new http();
	        httpResponse response = httpParam.send(requestparam);
	        
	        String strStatus = response.getStatus();
	        String strBody = response.getBody();
        	
         	System.debug('strStatus ....' + strStatus);
        	System.debug('strBody ....' + strBody);
        
        	set<string> EFTLocatorsSet = new set<string>();
        	set<string> MemberNumbers = new set<string>();
        	List<EFT__c> EFTList= new List<EFT__c>();
        	if(strBody!=''){        
       			List<Object> results = (List<Object>) JSON.deserializeUntyped(response.getBody());      
         		System.debug('Service response is ....' + results);
                
                 for(Object t : results){
                 	EFTWrapperObject temp = new EFTWrapperObject();
                    map<string, object> localAcc = (map<string, object>)t; 
                    MemberNumbers.add(String.valueOf(localAcc.get('AccountNumber')));  
                 }
                 
                 map<string, string> mapAccountIdName= new map<string, string>();
       				List<account_details__c> MemberAccountsList = [select id, name from account_details__c where name in: MemberNumbers and RecType__c = 'ACCT'];
       				if(MemberAccountsList.size() > 0){
       					for(account_details__c s: MemberAccountsList){
       						mapAccountIdName.put(s.Name, s.Id);
       					}
       				}
                
                 for(Object t : results){
                     
                      map<string, object> localAcc = (map<string, object>)t;
                      // System.debug('localAcc ....' + localAcc.get('Id'));
                       string lsId = '';
                       if(localAcc.get('Id') != null && localAcc.get('Id') != ''){
                       		lsId = String.valueOf(localAcc.get('Id')).substring(0, 2);
                       }
                      if(arrShareTypes.contains(lsId) || arrLoanTypes.contains(lsId)){
                   			EFTWrapperObject temp = new EFTWrapperObject();                       		   
                       		EFT__c objEFT = new EFT__c();
                       		objEFT.Routing_Number__c = String.valueOf(localAcc.get('Payee')); 
                       		objEFT.Account_Number__c = String.valueOf(localAcc.get('Reference'));
                       		//system.debug('Account_Number__c=='+objEFT.Account_Number__c);
                       		objEFT.Payment_Amount__c = Decimal.valueOf(String.valueOf(localAcc.get('Amount')));
                       		if(String.valueOf(localAcc.get('EffectiveDate')) != '' && String.valueOf(localAcc.get('EffectiveDate')) != null)
                       		objEFT.Effective_Date__c = Date.valueOf(String.valueOf(localAcc.get('EffectiveDate')));
                       		if(String.valueOf(localAcc.get('Frequency')) == '5')
                       			objEFT.Frequency__c = 'Semi-Monthly';
                       		else
                       			objEFT.Frequency__c = 'Monthly';
                       		objEFT.Day_of_Month__c = String.valueOf(localAcc.get('Day1'));                       		
                       		objEFT.Second_Day_of_Month__c = String.valueOf(localAcc.get('Day2'));
                       		objEFT.Bank_Name__c = String.valueOf(localAcc.get('FinancialInstitution'));
                       		objEFT.Share_Loan_Id__c = String.valueOf(localAcc.get('Id'));
                       		//system.debug('EftLocator__c=='+String.valueOf(localAcc.get('EftLocator')));
                       		
                       		objEFT.EftLocator__c = String.valueOf(localAcc.get('EftLocator'));
                       		//objEFT.Member_Account__c = 'a0Of100000GF8xOEAT';
                       		if(String.valueOf(localAcc.get('AmountCode')) == '37')                       		
                       			objEFT.Type__c = 'Savings'; 
                       		else
                       		    objEFT.Type__c = 'Checking';  
                       		if(String.valueOf(localAcc.get('ExpirationDate')) != null && String.valueOf(localAcc.get('ExpirationDate')) != ''){
                       			Date expDate = Date.valueOf(String.valueOf(localAcc.get('ExpirationDate')));
                       			//if(expDate <= Date.today())
                       				objEFT.expired__c = true;
                       		}     
                       		system.debug('EXPDATE=='+String.valueOf(localAcc.get('ExpirationDate'))) ;      		
                       		//objEFT.EftLocator__c = String.valueOf(localAcc.get('EftLocator__c'));    
                       		objEFT.Member_Account__r = new account_details__c(id =mapAccountIdName.get(String.valueOf(localAcc.get('AccountNumber'))), Name = String.valueOf(localAcc.get('AccountNumber')));//mapAccountIdName.get(String.valueOf(localAcc.get('AccountNumber')));  
                       		//system.debug('Member_Account__r=='+objEFT.Member_Account__r.Name);
                       		List<EFT__c> SFEFT = [Select id from EFT__c where Member_Account__r.Name =:  objEFT.Member_Account__r.Name 
                       						and EftLocator__c =: String.valueOf(localAcc.get('EftLocator')) limit 1] ;
                       		
                       		if(SFEFT.size() > 0){
                       			objEFT.id = SFEFT[0].id;
                       		}
                       		
                       		EFTList.add(objEFT);
                 }
       		}
       				
       				
       			
            }
            
            //System.debug('EFTLocatorsSet ....' + EFTLocatorsSet);
           /* List<EFT__c> EFTList = [select id, name,EFT_ID_Type__c, Member_Account__c, Stage__c, Action_Type__c, Share_Loan_Id__c, Type__c	,Share_Loan_Type__c, 	
                                    Share_Loan_Description__c, Routing_Number__c, Bank_Name__c, Account_Number__c, Alternate_Amount__c,Effective_Date__c,
                                      Frequency__c, Payment_Amount__c, Day_of_Month__c, Member_Account__r.name, Case__c, Case__r.CaseNumber, expired__C
                                      from EFT__c where Member_Account__c =: recordId and EftLocator__c in: EFTLocatorsSet];*/
            
            return EFTList;       
    }
    
    @AuraEnabled
    public static map<string,object> getEpisysEmailAddresses(string recordId){
    		system.debug('recordId=='+recordId);
        	Account_Details__c MemberAccount = [select id,name from Account_Details__c where id=:recordId limit 1];
        	String AccountNumber = MemberAccount.name;
        	set<string> setEmailIds = new set<string>();
        	set<string> setEmailNames = new set<string>();
        	List<EpisysAccountDetailsWrapper> listAccounts = new List<EpisysAccountDetailsWrapper>();
        	List<EpisysAccountDetailsWrapper> listResultAccounts = new List<EpisysAccountDetailsWrapper>();
        	
        	Person_Account__c paPrimary = [SELECT Id,PersonID__c,
                             Account_Number__c, Account_Number__r.RecType__c,TypeTranslate__c, Account_Number__r.Name, PersonID__r.Home_Phone__pc,PersonID__r.Residential_City__pc,PersonID__r.Residential_State__pc, PersonID__r.Residential_Street__pc, PersonID__r.Residential_Zipocde__pc, PersonID__r.Name, PersonID__r.Email_raw__c FROM Person_Account__c 
                             WHERE Account_Number__c =: recordId and TypeTranslate__c  like '%Primary%' limit 1];
        	
        	string primaryName='';
        	if(paPrimary != null){
        		primaryName = paPrimary.PersonID__r.Name.replace(' ','%20');
        	}
        	system.debug('primaryName=='+ primaryName);
        	system.debug('AccountNumber=='+ AccountNumber);
        	httpRequest requestparam = new httpRequest(); 
	        requestparam.setEndpoint('https://symxapi.chevronfcu.org/devclient/AddressChange/GetAddress?accountNumber=' + AccountNumber +'&FullNameStringList=' + primaryName +'&FullName=' + primaryName);
	        requestparam.setMethod('GET');  
	        
	        	       
	        http httpParam = new http();
	        httpResponse response = httpParam.send(requestparam);
	        
	        String strStatus = response.getStatus();
	        String strBody = response.getBody();
        	
         	System.debug('strStatus ....' + strStatus);
        	System.debug('strBody ....' + strBody);
        
        	set<string> EFTLocatorsSet = new set<string>();
        	set<string> MemberNumbers = new set<string>();
        	List<EFT__c> EFTList= new List<EFT__c>();
        	if(strBody!=''){        
       			List<Object> results = (List<Object>) JSON.deserializeUntyped(response.getBody());      
         		System.debug('Service response is ....' + results);
                
                 
                
                 for(Object t : results){
                     
                      map<string, object> localAcc = (map<string, object>)t;
                       System.debug('localAcc ....' + localAcc.get('email'));
                       System.debug('altemail ....' + localAcc.get('altemail'));
                       string emailid = (string)localAcc.get('email');                       
                       if(true){//!setEmailIds.contains(emailid) && emailid!= ''
	                       	setEmailIds.add((string)localAcc.get('email'));
	                       	if(emailid != '')
	                       		setEmailNames.add(emailid+ ',' + (string)localAcc.get('fullname'));
	                       	if((string)localAcc.get('altemail') != '' && (string)localAcc.get('altemail') != null)
	                       	setEmailNames.add((string)localAcc.get('altemail')+ ',' + (string)localAcc.get('fullname'));
	                      // 	setEmailIds.add((string)localAcc.get('altemail'));
	                       	EpisysAccountDetailsWrapper tmp = new EpisysAccountDetailsWrapper();
	                       tmp.EmailId=(string)localAcc.get('email');
	                       tmp.AccountType=(string)localAcc.get('accountTypeName');
	                       tmp.FullName=(string)localAcc.get('fullname');
	                       tmp.AltEmailId = (string)localAcc.get('altemail');
	                       listAccounts.add(tmp);
                       }
                       
                       /*
                       if(emailid != null && emailid != ''){
                       		setEmailIds.add(emailid);
                       }  */       
       			}       			
           }
         system.debug('setEmailNames==' + setEmailNames);  
         for(Integer i=0;i<listAccounts.size();i++){
           		if(setEmailNames.contains(listAccounts[i].EmailId +',' +listAccounts[i].fullname)){
           				  EpisysAccountDetailsWrapper tmp = new EpisysAccountDetailsWrapper();
	                       tmp.EmailId=listAccounts[i].EmailId;
	                       tmp.AccountType=listAccounts[i].AccountType;
	                       tmp.FullName=listAccounts[i].fullname;
	                       listResultAccounts.add(tmp);
           		}
           		if(setEmailNames.contains(listAccounts[i].AltEmailId +',' +listAccounts[i].fullname)){
           				  EpisysAccountDetailsWrapper tmp1 = new EpisysAccountDetailsWrapper();
	                       tmp1.EmailId=listAccounts[i].AltEmailId;
	                       tmp1.AccountType=listAccounts[i].AccountType;
	                       tmp1.FullName=listAccounts[i].fullname;
	                       listResultAccounts.add(tmp1);
           		}
         }
           
           system.debug('listResultAccounts==' + listResultAccounts);
            map<string,object> returnmap = new map<string,object>();
           	returnmap.put('EmailIds',listResultAccounts);
            return returnmap;       
    }
    
     @AuraEnabled //get Account Industry Picklist Values
    public static Map<String, String> getDaysofMonth(){
        Map<String, String> options = new Map<String, String>();
       
        Schema.DescribeFieldResult fieldResult = EFT__c.Day_of_Month__c.getDescribe();       
        List<Schema.PicklistEntry> pList = fieldResult.getPicklistValues();
        for (Schema.PicklistEntry p: pList) {          
            options.put(p.getValue(), p.getLabel());
        }
        return options;
    }

    @AuraEnabled
    public static Id saveSignature(String signatureBody, string EFTId,EFT__c EFTRecord){
        system.debug('EFTRecord.EftLocator__c=='+EFTRecord.EftLocator__c); 
        Attachment a = new Attachment();
        a.ParentId = EFTId; // record id of object.
        a.Body = EncodingUtil.base64Decode(signatureBody);
        a.ContentType = 'image/png';
        a.Name = 'ESignature.png';
        insert a;

        
        saveStageData(EFTRecord); 
        Set<id> ids = new Set<id>();
        ids.add(EFTId);
        if(EFTRecord.EftLocator__c == null)
            EFTToSyimtar.insertEFTs(ids);    
        else
            EFTToSyimtar.UpdateEFT(ids,false);
        return a.Id;
    }

    @RemoteAction
    public static Id saveSignature(String signatureBody, id parentId){
            Attachment a = new Attachment();
            a.ParentId = parentId; // record id of object.
            a.Body = EncodingUtil.base64Decode(signatureBody);
            a.ContentType = 'image/png';
            a.Name = 'ESignature.png';
            insert a;
            return a.Id;
      }
    
      public PageReference attach() {
        Attachment myAttach = new Attachment();
        myAttach.ParentId = ACH.Id;//Id of the object to which the page is attached
        myAttach.name = 'ACH DIRECT PAYMENT AUTHORIZATION.pdf';
        PageReference myPdf = ApexPages.currentPage();//myPdfPage is the name of your pdf page
        myAttach.body = myPdf.getContentAsPdf();
        insert myAttach;
        
        List<Attachment> signatures = new List<Attachment>();
        	signatures = [SELECT Id FROM Attachment Where ParentId=:ACH.Id and Name='ESignature.png' Order by CreatedDate desc OFFSET 1]; 
         	if(signatures.size()>0){
             delete signatures;
         	}
         
            List<Attachment> eSignPdfs = new List<Attachment>();
        	eSignPdfs = [SELECT Id FROM Attachment Where ParentId=:ACH.Id and Name='ACH DIRECT PAYMENT AUTHORIZATION.pdf' Order by CreatedDate desc OFFSET 1]; 
         	if(eSignPdfs.size()>0){
             delete eSignPdfs;
         	}
        
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,'ACH Direct Payment Authorization pdf has been generated successfully.'));  
        
        PageReference pageRef = new PageReference('/' + objParentId);
		pageRef.setRedirect(true);
        return pageRef;
    }
    
     public PageReference Cancel() {
		PageReference pageRef = new PageReference('/' + objParentId);
		pageRef.setRedirect(true);
        return pageRef;
    }
    
    public class ShareLoanWrapperObject
    {
      @AuraEnabled
      public String ShareLoanID {get;set;}
      @AuraEnabled
      public string Description {get;set;}
      @AuraEnabled
      public string TypeTranslate {get;set;}
      @AuraEnabled
      public string Type {get;set;}
      @AuraEnabled
      public string ShareLoanIDString {get;set;}
      @AuraEnabled
      public decimal Payment {get;set;}
      @AuraEnabled
      public Date EffectiveDate {get;set;}
      @AuraEnabled
      public integer Day1 {get;set;}
       @AuraEnabled
      public integer Day2 {get;set;}
    }
    
     public class EFTWrapperObject
    {
      @AuraEnabled
      public Integer EftLocator {get;set;}
      @AuraEnabled
      public string AccountNumber {get;set;}
      @AuraEnabled
      public string AmountCode {get;set;}
      @AuraEnabled
      public string Amount {get;set;}
        @AuraEnabled
      public string FinancialInstitution {get;set;}
        @AuraEnabled
      public string Payee {get;set;}
        @AuraEnabled
      public string Reference {get;set;}
        @AuraEnabled
      public string EffectiveDate {get;set;}
         @AuraEnabled
      public string Day1 {get;set;}
         @AuraEnabled
      public string Frequency {get;set;}
         @AuraEnabled
      public string Status {get;set;}
         @AuraEnabled
      public string Error {get;set;}
         @AuraEnabled
      public string ErrorDetails {get;set;}
      @AuraEnabled
      public string ExpirationDate {get;set;}      
      @AuraEnabled
      public string Id {get;set;}
        
    }
    
     public class EpisysAccountDetailsWrapper
    {
      @AuraEnabled
      public string EmailId {get;set;}
      @AuraEnabled
      public string AccountType {get;set;}
      @AuraEnabled
      public string FullName {get;set;}
      @AuraEnabled
      public string AltEmailId {get;set;}
    }

}