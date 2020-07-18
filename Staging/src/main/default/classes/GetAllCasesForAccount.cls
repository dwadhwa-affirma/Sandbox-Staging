public with sharing class GetAllCasesForAccount {
	
	  public  String CaseId {get; set;} 
   public  case CaseDetail {get; set;}
   public  string CloseWindow {get; set;}
   public  list<Case> CaseList {get; set;}  
   public  string SelectedIds {get; set;}
      public  List<string> ListSelectedIds {get; set;}  
  public String Caseids {get; set;} 
  
  public GetAllCasesForAccount()
        {
      
      
        CaseId = System.currentPageReference().getParameters().get('recId');
        system.debug('CaseId===' + CaseId);
        CaseDetail = new Case();
        CaseDetail = [Select Id,AccountID,Parentid from Case where Id =: CaseId limit 1];
        system.debug('CaseDetail.AccountId====' + CaseDetail.AccountId);
        CaseList = [Select Id, AccountId,Account_Number__c,Brand__c,CaseNumber,Case_type__c, Status, Subject, Description 
            from Case where Accountid =: CaseDetail.AccountId and id !=: CaseId and Id !=: CaseDetail.ParentId];
        
      list<Case>  ListCaseSelected = [select id from Case where ParentId =: CaseId];
        
        SelectedIds = '';
        ListSelectedIds = new List<string>();
        for(Case c : ListCaseSelected )
        {
          if(SelectedIds == '')
          {
          SelectedIds = c.id;  
            
          }
          else
          {
            SelectedIds = SelectedIds + ',' + c.id;
            
          }
          ListSelectedIds.add(c.id);
          
          
        }
        
        CloseWindow = 'false';
        system.debug('CaseList=====' + CaseList);
        
      }
      
       public void ButtonSave_Click()
      {
        List<string> cids = new List <string>();
        system.debug('Caseids=======' + Caseids); 
        for(string key: Caseids.split(','))
        {
          cids.add(key);
        }
        List<Case> cdataToNull = [SELECT ID, ParentId from case where id In: ListSelectedIds];
        for(Case cas:cdataToNull)
        {
          cas.parentid = null;
          
        }
        update cdataToNull;
        List<Case> cdata = [SELECT ID, ParentId from case where Id IN :cids];
        
        for(Case cas:cdata)
        {
          cas.ParentId = CaseId;
        }
        update cdata;
        CloseWindow = 'true';
      }
    
    @AuraEnabled    
    public static List<CaseListSelection> GetAllCases(Id caseid)
    {
    		
				 
        


    			Case CaseDetail1 = new Case();
    			List<CaseListSelection> cls = new List<CaseListSelection>();
    			
				CaseDetail1 = [Select Id,AccountID,Parentid from Case where Id =: caseid limit 1];
				
				List<string> accountNumberSet = new List<string>();
				list<Person_Account__c> paList = [SELECT Id,
                             Account_Number__c, Account_Number__r.RecType__c,TypeTranslate__c, Account_Number__r.Name FROM Person_Account__c WHERE PersonID__c =:CaseDetail1.AccountId];
				 for(Person_Account__c var: paList){
            			accountNumberSet.add(var.Account_Number__r.Name);
				 }
				
				
				List<Account_Details__c> listAccountDetails = [SELECT Id from Account_Details__c where Name =: accountNumberSet and RecType__c != 'CARD'];
				
				
				List<Person_Account__c> listPersonAccount = [Select PersonID__c from Person_Account__c where Account_Number__r.Name In:  accountNumberSet];
				List<string> listAccountIds = new List<string>(); 
				for(Person_Account__c pcAccount : listPersonAccount)
				{
					listAccountIds.add(pcAccount.PersonID__c);
				}
				
				List<Case> CaseList1 = [Select Id, AccountId,Account_Number__c,Brand__c,CaseNumber,Case_type__c, Status, Subject, Description 
						from Case where Accountid In: listAccountIds and id !=: caseid and Id !=: CaseDetail1.ParentId];
				
				list<Case> ListCaseSelected1 = new list<Case>();
				system.debug('CaseDetail.ParentId###'+CaseDetail1.ParentId);
				
					ListCaseSelected1 = [select id, ParentId from Case where ParentId =: caseid /*or ParentId  =: CaseDetail1.ParentId*/];
				

				string SelectedIds = '';
		        List<string> ListSelectedIds1 = new List<string>();
		        system.debug('CaseList=======' + CaseList1); 
		          system.debug('ListCaseSelected=======' + ListCaseSelected1); 
		        for(Case ca : CaseList1 )
		        {
		        	CaseListSelection objcls = new CaseListSelection();
		          objcls.cases = ca;
		          boolean selected = false;
		        for(Case c : ListCaseSelected1 )
		        {
		         
		          if(ca.id  == c.id && c.Parentid != null)
		          {		          	
		            selected = true;
		          }	          
		          
		          
		         
		         
		        }
		        if(selected)
		        {
		        	objcls.isSelected = true;
		        }
		        else
		        {
		        	objcls.isSelected = false;
		        }
		         cls.add(objcls);
		        }
				 
				return cls;
    }
       @AuraEnabled 
    public static void ButtonSave_Click1(Id caseid, List<String> Caseids)
    {
    	//system.debug('Dhwani caseid=======' + caseid); 
    	//system.debug('Dhwani Caseids=======' + Caseids); 
    			list<Case>	ListCaseSelected = [select id from Case where id =: caseid];
				
				string SelectedIds = '';
				List<string> ListSelectedIds = new List<string>();
				for(Case c : ListCaseSelected )
				{
					if(SelectedIds == '')
					{
					SelectedIds = c.id;	
						
					}
					else
					{
						SelectedIds = SelectedIds + ',' + c.id;
						
					}
					
					ListSelectedIds.add(c.id);
					
    			Set<ID> cids = new Set<ID>();
    			Set<ID> crids = new Set<ID>();
				system.debug('Caseids=======' + Caseids); 
				for(string key: Caseids)
				{
					cids.add(key);
				}
				
				
				
				List<Case> cdataToNull = [SELECT ID, ParentId from case where parentId =: CaseId];
				
				for(Case cas:cdataToNull)
				{
					cas.parentid = null;
					
				}
				update cdataToNull;
				List<Case> cdata = [SELECT ID, ParentId from case where Id IN :cids];
				
				for(Case cas:cdata)
				{
					cas.ParentId = CaseId;
				}
				update cdata;
    	
    }
    }
    
public class CaseListSelection
	{
		@AuraEnabled
		public object cases {get;set;}
		@AuraEnabled
		public boolean isSelected {get;set;}
	}
           
    
}