trigger AccountTrigger on Account (before update) {
 
    List<Account_Details__c> accDetails = [Select Id from Account_Details__c where RESTRICTED_ACCESS__c > 0 AND RecType__c = 'ACCT'];
    Set<Id> newaccDetails = new Set<Id>();
    for(Account_Details__c ad : accDetails){
        newaccDetails.add(ad.Id);
    }
    System.debug('Account details:::'+accDetails);
   
   List<Person_Account__c> pa = [Select Id, PersonID__c, Account_Number__r.RESTRICTED_ACCESS__c from Person_Account__c where Account_Number__c =:newaccDetails AND Name_Type__c = 0];
   Set<Id> junAcc = new Set<Id>();
    for(Person_Account__c p : pa){
        junAcc.add(p.PersonID__c);
    }
    System.debug('Person Accounts:::'+pa);
    
    List<Account> accList = [Select Id,Employee_Restricted_Access__c from Account where Id =:junAcc];
    System.debug('Accounts:::'+accList);
    
    for(Account a : Trigger.new){  
        for(Person_Account__c p1 : pa){
            if(a.Id == p1.PersonID__c){
                a.Employee_Restricted_Access__c = p1.Account_Number__r.RESTRICTED_ACCESS__c;
            }
        }        
    }
 }