public class CollectionsInLightningCls 
{
	@AuraEnabled
	public static Map<String, Map<String, List<String>>> getPicklistValues(String objpicklistFieldsMap)
	{
        System.Debug('objpicklistFieldsMap Value' + objpicklistFieldsMap);
		Map<String, List<String>> objPickmap = (Map<String, List<String>>)JSON.deserialize(objpicklistFieldsMap, Map<String, List<String>>.class);
		system.debug('objpickmap ' + objPickmap);
		 
		Map<String, Map<String, List<String>>> objFieldPicklistMap = new Map<String, Map<String, List<String>>>();
		List<String> sobjectslist = new List<String>(objPickmap.keySet());
		Schema.DescribeSobjectResult[] results = Schema.describeSObjects(sobjectslist);
		Map<String, List<String>> fieldOptionsMap;
		system.debug('results---' + results);
		for(Schema.DescribeSObjectResult result : results)
		{
			fieldOptionsMap = new Map<String, List<String>>();
			 system.debug('result123---' + result);
			Schema.sObjectType objType = result.getSObjectType();
			 
			Schema.DescribeSObjectResult objDescribe = objType.getDescribe();
			map<String, Schema.SObjectField> fieldMap = objDescribe.fields.getMap();
			List<String> objFieldlist = objPickmap.get(result.getName());
			system.debug('objname ' + result.getName());
			system.debug('list of fields ' + objFieldlist);
			for(String fld : objFieldlist)
			{
				system.debug('fields ' + fld);
				List<String > allOpts = new list<String>();
				list<Schema.PicklistEntry> values =
				fieldMap.get(fld).getDescribe().getPickListValues();
				 
				for (Schema.PicklistEntry a : values)
				{
					allOpts.add(a.getValue());
				}
				fieldOptionsMap.put(fld, allOpts);
			}
			
			objFieldPicklistMap.put(result.getName(), fieldOptionsMap);
		}
		return objFieldPicklistMap;
	}
	
	@AuraEnabled
	public static list<NA_Other_Existing_Loans__c> getExistingLoans(String AssessmentId)
	{
		list<NA_Other_Existing_Loans__c> otherExistingLoans = new list<NA_Other_Existing_Loans__c>();
		otherExistingLoans = [select id, Balance__c, End_Date__c, Financial_Institution__c, Needs_Assessment__c, Rate__c, Type_of_Loan__c 
                        from NA_Other_Existing_Loans__c where Needs_Assessment__c =: AssessmentId];
                        
		return otherExistingLoans;		
	}
	
	@AuraEnabled
	public static list<NA_Membership_Referral_Questions__c> getMembershipLoans(String AssessmentId)
	{
		list<NA_Membership_Referral_Questions__c> loans = new list<NA_Membership_Referral_Questions__c>();
		loans = [select id, Age__c, Name__c, Needs_Assessment__c, Want_to_Refer_Membership__c 
                        from NA_Membership_Referral_Questions__c where Needs_Assessment__c =: AssessmentId];
                        
		return loans;		
	}
	
	@AuraEnabled
	public static list<NA_Deposit__c> GetDepositData(String AssessmentId)
	{
		list<NA_Deposit__c> deposits = new list<NA_Deposit__c>();
		deposits = [select id, Balance__c, Financial_Instituition__c, Needs_Assessment__c, Rate__c, Type__c 
                        from NA_Deposit__c where Needs_Assessment__c =: AssessmentId];
                        
		return deposits;		
	}
	
    
	@AuraEnabled    
	public static Map<String, List<KeyValuePairModelInt>> getYearPickList()
	{   
        Map<String, List<KeyValuePairModelInt>> options = new Map<String, List<KeyValuePairModelInt>>();
        KeyValuePairModelInt pair = new KeyValuePairModelInt();
        List<KeyValuePairModelInt> lstPair = new List<KeyValuePairModelInt>();
		pair.Text = '--None--';
		pair.Value = 0;
		        
        lstPair.add(pair);
        
        for (Integer i = System.Today().year() + 1; i < System.Today().year() + 31; i++) 
        {
            pair = new KeyValuePairModelInt();
            pair.Text = string.valueof(i);
            pair.Value = i;
            lstPair.add(pair);            
    	}
        options.put('data', lstPair);
        return options;		
	}
	
	    
	public class KeyValuePairModelInt
	{
		@AuraEnabled    
		public string Text {get;set;}
		@AuraEnabled    
		public Integer Value {get;set;}
		
	} 
}