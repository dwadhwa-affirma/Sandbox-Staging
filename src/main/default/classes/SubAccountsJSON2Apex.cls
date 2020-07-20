public class SubAccountsJSON2Apex {

        public CardDetail CardDetail;
        public ShareDetail ShareDetail;
        public LoanDetail LoanDetail;
    
        public class CardDetail {
            public String AccountId;
            public String AuthLimit;
            public String BlockCode;
            public String CardName;
            public String CardNumber;
            public String CloseDate;
            public String DepLimit;
            public String ExpirationDate;
            public String Status;
            public String StatusReason;
           // public WarningCodes WarningCodes;    
            public String WarningCodes;

        }
    
        public class ShareDetail {
            public String AvailableBalance;
            public String Balance;
            public String CloseDate;
            public String LastTranDate;
            public String MaturityDate;
            public String OdtOptInOptionOther;
            public String OdtOptInOptionRegE;
            public String AccountId;
            public String CpEligibility;
            public String CpRemovedDate;
            public String CpRevokedDate;
            public String LastOverdrawnDate;
            public String DivPostCode;
            public String NegativeBalanceDate;
            public String OverdraftTolerance;
           // public WarningCodes WarningCodes;
            public String WarningCodes;
        }
    
        public class LoanDetail {
            public String AccountId;
            public String AvailableCredit;
            public String Balance;
            public String CloseDate;
            public String CreditLimit;
            public String CreditLimitExpiration;
            public String DueDate;
            public String InterestYtd;
            public String InterestRate;
            public String InterestRateMargin;
            public String InterestRateMarginSign;
            public String LastTranDate;
            public String LastPaymentDate;
            public String LateChargeDue;
            public String LateChargeUnpaid;
            public String MaturityDate;
            public String PartialPayment;
            public String PastDueAmount;
            public String PaymentDue;
            public String PayoffAmount;
            public String ServiceCodes;
           // public WarningCodes WarningCodes;
            public String WarningCodes;
        }
    
      /*  public class WarningCodes {
            public String WarningCode01;
            public String WarningCode02;
            public String WarningCode03;
            public String WarningCode04;
            public String WarningCode05;
            public String WarningCode06;
            public String WarningCode07;
            public String WarningCode08;
            public String WarningCode09;
            public String WarningCode10;
            public String WarningCode11;
            public String WarningCode12;
            public String WarningCode13;
            public String WarningCode14;
            public String WarningCode15;
            public String WarningCode16;
            public String WarningCode17;
            public String WarningCode18;
            public String WarningCode19;
            public String WarningCode20;
        } */
    
    public static SubAccountsJSON2Apex parse(String json) {
		return (SubAccountsJSON2Apex) System.JSON.deserialize(json, SubAccountsJSON2Apex.class);
	}

    }