trigger SolarLoan on Solar_Loans__c (after insert, before Update, after update) {

   if(Trigger.isUpdate && Trigger.isAfter){
   
     for(Solar_loans__c sl:Trigger.new)
     {
       if(sl.Status__c=='pending'&& sl.Product__c=='Test')
      
       {
       System.debug('this is test');
       }
     
     }
   
   }

}