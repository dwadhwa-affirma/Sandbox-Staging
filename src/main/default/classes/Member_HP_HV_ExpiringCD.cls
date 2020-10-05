public class Member_HP_HV_ExpiringCD{
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
	public static List<Account> getData(){

		HP_HV_Expiring_CD_Configurations__c mcs = HP_HV_Expiring_CD_Configurations__c.getValues('Primary');
		Integer DaysToExpire = 0;
		DaysToExpire = (Integer)mcs.DaysToExpire__c;		
		date NextNDays = system.today().addDays(DaysToExpire);
		system.debug('NextNDays##' + NextNDays);
		

		List<Person_Account__C> pa = [SELECT id, Account_Number__c, PersonId__c, Account_Number__r.Maturity_Date__c, PersonId__r.High_Value_Flag__c
		                              from Person_Account__C
		                              where Account_Number__r.Maturity_Date__c <=: NextNDays and PersonId__r.High_Value_Flag__c > 0];
		set<string> MemberPersonSet = new set<string>();
		for (Person_Account__C p : pa){
			MemberPersonSet.add(p.PersonId__c);
		}

		List<Account> accounts = [SELECT Id, Name, Member_Branch__c, Phone, High_Value_Flag__c
		                          FROM Account
		                          Where id in :MemberPersonSet];
		system.debug('accounts==' + accounts);


		return accounts;
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