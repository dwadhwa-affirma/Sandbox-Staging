public class SearchMemberController2{ 
public SearchMemberController2(ApexPages.StandardController controller) {

    }
public String firstnameQuery {get; set;}
public String nameQuery {get; set;}
public String lastnameQuery {get; set;}
public String SSNLast4Query {get; set;}
public String TINLast4Query {get; set;}
public String trustnameQuery {get;set;}
public String MembernumberQuery {get;set;}
public String CardnameQuery {get;set;}
public String CardnumberQuery {get;set;}
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
           system.debug('the firstname is '+firstnameQuery);
           system.debug('the lastname is '+lastnameQuery);
           system.debug('the ssnlast4 is '+SSNLast4Query);
           
           
         /*   if (firstnameQuery != '' || lastnameQuery != '' || (SSNLast4Query!=null || SSNLast4Query !='')){                
                accounts=[SELECT Id, Name, SSN_TIN_Encrypted__pc, SSN_Last_4__pc, firstname, lastname, PersonBirthdate, Residential_Zipocde__pc, PersonHomePhone, PersonEmail
                FROM Account 
                where (firstname Like:('%'+firstnameQuery+'%') and lastname Like:('%'+lastnameQuery+'%') and SSN_Last_4__pc Like:('%'+SSNLast4Query+'%')) LIMIT 25] ;          
            } */
       
         /*   if(firstnameQuery != '' || lastnameQuery != '' || SSNLast4Query !=''){
                accounts=[SELECT Id, Name, SSN_TIN_Encrypted__pc, SSN_Last_4__pc, firstname, lastname, PersonBirthdate, Residential_Zipocde__pc, PersonHomePhone, PersonEmail 
                FROM Account 
                where (firstname Like:('%'+firstnameQuery+'%') and lastname Like:('%'+lastnameQuery+'%') and SSN_Last_4__pc Like:('%'+SSNLast4Query+'%')) LIMIT 25 ] ;
            }else if(firstnameQuery != '' || SSNLast4Query !='' || lastnameQuery==''){
                accounts=[SELECT Id, Name, SSN_TIN_Encrypted__pc, SSN_Last_4__pc, firstname, lastname, PersonBirthdate, Residential_Zipocde__pc, PersonHomePhone, PersonEmail 
                FROM Account 
                where (firstname Like:('%'+firstnameQuery+'%') and SSN_Last_4__pc Like: ('%'+SSNLast4Query+'%')) LIMIT 25 ] ;        
            }else if(lastnameQuery != '' || SSNLast4Query !='' || firstnameQuery=='') {
                accounts=[SELECT Id, Name, SSN_TIN_Encrypted__pc, SSN_Last_4__pc, firstname, lastname, PersonBirthdate, Residential_Zipocde__pc, PersonHomePhone, PersonEmail 
                FROM Account 
                where (lastname Like:('%'+lastnameQuery+'%') and SSN_Last_4__pc Like:('%'+SSNLast4Query+'%')) LIMIT 25 ] ;            
            }  */
        
            if(firstnameQuery != '' && lastnameQuery == '' && SSNLast4Query ==''){
                accounts=[SELECT Id, Name, SSN_TIN_Encrypted__pc, SSN_Last_4__pc, firstname, lastname, PersonBirthdate, Residential_Zipocde__pc, PersonHomePhone, PersonEmail 
                FROM Account 
                where (firstname Like:('%'+firstnameQuery+'%') and lastname Like:('%'+lastnameQuery+'%') and SSN_Last_4__pc Like:('%'+SSNLast4Query+'%')) LIMIT 25 ] ;
            }else if(firstnameQuery == '' && SSNLast4Query !='' && lastnameQuery==''){
                accounts=[SELECT Id, Name, SSN_TIN_Encrypted__pc, SSN_Last_4__pc, firstname, lastname, PersonBirthdate, Residential_Zipocde__pc, PersonHomePhone, PersonEmail 
                FROM Account 
                where (firstname Like:('%'+firstnameQuery+'%') and SSN_Last_4__pc Like: ('%'+SSNLast4Query+'%')) LIMIT 25 ] ;        
            }else if(lastnameQuery != '' && SSNLast4Query =='' && firstnameQuery=='') {
                accounts=[SELECT Id, Name, SSN_TIN_Encrypted__pc, SSN_Last_4__pc, firstname, lastname, PersonBirthdate, Residential_Zipocde__pc, PersonHomePhone, PersonEmail 
                FROM Account 
                where (lastname Like:('%'+lastnameQuery+'%') and SSN_Last_4__pc Like:('%'+SSNLast4Query+'%')) LIMIT 25 ] ;            
            } 
            else if(firstnameQuery != '' && lastnameQuery != '' && SSNLast4Query ==''){
                accounts=[SELECT Id, Name, SSN_TIN_Encrypted__pc, SSN_Last_4__pc, firstname, lastname, PersonBirthdate, Residential_Zipocde__pc, PersonHomePhone, PersonEmail 
                FROM Account 
                where (firstname Like:('%'+firstnameQuery+'%') and lastname Like:('%'+lastnameQuery+'%') and SSN_Last_4__pc Like:('%'+SSNLast4Query+'%')) LIMIT 25 ] ;
            }
            else if(firstnameQuery != '' && lastnameQuery != '' && SSNLast4Query !=''){
                accounts=[SELECT Id, Name, SSN_TIN_Encrypted__pc, SSN_Last_4__pc, firstname, lastname, PersonBirthdate, Residential_Zipocde__pc, PersonHomePhone, PersonEmail 
                FROM Account 
                where (firstname Like:('%'+firstnameQuery+'%') and lastname Like:('%'+lastnameQuery+'%') and SSN_Last_4__pc Like:('%'+SSNLast4Query+'%')) LIMIT 25 ] ;
            }
           /* else if(firstnameQuery != '' && lastnameQuery == '' && SSNLast4Query ==''){
                accounts=[SELECT Id, Name, SSN_TIN_Encrypted__pc, SSN_Last_4__pc, firstname, lastname, PersonBirthdate, Residential_Zipocde__pc, PersonHomePhone, PersonEmail 
                FROM Account 
                where (firstname Like:('%'+firstnameQuery+'%') and lastname Like:('%'+lastnameQuery+'%') and SSN_Last_4__pc Like:('%'+SSNLast4Query+'%')) LIMIT 25 ] ;
            } */
            else if(firstnameQuery == '' && lastnameQuery != '' && SSNLast4Query !=''){
                accounts=[SELECT Id, Name, SSN_TIN_Encrypted__pc, SSN_Last_4__pc, firstname, lastname, PersonBirthdate, Residential_Zipocde__pc, PersonHomePhone, PersonEmail 
                FROM Account 
                where (firstname Like:('%'+firstnameQuery+'%') and lastname Like:('%'+lastnameQuery+'%') and SSN_Last_4__pc Like:('%'+SSNLast4Query+'%')) LIMIT 25 ] ;
            }
            else if(firstnameQuery != '' && lastnameQuery == '' && SSNLast4Query !=''){
                accounts=[SELECT Id, Name, SSN_TIN_Encrypted__pc, SSN_Last_4__pc, firstname, lastname, PersonBirthdate, Residential_Zipocde__pc, PersonHomePhone, PersonEmail 
                FROM Account 
                where (firstname Like:('%'+firstnameQuery+'%') and lastname Like:('%'+lastnameQuery+'%') and SSN_Last_4__pc Like:('%'+SSNLast4Query+'%')) LIMIT 25 ] ;
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
        

      /*  if(MembernumberQuery != ''){
            accDetails=[SELECT Id, Name, Card_Name__c, Card_Number__c 
            From Account_Details__c 
            where Name =: MembernumberQuery LIMIT 25];
        } */
        
            if(MembernumberQuery != '' && CardnameQuery == '' && CardnumberQuery ==''){
                accDetails=[SELECT Id, Name, Card_Name__c, Card_Number__c 
                From Account_Details__c 
                where (Name Like:('%'+MembernumberQuery+'%') and Card_Name__c Like:('%'+CardnameQuery+'%') and Card_Number__c Like:('%'+CardnumberQuery+'%')) LIMIT 25 ] ;
            }else if(MembernumberQuery == '' && CardnumberQuery !='' && CardnameQuery==''){
                accDetails=[SELECT Id, Name, Card_Name__c, Card_Number__c 
                From Account_Details__c 
                where (Name Like:('%'+MembernumberQuery+'%') and Card_Number__c Like: ('%'+CardnumberQuery+'%')) LIMIT 25 ] ;        
            }else if(CardnameQuery != '' && CardnumberQuery =='' && MembernumberQuery=='') {
                accDetails=[SELECT Id, Name, Card_Name__c, Card_Number__c 
                From Account_Details__c 
                where (Card_Name__c Like:('%'+CardnameQuery+'%') and Card_Number__c Like:('%'+CardnumberQuery+'%')) LIMIT 25 ] ;            
            } 
            else if(MembernumberQuery != '' && CardnameQuery != '' && CardnumberQuery ==''){
                accDetails=[SELECT Id, Name, Card_Name__c, Card_Number__c 
                From Account_Details__c 
                where (Name Like:('%'+MembernumberQuery+'%') and Card_Name__c Like:('%'+CardnameQuery+'%') and Card_Number__c Like:('%'+CardnumberQuery+'%')) LIMIT 25 ] ;
            }
            else if(MembernumberQuery != '' && CardnameQuery != '' && CardnumberQuery !=''){
                accDetails=[SELECT Id, Name, Card_Name__c, Card_Number__c 
                From Account_Details__c 
                where (Name Like:('%'+MembernumberQuery+'%') and Card_Name__c Like:('%'+CardnameQuery+'%') and Card_Number__c Like:('%'+CardnumberQuery+'%')) LIMIT 25 ] ;
            }
           /* else if(MembernumberQuery != '' && CardnameQuery == '' && CardnumberQuery ==''){
                accDetails=[SELECT Id, Name, Card_Name__c, Card_Number__c 
                From Account_Details__c 
                where (Name Like:('%'+MembernumberQuery+'%') and Card_Name__c Like:('%'+CardnameQuery+'%') and Card_Number__c Like:('%'+CardnumberQuery+'%')) LIMIT 25 ] ;
            } */
            else if(MembernumberQuery == '' && CardnameQuery != '' && CardnumberQuery !=''){
                accDetails=[SELECT Id, Name, Card_Name__c, Card_Number__c 
                From Account_Details__c 
                where (Name Like:('%'+MembernumberQuery+'%') and Card_Name__c Like:('%'+CardnameQuery+'%') and Card_Number__c Like:('%'+CardnumberQuery+'%')) LIMIT 25 ] ;
            }
            else if(MembernumberQuery != '' && CardnameQuery == '' && CardnumberQuery !=''){
                accDetails=[SELECT Id, Name, Card_Name__c, Card_Number__c 
                From Account_Details__c 
                where (Name Like:('%'+MembernumberQuery+'%') and Card_Name__c Like:('%'+CardnameQuery+'%') and Card_Number__c Like:('%'+CardnumberQuery+'%')) LIMIT 25 ] ;
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
         TINLast4Query='';
         trustnameQuery='';
         MembernumberQuery='';
         CardnameQuery='';
         CardNumberQuery='';
         accounts.clear();
         accDetails.clear();
         trustaccounts.clear();
         searchMsg = false;
         searchMsgDetails = false;
         searchMsgTrust = false;
    }
   
    public SearchMemberController2()
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
              MembernumberQuery=urlQuery;
              TINLast4Query=urlQuery;
              trustnameQuery=urlQuery;
              

        }          
    }
 
}//end class