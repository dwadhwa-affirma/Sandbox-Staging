public class MemberNumberController{ 

public String MembernumberQuery {get;set;}
public Boolean searchMsgDetails {get; set;}
//public List<Account_Details__c> accDetails = new List<Account_Details__c>();
public List<Person_Account__c> accDetails = new List<Person_Account__c>();  
//public Set<Person_Account__c> myset = new Set<Person_Account__c>();
//public List<Person_Account__c> result = new List<Person_Account__c>();
//public set<Id> paIds = new set<Id>();
public String imageURL{get;set;}

    public void searchAccount(){
        
       // accDetails = new List<Account_Details__c>(); 
        accDetails = new List<Person_Account__c>();
        MembernumberQuery = MembernumberQuery.trim();
        
        system.debug('membernumberQuery::::'+membernumberQuery);
        
       // string genQuery = 'SELECT Id, Name, Card_Name__c, Card_Number__c, Loan_Number__c, VIN__c, PROPERTY_ADDRESS__c, Property_City__c, Property_State__c, Property_Zip__c FROM Account_Details__c WHERE';
        string genQuery = 'SELECT PersonId__r.Name , Split_Type_Translate__c, Account_Number__r.TypeTranslate__c, Name_Type__c, Account_Number__r.ID1__c FROM Person_Account__c WHERE';
        string whereQuery;
        if(MembernumberQuery != ''){
            if(whereQuery!=NULL){
                whereQuery = whereQuery+ 'AND Account_Number__r.Name LIKE \''+MembernumberQuery+'\'';
            }else{
                integer i;
                integer membersize = membernumberQuery.length();
                for(i=membersize; i<10;i++){
                membernumberQuery = '0'+membernumberQuery;
              }
                whereQuery = ' (Account_Number__r.Name LIKE \''+MembernumberQuery+'\' OR Account_Number__r.Parent_Account__r.Name LIKE \''+MembernumberQuery+'\') AND Split_Type_Translate__c IN(\'Primary\',\'Joint Member\',\'Joint Owner\',\'Power of Attorney\',\'Trustee\',\'Authorized Signer\',\'Representative Payee\',\'Custodian\',\'Responsible Individual\') ORDER BY Name_Type__c ASC NULLS LAST ' ;
            }
        }
        
        if(whereQuery!=NULL){
            string totalQuery = genQuery+whereQuery+'LIMIT 100';
            system.debug('TotalQuery'+totalQuery);
            accDetails = Database.query(totalQuery);
          //  myset.addAll(accDetails);
          //  result.addAll(myset);
        }   
        System.debug('Total Query is::::'+accDetails);

        //to display some custom message when no related member records found
            if(accDetails == null || accDetails.size()==0)
                searchMsgDetails = true; 
            else
                searchMsgDetails = false;                                             
    }

    //Method to return all the account details records based on user input
  /*  public List<Account_Details__c> getMemberAccountInfo()
    {
        return accDetails;
    } */
    public List<Person_Account__c> getMemberAccountInfo()
    {
        return accDetails;
        
    }
    
    
    //Method to clear all user input values and the related member records
    public void clearAll()
    {
         MembernumberQuery='';
         accDetails.clear();
         searchMsgDetails = false;
    }
   
    public MemberNumberController()
    {        
        imageURL='/servlet/servlet.FileDownload?file=';
        List< document > documentList=[select name from document where Name='CFCU Logo'];
       
        if(documentList.size()>0)
        {
          imageURL=imageURL+documentList[0].id;
        }
 
        // if query appears in URL, execute it
        String urlQuery=ApexPages.currentPage().getParameters().get('query');
       
        if ( (null!=urlQuery) && (0!=urlQuery.length()) ){
              MembernumberQuery=urlQuery;       
  }          
    }
 
}//end class