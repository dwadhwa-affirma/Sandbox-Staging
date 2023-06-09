@isTest
public class CaseTriggerTest {
    
    static testMethod void testMethod1(){
             
        RecordType recTpe = [Select Id, Name from RecordType where Name='Brand Details' Limit 1];
        
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
        
        Mapping__c mapg = new Mapping__c();
          mapg.RecordTypeId = recTpe.Id;
          mapg.Object_Name__c = 'Case';
          mapg.Brand_Code__c = 'BC01';
          mapg.Brand_Abbreviation__c = 'CFCU';
          mapg.Credit_Union_Name__c = 'Chevron Federal';
          mapg.Image_URL__c = 'xyz';
          mapg.Support_Contact_Details__c = 'test details';       
        insert mapg;   
 
        Case cs = new Case();
          cs.Brand__c = 'CFCU';
        insert cs;
        
        cs.Brand__c = 'Spectrum';
        update cs;
        
        Task t = new Task();
        t.WhatId = cs.id;
        t.OwnerId = UserInfo.getUserId();
        t.Subject='Donni';
        t.Status = 'Open';
        insert t; 
        
        Event e = new Event();
        e.WhatId = cs.id;
        e.StartDateTime = system.today();
        e.EndDateTime = system.today()+5;
        insert e;
   
        delete e;
  
    }
    
    static testMethod void testMethod2(){
        
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
        
        Case cs = new Case();
           cs.Brand__c = 'CFCU';
           cs.Primary_Category__c = 'Shared Branch';
        insert cs;
        
        Task tk = new task();
          tk.Status = 'Open';
        insert tk;
        
        try{
            cs.Status = 'Resolution';
            update cs;
        }catch (DmlException ex) {
            System.assertEquals('All Tasks associated with a Case must be close/completed before the Case can be closed.', ex.getDmlMessage(0));   
        }
    } 
    
  
    static testMethod void testMethod3(){
        
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
        
        Account_Details__c accDetail = new Account_Details__c();
          accDetail.Name = 'Test';
          accDetail.RecType__c = 'ACCT';
          accDetail.Reference__c = 'BC01';
        insert accDetail;
        
        Case cs = new Case();
          cs.Account_Number__c = accDetail.Id;
        insert cs;
    } 
    
    static testMethod void testMethod4(){
        
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
        
        Case cs = new Case();
          cs.Brand__c = '';
       //   cs.Account_Number__c = '';
        
        Test.startTest();
        try {
        insert cs;
       }
        catch (DmlException ex) {
            System.assertEquals('Please select either an "Account Number" OR a "Brand" to proceed further', ex.getDmlMessage(0));   
    }
        Test.stopTest();
  } 
    
    
  /*  static testMethod void testMethod5(){

        Case_Type_Decisiong__c cd = new Case_Type_Decisiong__c();
           cd.Case_Type__c = 'test1 - test2 - test3';
           cd.Case_text__c = 'this is for test';
           cd.Name = 'abc1';
        insert cd;
        
         Case cs = new Case();
          cs.Brand__c = 'CFCU';
          cs.Primary_Category__c = 'test1';
          cs.Secondary_Category__c = 'test2';
          cs.Tertiary_Category__c = 'test3';
          cs.Case_type__c = 'this is for test';
        insert cs;
   }  */
    
    
    static testMethod void testMethod6(){
        
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
   
        Account_Details__c accDetail = new Account_Details__c();
        accDetail.Name = 'Test';
        accDetail.RecType__c = 'ACCT';
        accDetail.SecureEmailAddress__c = 'test@test.com';
        insert accDetail;
        
        Account_Details__c accDetail1 = new Account_Details__c();
        accDetail1.Name = 'Test';
        accDetail1.RecType__c = 'CARD';
        insert accDetail1; 
 
        Case cs1 = new Case();
          cs1.Account_Number__c = accDetail.Id;
         
        insert cs1;
        
        cs1.Account_Number__c = accDetail1.Id;
       // update cs1; 
    } 
    
