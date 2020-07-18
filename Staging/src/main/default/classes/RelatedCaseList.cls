public with sharing class RelatedCaseList {

    @AuraEnabled    
    public static List<object> GetRelatedCases(Id caseid)
    {
        Case cas = new Case();
        List<Case> caselist = new List<Case>();
        List<Case> rcaselist = new List<Case>();
        cas = [Select Id , parentId, Parent.Id, Subject, CaseNumber from Case where id =: caseid];
        caselist =[SELECT ID,CaseNumber, Subject, Parent.Id,Parent.CaseNumber from Case where parentid =: caseid ];
        List<CaseListCollection> collection = new List<CaseListCollection>();
        string parentCaseId ='';
        
       
        parentCaseId = cas.Parent.Id;
        system.debug('parentCaseId=='+parentCaseId);
        
        rcaselist = [SELECT ID,CaseNumber, Subject, Parent.Id,Parent.CaseNumber from Case where parentid  =: caseid];
        
         if(rcaselist.size() > 0)
            {
                for(integer i=0 ; i< rcaselist.size(); i++ )
                {
                     CaseListCollection clc = new CaseListCollection();
                        clc.relation = 'child';
                        clc.cases =rcaselist[i];
                    	collection.Add(clc);
                   
                    
                    
                }
            }
        if(parentCaseId != null)
        {
        	
            rcaselist = [SELECT ID,CaseNumber, Subject, Parent.Id,Parent.CaseNumber from Case where id  != : caseid and (parentid  = : Cas.Parent.Id or Id  = : Cas.Parent.Id)];
             //rcaselist = [SELECT ID,CaseNumber, Subject, Parent.Id,Parent.CaseNumber from Case where id  != : caseid and (parentid  = : caseid or id =: cas.Parent.Id) ];
              system.debug('rcaselist=='+rcaselist);
            if(rcaselist.size() > 0)
            {
                for(integer i=0 ; i< rcaselist.size(); i++ )
                {
                    CaseListCollection clc = new CaseListCollection();
                    if(rcaselist[i].id == parentCaseId )
                    {
                       clc.relation = 'Parent'; 
                       clc.cases =rcaselist[i];
                    	collection.Add(clc);
                        
                    } 
                    
                    else if(rcaselist[i].Parentid !=null && rcaselist[i].parentid == parentCaseId )
                    {                    	
                        clc.relation = 'Sibling';
                        clc.cases =rcaselist[i];
                    	collection.Add(clc);
                    }
                    
                    
                }
            }
        }
        
        return collection;
    }
    
    public class CaseListCollection
	{
		@AuraEnabled
		public object cases {get;set;}
		@AuraEnabled
		public string relation {get;set;}
	}
        
}