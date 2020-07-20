@isTest
global class MockClassSubAccsLoan implements HttpCalloutMock{

    global HTTPResponse respond(HTTPRequest req) {
        
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/JSON');
       // res.setBody('{"CardDetail":null,"ShareDetail":null,"LoanDetail":{"AccountId":"0000018249L0100P0100","AvailableCredit":"7000","Balance":"0","CloseDate":"","CreditLimit":"7000","CreditLimitExpiration":null,"DueDate":"2015-12-25T00:00:00Z","InterestYtd":"0","InterestRate":"14.9","InterestRateMargin":"0","InterestRateMarginSign":"0","LastTranDate":"2011-12-02T00:00:00Z","LastPaymentDate":"2011-12-02T00:00:00Z","LateChargeDue":"0","LateChargeUnpaid":"0","MaturityDate":"2006-11-30T00:00:00Z","PartialPayment":"0","PastDueAmount":"0","PaymentDue":"0","PayoffAmount":"0","ServiceCodes":null,"WarningCodes":{"WarningCode01":"000-NONE","WarningCode02":"000-NONE","WarningCode03":"000-NONE","WarningCode04":"000-NONE","WarningCode05":"000-NONE","WarningCode06":"000-NONE","WarningCode07":"000-NONE","WarningCode08":"000-NONE","WarningCode09":"000-NONE","WarningCode10":"000-NONE","WarningCode11":"000-NONE","WarningCode12":"000-NONE","WarningCode13":"000-NONE","WarningCode14":"000-NONE","WarningCode15":"000-NONE","WarningCode16":"000-NONE","WarningCode17":"000-NONE","WarningCode18":"000-NONE","WarningCode19":"000-NONE","WarningCode20":"000-NONE"}}}');
        res.setBody('{"CardDetail":null,"ShareDetail":null,"LoanDetail":{"AccountId":"0000164414L3600P3600","AvailableCredit":"26242.09","Balance":"22757.91","CloseDate":"","CreditLimit":"49000","CreditLimitExpiration":null,"DueDate":"2016-10-04T00:00:00Z","InterestYtd":"1082","InterestRate":"5","InterestRateMargin":"1.5","InterestRateMarginSign":"0","LastTranDate":"2016-08-29T00:00:00Z","LastPaymentDate":"2016-08-29T00:00:00Z","LateChargeDue":"0","LateChargeUnpaid":"0","MaturityDate":"2033-09-29T00:00:00Z","PartialPayment":"0","PastDueAmount":"0","PaymentDue":"0","PayoffAmount":"22782.85","ServiceCodes":null,"WarningCodes":"084"}}');
        res.setStatusCode(200);
        return res;
    }
}