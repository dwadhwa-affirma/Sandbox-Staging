@isTest
public class WIRESTransactionTriggerTest {
    static testMethod void test1(){
        
        SolarLoan_To_Episys_API_Details__c api = new SolarLoan_To_Episys_API_Details__c();
        api.URL__c = 'https://symxapi.chevronfcu.org/devclient';
        api.Name = 'ProductionURL';
        insert api;
        
        Member360_TypeTranslate__c t= new Member360_TypeTranslate__c();
        t.name='0000/Primary';
        insert t;
        
       /* User u=new User();
        u.Email='test@test.com';
        insert u;*/
        
        
        
        Wires_Progress_Email_Test__c wpt = new Wires_Progress_Email_Test__c();
        wpt.Name = 'Test';
        wpt.Email__c = 'test@test.com';
        insert wpt;
        
        Wires_Docusign_Emails__c wde = new Wires_Docusign_Emails__c();
        wde.Name = 'Email For Testing';
        wde.Emails__c = 'Testing';
        insert wde;
        
        
         Account acc = new Account();
        //acc.RecordTypeID=rtId;
        acc.FirstName='Test FName';
        acc.LastName='Test LName';    
        acc.Mobile_Phone__pc='555-469-3885'; 
        acc.Home_Phone__pc='555-469-3886';
        acc.Work_Phone__pc='555-469-3887';
        acc.Email_raw__c='test@test.com'; 	
        acc.PersonEmail='test1@test.com'; 
        acc.PersonID__c='V565138120';
        insert acc;
        
        acc.Mobile_Phone__pc='555-479-3885'; 
        update acc;
        
        
        
        Account_Details__c accDetail = new Account_Details__c();
        accDetail.Name = '00000000123';
        accDetail.RecType__c = 'ACCT';
        accDetail.TypeTranslate__c = '1-PERSONAL';
        accDetail.ID1__c = '001';
        accDetail.OPEN_DATE__c = Date.newInstance(2018, 12, 10);
        insert accDetail;
        
        
        
        
       
        
        List<Person_Account__c> person_obj= new List<Person_Account__c>{
            new Person_Account__c(TypeTranslate__c='0000/Primary',Account_Number__c = accDetail.Id, PersonID__c = acc.Id), 
                new Person_Account__c(TypeTranslate__c='0000/Primary',Account_Number__c = accDetail.Id, PersonID__c = acc.Id)};
                    Insert person_obj;
        
        
                
        
        WIRES_Transaction__c objWC = new WIRES_Transaction__c();
        objWC.Description__c='test';
        objWC.Fees__c = 30.0;
        objWC.Chevron_Account_Number__c = accDetail.Name;
        objWC.Share_ID__c ='001';
        objWC.FromAccount__c = accDetail.Name;
        //objWC.Mobile_Phone__c = '1234567890';
       objWC.Member_SSN__c='565138120';
        objWC.WireAmount__c=500;
        objWC.Frequency__c = 'One - Time';
        objWC.Source__c = 'Branch';
        objWC.Current_Reviewer__c = UserInfo.getUserId();
		
        insert objWC;
        
        objWC.WireAmount__c= 400;
        objWC.Current_Reviewer__c = UserInfo.getUserId();
       // objWC.First_Reviewer__c = UserInfo.getUserId();
        objWC.Frequency__c = 'One - Time';
        objWC.Approval_Status__c = 'Released In WireXchange';
        objWC.Status__c ='Voided';
        objWC.Source__c = 'Online Banking';
        objWC.Has_Additional_Documents__c = true;
        update objWC;
    }
    
