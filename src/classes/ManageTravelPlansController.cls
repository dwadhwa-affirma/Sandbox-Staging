public class ManageTravelPlansController {  
  
  public class Member360View
  {
    @AuraEnabled
    public object accList {get;set;}
    @AuraEnabled
    public integer totalrecords {get;set;}
    @AuraEnabled
    public string USPhone {get;set;}
    @AuraEnabled
    public string Email {get;set;}
    @AuraEnabled
    public boolean isTravelCard {get;set;}
  }
  
  public class AccountList360
    {
        public string Id {get;set;}
        public string Name {get;set;}
        public string RecType {get;set;}
        public string TypeTranslate {get;set;}
        public string ID1 {get;set;}
        
        public string Brand {get;set;}
        public string Combined_Account_ID {get;set;}
        public string Loan_Number {get;set;}
        public Date Close_Date {get;set;}
        public string Card_Number_Last_4_Digits {get;set;}
        public Date OPEN_DATE {get;set;}
        public Date  Expiration_Date {get;set;}
        public date Issue_Date {get;set;}
        public string Emp_Available_Balance {get;set;}
        public decimal Available_Balance {get;set;}
        public string Emp_Balance {get;set;}
        
        public decimal Balance {get;set;}
        public string Relationship {get;set;}
        public string Card_Number_c {get;set;}
        
        
    }
    
    public class MCOriginalDataWrapper implements Comparable {
        public MCOriginalData obj = new MCOriginalData();    
        public MCOriginalDataWrapper(MCOriginalData op) {
              obj = op;
        }
        public Integer compareTo(Object other) {
            MCOriginalDataWrapper compareToOppy = (MCOriginalDataWrapper)other;       
              Integer returnValue = 0;
              if (obj.FromDate > compareToOppy.obj.FromDate) {                  
                  returnValue = 1;
              } else if (obj.FromDate < compareToOppy.obj.FromDate) {                  
                  returnValue = -1;
              }
      
              return returnValue; 
        }
  }
    
    public class MCOriginalData
    {
      @AuraEnabled
      public Date FromDate {get;set;}
      @AuraEnabled
      public Date ToDate {get;set;}      
      @AuraEnabled
      public string TimeZone {get;set;}
      @AuraEnabled
      public string CardNo {get;set;}
      @AuraEnabled
      public string SegmentName {get;set;}
      @AuraEnabled
      public string Last4Digits {get;set;}
      @AuraEnabled
      public DateTime FromDateTime {get;set;} 
      @AuraEnabled
      public DateTime ToDateTime {get;set;}         
     
    }
    
    public class wrapperObject
    {
      @AuraEnabled
      public MCOriginalData MCOriginalDataObj {get;set;}
      @AuraEnabled
      public Mastercard_Travel__c MasterCardSFObj {get;set;}
    }

    public static string USPhone {get;set;}  
  public static string Email {get;set;}
  public static boolean isTravelCard {get;set;}
  public static Blob key = EncodingUtil.base64Decode('mRMjHmlC1C+1L/Dkz8EJuw==');
  public static Blob IV = Blob.valueof('Mcapipr of IV786');

    /*@AuraEnabled
     public static List<Case> getDetails(string caseId){
       List<Case> tempCase = new List<Case>();       
        //List<Mastercard_Travel__c> objMemberComment = new List<Mastercard_Travel__c>();
        tempCase = [select id,Account_Number__c, AccountId, CreatedBy.Email,Secure_Email__c from case where id =:caseId];
        
        return tempCase;
     }*/
     
      @AuraEnabled
     public static List<wrapperObject> getCurrentTravelPlans(string recordId){     
       List<wrapperObject> finaldataLst = new List<wrapperObject>();         
       List<Account_Details__c> tempAccount = new List<Account_Details__c>();       
        Mastercard_Travel__c MastercardObj = new Mastercard_Travel__c();
        List<Case> tempCase = new List<Case>(); 
        List<Mastercard_Travel__c> ListMastercardObj = new List<Mastercard_Travel__c>();        
        system.debug('recordId====' + recordId);
        string AccountId;
        Member360View cardList;
        Integer PageNo = 1,  PageSize = 10;
        
        tempCase = [select id,Account_Number__c, AccountId, CreatedBy.Email,Secure_Email__c, category__c from case where id =: recordId];
        system.debug('tempCase' + tempCase);        
        
        tempAccount = [Select Id, Name, Parent_Account__c from Account_Details__c where Id=:recordId];
        
        if(tempCase != null && tempCase.size()> 0)
        {
          List<Account> listAccount;         
          
                             
          Account acc = new Account();
          listAccount = [select Id,FirstName,LastName,home_phone__pc,Mobile_Phone__pc,Work_Phone__pc,PersonEmail,Alternate_Email__pc, Email_raw__c from Account where ID =:tempCase[0].AccountId];
                if(listAccount.size() > 0)
                {
                  acc = listAccount[0];
                }
          system.debug('acc1' + acc);
          AccountId = acc.Id;
        }       
        else if(tempAccount != null && tempAccount.size()> 0){                 
          List<Account> listAccount;
          list<Person_Account__c> paList = [SELECT Id,PersonID__c,
                             Account_Number__c, Account_Number__r.RecType__c,TypeTranslate__c, Account_Number__r.Name FROM Person_Account__c WHERE (Account_Number__c  =:tempAccount[0].Id or Account_Number__c  =:tempAccount[0].Parent_Account__c)];
            
            if(paList.size() > 0){                 
          Account acc = new Account();
          listAccount = [select Id,FirstName,LastName,home_phone__pc,Mobile_Phone__pc,Work_Phone__pc,PersonEmail,Alternate_Email__pc, Email_raw__c from Account where ID =:paList[0].PersonID__c ];
                if(listAccount.size() > 0)
                {
                  acc = listAccount[0];
                }  
          
         AccountId =  acc.id;
            }
          
        }   
       else
       {
          AccountId = recordId;
       }
        list<Person_Account__c> paList = [SELECT Id,
                             Account_Number__c, Account_Number__r.RecType__c,TypeTranslate__c, Account_Number__r.Name FROM Person_Account__c WHERE PersonID__c =:AccountId];
        
        List<Account> listAccount; 
        Account acc = new Account();
        listAccount = [select Id,FirstName,LastName,home_phone__pc,Mobile_Phone__pc,Work_Phone__pc,PersonEmail,Alternate_Email__pc, Email_raw__c from Account where ID =:AccountId ];
              if(listAccount.size() > 0)
              {
                acc = listAccount[0];
              }        
        
        List<string> accountNumberSet = new List<string>();
        List<string> accIdset = new List<string>();
        List<string> acctypeSet = new List<string>();
        Map<string,string> listRelationships = new  Map<string,string>(); 
        Map<string,string> listRelationshipsName = new  Map<string,string>();
        for(Person_Account__c var: paList){
            accountNumberSet.add(var.Account_Number__r.Name);
            acctypeSet.add(var.Account_Number__r.RecType__c);
            accIdSet.add(var.Account_Number__c);
            listRelationships.put(var.Account_Number__c,var.TypeTranslate__c);
            listRelationshipsName.put(var.Account_Number__r.Name,var.TypeTranslate__c);
        }
        
        Object accList =  GetAccList(listRelationships,listRelationshipsName,acctypeSet, accountNumberSet, accIdset, 1, 1000, '', '', '');
        
        Member360View localAcc =    (Member360View)accList;
        List<Account_Details__c> listACCList = (List<Account_Details__c>)localAcc.accList;
        List<String> accountNumberSetWOBeneficiary = new List<String>();
        List<String> accIdSetWOBeneficiary = new List<String>();
        
        for(Account_Details__c item: listACCList)
        {
            accountNumberSetWOBeneficiary.add(item.Name);
            accIdSetWOBeneficiary.add(item.id);            
        }  
       
        cardList = (Member360View)GetCardList(accountNumberSetWOBeneficiary,accIdSetWOBeneficiary,acctypeSet,accountNumberSet,accIdset,PageNo,PageSize, '', '', '');
        system.debug('cardList.accList====' + cardList.accList);         
        List<Account_Details__c> lstaccount =(List<Account_Details__c>)cardList.accList;
        List<String> cardIds = new List<String>();
         List<String> cardNos = new List<String>();
        for(Account_Details__c a : lstaccount){
          
            cardIds.add(a.Id); 
            cardNos.add(a.Card_Number__c); 
          
        }
        
        Set<String> uniqueCardNos = new Set<String>();
        uniqueCardNos.addAll(cardNos);
        cardNos.clear();
        cardNos.addAll(uniqueCardNos);
        
        
        
         system.debug('cardNos====' + cardNos); 
          system.debug('cardIds====' + cardIds);
       
        ListMastercardObj = [select id, CardId__c,Case__c,Country__c,Departure_Date__c, Destination__c,Email__c, Return_Date__c, Name,IsEmailPreferred__c, IsPhonePreferred__c, State__c,StateList__c,US_Mobile_Number__c,  CardId__r.Card_Number_Last_4_Digits__c,CardId__r.TypeTranslate__c,Timezone__c, CardId__r.Card_Number__c from Mastercard_Travel__c
                  where CardId__c IN : cardIds];  
        system.debug('ListMastercardObj====' + ListMastercardObj); 
        
        List<MCOriginalData> mcorgdataLst = new List<MCOriginalData>();       
       mcorgdataLst = getMCOrgData(cardNos);   
       
       List<MCOriginalDataWrapper> oppyList = new List<MCOriginalDataWrapper>();
       for(MCOriginalData mo: mcorgdataLst){
         oppyList.add(new MCOriginalDataWrapper(mo));
       }
       oppyList.sort();   
       mcorgdataLst.clear(); 
       
       for(MCOriginalDataWrapper MW : oppyList){
            mcorgdataLst.add(MW.obj);
        }
        for(Mastercard_Travel__c mc : ListMastercardObj){                        
          
          /*if(mc.Country__c != '' && mc.Country__c != null)
          {
            mc.Destination__c = mc.Country__c;
          }
          else
          {
            mc.Destination__c = mc.State__c;
          }   */
          string cardtype= mc.CardId__r.TypeTranslate__c.substring(0, 2);
          if(cardtype == '11' || cardtype == '12'){
            mc.CardId__r.TypeTranslate__c = 'ATM';
          }
          else if(cardtype == '13' || cardtype =='14' || cardtype =='15'){
            mc.CardId__r.TypeTranslate__c = 'DEBIT';
          }
          else if(cardtype == '16' || cardtype =='17'){
             mc.CardId__r.TypeTranslate__c = 'HSA';
          }           
          
          
        }
         
        system.debug('ListMastercardObj====' + ListMastercardObj);   
         system.debug('ListMCOriginalObj====' + mcorgdataLst); 
        
        for(MCOriginalData mo: mcorgdataLst){
          boolean isMatched=false;
          for(Mastercard_Travel__c mc : ListMastercardObj){
            wrapperObject wo = new wrapperObject();            
            if((mc.CardId__r.Card_Number__c == mo.CardNo) && (mc.Departure_Date__c == mo.FromDate) && (mc.Return_Date__c == mo.ToDate) && (isMatched ==false) ){
              wo.MCOriginalDataObj = mo;
              wo.MasterCardSFObj = mc;
              finaldataLst.add(wo);   
              isMatched=true;           
            }            
          }
          if(!isMatched){
            wrapperObject wo = new wrapperObject();    
            wo.MCOriginalDataObj = mo; 
            wo.MasterCardSFObj = new Mastercard_Travel__c();
            wo.MasterCardSFObj.Departure_Date__c = mo.FromDate;  
            wo.MasterCardSFObj.Return_Date__c = mo.ToDate;  
            wo.MasterCardSFObj.Timezone__c = mo.TimeZone; 
            system.debug('wo====' + wo);          
            finaldataLst.add(wo);  
          }
        }
        
        system.debug('finaldataLst====' + finaldataLst); 
        return finaldataLst; 
     }
     
     public static List<MCOriginalData> getMCOrgData(List<String> MCObj){
       List<MCOriginalData> mcorgdataLst = new List<MCOriginalData>();
           
        system.debug('MCObj====' + MCObj); 
       for(string s : MCObj){
         Blob getdata = Blob.valueof('cardnumber=' + s);
         Blob getencrypted = Crypto.encrypt('AES128', key, Iv, getdata);
         string URL = 'https://mcapi.chevronfcu.org/Home/getsegmentation?data=' + EncodingUtil.base64Encode(getencrypted).replace('=',',').replace('/','_').replace('+','-');
         //string URL= 'https://mcapi.chevronfcu.org/Home/index?cardnumber=' + s +'&actionName=get';
          system.debug('URL====' + URL); 
          
         // Blob data = Blob.valueof(URL);
         // Blob encrypted = Crypto.encrypt('AES128', key, Iv, data);
          //String encodedCipherText = EncodingUtil.base64Encode(encrypted);
          //system.debug('encodedCipherText====' + encodedCipherText); 
           
         Http http = new Http();
      HttpRequest request = new HttpRequest();
      request.setEndpoint(URL);
      request.setMethod('GET');
      HttpResponse response = http.send(request);
      system.debug('Response====' + response.getStatusCode()); 
    
      if (response.getStatusCode() == 200) {          
          Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
          system.debug('results====' + results);          
           Map<String, Object> res1 = (Map<String, Object>)results.get('Body');    
           
           if((Map<String, Object>)res1.get('AddSegmentAssignmentOutput') == null){
             
           }
           if((Map<String, Object>)res1.get('GetSegmentAssignmentOutput') != null){               
           Map<String, Object> res2 = (Map<String, Object>)res1.get('GetSegmentAssignmentOutput'); 
          Map<String, Object> res3 = (Map<String, Object>)res2.get('GetSegmentAssignmentResponse'); 
            Map<String, Object> res4 = (Map<String, Object>)res3.get('SegmentAssignmentResponseList'); 
            string CardNo = (string)res3.get('CardNumber'); 
            List<Object> o1 = (List<Object>)res4.get('SegmentAssignmentResponse');
             for (Object o: o1) {
                 MCOriginalData mcorgdataObj = new MCOriginalData(); 
                Map<String, Object> newCast = (Map<String, Object>)o;
                string tempdate =(string)(newCast.get('FromDate'));
                system.debug('tempdate=='+tempdate);
                mcorgdataObj.FromDate=Date.valueOf((tempdate.split('T'))[0]);
                mcorgdataObj.FromDateTime=DateTime.valueOf((tempdate.replace('T',' ')));  
                tempdate =(string)(newCast.get('ToDate'));
               mcorgdataObj.ToDate=Date.valueOf((tempdate.split('T'))[0]);  
               mcorgdataObj.ToDateTime=DateTime.valueOf((tempdate.replace('T',' ')));
    
                          
               mcorgdataObj.TimeZone=(string)newCast.get('TimeZone');
               mcorgdataObj.CardNo=CardNo;
               mcorgdataObj.SegmentName =(string)newCast.get('SegmentationName');
               mcorgdataObj.Last4Digits = CardNo.substring(12);
              system.debug('mcorgdataObj=='+mcorgdataObj);
              mcorgdataLst.add(mcorgdataObj);
            }
           }
         
      }
       }    
     
   
       
       system.debug('mcorgdataLst'+mcorgdataLst);
       return mcorgdataLst;
       
     }
     
      @AuraEnabled
      public static Object getCardDetails(string accid){
        system.debug('accid' + accid);
         string AccountId;
         Integer PageNo = 1,  PageSize = 10;
        List<Case> tempCase = new List<Case>(); 
        List<Account_Details__c> tempAccount = new List<Account_Details__c>();  
        isTravelCard = true;      
         Object cardList;
        tempCase = [select id,Account_Number__c, AccountId, CreatedBy.Email,Secure_Email__c, category__c, Tertiary_Category__c from case where id =: accid];
        system.debug('tempCase' + tempCase);        
        
        tempAccount = [Select Id, Name, Parent_Account__r.name from Account_Details__c where Id=:accid];
     
        
        if(tempCase != null && tempCase.size()> 0)
        {
          List<Account> listAccount;
          if(tempCase[0].Tertiary_Category__c != 'Travel notification')
          {
                  isTravelCard=false;   
                   Member360View card = new Member360View();     
              card.isTravelCard = isTravelCard;
              
                  return card;                                  
          }
          AccountId = tempCase[0].Account_Number__c;   
          Account_Details__c accDRec = [Select Id, Name, Parent_Account__r.name from Account_Details__c where Id=:AccountId Limit 1];
                 
           //list<Person_Account__c> paList = [SELECT Id,PersonID__c,
            //                 Account_Number__c, Account_Number__r.RecType__c,TypeTranslate__c, Account_Number__r.Name FROM Person_Account__c WHERE Account_Number__c  =:AccountId];
                             
          Account acc = new Account();
          listAccount = [select Id,FirstName,LastName,home_phone__pc,Mobile_Phone__pc,Work_Phone__pc,PersonEmail,Alternate_Email__pc, Email_raw__c from Account where ID =:tempCase[0].AccountId ];
                if(listAccount.size() > 0)
                {
                  acc = listAccount[0];
                }
          system.debug('acc1' + acc); 
          
          
          USPhone = acc.Mobile_Phone__pc;
          Email = acc.Email_raw__c;
          
          
          cardList = GetCardListforAccount(accDRec.Name,accDRec.Parent_Account__r.name,PageNo,PageSize, '', '', '');
           system.debug('cardList' + cardList); 
        }
        else if(tempAccount != null && tempAccount.size()> 0)
        {
          List<Account> listAccount;          
          
          list<Person_Account__c> paList = [SELECT Id,PersonID__c,
                             Account_Number__c, Account_Number__r.RecType__c,TypeTranslate__c, Account_Number__r.Name FROM Person_Account__c WHERE Account_Number__c  =:tempAccount[0].Id or Account_Number__c  =:tempAccount[0].Parent_Account__c];
             system.debug('paList==='+paList);       
             if(paList.size() > 0){         
            Account acc = new Account();
            listAccount = [select Id,FirstName,LastName,home_phone__pc,Mobile_Phone__pc,Work_Phone__pc,PersonEmail,Alternate_Email__pc, Email_raw__c from Account where ID =:paList[0].PersonID__c ];
                  if(listAccount.size() > 0)
                  {
                    acc = listAccount[0];
                  }
            system.debug('acc2' + acc); 
            USPhone = acc.Mobile_Phone__pc;
            Email = acc.Email_raw__c;
             }
          
          Account_Details__c accDRec = [Select Id, Name, Parent_Account__r.name from Account_Details__c where Id=:tempAccount[0].Id Limit 1];
          cardList = GetCardListforAccount(accDRec.Name,accDRec.Parent_Account__r.name, PageNo,PageSize, '', '', '');
          system.debug('cardList' + cardList); 
        }
        else
        {
          AccountId = accid;
          list<Person_Account__c> paList = [SELECT Id,
                             Account_Number__c, Account_Number__r.RecType__c,TypeTranslate__c, Account_Number__r.Name FROM Person_Account__c WHERE PersonID__c =:AccountId];
        
        List<Account> listAccount; 
        Account acc = new Account();
        listAccount = [select Id,FirstName,LastName,home_phone__pc,Mobile_Phone__pc,Work_Phone__pc,PersonEmail,Alternate_Email__pc, Email_raw__c from Account where ID =:AccountId ];
              if(listAccount.size() > 0)
              {
                acc = listAccount[0];
              }
        
        USPhone = acc.Mobile_Phone__pc;
        Email = acc.Email_raw__c;
        
        List<string> accountNumberSet = new List<string>();
        List<string> accIdset = new List<string>();
        List<string> acctypeSet = new List<string>();
        Map<string,string> listRelationships = new  Map<string,string>(); 
        Map<string,string> listRelationshipsName = new  Map<string,string>();
        for(Person_Account__c var: paList){
            accountNumberSet.add(var.Account_Number__r.Name);
            acctypeSet.add(var.Account_Number__r.RecType__c);
            accIdSet.add(var.Account_Number__c);
            listRelationships.put(var.Account_Number__c,var.TypeTranslate__c);
            listRelationshipsName.put(var.Account_Number__r.Name,var.TypeTranslate__c);
        }
        
        Object accList =  GetAccList(listRelationships,listRelationshipsName,acctypeSet, accountNumberSet, accIdset, 1, 1000, '', '', '');
        
        Member360View localAcc =    (Member360View)accList;
        List<Account_Details__c> listACCList = (List<Account_Details__c>)localAcc.accList;
        List<String> accountNumberSetWOBeneficiary = new List<String>();
        List<String> accIdSetWOBeneficiary = new List<String>();
        
        for(Account_Details__c item: listACCList)
        {
            accountNumberSetWOBeneficiary.add(item.Name);
            accIdSetWOBeneficiary.add(item.id);
            
        }    

       
        cardList = GetCardList(accountNumberSetWOBeneficiary,accIdSetWOBeneficiary,acctypeSet,accountNumberSet,accIdset,PageNo,PageSize, '', '', '');
        }       
         
       
        return cardList;
     }
      
    @AuraEnabled
    public static List<string> getCountryData()
    {   
                 
        List<Country__c> country = new List<Country__c>();
        country = [select id, Name,Country_Code__c,  Region__c,   Region_Code__c  from Country__c ORDER BY Name ASC];
        
        set<String> uniques = new set<String>();        
        for(Country__c c: country){
            uniques.add(c.Name);
        }               
        
        List<string> strData = new List<string>(); 
        for(string str : uniques)
        {
            strData.add(str.toUpperCase());
        }
        return strData;
    }
      
     private static object GetAccList(Map<string,string> listRelationships,Map<string,string> listRelationshipsName,   List<string> acctypeSet, List<string> accountNumberSet, 
            List<string> accIdset,Integer PageNo, Integer PageSize, string SortBy, string SortDir,string SearchText)
    {
         Integer PageSize_Local = Integer.Valueof( PageSize);
        Integer PageNo_Local = Integer.Valueof( PageNo);
        string orderString = '';
        if(SortBy != '' && SortDir != '')
        {
            orderString = ' Order by ' + SortBy + ' ' + SortDir;    
            
        }        
        string offset = string.valueof( ((PageNo_Local - 1 ) * PageSize_Local));
            AggregateResult[] ARs;
        list<Account_Details__c>  accList = new list<Account_Details__c>();
        string SOQLQuery = '';
        string searchquery = '';
        boolean isDate = false;
        Date dtSearchText;
        if(SearchText != '')
        {
            try{
                dtSearchText = Date.Parse(SearchText);
                string month = string.valueOf(dtSearchText.month());
                string date1 = string.valueOf(dtSearchText.day());
                if(dtSearchText.month() <=9)
                    month = '0' + string.valueOf(dtSearchText.month());
                if(dtSearchText.day() <= 9)
                    date1 = '0' + string.valueOf(dtSearchText.day());
                SearchText = string.valueOf(dtSearchText.year()) + '-' + month + '-' + date1;
                
                searchquery +=  '(Name LIKE \'%' + SearchText + '%\' or RecType__c LIKE \'%' + SearchText + '%\' or Brand__c LIKE \'%' + SearchText + '%\' or TypeTranslate__c LIKE \'%' + SearchText + '%\' or ID1__c LIKE \'%' + SearchText + '%\' or Loan_Number__c LIKE \'%' + SearchText + '%\' or Emp_Available_Balance__c LIKE  \'%' + SearchText + '%\' or Emp_Balance__c LIKE \'%' + SearchText + '%\' or Close_Date__c = '+SearchText+' or  OPEN_DATE__c = '+ SearchText+')';
                isDate = true;
            }
            catch(Exception ex){
                searchquery += '(Name LIKE \'%' + SearchText + '%\' or RecType__c LIKE \'%' + SearchText + '%\' or Brand__c LIKE \'%' + SearchText + '%\' or TypeTranslate__c LIKE \'%' + SearchText + '%\' or ID1__c LIKE \'%' + SearchText + '%\' or Loan_Number__c LIKE \'%' + SearchText + '%\' or Emp_Available_Balance__c LIKE  \'%' + SearchText + '%\' or Emp_Balance__c LIKE \'%' + SearchText + '%\')';
            }
        }
        
        if(checkValueExistsInList(acctypeSet, 'ACCT')){
            
            if(searchquery.length() > 0)
            {
                 SOQLQuery = 'SELECT Id, ' +
                               ' Name, ' +
                              ' RecType__c, ' +
                              ' TypeTranslate__c, ' +
                              ' ID1__c, ' +
                              ' Balance__c, ' +
                              ' Combined_Account_ID__c, ' +
                              ' Brand__c, ' +
                              ' Loan_Number__c, ' +
                              ' Close_Date__c, ' +
                              ' Card_Number_Last_4_Digits__c, ' +
                              ' Card_Number__c, ' +
                              ' OPEN_DATE__c, ' +
                              ' Expiration_Date__c, ' +
                              ' Issue_Date__c, ' +
                              ' Emp_Balance__c, ' +
                              ' Emp_Available_Balance__c, ' +
                              ' Available_Balance__c FROM Account_Details__c WHERE Name IN (\'' + string.join(accountNumberSet,'\',\'') +  '\') and RecType__c != \'CARD\' and ' + searchquery + ' ' +  orderString;
                  string temp = '%' + SearchText + '%';
                  ARs = [SELECT Count(Id)  cnt FROM Account_Details__c WHERE Name IN:accountNumberSet and RecType__c != 'CARD' and (Name LIKE : temp or RecType__c LIKE : temp  or Brand__c LIKE : temp  or TypeTranslate__c LIKE : temp  or ID1__c LIKE : temp  or Loan_Number__c LIKE : temp or Emp_Available_Balance__c LIKE : temp or Emp_Balance__c LIKE : temp)];
                  if(isDate)
                    ARs = [SELECT Count(Id)  cnt FROM Account_Details__c WHERE Name IN:accountNumberSet and RecType__c != 'CARD' and (Name LIKE : temp or RecType__c LIKE : temp  or Brand__c LIKE : temp  or TypeTranslate__c LIKE : temp  or ID1__c LIKE : temp  or Loan_Number__c LIKE : temp or Emp_Available_Balance__c LIKE : temp or Emp_Balance__c LIKE : temp or Close_Date__c =: dtSearchText or OPEN_DATE__c =: dtSearchText)];
            }
            else
            {
                SOQLQuery = 'SELECT Id, ' +
                               ' Name, ' +
                              ' RecType__c, ' +
                              ' TypeTranslate__c, ' +
                              ' ID1__c, ' +
                              ' Balance__c, ' +
                              ' Combined_Account_ID__c, ' +
                              ' Brand__c, ' +
                              ' Loan_Number__c, ' +
                              ' Close_Date__c, ' +
                              ' Card_Number_Last_4_Digits__c, ' +
                              ' Card_Number__c, ' +
                              ' OPEN_DATE__c, ' +
                              ' Expiration_Date__c, ' +
                              ' Issue_Date__c, ' +
                              ' Emp_Balance__c, ' +
                              ' Emp_Available_Balance__c, ' +
                              ' Available_Balance__c FROM Account_Details__c WHERE Name IN (\'' + string.join(accountNumberSet,'\',\'') +  '\') and RecType__c != \'CARD\' ' +  orderString;
                ARs = [SELECT Count(Id)  cnt FROM Account_Details__c WHERE Name IN:accountNumberSet and RecType__c != 'CARD'];
            }
            
        }else{
            
            if(searchquery.length() > 0)
            {
                SOQLQuery = ' SELECT Id, ' +
                              ' Name, ' +
                              '  RecType__c, ' +
                              ' TypeTranslate__c, ' +
                              ' ID1__c, ' +
                              ' Balance__c, ' +
                              ' Combined_Account_ID__c, ' +
                              ' Brand__c, ' +
                              ' Loan_Number__c, ' +
                              ' Close_Date__c, ' +
                              ' Card_Number_Last_4_Digits__c, ' +
                              ' Card_Number__c, ' +
                              ' OPEN_DATE__c, ' +
                              ' Expiration_Date__c, ' +
                              ' Issue_Date__c, ' +
                              ' Emp_Balance__c, ' +
                              ' Emp_Available_Balance__c, ' +
                              ' Available_Balance__c FROM Account_Details__c Where Id IN (\'' + string.join(accIdSet,'\',\'') +  '\') and RecType__c != \'CARD\' and ' + searchquery + ' ' +  orderString;
                
                string temp = '%' + SearchText + '%';               
                ARs  = [SELECT Count(id) cnt FROM Account_Details__c Where Id IN:accIdSet and RecType__c != 'CARD' and (Name LIKE : temp or RecType__c LIKE : temp  or Brand__c LIKE : temp  or TypeTranslate__c LIKE : temp  or ID1__c LIKE : temp  or Loan_Number__c LIKE : temp or Emp_Available_Balance__c LIKE : temp or Emp_Balance__c LIKE : temp)];
                if(isDate)
                    ARs = [SELECT Count(Id)  cnt FROM Account_Details__c WHERE Name IN:accountNumberSet and RecType__c != 'CARD' and (Name LIKE : temp or RecType__c LIKE : temp  or Brand__c LIKE : temp  or TypeTranslate__c LIKE : temp  or ID1__c LIKE : temp  or Loan_Number__c LIKE : temp or Emp_Available_Balance__c LIKE : temp or Emp_Balance__c LIKE : temp or Close_Date__c =: dtSearchText or OPEN_DATE__c =: dtSearchText)];
            }
            else
            {
                SOQLQuery = ' SELECT Id, ' +
                              ' Name, ' +
                              '  RecType__c, ' +
                              ' TypeTranslate__c, ' +
                              ' ID1__c, ' +
                              ' Balance__c, ' +
                              ' Combined_Account_ID__c, ' +
                              ' Brand__c, ' +
                              ' Loan_Number__c, ' +
                              ' Close_Date__c, ' +
                              ' Card_Number_Last_4_Digits__c, ' +
                              ' Card_Number__c, ' +
                              ' OPEN_DATE__c, ' +
                              ' Expiration_Date__c, ' +
                              ' Issue_Date__c, ' +
                              ' Emp_Balance__c, ' +
                              ' Emp_Available_Balance__c, ' +
                              ' Available_Balance__c FROM Account_Details__c Where Id IN (\'' + string.join(accIdSet,'\',\'') +  '\') and RecType__c != \'CARD\' ' +  orderString;
                                
                ARs  = [SELECT Count(id) cnt FROM Account_Details__c Where Id IN:accIdSet and RecType__c != 'CARD'];
            }
            
        }
        
        
        
        List<sObject> sobjList = Database.query(SOQLQuery);
        
        List<AccountList360> listAccountList360 = new List<AccountList360>();
        List<String> AccountListIdSet = new List<String>();
        
        for(sObject acc1 : sobjList)
        {
            Account_Details__c acc = (Account_Details__c)acc1;
            
            AccountList360 obj = new AccountList360();
            obj.Id = acc.Id;
            obj.Name = acc.Name;
            obj.RecType = acc.RecType__c;
            obj.TypeTranslate = acc.TypeTranslate__c;
            obj.Balance = acc.Balance__c;
            obj.ID1 = acc.ID1__c;
            obj.Combined_Account_ID = acc.Combined_Account_ID__c;
            
            obj.Card_Number_Last_4_Digits = acc.Card_Number_Last_4_Digits__c;
            obj.Combined_Account_ID = acc.Combined_Account_ID__c;
            obj.Loan_Number = acc.Loan_Number__c;
            obj.Brand = acc.Brand__c;
            obj.Loan_Number = acc.Loan_Number__c;
            obj.Close_Date = acc.Close_Date__c;
            obj.Expiration_Date = acc.Expiration_Date__c;
            obj.OPEN_DATE = acc.OPEN_DATE__c;
            obj.Issue_Date = acc.Issue_Date__c;
            obj.Emp_Balance = acc.Emp_Balance__c;
            obj.Emp_Available_Balance = acc.Emp_Available_Balance__c;
            obj.Available_Balance = acc.Available_Balance__c;
            obj.Card_Number_c = acc.Card_Number__c;
            if(acctypeSet.contains('ACCT')){
                obj.Relationship = listRelationshipsName.get(obj.Name);         
                
            }
            else
            {
                obj.Relationship = listRelationships.get(obj.Id);
            }
            
            
            if(obj.Relationship != null && !obj.Relationship.contains('Beneficiary'))
            {
                listAccountList360.add(obj);
                AccountListIdSet.Add(obj.Id);   
                accList.add(acc);
            }    
        
        }
        
      
      if(AccountListIdSet.size() > 0)
      {  
      
                SOQLQuery = ' SELECT Id, ' +
                              ' Name, ' +
                              '  RecType__c, ' +
                              ' TypeTranslate__c, ' +
                              ' ID1__c, ' +
                              ' Balance__c, ' +
                              ' Combined_Account_ID__c, ' +
                              ' Brand__c, ' +
                              
                              ' Loan_Number__c, ' +
                              ' Close_Date__c, ' +
                              ' Card_Number_Last_4_Digits__c, ' +
                              ' Card_Number__c, ' +
                              ' OPEN_DATE__c, ' +
                              ' Expiration_Date__c, ' +
                              ' Issue_Date__c, ' +
                              ' Card_Name__c, ' +
                              ' Emp_Balance__c, ' +
                              ' Emp_Available_Balance__c, ' +
                              ' Available_Balance__c FROM Account_Details__c Where Id IN (\'' + string.join(AccountListIdSet,'\',\'') +  '\') ' +  orderString + ' LIMIT  ' + string.valueOf( PageSize_Local) + ' OFFSET ' +  offset;
                                
              sobjList = Database.query(SOQLQuery);
                
                for(sObject acc : sobjList)
                {
                     Account_Details__c acc1 = (Account_Details__c)acc;
                    
                    if(acctypeSet.contains('ACCT')){
                        acc1.Card_Name__c = listRelationshipsName.get(acc1.Name);           
                        
                    }
                    else
                    {
                        acc1.Card_Name__c = listRelationships.get(acc1.Id);
                    }
                    
                }
                
                Member360View test = new Member360View();
                test.accList = sobjList;
                test.totalrecords = AccountListIdSet.size();
                return test;
     
      } 
      else
      {
         Member360View test = new Member360View();
            test.accList = new List<Account_Details__c>();
            
            
                test.totalrecords = 0;
                return test;
        
      }
        
        
       
    
    }
    
    private static boolean checkValueExistsInList(List<string> listValues, string value)
    {
        
        for(string item: listvalues)
        {
            if(item == value)
            {
                return true;
            }           
        }
        return false;
    }
    
    private static object GetCardList(List<String> accountNumberSetWOBeneficiary, List<String> accIdSetWOBeneficiary,List<string> acctypeSet, List<string> accountNumberSet, List<string> accIdset,Integer PageNo, Integer PageSize, string SortBy, string SortDir,string SearchText)
    {
        Integer PageSize_Local = Integer.Valueof( PageSize);
        Integer PageNo_Local = Integer.Valueof( PageNo);
        
        string orderString = '';
        if(SortBy != '' && SortDir != '')
        {
            orderString = ' Order by ' + SortBy + ' ' + SortDir;    
            
        }        
        string offset = string.valueof( ((PageNo_Local - 1 ) * PageSize_Local));
            AggregateResult[] ARs;
        string SOQLQuery = '';      
        string searchquery = '';
        if(SearchText != '')
        {
            searchquery += '(Name LIKE \'%' + SearchText + '%\' or Card_Number_Last_4_Digits__c LIKE \'%' + SearchText + '%\' or Brand__c LIKE \'%' + SearchText + '%\' or TypeTranslate__c LIKE \'%' + SearchText + '%\' or Card_Name__c LIKE \'%' + SearchText + '%\')';
        }
        
       if(checkValueExistsInList(acctypeSet, 'ACCT')){
            if(searchquery.length() > 0)
            {
                SOQLQuery = 'SELECT Id, ' +
                              'Name, ' +
                              'Card_Number__c, ' +
                              'RecType__c, ' +
                              'TypeTranslate__c, ' +
                              'ID1__c, ' +
                              'Balance__c, ' +
                              'Combined_Account_ID__c, ' +
                              'Brand__c, ' +
                              'Loan_Number__c, ' +
                              'Close_Date__c, ' +
                              'Card_Number_Last_4_Digits__c, ' +
                              'OPEN_DATE__c, ' +
                              'Expiration_Date__c, ' +
                              'Issue_Date__c, ' +
                              'Emp_Balance__c, ' +
                              'Card_Name__c FROM Account_Details__c Where Status1__c = \'1 Issued\' and Expiration_Date__c >= TODAY and Close_Date__c = null and Name IN (\'' + string.join(accountNumberSetWOBeneficiary,'\',\'') +  '\') and RecType__c = \'CARD\' and ' + searchquery + ' ' +  orderString +  '   LIMIT  ' + string.valueOf( PageSize_Local) + ' OFFSET ' +  offset;
                              
                string temp = '%' + SearchText + '%';               
                ARs  = [SELECT Count(id) cnt FROM Account_Details__c Where Name IN:accountNumberSet and RecType__c = 'CARD' and (Name LIKE : temp or Card_Number_Last_4_Digits__c LIKE : temp  or Brand__c LIKE : temp  or TypeTranslate__c LIKE : temp  or Card_Name__c LIKE : temp)];
            }
            else
            {
                SOQLQuery = 'SELECT Id, ' +
                              'Name, ' +
                              'Card_Number__c, ' +
                              'RecType__c, ' +
                              'TypeTranslate__c, ' +
                              'ID1__c, ' +
                              'Balance__c, ' +
                              'Combined_Account_ID__c, ' +
                              'Brand__c, ' +
                              'Loan_Number__c, ' +
                              'Close_Date__c, ' +
                              'Card_Number_Last_4_Digits__c, ' +
                              'OPEN_DATE__c, ' +
                              'Expiration_Date__c, ' +
                              'Issue_Date__c, ' +
                              'Emp_Balance__c, ' +
                              'Card_Name__c FROM Account_Details__c Where Status1__c = \'1 Issued\' and Expiration_Date__c >= TODAY and Close_Date__c = null and Name IN (\'' + string.join(accountNumberSetWOBeneficiary,'\',\'') +  '\') and RecType__c = \'CARD\' ' +  orderString +  '   LIMIT  ' + string.valueOf( PageSize_Local) + ' OFFSET ' +  offset;
                              
              ARs  = [SELECT Count(id) cnt FROM Account_Details__c Where Name IN:accountNumberSet and RecType__c = 'CARD'];
            }
            
        }else{
            if(searchquery.length() > 0)
            {
                SOQLQuery = 'SELECT Id, ' +
                              'Name, ' +
                              'Card_Number__c, ' +
                              'RecType__c, ' +
                              'TypeTranslate__c, ' +
                              'ID1__c, ' +
                              'Balance__c, ' +
                              'Combined_Account_ID__c, ' +
                              'Brand__c, ' +
                              'Loan_Number__c, ' +
                              'Close_Date__c, ' +
                              'Card_Number_Last_4_Digits__c, ' +
                              'OPEN_DATE__c, ' +
                              'Expiration_Date__c, ' +
                              'Issue_Date__c, ' +
                              'Emp_Balance__c, ' +
                              'Card_Name__c FROM Account_Details__c Where Status1__c = \'1 Issued\' and Expiration_Date__c >= TODAY and Close_Date__c = null and Name IN (\'' + string.join(accIdSetWOBeneficiary,'\',\'') +  '\') and RecType__c = \'CARD\' and ' + searchquery + ' ' +  orderString +  '   LIMIT  ' + string.valueOf( PageSize_Local) + ' OFFSET ' +  offset;
                        
                        string temp = '%' + SearchText + '%';
                        ARs  = [SELECT Count(id) cnt FROM Account_Details__c Where Id IN:accIdSet and RecType__c = 'CARD' and (Name LIKE : temp or Card_Number_Last_4_Digits__c LIKE : temp  or Brand__c LIKE : temp  or TypeTranslate__c LIKE : temp  or Card_Name__c LIKE : temp)];
            }
            else
            {
                SOQLQuery = 'SELECT Id, ' +
                              'Name, ' +
                              'Card_Number__c, ' +
                              'RecType__c, ' +
                              'TypeTranslate__c, ' +
                              'ID1__c, ' +
                              'Balance__c, ' +
                              'Combined_Account_ID__c, ' +
                              'Brand__c, ' +
                              'Loan_Number__c, ' +
                              'Close_Date__c, ' +
                              'Card_Number_Last_4_Digits__c, ' +
                              'OPEN_DATE__c, ' +
                              'Expiration_Date__c, ' +
                              'Issue_Date__c, ' +
                              'Emp_Balance__c, ' +
                              'Card_Name__c FROM Account_Details__c Where Status1__c = \'1 Issued\' and Expiration_Date__c >= TODAY and Close_Date__c = null and Name IN (\'' + string.join(accIdSetWOBeneficiary,'\',\'') +  '\') and RecType__c = \'CARD\' ' +  orderString +  '   LIMIT  ' + string.valueOf( PageSize_Local) + ' OFFSET ' +  offset;
                                       
                        ARs  = [SELECT Count(id) cnt FROM Account_Details__c Where Id IN:accIdSet and RecType__c = 'CARD'];
            }
            
        }
        
        system.debug('SOQLQuery=='+SOQLQuery);
        List<Account_Details__c> cardList = Database.query(SOQLQuery);      
        for(Account_Details__c card : cardList){
            List<AggregateResult> countResult =[select Count(Id) from CFCU_Mastercard_Alerts__c  where Card_Number__c =: card.Card_Number_Last_4_Digits__c and Member_Number__c =: card.Name ];
             integer countCardRecords = (Integer)  countResult [0].get('expr0');
             if(countCardRecords > 0)
             {
                card.Onboarded__c = true;
             }
             else
             {
                card.Onboarded__c = false;       
             }
       }    
        Member360View card = new Member360View();
        card.accList = cardList;
        card.totalrecords = Integer.Valueof( ARs[0].get('cnt'));
        card.USPhone = USPhone;
        card.Email = Email;
        card.isTravelCard = isTravelCard;
        return card;
    
    }
    
    @AuraEnabled
    public static void saveTravelNotification(string id, string selectedCards,string traveldetailsobj, string result){
      system.debug('id===='+id);
      system.debug('traveldetailsobj===='+traveldetailsobj);      
      system.debug('selectedCards===='+selectedCards);
      system.debug('result===='+result);
      List<Mastercard_Travel__c> traveldetails = (List<Mastercard_Travel__c>)JSON.deserialize(traveldetailsobj, List<Mastercard_Travel__c>.class);
      List<case> tempCase = new List<case>();         
    List<Account_Details__c> tempAccount = new List<Account_Details__c>();  
    Account accq = new Account();
    List<case> CasestoClose = new List<case>();       
    List<Mastercard_Travel__c> ListMastercardObj = new List<Mastercard_Travel__c>();   
    string Timezone = 'America/Los_Angeles';
    
    string[] res = result.split('\\;');

      
      tempCase = [select id,Brand__c, ContactId, Account_Number__c, AccountId, CreatedBy.Email,Primary_Category__c, Secondary_Category__c ,Tertiary_Category__c
                       from case where id =:id];
            system.debug('tempCase===' + tempCase);
           
            tempAccount = [Select Id, Name from Account_Details__c where Id=:id];
                        
            if(tempCase != null && tempCase.Size() > 0)
            {
              
             List<Account> listAccount = new List<Account>();                    
            Account acc = new Account();
            listAccount = [select Id,FirstName,LastName,home_phone__pc,Mobile_Phone__pc,Work_Phone__pc,PersonEmail,Alternate_Email__pc, Email_raw__c from Account where ID =:tempCase[0].AccountId];
                if(listAccount.size() > 0)
                {
                  accq = listAccount[0];
                }      
               //accq = [select id, FirstName, LastName from account where id =: id];
               list<string> scards = (list<string>)JSON.deserialize(selectedCards, list<string>.class);
               boolean isupdate =false;
              for(string str: scards)              
               {        
                 string caseDescription='';
                string cardString = '';
                Account_Details__c ac = [Select Id, Name, Card_Number__c, Card_Number_Last_4_Digits__c, TypeTranslate__c from Account_Details__c where Id=:str];
                  if(ac != null){                  
                    
                      string cardtype= ac.TypeTranslate__c.substring(0, 2);
                    if(cardtype == '11' || cardtype == '12'){
                      cardString = 'ATM';
                    }
                    else if(cardtype == '13' || cardtype =='14' || cardtype =='15'){
                      cardString = 'DEBIT';
                    }
                    else if(cardtype == '16' || cardtype =='17'){
                       cardString = 'HSA';
                    }  
                    cardString = cardString + ' - ' +  (ac.Card_Number_Last_4_Digits__c);
                    }
          
                for(Mastercard_Travel__c td: traveldetails){

                boolean exist = isExist(res, ac.Card_Number__c,  td.Country__c, td.State__c);
                if(exist)   {
                  
                
                    
                    datetime ddate= Datetime.valueof(td.Departure_Date__c + ' 00:00:00');
                    datetime rdate= Datetime.valueof(td.Return_Date__c + ' 00:00:00');
                
                    caseDescription = caseDescription + ' ' + (ddate.format('MMM dd, yyyy')) + ' ' + (rdate.format('MMM dd, yyyy'));
                    if(td.Destination__c == 'Domestic')
                        {
                          caseDescription = caseDescription + ' ' + td.State__c;
                        }
                        else
                        {
                          caseDescription = caseDescription + ' ' + td.Country__c;
                        }
                      caseDescription = caseDescription + ' America/Los_Angeles ' + cardString + '\n';
                  
                  tempCase[0].Description =caseDescription;
                  isupdate =true;
                    Mastercard_Travel__c finaltraveldetails = new Mastercard_Travel__c();
                   finaltraveldetails.Case__c =  id;//caseobj.id;
                   finaltraveldetails.CardId__c = str; 
                   finaltraveldetails.Timezone__c = td.Timezone__c;
                   if(td.Destination__c == 'Domestic')
                      {
                        finaltraveldetails.State__c = td.State__c;
                      }
                      else
                      {
                        finaltraveldetails.Country__c = td.Country__c;
                      }
                    finaltraveldetails.Departure_Date__c = td.Departure_Date__c;
                    finaltraveldetails.Destination__c = td.Destination__c;
                    finaltraveldetails.Email__c = td.Email__c;
                    finaltraveldetails.Return_Date__c = td.Return_Date__c;
                    finaltraveldetails.US_Mobile_Number__c = td.US_Mobile_Number__c;
                    finaltraveldetails.IsPhonePreferred__c = td.IsPhonePreferred__c;
                    finaltraveldetails.IsEmailPreferred__c = td.IsEmailPreferred__c;
                    finaltraveldetails.Timezone__c = Timezone;
                    try{ 
                          
                  insert finaltraveldetails;
                  ListMastercardObj.add(finaltraveldetails);
                   System.debug('travel Deatils created :' + finaltraveldetails);          
                   }catch (exception e)  {           
                   System.debug('An error occured while inserting case :' + e);                 
                  }  
                }
               }      
               }
          QueueSObject QueueID = [Select Queue.Id, Queue.Name, Queue.Type from QueueSObject WHERE Queue.Type ='Queue' AND Queue.Name =: 'Travel Notification Queue' Limit 1];
      if (QueueID.id   != null){        
                   tempCase[0].OwnerId = QueueID.Queue.Id;
           }               
             try{
                 if(isupdate)
                update tempCase[0];
                 }
                catch(Exception e){
                    System.debug('Exception: ' + e);
                     }               
            }  
            
            else if(tempAccount != null && tempAccount.Size() > 0){
              List<Account> listAccount;    
                
          list<Person_Account__c> paList = [SELECT Id,PersonID__c,
                             Account_Number__c, Account_Number__r.RecType__c,TypeTranslate__c, Account_Number__r.Name FROM Person_Account__c WHERE Account_Number__c  =:tempAccount[0].Id];
            
            Account acc = new Account();
            if(paList.size() > 0){               
          
          listAccount = [select Id,FirstName,LastName,home_phone__pc,Mobile_Phone__pc,Work_Phone__pc,PersonEmail,Alternate_Email__pc, Email_raw__c from Account where ID =:paList[0].PersonID__c ];
                if(listAccount.size() > 0)
                {
                  acc = listAccount[0];
                }          
          
            accq = acc;
            }
          
              list<string> scards = (list<string>)JSON.deserialize(selectedCards, list<string>.class);
         
              for(string str: scards)              
               {
                 string successCase = '';   
                 boolean isCreate = false;
                 Account_Details__c ac = [Select Id, Name, Card_Number__c, Card_Number_Last_4_Digits__c, TypeTranslate__c from Account_Details__c where Id=:str];
                 for(Mastercard_Travel__c td: traveldetails){
                    boolean exist = isExist(res, ac.Card_Number__c,  td.Country__c, td.State__c);
                    system.debug('e:'+exist);
                   if(exist)   {
                     isCreate = true;
                   }
                 }
                   
                 
                Case caseobj = new Case();
                caseobj.Primary_Category__c = 'Card services';
                caseobj.Secondary_Category__c = 'ATM-Debit';
                caseobj.Tertiary_Category__c = 'Travel notification';
                string caseDescription='';
                string cardString = '';
                
                
                if(ac != null){                  
                
                  string cardtype= ac.TypeTranslate__c.substring(0, 2);
                if(cardtype == '11' || cardtype == '12'){
                  cardString = 'ATM';
                }
                else if(cardtype == '13' || cardtype =='14' || cardtype =='15'){
                  cardString = 'DEBIT';
                }
                else if(cardtype == '16' || cardtype =='17'){
                   cardString = 'HSA';
                }  
                cardString = cardString + ' - ' +  (ac.Card_Number_Last_4_Digits__c);
                }
                
                list<CaseRecordType__c> scList = [SELECT Id,
                                                   Primary_Category__c,
                                                   Secondary_Category__c,
                                                   Teritiary_Category__c,
                                                   Record_Type_Name__c,
                                                   RecordTypeId__c FROM CaseRecordType__c WHERE Primary_Category__c =:caseobj.Primary_Category__c AND Secondary_Category__c=:caseobj.Secondary_Category__c AND Teritiary_Category__c=:caseobj.Tertiary_Category__c LIMIT 1];
                                                   
                                                   
                  List<Contact> clist = [SELECT Id, Name FROM Contact WHERE Contact.AccountId =:acc.Id];   
                  
                for(CaseRecordType__c crt : scList){
                caseobj.RecordTypeId = scList[0].RecordTypeId__c;
                caseobj.Primary_Category__c = scList[0].Primary_Category__c;
                caseobj.Secondary_Category__c = scList[0].Secondary_Category__c;
                caseobj.Tertiary_Category__c = scList[0].Teritiary_Category__c; }           
                caseobj.Brand__c = 'CFCU';
                caseobj.AccountId = acc.Id;
                if(cList.size() > 0)
                caseobj.ContactId = cList[0].Id;  
                caseobj.Account_Number__c  = tempAccount[0].Id;  
                QueueSObject QueueID = [Select Queue.Id, Queue.Name, Queue.Type from QueueSObject WHERE Queue.Type ='Queue' AND Queue.Name =: 'Travel Notification Queue' Limit 1];        
          caseobj.OwnerId = QueueID.Queue.Id;
          //caseobj.Description =caseDescription;
          
               try{ 
                 if(isCreate){
                   insert caseobj;
                   successCase = caseobj.id;
                 }
                   System.debug('Case created :' + caseobj.Id);            
                   }catch (exception e)  {           
                   System.debug('An error occured while inserting case :' + e);                   
                  
                  }   
                  
              for(Mastercard_Travel__c td: traveldetails){
                boolean exist = isExist(res, ac.Card_Number__c,  td.Country__c, td.State__c);
                 System.debug('exist' + exist); 
                  System.debug('C' + td.Country__c);
                   System.debug('S' +  td.State__c);
                if(exist) 
                {                
                  
                  datetime ddate= Datetime.valueof(td.Departure_Date__c + ' 00:00:00');
                  datetime rdate= Datetime.valueof(td.Return_Date__c + ' 00:00:00');
              
                  caseDescription = caseDescription + ' ' + (ddate.format('MMM dd, yyyy')) + ' ' + (rdate.format('MMM dd, yyyy'));
                  if(td.Destination__c == 'Domestic')
                      {
                        caseDescription = caseDescription + ' ' + td.State__c;
                      }
                      else
                      {
                        caseDescription = caseDescription + ' ' + td.Country__c;
                      }
                    caseDescription = caseDescription + ' America/Los_Angeles ' + cardString + '\n';
                
                
                    Mastercard_Travel__c finaltraveldetails = new Mastercard_Travel__c();
                   finaltraveldetails.Case__c =  caseobj.id;
                   finaltraveldetails.CardId__c = str; 
                   if(td.Destination__c == 'Domestic')
                      {
                        finaltraveldetails.State__c = td.State__c;
                      }
                      else
                      {
                        finaltraveldetails.Country__c = td.Country__c;
                      }
                    finaltraveldetails.Departure_Date__c = td.Departure_Date__c;
                    finaltraveldetails.Destination__c = td.Destination__c;
                    finaltraveldetails.Email__c = td.Email__c;
                    finaltraveldetails.Return_Date__c = td.Return_Date__c;
                    finaltraveldetails.US_Mobile_Number__c = td.US_Mobile_Number__c;                   
                    finaltraveldetails.IsPhonePreferred__c = td.IsPhonePreferred__c;
                    finaltraveldetails.IsEmailPreferred__c = td.IsEmailPreferred__c;
                    finaltraveldetails.Timezone__c = Timezone;
                   
                  insert finaltraveldetails;
                  ListMastercardObj.add(finaltraveldetails);
                      
                }
                 
                    
                   
                }
                system.debug('successCase==='+successCase);
                if(successCase != null && successCase != ''){
                  
                      
                      system.debug('caseDescription==='+caseDescription);
                      case c = [select id, Description from case where id =: successCase];
                      system.debug('case==='+c);
                      c.Description =caseDescription;
                      update c;
                    
                  
                }
                             
              
               } 
            }
            else
            {
              accq = [select id, FirstName, LastName, Email_raw__c from account where id =: id];
               list<string> scards = (list<string>)JSON.deserialize(selectedCards, list<string>.class);
               Id maccountid;
             list<Person_Account__c> paList = [SELECT Id,
                             Account_Number__c, Account_Number__r.RecType__c,TypeTranslate__c, Account_Number__r.Name FROM Person_Account__c WHERE PersonID__c =:id and Account_Number__r.RecType__c =: 'ACCT'];
                if(paList.size() > 0){
                  maccountid = paList[0].Account_Number__c;
                }
                string successCase = '';
              for(string str: scards)              
               {
                 boolean isCreate = false;
                 Account_Details__c ac = [Select Id, Name, Card_Number__c, Card_Number_Last_4_Digits__c, TypeTranslate__c from Account_Details__c where Id=:str];
                 for(Mastercard_Travel__c td: traveldetails){
                    boolean exist = isExist(res, ac.Card_Number__c,  td.Country__c, td.State__c);
                    system.debug('e:'+exist);
                   if(exist)   {
                     isCreate = true;
                   }
                 }
                                 
                Case caseobj = new Case();
                caseobj.Primary_Category__c = 'Card services';
                caseobj.Secondary_Category__c = 'ATM-Debit';
                caseobj.Tertiary_Category__c = 'Travel notification';
                string caseDescription='';
                string cardString = '';
                
                
                if(ac != null){                  
                
                  string cardtype= ac.TypeTranslate__c.substring(0, 2);
                if(cardtype == '11' || cardtype == '12'){
                  cardString = 'ATM';
                }
                else if(cardtype == '13' || cardtype =='14' || cardtype =='15'){
                  cardString = 'DEBIT';
                }
                else if(cardtype == '16' || cardtype =='17'){
                   cardString = 'HSA';
                }  
                cardString = cardString + ' - ' +  (ac.Card_Number_Last_4_Digits__c);
                }
                
                  
                
                list<CaseRecordType__c> scList = [SELECT Id,
                                                   Primary_Category__c,
                                                   Secondary_Category__c,
                                                   Teritiary_Category__c,
                                                   Record_Type_Name__c,
                                                   RecordTypeId__c FROM CaseRecordType__c WHERE Primary_Category__c =:caseobj.Primary_Category__c AND Secondary_Category__c=:caseobj.Secondary_Category__c AND Teritiary_Category__c=:caseobj.Tertiary_Category__c LIMIT 1];
                                                   
                                                   
                   List<Contact> clist = [SELECT Id, Name FROM Contact WHERE Contact.AccountId =:id];  
                
                for(CaseRecordType__c crt : scList){
                caseobj.RecordTypeId = scList[0].RecordTypeId__c;
                caseobj.Primary_Category__c = scList[0].Primary_Category__c;               
               }           
                caseobj.Brand__c = 'CFCU';
                caseobj.AccountId = id;
                caseobj.ContactId = cList[0].Id;    
                caseobj.Account_Number__c = maccountid;
                QueueSObject QueueID = [Select Queue.Id, Queue.Name, Queue.Type from QueueSObject WHERE Queue.Type ='Queue' AND Queue.Name =: 'Travel Notification Queue' Limit 1];        
          caseobj.OwnerId = QueueID.Queue.Id;    
          //caseobj.Description =caseDescription;      
    
               try{ 
                 if(isCreate)
                   insert caseobj;
                   System.debug('Case created :' + caseobj);  
                    successCase = caseobj.id;          
                   }catch (exception e)  {           
                   System.debug('An error occured while inserting case :' + e);                   
                  
                  }  
                
               
                for(Mastercard_Travel__c td: traveldetails){
                boolean exist = isExist(res, ac.Card_Number__c,  td.Country__c, td.State__c);
                 System.debug('exist' + exist); 
                  System.debug('C' + td.Country__c);
                   System.debug('S' +  td.State__c);
                if(exist)   {
                    datetime ddate= Datetime.valueof(td.Departure_Date__c + ' 00:00:00');
                    datetime rdate= Datetime.valueof(td.Return_Date__c + ' 00:00:00');
                
                    caseDescription = caseDescription + ' ' + (ddate.format('MMM dd, yyyy')) + ' ' + (rdate.format('MMM dd, yyyy'));
                    if(td.Destination__c == 'Domestic')
                        {
                          caseDescription = caseDescription + ' ' + td.State__c;
                        }
                        else
                        {
                          caseDescription = caseDescription + ' ' + td.Country__c;
                        }
                      caseDescription = caseDescription + ' America/Los_Angeles ' + cardString + '\n';
                
                      Mastercard_Travel__c finaltraveldetails = new Mastercard_Travel__c();
                     finaltraveldetails.Case__c =  caseobj.id;
                     finaltraveldetails.CardId__c = str; 
                     if(td.Destination__c == 'Domestic')
                        {
                          finaltraveldetails.State__c = td.State__c;
                        }
                        else
                        {
                          finaltraveldetails.Country__c = td.Country__c;
                        }
                      finaltraveldetails.Departure_Date__c = td.Departure_Date__c;
                      finaltraveldetails.Destination__c = td.Destination__c;
                      finaltraveldetails.Email__c = td.Email__c;
                      finaltraveldetails.Return_Date__c = td.Return_Date__c;
                      finaltraveldetails.US_Mobile_Number__c = td.US_Mobile_Number__c;
                      finaltraveldetails.IsPhonePreferred__c = td.IsPhonePreferred__c;
                      finaltraveldetails.Timezone__c = Timezone;
                      finaltraveldetails.IsEmailPreferred__c = td.IsEmailPreferred__c;                   
                    insert finaltraveldetails;
                    ListMastercardObj.add(finaltraveldetails);
                   
                    }
                
                  
                }
                system.debug('successCase==='+successCase);
                if(successCase != null && successCase != ''){
                  
                      
                      system.debug('caseDescription==='+caseDescription);
                      case c = [select id, Description from case where id =: successCase];
                      system.debug('case==='+c);
                      c.Description =caseDescription;
                      update c;
                    
                  
                }
                              
                    
                  
               }
               
                   
            }
            
            if(ListMastercardObj.size() > 0){
              date minFromdate, maxTodate;
              minFromdate = ListMastercardObj[0].Departure_Date__c;
                maxTodate = ListMastercardObj[0].Return_Date__c;
              for(Mastercard_Travel__c mc:ListMastercardObj){                
                if(mc.Departure_Date__c < minFromdate){
                  minFromdate = mc.Departure_Date__c;
                }
                if(mc.Return_Date__c > maxTodate){
                  maxTodate = mc.Return_Date__c;
                }             
              }
             if(ListMastercardObj.size() > 0){         
               
               if(ListMastercardObj[0].IsEmailPreferred__c){
                   SendTravelNotificationEmail(accq, minFromdate, maxTodate, ListMastercardObj);  
               }
               if(ListMastercardObj[0].IsPhonePreferred__c){                 
                 SendTravelNotificationSMS(accq, minFromdate, maxTodate, ListMastercardObj);                   
               }
             }
                
              
            }  
      
        
            
          
    
    }
    
  /*  private static void CloseCase(List<Case> CasestoClose){
    
    }*/
    
    private static object GetCardListforAccount(String accRecName,string parentaccount, Integer PageNo, Integer PageSize, string SortBy, string SortDir,string SearchText)
  {
    Integer PageSize_Local = Integer.Valueof( PageSize);
        Integer PageNo_Local = Integer.Valueof( PageNo);
        
    string orderString = '';
        if(SortBy != '' && SortDir != '')
        {
          orderString = ' Order by ' + SortBy + ' ' + SortDir;  
          
        }        
    string offset = string.valueof( ((PageNo_Local - 1 ) * PageSize_Local));
          AggregateResult[] ARs;
        string SOQLQuery = '';    
        string searchquery = '';
        if(SearchText != '')
        {
          searchquery += '(Name LIKE \'%' + SearchText + '%\' or Card_Number_Last_4_Digits__c LIKE \'%' + SearchText + '%\' or Brand__c LIKE \'%' + SearchText + '%\' or TypeTranslate__c LIKE \'%' + SearchText + '%\' or Card_Name__c LIKE \'%' + SearchText + '%\')';
        }
        
      
           if(searchquery.length() > 0)
          {
            SOQLQuery = 'SELECT Id, ' +
                              'Name, ' +
                              'RecType__c, ' +
                              'TypeTranslate__c, ' +
                              'ID1__c, ' +
                              'Balance__c, ' +
                              'Combined_Account_ID__c, ' +
                              'Brand__c, ' +
                              'Loan_Number__c, ' +
                              'Close_Date__c, ' +
                              'Card_Number_Last_4_Digits__c, ' +
                              'Card_Number__c, ' +
                              'OPEN_DATE__c, ' +
                              'Expiration_Date__c, ' +
                              'Issue_Date__c, ' +
                              'Emp_Balance__c, ' +
                              'Card_Name__c FROM Account_Details__c Where Status1__c = \'1 Issued\' and Expiration_Date__c >= TODAY and Close_Date__c = null AND (Name = \'' + accRecName +  '\' or Name = \'' +  parentaccount  + '\') and RecType__c = \'CARD\' and ' + searchquery + ' ' +  orderString +  '   LIMIT  ' + string.valueOf( PageSize_Local) + ' OFFSET ' +  offset;
                
                string temp = '%' + SearchText + '%';        
        ARs  = [SELECT Count(id) cnt FROM Account_Details__c Where Name =:accRecName and RecType__c = 'CARD' and (Name LIKE : temp or Card_Number_Last_4_Digits__c LIKE : temp  or Brand__c LIKE : temp  or TypeTranslate__c LIKE : temp  or Card_Name__c LIKE : temp)];
          }
          else
          {
            SOQLQuery = 'SELECT Id, ' +
                              'Name, ' +
                              'RecType__c, ' +
                              'TypeTranslate__c, ' +
                              'ID1__c, ' +
                              'Balance__c, ' +
                              'Combined_Account_ID__c, ' +
                              'Brand__c, ' +
                              'Loan_Number__c, ' +
                              'Close_Date__c, ' +
                              'Card_Number_Last_4_Digits__c, ' +  
                              'Card_Number__c, ' +
                              'OPEN_DATE__c, ' +
                              'Expiration_Date__c, ' +
                              'Issue_Date__c, ' +
                              'Emp_Balance__c, ' +
                              'Card_Name__c FROM Account_Details__c Where Status1__c = \'1 Issued\' and Expiration_Date__c >= TODAY and Close_Date__c = null AND (Name = \'' + accRecName + '\' or Name = \'' +  parentaccount  + '\') and RecType__c = \'CARD\' ' +  orderString +  '   LIMIT  ' + string.valueOf( PageSize_Local) + ' OFFSET ' +  offset;
                
              ARs  = [SELECT Count(id) cnt FROM Account_Details__c Where Name =:accRecName and RecType__c = 'CARD'];
          }
        
    
    system.debug('SOQLQuery---' + SOQLQuery);
    List<Account_Details__c> cardList = Database.query(SOQLQuery);    
    for(Account_Details__c card : cardList){
      List<AggregateResult> countResult =[select Count(Id) from CFCU_Mastercard_Alerts__c  where Card_Number__c =: card.Card_Number_Last_4_Digits__c and Member_Number__c =: card.Name ];
       integer countCardRecords = (Integer)  countResult [0].get('expr0');
       if(countCardRecords > 0)
       {
               card.Onboarded__c = true;
       }
       else
       {
         card.Onboarded__c = false;     
       }
       }   
        Member360View card = new Member360View();
        card.accList = cardList;
        card.totalrecords = Integer.Valueof( ARs[0].get('cnt'));
        card.USPhone = USPhone;
        card.Email = Email;
        card.isTravelCard = isTravelCard;
        return card;
  
  }
    
    private static void SendTravelNotificationEmail(Account acc, date FromDate, date ToDate,List<Mastercard_Travel__c> successAPIList)
    {
      string body='';
      try{
        list<Person_Account__c> paList = [SELECT Id,Brand__c,
                               Account_Number__c, Account_Number__r.RecType__c,TypeTranslate__c, Account_Number__r.Name FROM Person_Account__c WHERE PersonID__c =:acc.Id];
          List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
          Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
          List<String> sendTo = new List<String>();
          //sendTo.add(acc.Email_raw__c);
          sendTo.add(successAPIList[0].Email__c);
          mail.setToAddresses(sendTo);
          string templatenAME = '';
          if(paList[0].Brand__c == 'Spectrum')
            templatenAME ='Spectrum Travel Notification';
          else
            templatenAME ='CFCU Travel Notification';
          List<EmailTemplate> listEmailTemplate =  [select Id,Name,Body,Subject from EmailTemplate where Name =: templatenAME];
          
          mail.setSubject(listEmailTemplate[0].Subject);
          
          
        /*  string emailadd;
          if(Brand == 'Spectrum')
          {
            emailadd = 'noreply@spectrumcu.org';
          }
          else
          {
            emailadd = 'noreply@chevronfcu.org';
          }
          
          List<OrgWideEmailAddress> listAdd = [select Id,Address,DisplayName  from OrgWideEmailAddress where Address =: emailadd];*/
          Datetime fdt = datetime.newInstance(FromDate.year(), FromDate.month(),FromDate.day());
          String fdateStr =  fdt.format('MM/dd/yy');
          Datetime tdt = datetime.newInstance(ToDate.year(), ToDate.month(),ToDate.day());
          String tdateStr =  tdt.format('MM/dd/yy') ;
          body = listEmailTemplate[0].body.replace('$MemberName', acc.FirstName + ' '  + acc.LastName).replace('$StartDate', fdateStr).replace('$EndDate', tdateStr);
  
          mail.setPlainTextBody(body);
         // mail.setOrgWideEmailAddressId(listAdd[0].Id);
          mails.add(mail);
          
          Messaging.sendEmail(mails);
          List<MasterCard_Travel_Confirmation__c> mctcList = new List<MasterCard_Travel_Confirmation__c>();
          map<string, string> accIds = new map<string, string>();
          for(Mastercard_Travel__c mc: successAPIList){
            Account_Details__c ac1 =[select id, Card_Number__c from Account_Details__c where id =: mc.CardId__c limit 1]; 
            accIds.put(ac1.Card_Number__c,   mc.Case__c);
          }
          
          for(string s: accIds.keySet()){
            MasterCard_Travel_Confirmation__c mctc = new MasterCard_Travel_Confirmation__c();
            mctc.Case__c = accIds.get(s);  
               if(successAPIList[0].IsEmailPreferred__c){
            mctc.isSuccessEmail__c = true;               
               }     
               
               mctc.Card_Number__c = s; 
               mctc.Message__c = 'Email';
               mctc.Message_SentTo__c = successAPIList[0].Email__c;
               mctc.Message_Text__c = body;    
               mctcList.add(mctc);  
          }
                 
          /*for(Mastercard_Travel__c mc: successAPIList){
            Account_Details__c ac1 =[select Card_Number__c from Account_Details__c where id =: mc.CardId__c limit 1];                            
            MasterCard_Travel_Confirmation__c mctc = new MasterCard_Travel_Confirmation__c();  
               mctc.Case__c = mc.Case__c;  
               if(successAPIList[0].IsEmailPreferred__c){
            mctc.isSuccessEmail__c = true;               
               }     
               
               mctc.Card_Number__c = ac1.Card_Number__c; 
               mctc.Message__c = 'Email';
               mctc.Message_SentTo__c = acc.Email_raw__c;
               mctc.Message_Text__c = body;    
               mctcList.add(mctc);           
             }*/
             insert mctcList;
      }
      catch(exception e){
         List<MasterCard_Travel_Confirmation__c> mctcList = new List<MasterCard_Travel_Confirmation__c>();
         map<string, string> accIds = new map<string, string>();
          for(Mastercard_Travel__c mc: successAPIList){
            Account_Details__c ac1 =[select id, Card_Number__c from Account_Details__c where id =: mc.CardId__c limit 1]; 
            accIds.put(ac1.Card_Number__c,   mc.Case__c);
          }
          
          for(string s: accIds.keySet()){
            MasterCard_Travel_Confirmation__c mctc = new MasterCard_Travel_Confirmation__c();
            mctc.Case__c = accIds.get(s);  
               if(successAPIList[0].IsEmailPreferred__c){
            mctc.isSuccessEmail__c = true;               
               }     
               
               mctc.Card_Number__c = s; 
               mctc.Message__c = 'Email';
               mctc.Message_SentTo__c = successAPIList[0].Email__c;
               mctc.Message_Text__c = body;    
               mctcList.add(mctc);  
          }
             insert mctcList;
      }
        
    }
    
    @AuraEnabled
    public static List<String> getTimeZone(){   
        List<String> options = new List<String>();
        Schema.DescribeFieldResult fieldResult = Mastercard_Travel__c.Timezone__c.getDescribe();
        List<Schema.PicklistEntry> pList = fieldResult.getPicklistValues();
        for (Schema.PicklistEntry p: pList) {
            options.add(p.getValue());
        }
        return options;
    }
    
    @AuraEnabled
    public static List<String> getStateData(){      
        List<String> options = new List<String>();
        Schema.DescribeFieldResult fieldResult = Mastercard_Travel__c.State__c.getDescribe();
        List<Schema.PicklistEntry> pList = fieldResult.getPicklistValues();
        for (Schema.PicklistEntry p: pList) {
            options.add(p.getLabel());
        }
        return options;
    }
    
     @AuraEnabled
     public static string updateCurrentTravelPlans(string mcObjString){ 
       system.debug('mcObj===='+mcObjString);
       wrapperObject mcObj = (wrapperObject)JSON.deserialize(mcObjString, wrapperObject.class);
        boolean isDestinationchanged = false;
        string segmentationname='';
        string Timezone = 'America/Los_Angeles';
        string result='';
         
       List<Mastercard_Travel__c> tempMCObj = new List<Mastercard_Travel__c>();
       if(mcObj.MasterCardSFObj.id != null){   
          tempMCObj = [select id, CardId__c,Case__c,Country__c,Departure_Date__c, Destination__c,Email__c, Return_Date__c, Name,IsEmailPreferred__c, IsPhonePreferred__c, State__c,StateList__c,US_Mobile_Number__c,  CardId__r.Card_Number_Last_4_Digits__c,CardId__r.TypeTranslate__c,Timezone__c, CardId__r.Card_Number__c from Mastercard_Travel__c
                  where id =: mcObj.MasterCardSFObj.id];
          }
       
        if(mcObj.MasterCardSFObj.Destination__c != null){
          if(mcObj.MasterCardSFObj.Destination__c == 'Domestic'){
                   States__c states = [select id, Region_Code__c, Region_Name__c, State_Code__c, Name, Travel_Category__c from States__c where Name =: mcObj.MasterCardSFObj.State__c limit 1];                   
                   segmentationname= states.Region_Name__c;
                   system.debug('segmentationname=='+segmentationname);
          }
      else
          {
                   List<Country__c> country = [select id, Country_Code__c, Name, Region__c, Region_Code__c from Country__c where Name =: mcObj.MasterCardSFObj.Country__c limit 1];
                   if(country.size() > 0){               
                   segmentationname= country[0].Region__c;
                   }
                   system.debug('segmentationname=='+segmentationname);
          }
          
        }
      
        if(mcObj.MCOriginalDataObj.SegmentName != segmentationname){
          isDestinationchanged = true;
        }       
        
        if(isDestinationchanged)
        {
          Blob deletedata = Blob.valueof('cardnumber='+ mcObj.MCOriginalDataObj.CardNo + ',fromdate=' + FormatdateTime(mcObj.MCOriginalDataObj.FromDateTime) + ',todate=' + FormatdateTime(mcObj.MCOriginalDataObj.ToDateTime) + ',SegmentationName=' + mcObj.MCOriginalDataObj.SegmentName + ',TimeZone=' +  mcObj.MCOriginalDataObj.TimeZone);
         Blob deleteencrypted = Crypto.encrypt('AES128', key, Iv, deletedata);
          string URL = 'https://mcapi.chevronfcu.org/Home/deletesegmentation?data=' + EncodingUtil.base64Encode(deleteencrypted).replace('=',',').replace('/','_').replace('+','-');
          // string URL='https://mcapi.chevronfcu.org/Home/index?cardnumber='+ mcObj.MCOriginalDataObj.CardNo + '&fromdate=' + FormatdateTime(mcObj.MCOriginalDataObj.FromDateTime) + '&todate=' + FormatdateTime(mcObj.MCOriginalDataObj.ToDateTime) + '&SegmentationName=' + EncodingUtil.urlEncode(mcObj.MCOriginalDataObj.SegmentName, 'UTF-8') + '&TimeZone=' +  mcObj.MCOriginalDataObj.TimeZone  +'&actionName=delete';
         
         system.debug('DeleteURL====' + URL); 
         Http http = new Http();
      HttpRequest request = new HttpRequest();
      request.setEndpoint(URL);
      request.setMethod('GET');
      HttpResponse response = http.send(request);
      system.debug('Response====' + response.getStatusCode()); 
      if (response.getStatusCode() == 200) {
                 Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());         
                   Map<String, Object> res1 = (Map<String, Object>)results.get('Body');    
                   if((Map<String, Object>)res1.get('DeleteSegmentAssignmentOutput') != null){           
                      Object o1 = (Object)res1.get('DeleteSegmentAssignmentOutput');                                                                          
                       Map<String, Object> newCast = (Map<String, Object>)o1;
                       string ErrorCode =(string)(newCast.get('ErrorCode'));                            
                     system.debug('ErrorCode=='+ErrorCode);    
                     if(ErrorCode != null)  
                     result= result + ' ' + ErrorCode;                                 
                                                 
                   }        
            }    
      
      Blob adddata = Blob.valueof('cardnumber='+ mcObj.MCOriginalDataObj.CardNo + ',fromdate=' + Formatdate(mcObj.MasterCardSFObj.Departure_Date__c) + ',todate=' + Formatdate(mcObj.MasterCardSFObj.Return_Date__c) + ',SegmentationName=' + segmentationname + ',TimeZone=' + mcObj.MCOriginalDataObj.TimeZone);
         Blob addencrypted = Crypto.encrypt('AES128', key, Iv, adddata);
         URL = 'https://mcapi.chevronfcu.org/Home/addsegmentation?data=' + EncodingUtil.base64Encode(addencrypted).replace('=',',').replace('/','_').replace('+','-');
      //URL='https://mcapi.chevronfcu.org/Home/index?cardnumber='+ mcObj.MCOriginalDataObj.CardNo + '&fromdate=' + Formatdate(mcObj.MasterCardSFObj.Departure_Date__c) + '&todate=' + Formatdate(mcObj.MasterCardSFObj.Return_Date__c) + '&SegmentationName=' + EncodingUtil.urlEncode(segmentationname, 'UTF-8') + '&TimeZone=' + mcObj.MCOriginalDataObj.TimeZone +'&actionName=add';    
      system.debug('AddURL====' + URL);
      http = new Http();
      request = new HttpRequest();
      request.setEndpoint(URL);
      request.setMethod('GET');
      response = http.send(request);
      system.debug('Response====' + response.getStatusCode());
      if (response.getStatusCode() == 200) {
                 Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());         
                   Map<String, Object> res1 = (Map<String, Object>)results.get('Body');    
                   if((Map<String, Object>)res1.get('AddSegmentAssignmentOutput') != null){           
                      Object o1 = (Object)res1.get('AddSegmentAssignmentOutput');                                                                          
                       Map<String, Object> newCast = (Map<String, Object>)o1;
                       string ErrorCode =(string)(newCast.get('ErrorCode'));                            
                     system.debug('ErrorCode=='+ErrorCode);    
                     if(ErrorCode != null)  
                     result=  result + ' ' + ErrorCode;                                       
                   }        
            }    
        }
        else
        {
          Blob updatedata = Blob.valueof('cardnumber='+ mcObj.MCOriginalDataObj.CardNo + ',fromdate=' + FormatdateTime(mcObj.MCOriginalDataObj.FromDateTime) + ',todate=' + FormatdateTime(mcObj.MCOriginalDataObj.ToDateTime) + ',s=' + segmentationname + ',t=' +  mcObj.MCOriginalDataObj.TimeZone  +',n=' + Formatdate(mcObj.MasterCardSFObj.Departure_Date__c) + ',w=' + Formatdate(mcObj.MasterCardSFObj.Return_Date__c) );
          Blob updateencrypted = Crypto.encrypt('AES128', key, Iv, updatedata);
          string URL = 'https://mcapi.chevronfcu.org/Home/updatesegmentation?data=' + EncodingUtil.base64Encode(updateencrypted).replace('=',',').replace('/','_').replace('+','-');
          
           //string URL='https://mcapi.chevronfcu.org/Home/index?cardnumber='+ mcObj.MCOriginalDataObj.CardNo + '&fromdate=' + FormatdateTime(mcObj.MCOriginalDataObj.FromDateTime) + '&todate=' + FormatdateTime(mcObj.MCOriginalDataObj.ToDateTime) + '&SegmentationName=' + EncodingUtil.urlEncode(segmentationname, 'UTF-8') + '&TimeZone=' +  mcObj.MCOriginalDataObj.TimeZone  +'&actionName=update&newfromdate=' + Formatdate(mcObj.MasterCardSFObj.Departure_Date__c) + '&newtodate=' + Formatdate(mcObj.MasterCardSFObj.Return_Date__c) + '&newTimeZone=America/Los_Angeles';
         
         system.debug('UpdateURL====' + URL); 
         Http http = new Http();
      HttpRequest request = new HttpRequest();
      request.setEndpoint(URL);
      request.setMethod('GET');
      HttpResponse response = http.send(request);
      system.debug('Response====' + response.getStatusCode()); 
      if (response.getStatusCode() == 200) {
                 Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());         
                   Map<String, Object> res1 = (Map<String, Object>)results.get('Body');    
                   if((Map<String, Object>)res1.get('UpdateSegmentAssignmentOutput') != null){           
                      Object o1 = (Object)res1.get('UpdateSegmentAssignmentOutput');                                                                          
                       Map<String, Object> newCast = (Map<String, Object>)o1;
                       string ErrorCode =(string)(newCast.get('ErrorCode'));                            
                     system.debug('ErrorCode=='+ErrorCode);    
                     if(ErrorCode != null)  
                     result=  result + ' ' + ErrorCode;  
                               
                                                 
                   }        
            }    
        }
        
       return result;
     }
     
      @AuraEnabled
     public static void updateSFCurrentTravelPlans(string mcObjString){ 
       system.debug('mcObj===='+mcObjString);
       wrapperObject mcObj = (wrapperObject)JSON.deserialize(mcObjString, wrapperObject.class);
        boolean isDestinationchanged = false;
        string segmentationname='';
        string Timezone = 'America/Los_Angeles';
         
       List<Mastercard_Travel__c> tempMCObj = new List<Mastercard_Travel__c>();
       if(mcObj.MasterCardSFObj.id != null){   
          tempMCObj = [select id, CardId__c,Case__c,Country__c,Departure_Date__c, Destination__c,Email__c, Return_Date__c, Name,IsEmailPreferred__c, IsPhonePreferred__c, State__c,StateList__c,US_Mobile_Number__c,  CardId__r.Card_Number_Last_4_Digits__c,CardId__r.TypeTranslate__c,Timezone__c, CardId__r.Card_Number__c from Mastercard_Travel__c
                  where id =: mcObj.MasterCardSFObj.id];
          }
       
    if(tempMCObj.size() > 0 ){
       tempMCObj[0].Departure_Date__c = mcObj.MasterCardSFObj.Departure_Date__c;
          tempMCObj[0].Return_Date__c = mcObj.MasterCardSFObj.Return_Date__c;
          tempMCObj[0].State__c = mcObj.MasterCardSFObj.State__c;
          tempMCObj[0].Country__c = mcObj.MasterCardSFObj.Country__c;      
          
          update tempMCObj;
         // SendTravelNotificationEmail(accq, mcObj.MasterCardSFObj.Departure_Date__c, mcObj.MasterCardSFObj.Return_Date__c, tempMCObj);  
          
    }
        
        
       
     }
     
     @AuraEnabled
     public static string deleteCurrentTravelPlans(string mcObjString){ 
       system.debug('mcObj===='+mcObjString);
       boolean todelete=false;
       wrapperObject mcObj = (wrapperObject)JSON.deserialize(mcObjString, wrapperObject.class);
       List<Mastercard_Travel__c> tempMCObj = new List<Mastercard_Travel__c>();
        string Timezone = 'America/Los_Angeles';
         string segmentationname='';
         string result='';
        
         system.debug('mcObj==='+mcObj.MasterCardSFObj.id); 
        if(mcObj.MasterCardSFObj.id != null){ 
         
        tempMCObj = [select id, CardId__c,Case__c,Country__c,Departure_Date__c, Destination__c,Email__c, Return_Date__c, Name,IsEmailPreferred__c, IsPhonePreferred__c, State__c,StateList__c,US_Mobile_Number__c,  CardId__r.Card_Number_Last_4_Digits__c,CardId__r.TypeTranslate__c,Timezone__c, CardId__r.Card_Number__c from Mastercard_Travel__c
                  where Id =: mcObj.MasterCardSFObj.id];      
                  
                  system.debug('tempMCObj==='+tempMCObj); 
         if(tempMCObj.size() >0){             
           todelete=true;
         }
        }
        
         
         Blob deletedata = Blob.valueof('cardnumber='+ mcObj.MCOriginalDataObj.CardNo + ',fromdate=' + FormatdateTime(mcObj.MCOriginalDataObj.FromDateTime) + ',todate=' + FormatdateTime(mcObj.MCOriginalDataObj.ToDateTime) + ',SegmentationName=' + mcObj.MCOriginalDataObj.SegmentName + ',TimeZone=' +  mcObj.MCOriginalDataObj.TimeZone);
       Blob deleteencrypted = Crypto.encrypt('AES128', key, Iv, deletedata);
        string URL = 'https://mcapi.chevronfcu.org/Home/deletesegmentation?data=' + EncodingUtil.base64Encode(deleteencrypted).replace('=',',').replace('/','_').replace('+','-');
        
        //string URL='https://mcapi.chevronfcu.org/Home/index?cardnumber='+ mcObj.MCOriginalDataObj.CardNo + '&fromdate=' + FormatdateTime(mcObj.MCOriginalDataObj.FromDateTime) + '&todate=' + FormatdateTime(mcObj.MCOriginalDataObj.ToDateTime) + '&SegmentationName=' + EncodingUtil.urlEncode(mcObj.MCOriginalDataObj.SegmentName, 'UTF-8') + '&TimeZone=' +  mcObj.MCOriginalDataObj.TimeZone  +'&actionName=delete';
         //string URL= 'https://mcapi.chevronfcu.org/Home/index?cardnumber=' + s.CardId__r.Card_Number__c +'&actionName=get';
          system.debug('URL====' + URL); 
         // URL = EncodingUtil.urlEncode(URL, 'UTF-8');
           system.debug('URL====' + URL); 
         Http http = new Http();
      HttpRequest request = new HttpRequest();
      request.setEndpoint(URL);
      request.setMethod('GET');
      HttpResponse response = http.send(request);
      system.debug('Response====' + response.getStatusCode()); 
    
            if (response.getStatusCode() == 200) {
                 Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
                 system.debug('results====' + results);          
                   Map<String, Object> res1 = (Map<String, Object>)results.get('Body');    
                   if((Map<String, Object>)res1.get('DeleteSegmentAssignmentOutput') != null){           
                      Object o1 = (Object)res1.get('DeleteSegmentAssignmentOutput');                                                                          
                       Map<String, Object> newCast = (Map<String, Object>)o1;
                       string ErrorCode =(string)(newCast.get('ErrorCode'));                            
                     system.debug('ErrorCode=='+ErrorCode);    
                     if(ErrorCode != null)  
                     result= ErrorCode;
                     else{
                       if(todelete){
                      delete tempMCObj;
                      }
                     }              
                                                 
                   }        
            }      
      
           return result;
     }
     
      @AuraEnabled
    public static List<string> MCAPICallout(string id, string selectedCards,string traveldetailsobj){
      
      List<Mastercard_Travel__c> traveldetails = (List<Mastercard_Travel__c>)JSON.deserialize(traveldetailsobj, List<Mastercard_Travel__c>.class);          
    system.debug('traveldetails====' + traveldetails); 
    Account accq = new Account();    
    List<Mastercard_Travel__c> ListMastercardObj = new List<Mastercard_Travel__c>(); 
    string Timezone = 'America/Los_Angeles';
    List<string> Result = new List<string>();
    List<case> tempCase = new List<case>();         
    List<Account_Details__c> tempAccount = new List<Account_Details__c>();
    tempCase = [select id,Brand__c, ContactId, Account_Number__c, AccountId, CreatedBy.Email,Primary_Category__c, Secondary_Category__c ,Tertiary_Category__c
                       from case where id =:id];
        system.debug('tempCase===' + tempCase);           
        tempAccount = [Select Id, Name, Parent_Account__c from Account_Details__c where Id=:id];
        if(tempCase != null && tempCase.size()> 0){
          List<Account> listAccount = new List<Account>();                    
          Account acc = new Account();
          listAccount = [select Id,FirstName,LastName,home_phone__pc,Mobile_Phone__pc,Work_Phone__pc,PersonEmail,Alternate_Email__pc, Email_raw__c from Account where ID =:tempCase[0].AccountId];
                if(listAccount.size() > 0)
                {
                  accq = listAccount[0];
                }       
        }
        else if(tempAccount != null && tempAccount.size()> 0){
          List<Account> listAccount;
          list<Person_Account__c> paList = [SELECT Id,PersonID__c,
                             Account_Number__c, Account_Number__r.RecType__c,TypeTranslate__c, Account_Number__r.Name FROM Person_Account__c WHERE (Account_Number__c  =:tempAccount[0].Id or Account_Number__c  =:tempAccount[0].Parent_Account__c)];
            
            if(paList.size() > 0){                 
          Account acc = new Account();
          listAccount = [select Id,FirstName,LastName,home_phone__pc,Mobile_Phone__pc,Work_Phone__pc,PersonEmail,Alternate_Email__pc, Email_raw__c from Account where ID =:paList[0].PersonID__c ];
            
                if(listAccount.size() > 0)
                {
                  accq = listAccount[0];
                } 
            }
                  
         
        }
        else
        {
          accq = [select id, FirstName, LastName, Email_raw__c from account where id =: id];
        }
         
         list<string> scards = (list<string>)JSON.deserialize(selectedCards, list<string>.class);
         List<Mastercard_Travel__c> successAPIList = new List<Mastercard_Travel__c>();
         //List<Mastercard_Travel__c> successAPISMSList = new List<Mastercard_Travel__c>();
         Set<Mastercard_Travel__c> uniqueset = new Set<Mastercard_Travel__c>();
         
             
              for(string str: scards)              
               {                 
                
                for(Mastercard_Travel__c td: traveldetails){
                    Mastercard_Travel__c finaltraveldetails = new Mastercard_Travel__c();
                  
                   finaltraveldetails.CardId__c = str;
                   
                    finaltraveldetails.Departure_Date__c = td.Departure_Date__c;                   
                    finaltraveldetails.Return_Date__c = td.Return_Date__c;                    
                    finaltraveldetails.Timezone__c = td.Timezone__c;   
                    finaltraveldetails.Destination__c = td.Destination__c;
                    finaltraveldetails.State__c = td.State__c;
                    finaltraveldetails.Country__c = td.Country__c;  
                    finaltraveldetails.IsEmailPreferred__c = td.IsEmailPreferred__c; 
                    finaltraveldetails.IsPhonePreferred__c = td.IsPhonePreferred__c;         
                  
                  ListMastercardObj.add(finaltraveldetails);                  
                }  
               }
               
               system.debug('ListMastercardObj=='+ListMastercardObj);
             for(Mastercard_Travel__c mc: ListMastercardObj){   
               Account_Details__c ac =[select Card_Number__c from Account_Details__c where id =: mc.CardId__c limit 1];
                system.debug('ac=='+ac);
                system.debug('mc=='+mc);
                system.debug('mc.Country__c=='+mc.Country__c);
               string segmentationname='';
               string dest ='';
               if(mc.Destination__c == 'Domestic'){
                   States__c states = [select id, Region_Code__c, Region_Name__c, State_Code__c, Name, Travel_Category__c from States__c where Name =: mc.State__c limit 1];
                   system.debug('states=='+states);
                   segmentationname= states.Region_Name__c;
                   system.debug('segmentationname=='+segmentationname);
                   dest = mc.State__c;
               }
               else
               {
                   List<Country__c> country = [select id, Country_Code__c, Name, Region__c, Region_Code__c from Country__c where Name =: mc.Country__c limit 1];
                   system.debug('country=='+country);
                   dest = mc.Country__c;
                   if(country.size() > 0){
                     segmentationname= country[0].Region__c;
                   }
                   system.debug('segmentationname=='+segmentationname);
               }
               Blob adddata = Blob.valueof('cardnumber='+ ac.Card_Number__c + ',fromdate=' + Formatdate(mc.Departure_Date__c) + ',todate=' + Formatdate(mc.Return_Date__c) + ',SegmentationName=' + segmentationname + ',TimeZone=' + Timezone);
             Blob addencrypted = Crypto.encrypt('AES128', key, Iv, adddata);
             string URL = 'https://mcapi.chevronfcu.org/Home/addsegmentation?data=' + EncodingUtil.base64Encode(addencrypted).replace('=',',').replace('/','_').replace('+','-');
                  //  string URL='https://mcapi.chevronfcu.org/Home/index?cardnumber='+ ac.Card_Number__c + '&fromdate=' + Formatdate(mc.Departure_Date__c) + '&todate=' + Formatdate(mc.Return_Date__c) + '&SegmentationName=' + EncodingUtil.urlEncode(segmentationname, 'UTF-8') + '&TimeZone=' + Timezone +'&actionName=add';
                 //string URL= 'https://mcapi.chevronfcu.org/Home/index?cardnumber=' + s.CardId__r.Card_Number__c +'&actionName=get';
                 system.debug('URL====' + URL); 
                 Http http = new Http();
              HttpRequest request = new HttpRequest();
              request.setEndpoint(URL);
              request.setMethod('GET');
              HttpResponse response = http.send(request);
              system.debug('Response====' + response.getStatusCode()); 
              if (response.getStatusCode() == 200) {          
                  Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
                  system.debug('results====' +results);         
                   Map<String, Object> res1 = (Map<String, Object>)results.get('Body');    
                   if((Map<String, Object>)res1.get('AddSegmentAssignmentOutput') != null){           
                      Object o1 = (Object)res1.get('AddSegmentAssignmentOutput');                                                                          
                       Map<String, Object> newCast = (Map<String, Object>)o1;
                       string ErrorCode =(string)(newCast.get('ErrorCode'));                            
                     system.debug('ErrorCode=='+ErrorCode);    
                     if(ErrorCode != null)    
                      Result.add(ac.Card_Number__c + ', '+ dest +'|' +ErrorCode);                  
                                                      
                        else
                        {
                          successAPIList.add(mc);
                          Result.add(ac.Card_Number__c + ','+ dest +'|' + '');  
                          //SendTravelNotificationEmail(accq, mc.Departure_Date__c, mc.Return_Date__c);
                        }
                   }
                   else{
                      Result.add(ac.Card_Number__c + ','+ dest +'| : Unexpected Server Error' );  
                   }
                 }  
             } 
             system.debug('traveldetails==='+traveldetails);   
              system.debug('successAPIEmailList==='+successAPIList);   
               system.debug('Result==='+Result);   
             date minFromdate, maxTodate;
           /*  if(successAPIList.size() > 0){
               minFromdate = successAPIList[0].Departure_Date__c;
                maxTodate = successAPIList[0].Return_Date__c;
             for(Mastercard_Travel__c mc: successAPIList){
                
                if(mc.Departure_Date__c < minFromdate){
                  minFromdate = mc.Departure_Date__c;
                }
                if(mc.Return_Date__c > maxTodate){
                  maxTodate = mc.Return_Date__c;
                }
             }
             
             if(successAPIList.size() > 0){         
               
               if(successAPIList[0].IsEmailPreferred__c){
                   SendTravelNotificationEmail(accq, minFromdate, maxTodate, successAPIList);  
               }
               if(successAPIList[0].IsPhonePreferred__c){                 
                 //SendTravelNotificationSMS(accq, minFromdate, maxTodate, successAPIList);                   
               }
             }

             }*/
             
                    
      /*  for(Mastercard_Travel__c td: traveldetails){
                for(Mastercard_Travel__c mc: successAPISMSList){
                    if(td.Departure_Date__c == mc.Departure_Date__c && td.Return_Date__c == mc.Return_Date__c){
                      //SendTravelNotificationSMS(accq, mc.Departure_Date__c, mc.Return_Date__c);
                      break;
                    }
                }
              }*/
             
           return Result;    
                  
    }
    
    public static void SendTravelNotificationSMS(Account acc, date FromDate, date ToDate,List<Mastercard_Travel__c> successAPIList )
    {
      string smstext='';
      try{
            List <smagicinteract__smsmagic__c> smsObjectList = new List <smagicinteract__smsmagic__c>();
            String senderId = 'CreditUnion';
            smagicinteract__smsMagic__c smsObject = new smagicinteract__smsMagic__c();
            smsObject.smagicinteract__SenderId__c = 'CreditUnion';
            string emailadd;
            list<Person_Account__c> paList = [SELECT Id,Brand__c,
                             Account_Number__c, Account_Number__r.RecType__c,TypeTranslate__c, Account_Number__r.Name FROM Person_Account__c WHERE PersonID__c =:acc.Id];
       
            if(paList[0].Brand__c == 'Spectrum')
              emailadd ='SpectrumTravelNoticeSMS';
          else
              emailadd ='CFCUTravelNoticeSMS';
          Datetime fdt = datetime.newInstance(FromDate.year(), FromDate.month(),FromDate.day());
          String fdateStr =  fdt.format('MM/dd/yy');
          Datetime tdt = datetime.newInstance(ToDate.year(), ToDate.month(),ToDate.day());
          String tdateStr =  tdt.format('MM/dd/yy') ;
            list<smagicinteract__SMS_Template__c> listTemplate =  [select Id,smagicinteract__Text__c from smagicinteract__SMS_Template__c where smagicinteract__Name__c =: emailadd];
           
           // smsObject.smagicinteract__PhoneNumber__c = acc.Mobile_Phone__pc;
            smsObject.smagicinteract__PhoneNumber__c = successAPIList[0].US_Mobile_Number__c;
            smsObject.smagicinteract__Name__c = 'SMS - User'; // records name
            smsObject.smagicinteract__ObjectType__c = 'Contact'; // record type
            smsObject.smagicinteract__disableSMSOnTrigger__c = 0; // this field either be 0 or 1, if you specify the value as 1 then sms will not get send but entry of sms will get create under SMS History object
            smsObject.smagicinteract__external_field__c = smagicinteract.ApexAPI.generateUniqueKey();
            if(listTemplate.size() > 0 ) {
                 smsObject.smagicinteract__SMSText__c = listTemplate[0].smagicinteract__Text__c.replace('$StartDate',fdateStr).replace('$EndDate',tdateStr);
                 smstext = listTemplate[0].smagicinteract__Text__c.replace('$StartDate',fdateStr).replace('$EndDate',tdateStr);
            }
            smsObjectList.add(smsObject); 
            Database.insert(smsObjectList,false);     
            
            List<MasterCard_Travel_Confirmation__c> mctcList = new List<MasterCard_Travel_Confirmation__c>();
            map<string, string> accIds = new map<string, string>();
          for(Mastercard_Travel__c mc: successAPIList){
            Account_Details__c ac1 =[select id, Card_Number__c from Account_Details__c where id =: mc.CardId__c limit 1]; 
            accIds.put(ac1.Card_Number__c,   mc.Case__c);
          }
          
          for(string s: accIds.keySet()){
            MasterCard_Travel_Confirmation__c mctc = new MasterCard_Travel_Confirmation__c();
            mctc.Case__c = accIds.get(s);  
               if(successAPIList[0].IsPhonePreferred__c){
            mctc.isSuccessPhone__c = true;               
               }     
               
               mctc.Card_Number__c = s; 
               mctc.Message__c = 'SMS';
               mctc.Message_SentTo__c = successAPIList[0].US_Mobile_Number__c;
               mctc.Message_Text__c = smstext;    
               mctcList.add(mctc);  
          }

         /* for(Mastercard_Travel__c mc: successAPIList){
            MasterCard_Travel_Confirmation__c mctc = new MasterCard_Travel_Confirmation__c();  
               mctc.Case__c = mc.Case__c;  
               if(mc.IsPhonePreferred__c){
            mctc.isSuccessPhone__c = true;               
               }
              Account_Details__c ac1 =[select Card_Number__c from Account_Details__c where id =: mc.CardId__c limit 1];             
                 mctc.Card_Number__c = ac1.Card_Number__c; 
               mctc.Message__c = 'SMS';
               mctc.Message_SentTo__c = successAPIList[0].US_Mobile_Number__c;
               mctc.Message_Text__c = smstext;    
               mctcList.add(mctc);           
             }*/
             insert mctcList;  
      }
      catch(Exception ex){
        List<MasterCard_Travel_Confirmation__c> mctcList = new List<MasterCard_Travel_Confirmation__c>();         
           map<string, string> accIds = new map<string, string>();
          for(Mastercard_Travel__c mc: successAPIList){
            Account_Details__c ac1 =[select id, Card_Number__c from Account_Details__c where id =: mc.CardId__c limit 1]; 
            accIds.put(ac1.Card_Number__c,   mc.Case__c);
          }
          
          for(string s: accIds.keySet()){
            MasterCard_Travel_Confirmation__c mctc = new MasterCard_Travel_Confirmation__c();
            mctc.Case__c = accIds.get(s);  
               if(successAPIList[0].IsPhonePreferred__c){
            mctc.isSuccessPhone__c = false;               
               }     
               
               mctc.Card_Number__c = s; 
               mctc.Message__c = 'SMS';
               mctc.Message_SentTo__c = successAPIList[0].US_Mobile_Number__c;
               mctc.Message_Text__c = smstext;    
               mctcList.add(mctc);  
          }
             insert mctcList;
        
      }     
    }
    
    private static string Formatdate(date tempDate){
    date FromDate =tempDate;
  string fd =String.valueOf(FromDate.day());
  string fm =String.valueOf(FromDate.month());
  if(FromDate.day() <10)
  {
      fd='0'+fd;
  }
  if(FromDate.month() <10)
  {
      fm='0'+fm;
  }
  string finaldate= FromDate.year() + '-' +fm + '-'+ fd + 'T00:00:00';
  system.debug(finaldate);
      return finaldate;
    }
    
    private static boolean isExist(List<string> res, string cardno, string destCountry,string destState){
      for(integer i =0; i< res.size();i++){
      string[] subresult=res[i].split('\\|');
      system.debug('subresult===='+subresult);
      system.debug('cardno===='+cardno);
      system.debug('destCountry===='+destCountry);
      system.debug('destState===='+destState);
      if(subresult.size() == 1 || (subresult.size() > 1 && subresult[1] == '')){
      List<string> destination = subresult[0].split('\\,');
      system.debug('destination===='+destination);
        if(cardno == destination[0] && ((destination[1] == destCountry) ||(destination[1] == destState)))   {
          return true;
        }        
        }
        }
        return false;
      }
      
   private static string FormatdateTime(datetime tempDate){
  string finaldate =  tempDate.format('yyyy-MM-dd\'T\'HH:mm:ss');
  system.debug('finaldate==='+finaldate);
      return finaldate;
    }
    
    }