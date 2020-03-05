trigger DocusignTrigger on dsfs__DocuSign_Status__c (after insert, after update) {

    List<Id> docList = new List<Id>();
    Set<ID> DocusignIdList = new Set<Id>();
    List<Solar_Loans__c> SolarLoansToUpdate = new List<Solar_Loans__c>();
    List<WIRES_Transaction__c> WiresTransactionToUpdate = new List<WIRES_Transaction__c>();
    
    Map<Id,String> docMap = new Map<Id,String>();
    for(dsfs__DocuSign_Status__c d : Trigger.new){
        docList.add(d.dsfs__Case__c );
        docMap.put(d.dsfs__Case__c,d.dsfs__Envelope_Status__c);
        if(d.dsfs__Envelope_Status__c == 'Completed'){
            DocusignIdList.add(String.ValueOf(d.Id));
        }
    }
    
    //----------------------Update DocuSign Status in "Solar Loan" record ----------------------------------------------------------------//
    
  	List<Solar_Loans__c> slList = [select id, DocuSignId__c from Solar_Loans__c where DocuSignId__c != null];
    List<dsfs__DocuSign_Status__c> dsList = [select id, dsfs__DocuSign_Envelope_ID__c from dsfs__DocuSign_Status__c where id In:DocusignIdList];
    
    for(Solar_Loans__c sl : slList){
        
        for(dsfs__DocuSign_Status__c d : dsList){
            
            if(sl.DocuSignId__c == d.dsfs__DocuSign_Envelope_ID__c){
                Solar_Loans__c s = new Solar_Loans__c();
                s.Id = sl.id;
                s.Status__c = 'Completed';
                SolarLoansToUpdate.add(s);
            }
        }
    }
    if(SolarLoansToUpdate.size() > 0)
    	update SolarLoansToUpdate;
    
    //----------------------Update DocuSign Status in "Solar Loan" record ----------------------------------------------------------------//
    
    
    //----------------------Update DocuSign Status in "WIRES Transaction" record ----------------------------------------------------------------//
    
  	List<WIRES_Transaction__c> wtlList = [select id, DocuSignId__c from WIRES_Transaction__c where DocuSignId__c != null];
    
    for(WIRES_Transaction__c wt : wtlList){
        
        for(dsfs__DocuSign_Status__c d : dsList){
            
            if(wt.DocuSignId__c == d.dsfs__DocuSign_Envelope_ID__c){
                WIRES_Transaction__c w = new WIRES_Transaction__c();
                w.Id = wt.id;
                w.Status__c = 'Completed';
                WiresTransactionToUpdate.add(w);
            }
        }
    }
    
    if(WiresTransactionToUpdate.size() > 0) 
    	update WiresTransactionToUpdate;	
    
    //----------------------Update DocuSign Status in "WIRES Transaction" record ----------------------------------------------------------------//
    
    
    List<Case> cs = [Select Id, Previous_Owner__c from Case where Id IN:docMap.keySet()];
    
    for(Case c : cs){
        //c.Docusign_Envelope_Status__c = Trigger.new[0].dsfs__Envelope_Status__c;
        if(docMap.get(c.Id) == 'Completed'){
       // c.Docusign_Envelope_Status__c = docMap.get(c.Id);
           if(c.Previous_Owner__c == null||c.Previous_Owner__c == ''){
           } else {
                c.OwnerId = Id.valueOf(c.Previous_Owner__c);
           }
           c.Docusign_Envelope_Status__c = 'Completed';
        }
        if(docMap.get(c.Id) == 'Sent'){
           c.Docusign_Envelope_Status__c = 'Sent';
        }
        if(docMap.get(c.Id) == 'Voided'){
           c.Docusign_Envelope_Status__c = 'Voided';
        }
        if(docMap.get(c.Id) == 'Declined'){
           c.Docusign_Envelope_Status__c = 'Declined';
           if(c.Previous_Owner__c == null||c.Previous_Owner__c == ''){
           } else {
                c.OwnerId = Id.valueOf(c.Previous_Owner__c);
           }
        }
        if(docMap.get(c.Id) == 'Authentication Failed'){
           c.Docusign_Envelope_Status__c = 'Authentication Failed';
           if(c.Previous_Owner__c == null||c.Previous_Owner__c == ''){
           } else {
                c.OwnerId = Id.valueOf(c.Previous_Owner__c);
           }
        }
    } 
    update cs;    
}