    static testMethod void testMethod7(){
        
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
        
        Profile[] p1 = [select Id from Profile where Name = 'System Administrator' limit 1];
        
        User user1 = new User(alias = 'u1',lastname='test999', languagelocalekey='en_US', 
                              email='User1@avfg.com', emailencodingkey='UTF-8', 
                              localesidkey='en_US', profileId = p1[0].id, timezonesidkey='America/Los_Angeles', 
                              username='test9991'+'@avfg.com',
                              Mortgage_Loan_Officer__c = true);
        
        insert user1;

        Case cs = new Case();
           cs.Status = 'Closed';
           cs.Brand__c = 'Specturm';
        insert cs;
        
       cs.OwnerId = user1.Id; 
       update cs;
        
        List<GroupMember> gm = [select group.name, group.DeveloperName from GroupMember where UserOrGroupId = :user1.Id];
      
    } 
    
    static testMethod void testMethod8(){
        
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
        
        RecordType recTpe = [Select Id, Name from RecordType where Name='Brand Details' Limit 1];
        
        Mapping__c mapg = new Mapping__c();
          mapg.RecordTypeId = recTpe.Id;
          mapg.Object_Name__c = 'Case';
          mapg.Brand_Code__c = 'BC01';
          mapg.Brand_Abbreviation__c = 'CFCU';
          mapg.Credit_Union_Name__c = 'Chevron Federal';
          mapg.Image_URL__c = 'xyz';
          mapg.Support_Contact_Details__c = 'test details';       
        insert mapg; 
        
         Account_Details__c accDetail = new Account_Details__c();
          accDetail.Name = 'Test';
          accDetail.RecType__c = 'ACCT';
          accDetail.Reference__c = 'BC01';
        insert accDetail;
        
        Case cs = new Case();
          cs.Account_Number__c = accDetail.Id;
        insert cs;
        
    }
    
    static testMethod void testMethod9(){
        
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
        
        Profile[] p1 = [select Id from Profile where Name = 'CFCU Admin' limit 1];
        
        User user1 = new User(alias = 'u1',lastname='test999', languagelocalekey='en_US', 
                              email='User1@avfg.com', emailencodingkey='UTF-8', 
                              localesidkey='en_US', profileId = p1[0].id, timezonesidkey='America/Los_Angeles', 
                              username='test9991'+'@avfg.com',
                              Mortgage_Loan_Officer__c = true);
        
        insert user1;
        
        Case cs = new Case();
           cs.Status = 'Open';
           cs.Brand__c = 'Specturm';
        insert cs;
       
       cs.Status = 'Resolution';
       cs.OwnerId = user1.Id; 
       update cs;     
    }  
    
