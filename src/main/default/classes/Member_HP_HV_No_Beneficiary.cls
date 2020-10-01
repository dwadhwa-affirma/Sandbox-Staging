public class Member_HP_HV_No_Beneficiary{
	public List<Account> accounts{ get; set; }

	public Member_HP_HV_No_Beneficiary(){
		List<Person_Account__C> paList = [select Id, PersonId__r.High_Value_Flag__c, Account_Number__c, Account_Number__r.RecType__c, TypeTranslate__c, Account_Number__r.Name
		                                  from Person_Account__C
		                                  where PersonId__r.High_Value_Flag__c > 0 
                                          order by TypeTranslate__c desc];
                                          
        set<string> typeList = new set<string>();
        List<String> accountNumberSetWOBeneficiary = new List<String>();
        List<String> accountNumberSetWOBeneficiaryContact = new List<String>();
        set<String> BeneficiaryaccountNumberSet = new set<String>();
        set<String> BeneficiaryPersonIdSet = new set<String>();

		for (Member360_TypeTranslate__c t : Member360_TypeTranslate__c.getAll().values()){
			typeList.add(t.name);
        }
        
        List<string> accountNumberSet = new List<string>();
        Map<string,string> listRelationshipsexcluded = new  Map<string,string>();
        Map<string,string> listRelationshipsNameexcluded = new  Map<string,string>();  
        Map<string,string> listRelationshipsName = new  Map<string,string>();
        Map<string,string> listRelationships = new  Map<string,string>(); 

        for(Person_Account__c var: paList){
            accountNumberSet.add(var.Account_Number__r.Name);
            listRelationships.put(var.Account_Number__c,var.TypeTranslate__c);
            listRelationshipsName.put(var.Account_Number__r.Name,var.TypeTranslate__c);
            if(var.TypeTranslate__c.contains('Beneficiary')){
                BeneficiaryaccountNumberSet.add(var.Account_Number__r.Name);
                BeneficiaryPersonIdSet.add(var.PersonId__c);
            }
            if(typeList.contains(var.TypeTranslate__c)){
        					
            }    
            else{
   
                    listRelationshipsexcluded.put(var.Account_Number__c,var.TypeTranslate__c);
                    listRelationshipsNameexcluded.put(var.Account_Number__r.Name,var.TypeTranslate__c);
                }
        }

        List<Account_Details__c> listACCList =  [SELECT Id, Name from Account_Details__c where Name In: accountNumberSet and RecType__c != 'CARD'];
        for(Account_Details__c item: listACCList)
        {
            if(!listRelationshipsexcluded.containsKey(item.id))
            {
            	 //accIdSetWOBeneficiaryContact.add(item.id);
            }
            if(!listRelationshipsNameexcluded.containsKey(item.Name))
            {
            	 accountNumberSetWOBeneficiaryContact.add(item.Name);
            }  
           
            
        }
        list<Account_Details__c> accList1 = new list<Account_Details__c>();
        accList1 = [SELECT Id, Name,TypeTranslate__c FROM Account_Details__c WHERE Name IN:accountNumberSetWOBeneficiaryContact and RecType__c != 'CARD'];
        
        set<string> accName = new set<string>();
        for(Account_Details__c var: accList1){
            accName.add(var.Name);
        }
        system.debug('BeneficiaryaccountNumberSet=='+BeneficiaryaccountNumberSet);
        List<Person_Account__C> paList1 = [SELECT Id, PersonId__r.High_Value_Flag__c, Account_Number__c, Account_Number__r.RecType__c, TypeTranslate__c, Account_Number__r.Name
		                                  from Person_Account__C
		                                  where PersonId__c NOT IN: BeneficiaryPersonIdSet and PersonId__r.High_Value_Flag__c > 0];

        system.debug('paList1=='+paList1.size());


        set<string> MemberPersonSet = new set<string>();
		for (Person_Account__C p : paList1){
			MemberPersonSet.add(p.PersonId__c);
		}

		accounts = [SELECT Id, Name, Member_Branch__c, Phone, High_Value_Flag__c
		            FROM Account
		            Where id in :MemberPersonSet];
		system.debug('accounts==' + accounts);
    }
    
    @AuraEnabled
    public static List<Account> getData(){
        List<Person_Account__C> paList = [select Id, PersonId__r.High_Value_Flag__c, Account_Number__c, Account_Number__r.RecType__c, TypeTranslate__c, Account_Number__r.Name
		                                  from Person_Account__C
		                                  where PersonId__r.High_Value_Flag__c > 0 
                                          order by TypeTranslate__c desc];
                                          
        set<string> typeList = new set<string>();
        List<String> accountNumberSetWOBeneficiary = new List<String>();
        List<String> accountNumberSetWOBeneficiaryContact = new List<String>();
        set<String> BeneficiaryaccountNumberSet = new set<String>();
        set<String> BeneficiaryPersonIdSet = new set<String>();

		for (Member360_TypeTranslate__c t : Member360_TypeTranslate__c.getAll().values()){
			typeList.add(t.name);
        }
        
        List<string> accountNumberSet = new List<string>();
        Map<string,string> listRelationshipsexcluded = new  Map<string,string>();
        Map<string,string> listRelationshipsNameexcluded = new  Map<string,string>();  
        Map<string,string> listRelationshipsName = new  Map<string,string>();
        Map<string,string> listRelationships = new  Map<string,string>(); 

        for(Person_Account__c var: paList){
            accountNumberSet.add(var.Account_Number__r.Name);
            listRelationships.put(var.Account_Number__c,var.TypeTranslate__c);
            listRelationshipsName.put(var.Account_Number__r.Name,var.TypeTranslate__c);
            if(var.TypeTranslate__c.contains('Beneficiary')){
                BeneficiaryaccountNumberSet.add(var.Account_Number__r.Name);
                BeneficiaryPersonIdSet.add(var.PersonId__c);
            }
            if(typeList.contains(var.TypeTranslate__c)){
        					
            }    
            else{
   
                    listRelationshipsexcluded.put(var.Account_Number__c,var.TypeTranslate__c);
                    listRelationshipsNameexcluded.put(var.Account_Number__r.Name,var.TypeTranslate__c);
                }
        }

       
        List<Person_Account__C> paList1 = [SELECT Id, PersonId__r.High_Value_Flag__c, Account_Number__c, Account_Number__r.RecType__c, TypeTranslate__c, Account_Number__r.Name
		                                  from Person_Account__C
		                                  where PersonId__c NOT IN: BeneficiaryPersonIdSet and PersonId__r.High_Value_Flag__c > 0];

        system.debug('paList1=='+paList1.size());


        set<string> MemberPersonSet = new set<string>();
		for (Person_Account__C p : paList1){
			MemberPersonSet.add(p.PersonId__c);
		}

		List<Account> accounts = [SELECT Id, Name, Member_Branch__c, Phone, High_Value_Flag__c
		            FROM Account
		            Where id in :MemberPersonSet];
        system.debug('accounts==' + accounts);
        return accounts;
        
    }
}