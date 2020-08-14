public class ChangeLimitController {

    //------------------------------- Getting Stage Details and Member Account Details-----------------------------------------------//
    @AuraEnabled
    public static map<string,object> getStageData(string recordId, string sObjectType){
        map<string,object> resultMap = new map<string,object>();
        
        List<ChangeLimit_Stages__c> CLStages = new List<ChangeLimit_Stages__c>();
        CLStages = [SELECT id, name, isActive__c, Order__c, Stage_Action__c,Stage_Action_Placeholder__c, Stage_Component__c, Stage_Label__c, StepId__c from ChangeLimit_Stages__c where isActive__c = true]; //where isActive__c = true;      //EFT_Stages__c.getall().values();
        resultMap.put('CLStages', CLStages);
        system.debug('sObjectType=='+sObjectType);
       
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
       
        return resultMap;
    }
    
    @AuraEnabled
    public static map<string,object> getMembers(string recordId){
    	
        list<Person_Account__c> paList = PersonNameLightningController.getData(recordId);
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
}