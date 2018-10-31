Public class DocuSignCaseCloseAction{
    
    @InvocableMethod
    public static void CheckCondition(List<Id> CaseId)
    {
        system.debug('----------CaseId-----------'+CaseId);
        //Case lstcs = [Select Id,Origin,Previous_Owner__c from case where id in: caseId];
        List<AggregateResult> lstAR = [select count(id) pendingDocCount, case__c csid from OnBase_Document__c where 
                                       (document_type__c = '' and (case__c IN: CaseId or Member_Comment__r.Case__C IN: CaseId ) )   group by case__c];
        
        
        List<case> UpdateCase = new List<case>();
        User ur = [select id from user where name='MARS System' limit 1];
        for(case cs :  [Select Id,Origin,Previous_Owner__c,Future_Date__c,CreatedById,Secondary_Category__c from case where id in: caseId]){
              
            boolean check = false; 
            case c = new case();
            for(AggregateResult AR : lstAR){
                
                if(cs.id == AR.get('csid') ){
                   
                    if((Integer)AR.get('pendingDocCount') > 0 || cs.Future_Date__c != null || cs.Secondary_Category__c != 'Onboarding'){
                        
                        c.status = 'DocuSign Voided';
                        c.OwnerId = cs.Previous_Owner__c;
                        c.id=cs.id;
                        check  = true ; 
                    }
                }
            }
           
            if(!check){
                 
                if(cs.Origin == 'Portal'){
                    c.id=cs.id;
                    c.OwnerId  = ur.id; 
                }
                else {
                    c.id=cs.id;
                    c.OwnerId = cs.CreatedById;
                }
                c.status = 'Closed';
                c.id=cs.id;
            }
            if(c.id != null){
                UpdateCase.add(c);
            }
           
            
        }
         update UpdateCase;
        
    }
}