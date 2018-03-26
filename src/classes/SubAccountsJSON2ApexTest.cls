@IsTest
public class SubAccountsJSON2ApexTest {
	
	static testMethod void testParse() {
		String json = '{\"CardDetail\":null,\"ShareDetail\":{\"AvailableBalance\":\"839.16\",\"Balance\":\"864.16\",\"CloseDate\":\"\",\"LastTranDate\":\"2016-09-06T00:00:00Z\",\"MaturityDate\":\"\",\"OdtOptInOptionOther\":\"0\",\"OdtOptInOptionRegE\":\"-1\",\"AccountId\":\"0000214414S0100P0100\",\"CpEligibility\":-1,\"CpRemovedDate\":\"\",\"CpRevokedDate\":\"\",\"LastOverdrawnDate\":\"\",\"DivPostCode\":0,\"NegativeBalanceDate\":\"\",\"OverdraftTolerance\":null,\"WarningCodes\":\"\"},\"LoanDetail\":null}';
		SubAccountsJSON2Apex obj = SubAccountsJSON2Apex.parse(json);
		System.assert(obj != null);
	}
}