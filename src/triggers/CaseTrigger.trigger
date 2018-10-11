trigger CaseTrigger on Case (before insert, before update, after insert, after update, before delete) {

    Id loggedInUserId;
    if(Trigger.isBefore && Trigger.isDelete){
      case tempCase = [select id, Subject from case where Subject =: 'This is a test Case to Upload Attachment.' and status ='In Process'];
      system.debug(tempCase);
      for(case c: Trigger.old){
        system.debug('c====' + c);
      
          if(c.id == tempCase.id)
          {          
             c.addError('You can not delete this case');
          }
        
      }
      return;
    }

    if (Trigger.isBefore) {
        if (Trigger.isInsert) {
            
            updateCaseBrandInfo(Trigger.new);
            updateEmailtoSend(Trigger.new);
            updateAccountNumberfromSubject(Trigger.new);
            updateSurveyCase(Trigger.new); 
            updateBranchRegion(Trigger.new);   
        }
        if (Trigger.isUpdate) {
          if(IsOtherThanTaskCountFieldUpdated())
          {
            updateCaseBrandInfo(Trigger.new);
            updateEmailtoSend(Trigger.new);
            updateErrorOnCaseClosing(Trigger.new);
            updateContactName(Trigger.new);
            surveyCaseValidation(Trigger.old);
            updateBranchRegion(Trigger.new); 
           // updateSurveyCase(Trigger.new);         
                                                    
            updateMemberInfo(Trigger.New, Trigger.Old);  
            
            updateownershipLog(Trigger.New);    
           
            
            
               
          }  
        }
        
        if(IsOtherThanTaskCountFieldUpdated())
          {
        // Removed query from for loop so we need to query object once for all cases
          list<CaseRecordType__c> scList = [SELECT Id,
                                                 Primary_Category__c,
                                                 Secondary_Category__c,
                                                 Teritiary_Category__c,
                                                 Record_Type_Name__c,
                                                 RecordTypeId__c, SLA__c
                                            FROM CaseRecordType__c 
                                        /*   WHERE Primary_Category__c =:c_new.Primary_Category__c 
                                             AND Secondary_Category__c=:c_new.Secondary_Category__c 
                                             AND Teritiary_Category__c=:c_new.Tertiary_Category__c 
                                             LIMIT 1*/]; 
        
         for(Case c_new : Trigger.new){   
            if(scList.size()> 0)
             {
                 for(CaseRecordType__c sc : scList)
                 {
                    
                    if(sc.Primary_Category__c == c_new.Primary_Category__c && sc.Secondary_Category__c == c_new.Secondary_Category__c  && sc.Teritiary_Category__c == c_new.Tertiary_Category__c)
                    {
                         c_new.SLA__c =  sc.SLA__c;
                         
                    }
        if(c_new.Primary_Category__c == 'Surveys'){
                            c_new.SLA__c =  40;
                    }
                 }
         }
               
         }
          }
        
        
    }
        
    if(Trigger.isAfter){
        if(Trigger.isInsert){
            
            insertCaseTask(Trigger.new);
            CaseAssign(Trigger.new);
            
        }
        if(Trigger.isUpdate){
        //   surveyCaseValidation(Trigger.old);
        //   updateSurveyCase(Trigger.new);    
             
//            CaseAssign(Trigger.new);
        }  
    }

    
public void updateBranchRegion(List<case> caseList)   { 
    
    set<Id> accDetailIds = new set<Id>();
    list<case> cases = new list<case>();
    List<Account_Details__c> accDetailMap = new List<Account_Details__c>();
    Map<Id,string> accountMemberBranch = new Map<Id,string>();
    
    for(Case c: caseList){  
        if(c.Account_Number__c != null)
        {
            accDetailIds.add(c.Account_Number__c);      
            cases.add(c);   
        }
    }
    
    if(accDetailIds.size() > 0){
        
        accDetailMap = [select id,RecType__c,Current_Branch1__c,Current_Branch__c from Account_Details__c where ID in : accDetailIds];
        
        for(Account_Details__c acc : accDetailMap){
            accountMemberBranch.put(acc.id,acc.Current_Branch1__c); 
        }
        
        List<Valid_Branch__c> branchList = [select id,Region__c,Name from Valid_Branch__c];
        
        for(Case c: cases)
        {
            string memberBranch = accountMemberBranch.get(c.Account_Number__c);
            
                       
                    
            for(Integer i=0;i<branchList.size();i++)
            {
                String branchName = branchList[i].Name;
                
            
                if (memberBranch.equals(branchName))
                {
                    
                    c.Branch_Region__c = branchList[i].Region__c;   
                }
            }
        }
    }
}

// This method is used to force case assignment rules when bulk loading cases via Boomi  
public void CaseAssign(list < case > newValues)   { 
System.Debug('Calling the CaseAssign method');
    if(newValues[0].Origin == 'BoomiBulk'){
    System.Debug('This is a BoomiBulk Case: ' +newValues[0].caseNumber);
         Set < Id > CaseIds = new Set < Id > ();
         //To avoid too many SOQL "SOQL statement taken outside loop 
         for (case cse: newValues) {
            CaseIds.add(cse.id); 
         }
          Database.DMLOptions dmo = new Database.DMLOptions();            
            dmo.assignmentRuleHeader.useDefaultRule= true;                     
            List<case> cs=[select id from case where case.id in : CaseIds];   
            for(case c : cs )
            {
              
              c.setOptions(dmo);  
            }                
            
            
            List<Person_Account__c> pa = [Select PersonId__c,  
                                                 Account_Number__c
                                            from Person_Account__c 
                                           where Account_Number__c = :newValues[0].Account_Number__c 
                                             AND Name_Type__c = 0];
            
            for(case c : cs )
            {
              
              c.AccountId = pa[0].PersonID__C;
            }
            
            update cs;    
      
         
     } else {
     System.Debug('This is Not a BoomiBulk Case: ' +newValues[0].caseNumber);
     }
}
  
  
              
         
                       
  
  
    
    
    
    
    

    public void updateEmailtoSend(List<Case> newCaseList){
        for(Case c : newCaseList){
            try{
            String emailRegex = '([a-zA-Z0-9_\\-\\.]+)@((\\[a-z]{1,3}\\.[a-z]{1,3}\\.[a-z]{1,3}\\.)|(([a-zA-Z0-9\\-]+\\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})';
      Pattern MyPattern = Pattern.compile(emailRegex);
      Matcher MyMatcher = MyPattern.matcher(C.Email_Address__c);
      if (MyMatcher.matches()){
         C.Email_to_Send__c = C.Email_Address__c; // Used for sending email to the member.
      }  
            }catch(Exception e){}
        }
    
    }
    

    public void insertCaseTask(List<Case> newCaseList){
        List<Task> insertTask = new List<Task>();
        try{
            //// Iterating through the incoming cases to create a task where record type is shared branch
            for(Case nc : newCaseList){
                if(nc.Primary_Category__c == 'Shared Branch'){
                    Task newTask = new Task();
                    newTask.Subject = 'Contact Shared Branch Credit Union and request copy of the check(s).';
                    newTask.WhatId = nc.Id;
                    newTask.OwnerId = nc.OwnerId;
                    newTask.Status = nc.Status;
                    newTask.Priority = 'Normal';
                    insertTask.add(newTask);
                }
            }
            if(insertTask.size()>0){
                insert insertTask;
            }
        if(Test.isRunningTest()){
              Integer x=1/0;
              }
        }catch(Exception e) {
                System.debug('An error was encountered in the insertCaseTask method defined in the CaseTrigger :'+e);
        }
    }
    
    
    public void updateAccountNumberfromSubject(List<Case> cList){
        if(cList[0].Origin == 'Email'){
        Set<String> str = new Set<String>();
        Set<Id> accDId = new Set<Id>();
        Set<String> newListCrt = new Set<String>();
            
            if(cList[0].Subject == null || cList[0].Subject == ''){
             cList[0].Member_Number__c = '';
                cList[0].Code_Number__c = '';
            }else{          
          system.debug('cList###' + cList);
            List<String> splitted = cList[0].Subject.replace('[EXTERNAL] ','').split('\\s+');
           
          /*  if(splitted.size()>0 && splitted.size()<=1){
            cList[0].Member_Number__c = splitted[0];
               integer i;
               integer membersize = cList[0].Member_Number__c.length();
                 for(i=membersize; i<10;i++){
                      cList[0].Member_Number__c = '0'+cList[0].Member_Number__c;
                  } 
            } */
                
             if(splitted.size()>0 && splitted.size()<=1){
                  cList[0].Code_Number__c = splitted[0];
             }
        system.debug('splitted###' + splitted);
        if(splitted.size()>=2){
            cList[0].Code_Number__c = splitted[0];
            cList[0].Member_Number__c = splitted[1];
                 integer i;
                 integer membersize = cList[0].Member_Number__c.length();
                    for(i=membersize; i<10;i++){
                       cList[0].Member_Number__c = '0'+cList[0].Member_Number__c;                          
                   }                         
                }
            }          
        
        for(Case c : Trigger.new){             
            if(c.Member_Number__c != null || c.Member_Number__c != '' || c.Code_Number__c != null || c.Code_Number__c != ''){
            str.add(c.Member_Number__c); 
            newListCrt.add(c.Code_Number__c); 
                
            }
        }     
        
        List<Account_Details__c> accDetails = [Select Id, Name from Account_Details__c where Name =:str AND RecType__c = 'ACCT'];
        
        System.debug('accDetails mylist is:::'+accDetails);
        
        for(Account_Details__c accD : accDetails){
            accDId.add(accD.Id);
        }
        
        List<Person_Account__c> pa = [Select PersonId__c, PersonId__r.FirstName, PersonId__r.LastName, PersonId__r.MiddleName, Account_Number__c,
                                             PersonId__r.Residential_Street__pc, PersonId__r.Residential_Extra_Address__pc, PersonId__r.Residential_City__pc,
                                             PersonId__r.Residential_State__pc, PersonId__r.Residential_Country__pc, PersonId__r.Residential_Zipocde__pc from Person_Account__c where Account_Number__c =:accDId AND Name_Type__c = 0];
        
        System.debug('list of person accounts::::'+pa);
         
        Set<Id> perId = new Set<Id>();
          for(Person_Account__c p : pa){
                perId.add(p.PersonId__c);
            }
            
        List<Contact> con = [Select Id, Name, AccountId from Contact where Contact.AccountId =:perId];
        Map<Id,Id> conMap = new Map<Id,Id>();
        for(Contact ct : con){
            conMap.put(ct.AccountId, ct.Id);
        }

      //  List<CaseRecordType__c> crtList = [Select Primary_Category__c, Secondary_Category__c, Teritiary_Category__c, RecordTypeId__c from CaseRecordType__c where Name =:newListCrt];
            
        List<EmailtoCaseCode__c> crtList = [Select Primary_Category__c, Secondary_Category__c, Teritiary_Category__c, RecordTypeId__c from EmailtoCaseCode__c where Name =:newListCrt];    
        
        for(Case c : Trigger.new){
            if(accDetails.size()>0 || pa.size()>0 ){
                c.Account_Number__c = accDetails[0].Id;
                if(pa.size() > 0)
                {
                    c.AccountId = pa[0].PersonId__c;
                    c.ContactId = conMap.get(pa[0].PersonId__c);
                    c.First_Name__c = pa[0].PersonId__r.FirstName;
                    c.Last_Name__c = pa[0].PersonId__r.LastName;
                    c.Middle_Name__c = pa[0].PersonId__r.MiddleName;
                    c.Street_Address_1__c = pa[0].PersonId__r.Residential_Street__pc;
                    c.Street_Address_2__c = pa[0].PersonId__r.Residential_Extra_Address__pc;
                    c.City__c = pa[0].PersonId__r.Residential_City__pc;
                    c.State__c = pa[0].PersonId__r.Residential_State__pc;
                    c.Country__c = pa[0].PersonId__r.Residential_Country__pc;
                    c.Zip_Code__c = pa[0].PersonId__r.Residential_Zipocde__pc;
                }
                } 
                if(crtList.size()>0 || !crtList.isEmpty()){
                c.Primary_Category__c = crtList[0].Primary_Category__c;
                c.Secondary_Category__c = crtList[0].Secondary_Category__c;
                c.Tertiary_Category__c = crtList[0].Teritiary_Category__c;
                c.RecordTypeId = crtList[0].RecordTypeId__c;
                }           
           }    
      } 
}

    
    public void updateCaseBrandInfo(List<Case> newCaseList) {

        Set<String> brandCodeSet = new Set<String>();
        Set<String> accountDetailsIdSet = new Set<String>();
        Set<String> brandTextSet = new Set<String>();
        Map<String,String> accIDBrandCodeMap = new Map<String,String>();
        Map<String,Mapping__c> accNBrandInfoMap = new Map<String,Mapping__c>();
        Map<String,Mapping__c> brandTextNBrandDetailMap = new Map<String,Mapping__c>();
        List<Case> casesToBeUpdated = new List<Case>();

        try {
            // Iterating through the incoming cases to create a Set of Account_Details__c IDs
            for (Case newCase : newCaseList) {

//              if (newCase.Account_Number__c == NULL && newCase.Brand__c == NULL && newCase.SuppliedEmail == NULL ) {
                if (newCase.Account_Number__c == NULL && newCase.Brand__c == NULL && newCase.SuppliedEmail == NULL && newCase.Origin != 'BoomiBulk' && newCase.Origin != 'MaritzCX') {

                    newCase.addError('Please select either an "Account Number" OR a "Brand" to proceed further');
                    newCase.Account_Number__c.addError('Account Number');
                    newCase.Brand__c.addError('Brand');

                } else {

                    if(newCase.Account_Number__c != NULL){
                        System.debug('newCase.Account_Number__c is :'+newCase.Account_Number__c);
                        if(Trigger.isInsert) {
                            accountDetailsIdSet.add(newCase.Account_Number__c);
                            casesToBeUpdated.add(newCase);
                        } else {
                            Case oldCase = Trigger.oldMap.get(newCase.Id);
                            if (oldCase.Account_Number__c != newCase.Account_Number__c) {
                                accountDetailsIdSet.add(newCase.Account_Number__c);
                                casesToBeUpdated.add(newCase);
                            }
                        }
                    } else if (newCase.Brand__c != NULL) {
                        if(Trigger.isInsert) {
                            brandTextSet.add(newCase.Brand__c);
                            casesToBeUpdated.add(newCase);
                        } else {
                            Case oldCase = Trigger.oldMap.get(newCase.Id);
                            if (oldCase.Brand__c != newCase.Brand__c) {
                                brandTextSet.add(newCase.Brand__c);
                                casesToBeUpdated.add(newCase);
                            }
                        }
                    }
                }
            }

            System.debug('brandTextSet is :'+brandTextSet);
            System.debug('accountDetailsIdSet is :'+accountDetailsIdSet);

            // Iterating through all Account_Details__c records for the captured ID set, and 
            // creating a MAP<AccountDetailsID,BrandCode> as well as SET<BrandCodes>
            if (accountDetailsIdSet.size() > 0) {
                for (Account_Details__c account : [SELECT Id, Reference__c FROM Account_Details__c WHERE Id IN :accountDetailsIdSet]) {
                    
                    if(account.Reference__c != NULL) {
                        accIDBrandCodeMap.put(account.Id,account.Reference__c);
                        brandCodeSet.add(account.Reference__c);
                    }
                }
                   

                System.debug('accIDBrandCodeMap is :'+accIDBrandCodeMap);
                System.debug('brandCodeSet is :'+brandCodeSet);

                //Querrying the Mapping__c object to capture the Brand specific information from BrandCodes set i.e. brandCodeSet
                // and create a Map<AccountDetailsID,Mapping__c>
                Set<String> accDetailsIds = accIDBrandCodeMap.keySet();
                for (Mapping__c mapping : [SELECT Id, Brand_Code__c, Brand_Abbreviation__c, Credit_Union_Name__c, Image_URL__c, Object_Name__c, Support_Contact_Details__c FROM Mapping__c WHERE RecordType.name = 'Brand Details' AND Object_Name__c = 'Case' AND Brand_Code__c IN :brandCodeSet]) {
                    for (String accDetailsId : accDetailsIds) {
                        if (String.valueOf(accIDBrandCodeMap.get(accDetailsId)) == String.valueOf(mapping.Brand_Code__c)) {
                            accNBrandInfoMap.put(accDetailsId,mapping);
                        }
                    }
                }
            }

            if (brandTextSet.size() > 0) {
                for (Mapping__c mapping : [SELECT Id, Brand_Code__c, Brand_Abbreviation__c, Credit_Union_Name__c, Image_URL__c, Object_Name__c, Support_Contact_Details__c FROM Mapping__c WHERE RecordType.name = 'Brand Details' AND Object_Name__c = 'Case' AND Brand_Abbreviation__c IN :brandTextSet]) {
                    for (String bt : brandTextSet) {
                        if (String.valueOf(bt) == String.valueOf(mapping.Brand_Abbreviation__c)) {
                            brandTextNBrandDetailMap.put(bt,mapping);
                        }
                    }
                }
            }

            System.debug('accNBrandInfoMap is :'+accNBrandInfoMap);
            System.debug('brandTextNBrandDetailMap is :'+brandTextNBrandDetailMap);

            // Iterating through the incoming cases again, This time grabbing the mapping record from the 
            // Map<AccountDetailsID,Mapping__c> based on the Account_DetailsID and updating the case Object
            for (Case newCase : casesToBeUpdated) {
                if (newCase.Account_Number__c != NULL) {
                    Mapping__c brandMapping = accNBrandInfoMap.get(newCase.Account_Number__c);
                    if (brandMapping != NULL) {
                        newCase.Brand_Code__c = brandMapping.Brand_Code__c;
                        newCase.Brand_Abbreviation__c = brandMapping.Brand_Abbreviation__c;
                        newCase.Credit_Union_Name__c = brandMapping.Credit_Union_Name__c;
                        newCase.Image_URL__c = brandMapping.Image_URL__c;
                        newCase.Support_Contact_Details__c = brandMapping.Support_Contact_Details__c;
                        newCase.Brand__c = brandMapping.Brand_Abbreviation__c;
                    }
                } else if (newCase.Brand__c != NULL) {
                    Mapping__c brandMapping = brandTextNBrandDetailMap.get(newCase.Brand__c);
                    if (brandMapping != NULL) {
                        newCase.Brand_Code__c = brandMapping.Brand_Code__c;
                        newCase.Brand_Abbreviation__c = brandMapping.Brand_Abbreviation__c;
                        newCase.Credit_Union_Name__c = brandMapping.Credit_Union_Name__c;
                        newCase.Image_URL__c = brandMapping.Image_URL__c;
                        newCase.Support_Contact_Details__c = brandMapping.Support_Contact_Details__c;
                        newCase.Brand__c = brandMapping.Brand_Abbreviation__c;
                    }
                }   
            }

        if(Test.isRunningTest()){
               Integer x=1/0;
        }
        } catch (Exception e) {
            System.debug('An error was encountered in the updateCaseBrandInfo method defined in the CaseTrigger :'+e);
        }

    }

    
    public void updateErrorOnCaseClosing(List<Case> inCases){ 
        
        Map<Id, Task> taskMap = new Map<Id, Task>();
         
        List<Task> tskList = [SELECT Id, WhatId FROM Task WHERE IsClosed=false AND WhatId IN :trigger.newMap.keySet()];
         Map<Object, Object> caseAttachMap = new Map<Object, Object>();
        System.debug('tskList is:::'+tskList);

         for(Task t : tskList)
         {
            taskMap.put(t.WhatId, t);
         }
         System.debug('taskmap is::::'+taskMap);

        for(Case c : inCases)
         {
           if(c.Status == 'Closed' && c.Future_Date__c > system.today()){
             
             c.addError('Case cannot be closed with a future date greater than today.');
           }
           
           if(c.Status == 'Closed'){
             if(taskMap.containsKey(c.Id)){
                c.addError('All Tasks associated with a Case must be close/completed before the Case can be closed.');
           }
          }    
         }
         
        AggregateResult[] pendingAttachCases = [select count(id) pendingDocCount, case__c from OnBase_Document__c where ((case__c IN:trigger.newMap.keySet() or Member_Comment__r.Case__C IN: trigger.newMap.keySet()) and document_type__c = '')  group by case__c];
    
    for(AggregateResult aggRes : pendingAttachCases){
      System.debug('aggRes :: '+ aggRes);
      caseAttachMap.put(aggRes.get('Case__c'),aggRes.get('pendingDocCount'));
    }
    
    System.debug('caseAttachMap :: '+caseAttachMap);
    
    
        for(Case c : inCases)
         {
           if(c.Status == 'Closed'){
               if(caseAttachMap.containsKey(c.Id) && (Integer) caseAttachMap.get(c.Id)>0){
                   c.addError('All attachments must be indexed before the case can be closed.');
               }
            }    
         }
         
         
         
         
         
         
         
        }
    
    public void updateContactName(List<Case> ccList){

        List<Contact> conList = [Select Id, Name from Contact where Contact.AccountId =:ccList[0].AccountId];
        
        System.debug('List of contacts:::'+conList);
        
        for(Case incomingCase : Trigger.new){
            if(incomingCase.AccountId != NULL && incomingCase.ContactId == NULL && (incomingCase.Secondary_Category__c != 'Onboarding' || incomingCase.Origin != 'Email')){
               incomingCase.ContactId = conList[0].Id;
                
            }
        }
    }
    
    
    
   public void updateownershipLog(List<Case> cList){
       List<ownership_log__c> olog = [select id, sequence__c,type__c from ownership_log__c where case__c = :cList[0].Id];
    
    }  
    
    
   
    public void updateMemberInfo(List<Case> ccList, List<Case> oldList){
          string newId = ccList[0].AccountId;
          string oldId = oldList[0].AccountId;
          System.Debug('member old id::::: ' +oldId); 
          System.Debug('member new id:::::: ' +newId); 
         
          if(oldId != newId){
        
                   if(newId != null){
                                      List<Account> actList = [Select Id, Name, Home_Phone_Number__c, Residential_Street__pc, Residential_City__pc,
                                                               Residential_Zipocde__pc, Email_raw__c, Residential_Country__pc,
                                                               Residential_Extra_Address__pc, Residential_State__pc from Account where Id =:newId];
            
                             List<Person_Account__c> pa1 = [Select PersonId__c, PersonId__r.Email_raw__c,
                                                            PersonId__r.Home_Phone_Number__c, 
                                                            PersonId__r.Residential_Street__pc, 
                                                            PersonId__r.Residential_Extra_Address__pc, PersonId__r.Residential_City__pc,
                                                            PersonId__r.Residential_State__pc, PersonId__r.Residential_Country__pc,
                                                            PersonId__r.Residential_Zipocde__pc from Person_Account__c
                                                            where PersonID__c =:newId];
             
                     if(actList.size()>0){
                                  List<Contact> conList1 = [Select Id, Home_Phone__c, Name, email from Contact where Contact.AccountId =:newId];
                                  if(conList1.size()>0){
                                                         ccList[0].ContactId = conList1[0].Id;
                                                         ccList[0].AccountId = actList[0].Id;
                                                       // ccList[0].ContactPhone = conList1[0].Home_Phone__c;
                                                         ccList[0].Email_Address__c = actList[0].Email_raw__c;
                                                         ccList[0].Street_Address_1__c = actList[0].Residential_Street__pc;
                                                         ccList[0].Street_Address_2__c = actList[0].Residential_Extra_Address__pc;
                                                         ccList[0].City__c = actList[0].Residential_City__pc;
                                                         ccList[0].State__c = actList[0].Residential_State__pc;
                                                         ccList[0].Country__c = actList[0].Residential_Country__pc;
                                                         ccList[0].Zip_Code__c = actList[0].Residential_Zipocde__pc;
                                                        } 
                                           }  
                                      }
                          
            
                    else{
                              // List<Contact> conList2 = [Select Id, Name from Contact where Contact.AccountId =:ccList[0].AccountId];
                            ccList[0].ContactId = null;
                ccList[0].AccountId = null;
                //ccList[0].ContactPhone = pa1[0].PersonId__r.Home_Phone_Number__c;
                           ccList[0].Email_Address__c = '';
                           ccList[0].Street_Address_1__c = '';
                           ccList[0].Street_Address_2__c = '';
                           ccList[0].City__c = '';
                           ccList[0].State__c = '';
                           ccList[0].Country__c = '';
                            ccList[0].Zip_Code__c = '';

                
                 } 
        }  
    }
    
    public void surveyCaseValidation(List<Case> cList){
        String origOwner;
        System.debug('Debug::::Survey Case Update Validation Starting');
        System.debug('Debug::::Checking Branch');
        if(cList[0].category__c == 'Surveys / Branch / Other' || cList[0].category__c == 'Surveys / Relationship / Other' ){
            System.debug('Debug::::Branch/Relationship Confirmed');                  
            Set<String> groupNames = new Set<String>();
            for (GroupMember gm : [select group.name, group.DeveloperName from GroupMember where UserOrGroupId = :UserInfo.getUserId()]) {
                 groupNames.add(gm.group.DeveloperName);
            }
            for(Case c : Trigger.old){  
               origOwner = cList[0].OwnerID;
            }
            for(Case c : Trigger.new){     
                if(!groupNames.contains('Branch_Manager_Group')){ 
                    System.debug('Debug::::User not in Public Group');
                    if(origOwner == UserInfo.getUserId() ) {  // cList[0].OwnerId == UserInfo.getUserId() ) {
                       System.debug('Debug::::User is the current owner');
                    } else {
                       System.debug('Debug::::User is not the current owner');
                        if(cList[0].Update_Check__c){ 
                           // allow simple ownership log changes to the case based on very recent last modified date/time.
                       } else {
                            c.addError('Only Users in the Branch Managers Group can update Branch/Relationship Survey cases');
                       }
                    
                    }
                 } else {
                       System.debug('Debug::::User is in the public group');    
                 }
            }            
        }
        
        System.debug('Debug::::Checking Call Center');
         if(cList[0].category__c == 'Surveys / Call Center / Other'){
            System.debug('Debug::::Call Center Confirmed');
            Set<String> groupNames = new Set<String>();
            for (GroupMember gm : [select group.name, group.DeveloperName from GroupMember where UserOrGroupId = :UserInfo.getUserId()]) {
                 groupNames.add(gm.group.DeveloperName);
            }
            for(Case c : Trigger.old){  
               origOwner = cList[0].OwnerID;
            }
            for(Case c : Trigger.new){             
                if (!groupNames.contains('Call_Center_Managers')) {
                    System.debug('Debug::::User not in Public Group');
                    if(origOwner == UserInfo.getUserId() ) {
                       System.debug('Debug::::User is the current owner');
                    } else {
                       System.debug('Debug::::User is not the current owner');
                       if(cList[0].Update_Check__c){ 
                           // allow simple ownership log changes to the case based on very recent last modified date/time.
                       } else {
                            c.addError('Only Users in the Call Center Managers Group can update Call Center Survey cases');
                       }     
                    }
                 } else {
                       System.debug('Debug::::User is in the public group');    
                 }
            }  
        } 
        System.debug('Debug:::: Survey Case Update Validation Complete');             
    }
    
    
    public void updateSurveyCase(List<Case> scList)
      {
      String surveyType;
      Integer splitSize;
      if(scList[0].Origin == 'MaritzCX'){   
        Set<String> str = new Set<String>();
        Set<Id> accDId = new Set<Id>();
        Set<String> newListScc = new Set<String>();
        System.debug('scList[0].Subject is:::'+scList[0].Subject);    
            
            if(scList[0].Subject == null || scList[0].Subject == ''){
                scList[0].Member_Number__c = '';
                scList[0].Code_Number__c = '72';
                System.debug('Subject is null/blank and scList[0].Code_Number__ct is:::'+scList[0].Code_Number__c); 
            }else{          
            
                 List<String> splitted = scList[0].Subject.split(':'); // Split email subject on the vertical bar to get branch/dept and member# and survey type
                 splitSize = splitted.size();
                 System.debug('Debug- Subject split size = ' +splitSize);
                 System.debug('Debug- Name - splitted[0] = '+splitted[0]); 
                 System.debug('Debug- branch/dept # - splitted[1] = '+splitted[1]); 
                 System.debug('Debug- account # -splitted[2] = '+splitted[2]);
                 
                 surveyType = 'Branch';
                 if(splitted[0].contains('Relationship')){
                      surveyType = 'Relationship';
                 }
                 if(splitted[0].contains('Call Center')){
                      surveyType = 'Call Center';
                 }
                 if(splitted[0].contains('RE Lending')){
                      surveyType = 'RE Lending';
                 }
                 if(splitted[0].contains('Future Placeholder')){
                      surveyType = 'Future Placeholder';
                 }
                 System.debug('Debug- SurveyType = ' +surveyType );
                  
  
                 if(splitted.size()>0 && splitted.size()<=1){
                      scList[0].Code_Number__c = splitted[1].trim().left(10); 
                 }
        
       //         if(splitSize==3){  
                     scList[0].Code_Number__c = splitted[1].trim().left(10);
                     System.debug('Debug- scList[0].Code_Number__c is:::'+scList[0].Code_Number__c);
                     scList[0].Member_Number__c = splitted[2];
                     integer i;
                     integer membersize = scList[0].Member_Number__c.length();
                     for(i=membersize; i<10;i++){
                         scList[0].Member_Number__c = '0'+scList[0].Member_Number__c;                          
                     }                         
       //          }

                 integer codesize = scList[0].Code_Number__c.length();
                 if(codesize < 1 || codesize > 3){
                      scList[0].Code_Number__c = '72';
                 }
            }          
        
            for(Case c : Trigger.new){             
                if(c.Member_Number__c != null || c.Member_Number__c != '' || c.Code_Number__c != null || c.Code_Number__c != ''){
                     str.add(c.Member_Number__c); 
                     newListScc.add(c.Code_Number__c);              
                }
            }     
        
            List<Account_Details__c> accDetails = [Select Id, Name 
                                                     from Account_Details__c 
                                                    where Name =:str 
                                                      AND RecType__c = 'ACCT'];
                                                                                            
        
            System.debug('Debug- accDetails mylist is:::'+accDetails);
        
            for(Account_Details__c accD : accDetails){
                accDId.add(accD.Id);
            }
        
            List<Person_Account__c> pa = [Select PersonId__c, PersonId__r.FirstName, PersonId__r.LastName, PersonId__r.MiddleName, Account_Number__c,
                                                 PersonId__r.Residential_Street__pc, PersonId__r.Residential_Extra_Address__pc, PersonId__r.Residential_City__pc,
                                                 PersonId__r.Residential_State__pc, PersonId__r.Residential_Country__pc, PersonId__r.Residential_Zipocde__pc 
                                            from Person_Account__c 
                                           where Account_Number__c =:accDId 
                                             AND Name_Type__c = 0];
        
            System.debug('Debug- list of person accounts::::'+pa);
         
            Set<Id> perId = new Set<Id>();
              for(Person_Account__c p : pa){
                  perId.add(p.PersonId__c);
              }
            
            List<Contact> con = [Select Id, Name, AccountId
                                   from Contact 
                                  where Contact.AccountId =:perId];
            Map<Id,Id> conMap = new Map<Id,Id>();
            for(Contact ct : con){
                conMap.put(ct.AccountId, ct.Id);
            }
        
            System.debug('Debug- list of Survey Case Codes::::'+newListScc);

            List<Survey_Case_Codes__c> sccList = [Select Primary_Category__c, Secondary_Category__c, Tertiary_Category__c, Queue__c 
                                                    from Survey_Case_Codes__c
                                                   where Name =:newListScc];
                                                                                                   
       /*     if(splitSize == 3){
                     surveyType = sccList[0].Secondary_Category__c;
                     System.debug('Debug- surveyType is:::'+surveyType);  
            }                  */                                                         
            System.debug('Debug- :::: perID = '+perID);                                        
            List<Contact> contactList = [Select Id, Name, AccountId, Email 
                                   from Contact 
                                  where Contact.AccountId =:perId];                                       
            System.debug('Debug- list of contact info::::'+contactList);  
            System.debug('Debug- Queue Name::::'+sccList[0].Queue__c);                                    
            List<Group> queList = [Select id, Name 
                                     from Group where Name =:sccList[0].Queue__c];
            
            List<CaseRecordType__c> crtList = [Select RecordTypeId__c 
                                                 from CaseRecordType__c
                                                where Primary_Category__c = 'Surveys'];  
                                                
  /*          List<Episys_User__c> euDetails = [Select Episys_ID__c,  Episys_Name__c
                                                     from Episys_User__c
                                                    where Episys_User__c
                                                      AND Episys_ID__c= 'ACCT'];                */                                    
                                                  
            System.debug('Debug- Start final update action'); 
            for(Case c : Trigger.new){
                if(accDetails.size()>0 || pa.size()>0 ){
                   c.Account_Number__c = accDetails[0].Id;
                   c.AccountId = pa[0].PersonId__c;
                   c.ContactId = conMap.get(pa[0].PersonId__c);
   /*                c.Email_Address__c = contactList[0].Email;             */         
                   c.First_Name__c = pa[0].PersonId__r.FirstName;
                   c.Last_Name__c = pa[0].PersonId__r.LastName;
                   c.Middle_Name__c = pa[0].PersonId__r.MiddleName;
                   c.Street_Address_1__c = pa[0].PersonId__r.Residential_Street__pc;
                   c.Street_Address_2__c = pa[0].PersonId__r.Residential_Extra_Address__pc;
                   c.City__c = pa[0].PersonId__r.Residential_City__pc;
                   c.State__c = pa[0].PersonId__r.Residential_State__pc;
                   c.Country__c = pa[0].PersonId__r.Residential_Country__pc;
                   c.Zip_Code__c = pa[0].PersonId__r.Residential_Zipocde__pc;} 
                   if(sccList.size()>0 || !sccList.isEmpty()){
                        c.Primary_Category__c = sccList[0].Primary_Category__c;
                        c.Secondary_Category__c = surveyType ; //sccList[0].Secondary_Category__c;
                        c.Tertiary_Category__c = sccList[0].Tertiary_Category__c;   
                        c.RecordTypeId = crtList[0].RecordTypeId__c; 
                        c.Ownerid = queList[0].id;
                        
                   }           
               }    
          } 
          
          
          
}          


private boolean IsOtherThanTaskCountFieldUpdated()
{ 
  if(trigger.isinsert)
  {
    return true;
    
  }
        Case gplObject = new Case(); // This takes all available fields from the required object. 
        Schema.SObjectType objType = gplObject.getSObjectType(); 
        Map<String, Schema.SObjectField> mapFields = Schema.SObjectType.Case.fields.getMap(); 
        
        for(Case   gpl : trigger.new)
        {
            Case   oldGPL = trigger.oldMap.get(gpl.Id);
    if(mapFields.size()>0)
        {
            for (String str : mapFields.keyset()) 
            { 
                try 
                { 
                    if(gpl.get(str) != oldGPL.get(str) && str.toLowerCase() == 'Overdue_task_count__c')
                    { 
                      System.Debug('Other than Email updated...' + str);
                        return false; 
                    } 
                } 
                catch (Exception e) 
                { 
                    System.Debug('Error: ' + e); 
                } 
            }
        }
        }
        System.Debug('No Other field than Email updated...');
        
        return true;
}
    

    
}