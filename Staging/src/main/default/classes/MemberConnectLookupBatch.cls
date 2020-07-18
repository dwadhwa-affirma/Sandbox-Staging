global class MemberConnectLookupBatch implements Database.Batchable<SObject>, Database.Stateful{
    global Iterable<SObject> start(Database.BatchableContext BC)
    {
        //Member_Connect_Report__c mc = Member_Connect_Report__c.getValues('Week');
		//integer day = Integer.valueOf(mc.Days__c);
        string query='select id,Member_Connect_Name__c from Count_Member_Connect__c where (Date__c = THIS_WEEK and IS_week__c = true) or (date__c = THIS_MONTH  and is_Month__c=true) or (Date__c = THIS_QUARTER and is_Quarter__c = true)' ;
        system.debug('-q---'+query);            
       
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<Count_Member_Connect__c> scope)
    {
        //Weekly count member connect
        //List<Count_Member_Connect__c> countlst = new List<Count_Member_Connect__c>();
       List<Count_Member_Connect_Lookup__c> CML = new List<Count_Member_Connect_Lookup__c>();
       for(Count_Member_Connect__c cm : scope)
        {
            if(cm.Member_Connect_Name__c != null && cm.Member_Connect_Name__c != ''){	
                for(string memid : cm.Member_Connect_Name__c.split(',')){
                    CML.add(new Count_Member_Connect_Lookup__c(Count_Member_Connect__c = cm.id,Member_Connect__c=memid));
                }
        	}
        }  
        system.debug('---------------------'+CML);
            
        insert CML;
    }  
    global void finish(Database.BatchableContext BC)
    {
    	 try {
				 
    	 }
    	 catch (exception e){} 
        
         
        
    }
}