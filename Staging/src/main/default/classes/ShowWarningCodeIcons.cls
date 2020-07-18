public class ShowWarningCodeIcons {
   
    public string accId;
    public list<case> caseList{get;set;}
    public list<Person_Account__c> ContactList{get;set;}
    public list<warningStringWrapper> wsWrapperList{get;set;}
    
    public ShowWarningCodeIcons (ApexPages.StandardController controller){
        //this.cRec = (Case)Controller.getRecord();
        accId = System.currentPageReference().getParameters().get('Id');
        if(accId!=NULL || accId!=''){
            personAccounts(accId);
            
        }else{
            
        }
    }
    
    public void personAccounts(string accId){
        list<Person_Account__c> paList = new list<Person_Account__c>();
            paList = [SELECT Id,
                             Account_Number__c FROM Person_Account__c WHERE PersonID__c =:accId];
        ContactDetails(paList);
        warningCodeDetails(paList);     
    }
    
    public void warningCodeDetails(list<Person_Account__c> paList){
        set<Id> paIds = new set<Id>();
        for(Person_Account__c var: paList){
            paIds.add(var.Account_Number__c);
        }
        
        list<Account_Details__c> accountDetailsList = new list<Account_Details__c>();
        
        accountDetailsList = [Select Id,
                                     Name,
                                     WARNING_01_CODE__c,
                                     WARNING_02_CODE__c,
                                     WARNING_03_CODE__c,
                                     WARNING_04_CODE__c,
                                     WARNING_05_CODE__c,
                                     WARNING_06_CODE__c,
                                     WARNING_07_CODE__c,
                                     WARNING_08_CODE__c,
                                     WARNING_09_CODE__c,
                                     WARNING_10_CODE__c,
                                     WARNING_11_CODE__c,
                                     WARNING_12_CODE__c,
                                     WARNING_13_CODE__c,
                                     WARNING_14_CODE__c,
                                     WARNING_15_CODE__c,
                                     WARNING_16_CODE__c,
                                     WARNING_17_CODE__c,
                                     WARNING_18_CODE__c,
                                     WARNING_19_CODE__c,
                                     WARNING_20_CODE__c FROM Account_Details__c Where ID IN:paIds];
         system.debug(accountDetailsList); 
                                    
         wsWrapperList = new list<warningStringWrapper>();
                                    
         for(Account_Details__c var: accountDetailsList){
             
             if(var.WARNING_01_CODE__c != '0-NONE' && var.WARNING_01_CODE__c != NULL){
                 wsWrapperList.add(new warningStringWrapper(var.Id,var.Name,var.WARNING_01_CODE__c));
             }
             if(var.WARNING_02_CODE__c != '0-NONE' && var.WARNING_02_CODE__c != NULL){
                 wsWrapperList.add(new warningStringWrapper(var.Id,var.Name,var.WARNING_02_CODE__c));
             }
             if(var.WARNING_03_CODE__c != '0-NONE' && var.WARNING_03_CODE__c != NULL){
                 wsWrapperList.add(new warningStringWrapper(var.Id,var.Name,var.WARNING_03_CODE__c));
             }
             if(var.WARNING_04_CODE__c != '0-NONE' && var.WARNING_04_CODE__c != NULL){
                 wsWrapperList.add(new warningStringWrapper(var.Id,var.Name,var.WARNING_04_CODE__c));
             }
             if(var.WARNING_05_CODE__c != '0-NONE' && var.WARNING_05_CODE__c != NULL){
                 wsWrapperList.add(new warningStringWrapper(var.Id,var.Name,var.WARNING_05_CODE__c));
             }
             if(var.WARNING_06_CODE__c != '0-NONE' && var.WARNING_06_CODE__c != NULL){
                 wsWrapperList.add(new warningStringWrapper(var.Id,var.Name,var.WARNING_06_CODE__c));
             }
             if(var.WARNING_07_CODE__c != '0-NONE' && var.WARNING_07_CODE__c != NULL){
                 wsWrapperList.add(new warningStringWrapper(var.Id,var.Name,var.WARNING_07_CODE__c));
             }
             if(var.WARNING_08_CODE__c != '0-NONE' && var.WARNING_08_CODE__c != NULL){
                 wsWrapperList.add(new warningStringWrapper(var.Id,var.Name,var.WARNING_08_CODE__c));
             }
             if(var.WARNING_09_CODE__c != '0-NONE' && var.WARNING_09_CODE__c != NULL){
                 wsWrapperList.add(new warningStringWrapper(var.Id,var.Name,var.WARNING_09_CODE__c));
             }
             if(var.WARNING_10_CODE__c != '0-NONE' && var.WARNING_10_CODE__c != NULL){
                 wsWrapperList.add(new warningStringWrapper(var.Id,var.Name,var.WARNING_10_CODE__c));
             }
             if(var.WARNING_11_CODE__c != '0-NONE' && var.WARNING_11_CODE__c != NULL){
                 wsWrapperList.add(new warningStringWrapper(var.Id,var.Name,var.WARNING_11_CODE__c));
             }
             if(var.WARNING_12_CODE__c != '0-NONE' && var.WARNING_12_CODE__c != NULL){
                 wsWrapperList.add(new warningStringWrapper(var.Id,var.Name,var.WARNING_12_CODE__c));
             }
             if(var.WARNING_13_CODE__c != '0-NONE' && var.WARNING_13_CODE__c != NULL){
                 wsWrapperList.add(new warningStringWrapper(var.Id,var.Name,var.WARNING_13_CODE__c));
             }
             if(var.WARNING_14_CODE__c != '0-NONE' && var.WARNING_14_CODE__c != NULL){
                 wsWrapperList.add(new warningStringWrapper(var.Id,var.Name,var.WARNING_14_CODE__c));
             }
             if(var.WARNING_15_CODE__c != '0-NONE' && var.WARNING_15_CODE__c != NULL){
                 wsWrapperList.add(new warningStringWrapper(var.Id,var.Name,var.WARNING_15_CODE__c));
             }
             if(var.WARNING_16_CODE__c != '0-NONE' && var.WARNING_16_CODE__c != NULL){
                 wsWrapperList.add(new warningStringWrapper(var.Id,var.Name,var.WARNING_16_CODE__c));
             }
             if(var.WARNING_17_CODE__c != '0-NONE' && var.WARNING_17_CODE__c != NULL){
                 wsWrapperList.add(new warningStringWrapper(var.Id,var.Name,var.WARNING_17_CODE__c));
             }
             if(var.WARNING_18_CODE__c != '0-NONE' && var.WARNING_18_CODE__c != NULL){
                 wsWrapperList.add(new warningStringWrapper(var.Id,var.Name,var.WARNING_18_CODE__c));
             }
             if(var.WARNING_19_CODE__c != '0-NONE' && var.WARNING_19_CODE__c != NULL){
                 wsWrapperList.add(new warningStringWrapper(var.Id,var.Name,var.WARNING_19_CODE__c));
             }
             if(var.WARNING_20_CODE__c != '0-NONE' && var.WARNING_20_CODE__c != NULL){
                 wsWrapperList.add(new warningStringWrapper(var.Id,var.Name,var.WARNING_20_CODE__c));
             }
         }
         system.debug(wsWrapperList);
    }
    
    public void ContactDetails(list<Person_Account__c> paList){
        set<Id> paIds = new set<Id>();
        for(Person_Account__c var: paList){
            paIds.add(var.Account_Number__c);
        }
      ContactList = new list<Person_Account__c>();
            ContactList = [Select Id,
                              personId__c,
                              Account_Number__c,
                              TypeTranslate__c,
                              Account_Type__c,
                              Relationship__c,
                              PersonID__r.SSN_TIN_Encrypted__pc,
                              Open_Date__c,
                              PersonID__r.PersonBirthdate,
                              Account_Number__r.Name,
                              PersonID__r.FirstName,
                              PersonID__r.LastName From Person_Account__c WHERE Account_Number__c IN :paIds];
        
        caseDetails(ContactList);
    }
    
    public void caseDetails(list<Person_Account__c> paList1){
        set<Id> accIds = new set<Id>();
        for(Person_Account__c var: paList1){
            accIds.add(var.PersonID__c);
        }
        caseList = [Select Id,
                           CaseNumber,
                           OwnerId, 
                           Owner.Name,
                           Status,
                          // Concatenated_Case_Type__c,
                           Primary_Category__c,
                           Tertiary_Category__c,
                           Secondary_Category__c,
                           Brand__c  FROM case WHERE AccountId IN :accIds AND Status != 'Closed'];
    }
    
    public class warningStringWrapper {
        public Id accId {get; set;}
        public String accNum {get; set;}
        public String WarningCode {get; set;}
        
        public warningStringWrapper(Id id, String Name, String wc) {
            accId = id;
            accNum = Name;
            WarningCode = wc;
            system.debug(Name);
        }
    }
}