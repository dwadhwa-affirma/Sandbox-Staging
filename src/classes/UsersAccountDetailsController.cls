public class UsersAccountDetailsController {   
    public string accId;
    public list<case> caseList{get;set;}
    public list<Case> caseList1{get;set;}
    public Map<String, list<CaseComment>> mccomm{get;set;}
    public Map<String, list<Task>> tsks{get;set;}
    public list<CaseComment> caseCommentList{get;set;}
    public list<Task> tskList{get;set;}
    public list<Account_Details__c> accList{get;set;}
    public list<Person_Account__c> ContactList{get;set;}
    public list<warningStringWrapper> wsWrapperList{get;set;}
    public Map<String, Id> cnum_by_id1{get;set;}
    public Map<String, String> cnum_by_id2{get;set;}
    public list<document> docList {get;set;}
    public map<String, Id> docMap;
    public Map<String, String> cnum_by_id3{get;set;}
    public Map<String, String> cnum_by_id4{get;set;}
    public Map<String, String> cnum_by_id5{get;set;}
    public Map<String, String> cnum_by_id6{get;set;}
    public Map<String, String> cnum_by_id7{get;set;}
    public list<Account_Details__c> cardList{get;set;}
    public boolean CaseComentComments {get;set;}
        public boolean TaskCommentsShow {get;set;}
 public   List<AccountList360> listAccountList360 {get;set;}
    
    public UsersAccountDetailsController(ApexPages.StandardController controller){
        //this.cRec = (Case)Controller.getRecord();
        CaseComentComments = false;
        TaskCommentsShow = false;
        accId = System.currentPageReference().getParameters().get('Id');
        system.debug('account say person id....'+accID);
        if(accId!=NULL || accId!=''){
            personAccounts(accId);
            
        }else{
            
        }
    }
    
    public void personAccounts(string accId){
        list<Person_Account__c> paList = new list<Person_Account__c>();
            paList = [SELECT Id,
                             Account_Number__c, Account_Number__r.RecType__c, Account_Number__r.Name,TypeTranslate__c FROM Person_Account__c WHERE PersonID__c =:accId];
        accountDetails(paList);
       // ContactDetails(paList);
        warningCodeDetails(paList);     
    }
    
    public class AccountList360
    {
    	public string Id {get;set;}
    	public string Name {get;set;}
    	public string RecType {get;set;}
    	public string TypeTranslate {get;set;}
    	public string ID1 {get;set;}
    	
		public string Brand {get;set;}
    	public string Combined_Account_ID {get;set;}
    	public string Loan_Number {get;set;}
    	public Date Close_Date {get;set;}
    	public string Card_Number_Last_4_Digits {get;set;}
    	public Date OPEN_DATE {get;set;}
    	public Date  Expiration_Date {get;set;}
    	public date Issue_Date {get;set;}
    	public string Emp_Available_Balance {get;set;}
    	public decimal Available_Balance {get;set;}
    	public string Emp_Balance {get;set;}
    	
    	public decimal Balance {get;set;}
    	public string Relationship {get;set;}
    	
    	
    }
    
   public void accountDetails(list<Person_Account__c> paList){
        set<String> accountNumberSet = new set<String>();
        set<Id> accIdset = new set<Id>();
        Map<string,string> listRelationships = new  Map<string,string>(); 
        Map<string,string> listRelationshipsName = new  Map<string,string>(); 
        set<String> acctypeSet = new set<String>();
        for(Person_Account__c var: paList){
            accountNumberSet.add(var.Account_Number__r.Name);
            acctypeSet.add(var.Account_Number__r.RecType__c);
            accIdSet.add(var.Account_Number__c);
            listRelationships.put(var.Account_Number__c,var.TypeTranslate__c);
			listRelationshipsName.put(var.Account_Number__r.Name,var.TypeTranslate__c);
            
        }
        accList = new list<Account_Details__c>();
        list<Account_Details__c> accList1 = new list<Account_Details__c>();
        if(acctypeSet.contains('ACCT')){
            accList1 = [SELECT Id,
                              Name,
                              RecType__c,
                              TypeTranslate__c,
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
                              Emp_Available_Balance__c,
                              Available_Balance__c FROM Account_Details__c WHERE Name IN:accountNumberSet and RecType__c != 'CARD'];
        }else{
            accList1 = [SELECT Id,
                              Name,
                              RecType__c,
                              TypeTranslate__c,
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
                              Emp_Available_Balance__c,
                              Available_Balance__c FROM Account_Details__c Where Id IN:accIdSet and RecType__c != 'CARD'];
        }
         listAccountList360  = new  List<AccountList360> ();
        for(Account_Details__c acc : accList1)
        {
        	AccountList360 obj = new AccountList360();
        	obj.Id = acc.Id;
        	obj.Name = acc.Name;
			obj.RecType = acc.RecType__c;
			obj.TypeTranslate = acc.TypeTranslate__c;
			obj.Balance = acc.Balance__c;
			obj.ID1 = acc.ID1__c;
			obj.Combined_Account_ID = acc.Combined_Account_ID__c;
			
			obj.Card_Number_Last_4_Digits = acc.Card_Number_Last_4_Digits__c;
			obj.Combined_Account_ID = acc.Combined_Account_ID__c;
			obj.Loan_Number = acc.Loan_Number__c;
			obj.Brand = acc.Brand__c;
			obj.Loan_Number = acc.Loan_Number__c;
			obj.Close_Date = acc.Close_Date__c;
			obj.Expiration_Date = acc.Expiration_Date__c;
			obj.OPEN_DATE = acc.OPEN_DATE__c;
			obj.Issue_Date = acc.Issue_Date__c;
			obj.Emp_Balance = acc.Emp_Balance__c;
			obj.Emp_Available_Balance = acc.Emp_Available_Balance__c;
			obj.Available_Balance = acc.Available_Balance__c;
			if(acctypeSet.contains('ACCT')){
				obj.Relationship = listRelationshipsName.get(obj.Name);			
				
			}
			else
			{
				obj.Relationship = listRelationships.get(obj.Id);
			}
			
			
			if(obj.Relationship != null && !obj.Relationship.contains('Beneficiary'))
			{
				listAccountList360.add(obj);	
				accList.add(acc);
			}	
        }
        
        
        set<String> accountNumberSetWOBeneficiary = new set<String>();
        set<String> accIdSetWOBeneficiary = new set<String>();
        
        
        for(AccountList360 item : listAccountList360){
        	accountNumberSetWOBeneficiary.add(item.Name);
        	accIdSetWOBeneficiary.add(item.id);
        }
        
                for(AccountList360 item : listAccountList360){
        	
        }
        
       system.debug('accountNumberSet ---  '  + accountNumberSet);
       cardList = new list<Account_Details__c>();
       if(acctypeSet.contains('ACCT')){
            cardList = [SELECT Id,
                              Name,
                              RecType__c,
                              TypeTranslate__c,
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
                              Card_Name__c FROM Account_Details__c Where Name IN:accountNumberSetWOBeneficiary and RecType__c = 'CARD'];
        }else{
            cardList = [SELECT Id,
                              Name,
                              RecType__c,
                              TypeTranslate__c,
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
                              Card_Name__c FROM Account_Details__c Where Id IN:accIdSetWOBeneficiary and RecType__c = 'CARD'];
        }
        List<string> listCard = new List<string>();
        for(Account_Details__c card : cardList){
			List<AggregateResult> countResult =[select Count(Id) from CFCU_Mastercard_Alerts__c  where Card_Number__c =: card.Card_Number_Last_4_Digits__c and Member_Number__c =: card.Name ];
			 integer countCardRecords = (Integer)  countResult [0].get('expr0');
			 if(countCardRecords > 0)
			 {
           		card.Onboarded__c = true;
			 }
			 else
			 {
			 card.Onboarded__c = false;	
			 
			 }
       } 
    /*   Set<String> clsDate = new Set<String>();
       for(Account_Details__c accDl : accList){
           clsDate.add(String.valueOf(accDl.Close_Date__c));
       } */
        ContactDetails(accList1, accList);
       // warningCodeDetails(paList);
    } 
    
    public void warningCodeDetails(list<Person_Account__c> paList){
       /* set<Id> paIds = new set<Id>();
        for(Person_Account__c var: paList){
            paIds.add(var.Account_Number__c);
        } */
        
        set<String> accountNumberSet = new set<String>();
        set<Id> accIdset = new set<Id>();
        set<String> acctypeSet = new set<String>();
        for(Person_Account__c var: paList){
            accountNumberSet.add(var.Account_Number__r.Name);
            acctypeSet.add(var.Account_Number__r.RecType__c);
            accIdSet.add(var.Account_Number__c);
        }
        
        
        
        list<Account_Details__c> accountDetailsList = new list<Account_Details__c>();
        if(acctypeSet.contains('ACCT')){
        accountDetailsList = [Select Id,
                                     Name,
                                     Close_Date__c,
                                     RecType__c,
                                     TypeTranslate__c,
                                     ID1__c,
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
                                     Comment_Block_20__c FROM Account_Details__c Where Name IN:accountNumberSet];
        }else {
        accountDetailsList = [Select Id,
                                     Name,
                                     Close_Date__c,
                                     RecType__c,
                                     TypeTranslate__c,
                                     ID1__c,
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
                                     Comment_Block_20__c FROM Account_Details__c Where Id IN:accIdSet];
        }           
            
        system.debug(accountDetailsList); 
        
        docList =[SELECT Id,
                      Name FROM Document];
        docMap = new map<string,Id>();
        for(Document d: docList){
            docMap.put(d.Name,d.Id);
        }
                                    
         wsWrapperList = new list<warningStringWrapper>();
                                    
         for(Account_Details__c var: accountDetailsList){
             boolean found = false;
             for(AccountList360 accountQDetails : listAccountList360)
             {
             	if(accountQDetails.id == var.id)
             	{
             		found = true;
             	}
             }
             if(found)
             {
	             if(var.WARNING_01_CODE__c != '000-NONE' && var.WARNING_01_CODE__c != NULL && var.WARNING_01_CODE__c != '0-NONE'){
	                 wsWrapperList.add(new warningStringWrapper(var.Id,var.Name,var.Close_Date__c,var.WARNING_01_CODE__c,var.RecType__c,var.TypeTranslate__c, docMap, var.ID1__c, 'Warning Code'));
	             }
	             if(var.Comment_Block_01__c != null){
	                 wsWrapperList.add(new warningStringWrapper(var.Id,var.Name,var.Close_Date__c,var.Comment_Block_01__c,var.RecType__c,var.TypeTranslate__c, docMap, var.ID1__c, 'Comment'));
	             }
	             if(var.WARNING_02_CODE__c != '000-NONE' && var.WARNING_02_CODE__c != NULL && var.WARNING_02_CODE__c != '0-NONE'){
	                 wsWrapperList.add(new warningStringWrapper(var.Id,var.Name,var.Close_Date__c,var.WARNING_02_CODE__c,var.RecType__c,var.TypeTranslate__c, docMap, var.ID1__c, 'Warning Code'));
	             }
	             if(var.Comment_Block_02__c != null){
	                 wsWrapperList.add(new warningStringWrapper(var.Id,var.Name,var.Close_Date__c,var.Comment_Block_02__c,var.RecType__c,var.TypeTranslate__c, docMap, var.ID1__c, 'Comment'));
	             }
	             if(var.WARNING_03_CODE__c != '000-NONE' && var.WARNING_03_CODE__c != NULL && var.WARNING_03_CODE__c != '0-NONE'){
	                 wsWrapperList.add(new warningStringWrapper(var.Id,var.Name,var.Close_Date__c,var.WARNING_03_CODE__c,var.RecType__c,var.TypeTranslate__c, docMap, var.ID1__c, 'Warning Code'));
	             }
	             if(var.Comment_Block_03__c != null){
	                 wsWrapperList.add(new warningStringWrapper(var.Id,var.Name,var.Close_Date__c,var.Comment_Block_03__c,var.RecType__c,var.TypeTranslate__c, docMap, var.ID1__c, 'Comment'));
	             }
	             if(var.WARNING_04_CODE__c != '000-NONE' && var.WARNING_04_CODE__c != NULL && var.WARNING_04_CODE__c != '0-NONE'){
	                 wsWrapperList.add(new warningStringWrapper(var.Id,var.Name,var.Close_Date__c,var.WARNING_04_CODE__c,var.RecType__c,var.TypeTranslate__c, docMap, var.ID1__c, 'Warning Code'));
	             }
	             if(var.Comment_Block_04__c != null){
	                 wsWrapperList.add(new warningStringWrapper(var.Id,var.Name,var.Close_Date__c,var.Comment_Block_04__c,var.RecType__c,var.TypeTranslate__c, docMap, var.ID1__c, 'Comment'));
	             }
	             if(var.WARNING_05_CODE__c != '000-NONE' && var.WARNING_05_CODE__c != NULL && var.WARNING_05_CODE__c != '0-NONE'){
	                 wsWrapperList.add(new warningStringWrapper(var.Id,var.Name,var.Close_Date__c,var.WARNING_05_CODE__c,var.RecType__c,var.TypeTranslate__c, docMap, var.ID1__c, 'Warning Code'));
	             }
	             if(var.Comment_Block_05__c != null){
	                 wsWrapperList.add(new warningStringWrapper(var.Id,var.Name,var.Close_Date__c,var.Comment_Block_05__c,var.RecType__c,var.TypeTranslate__c, docMap, var.ID1__c, 'Comment'));
	             }
	             if(var.WARNING_06_CODE__c != '000-NONE' && var.WARNING_06_CODE__c != NULL && var.WARNING_06_CODE__c != '0-NONE'){
	                 wsWrapperList.add(new warningStringWrapper(var.Id,var.Name,var.Close_Date__c,var.WARNING_06_CODE__c,var.RecType__c,var.TypeTranslate__c, docMap, var.ID1__c, 'Warning Code'));
	             }
	             if(var.Comment_Block_06__c != null){
	                 wsWrapperList.add(new warningStringWrapper(var.Id,var.Name,var.Close_Date__c,var.Comment_Block_06__c,var.RecType__c,var.TypeTranslate__c, docMap, var.ID1__c, 'Comment'));
	             }
	             if(var.WARNING_07_CODE__c != '000-NONE' && var.WARNING_07_CODE__c != NULL && var.WARNING_07_CODE__c != '0-NONE'){
	                 wsWrapperList.add(new warningStringWrapper(var.Id,var.Name,var.Close_Date__c,var.WARNING_07_CODE__c,var.RecType__c,var.TypeTranslate__c, docMap, var.ID1__c, 'Warning Code'));
	             }
	             if(var.Comment_Block_07__c != null){
	                 wsWrapperList.add(new warningStringWrapper(var.Id,var.Name,var.Close_Date__c,var.Comment_Block_07__c,var.RecType__c,var.TypeTranslate__c, docMap, var.ID1__c, 'Comment'));
	             }
	             if(var.WARNING_08_CODE__c != '000-NONE' && var.WARNING_08_CODE__c != NULL && var.WARNING_08_CODE__c != '0-NONE'){
	                 wsWrapperList.add(new warningStringWrapper(var.Id,var.Name,var.Close_Date__c,var.WARNING_08_CODE__c,var.RecType__c,var.TypeTranslate__c, docMap, var.ID1__c, 'Warning Code'));
	             }
	             if(var.Comment_Block_08__c != null){
	                 wsWrapperList.add(new warningStringWrapper(var.Id,var.Name,var.Close_Date__c,var.Comment_Block_08__c,var.RecType__c,var.TypeTranslate__c, docMap, var.ID1__c, 'Comment'));
	             }
	             if(var.WARNING_09_CODE__c != '000-NONE' && var.WARNING_09_CODE__c != NULL && var.WARNING_09_CODE__c != '0-NONE'){
	                 wsWrapperList.add(new warningStringWrapper(var.Id,var.Name,var.Close_Date__c,var.WARNING_09_CODE__c,var.RecType__c,var.TypeTranslate__c, docMap, var.ID1__c, 'Warning Code'));
	             }
	             if(var.Comment_Block_09__c != null){
	                 wsWrapperList.add(new warningStringWrapper(var.Id,var.Name,var.Close_Date__c,var.Comment_Block_09__c,var.RecType__c,var.TypeTranslate__c, docMap, var.ID1__c, 'Comment'));
	             }
	             if(var.WARNING_10_CODE__c != '000-NONE' && var.WARNING_10_CODE__c != NULL && var.WARNING_10_CODE__c != '0-NONE'){
	                 wsWrapperList.add(new warningStringWrapper(var.Id,var.Name,var.Close_Date__c,var.WARNING_10_CODE__c,var.RecType__c,var.TypeTranslate__c, docMap, var.ID1__c, 'Warning Code'));
	             }
	             if(var.Comment_Block_10__c != null){
	                 wsWrapperList.add(new warningStringWrapper(var.Id,var.Name,var.Close_Date__c,var.Comment_Block_10__c,var.RecType__c,var.TypeTranslate__c, docMap, var.ID1__c, 'Comment'));
	             }
	             if(var.WARNING_11_CODE__c != '000-NONE' && var.WARNING_11_CODE__c != NULL && var.WARNING_11_CODE__c != '0-NONE'){
	                 wsWrapperList.add(new warningStringWrapper(var.Id,var.Name,var.Close_Date__c,var.WARNING_11_CODE__c,var.RecType__c,var.TypeTranslate__c, docMap, var.ID1__c, 'Warning Code'));
	             }
	             if(var.Comment_Block_11__c != null){
	                 wsWrapperList.add(new warningStringWrapper(var.Id,var.Name,var.Close_Date__c,var.Comment_Block_11__c,var.RecType__c,var.TypeTranslate__c, docMap, var.ID1__c, 'Comment'));
	             }
	             if(var.WARNING_12_CODE__c != '000-NONE' && var.WARNING_12_CODE__c != NULL && var.WARNING_12_CODE__c != '0-NONE'){
	                 wsWrapperList.add(new warningStringWrapper(var.Id,var.Name,var.Close_Date__c,var.WARNING_12_CODE__c,var.RecType__c,var.TypeTranslate__c, docMap, var.ID1__c, 'Warning Code'));
	             }
	             if(var.Comment_Block_12__c != null){
	                 wsWrapperList.add(new warningStringWrapper(var.Id,var.Name,var.Close_Date__c,var.Comment_Block_12__c,var.RecType__c,var.TypeTranslate__c, docMap, var.ID1__c, 'Comment'));
	             }
	             if(var.WARNING_13_CODE__c != '000-NONE' && var.WARNING_13_CODE__c != NULL && var.WARNING_13_CODE__c != '0-NONE'){
	                 wsWrapperList.add(new warningStringWrapper(var.Id,var.Name,var.Close_Date__c,var.WARNING_13_CODE__c,var.RecType__c,var.TypeTranslate__c, docMap, var.ID1__c, 'Warning Code'));
	             }
	             if(var.Comment_Block_13__c != null){
	                 wsWrapperList.add(new warningStringWrapper(var.Id,var.Name,var.Close_Date__c,var.Comment_Block_13__c,var.RecType__c,var.TypeTranslate__c, docMap, var.ID1__c, 'Comment'));
	             }
	             if(var.WARNING_14_CODE__c != '000-NONE' && var.WARNING_14_CODE__c != NULL && var.WARNING_14_CODE__c != '0-NONE'){
	                 wsWrapperList.add(new warningStringWrapper(var.Id,var.Name,var.Close_Date__c,var.WARNING_14_CODE__c,var.RecType__c,var.TypeTranslate__c, docMap, var.ID1__c, 'Warning Code'));
	             }
	             if(var.Comment_Block_14__c != null){
	                 wsWrapperList.add(new warningStringWrapper(var.Id,var.Name,var.Close_Date__c,var.Comment_Block_14__c,var.RecType__c,var.TypeTranslate__c, docMap, var.ID1__c, 'Comment'));
	             }
	             if(var.WARNING_15_CODE__c != '000-NONE' && var.WARNING_15_CODE__c != NULL && var.WARNING_15_CODE__c != '0-NONE'){
	                 wsWrapperList.add(new warningStringWrapper(var.Id,var.Name,var.Close_Date__c,var.WARNING_15_CODE__c,var.RecType__c,var.TypeTranslate__c, docMap, var.ID1__c, 'Warning Code'));
	             }
	             if(var.Comment_Block_15__c != null){
	                 wsWrapperList.add(new warningStringWrapper(var.Id,var.Name,var.Close_Date__c,var.Comment_Block_15__c,var.RecType__c,var.TypeTranslate__c, docMap, var.ID1__c, 'Comment'));
	             }
	             if(var.WARNING_16_CODE__c != '000-NONE' && var.WARNING_16_CODE__c != NULL && var.WARNING_16_CODE__c != '0-NONE'){
	                 wsWrapperList.add(new warningStringWrapper(var.Id,var.Name,var.Close_Date__c,var.WARNING_16_CODE__c,var.RecType__c,var.TypeTranslate__c, docMap, var.ID1__c, 'Warning Code'));
	             }
	             if(var.Comment_Block_16__c != null){
	                 wsWrapperList.add(new warningStringWrapper(var.Id,var.Name,var.Close_Date__c,var.Comment_Block_16__c,var.RecType__c,var.TypeTranslate__c, docMap, var.ID1__c, 'Comment'));
	             }
	             if(var.WARNING_17_CODE__c != '000-NONE' && var.WARNING_17_CODE__c != NULL && var.WARNING_17_CODE__c != '0-NONE'){
	                 wsWrapperList.add(new warningStringWrapper(var.Id,var.Name,var.Close_Date__c,var.WARNING_17_CODE__c,var.RecType__c,var.TypeTranslate__c, docMap, var.ID1__c, 'Warning Code'));
	             }
	             if(var.Comment_Block_17__c != null){
	                 wsWrapperList.add(new warningStringWrapper(var.Id,var.Name,var.Close_Date__c,var.Comment_Block_17__c,var.RecType__c,var.TypeTranslate__c, docMap, var.ID1__c, 'Comment'));
	             }
	             if(var.WARNING_18_CODE__c != '000-NONE' && var.WARNING_18_CODE__c != NULL && var.WARNING_18_CODE__c != '0-NONE'){
	                 wsWrapperList.add(new warningStringWrapper(var.Id,var.Name,var.Close_Date__c,var.WARNING_18_CODE__c,var.RecType__c,var.TypeTranslate__c, docMap, var.ID1__c, 'Warning Code'));
	             }
	             if(var.Comment_Block_18__c != null){
	                 wsWrapperList.add(new warningStringWrapper(var.Id,var.Name,var.Close_Date__c,var.Comment_Block_18__c,var.RecType__c,var.TypeTranslate__c, docMap, var.ID1__c, 'Comment'));
	             }
	             if(var.WARNING_19_CODE__c != '000-NONE' && var.WARNING_19_CODE__c != NULL && var.WARNING_19_CODE__c != '0-NONE'){
	                 wsWrapperList.add(new warningStringWrapper(var.Id,var.Name,var.Close_Date__c,var.WARNING_19_CODE__c,var.RecType__c,var.TypeTranslate__c, docMap, var.ID1__c, 'Warning Code'));
	             }
	             if(var.Comment_Block_19__c != null){
	                 wsWrapperList.add(new warningStringWrapper(var.Id,var.Name,var.Close_Date__c,var.Comment_Block_19__c,var.RecType__c,var.TypeTranslate__c, docMap, var.ID1__c, 'Comment'));
	             }
	             if(var.WARNING_20_CODE__c != '000-NONE' && var.WARNING_20_CODE__c != NULL && var.WARNING_20_CODE__c != '0-NONE'){
	                 wsWrapperList.add(new warningStringWrapper(var.Id,var.Name,var.Close_Date__c,var.WARNING_20_CODE__c,var.RecType__c,var.TypeTranslate__c, docMap, var.ID1__c, 'Warning Code'));
	             }
	             if(var.Comment_Block_20__c != null){
	                 wsWrapperList.add(new warningStringWrapper(var.Id,var.Name,var.Close_Date__c,var.Comment_Block_20__c,var.RecType__c,var.TypeTranslate__c, docMap, var.ID1__c, 'Comment'));
	             }
             }
         }
         system.debug(wsWrapperList);
    }
    
    public void ContactDetails(list<Account_Details__c> accList1, list<Account_Details__c> accList){
        set<String> accName = new Set<String>();
        set<String> accNameWoBeneficiary = new Set<String>();
        
        for(Account_Details__c var: accList1){
            accName.add(var.Name);
        }
        for(Account_Details__c var: accList){
            accNameWoBeneficiary.add(var.Name);
        }
      Id testId = System.currentPageReference().getParameters().get('Id');
      
      ContactList = new list<Person_Account__c>();
       list<Person_Account__c> ContactList1 = [Select Id,
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
                              Account_Number__r.Brand__c From Person_Account__c WHERE Account_Number__r.Name IN :accNameWoBeneficiary /*AND personId__c != :testId*/];
                              
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
                              Account_Number__r.Brand__c From Person_Account__c WHERE Account_Number__r.Name IN :accName AND personId__c != :testId];
        
        caseDetails(ContactList1);
    }
    
    
    public void caseDetails(list<Person_Account__c> paList1){
        set<Id> accIds = new set<Id>();
        for(Person_Account__c var: paList1){
			 boolean found = false;
             for(AccountList360 accountQDetails : listAccountList360)
             {
             	if(accountQDetails.id == var.Account_Number__c)
             	{
             		found = true;
             	}
             }
            accIds.add(var.Account_Number__c);
        }
        
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
                           Origin,
                           Parent.CaseNumber,
                           
                           ClosedDate FROM case WHERE Account_Number__c IN :accIds AND Status != 'Closed'];
       
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
                           Parent.CaseNumber,
                           
                           ClosedDate FROM case WHERE Account_Number__c IN :accIds AND Status = 'Closed'];


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
        CaseComentComments = !mccomm.IsEmpty();
        
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
          TaskCommentsShow = !tsks.IsEmpty();
        
    }
    
        public class warningStringWrapper {
        public Id accId {get; set;}
        public String accNum {get; set;}
        public Date CloseDate {get; set;}
        public String WarningCode {get; set;}
        public String tpeTrans {get; set;}
        public String recTpe {get; set;}
        public string imgUrl {get;set;}
        public String shareNo {get;set;}
       // public String Commts {get;set;}
        public String Descriptn {get;set;}
        
            public warningStringWrapper(Id id, String Name, Date Close_Date, String wc, String rt, String tt, map<string,id> docMap, String shrNo, String som) {
            accId = id;
            accNum = Name;
            CloseDate = Close_Date;
            WarningCode = wc;
            tpeTrans = tt;
            recTpe = rt;
            imgUrl = docMap.get(wc);
            shareNo = shrNo;
           // Commts = cmts;
            Descriptn = som;
            system.debug(Name);
            system.debug('docMap is:::'+imgUrl);              
        }
    }
}