public class AdvancedSearchController
{
	@AuraEnabled
	public static List<Account> getMemberAccounts(string firstnameQuery, string lastnameQuery, string SSNLast4Query, string memberCityQuery, string memberStateQuery)
	{		
		   List<Account> accounts = new List<Account>();
           // To trim all the white spaces from User Input                      
           firstnameQuery = firstnameQuery.trim();
           lastnameQuery = lastnameQuery.trim();
           SSNLast4Query = SSNLast4Query.trim();
           memberCityQuery = memberCityQuery.trim();
           memberStateQuery = memberStateQuery.trim();           
           
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
        return accounts;
	}
	
	@AuraEnabled
	public static List<Account_Details__c> getAccountDetails(string MembernumberQuery, string CardnameQuery, string CardnumberQuery, string VINQuery, string LoannumberQuery, string PropertyAddressQuery, string PropertyCityQuery, string PropertyStateQuery, string PropertyZipQuery)
	{
		List<Account_Details__c> accDetails = new List<Account_Details__c>(); 
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
        
        string genQuery = 'SELECT Id, Name, Card_Name__c,ID1__c, Card_Number__c, Loan_Number__c, VIN__c, PROPERTY_ADDRESS__c, Property_City__c, Property_State__c, Property_Zip__c FROM Account_Details__c WHERE';
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
        
        return accDetails;
				
	}
	
}