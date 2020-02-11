trigger XpressRefiTrigger on Xpress_Refi__c (before insert, after insert,before update, after update) {

   if(Trigger.isUpdate && Trigger.isAfter){
   
     for(Xpress_Refi__c xp:Trigger.new)
     {
       if(xp.Status__c=='ready'&& xp.Loan_Number__c=='200')
      
       {
       System.debug('this is test');
       }
     
     }
   
   }

}