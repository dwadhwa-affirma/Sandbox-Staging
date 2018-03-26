global class UpdateCaseTaskCount implements Database.Batchable<AggregateResult> {
   
   
 global Iterable<AggregateResult> start(Database.BatchableContext BC)
    {
    
        String query = 'select WhatId,Count(Id) from Task where What.Type = \'Case\' and Status = \'Open\'   group by WhatId';
       
        return new AggregateResultIterable(query);
        
    }
    


   
    global void execute(Database.BatchableContext BC,list<AggregateResult> scope)
    {
        system.debug('### scope ###' + scope);
        List<Case> listCase = new List<Case>();
        
        
        
        for(AggregateResult ar: scope){
            Case c = new Case();
            c.Id = (Id)ar.get('WhatId');
            
            c.Open_Task_Count__c   = (Decimal)ar.get('expr0');
            
            List<Case> listCaseNotClosed =  [select id,status from Case where Status != 'Closed' and Id =: c.Id];
            
            if(listCaseNotClosed.size() > 0)
            {
            	listCase.add(c);
            }
        }
        
        
        
        
        update listcase;
        
      
    }
 
    global void finish(Database.BatchableContext BC)
    {
     
    }
    
    global class AggregateResultIterator implements Iterator<AggregateResult> {
  AggregateResult [] results {get;set;}
  // tracks which result item is returned
  Integer index {get; set;} 
       
  global AggregateResultIterator(String query) {
    index = 0;
    results = Database.query(query);            

  } 

  global boolean hasNext(){ 
    return results != null && !results.isEmpty() && index < results.size(); 
  }    

  global AggregateResult next(){ 

             system.debug('## -- ##' + results[index] );
    return results[index++];            
  }       
}    
    global class AggregateResultIterable implements Iterable<AggregateResult> {
  private String query;

  global AggregateResultIterable(String soql){
    query = soql;
  }

  global Iterator<AggregateResult> Iterator(){
    return new AggregateResultIterator(query);
  }
}
    
    
 }