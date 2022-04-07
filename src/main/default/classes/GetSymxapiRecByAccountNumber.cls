public class GetSymxapiRecByAccountNumber {
    public static String body;
    public static HttpRequest req = new HttpRequest();
    public static Http http = new Http();
    public static HttpResponse res;
    public static String strStatus, strBody;
    public static String loanAPI;
    
    public static String GetACCTRecordsbyAccountNumber(String accountNumber){

        ACH_To_Episys_API_Details__c api = ACH_To_Episys_API_Details__c.getValues('ProductionURL');
                
        if(api.URL__c != null){
            loanAPI = api.URL__c;
        }

        req = new HttpRequest();
        body = '{"AccountNumber":"' + accountNumber + '"}';
        req.setHeader('Content-Type', 'application/json');
        req.setHeader('Accept', 'application/json');
        req.setTimeout(60000);
        req.setEndpoint(loanAPI + '/AddressChange/GetACCTRecordsbyAccountNumber');
        req.setMethod('POST');
        req.setBody(body);
        if (!Test.isRunningTest()){
            res = http.send(req);
            strBody = res.getBody();
        }
        else{
            strBody= '{"AccountNumber":"9000282907","ActivityDate":"2021-11-11T08:00:00Z","CorrespondDate":"0001-01-01T08:00:00Z","CreatedAtBranch":"94","CreatedByUser":"2026","InvalidAttemptCount":0,"InvalidAttemptDate":"0001-01-01T08:00:00Z","MemberGroup":0,"OpenDate":"2021-11-11T08:00:00Z","Reference":"","Restrict":0,"StatementMailCode":0,"Type":1,"NameObjects":[{"AddressType":"0","city":"","country":"","locator":"1","cardlocator":null,"cardlast4":null,"extraaddress":"","state":"","street":"","userchar2":"","zipcode":"","name":"MARS TESTING","email":"","DisplayOnly":"0","middlename":null,"mailoverride":"No","LastAddressChangeDate":"2021-11-11T08:00:00Z","Status":"Inactive","homephone":"","workphone":"","workphoneextension":"","expirationdate":"1900-01-01T08:00:00Z","expirationstring":"01/01/1900 12:00:00 AM","mobilephone":"","firstname":"MARS","lastname":"TESTING","ssn":null,"ssnnumber":"999852654","Order":100,"AvailableBalance":null,"fullname":"MARS TESTING","type":0,"accounttype":"PRIMARY","accountTypeName":"PRIMARY","altemail":null,"accountnumber":"9000282907","Description":null,"BirthDate":"02-01-2001","Last4Ssn":"2654","IsDormantAccount":false}]}';
        }       
        system.debug('###'+strBody);
        return String.valueOf(strBody);
    }
    
    public static String GetCardsbyAccountNumber(String accountNumber){
        ACH_To_Episys_API_Details__c api = ACH_To_Episys_API_Details__c.getValues('ProductionURL');
                
        if(api.URL__c != null){
            loanAPI = api.URL__c;
        }

        req = new HttpRequest();
        body = '{"AccountNumber":"' + accountNumber + '"}';
        req.setHeader('Content-Type', 'application/json');
        req.setHeader('Accept', 'application/json');
        req.setTimeout(60000);
        req.setEndpoint(loanAPI + '/CardLimitReset/GetCardsbyAccountNumber');        
        req.setMethod('POST');
        req.setBody(body);
        if (!Test.isRunningTest()){
            res = http.send(req);
            strBody = res.getBody();
        }
        else{
            strBody = '[{"AccountNumber":null,"CardNumber":"5460277346125384","ExpirationDate":"2025-05-01","CloseDate":"","CardOwner":null,"Locator":null,"LongName":"QA LIAT LUBAVIN","PosLimit":2500.00,"AuthLimit":2500.00,"UsageLimit":510.00,"CardStatus":1,"NameType":0,"Description":"CHEVRON DEBIT CARD","CreatedByUser":"1364","CreatedAtBranch":"88","StatusReason":"15","EffectiveDate":"2016-04-11","IssueDate":"2016-04-11","DepLimit":500.00,"LimitAmount":0.00,"Status":null,"Error":null,"ErrorDetails":null},{"AccountNumber":null,"CardNumber":"6422581678518529","ExpirationDate":"2024-06-01","CloseDate":"","CardOwner":null,"Locator":null,"LongName":null,"PosLimit":2500.00,"AuthLimit":0.01,"UsageLimit":51.00,"CardStatus":1,"NameType":0,"Description":"CHEVRON ATM CARD","CreatedByUser":"561","CreatedAtBranch":"88","StatusReason":"1","EffectiveDate":"2016-05-27","IssueDate":"2016-05-27","DepLimit":500.00,"LimitAmount":0.00,"Status":null,"Error":null,"ErrorDetails":null},{"AccountNumber":null,"CardNumber":"5128931592567061","ExpirationDate":"2024-06-01","CloseDate":"","CardOwner":null,"Locator":null,"LongName":null,"PosLimit":2500.00,"AuthLimit":2500.00,"UsageLimit":510.00,"CardStatus":1,"NameType":0,"Description":"CHEVRON HSA DEBIT CARD","CreatedByUser":"33","CreatedAtBranch":"88","StatusReason":"1","EffectiveDate":"2016-05-27","IssueDate":"2016-05-27","DepLimit":500.00,"LimitAmount":0.00,"Status":null,"Error":null,"ErrorDetails":null},{"AccountNumber":null,"CardNumber":"5460277625279795","ExpirationDate":"2025-10-01","CloseDate":"","CardOwner":null,"Locator":null,"LongName":"QBS3 TEST","PosLimit":2600.00,"AuthLimit":2600.00,"UsageLimit":250.00,"CardStatus":1,"NameType":0,"Description":"CHEVRON DEBIT CARD","CreatedByUser":"242","CreatedAtBranch":"85","StatusReason":"1","EffectiveDate":"2016-09-01","IssueDate":"2016-09-01","DepLimit":500.00,"LimitAmount":0.00,"Status":null,"Error":null,"ErrorDetails":null},{"AccountNumber":null,"CardNumber":"5128932658235189","ExpirationDate":"","CloseDate":"","CardOwner":null,"Locator":null,"LongName":"QBS3 TEST","PosLimit":2500.00,"AuthLimit":2500.00,"UsageLimit":510.00,"CardStatus":1,"NameType":0,"Description":"CHEVRON HSA DEBIT CARD","CreatedByUser":"242","CreatedAtBranch":"85","StatusReason":"1","EffectiveDate":"2016-09-01","IssueDate":"2016-09-01","DepLimit":500.00,"LimitAmount":0.00,"Status":null,"Error":null,"ErrorDetails":null},{"AccountNumber":null,"CardNumber":"5263879856757289","ExpirationDate":"2022-09-01","CloseDate":"","CardOwner":null,"Locator":null,"LongName":"APPLICATION SERVICES TEST","PosLimit":2500.00,"AuthLimit":2500.00,"UsageLimit":1010.00,"CardStatus":1,"NameType":0,"Description":"CHEVRON DEBIT EMV CARD","CreatedByUser":"1541","CreatedAtBranch":"88","StatusReason":"0","EffectiveDate":"2019-08-30","IssueDate":"2019-08-30","DepLimit":500.00,"LimitAmount":0.00,"Status":null,"Error":null,"ErrorDetails":null}]';
        }        
        system.debug('###'+strBody);
        return String.valueOf(strBody);
    }
    
    public static String GetLoansSelectFields(String accountNumber){
        ACH_To_Episys_API_Details__c api = ACH_To_Episys_API_Details__c.getValues('ProductionURL');
                
        if(api.URL__c != null){
            loanAPI = api.URL__c;
        }

        req = new HttpRequest();
        String endPoint = loanAPI + '/MARS/GetLoansAccounts?accountNumber=' + accountNumber; 
        req.setHeader('Content-Type', 'application/json');
        req.setHeader('Accept', 'application/json');
        req.setTimeout(60000);        
        req.setEndpoint(endPoint);        
        req.setMethod('GET');
        if (!Test.isRunningTest()){
            res = http.send(req);
            strBody = res.getBody();
        }
        else{
            strBody = '[{"LoanId":0,"LoanType":0,"Description":"","Payment":0.0,"AlternatePayment":0.0,"PmtBucketAmount":0.0,"UserAmount2":0.0,"DueDate":"","DueDay1":0,"DueDay2":0,"LoanCode":"","Balance":0.0,"FirstPaymentDate":"","OpenDate":"","OriginalDate":"","LastAdvanceDate":"","ApprovalDate":"","CreatedAtBranch":"","CreatedByUser":"","OriginalBalance":0.0,"MaturityDate":"","LastPaymentDate":"","LastTranDate":"","CreditScore":"","InterestRate":0.0,"InterestYtd":0.0,"InterestLastYear":0.0,"InterestRateMargin":0.0,"LateChargeUnpaid":0.0,"PastDueAmount":0.0,"InterestDue":0.0,"PartialPayment":0.0,"InsuranceType":"","MicrAcctNumber":"","NoteNumber":"","ServiceValue1":null,"ServiceValue2":null,"ServiceValue3":null,"ServiceValue4":null,"ServiceValue5":null,"ServiceValue6":null,"ServiceValue7":null,"ServiceValue8":null},{"LoanId":5600,"LoanType":56,"Description":"INDIRECT LENDING NEW RV","Payment":125.00,"AlternatePayment":0.00,"PmtBucketAmount":1125.00,"UserAmount2":0.00,"DueDate":"2021-12-25","DueDay1":0,"DueDay2":0,"LoanCode":"0","Balance":85000.00,"FirstPaymentDate":"2021-12-25","OpenDate":"2021-11-11","OriginalDate":"2021-11-11","LastAdvanceDate":"2021-11-11","ApprovalDate":"","CreatedAtBranch":"94","CreatedByUser":"2026","OriginalBalance":85000.00,"MaturityDate":"","LastPaymentDate":"","LastTranDate":"2021-11-11","CreditScore":"0","InterestRate":3.990,"InterestYtd":0.00,"InterestLastYear":0.00,"InterestRateMargin":0.000,"LateChargeUnpaid":0.00,"PastDueAmount":0.00,"InterestDue":195.13,"PartialPayment":0.00,"InsuranceType":"0","MicrAcctNumber":"","NoteNumber":"","ServiceValue1":"0","ServiceValue2":"0","ServiceValue3":"0","ServiceValue4":"0","ServiceValue5":"0","ServiceValue6":"0","ServiceValue7":"0","ServiceValue8":"0"}]';
        }
        system.debug('###'+strBody);
        return String.valueOf(strBody);
    }
    
    public static String GetSharesEFT(String accountNumber){
        ACH_To_Episys_API_Details__c api = ACH_To_Episys_API_Details__c.getValues('ProductionURL');
                
        if(api.URL__c != null){
            loanAPI = api.URL__c;
        }

        req = new HttpRequest();
        String endPoint = loanAPI + '/MARS/GetShareAccounts?accountNumber=' + accountNumber + '&userchar2=abc'; 
        req.setHeader('Content-Type', 'application/json');
        req.setHeader('Accept', 'application/json');
        req.setTimeout(60000);
        req.setEndpoint(endPoint);
        req.setMethod('GET');
        if (!Test.isRunningTest()){
            res = http.send(req);
            strBody = res.getBody();
        }
        else{
            strBody = '[{"Order":0,"AvailableBalance":"84975.00","Id":"0001","Type":0,"AccountType":null,"NameAndBalance":"0001 Available Balance( $84975.00)","AccountNumber":null,"Description":"PRIMARY SHARE","UserChar3":null,"UserAmount2":0.0,"CloseDate":"","ActivityDate":"2021-11-11","CreatedAtBranch":"94","CreatedByUser":"2026","MicrAcctNumber":"","Balance":85000.00,"OpenDate":"2021-11-11","LastTranDate":"2021-11-11","NegativeBalanceDate":"","MaturityDate":"","OverdraftTolerance":0.00,"DivType":"1","DivRate":0.000,"DivPostCode":"0","DivYtd":0.00,"DivLastYear":"0.00","LastDivAmount":0.00,"LastDivDate":"","ServiceEntryId1":null,"ServiceValue1":"30","ServiceEntryId2":null,"ServiceValue2":"3","ServiceEntryId3":null,"ServiceValue3":"0","ServiceEntryId4":null,"ServiceValue4":"0","ServiceEntryId5":null,"ServiceValue5":"0","ServiceEntryId6":null,"ServiceValue6":"0","ServiceEntryId7":null,"ServiceValue7":"0","ServiceEntryId8":null,"ServiceValue8":"0"}]';
        }        
        system.debug('###'+strBody);
        return String.valueOf(strBody);
    }
}