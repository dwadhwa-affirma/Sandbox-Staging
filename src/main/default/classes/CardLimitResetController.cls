public class CardLimitResetController {

    //------------------------------- Getting Stage Details and Member Account Details-----------------------------------------------//
    @AuraEnabled
    public static map<string,object> getStageData(string recordId, string sObjectType){
        map<string,object> resultMap = new map<string,object>();
        List<ChangeLimit_Stages__c> CLStages = new List<ChangeLimit_Stages__c>();
        Id uniqueId = recordId;
        Schema.SObjectType objType = uniqueId.getsobjecttype();
       
        if(objType == Account_Details__c.sObjectType){
            
            CLStages = [SELECT id, name, isActive__c, Order__c, Stage_Action__c,Stage_Action_Placeholder__c, Stage_Component__c, Stage_Label__c, StepId__c from ChangeLimit_Stages__c where isActive__c = true]; //where isActive__c = true;      //EFT_Stages__c.getall().values();
            resultMap.put('CLStages', CLStages);

            List<Change_Limit__c> CLRecord = [Select id, name, Member_Account__c, Member__c from Change_Limit__c where Member_Account__c =:recordId limit 1];
            integer activeStageIndex = 0;
            if(CLRecord.size() >0){               
                for(ChangeLimit_Stages__c clstage:CLStages){ 
                    if(CLRecord[0].Stage__c == clstage.Stage_Label__c){
                    	activeStageIndex = (integer)clstage.Order__c;
                	}
                }
                              
                resultMap.put('CLRecord', CLRecord);
                
            }
            Account_Details__c MemberAccount = [select id,name from Account_Details__c where id=:recordId limit 1];
            resultMap.put('MemberAccount', MemberAccount);
        }

        if(objType == Account.sObjectType){
            
            CLStages = [SELECT id, name, isActive__c, Order__c, Stage_Action__c,Stage_Action_Placeholder__c, Stage_Component__c, Stage_Label__c, StepId__c from ChangeLimit_Stages__c where StepId__c != 'Step1' and isActive__c = true];
            resultMap.put('CLStages', CLStages);

            List<Change_Limit__c> CLRecord = [Select id, name, Member_Account__c, Member__c from Change_Limit__c where Member_Account__c =:recordId limit 1];
            integer activeStageIndex = 0;
            if(CLRecord.size() >0){               
                for(ChangeLimit_Stages__c clstage:CLStages){
                    if(CLRecord[0].Stage__c == clstage.Stage_Label__c){
                    	activeStageIndex = (integer)clstage.Order__c;
                	}
                }
                              
                resultMap.put('CLRecord', CLRecord);
                
            }
            Account Member = [select id,name from Account where id=:recordId limit 1];
            resultMap.put('Member', Member);
        }
        return resultMap;
    }
    
    @AuraEnabled
    public static map<string,object> getMembers(string recordId){
    	
        list<Person_Account__c> paList = getData(recordId);
    	system.debug('result=='+paList);
    	map<string,object> resultmap=new map<string,object>();
    	
    	list<Person_Account__c> result = new List<Person_Account__c>();
    	
    	set<string> typeList = new set<string>();
        for(Member360_TypeTranslate__c t : Member360_TypeTranslate__c.getAll().values()){
        	typeList.add(t.name);	
        } 
        
        for(Person_Account__c var: paList){           			
		         	if(typeList.contains(var.TypeTranslate__c)){
        				result.add(var);
        			}    
        			
            }
        resultmap.put('PersonList', result);
      
    	return resultmap;
    }

    @AuraEnabled
    public static list<Person_Account__c> getData(string accoutid){
    
    	list<Person_Account__c> paList = new list<Person_Account__c>();
    	Account_Details__c accDetails = [Select Parent_Account__c,RecType__c,RecordType.Name from Account_Details__c where Id=:accoutid Limit 1];
    	List<string> listStringIds = new List<string>();
    	listStringIds.add(accoutid);
    	if(accDetails.Parent_Account__c != null)
    	{
    		listStringIds.add(accDetails.Parent_Account__c);
    		List<Account_Details__c> accDetailsList = [Select Parent_Account__c,RecType__c,RecordType.Name from Account_Details__c where Parent_Account__c=:accDetails.Parent_Account__c];
    		for(Account_Details__c item: accDetailsList )
    		{
    			
    			listStringIds.add(item.id);
    		}
    	}
    	else
	    {
	    	List<Account_Details__c> accDetailsList = [Select Parent_Account__c,RecType__c,RecordType.Name from Account_Details__c where Parent_Account__c=:accDetails.Id];
    		for(Account_Details__c item: accDetailsList )
    		{
    			
    			listStringIds.add(item.id);
    		}
	    }
    	paList = [SELECT Id,
                          Account_Number__c,
                          PersonId__c,
                          PersonID__r.Name,
                          TypeTranslate__c FROM Person_Account__c WHERE Account_Number__c in: listStringIds];
    	
    	
    	AggregateResult[] groupedResults
		  = [SELECT 
                          PersonId__c,
                          PersonID__r.Name acctName,
                          TypeTranslate__c FROM Person_Account__c WHERE Account_Number__c in: listStringIds group by PersonId__c,PersonID__r.Name,TypeTranslate__c ];
    	list<Person_Account__c> paList1 = new list<Person_Account__c>();
    	for (AggregateResult ar : groupedResults)  {
    		Person_Account__c item = new Person_Account__c();
    		item.PersonId__c = (string)ar.get('PersonId__c');
    		item.PersonID__r = new Account();
    		item.PersonID__r.Name = (string)ar.get('acctName');
    		item.TypeTranslate__c = (string)ar.get('TypeTranslate__c');
    		paList1.add(item);
        }
        
    	return paList1;
    }
    
    @AuraEnabled
    public static List<Account_Details__c> getCard(string recordId, string sObjectType){
    
        system.debug('sObjectType'+sObjectType); 
        system.debug('recordId'+recordId);
        String Type;
        //String SSN;
        
        //Account acc = [select id,name,SSN_TIN_Encrypted__pc from Account where id=:sObjectType limit 1];
        //SSN = acc.SSN_TIN_Encrypted__pc;
        
        List<Account_Details__c> cardList = new List<Account_Details__c>();

        Account_Details__c MemberAccount = [select id,name from Account_Details__c where id=:recordId limit 1];

        List<Person_Account__c> paList = [select id ,PersonId__c,Name_Type__c , PersonID__r.Name, TypeTranslate__c FROM Person_Account__c where
                                            Account_Number__r.name =: MemberAccount.name];
        for(Person_Account__c pa : paList){
            
            if(pa.PersonID__r.Name == sObjectType){
                Type = String.ValueOf(pa.Name_Type__c) ;
            }
        }                                    

        if(Type == '0'){
            cardList = [select id, Name, RecType__c, Card_Number__c, TypeTranslate__c, Card_Name__c, Card_Number_Last_4_Digits__c
                                           from Account_Details__c where RecType__c = 'CARD' and name =: MemberAccount.name ];
        }
        if(Type == '1'){
            cardList = [select id, Name, RecType__c, Card_Number__c, TypeTranslate__c, Card_Name__c, Card_Number_Last_4_Digits__c
                                           from Account_Details__c where RecType__c = 'CARD' and Card_Name__c =: sObjectType];
        }                                   

		return cardList;
    }
}