    static testMethod void testMethod10(){
		
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
        
		CaseRecordType__c crt = new CaseRecordType__c();
        crt.Primary_Category__c = 'AAA';
        crt.Secondary_Category__c = 'BBB';
        crt.Teritiary_Category__c = 'CCC';
        crt.Name = 'AAA';
        crt.SLA__c = 50;
        insert crt;
        
        Account_Details__c accDetail = new Account_Details__c();
        accDetail.Name = 'Test123';
        accDetail.RecType__c = 'ACCT';
        insert accDetail;
        
        Account_Details__c accDetail1 = new Account_Details__c();
        accDetail1.Name = 'Test1234';
        accDetail1.RecType__c = 'ACCT';
        insert accDetail1;
        
        String RecTypeId= [select Id from RecordType where (Name='Person Account') and (SobjectType='Account')].Id;
        
        Account acc = new Account(
           RecordTypeID=RecTypeId,
           FirstName='Test FName',
           LastName='Test LName',
           PersonMailingStreet='test@yahoo.com',
           PersonMailingPostalCode='12345',
           PersonMailingCity='SFO',
           PersonEmail='test@yahoo.com',
           PersonHomePhone='1234567',
           PersonMobilePhone='12345678');
         
        insert acc;
        
         Account acc1 = new Account(
           RecordTypeID=RecTypeId,
           FirstName='Test FName',
           LastName='Test LName',
           PersonMailingStreet='test@yahoo.com',
           PersonMailingPostalCode='12345',
           PersonMailingCity='SFO',
           PersonEmail='test@yahoo.com',
           PersonHomePhone='1234567',
           PersonMobilePhone='12345678');
         
        insert acc1;
        
      /*    Person_Account__c pa = new Person_Account__c();
        pa.PersonID__c = acc.Id;
        pa.Account_Number__c = accDetail.Id; 
        pa.Name_Type__c = 0;
        insert pa;
        
        Person_Account__c pa1 = new Person_Account__c();
        pa1.PersonID__c = acc1.Id;
        pa1.Account_Number__c = accDetail1.Id; 
        pa1.Name_Type__c = 0;
        insert pa1;
        
        Case cs = new Case();
        cs.Brand__c = 'Specturm';
     //   cs.Origin = 'Email';
        cs.Subject = '1234 testing tet sdf asdfa';
         cs.Primary_Category__c = 'AAA';
          cs.Secondary_Category__c = 'BBB';
          cs.Tertiary_Category__c = 'CCC';
          cs.Origin = 'BoomiBulk';
        cs.Account_Number__c = accDetail.Id;
        cs.Member_Number__c = 'Test123';
        cs.AccountId = acc.Id;       
        insert cs;
        
        cs.Origin = 'Email';
        cs.AccountId = acc1.Id;
        update cs;
        
         Case cs1 = new Case();
         cs1.Brand__c = 'Specturm';
         cs1.Subject = '1234 testing tet sdf asdfa';
         cs1.Primary_Category__c = 'AAA';
         cs1.Secondary_Category__c = 'BBB';
         cs1.Tertiary_Category__c = 'CCC';
         cs1.Origin = 'BoomiBulk';
         cs1.Account_Number__c = accDetail.Id;
         cs1.Member_Number__c = 'Test123';
         cs1.AccountId = null;       
        insert cs1;
        
        cs1.Origin = 'Email';
        
      update cs1;
        

     Group grp = new Group();
     grp.Name =  'Branch 202 -Spectrum Hou(Galleria) Queue';
     insert grp;
     
     CaseRecordType__c crt1 = new CaseRecordType__c();
     crt1.Primary_Category__c= 'Surveys';
     crt1.RecordTypeId__c = '012f10000010MS8';
     crt1.SLA__c = 40;
     crt1.Record_Type_Name__c = 'Survey Cases';
     crt1.Name = '302';
     insert crt1;
     
 Survey_Case_Codes__c scc = new Survey_Case_Codes__c();
        scc.Primary_Category__c = 'Surveys';
         scc.Secondary_Category__c ='Call Center';
         scc.Tertiary_Category__c='Other';
         scc.Queue__c='Branch 202 -Spectrum Hou(Galleria) Queue';   
         scc.Name='202';
         scc.Branch_Dept__c = 'Branch 202 -Spectrum Hou(Galleria) Queue';
         insert scc;*/
       
       
        
       
       
        
    }
    
    static testMethod void testMethod11(){

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
        
        Case cs = new Case();
          cs.Brand__c = 'Specturm';
          cs.Origin = 'Email';
          cs.Subject = '';          
        insert cs;
    }
    
    static testMethod void testMethod12(){

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
        
        Case cs = new Case();
          cs.Brand__c = 'Specturm';
          cs.Origin = 'Email';
          cs.Subject = '1   ';          
        insert cs;       
    }
    
