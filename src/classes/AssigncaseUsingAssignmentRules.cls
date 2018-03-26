public class AssigncaseUsingAssignmentRules {    
  
    public static void CaseAssign(list < case > newValues)   { 
         Set < Id > CaseIds = new Set < Id > ();        
         for (case cse: newValues) {
            CaseIds.add(cse.id); 
            Database.DMLOptions dmo = new Database.DMLOptions();            
            dmo.assignmentRuleHeader.useDefaultRule= true;                     
            case cs=[select id from case where case.id in : CaseIds];            
            cs.setOptions(dmo); 
            cs.test__c= 'tst1';            
            update cs;    
         }
    }
}