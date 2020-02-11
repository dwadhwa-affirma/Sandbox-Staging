public class Accounts360ViewController {

    private final Account_Details__c accRec;
    public String accId;
    public list<warningStringWrapper> wsWrapperList{get;set;}
    public list<Account_Details__c> accountsList{get;set;}
    public list<Account_Details__c> cardList{get;set;}
    public list<case> caseList{get;set;}
    public list<case> caseList1{get;set;}
    public list<Person_Account__c> ContactList{get;set;}
    public Map<String, Id> cnum_by_id1{get;set;}
    public Map<String, String> cnum_by_id2{get;set;}
    public Map<String, String> cnum_by_id3{get;set;}
    public Map<String, String> cnum_by_id4{get;set;}
    public Map<String, String> cnum_by_id5{get;set;}
    public Map<String, String> cnum_by_id6{get;set;}
    public Map<String, String> cnum_by_id7{get;set;}
    public list<CaseComment> caseCommentList{get;set;}
    public Map<String, list<CaseComment>> mccomm{get;set;}
    public list<Task> tskList{get;set;}
    public Map<String, list<Task>> tsks{get;set;}
    public list<document> docList {get;set;}
    public map<String, Id> docMap;
     public integer cM_date5=0;
     public integer cABal=0;

    public Accounts360ViewController(ApexPages.StandardController controller){
     // this.accRec = (Account_Details__c)Controller.getRecord();
      accId = System.currentPageReference().getParameters().get('Id');
     Account_Details__c accDRec = [Select Id, Name from Account_Details__c where Id=:accId Limit 1];
        System.debug('Parent Account Id is::::'+accDRec); 
      CaseDetails(accDRec.Name);
      ContactDetails(accDRec.Name);
    }
    
    public void ContactDetails(String accRecName){   
        
      ContactList = new list<Person_Account__c>();
        ContactList = [Select Id,
                              personId__c,
                              Account_Number__c,
                              TypeTranslate__c,
                              Account_Type__c,
                              Relationship__c,
                              PersonID__r.SSN_Last_4__pc,
                              Open_Date__c,
                             // PersonID__r.BIRTH_DATE__pc,
                              Account_Number__r.Name,
                              Account_Number__r.TypeTranslate__c,
                              PersonID__r.FirstName,
                              PersonID__r.LastName,
                              PersonID__r.Name, 
                              Account_Number__r.Brand__c From Person_Account__c WHERE Account_Number__r.Name =:accRecName OR
                                                                    Account_Number__r.Parent_Account__r.Name =:accRecName];
        
    }
    
    public void CaseDetails(String accRecName){
        caseList = new list<Case>();
        caseList1 = new list<Case>();
        caseList = [Select Id,
                           CaseNumber,
                           OwnerId, 
                           Owner.Name,
                           Status,
                           Category__c,
                           Primary_Category__c,
                           Tertiary_Category__c,
                           Secondary_Category__c,
                           Account_Number__r.Brand__c,
                           Account.Name,
                           Account_Number__r.Name,
                           Account_Number__r.TypeTranslate__c,
                           ParentId,
                           Subject,
                           CreatedDate,
                           ClosedDate,
                           Origin
                         //  (Select CommentBody, IsPublished, ParentId, CreatedById, CreatedDate, LastModifiedDate from CaseComments) 
                           FROM case WHERE Account_Number__r.Name =:accRecName AND Status != 'Closed'];
        
      /*  if(caseList[0].CaseComments != null && caseList[0].CaseComments.size()>0){
            caseCommentList = caseList[0].CaseComments;
        } */
        
        caseList1 = [Select Id,
                           CaseNumber,
                           OwnerId, 
                           Owner.Name,
                           Status,
                           Category__c,
                           Primary_Category__c,
                           Tertiary_Category__c,
                           Secondary_Category__c,
                           Account_Number__r.Brand__c,
                           Account.Name,
                           Account_Number__r.Name,
                           Account_Number__r.TypeTranslate__c,
                           ParentId,
                           Subject,
                           CreatedDate,
                           Origin,
                           ClosedDate FROM case WHERE Account_Number__r.Name =:accRecName AND Status = 'Closed'];
        
        Map<Id, String> cnum_by_id = new Map<Id, String>();
        cnum_by_id1 = new Map<String, Id>();
        cnum_by_id2 = new Map<String, String>();
        cnum_by_id3 = new Map<String, String>();
        cnum_by_id4 = new Map<String, String>();
        cnum_by_id5 = new Map<String, String>();
        cnum_by_id6 = new Map<String, String>();
        cnum_by_id7 = new Map<String, String>();
        
        for(Case c: caseList) {
      
            if(c.CaseNumber != null){
                 cnum_by_id.put(c.Id, c.CaseNumber);
            }else{
                 cnum_by_id.put(c.Id, '');
            }
            
            if(c.Id != null){
                 cnum_by_id1.put(c.CaseNumber, c.Id);
            }else{
                 cnum_by_id1.put(c.CaseNumber, '');
            }
            
            if(c.Category__c != null){
                 cnum_by_id2.put(c.CaseNumber, c.Category__c);
            }else{
                 cnum_by_id2.put(c.CaseNumber, '');
            }
            
            if(c.Status != null){
                 cnum_by_id3.put(c.CaseNumber, c.Status);
            }else{
                 cnum_by_id3.put(c.CaseNumber, '');
            }
            
            if(c.Account_Number__r.Name != null){
                 cnum_by_id5.put(c.CaseNumber, c.Account_Number__r.Name);
            }else{
                 cnum_by_id5.put(c.CaseNumber, '');
            }
            
            if(c.Account.Name != null){
                 cnum_by_id6.put(c.CaseNumber, c.Account.Name);
            }else{
                 cnum_by_id6.put(c.CaseNumber, '');
            }
            
            if(c.Subject != null){
                 cnum_by_id7.put(c.CaseNumber, c.Subject);
            }else{
                 cnum_by_id7.put(c.CaseNumber, '');   
            } 
        }  
        
        caseCommentList = [Select CommentBody, IsPublished, ParentId, CreatedById, CreatedDate, LastModifiedDate from CaseComment Where ParentId IN :caseList order by LastModifiedDate DESC];
        
              System.debug('casecommentlist is:::'+caseCommentList);       
              mccomm = new Map<String, list<CaseComment>>();       
        
              for(CaseComment ccomm : caseCommentList){
                    string cnum = cnum_by_id.get(ccomm.ParentId);

                   // Id id1 = cnum_by_id1.get(ccomm.ParentId); 
                    system.debug('Case Number is::::'+cnum);

                    if(mccomm.get(cnum) != null) {
                         list<CaseComment> cc = mccomm.get(cnum);
                         cc.add(ccomm);
                         mccomm.put(cnum, cc);
                    }else {
                         list<CaseComment> cc = new list<CaseComment>();
                         cc.add(ccomm);
                         mccomm.put(cnum, cc);
                    }            
                   }         
                   System.debug('Case Comments are:::::'+ mccomm);  
        
       
        tskList = [Select Id, Subject, whatId, Type, What.Name, Status, Priority, Description from Task where What.Type='Case' AND WhatId IN :caseList order by LastModifieddate DESC NULLS LAST]; 
        
               tsks = new Map<String, list<Task>>(); 
        
               for(Task tsk : tskList){
                 string cnum1 = cnum_by_id.get(tsk.WhatId);

                 system.debug('Case Number1 is::::'+cnum1);

                 if(tsks.get(cnum1) != null) {
                    list<Task> tt = tsks.get(cnum1);
                    tt.add(tsk);
                    tsks.put(cnum1, tt);
                 }else {
                    list<Task> tt = new list<Task>();
                    tt.add(tsk);
                    tsks.put(cnum1, tt);
                 }           
               } 
             System.debug('Case Tasks are:::::'+ tsks);
        
             AccountDetails(accRecName);         
          }
    
    public void AccountDetails(String accRecName){
        accountsList = new list<Account_Details__c>();
       
        
              accountsList = [Select Id,
                                     Name,
                                     ID1__c,
                                     Balance__c,
                                     Combined_Account_ID__c,
                                     Brand__c,
                                     Loan_Number__c,
                                     Close_Date__c,
                                     Card_Number_Last_4_Digits__c,
                                     OPEN_DATE__c,
                                     Expiration_Date__c,
                                     Issue_Date__c,
                                     Emp_Balance__c,
                                     RecType__c,
                                     TypeTranslate__c,
                                     Available_Balance__c,
                                     Emp_Available_Balance__c,
                                     Maturity_Date__c FROM Account_Details__c Where Name=:accRecName and RecType__c != 'CARD'];
        
      /* for(Account_Details__c var:accountsList){
            if(var.Maturity_Date__c!=NULL){
                cM_date5 = cM_date5 +1;
              
            }
          } 
       
        for(Account_Details__c var:accountsList){
            var.maturity_count__c= cM_date5;
        }*/
        
            cardList = new list<Account_Details__c>();
                  cardList = [Select Id,
                                     Name,
                                     ID1__c,
                                     Balance__c,
                                     Combined_Account_ID__c,
                                     Brand__c,
                                     Loan_Number__c,
                                     Close_Date__c,
                                     Card_Number_Last_4_Digits__c,
                                     OPEN_DATE__c,
                                     Expiration_Date__c,
                                     Issue_Date__c,
                                     Emp_Balance__c,
                                     RecType__c,
                                     TypeTranslate__c,
                                     Card_Name__c FROM Account_Details__c Where Name=:accRecName and RecType__c = 'CARD'];
    
         warningCodeDetails(accRecName);
        }

    
      public void warningCodeDetails(String accRecName){
      
        list<Account_Details__c> accountDetailsList = new list<Account_Details__c>();
        
        accountDetailsList = [Select Id,
                                     Name,
                                     ID1__c,
                                     Balance__c,
                                     Combined_Account_ID__c,
                                     Brand__c,
                                     Loan_Number__c,
                                     Close_Date__c,
                                     Card_Number_Last_4_Digits__c,
                                     OPEN_DATE__c,
                                     Expiration_Date__c,
                                     Issue_Date__c,
                                     Emp_Balance__c,
                                     RecType__c,
                                     TypeTranslate__c,
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
                                     Comment_Block_20__c FROM Account_Details__c Where Name=:accRecName];
        
            
         system.debug(accountDetailsList); 
          
          docList =[SELECT Id,
                      Name FROM Document];
        docMap = new map<string,Id>();
        for(Document d: docList){
            docMap.put(d.Name,d.Id);
        }
                                    
         wsWrapperList = new list<warningStringWrapper>();
                                    
         for(Account_Details__c var: accountDetailsList){
              System.debug('Debug::::Close_Date__c = '+var.Close_Date__c);                  
             if(var.WARNING_01_CODE__c != '000-NONE' && var.WARNING_01_CODE__c != NULL && var.WARNING_01_CODE__c != '0-NONE'){
                 wsWrapperList.add(new warningStringWrapper(var.Id,var.Name, var.Close_Date__c, var.WARNING_01_CODE__c,var.RecType__c,var.TypeTranslate__c,var.ID1__c,docMap, 'Warning Code'));
             }
             if(var.Comment_Block_01__c != null){
                 wsWrapperList.add(new warningStringWrapper(var.Id,var.Name,var.Close_Date__c,var.Comment_Block_01__c,var.RecType__c,var.TypeTranslate__c,var.ID1__c,docMap, 'Comment'));
             }
             if(var.WARNING_02_CODE__c != '000-NONE' && var.WARNING_02_CODE__c != NULL && var.WARNING_02_CODE__c != '0-NONE'){
                 wsWrapperList.add(new warningStringWrapper(var.Id,var.Name,var.Close_Date__c,var.WARNING_02_CODE__c,var.RecType__c,var.TypeTranslate__c,var.ID1__c,docMap, 'Warning Code'));
             }
             if(var.Comment_Block_02__c != null){
                 wsWrapperList.add(new warningStringWrapper(var.Id,var.Name,var.Close_Date__c,var.Comment_Block_02__c,var.RecType__c,var.TypeTranslate__c,var.ID1__c,docMap, 'Comment'));
             }
             if(var.WARNING_03_CODE__c != '000-NONE' && var.WARNING_03_CODE__c != NULL && var.WARNING_03_CODE__c != '0-NONE'){
                 wsWrapperList.add(new warningStringWrapper(var.Id,var.Name,var.Close_Date__c,var.WARNING_03_CODE__c,var.RecType__c,var.TypeTranslate__c,var.ID1__c,docMap, 'Warning Code'));
             }
             if(var.Comment_Block_03__c != null){
                 wsWrapperList.add(new warningStringWrapper(var.Id,var.Name,var.Close_Date__c,var.Comment_Block_03__c,var.RecType__c,var.TypeTranslate__c,var.ID1__c,docMap, 'Comment'));
             }
             if(var.WARNING_04_CODE__c != '000-NONE' && var.WARNING_04_CODE__c != NULL && var.WARNING_04_CODE__c != '0-NONE'){
                 wsWrapperList.add(new warningStringWrapper(var.Id,var.Name,var.Close_Date__c,var.WARNING_04_CODE__c,var.RecType__c,var.TypeTranslate__c,var.ID1__c,docMap, 'Warning Code'));
             }
             if(var.Comment_Block_04__c != null){
                 wsWrapperList.add(new warningStringWrapper(var.Id,var.Name,var.Close_Date__c,var.Comment_Block_04__c,var.RecType__c,var.TypeTranslate__c,var.ID1__c,docMap, 'Comment'));
             }
             if(var.WARNING_05_CODE__c != '000-NONE' && var.WARNING_05_CODE__c != NULL && var.WARNING_05_CODE__c != '0-NONE'){
                 wsWrapperList.add(new warningStringWrapper(var.Id,var.Name,var.Close_Date__c,var.WARNING_05_CODE__c,var.RecType__c,var.TypeTranslate__c,var.ID1__c,docMap, 'Warning Code'));
             }
             if(var.Comment_Block_05__c != null){
                 wsWrapperList.add(new warningStringWrapper(var.Id,var.Name,var.Close_Date__c,var.Comment_Block_05__c,var.RecType__c,var.TypeTranslate__c,var.ID1__c,docMap, 'Comment'));
             }
             if(var.WARNING_06_CODE__c != '000-NONE' && var.WARNING_06_CODE__c != NULL && var.WARNING_06_CODE__c != '0-NONE'){
                 wsWrapperList.add(new warningStringWrapper(var.Id,var.Name,var.Close_Date__c,var.WARNING_06_CODE__c,var.RecType__c,var.TypeTranslate__c,var.ID1__c,docMap, 'Warning Code'));
             }
             if(var.Comment_Block_06__c != null){
                 wsWrapperList.add(new warningStringWrapper(var.Id,var.Name,var.Close_Date__c,var.Comment_Block_06__c,var.RecType__c,var.TypeTranslate__c,var.ID1__c,docMap, 'Comment'));
             }
             if(var.WARNING_07_CODE__c != '000-NONE' && var.WARNING_07_CODE__c != NULL && var.WARNING_07_CODE__c != '0-NONE'){
                 wsWrapperList.add(new warningStringWrapper(var.Id,var.Name,var.Close_Date__c,var.WARNING_07_CODE__c,var.RecType__c,var.TypeTranslate__c,var.ID1__c,docMap, 'Warning Code'));
             }
             if(var.Comment_Block_07__c != null){
                 wsWrapperList.add(new warningStringWrapper(var.Id,var.Name,var.Close_Date__c,var.Comment_Block_07__c,var.RecType__c,var.TypeTranslate__c,var.ID1__c,docMap, 'Comment'));
             }
             if(var.WARNING_08_CODE__c != '000-NONE' && var.WARNING_08_CODE__c != NULL && var.WARNING_08_CODE__c != '0-NONE'){
                 wsWrapperList.add(new warningStringWrapper(var.Id,var.Name,var.Close_Date__c,var.WARNING_08_CODE__c,var.RecType__c,var.TypeTranslate__c,var.ID1__c,docMap, 'Warning Code'));
             }
             if(var.Comment_Block_08__c != null){
                 wsWrapperList.add(new warningStringWrapper(var.Id,var.Name,var.Close_Date__c,var.Comment_Block_08__c,var.RecType__c,var.TypeTranslate__c,var.ID1__c,docMap, 'Comment'));
             }
             if(var.WARNING_09_CODE__c != '000-NONE' && var.WARNING_09_CODE__c != NULL && var.WARNING_09_CODE__c != '0-NONE'){
                 wsWrapperList.add(new warningStringWrapper(var.Id,var.Name,var.Close_Date__c,var.WARNING_09_CODE__c,var.RecType__c,var.TypeTranslate__c,var.ID1__c,docMap, 'Warning Code'));
             }
             if(var.Comment_Block_09__c != null){
                 wsWrapperList.add(new warningStringWrapper(var.Id,var.Name,var.Close_Date__c,var.Comment_Block_09__c,var.RecType__c,var.TypeTranslate__c,var.ID1__c,docMap, 'Comment'));
             }
             if(var.WARNING_10_CODE__c != '000-NONE' && var.WARNING_10_CODE__c != NULL && var.WARNING_10_CODE__c != '0-NONE'){
                 wsWrapperList.add(new warningStringWrapper(var.Id,var.Name,var.Close_Date__c,var.WARNING_10_CODE__c,var.RecType__c,var.TypeTranslate__c,var.ID1__c,docMap, 'Warning Code'));
             }
             if(var.Comment_Block_10__c != null){
                 wsWrapperList.add(new warningStringWrapper(var.Id,var.Name,var.Close_Date__c,var.Comment_Block_10__c,var.RecType__c,var.TypeTranslate__c,var.ID1__c,docMap, 'Comment'));
             }
             if(var.WARNING_11_CODE__c != '000-NONE' && var.WARNING_11_CODE__c != NULL && var.WARNING_11_CODE__c != '0-NONE'){
                 wsWrapperList.add(new warningStringWrapper(var.Id,var.Name,var.Close_Date__c,var.WARNING_11_CODE__c,var.RecType__c,var.TypeTranslate__c,var.ID1__c,docMap, 'Warning Code'));
             }
             if(var.Comment_Block_11__c != null){
                 wsWrapperList.add(new warningStringWrapper(var.Id,var.Name,var.Close_Date__c,var.Comment_Block_11__c,var.RecType__c,var.TypeTranslate__c,var.ID1__c,docMap, 'Comment'));
             }
             if(var.WARNING_12_CODE__c != '000-NONE' && var.WARNING_12_CODE__c != NULL && var.WARNING_12_CODE__c != '0-NONE'){
                 wsWrapperList.add(new warningStringWrapper(var.Id,var.Name,var.Close_Date__c,var.WARNING_12_CODE__c,var.RecType__c,var.TypeTranslate__c,var.ID1__c,docMap, 'Warning Code'));
             }
             if(var.Comment_Block_12__c != null){
                 wsWrapperList.add(new warningStringWrapper(var.Id,var.Name,var.Close_Date__c,var.Comment_Block_12__c,var.RecType__c,var.TypeTranslate__c,var.ID1__c,docMap, 'Comment'));
             }
             if(var.WARNING_13_CODE__c != '000-NONE' && var.WARNING_13_CODE__c != NULL && var.WARNING_13_CODE__c != '0-NONE'){
                 wsWrapperList.add(new warningStringWrapper(var.Id,var.Name,var.Close_Date__c,var.WARNING_13_CODE__c,var.RecType__c,var.TypeTranslate__c,var.ID1__c,docMap, 'Warning Code'));
             }
             if(var.Comment_Block_13__c != null){
                 wsWrapperList.add(new warningStringWrapper(var.Id,var.Name,var.Close_Date__c,var.Comment_Block_13__c,var.RecType__c,var.TypeTranslate__c,var.ID1__c,docMap, 'Comment'));
             }
             if(var.WARNING_14_CODE__c != '000-NONE' && var.WARNING_14_CODE__c != NULL && var.WARNING_14_CODE__c != '0-NONE'){
                 wsWrapperList.add(new warningStringWrapper(var.Id,var.Name,var.Close_Date__c,var.WARNING_14_CODE__c,var.RecType__c,var.TypeTranslate__c,var.ID1__c,docMap, 'Warning Code'));
             }
             if(var.Comment_Block_14__c != null){
                 wsWrapperList.add(new warningStringWrapper(var.Id,var.Name,var.Close_Date__c,var.Comment_Block_14__c,var.RecType__c,var.TypeTranslate__c,var.ID1__c,docMap, 'Comment'));
             }
             if(var.WARNING_15_CODE__c != '000-NONE' && var.WARNING_15_CODE__c != NULL && var.WARNING_15_CODE__c != '0-NONE'){
                 wsWrapperList.add(new warningStringWrapper(var.Id,var.Name,var.Close_Date__c,var.WARNING_15_CODE__c,var.RecType__c,var.TypeTranslate__c,var.ID1__c,docMap, 'Warning Code'));
             }
             if(var.Comment_Block_15__c != null){
                 wsWrapperList.add(new warningStringWrapper(var.Id,var.Name,var.Close_Date__c,var.Comment_Block_15__c,var.RecType__c,var.TypeTranslate__c,var.ID1__c,docMap, 'Comment'));
             }
             if(var.WARNING_16_CODE__c != '000-NONE' && var.WARNING_16_CODE__c != NULL && var.WARNING_16_CODE__c != '0-NONE'){
                 wsWrapperList.add(new warningStringWrapper(var.Id,var.Name,var.Close_Date__c,var.WARNING_16_CODE__c,var.RecType__c,var.TypeTranslate__c,var.ID1__c,docMap, 'Warning Code'));
             }
             if(var.Comment_Block_16__c != null){
                 wsWrapperList.add(new warningStringWrapper(var.Id,var.Name,var.Close_Date__c,var.Comment_Block_16__c,var.RecType__c,var.TypeTranslate__c,var.ID1__c,docMap, 'Comment'));
             }
             if(var.WARNING_17_CODE__c != '000-NONE' && var.WARNING_17_CODE__c != NULL && var.WARNING_17_CODE__c != '0-NONE'){
                 wsWrapperList.add(new warningStringWrapper(var.Id,var.Name,var.Close_Date__c,var.WARNING_17_CODE__c,var.RecType__c,var.TypeTranslate__c,var.ID1__c,docMap, 'Warning Code'));
             }
             if(var.Comment_Block_17__c != null){
                 wsWrapperList.add(new warningStringWrapper(var.Id,var.Name,var.Close_Date__c,var.Comment_Block_17__c,var.RecType__c,var.TypeTranslate__c,var.ID1__c,docMap, 'Comment'));
             }
             if(var.WARNING_18_CODE__c != '000-NONE' && var.WARNING_18_CODE__c != NULL && var.WARNING_18_CODE__c != '0-NONE'){
                 wsWrapperList.add(new warningStringWrapper(var.Id,var.Name,var.Close_Date__c,var.WARNING_18_CODE__c,var.RecType__c,var.TypeTranslate__c,var.ID1__c,docMap, 'Warning Code'));
             }
             if(var.Comment_Block_18__c != null){
                 wsWrapperList.add(new warningStringWrapper(var.Id,var.Name,var.Close_Date__c,var.Comment_Block_18__c,var.RecType__c,var.TypeTranslate__c,var.ID1__c,docMap, 'Comment'));
             }
             if(var.WARNING_19_CODE__c != '000-NONE' && var.WARNING_19_CODE__c != NULL && var.WARNING_19_CODE__c != '0-NONE'){
                 wsWrapperList.add(new warningStringWrapper(var.Id,var.Name,var.Close_Date__c,var.WARNING_19_CODE__c,var.RecType__c,var.TypeTranslate__c,var.ID1__c,docMap, 'Warning Code'));
             }
             if(var.Comment_Block_19__c != null){
                 wsWrapperList.add(new warningStringWrapper(var.Id,var.Name,var.Close_Date__c,var.Comment_Block_19__c,var.RecType__c,var.TypeTranslate__c,var.ID1__c,docMap, 'Comment'));
             }
             if(var.WARNING_20_CODE__c != '000-NONE' && var.WARNING_20_CODE__c != NULL && var.WARNING_20_CODE__c != '0-NONE'){
                 wsWrapperList.add(new warningStringWrapper(var.Id,var.Name,var.Close_Date__c,var.WARNING_20_CODE__c,var.RecType__c,var.TypeTranslate__c,var.ID1__c,docMap, 'Warning Code'));
             }
             if(var.Comment_Block_20__c != null){
                 wsWrapperList.add(new warningStringWrapper(var.Id,var.Name,var.Close_Date__c,var.Comment_Block_20__c,var.RecType__c,var.TypeTranslate__c,var.ID1__c,docMap, 'Comment'));
             }
         }
         system.debug(wsWrapperList);        
    }
    
    public class warningStringWrapper {
        public Id accId {get; set;}
        public String accNum {get; set;}
        public Date CloseDate {get; set;}
        public String WarningCode {get; set;}
        public String tpeTrans {get; set;}
        public String recTpe {get; set;} 
        public String shareNo {get;set;}
        public string imgUrl {get;set;}
        public String Descriptn {get;set;}
        
            public warningStringWrapper(Id id, String Name, Date Close_Date, String wc, String rt, String tt, String shrNo, map<string,id> docMap, String som) {
            accId = id;
            accNum = Name;
            CloseDate = Close_Date;
            WarningCode = wc;
            tpeTrans = tt;
            recTpe = rt;
            shareNo = shrNo;
            imgUrl = docMap.get(wc);
            Descriptn = som;
            system.debug(Name);
        }
    }
}