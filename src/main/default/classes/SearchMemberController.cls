public class SearchMemberController{ 

public String firstnameQuery {get; set;}
public String nameQuery {get; set;}
public String lastnameQuery {get; set;}
public String SSNLast4Query {get; set;}
public String memberCityQuery {get;set;}
public String memberStateQuery {get;set;}    
public String TINLast4Query {get; set;}
public String trustnameQuery {get;set;}
public String MembernumberQuery {get;set;}
public String CardnameQuery {get;set;}
public String CardnumberQuery {get;set;}
public String VINQuery {get;set;}
public String LoannumberQuery {get;set;}
public String PropertyAddressQuery {get;set;}
public String PropertyCityQuery {get;set;}
public String PropertyStateQuery {get;set;}
public String PropertyZipQuery {get;set;}
public Boolean searchMsg {get; set;}   
public Boolean searchMsgDetails {get; set;}
public Boolean searchMsgTrust {get; set;}
public List<Account> accounts = new List<Account>();
public List<Account> trustaccounts = new List<Account>();
public List<Account_Details__c> accDetails = new List<Account_Details__c>();
public String imageURL{get;set;}
  
    //Method invoked when Search button is clicked to retrieve all the Member Records based on User Inputs  
    public void executeSearch()
    {                   
           accounts = new List<Account>();
           // To trim all the white spaces from User Input
           firstnameQuery = firstnameQuery.trim();
           lastnameQuery = lastnameQuery.trim();
           SSNLast4Query = SSNLast4Query.trim();
           memberCityQuery = memberCityQuery.trim();
           memberStateQuery = memberStateQuery.trim();
           system.debug('the firstname is '+firstnameQuery);
           system.debug('the lastname is '+lastnameQuery);
           system.debug('the ssnlast4 is '+SSNLast4Query);
           
           String genQuery = 'SELECT Id, Name, SSN_TIN_Encrypted__pc, SSN_Last_4__pc, firstname, lastname, PersonBirthdate, PersonHomePhone, PersonEmail, Residential_Zipocde__pc, Residential_City__pc, Residential_State__pc FROM Account WHERE';
           String whereQuery;
        
           if(firstnameQuery != ''){
            if(whereQuery != NULL){
                whereQuery = whereQuery+ 'AND FirstName LIKE \'%'+firstnameQuery+'%\'';
            }else{
                whereQuery = ' FirstName LIKE \'%'+firstnameQuery+'%\'';
            }
           }if(lastnameQuery != ''){
            if(whereQuery != NULL){
                whereQuery = whereQuery+ 'AND LastName LIKE \'%'+lastnameQuery+'%\'';
            }else{
                whereQuery = ' LastName LIKE \'%'+lastnameQuery+'%\'';
            }
           }if(SSNLast4Query != ''){
            if(whereQuery != NULL){
                whereQuery = whereQuery+ 'AND SSN_Last_4__pc LIKE \'%'+SSNLast4Query+'%\'';
            }else{
                whereQuery = ' SSN_Last_4__pc LIKE \'%'+SSNLast4Query+'%\''; 
            }
           }if(memberCityQuery != ''){
            if(whereQuery != NULL){
                whereQuery = whereQuery+ 'AND Residential_City__pc LIKE \'%'+memberCityQuery+'%\'';
            }else{
                whereQuery = ' Residential_City__pc LIKE \'%'+memberCityQuery+'%\''; 
            }
           }if(memberStateQuery != ''){
            if(whereQuery != NULL){
                whereQuery = whereQuery+ 'AND Residential_State__pc LIKE \'%'+memberStateQuery+'%\'';
            }else{
                whereQuery = ' Residential_State__pc LIKE \'%'+memberStateQuery+'%\''; 
            }
           }
        
        if(whereQuery!=NULL){
            String totalQuery = genQuery+whereQuery+'LIMIT 100';
            system.debug('TotalQuery'+totalQuery);
            accounts = Database.query(totalQuery);
        } 
        
            //to display some custom message when no related member records found
            if(accounts == null || accounts.size()==0)
                searchMsg = true; 
            else
                searchMsg = false;    
    }

    public void searchAccount(){
        
        accDetails = new List<Account_Details__c>(); 
        MembernumberQuery = MembernumberQuery.trim();
        CardnameQuery = CardnameQuery.trim();
        CardnumberQuery = CardnumberQuery.trim();
        VINQuery = VINQuery.trim();
        LoannumberQuery = LoannumberQuery.trim();
        PropertyAddressQuery = PropertyAddressQuery.trim();
        PropertyCityQuery = PropertyCityQuery.trim();
        PropertyStateQuery = PropertyStateQuery.trim();
        PropertyZipQuery = PropertyZipQuery.trim();
        
      /*  integer i;
        integer membersize = membernumberQuery.length();
        for(i=membersize; i<10;i++){
            membernumberQuery = '0'+membernumberQuery;
        } */
        
        system.debug('membernumberQuery::::'+membernumberQuery);
        
        string genQuery = 'SELECT Id, Name, Card_Name__c, Card_Number__c, Loan_Number__c, VIN__c, PROPERTY_ADDRESS__c, Property_City__c, Property_State__c, Property_Zip__c FROM Account_Details__c WHERE';
        string whereQuery;
        if(MembernumberQuery != ''){
            if(whereQuery!=NULL){
                whereQuery = whereQuery+ 'AND Name LIKE \''+MembernumberQuery+'\'';
            }else{
                integer i;
                integer membersize = membernumberQuery.length();
                for(i=membersize; i<10;i++){
                membernumberQuery = '0'+membernumberQuery;
              }
                whereQuery = ' Name LIKE \''+MembernumberQuery+'\'' ;
            }
        }if(CardnameQuery != ''){
            if(whereQuery!=NULL){
                whereQuery = whereQuery+ 'AND Card_Name__c LIKE \'%'+CardnameQuery+'%\'' ;
            }else{
                whereQuery = ' Card_Name__c LIKE \'%'+CardnameQuery+'%\'' ;
            }
        }if(CardnumberQuery != ''){
            if(whereQuery!=NULL){ 
                whereQuery = whereQuery+ 'AND Card_Number__c LIKE \'%'+CardnumberQuery+'%\'';
            }else{
                whereQuery = ' Card_Number__c LIKE \'%'+CardnumberQuery+'%\'';
            }
        }if(LoannumberQuery != ''){
            if(whereQuery!=NULL){  
                whereQuery = whereQuery+ 'AND Loan_Number__c LIKE \'%'+LoannumberQuery+'%\'';
            }else{
                whereQuery = ' Loan_Number__c LIKE \'%'+LoannumberQuery+'%\'';
            }
        }if(VINQuery != ''){
            if(whereQuery!=NULL){ 
                whereQuery = whereQuery+ 'AND VIN__c LIKE \'%'+VINQuery+'%\'';
            }else{
                whereQuery = ' VIN__c LIKE \'%'+VINQuery+'%\'';
            }
        }if(PropertyAddressQuery != ''){
            if(whereQuery!=NULL){   
                whereQuery = whereQuery+ 'AND PROPERTY_ADDRESS__c LIKE \'%'+PropertyAddressQuery+'%\'';
            }else{
                whereQuery =' PROPERTY_ADDRESS__c LIKE \'%'+PropertyAddressQuery+'%\'';
            }
        }if(PropertyCityQuery != ''){
            if(whereQuery!=NULL){   
                whereQuery = whereQuery+ 'AND Property_City__c LIKE \'%'+PropertyCityQuery+'%\'';
            }else{
                whereQuery = ' Property_City__c LIKE \'%'+PropertyCityQuery+'%\'';
            }
        }if(PropertyStateQuery != ''){
            if(whereQuery!=NULL){  
                whereQuery = whereQuery+ 'AND Property_State__c LIKE \'%'+PropertyStateQuery+'%\'';
            }else{
                whereQuery = ' Property_State__c LIKE \'%'+PropertyStateQuery+'%\'';
            }
        }if(PropertyZipQuery != ''){
            if(whereQuery!=NULL){  
                whereQuery = whereQuery+ 'AND Property_Zip__c LIKE \'%'+PropertyZipQuery+'%\'';
            }else{
                whereQuery = ' Property_Zip__c LIKE \'%'+PropertyZipQuery+'%\'';
            }
        }
        
        if(whereQuery!=NULL){
            string totalQuery = genQuery+whereQuery+'LIMIT 100';
            system.debug('TotalQuery'+totalQuery);
            accDetails = Database.query(totalQuery);
        }   

        //to display some custom message when no related member records found
            if(accDetails == null || accDetails.size()==0)
                searchMsgDetails = true; 
            else
                searchMsgDetails = false;                                             
    }
     
    //Method to return all the member records based on user input
    public List<Account> getAccountDetails()
    {
        return accounts;
    }

    public List<Account> getTrustAccountDetails(){
        return trustaccounts;
    }
    //Method to return all the account details records based on user input
    public List<Account_Details__c> getMemberAccountInfo()
    {
        return accDetails;
    }
    
    //Method to clear all user input values and the related member records
    public void clearAll()
    {
         firstnameQuery='';
         lastnameQuery='';
         SSNLast4Query='';
         memberCityQuery='';
         memberStateQuery='';
         TINLast4Query='';
         trustnameQuery='';
         MembernumberQuery='';
         CardnameQuery='';
         CardNumberQuery='';
         VINQuery='';
         LoannumberQuery='';
         PropertyAddressQuery='';
         PropertyCityQuery='';
         PropertyStateQuery='';
         PropertyZipQuery='';
         accounts.clear();
         accDetails.clear();
         trustaccounts.clear();
         searchMsg = false;
         searchMsgDetails = false;
         searchMsgTrust = false;
    }
   
    public SearchMemberController()
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
              firstnameQuery=urlQuery;
              lastnameQuery=urlQuery;
              SSNlast4Query=urlQuery;
              memberCityQuery=urlQuery;
              memberStateQuery=urlQuery;
              MembernumberQuery=urlQuery;
              TINLast4Query=urlQuery;
              trustnameQuery=urlQuery;
              CardnameQuery=urlQuery;
              CardNumberQuery=urlQuery;
              VINQuery=urlQuery;
              LoannumberQuery=urlQuery;
              PropertyAddressQuery=urlQuery;
              PropertyCityQuery=urlQuery;
              PropertyStateQuery=urlQuery;
              PropertyZipQuery=urlQuery;
        
  }          
    }
 
}//end class