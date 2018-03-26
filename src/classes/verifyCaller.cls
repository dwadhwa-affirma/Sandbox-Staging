public class verifyCaller{

    public List<Account> namesofCaller = new List<Account>();
    //String check = '';
    
    public List<Account> ValidatePhoneNumber(String phoneNumber){
        namesofCaller = new List<Account>();
        String additionalformat = getAdditionalPhoneNumber(phoneNumber);
        String additionalformat1 = getAdditionalPhoneNumber1(phoneNumber);
        try{
            namesofCaller = [select FirstName , LastName , ID, SSN_Last_4__pc, BIRTH_DATE__pc,Mothers_Maiden_Name__pc, PersonEmail,ID_1_Number__pc ,ID_2_Number__pc, ID_3_Number__pc,(select Card_Number__c FROM Person_Account__r ) from Account where PersonHomePhone =:phoneNumber OR PersonMobilePhone=:phoneNumber 
            OR  PersonOtherPhone =:phoneNumber OR Phone =:phoneNumber OR PersonAssistantPhone =:phoneNumber OR PersonHomePhone =:additionalformat OR PersonMobilePhone=:additionalformat 
            OR  PersonOtherPhone =:additionalformat OR Phone =:additionalformat OR PersonAssistantPhone =:additionalformat OR Home_Phone__pc =:additionalformat OR Mobile_Phone__pc =:additionalformat OR  Work_Phone__pc =:additionalformat OR Home_Phone__pc =:additionalformat1 OR Mobile_Phone__pc =:additionalformat1 OR  Work_Phone__pc =:additionalformat1
            OR  Home_Phone__pc =:phoneNumber OR Mobile_Phone__pc =:phoneNumber OR  Work_Phone__pc =:phoneNumber];            
         }
         Catch(QueryException e){
             
         }
         return namesofCaller;
    }
    
    public Account getAccountByName(String ID){
        Account CallerDetails = new Account();
        try{
            CallerDetails = [select FirstName , LastName , ID,AccountNumber, SSN_Last_4__pc, BIRTH_DATE__pc,Mothers_Maiden_Name__pc, PersonEmail,ID_1_Number__pc 
            ,ID_2_Number__pc, ID_3_Number__pc, (select id, Card_Number__c FROM Person_Account__r ) from Account where ID =:ID];
            
         }
         Catch(QueryException e){
             
         }
         return CallerDetails;
    }
    
    public String getAdditionalPhoneNumber(String phoneNumber){
        String phoneNumber1;
        String phoneNumber2;
        String phoneNumber3;
        if(phoneNumber.containsAny('() -')){
            phoneNumber = phoneNumber.remove('(');
            phoneNumber = phoneNumber.remove(')');
            phoneNumber = phoneNumber.remove(' ');
            phoneNumber = phoneNumber.remove('-');
        }
        phoneNumber1 = phoneNumber.substring(0,3);
        phoneNumber2 = phoneNumber.substring(3,6);
        phoneNumber3 = phoneNumber.substring(6,10);
        
        phoneNumber = '('+phoneNumber1+')'+' '+phoneNumber2+'-'+phoneNumber3;
        system.debug('phoneNumber....'+phoneNumber);
        return phoneNumber;        
    }
    
    public String getAdditionalPhoneNumber1(String phoneNumber){
        String phoneNumber1;
        String phoneNumber2;
        String phoneNumber3;
        if(phoneNumber.containsAny('() -')){
            phoneNumber = phoneNumber.remove('(');
            phoneNumber = phoneNumber.remove(')');
            phoneNumber = phoneNumber.remove(' ');
            phoneNumber = phoneNumber.remove('-');
        }
        phoneNumber1 = phoneNumber.substring(0,3);
        phoneNumber2 = phoneNumber.substring(3,6);
        phoneNumber3 = phoneNumber.substring(6,10);
        
        phoneNumber = phoneNumber1+'-'+phoneNumber2+'-'+phoneNumber3;
        system.debug('phoneNumber....'+phoneNumber);
        return phoneNumber;        
    }
    
    /*public String queryMemberNumber(String memberNumber){
        List<Person_Account__c> memberLists = [select id from Person_Account__c where Account_Number__r.name =: memberNumber];
        String ids = '(';
        for(Person_Account__c pa : memberLists){
                ids = ids+'\''+pa.id+'\',';
        }
        ids = ids+')';
        ids.replace(',)', ')');
        return ids;
    }*/
    
    // get all related account details
    public List<Account_Details__c> AccountNumbersAuth(String id){
        List<Account_Details__c> MemberNumberAuth = new List<Account_Details__c>();
        List<Person_Account__c> relatedPerson = new List<Person_Account__c>();
        relatedPerson = [select Account_Number__c, TypeTranslate__C from Person_Account__c where 
        TypeTranslate__C != '0004/Beneficiary' and
        PersonID__c =:id ];
         system.debug('relatedPerson---'+relatedPerson);
        List<id> relatedIds = new List<Id>();
        for(Person_Account__c p : relatedPerson ){
            relatedIds.add(p.Account_Number__c);
        }
        system.debug('relatedIds---'+relatedIds);
        MemberNumberAuth = [Select Name, id, TypeTranslate__C from  Account_Details__c where Parent_Account__c in :relatedIds Or id in :relatedIds];
        system.debug('MemberNumberAuth ----'+MemberNumberAuth );
        return MemberNumberAuth;
    }
    
    public List<Account_Details__c> MemberLoanDetails(String id){
        List<Account_Details__c> MemberNumberLoanDetail = new List<Account_Details__c>();
        List<Person_Account__c> relatedPerson = new List<Person_Account__c>();
        relatedPerson = [select Account_Number__c from Person_Account__c where 
        TypeTranslate__C != '0004/Beneficiary' and
         PersonID__c =:id ];
        List<id> relatedIds = new List<Id>();
        for(Person_Account__c p : relatedPerson ){
            relatedIds.add(p.Account_Number__c);
        }
        system.debug('relatedIds---'+relatedIds);
        MemberNumberLoanDetail  = [Select Name, id,TypeTranslate__c,Balance__c,OPEN_DATE__c ,Close_Date__c,PAYMENT__c from  Account_Details__c where (RecType__c = 'LOAN' or RecType__c = 'MORT' or RecType__c = 'STDL') AND (Parent_Account__c in :relatedIds Or id in :relatedIds)];
        system.debug('MemberNumberLoanDetail----'+MemberNumberLoanDetail );
        return MemberNumberLoanDetail ;
    }
    
    public List<Account_Details__c> MemberDetailsDOB(String id){
        List<Account_Details__c> MemberNumberDOBDetail = new List<Account_Details__c>();
        List<Person_Account__c> relatedPerson = new List<Person_Account__c>();
        // do not query for beneficiary as we don't want information to be displayed for selected user who is a beneficiary.
        relatedPerson = [select Account_Number__c from Person_Account__c where 
        TypeTranslate__C != '0004/Beneficiary'and
         PersonID__c =:id];
        List<id> relatedIds = new List<Id>();
        for(Person_Account__c p : relatedPerson ){
            relatedIds.add(p.Account_Number__c);
        }
        system.debug('relatedIds---'+relatedIds);
        MemberNumberDOBDetail  = [Select Name, id,TypeTranslate__c,Balance__c,OPEN_DATE__c ,Close_Date__c,PAYMENT__c from  Account_Details__c where (Parent_Account__c in :relatedIds Or id in :relatedIds)];
        system.debug('MemberNumberDOBDetail----'+MemberNumberDOBDetail );
        return MemberNumberDOBDetail ;
    }
    
    
     public List<Person_Account__c> MemebersNameDobDetails(list<Account_Details__c> accList) {
        
         set<String> accName = new Set<String>();
        
        for(Account_Details__c var: accList){
            accName.add(var.Name);
        }
        
        system.debug('accName--'+accName);
        //List<Account_Details__c> MemberNumberAuth = new List<Account_Details__c>();
        // should not filter for beneficiary as we are displaying results for selected accounts. We should not get account accName in case member in focus is only a beneficiary.  
        List<Person_Account__c> relatedPerson = new List<Person_Account__c>();
        relatedPerson = [Select Id,personId__c,Account_Number__c,TypeTranslate__c,Account_Type__c,
                        Relationship__c,PersonID__r.SSN_Last_4__pc,Open_Date__c,PersonID__r.BIRTH_DATE__pc,
                        Account_Number__r.Name,Account_Number__r.TypeTranslate__c, PersonID__r.FirstName, PersonID__r.LastName,Person_Account__c.Name ,PersonID__r.Name 
                        from Person_Account__c where 
                      //  TypeTranslate__C != '0004/Beneficiary' and
                         Account_Number__r.Name IN :accName ];
        system.debug('relatedPersonLoan---'+relatedPerson);                             
        return relatedPerson;
    }
    
    public List<Account_Details__c> CardNumbersAuth(String id){
        List<Account_Details__c> MemberNumberAuth = new List<Account_Details__c>();
        List<Person_Account__c> relatedPerson = new List<Person_Account__c>();
        relatedPerson = [select Account_Number__c from Person_Account__c where 
        TypeTranslate__C != '0004/Beneficiary' and
         PersonID__c =:id];
        List<id> relatedIds = new List<Id>();
        for(Person_Account__c p : relatedPerson ){
            relatedIds.add(p.Account_Number__c);
        }
        System.debug(relatedIds);
        MemberNumberAuth = [Select Name,Card_Number_Last_4_Digits__c,Card_Number__c , id from  Account_Details__c where (Parent_Account__c in :relatedIds Or id in :relatedIds) and status1__c = '1 Issued'];
        return MemberNumberAuth;
    }
    
    public Boolean validateMemberNumber(string memberNumber)
    {
    	if(memberNumber != null && memberNumber != ''){
            List<Person_Account__c> memberLists = [select id,PersonID__c from Person_Account__c where 
            TypeTranslate__C != '0004/Beneficiary' and 
            Account_Number__r.name =: memberNumber];
            system.debug('memberLists---'+memberLists);
            
            if(memberLists.size()>0)
            {
                    return true;
          
            }
            else
            {
            	return false;    
            }
    	}
    	return false;
    }
    
    public List<Account> queryByParametersAvailable(verificationObject input, boolean onlyQueryParameters){
        String check = '';
        String queryString = 'select FirstName , LastName , ID, SSN_Last_4__pc, BIRTH_DATE__pc,Mothers_Maiden_Name__pc, PersonEmail, ID_1_Number__pc ,ID_2_Number__pc, ID_3_Number__pc from Account where (';
        String conditions = '';
        String additionalConditions = ''; 
        String phoneQuery = '';
        List<id> ids = new List<id>();
        List<Account> ListofNames = new List<Account>(); 
        system.debug('input---'+input);   
        system.debug('memberNumber---'+input.memberNumber );
        if(input.memberNumber != null && input.memberNumber != ''){
            List<Person_Account__c> memberLists = [select id,PersonID__c from Person_Account__c where 
            TypeTranslate__C != '0004/Beneficiary' and 
            Account_Number__r.name =: input.memberNumber];
            system.debug('memberLists---'+memberLists);
            
            if(memberLists.size()>0){
                    for(Person_Account__c pa : memberLists){
                            ids.add(pa.PersonID__c);
                    }
            }else{
                if(input.fieldnametocheck == 'memberNumber'){
                    return ListofNames;
                }
            }
                /*
            if(check == '0'){
                queryString = queryString+ ' And ';
            }
            String ids = queryMemberNumber(input.memberNumber);
            queryString = queryString+ 'id in '+ids;
            check = '0';*/
            
        }
        if(input.SSN != null && input.SSN != ''){
            if(check == '0'){
                queryString = queryString+ ' And ';
            }
            queryString = queryString+ 'SSN_Last_4__pc = \''+input.SSN+'\'';
            check = '0';
        }
        if(input.CardNumber != null && input.CardNumber != ''){         
            List<Account_Details__c> temp = new List<Account_Details__c>();
            //temp = [select Id, Parent_Account__c from Account_Details__c where Card_Number_Last_4_Digits__c =:input.CardNumber];
            temp = [select Id, Parent_Account__c from Account_Details__c where Card_Number__c like :'%'+input.CardNumber];
            String addOr = '';
            if(temp.size()>0){
            list<id> tempIds = new List<Id>();
                for(Account_Details__c single: temp){
                    /*if(addOr == '0'){
                        conditions = conditions+' OR';
                    }
                    conditions = conditions+' id =\''+single.Parent_Account__c+'\'';
                    addOr = '0';*/
                    tempIds.add(single.Parent_Account__c);
                } /*
                if(check == '0'){
                    queryString = queryString+ ' And ';
                }           
                conditions  = '('+conditions+')'; */
                List<Person_Account__c> persons = new List<Person_Account__c>();
                persons = [select PersonID__c from Person_Account__c where 
                TypeTranslate__C != '0004/Beneficiary' and
                 Account_Number__c in :tempIds];
                system.debug('input.fieldnametocheck....'+input.fieldnametocheck);
                if(input.fieldnametocheck == 'CardNumber'){
                    system.debug('persons.size()...'+persons.size());
                    system.debug('persons.size()...'+persons);
                    if(persons.size() < 1){
                        return ListofNames;
                    }else{
                        if(ids.size()>0){
                            boolean flagForId = false;
                            for(id inc : ids){
                                for(Person_Account__c p: persons){
                                    if(p.PersonID__c == inc){
                                        flagForId = true;
                                    }
                                }                            
                            }
                            if(flagForId){
                                for(Person_Account__c p: persons){                    
                                    Ids.add(p.PersonID__c);
                                } 
                            }else{
                                return ListofNames;
                            }
                        }else{
                            for(Person_Account__c p: persons){                    
                                Ids.add(p.PersonID__c);
                            } 
                        }
                    }
                }else{
                    system.debug('ummmmmmmmm');
                    if(persons.size()>0 && input.fieldnametocheck != 'memberNumber'){
                        for(Person_Account__c p: persons){                    
                            Ids.add(p.PersonID__c);
                        } 
                    }else if(persons.size()>0 && input.fieldnametocheck == 'memberNumber'){
                        boolean flagForId = false;
                            for(id inc : ids){
                                for(Person_Account__c p: persons){
                                    if(p.PersonID__c == inc){
                                        flagForId = true;
                                    }
                                }                            
                            }
                            if(flagForId){
                                for(Person_Account__c p: persons){                    
                                    Ids.add(p.PersonID__c);
                                } 
                            }
                    }else if(persons.size()>0){
                        for(Person_Account__c p: persons){                    
                            Ids.add(p.PersonID__c);
                        } 
                    }
                }
            }else{
                return ListofNames;
            }
            
        }
        if(!onlyQueryParameters){
            wrapper wrap = new wrapper();
            wrap = getNamesList(input,check);
            additionalConditions = wrap.queryString;
            check = wrap.check;
            
        }
        if(ids.size()>0){
            if(check == '0'){
                conditions = ' And ';
            }
            conditions = conditions+'id in (';
            for(id i : ids){
                conditions = conditions+'\''+i+'\',';
            }
            integer x = conditions.length();
            if(x>2){
                conditions = conditions.substring(0,x-1);
                conditions = conditions+')';
            }
            check = '0';
        }
        if(input.phoneNumber != null && input.phoneNumber != ''){
            if(check == '0'){
                phoneQuery = phoneQuery+ ' OR ';
            }
            String additionalformat = getAdditionalPhoneNumber(input.phoneNumber);          
            String additionalformat1 = getAdditionalPhoneNumber1(input.phoneNumber);

            phoneQuery = phoneQuery+ '(PersonHomePhone =\''+input.phoneNumber+'\' OR PersonMobilePhone=\''+input.phoneNumber+'\' OR  PersonOtherPhone =\''+input.phoneNumber+'\' OR Phone =\''+input.phoneNumber+'\' OR PersonAssistantPhone =\''+input.phoneNumber+
                           '\' OR PersonHomePhone =\''+additionalformat1+'\' OR PersonMobilePhone=\''+additionalformat1+'\' OR  PersonOtherPhone =\''+additionalformat1+'\' OR Phone =\''+additionalformat1+'\' OR PersonAssistantPhone =\''+additionalformat1+
                           '\' OR Home_Phone__pc =\''+additionalformat+'\' OR Mobile_Phone__pc =\''+additionalformat+'\' OR  Work_Phone__pc =\''+additionalformat+
                           '\' OR Home_Phone__pc =\''+additionalformat1+'\' OR Mobile_Phone__pc =\''+additionalformat1+'\' OR  Work_Phone__pc =\''+additionalformat1+
                           '\' OR Home_Phone__pc =\''+input.phoneNumber+'\' OR Mobile_Phone__pc =\''+input.phoneNumber+'\' OR  Work_Phone__pc =\''+input.phoneNumber+
                            '\' OR PersonHomePhone =\''+additionalformat+'\' OR PersonMobilePhone=\''+additionalformat+'\' OR  PersonOtherPhone =\''+additionalformat+'\' OR Phone =\''+additionalformat+'\' OR PersonAssistantPhone =\''+additionalformat+'\' )';
            check = '0';
        }
        queryString = queryString+additionalConditions+conditions+' ) '+phoneQuery;
        system.debug('queryString....'+queryString);
        try{
            ListofNames = Database.query(queryString);
        }Catch(QueryException e){
            
        }
        
        system.debug('ListofNames ......'+ListofNames);
        return (ListofNames);
    }
    
    
    public wrapper getNamesList(verificationObject input, String check){
        //String check = '';
        String queryString = '';
        
        if(input.DOB != null && input.DOB != ''){
            if(check == '0'){
                queryString = queryString+ ' And ';
            }
            queryString = queryString+ 'BIRTH_DATE__pc = '+input.DOB;
            check = '0';
        }
        if(input.MMN != null && input.MMN != ''){
            if(check == '0'){
                queryString = queryString+ ' And ';
            }
            queryString = queryString+ 'Mothers_Maiden_Name__pc = \''+input.MMN+'\'';
            check = '0';
        }
        if(input.ICardNumber != null && input.ICardNumber != ''){
            if(check == '0'){
                queryString = queryString+ ' And ';
            }
            queryString = queryString+ '(ID_1_Number__pc =\''+input.ICardNumber+'\' OR ID_2_Number__pc =\'' +input.ICardNumber+'\' OR ID_3_Number__pc =\''+input.ICardNumber+'\')';
            check = '0';
        }

        if(input.Email != null && input.Email != ''){
            if(check == '0'){
                queryString = queryString+ ' And ';
            }
            queryString = queryString+ 'PersonEmail = \''+input.Email+'\'';
            check = '0';
        }
        
        wrapper wrap = new wrapper();
        wrap.queryString = queryString;
        wrap.check = check;
        return wrap;       
    }
    
    public class wrapper{
        public string queryString;
        public string check;
    }
    
}