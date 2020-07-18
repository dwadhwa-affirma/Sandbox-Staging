public class NA_Earn_More_RecommendationController
{
	   public Needs_Assesment__c nao_Page {get;set;}
	public List<NA_Deposit__c> otherDeposits {get {
			system.debug('otherDeposits---');
	    		List<NA_Deposit__c>  list1  = [select Id,Type__C,Financial_Instituition__c,Balance__c,Rate__c 
	    		from NA_Deposit__c where Needs_Assessment__c =: nao_Page.Id];
	    		
	    		
	    		
	    		return list1;
	} set;}
	 
	    
	   
}