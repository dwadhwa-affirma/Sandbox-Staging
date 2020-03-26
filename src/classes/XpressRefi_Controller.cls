public class XpressRefi_Controller {
    
    @AuraEnabled
    public Id memberId {get;set;}
    public List<Account_Details__c> acList {get;set;}
    public List<Account_details__c> mortg {get;set;}
    public List<String> loanlist {get;set;}
    public Boolean loan{get; set;}
    public String SelectedLoan{get;set;}
    public Xpress_Refi__c xprs {get; set;}
    public String currentRecordId {get;set;}
    public List<Xpress_Refi__c> ListXpressToInsert = new List<Xpress_Refi__c>();
    
    //public Xpress_Refi__c xprs = new Xpress_Refi__c();
   
    public XpressRefi_Controller(ApexPages.StandardController controller){
        
        currentRecordId  = ApexPages.CurrentPage().getparameters().get('MemberId');
        system.debug('currentRecordId'+currentRecordId);
        memberId = controller.getRecord().Id; // getting the id of the current member
        Set<String> NameSet = new Set<String>();
        List<Account_Details__c> accList = new List<Account_Details__c>();
    
        List<Person_Account__c> prsn = [SELECT Id, Account_Number__c, Account_Number__r.RecType__c,
                                        TypeTranslate__c, Account_Number__r.Name FROM Person_Account__c WHERE PersonID__c =:currentRecordId];
        system.debug('prsn'+prsn);
        if(prsn.size()>0){
            for(Person_Account__c p: prsn){
              
                 NameSet.add(p.Account_Number__r.Name);              
            }
        }
        // Associated member accounts
        acList = [SELECT Id,  Name,  RecType__c,  TypeTranslate__c, Brand__c,  Loan_Number__c, Mortgage_Name_1__c, Mortgage_Name_2__c,
                              Emp_Available_Balance__c, Available_Balance__c FROM Account_Details__c WHERE Name IN :NameSet and TypeTranslate__c='MORTGAGE'];
                                                    
   		system.debug('acList'+acList);
        /* if(acList.size()>0){
            loan = True;
        }*/
        loan=TRUE;
    }
    
     
    
    public void SelectLoan(){
        SelectedLoan = System.currentPageReference().getParameters().get('acid');
        system.debug(SelectedLoan);
        system.debug('selected  loan ++'+ SelectedLoan);
        //UpdateXprs(SelectedLoan);
          mortg = [SELECT Id,  Name,  RecType__c,  TypeTranslate__c, Brand__c,  Loan_Number__c, Mortgage_Name_1__c, Mortgage_Name_2__c,
                              Emp_Available_Balance__c, Available_Balance__c, Balance__c, PROPERTY_ADDRESS__c, Property_City__c,
                   Property_State__c, Property_Zip__c  FROM Account_Details__c WHERE id =:SelectedLoan limit 1]; 
                   
        for(Account_Details__c a : mortg){
        	
        	xprs = new Xpress_Refi__c();
        	xprs.Loan_Number__c = a.Loan_Number__c;
        	xprs.Borrower_1_Name__c = a.Mortgage_Name_1__c;
        	xprs.Borrower_2_Name__c = a.Mortgage_Name_2__c;
        	xprs.Property_Address__c = a.PROPERTY_ADDRESS__c;
        	xprs.City__c = a.Property_City__c;
        	if(a.Property_Zip__c != null)
        		xprs.Zip_Code__c = Decimal.valueOf(a.Property_Zip__c);
        	xprs.State__c = a.Property_State__c;
        	//xprs.Member_Phone__c =
        	//xprs.Member_Email__c =
        	//xprs.Mailing_address_if_different__c =
        	xprs.Current_Balance__c = a.Available_Balance__c;
        	//xprs.Current_Principal_and_Interest_Payment__c =
        }
        
       
       // xprs  = [select id, Name,City__c,State__c,Zip_Code__c,Member_Number__c,Loan_Number__c,Borrower_1_Name__c,Borrower_2_Name__c,Member_Phone__c,Member_Email__c,
       //           Property_Address__c,Mailing_address_if_different__c from Xpress_Refi__c where Member_Number__r.id =:SelectedLoan];
        System.debug('test'+xprs);
        System.debug('selected mortgage +++ '+mortg[0].name);
        
    }
    
    
                
    public void UpdateXprs(String SelectedLoan){
    
        Account_details__c mort = new Account_details__c (); 
       // Xpress_Refi__c xprs = new Xpress_Refi__c();
        mort = [SELECT Id,  Name,  RecType__c,  TypeTranslate__c, Brand__c,  Loan_Number__c, Mortgage_Name_1__c, Mortgage_Name_2__c,
                      Emp_Available_Balance__c, Available_Balance__c, Balance__c, PROPERTY_ADDRESS__c, Property_City__c,
           Property_State__c, Property_Zip__c  FROM Account_Details__c WHERE id =:SelectedLoan limit 1];
        System.debug('selected mort +++ '+ mort.Loan_Number__c);
        
      //  xprs.Loan_Number__c = mort.Loan_Number__c;
        System.debug('selected xprs +++ '+ xprs.Loan_Number__c);
        
        //insert xprs;
         
        /*  mortg = [SELECT Id,  Name,  RecType__c,  TypeTranslate__c, Brand__c,  Loan_Number__c, Mortgage_Name_1__c, Mortgage_Name_2__c,
                      Emp_Available_Balance__c, Available_Balance__c, Balance__c, PROPERTY_ADDRESS__c, Property_City__c, Property_State__c, Property_Zip__c  FROM Account_Details__c WHERE id =:SelectedLoan limit 1];
        System.debug('selected mortgage +++ '+mortg[0].name);
        xprs.Borrower_1_Name__c = mortg[0].Mortgage_Name_1__c;
        xprs.Borrower_2_Name__c = mortg[0].Mortgage_Name_2__c;
        xprs.Current_Balance__c = mortg[0].Balance__c;
        xprs.Loan_Number__c = mortg[0].Loan_Number__c;
        xprs.Property_Address__c= mortg[0].PROPERTY_ADDRESS__c;
        xprs.Loan_Number__c = mortg[0].Loan_Number__c;
        xprs.Zip_Code__c = integer.valueof(mortg[0].Property_Zip__c);
        xprs.Member_Number__c = mortg[0].Name;

        */
        
    }
    
    public PageReference save(){
    	
    	
    	Xpress_Refi__c xprs1 = new Xpress_Refi__c();
    	xprs1.Loan_Number__c = xprs.Loan_Number__c;
    	xprs1.Borrower_1_Name__c = xprs.Borrower_1_Name__c;
    	xprs1.Borrower_2_Name__c = xprs.Borrower_2_Name__c;
    	xprs1.Property_Address__c = xprs.Property_Address__c;
    	xprs1.City__c = xprs.City__c;
    	xprs1.Zip_Code__c = xprs.Zip_Code__c;
    	xprs1.State__c = xprs.State__c;
    	//xprs1.Member_Phone__c =
    	//xprs1.Member_Email__c =
    	//xprs1.Mailing_address_if_different__c =
    	xprs1.Current_Balance__c = xprs.Current_Balance__c;
    	//xprs1.Current_Principal_and_Interest_Payment__c =
    	xprs1.Current_Loan_Program__c = 'Test';
    	xprs1.Rate_Sheet_Date__c = System.Today();
    	ListXpressToInsert.add(xprs1);
       
        if(ListXpressToInsert.size() > 0){
        	
        	insert ListXpressToInsert;	
        }
        else{
        	ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please enter values'));
	    	return null;
		} 
        
        	
    	return null;
    }
    
  }