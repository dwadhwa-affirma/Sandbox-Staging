trigger CloseOppurtunityNote on Note (before insert,before Update , before Delete ) {

Set<Id> noteid = new Set<Id>();
Map<id,Opportunity> OppMap = new Map<id,Opportunity>();
if(trigger.isDelete){
	
	for(Note n : Trigger.old)
	{
		if(n.ParentId.getSobjectType() == opportunity.SobjectType)
		{
			noteid.add(n.ParentId);
		}
		
	}
	
	OppMap = new Map<id,Opportunity> ([select id,StageName from Opportunity where (StageName = 'Closed Lost' OR StageName ='Closed Won') and Id IN :noteid ]);
		
	for(Note myNotes : Trigger.old){   
 		If(OppMap.containsKey(myNotes.parentID))
 		{  			
        	myNotes.addError('Delete note not allowed for closed Opportunity');
 		}
 	}
 	
}
else{                                          
	
	for(Note n : Trigger.new)
	{
		if(n.ParentId.getSobjectType() == opportunity.SobjectType)
		{
			noteid.add(n.ParentId);
		}
		
	}
	OppMap = new Map<id,Opportunity> ([select id,StageName from Opportunity where (StageName = 'Closed Lost' OR StageName ='Closed Won') and Id IN :noteid ]);
	
	for(Note myNotes : Trigger.new)
	{
   		If(OppMap.containsKey(myNotes.parentID)){
	
			if(Trigger.isInsert){
				myNotes.addError('Add new note not allowed for closed Opportunity');
	      	}
	      	if(Trigger.isUpdate)
	          	myNotes.addError('Notes are read only for closed Opportunity');
	   	   
	  	}                                                    
  	}
 }


	
  /*   Map<id,Opportunity> OppMap = new Map<id,Opportunity> ([select id,StageName from Opportunity where (StageName =: 'Closed Lost' OR StageName =:'Closed Won')]);
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
     }*/
}