    static testMethod void testMethod13(){
        
        String RecTypeId= [select Id from RecordType where (Name='Person Account') and (SobjectType='Account')].Id;
        
         Account acc = new Account(
           RecordTypeID=RecTypeId,
           FirstName='Test FName',
           LastName='Test LName',
           PersonMailingStreet='test@yahoo.com',
           PersonMailingPostalCode='12345',
           PersonMailingCity='SFO',
           PersonEmail='test@yahoo.com',
           PersonHomePhone='1234567',
           PersonMobilePhone='12345678');
         
        insert acc;
        
        Account_Details__c accDetail = new Account_Details__c();
        accDetail.Name = 'Test123';
        accDetail.RecType__c = 'ACCT';
        //accDetail.Brand__c = 'Spectrum';
        insert accDetail;
        
        Person_Account__c pa = new Person_Account__c();
        pa.PersonID__c = acc.Id;
        pa.Account_Number__c = accDetail.Id; 
        pa.Name_Type__c = 0;
        insert pa;
        
        test.startTest();
        Case cs = new Case();
       //cs.Brand__c = 'Chevron';
        cs.Subject = '1234 testing tet sdf asdfa';
         cs.Primary_Category__c = 'Card Services';
          cs.Secondary_Category__c = 'ATM-Debit';
          cs.Tertiary_Category__c = 'Travel Notification';
         // cs.Origin = 'BoomiBulk';
        cs.Account_Number__c = accDetail.Id;
        cs.Member_Number__c = 'Test123';
        cs.AccountId = acc.Id;       
        insert cs;
        
         Case cs1 = new Case();
        cs1.Brand__c = 'Specturm';
        cs1.Subject = '1234 testing tet sdf asdfa';
         cs1.Primary_Category__c = 'Card Services';
          cs1.Secondary_Category__c = 'ATM-Debit';
          cs1.Tertiary_Category__c = 'Travel Notification';
         // cs.Origin = 'BoomiBulk';
        cs1.Account_Number__c = accDetail.Id;
        cs1.Member_Number__c = 'Test123';
        cs1.AccountId = acc.Id;       
        insert cs1;
        
        Mastercard_Travel__c mcObj = new Mastercard_Travel__c();
			  	mcobj.CardId__c = accDetail.id;
			  	mcobj.Case__c= cs.Id;
			  	mcobj.Country__c= 'India';
			  	mcobj.Departure_Date__c= Date.newInstance(2018, 12, 01);
			  	mcobj.Destination__c= 'International';
			  	mcobj.Email__c='dbhavsar@affirma.com';
			  	mcobj.IsEmailPreferred__c= true;
			  	mcobj.IsPhonePreferred__c=false;
			  	mcobj.Return_Date__c=Date.newInstance(2018, 12, 10);
			  	mcobj.State__c='';
			  	mcobj.Timezone__c='America/Los_Angeles';
			  //	mcobj.US_Mobile_Number__c='123456789';         		
        		mcobj.isPlacedFromBoomi__c= true;
			  	insert mcObj;
        
                Mastercard_Travel__c mcObj1 = new Mastercard_Travel__c();
			  	mcObj1.CardId__c = accDetail.id;
			  	mcObj1.Case__c= cs1.Id;
			  	mcObj1.Country__c= 'India';
			  	mcObj1.Departure_Date__c= Date.newInstance(2018, 12, 01);
			  	mcObj1.Destination__c= 'International';
			  	//mcObj1.Email__c='dbhavsar@affirma.com';
			  	mcObj1.IsEmailPreferred__c= false;
			  	mcObj1.IsPhonePreferred__c=true;
			  	mcObj1.Return_Date__c=Date.newInstance(2018, 12, 10);
			  	mcObj1.State__c='';
			  	mcObj1.Timezone__c='America/Los_Angeles';
			  	mcObj1.US_Mobile_Number__c='123456789';         		
        		mcobj1.isPlacedFromBoomi__c= true;
			  	insert mcObj1;
        
       /* MasterCard_Travel_Confirmation__c mctc = new MasterCard_Travel_Confirmation__c();
        mctc.Case__c = cs.id;
         mctc.Message__c = 'Email';
        insert mctc;
        
        MasterCard_Travel_Confirmation__c mctc1 = new MasterCard_Travel_Confirmation__c();
        mctc1.Case__c = cs1.id;
         mctc1.Message__c = 'SMS';
        insert mctc1;*/
        
        
        cs.Description = 'Travel Notificatoon Test';
        update cs;
        
        cs1.Description = 'Travel Notificatoon Test';
        update cs1;
        
        test.stopTest();
    }
}