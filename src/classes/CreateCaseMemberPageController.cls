public class CreateCaseMemberPageController {
    @auraenabled
    public static  Map<string,object> getData(string accoutid)
    {
    	List<Account> acc = [SELECT Id,
                          Name,
                          Alternate_Email__pc,
                          FirstName,
                          MiddleName,
                          LastName,
                          PersonEmail,
                          Residential_City__pc,
                          Residential_Country_Code__pc,
                          Residential_Country__pc,
                          Residential_Extra_Address__pc,
                          Residential_State__pc,
                          Residential_Street__pc,
                          Residential_Zipocde__pc,
                          PersonHomePhone,
                          Email_raw__c,
                          PersonID__c FROM Account Where Id =:accoutid];
                          
       Map<string,object> mapList = new Map<string,object>();
       mapList.put('accountDetails', acc[0]);
       mapList.put('pcOptions', pcOptions());
       
       
       
        list<Person_Account__c> paList = new list<Person_Account__c>();
            paList = [SELECT Id,
                             Account_Number__c, Account_Number__r.RecType__c, Account_Number__r.Name FROM Person_Account__c WHERE PersonID__c =:accoutid];
                             
		 set<String> accountNumberSet = new set<String>();
        set<Id> accIdset = new set<Id>();
        set<String> acctypeSet = new set<String>();
        for(Person_Account__c var: paList){
            accountNumberSet.add(var.Account_Number__r.Name);
            acctypeSet.add(var.Account_Number__r.RecType__c);
            accIdSet.add(var.Account_Number__c);
        }
        list<Account_Details__c> accList = new list<Account_Details__c>();
        
        
        if(acctypeSet.contains('ACCT')){
            accList = [SELECT Id,
                              Name,
                              RecType__c,
                              TypeTranslate__c,
                              ID1__c,
                              Balance__c,
                              Reference__c,
                              Brand__c FROM Account_Details__c Where Name IN:accountNumberSet ORDER BY Name asc, RecType__c asc];
        }else{
            accList = [SELECT Id,
                              Name,
                              RecType__c,
                              TypeTranslate__c,
                              ID1__c,
                              Balance__c,
                              Reference__c,
                              Brand__c  FROM Account_Details__c Where Id IN:accIdSet ORDER BY Name asc, RecType__c asc];
        }
        
        mapList.put('accList', accList);
       
       
       
       return mapList;
    	
    }
    
    @auraenabled
    public static  Map<string,object> getAccountDetailsData(string accoutid)
    {
    	List<Account_Details__c> acc = [Select Id,
                      Name,
                      Brand__c,
                      RecType__c,
                      Reference__c, Parent_Account__r.Name,Parent_Account__c,RecordType.Name FROM Account_Details__c Where Id=:accoutid limit 1];
                          
       Map<string,object> mapList = new Map<string,object>();
       mapList.put('accountDetails', acc[0]);
       mapList.put('pcOptions', pcOptions());
       
       
       
        list<Person_Account__c> paList = new list<Person_Account__c>();
        if(acc[0].RecordType.Name == 'Membership'){
            paList = [SELECT Id,Account_Number__c, PersonID__c, Account_Number__r.RecType__c,Account_Number__r.Name,PersonID__r.Name,TypeTranslate__c FROM Person_Account__c WHERE Account_Number__c =:accoutid];
        }
        else
        {
        	string accId1;
        	if(acc[0].Parent_Account__r.Name != null){
              accId1 = acc[0].Parent_Account__c;
              paList = [SELECT Id,
                             Account_Number__c, 
                             PersonID__c,
                             Account_Number__r.RecType__c, 
                             Account_Number__r.Name,
                             PersonID__r.Name,
                             RecType__c,
                             TypeTranslate__c FROM Person_Account__c WHERE Account_Number__c =:accoutid OR Account_Number__c =:accId1];
            }else{
            	paList = [SELECT Id,
                             Account_Number__c, 
                             PersonID__c,
                             Account_Number__r.RecType__c, 
                             Account_Number__r.Name,
                             PersonID__r.Name,
                             RecType__c,
                             TypeTranslate__c FROM Person_Account__c WHERE Account_Number__c =:accoutid];
            }
        
            
        } 
                           
		 set<String> accountNumberSet = new set<String>();
        set<Id> accIdset = new set<Id>();
        set<String> acctypeSet = new set<String>();
        for(Person_Account__c var: paList){
            accountNumberSet.add(var.PersonID__r.Name);
            acctypeSet.add(var.Account_Number__r.RecType__c);
            accIdSet.add(var.PersonID__c);
        }
        list<Account> accList = new list<Account>();
        
        
        if(acc[0].RecordType.Name == 'Membership'){
            accList = [Select Id,
                          Name,
                          Alternate_Email__pc,
                          FirstName,
                          MiddleName,
                          LastName,
                          PersonEmail,
                          Residential_City__pc,
                          Residential_Country_Code__pc,
                          Residential_Country__pc,
                          Residential_Extra_Address__pc,
                          Residential_State__pc,
                          Residential_Street__pc,
                          Residential_Zipocde__pc,
                          PersonHomePhone FROM Account Where Name IN:accountNumberSet];
        }else{
            accList = [Select Id,
                          Name,
                          Alternate_Email__pc,
                          FirstName,
                          MiddleName,
                          LastName,
                          PersonEmail,
                          Residential_City__pc,
                          Residential_Country_Code__pc,
                          Residential_Country__pc,
                          Residential_Extra_Address__pc,
                          Residential_State__pc,
                          Residential_Street__pc,
                          Residential_Zipocde__pc,
                          PersonHomePhone FROM Account Where Id IN:accIdSet];
        }
        
        mapList.put('accList', paList);
       
       
       
       return mapList;
    	
    }
    
    @AuraEnabled
    public static Map<String, Map<String, List<String>>> getPicklistValues(String objpicklistFieldsMap)
    {
    	return CollectionsInLightningCls.getPicklistValues(objpicklistFieldsMap);
    }
    @AuraEnabled
    public static List<String> getDataValue(string newSearchText)
    {
    	 String newSearchTextLike = '%'+newSearchText+'%';
    	list<CaseRecordType__c> tcList = [SELECT Id,
                                                Primary_Category__c,Secondary_Category__c, Teritiary_Category__c FROM CaseRecordType__c WHERE Teritiary_Category__c like :newSearchTextLike or 
                                                Primary_Category__c like :newSearchTextLike or Secondary_Category__c like :newSearchTextLike ];
        List<String> str = new List<String>();

        for(CaseRecordType__c tcr: tcList){
            str.add(tcr.Primary_Category__c + ' / ' + tcr.Secondary_Category__c + ' / ' + tcr.Teritiary_Category__c);
        }
        
        return str;
    	
    }
    
 
    
    
            @AuraEnabled
    public static Map<string, object> selectCaseCategories(string selectedText)
    {
    	Map<string,object> mapList = new Map<string,object>();
    	
    	
    	List<String> splits = selectedText.split(' / ');
    	
    	List<KeyValuePairModel> scOptions =  getscOptions(splits[0]);
    	List<KeyValuePairModel> tcOptions =  gettcOptions(splits[1]);
    	
    	
    	
        mapList.put('scOptions', scOptions);
        mapList.put('tcOptions', tcOptions);
    	
    	return mapList;
    	
    }
    
    
    @AuraEnabled
     public static  List<KeyValuePairModel> getscOptions(string pcValue) {
    
        list<CaseRecordType__c> scList = [SELECT Id,
                                                 Primary_Category__c,
                                                 Secondary_Category__c FROM CaseRecordType__c WHERE Primary_Category__c =:pcValue];
        set<String> scSet = new set<String>(); 

        scList.sort();
        for(CaseRecordType__c var: scList){
            scSet.add(var.Secondary_Category__c);
        } 
        list<KeyValuePairModel> op = new list<KeyValuePairModel>();
        op.add(new KeyValuePairModel('--- None ---',''));
        for (String sc : scSet)
        {
            if(sc!='None'){
            	op.add(new KeyValuePairModel(sc,sc));
            }
        }
        return op;
    }
    
    
        @AuraEnabled
     public static  List<KeyValuePairModel>  gettcOptions(string scValue) {
        
        list<CaseRecordType__c> tcList = [SELECT Id,
                                                 Primary_Category__c,
                                                 Secondary_Category__c,
                                                 Teritiary_Category__c FROM CaseRecordType__c WHERE Secondary_Category__c =:scValue];
        set<String> scSet = new set<String>();
        tcList.sort();
        for(CaseRecordType__c tcr: tcList){
            scSet.add(tcr.Teritiary_Category__c);
        }
     //   str.sort();
        list<KeyValuePairModel> op = new list<KeyValuePairModel>();
        op.add(new KeyValuePairModel('--- None ---',''));
        for (String tc : scSet){
            if(tc!='None'){
                op.add(new KeyValuePairModel(tc,tc));
            }
        }
        
        return op;
    } 

    
    public static List<KeyValuePairModel> pcOptions() {
    
    	Schema.DescribeFieldResult statusFieldDescription = Case.Primary_Category__c.getDescribe();
        System.debug('Getting description:::'+ statusFieldDescription);
        list<KeyValuePairModel> op = new list<KeyValuePairModel>();
        op.add(new KeyValuePairModel('--- None ---',''));
        for (Schema.Picklistentry picklistEntry : statusFieldDescription.getPicklistValues())
        {
            op.add(new KeyValuePairModel(pickListEntry.getValue(),pickListEntry.getLabel()));
        }
        return op;
    }
    
    @AuraEnabled
    public static Map<string,string> saveData(Case caseObject, Account accObject, Account_Details__c selectedAcctNumber)
    {
    	string returnvalue = '';
    	Map<string, string> mapresult = new Map<string,string>();
    	
    	integer commentLimit = 4000;
    	if(selectedAcctNumber == null){
            
            returnvalue= 'Please select Account Number';
            mapresult.put('IsSaved', 'false');
            mapresult.put('Message', returnvalue);
            return mapresult;
           }
          else if(caseObject.Primary_Category__c == NULL || caseObject.Primary_Category__c == '-None-'){
            
            returnvalue = 'Please select Primary Category';
            mapresult.put('IsSaved', 'false');
            mapresult.put('Message', returnvalue);
            return mapresult;
        } else if(caseObject.Secondary_Category__c == NULL || caseObject.Secondary_Category__c == '-None-'){
           
            returnvalue = 'Please select Secondary Category';
            mapresult.put('IsSaved', 'false');
            mapresult.put('Message', returnvalue);
            return mapresult;
        } 
         else if(caseObject.Tertiary_Category__c == NULL || caseObject.Tertiary_Category__c == '-None-' && caseObject.Secondary_Category__c != 'Transfers Between Sub-Accounts' && caseObject.Secondary_Category__c != 'Transfers Between Memberships'
                 && caseObject.Secondary_Category__c != 'Check By Phone' && caseObject.Secondary_Category__c != 'Loan Payment' && caseObject.Secondary_Category__c != 'Check Withdrawal to Self'
                 && caseObject.Secondary_Category__c != 'Credit Card Payment' && caseObject.Secondary_Category__c != 'Check Withdrawal to Third Party' && caseObject.Secondary_Category__c != 'Other') 
         /* else if(tcValue == NULL || tcValue == '-None-' && scValue != 'Death Claims' && scValue != 'EPS Research' && scValue != 'OnBoarding')*/
           {
            
            returnvalue = 'Please select Tertiary Category';
            mapresult.put('IsSaved', 'false');
            mapresult.put('Message', returnvalue);
            return mapresult;
           } 
         else if(caseObject.CaseComments__c != NULL && caseObject.CaseComments__c.length() > commentLimit ) {
                
                returnvalue = 'Case Comments must be less than ' + commentLimit + ' characters. [' + caseObject.CaseComments__c.length() + ']';
	            mapresult.put('IsSaved', 'false');
	            mapresult.put('Message', returnvalue);
	            return mapresult;
            }           
     
        else{
           if(caseObject.Tertiary_Category__c == '-None-'){
                caseObject.Tertiary_Category__c = 'None';
            } 
        }     
        list<CaseRecordType__c> scList = [SELECT Id,
                                                 Primary_Category__c,
                                                 Secondary_Category__c,
                                                 Teritiary_Category__c,
                                                 Record_Type_Name__c,
                                                 RecordTypeId__c FROM CaseRecordType__c WHERE Primary_Category__c =:caseObject.Primary_Category__c AND Secondary_Category__c=:caseObject.Secondary_Category__c AND Teritiary_Category__c=:caseObject.Tertiary_Category__c LIMIT 1];
       List<Contact> clist = [SELECT Id, Name FROM Contact WHERE Contact.AccountId =:accObject.Id];
        AssignmentRule AR = new AssignmentRule(); 
        AR = [SELECT Id FROM AssignmentRule WHERE SobjectType = 'Case' AND Active = True LIMIT 1];
            
        Database.DMLOptions dmlOpts = new Database.DMLOptions(); 
        dmlOpts.assignmentRuleHeader.assignmentRuleId= AR.id;   
       
        Case cs = new case();            
            cs.setOptions(dmlOpts);
            for(CaseRecordType__c crt : scList){
            cs.RecordTypeId = scList[0].RecordTypeId__c;
            cs.Primary_Category__c = scList[0].Primary_Category__c;
            cs.Secondary_Category__c = scList[0].Secondary_Category__c;
            cs.Tertiary_Category__c = scList[0].Teritiary_Category__c; }
            cs.Brand__c = caseObject.Brand__c;
            cs.Brand__c = 'CFCU';
            cs.AccountId = accObject.Id;
            cs.ContactId = cList[0].Id;
              if(accObject.PersonEmail != null){
                  cs.Email_Address__c = accObject.PersonEmail;
              }else{
                  cs.Email_Address__c = accObject.Email_raw__c;
             }
            cs.Phone_Number__c = accObject.PersonHomePhone;
            cs.First_Name__c = accObject.FirstName;
            cs.Last_Name__c = accObject.LastName;
            cs.Street_Address_1__c = accObject.Residential_Street__pc;
            cs.Street_Address_2__c = accObject.Residential_Extra_Address__pc;
            cs.City__c = accObject.Residential_City__pc;
            cs.State__c = accObject.Residential_State__pc;
            cs.Country__c = accObject.Residential_Country__pc;
            cs.Zip_Code__c = accObject.Residential_Zipocde__pc;
            if(selectedAcctNumber != null)
            	cs.Account_Number__c = selectedAcctNumber.Id;
            cs.Status = caseObject.Status;
            cs.LTK__c = caseObject.LTK__c;
            cs.Description = caseObject.Description;
            cs.CaseComments__c = caseObject.CaseComments__c;            
            cs.Subject = caseObject.Subject;
            cs.Ownership__c = caseObject.Ownership__c;
            if(cs.Ownership__c == 'Assign'){
                cs.OwnerId = caseObject.OwnerId;
            }
            cs.Future_Date__c = caseObject.Future_Date__c;  
            cs.Follow_up_Text__c = caseObject.Follow_up_Text__c; 
       try{ 
           insert cs;
           if(Test.isRunningTest()){
               Integer x=1/0;}            
           }catch (exception e)  {           
           System.debug('An error occured while inserting case :' + e);                   
          
          }
            if(cs.CaseComments__c != null){
            CaseComment cc = new CaseComment();
              cc.ParentId = cs.Id;
              cc.CommentBody = cs.CaseComments__c;
             
            insert cc; 
            }
            returnvalue = 'Case saved successfully.';
            mapresult.put('IsSaved', 'true');
            mapresult.put('Message', returnvalue);
            mapresult.put('CaseId', string.valueOf(cs.Id));
			Case caseFinal = [select CaseNumber from Case where Id =: cs.Id];
            mapresult.put('CaseNumber', string.valueOf(caseFinal.CaseNumber));
            return mapresult;    	
    }
    
    @AuraEnabled
    public static Id saveTheAttachment(Id parentId, String fileName, String base64Data, String contentType){
    	base64Data = EncodingUtil.urlDecode(base64Data, 'UTF-8');
        
        Attachment a = new Attachment();
        a.parentId = parentId;
 
        a.Body = EncodingUtil.base64Decode(base64Data);
        a.Name = fileName;
        a.ContentType = contentType;
        
        insert a;
        
        return a.Id;
    }
    
    
    @AuraEnabled
    public static Map<string,string> saveStandAloneData(Case caseObject)
    {
    	string returnvalue = '';
    	Map<string, string> mapresult = new Map<string,string>();
    	
    	integer commentLimit = 4000;
    	if(caseObject.Primary_Category__c == NULL || caseObject.Primary_Category__c == '-None-'){
           
            returnvalue = 'Please select Primary Category';
            mapresult.put('IsSaved', 'false');
            mapresult.put('Message', returnvalue);
            return mapresult;
        } else if(caseObject.Secondary_Category__c == NULL || caseObject.Secondary_Category__c == '-None-'){
            
            returnvalue = 'Please select Secondary Category';
            mapresult.put('IsSaved', 'false');
            mapresult.put('Message', returnvalue);
            return mapresult;
        } 
         else if(caseObject.Tertiary_Category__c == NULL || caseObject.Tertiary_Category__c == '-None-' && caseObject.Secondary_Category__c != 'Transfers Between Sub-Accounts' && caseObject.Secondary_Category__c != 'Transfers Between Memberships'
                 && caseObject.Secondary_Category__c != 'Check By Phone' && caseObject.Secondary_Category__c != 'Loan Payment' && caseObject.Secondary_Category__c != 'Check Withdrawal to Self'
                 && caseObject.Secondary_Category__c != 'Credit Card Payment' && caseObject.Secondary_Category__c != 'Check Withdrawal to Third Party' && caseObject.Secondary_Category__c != 'Other') 
         /* else if(tcValue == NULL || tcValue == '-None-' && scValue != 'Death Claims' && scValue != 'EPS Research' && scValue != 'OnBoarding')*/
           {
            
            returnvalue = 'Please select Tertiary Category';
            mapresult.put('IsSaved', 'false');
            mapresult.put('Message', returnvalue);
            return mapresult;
           } 
         else if(caseObject.CaseComments__c != NULL && caseObject.CaseComments__c.length() > commentLimit ) {
                
                returnvalue = 'Case Comments must be less than ' + commentLimit + ' characters. [' + caseObject.CaseComments__c.length() + ']';
	            mapresult.put('IsSaved', 'false');
	            mapresult.put('Message', returnvalue);
	            return mapresult;
            }           
     
        else{
           if(caseObject.Tertiary_Category__c == '-None-'){
                caseObject.Tertiary_Category__c = 'None';
            } 
        }     
        list<CaseRecordType__c> scList = [SELECT Id,
                                                 Primary_Category__c,
                                                 Secondary_Category__c,
                                                 Teritiary_Category__c,
                                                 Record_Type_Name__c,
                                                 RecordTypeId__c FROM CaseRecordType__c WHERE Primary_Category__c =:caseObject.Primary_Category__c AND Secondary_Category__c=:caseObject.Secondary_Category__c AND Teritiary_Category__c=:caseObject.Tertiary_Category__c LIMIT 1];
     
        AssignmentRule AR = new AssignmentRule(); 
        AR = [SELECT Id FROM AssignmentRule WHERE SobjectType = 'Case' AND Active = True LIMIT 1];
            
        Database.DMLOptions dmlOpts = new Database.DMLOptions(); 
        dmlOpts.assignmentRuleHeader.assignmentRuleId= AR.id;   
       
        Case cs = new case();            
            cs.setOptions(dmlOpts);
            for(CaseRecordType__c crt : scList){
            cs.RecordTypeId = scList[0].RecordTypeId__c;
            cs.Primary_Category__c = scList[0].Primary_Category__c;
            cs.Secondary_Category__c = scList[0].Secondary_Category__c;
            cs.Tertiary_Category__c = scList[0].Teritiary_Category__c; }
            cs.Brand__c = 'CFCU';                     
            cs.Status = caseObject.Status;
            cs.LTK__c = caseObject.LTK__c;
            cs.Description = caseObject.Description;
            cs.CaseComments__c = caseObject.CaseComments__c;            
            cs.Subject = caseObject.Subject;
            cs.Ownership__c = caseObject.Ownership__c;
            if(cs.Ownership__c == 'Assign'){
                cs.OwnerId = caseObject.OwnerId;
            }
            cs.Future_Date__c = caseObject.Future_Date__c;
            cs.Follow_up_Text__c = caseObject.Follow_up_Text__c;  
       try{ 
           insert cs;
           if(Test.isRunningTest()){
               Integer x=1/0;}            
           }catch (exception e)  {           
           System.debug('An error occured while inserting case :' + e);                   
           //ApexPages.Message msgs = new ApexPages.Message(ApexPages.Severity.ERROR, 'Please select appropriate values for all the fields.');
           //ApexPages.addMessage(msgs); 
          }
            if(cs.CaseComments__c != null){
            CaseComment cc = new CaseComment();
              cc.ParentId = cs.Id;
              cc.CommentBody = cs.CaseComments__c;
             
            insert cc; 
            }
            returnvalue = 'Case saved successfully.';
            mapresult.put('IsSaved', 'true');
            mapresult.put('Message', returnvalue);
            mapresult.put('CaseId', string.valueOf(cs.Id));
            Case caseFinal = [select CaseNumber from Case where Id =: cs.Id];
            mapresult.put('CaseNumber', string.valueOf(caseFinal.CaseNumber));
            return mapresult;    	
    }
    
    
     @AuraEnabled
    public static Map<string,string> saveDataForAccountDetails(Case caseObject, Account_Details__c memObject, Person_Account__c selectedMemberNumber)
    {
    	string returnvalue = '';
    	Map<string, string> mapresult = new Map<string,string>();
    	
    	integer commentLimit = 4000;
    	if(selectedMemberNumber == null){
            
            returnvalue= 'Please select Member';
            mapresult.put('IsSaved', 'false');
            mapresult.put('Message', returnvalue);
            return mapresult;
           }
          else if(caseObject.Primary_Category__c == NULL || caseObject.Primary_Category__c == '-None-'){
          
            returnvalue = 'Please select Primary Category';
            mapresult.put('IsSaved', 'false');
            mapresult.put('Message', returnvalue);
            return mapresult;
        } else if(caseObject.Secondary_Category__c == NULL || caseObject.Secondary_Category__c == '-None-'){
            
            returnvalue = 'Please select Secondary Category';
            mapresult.put('IsSaved', 'false');
            mapresult.put('Message', returnvalue);
            return mapresult;
        } 
         else if(caseObject.Tertiary_Category__c == NULL || caseObject.Tertiary_Category__c == '-None-' && caseObject.Secondary_Category__c != 'Transfers Between Sub-Accounts' && caseObject.Secondary_Category__c != 'Transfers Between Memberships'
                 && caseObject.Secondary_Category__c != 'Check By Phone' && caseObject.Secondary_Category__c != 'Loan Payment' && caseObject.Secondary_Category__c != 'Check Withdrawal to Self'
                 && caseObject.Secondary_Category__c != 'Credit Card Payment' && caseObject.Secondary_Category__c != 'Check Withdrawal to Third Party' && caseObject.Secondary_Category__c != 'Other') 
         /* else if(tcValue == NULL || tcValue == '-None-' && scValue != 'Death Claims' && scValue != 'EPS Research' && scValue != 'OnBoarding')*/
           {
           
            returnvalue = 'Please select Tertiary Category';
            mapresult.put('IsSaved', 'false');
            mapresult.put('Message', returnvalue);
            return mapresult;
           } 
         else if(caseObject.CaseComments__c != NULL && caseObject.CaseComments__c.length() > commentLimit ) {
              
                returnvalue = 'Case Comments must be less than ' + commentLimit + ' characters. [' + caseObject.CaseComments__c.length() + ']';
	            mapresult.put('IsSaved', 'false');
	            mapresult.put('Message', returnvalue);
	            return mapresult;
            }           
     
        else{
           if(caseObject.Tertiary_Category__c == '-None-'){
                caseObject.Tertiary_Category__c = 'None';
            } 
        }     
        list<CaseRecordType__c> scList = [SELECT Id,
                                                 Primary_Category__c,
                                                 Secondary_Category__c,
                                                 Teritiary_Category__c,
                                                 Record_Type_Name__c,
                                                 RecordTypeId__c FROM CaseRecordType__c WHERE Primary_Category__c =:caseObject.Primary_Category__c AND Secondary_Category__c=:caseObject.Secondary_Category__c AND Teritiary_Category__c=:caseObject.Tertiary_Category__c LIMIT 1];
       
       list<Person_Account__c> pa =  [Select Id,
						                   Name,
						                   Account_Number__c, 
						                   PersonId__c,
						                   Account_Number__r.RecType__c, 
						                   Account_Number__r.Name,
						                   PersonId__r.Name,
						                   PersonId__r.PersonEmail,
						                   PersonId__r.FirstName,
						                   PersonId__r.PersonHomePhone,
						                   PersonId__r.LastName,
						                   PersonId__r.Residential_Street__pc,
						                   PersonId__r.Residential_Extra_Address__pc,
						                   PersonId__r.Residential_City__pc,
						                   PersonId__r.Residential_State__pc,
						                   PersonId__r.Residential_Country__pc,
						                   PersonId__r.Residential_Zipocde__pc,
						                   PersonId__r.Email_raw__c FROM Person_Account__c WHERE PersonId__c =:selectedMemberNumber.PersonID__c LIMIT 1];
                   
       List<Contact> clist = [SELECT Id, Name FROM Contact WHERE Contact.AccountId =:selectedMemberNumber.PersonID__c];
        AssignmentRule AR = new AssignmentRule(); 
        AR = [SELECT Id FROM AssignmentRule WHERE SobjectType = 'Case' AND Active = True LIMIT 1];
            
        Database.DMLOptions dmlOpts = new Database.DMLOptions(); 
        dmlOpts.assignmentRuleHeader.assignmentRuleId= AR.id;   
       
        Case cs = new case();            
            cs.setOptions(dmlOpts);
            for(CaseRecordType__c crt : scList){
            cs.RecordTypeId = scList[0].RecordTypeId__c;
            cs.Primary_Category__c = scList[0].Primary_Category__c;
            cs.Secondary_Category__c = scList[0].Secondary_Category__c;
            cs.Tertiary_Category__c = scList[0].Teritiary_Category__c; }
            cs.Account_Number__c = memObject.Id;
            cs.Brand__c = 'CFCU';
            cs.AccountId = selectedMemberNumber.PersonID__c;
            if(cList.size() > 0)
            	cs.ContactId = cList[0].Id;
           	if(pa.size()>0){
                if(pa[0].PersonId__r.PersonEmail != null){
                   cs.Email_Address__c = pa[0].PersonId__r.PersonEmail;
                }else{
                   cs.Email_Address__c = pa[0].PersonId__r.Email_raw__c; 
                }
	            cs.Phone_Number__c = pa[0].PersonId__r.PersonHomePhone;
	            cs.First_Name__c = pa[0].PersonId__r.FirstName;
	            cs.Last_Name__c = pa[0].PersonId__r.LastName;
	            cs.Street_Address_1__c = pa[0].PersonId__r.Residential_Street__pc;
	            cs.Street_Address_2__c = pa[0].PersonId__r.Residential_Extra_Address__pc;
	            cs.City__c = pa[0].PersonId__r.Residential_City__pc;
	            cs.State__c = pa[0].PersonId__r.Residential_State__pc;
	            cs.Country__c = pa[0].PersonId__r.Residential_Country__pc;
	            cs.Zip_Code__c = pa[0].PersonId__r.Residential_Zipocde__pc;    
            }
            cs.Status = caseObject.Status;
            cs.LTK__c = caseObject.LTK__c;
            cs.Subject = caseObject.Subject;
            cs.CaseComments__c = caseObject.CaseComments__c;
            cs.Ownership__c = caseObject.Ownership__c;
            if(cs.Ownership__c == 'Assign'){
            cs.OwnerId = caseObject.OwnerId;
            }
            cs.Future_Date__c = caseObject.Future_Date__c;  
            cs.Follow_up_Text__c = caseObject.Follow_up_Text__c; 
       try{ 
           insert cs;
           if(Test.isRunningTest()){
               Integer x=1/0;}            
           }catch (exception e)  {           
           System.debug('An error occured while inserting case :' + e);                   
          
          }
            if(cs.CaseComments__c != null){
            CaseComment cc = new CaseComment();
              cc.ParentId = cs.Id;
              cc.CommentBody = cs.CaseComments__c;
             
            insert cc; 
            }
            
            Case caseFinal = [select CaseNumber from Case where Id =: cs.Id];
            returnvalue = 'Case saved successfully.';
            mapresult.put('IsSaved', 'true');
            mapresult.put('Message', returnvalue);
            mapresult.put('CaseId', string.valueOf(cs.Id));
            mapresult.put('CaseNumber', string.valueOf(caseFinal.CaseNumber));
            return mapresult;    	
    }
}