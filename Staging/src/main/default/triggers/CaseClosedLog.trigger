trigger CaseClosedLog on Case (before insert, before update,after update, after insert) {
    
 
   
    if(Trigger.IsBefore)
    {
    
        List<Ownership_Log__c> OwnershipLst = new List<Ownership_Log__c>();     
                
                boolean isUpdateCase = false;
        
            for(Case c : Trigger.New){
                
                
                if(Trigger.IsUpdate)
                {
                           
                    Case oldc = Trigger.oldMap.get( c.id );
                    
                    
                    
                    Case caseOwner  =  [select Owner.Name from  Case where Id =: c.id limit 1];
                    if(c.Ownership_Sequence__c != null)
                    {
                    
		                    if(oldc.Status == 'Closed' && oldc.Status != c.status ){
		                        List<Ownership_Log__c> listOwnershiplogs  =  [select Id,Sequence__c,End__c,Owner__c from  Ownership_Log__c 
		                                where Sequence__c =: c.Ownership_Sequence__c  and Case__c =: c.id limit 1];
		                        
		                        if(listOwnershiplogs.size() > 0 && caseOwner.Owner.Name !=  listOwnershiplogs[0].Owner__c)
		                        {
			                            Ownership_Log__c ownership = new Ownership_Log__c();
			                         ownership.Case__c = c.id;
			                         ownership.Owner__c = caseOwner.Owner.Name;
			                         
			                         ownership.Sequence__c = c.Ownership_Sequence__c + 1;       
			                         ownership.Start__c = system.now();
			                         ownership.Type__c  = 'Owner Change';
			                         OwnershipLst.add(ownership);
			                        
			                            insert ownership;
			                        
			                         
			                         c.Ownership_Sequence__c = c.Ownership_Sequence__c + 1;
		                         
		                        }
                   	 }
                        
                    }
                    
                    if( oldc.OwnerId != c.OwnerId && c.status <> 'Closed')
                    {
                        
                        List<Ownership_Log__c> listOwnershiplogs  =  [select Id,Sequence__c,End__c from  Ownership_Log__c where Sequence__c =: c.Ownership_Sequence__c  and Case__c =: c.id limit 1];
                           if(listOwnershiplogs.size() > 0)
                           {
	                            if(listOwnershiplogs[0].End__c == null)
	                            {
	                                 listOwnershiplogs[0].End__c = system.now();
	                                 system.debug('listOwnershiplogs---' + listOwnershiplogs[0]);
	                                  update listOwnershiplogs[0];
	                            }  
                           }              
                        if(c.Ownership_Sequence__c != null)
                        {
	                         Ownership_Log__c ownership = new Ownership_Log__c();
	                         ownership.Case__c = c.id;
	                         ownership.Owner__c = caseOwner.Owner.Name;
	                         
	                         ownership.Sequence__c = c.Ownership_Sequence__c + 1;       
	                         ownership.Start__c = system.now();
	                         ownership.Type__c  = 'Owner Change';
	                         OwnershipLst.add(ownership);
	                         
	                         insert ownership;
	                         
	                         
	                        
	                       
	                     
	                         c.Ownership_Sequence__c = c.Ownership_Sequence__c + 1;
	                     
                        }
                        
                         
                         
                         
                    
                    }
                    
                    if(c.Status == 'Closed')
                    {
                        
                         
                         if(OwnershipLst.size() > 1)
                         {
                            OwnershipLst[0].End__c = system.now();
                             update OwnershipLst[0];
                         }
                         else
                         {
                            
                            
                                    List<Ownership_Log__c> listOwnershiplogs  =  [select Id,Sequence__c,End__c from  Ownership_Log__c where Sequence__c =: c.Ownership_Sequence__c and Case__c =: c.id limit 1];
                                    
                                 if(listOwnershiplogs.size() > 0 && listOwnershiplogs[0].End__c == null){
                                    listOwnershiplogs[0].End__c = system.now();
                                     update listOwnershiplogs[0];
                                }
                            
                         }
                         isUpdateCase = true;
                         
                          
                    } 
                }
                if(Trigger.IsInsert)
                {
                    //system.debug('before case owner---1');
                     c.Ownership_Sequence__c =1;
                    
                   
                }
                
                
            
            
            }
        
    }
    
    
    
        
    if(Trigger.IsAfter)
    {
        for(Case c : Trigger.New){
            if(Trigger.IsInsert)
            {
                 Case caseOwner  =  [select Owner.Name from  Case where Id =: c.id limit 1];
                //system.debug('after case owner---' + caseOwner);
                system.debug('before case owner---' + caseOwner);
                
                 Ownership_Log__c ownership = new Ownership_Log__c();
                 ownership.Case__c = c.id;
                 ownership.Owner__c = caseOwner.Owner.Name;
                 ownership.Sequence__c = 1;     
                 ownership.Start__c =  system.now();
                 ownership.Type__c  = 'Owner Change';
                 
                 
                if(c.Status == 'Closed')
                {
                    ownership.End__c = system.now();
                }
                
                insert ownership;  
            }
            else
            {
        
                Case caseOwner  =  [select Owner.Name from  Case where Id =: c.id limit 1];
                if(c.Status != 'Closed')
                {
                    List<Ownership_Log__c> listOwnershiplogs  =  [select Id,Sequence__c,End__c,Owner__C from  Ownership_Log__c where Sequence__c =: c.Ownership_Sequence__c  and Case__c =: c.id limit 1];
                    IF(listOwnershiplogs.SIZE() > 0)
                    {
                    listOwnershiplogs[0].Owner__C = caseOwner.Owner.Name;
                    Update listOwnershiplogs;
                    }
                    
                }
            }
        }
    }  
         
     
}