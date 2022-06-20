trigger EDSMemberAlerts on EDS_Member_Alerts__c (after insert) {
    
    list<string> listString = new list<string>();  
    List<string> accDetailName = new List<string>();
   
    List<EDS_Member_Alerts__c> EDSRecords = new List<EDS_Member_Alerts__c>();
    List<Account_Details__c> accDetailMap = new List<Account_Details__c>();
    
    List<EDS_Member_Alert_Log__c> listToInsertLogs = new List<EDS_Member_Alert_Log__c>();
    List<Person_Account__c> palist = new List<Person_Account__c>();
    
    List<Id> AccList = new List<Id>();
    Set<String> AccNum = new Set<String>();
    
    Map<string,string> accountMemberBranch = new Map<string,string>();
    String emailRegex = '([a-zA-Z0-9_\\-\\.]+)@((\\[a-z]{1,3}\\.[a-z]{1,3}\\.[a-z]{1,3}\\.)|(([a-zA-Z0-9\\-]+\\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})';
    Pattern MyPattern = Pattern.compile(emailRegex);    
    Map<String,String> fnameFromEmail = new Map<String,String>();
    Map<String,String> lnameFromEmail = new Map<String,String>();
    string Firstname, Lastname;
    string WXRefNumber;
    Set<String> setTypeTranslate = new Set<String>();
    Map<String,String> accountEmail = new Map<String,String>();
    
    for(EDS_Member_Alerts__c objEDS: trigger.New){
        
        accDetailName.add(objEDS.Account_Number__c);          
        EDSRecords.add(objEDS); 
    }
    
    if(accDetailName.size() > 0){
        
        System.debug('Set: '+accDetailName);
        accDetailMap = [select id,Brand__c, Name from Account_Details__c where Name In :accDetailName];
        
        paList = [select id,TypeTranslate__c,Account_Number__r.name,PersonId__r.Firstname,PersonId__r.Lastname,PersonId__c,PersonId__r.Email_raw__c, PersonId__r.PersonEmail, Account_Number__r.TypeTranslate__c from Person_Account__c where Account_Number__r.name in: accDetailName and TypeTranslate__c IN ('0000/Primary','0006/Trustee') and Account_Number__r.TypeTranslate__c IN ('1-PERSONAL','2-TRUST','5-FOREIGN')];
        
		for(Person_Account__c p2: paList){            
            setTypeTranslate.add(p2.Account_Number__r.TypeTranslate__c);
        }        


        //Get Trustees Email Addresses
        if(setTypeTranslate.contains('2-TRUST')){
            string Email =''; 
            for(Person_Account__c p2: paList){ 
                if(p2.TypeTranslate__c == '0006/Trustee'){
                    if(accountEmail.containsKey(p2.Account_Number__r.name)){   
                        string EmailString = accountEmail.get(p2.Account_Number__r.name);
                        if(!EmailString.contains(p2.PersonId__r.PersonEmail)){
                            Email = accountEmail.get(p2.Account_Number__r.name) + ',' +  p2.PersonId__r.PersonEmail;                    
                            accountEmail.put(p2.Account_Number__r.name, Email);
                        }           
                        
                    }
                    else{
                        accountEmail.put(p2.Account_Number__r.name, p2.PersonId__r.PersonEmail);
                    }
                    fnameFromEmail.put(p2.PersonId__r.PersonEmail,p2.PersonId__r.Firstname);
                    lnameFromEmail.put(p2.PersonId__r.PersonEmail,p2.PersonId__r.Lastname); 
                }               
            }
        }

        //Get Primary Email Addresses in case of Foreign and Non-trust accounts
        else{
            string Email =''; 
            for(Person_Account__c p2: paList){ 
                if(p2.TypeTranslate__c == '0000/Primary'){
                    if(accountEmail.containsKey(p2.Account_Number__r.name)){ 
                        string EmailString = accountEmail.get(p2.Account_Number__r.name);
                        if(!EmailString.contains(p2.PersonId__r.PersonEmail)){                   
                            Email = accountEmail.get(p2.Account_Number__r.name) + ',' +  p2.PersonId__r.PersonEmail;                    
                            accountEmail.put(p2.Account_Number__r.name, Email);
                        }
                    }
                    else{
                        accountEmail.put(p2.Account_Number__r.name, p2.PersonId__r.PersonEmail);
                    }
                    fnameFromEmail.put(p2.PersonId__r.PersonEmail,p2.PersonId__r.Firstname);
                    lnameFromEmail.put(p2.PersonId__r.PersonEmail,p2.PersonId__r.Lastname); 
                }               
            }
        }       
        
		
        system.debug('fnameFromEmail: '+fnameFromEmail);
        system.debug('lnameFromEmail: '+lnameFromEmail);
        
        for(Account_Details__c acc : accDetailMap){
            if(!accountMemberBranch.containsKey(acc.Name)){
                accountMemberBranch.put(acc.Name,acc.Brand__c);
            }   
        }
        
        //STRY0012093: Call to Queueable class To send Notification Emails 
        ID jobID = System.enqueueJob(new EDSAlertSendEmailQueueable(EDSRecords,accountEmail, accountMemberBranch,fnameFromEmail, lnameFromEmail));        
    }
    
    
}