    static testMethod void test2(){
        
        SolarLoan_To_Episys_API_Details__c api = new SolarLoan_To_Episys_API_Details__c();
        api.URL__c = 'https://symxapi.chevronfcu.org/devclient';
        api.Name = 'ProductionURL';
        insert api;
        
        Member360_TypeTranslate__c t= new Member360_TypeTranslate__c();
        t.name='0000/Primary';
        insert t;
        
       /* User u=new User();
        u.Email='test@test.com';
        insert u;*/
        
        
        
        Wires_Progress_Email_Test__c wpt = new Wires_Progress_Email_Test__c();
        wpt.Name = 'Test';
        wpt.Email__c = 'test@test.com';
        insert wpt;
        
        Wires_Docusign_Emails__c wde = new Wires_Docusign_Emails__c();
        wde.Name = 'Email For Testing';
        wde.Emails__c = 'Testing';
        insert wde;
        
        
         Account acc = new Account();
        //acc.RecordTypeID=rtId;
        acc.FirstName='Test FName';
        acc.LastName='Test LName';    
        acc.Mobile_Phone__pc='555-469-3885'; 
        acc.Home_Phone__pc='555-469-3886';
        acc.Work_Phone__pc='555-469-3887';
        acc.Email_raw__c='test@test.com'; 	
        acc.PersonEmail='test1@test.com'; 
        acc.PersonID__c='V565138120';
        insert acc;
        
        acc.Mobile_Phone__pc='555-479-3885'; 
        update acc;
        
        
        
        Account_Details__c accDetail = new Account_Details__c();
        accDetail.Name = '00000000123';
        accDetail.RecType__c = 'ACCT';
        accDetail.TypeTranslate__c = '1-PERSONAL';
        accDetail.ID1__c = '001';
        accDetail.OPEN_DATE__c = Date.newInstance(2018, 12, 10);
        insert accDetail;
        
        
        
        
       
        
        List<Person_Account__c> person_obj= new List<Person_Account__c>{
            new Person_Account__c(TypeTranslate__c='0000/Primary',Account_Number__c = accDetail.Id, PersonID__c = acc.Id), 
                new Person_Account__c(TypeTranslate__c='0000/Primary',Account_Number__c = accDetail.Id, PersonID__c = acc.Id)};
                    Insert person_obj;
        
        
                
        
        WIRES_Transaction__c objWC = new WIRES_Transaction__c();
        objWC.Description__c='test';
        objWC.Fees__c = 30.0;
        objWC.Chevron_Account_Number__c = accDetail.Name;
        objWC.Share_ID__c ='001';
        objWC.FromAccount__c = accDetail.Name;
        //objWC.Mobile_Phone__c = '1234567890';
       objWC.Member_SSN__c='565138120';
        objWC.WireAmount__c=500;
        objWC.Frequency__c = 'Recurring';
        //objWC.Current_Reviewer__c = UserInfo.getUserId();
        objWC.Approval_Status__c = 'Rejected';
        objWC.Source__c ='Branch';

        insert objWC;
        
          //WIRES_Transaction__c objWC = new WIRES_Transaction__c();
        objWC.WireAmount__c= 5000;
        objWC.Current_Reviewer__c = UserInfo.getUserId();
        objWC.First_Reviewer__c = UserInfo.getUserId();
        objWC.Frequency__c = 'One - Time';
        objWC.Source__c ='Branch';

        objWC.Status__c ='Completed';
        //objWC.Source__c = 'Online Banking';
        update objWC;
    }
    
    static testMethod void test3(){
        
        SolarLoan_To_Episys_API_Details__c api = new SolarLoan_To_Episys_API_Details__c();
        api.URL__c = 'https://symxapi.chevronfcu.org/devclient';
        api.Name = 'ProductionURL';
        insert api;
        
        Member360_TypeTranslate__c t= new Member360_TypeTranslate__c();
        t.name='0000/Primary';
        insert t;
        
       /* User u=new User();
        u.Email='test@test.com';
        insert u;*/
        
        
        
        Wires_Progress_Email_Test__c wpt = new Wires_Progress_Email_Test__c();
        wpt.Name = 'Test';
        wpt.Email__c = 'test@test.com';
        insert wpt;
        
        Wires_Docusign_Emails__c wde = new Wires_Docusign_Emails__c();
        wde.Name = 'Email For Testing';
        wde.Emails__c = 'Testing';
        insert wde;
        
        
         Account acc = new Account();
        //acc.RecordTypeID=rtId;
        acc.FirstName='Test FName';
        acc.LastName='Test LName';    
        acc.Mobile_Phone__pc='555-469-3885'; 
        acc.Home_Phone__pc='555-469-3886';
        acc.Work_Phone__pc='555-469-3887';
        acc.Email_raw__c='test@test.com'; 	
        acc.PersonEmail='test1@test.com'; 
        acc.PersonID__c='V565138120';
        insert acc;
        
        acc.Mobile_Phone__pc='555-479-3885'; 
        update acc;
        
        
        
        Account_Details__c accDetail = new Account_Details__c();
        accDetail.Name = '00000000123';
        accDetail.RecType__c = 'ACCT';
        accDetail.TypeTranslate__c = '1-PERSONAL';
        accDetail.ID1__c = '001';
        accDetail.OPEN_DATE__c = Date.newInstance(2018, 12, 10);
        insert accDetail;
        
        
        
        
       
        
        List<Person_Account__c> person_obj= new List<Person_Account__c>{
            new Person_Account__c(TypeTranslate__c='0000/Primary',Account_Number__c = accDetail.Id, PersonID__c = acc.Id), 
                new Person_Account__c(TypeTranslate__c='0000/Primary',Account_Number__c = accDetail.Id, PersonID__c = acc.Id)};
                    Insert person_obj;
        
 
                
                
        
        WIRES_Transaction__c objWC = new WIRES_Transaction__c();
        objWC.Description__c='test';
        objWC.Fees__c = 30.0;
        objWC.Chevron_Account_Number__c = accDetail.Name;
        objWC.Share_ID__c ='001';
        objWC.FromAccount__c = accDetail.Name;
        //objWC.Mobile_Phone__c = '1234567890';
       objWC.Member_SSN__c='565138120';
        objWC.WireAmount__c=100;
        objWC.Frequency__c = 'Recurring';
        objWC.Current_Reviewer__c = UserInfo.getUserId();
		
        insert objWC;
        
        
        
        objWC.WireAmount__c= 10001;
        objWC.Current_Reviewer__c = UserInfo.getUserId();
       // objWC.First_Reviewer__c = UserInfo.getUserId();
        objWC.Frequency__c = 'One - Time';
        objWC.Approval_Status__c = 'Released In WireXchange';
        objWC.Status__c ='Declined';
        objWC.Source__c = 'Online Banking';
        objWC.Has_Additional_Documents__c = true;
        update objWC;
        
    }
    
}