trigger DocusignTrigger on dsfs__DocuSign_Status__c (after insert, after update) {

    List<Id> docList = new List<Id>();
    Map<Id,String> docMap = new Map<Id,String>();
    for(dsfs__DocuSign_Status__c d : Trigger.new){
        docList.add(d.dsfs__Case__c );
        docMap.put(d.dsfs__Case__c,d.dsfs__Envelope_Status__c);
    }
    
  //  List<Case> cs = [Select Id from Case where Id =:docList];
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