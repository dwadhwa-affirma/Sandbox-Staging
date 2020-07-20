@isTest
global class MockClassSubAccs implements HttpCalloutMock{

    global HTTPResponse respond(HTTPRequest req) {
        
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/JSON');
       // res.setBody('{"CardDetail":{"AccountId":"0000018249C9821P0061","AuthLimit":"2500","BlockCode":"","CardName":"VINCENT J CAVALIERI","CardNumber":"5460278000289821","CloseDate":"","DepLimit":"500","ExpirationDate":"2016-06-01T00:00:00Z","Status":1,"StatusReason":0,"WarningCodes":{"WarningCode01":"000-NONE","WarningCode02":"000-NONE","WarningCode03":"000-NONE","WarningCode04":"000-NONE","WarningCode05":"000-NONE","WarningCode06":"000-NONE","WarningCode07":"000-NONE","WarningCode08":"000-NONE","WarningCode09":"000-NONE","WarningCode10":"000-NONE","WarningCode11":"000-NONE","WarningCode12":"000-NONE","WarningCode13":"000-NONE","WarningCode14":"000-NONE","WarningCode15":"000-NONE","WarningCode16":"000-NONE","WarningCode17":"000-NONE","WarningCode18":"000-NONE","WarningCode19":"000-NONE","WarningCode20":"000-NONE"}},"ShareDetail":null,"LoanDetail":null}');
        res.setBody('{"CardDetail":{"AccountId":"0000214414C0010P0010","AuthLimit":"2500","BlockCode":"","CardName":"JEFF PACHECO FRANKLIN","CardNumber":"5460277062845116","CloseDate":"2016-08-16T00:00:00Z","DepLimit":"500","ExpirationDate":"2019-06-01T00:00:00Z","Status":2,"StatusReason":20,"WarningCodes":""},"ShareDetail":null,"LoanDetail":null}');
        res.setStatusCode(200);
        return res;
    } 
    
}