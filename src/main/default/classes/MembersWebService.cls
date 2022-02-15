@RestResource(urlMapping = '/Member/*')
global with sharing class MembersWebService{
    @HttpPOST
    global static void checkMemberDetails(){
        RestRequest request = RestContext.request;
        // grab the accountId from the end of the URL
        String accountNumber = request.params.get('AccountNumber');//request.requestURI.substring(request.requestURI.lastIndexOf('/')+1);
        String appId = request.params.get('AppId');
        system.debug('###' + accountNumber);
        List<Account_Details__c> lstAccountDetails = new List<Account_Details__c>();
        lstAccountDetails = [SELECT Id, Name
                             FROM Account_Details__c
                             WHERE Name = :accountNumber];
        //system.debug('###'+ lstAccountDetails.size());

        List<RecordType> membershipRecordType = [select id, name
                                                 from RecordType
                                                 where Name = 'Membership'];

        List<RecordType> cardRecordType = [select id, name
                                           from RecordType
                                           where Name = 'Card'];

        List<RecordType> shareRecordType = [select id, name
                                            from RecordType
                                            where Name = 'Share'];

        List<RecordType> loanRecordType = [select id, name
                                           from RecordType
                                           where Name = 'Loan'];       


        String accts = GetSymxapiRecByAccountNumber.GetACCTRecordsbyAccountNumber(accountNumber);
        String cards = GetSymxapiRecByAccountNumber.GetCardsbyAccountNumber(accountNumber);
        String loans = GetSymxapiRecByAccountNumber.GetLoansSelectFields(accountNumber);
        String shares = GetSymxapiRecByAccountNumber.GetSharesEFT(accountNumber);

        system.debug('###accts==' + accts);
        system.debug('###cards==' + cards);
        system.debug('###loans==' + loans);
        system.debug('###shares==' + shares);

        Map<string, Object> lstAccts = (Map<string, Object>)JSON.deserializeUntyped(accts);
        List<Object> lstCards = (List<Object>)JSON.deserializeUntyped(cards);
        List<Object> lstLoans = (List<Object>)JSON.deserializeUntyped(loans);
        List<Object> lstShares = (List<Object>)JSON.deserializeUntyped(shares);

        system.debug('lstAccts###' + lstAccts);
        system.debug('lstCards###' + lstCards);
        system.debug('lstLoans###' + lstLoans);
        system.debug('lstShares###' + lstShares);

        if (lstAccountDetails.size() == 0){
            Id ACCTId;
            if (lstAccts.size() > 0){
                //Accounts to be inserted for ACCT Record Type
                Account_Details__c objAccount = new Account_Details__c();
                Map<String, Object> objItem = lstAccts;
                system.debug('objItem###' + objItem);
                objAccount.Name = String.valueof(objItem.get('AccountNumber'));
                if (String.isNotBlank(String.valueof(objItem.get('ActivityDate')))){
                    system.debug('ActivityDate=='+(string) objItem.get('ActivityDate'));
                    Date activitydate = Date.valueOf(String.valueof(objItem.get('ActivityDate')));
                    //Date myDate = date.newinstance(activitydate.year() + 2000, activitydate.month(), activitydate.day());
                    if(activitydate != date.newInstance(0001, 01, 01)){
                        objAccount.Activity_Date__c = activitydate;
                    }                    
                }
                if (String.isNotBlank(String.valueof(objItem.get('CorrespondDate')))){
                    system.debug('Corr Date=='+(string) objItem.get('CorrespondDate'));
                    Date cdate = Date.valueOf((string) objItem.get('CorrespondDate'));
                   // Date myDate = date.newinstance(cdate.year() + 2000, cdate.month(), cdate.day());
                   system.debug('cdate=='+cdate);
                   if(cdate != date.newInstance(0001, 01, 01)){
                        objAccount.Correspondence_Date__c = cdate;
                   }                    
                }
                if (String.isNotBlank(String.valueof(objItem.get('CreatedAtBranch')))){
                    objAccount.Created_At_Branch__c = Decimal.valueof(String.valueof(objItem.get('CreatedAtBranch')));
                }
                if (String.isNotBlank(String.valueof(objItem.get('CreatedByUser')))){
                    objAccount.Created_By_User__c = Decimal.valueof(String.valueof(objItem.get('CreatedByUser')));
                }

                if (String.isNotBlank(String.valueof(objItem.get('InvalidAttemptCount')))){
                    system.debug('InvalidAttemptCount==' + String.valueof(objItem.get('InvalidAttemptCount')));
                    objAccount.Invalid_Password_Attempts__c = Decimal.valueof(String.valueof(objItem.get('InvalidAttemptCount')));
                }

                if (String.isNotBlank(String.valueof(objItem.get('MemberGroup')))){
                    objAccount.Member_Group_Seg__c = Decimal.valueof(String.valueof(objItem.get('MemberGroup')));
                }

                if (String.isNotBlank(String.valueof(objItem.get('OpenDate')))){
                    Date odate = Date.valueOf(String.valueof(objItem.get('OpenDate')));
                    //Date myDate = date.newinstance(odate.year() +, odate.month(), odate.day());
                    objAccount.OPEN_DATE__c = odate;
                }

                objAccount.Reference__c = String.valueof(objItem.get('Reference'));
                objAccount.Brand_Code__c = String.valueof(objItem.get('Reference'));

                if (String.isNotBlank(String.valueof(objItem.get('Restrict')))){
                    objAccount.RESTRICTED_ACCESS__c = Decimal.valueof(String.valueof(objItem.get('Restrict')));
                }

                if (String.isNotBlank(String.valueof(objItem.get('StatementMailCode')))){
                    objAccount.STATEMENT_MAIL_CODE__c = Decimal.valueof(String.valueof(objItem.get('StatementMailCode')));
                }

                if (String.isNotBlank(String.valueof(objItem.get('Type')))){
                    objAccount.TYPE__c = Decimal.valueof(String.valueof(objItem.get('Type')));
                }
                //App_id__c = 'RV ' + String.valueof(........)
                if (String.isNotBlank(appId)){
                    objAccount.App_id__c = 'RV ' + appId;
                }

                objAccount.RecType__c = 'ACCT';
                objAccount.RecTypeID__c = 'A9999';

                if (membershipRecordType.size() > 0){
                    objAccount.RecordTypeId = membershipRecordType[0].Id;
                }
                system.debug('objAccount==' + objAccount);
                insert objAccount;
                ACCTId = objAccount.Id;

                List<Object> NameObject = (List<Object>)objItem.get('NameObjects');
                system.debug('###' + NameObject);
                map<string, object> resultMemberMap = CreateUpdateMemberRecord(NameObject);
                List<Account> PAToInsert = (List<Account>)resultMemberMap.get('Insert');
                for(Account a: PAToInsert){
                    CreateUpdatePersonRecord('ACCT', ACCTId, a.Id, a.PersonId__c);
                }                
            }

            if (lstCards.size() > 0){
                List<Account_Details__c> lstCardAccounts = new List<Account_Details__c>();
                for (Object obj : lstCards){
                    Account_Details__c tempCardObj = new Account_Details__c();
                    Map<String, Object> objItem = (Map<String, Object>)obj;
                    //system.debug('objItem=='+objItem);

                    tempCardObj.name = accountNumber;
                    if (string.isNotBlank(ACCTId)){
                        tempCardObj.Parent_Account__c = ACCTId;
                    }

                    tempCardObj.Description__c = String.valueof(objItem.get('Description'));

                    if (String.isNotBlank(String.valueof(objItem.get('CreatedAtBranch')))){
                        tempCardObj.Created_At_Branch__c = Decimal.valueof(String.valueof(objItem.get('CreatedAtBranch')));
                    }
                    if (String.isNotBlank(String.valueof(objItem.get('CreatedByUser')))){
                        tempCardObj.Created_By_User__c = Decimal.valueof(String.valueof(objItem.get('CreatedByUser')));
                    }

                    tempCardObj.Card_Number__c = String.valueof(objItem.get('CardNumber'));
                    system.debug('longname==' + String.valueof(objItem.get('LongName')));
                    tempCardObj.Card_Name__c = String.valueof(objItem.get('LongName'));
                    tempCardObj.STATUS__c = (Integer) objItem.get('CardStatus');

                    if (String.isNotBlank(String.valueof(objItem.get('StatusReason')))){
                        tempCardObj.STATUSREASON__c = Decimal.valueof((string) objItem.get('StatusReason'));
                    }

                    if (String.isNotBlank(String.valueof(objItem.get('CloseDate')))){
                        date cdate = Date.valueOf(String.valueof(objItem.get('CloseDate')));
                        tempCardObj.Close_Date__c = cdate;
                    }

                    if (String.isNotBlank(String.valueof(objItem.get('ExpirationDate')))){
                        date cdate = Date.valueOf(String.valueof(objItem.get('ExpirationDate')));
                        tempCardObj.Expiration_Date__c = cdate;
                    }

                    if (String.isNotBlank(String.valueof(objItem.get('IssueDate')))){
                        date cdate = Date.valueOf(String.valueof(objItem.get('IssueDate')));
                        tempCardObj.Issue_Date__c = cdate;
                    }

                    tempCardObj.DepLimit__c = Decimal.valueof(String.valueof(objItem.get('DepLimit')));
                    tempCardObj.Limit_Amount__c = Decimal.valueof(String.valueof(objItem.get('LimitAmount')));
                    tempCardObj.POSLIMIT__c = Decimal.valueof(String.valueof(objItem.get('PosLimit')));
                    tempCardObj.AuthLimit__c = Decimal.valueof(String.valueof(objItem.get('AuthLimit')));
                    tempCardObj.RecType__c = 'CARD';
                    tempCardObj.RecTypeID__c = 'C' + tempCardObj.Card_Number__c.right(4);
                    if (cardRecordType.size() > 0){
                        tempCardObj.RecordTypeId = cardRecordType[0].Id;
                    }

                    system.debug('tempCardObj==' + tempCardObj);
                    if (tempCardObj.Close_Date__c == null){
                        lstCardAccounts.add(tempCardObj);
                    }
                }
                system.debug('lstCardAccounts.size==' + lstCardAccounts.size());
                insert lstCardAccounts;
            }

            if (lstLoans.size() > 0){
                List<Account_Details__c> lstLoanAccounts = new List<Account_Details__c>();
                for (Object obj : lstLoans){
                    Account_Details__c tempLoanObj = new Account_Details__c();
                    Map<String, Object> objItem = (Map<String, Object>)obj;
                    //system.debug('objItem=='+objItem);

                    tempLoanObj.name = accountNumber;
                    if (string.isNotBlank(ACCTId)){
                        tempLoanObj.Parent_Account__c = ACCTId;
                    }

                    tempLoanObj.Description__c = String.valueof(objItem.get('Description'));

                    if (String.isNotBlank(String.valueof(objItem.get('CreatedAtBranch')))){
                        tempLoanObj.Created_At_Branch__c = Decimal.valueof(String.valueof(objItem.get('CreatedAtBranch')));
                    }
                    if (String.isNotBlank(String.valueof(objItem.get('CreatedByUser')))){
                        tempLoanObj.Created_By_User__c = Decimal.valueof(String.valueof(objItem.get('CreatedByUser')));
                    }

                    tempLoanObj.ID1__c = String.valueof(objItem.get('LoanId'));
                    if (String.isNotBlank(String.valueof(objItem.get('LoanCode')))){
                        tempLoanObj.Loan_code__c = Decimal.valueof((String.valueof(objItem.get('LoanCode'))));
                    }

                    tempLoanObj.Balance__c = Decimal.valueof(String.valueof(objItem.get('Balance')));
                    tempLoanObj.ORIGINALBALANCE__c = Decimal.valueof(String.valueof(objItem.get('OriginalBalance')));

                    if (String.isNotBlank(String.valueof(objItem.get('DueDate')))){
                        date cdate = Date.valueOf(String.valueof(objItem.get('DueDate')));
                        tempLoanObj.Due_Date__c = cdate;
                    }

                    if (String.isNotBlank(String.valueof(objItem.get('OriginalDate')))){
                        date cdate = Date.valueOf(String.valueof(objItem.get('OriginalDate')));
                        tempLoanObj.ORIGINALDATE__c = cdate;
                    }
                    if (String.isNotBlank(String.valueof(objItem.get('OpenDate')))){
                        date cdate = Date.valueOf(String.valueof(objItem.get('OpenDate')));
                        tempLoanObj.OPEN_DATE__c = cdate;
                    }
                    if (String.isNotBlank(String.valueof(objItem.get('MaturityDate')))){
                        date cdate = Date.valueOf(String.valueof(objItem.get('MaturityDate')));
                        tempLoanObj.Maturity_Date__c = cdate;
                    }
                    if (String.isNotBlank(String.valueof(objItem.get('LastPaymentDate')))){
                        date cdate = Date.valueOf(String.valueof(objItem.get('LastPaymentDate')));
                        tempLoanObj.Last_Payment_Date__c = cdate;
                    }
                    if (String.isNotBlank(String.valueof(objItem.get('LastTranDate')))){
                        date cdate = Date.valueOf(String.valueof(objItem.get('LastTranDate')));
                        tempLoanObj.Last_Transaction_Date__c = cdate;
                    }


                    tempLoanObj.Credit_Score__c = String.valueof(objItem.get('CreditScore'));
                    if (String.isNotBlank(String.valueof(objItem.get('InterestRate')))){
                        tempLoanObj.Interest_Rate__c = Decimal.valueof(String.valueof(objItem.get('InterestRate')));
                    }

                    if (String.isNotBlank(String.valueof(objItem.get('InterestYtd')))){
                        tempLoanObj.Interest_YTD__c = Decimal.valueof(String.valueof(objItem.get('InterestYtd')));
                    }

                    if (String.isNotBlank(String.valueof(objItem.get('InterestLastYear')))){
                        tempLoanObj.Interest_Last_Year__c = Decimal.valueof(String.valueof(objItem.get('InterestLastYear')));
                    }

                    if (String.isNotBlank(String.valueof(objItem.get('InterestRateMargin')))){
                        tempLoanObj.Interest_Rate_Margin__c = Decimal.valueof(String.valueof(objItem.get('InterestRateMargin')));
                    }

                    if (String.isNotBlank(String.valueof(objItem.get('LateChargeUnpaid')))){
                        tempLoanObj.Late_Charge_Unpaid__c = Decimal.valueof(String.valueof(objItem.get('LateChargeUnpaid')));
                    }

                    if (String.isNotBlank(String.valueof(objItem.get('PastDueAmount')))){
                        tempLoanObj.PASTDUEPAYMENT__c = Decimal.valueof(String.valueof(objItem.get('PastDueAmount')));
                    }

                    if (String.isNotBlank(String.valueof(objItem.get('InterestDue')))){
                        tempLoanObj.Interest_Past_Due__c = Decimal.valueof(String.valueof(objItem.get('InterestDue')));
                    }

                    if (String.isNotBlank(String.valueof(objItem.get('PartialPayment')))){
                        tempLoanObj.PARTIALPAYMENT__c = Decimal.valueof(String.valueof(objItem.get('PartialPayment')));
                    }

                    if (String.isNotBlank(String.valueof(objItem.get('Payment')))){
                        tempLoanObj.PAYMENT__c = Decimal.valueof(String.valueof(objItem.get('Payment')));
                    }

                    if (String.isNotBlank(String.valueof(objItem.get('InsuranceType')))){
                        tempLoanObj.Insurance_Type__c = Decimal.valueof(String.valueof(objItem.get('InsuranceType')));
                    }

                    tempLoanObj.MICR_Account_Number__c = String.valueof(objItem.get('MicrAcctNumber'));
                    tempLoanObj.NOTENUMBER__c = String.valueof(objItem.get('NoteNumber'));


                    if (String.isNotBlank(String.valueof(objItem.get('ServiceValue1')))){
                        tempLoanObj.SERVICE_1__c = Decimal.valueof(String.valueof(objItem.get('ServiceValue1')));
                    }

                    if (String.isNotBlank(String.valueof(objItem.get('ServiceValue2')))){
                        tempLoanObj.SERVICE_2__c = Decimal.valueof(String.valueof(objItem.get('ServiceValue2')));
                    }

                    if (String.isNotBlank(String.valueof(objItem.get('ServiceValue3')))){
                        tempLoanObj.SERVICE_3__c = Decimal.valueof(String.valueof(objItem.get('ServiceValue3')));
                    }

                    if (String.isNotBlank(String.valueof(objItem.get('ServiceValue4')))){
                        tempLoanObj.SERVICE_4__c = Decimal.valueof(String.valueof(objItem.get('ServiceValue4')));
                    }

                    if (String.isNotBlank(String.valueof(objItem.get('ServiceValue5')))){
                        tempLoanObj.SERVICE_5__c = Decimal.valueof(String.valueof(objItem.get('ServiceValue5')));
                    }

                    if (String.isNotBlank(String.valueof(objItem.get('ServiceValue6')))){
                        tempLoanObj.SERVICE_6__c = Decimal.valueof(String.valueof(objItem.get('ServiceValue6')));
                    }

                    if (String.isNotBlank(String.valueof(objItem.get('ServiceValue7')))){
                        tempLoanObj.SERVICE_7__c = Decimal.valueof(String.valueof(objItem.get('ServiceValue7')));
                    }

                    if (String.isNotBlank(String.valueof(objItem.get('ServiceValue8')))){
                        tempLoanObj.SERVICE_8__c = Decimal.valueof(String.valueof(objItem.get('ServiceValue8')));
                    }
                    tempLoanObj.RecType__c = 'LOAN';
                    tempLoanObj.RecTypeID__c = 'L' + tempLoanObj.ID1__c;
                    if (loanRecordType.size() > 0){
                        tempLoanObj.RecordTypeId = loanRecordType[0].Id;
                    }

                    system.debug('tempLoanObj==' + tempLoanObj);
                    if (tempLoanObj.Close_Date__c == null && String.isNotBlank(tempLoanObj.ID1__c) && tempLoanObj.ID1__c != '0'){
                        lstLoanAccounts.add(tempLoanObj);
                    }
                }
                system.debug('lstLoanAccounts.size==' + lstLoanAccounts.size());
                insert lstLoanAccounts;
            }

            if (lstShares.size() > 0){
                List<Account_Details__c> lstShareAccounts = new List<Account_Details__c>();
                for (Object obj : lstShares){
                    Account_Details__c tempShareObj = new Account_Details__c();
                    Map<String, Object> objItem = (Map<String, Object>)obj;
                    //system.debug('objItem=='+objItem);

                    tempShareObj.name = accountNumber;
                    if (string.isNotBlank(ACCTId)){
                        tempShareObj.Parent_Account__c = ACCTId;
                    }

                    tempShareObj.Description__c = String.valueof(objItem.get('Description'));

                    if (String.isNotBlank(String.valueof(objItem.get('CreatedAtBranch')))){
                        tempShareObj.Created_At_Branch__c = Decimal.valueof(String.valueof(objItem.get('CreatedAtBranch')));
                    }
                    if (String.isNotBlank(String.valueof(objItem.get('CreatedByUser')))){
                        tempShareObj.Created_By_User__c = Decimal.valueof(String.valueof(objItem.get('CreatedByUser')));
                    }

                    if (String.isNotBlank(String.valueof(objItem.get('ActivityDate')))){
                        Date activitydate = Date.valueOf(String.valueof(objItem.get('ActivityDate')));
                        //Date cdate = date.newinstance(activitydate.year() + 2000, activitydate.month(), activitydate.day());
                        tempShareObj.Activity_Date__c = activitydate;
                    }


                    tempShareObj.MICR_Account_Number__c = String.valueof(objItem.get('MicrAcctNumber'));
                    tempShareObj.ID1__c = String.valueof(objItem.get('Id'));

                    if (String.isNotBlank(String.valueof(objItem.get('Balance')))){
                        tempShareObj.Balance__c = Decimal.valueof(String.valueof(objItem.get('Balance')));
                    }

                    if (String.isNotBlank(String.valueof(objItem.get('AvailableBalance')))){
                        tempShareObj.Available_Balance__c = Decimal.valueof(String.valueof(objItem.get('AvailableBalance')));
                    }

                    if (String.isNotBlank(String.valueof(objItem.get('OpenDate')))){
                        date cdate = Date.valueOf(String.valueof(objItem.get('OpenDate')));
                        tempShareObj.OPEN_DATE__c = cdate;
                    }

                    if (String.isNotBlank(String.valueof(objItem.get('LastTranDate')))){
                        date cdate = Date.valueOf(String.valueof(objItem.get('LastTranDate')));
                        tempShareObj.Last_Transaction_Date__c = cdate;
                    }

                    if (String.isNotBlank(String.valueof(objItem.get('CloseDate')))){
                        date cdate = Date.valueOf(String.valueof(objItem.get('CloseDate')));
                        tempShareObj.Close_Date__c = cdate;
                    }

                    if (String.isNotBlank(String.valueof(objItem.get('MaturityDate')))){
                        date cdate = Date.valueOf(String.valueof(objItem.get('MaturityDate')));
                        tempShareObj.Maturity_Date__c = cdate;
                    }

                    if (String.isNotBlank(String.valueof(objItem.get('NegativeBalanceDate')))){
                        date cdate = Date.valueOf(String.valueof(objItem.get('NegativeBalanceDate')));
                        tempShareObj.NEGATIVEBALANCEDATE__c = cdate;
                    }

                    if (String.isNotBlank(String.valueof(objItem.get('OverdraftTolerance')))){
                        tempShareObj.OVERDRAFTTOLERANCE__c = Decimal.valueof(String.valueof(objItem.get('OverdraftTolerance')));
                    }

                    if (String.isNotBlank(String.valueof(objItem.get('DivType')))){
                        tempShareObj.Div_Type__c = Decimal.valueOf(String.valueof(objItem.get('DivType')));
                    }
                    if (String.isNotBlank(String.valueof(objItem.get('DivPostCode')))){
                        tempShareObj.Div_Post_Code__c = Decimal.valueOf(String.valueof(objItem.get('DivPostCode')));
                    }

                    if (String.isNotBlank(String.valueof(objItem.get('DivYtd')))){
                        tempShareObj.Div_YTD__c = Decimal.valueOf(String.valueof(objItem.get('DivYtd')));
                    }
                    if (String.isNotBlank(String.valueof(objItem.get('DivLastYear')))){
                        tempShareObj.Div_Last_Year__c = Decimal.valueOf(String.valueof(objItem.get('DivLastYear')));
                    }
                    if (String.isNotBlank(String.valueof(objItem.get('LastDivAmount')))){
                        tempShareObj.Last_Div_Amount__c = Decimal.valueOf(String.valueof(objItem.get('LastDivAmount')));
                    }

                    if (String.isNotBlank(String.valueof(objItem.get('LastDivDate')))){
                        date cdate = Date.valueOf(String.valueof(objItem.get('LastDivDate')));
                        tempShareObj.Last_Div_Date__c = cdate;
                    }


                    if (String.isNotBlank(String.valueof(objItem.get('ServiceValue1')))){
                        tempShareObj.SERVICE_1__c = Decimal.valueof(String.valueof(objItem.get('ServiceValue1')));
                    }

                    if (String.isNotBlank(String.valueof(objItem.get('ServiceValue2')))){
                        tempShareObj.SERVICE_2__c = Decimal.valueof(String.valueof(objItem.get('ServiceValue2')));
                    }

                    if (String.isNotBlank(String.valueof(objItem.get('ServiceValue3')))){
                        tempShareObj.SERVICE_3__c = Decimal.valueof(String.valueof(objItem.get('ServiceValue3')));
                    }

                    if (String.isNotBlank(String.valueof(objItem.get('ServiceValue4')))){
                        tempShareObj.SERVICE_4__c = Decimal.valueof(String.valueof(objItem.get('ServiceValue4')));
                    }

                    if (String.isNotBlank(String.valueof(objItem.get('ServiceValue5')))){
                        tempShareObj.SERVICE_5__c = Decimal.valueof(String.valueof(objItem.get('ServiceValue5')));
                    }

                    if (String.isNotBlank(String.valueof(objItem.get('ServiceValue6')))){
                        tempShareObj.SERVICE_6__c = Decimal.valueof(String.valueof(objItem.get('ServiceValue6')));
                    }

                    if (String.isNotBlank(String.valueof(objItem.get('ServiceValue7')))){
                        tempShareObj.SERVICE_7__c = Decimal.valueof(String.valueof(objItem.get('ServiceValue7')));
                    }

                    if (String.isNotBlank(String.valueof(objItem.get('ServiceValue8')))){
                        tempShareObj.SERVICE_8__c = Decimal.valueof(String.valueof(objItem.get('ServiceValue8')));
                    }

                    tempShareObj.RecType__c = 'SHAR';
                    tempShareObj.RecTypeID__c = 'S' + tempShareObj.ID1__c;
                    if (shareRecordType.size() > 0){
                        tempShareObj.RecordTypeId = shareRecordType[0].Id;
                    }


                    system.debug('tempShareObj==' + tempShareObj);
                    if (tempShareObj.Close_Date__c == null){
                        lstShareAccounts.add(tempShareObj);
                    }
                }
                system.debug('lstShareAccounts.size==' + lstShareAccounts.size());
                insert lstShareAccounts;
            }
        } else{
            string ACCTId = '';
            List<Account_Details__c> listACCTRecord = [Select Id, Name, Card_Number__c
                                                       from Account_Details__c
                                                       where RecType__c = 'Membership' and name = :accountNumber and RecType__c = 'ACCT'];
            if (listACCTRecord.size() > 0){
                ACCTId = listACCTRecord[0].id;
            }
            if (lstCards.size() > 0){
                Set<string> setCardNumbers = new set<string>();
                map<string, Account_Details__c> mapCardNumberAccount = new map<string, Account_Details__c>();

                List<Account_Details__c> listMemberCards = [Select Id, Name, Card_Number__c, Description__c, Created_At_Branch__c, Created_By_User__c, Card_Name__c, STATUS__c, STATUSREASON__c, Close_Date__c, Expiration_Date__c, Issue_Date__c, DepLimit__c, Limit_Amount__c, POSLIMIT__c, AuthLimit__c
                                                            from Account_Details__c
                                                            where RecType__c = 'CARD' and name = :accountNumber];

                for (Account_Details__c obj : listMemberCards){
                    setCardNumbers.add(obj.Card_Number__c);
                    mapCardNumberAccount.put(obj.Card_Number__c, obj);
                }

                List<Account_Details__c> lstCardAccountsInsert = new List<Account_Details__c>();
                List<Account_Details__c> lstCardAccountsUpdate = new List<Account_Details__c>();

                for (Object obj : lstCards){
                    Map<String, Object> objItem = (Map<String, Object>)obj;
                    string cardnumber = String.valueof(objItem.get('CardNumber'));
                    if (setCardNumbers.contains(cardnumber)){
                        //Update Details
                        boolean isUpdated = false;
                        Account_Details__c tempCardObj = mapCardNumberAccount.get(cardnumber);

                        if (tempCardObj.Description__c != (String.valueof(objItem.get('Description')))){
                            isUpdated = true;
                            tempCardObj.Description__c = String.valueof(objItem.get('Description'));
                        }

                        if (String.isNotBlank(String.valueof(objItem.get('CreatedAtBranch')))){
                            if (tempCardObj.Created_At_Branch__c != (Decimal.valueof(String.valueof(objItem.get('CreatedAtBranch'))))){
                                isUpdated = true;
                                tempCardObj.Created_At_Branch__c = Decimal.valueof(String.valueof(objItem.get('CreatedAtBranch')));
                            }

                        }
                        if (String.isNotBlank(String.valueof(objItem.get('CreatedByUser')))){
                            if (tempCardObj.Created_By_User__c != (Decimal.valueof(String.valueof(objItem.get('CreatedByUser'))))){
                                tempCardObj.Created_By_User__c = Decimal.valueof(String.valueof(objItem.get('CreatedByUser')));
                                isUpdated = true;
                            }
                        }

                        if (tempCardObj.Card_Name__c != String.valueof(objItem.get('LongName'))){
                            tempCardObj.Card_Name__c = String.valueof(objItem.get('LongName'));
                            isUpdated = true;
                        }

                        if (tempCardObj.STATUS__c != (Integer) objItem.get('CardStatus')){
                            tempCardObj.STATUS__c = (Integer) objItem.get('CardStatus');
                            isUpdated = true;
                        }


                        if (String.isNotBlank(String.valueof(objItem.get('StatusReason')))){
                            if (tempCardObj.STATUSREASON__c != (Decimal.valueof((string) objItem.get('StatusReason')))){
                                tempCardObj.STATUSREASON__c = Decimal.valueof((string) objItem.get('StatusReason'));
                                isUpdated = true;
                            }

                        }

                        if (String.isNotBlank(String.valueof(objItem.get('CloseDate')))){
                            date cdate = Date.valueOf(String.valueof(objItem.get('CloseDate')));
                            if (tempCardObj.Close_Date__c != cdate){
                                tempCardObj.Close_Date__c = cdate;
                                isUpdated = true;
                            }

                        }

                        if (String.isNotBlank(String.valueof(objItem.get('ExpirationDate')))){
                            date cdate = Date.valueOf(String.valueof(objItem.get('ExpirationDate')));
                            if (tempCardObj.Expiration_Date__c != cdate){
                                tempCardObj.Expiration_Date__c = cdate;
                                isUpdated = true;
                            }
                        }

                        if (String.isNotBlank(String.valueof(objItem.get('IssueDate')))){
                            date cdate = Date.valueOf(String.valueof(objItem.get('IssueDate')));
                            if (tempCardObj.Issue_Date__c != cdate){
                                tempCardObj.Issue_Date__c = cdate;
                                isUpdated = true;
                            }
                        }

                        if (String.isNotBlank(String.valueof(objItem.get('DepLimit')))){
                            if (tempCardObj.DepLimit__c != (Decimal.valueof(String.valueof(objItem.get('DepLimit'))))){
                                tempCardObj.DepLimit__c = Decimal.valueof(String.valueof(objItem.get('DepLimit')));
                                isUpdated = true;
                            }
                        }

                        if (String.isNotBlank(String.valueof(objItem.get('LimitAmount')))){
                            if (tempCardObj.Limit_Amount__c != (Decimal.valueof(String.valueof(objItem.get('LimitAmount'))))){
                                tempCardObj.Limit_Amount__c = Decimal.valueof(String.valueof(objItem.get('LimitAmount')));
                                isUpdated = true;
                            }
                        }

                        if (String.isNotBlank(String.valueof(objItem.get('PosLimit')))){
                            if (tempCardObj.POSLIMIT__c != (Decimal.valueof(String.valueof(objItem.get('PosLimit'))))){
                                tempCardObj.POSLIMIT__c = Decimal.valueof(String.valueof(objItem.get('PosLimit')));
                                isUpdated = true;
                            }
                        }

                        if (String.isNotBlank(String.valueof(objItem.get('AuthLimit')))){
                            if (tempCardObj.AuthLimit__c != (Decimal.valueof(String.valueof(objItem.get('AuthLimit'))))){
                                tempCardObj.AuthLimit__c = Decimal.valueof(String.valueof(objItem.get('AuthLimit')));
                                isUpdated = true;
                            }
                        }

                        if (tempCardObj.Close_Date__c == null && isUpdated){
                            lstCardAccountsUpdate.add(tempCardObj);
                        }
                    } else{
                        //Create Record
                        Account_Details__c tempCardObj = new Account_Details__c();
                        //system.debug('objItem=='+objItem);

                        tempCardObj.name = accountNumber;
                        if (string.isNotBlank(ACCTId)){
                            tempCardObj.Parent_Account__c = ACCTId;
                        }

                        tempCardObj.Description__c = String.valueof(objItem.get('Description'));

                        if (String.isNotBlank(String.valueof(objItem.get('CreatedAtBranch')))){
                            tempCardObj.Created_At_Branch__c = Decimal.valueof(String.valueof(objItem.get('CreatedAtBranch')));
                        }
                        if (String.isNotBlank(String.valueof(objItem.get('CreatedByUser')))){
                            tempCardObj.Created_By_User__c = Decimal.valueof(String.valueof(objItem.get('CreatedByUser')));
                        }

                        tempCardObj.Card_Number__c = String.valueof(objItem.get('CardNumber'));
                        system.debug('longname==' + String.valueof(objItem.get('LongName')));
                        tempCardObj.Card_Name__c = String.valueof(objItem.get('LongName'));
                        tempCardObj.STATUS__c = (Integer) objItem.get('CardStatus');

                        if (String.isNotBlank(String.valueof(objItem.get('StatusReason')))){
                            tempCardObj.STATUSREASON__c = Decimal.valueof((string) objItem.get('StatusReason'));
                        }

                        if (String.isNotBlank(String.valueof(objItem.get('CloseDate')))){
                            date cdate = Date.valueOf(String.valueof(objItem.get('CloseDate')));
                            tempCardObj.Close_Date__c = cdate;
                        }

                        if (String.isNotBlank(String.valueof(objItem.get('ExpirationDate')))){
                            date cdate = Date.valueOf(String.valueof(objItem.get('ExpirationDate')));
                            tempCardObj.Expiration_Date__c = cdate;
                        }

                        if (String.isNotBlank(String.valueof(objItem.get('IssueDate')))){
                            date cdate = Date.valueOf(String.valueof(objItem.get('IssueDate')));
                            tempCardObj.Issue_Date__c = cdate;
                        }

                        tempCardObj.DepLimit__c = Decimal.valueof(String.valueof(objItem.get('DepLimit')));
                        tempCardObj.Limit_Amount__c = Decimal.valueof(String.valueof(objItem.get('LimitAmount')));
                        tempCardObj.POSLIMIT__c = Decimal.valueof(String.valueof(objItem.get('PosLimit')));
                        tempCardObj.AuthLimit__c = Decimal.valueof(String.valueof(objItem.get('AuthLimit')));
                        tempCardObj.RecType__c = 'CARD';
                        tempCardObj.RecTypeID__c = 'C' + tempCardObj.Card_Number__c.right(4);
                        if (cardRecordType.size() > 0){
                            tempCardObj.RecordTypeId = cardRecordType[0].Id;
                        }

                        system.debug('tempCardObj==' + tempCardObj);
                        if (tempCardObj.Close_Date__c == null){
                            lstCardAccountsInsert.add(tempCardObj);
                        }
                    }
                }

                if (lstCardAccountsInsert.size() > 0){
                    system.debug('Card Insert');
                    insert lstCardAccountsInsert;
                }

                if (lstCardAccountsUpdate.size() > 0){
                    system.debug('Card Update' + lstCardAccountsUpdate.size());
                    update lstCardAccountsUpdate;
                }
            }

            if (lstLoans.size() > 0){
                Set<string> setLoanIds = new set<string>();
                map<string, Account_Details__c> mapLoanIdAccount = new map<string, Account_Details__c>();

                List<Account_Details__c> listMemberCards = [Select Id, Name, Card_Number__c, ID1__c, Description__c, Created_At_Branch__c, Created_By_User__c, Loan_code__c, Balance__c, ORIGINALBALANCE__c, Due_Date__c, ORIGINALDATE__c, OPEN_DATE__c, Maturity_Date__c, Last_Payment_Date__c, Last_Transaction_Date__c, Credit_Score__c, Interest_Rate__c, Interest_YTD__c, Interest_Last_Year__c, Interest_Rate_Margin__c, Late_Charge_Unpaid__c, PASTDUEPAYMENT__c, Interest_Past_Due__c, PARTIALPAYMENT__c, PAYMENT__c, Insurance_Type__c, MICR_Account_Number__c, NOTENUMBER__c, SERVICE_1__c, SERVICE_2__c, SERVICE_3__c, SERVICE_4__c, SERVICE_5__c, SERVICE_6__c, SERVICE_7__c, SERVICE_8__c, Close_Date__c
                                                            from Account_Details__c
                                                            where RecType__c = 'LOAN' and name = :accountNumber];

                for (Account_Details__c obj : listMemberCards){
                    setLoanIds.add(obj.ID1__c);
                    mapLoanIdAccount.put(obj.ID1__c, obj);
                }

                List<Account_Details__c> lstLoanAccountsInsert = new List<Account_Details__c>();
                List<Account_Details__c> lstLoanAccountsUpdate = new List<Account_Details__c>();

                for (Object obj : lstLoans){
                    Map<String, Object> objItem = (Map<String, Object>)obj;
                    string LoanId = String.valueof(objItem.get('LoanId'));
                    if (setLoanIds.contains(LoanId)){
                        //Update Details

                        boolean isUpdated = false;
                        Account_Details__c tempLoanObj = mapLoanIdAccount.get(LoanId);

                        if (tempLoanObj.Description__c != (String.valueof(objItem.get('Description')))){
                            isUpdated = true;
                            tempLoanObj.Description__c = String.valueof(objItem.get('Description'));
                        }

                        if (String.isNotBlank(String.valueof(objItem.get('CreatedAtBranch')))){
                            if (tempLoanObj.Created_At_Branch__c != (Decimal.valueof(String.valueof(objItem.get('CreatedAtBranch'))))){
                                isUpdated = true;
                                tempLoanObj.Created_At_Branch__c = Decimal.valueof(String.valueof(objItem.get('CreatedAtBranch')));
                            }
                        }

                        if (String.isNotBlank(String.valueof(objItem.get('CreatedByUser')))){
                            if (tempLoanObj.Created_By_User__c != (Decimal.valueof(String.valueof(objItem.get('CreatedByUser'))))){
                                tempLoanObj.Created_By_User__c = Decimal.valueof(String.valueof(objItem.get('CreatedByUser')));
                                isUpdated = true;
                            }
                        }


                        if (String.isNotBlank(String.valueof(objItem.get('LoanCode')))){
                            if (tempLoanObj.Loan_code__c != (Decimal.valueof((String.valueof(objItem.get('LoanCode')))))){
                                tempLoanObj.Loan_code__c = Decimal.valueof((String.valueof(objItem.get('LoanCode'))));
                                isUpdated = true;
                            }

                        }

                        if (tempLoanObj.Balance__c != (Decimal.valueof(String.valueof(objItem.get('Balance'))))){
                            tempLoanObj.Balance__c = Decimal.valueof(String.valueof(objItem.get('Balance')));
                            isUpdated = true;
                        }

                        if (tempLoanObj.Balance__c != (Decimal.valueof(String.valueof(objItem.get('OriginalBalance'))))){
                            if (tempLoanObj.ORIGINALBALANCE__c != (Decimal.valueof(String.valueof(objItem.get('OriginalBalance'))))){
                                tempLoanObj.ORIGINALBALANCE__c = Decimal.valueof(String.valueof(objItem.get('OriginalBalance')));
                                isUpdated = true;
                            }
                        }


                        if (String.isNotBlank(String.valueof(objItem.get('DueDate')))){
                            date cdate = Date.valueOf(String.valueof(objItem.get('DueDate')));
                            if (tempLoanObj.Due_Date__c != cdate){
                                tempLoanObj.Due_Date__c = cdate;
                                isUpdated = true;
                            }
                        }

                        if (String.isNotBlank(String.valueof(objItem.get('OriginalDate')))){
                            date cdate = Date.valueOf(String.valueof(objItem.get('OriginalDate')));
                            if (tempLoanObj.ORIGINALDATE__c != cdate){
                                tempLoanObj.ORIGINALDATE__c = cdate;
                                isUpdated = true;
                            }
                        }

                        if (String.isNotBlank(String.valueof(objItem.get('OpenDate')))){
                            date cdate = Date.valueOf(String.valueof(objItem.get('OpenDate')));
                            if (tempLoanObj.OPEN_DATE__c != cdate){
                                tempLoanObj.OPEN_DATE__c = cdate;
                                isUpdated = true;
                            }
                        }

                        if (String.isNotBlank(String.valueof(objItem.get('MaturityDate')))){
                            date cdate = Date.valueOf(String.valueof(objItem.get('MaturityDate')));
                            if (tempLoanObj.Maturity_Date__c != cdate){
                                tempLoanObj.Maturity_Date__c = cdate;
                                isUpdated = true;
                            }
                        }

                        if (String.isNotBlank(String.valueof(objItem.get('LastPaymentDate')))){
                            date cdate = Date.valueOf(String.valueof(objItem.get('LastPaymentDate')));
                            if (tempLoanObj.Last_Payment_Date__c != cdate){
                                tempLoanObj.Last_Payment_Date__c = cdate;
                                isUpdated = true;
                            }
                        }

                        if (String.isNotBlank(String.valueof(objItem.get('LastTranDate')))){
                            date cdate = Date.valueOf(String.valueof(objItem.get('LastTranDate')));
                            if (tempLoanObj.Last_Transaction_Date__c != cdate){
                                tempLoanObj.Last_Transaction_Date__c = cdate;
                                isUpdated = true;
                            }

                        }

                        if (tempLoanObj.Credit_Score__c != String.valueof(objItem.get('CreditScore'))){
                            tempLoanObj.Credit_Score__c = String.valueof(objItem.get('CreditScore'));
                            isUpdated = true;
                        }


                        if (String.isNotBlank(String.valueof(objItem.get('InterestRate')))){
                            if (tempLoanObj.Interest_Rate__c != (Decimal.valueof(String.valueof(objItem.get('InterestRate'))))){
                                tempLoanObj.Interest_Rate__c = Decimal.valueof(String.valueof(objItem.get('InterestRate')));
                                isUpdated = true;
                            }
                        }

                        if (String.isNotBlank(String.valueof(objItem.get('InterestYtd')))){
                            if (tempLoanObj.Interest_YTD__c != (Decimal.valueof(String.valueof(objItem.get('InterestYtd'))))){
                                tempLoanObj.Interest_YTD__c = Decimal.valueof(String.valueof(objItem.get('InterestYtd')));
                                isUpdated = true;
                            }
                        }

                        if (String.isNotBlank(String.valueof(objItem.get('InterestLastYear')))){
                            if (tempLoanObj.Interest_Last_Year__c != (Decimal.valueof(String.valueof(objItem.get('InterestLastYear'))))){
                                tempLoanObj.Interest_Last_Year__c = Decimal.valueof(String.valueof(objItem.get('InterestLastYear')));
                                isUpdated = true;
                            }
                        }

                        if (String.isNotBlank(String.valueof(objItem.get('InterestRateMargin')))){
                            if (tempLoanObj.Interest_Rate_Margin__c != (Decimal.valueof(String.valueof(objItem.get('InterestRateMargin'))))){
                                tempLoanObj.Interest_Rate_Margin__c = Decimal.valueof(String.valueof(objItem.get('InterestRateMargin')));
                                isUpdated = true;
                            }
                        }

                        if (String.isNotBlank(String.valueof(objItem.get('LateChargeUnpaid')))){
                            if (tempLoanObj.Late_Charge_Unpaid__c != (Decimal.valueof(String.valueof(objItem.get('LateChargeUnpaid'))))){
                                tempLoanObj.Late_Charge_Unpaid__c = Decimal.valueof(String.valueof(objItem.get('LateChargeUnpaid')));
                                isUpdated = true;
                            }
                        }

                        if (String.isNotBlank(String.valueof(objItem.get('PastDueAmount')))){
                            if (tempLoanObj.PASTDUEPAYMENT__c != (Decimal.valueof(String.valueof(objItem.get('PastDueAmount'))))){
                                tempLoanObj.PASTDUEPAYMENT__c = Decimal.valueof(String.valueof(objItem.get('PastDueAmount')));
                                isUpdated = true;
                            }
                        }

                        if (String.isNotBlank(String.valueof(objItem.get('InterestDue')))){
                            if (tempLoanObj.Interest_Past_Due__c != (Decimal.valueof(String.valueof(objItem.get('InterestDue'))))){
                                tempLoanObj.Interest_Past_Due__c = Decimal.valueof(String.valueof(objItem.get('InterestDue')));
                                isUpdated = true;
                            }
                        }

                        if (String.isNotBlank(String.valueof(objItem.get('PartialPayment')))){
                            if (tempLoanObj.PARTIALPAYMENT__c != (Decimal.valueof(String.valueof(objItem.get('PartialPayment'))))){
                                tempLoanObj.PARTIALPAYMENT__c = Decimal.valueof(String.valueof(objItem.get('PartialPayment')));
                                isUpdated = true;
                            }
                        }

                        if (String.isNotBlank(String.valueof(objItem.get('Payment')))){
                            if (tempLoanObj.PAYMENT__c != (Decimal.valueof(String.valueof(objItem.get('Payment'))))){
                                tempLoanObj.PAYMENT__c = Decimal.valueof(String.valueof(objItem.get('Payment')));
                                isUpdated = true;
                            }
                        }

                        if (String.isNotBlank(String.valueof(objItem.get('InsuranceType')))){
                            if (tempLoanObj.Insurance_Type__c != (Decimal.valueof(String.valueof(objItem.get('InsuranceType'))))){
                                tempLoanObj.Insurance_Type__c = Decimal.valueof(String.valueof(objItem.get('InsuranceType')));
                                isUpdated = true;
                            }
                        }

                        if (tempLoanObj.MICR_Account_Number__c != String.valueof(objItem.get('MicrAcctNumber'))){
                            tempLoanObj.MICR_Account_Number__c = String.valueof(objItem.get('MicrAcctNumber'));
                            isUpdated = true;
                        }

                        if (tempLoanObj.NOTENUMBER__c != String.valueof(objItem.get('NoteNumber'))){
                            tempLoanObj.NOTENUMBER__c = String.valueof(objItem.get('NoteNumber'));
                            isUpdated = true;
                        }


                        if (String.isNotBlank(String.valueof(objItem.get('ServiceValue1')))){
                            if (tempLoanObj.SERVICE_1__c != (Decimal.valueof(String.valueof(objItem.get('ServiceValue1'))))){
                                tempLoanObj.SERVICE_1__c = Decimal.valueof(String.valueof(objItem.get('ServiceValue1')));
                                isUpdated = true;
                            }
                        }

                        if (String.isNotBlank(String.valueof(objItem.get('ServiceValue2')))){
                            if (tempLoanObj.SERVICE_2__c != (Decimal.valueof(String.valueof(objItem.get('ServiceValue2'))))){
                                tempLoanObj.SERVICE_2__c = Decimal.valueof(String.valueof(objItem.get('ServiceValue2')));
                                isUpdated = true;
                            }
                        }

                        if (String.isNotBlank(String.valueof(objItem.get('ServiceValue3')))){
                            if (tempLoanObj.SERVICE_3__c != (Decimal.valueof(String.valueof(objItem.get('ServiceValue3'))))){
                                tempLoanObj.SERVICE_3__c = Decimal.valueof(String.valueof(objItem.get('ServiceValue3')));
                                isUpdated = true;
                            }
                        }

                        if (String.isNotBlank(String.valueof(objItem.get('ServiceValue4')))){
                            if (tempLoanObj.SERVICE_4__c != (Decimal.valueof(String.valueof(objItem.get('ServiceValue4'))))){
                                tempLoanObj.SERVICE_4__c = Decimal.valueof(String.valueof(objItem.get('ServiceValue4')));
                                isUpdated = true;
                            }
                        }

                        if (String.isNotBlank(String.valueof(objItem.get('ServiceValue5')))){
                            if (tempLoanObj.SERVICE_5__c != (Decimal.valueof(String.valueof(objItem.get('ServiceValue5'))))){
                                tempLoanObj.SERVICE_5__c = Decimal.valueof(String.valueof(objItem.get('ServiceValue5')));
                                isUpdated = true;
                            }
                        }

                        if (String.isNotBlank(String.valueof(objItem.get('ServiceValue6')))){
                            if (tempLoanObj.SERVICE_6__c != (Decimal.valueof(String.valueof(objItem.get('ServiceValue6'))))){
                                tempLoanObj.SERVICE_6__c = Decimal.valueof(String.valueof(objItem.get('ServiceValue6')));
                                isUpdated = true;
                            }
                        }

                        if (String.isNotBlank(String.valueof(objItem.get('ServiceValue7')))){
                            if (tempLoanObj.SERVICE_7__c != (Decimal.valueof(String.valueof(objItem.get('ServiceValue7'))))){
                                tempLoanObj.SERVICE_7__c = Decimal.valueof(String.valueof(objItem.get('ServiceValue7')));
                                isUpdated = true;
                            }
                        }

                        if (String.isNotBlank(String.valueof(objItem.get('ServiceValue8')))){
                            if (tempLoanObj.SERVICE_8__c != (Decimal.valueof(String.valueof(objItem.get('ServiceValue8'))))){
                                tempLoanObj.SERVICE_8__c = Decimal.valueof(String.valueof(objItem.get('ServiceValue8')));
                                isUpdated = true;
                            }
                        }


                        system.debug('tempLoanObj==' + tempLoanObj);
                        if (tempLoanObj.Close_Date__c == null && isUpdated){
                            lstLoanAccountsUpdate.add(tempLoanObj);
                        }

                    } else{
                        //Insert Record
                        Account_Details__c tempLoanObj = new Account_Details__c();
                        //system.debug('objItem=='+objItem);

                        tempLoanObj.name = accountNumber;
                        if (string.isNotBlank(ACCTId)){
                            tempLoanObj.Parent_Account__c = ACCTId;
                        }

                        tempLoanObj.Description__c = String.valueof(objItem.get('Description'));

                        if (String.isNotBlank(String.valueof(objItem.get('CreatedAtBranch')))){
                            tempLoanObj.Created_At_Branch__c = Decimal.valueof(String.valueof(objItem.get('CreatedAtBranch')));
                        }
                        if (String.isNotBlank(String.valueof(objItem.get('CreatedByUser')))){
                            tempLoanObj.Created_By_User__c = Decimal.valueof(String.valueof(objItem.get('CreatedByUser')));
                        }

                        tempLoanObj.ID1__c = String.valueof(objItem.get('LoanId'));
                        if (String.isNotBlank(String.valueof(objItem.get('LoanCode')))){
                            tempLoanObj.Loan_code__c = Decimal.valueof((String.valueof(objItem.get('LoanCode'))));
                        }

                        tempLoanObj.Balance__c = Decimal.valueof(String.valueof(objItem.get('Balance')));
                        tempLoanObj.ORIGINALBALANCE__c = Decimal.valueof(String.valueof(objItem.get('OriginalBalance')));

                        if (String.isNotBlank(String.valueof(objItem.get('DueDate')))){
                            date cdate = Date.valueOf(String.valueof(objItem.get('DueDate')));
                            tempLoanObj.Due_Date__c = cdate;
                        }

                        if (String.isNotBlank(String.valueof(objItem.get('OriginalDate')))){
                            date cdate = Date.valueOf(String.valueof(objItem.get('OriginalDate')));
                            tempLoanObj.ORIGINALDATE__c = cdate;
                        }
                        if (String.isNotBlank(String.valueof(objItem.get('OpenDate')))){
                            date cdate = Date.valueOf(String.valueof(objItem.get('OpenDate')));
                            tempLoanObj.OPEN_DATE__c = cdate;
                        }
                        if (String.isNotBlank(String.valueof(objItem.get('MaturityDate')))){
                            date cdate = Date.valueOf(String.valueof(objItem.get('MaturityDate')));
                            tempLoanObj.Maturity_Date__c = cdate;
                        }
                        if (String.isNotBlank(String.valueof(objItem.get('LastPaymentDate')))){
                            date cdate = Date.valueOf(String.valueof(objItem.get('LastPaymentDate')));
                            tempLoanObj.Last_Payment_Date__c = cdate;
                        }
                        if (String.isNotBlank(String.valueof(objItem.get('LastTranDate')))){
                            date cdate = Date.valueOf(String.valueof(objItem.get('LastTranDate')));
                            tempLoanObj.Last_Transaction_Date__c = cdate;
                        }


                        tempLoanObj.Credit_Score__c = String.valueof(objItem.get('CreditScore'));
                        if (String.isNotBlank(String.valueof(objItem.get('InterestRate')))){
                            tempLoanObj.Interest_Rate__c = Decimal.valueof(String.valueof(objItem.get('InterestRate')));
                        }

                        if (String.isNotBlank(String.valueof(objItem.get('InterestYtd')))){
                            tempLoanObj.Interest_YTD__c = Decimal.valueof(String.valueof(objItem.get('InterestYtd')));
                        }

                        if (String.isNotBlank(String.valueof(objItem.get('InterestLastYear')))){
                            tempLoanObj.Interest_Last_Year__c = Decimal.valueof(String.valueof(objItem.get('InterestLastYear')));
                        }

                        if (String.isNotBlank(String.valueof(objItem.get('InterestRateMargin')))){
                            tempLoanObj.Interest_Rate_Margin__c = Decimal.valueof(String.valueof(objItem.get('InterestRateMargin')));
                        }

                        if (String.isNotBlank(String.valueof(objItem.get('LateChargeUnpaid')))){
                            tempLoanObj.Late_Charge_Unpaid__c = Decimal.valueof(String.valueof(objItem.get('LateChargeUnpaid')));
                        }

                        if (String.isNotBlank(String.valueof(objItem.get('PastDueAmount')))){
                            tempLoanObj.PASTDUEPAYMENT__c = Decimal.valueof(String.valueof(objItem.get('PastDueAmount')));
                        }

                        if (String.isNotBlank(String.valueof(objItem.get('InterestDue')))){
                            tempLoanObj.Interest_Past_Due__c = Decimal.valueof(String.valueof(objItem.get('InterestDue')));
                        }

                        if (String.isNotBlank(String.valueof(objItem.get('PartialPayment')))){
                            tempLoanObj.PARTIALPAYMENT__c = Decimal.valueof(String.valueof(objItem.get('PartialPayment')));
                        }

                        if (String.isNotBlank(String.valueof(objItem.get('Payment')))){
                            tempLoanObj.PAYMENT__c = Decimal.valueof(String.valueof(objItem.get('Payment')));
                        }

                        if (String.isNotBlank(String.valueof(objItem.get('InsuranceType')))){
                            tempLoanObj.Insurance_Type__c = Decimal.valueof(String.valueof(objItem.get('InsuranceType')));
                        }

                        tempLoanObj.MICR_Account_Number__c = String.valueof(objItem.get('MicrAcctNumber'));
                        tempLoanObj.NOTENUMBER__c = String.valueof(objItem.get('NoteNumber'));


                        if (String.isNotBlank(String.valueof(objItem.get('ServiceValue1')))){
                            tempLoanObj.SERVICE_1__c = Decimal.valueof(String.valueof(objItem.get('ServiceValue1')));
                        }

                        if (String.isNotBlank(String.valueof(objItem.get('ServiceValue2')))){
                            tempLoanObj.SERVICE_2__c = Decimal.valueof(String.valueof(objItem.get('ServiceValue2')));
                        }

                        if (String.isNotBlank(String.valueof(objItem.get('ServiceValue3')))){
                            tempLoanObj.SERVICE_3__c = Decimal.valueof(String.valueof(objItem.get('ServiceValue3')));
                        }

                        if (String.isNotBlank(String.valueof(objItem.get('ServiceValue4')))){
                            tempLoanObj.SERVICE_4__c = Decimal.valueof(String.valueof(objItem.get('ServiceValue4')));
                        }

                        if (String.isNotBlank(String.valueof(objItem.get('ServiceValue5')))){
                            tempLoanObj.SERVICE_5__c = Decimal.valueof(String.valueof(objItem.get('ServiceValue5')));
                        }

                        if (String.isNotBlank(String.valueof(objItem.get('ServiceValue6')))){
                            tempLoanObj.SERVICE_6__c = Decimal.valueof(String.valueof(objItem.get('ServiceValue6')));
                        }

                        if (String.isNotBlank(String.valueof(objItem.get('ServiceValue7')))){
                            tempLoanObj.SERVICE_7__c = Decimal.valueof(String.valueof(objItem.get('ServiceValue7')));
                        }

                        if (String.isNotBlank(String.valueof(objItem.get('ServiceValue8')))){
                            tempLoanObj.SERVICE_8__c = Decimal.valueof(String.valueof(objItem.get('ServiceValue8')));
                        }
                        tempLoanObj.RecType__c = 'LOAN';
                        tempLoanObj.RecTypeID__c = 'L' + tempLoanObj.ID1__c;
                        if (loanRecordType.size() > 0){
                            tempLoanObj.RecordTypeId = loanRecordType[0].Id;
                        }

                        system.debug('tempLoanObj==' + tempLoanObj);
                        if (tempLoanObj.Close_Date__c == null && String.isNotBlank(tempLoanObj.Loan_Number__c) && tempLoanObj.Loan_Number__c != '0'){
                            lstLoanAccountsInsert.add(tempLoanObj);
                        }
                    }
                }

                if (lstLoanAccountsInsert.size() > 0){
                    system.debug('Loan Insert');
                    insert lstLoanAccountsInsert;
                }

                if (lstLoanAccountsUpdate.size() > 0){
                    system.debug('Loan Update' + lstLoanAccountsUpdate.size());
                    update lstLoanAccountsUpdate;
                }

            }

            if (lstShares.size() > 0){
                Set<string> setShareIds = new set<string>();
                map<string, Account_Details__c> mapShareIdAccount = new map<string, Account_Details__c>();

                List<Account_Details__c> listMemberCards = [Select Id, Name, Card_Number__c, Description__c, Created_At_Branch__c, Created_By_User__c, Activity_Date__c, ID1__c, MICR_Account_Number__c, Balance__c, Available_Balance__c, OPEN_DATE__c, Last_Transaction_Date__c, Close_Date__c, Maturity_Date__c, NEGATIVEBALANCEDATE__c, OVERDRAFTTOLERANCE__c, Div_Type__c, Div_Post_Code__c, Div_YTD__c, Div_Last_Year__c, Last_Div_Amount__c, Last_Div_Date__c, SERVICE_1__c, SERVICE_2__c, SERVICE_3__c, SERVICE_4__c, SERVICE_5__c, SERVICE_6__c, SERVICE_7__c, SERVICE_8__c
                                                            from Account_Details__c
                                                            where RecType__c = 'SHAR' and name = :accountNumber];

                for (Account_Details__c obj : listMemberCards){
                    setShareIds.add(obj.ID1__c);
                    mapShareIdAccount.put(obj.ID1__c, obj);
                }

                List<Account_Details__c> lstShareAccountsInsert = new List<Account_Details__c>();
                List<Account_Details__c> lstShareAccountsUpdate = new List<Account_Details__c>();

                for (Object obj : lstShares){
                    Map<String, Object> objItem = (Map<String, Object>)obj;
                    string ShareId = String.valueof(objItem.get('Id'));

                    if (setShareIds.contains(ShareId)){
                        //Update Details
                        boolean isUpdated = false;
                        Account_Details__c tempShareObj = mapShareIdAccount.get(ShareId);

                        if (string.isNotBlank(String.valueof(objItem.get('Description')))){
                            if (tempShareObj.Description__c != String.valueof(objItem.get('Description'))){
                                tempShareObj.Description__c = String.valueof(objItem.get('Description'));
                                isUpdated = true;
                            }
                        }

                        if (String.isNotBlank(String.valueof(objItem.get('CreatedAtBranch')))){
                            if (tempShareObj.Created_At_Branch__c != (Decimal.valueof(String.valueof(objItem.get('CreatedAtBranch'))))){
                                tempShareObj.Created_At_Branch__c = Decimal.valueof(String.valueof(objItem.get('CreatedAtBranch')));
                                isUpdated = true;
                            }
                        }

                        if (String.isNotBlank(String.valueof(objItem.get('CreatedByUser')))){
                            if (tempShareObj.Created_By_User__c != (Decimal.valueof(String.valueof(objItem.get('CreatedByUser'))))){
                                tempShareObj.Created_By_User__c = Decimal.valueof(String.valueof(objItem.get('CreatedByUser')));
                                isUpdated = true;
                            }
                        }

                        if (String.isNotBlank(String.valueof(objItem.get('ActivityDate')))){
                            date cdate = Date.valueOf(String.valueof(objItem.get('ActivityDate')));
                            if (tempShareObj.Activity_Date__c != cdate){
                                tempShareObj.Activity_Date__c = cdate;
                                isUpdated = true;
                            }
                        }

                        if (tempShareObj.MICR_Account_Number__c != String.valueof(objItem.get('MicrAcctNumber'))){
                            tempShareObj.MICR_Account_Number__c = String.valueof(objItem.get('MicrAcctNumber'));
                            isUpdated = true;
                        }

                        if (tempShareObj.ID1__c != String.valueof(objItem.get('Id'))){
                            tempShareObj.ID1__c = String.valueof(objItem.get('Id'));
                            isUpdated = true;
                        }


                        if (String.isNotBlank(String.valueof(objItem.get('Balance')))){
                            if (tempShareObj.Balance__c != (Decimal.valueof(String.valueof(objItem.get('Balance'))))){
                                tempShareObj.Balance__c = Decimal.valueof(String.valueof(objItem.get('Balance')));
                                isUpdated = true;
                            }
                        }

                        if (String.isNotBlank(String.valueof(objItem.get('AvailableBalance')))){
                            if (tempShareObj.Available_Balance__c != (Decimal.valueof(String.valueof(objItem.get('AvailableBalance'))))){
                                tempShareObj.Available_Balance__c = Decimal.valueof(String.valueof(objItem.get('AvailableBalance')));
                                isUpdated = true;
                            }
                        }

                        if (String.isNotBlank(String.valueof(objItem.get('OpenDate')))){
                            date cdate = Date.valueOf(String.valueof(objItem.get('OpenDate')));
                            if (tempShareObj.OPEN_DATE__c != cdate){
                                tempShareObj.OPEN_DATE__c = cdate;
                                isUpdated = true;
                            }
                        }

                        if (String.isNotBlank(String.valueof(objItem.get('LastTranDate')))){
                            date cdate = Date.valueOf(String.valueof(objItem.get('LastTranDate')));
                            if (tempShareObj.Last_Transaction_Date__c != cdate){
                                tempShareObj.Last_Transaction_Date__c = cdate;
                                isUpdated = true;
                            }
                        }

                        if (String.isNotBlank(String.valueof(objItem.get('CloseDate')))){
                            date cdate = Date.valueOf(String.valueof(objItem.get('CloseDate')));
                            if (tempShareObj.Close_Date__c != cdate){
                                tempShareObj.Close_Date__c = cdate;
                                isUpdated = true;
                            }

                        }

                        if (String.isNotBlank(String.valueof(objItem.get('MaturityDate')))){
                            date cdate = Date.valueOf(String.valueof(objItem.get('MaturityDate')));
                            if (tempShareObj.Maturity_Date__c != cdate){
                                tempShareObj.Maturity_Date__c = cdate;
                                isUpdated = true;
                            }
                        }

                        if (String.isNotBlank(String.valueof(objItem.get('NegativeBalanceDate')))){
                            date cdate = Date.valueOf(String.valueof(objItem.get('NegativeBalanceDate')));
                            if (tempShareObj.NEGATIVEBALANCEDATE__c != cdate){
                                tempShareObj.NEGATIVEBALANCEDATE__c = cdate;
                                isUpdated = true;
                            }
                        }

                        if (String.isNotBlank(String.valueof(objItem.get('OverdraftTolerance')))){
                            if (tempShareObj.OVERDRAFTTOLERANCE__c != (Decimal.valueof(String.valueof(objItem.get('OverdraftTolerance'))))){
                                tempShareObj.OVERDRAFTTOLERANCE__c = Decimal.valueof(String.valueof(objItem.get('OverdraftTolerance')));
                                isUpdated = true;
                            }
                        }

                        if (String.isNotBlank(String.valueof(objItem.get('DivType')))){
                            if (tempShareObj.Div_Type__c != (Decimal.valueOf(String.valueof(objItem.get('DivType'))))){
                                tempShareObj.Div_Type__c = Decimal.valueOf(String.valueof(objItem.get('DivType')));
                                isUpdated = true;
                            }
                        }

                        if (String.isNotBlank(String.valueof(objItem.get('DivPostCode')))){
                            if (tempShareObj.Div_Post_Code__c != (Decimal.valueOf(String.valueof(objItem.get('DivPostCode'))))){
                                tempShareObj.Div_Post_Code__c = Decimal.valueOf(String.valueof(objItem.get('DivPostCode')));
                                isUpdated = true;
                            }
                        }

                        if (String.isNotBlank(String.valueof(objItem.get('DivYtd')))){
                            if (tempShareObj.Div_YTD__c != (Decimal.valueOf(String.valueof(objItem.get('DivYtd'))))){
                                tempShareObj.Div_YTD__c = Decimal.valueOf(String.valueof(objItem.get('DivYtd')));
                                isUpdated = true;
                            }
                        }

                        if (String.isNotBlank(String.valueof(objItem.get('DivLastYear')))){
                            if (tempShareObj.Div_Last_Year__c != (Decimal.valueOf(String.valueof(objItem.get('DivLastYear'))))){
                                tempShareObj.Div_Last_Year__c = Decimal.valueOf(String.valueof(objItem.get('DivLastYear')));
                                isUpdated = true;
                            }
                        }

                        if (String.isNotBlank(String.valueof(objItem.get('LastDivAmount')))){
                            if (tempShareObj.Last_Div_Amount__c != (Decimal.valueOf(String.valueof(objItem.get('LastDivAmount'))))){
                                tempShareObj.Last_Div_Amount__c = Decimal.valueOf(String.valueof(objItem.get('LastDivAmount')));
                                isUpdated = true;
                            }
                        }

                        if (String.isNotBlank(String.valueof(objItem.get('LastDivDate')))){
                            date cdate = Date.valueOf(String.valueof(objItem.get('LastDivDate')));
                            if (tempShareObj.Last_Div_Date__c != cdate){
                                tempShareObj.Last_Div_Date__c = cdate;
                                isUpdated = true;
                            }
                        }


                        if (String.isNotBlank(String.valueof(objItem.get('ServiceValue1')))){
                            if (tempShareObj.SERVICE_1__c != (Decimal.valueof(String.valueof(objItem.get('ServiceValue1'))))){
                                tempShareObj.SERVICE_1__c = Decimal.valueof(String.valueof(objItem.get('ServiceValue1')));
                                isUpdated = true;
                            }
                        }

                        if (String.isNotBlank(String.valueof(objItem.get('ServiceValue2')))){
                            if (tempShareObj.SERVICE_2__c != (Decimal.valueof(String.valueof(objItem.get('ServiceValue2'))))){
                                tempShareObj.SERVICE_2__c = Decimal.valueof(String.valueof(objItem.get('ServiceValue2')));
                                isUpdated = true;
                            }
                        }

                        if (String.isNotBlank(String.valueof(objItem.get('ServiceValue3')))){
                            if (tempShareObj.SERVICE_3__c != (Decimal.valueof(String.valueof(objItem.get('ServiceValue3'))))){
                                tempShareObj.SERVICE_3__c = Decimal.valueof(String.valueof(objItem.get('ServiceValue3')));
                                isUpdated = true;
                            }
                        }

                        if (String.isNotBlank(String.valueof(objItem.get('ServiceValue4')))){
                            if (tempShareObj.SERVICE_4__c != (Decimal.valueof(String.valueof(objItem.get('ServiceValue4'))))){
                                tempShareObj.SERVICE_4__c = Decimal.valueof(String.valueof(objItem.get('ServiceValue4')));
                                isUpdated = true;
                            }
                        }

                        if (String.isNotBlank(String.valueof(objItem.get('ServiceValue5')))){
                            if (tempShareObj.SERVICE_5__c != (Decimal.valueof(String.valueof(objItem.get('ServiceValue5'))))){
                                tempShareObj.SERVICE_5__c = Decimal.valueof(String.valueof(objItem.get('ServiceValue5')));
                                isUpdated = true;
                            }
                        }

                        if (String.isNotBlank(String.valueof(objItem.get('ServiceValue6')))){
                            if (tempShareObj.SERVICE_6__c != (Decimal.valueof(String.valueof(objItem.get('ServiceValue6'))))){
                                tempShareObj.SERVICE_6__c = Decimal.valueof(String.valueof(objItem.get('ServiceValue6')));
                                isUpdated = true;
                            }
                        }

                        if (String.isNotBlank(String.valueof(objItem.get('ServiceValue7')))){
                            if (tempShareObj.SERVICE_7__c != (Decimal.valueof(String.valueof(objItem.get('ServiceValue7'))))){
                                tempShareObj.SERVICE_7__c = Decimal.valueof(String.valueof(objItem.get('ServiceValue7')));
                                isUpdated = true;
                            }
                        }

                        if (String.isNotBlank(String.valueof(objItem.get('ServiceValue8')))){
                            if (tempShareObj.SERVICE_8__c != (Decimal.valueof(String.valueof(objItem.get('ServiceValue8'))))){
                                tempShareObj.SERVICE_8__c = Decimal.valueof(String.valueof(objItem.get('ServiceValue8')));
                                isUpdated = true;
                            }
                        }

                        system.debug('tempShareObj==' + tempShareObj);
                        if (tempShareObj.Close_Date__c == null && isUpdated){
                            lstShareAccountsUpdate.add(tempShareObj);
                        }
                    } else{
                        Account_Details__c tempShareObj = new Account_Details__c();

                        tempShareObj.name = accountNumber;
                        if (string.isNotBlank(ACCTId)){
                            tempShareObj.Parent_Account__c = ACCTId;
                        }

                        tempShareObj.Description__c = String.valueof(objItem.get('Description'));

                        if (String.isNotBlank(String.valueof(objItem.get('CreatedAtBranch')))){
                            tempShareObj.Created_At_Branch__c = Decimal.valueof(String.valueof(objItem.get('CreatedAtBranch')));
                        }
                        if (String.isNotBlank(String.valueof(objItem.get('CreatedByUser')))){
                            tempShareObj.Created_By_User__c = Decimal.valueof(String.valueof(objItem.get('CreatedByUser')));
                        }

                        if (String.isNotBlank(String.valueof(objItem.get('ActivityDate')))){
                            Date activitydate = Date.valueOf(String.valueof(objItem.get('ActivityDate')));
                            //Date cdate = date.newinstance(activitydate.year() + 2000, activitydate.month(), activitydate.day());
                            tempShareObj.Activity_Date__c = activitydate;
                        }


                        tempShareObj.MICR_Account_Number__c = String.valueof(objItem.get('MicrAcctNumber'));
                        tempShareObj.ID1__c = String.valueof(objItem.get('Id'));

                        if (String.isNotBlank(String.valueof(objItem.get('Balance')))){
                            tempShareObj.Balance__c = Decimal.valueof(String.valueof(objItem.get('Balance')));
                        }

                        if (String.isNotBlank(String.valueof(objItem.get('AvailableBalance')))){
                            tempShareObj.Available_Balance__c = Decimal.valueof(String.valueof(objItem.get('AvailableBalance')));
                        }

                        if (String.isNotBlank(String.valueof(objItem.get('OpenDate')))){
                            date cdate = Date.valueOf(String.valueof(objItem.get('OpenDate')));
                            tempShareObj.OPEN_DATE__c = cdate;
                        }

                        if (String.isNotBlank(String.valueof(objItem.get('LastTranDate')))){
                            date cdate = Date.valueOf(String.valueof(objItem.get('LastTranDate')));
                            tempShareObj.Last_Transaction_Date__c = cdate;
                        }

                        if (String.isNotBlank(String.valueof(objItem.get('CloseDate')))){
                            date cdate = Date.valueOf(String.valueof(objItem.get('CloseDate')));
                            tempShareObj.Close_Date__c = cdate;
                        }

                        if (String.isNotBlank(String.valueof(objItem.get('MaturityDate')))){
                            date cdate = Date.valueOf(String.valueof(objItem.get('MaturityDate')));
                            tempShareObj.Maturity_Date__c = cdate;
                        }

                        if (String.isNotBlank(String.valueof(objItem.get('NegativeBalanceDate')))){
                            date cdate = Date.valueOf(String.valueof(objItem.get('NegativeBalanceDate')));
                            tempShareObj.NEGATIVEBALANCEDATE__c = cdate;
                        }

                        if (String.isNotBlank(String.valueof(objItem.get('OverdraftTolerance')))){
                            tempShareObj.OVERDRAFTTOLERANCE__c = Decimal.valueof(String.valueof(objItem.get('OverdraftTolerance')));
                        }

                        if (String.isNotBlank(String.valueof(objItem.get('DivType')))){
                            tempShareObj.Div_Type__c = Decimal.valueOf(String.valueof(objItem.get('DivType')));
                        }
                        if (String.isNotBlank(String.valueof(objItem.get('DivPostCode')))){
                            tempShareObj.Div_Post_Code__c = Decimal.valueOf(String.valueof(objItem.get('DivPostCode')));
                        }

                        if (String.isNotBlank(String.valueof(objItem.get('DivYtd')))){
                            tempShareObj.Div_YTD__c = Decimal.valueOf(String.valueof(objItem.get('DivYtd')));
                        }
                        if (String.isNotBlank(String.valueof(objItem.get('DivLastYear')))){
                            tempShareObj.Div_Last_Year__c = Decimal.valueOf(String.valueof(objItem.get('DivLastYear')));
                        }
                        if (String.isNotBlank(String.valueof(objItem.get('LastDivAmount')))){
                            tempShareObj.Last_Div_Amount__c = Decimal.valueOf(String.valueof(objItem.get('LastDivAmount')));
                        }

                        if (String.isNotBlank(String.valueof(objItem.get('LastDivDate')))){
                            date cdate = Date.valueOf(String.valueof(objItem.get('LastDivDate')));
                            tempShareObj.Last_Div_Date__c = cdate;
                        }


                        if (String.isNotBlank(String.valueof(objItem.get('ServiceValue1')))){
                            tempShareObj.SERVICE_1__c = Decimal.valueof(String.valueof(objItem.get('ServiceValue1')));
                        }

                        if (String.isNotBlank(String.valueof(objItem.get('ServiceValue2')))){
                            tempShareObj.SERVICE_2__c = Decimal.valueof(String.valueof(objItem.get('ServiceValue2')));
                        }

                        if (String.isNotBlank(String.valueof(objItem.get('ServiceValue3')))){
                            tempShareObj.SERVICE_3__c = Decimal.valueof(String.valueof(objItem.get('ServiceValue3')));
                        }

                        if (String.isNotBlank(String.valueof(objItem.get('ServiceValue4')))){
                            tempShareObj.SERVICE_4__c = Decimal.valueof(String.valueof(objItem.get('ServiceValue4')));
                        }

                        if (String.isNotBlank(String.valueof(objItem.get('ServiceValue5')))){
                            tempShareObj.SERVICE_5__c = Decimal.valueof(String.valueof(objItem.get('ServiceValue5')));
                        }

                        if (String.isNotBlank(String.valueof(objItem.get('ServiceValue6')))){
                            tempShareObj.SERVICE_6__c = Decimal.valueof(String.valueof(objItem.get('ServiceValue6')));
                        }

                        if (String.isNotBlank(String.valueof(objItem.get('ServiceValue7')))){
                            tempShareObj.SERVICE_7__c = Decimal.valueof(String.valueof(objItem.get('ServiceValue7')));
                        }

                        if (String.isNotBlank(String.valueof(objItem.get('ServiceValue8')))){
                            tempShareObj.SERVICE_8__c = Decimal.valueof(String.valueof(objItem.get('ServiceValue8')));
                        }

                        tempShareObj.RecType__c = 'SHAR';
                        tempShareObj.RecTypeID__c = 'S' + tempShareObj.ID1__c;
                        if (shareRecordType.size() > 0){
                            tempShareObj.RecordTypeId = shareRecordType[0].Id;
                        }


                        system.debug('tempShareObj==' + tempShareObj);
                        if (tempShareObj.Close_Date__c == null){
                            lstShareAccountsInsert.add(tempShareObj);
                        }
                    }
                }

                if (lstShareAccountsInsert.size() > 0){
                    system.debug('Share Insert');
                    insert lstShareAccountsInsert;
                }

                if (lstShareAccountsUpdate.size() > 0){
                    system.debug('Share Update' + lstShareAccountsUpdate.size());
                    update lstShareAccountsUpdate;
                }
            }
        }

        /* if(lstPersonAccount.size() == 0){
         Id ACCTId;
         Person_Account__c objPersonAccount = new Person_Account__c();
         Map<String, Object> objItemPerson = lstAccts;
         if (String.isNotBlank(String.valueof(objItemPerson.get('Locator')))){
         objPersonAccount.Locator__c = Decimal.valueof(String.valueof(objItemPerson.get('Locator')));
         }
         if (String.isNotBlank(String.valueof(objItemPerson.get('Type')))){
         objPersonAccount.Name_Type__c = Decimal.valueof(String.valueof(objItemPerson.get('Type')));
         }

         Account_Details__c objAcc = [select id from Account_Details__c where Name =: accountNumber limit 1];
         objPersonAccount.Account_Number__c = objAcc.Id;
         insert objPersonAccount;
         ACCTId = objPersonAccount.Id;
         }
         else{
         Id ACCTId;
         Person_Account__c objPersonAccount = [select id from Person_Account__c where Account_Number__r.Name =: accountNumber limit 1];
         Map<String, Object> objItemPerson = lstAccts;
         if (String.isNotBlank(String.valueof(objItemPerson.get('Locator')))){
         objPersonAccount.Locator__c = Decimal.valueof(String.valueof(objItemPerson.get('Locator')));
         }
         if (String.isNotBlank(String.valueof(objItemPerson.get('Type')))){
         objPersonAccount.Name_Type__c = Decimal.valueof(String.valueof(objItemPerson.get('Type')));
         }

         update objPersonAccount;
         }*/
        /*  if(lstAccount.size()==0){
         Id ACCTId;
         Account objMemberAccount = new Account();
         Map<String, Object> objItemMember = lstAccts;
         if (String.isNotBlank(String.valueof(objItemMember.get('state')))){
         objMemberAccount.State__c = String.valueof(objItemMember.get('state'));
         }
         if (String.isNotBlank(String.valueof(objItemMember.get('city')))){
         objMemberAccount.City__c = String.valueof(objItemMember.get('city'));
         }
         if (String.isNotBlank(String.valueof(objItemMember.get('state')))){
         objMemberAccount.State__c = String.valueof(objItemMember.get('state'));
         }
         if (String.isNotBlank(String.valueof(objItemMember.get('Description')))){
         objMemberAccount.Description = String.valueof(objItemMember.get('Description'));
         }
         if (String.isNotBlank(String.valueof(objItemMember.get('email')))){
         objMemberAccount.Email_raw__c = String.valueof(objItemMember.get('email'));
         }
         Account objAccount = [SELECT Id
         FROM Account
         WHERE PersonID__c = :ssnnumber limit 1];

         objMemberAccount.PersonID__c = objAccount.Id;
         insert objMemberAccount;
         ACCTId = objMemberAccount.Id;

         }else{
         Id ACCTId;
         Account objMemberAccount = [SELECT Id
         FROM Account
         WHERE PersonID__c = :ssnnumber limit 1];

         Map<String, Object> objItemMember = lstAccts;
         if (String.isNotBlank(String.valueof(objItemMember.get('state')))){
         objMemberAccount.State__c = String.valueof(objItemMember.get('state'));
         }
         if (String.isNotBlank(String.valueof(objItemMember.get('city')))){
         objMemberAccount.City__c = String.valueof(objItemMember.get('city'));
         }
         if (String.isNotBlank(String.valueof(objItemMember.get('state')))){
         objMemberAccount.State__c = String.valueof(objItemMember.get('state'));
         }
         if (String.isNotBlank(String.valueof(objItemMember.get('zipcode')))){
         objMemberAccount.Residential_Zipocde__pc = String.valueof(objItemMember.get('zipcode'));
         }
         if (String.isNotBlank(String.valueof(objItemMember.get('country')))){
         objMemberAccount.Country__c = String.valueof(objItemMember.get('country'));
         }
         if (String.isNotBlank(String.valueof(objItemMember.get('Description')))){
         objMemberAccount.Description = String.valueof(objItemMember.get('Description'));
         }
         if (String.isNotBlank(String.valueof(objItemMember.get('email')))){
         objMemberAccount.Email_raw__c = String.valueof(objItemMember.get('email'));
         }
         update objMemberAccount;
         }


         }*/
    }

    public static map<string, object> CreateUpdateMemberRecord(List<Object> NameObject){
        string SSNNumber;
        List<Account> lstAccount = new List<Account>();
        List<Object> NameObjectsToUpdate = new List<Object>();
        List<Object> NameObjectsToInsert = new List<Object>();
        List<Account> lstAccountInsert = new List<Account>();
        map<string, object> result = new map<string, object>();
        List<Account> lstAccountUpdate = new List<Account>();

        List<RecordType> accountRecordType = [select id, name
        from RecordType
        where Name = 'Person Account'];

        for (Object obj : NameObject){
            Map<String, Object> objItem = (Map<String, Object>)obj;
            string type = String.valueof(objItem.get('type'));
            SSNNumber = String.valueof(objItem.get('ssnnumber'));
            if (string.isNotBlank(SSNNumber) && type == '0'){
                string ssnString = '%' + SSNNumber;
                lstAccount = [SELECT Id, Name, PersonID__c
                              FROM Account
                              WHERE PersonID__c like:ssnString];
                if (lstAccount.size() == 0){
                    NameObjectsToInsert.add(obj);
                } else{
                    NameObjectsToUpdate.add(obj);
                }
            }
        }

        for (Object obj : NameObjectsToInsert){
            Account tempAccountObj = new Account();
            Map<String, Object> objItem = (Map<String, Object>)obj;
            if (String.isNotBlank(String.valueof(objItem.get('city')))){
                tempAccountObj.Residential_City__pc = String.valueof(objItem.get('city'));
            }

            if (String.isNotBlank(String.valueof(objItem.get('country')))){
                tempAccountObj.Residential_Country__pc = String.valueof(objItem.get('country'));
            }

            if (String.isNotBlank(String.valueof(objItem.get('extraaddress')))){
                tempAccountObj.Residential_Extra_Address__pc = String.valueof(objItem.get('extraaddress'));
            }

            if (String.isNotBlank(String.valueof(objItem.get('state')))){
                tempAccountObj.Residential_State__pc = String.valueof(objItem.get('state'));
            }

            if (String.isNotBlank(String.valueof(objItem.get('street')))){
                tempAccountObj.Residential_Street__pc = String.valueof(objItem.get('street'));
            }

            if (String.isNotBlank(String.valueof(objItem.get('userchar2')))){
                tempAccountObj.PersonID__pc = String.valueof(objItem.get('userchar2'));
                tempAccountObj.PersonID__c = String.valueof(objItem.get('userchar2'));
            }

            if (String.isNotBlank(String.valueof(objItem.get('zipcode')))){
                tempAccountObj.Residential_Zipocde__pc = String.valueof(objItem.get('zipcode'));
            }

            if (String.isNotBlank(String.valueof(objItem.get('email')))){
                tempAccountObj.Email_raw__c = String.valueof(objItem.get('email'));
            }

            if (String.isNotBlank(String.valueof(objItem.get('middlename')))){
                tempAccountObj.MiddleName = String.valueof(objItem.get('middlename'));
            }

            if (String.isNotBlank(String.valueof(objItem.get('homephone')))){
                tempAccountObj.Home_Phone__pc = String.valueof(objItem.get('homephone'));
            }

            if (String.isNotBlank(String.valueof(objItem.get('workphone')))){
                tempAccountObj.Work_Phone__pc = String.valueof(objItem.get('workphone'));
            }

            if (String.isNotBlank(String.valueof(objItem.get('workphoneextension')))){
                tempAccountObj.Work_Phone_Extension__pc = String.valueof(objItem.get('workphoneextension'));
            }

            if (String.isNotBlank(String.valueof(objItem.get('mobilephone')))){
                tempAccountObj.Mobile_Phone__pc = String.valueof(objItem.get('mobilephone'));
            }

            if (String.isNotBlank(String.valueof(objItem.get('firstname')))){
                tempAccountObj.FirstName = String.valueof(objItem.get('firstname'));
            }

            if (String.isNotBlank(String.valueof(objItem.get('lastname')))){
                tempAccountObj.LastName = String.valueof(objItem.get('lastname'));
            }

            if (String.isNotBlank(String.valueof(objItem.get('altemail')))){
                tempAccountObj.Alt_Email_Raw__c = String.valueof(objItem.get('altemail'));
            }

            if (String.isNotBlank(String.valueof(objItem.get('Description')))){
                tempAccountObj.Description = String.valueof(objItem.get('Description'));
            }

            if (String.isNotBlank(String.valueof(objItem.get('BirthDate')))){                
                string birthdatestring = String.valueof(objItem.get('BirthDate'));
                system.debug('BirthDate:'+birthdatestring);
                string[] sarray = birthdatestring.split('-');
                if(sarray.size() ==3 ){
                    Integer Day = Integer.Valueof(sarray[1]);
                    Integer Month = Integer.Valueof(sarray[0]);
                    Integer Year = Integer.Valueof(sarray[2]);
                    date cdate = date.newInstance(Year,Month, Day);
                    system.debug('cdate:'+cdate);
                    tempAccountObj.BIRTH_DATE__pc = cdate;
                }
                
            }

            if (accountRecordType.size() > 0){
                tempAccountObj.RecordTypeId = accountRecordType[0].Id;
            }
            
            lstAccountInsert.add(tempAccountObj);
        }

        if (lstAccountInsert.size() > 0){
            insert lstAccountInsert;
            result.put('Insert', lstAccountInsert);
        }

        for (Object obj : NameObjectsToUpdate){
            Map<String, Object> objItem = (Map<String, Object>)obj;
            boolean isUpdated = false;
            Account tempAccountObj = new Account();
            if (String.isNotBlank(String.valueof(objItem.get('city')))){
                isUpdated = true;
                if (tempAccountObj.Residential_City__pc != String.valueof(objItem.get('city'))){
                    tempAccountObj.Residential_City__pc = String.valueof(objItem.get('city'));
                }
            }

            if (String.isNotBlank(String.valueof(objItem.get('country')))){
                if (tempAccountObj.Residential_Country__pc != String.valueof(objItem.get('country'))){
                    isUpdated = true;
                    tempAccountObj.Residential_Country__pc = String.valueof(objItem.get('country'));
                }
            }

            if (String.isNotBlank(String.valueof(objItem.get('extraaddress')))){
                if (tempAccountObj.Residential_Extra_Address__pc != String.valueof(objItem.get('extraaddress'))){
                    tempAccountObj.Residential_Extra_Address__pc = String.valueof(objItem.get('extraaddress'));
                    isUpdated = true;
                }
            }

            if (String.isNotBlank(String.valueof(objItem.get('state')))){
                if (tempAccountObj.Residential_State__pc != String.valueof(objItem.get('state'))){
                    tempAccountObj.Residential_State__pc = String.valueof(objItem.get('state'));
                    isUpdated = true;
                }
            }

            if (String.isNotBlank(String.valueof(objItem.get('street')))){
                if (tempAccountObj.Residential_Street__pc != String.valueof(objItem.get('street'))){
                    tempAccountObj.Residential_Street__pc = String.valueof(objItem.get('street'));
                    isUpdated = true;
                }
            }

            if (String.isNotBlank(String.valueof(objItem.get('userchar2')))){
                if (tempAccountObj.PersonID__pc != String.valueof(objItem.get('userchar2'))){
                    tempAccountObj.PersonID__pc = String.valueof(objItem.get('userchar2'));
                    tempAccountObj.PersonID__c = String.valueof(objItem.get('userchar2'));
                    isUpdated = true;
                }
            }

            if (String.isNotBlank(String.valueof(objItem.get('zipcode')))){
                if (tempAccountObj.Residential_Zipocde__pc != String.valueof(objItem.get('zipcode'))){
                    tempAccountObj.Residential_Zipocde__pc = String.valueof(objItem.get('zipcode'));
                    isUpdated = true;
                }

            }

            if (String.isNotBlank(String.valueof(objItem.get('email')))){
                if (tempAccountObj.Email_raw__c != String.valueof(objItem.get('email'))){
                    tempAccountObj.Email_raw__c = String.valueof(objItem.get('email'));
                    isUpdated = true;
                }
            }

            if (String.isNotBlank(String.valueof(objItem.get('middlename')))){
                if (tempAccountObj.MiddleName != String.valueof(objItem.get('middlename'))){
                    tempAccountObj.MiddleName = String.valueof(objItem.get('middlename'));
                    isUpdated = true;
                }
            }

            if (String.isNotBlank(String.valueof(objItem.get('homephone')))){
                if (tempAccountObj.Home_Phone__pc != String.valueof(objItem.get('homephone'))){
                    tempAccountObj.Home_Phone__pc = String.valueof(objItem.get('homephone'));
                    isUpdated = true;
                }
            }

            if (String.isNotBlank(String.valueof(objItem.get('workphone')))){
                if (tempAccountObj.Work_Phone__pc != String.valueof(objItem.get('workphone'))){
                    tempAccountObj.Work_Phone__pc = String.valueof(objItem.get('workphone'));
                    isUpdated = true;
                }
            }

            if (String.isNotBlank(String.valueof(objItem.get('workphoneextension')))){
                if (tempAccountObj.Work_Phone_Extension__pc != String.valueof(objItem.get('workphoneextension'))){
                    tempAccountObj.Work_Phone_Extension__pc = String.valueof(objItem.get('workphoneextension'));
                    isUpdated = true;
                }
            }

            if (String.isNotBlank(String.valueof(objItem.get('mobilephone')))){
                if (tempAccountObj.Mobile_Phone__pc != String.valueof(objItem.get('mobilephone'))){
                    tempAccountObj.Mobile_Phone__pc = String.valueof(objItem.get('mobilephone'));
                    isUpdated = true;
                }
            }

            if (String.isNotBlank(String.valueof(objItem.get('firstname')))){
                if (tempAccountObj.FirstName != String.valueof(objItem.get('firstname'))){
                    tempAccountObj.FirstName = String.valueof(objItem.get('firstname'));
                    isUpdated = true;
                }
            }

            if (String.isNotBlank(String.valueof(objItem.get('lastname')))){
                if (tempAccountObj.LastName != String.valueof(objItem.get('lastname'))){
                    tempAccountObj.LastName = String.valueof(objItem.get('lastname'));
                    isUpdated = true;
                }
            }

            if (String.isNotBlank(String.valueof(objItem.get('altemail')))){
                if (tempAccountObj.Alt_Email_Raw__c != String.valueof(objItem.get('altemail'))){
                    tempAccountObj.Alt_Email_Raw__c = String.valueof(objItem.get('altemail'));
                    isUpdated = true;
                }
            }

            if (String.isNotBlank(String.valueof(objItem.get('Description')))){
                if (tempAccountObj.Description != String.valueof(objItem.get('Description'))){
                    tempAccountObj.Description = String.valueof(objItem.get('Description'));
                    isUpdated = true;
                }
            }

            if (String.isNotBlank(String.valueof(objItem.get('BirthDate')))){
                date cdate = Date.valueOf(String.valueof(objItem.get('BirthDate')));
                if (tempAccountObj.BIRTH_DATE__pc != cdate){
                    tempAccountObj.BIRTH_DATE__pc = cdate;
                    isUpdated = true;
                }
            }

            if (isUpdated){
                lstAccountUpdate.add(tempAccountObj);
            }
        }

        if (lstAccountUpdate.size() > 0){
            update lstAccountUpdate;
            result.put('Update', lstAccountUpdate);
        }
        return result;
    }

    public static void CreateUpdatePersonRecord(string Type, string AccountSFId, string MemberSFId, string PersonId){
        Person_Account__c objPA = new Person_Account__c();
        if(Type == 'ACCT'){
            objPA.Name_Type__c = decimal.valueOf('0');
        }
        
        objPA.Account_Number__c = AccountSFId;
        objPA.PersonID__c = MemberSFId;
        insert objPA;
        
    }

}