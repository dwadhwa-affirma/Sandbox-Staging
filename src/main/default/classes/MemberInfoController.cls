public class MemberInfoController {

    @AuraEnabled
    public static AccountViewModel GetMemberInfomation(Id accountId){
        System.debug('Reached here');
        Account acc = [SELECT Id,Name,BIRTH_DATE__pc,Email_raw__c, 
                       Mobile_Phone__pc,MemberType__c,CreatedDate
                       FROM Account WHERE 
                       Id=:accountId];
        
        Integer joiningDaysDiff = date.newinstance(acc.CreatedDate.year(), acc.CreatedDate.month(), acc.CreatedDate.day()).daysBetween(Date.today());
        
        Integer daysDiffBetwBirthAndToday=0;
        Integer daysDiffBetwThisYearBirthAndBirthDate=0;
        Integer birthDaysDiff= 0;
        if(acc.BIRTH_DATE__pc!=null){
        	daysDiffBetwBirthAndToday = date.newinstance(acc.BIRTH_DATE__pc.year(), acc.BIRTH_DATE__pc.month(), acc.BIRTH_DATE__pc.day()).daysBetween(Date.today());
        	daysDiffBetwThisYearBirthAndBirthDate = date.newinstance(acc.BIRTH_DATE__pc.year(), acc.BIRTH_DATE__pc.month(), acc.BIRTH_DATE__pc.day()).daysBetween(date.newinstance(Date.today().year(), acc.BIRTH_DATE__pc.month(), acc.BIRTH_DATE__pc.day()));
        	birthDaysDiff = daysDiffBetwThisYearBirthAndBirthDate - daysDiffBetwBirthAndToday;
        }
            
        AccountViewModel accViewModel = new AccountViewModel();
        accViewModel.Name = acc.Name;
        accViewModel.BirthDate = acc.BIRTH_DATE__pc;
        accViewModel.Email = acc.Email_raw__c;
        accViewModel.MobilePhone = acc.Mobile_Phone__pc;
        accViewModel.MemberType = acc.MemberType__c;
        accViewModel.JoiningDaysDiff = joiningDaysDiff;
        accViewModel.BirthDaysDiff = birthDaysDiff;   
        
        return accViewModel;
    }
    
    @AuraEnabled
    public static List<WarningsViewModel> GetMemberInfoWarnings(Id accountId) { 
        System.debug('Reached in'+accountId);
        list<Person_Account__c> paList = [SELECT Id,Account_Number__c, 
                                          Account_Number__r.RecType__c, Account_Number__r.Name 
                                          FROM Person_Account__c 
                                          WHERE PersonID__c =:accountId and TypeTranslate__c !=: '0004/Beneficiary'];
        
        System.debug('pa list'+paList);
    	set<String> accountNumberSet = new set<String>();
        set<Id> accIdset = new set<Id>();
        set<String> acctypeSet = new set<String>();
        for(Person_Account__c var: paList){
            accountNumberSet.add(var.Account_Number__r.Name);
            acctypeSet.add(var.Account_Number__r.RecType__c);
            accIdSet.add(var.Account_Number__c);
        }
        System.debug('Account type c'+acctypeSet);
        list<Account_Details__c> accList = new list<Account_Details__c>();
        if(acctypeSet.contains('ACCT')){
            System.debug('Reached in if condition only');
            accList = [SELECT Id,
                              Name,
                              RecType__c,
                              TypeTranslate__c,
                              ID1__c,
                              Balance__c,
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
                              WARNING_20_CODE__c,
                              Combined_Account_ID__c FROM Account_Details__c Where Name IN:accountNumberSet];
        }else{
            System.debug('Reached in else condition only');
            accList = [SELECT Id,
                              Name,
                              RecType__c,
                              TypeTranslate__c,
                              ID1__c,
                              Balance__c,
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
                              WARNING_20_CODE__c,
                              Combined_Account_ID__c FROM Account_Details__c Where Id IN:accIdSet];
        }
        
        List<WarningsViewModel> wcwList = new List<WarningsViewModel>();
        for(Account_Details__c var: accList){
            if(var.WARNING_01_CODE__c != NULL || var.WARNING_01_CODE__c !='' || var.WARNING_01_CODE__c != '000-NONE' || var.WARNING_01_CODE__c != '0-NONE'){
                WarningsViewModel wcw1 =new WarningsViewModel(var.WARNING_01_CODE__c);
                 if(wcw1.isNull != true) {
                	wcwList.add(wcw1);
                 }
            }
            if(var.WARNING_02_CODE__c != NULL || var.WARNING_02_CODE__c !='' || var.WARNING_02_CODE__c != '000-NONE' || var.WARNING_02_CODE__c != '0-NONE'){
                WarningsViewModel wcw2 =new WarningsViewModel(var.WARNING_02_CODE__c);
                 if(wcw2.isNull != true) {
                wcwList.add(wcw2);
                 }
            }
            if(var.WARNING_03_CODE__c != NULL || var.WARNING_03_CODE__c !='' || var.WARNING_03_CODE__c != '000-NONE' || var.WARNING_03_CODE__c != '0-NONE'){
                WarningsViewModel wcw3 =new WarningsViewModel(var.WARNING_03_CODE__c);
                if(wcw3.isNull != true) {
                wcwList.add(wcw3);
                }
            }            
            if(var.WARNING_04_CODE__c != NULL || var.WARNING_04_CODE__c !='' || var.WARNING_04_CODE__c != '000-NONE' || var.WARNING_04_CODE__c != '0-NONE'){
                WarningsViewModel wcw4 =new WarningsViewModel(var.WARNING_04_CODE__c);
                 if(wcw4.isNull != true) {
                wcwList.add(wcw4);
                 }
            }
            if(var.WARNING_05_CODE__c != NULL || var.WARNING_05_CODE__c !='' || var.WARNING_05_CODE__c != '000-NONE' || var.WARNING_05_CODE__c != '0-NONE'){
                WarningsViewModel wcw5 =new WarningsViewModel(var.WARNING_05_CODE__c);                
                 if(wcw5.isNull != true) {
                wcwList.add(wcw5);  
                 }
            }
            if(var.WARNING_06_CODE__c != NULL || var.WARNING_06_CODE__c !='' || var.WARNING_06_CODE__c != '000-NONE' || var.WARNING_06_CODE__c != '0-NONE'){
                WarningsViewModel wcw6 =new WarningsViewModel(var.WARNING_06_CODE__c);              
                 if(wcw6.isNull != true) {
                wcwList.add(wcw6); 
                 }
            }
            if(var.WARNING_07_CODE__c != NULL || var.WARNING_07_CODE__c !='' || var.WARNING_07_CODE__c != '000-NONE' || var.WARNING_07_CODE__c != '0-NONE'){
                WarningsViewModel wcw7 =new WarningsViewModel(var.WARNING_07_CODE__c);               
                 if(wcw7.isNull != true) {
                wcwList.add(wcw7); 
                 }
            }
            if(var.WARNING_08_CODE__c != NULL || var.WARNING_08_CODE__c !='' || var.WARNING_08_CODE__c != '000-NONE' || var.WARNING_08_CODE__c != '0-NONE'){
                WarningsViewModel wcw8 =new WarningsViewModel(var.WARNING_08_CODE__c);               
                 if(wcw8.isNull != true) {
                wcwList.add(wcw8); 
                 }
            }
            if(var.WARNING_09_CODE__c != NULL || var.WARNING_09_CODE__c !='' || var.WARNING_09_CODE__c != '000-NONE' || var.WARNING_09_CODE__c != '0-NONE'){
                WarningsViewModel wcw9 =new WarningsViewModel(var.WARNING_09_CODE__c);                
                 if(wcw9.isNull != true) {
                wcwList.add(wcw9); 
                 }
            }
            if(var.WARNING_10_CODE__c != NULL || var.WARNING_10_CODE__c !='' || var.WARNING_10_CODE__c != '000-NONE' || var.WARNING_10_CODE__c != '0-NONE'){
                WarningsViewModel wcw10 =new WarningsViewModel(var.WARNING_10_CODE__c);               
                 if(wcw10.isNull != true) {
                wcwList.add(wcw10);
                 }
            }
            if(var.WARNING_11_CODE__c != NULL || var.WARNING_11_CODE__c !='' || var.WARNING_11_CODE__c != '000-NONE' || var.WARNING_11_CODE__c != '0-NONE'){
                WarningsViewModel wcw11 =new WarningsViewModel(var.WARNING_11_CODE__c);               
                if(wcw11.isNull != true) {
                wcwList.add(wcw11);     
                 }
            }
            if(var.WARNING_12_CODE__c != NULL || var.WARNING_12_CODE__c !='' || var.WARNING_12_CODE__c != '000-NONE' || var.WARNING_12_CODE__c != '0-NONE'){
                WarningsViewModel wcw12 =new WarningsViewModel(var.WARNING_12_CODE__c);               
                 if(wcw12.isNull != true) {
                wcwList.add(wcw12);
                 }
            }
            if(var.WARNING_13_CODE__c != NULL || var.WARNING_13_CODE__c !='' || var.WARNING_13_CODE__c != '000-NONE' || var.WARNING_13_CODE__c != '0-NONE'){
                WarningsViewModel wcw13 =new WarningsViewModel(var.WARNING_13_CODE__c);
                 if(wcw13.isNull != true) {
                wcwList.add(wcw13);
                 }
            }
            if(var.WARNING_14_CODE__c != NULL || var.WARNING_14_CODE__c !='' || var.WARNING_14_CODE__c != '000-NONE' || var.WARNING_14_CODE__c != '0-NONE'){
                WarningsViewModel wcw14 =new WarningsViewModel(var.WARNING_14_CODE__c);
                 if(wcw14.isNull != true) {
                wcwList.add(wcw14);
                 }
            }
            if(var.WARNING_15_CODE__c != NULL || var.WARNING_15_CODE__c !='' || var.WARNING_15_CODE__c != '000-NONE' || var.WARNING_15_CODE__c != '0-NONE'){
                WarningsViewModel wcw15 =new WarningsViewModel(var.WARNING_15_CODE__c);
                 if(wcw15.isNull != true) {
                wcwList.add(wcw15);
                 }
            }
            if(var.WARNING_16_CODE__c != NULL || var.WARNING_16_CODE__c !='' || var.WARNING_16_CODE__c != '000-NONE' || var.WARNING_16_CODE__c != '0-NONE'){
                WarningsViewModel wcw16 =new WarningsViewModel(var.WARNING_16_CODE__c);
                 if(wcw16.isNull != true) {
                wcwList.add(wcw16);
                 }
            }
            if(var.WARNING_17_CODE__c != NULL || var.WARNING_17_CODE__c !='' || var.WARNING_17_CODE__c != '000-NONE' || var.WARNING_17_CODE__c != '0-NONE'){
                WarningsViewModel wcw17 =new WarningsViewModel(var.WARNING_17_CODE__c);
                 if(wcw17.isNull != true) {
                wcwList.add(wcw17);
                 }
            }
            if(var.WARNING_18_CODE__c != NULL || var.WARNING_18_CODE__c !='' || var.WARNING_18_CODE__c != '000-NONE' || var.WARNING_18_CODE__c != '0-NONE'){
                WarningsViewModel wcw18 =new WarningsViewModel(var.WARNING_18_CODE__c);
                 if(wcw18.isNull != true) {
                wcwList.add(wcw18);
                 }
            }
            if(var.WARNING_19_CODE__c != NULL || var.WARNING_19_CODE__c !='' || var.WARNING_19_CODE__c != '000-NONE' || var.WARNING_19_CODE__c != '0-NONE'){
                WarningsViewModel wcw19 =new WarningsViewModel(var.WARNING_19_CODE__c);
                 if(wcw19.isNull != true) {
                wcwList.add(wcw19);
                 }
            }
            if(var.WARNING_20_CODE__c != NULL || var.WARNING_20_CODE__c !='' || var.WARNING_20_CODE__c != '000-NONE' || var.WARNING_20_CODE__c != '0-NONE'){
                WarningsViewModel wcw20 =new WarningsViewModel(var.WARNING_20_CODE__c);
                 if(wcw20.isNull != true) {
                wcwList.add(wcw20);
                 }
            }
            
        }        
      
        return wcwList;
    }
    
    public class AccountViewModel {
        @AuraEnabled public string Name;
        @AuraEnabled public Date BirthDate;
        @AuraEnabled public string Email;
        @AuraEnabled public string MobilePhone;
        @AuraEnabled public string MemberType;
        @AuraEnabled public Integer JoiningDaysDiff;
        @AuraEnabled public Integer BirthDaysDiff;
    }
    
    public class WarningsViewModel {
         @AuraEnabled public string Code;
         @AuraEnabled public string Description;
         @AuraEnabled public boolean isNull {get;set;}    
        public WarningsViewModel(string val){
            if(String.isNotBlank(val) && String.isNotEmpty(val)) {
                 string[] splitted = val.split('-');
                 if(splitted.size()==2){
                 	this.Code=splitted[0];
                    this.Description=splitted[1];
                    this.isNull=false;
                 }else{
                     this.isNull = true;
                 }
            }else{
                this.isNull = true;
            }
        }
    }
}