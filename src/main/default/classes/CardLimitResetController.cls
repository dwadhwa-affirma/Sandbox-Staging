public class CardLimitResetController {

    //CardLimitReset/GetCards
    //CardLimitReset/UpdateCardLimits
    //EFT/GetAccountBySSN
    //Account/IsDormantAccount

    //------------------------------- Getting Stage Details and Member Account Details-----------------------------------------------//
    @AuraEnabled
    public static map<string,object> getStageData(string recordId, string sObjectType){
        map<string,object> resultMap = new map<string,object>();
        List<ChangeLimit_Stages__c> CLStages = new List<ChangeLimit_Stages__c>();
        Id uniqueId = recordId;
        Schema.SObjectType objType = uniqueId.getsobjecttype();
       
        if(objType == Account_Details__c.sObjectType){
            
            CLStages = [SELECT id, name, isActive__c, Order__c, Stage_Action__c,Stage_Action_Placeholder__c, Stage_Component__c, Stage_Label__c, StepId__c from ChangeLimit_Stages__c where isActive__c = true]; //where isActive__c = true;      //EFT_Stages__c.getall().values();
            resultMap.put('CLStages', CLStages);

            List<Change_Limit__c> CLRecord = [Select id, name, Stage__c,Member_Account__c, Member__c from Change_Limit__c where Member_Account__c =:recordId limit 1];
            integer activeStageIndex = 0;
            if(CLRecord.size() >0){               
                for(ChangeLimit_Stages__c clstage:CLStages){ 
                    if(CLRecord[0].Stage__c == clstage.Stage_Label__c){
                    	activeStageIndex = (integer)clstage.Order__c;
                	}
                }
                              
                resultMap.put('CLRecord', CLRecord);
                
            }
            Account_Details__c MemberAccount = [select id,name from Account_Details__c where id=:recordId limit 1];
            resultMap.put('MemberAccount', MemberAccount);
        }

        if(objType == Account.sObjectType){
            
            CLStages = [SELECT id, name, isActive__c, Order__c, Stage_Action__c,Stage_Action_Placeholder__c, Stage_Component__c, Stage_Label__c, StepId__c from ChangeLimit_Stages__c where StepId__c != 'Step1' and isActive__c = true];
            resultMap.put('CLStages', CLStages);

            List<Change_Limit__c> CLRecord = [Select id, name, Member_Account__c, Member__c from Change_Limit__c where Member_Account__c =:recordId limit 1];
            integer activeStageIndex = 0;
            if(CLRecord.size() >0){               
                for(ChangeLimit_Stages__c clstage:CLStages){
                    if(CLRecord[0].Stage__c == clstage.Stage_Label__c){
                    	activeStageIndex = (integer)clstage.Order__c;
                	}
                }
                              
                resultMap.put('CLRecord', CLRecord);
                
            }
            Account Member = [select id,name from Account where id=:recordId limit 1];
            resultMap.put('Member', Member);
        }
        return resultMap;
    }
    
    @AuraEnabled
    public static map<string,object> getMembers(string recordId){
    	
        list<Person_Account__c> paList = getData(recordId);
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
      
    	return resultmap;
    }

    @AuraEnabled
    public static list<Person_Account__c> getData(string accoutid){
    
    	list<Person_Account__c> paList = new list<Person_Account__c>();
    	Account_Details__c accDetails = [Select Parent_Account__c,RecType__c,RecordType.Name from Account_Details__c where Id=:accoutid Limit 1];
    	List<string> listStringIds = new List<string>();
    	listStringIds.add(accoutid);
    	if(accDetails.Parent_Account__c != null)
    	{
    		listStringIds.add(accDetails.Parent_Account__c);
    		List<Account_Details__c> accDetailsList = [Select Parent_Account__c,RecType__c,RecordType.Name from Account_Details__c where Parent_Account__c=:accDetails.Parent_Account__c];
    		for(Account_Details__c item: accDetailsList )
    		{
    			
    			listStringIds.add(item.id);
    		}
    	}
    	else
	    {
	    	List<Account_Details__c> accDetailsList = [Select Parent_Account__c,RecType__c,RecordType.Name from Account_Details__c where Parent_Account__c=:accDetails.Id];
    		for(Account_Details__c item: accDetailsList )
    		{
    			
    			listStringIds.add(item.id);
    		}
	    }
    	paList = [SELECT Id,
                          Account_Number__c,
                          PersonId__c,
                          PersonID__r.Name,
                          TypeTranslate__c FROM Person_Account__c WHERE Account_Number__c in: listStringIds];
    	
    	
    	AggregateResult[] groupedResults
		  = [SELECT 
                          PersonId__c,
                          PersonID__r.Name acctName,
                          TypeTranslate__c FROM Person_Account__c WHERE Account_Number__c in: listStringIds group by PersonId__c,PersonID__r.Name,TypeTranslate__c ];
    	list<Person_Account__c> paList1 = new list<Person_Account__c>();
    	for (AggregateResult ar : groupedResults)  {
    		Person_Account__c item = new Person_Account__c();
    		item.PersonId__c = (string)ar.get('PersonId__c');
    		item.PersonID__r = new Account();
    		item.PersonID__r.Name = (string)ar.get('acctName');
    		item.TypeTranslate__c = (string)ar.get('TypeTranslate__c');
    		paList1.add(item);
        }
        
    	return paList1;
    }
    
    @AuraEnabled
    public static Map<string,List<CardDetailWrapperObject>> getCard(string recordId, string sObjectType){
    
        system.debug('sObjectType'+sObjectType); 
        system.debug('recordId'+recordId);
        Id uniqueId = recordId;
        Schema.SObjectType objType = uniqueId.getsobjecttype();
       
        Map<string,List<CardDetailWrapperObject>> resultmap = new Map<string,List<CardDetailWrapperObject>>();
        List<CardDetailWrapperObject> resultList = new List<CardDetailWrapperObject>();
        HttpRequest req = new HttpRequest();
        HttpResponse res;
        Http http = new Http();
        string responseBody;
        string loanAPI;
        String jsonData;

        HttpRequest req1 = new HttpRequest();
        HttpResponse res1;
        Http http1 = new Http();
        string responseBody1;
        string isDormant;

        String Type;
        String SSN;
        List<String> CardNumber = new List<String>();
        List<String> CardLocator = new List<String>();
        
        string firstname,lastname;
        List<string> Names = sObjectType.split(' ');
        if(Names.size() == 2){
            firstname = Names[0]+ '%';
            lastname= '%'+Names[1] + '%';
        }
        else if(Names.size() >= 3){
            firstname = Names[0]+ '%';
            lastname= '%'+Names[Names.size()-1] +'%';
        }

        SolarLoan_To_Episys_API_Details__c api = SolarLoan_To_Episys_API_Details__c.getValues('ProductionURL');
                        
        if(api.URL__c != null){
            loanAPI = api.URL__c;
        }

        string AccountNumber;
        Person_Account__c pa;

        if(objType == Account_Details__c.sObjectType){

            if(recordId != null){
                AccountNumber = [Select id, name from account_details__c where id=: recordId].Name;
            }
            else{
                AccountNumber = AccountNumber = [Select id, name from account_details__c where id=: recordId].Name;
            }          
            
            system.debug('AccountNumber'+AccountNumber);

            pa =[SELECT id, name,PersonID__c,Account_Number__c,PersonID__r.name 
                    from Person_Account__c where PersonID__r.firstname like: firstname
                    AND PersonID__r.LASTNAME like: lastname
                    AND Account_Number__r.name =: AccountNumber limit 1];
            
            system.debug('Member - '+pa.PersonID__c);

            Account acc = [select id,name,SSN_TIN_Encrypted__pc from Account where id =:pa.PersonID__c limit 1];
            SSN = acc.SSN_TIN_Encrypted__pc;  
            //SSN = '123456789';

            system.debug('SSN'+SSN);
            
            req1.setEndpoint(loanAPI+'/Account/IsDormantAccount?accountNumber='+accountNumber);
            req1.setMethod('GET');
            req1.setHeader('Content-Type', 'application/json');
            req1.setHeader('Accept', 'application/json');
            req1.setTimeout(60000); 

            if(!Test.isRunningTest()){                       
                res1 = http1.send(req1);
                responseBody1 = res1.getBody();
            }
            else{
                responseBody1 = '{"IsDormant":"false","Status":"OK","Error":"null","ErrorDetails":"null"}';   
            }
            if(responseBody1 !=''){        
                Map<String,Object> results = (Map<String,Object>) JSON.deserializeUntyped(responseBody1);      
                System.debug('Service response is ....' + results);
                if(results.size() > 0){
                    for(String key : results.keySet()){                   			
                        if(key == 'IsDormant'){
                            isDormant = string.valueOf(results.get(key));
                        }
                    }
                }
            }
            system.debug('isDormant : ' + isDormant);
        }
        if(objType == Account.sObjectType){
            
            pa =[SELECT id, name,PersonID__c,Account_Number__c,PersonID__r.name 
                    from Person_Account__c where PersonID__r.firstname like: firstname
                    AND PersonID__r.LASTNAME like: lastname limit 1];
            
            system.debug('Member - '+pa.PersonID__c);

            Account acc = [select id,name,SSN_TIN_Encrypted__pc from Account where id =:pa.PersonID__c limit 1];
            SSN = acc.SSN_TIN_Encrypted__pc;
            //SSN = '123456789';
            system.debug('SSN'+SSN);

        }
     
        //----------------------------------------Checking if Membership is not dormant -----------------------------------------//
        
        if(isDormant != 'true'){

            req.setEndpoint(loanAPI+'/CardLimitReset/GetCards');
            req.setMethod('POST');
            req.setHeader('Content-Type', 'application/json');
            req.setHeader('Accept', 'application/json');
            jsonData = '{"SSN":' + '\"'+ SSN +'\"}';                 
            req.setBodyAsBlob(Blob.valueof(jsonData));
            req.setTimeout(60000);                    
            
            system.debug('Request: '+jsonData);

            if(!Test.isRunningTest()){                       
                res = http.send(req);
                responseBody = res.getBody();
                System.debug('ResponseBody ::'+responseBody);    
            }
            else{
                responseBody = '[{"CardNumber":"5460277067636965","ExpirationDate":"2021-10-01","CloseDate":"","CardOwner":null,"Locator":"33","Status":null,"Error":null,"ErrorDetails":null}]';

            }
            if(responseBody != '' && responseBody != null){        
                List<object> results = (List<Object>) JSON.deserializeUntyped(responseBody);      
                System.debug('Response is ....' + results);
                
                if(results.size() > 0){
                    
                    for(Object key : results){ 
                        CardDetailWrapperObject temp = new CardDetailWrapperObject();
                        Map<String, Object> carddetail = (Map<String, Object>)key;
                        string Card = string.valueof(carddetail.get('CardNumber'));
                        temp.CardNumber =  string.valueof(carddetail.get('CardNumber'));
                        temp.CardLocator =   string.valueof(carddetail.get('Locator'));
                        resultList.add(temp);  
                        system.debug('temp.CardNumber'+temp.CardNumber);
                        system.debug('temp.CardLocator'+temp.CardLocator);
                        system.debug('resultList'+resultList);
                    }
                } 
            }
        }

        resultmap.put('CardList',resultList);
        
		return resultmap;
    }
    @AuraEnabled
    public static Change_Limit__c createCase(Change_Limit__c CLRecord, String cardnumber, String type, String authlimit, String atmlimit, String membername){

        list<CaseRecordType__c> scList = [SELECT Id,
											 Primary_Category__c,
											 Secondary_Category__c,
											 Teritiary_Category__c,
											 Record_Type_Name__c,
											 SLA__c,
                                             RecordTypeId__c FROM CaseRecordType__c WHERE Primary_Category__c = 'Card Services' AND Secondary_Category__c='ATM/DEBIT' AND Teritiary_Category__c='Limit Changes' LIMIT 1];
        
        Case cs = new case();
        for(CaseRecordType__c crt : scList){
            cs.RecordTypeId = scList[0].RecordTypeId__c; 
            cs.Primary_Category__c = scList[0].Primary_Category__c;
            cs.Secondary_Category__c = scList[0].Secondary_Category__c;
            cs.Tertiary_Category__c = scList[0].Teritiary_Category__c;
            cs.Sla__c = scList[0].SLA__c;

        }
        cs.Status = 'Closed';
        cs.Subject = 'Limit Change';
        cs.Description =  'Card Limit Change details: ' +'\n' + '\n' +'Member Name: '+ membername + '\n' + 'Card Number: '+ cardnumber + '\n' + 'Request Type: ' + type + '\n' + 'ATM Usage Limit: ' + atmlimit + '\n' + 'Auth/POS Limit: ' + authlimit + '\n' + 'Change Performed By: '+ UserInfo.getName();
        cs.Account_Number__c = CLRecord.Member_Account__c;
        cs.ownerid = UserInfo.getUserId();
        if(CLRecord.Member__c != null){
            cs.AccountId = CLRecord.Member__c;
        }
        
        insert cs;
        id caseId = cs.id;
        
        CLRecord.Case__c = caseId;
        update CLRecord;
        
        return null;
    }
    @AuraEnabled
    public static Change_Limit__c Submit(string recordId,string cardnumber,string cardlocator,string membername,string type,string authlimit,string atmlimit){ 
        
        system.debug('membername'+membername); 
        system.debug('cardnumber'+cardnumber);
        system.debug('cardlocator'+cardlocator);
        system.debug('type'+type); 
        system.debug('authlimit'+authlimit); 
        system.debug('atmlimit'+atmlimit); 
        system.debug('recordId'+recordId);
        
        Id uniqueId = recordId;
        Schema.SObjectType objType = uniqueId.getsobjecttype();

        HttpRequest req = new HttpRequest();
        HttpResponse res;
        Http http = new Http();
        string responseBody;
        string loanAPI;
        String jsonData;

        HttpRequest req1 = new HttpRequest();
        HttpResponse res1;
        Http http1 = new Http();
        string responseBody1;
        String jsonData1;
        String SSN;
        SolarLoan_To_Episys_API_Details__c api = SolarLoan_To_Episys_API_Details__c.getValues('ProductionURL');
                        
        if(api.URL__c != null){
            loanAPI = api.URL__c;
        }

        string firstname,lastname;
        List<string> Names=membername.split(' ');
        if(Names.size() == 2){
            firstname = Names[0]+ '%';
            lastname= '%'+Names[1] + '%';
        }
        else if(Names.size() >= 3){
            firstname = Names[0]+ '%';
            lastname= '%'+Names[Names.size()-1] +'%';
        }
        
        string AccountNumber;
        Person_Account__c pa;

        if(objType == Account_Details__c.sObjectType){

            if(recordId != null){
                AccountNumber = [Select id, name from account_details__c where id=: recordId].Name;
            }
            else{
                AccountNumber = AccountNumber = [Select id, name from account_details__c where id=: recordId].Name;
            }          
            
            system.debug('AccountNumber'+AccountNumber);

            pa =[SELECT id, name,PersonID__c,Account_Number__c,PersonID__r.name 
                    from Person_Account__c where PersonID__r.firstname like: firstname
                    AND PersonID__r.LASTNAME like: lastname
                    AND Account_Number__r.name =: AccountNumber limit 1];
            
            system.debug('Member - '+pa.PersonID__c);

        }

        
        if(objType == Account.sObjectType){
            
            pa =[SELECT id, name,PersonID__c,Account_Number__c,PersonID__r.name 
                    from Person_Account__c where PersonID__r.firstname like: firstname
                    AND PersonID__r.LASTNAME like: lastname limit 1];
            
            system.debug('Member - '+pa.PersonID__c);

            Account acc = [select id,name,SSN_TIN_Encrypted__pc from Account where id =:pa.PersonID__c limit 1];
            SSN = acc.SSN_TIN_Encrypted__pc;
            //SSN = '123456789';
            system.debug('SSN'+SSN);

            System.debug('GetMemberNumber method called');

            req1.setEndpoint(loanAPI+'/EFT/GetAccountBySSN?ssn='+SSN);
            req1.setMethod('GET');
            req1.setHeader('Content-Type', 'application/json');
            req1.setHeader('Accept', 'application/json');
            req1.setTimeout(60000);

            if(!Test.isRunningTest()){                       
                res1 = http1.send(req1);
                responseBody1 = res1.getBody();
                System.debug('Response Body SolarLoan:'+res1.getBody());    
            }else{
                responseBody1 = '{"Type":"3","Last":"27","First":"1","Street":"1","ExtraAddress":"100","City":"Chicago","State":"IL","ZipCode":"0012345,"BirthDate":"01-01-2019","SSN":"1345","LoanId":"322271627","AccountNumber":"00000123456"}';
                
            }
            
            JSONParser parser = JSON.createParser(responseBody1);
            AccountNumber = String.valueOf(responseBody1).substringAfter('AccountNumber":"');
            AccountNumber = String.valueOf(AccountNumber).substringBefore('",');
            System.debug('Member Number' + AccountNumber);
            Account_Details__c ad = [select id, Name, Brand__c, ID1__c, TypeTranslate__c,RecType__c from Account_Details__c where Name =:AccountNumber Limit 1];
            recordId = ad.id;
        }

        system.debug('recordId'+recordId);

        if(type == 'Change Card Limits'){

            System.debug('Change Card Limits');

            req.setEndpoint(loanAPI+'/CardLimitReset/UpdateCardLimits');
            req.setMethod('POST');
            req.setHeader('Content-Type', 'application/json');
            req.setHeader('Accept', 'application/json');
            jsonData = '{"Locator":' + '\"'+ cardlocator +'\","AccountNumber":' + '\"'+ AccountNumber +'\","PosLimit":' + '\"'+ authlimit +'\","AuthLimit":' + '\"'+ atmlimit +'\"}';                 
            system.debug('test'+jsonData);
            req.setBodyAsBlob(Blob.valueof(jsonData));
            req.setTimeout(60000);                    
            
            system.debug('Request: '+jsonData);

            if(!Test.isRunningTest()){                       
                res = http.send(req);
                responseBody = res.getBody();
                System.debug('ResponseBody ::'+responseBody);    
            }
            else{
                responseBody = '{"Locator":"120","AccountNumber":"0000214414","atmlimit":"5000","AuthLimit":"2500"}';
            }

        }
        if(type == 'Reset Card Limits'){

            System.debug('Reset Card Limits');

            req.setEndpoint(loanAPI+'/CardLimitReset/UpdateCardLimits');
            req.setMethod('POST');
            req.setHeader('Content-Type', 'application/json');
            req.setHeader('Accept', 'application/json');
            jsonData = '{"Locator":' + '\"'+ cardlocator +'\","AccountNumber":' + '\"'+ AccountNumber +'\","PosLimit":' + '\"'+ authlimit +'\","AuthLimit":' + '\"'+ atmlimit +'\"}';                 
            system.debug('test'+jsonData);
            req.setBodyAsBlob(Blob.valueof(jsonData));
            req.setTimeout(60000);                    
            
            system.debug('Request: '+jsonData);

            if(!Test.isRunningTest()){                       
                res = http.send(req);
                responseBody = res.getBody();
                System.debug('ResponseBody ::'+responseBody);    
            }
            else{
                responseBody = '{"Locator":"120","AccountNumber":"0000214414","atmlimit":"5000","AuthLimit":"2500"}';
            }
        }

        system.debug('recordId'+recordId);

        Change_Limit__c cl = new Change_Limit__c();
        cl.Auth_POS_Limit__c = Decimal.valueOf(authlimit);
        cl.ATM_Usage_Limit__c = Decimal.valueOf(atmlimit);
        cl.Card_Number__c = cardnumber;
        cl.Card_Locator__c = cardlocator;
        cl.Type__c = type;
        cl.Member_Name__c = membername;
        cl.Member_Account__c = recordId;
        cl.Member__c = pa.PersonID__c;

        insert cl;
        //createCase(cl,cardnumber,type,authlimit,atmlimit,membername);

        return null;    
    }
    public class CardDetailWrapperObject{

        @AuraEnabled
        public String CardNumber {get;set;}
        @AuraEnabled
        public string CardLocator {get;set;}
          
    }    
}