public class Member_HP_HV_No_Beneficiary{
	   
    @AuraEnabled
    public static AccountDataTableWrapper getData(string MemberBranchQuery, string HighValueFlagQuery, Decimal pageNumber, Decimal pageSize){
        
        MemberBranchQuery = MemberBranchQuery.trim();
		HighValueFlagQuery = HighValueFlagQuery.trim();

		Integer pSize = (Integer)pageSize;
		Integer pNumber = (Integer)pageNumber;

		//Offset for SOQL
		Integer offset = (pNumber - 1) * pSize;

        List<Person_Account__C> paList = new List<Person_Account__C>();
        List<Person_Account__C> paList1 = new List<Person_Account__C>();

        String genQuery = 'SELECT id, Account_Number__c, PersonId__c, Account_Number__r.Maturity_Date__c, PersonId__r.High_Value_Flag__c,TypeTranslate__c,Account_Number__r.Name from Person_Account__C where';
        String whereQuery;

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
			paList = Database.query(totalQuery);
			system.debug('paList' + paList);
        }
        else{
            String totalQuery = genQuery.replace(' where','') +  ' limit 1000';
			system.debug('TotalQuery' + totalQuery);
			paList = Database.query(totalQuery);
			system.debug('paList' + paList);
        }
       
        
        // List<Person_Account__C> paList = [select Id, PersonId__r.High_Value_Flag__c, Account_Number__c, Account_Number__r.RecType__c, TypeTranslate__c, Account_Number__r.Name
		//                                   from Person_Account__C
		//                                   where PersonId__r.High_Value_Flag__c > 0 
        //                                   order by TypeTranslate__c desc];
                                          
        set<string> typeList = new set<string>();       
        set<String> BeneficiaryPersonIdSet = new set<String>();
        set<String> BeneficiaryaccountNumberSet = new set<String>();

		for (Member360_TypeTranslate__c t : Member360_TypeTranslate__c.getAll().values()){
			typeList.add(t.name);
        }       

        for(Person_Account__c var: paList){
            
            if(var.TypeTranslate__c.contains('Beneficiary')){
                BeneficiaryaccountNumberSet.add(var.Account_Number__r.Name);
                BeneficiaryPersonIdSet.add(var.PersonId__c);
            }
            
        }

        String genQuery1 = 'SELECT id, Account_Number__c, PersonId__c, Account_Number__r.Maturity_Date__c, PersonId__r.High_Value_Flag__c,TypeTranslate__c,Account_Number__r.Name from Person_Account__C where';
		String whereQuery1;

        whereQuery1 = ' PersonId__c NOT IN: BeneficiaryPersonIdSet ';

        if (whereQuery != NULL){
            whereQuery1 = whereQuery1 + 'AND ' + whereQuery;
			String totalQuery1 = genQuery1 + whereQuery1 + ' limit 1000';
			system.debug('TotalQuery1' + totalQuery1);
			paList1 = Database.query(totalQuery1);
			system.debug('paList1' + paList1);
        }
        else{           
			String totalQuery1 = genQuery1 + whereQuery1 + ' limit 1000';
			system.debug('TotalQuery1' + totalQuery1);
			paList1 = Database.query(totalQuery1);
            system.debug('paList1' + paList1);           
        }
        
        // List<Person_Account__C> paList1 = [SELECT Id, PersonId__r.High_Value_Flag__c, Account_Number__c, Account_Number__r.RecType__c, TypeTranslate__c, Account_Number__r.Name
		//                                   from Person_Account__C
		//                                   where PersonId__c NOT IN: BeneficiaryPersonIdSet limit 1000];

        system.debug('paList1=='+paList1.size());


        set<string> MemberPersonSet = new set<string>();
		for (Person_Account__C p : paList1){
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