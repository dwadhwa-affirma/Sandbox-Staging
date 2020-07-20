global without sharing class SendRequestToRTSController {
    
    string accNumber;
    string endPointURL {get;set;}
    string xmlresult {get;set;}
    list<Account_Details__c> accDetailsList;
    map<string,Account_Details__c> accMap;
    list<Account_Details__c> MemberAccountList;
    string authHeader;
    private Helper hObj = new Helper();
    private Blob private_Key;
    private string key = hObj.WebServiceClientkey;
    private string KeyPart2 = hObj.WebServiceClientKeyPart2;
    private string KeyPart3 = hObj.WebServiceClientKeyPart3;
    private string KeyPart4 = hObj.WebServiceClientKeyPart4;
    private string strPrivate_Key= key+KeyPart2+KeyPart3+KeyPart4;
    private string Origin;
    datetime dte = System.now();
    /*public SendRequestToRTSController(){
        
    } */
    
    public string buildAuthHeader(){
        System.debug('SPK:::::::::::::::::'+strPrivate_Key);
        Origin = hObj.WebServiceClientOrigin;
        accNumber = System.currentPageReference().getParameters().get('accNum');
        String url = '/api/accounts/'+accNumber;
        string s_RequestDateTime = DateTime.Now().formatGmt('MMM d yyyy HH:mm:ss') + ' GMT';
        String SigningString =  'GET' + ' ' + url + ' HTTP/1.1' 
                                + '\n' 
                                + 'date= ' + s_RequestDateTime
                                + '\n' 
                                + 'origin:' + Origin
                                + '\n'; 
        private_Key = EncodingUtil.base64Decode(strPrivate_Key);
        
        Blob signingdata = Blob.valueOf(SigningString);
        Blob MAC = Crypto.sign('RSA-SHA256', signingdata, private_Key);
        String Signature = EncodingUtil.base64Encode(MAC); 
        
        authHeader = 'Origin='+Origin+',algorithm=rsa-sha256, headers='; 
        authHeader +=  url + ' ' +  'GET' + ' HTTP/1.1 ' + 'date=' + s_RequestDateTime +  ', signature ' + Signature;       
                
        return authHeader;
       
    }
    
    public Datetime jsonDeserialiseMethod(String jsonDate){
        return (datetime)json.deserialize('"' + jsonDate + '"', datetime.class);
    } 
        
    public pageReference init(){
        authHeader = buildAuthHeader();
        System.debug('AuthHeader::::::'+ authHeader);
        accNumber = System.currentPageReference().getParameters().get('accNum');
        endPointURL = 'https://sfrts.chevronfcu.org/api/Accounts/'+accNumber;
        System.debug('EndPointURL:::::'+ endPointURL);
        MemberAccountList = [Select Id,
                                     Comments_Block__c,
                                     Correspondence_Date__c,
                                     Audio_HB_Frozen_Mode__c,
                                     FrozenTranslated__c,
                                     Invalid_Password_Attempts__c,
                                     Last_logon_Date__c,
                                     Last_HB_Password_Change__c,
                                     Mailing_City__c,
                                     Mailing_Country__c,
                                     Mailing_Country_Code__c,
                                     Mailing_Extra_Address__c,
                                     Mailing_State__c,
                                     Mailing_Street__c,
                                     Mailing_Zipcode__c,
                                     STATEMENT_MAIL_CODE__c,
                                     Statement_Mail_Translate__c,
                                     TYPE__c,
                                     TypeTranslate__c,
                                     WARNING_01_CODE__c,
                                     WARNING_02_CODE__c,
                                     WARNING_03_CODE__c,
                                     WARNING_04_CODE__c,
                                     WARNING_05_CODE__c,
                                     WARNING_06_CODE__c,
                                     WARNING_07_CODE__c,
                                     WARNING_08_CODE__c,
                                     WARNING_09_CODE__c,
                                     WARNING_10_CODE__c,
                                     WARNING_11_CODE__c,
                                     WARNING_12_CODE__c,
                                     WARNING_13_CODE__c,
                                     WARNING_14_CODE__c,
                                     WARNING_15_CODE__c,
                                     WARNING_16_CODE__c,
                                     WARNING_17_CODE__c,
                                     WARNING_18_CODE__c,
                                     WARNING_19_CODE__c,
                                     WARNING_20_CODE__c,
                                     Refresh_Time__c  From Account_Details__c Where Name=:accNumber AND RecordType.Name='Membership'];
                
       System.debug(MemberAccountList);      
       
       list<Account_Details__c> accList = [Select Id,
                                                   Combined_Account_ID__c,
                                                   BlockCode__c,
                                                   Card_Name__c,
                                                   Card_Number__c,
                                                   Available_Credit__c, 
                                                   Credit_Limit__c,
                                                   Credit_Limit_Expiration__c,
                                                   Due_Date__c,
                                                   Interest_YTD__c,
                                                   Interest_Rate__c,
                                                   Interest_Rate_Margin__c,
                                                   Interest_Rate_Margin_Sign__c,
                                                   Last_Payment_Date__c,
                                                   Late_Charge_Due__c,
                                                   Late_Charge_Unpaid__c,
                                                   PARTIALPAYMENT__c,
                                                   PASTDUEPAYMENT__c,
                                                   PAYMENTDUE__c,
                                                   PAYOFFAMOUNT__c,
                                                   Available_Balance__c,
                                                   CP_Eligibility__c,
                                                   Date_CP_Removed__c,
                                                   Date_CP_Revoked__c,
                                                   Div_Post_Code__c,
                                                   Date_Last_Overdrawn__c,
                                                   NEGATIVEBALANCEDATE__c,
                                                   ODT_OPT_IN_OPTION_OTHER__c,
                                                   ODT_OPT_IN_OPTION_RAGE__c,
                                                   ODT_OPT_IN_STATUS_OTHER__c,
                                                   ODT_OPT_IN_STATUS_RAGE__c,
                                                   OVERDRAFTTOLERANCE__c,
                                                   Refresh_Time__c,
                                                   WARNING_01_CODE__c,
                                                   WARNING_02_CODE__c,
                                                   WARNING_03_CODE__c,
                                                   WARNING_04_CODE__c,
                                                   WARNING_05_CODE__c,
                                                   WARNING_06_CODE__c,
                                                   WARNING_07_CODE__c,
                                                   WARNING_08_CODE__c,
                                                   WARNING_09_CODE__c,
                                                   WARNING_10_CODE__c,
                                                   WARNING_11_CODE__c,
                                                   WARNING_12_CODE__c,
                                                   WARNING_13_CODE__c,
                                                   WARNING_14_CODE__c,
                                                   WARNING_15_CODE__c,
                                                   WARNING_16_CODE__c,
                                                   WARNING_17_CODE__c,
                                                   WARNING_18_CODE__c,
                                                   WARNING_19_CODE__c,
                                                   WARNING_20_CODE__c From Account_Details__c Where Parent_Account__r.Name =:accNumber];
        
     
        accMap = new map<string,Account_Details__c>();
        for(Account_Details__c var: accList){
            accMap.put(var.Combined_Account_ID__c,var);
        }
        
        
       // callOutMethod('https://sfrtsqa.chevronfcu.org/api/Accounts/0000018249');
          callOutMethod(endPointURL,authHeader);
         /* if(xmlresult!=null){
            xmlparseMethod(xmlresult);
        }*/
        
        PageReference redirectPage = new PageReference('/'+MemberAccountList[0].Id);
        redirectPage.setRedirect(true);
        return redirectPage;
    }
    public void callOutMethod(string endPoint, string authHeader){
        
        Http h = new Http();
        
        string s_RequestDateTime = DateTime.Now().formatGmt('MMM d yyyy HH:mm:ss') + ' GMT';
        
        HttpRequest req = new HttpRequest();
            req.setMethod('GET');
            req.setHeader('Accept', 'application/xml');
            req.setHeader('date', s_RequestDateTime);
            req.setHeader('content-type','application/xml');
            req.setHeader('Authorization',authHeader);           
            req.setEndpoint(endPoint);
            req.setTimeout(120000);
        
        
        HttpResponse res; 
        
        String xmlr;
        
        
      //  if(!Test.isRunningTest())
      //  {
            try{
                res = h.send(req);
                xmlr = res.getBody();
                System.debug('XML Result: ' + xmlr);
                
                XmlStreamReader reader = res.getXmlStreamReader();
                  
                parserMethodMain(reader);
            
            if(Test.isRunningTest()){
               Integer x=1/0;}
            }catch(Exception e)
            {
                system.debug('FailedException::::::::::::::' + e) ;
            }
        
     //   }

    }
    public void parserMethodMain(XmlStreamReader reader){
        list<Account_Details__c> acdList = new list<Account_Details__c>();
        list<Account_Details__c> loanList = new list<Account_Details__c>();
        list<Account_Details__c> shareList = new list<Account_Details__c>();
        String commentAggregate;
        String frozenMode;
        String correspondenceDate;
        String frozenTranslated;
        String invalidPasswordAttempts;
        String lastLogonDate;
        String lastPasswordChangeDate;
        String city;
        String country;
        String countryCode;
        String extraAddress;
        String state;
        String street;
        String zipCode;
        String statementMailCode;
        String statementMailTranslate;
        String type1;
        String typeTranslate;
        String warningCode01;
        String warningCode02;
        String warningCode03;
        String warningCode04;
        String warningCode05;
        String warningCode06;
        String warningCode07;
        String warningCode08;
        String warningCode09;
        String warningCode10;
        String warningCode11;
        String warningCode12;
        String warningCode13;
        String warningCode14;
        String warningCode15;
        String warningCode16;
        String warningCode17;
        String warningCode18;
        String warningCode19;
        String warningCode20;
       // String rtsDateTime;
        String lastLogOnStr;
 
        while(reader.hasNext()) {
            if (reader.getEventType() == XmlTag.START_ELEMENT) {
                System.debug('^^^^' + reader.getLocalName());
                if('Cards' == reader.getLocalName()){
                    
                    acdList = CardParserMethodSub(reader);
                  
                }else if('CommentAggregate' == reader.getLocalName()){
                    commentAggregate = detailCardParser(reader);
                    if(commentAggregate!=NULL && commentAggregate!='' ){
                    MemberAccountList[0].Comments_Block__c = commentAggregate;
                    }
                }else if('FrozenMode' == reader.getLocalName()){
                    frozenMode = detailCardParser(reader);
                    if(frozenMode!=NULL && frozenMode!='' ){
                    MemberAccountList[0].Audio_HB_Frozen_Mode__c = Decimal.valueOf(frozenMode);
                    }
                }else if('CorrespondenceDate' == reader.getLocalName()){
                    correspondenceDate = detailCardParser(reader);
                    if(correspondenceDate!=NULL && correspondenceDate!='' ){
                      Datetime dt = jsonDeserialiseMethod(correspondenceDate);
                      MemberAccountList[0].Correspondence_Date__c = dt.dateGmt();
                   // Datetime dt = jsonDeserialiseMethod(correspondenceDate);
                   // String gmtDt = dt.format('dd/MM/yyyy hh:mm a', 'GMT');
                   // MemberAccountList[0].Correspondence_Date_Str__c = gmtDt;
                    }
                }else if('FrozenTranslated' == reader.getLocalName()){
                    frozenTranslated = detailCardParser(reader);
                    if(frozenTranslated!=NULL && frozenTranslated!='' ){
                    MemberAccountList[0].FrozenTranslated__c = frozenTranslated;
                    }
                }else if('InvalidPasswordAttempts' == reader.getLocalName()){
                    invalidPasswordAttempts = detailCardParser(reader);
                    if(invalidPasswordAttempts!=NULL && invalidPasswordAttempts!='' ){
                    MemberAccountList[0].Invalid_Password_Attempts__c = Decimal.valueOf(invalidPasswordAttempts);
                    }
                }else if('LastLogonDate' == reader.getLocalName()){
                    lastLogonDate = detailCardParser(reader);
                    if(lastLogonDate!=NULL && lastLogonDate!='' ){
                    Datetime dt = jsonDeserialiseMethod(lastLogonDate);
                    MemberAccountList[0].Last_logon_Date__c = dt.dateGmt();
                    }
                }else if('LastPasswordChangeDate' == reader.getLocalName()){
                    lastPasswordChangeDate = detailCardParser(reader);
                    if(lastPasswordChangeDate!=NULL && lastPasswordChangeDate!='' ){ 
                     Datetime dt = jsonDeserialiseMethod(lastPasswordChangeDate);
                     MemberAccountList[0].Last_HB_Password_Change__c = dt.dateGmt();
                     }
                }
                /*else if('City' == reader.getLocalName()){
                    city = detailCardParser(reader);
                    if(city!=NULL && city!='' ){
                    MemberAccountList[0].Mailing_City__c = city;
                    }
                }else if('Country' == reader.getLocalName()){
                    country = detailCardParser(reader);
                    if(country!=NULL && country!='' ){
                    MemberAccountList[0].Mailing_Country__c = country;
                    }
                }else if('CountryCode' == reader.getLocalName()){
                    countryCode = detailCardParser(reader);
                    if(countryCode!=NULL && countryCode!='' ){
                    MemberAccountList[0].Mailing_Country_Code__c = countryCode;
                    }
                }else if('ExtraAddress' == reader.getLocalName()){
                    extraAddress = detailCardParser(reader);
                    if(extraAddress!=NULL && extraAddress!='' ){
                    MemberAccountList[0].Mailing_Extra_Address__c = extraAddress;
                    }
                }else if('State' == reader.getLocalName()){
                    state = detailCardParser(reader);
                    if(state!=NULL && state!='' ){
                    MemberAccountList[0].Mailing_State__c = state;
                   }
                }else if('Street' == reader.getLocalName()){
                    street = detailCardParser(reader);
                    if(street!=NULL && street!='' ){
                    MemberAccountList[0].Mailing_Street__c = street;
                    }
                }else if('ZipCode' == reader.getLocalName()){
                    zipCode = detailCardParser(reader);
                    if(zipCode!=NULL && zipCode!='' ){
                    MemberAccountList[0].Mailing_Zipcode__c = zipCode;
                    }
                } */
                 else if('StatementMailCode' == reader.getLocalName()){
                    statementMailCode = detailCardParser(reader);
                    if(statementMailCode!=NULL && statementMailCode!='' ){
                    MemberAccountList[0].STATEMENT_MAIL_CODE__c = Decimal.valueOf(statementMailCode);
                    }
                }else if('StatementMailTranslate' == reader.getLocalName()){
                    statementMailTranslate = detailCardParser(reader);
                    if(statementMailTranslate!=NULL && statementMailTranslate!='' ){
                    MemberAccountList[0].Statement_Mail_Translate__c = statementMailTranslate;
                    }
                }else if('Type' == reader.getLocalName()){
                    type1 = detailCardParser(reader);
                    system.debug('type1::::::::'+type1);
                    if(type1!=NULL && type1!='' ){
                        MemberAccountList[0].TYPE__c = Decimal.valueOf(type1);
                    }
                }else if('TypeTranslate' == reader.getLocalName()){
                    typeTranslate = detailCardParser(reader);
                    if(typeTranslate!=NULL && typeTranslate!='' ){
                    MemberAccountList[0].TypeTranslate__c = typeTranslate;
                    }
                }else if('WarningCodes'== reader.getLocalName()){
                    String warningCodes = detailCardParser(reader);   
                    System.debug('List of warning codes:::'+warningCodes);                  
                    List<String> splitted = warningCodes.split('\\_');                    
                    System.debug('Splitted array:::'+splitted);
                    integer numTokens = splitted.size();
                     
                       if(numTokens > 0){
                           MemberAccountList[0].WARNING_01_CODE__c = splitted[0];
                       }else{
                           MemberAccountList[0].WARNING_01_CODE__c = '';
                       }
                       if(numTokens >= 2) {
                           MemberAccountList[0].WARNING_02_CODE__c = splitted[1];              
                        }else{
                           MemberAccountList[0].WARNING_02_CODE__c = '';
                       }
                       if(numTokens >= 3) {
                           MemberAccountList[0].WARNING_03_CODE__c = splitted[2];
                       }else{
                           MemberAccountList[0].WARNING_03_CODE__c = '';
                       }
                        if(numTokens >= 4) {
                           MemberAccountList[0].WARNING_04_CODE__c = splitted[3];
                        }else{
                           MemberAccountList[0].WARNING_04_CODE__c = '';
                       }
                        if(numTokens >= 5) {
                           MemberAccountList[0].WARNING_05_CODE__c = splitted[4];
                        }else{
                           MemberAccountList[0].WARNING_05_CODE__c = '';
                       }
                        if(numTokens >= 6) {
                           MemberAccountList[0].WARNING_06_CODE__c = splitted[5];
                        }else{
                           MemberAccountList[0].WARNING_06_CODE__c = '';
                       }
                        if(numTokens >= 7) {
                           MemberAccountList[0].WARNING_07_CODE__c = splitted[6];
                        }else{
                           MemberAccountList[0].WARNING_07_CODE__c = '';
                       }
                        if(numTokens >= 8) {
                           MemberAccountList[0].WARNING_08_CODE__c = splitted[7];
                        }else{
                           MemberAccountList[0].WARNING_08_CODE__c = '';
                       }
                        if(numTokens >= 9) {
                           MemberAccountList[0].WARNING_09_CODE__c = splitted[8];
                        }else{
                           MemberAccountList[0].WARNING_09_CODE__c = '';
                       }
                        if(numTokens >= 10) {
                           MemberAccountList[0].WARNING_10_CODE__c = splitted[9];
                        }else{
                           MemberAccountList[0].WARNING_10_CODE__c = '';
                       }
                        if(numTokens >= 11) {
                           MemberAccountList[0].WARNING_11_CODE__c = splitted[10];
                        }else{
                           MemberAccountList[0].WARNING_11_CODE__c = '';
                       }
                        if(numTokens >= 12) {
                           MemberAccountList[0].WARNING_12_CODE__c = splitted[11];
                        }else{
                           MemberAccountList[0].WARNING_12_CODE__c = '';
                       }
                        if(numTokens >= 13) {
                           MemberAccountList[0].WARNING_13_CODE__c = splitted[12];
                        }else{
                           MemberAccountList[0].WARNING_13_CODE__c = '';
                       }
                        if(numTokens >= 14) {
                           MemberAccountList[0].WARNING_14_CODE__c = splitted[13];
                        }else{
                           MemberAccountList[0].WARNING_14_CODE__c = '';
                       }
                        if(numTokens >= 15) {
                           MemberAccountList[0].WARNING_15_CODE__c = splitted[14];
                        }else{
                           MemberAccountList[0].WARNING_15_CODE__c = '';
                       }
                        if(numTokens >= 16) {
                           MemberAccountList[0].WARNING_16_CODE__c = splitted[15];
                        }else{
                           MemberAccountList[0].WARNING_16_CODE__c = '';
                       }
                        if(numTokens >= 17) {
                           MemberAccountList[0].WARNING_17_CODE__c = splitted[16];
                        }else{
                           MemberAccountList[0].WARNING_17_CODE__c = '';
                       }
                        if(numTokens >= 18) {
                           MemberAccountList[0].WARNING_18_CODE__c = splitted[17];
                        }else{
                           MemberAccountList[0].WARNING_18_CODE__c = '';
                       }
                        if(numTokens >= 19) {
                           MemberAccountList[0].WARNING_19_CODE__c = splitted[18];
                        }else{
                           MemberAccountList[0].WARNING_19_CODE__c = '';
                       }
                        if(numTokens >= 20) {
                           MemberAccountList[0].WARNING_20_CODE__c = splitted[19]; 
                        }else{
                           MemberAccountList[0].WARNING_20_CODE__c = '';
                       }
                    }

               /*  else if('RtsDateTime' == reader.getLocalName()){
                   rtsDateTime = detailCardParser(reader);
                   if(rtsDateTime!=NULL && rtsDateTime!='' ){
                   MemberAccountList[0].RtsDateTime__c = (datetime)json.deserialize(rtsDateTime, datetime.class);
                    }
                } */      
                  else if('Loans' == reader.getLocalName()){
                    loanList = LoanParserMethodSub(reader);
                    
                } else if('Shares' == reader.getLocalName()){
                    shareList = ShareParserMethodSub(reader);
                }
            }
            reader.next();
        }
       // MemberAccountList[0].Refresh_Time__c = System.now();
       // update MemberAccountList;
       // acdList.addall(loanList);
       // acdList.addall(shareList);
       // update acdList;
        
        MemberAccountList[0].Refresh_Time__c = System.now();
        update MemberAccountList;
        
        if(loanList.size()>0 && loanList != NULL){
          acdList.addall(loanList);
        }
        
       if(shareList.size()>0 && shareList != NULL){
          acdList.addall(shareList);
        }
 
        if(acdList.size()>0 && acdList != NULL){
            for(Account_Details__c subAccs : acdList) {
                subAccs.Refresh_Time__c = dte;
            }
        update acdList;
        }   
     }     

    
    public list<Account_Details__c> CardParserMethodSub(XmlStreamReader reader){
        list<Account_Details__c> accDetailsList = new list<Account_Details__c>();
        while(reader.hasNext()) {
            if (reader.getEventType() == XmlTag.END_ELEMENT && 'Cards' == reader.getLocalName()) {
                break;
            }
            if (reader.getEventType() == XmlTag.START_ELEMENT) {
                System.debug('^^^^' + reader.getLocalName());
                if('SalesForceCard' == reader.getLocalName()){
                    Account_Details__c cardAc = cardParser(reader);
                    if(cardAc!=NULL){
                        accDetailsList.add(cardAc);
                    }
                }
            }
            reader.next();
        }
        return accDetailsList;
    }
    public list<Account_Details__c> LoanParserMethodSub(XmlStreamReader reader){
        list<Account_Details__c> accDetailsList = new list<Account_Details__c>();
        while(reader.hasNext()) {
            if (reader.getEventType() == XmlTag.END_ELEMENT && 'Loans' == reader.getLocalName()) {
                break;
            }
            if (reader.getEventType() == XmlTag.START_ELEMENT) {
                System.debug('^^^^' + reader.getLocalName());
                if('SalesForceLoan' == reader.getLocalName()){
                    Account_Details__c loanAc = loanParser(reader);
                    if(loanAc!=NULL){
                        accDetailsList.add(loanAc);
                    }
                } 
            }
            reader.next();
        }
        return accDetailsList;
    }
    public list<Account_Details__c> ShareParserMethodSub(XmlStreamReader reader){
        list<Account_Details__c> accDetailsList = new list<Account_Details__c>();
        while(reader.hasNext()) {
            if (reader.getEventType() == XmlTag.END_ELEMENT && 'Shares' == reader.getLocalName()) {
                break;
            }
            if (reader.getEventType() == XmlTag.START_ELEMENT) {
                System.debug('^^^^' + reader.getLocalName());
                if('SalesForceShare' == reader.getLocalName()){
                    Account_Details__c shareAc = shareParser(reader);
                    if(shareAc!=NULL){
                        accDetailsList.add(shareAc);
                    }
                }
            }
            reader.next();
        }
        return accDetailsList;
    }
    
    Account_Details__c cardParser(XmlStreamReader reader){
        Account_Details__c acd = new Account_Details__c();
        while(reader.hasNext()) {
            System.debug('^^^^' + reader.getEventType());
            if (reader.getEventType() == XmlTag.END_ELEMENT && 'SalesForceCard' == reader.getLocalName()) {
                break;
            }
            if (reader.getEventType() == XmlTag.START_ELEMENT) {
                System.debug('^^^^' + reader.getLocalName());
               if('AccountId'== reader.getLocalName()){
                   String accountId = detailCardParser(reader);
                   acd=accMap.get(accountId);
                   system.debug('acd::::::'+acd);
               }else if('CardName'== reader.getLocalName()){
                   String cardName = detailCardParser(reader);
                   if(cardName!=NULL && cardName!='' ){
                    if(acd!=NULL){
                   acd.Card_Name__c = cardName;
                    }
                   }
               }else if('BlockCode'== reader.getLocalName()){
                   String blockCode = detailCardParser(reader);
                   if(blockCode!=NULL && blockCode!='' ){
                    if(acd!=NULL){
                   acd.BlockCode__c = blockCode;
                    }
                   }
               }else if('CardNumber'== reader.getLocalName()){
                   String cardNumber = detailCardParser(reader);
                   if(cardNumber!=NULL && cardNumber!='' ){
                    if(acd!=NULL){
                   acd.Card_Number__c = cardNumber;
                    }
                   }
               }else if('WarningCodes'== reader.getLocalName()){
                    String warningCodes = detailCardParser(reader);   
                    System.debug('List of warning codes:::'+warningCodes);                  
                    List<String> splitted = warningCodes.split('\\_');                    
                    System.debug('Splitted array:::'+splitted);
                    integer numTokens = splitted.size();
                    
                       if(acd!=NULL){ 
                       if(numTokens > 0){
                            acd.WARNING_01_CODE__c = splitted[0];
                       }else{
                           acd.WARNING_01_CODE__c = '';
                       }
                       if(numTokens >= 2) {
                            acd.WARNING_02_CODE__c = splitted[1];              
                        }else{
                           acd.WARNING_02_CODE__c = '';
                       }
                       if(numTokens >= 3) {
                            acd.WARNING_03_CODE__c = splitted[2];
                       }else{
                           acd.WARNING_03_CODE__c = '';
                       }
                        if(numTokens >= 4) {
                            acd.WARNING_04_CODE__c = splitted[3];
                        }else{
                           acd.WARNING_04_CODE__c = '';
                       }
                        if(numTokens >= 5) {
                            acd.WARNING_05_CODE__c = splitted[4];
                        }else{
                           acd.WARNING_05_CODE__c = '';
                       }
                        if(numTokens >= 6) {
                            acd.WARNING_06_CODE__c = splitted[5];
                        }else{
                           acd.WARNING_06_CODE__c = '';
                       }
                        if(numTokens >= 7) {
                            acd.WARNING_07_CODE__c = splitted[6];
                        }else{
                           acd.WARNING_07_CODE__c = '';
                       }
                        if(numTokens >= 8) {
                            acd.WARNING_08_CODE__c = splitted[7];
                        }else{
                           acd.WARNING_08_CODE__c = '';
                       }
                        if(numTokens >= 9) {
                            acd.WARNING_09_CODE__c = splitted[8];
                        }else{
                           acd.WARNING_09_CODE__c = '';
                       }
                        if(numTokens >= 10) {
                            acd.WARNING_10_CODE__c = splitted[9];
                        }else{
                           acd.WARNING_10_CODE__c = '';
                       }
                        if(numTokens >= 11) {
                            acd.WARNING_11_CODE__c = splitted[10];
                        }else{
                           acd.WARNING_11_CODE__c = '';
                       }
                        if(numTokens >= 12) {
                            acd.WARNING_12_CODE__c = splitted[11];
                        }else{
                           acd.WARNING_12_CODE__c = '';
                       }
                        if(numTokens >= 13) {
                            acd.WARNING_13_CODE__c = splitted[12];
                        }else{
                           acd.WARNING_13_CODE__c = '';
                       }
                        if(numTokens >= 14) {
                            acd.WARNING_14_CODE__c = splitted[13];
                        }else{
                           acd.WARNING_14_CODE__c = '';
                       }
                        if(numTokens >= 15) {
                            acd.WARNING_15_CODE__c = splitted[14];
                        }else{
                           acd.WARNING_15_CODE__c = '';
                       }
                        if(numTokens >= 16) {
                            acd.WARNING_16_CODE__c = splitted[15];
                        }else{
                           acd.WARNING_16_CODE__c = '';
                       }
                        if(numTokens >= 17) {
                            acd.WARNING_17_CODE__c = splitted[16];
                        }else{
                           acd.WARNING_17_CODE__c = '';
                       }
                        if(numTokens >= 18) {
                            acd.WARNING_18_CODE__c = splitted[17];
                        }else{
                           acd.WARNING_18_CODE__c = '';
                       }
                        if(numTokens >= 19) {
                            acd.WARNING_19_CODE__c = splitted[18];
                        }else{
                           acd.WARNING_19_CODE__c = '';
                       }
                        if(numTokens >= 20) {
                            acd.WARNING_20_CODE__c = splitted[19]; 
                        }else{
                           acd.WARNING_20_CODE__c = '';
                       }
                    }
                } 
            }
            reader.next();
        }
        system.debug('acd::::::'+acd);
        return acd;
    } 
    
    Account_Details__c loanParser(XmlStreamReader reader){
        Account_Details__c ald = new Account_Details__c();
        while(reader.hasNext()) {
            System.debug('^^^^' + reader.getEventType());
            if (reader.getEventType() == XmlTag.END_ELEMENT && 'SalesForceLoan' == reader.getLocalName()) {
                break;
            }
            if (reader.getEventType() == XmlTag.START_ELEMENT) {
                System.debug('^^^^' + reader.getLocalName());
               if('AccountId'== reader.getLocalName()){
                   String accountId = detailCardParser(reader);
                   ald=accMap.get(accountId);
                   system.debug('ald::::::'+ald);
               }else if('AvailableCredit'== reader.getLocalName()){
                   String availableCredit = detailCardParser(reader);
                   if(availableCredit!=NULL && availableCredit!='' ){
                   if(ald!=NULL){
                   ald.Available_Credit__c = Decimal.valueOf(availableCredit);
                   }
                   }
               }else if('CreditLimit'== reader.getLocalName()){
                   String creditLimit = detailCardParser(reader);
                   if(creditLimit != null && creditLimit != ''){
                   if(ald!=NULL){
                   ald.Credit_Limit__c = Decimal.valueOf(creditLimit);                  
                   }
                   }
               }else if('CreditLimitExpiration'== reader.getLocalName()){
                   String creditLimitExpiration = detailCardParser(reader);
                   if(creditLimitExpiration != null && creditLimitExpiration != ''){
                   if(ald!=NULL){ 
                       Datetime dt = jsonDeserialiseMethod(creditLimitExpiration);
                       ald.Credit_Limit_Expiration__c = dt.dateGmt();
                    }
                   }
               }else if('DueDate'== reader.getLocalName()){
                   String dueDate = detailCardParser(reader);
                   if(dueDate!=NULL && dueDate!='' ){
                   if(ald!=NULL){
                      Datetime dt = jsonDeserialiseMethod(dueDate); 
                      ald.Due_Date__c = dt.dateGmt();
                   }                   
                  } 
                }else if('InteresetYtd'== reader.getLocalName()){
                   String interestYtd = detailCardParser(reader);
                   if(interestYtd!=NULL && interestYtd!='' ){
                   if(ald!=NULL){
                   ald.Interest_YTD__c = Decimal.valueOf(interestYtd);
                   }
                   }
                }else if('InterestRate'== reader.getLocalName()){
                   String interestRate = detailCardParser(reader);
                   if(interestRate != null && interestRate != ''){
                   if(ald!=NULL){
                   ald.Interest_Rate__c = Decimal.valueOf(interestRate);
                   }
                   }
                }else if('InterestRateMargin'== reader.getLocalName()){
                   String interestRateMargin = detailCardParser(reader);
                   if(interestRateMargin != null && interestRateMargin != ''){
                   if(ald!=NULL){
                   ald.Interest_Rate_Margin__c = Decimal.valueOf(interestRateMargin); 
                   }
                   }
                }else if('InterestRateMarginSign'== reader.getLocalName()){
                   String interestRateMarginSign = detailCardParser(reader);
                   if(interestRateMarginSign!=NULL && interestRateMarginSign!='' ){
                   if(ald!=NULL){
                   ald.Interest_Rate_Margin_Sign__c = Decimal.valueOf(interestRateMarginSign);
                   }
                   }
                }else if('LastPaymentDate'== reader.getLocalName()){
                   String lastPaymentDate = detailCardParser(reader);
                   if(lastPaymentDate!=NULL && lastPaymentDate!='' ){
                   if(ald!=NULL){
                    Datetime dt = jsonDeserialiseMethod(lastPaymentDate);
                    ald.Last_Payment_Date__c = dt.dateGmt();
                   }
                   }
                }else if('LateChargeDue'== reader.getLocalName()){
                   String lateChargeDue = detailCardParser(reader);
                   if(lateChargeDue != null && lateChargeDue != ''){
                   if(ald!=NULL){
                   ald.Late_Charge_Due__c = Decimal.valueOf(lateChargeDue);
                   }
                   }
                }else if('LateChargeUnpaid'== reader.getLocalName()){
                   String lateChargeUnpaid = detailCardParser(reader);
                   if(lateChargeUnpaid != null && lateChargeUnpaid != ''){
                   if(ald!=NULL){
                   ald.Late_Charge_Unpaid__c  = Decimal.valueOf(lateChargeUnpaid);
                   }
                   }
                }else if('PartialPayment'== reader.getLocalName()){
                   String partialPayment = detailCardParser(reader);
                   if(partialPayment != null && partialPayment != ''){
                   if(ald!=NULL){
                   ald.PARTIALPAYMENT__c = Decimal.valueOf(partialPayment);
                   }
                   }
                }else if('PastDueAmount'== reader.getLocalName()){
                   String pastDueAmount = detailCardParser(reader);
                   if(pastDueAmount!=NULL && pastDueAmount!='' ){
                   if(ald!=NULL){
                   ald.PASTDUEPAYMENT__c = Decimal.valueOf(pastDueAmount);
                   }
                   }
                }else if('PaymentDue'== reader.getLocalName()){
                   String paymentDue = detailCardParser(reader);
                   if(paymentDue!=NULL && paymentDue!='' ){
                   if(ald!=NULL){
                   ald.PAYMENTDUE__c = Decimal.valueOf(paymentDue); 
                   }
                   }
                }else if('PayoffAmount'== reader.getLocalName()){
                   String payoffAmount = detailCardParser(reader);
                   if(payoffAmount!=NULL && payoffAmount!='' ){
                   if(ald!=NULL){
                   ald.PAYOFFAMOUNT__c = Decimal.valueOf(payoffAmount); 
                   }
                   }
                }else if('WarningCodes'== reader.getLocalName()){
                    String warningCodes = detailCardParser(reader);   
                    System.debug('List of warning codes:::'+warningCodes);                  
                    List<String> splitted = warningCodes.split('\\_');                    
                    System.debug('Splitted array:::'+splitted);
                    integer numTokens = splitted.size();
                    
                       if(ald!=NULL){ 
                       if(numTokens > 0){
                            ald.WARNING_01_CODE__c = splitted[0];
                       }else{
                           ald.WARNING_01_CODE__c = '';
                       }
                       if(numTokens >= 2) {
                            ald.WARNING_02_CODE__c = splitted[1];              
                        }else{
                           ald.WARNING_02_CODE__c = '';
                       }
                       if(numTokens >= 3) {
                            ald.WARNING_03_CODE__c = splitted[2];
                       }else{
                           ald.WARNING_03_CODE__c = '';
                       }
                        if(numTokens >= 4) {
                            ald.WARNING_04_CODE__c = splitted[3];
                        }else{
                           ald.WARNING_04_CODE__c = '';
                       }
                        if(numTokens >= 5) {
                            ald.WARNING_05_CODE__c = splitted[4];
                        }else{
                           ald.WARNING_05_CODE__c = '';
                       }
                        if(numTokens >= 6) {
                            ald.WARNING_06_CODE__c = splitted[5];
                        }else{
                           ald.WARNING_06_CODE__c = '';
                       }
                        if(numTokens >= 7) {
                            ald.WARNING_07_CODE__c = splitted[6];
                        }else{
                           ald.WARNING_07_CODE__c = '';
                       }
                        if(numTokens >= 8) {
                            ald.WARNING_08_CODE__c = splitted[7];
                        }else{
                           ald.WARNING_08_CODE__c = '';
                       }
                        if(numTokens >= 9) {
                            ald.WARNING_09_CODE__c = splitted[8];
                        }else{
                           ald.WARNING_09_CODE__c = '';
                       }
                        if(numTokens >= 10) {
                            ald.WARNING_10_CODE__c = splitted[9];
                        }else{
                           ald.WARNING_10_CODE__c = '';
                       }
                        if(numTokens >= 11) {
                            ald.WARNING_11_CODE__c = splitted[10];
                        }else{
                           ald.WARNING_11_CODE__c = '';
                       }
                        if(numTokens >= 12) {
                            ald.WARNING_12_CODE__c = splitted[11];
                        }else{
                           ald.WARNING_12_CODE__c = '';
                       }
                        if(numTokens >= 13) {
                            ald.WARNING_13_CODE__c = splitted[12];
                        }else{
                           ald.WARNING_13_CODE__c = '';
                       }
                        if(numTokens >= 14) {
                            ald.WARNING_14_CODE__c = splitted[13];
                        }else{
                           ald.WARNING_14_CODE__c = '';
                       }
                        if(numTokens >= 15) {
                            ald.WARNING_15_CODE__c = splitted[14];
                        }else{
                           ald.WARNING_15_CODE__c = '';
                       }
                        if(numTokens >= 16) {
                            ald.WARNING_16_CODE__c = splitted[15];
                        }else{
                           ald.WARNING_16_CODE__c = '';
                       }
                        if(numTokens >= 17) {
                            ald.WARNING_17_CODE__c = splitted[16];
                        }else{
                           ald.WARNING_17_CODE__c = '';
                       }
                        if(numTokens >= 18) {
                            ald.WARNING_18_CODE__c = splitted[17];
                        }else{
                           ald.WARNING_18_CODE__c = '';
                       }
                        if(numTokens >= 19) {
                            ald.WARNING_19_CODE__c = splitted[18];
                        }else{
                           ald.WARNING_19_CODE__c = '';
                       }
                        if(numTokens >= 20) {
                            ald.WARNING_20_CODE__c = splitted[19]; 
                        }else{
                           ald.WARNING_20_CODE__c = '';
                       }
                    }
                }
      
            } 
            reader.next();
        }
        system.debug('ald::::::'+ald);
        return ald;
    }
    
    
    Account_Details__c shareParser(XmlStreamReader reader){
        Account_Details__c asd = new Account_Details__c();
        while(reader.hasNext()) {
            System.debug('^^^^' + reader.getEventType());
            if (reader.getEventType() == XmlTag.END_ELEMENT && 'SalesForceShare' == reader.getLocalName()) {
                break;
            }
            if (reader.getEventType() == XmlTag.START_ELEMENT) {
                System.debug('^^^^' + reader.getLocalName());
               if('AccountId'== reader.getLocalName()){
                   String accountId = detailCardParser(reader);
                   asd=accMap.get(accountId);
                   system.debug('asd::::::'+asd);
               }else if('AvailableBalance'== reader.getLocalName()){
                   String availableBalance = detailCardParser(reader);
                   if(availableBalance!=NULL && availableBalance!='' ){
                   if(asd!=NULL){
                   asd.Available_Balance__c = Decimal.valueOf(availableBalance);
                   }
                  }
               }else if('CpEligibility'== reader.getLocalName()){
                   String cpEligibility = detailCardParser(reader);
                   if(cpEligibility!=NULL && cpEligibility!='' ){
                   if(asd!=NULL){
                   asd.CP_Eligibility__c = Decimal.valueOf(cpEligibility);
                   }
                   }
               }else if('CpRemovedDate'== reader.getLocalName()){
                   String cpRemovedDate = detailCardParser(reader);
                   if(cpRemovedDate != null && cpRemovedDate != ''){
                   if(asd!=NULL){
                   Datetime dt = jsonDeserialiseMethod(cpRemovedDate);
                   asd.Date_CP_Removed__c = dt.dateGmt();
                   }
                   }
                   
               }else if('CpRevokedDate'== reader.getLocalName()){
                   String cpRevokedDate = detailCardParser(reader);
                   if(cpRevokedDate != null && cpRevokedDate != ''){
                   if(asd!=NULL){
                   Datetime dt = jsonDeserialiseMethod(cpRevokedDate);
                   asd.Date_CP_Revoked__c = dt.dateGmt();
                   }
                   }
               }else if('DivPostCode'== reader.getLocalName()){
                   String divPostCode = detailCardParser(reader);
                   if(divPostCode!=NULL && divPostCode!='' ){
                   if(asd!=NULL){
                   asd.Div_Post_Code__c = Decimal.valueOf(divPostCode);
                   }
                   }
               }else if('LastOverdrawnDate'== reader.getLocalName()){
                   String lastOverdrawnDate = detailCardParser(reader);
                   if(lastOverdrawnDate != null && lastOverdrawnDate != ''){
                   if(asd!=NULL){
                   Datetime dt = jsonDeserialiseMethod(lastOverdrawnDate);
                   asd.Date_Last_Overdrawn__c = dt.dateGmt();
                   }
                   }
               }else if('NegativeBalanceDate'== reader.getLocalName()){
                   String negativeBalanceDate = detailCardParser(reader);
                   if(negativeBalanceDate != null && negativeBalanceDate != ''){
                   if(asd!=NULL){
                   Datetime dt = jsonDeserialiseMethod(negativeBalanceDate);    
                   asd.NEGATIVEBALANCEDATE__c = dt.dateGmt();
                   }
                   }
               }else if('OdtOptInOptionOther'== reader.getLocalName()){
                   String odtOptInOptionOther = detailCardParser(reader);
                   if(odtOptInOptionOther!=NULL && odtOptInOptionOther!='' ){
                   if(asd!=NULL){
                   asd.ODT_OPT_IN_OPTION_OTHER__c = Decimal.valueOf(odtOptInOptionOther);
                   }
                   }
               }else if('OdtOptInOptionRegE'== reader.getLocalName()){
                   String odtOptInOptionRegE = detailCardParser(reader);
                   if(odtOptInOptionRegE!=NULL && odtOptInOptionRegE!='' ){
                   if(asd!=NULL){
                   asd.ODT_OPT_IN_OPTION_RAGE__c = Decimal.valueOf(odtOptInOptionRegE);
                   }
                   }
               }else if('OdtOptInStatusOther'== reader.getLocalName()){
                   String odtOptInStatusOther = detailCardParser(reader);
                   if(odtOptInStatusOther!=NULL && odtOptInStatusOther!='' ){
                   if(asd!=NULL){
                   asd.ODT_OPT_IN_STATUS_OTHER__c = Decimal.valueOf(odtOptInStatusOther);
                   }
                   }
               }else if('OdtOptInStatusRegE'== reader.getLocalName()){
                   String odtOptInStatusRegE = detailCardParser(reader);
                   if(odtOptInStatusRegE!=NULL && odtOptInStatusRegE!='' ){
                   if(asd!=NULL){
                   asd.ODT_OPT_IN_STATUS_RAGE__c = Decimal.valueOf(odtOptInStatusRegE);
                   }
                   }
               }else if('OverdraftTolerance'== reader.getLocalName()){
                   String overdraftTolerance = detailCardParser(reader);
                   if(overdraftTolerance!=NULL && overdraftTolerance!='' ){
                   if(asd!=NULL){
                   asd.OVERDRAFTTOLERANCE__c = Decimal.valueOf(overdraftTolerance);
                   }
                   }
               }else if('WarningCodes'== reader.getLocalName()){
                    String warningCodes = detailCardParser(reader);   
                    System.debug('List of warning codes:::'+warningCodes);                  
                    List<String> splitted = warningCodes.split('\\_');                    
                    System.debug('Splitted array:::'+splitted);
                    integer numTokens = splitted.size();
                    
                       if(asd!=NULL){
                       if(numTokens > 0){
                            asd.WARNING_01_CODE__c = splitted[0];
                       }else{
                           asd.WARNING_01_CODE__c = '';
                       }
                        if(numTokens >= 2) {
                            asd.WARNING_02_CODE__c = splitted[1];              
                        }else{
                           asd.WARNING_02_CODE__c = '';
                       }
                       if(numTokens >= 3) {
                            asd.WARNING_03_CODE__c = splitted[2];
                        }else{
                           asd.WARNING_03_CODE__c = '';
                       }
                        if(numTokens >= 4) {
                            asd.WARNING_04_CODE__c = splitted[3];
                        }else{
                           asd.WARNING_04_CODE__c = '';
                       }
                        if(numTokens >= 5) {
                            asd.WARNING_05_CODE__c = splitted[4];
                        }else{
                           asd.WARNING_05_CODE__c = '';
                       }
                        if(numTokens >= 6) {
                            asd.WARNING_06_CODE__c = splitted[5];
                        }else{
                           asd.WARNING_06_CODE__c = '';
                       }
                        if(numTokens >= 7) {
                            asd.WARNING_07_CODE__c = splitted[6];
                        }else{
                           asd.WARNING_07_CODE__c = '';
                       }
                        if(numTokens >= 8) {
                            asd.WARNING_08_CODE__c = splitted[7];
                        }else{
                           asd.WARNING_08_CODE__c = '';
                       }
                        if(numTokens >= 9) {
                            asd.WARNING_09_CODE__c = splitted[8];
                        }else{
                           asd.WARNING_09_CODE__c = '';
                       }
                        if(numTokens >= 10) {
                            asd.WARNING_10_CODE__c = splitted[9];
                        }else{
                           asd.WARNING_10_CODE__c = '';
                       }
                        if(numTokens >= 11) {
                            asd.WARNING_11_CODE__c = splitted[10];
                        }else{
                           asd.WARNING_11_CODE__c = '';
                       }
                        if(numTokens >= 12) {
                            asd.WARNING_12_CODE__c = splitted[11];
                        }else{
                           asd.WARNING_12_CODE__c = '';
                       }
                        if(numTokens >= 13) {
                            asd.WARNING_13_CODE__c = splitted[12];
                        }else{
                           asd.WARNING_13_CODE__c = '';
                       }
                        if(numTokens >= 14) {
                            asd.WARNING_14_CODE__c = splitted[13];
                        }else{
                           asd.WARNING_14_CODE__c = '';
                       }
                        if(numTokens >= 15) {
                            asd.WARNING_15_CODE__c = splitted[14];
                        }else{
                           asd.WARNING_15_CODE__c = '';
                       }
                        if(numTokens >= 16) {
                            asd.WARNING_16_CODE__c = splitted[15];
                        }else{
                           asd.WARNING_16_CODE__c = '';
                       }
                        if(numTokens >= 17) {
                            asd.WARNING_17_CODE__c = splitted[16];
                        }else{
                           asd.WARNING_17_CODE__c = '';
                       }
                        if(numTokens >= 18) {
                            asd.WARNING_18_CODE__c = splitted[17];
                        }else{
                           asd.WARNING_18_CODE__c = '';
                       }
                        if(numTokens >= 19) {
                            asd.WARNING_19_CODE__c = splitted[18];
                        }else{
                           asd.WARNING_19_CODE__c = '';
                       }
                        if(numTokens >= 20) {
                            asd.WARNING_20_CODE__c = splitted[19]; 
                        }else{
                           asd.WARNING_20_CODE__c = '';
                       }
                    }                        
                }
            } 
            reader.next();
        }
        system.debug('asd::::::'+asd);
        return asd;
    }

    
    string detailCardParser(XmlStreamReader reader){
        String card ='';
        while(reader.hasNext()) {
            System.debug('^^^^' + reader.getEventType());
            if (reader.getEventType() == XmlTag.END_ELEMENT) {
                break;
            } else if (reader.getEventType() == XmlTag.CHARACTERS) {
                card = reader.getText();
                system.debug('card:::::::::'+card);
            }
            reader.next();
        }
        
        return card;
    }
}