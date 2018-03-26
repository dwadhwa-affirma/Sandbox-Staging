public class warningCodeIconController {
    
    private final Account accRec;
    public list<Account_Details__c> accList{get;set;}
    public list<document> docList {get;set;}
    public map<String, Id> docMap;
    public list<warningCodeWrapper> wcwList {get;set;}
    public list<string> rwcwList {get;set;}
    public set<string> wcwSet {get;set;}
    
    public warningCodeIconController(ApexPages.StandardController controller){
        this.accRec = (Account)Controller.getRecord();
        personAccounts(accRec.Id);
    }
    
    public void personAccounts(string accId){
        list<Person_Account__c> paList = new list<Person_Account__c>();
            paList = [SELECT Id,
                             Account_Number__c, Account_Number__r.RecType__c, Account_Number__r.Name FROM Person_Account__c WHERE PersonID__c =:accId];
        accountDetails(paList);
             
    }
    
    public void accountDetails(list<Person_Account__c> paList){
        set<String> accountNumberSet = new set<String>();
        set<Id> accIdset = new set<Id>();
        set<String> acctypeSet = new set<String>();
        for(Person_Account__c var: paList){
            accountNumberSet.add(var.Account_Number__r.Name);
            acctypeSet.add(var.Account_Number__r.RecType__c);
            accIdSet.add(var.Account_Number__c);
        }
        accList = new list<Account_Details__c>();
        if(acctypeSet.contains('ACCT')){
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
        mainMethod();
    }
    
    public void mainMethod(){
        
        docList =[SELECT Id,
                      Name FROM Document];
        docMap = new map<string,Id>();
        for(Document d: docList){
            docMap.put(d.Name,d.Id);
        }
        
        wcwList = new list<warningCodeWrapper>();
        rwcwList = new list<string>();
        for(Account_Details__c var: accList){
            if(var.WARNING_01_CODE__c != NULL || var.WARNING_01_CODE__c !='' || var.WARNING_01_CODE__c != '000-NONE' || var.WARNING_01_CODE__c != '0-NONE'){
                warningCodeWrapper wcw1 =new warningCodeWrapper(var.WARNING_01_CODE__c , docMap);
                if(wcw1.isNull != true) {
                 wcwList.add(wcw1);
                }
            }
            if(var.WARNING_02_CODE__c != NULL || var.WARNING_02_CODE__c !='' || var.WARNING_02_CODE__c != '000-NONE' || var.WARNING_02_CODE__c != '0-NONE'){
                warningCodeWrapper wcw2 =new warningCodeWrapper(var.WARNING_02_CODE__c , docMap);
                if(wcw2.isNull != true) {
                  wcwList.add(wcw2);
                }
            }
            if(var.WARNING_03_CODE__c != NULL || var.WARNING_03_CODE__c !='' || var.WARNING_03_CODE__c != '000-NONE' || var.WARNING_03_CODE__c != '0-NONE'){
                warningCodeWrapper wcw3 =new warningCodeWrapper(var.WARNING_03_CODE__c , docMap);
                if(wcw3.isNull != true) {
                wcwList.add(wcw3);
                }
            }            
            if(var.WARNING_04_CODE__c != NULL || var.WARNING_04_CODE__c !='' || var.WARNING_04_CODE__c != '000-NONE' || var.WARNING_04_CODE__c != '0-NONE'){
                warningCodeWrapper wcw4 =new warningCodeWrapper(var.WARNING_04_CODE__c , docMap);
               if(wcw4.isNull != true) {
                  wcwList.add(wcw4);
                }
            }
            if(var.WARNING_05_CODE__c != NULL || var.WARNING_05_CODE__c !='' || var.WARNING_05_CODE__c != '000-NONE' || var.WARNING_05_CODE__c != '0-NONE'){
                warningCodeWrapper wcw5 =new warningCodeWrapper(var.WARNING_05_CODE__c , docMap);
                 if(wcw5.isNull != true) {
                  wcwList.add(wcw5);
                }
            }
            if(var.WARNING_06_CODE__c != NULL || var.WARNING_06_CODE__c !='' || var.WARNING_06_CODE__c != '000-NONE' || var.WARNING_06_CODE__c != '0-NONE'){
                warningCodeWrapper wcw6 =new warningCodeWrapper(var.WARNING_06_CODE__c , docMap);
                if(wcw6.isNull != true) {
                  wcwList.add(wcw6);
                }
            }
            if(var.WARNING_07_CODE__c != NULL || var.WARNING_07_CODE__c !='' || var.WARNING_07_CODE__c != '000-NONE' || var.WARNING_07_CODE__c != '0-NONE'){
                warningCodeWrapper wcw7 =new warningCodeWrapper(var.WARNING_07_CODE__c , docMap);
                if(wcw7.isNull != true) {
                  wcwList.add(wcw7);
                }
            }
            if(var.WARNING_08_CODE__c != NULL || var.WARNING_08_CODE__c !='' || var.WARNING_08_CODE__c != '000-NONE' || var.WARNING_08_CODE__c != '0-NONE'){
                warningCodeWrapper wcw8 =new warningCodeWrapper(var.WARNING_08_CODE__c , docMap);
                if(wcw8.isNull != true) {
                  wcwList.add(wcw8);
                }
            }
            if(var.WARNING_09_CODE__c != NULL || var.WARNING_09_CODE__c !='' || var.WARNING_09_CODE__c != '000-NONE' || var.WARNING_09_CODE__c != '0-NONE'){
                warningCodeWrapper wcw9 =new warningCodeWrapper(var.WARNING_09_CODE__c , docMap);
                if(wcw9.isNull != true) {
                  wcwList.add(wcw9);
                }
            }
            if(var.WARNING_10_CODE__c != NULL || var.WARNING_10_CODE__c !='' || var.WARNING_10_CODE__c != '000-NONE' || var.WARNING_10_CODE__c != '0-NONE'){
                warningCodeWrapper wcw10 =new warningCodeWrapper(var.WARNING_10_CODE__c , docMap);
                if(wcw10.isNull != true) {
                  wcwList.add(wcw10);
                }
            }
            if(var.WARNING_11_CODE__c != NULL || var.WARNING_11_CODE__c !='' || var.WARNING_11_CODE__c != '000-NONE' || var.WARNING_11_CODE__c != '0-NONE'){
                warningCodeWrapper wcw11 =new warningCodeWrapper(var.WARNING_11_CODE__c , docMap);
                if(wcw11.isNull != true) {
                  wcwList.add(wcw11);
                }
            }
            if(var.WARNING_12_CODE__c != NULL || var.WARNING_12_CODE__c !='' || var.WARNING_12_CODE__c != '000-NONE' || var.WARNING_12_CODE__c != '0-NONE'){
                warningCodeWrapper wcw12 =new warningCodeWrapper(var.WARNING_12_CODE__c , docMap);
                if(wcw12.isNull != true) {
                  wcwList.add(wcw12);
                }
            }
            if(var.WARNING_13_CODE__c != NULL || var.WARNING_13_CODE__c !='' || var.WARNING_13_CODE__c != '000-NONE' || var.WARNING_13_CODE__c != '0-NONE'){
                warningCodeWrapper wcw13 =new warningCodeWrapper(var.WARNING_13_CODE__c , docMap);
                if(wcw13.isNull != true) {
                  wcwList.add(wcw13);
                }
            }
            if(var.WARNING_14_CODE__c != NULL || var.WARNING_14_CODE__c !='' || var.WARNING_14_CODE__c != '000-NONE' || var.WARNING_14_CODE__c != '0-NONE'){
                warningCodeWrapper wcw14 =new warningCodeWrapper(var.WARNING_14_CODE__c , docMap);
                if(wcw14.isNull != true) {
                  wcwList.add(wcw14);
                }
            }
            if(var.WARNING_15_CODE__c != NULL || var.WARNING_15_CODE__c !='' || var.WARNING_15_CODE__c != '000-NONE' || var.WARNING_15_CODE__c != '0-NONE'){
                warningCodeWrapper wcw15 =new warningCodeWrapper(var.WARNING_15_CODE__c , docMap);
                if(wcw15.isNull != true) {
                  wcwList.add(wcw15);
                }
            }
            if(var.WARNING_16_CODE__c != NULL || var.WARNING_16_CODE__c !='' || var.WARNING_16_CODE__c != '000-NONE' || var.WARNING_16_CODE__c != '0-NONE'){
                warningCodeWrapper wcw16 =new warningCodeWrapper(var.WARNING_16_CODE__c , docMap);
                if(wcw16.isNull != true) {
                  wcwList.add(wcw16);
                }
            }
            if(var.WARNING_17_CODE__c != NULL || var.WARNING_17_CODE__c !='' || var.WARNING_17_CODE__c != '000-NONE' || var.WARNING_17_CODE__c != '0-NONE'){
                warningCodeWrapper wcw17 =new warningCodeWrapper(var.WARNING_17_CODE__c , docMap);
                if(wcw17.isNull != true) {
                  wcwList.add(wcw17);
                }
            }
            if(var.WARNING_18_CODE__c != NULL || var.WARNING_18_CODE__c !='' || var.WARNING_18_CODE__c != '000-NONE' || var.WARNING_18_CODE__c != '0-NONE'){
                warningCodeWrapper wcw18 =new warningCodeWrapper(var.WARNING_18_CODE__c , docMap);
                if(wcw18.isNull != true) {
                  wcwList.add(wcw18);
                }
            }
            if(var.WARNING_19_CODE__c != NULL || var.WARNING_19_CODE__c !='' || var.WARNING_19_CODE__c != '000-NONE' || var.WARNING_19_CODE__c != '0-NONE'){
                warningCodeWrapper wcw19 =new warningCodeWrapper(var.WARNING_19_CODE__c , docMap);
                if(wcw19.isNull != true) {
                  wcwList.add(wcw19);
                }
            }
            if(var.WARNING_20_CODE__c != NULL || var.WARNING_20_CODE__c !='' || var.WARNING_20_CODE__c != '000-NONE' || var.WARNING_20_CODE__c != '0-NONE'){
                warningCodeWrapper wcw20 =new warningCodeWrapper(var.WARNING_20_CODE__c , docMap);
                if(wcw20.isNull != true) {
                  wcwList.add(wcw20);
                }
            }
            
        }
        
      wcwSet = new set<string>();
        for(warningCodeWrapper w: wcwList){
            wcwSet.add(w.imgUrl);
        }
        rwcwList.addAll(wcwSet);
        system.debug('Warning Code List:::::::'+wcwSet);
        system.debug('DocMap List:::::::'+ rwcwList);
     }
    
    /*01511000000gzJdAAI
    01511000000gz78AAA
    01511000000gz7DAAQ
    01511000000gz7IAAQ
    01511000000gzIfAAI*/
    
    public class warningCodeWrapper{
        public string imgUrl {get;set;}
        public boolean isNull {get;set;} 
        
        public warningCodeWrapper(string var, map<string,id> docMap){
            system.debug('var is ::::'+ var);
            system.debug('docMap is ::::'+ docMap);
            if(docMap.get(var) == null) {
                imgUrl = null;
                isNull = true;
            } else {
            imgUrl = '/servlet/servlet.FileDownload?file='+docMap.get(var);
                isNull = false;
                system.debug('docMap List:::::'+docMap.get(var));
            }
        }
    }
}