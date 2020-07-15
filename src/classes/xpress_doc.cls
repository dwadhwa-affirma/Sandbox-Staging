global class xpress_doc implements Database.batchable<sObject>{

    global database.querylocator start(database.batchablecontext bc){
    
    string query = 'select id, name from xpress_refi__c';
    return database.getQueryLocator(query);
    
    }
    
    global void execute(database.batchableContext bc, List<xpress_refi__c> xlist){
    
    //xlist = 
    
    }
    
    global void finish(database.batchableContext bc){
    
    }

  set<id> xpsToSend = new set<id>();
global xpress_doc(Set<Id> xpsIds){
      xpsToSend = xpsIds;
    }
  

}