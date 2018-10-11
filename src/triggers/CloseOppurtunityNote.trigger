trigger CloseOppurtunityNote on Note (before insert,before Update , before Delete ) {
	
     Map<id,Opportunity> OppMap = new Map<id,Opportunity> ([select id,StageName from Opportunity where (StageName =: 'Closed Lost' OR StageName =:'Closed Won')]);
     Boolean isCalledfromlead = false;     
     if(trigger.isDelete){
     	if(trigger.old[0].ParentId.getSobjectType() == opportunity.SobjectType){
     		for(Note myNotes : Trigger.old){   
     			If(OppMap.containsKey(myNotes.parentID)){  			
                  		myNotes.addError('Delete note not allowed for closed Opportunity');
     			}
     		}
     		
     	}     	
     }  
     else{                                          
     for(Note myNotes : Trigger.new)
          {
              
              If(OppMap.containsKey(myNotes.parentID)){
                  if(Trigger.isInsert)
                  	  myNotes.addError('Add new note not allowed for closed Opportunity');
                  if(Trigger.isUpdate)
                      myNotes.addError('Notes are read only for closed Opportunity');
                  
              }                                                    
		  }
     }
}