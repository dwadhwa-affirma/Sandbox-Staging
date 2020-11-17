@isTest
public class CreateOpportunityB2BControllerTest {
   
    static testMethod void CreateOpportunityB2BControllerTest(){
        
        SolarLoan_To_Episys_API_Details__c api = new SolarLoan_To_Episys_API_Details__c();
        api.URL__c = 'https://symxapi.chevronfcu.org/devclient';
        api.Name = 'ProductionURL';
        insert api;
        
        string uid= UserInfo.getUserId();
        User usr = [Select id, name, alias from User where id=:uid];
        List<Episys_User__c> eusr = [SELECT id, alias__c, Assigned_Branch__c,Episys_ID__c, Branch_Name__c,Default__c from Episys_User__c 
                                     where alias__c=:usr.alias order by Default__c desc];
        
        Account_Details__c accDetails = new Account_Details__c();
        accDetails.Name = 'test';
        accDetails.SecureEmailAddress__c = 'sample@sample.com';
        accDetails.Created_By_User__c = 1;
        insert accDetails;
        
        Account_Details__c accDetail = new Account_Details__c();
        accDetail.Name = 'Test';
        accDetail.RecType__c = 'ACCT';
        insert accDetail;
        
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
        
        
        Person_Account__c pa = new Person_Account__c();
        pa.PersonID__c = acc.Id;
        pa.Account_Number__c = accDetail.Id;
        insert pa;
        
        Episys_User__c eu = new Episys_User__c();
        eu.Episys_ID__c = 1;
        eu.Episys_Name__c = 'testname';
        accDetails.SecureEmailAddress__c = 'sample@sample.com';
        insert eu;
        
        Group	listQueue = [select id,Name,Email from Group where Type = 'Queue' and (Email like '%lead.com') limit 1];
        
        Account account_Obj = new Account(PersonHomePhone='', PersonHasOptedOutOfEmail = false, Name = 'MARIA BANDA');
        insert account_Obj; 
        
        
        
        Lead ld = new Lead (LastName = 'Test',Product_Type__c = 'Card',Brand__c = 'CFCU',FirstName = 'test',MiddleName = 'New', Description = 'New',
                            Salutation = 'MR.',Suffix = 'MR',Status = 'New',Phone= '1234567890',Email='test@test.com',MobilePhone='1234567892',How_did_you_hear_about_us__c='Website',Event_Source__c='Event-Reston-Open House-04/20/18',
                            LeadSource='BDO-Realtor Referral' , Ownership__c='Queue', OwnerId = listQueue.Id, Street_Address_1__c='Address 1',State__c= 'NY',Zip_Code__c= '12345',City__c='NYC',Country__c ='USA');
        insert ld;
        
        Account account_Obj1 = new Account(PersonHomePhone='', PersonHasOptedOutOfEmail = false, Name = 'MARIA BANDA', Parent_Lead__c =ld.id);
        insert account_Obj1;  	
        
        Opportunity op = new Opportunity(Name = 'Name', StageName = 'Open',Product_Type__c = 'Misc', CloseDate = system.today(),  Is_Converted__c = true, Queue_Assigned_Id__c= listQueue.Id,  Opportunity_Source__c = 'Word of mouth', AccountId = account_Obj.id,  Ownership__c = 'Auto Assign', Episys_User_ID__c = 1);
        
        
        Opportunity op1 = new Opportunity(Name = 'Name', StageName = 'Open',Product_Type__c = 'Misc', CloseDate = system.today(),  Is_Converted__c = true, Queue_Assigned_Id__c= listQueue.Id,  Opportunity_Source__c = 'Word of mouth', AccountId = account_Obj.id,  Ownership__c = 'Auto Assign', Episys_User_ID__c = 1033);
        
        
        Opportunity op2 = new Opportunity(Name = 'Name', StageName = 'Open',Product_Type__c = 'Misc', CloseDate = system.today(),  Is_Converted__c = false, Queue_Assigned_Id__c= listQueue.Id,  Opportunity_Source__c = 'Word of mouth', AccountId = account_Obj.id,  Ownership__c = 'Keep', Episys_User_ID__c = 1);
        
        
        Opportunity op3 = new Opportunity(Name = 'Name', StageName = 'Open', Product_Type__c = 'Misc',CloseDate = system.today(),  Is_Converted__c = false, Queue_Assigned_Id__c= listQueue.Id,  Opportunity_Source__c = 'Branch Call', AccountId = account_Obj1.id,  Ownership__c = 'Auto Assign', Episys_User_ID__c = 1);
        
        Opportunity op4 = new Opportunity(Name = 'Name', StageName = 'Open', Product_Type__c = 'Misc', CloseDate = system.today(),  Is_Converted__c = false, Queue_Assigned_Id__c= listQueue.Id,  Opportunity_Source__c = 'Word of mouth', AccountId = account_Obj.id,  Ownership__c = 'Auto Assign', Episys_User_ID__c = 1);
        // Opportunity op5 = new Opportunity(Name = 'Name', StageName = 'Open', Product_Type__c = 'Misc', CloseDate = system.today(),  Is_Converted__c = false, Queue_Assigned_Id__c= listQueue.Id,  Opportunity_Source__c = 'Word of mouth', AccountId = pa.id,  Ownership__c = 'Auto Assign');
        Opportunity op6 = new Opportunity(Name = 'Name', StageName = 'Open', Product_Type__c = 'Misc', CloseDate = system.today(),  Is_Converted__c = false, Queue_Assigned_Id__c= listQueue.Id,  Opportunity_Source__c = 'Branch Call', AccountId = account_Obj.id,  Ownership__c = 'Auto Assign',Episys_User_ID__c = 1);
        Opportunity op7 = new Opportunity(Name = 'Name', StageName = 'Open', Product_Type__c = 'Misc', CloseDate = system.today(),  Is_Converted__c = false, Queue_Assigned_Id__c= listQueue.Id,  Opportunity_Source__c = 'Branch Call', AccountId = account_Obj.id,  Ownership__c = 'Keep');
        Opportunity op8 = new Opportunity(Name = 'Name', StageName = 'Open', Product_Type__c = 'Misc', CloseDate = system.today(),  Is_Converted__c = false, Queue_Assigned_Id__c= listQueue.Id,  Opportunity_Source__c = 'Branch Call', AccountId = account_Obj.id,  Ownership__c = 'Assign');
        Opportunity op9 = new Opportunity(Name = 'Name', StageName = 'Open',Product_Sub__c = 'Credit Cards', Product_Type__c = 'Cards', CloseDate = system.today(),  Is_Converted__c = false, Queue_Assigned_Id__c= listQueue.Id,  Opportunity_Source__c = 'Branch Call', AccountId = account_Obj.id,  Ownership__c = 'Assign');
        
        List<Opportunity> insertopp = new List<Opportunity>();
        insertopp.Add(op);
        insertopp.Add(op1);
        insertopp.Add(op2);
        insertopp.Add(op3);
        insertopp.Add(op4);  
        
        test.StartTest();
        insert insertopp;
       	CreateOpportunityB2BController.FetchLeadData(acc.id);
        CreateOpportunityB2BController.OpportunityInsertUpdate(op9);
        BDCompanyTabController.listValues('Account');
        test.stopTest();
        
    }
}