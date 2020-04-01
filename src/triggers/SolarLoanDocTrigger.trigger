trigger SolarLoanDocTrigger on SolarLoan_Document__c (before insert, before update, after insert, after update) {
	List<Solar_Loans__c> sllist = new List<Solar_Loans__c>();
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
   
       
   AggregateResult[] groupedResults = [SELECT COUNT(Id), Solar_Loans__c FROM SolarLoan_Document__c where NewFile__c = true and Solar_Loans__c IN :custord GROUP BY Solar_Loans__c ];
   
   for(AggregateResult ar:groupedResults) {
     
     Id custid = (ID)ar.get('Solar_Loans__c');
     
     Integer count = (INTEGER)ar.get('expr0');
     
     Solar_Loans__c sl = new Solar_Loans__c(Id=custid);
     
     sl.NewDoc__c = true;
     system.debug('ttt'+count);
     sllist.add(sl);
   }
   
   update sllist;

}