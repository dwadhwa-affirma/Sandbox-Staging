public class UpdateCaseCategoriesController {
	 
	@auraenabled
    public static  Map<string,object> getData(string caseId){
    	system.debug('Test1###');
    	List<Case> CaseList = [select id, Primary_Category__c, Secondary_Category__c, Tertiary_Category__c
    							 from case where id =: caseId];
    	 Map<string,object> mapList = new Map<string,object>();
    	 mapList.put('CaseData', CaseList[0]);
    	 
    	 boolean showData1 = false;		
		 Set<Id> results = new Set<Id>();		
		Map<Id,Id> grRoleMap = new Map<Id,Id>();			
			for(Group gr : [select id,relatedid,name from Group])
			{
				grRoleMap.put(gr.relatedId,gr.id);
			}
			
			Set<Id> groupwithUser = new Set<Id>();			
			
			for(GroupMember  u :[select groupId from GroupMember where UserOrGroupId=:UserInfo.getUserId() and (Group.Type = 'Regular' OR Group.Type='Role' OR Group.Type='RoleAndSubordinates')])
			{
				groupwithUser.add(u.groupId);
			}
		
			for(User  u :[select UserRoleId from User where id=:UserInfo.getUserId()])
			{
				if(grRoleMap.containsKey(u.UserRoleId))
				{
					results.add(grRoleMap.get(u.UserRoleId));
				}
			}
			
			results.addAll(groupwithUser);
			
			Map<Id,Id> grMap = new Map<Id,Id>();
			for(GroupMember gr : [select id,UserOrGroupId,Groupid from GroupMember where
			        (Group.Type = 'Regular' OR Group.Type='Role' OR Group.Type='RoleAndSubordinates')])
			{
				grMap.put(gr.UserOrGroupId,gr.Groupid);
			}
			for(Id i :results)
			{
				if(grMap.containsKey(i))
				{
					results.add(grMap.get(i));
				}
			}
			
			
			system.debug('########' + results);
			  
        	showData1 = false;
  		
  		
		list<GroupMember> listNamegroup =	[select group.developerName from GroupMember where UserOrGroupId in: results];
		set<string> listName = new set<string>();
			for(GroupMember i :listNamegroup)
			{
				
					listName.add(i.group.developerName );
				
			}
			
			system.debug('########' + listName);
		   
		      if (listName.contains('Update_Case_Category')) {
		           showData1 = true;
		      }
		     
		     
		     
		     Set<String> groupNames = new Set<String>();
		   for (GroupMember gm : [select 
		                             group.name,
		                             group.DeveloperName 
		                          from GroupMember 
		                          where UserOrGroupId = :UserInfo.getUserId()]) {
		       groupNames.add(gm.group.DeveloperName);
		   }
			
			system.debug('groupNames---' + groupNames);
		   
		      if (groupNames.contains('Update_Case_Category')) {
		           showData1 = true;
		      }
		     
		      
		     mapList.put('hasAccess', showData1);
    	 
    	 
    	 return mapList;
    }
    
     @AuraEnabled
    public static Map<String, Map<String, List<String>>> getPicklistValues(String objpicklistFieldsMap)
    {
    	return CollectionsInLightningCls.getPicklistValues(objpicklistFieldsMap);
    }
    
     @AuraEnabled
	public static Map<String,List<String>> getDependentOptionsImpl(String objName, String contrfieldName, String depfieldName)
	{
		return clspicklist.getDependentOptionsImpl(objName, contrfieldName, depfieldName);
	}
    
      @AuraEnabled
     public static  List<KeyValuePairModel> getscOptions(string pcValue) {
    
        list<CaseRecordType__c> scList = [SELECT Id,
                                                 Primary_Category__c,
                                                 Secondary_Category__c FROM CaseRecordType__c WHERE Primary_Category__c =:pcValue];
        set<String> scSet = new set<String>(); 

        scList.sort();
        for(CaseRecordType__c var: scList){
            scSet.add(var.Secondary_Category__c);
        } 
        list<KeyValuePairModel> op = new list<KeyValuePairModel>();
        op.add(new KeyValuePairModel('--- None ---',''));
        for (String sc : scSet)
        {
            if(sc!='None'){
            	op.add(new KeyValuePairModel(sc,sc));
            }
        }
        return op;
    }
    
    
        @AuraEnabled
     public static  List<KeyValuePairModel>  gettcOptions(string scValue) {
        
        list<CaseRecordType__c> tcList = [SELECT Id,
                                                 Primary_Category__c,
                                                 Secondary_Category__c,
                                                 Teritiary_Category__c FROM CaseRecordType__c WHERE Secondary_Category__c =:scValue];
        set<String> scSet = new set<String>();
        tcList.sort();
        for(CaseRecordType__c tcr: tcList){
            scSet.add(tcr.Teritiary_Category__c);
        }
     //   str.sort();
        list<KeyValuePairModel> op = new list<KeyValuePairModel>();
        op.add(new KeyValuePairModel('--- None ---',''));
        for (String tc : scSet){
            if(tc!='None'){
                op.add(new KeyValuePairModel(tc,tc));
            }
        }
        
        return op;
    } 

    
    public static List<KeyValuePairModel> pcOptions() {
    
    	Schema.DescribeFieldResult statusFieldDescription = Case.Primary_Category__c.getDescribe();
        System.debug('Getting description:::'+ statusFieldDescription);
        list<KeyValuePairModel> op = new list<KeyValuePairModel>();
        op.add(new KeyValuePairModel('--- None ---',''));
        for (Schema.Picklistentry picklistEntry : statusFieldDescription.getPicklistValues())
        {
            op.add(new KeyValuePairModel(pickListEntry.getValue(),pickListEntry.getLabel()));
        }
        return op;
    }
    
     @AuraEnabled
    public static Map<string,string> saveCategories(Case caseObject)
    {
    	string returnvalue = '';
    	Map<string, string> mapresult = new Map<string,string>();
    	
    	
          if(caseObject.Primary_Category__c == NULL || caseObject.Primary_Category__c == '-None-'){
            
            returnvalue = 'Please select Primary Category';
            mapresult.put('IsSaved', 'false');
            mapresult.put('Message', returnvalue);
            return mapresult;
        } 
        else if(caseObject.Secondary_Category__c == NULL || caseObject.Secondary_Category__c == '-None-'){
           
            returnvalue = 'Please select Secondary Category';
            mapresult.put('IsSaved', 'false');
            mapresult.put('Message', returnvalue);
            return mapresult;
        } 
         else if(caseObject.Tertiary_Category__c == NULL || caseObject.Tertiary_Category__c == '-None-' && caseObject.Secondary_Category__c != 'Transfers Between Sub-Accounts' && caseObject.Secondary_Category__c != 'Transfers Between Memberships'
                 && caseObject.Secondary_Category__c != 'Check By Phone' && caseObject.Secondary_Category__c != 'Loan Payment' && caseObject.Secondary_Category__c != 'Check Withdrawal to Self'
                 && caseObject.Secondary_Category__c != 'Credit Card Payment' && caseObject.Secondary_Category__c != 'Check Withdrawal to Third Party' && caseObject.Secondary_Category__c != 'Other') 
         /* else if(tcValue == NULL || tcValue == '-None-' && scValue != 'Death Claims' && scValue != 'EPS Research' && scValue != 'OnBoarding')*/
           {
            
            returnvalue = 'Please select Tertiary Category';
            mapresult.put('IsSaved', 'false');
            mapresult.put('Message', returnvalue);
            return mapresult;
           } 
        
        else{
           if(caseObject.Tertiary_Category__c == '-None-'){
                caseObject.Tertiary_Category__c = 'None';
            } 
        }     
        list<CaseRecordType__c> scList = [SELECT Id,
                                                 Primary_Category__c,
                                                 Secondary_Category__c,
                                                 Teritiary_Category__c,
                                                 Record_Type_Name__c,
                                                 RecordTypeId__c FROM CaseRecordType__c WHERE Primary_Category__c =:caseObject.Primary_Category__c AND Secondary_Category__c=:caseObject.Secondary_Category__c AND Teritiary_Category__c=:caseObject.Tertiary_Category__c LIMIT 1];
      
       Case cs = [select id from case where id =: caseObject.id];
		//for(CaseRecordType__c crt : scList){
		if(scList.size() > 0)
		{
			cs.RecordTypeId = scList[0].RecordTypeId__c;
		}
            
            cs.Primary_Category__c = caseObject.Primary_Category__c;
            cs.Secondary_Category__c = caseObject.Secondary_Category__c;
            cs.Tertiary_Category__c = caseObject.Tertiary_Category__c; 
            //}
           
       try{ 
           		update cs;                   
           }
           catch (exception e)  
           {           
           		System.debug('An error occured while updating case :' + e);                  
           }
            
            returnvalue = 'Categories Updated successfully.';
            mapresult.put('IsSaved', 'true');
            mapresult.put('Message', returnvalue);            
            return mapresult;    	
    }
}