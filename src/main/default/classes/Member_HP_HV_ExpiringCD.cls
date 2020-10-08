public without sharing class Member_HP_HV_ExpiringCD{
	public List<Account> accounts{ get; set; }

	public Member_HP_HV_ExpiringCD(){
		//if (accounts == null){
		List<Person_Account__C> pa = [SELECT id, Account_Number__c, PersonId__c, Account_Number__r.Maturity_Date__c, PersonId__r.High_Value_Flag__c
		                              from Person_Account__C
		                              where Account_Number__r.Maturity_Date__c = NEXT_N_DAYS:365 and PersonId__r.High_Value_Flag__c > 0];
		set<string> MemberPersonSet = new set<string>();
		for (Person_Account__C p : pa){
			MemberPersonSet.add(p.PersonId__c);
		}

		accounts = [SELECT Id, Name, Member_Branch__c, Phone, High_Value_Flag__c
		            FROM Account
		            Where id in :MemberPersonSet];
		system.debug('accounts==' + accounts);
		//    }
		//    return accounts;
	}

	@AuraEnabled
	public static AccountDataTableWrapper getData(string MemberBranchQuery, string HighValueFlagQuery, Decimal pageNumber, Decimal pageSize){

		MemberBranchQuery = MemberBranchQuery.trim();
		HighValueFlagQuery = HighValueFlagQuery.trim();

		Integer pSize = (Integer)pageSize;
		Integer pNumber = (Integer)pageNumber;

		//Offset for SOQL
		Integer offset = (pNumber - 1) * pSize;

		List<Person_Account__C> pa = new List<Person_Account__C>();

		HP_HV_Expiring_CD_Configurations__c mcs = HP_HV_Expiring_CD_Configurations__c.getValues('Primary');
		Integer DaysToExpire = 0;
		DaysToExpire = (Integer)mcs.DaysToExpire__c;
		date NextNDays = system.today().addDays(DaysToExpire);
		system.debug('NextNDays##' + NextNDays);


		String genQuery = 'SELECT id, Account_Number__c, PersonId__c, Account_Number__r.Maturity_Date__c, PersonId__r.High_Value_Flag__c from Person_Account__C    where';
		String whereQuery;

		whereQuery = ' Account_Number__r.Maturity_Date__c <=: NextNDays ';

		if (MemberBranchQuery != ''){
			if (whereQuery != NULL){
				whereQuery = whereQuery + 'AND PersonId__r.Member_Branch__c LIKE \'%' + MemberBranchQuery + '%\'';
			} else{
				whereQuery = ' PersonId__r.Member_Branch__c LIKE \'%' + MemberBranchQuery + '%\'';
			}
		}
		if (HighValueFlagQuery != ''){
			if (HighValueFlagQuery == 'None'){
				whereQuery = whereQuery;
			} else if (HighValueFlagQuery == 'High Value'){
				if (whereQuery != NULL){
					whereQuery = whereQuery + ' AND PersonId__r.High_Value_Flag__c = 1';
				} else{
					whereQuery = ' PersonId__r.High_Value_Flag__c = 1';
				}
			} else if (HighValueFlagQuery == 'High Potential'){
				if (whereQuery != NULL){
					whereQuery = whereQuery + ' AND PersonId__r.High_Value_Flag__c = 2';
				} else{
					whereQuery = ' PersonId__r.High_Value_Flag__c = 2';
				}
			} else if (HighValueFlagQuery == 'High Value and High Potential'){
				if (whereQuery != NULL){
					whereQuery = whereQuery + ' AND PersonId__r.High_Value_Flag__c > 0';
				} else{
					whereQuery = ' PersonId__r.High_Value_Flag__c > 0';
				}
			}

		}

		if (whereQuery != NULL){
			String totalQuery = genQuery + whereQuery;
			system.debug('TotalQuery' + totalQuery);
			pa = Database.query(totalQuery);
			system.debug('pa' + pa);
		}

		// List<Person_Account__C> pa = [SELECT id, Account_Number__c, PersonId__c, Account_Number__r.Maturity_Date__c, PersonId__r.High_Value_Flag__c
		//                               from Person_Account__C
		//                               where Account_Number__r.Maturity_Date__c <=: NextNDays and PersonId__r.High_Value_Flag__c > 0];
		set<string> MemberPersonSet = new set<string>();
		for (Person_Account__C p : pa){
			MemberPersonSet.add(p.PersonId__c);
		}

		Integer totalRecords = [SELECT COUNT()
		                        FROM Account
		                        Where id in :MemberPersonSet];
		Integer recordEnd = pSize * pNumber;

		AccountDataTableWrapper objDT = new AccountDataTableWrapper();
		objDT.pageSize = pSize;
		objDT.pageNumber = pNumber;
		objDT.recordStart = offset + 1;
		objDT.recordEnd = totalRecords >= recordEnd ? recordEnd : totalRecords;
		objDT.totalRecords = totalRecords;
		objDT.accountList = [SELECT Id, Name, Member_Branch__c, Phone, High_Value_Flag__c
		                     FROM Account
		                     Where id in :MemberPersonSet
		                     ORDER BY Name
		                     LIMIT :pSize
							 OFFSET :offset];
							 
		system.debug('objDT.accountList' + objDT.accountList);
		return objDT;

		// List<Account> accounts = [SELECT Id, Name, Member_Branch__c, Phone, High_Value_Flag__c
		//                           FROM Account
		//                           Where id in :MemberPersonSet];
		//system.debug('accounts==' + accounts);


		//return accounts;
	}

	public class AccountDataTableWrapper{
		@AuraEnabled
		public Integer pageSize{ get; set; }

		@AuraEnabled
		public Integer pageNumber{ get; set; }

		@AuraEnabled
		public Integer totalRecords{ get; set; }

		@AuraEnabled
		public Integer recordStart{ get; set; }

		@AuraEnabled
		public Integer recordEnd{ get; set; }

		@AuraEnabled
		public List<Account> accountList{ get; set; }
	}
}

// public with sharing class Member_HP_HV_ExpiringCD{
//     private ApexPages.StandardSetController setController;
//     public Member_HP_HV_ExpiringCD(ApexPages.StandardSetController setController){
//         this.setController = setController;
//         set<string> MemberPersonSet = new set<string>();
//         List<Person_Account__C> pa = [SELECT id, Account_Number__c, PersonId__c, Account_Number__r.Maturity_Date__c, PersonId__r.High_Value_Flag__c
//                                       from Person_Account__C
//                                       where Account_Number__r.Maturity_Date__c = NEXT_N_DAYS:365 and PersonId__r.High_Value_Flag__c > 0];
//         for (Person_Account__C p : pa){
//             MemberPersonSet.add(p.PersonId__c);
//         }
//         List<Account> Resultrecords = [SELECT Id, Name, Member_Branch__c, Phone, High_Value_Flag__c
//                                        FROM Account
//                                        Where id in :MemberPersonSet];
//         system.debug('Resultrecords==' + Resultrecords);
//         setController.setSelected(Resultrecords);
//     }
// }