@isTest
global class MockClassAccs implements HttpCalloutMock{

    global HTTPResponse respond(HTTPRequest req) {
        
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/xml');
        //res.setBody('<SalesForceAccountSummary xmlns:i="http://www.w3.org/2001/XMLSchema-instance" xmlns="http://schemas.datacontract.org/2004/07/RealTimeApi.Data.Entities"><AccountId>0000018249A9999P9999</AccountId><ActivityDate>2015-12-21T00:00:00Z</ActivityDate><Cards xmlns:d2p1="http://schemas.datacontract.org/2004/07/RealTimeApi.Contracts.Domain"><d2p1:SalesForceCard><d2p1:AccountId>0000018249C9821P0061</d2p1:AccountId><d2p1:BlockCode></d2p1:BlockCode><d2p1:CardName>VINCENT J CAVALIERI</d2p1:CardName><d2p1:CardNumber>5460278000289821</d2p1:CardNumber><d2p1:ExpirationDate>2016-06-01T00:00:00Z</d2p1:ExpirationDate></d2p1:SalesForceCard><d2p1:SalesForceCard><d2p1:AccountId>0000018249C2666P0072</d2p1:AccountId><d2p1:BlockCode>L</d2p1:BlockCode><d2p1:CardName>VINCENT J CAVALIERI</d2p1:CardName><d2p1:CardNumber>4408680010242666</d2p1:CardNumber><d2p1:ExpirationDate>2009-03-01T00:00:00Z</d2p1:ExpirationDate></d2p1:SalesForceCard><d2p1:SalesForceCard><d2p1:AccountId>0000018249C2666P0073</d2p1:AccountId><d2p1:BlockCode>L</d2p1:BlockCode><d2p1:CardName>MARGARITA CAVALIERI</d2p1:CardName><d2p1:CardNumber>4408680010242666</d2p1:CardNumber><d2p1:ExpirationDate>2009-03-01T00:00:00Z</d2p1:ExpirationDate></d2p1:SalesForceCard><d2p1:SalesForceCard><d2p1:AccountId>0000018249C4391P0099</d2p1:AccountId><d2p1:BlockCode>X</d2p1:BlockCode><d2p1:CardName>VINCENT J CAVALIERI</d2p1:CardName><d2p1:CardNumber>4408680050724391</d2p1:CardNumber><d2p1:ExpirationDate>2011-01-01T00:00:00Z</d2p1:ExpirationDate></d2p1:SalesForceCard><d2p1:SalesForceCard><d2p1:AccountId>0000018249C0831P0130</d2p1:AccountId><d2p1:BlockCode></d2p1:BlockCode><d2p1:CardName>VINCENT J CAVALIERI</d2p1:CardName><d2p1:CardNumber>5460277815480831</d2p1:CardNumber><d2p1:ExpirationDate>2016-07-01T00:00:00Z</d2p1:ExpirationDate></d2p1:SalesForceCard><d2p1:SalesForceCard><d2p1:AccountId>0000018249C2347P0144</d2p1:AccountId><d2p1:BlockCode></d2p1:BlockCode><d2p1:CardName>MARGARITA R CAVALIERI</d2p1:CardName><d2p1:CardNumber>5460277953762347</d2p1:CardNumber><d2p1:ExpirationDate>2017-03-01T00:00:00Z</d2p1:ExpirationDate></d2p1:SalesForceCard></Cards><CommentAggregate>CHEVRON FEDERAL CREDIT UNION :BSI BREACH :PLZ DEPOSIT ALL CHECKS SEPARATELY :LOST/STOLEN VISA 4408680010242666 :</CommentAggregate><CorrespondenceDate>2005-09-29T00:00:00Z</CorrespondenceDate><FrozenMode>0</FrozenMode><FrozenTranslated>0 NORMAL</FrozenTranslated><InvalidPasswordAttempts>0</InvalidPasswordAttempts><LastLogonDate>2015-12-21T10:36:00Z</LastLogonDate><LastPasswordChangeDate></LastPasswordChangeDate><Loans><SalesForceLoan><AccountId>0000018249L0100P0100</AccountId><AvailableCredit>7000</AvailableCredit><CreditLimit i:nil="true" /><CreditLimitExpiration i:nil="true" /><DueDate>2015-12-25T00:00:00Z</DueDate><InteresetYtd>0</InteresetYtd><InterestRate i:nil="true" /><InterestRateMargin i:nil="true" /><InterestRateMarginSign>0</InterestRateMarginSign><InterestYtd i:nil="true" /><LastPaymentDate>2011-12-02T00:00:00Z</LastPaymentDate><LateChargeDue i:nil="true" /><LateChargeUnpaid i:nil="true" /><PartialPayment>0</PartialPayment><PastDueAmount>0</PastDueAmount><PaymentDue>0</PaymentDue><PayoffAmount>0</PayoffAmount><RealTimeApi.Contracts.Domain.ISalesForceLoanBase.InterestRateMarginSign i:nil="true" /></SalesForceLoan><SalesForceLoan><AccountId>0000018249L2000P0000</AccountId><AvailableCredit>0</AvailableCredit><CreditLimit i:nil="true" /><CreditLimitExpiration i:nil="true" /><DueDate>2008-12-25T00:00:00Z</DueDate><InteresetYtd>0</InteresetYtd><InterestRate i:nil="true" /><InterestRateMargin i:nil="true" /><InterestRateMarginSign>0</InterestRateMarginSign><InterestYtd i:nil="true" /><LastPaymentDate>2008-11-01T00:00:00Z</LastPaymentDate><LateChargeDue i:nil="true" /><LateChargeUnpaid i:nil="true" /><PartialPayment>0</PartialPayment><PastDueAmount>0</PastDueAmount><PaymentDue>0</PaymentDue><PayoffAmount>0</PayoffAmount><RealTimeApi.Contracts.Domain.ISalesForceLoanBase.InterestRateMarginSign i:nil="true" /></SalesForceLoan><SalesForceLoan><AccountId>0000018249L3600P0600</AccountId><AvailableCredit>0</AvailableCredit><CreditLimit i:nil="true" /><CreditLimitExpiration i:nil="true" /><DueDate>2008-01-05T00:00:00Z</DueDate><InteresetYtd>0</InteresetYtd><InterestRate i:nil="true" /><InterestRateMargin i:nil="true" /><InterestRateMarginSign>0</InterestRateMarginSign><InterestYtd i:nil="true" /><LastPaymentDate>2007-11-26T00:00:00Z</LastPaymentDate><LateChargeDue i:nil="true" /><LateChargeUnpaid i:nil="true" /><PartialPayment>0</PartialPayment><PastDueAmount>0</PastDueAmount><PaymentDue>0</PaymentDue><PayoffAmount>0</PayoffAmount><RealTimeApi.Contracts.Domain.ISalesForceLoanBase.InterestRateMarginSign i:nil="true" /></SalesForceLoan></Loans><MailingAddress><City>SAN RAMON</City><Country></Country><CountryCode></CountryCode><ExtraAddress></ExtraAddress><State>CA</State><Street>300 ADELAIDE HILLS CT</Street><ZipCode>94582-2894</ZipCode></MailingAddress><MemberId>0000018249</MemberId><Shares><SalesForceShare><AccountId>0000018249S0100P0100</AccountId><AvailableBalance>2609.26</AvailableBalance><CpEligibility>-1</CpEligibility><CpRemovedDate></CpRemovedDate><CpRevokedDate></CpRevokedDate><DivPostCode>0</DivPostCode><LastOverdrawnDate></LastOverdrawnDate><NegativeBalanceDate></NegativeBalanceDate><OdtOptInOptionOther>0</OdtOptInOptionOther><OdtOptInOptionRegE>7</OdtOptInOptionRegE><OdtOptInStatusOther>-1</OdtOptInStatusOther><OdtOptInStatusRegE>-1</OdtOptInStatusRegE><OverdraftTolerance>0</OverdraftTolerance></SalesForceShare><SalesForceShare><AccountId>0000018249S0400P0400</AccountId><AvailableBalance>2325.12</AvailableBalance><CpEligibility>-1</CpEligibility><CpRemovedDate></CpRemovedDate><CpRevokedDate></CpRevokedDate><DivPostCode>0</DivPostCode><LastOverdrawnDate></LastOverdrawnDate><NegativeBalanceDate></NegativeBalanceDate><OdtOptInOptionOther>0</OdtOptInOptionOther><OdtOptInOptionRegE>7</OdtOptInOptionRegE><OdtOptInStatusOther>-1</OdtOptInStatusOther><OdtOptInStatusRegE>-1</OdtOptInStatusRegE><OverdraftTolerance>0</OverdraftTolerance></SalesForceShare><SalesForceShare><AccountId>0000018249S0401P0401</AccountId><AvailableBalance>8300.46</AvailableBalance><CpEligibility>-1</CpEligibility><CpRemovedDate></CpRemovedDate><CpRevokedDate></CpRevokedDate><DivPostCode>0</DivPostCode><LastOverdrawnDate></LastOverdrawnDate><NegativeBalanceDate></NegativeBalanceDate><OdtOptInOptionOther>0</OdtOptInOptionOther><OdtOptInOptionRegE>7</OdtOptInOptionRegE><OdtOptInStatusOther>-1</OdtOptInStatusOther><OdtOptInStatusRegE>-1</OdtOptInStatusRegE><OverdraftTolerance>0</OverdraftTolerance></SalesForceShare><SalesForceShare><AccountId>0000018249S0402P0402</AccountId><AvailableBalance>849.49</AvailableBalance><CpEligibility>-1</CpEligibility><CpRemovedDate></CpRemovedDate><CpRevokedDate></CpRevokedDate><DivPostCode>0</DivPostCode><LastOverdrawnDate></LastOverdrawnDate><NegativeBalanceDate></NegativeBalanceDate><OdtOptInOptionOther>0</OdtOptInOptionOther><OdtOptInOptionRegE>7</OdtOptInOptionRegE><OdtOptInStatusOther>-1</OdtOptInStatusOther><OdtOptInStatusRegE>-1</OdtOptInStatusRegE><OverdraftTolerance>0</OverdraftTolerance></SalesForceShare><SalesForceShare><AccountId>0000018249S0403P0403</AccountId><AvailableBalance>4102.32</AvailableBalance><CpEligibility>-1</CpEligibility><CpRemovedDate></CpRemovedDate><CpRevokedDate></CpRevokedDate><DivPostCode>0</DivPostCode><LastOverdrawnDate></LastOverdrawnDate><NegativeBalanceDate></NegativeBalanceDate><OdtOptInOptionOther>0</OdtOptInOptionOther><OdtOptInOptionRegE>7</OdtOptInOptionRegE><OdtOptInStatusOther>-1</OdtOptInStatusOther><OdtOptInStatusRegE>-1</OdtOptInStatusRegE><OverdraftTolerance>0</OverdraftTolerance></SalesForceShare><SalesForceShare><AccountId>0000018249S0404P0404</AccountId><AvailableBalance>160.43</AvailableBalance><CpEligibility>-1</CpEligibility><CpRemovedDate></CpRemovedDate><CpRevokedDate></CpRevokedDate><DivPostCode>0</DivPostCode><LastOverdrawnDate></LastOverdrawnDate><NegativeBalanceDate></NegativeBalanceDate><OdtOptInOptionOther>0</OdtOptInOptionOther><OdtOptInOptionRegE>7</OdtOptInOptionRegE><OdtOptInStatusOther>-1</OdtOptInStatusOther><OdtOptInStatusRegE>-1</OdtOptInStatusRegE><OverdraftTolerance>0</OverdraftTolerance></SalesForceShare><SalesForceShare><AccountId>0000018249S0405P0405</AccountId><AvailableBalance>1861.11</AvailableBalance><CpEligibility>-1</CpEligibility><CpRemovedDate></CpRemovedDate><CpRevokedDate></CpRevokedDate><DivPostCode>0</DivPostCode><LastOverdrawnDate></LastOverdrawnDate><NegativeBalanceDate></NegativeBalanceDate><OdtOptInOptionOther>0</OdtOptInOptionOther><OdtOptInOptionRegE>7</OdtOptInOptionRegE><OdtOptInStatusOther>-1</OdtOptInStatusOther><OdtOptInStatusRegE>-1</OdtOptInStatusRegE><OverdraftTolerance>0</OverdraftTolerance></SalesForceShare><SalesForceShare><AccountId>0000018249S0406P0406</AccountId><AvailableBalance>12991.43</AvailableBalance><CpEligibility>-1</CpEligibility><CpRemovedDate></CpRemovedDate><CpRevokedDate></CpRevokedDate><DivPostCode>0</DivPostCode><LastOverdrawnDate></LastOverdrawnDate><NegativeBalanceDate></NegativeBalanceDate><OdtOptInOptionOther>0</OdtOptInOptionOther><OdtOptInOptionRegE>7</OdtOptInOptionRegE><OdtOptInStatusOther>-1</OdtOptInStatusOther><OdtOptInStatusRegE>-1</OdtOptInStatusRegE><OverdraftTolerance>0</OverdraftTolerance></SalesForceShare><SalesForceShare><AccountId>0000018249S0900P0900</AccountId><AvailableBalance>25651.88</AvailableBalance><CpEligibility>1</CpEligibility><CpRemovedDate></CpRemovedDate><CpRevokedDate></CpRevokedDate><DivPostCode>0</DivPostCode><LastOverdrawnDate></LastOverdrawnDate><NegativeBalanceDate></NegativeBalanceDate><OdtOptInOptionOther>0</OdtOptInOptionOther><OdtOptInOptionRegE>1</OdtOptInOptionRegE><OdtOptInStatusOther>2</OdtOptInStatusOther><OdtOptInStatusRegE>1</OdtOptInStatusRegE><OverdraftTolerance>700</OverdraftTolerance></SalesForceShare><SalesForceShare><AccountId>0000018249S2800P2800</AccountId><AvailableBalance>0</AvailableBalance><CpEligibility>-1</CpEligibility><CpRemovedDate></CpRemovedDate><CpRevokedDate></CpRevokedDate><DivPostCode>0</DivPostCode><LastOverdrawnDate></LastOverdrawnDate><NegativeBalanceDate></NegativeBalanceDate><OdtOptInOptionOther>0</OdtOptInOptionOther><OdtOptInOptionRegE>0</OdtOptInOptionRegE><OdtOptInStatusOther>-1</OdtOptInStatusOther><OdtOptInStatusRegE>-1</OdtOptInStatusRegE><OverdraftTolerance>0</OverdraftTolerance></SalesForceShare><SalesForceShare><AccountId>0000018249S2801P2801</AccountId><AvailableBalance>0</AvailableBalance><CpEligibility>-1</CpEligibility><CpRemovedDate></CpRemovedDate><CpRevokedDate></CpRevokedDate><DivPostCode>0</DivPostCode><LastOverdrawnDate></LastOverdrawnDate><NegativeBalanceDate></NegativeBalanceDate><OdtOptInOptionOther>0</OdtOptInOptionOther><OdtOptInOptionRegE>0</OdtOptInOptionRegE><OdtOptInStatusOther>-1</OdtOptInStatusOther><OdtOptInStatusRegE>-1</OdtOptInStatusRegE><OverdraftTolerance>0</OverdraftTolerance></SalesForceShare><SalesForceShare><AccountId>0000018249S2802P2802</AccountId><AvailableBalance>0</AvailableBalance><CpEligibility>-1</CpEligibility><CpRemovedDate></CpRemovedDate><CpRevokedDate></CpRevokedDate><DivPostCode>0</DivPostCode><LastOverdrawnDate></LastOverdrawnDate><NegativeBalanceDate></NegativeBalanceDate><OdtOptInOptionOther>0</OdtOptInOptionOther><OdtOptInOptionRegE>0</OdtOptInOptionRegE><OdtOptInStatusOther>-1</OdtOptInStatusOther><OdtOptInStatusRegE>-1</OdtOptInStatusRegE><OverdraftTolerance>0</OverdraftTolerance></SalesForceShare><SalesForceShare><AccountId>0000018249S2803P2803</AccountId><AvailableBalance>0</AvailableBalance><CpEligibility>-1</CpEligibility><CpRemovedDate></CpRemovedDate><CpRevokedDate></CpRevokedDate><DivPostCode>0</DivPostCode><LastOverdrawnDate></LastOverdrawnDate><NegativeBalanceDate></NegativeBalanceDate><OdtOptInOptionOther>0</OdtOptInOptionOther><OdtOptInOptionRegE>0</OdtOptInOptionRegE><OdtOptInStatusOther>-1</OdtOptInStatusOther><OdtOptInStatusRegE>-1</OdtOptInStatusRegE><OverdraftTolerance>0</OverdraftTolerance></SalesForceShare><SalesForceShare><AccountId>0000018249S2804P2804</AccountId><AvailableBalance>0</AvailableBalance><CpEligibility>-1</CpEligibility><CpRemovedDate></CpRemovedDate><CpRevokedDate></CpRevokedDate><DivPostCode>0</DivPostCode><LastOverdrawnDate></LastOverdrawnDate><NegativeBalanceDate></NegativeBalanceDate><OdtOptInOptionOther>0</OdtOptInOptionOther><OdtOptInOptionRegE>0</OdtOptInOptionRegE><OdtOptInStatusOther>-1</OdtOptInStatusOther><OdtOptInStatusRegE>-1</OdtOptInStatusRegE><OverdraftTolerance>0</OverdraftTolerance></SalesForceShare><SalesForceShare><AccountId>0000018249S2805P2805</AccountId><AvailableBalance>0</AvailableBalance><CpEligibility>-1</CpEligibility><CpRemovedDate></CpRemovedDate><CpRevokedDate></CpRevokedDate><DivPostCode>0</DivPostCode><LastOverdrawnDate></LastOverdrawnDate><NegativeBalanceDate></NegativeBalanceDate><OdtOptInOptionOther>0</OdtOptInOptionOther><OdtOptInOptionRegE>7</OdtOptInOptionRegE><OdtOptInStatusOther>-1</OdtOptInStatusOther><OdtOptInStatusRegE>-1</OdtOptInStatusRegE><OverdraftTolerance>0</OverdraftTolerance></SalesForceShare><SalesForceShare><AccountId>0000018249S2806P2806</AccountId><AvailableBalance>0</AvailableBalance><CpEligibility>-1</CpEligibility><CpRemovedDate></CpRemovedDate><CpRevokedDate></CpRevokedDate><DivPostCode>0</DivPostCode><LastOverdrawnDate></LastOverdrawnDate><NegativeBalanceDate></NegativeBalanceDate><OdtOptInOptionOther>0</OdtOptInOptionOther><OdtOptInOptionRegE>7</OdtOptInOptionRegE><OdtOptInStatusOther>-1</OdtOptInStatusOther><OdtOptInStatusRegE>-1</OdtOptInStatusRegE><OverdraftTolerance>0</OverdraftTolerance></SalesForceShare><SalesForceShare><AccountId>0000018249S2807P2807</AccountId><AvailableBalance>0</AvailableBalance><CpEligibility>-1</CpEligibility><CpRemovedDate></CpRemovedDate><CpRevokedDate></CpRevokedDate><DivPostCode>0</DivPostCode><LastOverdrawnDate></LastOverdrawnDate><NegativeBalanceDate></NegativeBalanceDate><OdtOptInOptionOther>0</OdtOptInOptionOther><OdtOptInOptionRegE>7</OdtOptInOptionRegE><OdtOptInStatusOther>-1</OdtOptInStatusOther><OdtOptInStatusRegE>-1</OdtOptInStatusRegE><OverdraftTolerance>0</OverdraftTolerance></SalesForceShare><SalesForceShare><AccountId>0000018249S2808P2808</AccountId><AvailableBalance>0</AvailableBalance><CpEligibility>-1</CpEligibility><CpRemovedDate></CpRemovedDate><CpRevokedDate></CpRevokedDate><DivPostCode>0</DivPostCode><LastOverdrawnDate></LastOverdrawnDate><NegativeBalanceDate></NegativeBalanceDate><OdtOptInOptionOther>0</OdtOptInOptionOther><OdtOptInOptionRegE>7</OdtOptInOptionRegE><OdtOptInStatusOther>-1</OdtOptInStatusOther><OdtOptInStatusRegE>-1</OdtOptInStatusRegE><OverdraftTolerance>0</OverdraftTolerance></SalesForceShare></Shares><StatementMailCode>1</StatementMailCode><StatementMailTranslate>0001 Normal Mail</StatementMailTranslate><Type>1</Type><TypeTranslate>01 PERSONAL</TypeTranslate><WarningCodes><WarningCode01>045-FUNDS TRANSFER OK</WarningCode01><WarningCode02>050-ELAN CREDIT CARD</WarningCode02><WarningCode03>000-NONE</WarningCode03><WarningCode04>000-NONE</WarningCode04><WarningCode05>000-NONE</WarningCode05><WarningCode06>000-NONE</WarningCode06><WarningCode07>000-NONE</WarningCode07><WarningCode08>000-NONE</WarningCode08><WarningCode09>000-NONE</WarningCode09><WarningCode10>000-NONE</WarningCode10><WarningCode11>000-NONE</WarningCode11><WarningCode12>000-NONE</WarningCode12><WarningCode13>000-NONE</WarningCode13><WarningCode14>000-NONE</WarningCode14><WarningCode15>000-NONE</WarningCode15><WarningCode16>000-NONE</WarningCode16><WarningCode17>000-NONE</WarningCode17><WarningCode18>000-NONE</WarningCode18><WarningCode19>000-NONE</WarningCode19><WarningCode20>000-NONE</WarningCode20></WarningCodes></SalesForceAccountSummary>');
        res.setBody('<SalesForceAccountSummary xmlns:i="http://www.w3.org/2001/XMLSchema-instance" xmlns="http://schemas.datacontract.org/2004/07/RealTimeApi.Data.Entities"><AccountId>0000164414A9999P9999</AccountId><ActivityDate>2016-09-13T00:00:00Z</ActivityDate><Cards xmlns:d2p1="http://schemas.datacontract.org/2004/07/RealTimeApi.Contracts.Domain"><d2p1:SalesForceCard><d2p1:AccountId>0000164414C0010P0010</d2p1:AccountId><d2p1:BlockCode></d2p1:BlockCode><d2p1:CardName>PAUL FARLEY</d2p1:CardName><d2p1:CardNumber>5823900009000497463</d2p1:CardNumber><d2p1:ExpirationDate>2012-02-01T00:00:00Z</d2p1:ExpirationDate><d2p1:WarningCodes></d2p1:WarningCodes></d2p1:SalesForceCard><d2p1:SalesForceCard><d2p1:AccountId>0000164414C0017P0017</d2p1:AccountId><d2p1:BlockCode></d2p1:BlockCode><d2p1:CardName>PAUL FARLEY</d2p1:CardName><d2p1:CardNumber>5460278001241565</d2p1:CardNumber><d2p1:ExpirationDate>2016-10-01T00:00:00Z</d2p1:ExpirationDate><d2p1:WarningCodes></d2p1:WarningCodes></d2p1:SalesForceCard></Cards><CommentAggregate>CHEVRON FEDERAL CREDIT UNION :VICTIM OF ID THEFT PLEASE ASK PW FOR ALL :PW = PKF5594@JANET : :</CommentAggregate><CorrespondenceDate>2016-06-20T00:00:00Z</CorrespondenceDate><FrozenMode>0</FrozenMode><FrozenTranslated>0 NORMAL</FrozenTranslated><InvalidPasswordAttempts>0</InvalidPasswordAttempts><LastLogonDate>2013-10-04T16:42:00Z</LastLogonDate><LastPasswordChangeDate></LastPasswordChangeDate><Loans><SalesForceLoan><AccountId>0000164414L3600P0600</AccountId><AvailableCredit>26720.33</AvailableCredit><CreditLimit i:nil="true" /><CreditLimitExpiration i:nil="true" /><DueDate>2016-11-04T00:00:00Z</DueDate><InteresetYtd>1128.76</InteresetYtd><InterestRate i:nil="true" /><InterestRateMargin i:nil="true" /><InterestRateMarginSign>0</InterestRateMarginSign><InterestYtd i:nil="true" /><LastPaymentDate>2016-09-13T00:00:00Z</LastPaymentDate><LateChargeDue i:nil="true" /><LateChargeUnpaid i:nil="true" /><PartialPayment>0</PartialPayment><PastDueAmount>0</PastDueAmount><PaymentDue>0</PaymentDue><PayoffAmount>22297.98</PayoffAmount><RealTimeApi.Contracts.Domain.ISalesForceLoanBase.InterestRateMarginSign i:nil="true" /><WarningCodes>084</WarningCodes></SalesForceLoan><SalesForceLoan><AccountId>0000164414L5000P0000</AccountId><AvailableCredit>0</AvailableCredit><CreditLimit i:nil="true" /><CreditLimitExpiration i:nil="true" /><DueDate>2016-10-20T00:00:00Z</DueDate><InteresetYtd>129.15</InteresetYtd><InterestRate i:nil="true" /><InterestRateMargin i:nil="true" /><InterestRateMarginSign>0</InterestRateMarginSign><InterestYtd i:nil="true" /><LastPaymentDate>2016-09-13T00:00:00Z</LastPaymentDate><LateChargeDue i:nil="true" /><LateChargeUnpaid i:nil="true" /><PartialPayment>0</PartialPayment><PastDueAmount>0</PastDueAmount><PaymentDue>0</PaymentDue><PayoffAmount>25481.04</PayoffAmount><RealTimeApi.Contracts.Domain.ISalesForceLoanBase.InterestRateMarginSign i:nil="true" /><WarningCodes></WarningCodes></SalesForceLoan></Loans><MailingAddress><City>LINDA</City><Country></Country><CountryCode></CountryCode><ExtraAddress></ExtraAddress><State>CA</State><Street>5594 PEACH TREE DR</Street><ZipCode>95901-8341</ZipCode></MailingAddress><MemberId>0000164414</MemberId><Shares><SalesForceShare><AccountId>0000164414S0100P0100</AccountId><AvailableBalance>82.15</AvailableBalance><CpEligibility>-1</CpEligibility><CpRemovedDate></CpRemovedDate><CpRevokedDate></CpRevokedDate><DivPostCode>0</DivPostCode><LastOverdrawnDate></LastOverdrawnDate><NegativeBalanceDate></NegativeBalanceDate><OdtOptInOptionOther>0</OdtOptInOptionOther><OdtOptInOptionRegE>7</OdtOptInOptionRegE><OdtOptInStatusOther>-1</OdtOptInStatusOther><OdtOptInStatusRegE>-1</OdtOptInStatusRegE><OverdraftTolerance>0</OverdraftTolerance><WarningCodes></WarningCodes></SalesForceShare><SalesForceShare><AccountId>0000164414S0400P0400</AccountId><AvailableBalance>39.78</AvailableBalance><CpEligibility>-1</CpEligibility><CpRemovedDate></CpRemovedDate><CpRevokedDate></CpRevokedDate><DivPostCode>0</DivPostCode><LastOverdrawnDate></LastOverdrawnDate><NegativeBalanceDate></NegativeBalanceDate><OdtOptInOptionOther>0</OdtOptInOptionOther><OdtOptInOptionRegE>7</OdtOptInOptionRegE><OdtOptInStatusOther>-1</OdtOptInStatusOther><OdtOptInStatusRegE>-1</OdtOptInStatusRegE><OverdraftTolerance>0</OverdraftTolerance><WarningCodes></WarningCodes></SalesForceShare><SalesForceShare><AccountId>0000164414S0900P0900</AccountId><AvailableBalance>539.14</AvailableBalance><CpEligibility>1</CpEligibility><CpRemovedDate></CpRemovedDate><CpRevokedDate></CpRevokedDate><DivPostCode>0</DivPostCode><LastOverdrawnDate></LastOverdrawnDate><NegativeBalanceDate></NegativeBalanceDate><OdtOptInOptionOther>0</OdtOptInOptionOther><OdtOptInOptionRegE>7</OdtOptInOptionRegE><OdtOptInStatusOther>1</OdtOptInStatusOther><OdtOptInStatusRegE>0</OdtOptInStatusRegE><OverdraftTolerance>700</OverdraftTolerance><WarningCodes></WarningCodes></SalesForceShare></Shares><StatementMailCode>1</StatementMailCode><StatementMailTranslate>0001 Normal Mail</StatementMailTranslate><Type>1</Type><TypeTranslate>01 PERSONAL</TypeTranslate><WarningCodes>045</WarningCodes></SalesForceAccountSummary>');
        res.setStatusCode(200);
        return res;
    }
}