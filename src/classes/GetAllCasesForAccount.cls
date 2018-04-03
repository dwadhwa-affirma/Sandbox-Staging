public class GetAllCasesForAccount {

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
                CaseDetail = [Select Id,AccountID from Case where Id =: CaseId limit 1];
                system.debug('CaseDetail.AccountId====' + CaseDetail.AccountId);
                CaseList = [Select Id, AccountId,Account_Number__c,Brand__c,CaseNumber,Case_type__c, Status, Subject, Description from Case where Accountid =: CaseDetail.AccountId and id !=: CaseId];
                
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
   
}