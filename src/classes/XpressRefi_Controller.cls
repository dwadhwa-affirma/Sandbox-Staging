public class XpressRefi_Controller {
     @AuraEnabled
    public Id memberId       {get;set;}
    public List<Account_Details__c> acList {get;set;}
    public List<Account_details__c> mortg {get;set;}
    public List<String> loanlist {get;set;}
    public Boolean loan{get; set;}
    public String SelectedLoan{get;set;}
    public Xpress_Refi__c xprs {get; set;}
    
    //public Xpress_Refi__c xprs = new Xpress_Refi__c();
   
public XpressRefi_Controller(ApexPages.StandardController controller)
{
 memberId = controller.getRecord().Id; // getting the id of the current member

    
    Set<String> NameSet = new Set<String>();
    List<Account_Details__c> accList = new List<Account_Details__c>();
    
    List<Person_Account__c> prsn = [SELECT Id, Account_Number__c, Account_Number__r.RecType__c,
        TypeTranslate__c, Account_Number__r.Name FROM Person_Account__c WHERE PersonID__c =:'001j000000y6mu2AAA'];
    
      if(prsn.size()>0){
          for(Person_Account__c p: prsn){
              
                 NameSet.add(p.Account_Number__r.Name);              
          }
         }
    // Associated member accounts
    acList = [SELECT Id,  Name,  RecType__c,  TypeTranslate__c, Brand__c,  Loan_Number__c, Mortgage_Name_1__c, Mortgage_Name_2__c,
                              Emp_Available_Balance__c, Available_Balance__c FROM Account_Details__c WHERE Name IN :NameSet and TypeTranslate__c='MORTGAGE'];    
   
    
  /*  if(SelectedLoan!=null){
        mortg = [SELECT Id,  Name,  RecType__c,  TypeTranslate__c, Brand__c,  Loan_Number__c, Mortgage_Name_1__c, Mortgage_Name_2__c,
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
        
    } */
    
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
        
        System.debug('selected mortgage +++ '+mortg[0].name);
        
    }
    
    
   				
			public void UpdateXprs(String SelectedLoan)
			{
				Account_details__c mort = new Account_details__c (); 
               // Xpress_Refi__c xprs = new Xpress_Refi__c();
				mort = [SELECT Id,  Name,  RecType__c,  TypeTranslate__c, Brand__c,  Loan_Number__c, Mortgage_Name_1__c, Mortgage_Name_2__c,
                              Emp_Available_Balance__c, Available_Balance__c, Balance__c, PROPERTY_ADDRESS__c, Property_City__c,
                   Property_State__c, Property_Zip__c  FROM Account_Details__c WHERE id =:SelectedLoan limit 1];
				System.debug('selected mort +++ '+ mort.Loan_Number__c);
				
              //  xprs.Loan_Number__c = mort.Loan_Number__c;
                System.debug('selected xprs +++ '+ xprs.Loan_Number__c);
                
                //insert xprs;
				
			}
    
  }