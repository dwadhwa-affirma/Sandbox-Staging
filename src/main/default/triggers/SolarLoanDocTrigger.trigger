trigger SolarLoanDocTrigger on SolarLoan_Document__c (before insert, before update, after insert, after update ,after delete) {
  List<Solar_Loans__c> sllist = new List<Solar_Loans__c>();
  List<Solar_Loans__c> slcountUpdate = new List<Solar_Loans__c>();
   	Set<Id> custord = new Set<Id>();
   	if(Trigger.isDelete) {
        for(SolarLoan_Document__c sld:Trigger.Old) {
            custord.add(sld.Solar_Loans__c);   
         }   
    }
   else if(Trigger.isUpdate) {
		for(SolarLoan_Document__c sld:Trigger.New){
     	   custord.add(sld.Solar_Loans__c);   
        }
		
       	for(SolarLoan_Document__c sld:Trigger.Old) {
      		custord.add(sld.Solar_Loans__c);   
    	}   
	}
   	else{
     	for(SolarLoan_Document__c sld:Trigger.New) {
      		custord.add(sld.Solar_Loans__c);   
        }
   	}
   
    if(Trigger.isDelete) {
       
      for(Solar_Loans__c sl : [SELECT id,NewDoc__c ,(SELECT Id FROM SolarLoan_Documents__r) FROM Solar_Loans__c where id in:custord]){
        Solar_Loans__c s = new Solar_Loans__c(Id=sl.id);
        s.count__c = String.valueof(sl.SolarLoan_Documents__r.size());
        slcountUpdate.add(s);
      } 

      if(slcountUpdate.size() > 0)	
        update slcountUpdate;
    }  
    
  	AggregateResult[] groupedResults = [SELECT COUNT(Id), Solar_Loans__c FROM SolarLoan_Document__c where NewFile__c = true and Solar_Loans__c IN :custord GROUP BY Solar_Loans__c ];
    
    AggregateResult[] groupedResults1 = [SELECT COUNT(Id), Solar_Loans__c FROM SolarLoan_Document__c where Document_Name__c LIKE '%Member Application_Completed%' and Solar_Loans__c IN :custord GROUP BY Solar_Loans__c ];
   
    if(groupedResults.size() == 0){
        
        For(Solar_Loans__c s : [SELECT id,NewDoc__c FROM Solar_Loans__c where id in:custord]){    
            
        Solar_Loans__c sl = new Solar_Loans__c(Id=s.id);
        sl.NewDoc__c = false;
     		sllist.add(sl);
        }
    }
	for(AggregateResult ar:groupedResults) {
    	Id custid = (ID)ar.get('Solar_Loans__c');
     	Integer count = (INTEGER)ar.get('expr0');
     	system.debug('ttt'+count);
     
     	Solar_Loans__c sl = new Solar_Loans__c(Id=custid);
     	sl.NewDoc__c = true;
     
     	if(groupedResults1.size() > 0)
     		sl.Signed__c = true;
     	sllist.add(sl);
   	}
   
	if(sllist.size() > 0){
        update sllist;     
    } 
   

}