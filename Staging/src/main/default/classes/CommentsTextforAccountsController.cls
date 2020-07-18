public class CommentsTextforAccountsController {

    private final Account_Details__c accRec;
    public list<Account_Details__c> accList{get;set;}
   // public list<document> docList {get;set;}
    public map<String, Id> docMap;
    public list<warningCodeWrapper> wcwList {get;set;}
    public list<string> rwcwList {get;set;}
    public set<string> wcwSet {get;set;}
    
    public CommentsTextforAccountsController(ApexPages.StandardController controller){
        this.accRec = (Account_Details__c)Controller.getRecord();
      //  personAccounts(accRec.Id);
      Account_Details__c accDRec = [Select Id, Name from Account_Details__c where Id=:accRec.Id Limit 1];
      accountDetails(accDRec.Name);
    }   
    
    
    public void accountDetails(String accRecName){
        
        accList = new list<Account_Details__c>();
        
            accList = [SELECT Id,
                              Name,
                              RecType__c,
                              TypeTranslate__c,
                              ID1__c,
                              Balance__c,
                              Comment_Block_01__c,
                              Comment_Block_02__c,
                              Comment_Block_03__c,
                              Comment_Block_04__c,
                              Comment_Block_05__c,
                              Comment_Block_06__c,
                              Comment_Block_07__c,
                              Comment_Block_08__c,
                              Comment_Block_09__c,
                              Comment_Block_10__c,
                              Comment_Block_11__c,
                              Comment_Block_12__c,
                              Comment_Block_13__c,
                              Comment_Block_14__c,
                              Comment_Block_15__c,
                              Comment_Block_16__c,
                              Comment_Block_17__c,
                              Comment_Block_18__c,
                              Comment_Block_19__c,
                              Comment_Block_20__c,
                              Combined_Account_ID__c FROM Account_Details__c Where Name =:accRecName];
        
        mainMethod();
    }
    
    public void mainMethod(){
        
        wcwList = new list<warningCodeWrapper>();
        rwcwList = new list<string>();
        for(Account_Details__c var: accList){
            if(var.Comment_Block_01__c != NULL || var.Comment_Block_01__c !=''){
                warningCodeWrapper wcw1 =new warningCodeWrapper(var.Comment_Block_01__c);
                 wcwList.add(wcw1);
            }
            if(var.Comment_Block_02__c != NULL || var.Comment_Block_02__c !=''){
                warningCodeWrapper wcw2 =new warningCodeWrapper(var.Comment_Block_02__c);
                  wcwList.add(wcw2);
            }
            if(var.Comment_Block_03__c != NULL || var.Comment_Block_03__c !=''){
                warningCodeWrapper wcw3 =new warningCodeWrapper(var.Comment_Block_03__c);
                wcwList.add(wcw3);
            }            
            if(var.Comment_Block_04__c != NULL || var.Comment_Block_04__c !=''){
                warningCodeWrapper wcw4 =new warningCodeWrapper(var.Comment_Block_04__c);
                  wcwList.add(wcw4);
            }
            if(var.Comment_Block_05__c != NULL || var.Comment_Block_05__c !=''){
                warningCodeWrapper wcw5 =new warningCodeWrapper(var.Comment_Block_05__c);
                  wcwList.add(wcw5);
            }
            if(var.Comment_Block_06__c != NULL || var.Comment_Block_06__c !=''){
                warningCodeWrapper wcw6 =new warningCodeWrapper(var.Comment_Block_06__c);
                  wcwList.add(wcw6);
            }
            if(var.Comment_Block_07__c != NULL || var.Comment_Block_07__c !=''){
                warningCodeWrapper wcw7 =new warningCodeWrapper(var.Comment_Block_07__c);
                  wcwList.add(wcw7);
            }
            if(var.Comment_Block_08__c != NULL || var.Comment_Block_08__c !=''){
                warningCodeWrapper wcw8 =new warningCodeWrapper(var.Comment_Block_08__c);
                  wcwList.add(wcw8);
            }
            if(var.Comment_Block_09__c != NULL || var.Comment_Block_09__c !=''){
                warningCodeWrapper wcw9 =new warningCodeWrapper(var.Comment_Block_09__c);
                  wcwList.add(wcw9);
            }
            if(var.Comment_Block_10__c != NULL || var.Comment_Block_10__c !=''){
                warningCodeWrapper wcw10 =new warningCodeWrapper(var.Comment_Block_10__c);
                  wcwList.add(wcw10);
            }
            if(var.Comment_Block_11__c != NULL || var.Comment_Block_11__c !=''){
                warningCodeWrapper wcw11 =new warningCodeWrapper(var.Comment_Block_11__c);
                  wcwList.add(wcw11);
            }
            if(var.Comment_Block_12__c != NULL || var.Comment_Block_12__c !=''){
                warningCodeWrapper wcw12 =new warningCodeWrapper(var.Comment_Block_12__c);
                  wcwList.add(wcw12);
            }
            if(var.Comment_Block_13__c != NULL || var.Comment_Block_13__c !=''){
                warningCodeWrapper wcw13 =new warningCodeWrapper(var.Comment_Block_13__c);
                  wcwList.add(wcw13);
            }
            if(var.Comment_Block_14__c != NULL || var.Comment_Block_14__c !=''){
                warningCodeWrapper wcw14 =new warningCodeWrapper(var.Comment_Block_14__c);
                  wcwList.add(wcw14);
            }
            if(var.Comment_Block_15__c != NULL || var.Comment_Block_15__c !=''){
                warningCodeWrapper wcw15 =new warningCodeWrapper(var.Comment_Block_15__c);
                  wcwList.add(wcw15);
            }
            if(var.Comment_Block_16__c != NULL || var.Comment_Block_16__c !=''){
                warningCodeWrapper wcw16 =new warningCodeWrapper(var.Comment_Block_16__c);
                  wcwList.add(wcw16);
            }
            if(var.Comment_Block_17__c != NULL || var.Comment_Block_17__c !=''){
                warningCodeWrapper wcw17 =new warningCodeWrapper(var.Comment_Block_17__c);
                  wcwList.add(wcw17);
            }
            if(var.Comment_Block_18__c != NULL || var.Comment_Block_18__c !=''){
                warningCodeWrapper wcw18 =new warningCodeWrapper(var.Comment_Block_18__c);
                  wcwList.add(wcw18);
            }
            if(var.Comment_Block_19__c != NULL || var.Comment_Block_19__c !=''){
                warningCodeWrapper wcw19 =new warningCodeWrapper(var.Comment_Block_19__c);
                  wcwList.add(wcw19);
            }
            if(var.Comment_Block_20__c != NULL || var.Comment_Block_20__c !=''){
                warningCodeWrapper wcw20 =new warningCodeWrapper(var.Comment_Block_20__c);
                  wcwList.add(wcw20);
            }           
        }
        
      wcwSet = new set<string>();
        for(warningCodeWrapper w: wcwList){
            wcwSet.add(w.comms);
        }
        rwcwList.addAll(wcwSet);
     }
    
    /*01511000000gzJdAAI
    01511000000gz78AAA
    01511000000gz7DAAQ
    01511000000gz7IAAQ
    01511000000gzIfAAI*/
    
    public class warningCodeWrapper{
        public string comms {get;set;}
        
        public warningCodeWrapper(string var){
           comms = var;           
            }
        }
    }