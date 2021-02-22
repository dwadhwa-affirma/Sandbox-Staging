public class xPressRefiController{
	//-----------------Getting Stage Details and Member Account Details-----------//
	@AuraEnabled
	public static map<string, object> getStageData(string recordId){
		map<string, object> resultMap = new map<string, object>();

		List<xPressRefi_Stages__c> EFTStages = new List<xPressRefi_Stages__c>();
		EFTStages = [SELECT id, name, isActive__c, Order__c, Stage_Action__c, Stage_Action_Placeholder__c, Stage_Component__c, Stage_Label__c, StepId__c
		             from xPressRefi_Stages__c
		             where isActive__c = true order by Order__c];
		resultMap.put('xPressRefiStages', EFTStages);
        return resultMap;
	}
}