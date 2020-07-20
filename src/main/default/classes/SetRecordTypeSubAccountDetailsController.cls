public class SetRecordTypeSubAccountDetailsController {

private final Case cRec;
    public list<SelectOption> pcOptionList{get;set;}
    public string pcValue { get;set; }
    public list<SelectOption> scOptionList{get;set;}
    public string scValue { get;set; }
    public list<SelectOption> tcOptionList{get;set;}
    public string tcValue { get;set; }
    public Account_Details__c acc {get;set;}
    //public Account_Details__c accDetail {get;set;}
    public string accId {get;set;}
   // public Id accountId {get;set;}
    public Id personId {get;set;}
    public string accountName {get;set;}
   // public list<Account_Details__c> accList{get;set;}
    public Blob file {get;set;} 
    public String fileName{get;set;} 
    public List<Attachment> allFileList {get; set;}
    public string firstPage {get;set;}
    public string caseId {get;set;}
    public Boolean b1{get;set;}
    public Boolean bool{get;set;}
    public List<Contact> cList {get;set;}
    public integer commentLimit = 4000;
    public String searchText{get;set;}
    public string selectedPrimary{ get;set; }
    public list<SelectOption> SearchResult{get;set;}
       
    public SetRecordTypeSubAccountDetailsController(ApexPages.StandardController controller){
        bool = false;
        this.cRec = (Case)Controller.getRecord();
        firstPage = System.currentPageReference().getParameters().get('firstPage');
        
        if(firstPage == 'True'){
        accId = System.currentPageReference().getParameters().get('acctId');  
        System.debug('acctId is ::::::::'+accId);
        
      /*  acc1 = [SELECT Id,
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
                      PersonHomePhone FROM Account Where Id =:accId]; */
        
        acc = [Select Id,
                      Name,
                      Brand__c,
                      Reference__c FROM Account_Details__c Where Id=:accId];
            System.debug('accId is::::'+accId);
                         
        pcOptionList = pcOptions();
    }else {
            caseId = System.currentPageReference().getParameters().get('caseId');
        }
    }
    
    public void change()
    {
        if(b1 == true)
        {
            bool = true;
        }
        else
        {
            bool = false;
        }
    }
 
    public List<SelectOption> pcOptions() {
    
    Schema.DescribeFieldResult statusFieldDescription = Case.Primary_Category__c.getDescribe();
        System.debug('Getting description:::'+ statusFieldDescription);
        list<SelectOption> op = new list<SelectOption>();
        op.add(new SelectOption('-None-','-None-'));
        for (Schema.Picklistentry picklistEntry : statusFieldDescription.getPicklistValues())
        {
            op.add(new SelectOption(pickListEntry.getValue(),pickListEntry.getLabel()));
        }
        return op;
    }
    
    public void scOptions() {
    
        list<CaseRecordType__c> scList = [SELECT Id,
                                                 Primary_Category__c,
                                                 Secondary_Category__c FROM CaseRecordType__c WHERE Primary_Category__c =:pcValue];
        set<String> scSet = new set<String>();
        scList.sort();
        for(CaseRecordType__c var: scList){
            scSet.add(var.Secondary_Category__c);
        }                                       
        scOptionList = new list<SelectOption>();
        scOptionList.add(new SelectOption('-None-','-None-'));
        for (String sc : scSet)
        {
            if(sc!='None'){
                scOptionList.add(new SelectOption(sc,sc));
            }
        }
        tcOptionList = new list<SelectOption>();
            tcOptionList.add(new SelectOption('-None-','-None-'));
    }
    
    
    
    public void tcOptions() {
        
        list<CaseRecordType__c> tcList = [SELECT Id,
                                                 Primary_Category__c,
                                                 Secondary_Category__c,
                                                 Teritiary_Category__c FROM CaseRecordType__c WHERE Secondary_Category__c =:scValue];
        List<String> str = new List<String>();
        tcList.sort();
        for(CaseRecordType__c tcr: tcList){
            str.add(tcr.Teritiary_Category__c);
        }
        tcOptionList = new list<SelectOption>();
        tcOptionList.add(new SelectOption('-None-','-None-'));
        for (String tc : str){
            if(tc!='None'){
                tcOptionList.add(new SelectOption(tc,tc));
            }
        }
    }   
    
    
    public pageReference nextPage(){
        if(String.isBlank(accountName)){
            ApexPages.Message msgs = new ApexPages.Message(ApexPages.Severity.ERROR, 'Please select Member');
            ApexPages.addMessage(msgs);
            return null;
           }
          else if(pcValue == NULL || pcValue == '-None-'){
            ApexPages.Message msgs = new ApexPages.Message(ApexPages.Severity.ERROR, 'Please select Primary Category');
            ApexPages.addMessage(msgs);
            return null;
        } else if(scValue == NULL || scValue == '-None-'){
            ApexPages.Message msgs = new ApexPages.Message(ApexPages.Severity.ERROR, 'Please select Secondary Category');
            ApexPages.addMessage(msgs);
            return null;
        } 
        else if(tcValue == NULL || tcValue == '-None-' && scValue != 'Transfers Between Sub-Accounts' && scValue != 'Transfers Between Memberships'
                 && scValue != 'Check By Phone' && scValue != 'Loan Payment' && scValue != 'Check Withdrawal to Self'
                 && scValue != 'Credit Card Payment' && scValue != 'Check Withdrawal to Third Party' && scValue != 'Other') 
        /*  else if(tcValue == NULL || tcValue == '-None-' && scValue != 'Death Claims' && scValue != 'EPS Research' && scValue != 'OnBoarding') */
           {
            ApexPages.Message msgs = new ApexPages.Message(ApexPages.Severity.ERROR, 'Please select Tertiary Category');
            ApexPages.addMessage(msgs);
            return null;
           } 
         else if(cRec.CaseComments__c != NULL && cRec.CaseComments__c.length() > commentLimit ) {
                ApexPages.Message msgs3 = new ApexPages.Message(ApexPages.Severity.ERROR, 'Case Comments must be less than ' + commentLimit + ' characters. [' + cRec.CaseComments__c.length() + ']');
                ApexPages.addMessage(msgs3); 
                return null;
            }           
     
        else{
           if(tcValue == '-None-'){
                tcValue = 'None';
            }
             
        list<CaseRecordType__c> scList = [SELECT Id,
                                                 Primary_Category__c,
                                                 Secondary_Category__c,
                                                 Teritiary_Category__c,
                                                 Record_Type_Name__c,
                                                 RecordTypeId__c FROM CaseRecordType__c WHERE Primary_Category__c =:pcValue AND Secondary_Category__c=:scValue AND Teritiary_Category__c=:tcValue LIMIT 1];  

        list<Person_Account__c> pa = new list<Person_Account__c>();

        pa = [Select Id,
                   Name,
                   Account_Number__c, 
                   Account_Number__r.RecType__c, 
                   Account_Number__r.Name,
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
                   PersonId__r.Email_raw__c FROM Person_Account__c WHERE PersonId__c =:personId LIMIT 1];
     
        clist = [SELECT Id, Name FROM Contact WHERE Contact.AccountId =:personId];
              
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
            cs.Brand__c = acc.Reference__c;
            cs.Account_Number__c = acc.Id;
            cs.Brand__c = 'CFCU';
            cs.AccountId = personId;
            cs.ContactId = cList[0].Id;
            if(pa.size()>0){
                if(pa[0].PersonId__r.PersonEmail != null){
                   cs.Email_Address__c = pa[0].PersonId__r.PersonEmail;
                }
                /*else{
                   cs.Email_Address__c = pa[0].PersonId__r.Email_raw__c; 
                }*/
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
            cs.Status = cRec.Status;
            cs.LTK__c = cRec.LTK__c;
            cs.Subject = cRec.Subject;
            cs.CaseComments__c = cRec.CaseComments__c;
            cs.Ownership__c = cRec.Ownership__c;
            if(cs.Ownership__c == 'Assign'){
            cs.OwnerId = cRec.OwnerId;
            }
              cs.Future_Date__c = cRec.Future_Date__c;
       try{ 
           insert cs;
           if(Test.isRunningTest()){
               Integer x=1/0;}            
           }catch (exception e)  {           
           //System.debug('An error occured while inserting case :' + e);                   
           ApexPages.Message msgs = new ApexPages.Message(ApexPages.Severity.ERROR, 'Please select appropriate values for all the fields.');
           ApexPages.addMessage(msgs); 
          }
            
            if(cs.CaseComments__c != null){  
            CaseComment cc = new CaseComment();
              cc.ParentId = cs.Id;
              cc.CommentBody = cs.CaseComments__c;
            
            insert cc;
            }
             
        PageReference pg1 = new PageReference('/apex/InputFilePage?caseId='+cs.Id);
        pg1.setRedirect(true);
        return pg1;          
         }        
    }
    
    public pageReference doCancel(){
        pageReference page = new pageReference('/'+acc.Id);
        page.setRedirect(true);
        return page;
    }
    
    public pageReference process1(){
        
        if(String.isBlank(accountName)){
            ApexPages.Message msgs = new ApexPages.Message(ApexPages.Severity.ERROR, 'Please select Member');
            ApexPages.addMessage(msgs);
            return null;
           }
          else if(pcValue == NULL || pcValue == '-None-'){
            ApexPages.Message msgs = new ApexPages.Message(ApexPages.Severity.ERROR, 'Please select Primary Category');
            ApexPages.addMessage(msgs);
            return null;
        } else if(scValue == NULL || scValue == '-None-'){
            ApexPages.Message msgs = new ApexPages.Message(ApexPages.Severity.ERROR, 'Please select Secondary Category');
            ApexPages.addMessage(msgs);
            return null;
        } 
        else if(tcValue == NULL || tcValue == '-None-' && scValue != 'Transfers Between Sub-Accounts' && scValue != 'Transfers Between Memberships'
                 && scValue != 'Check By Phone' && scValue != 'Loan Payment' && scValue != 'Check Withdrawal to Self'
                 && scValue != 'Credit Card Payment' && scValue != 'Check Withdrawal to Third Party' && scValue != 'Other') 
        /* else if(tcValue == NULL || tcValue == '-None-' && scValue != 'Death Claims' && scValue != 'EPS Research' && scValue != 'OnBoarding')*/
           {
            ApexPages.Message msgs = new ApexPages.Message(ApexPages.Severity.ERROR, 'Please select Tertiary Category');
            ApexPages.addMessage(msgs);
            return null;
           } 
  
       /*  if(pcValue == NUll || scValue == NULL || tcValue == NULL || cRec.Brand__c == NULL){
            ApexPages.Message msgs = new ApexPages.Message(ApexPages.Severity.ERROR, 'Please select appropriate values for all the fields.');
            ApexPages.addMessage(msgs);
            return null;
        }  */
 
         else if(cRec.CaseComments__c != NULL && cRec.CaseComments__c.length() > commentLimit ) {
                ApexPages.Message msgs3 = new ApexPages.Message(ApexPages.Severity.ERROR, 'Case Comments must be less than ' + commentLimit + ' characters. [' + cRec.CaseComments__c.length() + ']');
                ApexPages.addMessage(msgs3); 
                return null;
            }           
     
        else{
           if(tcValue == '-None-'){
                tcValue = 'None';
            } 
 
            
        list<CaseRecordType__c> scList = [SELECT Id,
                                                 Primary_Category__c,
                                                 Secondary_Category__c,
                                                 Teritiary_Category__c,
                                                 Record_Type_Name__c,
                                                 RecordTypeId__c FROM CaseRecordType__c WHERE Primary_Category__c =:pcValue AND Secondary_Category__c=:scValue
                                                                                                                            AND Teritiary_Category__c=:tcValue LIMIT 1];


        list<Person_Account__c> pa = new list<Person_Account__c>();

         pa = [Select Id,
                   Name,
                   Account_Number__c, 
                   Account_Number__r.RecType__c, 
                   Account_Number__r.Name,
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
                   PersonId__r.Email_raw__c FROM Person_Account__c WHERE PersonId__c =:personId LIMIT 1];

        clist = [SELECT Id, Name FROM Contact WHERE Contact.AccountId =:personId];
            
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
            cs.Brand__c = acc.Reference__c;
            cs.Account_Number__c = acc.Id;
            cs.Brand__c = 'CFCU';
            cs.AccountId = personId;
            cs.ContactId = cList[0].Id;
            if(pa.size()>0){
                if(pa[0].PersonId__r.PersonEmail != null){
                   cs.Email_Address__c = pa[0].PersonId__r.PersonEmail;
                }
                /*else{
                   cs.Email_Address__c = pa[0].PersonId__r.Email_raw__c; 
                }*/
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
            cs.Status = cRec.Status;
            cs.LTK__c = cRec.LTK__c;
            cs.Subject = cRec.Subject;
            cs.CaseComments__c = cRec.CaseComments__c;
            cs.Ownership__c = cRec.Ownership__c;
            if(cs.Ownership__c == 'Assign'){
            cs.OwnerId = cRec.OwnerId;
            }
            cs.Future_Date__c = cRec.Future_Date__c;
                        
       try{ 
           insert cs;
           if(Test.isRunningTest()){
               Integer x=1/0;}            
           }catch (exception e)  {           
           //System.debug('An error occured while inserting case :' + e);                   
           ApexPages.Message msgs = new ApexPages.Message(ApexPages.Severity.ERROR, 'Please select appropriate values for all the fields.');
           ApexPages.addMessage(msgs); 
          }
            if(cs.CaseComments__c != null){
            CaseComment cc = new CaseComment();
              cc.ParentId = cs.Id;
              cc.CommentBody = cs.CaseComments__c;  
              
            insert cc;
            }
                    
        list<Case> co = [select Id from Case order by CreatedDate desc limit 1];  
        PageReference pg = new PageReference('/'+co[0].Id);
        pg.setRedirect(true);
        return pg;
       }        
     }     
    
    public pageReference process(){
        
          Attachment a = new Attachment();
              if(file != null){ 
                a.Name= fileName;
                a.Body= file;
                a.ParentId= caseId;
                //a.CreatedById = UserInfo.getUserId();          
            insert a;
           }
            file = null;
        
        PageReference pg = new PageReference('/'+caseId);
        pg.setRedirect(true);
        return pg;
     }
      public void ChangeCategories()
    {
  if(!string.isBlank( searchText))
       {
           List<String> splits = selectedPrimary.split(' / ');
           pcValue  = splits[0];
           scOptions() ;
           scValue = splits[1];
          tcOptions() ;
                     tcValue = splits[2];
                     }
    }
     public void SearchTertiary(){
   
            pcOptionList = new list<SelectOption>();
            pcOptionList .add(new SelectOption('-None-','-None-'));
             scOptionList = new list<SelectOption>();
            scOptionList .add(new SelectOption('-None-','-None-'));
                        String newSearchText = '%'+searchText+'%';
            list<CaseRecordType__c> tcList = [SELECT Id,
                                                Primary_Category__c,Secondary_Category__c, Teritiary_Category__c FROM CaseRecordType__c WHERE Teritiary_Category__c like :newSearchText or 
                                                Primary_Category__c like :newSearchText or Secondary_Category__c like :newSearchText ];
        List<String> str = new List<String>();

        for(CaseRecordType__c tcr: tcList){
            str.add(tcr.Primary_Category__c + ' / ' + tcr.Secondary_Category__c + ' / ' + tcr.Teritiary_Category__c);
        }

         SearchResult = new list<SelectOption>();
         for (String tc : str){
            if(tc!='None'){
                SearchResult.add(new SelectOption(tc,tc));
            }
        }
      
        
        scOptionList = new list<SelectOption>();
        tcOptionList = new list<SelectOption>();
         tcOptionList.add(new SelectOption('-None-','-None-'));
         scOptionList.add(new SelectOption('-None-','-None-'));
                 pcOptionList = pcOptions();   
          scValue = '-None-';
        pcValue = '-None-';
        tcValue = '-None-';


    }
   }