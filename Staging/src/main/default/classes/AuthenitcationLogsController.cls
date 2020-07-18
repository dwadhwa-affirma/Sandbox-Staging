public class AuthenitcationLogsController
{
	public string accId {get;set;}
	public List<Authenticated_Log__c>	logs {get;set;}
	
  public AuthenitcationLogsController(ApexPages.StandardController controller){
      Account accRec = (Account)Controller.getRecord();
      accId = accRec.Id;
      
     logs = [select Id,CreatedBy.Name,Decision__c,CreatedDate from Authenticated_Log__c where SalesforceID__c =: accId 
     	and decision__C in ('OTP - No Contact Info','OTP – Not Eligible','OTP – Code not provided','OTP – Code Expired','OTP – Code Failed','Not Authenticated')
     	order by CreatedDate desc
     limit 3];
    }
}