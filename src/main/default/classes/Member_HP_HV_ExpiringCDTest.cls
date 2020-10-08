@isTest
public class Member_HP_HV_ExpiringCDTest {

   
        @testSetup
		  static void setupTestData(){
			  	test.startTest();
			  	
			  	Account acc = new Account();
		    	//acc.RecordTypeID=rtId;
		    	acc.FirstName='Test FName';
		        acc.LastName='Test LName';    
		        acc.Mobile_Phone__pc='555-469-3885'; 
		        acc.Email_raw__c='test@test.com'; 	
		        insert acc;
        
			  	Account_Details__c accDetail = new Account_Details__c();
		        accDetail.Name = '0000147163';
		        accDetail.RecType__c = 'ACCT';
		        accDetail.TypeTranslate__c = '1-PERSONAL';
		         accDetail.Brand_Code__c = 'BC01';
		        insert accDetail;
		        
		        Account_Details__c accDetail1 = new Account_Details__c();
		        accDetail1.Name = '0000147163';
		        accDetail1.RecType__c = 'CARD';
		        accDetail1.TypeTranslate__c = '15-CHEVRON DEBIT CARD';
		        accDetail1.Status__c = 1;
		        accDetail1.Card_Number__c= '5165967021121165';
		        accDetail1.Card_Name__c = 'MINDY O RIGA';
		        accDetail1.TypeTranslate__c = '15-CHEVRON DEBIT CARD';
		         accDetail.Brand_Code__c = 'BC02';
		        insert accDetail1;
		        
		        HP_HV_Expiring_CD_Configurations__c cs = new HP_HV_Expiring_CD_Configurations__c();	 	
		    	cs.DaysToExpire__c = 365;	
		    	cs.Name = 'Primary'; 
		    	insert cs;		    	
		        
		        List<Account_Details__c> obj = [select id from Account_Details__c where id =: accDetail.id limit 1];
    
    			List<Person_Account__c> person_obj= new List<Person_Account__c>{
	    		new Person_Account__c(TypeTranslate__c='0000/Primary',Account_Number__c = accDetail.id, PersonID__c = acc.Id), 
	    		new Person_Account__c(TypeTranslate__c='0000/Primary',Account_Number__c = accDetail.Id, PersonID__c = acc.Id)};
		     	Insert person_obj;
		        
				
			  	test.stopTest();
          }
          
          static testMethod void getDataTest() {
                Member_HP_HV_ExpiringCD.getData('branch','High Value and High Potential',1,20);
                Member_HP_HV_ExpiringCD.getData('','None',1,20);
                Member_HP_HV_ExpiringCD.getData('branch','High Value',1,20);
                Member_HP_HV_ExpiringCD.getData('branch','High Potential',1,20);
                Member_HP_HV_ExpiringCD.getData('branch','High Value and High Potential',1,20);
          }

    
}
