@isTest
public class MasterCardTravelTriggerTest {
	

		  static testMethod void test1(){
			  Account acc = new Account();
		    	//acc.RecordTypeID=rtId;
		    	acc.FirstName='Test FName';
		        acc.LastName='Test LName';    
		        acc.Mobile_Phone__pc='555-469-3885'; 
		        acc.Email_raw__c='dbhavsar@affirma.com'; 	
		        insert acc;
        
			  	Account_Details__c accDetail = new Account_Details__c();
		        accDetail.Name = '0000147163';
		        accDetail.RecType__c = 'ACCT';
		        accDetail.TypeTranslate__c = '1-PERSONAL';
		        insert accDetail;
		        
		        Account_Details__c accDetail1 = new Account_Details__c();
		        accDetail1.Name = '0000147163';
		        accDetail1.RecType__c = 'CARD';
		        accDetail1.TypeTranslate__c = '15-CHEVRON DEBIT CARD';
		        accDetail1.Status__c = 1;
		        accDetail1.Card_Number__c= '5165967021121165';
		        accDetail1.Card_Name__c = 'MINDY O RIGA';
		        accDetail1.TypeTranslate__c = '15-CHEVRON DEBIT CARD';
		        insert accDetail1;
		        
		        Master_Card_Configurations__c cs = new Master_Card_Configurations__c();	 	
		    	cs.Card_Type__c = '11,12';	
		    	cs.Name = 'ATM'; 
		    	insert cs; 
		    	
		    	Master_Card_Configurations__c cs1 = new Master_Card_Configurations__c();	 	
		    	cs1.Card_Type__c = '13,14,15,18';	
		    	cs1.Name = 'DEBIT'; 
		    	insert cs1;
		    	
		    	Master_Card_Configurations__c cs2 = new Master_Card_Configurations__c();	 	
		    	cs2.Card_Type__c = '16,17';	
		    	cs2.Name = 'HSA'; 
		    	  	
		    	insert cs2;
			  	
			  	List<Case> case_Obj = new List<Case>{
			    new Case(Status = 'In Process',description='Original Desc', Origin = null, Subject = 'Test', ClosedDate = null, IsEscalated = false, AccountId = acc.Id, Account_Number__c = accDetail.Id, Additional_Documents__c = false, Staff_Escalated__c = false, Five_Day_Flag__c = false, IsMarkDeleted__c = false, IsMarkRead__c = false, IsMarkSaved__c = false, Primary_Category__c = 'Card services', Secondary_Category__c = 'ATM/Debit', Tertiary_Category__c = 'Travel notification', MaritzCX__Response_Deleted_From_MaritzCX__c = false, SLATemp__c = false)	};
		    	
		    	Insert case_Obj;
		    	
			  	Mastercard_Travel__c mcObj = new Mastercard_Travel__c();
			  	mcobj.CardId__c = accDetail1.id;
			  	mcobj.Case__c= case_Obj[0].Id;
			  	mcobj.Country__c= 'India';
			  	mcobj.Departure_Date__c= Date.newInstance(2018, 12, 01);
			  	mcobj.Destination__c= 'International';
			  	mcobj.Email__c='dbhavsar@affirma.com';
			  	mcobj.IsEmailPreferred__c= true;
			  	mcobj.IsPhonePreferred__c=false;
			  	mcobj.Return_Date__c=Date.newInstance(2018, 12, 10);
			  	mcobj.State__c='';
			  	mcobj.Timezone__c='America/Los_Angeles';
			  	mcobj.US_Mobile_Number__c='123456789';
			  	insert mcObj;
			  	
			  	Mastercard_Travel__c mcObj1 = new Mastercard_Travel__c();
			  	mcObj1.CardId__c = accDetail1.id;
			  	mcObj1.Case__c= case_Obj[0].Id;
			  	mcObj1.Country__c= 'Nepal';
			  	mcObj1.Departure_Date__c= Date.newInstance(2018, 12, 21);
			  	mcObj1.Destination__c= 'International';
			  	mcObj1.Email__c='dbhavsar@affirma.com';
			  	mcObj1.IsEmailPreferred__c= true;
			  	mcObj1.IsPhonePreferred__c=false;
			  	mcObj1.Return_Date__c=Date.newInstance(2018, 12, 22);
			  	mcObj1.State__c='';
			  	mcObj1.Timezone__c='America/Los_Angeles';
			  	mcObj1.US_Mobile_Number__c='123456789';
			  	insert mcObj1;
			  	
			  	Mastercard_Travel__c mcObj2 = new Mastercard_Travel__c();
			  	mcObj2.CardId__c = accDetail1.id;
			  	mcObj2.Case__c= case_Obj[0].Id;
			  	mcObj2.Country__c= 'Nepal';
			  	mcObj2.Departure_Date__c= Date.newInstance(2018, 12, 24);
			  	mcObj2.Destination__c= 'International';
			  	mcObj2.Email__c='dbhavsar@affirma.com';
			  	mcObj2.IsEmailPreferred__c= true;
			  	mcObj2.IsPhonePreferred__c=false;
			  	mcObj2.Return_Date__c=Date.newInstance(2018, 12, 25);
			  	mcObj2.State__c='';
			  	mcObj2.Timezone__c='America/Los_Angeles';
			  	mcObj2.US_Mobile_Number__c='123456789';
			  	insert mcObj2;
			  	
			  	
			  //	Mastercard_Travel__c mcObj1 = [select id,Return_Date__c from Mastercard_Travel__c where id =: mcObj.id];
			  	mcObj.Return_Date__c = Date.newInstance(2018, 12, 12);
			  	update mcObj;

			 //// 	mcObj2.Return_Date__c = Date.newInstance(2018, 12, 26);
			  	//update mcObj2;
			  	
			  	
			  	delete mcObj;
			  	
			  	delete mcObj2;
			  	
		  }
    
}