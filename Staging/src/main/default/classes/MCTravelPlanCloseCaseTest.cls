@isTest
public class MCTravelPlanCloseCaseTest {
    
    public static testmethod void test1(){
    	
    	Create_SLA__c cl = new Create_SLA__c();
        cl.Status__c = 'Open';
        cl.Name = 'Open';
        cl.hours__c = 8;
        insert cl;
        
        Create_SLA__c cl1 = new Create_SLA__c();
        cl1.Status__c = 'In Process';
        cl1.Name = 'In Process';
        cl1.hours__c = 20;
        insert cl1;
        
        Create_SLA__c cl2 = new Create_SLA__c();
        cl2.Status__c = 'Resolution';
        cl2.Name = 'Resolution';
        cl2.hours__c = 20;
        insert cl2;
        
        Create_SLA__c cl3 = new Create_SLA__c();
        cl3.Status__c = 'Closed';
        cl3.Name = 'Closed';
        cl3.hours__c = 2;
        insert cl3;
        
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
		        
		        Account acc = new Account();
		    	//acc.RecordTypeID=rtId;
		    	acc.FirstName='Test FName';
		        acc.LastName='Test LName';    
		        acc.Mobile_Phone__pc='555-469-3885'; 
		        acc.Email_raw__c='dbhavsar@affirma.com'; 	
		        insert acc;
			  	
			  	List<Case> case_Obj = new List<Case>{
			    new Case(Status = 'In Process', Origin = null, Subject = 'Test', ClosedDate = null, IsEscalated = false, AccountId = acc.Id, Account_Number__c = accDetail.Id, Additional_Documents__c = false, Staff_Escalated__c = false, Five_Day_Flag__c = false, IsMarkDeleted__c = false, IsMarkRead__c = false, IsMarkSaved__c = false, Primary_Category__c = 'Card services', Secondary_Category__c = 'ATM/Debit', Tertiary_Category__c = 'Travel notification', MaritzCX__Response_Deleted_From_MaritzCX__c = false, SLATemp__c = false),
			    new Case(Status = 'In Process', Origin = null, Subject = 'Test', ClosedDate = null, IsEscalated = false, AccountId = acc.Id, Account_Number__c = accDetail.Id, Additional_Documents__c = false, Staff_Escalated__c = false, Five_Day_Flag__c = false, IsMarkDeleted__c = false, IsMarkRead__c = false, IsMarkSaved__c = false, Primary_Category__c = 'Card services', Secondary_Category__c = 'ATM/Debit', Tertiary_Category__c = 'Travel notification', MaritzCX__Response_Deleted_From_MaritzCX__c = false, SLATemp__c = false),
			    new Case(Status = 'In Process', Origin = null, Subject = 'Test', ClosedDate = null, IsEscalated = false, AccountId = acc.Id, Account_Number__c = accDetail.Id, Additional_Documents__c = false, Staff_Escalated__c = false, Five_Day_Flag__c = false, IsMarkDeleted__c = false, IsMarkRead__c = false, IsMarkSaved__c = false, Primary_Category__c = 'Card services', Secondary_Category__c = 'ATM/Debit', Tertiary_Category__c = 'Travel notification', MaritzCX__Response_Deleted_From_MaritzCX__c = false, SLATemp__c = false),
			    new Case(Status = 'In Process', Origin = null, Subject = 'Test', ClosedDate = null, IsEscalated = false,AccountId = acc.Id,  Account_Number__c = accDetail.Id, Additional_Documents__c = false, Staff_Escalated__c = false, Five_Day_Flag__c = false, IsMarkDeleted__c = false, IsMarkRead__c = false, IsMarkSaved__c = false, Primary_Category__c = 'Account Maintenance', Secondary_Category__c = 'Account Services', Tertiary_Category__c = 'Extended Check Hold', MaritzCX__Response_Deleted_From_MaritzCX__c = false, SLATemp__c = false)
		    	};
		    	
		    	insert case_Obj;
    	
    	Mastercard_Travel__c mcObj = new Mastercard_Travel__c();
			  	mcobj.CardId__c = accDetail1.id;
			  	mcobj.Case__c= case_Obj[0].Id;
			  	mcobj.Country__c= 'India';
			  	mcobj.Departure_Date__c= Date.newInstance(2018, 09, 09);
			  	mcobj.Destination__c= 'International';
			  	mcobj.Email__c='dbhavsar@affirma.com';
			  	mcobj.IsEmailPreferred__c= true;
			  	mcobj.IsPhonePreferred__c=false;
			  	mcobj.Return_Date__c=Date.newInstance(2018, 09, 10);
			  	mcobj.State__c='';
			  	mcobj.Timezone__c='America/Los_Angeles';
			  	mcobj.US_Mobile_Number__c='123456789';
			  	insert mcObj;
    	Test.startTest();
        Datetime dt = Datetime.now().addMinutes(1);
        String CRON_EXP = '0 '+ dt.minute() + ' * ' + dt.day() + ' ' + dt.month() + ' ? ' + dt.year();
        //MCTravelPlanCloseCaseTest.SchedulerMethod('Sample_Heading', CRON_EXP, new MCTravelPlanCloseCase () );   
        
         String jobId = System.schedule('ScheduleApexClassTest',  CRON_EXP,  new MCTravelPlanCloseCase ());
         CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered,   NextFireTime FROM CronTrigger WHERE id = :jobId];
         System.assertEquals(CRON_EXP,  ct.CronExpression);
        
        Test.stopTest();
    }
}