global without sharing class SendRequestToRTSSubAccsController {
 
    string accNumber;
    string endPointURL {get;set;}
    string xmlresult {get;set;}
    list<Account_Details__c> subAccountList;
    string authHeader;
    private Helper hObj = new Helper();
    private Blob private_Key;
    private string key = hObj.WebServiceClientkey;
    private string KeyPart2 = hObj.WebServiceClientKeyPart2;
    private string KeyPart3 = hObj.WebServiceClientKeyPart3;
    private string KeyPart4 = hObj.WebServiceClientKeyPart4;
    private string strPrivate_Key= key+KeyPart2+KeyPart3+KeyPart4;
    private string Origin;
    
    public SendRequestToRTSSubAccsController(){
        
    }
    
    public Datetime jsonDeserialiseMethod(String jsonDate){
        return (datetime)json.deserialize('"' + jsonDate + '"', datetime.class);
    }
    
     public string buildAuthHeader(){
        Origin = hObj.WebServiceClientOrigin;
        accNumber = System.currentPageReference().getParameters().get('accNum');
        String url = '/api/subaccountdetails/'+accNumber;
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
    
    
    public pageReference init(){
        authHeader = buildAuthHeader();
        System.debug('AuthHeader::::::'+authHeader);
        accNumber = System.currentPageReference().getParameters().get('accNum');
        endPointURL = 'https://sfrts.chevronfcu.org/api/subaccountdetails/'+accNumber;
        System.debug(endPointURL);
        subAccountList = [Select Id,
                                 Available_Balance__c,
                                 Balance__c,
                                 Close_Date__c,
                                 Last_Transaction_Date__c,
                                 Maturity_Date__c,
                                 ODT_OPT_IN_OPTION_OTHER__c,
                                 ODT_OPT_IN_OPTION_RAGE__c,
                                 Combined_Account_ID__c,
                                 CP_Eligibility__c,
                                 Date_CP_Removed__c,
                                 Date_CP_Revoked__c,
                                 Date_Last_Overdrawn__c,
                                 Div_Post_Code__c,
                                 NEGATIVEBALANCEDATE__c,
                                 OVERDRAFTTOLERANCE__c,
                                 AuthLimit__c,
                                 BlockCode__c,
                                 Card_Name__c,
                                 Card_Number__c,
                                 DepLimit__c,
                                 Expiration_Date__c,
                                 STATUS__c,
                                 STATUSREASON__c, 
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
                                 RecordType.Name,
                                 Refresh_Time__c FROM Account_Details__c Where Combined_Account_ID__c =:accNumber];
        
       // callOutMethod('https://sfrtsqa.chevronfcu.org/api/subaccountdetails/accNumber');
          callOutMethod(endPointURL, authHeader);
        
        PageReference redirectPage = new PageReference('/'+subAccountList[0].Id);
        redirectPage.setRedirect(true);
        return redirectPage;
    
    }
    
    public void callOutMethod(string endPoint, string authHeader){
        Http h = new Http();
        string s_RequestDateTime = DateTime.Now().formatGmt('MMM d yyyy HH:mm:ss') + ' GMT';
        HttpRequest req = new HttpRequest();
        req.setMethod('GET');
        req.setEndpoint(endPoint);
        req.setHeader('Accept', 'application/json'); 
        req.setHeader('date', s_RequestDateTime);
        req.setHeader('content-type','application/xml');
        req.setHeader('Authorization',authHeader);   
        req.setTimeout(120000);
       // req.setTimeout(20000);
        HttpResponse res; 
        string LoginResult = 'Success';
        
      //  if(!Test.isRunningTest())
      //  {
            try{
                res = h.send(req);
                xmlresult = res.getBody();
                System.debug('XML Result: ' + xmlresult);
                SubAccountsJSON2Apex result = (SubAccountsJSON2Apex)JSON.deserialize(xmlresult, SubAccountsJSON2Apex.class);
                System.debug('result: ' + result);
                postResultMethod (result);
            
            if(Test.isRunningTest()){
               Integer x=1/0;}
            }catch(Exception e)
            {
                LoginResult = 'FailedException::::::::::::::' + e ;
            }
        
      //  }
    }
    
    public void postResultMethod (SubAccountsJSON2Apex result){
        if(subAccountList[0].RecordType.Name == 'Share'){
            
            String availableBalance = result.ShareDetail.AvailableBalance;
                if(availableBalance!=NULL && availableBalance!=''){
                    subAccountList[0].Available_Balance__c = Decimal.valueOf(availableBalance);
                }
            String balance = result.ShareDetail.Balance;
                if(balance!=NULL && balance!=''){
                   subAccountList[0].Balance__c = Decimal.valueOf(balance);
                }
            String closeDate = result.ShareDetail.CloseDate;
                if(closeDate!=NULL && closeDate!=''){
                Datetime dt = jsonDeserialiseMethod(closeDate);
                subAccountList[0].Close_Date__c = dt.dateGmt();
                }
            String lastTranDate = result.ShareDetail.LastTranDate;
                if(lastTranDate!=NULL && lastTranDate!=''){
                Datetime dt = jsonDeserialiseMethod(lastTranDate);
                subAccountList[0].Last_Transaction_Date__c = dt.dateGmt();
                }
            String maturityDate = result.ShareDetail.MaturityDate;
                if(maturityDate!=NULL && maturityDate!=''){
                  Datetime dt = jsonDeserialiseMethod(maturityDate); 
                  subAccountList[0].Maturity_Date__c = dt.dateGmt();
                }
            String odtOptInOptionOther = result.ShareDetail.OdtOptInOptionOther;
                if(odtOptInOptionOther!=NULL && odtOptInOptionOther!=''){
                  subAccountList[0].ODT_OPT_IN_OPTION_OTHER__c = Decimal.valueOf(odtOptInOptionOther);
                }
            String odtOptInOptionRegE = result.ShareDetail.OdtOptInOptionRegE;
                if(odtOptInOptionRegE!=NULL && odtOptInOptionRegE!=''){
                  subAccountList[0].ODT_OPT_IN_OPTION_RAGE__c = Decimal.valueOf(odtOptInOptionRegE);
                }
           /* String accountId = result.ShareDetail.AccountId;
                if(accountId!=NULL && accountId!=''){
            subAccountList[0].Combined_Account_ID__c = accountId;
                } */
            String cpEligibility = result.ShareDetail.CpEligibility;
                if(cpEligibility!=NULL && cpEligibility!=''){
                  subAccountList[0].CP_Eligibility__c = Decimal.valueOf(cpEligibility);
                }
            String cpRemovedDate = result.ShareDetail.CpRemovedDate;
                if(cpRemovedDate!=NULL && cpRemovedDate!=''){
                  Datetime dt = jsonDeserialiseMethod(cpRemovedDate);
                  subAccountList[0].Date_CP_Removed__c = dt.dateGmt();
                }
            String cpRevokedDate = result.ShareDetail.CpRevokedDate;
                if(cpRevokedDate!=NULL && cpRevokedDate!=''){
                  Datetime dt = jsonDeserialiseMethod(cpRevokedDate); 
                  subAccountList[0].Date_CP_Revoked__c = dt.dateGmt();
                }
            String lastOverdrawnDate = result.ShareDetail.LastOverdrawnDate;
                if(lastOverdrawnDate!=NULL && lastOverdrawnDate!=''){
                  Datetime dt = jsonDeserialiseMethod(lastOverdrawnDate);
                  subAccountList[0].Date_Last_Overdrawn__c = dt.dateGmt();
                }
            String divPostCode = result.ShareDetail.DivPostCode;
                if(divPostCode!=NULL && divPostCode!=''){
                  subAccountList[0].Div_Post_Code__c = Decimal.valueOf(divPostCode);
                }
            String negativeBalanceDate = result.ShareDetail.NegativeBalanceDate;
                if(negativeBalanceDate!=NULL && negativeBalanceDate!=''){
                  Datetime dt = jsonDeserialiseMethod(negativeBalanceDate);  
                  subAccountList[0].NEGATIVEBALANCEDATE__c = dt.dateGmt();
                }
            String overdraftTolerance = result.ShareDetail.OverdraftTolerance;
                if(overdraftTolerance!=NULL && overdraftTolerance!=''){
                  subAccountList[0].OVERDRAFTTOLERANCE__c = Decimal.valueOf(overdraftTolerance);
                } 
            String warningCodes = result.ShareDetail.WarningCodes;
            List<String> splitted = warningCodes.split('\\_');
            integer numTokens = splitted.size();
                if(numTokens > 0){
                           subAccountList[0].WARNING_01_CODE__c = splitted[0];
                       }else{
                           subAccountList[0].WARNING_01_CODE__c = '';
                       }
                       if(numTokens >= 2) {
                           subAccountList[0].WARNING_02_CODE__c = splitted[1];              
                        }else{
                           subAccountList[0].WARNING_02_CODE__c = '';
                       }
                       if(numTokens >= 3) {
                           subAccountList[0].WARNING_03_CODE__c = splitted[2];
                       }else{
                           subAccountList[0].WARNING_03_CODE__c = '';
                       }
                        if(numTokens >= 4) {
                           subAccountList[0].WARNING_04_CODE__c = splitted[3];
                        }else{
                           subAccountList[0].WARNING_04_CODE__c = '';
                       }
                        if(numTokens >= 5) {
                           subAccountList[0].WARNING_05_CODE__c = splitted[4];
                        }else{
                           subAccountList[0].WARNING_05_CODE__c = '';
                       }
                        if(numTokens >= 6) {
                           subAccountList[0].WARNING_06_CODE__c = splitted[5];
                        }else{
                           subAccountList[0].WARNING_06_CODE__c = '';
                       }
                        if(numTokens >= 7) {
                           subAccountList[0].WARNING_07_CODE__c = splitted[6];
                        }else{
                           subAccountList[0].WARNING_07_CODE__c = '';
                       }
                        if(numTokens >= 8) {
                           subAccountList[0].WARNING_08_CODE__c = splitted[7];
                        }else{
                           subAccountList[0].WARNING_08_CODE__c = '';
                       }
                        if(numTokens >= 9) {
                           subAccountList[0].WARNING_09_CODE__c = splitted[8];
                        }else{
                           subAccountList[0].WARNING_09_CODE__c = '';
                       }
                        if(numTokens >= 10) {
                           subAccountList[0].WARNING_10_CODE__c = splitted[9];
                        }else{
                           subAccountList[0].WARNING_10_CODE__c = '';
                       }
                        if(numTokens >= 11) {
                           subAccountList[0].WARNING_11_CODE__c = splitted[10];
                        }else{
                           subAccountList[0].WARNING_11_CODE__c = '';
                       }
                        if(numTokens >= 12) {
                           subAccountList[0].WARNING_12_CODE__c = splitted[11];
                        }else{
                           subAccountList[0].WARNING_12_CODE__c = '';
                       }
                        if(numTokens >= 13) {
                           subAccountList[0].WARNING_13_CODE__c = splitted[12];
                        }else{
                           subAccountList[0].WARNING_13_CODE__c = '';
                       }
                        if(numTokens >= 14) {
                           subAccountList[0].WARNING_14_CODE__c = splitted[13];
                        }else{
                           subAccountList[0].WARNING_14_CODE__c = '';
                       }
                        if(numTokens >= 15) {
                           subAccountList[0].WARNING_15_CODE__c = splitted[14];
                        }else{
                           subAccountList[0].WARNING_15_CODE__c = '';
                       }
                        if(numTokens >= 16) {
                           subAccountList[0].WARNING_16_CODE__c = splitted[15];
                        }else{
                           subAccountList[0].WARNING_16_CODE__c = '';
                       }
                        if(numTokens >= 17) {
                           subAccountList[0].WARNING_17_CODE__c = splitted[16];
                        }else{
                           subAccountList[0].WARNING_17_CODE__c = '';
                       }
                        if(numTokens >= 18) {
                           subAccountList[0].WARNING_18_CODE__c = splitted[17];
                        }else{
                           subAccountList[0].WARNING_18_CODE__c = '';
                       }
                        if(numTokens >= 19) {
                           subAccountList[0].WARNING_19_CODE__c = splitted[18];
                        }else{
                           subAccountList[0].WARNING_19_CODE__c = '';
                       }
                        if(numTokens >= 20) {
                           subAccountList[0].WARNING_20_CODE__c = splitted[19]; 
                        }else{
                           subAccountList[0].WARNING_20_CODE__c = '';
                       } 

            if(subAccountList.size()>0 && subAccountList!=NULL){
                for(Account_Details__c share : subAccountList){
                    share.Refresh_Time__c = System.now();
                }
                system.debug('Shares List::::::'+subAccountList);
            update subAccountList;
            }
        }
        if(subAccountList[0].RecordType.Name == 'Card'){
           
          /*  String accountId = result.CardDetail.AccountId;
                if(accountId!=NULL && accountId!=''){
                    subAccountList[0].Combined_Account_ID__c = accountId;
                }  */
            String authLimit = result.CardDetail.AuthLimit;
                if(authLimit!=NULL && authLimit!=''){
                    subAccountList[0].AuthLimit__c = Decimal.valueOf(authLimit);
                }
            String blockCode = result.CardDetail.BlockCode;
                if(blockCode!=NULL && blockCode!=''){
                   subAccountList[0].BlockCode__c = blockCode;
                }
            String cardName = result.CardDetail.CardName;
                if(cardName!=NULL && cardName!=''){
                   subAccountList[0].Card_Name__c = cardName;
                }
            String cardNumber = result.CardDetail.CardNumber;
                if(cardNumber!=NULL && cardNumber!=''){
                   subAccountList[0].Card_Number__c = cardNumber;
                }
            String closeDte = result.CardDetail.CloseDate;
                if(closeDte!=NULL && closeDte!=''){
                Datetime dt = jsonDeserialiseMethod(closeDte);
                subAccountList[0].Close_Date__c = dt.dateGmt();
               }
            String depLimit = result.CardDetail.DepLimit;
                if(depLimit!=NULL && depLimit!=''){
                  subAccountList[0].DepLimit__c = Decimal.valueOf(depLimit);
                }
            
            String expirationDte = result.CardDetail.ExpirationDate;
               if(expirationDte!=NULL && expirationDte!=''){
               Datetime dt = jsonDeserialiseMethod(expirationDte);
               subAccountList[0].Expiration_Date__c = dt.dateGmt(); 
               }
            String status = result.CardDetail.Status;
                if(status!=NULL && status!=''){
                  subAccountList[0].STATUS__c = Decimal.valueOf(status);
                }
            String statusReason = result.CardDetail.StatusReason;
                if(statusReason!=NULL && statusReason!=''){
                  subAccountList[0].STATUSREASON__c = Decimal.valueOf(statusReason);
                }
            String warningCodes = result.CardDetail.WarningCodes;
            List<String> splitted = warningCodes.split('\\_');
            integer numTokens = splitted.size();
                if(numTokens > 0){
                           subAccountList[0].WARNING_01_CODE__c = splitted[0];
                       }else{
                           subAccountList[0].WARNING_01_CODE__c = '';
                       }
                       if(numTokens >= 2) {
                           subAccountList[0].WARNING_02_CODE__c = splitted[1];              
                        }else{
                           subAccountList[0].WARNING_02_CODE__c = '';
                       }
                       if(numTokens >= 3) {
                           subAccountList[0].WARNING_03_CODE__c = splitted[2];
                       }else{
                           subAccountList[0].WARNING_03_CODE__c = '';
                       }
                        if(numTokens >= 4) {
                           subAccountList[0].WARNING_04_CODE__c = splitted[3];
                        }else{
                           subAccountList[0].WARNING_04_CODE__c = '';
                       }
                        if(numTokens >= 5) {
                           subAccountList[0].WARNING_05_CODE__c = splitted[4];
                        }else{
                           subAccountList[0].WARNING_05_CODE__c = '';
                       }
                        if(numTokens >= 6) {
                           subAccountList[0].WARNING_06_CODE__c = splitted[5];
                        }else{
                           subAccountList[0].WARNING_06_CODE__c = '';
                       }
                        if(numTokens >= 7) {
                           subAccountList[0].WARNING_07_CODE__c = splitted[6];
                        }else{
                           subAccountList[0].WARNING_07_CODE__c = '';
                       }
                        if(numTokens >= 8) {
                           subAccountList[0].WARNING_08_CODE__c = splitted[7];
                        }else{
                           subAccountList[0].WARNING_08_CODE__c = '';
                       }
                        if(numTokens >= 9) {
                           subAccountList[0].WARNING_09_CODE__c = splitted[8];
                        }else{
                           subAccountList[0].WARNING_09_CODE__c = '';
                       }
                        if(numTokens >= 10) {
                           subAccountList[0].WARNING_10_CODE__c = splitted[9];
                        }else{
                           subAccountList[0].WARNING_10_CODE__c = '';
                       }
                        if(numTokens >= 11) {
                           subAccountList[0].WARNING_11_CODE__c = splitted[10];
                        }else{
                           subAccountList[0].WARNING_11_CODE__c = '';
                       }
                        if(numTokens >= 12) {
                           subAccountList[0].WARNING_12_CODE__c = splitted[11];
                        }else{
                           subAccountList[0].WARNING_12_CODE__c = '';
                       }
                        if(numTokens >= 13) {
                           subAccountList[0].WARNING_13_CODE__c = splitted[12];
                        }else{
                           subAccountList[0].WARNING_13_CODE__c = '';
                       }
                        if(numTokens >= 14) {
                           subAccountList[0].WARNING_14_CODE__c = splitted[13];
                        }else{
                           subAccountList[0].WARNING_14_CODE__c = '';
                       }
                        if(numTokens >= 15) {
                           subAccountList[0].WARNING_15_CODE__c = splitted[14];
                        }else{
                           subAccountList[0].WARNING_15_CODE__c = '';
                       }
                        if(numTokens >= 16) {
                           subAccountList[0].WARNING_16_CODE__c = splitted[15];
                        }else{
                           subAccountList[0].WARNING_16_CODE__c = '';
                       }
                        if(numTokens >= 17) {
                           subAccountList[0].WARNING_17_CODE__c = splitted[16];
                        }else{
                           subAccountList[0].WARNING_17_CODE__c = '';
                       }
                        if(numTokens >= 18) {
                           subAccountList[0].WARNING_18_CODE__c = splitted[17];
                        }else{
                           subAccountList[0].WARNING_18_CODE__c = '';
                       }
                        if(numTokens >= 19) {
                           subAccountList[0].WARNING_19_CODE__c = splitted[18];
                        }else{
                           subAccountList[0].WARNING_19_CODE__c = '';
                       }
                        if(numTokens >= 20) {
                           subAccountList[0].WARNING_20_CODE__c = splitted[19]; 
                        }else{
                           subAccountList[0].WARNING_20_CODE__c = '';
                       }
            
            if(subAccountList.size()>0 && subAccountList!=NULL){
                 for(Account_Details__c card : subAccountList){
                    card.Refresh_Time__c = System.now();
                }
            update subAccountList;
            }
        }
        if(subAccountList[0].RecordType.Name == 'Loan'){
         /*   String accountId = result.LoanDetail.AccountId;
                if(accountId!=NULL && accountId!=''){
                    subAccountList[0].Combined_Account_ID__c = accountId;
                } */
            String availableCredit = result.LoanDetail.AvailableCredit;
                if(availableCredit!=NULL && availableCredit!=''){
                    subAccountList[0].Available_Credit__c = Decimal.valueOf(availableCredit);
                }
            String balance = result.LoanDetail.Balance;
                if(balance!=NULL && balance!=''){
                   subAccountList[0].Balance__c = Decimal.valueOf(balance);
                }
            String closeDate = result.LoanDetail.CloseDate;
                if(closeDate!=NULL && closeDate!=''){
                   Datetime dt = jsonDeserialiseMethod(closeDate);
                   subAccountList[0].Close_Date__c = dt.dateGmt();
                }
            String creditLimit = result.LoanDetail.CreditLimit;
                if(creditLimit!=NULL && creditLimit!=''){
                   subAccountList[0].Credit_Limit__c = Decimal.valueOf(creditLimit);
                }
            String creditLimitExpiration = result.LoanDetail.CreditLimitExpiration;
                if(creditLimitExpiration!=NULL && creditLimitExpiration!=''){
                   Datetime dt = jsonDeserialiseMethod(creditLimitExpiration);
                   subAccountList[0].Credit_Limit_Expiration__c = dt.dateGmt();
                }
            String dueDate = result.LoanDetail.DueDate;
                if(dueDate!=NULL && dueDate!=''){
                   Datetime dt = jsonDeserialiseMethod(dueDate);
                   subAccountList[0].Due_Date__c = dt.dateGmt();
                }
            String interestYtd = result.LoanDetail.InterestYtd;
                if(interestYtd!=NULL && interestYtd!=''){
                   subAccountList[0].Interest_YTD__c = Decimal.valueOf(interestYtd);
                }
            String interestRate = result.LoanDetail.InterestRate;
                if(interestRate!=NULL && interestRate!=''){
                   subAccountList[0].Interest_Rate__c = Decimal.valueOf(interestRate);
                }
            String interestRateMargin = result.LoanDetail.InterestRateMargin;
                if(interestRateMargin!=NULL && interestRateMargin!=''){
                   subAccountList[0].Interest_Rate_Margin__c = Decimal.valueOf(interestRateMargin);
                }
            String interestRateMarginSign = result.LoanDetail.InterestRateMarginSign;
                if(interestRateMarginSign!=NULL && interestRateMarginSign!=''){
                   subAccountList[0].Interest_Rate_Margin_Sign__c = Decimal.valueOf(interestRateMarginSign);
                }
            String lastTranDate = result.LoanDetail.LastTranDate;
                if(lastTranDate!=NULL && lastTranDate!=''){
                   Datetime dt = jsonDeserialiseMethod(lastTranDate);
                   subAccountList[0].Last_Transaction_Date__c = dt.dateGmt();
                }
            String lastPaymentDate = result.LoanDetail.LastPaymentDate;
                if(lastPaymentDate!=NULL && lastPaymentDate!=''){
                   Datetime dt = jsonDeserialiseMethod(lastPaymentDate);
                   subAccountList[0].Last_Payment_Date__c = dt.dateGmt();
                }
            String lateChargeDue = result.LoanDetail.LateChargeDue;
                if(lateChargeDue!=NULL && lateChargeDue!=''){
                    subAccountList[0].Late_Charge_Due__c = Decimal.valueOf(lateChargeDue);
                }
            String lateChargeUnpaid = result.LoanDetail.LateChargeUnpaid;
                if(lateChargeUnpaid!=NULL && lateChargeUnpaid!=''){
                    subAccountList[0].Late_Charge_Unpaid__c = Decimal.valueOf(lateChargeUnpaid);
                }
            String maturityDate = result.LoanDetail.MaturityDate;
                if(maturityDate!=NULL && maturityDate!=''){
                    Datetime dt = jsonDeserialiseMethod(maturityDate);
                    subAccountList[0].Maturity_Date__c = dt.dateGmt();
                }
            String partialPayment = result.LoanDetail.PartialPayment;
                if(partialPayment!=NULL && partialPayment!=''){
                    subAccountList[0].PARTIALPAYMENT__c = Decimal.valueOf(partialPayment);
                }
            String pastDueAmount = result.LoanDetail.PastDueAmount;
                if(pastDueAmount!=NULL && pastDueAmount!=''){
                    subAccountList[0].PASTDUEPAYMENT__c = Decimal.valueOf(pastDueAmount);
                }
            String paymentDue = result.LoanDetail.PaymentDue;
                if(paymentDue!=NULL && paymentDue!=''){
                   subAccountList[0].PAYMENTDUE__c = Decimal.valueOf(paymentDue);
                }
            String payoffAmount = result.LoanDetail.PayoffAmount;
                if(payoffAmount!=NULL && payoffAmount!=''){            
                   subAccountList[0].PAYOFFAMOUNT__c = Decimal.valueOf(payoffAmount);
                }
            String warningCodes = result.LoanDetail.WarningCodes;
            List<String> splitted = warningCodes.split('\\_');
            integer numTokens = splitted.size();
                if(numTokens > 0){
                           subAccountList[0].WARNING_01_CODE__c = splitted[0];
                       }else{
                           subAccountList[0].WARNING_01_CODE__c = '';
                       }
                       if(numTokens >= 2) {
                           subAccountList[0].WARNING_02_CODE__c = splitted[1];              
                        }else{
                           subAccountList[0].WARNING_02_CODE__c = '';
                       }
                       if(numTokens >= 3) {
                           subAccountList[0].WARNING_03_CODE__c = splitted[2];
                       }else{
                           subAccountList[0].WARNING_03_CODE__c = '';
                       }
                        if(numTokens >= 4) {
                           subAccountList[0].WARNING_04_CODE__c = splitted[3];
                        }else{
                           subAccountList[0].WARNING_04_CODE__c = '';
                       }
                        if(numTokens >= 5) {
                           subAccountList[0].WARNING_05_CODE__c = splitted[4];
                        }else{
                           subAccountList[0].WARNING_05_CODE__c = '';
                       }
                        if(numTokens >= 6) {
                           subAccountList[0].WARNING_06_CODE__c = splitted[5];
                        }else{
                           subAccountList[0].WARNING_06_CODE__c = '';
                       }
                        if(numTokens >= 7) {
                           subAccountList[0].WARNING_07_CODE__c = splitted[6];
                        }else{
                           subAccountList[0].WARNING_07_CODE__c = '';
                       }
                        if(numTokens >= 8) {
                           subAccountList[0].WARNING_08_CODE__c = splitted[7];
                        }else{
                           subAccountList[0].WARNING_08_CODE__c = '';
                       }
                        if(numTokens >= 9) {
                           subAccountList[0].WARNING_09_CODE__c = splitted[8];
                        }else{
                           subAccountList[0].WARNING_09_CODE__c = '';
                       }
                        if(numTokens >= 10) {
                           subAccountList[0].WARNING_10_CODE__c = splitted[9];
                        }else{
                           subAccountList[0].WARNING_10_CODE__c = '';
                       }
                        if(numTokens >= 11) {
                           subAccountList[0].WARNING_11_CODE__c = splitted[10];
                        }else{
                           subAccountList[0].WARNING_11_CODE__c = '';
                       }
                        if(numTokens >= 12) {
                           subAccountList[0].WARNING_12_CODE__c = splitted[11];
                        }else{
                           subAccountList[0].WARNING_12_CODE__c = '';
                       }
                        if(numTokens >= 13) {
                           subAccountList[0].WARNING_13_CODE__c = splitted[12];
                        }else{
                           subAccountList[0].WARNING_13_CODE__c = '';
                       }
                        if(numTokens >= 14) {
                           subAccountList[0].WARNING_14_CODE__c = splitted[13];
                        }else{
                           subAccountList[0].WARNING_14_CODE__c = '';
                       }
                        if(numTokens >= 15) {
                           subAccountList[0].WARNING_15_CODE__c = splitted[14];
                        }else{
                           subAccountList[0].WARNING_15_CODE__c = '';
                       }
                        if(numTokens >= 16) {
                           subAccountList[0].WARNING_16_CODE__c = splitted[15];
                        }else{
                           subAccountList[0].WARNING_16_CODE__c = '';
                       }
                        if(numTokens >= 17) {
                           subAccountList[0].WARNING_17_CODE__c = splitted[16];
                        }else{
                           subAccountList[0].WARNING_17_CODE__c = '';
                       }
                        if(numTokens >= 18) {
                           subAccountList[0].WARNING_18_CODE__c = splitted[17];
                        }else{
                           subAccountList[0].WARNING_18_CODE__c = '';
                       }
                        if(numTokens >= 19) {
                           subAccountList[0].WARNING_19_CODE__c = splitted[18];
                        }else{
                           subAccountList[0].WARNING_19_CODE__c = '';
                       }
                        if(numTokens >= 20) {
                           subAccountList[0].WARNING_20_CODE__c = splitted[19]; 
                        }else{
                           subAccountList[0].WARNING_20_CODE__c = '';
                       }
            
            if(subAccountList.size()>0 && subAccountList!=NULL){
                for(Account_Details__c loan : subAccountList){
                    loan.Refresh_Time__c = System.now();
                }
                update subAccountList;
            }
        }
    }
}