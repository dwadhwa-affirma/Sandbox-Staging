public class CannedResponseController
{
	@AuraEnabled
	public static ResponseData GetCannedResponse(string recordId)
	{
		Canned_Responses__c objRes = new Canned_Responses__c();
		if(recordId != null && recordId != '')
		{
			objRes = [select Id, Primary_Lookup_Text__c, Secondary_Lookup_Text__c,Canned_Response_Title__c, Tertiary_Lookup_Text__c, Brand__c, Description__c, Active__c from Canned_Responses__c where Id =: recordId limit 1];
		}
		else
		{
			objRes.Primary_Lookup_Text__c = '';
			objRes.Secondary_Lookup_Text__c = '';
			objRes.Tertiary_Lookup_Text__c = '';
			objRes.Canned_Response_Title__c = '';
			objRes.Brand__c = '';
			objRes.Active__c = false;
		}
		
		List<Canned_Responses__c> crs = [Select Primary_Lookup_Text__c  from Canned_Responses__c  limit 5000];
	    List<Canned_Responses__c> crs1 = [Select  Secondary_Lookup_Text__c from Canned_Responses__c  limit 5000];
        List<Canned_Responses__c> crs2 = [Select  Tertiary_Lookup_Text__c from Canned_Responses__c limit 5000];
        ResponseData data = new ResponseData();
        data.response = objRes;
        data.primaryData = crs;
        data.secondaryData = crs1;
        data.TirtiaryData = crs2;        
        return data;    
	}
	
	@AuraEnabled
	public static void saveCannedResponse(Canned_Responses__c Model)
	{
		if(Model != null)
		{
			upsert Model;
		}
	}
	
	public class ResponseData
	{
		@AuraEnabled
		public Canned_Responses__c response {get; set;}  
		@AuraEnabled
		public List<Canned_Responses__c> primaryData {get; set;}
		@AuraEnabled
		public List<Canned_Responses__c> secondaryData {get; set;}
		@AuraEnabled
		public List<Canned_Responses__c> TirtiaryData {get; set;}
		
	}
}