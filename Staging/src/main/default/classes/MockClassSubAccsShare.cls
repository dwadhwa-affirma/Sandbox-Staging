@isTest
global class MockClassSubAccsShare implements HttpCalloutMock{

    global HTTPResponse respond(HTTPRequest req) {
        
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/JSON');
       // res.setBody('{"CardDetail":null,"ShareDetail":{"AvailableBalance":"2609.26","Balance":"2659.26","CloseDate":"","LastTranDate":"2015-12-01T00:00:00Z","MaturityDate":"","OdtOptInOptionOther":"0","OdtOptInOptionRegE":"-1","AccountId":"0000018249S0100P0100","CpEligibility":-1,"CpRemovedDate":"","CpRevokedDate":"","LastOverdrawnDate":"","DivPostCode":0,"NegativeBalanceDate":"","OverdraftTolerance":null,"WarningCodes":{"WarningCode01":"000-NONE","WarningCode02":"000-NONE","WarningCode03":"000-NONE","WarningCode04":"000-NONE","WarningCode05":"000-NONE","WarningCode06":"000-NONE","WarningCode07":"000-NONE","WarningCode08":"000-NONE","WarningCode09":"000-NONE","WarningCode10":"000-NONE","WarningCode11":"000-NONE","WarningCode12":"000-NONE","WarningCode13":"000-NONE","WarningCode14":"000-NONE","WarningCode15":"000-NONE","WarningCode16":"000-NONE","WarningCode17":"000-NONE","WarningCode18":"000-NONE","WarningCode19":"000-NONE","WarningCode20":"000-NONE"}},"LoanDetail":null}');
        res.setBody('{"CardDetail":null,"ShareDetail":{"AvailableBalance":"696.8","Balance":"721.8","CloseDate":"","LastTranDate":"2016-08-31T00:00:00Z","MaturityDate":"","OdtOptInOptionOther":"0","OdtOptInOptionRegE":"-1","AccountId":"0000214414S0100P0100","CpEligibility":-1,"CpRemovedDate":"","CpRevokedDate":"","LastOverdrawnDate":"","DivPostCode":0,"NegativeBalanceDate":"","OverdraftTolerance":null,"WarningCodes":""},"LoanDetail":null}');
        res.setStatusCode(200);
        return res;
    }
}