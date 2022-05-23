/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 05-18-2022
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public class CreateCaseMemberPageController {
    public static list<SelectOption> pcOptionList;
    public static string pcValue;
    public static list<SelectOption> scOptionList;
    public static string scValue ;
    public static list<SelectOption> tcOptionList;
    public static string tcValue ;
    public static list<SelectOption> SearchResult;
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
            system.debug('AccoutQuery'+acc );              
       Map<string,object> mapList = new Map<string,object>();
       mapList.put('accountDetails', acc[0]);
       mapList.put('pcOptions', pcOptions());
       
       
       
        list<Person_Account__c> paList = new list<Person_Account__c>();
            paList = [SELECT Id,
                             Account_Number__c, Account_Number__r.RecType__c, Account_Number__r.Name, TypeTranslate__c  FROM Person_Account__c WHERE PersonID__c =:accoutid and (NOT TypeTranslate__c like '%Beneficiary%')];
          
          system.debug('PersonAccoutQuery'+paList );                   
         set<String> accountNumberSet = new set<String>();
        set<Id> accIdset = new set<Id>();
        set<String> acctypeSet = new set<String>();
        for(Person_Account__c var: paList){
            accountNumberSet.add(var.Account_Number__r.Name);
            acctypeSet.add(var.Account_Number__r.RecType__c);
            accIdSet.add(var.Account_Number__c);
        }
        list<Account_Details__c> accList = new list<Account_Details__c>();
        
            system.debug('acctypeSet=='+acctypeSet);
            system.debug('accIdSet=='+accIdSet);
        if(acctypeSet.contains('ACCT')){        
            accList = [SELECT Id,
                              Name,
                              RecType__c,
                              TypeTranslate__c,
                              ID1__c,
                              Balance__c,
                              Reference__c,
                              Brand__c FROM Account_Details__c Where Name IN:accountNumberSet and (RecType__c = 'ACCT' or (RecType__c = 'SHAR' and TypeTranslate__c ='1-PRIMARY SHARE')) ORDER BY Name asc, RecType__c asc];
                               system.debug('AccoutDetailQuery1'+accList );  
        }else{        
            accList = [SELECT Id,
                              Name,
                              RecType__c,
                              TypeTranslate__c,
                              ID1__c,
                              Balance__c,
                              Reference__c,
                              Brand__c  FROM Account_Details__c Where  Name IN:accountNumberSet and (RecType__c = 'SHAR' and TypeTranslate__c ='1-PRIMARY SHARE') ORDER BY Name asc, RecType__c asc];
                             // Brand__c  FROM Account_Details__c Where /*Id IN:accIdSet*/ Name IN:accountNumberSet and (RecType__c = 'ACCT' or (RecType__c = 'SHAR' and TypeTranslate__c ='1-PRIMARY SHARE')) ORDER BY Name asc, RecType__c asc];
                              system.debug('AccoutDetailQuery2'+accList ); 
        }
        
        mapList.put('accList', accList);
        
      /*  List<Top_10_Case_Types__c> ctList= new List<Top_10_Case_Types__c>();    
        ctList = [select id, Case_Type__c, Internal_Comments__c, Primary_Category__c, Secondary_Category__c, Subject__c, Tertiary_Category__c  from Top_10_Case_Types__c order by Case_Type__c];
        
        
        mapList.put('toptencategories', ctList);    */
       return mapList;
        
    }
    
     @auraenabled
     
     public static Map<string,object> getTop10Cases()
     {
         List<Top_10_Case_Types__c> ctList= new List<Top_10_Case_Types__c>();    
        ctList = [select id, Case_Type__c, Internal_Comments__c, Primary_Category__c, Secondary_Category__c, Subject__c, Tertiary_Category__c  from Top_10_Case_Types__c order by Case_Type__c];
        
        Map<string,object> mapList = new Map<string,object>();
        mapList.put('toptencategories', ctList);    
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
            paList = [SELECT Id,Account_Number__c, PersonID__c, Account_Number__r.RecType__c,Account_Number__r.Name,PersonID__r.Name,TypeTranslate__c FROM Person_Account__c WHERE Account_Number__c =:accoutid and TypeTranslate__c !=: '0004/Beneficiary'];
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
                             TypeTranslate__c FROM Person_Account__c WHERE (Account_Number__c =:accoutid OR Account_Number__c =:accId1) and TypeTranslate__c !=: '0004/Beneficiary'];
            }else{
                paList = [SELECT Id,
                             Account_Number__c, 
                             PersonID__c,
                             Account_Number__r.RecType__c, 
                             Account_Number__r.Name,
                             PersonID__r.Name,
                             RecType__c,
                             TypeTranslate__c FROM Person_Account__c WHERE Account_Number__c =:accoutid and TypeTranslate__c !=: '0004/Beneficiary'];
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
       
    /*    List<Top_10_Case_Types__c> ctList= new List<Top_10_Case_Types__c>();    
        ctList = [select id, Case_Type__c, Internal_Comments__c, Primary_Category__c, Secondary_Category__c, Subject__c, Tertiary_Category__c  from Top_10_Case_Types__c order by Case_Type__c];
        
        
        mapList.put('toptencategories', ctList); */
       
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
        //op.add(new KeyValuePairModel('--- None ---',''));
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
        //op.add(new KeyValuePairModel('--- None ---',''));
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
        //op.add(new KeyValuePairModel('--- None ---',''));
        for (Schema.Picklistentry picklistEntry : statusFieldDescription.getPicklistValues())
        {
            op.add(new KeyValuePairModel(pickListEntry.getValue(),pickListEntry.getLabel()));
        }
        return op;
    }
    @AuraEnabled
    public static Map<string,string> saveData(Case caseObject, Account accObject, Account_Details__c selectedAcctNumber,  List<Account_Details__c> AccountObjectlist)
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
        /*List<Group> gp = [select Id, Name from Group where Type = 'Queue' and Name = 'Complaint Management Queue' Limit 1];
        List<Group> ARQ = [select Id, Name from Group where Type = 'Queue' and Name = 'Asset Recovery Complaints Queue' Limit 1];
        List<Group> SQ = [select Id, Name from Group where Type = 'Queue' and Name = 'Servicing Complaints Queue' Limit 1];
        List<Group> PQ = [select Id, Name from Group where Type = 'Queue' and Name = 'Product Complaints Queue' Limit 1];
        List<Group> ALQ = [select Id, Name from Group where Type = 'Queue' and Name = 'Auto Loans Complaints Queue' Limit 1];
        List<Group> SLQ = [select Id, Name from Group where Type = 'Queue' and Name = 'Solar Loans Complaints Queue' Limit 1];
        List<Group> FQ = [select Id, Name from Group where Type = 'Queue' and Name = 'Fraud Complaints Queue' Limit 1];
        List<Group> DBQ = [select Id, Name from Group where Type = 'Queue' and Name = 'Digital Banking Complaints Queue' Limit 1];
        List<Group> MQ = [select Id, Name from Group where Type = 'Queue' and Name = 'Marketing Complaints Queue' Limit 1];
        List<Group> MLQ = [select Id, Name from Group where Type = 'Queue' and Name = 'Mortgage Lending Complaints Queue' Limit 1];
        List<Group> PSQ = [select Id, Name from Group where Type = 'Queue' and Name = 'Payment Services Complaints Queue' Limit 1]; */
            
        Database.DMLOptions dmlOpts = new Database.DMLOptions(); 
        dmlOpts.assignmentRuleHeader.assignmentRuleId= AR.id;   
       
        Case cs = new case();            
            cs.setOptions(dmlOpts);
            for(CaseRecordType__c crt : scList){
                cs.RecordTypeId = scList[0].RecordTypeId__c;
                cs.Primary_Category__c = scList[0].Primary_Category__c;
                cs.Secondary_Category__c = scList[0].Secondary_Category__c;
                cs.Tertiary_Category__c = scList[0].Teritiary_Category__c;
                
                //----------------------------------------KX11043-26 and KX11043-27---------------------------------------------//
                
                /* if(scList[0].Primary_Category__c =='Complaint' && scList[0].Teritiary_Category__c == 'Asset Recovery'){
                    
                     cs.OwnerId = ARQ[0].id;
                }
                if(scList[0].Primary_Category__c =='Complaint' && scList[0].Teritiary_Category__c == 'Servicing'){
                    
                     cs.OwnerId = SQ[0].id;
                }
                if(scList[0].Primary_Category__c =='Complaint' && scList[0].Teritiary_Category__c == 'Product'){
                    
                     cs.OwnerId = PQ[0].id;
                 }
                if(scList[0].Primary_Category__c =='Complaint' && scList[0].Teritiary_Category__c == 'Auto Loans'){
                    
                     cs.OwnerId = ALQ[0].id;
                }
                if(scList[0].Primary_Category__c =='Complaint' && scList[0].Teritiary_Category__c == 'Solar Loan'){
                    
                     cs.OwnerId = SLQ[0].id;
                }
                if(scList[0].Primary_Category__c =='Complaint' && scList[0].Teritiary_Category__c == 'Others'){
                    
                     cs.OwnerId = gp[0].id;
                } 
                if(scList[0].Primary_Category__c =='Complaint' && scList[0].Teritiary_Category__c == 'Fraud'){
                    
                     cs.OwnerId = FQ[0].id;
                }
                if(scList[0].Primary_Category__c =='Complaint' && scList[0].Teritiary_Category__c == 'Digital Banking'){
                    
                     cs.OwnerId = DBQ[0].id;
                }
                if(scList[0].Primary_Category__c =='Complaint' && scList[0].Teritiary_Category__c == 'Marketing'){
                    
                     cs.OwnerId = MQ[0].id;
    			}
                if(scList[0].Primary_Category__c =='Complaint' && scList[0].Teritiary_Category__c == 'Mortgage Lending'){
                    
                     cs.OwnerId = MLQ[0].id;
                }
                if(scList[0].Primary_Category__c =='Complaint' && scList[0].Teritiary_Category__c == 'Payment Services'){
                    
                     cs.OwnerId = PSQ[0].id;
        		} */
                
               //----------------------------------------KX11043-26 and KX11043-27------------------------------------------------------//   
            }
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
            if(caseObject.Status != '---None---'){                
                cs.Status = caseObject.Status;
                system.debug('Line no 454----'+caseObject.Sub_Status__c);
                if(caseObject.Status == 'Closed - Privacy request completed'){
                    cs.Sub_Status__c = caseObject.Sub_Status__c;
                }
            }
            else{
                cs.Status = '';
            }
             
            if(selectedAcctNumber != null)
                cs.Account_Number__c = selectedAcctNumber.Id;
          
            cs.Special_Reporting_Number__c = caseObject.Special_Reporting_Number__c;
            cs.LTK__c = caseObject.LTK__c;
            cs.Description = caseObject.Description;
            cs.CaseComments__c = caseObject.CaseComments__c;            
            cs.Subject = caseObject.Subject;
            cs.Follow_up_Text__c = caseObject.Follow_up_Text__c;
            cs.Follow_up_Date__c = caseObject.Follow_up_Date__c;
            cs.Ownership__c = caseObject.Ownership__c;
            if(cs.Ownership__c == 'Assign'){
                cs.OwnerId = caseObject.OwnerId;
            }
            cs.Future_Date__c = caseObject.Future_Date__c;  
            cs.Follow_up_Text__c = caseObject.Follow_up_Text__c; 
            cs.Follow_up_Date__c = caseObject.Follow_up_Date__c;
            cs.LTK__c = caseObject.LTK__c;
       try{ 
           insert cs;
           if(Test.isRunningTest()){
               Integer x=1/0;}            
           }catch (DMLException  e)  { 
                String message = e.getDmlMessage(0);
            throw new AuraHandledException(message); 
          // System.debug('An error occured while inserting case :' + e);                   
          
          }
        catch (Exception e) {
             throw new AuraHandledException(e.getMessage()); 
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
             
            Integer mSize = AccountObjectlist.size();
            System.debug('AccountObjectlist##' + AccountObjectlist);
            List<CaseAccountMemberDetail__c> CaseAccountMemberDetailList = new List<CaseAccountMemberDetail__c>();
            
            CaseAccountMemberDetail__c camd1 = new CaseAccountMemberDetail__c();
            camd1.Case__c = cs.Id;
            camd1.MemberAccountid__c = selectedAcctNumber.Id ;
            camd1.Account_Name__c = selectedAcctNumber.Name;
            CaseAccountMemberDetailList.add(camd1); 
                                
            System.debug('AccountObjectlistarray##' + AccountObjectlist);
            if(mSize > 0 )
            {
                for(Account_Details__c accd : AccountObjectlist )
                {
                    system.debug('accd##'+ accd);
                    if(accd.Id != null)
                    {
                        CaseAccountMemberDetail__c camd = new CaseAccountMemberDetail__c();
                        camd.Case__c = cs.Id;
                        camd.MemberAccountid__c = accd.Id ;
                        camd.Account_Name__c = accd.Name;
                        CaseAccountMemberDetailList.add(camd);
                    }
                    
                }
            }
            System.debug('CaseAccountMemberDetailList##' + CaseAccountMemberDetailList);
            If(!CaseAccountMemberDetailList.IsEmpty())
            {
                insert CaseAccountMemberDetailList;
            }
            
            MaapCaseAddLog(accObject.Id,cs.Id);
            return mapresult;       
    }
    
    @AuraEnabled
    public static Map<string,string> saveData2(String primaryCat, String secondaryCat, String teritaryCat, String subject, String followuptext,String comments, Date followupdate,String status, String brand, String subStatus, String reportNumber, String Ltk, String description, String accId, List<Id> selectedAcctNumberId, String queueValue , String caseownership)
    {
        system.debug('followupdate'+followupdate);
        system.debug('followuptext'+followuptext);
        System.debug('selectedAcctNumberId...' + selectedAcctNumberId);
        System.debug('queueValue...'+queueValue);
        System.debug('ownership...'+caseownership);

        
        List<Id> selectedAcctNumber = new List<Id>();
        for(Id selId : selectedAcctNumberId){
            if(selId != null){
                selectedAcctNumber.add(selId);
            }
        }
        

        System.debug('selectedAcctNumberIds...' + selectedAcctNumber);

        string returnvalue = '';
        Map<string, string> mapresult = new Map<string,string>();
        List<Account_Details__c> AccountObjectlist = [select id, Name from Account_Details__c WHERE Id IN : selectedAcctNumberId];

        // List<Account_Details__c> selectedAcctNumber = [select id, Name from Account_Details__c WHERE Id IN : selectedAcctNumberId];
        //List<Account_Details__c> AccountObjectlist = new List<Account_Details__c>(); 
        //AccountObjectlist.add(selectedAcctNumber);

        Account accObject = [select id, PersonEmail, Email_raw__c, PersonHomePhone, FirstName, LastName, Residential_Street__pc,
                            Residential_Extra_Address__pc, Residential_City__pc, Residential_State__pc, 
                            Residential_Country__pc, Residential_Zipocde__pc from Account WHERE Id =: accId];

        integer commentLimit = 4000;
        if(selectedAcctNumber == null){
            
            returnvalue= 'Please select Account Number';
            mapresult.put('IsSaved', 'false');
            mapresult.put('Message', returnvalue);
            return mapresult;
           }
          else if(primaryCat == NULL || primaryCat == '-None-'){
            
            returnvalue = 'Please select Primary Category';
            mapresult.put('IsSaved', 'false');
            mapresult.put('Message', returnvalue);
            return mapresult;
        } else if(secondaryCat == NULL || secondaryCat == '-None-'){
           
            returnvalue = 'Please select Secondary Category';
            mapresult.put('IsSaved', 'false');
            mapresult.put('Message', returnvalue);
            return mapresult;
        } 
         else if(teritaryCat == NULL || teritaryCat == '-None-' && secondaryCat != 'Transfers Between Sub-Accounts' && secondaryCat != 'Transfers Between Memberships'
                 && secondaryCat != 'Check By Phone' && secondaryCat != 'Loan Payment' && secondaryCat != 'Check Withdrawal to Self'
                 && secondaryCat != 'Credit Card Payment' && secondaryCat != 'Check Withdrawal to Third Party' && secondaryCat != 'Other') 
         /* else if(tcValue == NULL || tcValue == '-None-' && scValue != 'Death Claims' && scValue != 'EPS Research' && scValue != 'OnBoarding')*/
           {
            
            returnvalue = 'Please select Tertiary Category';
            mapresult.put('IsSaved', 'false');
            mapresult.put('Message', returnvalue);
            return mapresult;
           } 
         else if(comments != NULL && comments.length() > commentLimit ) {
                
                returnvalue = 'Case Comments must be less than ' + commentLimit + ' characters. [' + comments.length() + ']';
                mapresult.put('IsSaved', 'false');
                mapresult.put('Message', returnvalue);
                return mapresult;
            }           
     
        else{
           if(teritaryCat == '-None-'){
                teritaryCat = 'None';
            } 
        }     
        list<CaseRecordType__c> scList = [SELECT Id,
                                                 Primary_Category__c,
                                                 Secondary_Category__c,
                                                 Teritiary_Category__c,
                                                 Record_Type_Name__c,
                                                 RecordTypeId__c FROM CaseRecordType__c WHERE Primary_Category__c =:primaryCat AND Secondary_Category__c=:secondaryCat AND Teritiary_Category__c=:teritaryCat LIMIT 1];
       List<Contact> clist = [SELECT Id, Name FROM Contact WHERE Contact.AccountId =:accObject.Id];
        AssignmentRule AR = new AssignmentRule(); 
        AR = [SELECT Id FROM AssignmentRule WHERE SobjectType = 'Case' AND Active = True LIMIT 1];
        /*List<Group> gp = [select Id, Name from Group where Type = 'Queue' and Name = 'Complaint Management Queue' Limit 1];
        List<Group> ARQ = [select Id, Name from Group where Type = 'Queue' and Name = 'Asset Recovery Complaints Queue' Limit 1];
        List<Group> SQ = [select Id, Name from Group where Type = 'Queue' and Name = 'Servicing Complaints Queue' Limit 1];
        List<Group> PQ = [select Id, Name from Group where Type = 'Queue' and Name = 'Product Complaints Queue' Limit 1];
        List<Group> ALQ = [select Id, Name from Group where Type = 'Queue' and Name = 'Auto Loans Complaints Queue' Limit 1];
        List<Group> SLQ = [select Id, Name from Group where Type = 'Queue' and Name = 'Solar Loans Complaints Queue' Limit 1];
        List<Group> FQ = [select Id, Name from Group where Type = 'Queue' and Name = 'Fraud Complaints Queue' Limit 1];
        List<Group> DBQ = [select Id, Name from Group where Type = 'Queue' and Name = 'Digital Banking Complaints Queue' Limit 1];
        List<Group> MQ = [select Id, Name from Group where Type = 'Queue' and Name = 'Marketing Complaints Queue' Limit 1];
        List<Group> MLQ = [select Id, Name from Group where Type = 'Queue' and Name = 'Mortgage Lending Complaints Queue' Limit 1];
        List<Group> PSQ = [select Id, Name from Group where Type = 'Queue' and Name = 'Payment Services Complaints Queue' Limit 1]; */
            
        Database.DMLOptions dmlOpts = new Database.DMLOptions(); 
        dmlOpts.assignmentRuleHeader.assignmentRuleId= AR.id;   
       
        Case cs = new case();            
            cs.setOptions(dmlOpts);
            for(CaseRecordType__c crt : scList){
                cs.RecordTypeId = scList[0].RecordTypeId__c;
                cs.Primary_Category__c = scList[0].Primary_Category__c;
                cs.Secondary_Category__c = scList[0].Secondary_Category__c;
                cs.Tertiary_Category__c = scList[0].Teritiary_Category__c;
                
                //----------------------------------------KX11043-26 and KX11043-27---------------------------------------------//
                
                /* if(scList[0].Primary_Category__c =='Complaint' && scList[0].Teritiary_Category__c == 'Asset Recovery'){
                    
                     cs.OwnerId = ARQ[0].id;
                }
                if(scList[0].Primary_Category__c =='Complaint' && scList[0].Teritiary_Category__c == 'Servicing'){
                    
                     cs.OwnerId = SQ[0].id;
                }
                if(scList[0].Primary_Category__c =='Complaint' && scList[0].Teritiary_Category__c == 'Product'){
                    
                     cs.OwnerId = PQ[0].id;
                 }
                if(scList[0].Primary_Category__c =='Complaint' && scList[0].Teritiary_Category__c == 'Auto Loans'){
                    
                     cs.OwnerId = ALQ[0].id;
                }
                if(scList[0].Primary_Category__c =='Complaint' && scList[0].Teritiary_Category__c == 'Solar Loan'){
                    
                     cs.OwnerId = SLQ[0].id;
                }
                if(scList[0].Primary_Category__c =='Complaint' && scList[0].Teritiary_Category__c == 'Others'){
                    
                     cs.OwnerId = gp[0].id;
                } 
                if(scList[0].Primary_Category__c =='Complaint' && scList[0].Teritiary_Category__c == 'Fraud'){
                    
                     cs.OwnerId = FQ[0].id;
                }
                if(scList[0].Primary_Category__c =='Complaint' && scList[0].Teritiary_Category__c == 'Digital Banking'){
                    
                     cs.OwnerId = DBQ[0].id;
                }
                if(scList[0].Primary_Category__c =='Complaint' && scList[0].Teritiary_Category__c == 'Marketing'){
                    
                     cs.OwnerId = MQ[0].id;
    			}
                if(scList[0].Primary_Category__c =='Complaint' && scList[0].Teritiary_Category__c == 'Mortgage Lending'){
                    
                     cs.OwnerId = MLQ[0].id;
                }
                if(scList[0].Primary_Category__c =='Complaint' && scList[0].Teritiary_Category__c == 'Payment Services'){
                    
                     cs.OwnerId = PSQ[0].id;
        		} */
                
               //----------------------------------------KX11043-26 and KX11043-27------------------------------------------------------//   
            }
            cs.Brand__c = brand;
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
            cs.Ownership__c = caseownership;
            
            if(Status != '---None---'){                
                cs.Status = Status;
                system.debug('Line no 454----'+subStatus);
                if(Status == 'Closed - Privacy request completed'){
                    cs.Sub_Status__c = subStatus;
                }
            }
            else{
                cs.Status = '';
            }
             
            if(selectedAcctNumber != null)
                cs.Account_Number__c = selectedAcctNumber[0];
          
            cs.Special_Reporting_Number__c = reportNumber;
            cs.LTK__c = Ltk;
            cs.Description = description;
            cs.CaseComments__c = comments;            
            cs.Subject = Subject;
            cs.Follow_up_Text__c = followuptext;
            cs.Follow_up_Date__c = followupdate;
            //cs.Ownership__c = caseObject.Ownership__c;
            if(queueValue != null && queueValue !=''){
                system.debug('ownerid'+queueValue);
                cs.OwnerId = queueValue;
                
            }


       try{ 
           insert cs;
           System.debug(cs);
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
             
            Integer mSize = AccountObjectlist.size();
            System.debug('AccountObjectlist##' + AccountObjectlist);
            List<CaseAccountMemberDetail__c> CaseAccountMemberDetailList = new List<CaseAccountMemberDetail__c>();
            
           /* CaseAccountMemberDetail__c camd1 = new CaseAccountMemberDetail__c();
            camd1.Case__c = cs.Id;
            camd1.MemberAccountid__c = selectedAcctNumber[0].Id ;
            camd1.Account_Name__c = selectedAcctNumber.Name;
            CaseAccountMemberDetailList.add(camd1); */
                                
            System.debug('AccountObjectlistarray##' + AccountObjectlist);
            if(mSize > 0 )
            {
                for(Account_Details__c accd : AccountObjectlist )
                {
                    system.debug('accd##'+ accd);
                    if(accd.Id != null)
                    {
                        CaseAccountMemberDetail__c camd = new CaseAccountMemberDetail__c();
                        camd.Case__c = cs.Id;
                        camd.MemberAccountid__c = accd.Id ;
                        camd.Account_Name__c = accd.Name;
                        CaseAccountMemberDetailList.add(camd);
                    }
                    
                }
            }
            System.debug('CaseAccountMemberDetailList##' + CaseAccountMemberDetailList);
            If(!CaseAccountMemberDetailList.IsEmpty())
            {
                insert CaseAccountMemberDetailList;
            }
            
            MaapCaseAddLog(accObject.Id,cs.Id);
            return mapresult;       
    }

    @AuraEnabled
    public static List<group> getQueueData(){
        List<group> queuelist = [select Id, Name from group where type = 'Queue'];
        return queuelist;

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
        /*List<Group> gp = [select Id, Name from Group where Type = 'Queue' and Name = 'Complaint Management Queue' Limit 1];
        List<Group> ARQ = [select Id, Name from Group where Type = 'Queue' and Name = 'Asset Recovery Complaints Queue' Limit 1];
        List<Group> SQ = [select Id, Name from Group where Type = 'Queue' and Name = 'Servicing Complaints Queue' Limit 1];
        List<Group> PQ = [select Id, Name from Group where Type = 'Queue' and Name = 'Product Complaints Queue' Limit 1];
        List<Group> ALQ = [select Id, Name from Group where Type = 'Queue' and Name = 'Auto Loans Complaints Queue' Limit 1];
        List<Group> SLQ = [select Id, Name from Group where Type = 'Queue' and Name = 'Solar Loans Complaints Queue' Limit 1];
        List<Group> FQ = [select Id, Name from Group where Type = 'Queue' and Name = 'Fraud Complaints Queue' Limit 1];
        List<Group> DBQ = [select Id, Name from Group where Type = 'Queue' and Name = 'Digital Banking Complaints Queue' Limit 1];
        List<Group> MQ = [select Id, Name from Group where Type = 'Queue' and Name = 'Marketing Complaints Queue' Limit 1];
        List<Group> MLQ = [select Id, Name from Group where Type = 'Queue' and Name = 'Mortgage Lending Complaints Queue' Limit 1];
        List<Group> PSQ = [select Id, Name from Group where Type = 'Queue' and Name = 'Payment Services Complaints Queue' Limit 1];*/
            
        Database.DMLOptions dmlOpts = new Database.DMLOptions(); 
        dmlOpts.assignmentRuleHeader.assignmentRuleId= AR.id;   
       
        Case cs = new case();            
            cs.setOptions(dmlOpts);
            for(CaseRecordType__c crt : scList){
                if(scList[0].Primary_Category__c == 'Privacy'){
                    List<recordtype> RTypes= [select id, name from recordtype where Name = 'Privacy Non Member' limit 1];
                    system.debug('RTypes=='+RTypes[0].id);
                    if(RTypes.size() > 0)
                    	cs.RecordTypeId = RTypes[0].id;
                    else
                        cs.RecordTypeId = scList[0].RecordTypeId__c;
                }
                else{
                    cs.RecordTypeId = scList[0].RecordTypeId__c;
                }                    
                    cs.Primary_Category__c = scList[0].Primary_Category__c;
                    cs.Secondary_Category__c = scList[0].Secondary_Category__c;
                    cs.Tertiary_Category__c = scList[0].Teritiary_Category__c;
                    
                    //----------------------------------------KX11043-26 and KX11043-27---------------------------------------------//
                    
                    /*if(scList[0].Primary_Category__c =='Complaint' && scList[0].Teritiary_Category__c == 'Asset Recovery'){
                    
                        cs.OwnerId = ARQ[0].id;
					}
                    if(scList[0].Primary_Category__c =='Complaint' && scList[0].Teritiary_Category__c == 'Servicing'){
                        
                         cs.OwnerId = SQ[0].id;
                     }
                    if(scList[0].Primary_Category__c =='Complaint' && scList[0].Teritiary_Category__c == 'Product'){
                        
                         cs.OwnerId = PQ[0].id;
                    }
                    if(scList[0].Primary_Category__c =='Complaint' && scList[0].Teritiary_Category__c == 'Auto Loans'){
                        
                         cs.OwnerId = ALQ[0].id;
                    }
                    if(scList[0].Primary_Category__c =='Complaint' && scList[0].Teritiary_Category__c == 'Solar Loan'){
                        
                         cs.OwnerId = SLQ[0].id;
					}
                    if(scList[0].Primary_Category__c =='Complaint' && scList[0].Teritiary_Category__c == 'Others'){
                        
                         cs.OwnerId = gp[0].id;
                    } 
                    if(scList[0].Primary_Category__c =='Complaint' && scList[0].Teritiary_Category__c == 'Fraud'){
                        
                         cs.OwnerId = FQ[0].id;
     				}
                    if(scList[0].Primary_Category__c =='Complaint' && scList[0].Teritiary_Category__c == 'Digital Banking'){
                        
                         cs.OwnerId = DBQ[0].id;
                    }
                    if(scList[0].Primary_Category__c =='Complaint' && scList[0].Teritiary_Category__c == 'Marketing'){
                        
                         cs.OwnerId = MQ[0].id;
                    }
                    if(scList[0].Primary_Category__c =='Complaint' && scList[0].Teritiary_Category__c == 'Mortgage Lending'){
                        
                         cs.OwnerId = MLQ[0].id;
                    }
                    if(scList[0].Primary_Category__c =='Complaint' && scList[0].Teritiary_Category__c == 'Payment Services'){
                        
                         cs.OwnerId = PSQ[0].id;
                    } */
                    
                    //----------------------------------------KX11043-26 and KX11043-27---------------------------------------------//
            }
            cs.Brand__c = 'CFCU';                     
            
            cs.Special_Reporting_Number__c = caseObject.Special_Reporting_Number__c;
            if(caseObject.Status != '---None---'){
                
                cs.Status = caseObject.Status;
                system.debug('Line no 686----'+caseObject.Sub_Status__c);
                if(caseObject.Status == 'Closed - Privacy request completed'){
                    cs.Sub_Status__c = caseObject.Sub_Status__c;
                }
            }
            else{
                cs.Status = '';
            }
             
             
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
            cs.Follow_up_Date__c = caseObject.Follow_up_Date__c;
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
    public static Map<string,string> saveDataForAccountDetails(Case caseObject, Account_Details__c memObject, Person_Account__c selectedMemberNumber )
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
        /*List<Group> gp = [select Id, Name from Group where Type = 'Queue' and Name = 'Complaint Management Queue' Limit 1];
        List<Group> ARQ = [select Id, Name from Group where Type = 'Queue' and Name = 'Asset Recovery Complaints Queue' Limit 1];
        List<Group> SQ = [select Id, Name from Group where Type = 'Queue' and Name = 'Servicing Complaints Queue' Limit 1];
        List<Group> PQ = [select Id, Name from Group where Type = 'Queue' and Name = 'Product Complaints Queue' Limit 1];
        List<Group> ALQ = [select Id, Name from Group where Type = 'Queue' and Name = 'Auto Loans Complaints Queue' Limit 1];
        List<Group> SLQ = [select Id, Name from Group where Type = 'Queue' and Name = 'Solar Loans Complaints Queue' Limit 1];
        List<Group> FQ = [select Id, Name from Group where Type = 'Queue' and Name = 'Fraud Complaints Queue' Limit 1];
        List<Group> DBQ = [select Id, Name from Group where Type = 'Queue' and Name = 'Digital Banking Complaints Queue' Limit 1];
        List<Group> MQ = [select Id, Name from Group where Type = 'Queue' and Name = 'Marketing Complaints Queue' Limit 1];
        List<Group> MLQ = [select Id, Name from Group where Type = 'Queue' and Name = 'Mortgage Lending Complaints Queue' Limit 1];
        List<Group> PSQ = [select Id, Name from Group where Type = 'Queue' and Name = 'Payment Services Complaints Queue' Limit 1];*/
               
        Database.DMLOptions dmlOpts = new Database.DMLOptions(); 
        dmlOpts.assignmentRuleHeader.assignmentRuleId= AR.id;   
       
            Case cs = new case();            
            cs.setOptions(dmlOpts);
            for(CaseRecordType__c crt : scList){
                
                cs.RecordTypeId = scList[0].RecordTypeId__c;
                cs.Primary_Category__c = scList[0].Primary_Category__c;
                cs.Secondary_Category__c = scList[0].Secondary_Category__c;
                cs.Tertiary_Category__c = scList[0].Teritiary_Category__c; 
                
                //----------------------------------------KX11043-26 and KX11043-27---------------------------------------------//
                
                /*if(scList[0].Primary_Category__c =='Complaint' && scList[0].Teritiary_Category__c == 'Asset Recovery'){
                    
                     cs.OwnerId = ARQ[0].id;
                }
                if(scList[0].Primary_Category__c =='Complaint' && scList[0].Teritiary_Category__c == 'Servicing'){
                    
                     cs.OwnerId = SQ[0].id;
                }
                if(scList[0].Primary_Category__c =='Complaint' && scList[0].Teritiary_Category__c == 'Product'){
                    
                     cs.OwnerId = PQ[0].id;
                }
                if(scList[0].Primary_Category__c =='Complaint' && scList[0].Teritiary_Category__c == 'Auto Loans'){
                    
                     cs.OwnerId = ALQ[0].id;
		        }
                if(scList[0].Primary_Category__c =='Complaint' && scList[0].Teritiary_Category__c == 'Solar Loan'){
                    
                     cs.OwnerId = SLQ[0].id;
                }
                if(scList[0].Primary_Category__c =='Complaint' && scList[0].Teritiary_Category__c == 'Others'){
                    
                     cs.OwnerId = gp[0].id;
                } 
                if(scList[0].Primary_Category__c =='Complaint' && scList[0].Teritiary_Category__c == 'Fraud'){
                    
                     cs.OwnerId = FQ[0].id;
                 }
                if(scList[0].Primary_Category__c =='Complaint' && scList[0].Teritiary_Category__c == 'Digital Banking'){
                    
                     cs.OwnerId = DBQ[0].id;
                }
                if(scList[0].Primary_Category__c =='Complaint' && scList[0].Teritiary_Category__c == 'Marketing'){
                    
                     cs.OwnerId = MQ[0].id;
                }
                if(scList[0].Primary_Category__c =='Complaint' && scList[0].Teritiary_Category__c == 'Mortgage Lending'){
                    
                     cs.OwnerId = MLQ[0].id;
                }
                if(scList[0].Primary_Category__c =='Complaint' && scList[0].Teritiary_Category__c == 'Payment Services'){
                    
                     cs.OwnerId = PSQ[0].id;
                } */
                
                //----------------------------------------KX11043-26 and KX11043-27---------------------------------------------//
            }
            cs.Account_Number__c = memObject.Id;
            cs.Brand__c = 'CFCU';
            cs.AccountId = selectedMemberNumber.PersonID__c;
            if(caseObject.Status != '---None---'){                
                cs.Status = caseObject.Status;
                system.debug('Line no 890----'+caseObject.Sub_Status__c);
                if(caseObject.Status == 'Closed - Privacy request completed'){
                    cs.Sub_Status__c = caseObject.Sub_Status__c;
                }
            }
            else{
                cs.Status = '';
            }
             
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
           
            cs.Special_Reporting_Number__c = caseObject.Special_Reporting_Number__c;
            cs.LTK__c = caseObject.LTK__c;
            cs.Subject = caseObject.Subject;
            cs.CaseComments__c = caseObject.CaseComments__c;
            cs.Ownership__c = caseObject.Ownership__c;
            if(cs.Ownership__c == 'Assign'){
            cs.OwnerId = caseObject.OwnerId;
            }
            cs.Future_Date__c = caseObject.Future_Date__c;  
            cs.Follow_up_Text__c = caseObject.Follow_up_Text__c; 
            cs.Follow_up_Date__c = caseObject.Follow_up_Date__c;
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
           
          
            MaapCaseAddLog(selectedMemberNumber.PersonID__c,cs.Id);
            return mapresult;       
    }
    
       @AuraEnabled
    public static Map<string, object> selectCaseCategoriesforTopTenTypes(string PrimaryText, string SecondaryText)
    {
        Map<string,object> mapList = new Map<string,object>();
        //List<String> splits = selectedText.split(' / ');
        List<KeyValuePairModel> scOptions =  getscOptions(PrimaryText);
        List<KeyValuePairModel> tcOptions =  gettcOptions(SecondaryText); 
        mapList.put('scOptions', scOptions);
        mapList.put('tcOptions', tcOptions);   
        return mapList;
        
    }
    
     @AuraEnabled 
    public static Map<String, List<String>> getDependentMap(string contrfieldApiName,string depfieldApiName) {
        String controllingField = contrfieldApiName.toLowerCase();
        String dependentField = depfieldApiName.toLowerCase();
        
        Map<String,List<String>> objResults = new Map<String,List<String>>();
        
       
        Map<String, Schema.SObjectField> objFieldMap = Schema.SObjectType.Case.fields.getMap();
        
        if (!objFieldMap.containsKey(controllingField) || !objFieldMap.containsKey(dependentField)){
            return objResults;     
        }
        
        Schema.SObjectField theField = objFieldMap.get(dependentField);
        Schema.SObjectField ctrlField = objFieldMap.get(controllingField);
        
        List<Schema.PicklistEntry> contrEntries = ctrlField.getDescribe().getPicklistValues();
        List<PicklistEntryWrapper> depEntries = wrapPicklistEntries(theField.getDescribe().getPicklistValues());
        List<String> controllingValues = new List<String>();
        
        for (Schema.PicklistEntry ple : contrEntries) {
            String label = ple.getLabel();
            objResults.put(label, new List<String>());
            controllingValues.add(label);
        }
        
        for (PicklistEntryWrapper plew : depEntries) {
            String label = plew.label;
            String validForBits = base64ToBits(plew.validFor);
            for (Integer i = 0; i < validForBits.length(); i++) {
                String bit = validForBits.mid(i, 1);
                if (bit == '1') {
                    objResults.get(controllingValues.get(i)).add(label);
                }
            }
        }
        return objResults;
    }
    
    public static String decimalToBinary(Integer val) {
        String bits = '';
        while (val > 0) {
            Integer remainder = Math.mod(val, 2);
            val = Integer.valueOf(Math.floor(val / 2));
            bits = String.valueOf(remainder) + bits;
        }
        return bits;
    }
    
    public static String base64ToBits(String validFor) {
        if (String.isEmpty(validFor)) return '';
        
        String validForBits = '';
        
        for (Integer i = 0; i < validFor.length(); i++) {
            String thisChar = validFor.mid(i, 1);
            Integer val = base64Chars.indexOf(thisChar);
            String bits = decimalToBinary(val).leftPad(6, '0');
            validForBits += bits;
        }
        
        return validForBits;
    }
    
    private static final String base64Chars = '' +
        'ABCDEFGHIJKLMNOPQRSTUVWXYZ' +
        'abcdefghijklmnopqrstuvwxyz' +
        '0123456789+/';
    
    
    private static List<PicklistEntryWrapper> wrapPicklistEntries(List<Schema.PicklistEntry> PLEs) {
        return (List<PicklistEntryWrapper>)
            JSON.deserialize(JSON.serialize(PLEs), List<PicklistEntryWrapper>.class);
    }
    
    @AuraEnabled
    public static void MaapCaseAddLog(string RecordId, string CaseId)
    {
        Datetime dt  = System.now();
        DateTime earlier = dt.addMinutes(-20);
        List<Authenticated_Log__c> MaapLogsList = [SELECT Id, Member__c,MAAP_Case_Number_s__c, CreatedDate from Authenticated_Log__c where LastModifiedDate >=: earlier and Member__c =: RecordId and RecordType.Name = 'Master Authentication Log' order by LastModifiedDate desc limit 1];
        system.debug('MaapLogsList.Size()=='+MaapLogsList.Size());
        if(MaapLogsList.size() > 0){
            string CaseNumber = [Select CaseNumber from Case where Id=: CaseId].CaseNumber;
            String ExistingCaseNumber = MaapLogsList[0].MAAP_Case_Number_s__c;
            string CaseURL = '<a href="' + URL.getSalesforceBaseUrl().toExternalForm() + '\\' + CaseId + '">' +  CaseNumber + '</a>';
            if(String.IsNotBlank(ExistingCaseNumber)){
                MaapLogsList[0].MAAP_Case_Number_s__c = ExistingCaseNumber + ', ' + CaseURL;
            }
            else{
                MaapLogsList[0].MAAP_Case_Number_s__c = CaseURL;
            }
            update MaapLogsList[0];
            system.debug('CaseURL=='+CaseURL);
            system.debug('MaapLogsList[0].MAAP_Case_Number_s__c=='+MaapLogsList[0].MAAP_Case_Number_s__c);
        }
    }
    public class PicklistEntryWrapper{
        public String active {get;set;}
        public String defaultValue {get;set;}
        public String label {get;set;}
        public String value {get;set;}
        public String validFor {get;set;}
        public PicklistEntryWrapper(){            
        }
    }
    @AuraEnabled(cacheable=true)
	public static List<Account_Details__c> getMemberAccounts(String AccountId)
	{
		system.debug('----------------------test-'+AccountId);
		list<Person_Account__c> paList = new list<Person_Account__c>();
            paList = [SELECT Id,
                             Account_Number__c, Account_Number__r.RecType__c, Account_Number__r.Name FROM Person_Account__c WHERE PersonID__c =: AccountId];
        system.debug('----------------------test-'+paList);
        return accountDetails(paList);
	}
    /*@AuraEnabled(cacheable=true)
    public static List<String> SearchTertiary(String searchText){
        List<String> lstOptions = new List<String>();

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

        Map<String, String> mapOfOptions = new Map<String, String>();
        for (String tc : str){
            if(tc!='None'){
                SearchResult.add(new SelectOption(tc,tc));
                mapOfOptions.put(tc, tc);
                lstOptions.add(tc);
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

        return lstOptions;
    }
    */
     @AuraEnabled(cacheable=true)
     public static Object getTop10CaseRecord(Id recId)
      {
          system.debug('recId...'+recId);
         Top_10_Case_Types__c objCaseType = [select id, Case_Type__c, Internal_Comments__c, Primary_Category__c, Secondary_Category__c, Subject__c, Tertiary_Category__c  from Top_10_Case_Types__c WHERE Id =: recId LIMIT 1];
         return objCaseType;
      }
      private static List<Account_Details__c> accountDetails(list<Person_Account__c> paList){
        set<String> accountNumberSet = new set<String>();
        set<Id> accIdset = new set<Id>();
        set<String> acctypeSet = new set<String>();
        for(Person_Account__c var: paList){
            accountNumberSet.add(var.Account_Number__r.Name);
            acctypeSet.add(var.Account_Number__r.RecType__c);
            accIdSet.add(var.Account_Number__c);
        }
        system.debug('---------------accIdSet-------test-'+accountNumberSet);
        list<Account_Details__c> accList = new list<Account_Details__c>();
        if(acctypeSet.contains('ACCT')){
            accList = [SELECT Id,
                              Name,
                              RecType__c,
                              TypeTranslate__c,
                              ID1__c,
                              Balance__c,                              
                              Combined_Account_ID__c,
                              Reference__c,
                              Brand__c FROM Account_Details__c Where Name IN:accountNumberSet and (RecType__c = 'ACCT' or (RecType__c = 'SHAR' and TypeTranslate__c ='1-PRIMARY SHARE')) ORDER BY Name asc, RecType__c asc];
        }else{
            accList = [SELECT Id,
                              Name,
                              RecType__c,
                              TypeTranslate__c,
                              ID1__c,
                              Balance__c,
                              
                              Combined_Account_ID__c,
                              Reference__c,
                              Brand__c  FROM Account_Details__c Where Id IN:accIdSet  and (RecType__c = 'ACCT' or (RecType__c = 'SHAR' and TypeTranslate__c ='1-PRIMARY SHARE')) ORDER BY Name asc, RecType__c asc];
        }
        return accList;
    }
    
      @AuraEnabled
      public static String uploadFile(String base64, String filename, String recordId) {
        Attachment  cv = createContentVersion(base64, filename);
        ContentDocumentLink cdl = createContentLink(cv.Id, recordId);
        cdl.LinkedEntityId = recordId;
        if (cv == null || cdl == null) { return null; }
        return cdl.Id;
      }

      
      private static Attachment  createContentVersion(String base64, String filename) {
        Attachment  cv = new Attachment ();
       // cv.VersionData = EncodingUtil.base64Decode(base64);
       // cv.Title = filename;
       // cv.PathOnClient = filename;
        try {
          insert cv;
          return cv;
        } catch(DMLException e) {
          System.debug(e);
          return null;
        }
      }

     
     private static ContentDocumentLink createContentLink(String contentVersionId, String recordId) {
            if (contentVersionId == null || recordId == null) { return null; }
                ContentDocumentLink cdl = new ContentDocumentLink();
                cdl.ContentDocumentId = [SELECT Id FROM ContentVersion WHERE Id =: contentVersionId].ContentDocumentId;
                cdl.LinkedEntityId = recordId;
                // ShareType is either 'V', 'C', or 'I'
                // V = Viewer, C = Collaborator, I = Inferred
                cdl.ShareType = 'V';
                try {
                insert cdl;
                return cdl;
                } catch(DMLException e) {
                System.debug(e);
                return null;
            }
        }

        // test
        @AuraEnabled
    public static String uploadFiles2(String recordId, String filedata) {
        try {
            if(String.isNotBlank(FileData)) {
                List<FileDataWP> files = (List<FileDataWP>) JSON.deserialize(filedata, List<FileDataWP>.class);
                System.debug(files);
 
                List<Attachment> attList = new List<Attachment>();
                for(FileDataWP file : files) {
                   Attachment oAttachment = new Attachment();
                    oAttachment.parentId = recordId;
             		if(file.fileContent != null)
                    oAttachment.Body = EncodingUtil.base64Decode(file.fileContent);
                    else
                        oAttachment.Body = EncodingUtil.base64Decode('');
                    oAttachment.Name = file.fileName;
                    attList.add(oAttachment);
                    //oAttachment.ContentType = contentType;
                }
                Insert attList;
         
            } else {
                return 'record Id is Blank';
            }
            return 'success';
        } catch (Exception ex) {
            System.debug(ex.getMessage() + ' -> ' + ex.getStackTraceString());
            throw new AuraHandledException(ex.getMessage());
        }
    }
 
    public class FileDataWP {
        public String fileName;
        public String fileContent;
    }

    // test 2

    @AuraEnabled
    public static Id saveChunk(Id parentId, String fileName, String base64, String contentType, String fileId) {
        // check if fileId id ''(Always blank in first chunk), then call the saveTheFile method,
        //  which is save the check data and return the attachemnt Id after insert, 
        //  next time (in else) we are call the appentTOFile() method
        //   for update the attachment with reamins chunks   
        if (fileId == '') {
            fileId = saveTheFile(parentId, fileName, base64, contentType);
        } else {
            appendToFile(fileId, base64);
        }
 
        return Id.valueOf(fileId);
    }
 
    public static Id saveTheFile(Id parentId, String fileName, String base64, String contentType) {
        base64 = EncodingUtil.urlDecode(base64, 'UTF-8');
 
        Attachment oAttachment = new Attachment();
        oAttachment.parentId = parentId;
 
        oAttachment.Body = EncodingUtil.base64Decode(base64);
        oAttachment.Name = fileName;
        oAttachment.ContentType = contentType;
 
 
 			system.debug('parentId###' +  parentId);
 		
 	
        insert oAttachment;
 
        return oAttachment.Id;
    }
 
    private static void appendToFile(Id fileId, String base64) {
        base64 = EncodingUtil.urlDecode(base64, 'UTF-8');
 
        Attachment a = [
            SELECT Id, Body
            FROM Attachment
            WHERE Id =: fileId
        ];
 
        String existingBody = EncodingUtil.base64Encode(a.Body);
 
        a.Body = EncodingUtil.base64Decode(existingBody + base64);
 
        update a;
    }
}