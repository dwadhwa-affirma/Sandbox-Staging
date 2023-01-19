@isTest
public  class OpportunityTriggerTest {
   
    @testSetup
    static void SetUp(){
            
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
        accDetail.Name = '000003456';
        accDetail.RecType__c = 'ACCT';
        accDetail.Open_Date__c = system.today() - 2;
        insert accDetail;
        
        Account_Details__c accDetail2 = new Account_Details__c();
        accDetail2.Name = '000003456';
        accDetail2.RecType__c = 'LOAN';
        accDetail2.ID1__c = '7500';
        insert accDetail2;
            
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
        pa.Name_Type__c = 0;
        pa.Account_Number__c = accDetail.Id;
        insert pa;
        
        Episys_User__c eu = new Episys_User__c();
        eu.Episys_ID__c = 1;
        eu.Episys_Name__c = 'testname';
        accDetails.SecureEmailAddress__c = 'sample@sample.com';
        eu.alias__c = usr.alias;
        insert eu;
        
        Group   listQueue = [select id,Name,Email from Group where Type = 'Queue' and (Email like '%lead.com') limit 1];
        
        Account account_Obj = new Account(PersonHomePhone='', PersonHasOptedOutOfEmail = false, Name = 'MARIA BANDA');
        insert account_Obj; 
                        
        test.StartTest();
        
        Lead ld = new Lead (LastName = 'Test',Product_Type__c = 'Card',Brand__c = 'CFCU',FirstName = 'test',MiddleName = 'New', Description = 'New',
        Salutation = 'MR.',Suffix = 'MR',Status = 'New',Phone= '1234567890',Email='test@test.com',MobilePhone='1234567892',How_did_you_hear_about_us__c='Website',
        LeadSource='BDO-Realtor Referral' , Ownership__c='Queue', OwnerId = listQueue.Id, Street_Address_1__c='Address 1',State__c= 'NY',Zip_Code__c= '12345',City__c='NYC',Country__c ='USA');

        insert ld;
        
        Account account_Obj1 = new Account(PersonHomePhone='', PersonHasOptedOutOfEmail = false, Name = 'MARIA BANDA', Parent_Lead__c =ld.id);
        insert account_Obj1;    
          
        Opportunity op = new Opportunity(Event_Source__c='Advantage Credit',Name = 'Name', member_account__c = accDetail.id, StageName = 'Open',Product_Type__c = 'Misc', CloseDate = system.today(),  Is_Converted__c = true, Queue_Assigned_Id__c= listQueue.Id,  Opportunity_Source__c = 'Word of mouth', AccountId = account_Obj.id,  Ownership__c = 'Auto Assign', Episys_User_ID__c = 1);
        
        
        Opportunity op1 = new Opportunity(Event_Source__c='Advantage Credit',Name = 'Name', member_account__c = accDetail.id, StageName = 'Open',Product_Type__c = 'Misc', CloseDate = system.today(),  Is_Converted__c = true, Queue_Assigned_Id__c= listQueue.Id,  Opportunity_Source__c = 'Word of mouth', AccountId = account_Obj.id,  Ownership__c = 'Auto Assign', Episys_User_ID__c = 1033);
        
        
        Opportunity op2 = new Opportunity(Event_Source__c='Advantage Credit',Name = 'Name', Product_Amount__c=100,member_account__c = accDetail.id, StageName = 'Open',Product_Type__c = 'Misc', CloseDate = system.today(),  Is_Converted__c = false, Queue_Assigned_Id__c= listQueue.Id,  Opportunity_Source__c = 'Word of mouth', AccountId = account_Obj.id,  Ownership__c = 'Keep', Episys_User_ID__c = 1);
        
        
        Opportunity op3 = new Opportunity(Event_Source__c='Advantage Credit',Name = 'Name',Product_Amount__c=100,member_account__c = accDetail.id,  StageName = 'Open', Product_Type__c = 'Misc',CloseDate = system.today(),  Is_Converted__c = false, Queue_Assigned_Id__c= listQueue.Id,  Opportunity_Source__c = 'Branch Call', AccountId = account_Obj1.id,  Ownership__c = 'Auto Assign', Episys_User_ID__c = 1);
        
        Opportunity op4 = new Opportunity(Event_Source__c='Advantage Credit',Name = 'Name',Product_Amount__c=100, member_account__c = accDetail.id, StageName = 'Open', Product_Type__c = 'Misc', CloseDate = system.today(),  Is_Converted__c = false, Queue_Assigned_Id__c= listQueue.Id,  Opportunity_Source__c = 'Word of mouth', AccountId = account_Obj.id,  Ownership__c = 'Auto Assign', Episys_User_ID__c = 1);
        Opportunity op5 = new Opportunity(Event_Source__c='Advantage Credit',Name = 'Name', Product_Amount__c=100,member_account__c = accDetail.id, StageName = 'Open', Product_Type__c = 'Misc', CloseDate = system.today(),  Is_Converted__c = false, Queue_Assigned_Id__c= listQueue.Id,  Opportunity_Source__c = 'Branch Call',   AccountId = account_Obj.id,  Ownership__c = 'Auto Assign', Episys_User_ID__c = 0);
        Opportunity op6 = new Opportunity(Event_Source__c='Advantage Credit',Name = 'Name',Product_Amount__c=100,member_account__c = accDetail.id,  StageName = 'Open', Product_Type__c = 'Misc', CloseDate = system.today(),  Is_Converted__c = false, Queue_Assigned_Id__c= listQueue.Id,  Opportunity_Source__c = 'Branch Call',   AccountId = account_Obj.id,  Ownership__c = 'Auto Assign');
        
        Opportunity op7 = new Opportunity(Event_Source__c='Advantage Credit',Name = 'Name',Product_Amount__c=100,member_account__c = accDetail.id, Product_Sub__c = 'Pre Select Auto',Product_Type__c = 'Consumer Lending', StageName = 'Open', CloseDate = system.today(),  Is_Converted__c = false, Queue_Assigned_Id__c= listQueue.Id,  Opportunity_Source__c = 'Event', AccountId = account_Obj.id,  Ownership__c = 'Auto Assign');
        Opportunity op8 = new Opportunity(Event_Source__c='Advantage Credit',Name = 'Name',Product_Amount__c=100,member_account__c = accDetail.id,  StageName = 'Open', Product_Type__c = 'Misc',CloseDate = system.today(),  Is_Converted__c = false, Queue_Assigned_Id__c= listQueue.Id,  Opportunity_Source__c = 'Campaign Outreach', DESCRIPTION = 'Relevant Member Number',AccountId = account_Obj1.id,  Ownership__c = 'Auto Assign', Episys_User_ID__c = 1);
        Opportunity op9 = new Opportunity(Event_Source__c='Advantage Credit',Name = 'Name',Product_Amount__c=100,member_account__c = accDetail.id,  StageName = 'Open', Product_Type__c = 'Misc',CloseDate = system.today(),  Is_Converted__c = false, Queue_Assigned_Id__c= listQueue.Id,  Opportunity_Source__c = 'Campaign Outreach', DESCRIPTION = 'Last Activity Date',AccountId = account_Obj1.id,  Ownership__c = 'Auto Assign', Episys_User_ID__c = 1);
        Opportunity op10 = new Opportunity(Event_Source__c='Advantage Credit',Name = 'Name',Product_Amount__c=100,member_account__c = accDetail.id,  StageName = 'Open', Product_Type__c = 'Misc',CloseDate = system.today(),  Is_Converted__c = false, Queue_Assigned_Id__c= listQueue.Id,  Opportunity_Source__c = 'Campaign Outreach', DESCRIPTION = 'Dormant Date',AccountId = account_Obj1.id,  Ownership__c = 'Auto Assign', Episys_User_ID__c = 1);
        Opportunity op11 = new Opportunity(Event_Source__c='Advantage Credit',Name = 'Name',Product_Amount__c=100,member_account__c = accDetail.id,  StageName = 'Open', Product_Type__c = 'Misc',CloseDate = system.today(),  Is_Converted__c = false, Queue_Assigned_Id__c= listQueue.Id,  Opportunity_Source__c = 'Campaign Outreach', DESCRIPTION = 'High Value/High Potential',AccountId = acc.id,  Ownership__c = 'Auto Assign', Episys_User_ID__c = 1);
        Opportunity op12 = new Opportunity(Event_Source__c='Advantage Credit',Name = 'Name',Product_Amount__c=100,member_account__c = accDetail.id,  StageName = 'Open', Product_Type__c = 'Misc',CloseDate = system.today(),  Is_Converted__c = false, Queue_Assigned_Id__c= listQueue.Id,  Opportunity_Source__c = 'Campaign Outreach', DESCRIPTION = 'Script Link',AccountId = acc.id,  Ownership__c = 'Auto Assign', Episys_User_ID__c = 1);
        
        Opportunity op13 = new Opportunity(Event_Source__c='Contractor Visit',Name = 'Test 13',Product_Amount__c=100,member_account__c = accDetail.id,  StageName = 'New', Product_Type__c = 'Mortgage',Product_Sub__c = 'Refinance', CloseDate = system.today().adddays(3), Is_Converted__c = false, Queue_Assigned_Id__c= listQueue.Id,  Opportunity_Source__c = 'Branch Call',   AccountId = account_Obj.id,  Ownership__c = 'Auto Assign',Last_TimeStamp_Updated__c = system.today());
        Opportunity op22 = new Opportunity(Event_Source__c='Advantage Credit',Product_Amount__c=1000, Name = 'Test 22',member_account__c = accDetail.Id,  StageName = 'Fulfillment', Product_Type__c = 'Mortgage',Product_Sub__c = 'Refinance', CloseDate = system.today().adddays(3), Is_Converted__c = false,  Opportunity_Source__c = 'Blend Incomplete',   AccountId = account_Obj.Id,  Ownership__c = 'Auto Assign',Last_TimeStamp_Updated__c = system.today());
        Opportunity op23 = new Opportunity(Event_Source__c='Advantage Credit',Product_Amount__c=1000, Name = 'Test 16',member_account__c = accDetail.Id,  StageName = 'New', Product_Type__c = 'Mortgage',Product_Sub__c = 'Refinance', CloseDate = system.today().adddays(3), Is_Converted__c = false,  Opportunity_Source__c = 'Branch Call',   AccountId = account_Obj.Id,  Ownership__c = 'Auto Assign',Last_TimeStamp_Updated__c = system.today());
        Opportunity op24 = new Opportunity(Event_Source__c='Advantage Credit',Product_Amount__c=1000, Name = 'Test 16',member_account__c = accDetail.Id,  StageName = 'New', Product_Type__c = 'Mortgage',Product_Sub__c = 'Refinance', CloseDate = system.today().adddays(3), Is_Converted__c = false,  Opportunity_Source__c = 'Branch Call',   AccountId = account_Obj.Id,  Ownership__c = 'Auto Assign',Last_TimeStamp_Updated__c = system.today());
        Opportunity op25 = new Opportunity(Event_Source__c='Advantage Credit',Product_Amount__c=1000, Name = 'Test 16',member_account__c = accDetail.Id,  StageName = 'New', Product_Type__c = 'Mortgage',Product_Sub__c = 'Refinance', CloseDate = system.today().adddays(3), Is_Converted__c = false,  Opportunity_Source__c = 'Branch Call',   AccountId = account_Obj.Id,  Ownership__c = 'Auto Assign',Last_TimeStamp_Updated__c = system.today());        
        Opportunity op26 = new Opportunity(Event_Source__c='Advantage Credit',Product_Amount__c=1000, Name = 'Test 16',member_account__c = accDetail.Id,  StageName = 'New', Product_Type__c = 'Mortgage',Product_Sub__c = 'Refinance', CloseDate = system.today().adddays(3), Is_Converted__c = false,  Opportunity_Source__c = 'Branch Call',   AccountId = account_Obj.Id,  Ownership__c = 'Auto Assign',Last_TimeStamp_Updated__c = system.today());        

        Opportunity op27 = new Opportunity(Event_Source__c='Advantage Credit',Product_Amount__c=1000, Name = 'Test 27',Sub_Status__c ='1st Attempt',member_account__c = accDetail.Id,  StageName = 'Outreach', Product_Type__c = 'Mortgage',Product_Sub__c = 'Refinance', CloseDate = system.today().adddays(3), Is_Converted__c = false,  Opportunity_Source__c = 'Branch Call',   AccountId = account_Obj.Id,  Ownership__c = 'Auto Assign',Last_TimeStamp_Updated__c = datetime.now());        
        Opportunity op28 = new Opportunity(Event_Source__c='Advantage Credit',Product_Amount__c=1000, Name = 'Test 27',member_account__c = accDetail.Id,  StageName = 'Considering', Product_Type__c = 'Mortgage',Product_Sub__c = 'Refinance', CloseDate = system.today().adddays(3), Is_Converted__c = false,  Opportunity_Source__c = 'Branch Call',   AccountId = account_Obj.Id,  Ownership__c = 'Auto Assign',Last_TimeStamp_Updated__c = datetime.now());        
        Opportunity op29 = new Opportunity(Event_Source__c='Advantage Credit',Product_Amount__c=1000, Name = 'Test 27',member_account__c = accDetail.Id,  StageName = 'Fulfillment', Product_Type__c = 'Mortgage',Product_Sub__c = 'Refinance', CloseDate = system.today().adddays(3), Is_Converted__c = false,  Opportunity_Source__c = 'Branch Call',   AccountId = account_Obj.Id,  Ownership__c = 'Auto Assign',Last_TimeStamp_Updated__c = datetime.now());        
        Opportunity op30 = new Opportunity(Event_Source__c='Advantage Credit',Product_Amount__c=1000, Name = 'Test 27',member_account__c = accDetail.Id,  StageName = 'Analyzing Needs', Product_Type__c = 'Mortgage',Product_Sub__c = 'Refinance', CloseDate = system.today().adddays(3), Is_Converted__c = false,  Opportunity_Source__c = 'Branch Call',   AccountId = account_Obj.Id,  Ownership__c = 'Auto Assign',Last_TimeStamp_Updated__c = datetime.now());        


        List<Opportunity> insertopp = new List<Opportunity>();
        insertopp.Add(op);
        insertopp.Add(op1);
        insertopp.Add(op2);
        insertopp.Add(op3);
        insertopp.Add(op4);
        insertopp.Add(op5);
        insertopp.Add(op6);
        insertopp.Add(op7);
        insertopp.Add(op8);
        insertopp.Add(op9);
        insertopp.Add(op10);
        insertopp.Add(op11);
        insertopp.Add(op12);
        insertopp.Add(op13);
        insertopp.Add(op22);
        insertopp.Add(op23);
        insertopp.Add(op24);

        insertopp.Add(op26);
        insertopp.Add(op27);
        insertopp.Add(op28);

        insertopp.Add(op29);
        insertopp.Add(op30);
         
        insert insertopp;  
        test.stopTest();
    }
    
    static testMethod void OpportunityTriggerHandlerTest() {
       
        Test.startTest(); 
            Account account_Obj = [Select Id from Account limit 1];
            Account_Details__c ad = [select id from Account_Details__c where RecType__c = 'ACCT' limit 1];
            Lead l = [Select id, Status,Ownership__c, LeadSource,Product_Type__c,Episys_User_ID__c from Lead limit 1];
            Opportunity op = [Select id,  Ownership__c,Queue_Owner__c,User_Owner__c,Queue_Assigned_Id__c from Opportunity where Ownership__c = 'Auto Assign' limit 1 ];
            Opportunity op1 = [Select id,  Ownership__c,Queue_Owner__c,User_Owner__c,Queue_Assigned_Id__c from Opportunity where Ownership__c = 'Keep' limit 1];
            op.StageName = 'Closed Won';  
            op1.StageName = 'Closed Won';
            
             update op;  
             update op1; 
        try{
            op.Opportunity_Source__c = 'BDO-Realtor Referral'; 
            update op;
        }
        catch(Exception error){
            System.debug('###' +    error.getMessage());
            System.assert(error.getMessage().contains('Opportunity Source is read only for Opportunity converted from Lead.')); 
        }
        try{
            op1.Is_Converted__c = true;
            op1.Brand__C ='Spectrum' ;
            update op1;
        }
        catch(Exception error){
           System.assert(error.getMessage().contains('Brand is read only for Opportunity converted from Lead.')); 
        }
        try{
            op1.Product_Type__c ='Cards' ;
            update op1;
        }
        catch(Exception error){
            System.assert(error.getMessage().contains('Product Type is read only for Opportunity converted from Lead.')); 
        }
        try{
            op1.Product_Sub__c ='Credit Cards' ;
            op1.member_account__c = null;
            update op1;
        }
        catch(Exception error){
            System.assert(error.getMessage().contains('Product Subtype is read only for Opportunity converted from Lead.')); 
        }
        try{
            op1.How_did_you_hear_about_us__c ='Employer' ;
            update op1;
        }
        catch(Exception error){
            System.assert(error.getMessage().contains('How did you hear about us is read only for Opportunity converted from Lead.')); 
        }
        try{
            op1.closedate = system.today().adddays(1) ;
            update op1;
        }
        catch(Exception error){
            System.assert(error.getMessage().contains('Close date is read only')); 
        }
        try{
            op1.AccountId = account_Obj.id ;
            update op1;
        }
        catch(Exception error){
            System.assert(error.getMessage().contains('Member name is read only')); 
        }
        Test.stopTest();  
    }

    static testMethod void OpportunityTriggerHandlerTest1() {
       
        Test.startTest(); 
        Account account_Obj = [Select Id from Account limit 1];
        Account_Details__c ad = [select id from Account_Details__c where RecType__c = 'ACCT' limit 1];
        Lead l = [Select id, Status,Ownership__c, LeadSource,Product_Type__c,Episys_User_ID__c from Lead limit 1];
        Opportunity op = [Select id,  Ownership__c,Queue_Owner__c,User_Owner__c,Queue_Assigned_Id__c from Opportunity where Ownership__c = 'Auto Assign' limit 1 ];
        Opportunity op1 = [Select id,  Ownership__c,Queue_Owner__c,User_Owner__c,Queue_Assigned_Id__c from Opportunity where Ownership__c = 'Keep' limit 1];
        op.StageName = 'Closed Won';  
        op1.StageName = 'Closed Won';
        op1.Product_Type__c = 'Consumer Lending';
        op1.Product_Sub__c = 'Pre Select Auto';
        update op;  
        update op1; 
        
        Test.stopTest();  
    }    

    static testMethod void OpportunityTriggerHandlerTest2() {
      Test.startTest();
      List<Account> accountObj = [SELECT Id From Account WHERE Name = 'MARIA BANDA' LIMIT 1];
      System.debug('Test Account Id: ' + accountObj[0].Id);

      List<Account_Details__c> accDetailObj = [SELECT Id From Account_Details__c WHERE Name = '000003456' LIMIT 1];
      System.debug('Test Account_Details__c Id: ' + accDetailObj[0].Id);

      Opportunity op14 = new Opportunity(Event_Source__c='Advantage Credit',Name = 'Test 14',member_account__c = accDetailObj[0].Id,  StageName = 'New', Product_Type__c = 'Mortgage',Product_Sub__c = 'Refinance', CloseDate = system.today().adddays(3), Is_Converted__c = false,  Opportunity_Source__c = 'Branch Call',   AccountId = accountObj[0].Id,  Ownership__c = 'Auto Assign',Last_TimeStamp_Updated__c = system.today());
      insert op14;
      System.debug('Test Opp');
      System.debug(op14);

      List<Opportunity> op13update = [SELECT Id, Name, Event_Source__c FROM Opportunity WHERE Event_Source__c = 'Contractor Visit' LIMIT 1];
      op13update[0].Event_Source__c = 'Membership Appreciation Drive';
      update op13update;
      System.debug('Update Test Opp 13');
      System.debug(op13update[0]);

      Test.stopTest();

    }

    static testMethod void OpportunityHelperTest() {
        Test.startTest();
        List<Account> accountObj = [SELECT Id From Account WHERE Name = 'MARIA BANDA' LIMIT 1];
        System.debug('Test Account Id: ' + accountObj[0].Id);
  
        List<Account_Details__c> accDetailObj = [SELECT Id From Account_Details__c WHERE Name = '000003456' LIMIT 1];
        System.debug('Test Account_Details__c Id: ' + accDetailObj[0].Id);
  
        Opportunity op14 = new Opportunity(Event_Source__c='Advantage Credit',Name = 'Test 14',member_account__c = accDetailObj[0].Id,  StageName = 'New', Product_Type__c = 'Mortgage',Product_Sub__c = 'Refinance', CloseDate = system.today().adddays(3), Is_Converted__c = false,  Opportunity_Source__c = 'Branch Call',   AccountId = accountObj[0].Id,  Ownership__c = 'Auto Assign',Last_TimeStamp_Updated__c = system.today());
        insert op14;
        System.debug('Test Opp');
        System.debug(op14);

        op14.Last_TimeStamp_Updated__c = Datetime.Now();
        op14.Product_Amount__c = 1000;
        op14.Sub_Status__c = '1st Attempt';
        op14.Stagename = 'Outreach';
        update op14;

        Test.stopTest();
  
      }


      static testMethod void OpportunityHelperTest2() {
        Test.startTest();
        List<Account> accountObj = [SELECT Id From Account WHERE Name = 'MARIA BANDA' LIMIT 1];
        System.debug('Test Account Id: ' + accountObj[0].Id);
  
        List<Account_Details__c> accDetailObj = [SELECT Id From Account_Details__c WHERE Name = '000003456' LIMIT 1];
        System.debug('Test Account_Details__c Id: ' + accDetailObj[0].Id);
  
        Opportunity op16 = new Opportunity(Event_Source__c='Advantage Credit',Sub_Status__c ='1st Attempt',Product_Amount__c=1000, Name = 'Test 16',member_account__c = accDetailObj[0].Id,  StageName = 'Outreach', Product_Type__c = 'Mortgage',Product_Sub__c = 'Refinance', CloseDate = system.today().adddays(3), Is_Converted__c = false,  Opportunity_Source__c = 'Branch Call',   AccountId = accountObj[0].Id,  Ownership__c = 'Auto Assign',Last_TimeStamp_Updated__c = system.today());
        insert op16;

        

        Test.stopTest();
      }

      static testMethod void OpportunityHelperTest3() {
        Test.startTest();
        List<Account> accountObj = [SELECT Id From Account WHERE Name = 'MARIA BANDA' LIMIT 1];
        System.debug('Test Account Id: ' + accountObj[0].Id);
  
        List<Account_Details__c> accDetailObj = [SELECT Id From Account_Details__c WHERE Name = '000003456' LIMIT 1];
        System.debug('Test Account_Details__c Id: ' + accDetailObj[0].Id);
  
        Opportunity op19 = new Opportunity(Event_Source__c='Advantage Credit',Product_Amount__c=1000, Name = 'Test 17',member_account__c = accDetailObj[0].Id,  StageName = 'Considering', Product_Type__c = 'Mortgage',Product_Sub__c = 'Refinance', CloseDate = system.today().adddays(3), Is_Converted__c = false,  Opportunity_Source__c = 'Branch Call',   AccountId = accountObj[0].Id,  Ownership__c = 'Auto Assign',Last_TimeStamp_Updated__c = system.today());
        insert op19;

        Test.stopTest();

  
      }

      static testMethod void OpportunityHelperTest4() {
        Test.startTest();
        List<Account> accountObj = [SELECT Id From Account WHERE Name = 'MARIA BANDA' LIMIT 1];
        System.debug('Test Account Id: ' + accountObj[0].Id);
  
        List<Account_Details__c> accDetailObj = [SELECT Id From Account_Details__c WHERE Name = '000003456' LIMIT 1];
        System.debug('Test Account_Details__c Id: ' + accDetailObj[0].Id);
  
        Opportunity op20 = new Opportunity(Event_Source__c='Advantage Credit',Product_Amount__c=1000, Name = 'Test 17',member_account__c = accDetailObj[0].Id,  StageName = 'Analyzing Needs', Product_Type__c = 'Mortgage',Product_Sub__c = 'Refinance', CloseDate = system.today().adddays(3), Is_Converted__c = false,  Opportunity_Source__c = 'Branch Call',   AccountId = accountObj[0].Id,  Ownership__c = 'Auto Assign',Last_TimeStamp_Updated__c = system.today());
        insert op20;

        Test.stopTest();

  
      }

      static testMethod void OpportunityHelperTest5() {
        Test.startTest();
        List<Account> accountObj = [SELECT Id From Account WHERE Name = 'MARIA BANDA' LIMIT 1];
        System.debug('Test Account Id: ' + accountObj[0].Id);
  
        List<Account_Details__c> accDetailObj = [SELECT Id From Account_Details__c WHERE Name = '000003456' LIMIT 1];
        System.debug('Test Account_Details__c Id: ' + accDetailObj[0].Id);
  
        Opportunity op21 = new Opportunity(Event_Source__c='Advantage Credit',Product_Amount__c=1000, Name = 'Test 17',member_account__c = accDetailObj[0].Id,  StageName = 'Fulfillment', Product_Type__c = 'Mortgage',Product_Sub__c = 'Refinance', CloseDate = system.today().adddays(3), Is_Converted__c = false,  Opportunity_Source__c = 'Branch Call',   AccountId = accountObj[0].Id,  Ownership__c = 'Auto Assign',Last_TimeStamp_Updated__c = system.today());
        insert op21;

        Test.stopTest();

  
      }

      static testMethod void OpportunityHelperTest6() {
        
        Opportunity op22 = [Select id,Name,Event_Source__c,StageName,Product_Amount__c From Opportunity where StageName != 'New' limit 1];

        Test.startTest();


        op22.StageName = 'New';
        op22.Last_TimeStamp_Updated__c = Datetime.now();
        update op22;

        Test.stopTest();

  
      }

      static testMethod void OpportunityHelperTest7() {
        
        Opportunity op23 = [SELECT id,Last_TimeStamp_Updated__c,SLA_Business_Hours__c,StageName, SLA_Breached_New_Status__c, SLA_Breached_Outreach_Status__c,SLA_Breached_Considering_Status__c, SLA_Breached_Analyzing_Needs_Status__c,SLA_Breached_Fulfillment_Status__c, SLA_New__c, SLA_Outreach__c, SLA_Considering__c, SLA_Analyzing_Needs__c,SLA_Fulfillment__c, Hour_Spent_New_Status__c,Hour_Spent_Outreach_Status__c,Hour_Spent_Considering_Status__c,Hour_Spent_Analyzing_Needs_Status__c,Hour_Spent_Fulfillment_Status__c,TimeStamp_New_status__c,TimeStamp_Outreach_status__c,TimeStamp_Considering_status__c,TimeStamp_Analyzing_Needs_status__c,TimeStamp_Fulfillment_status__c,Product_Type__c,Total_Opportunity_Business_Hours__c From Opportunity where StageName = 'New' and Product_Type__c = 'Mortgage' and Opportunity_Source__c ='Branch Call'  limit 1];

        Test.startTest();

        op23.Stagename = 'Considering';
        op23.Last_TimeStamp_Updated__c = datetime.now();
        update op23;

        OpportunityTriggerHelper helper = new OpportunityTriggerHelper();

        helper.updateTimeStampOnOpp('Considering',op23,2,false);
        helper.updateTimeStampOnOpp('Considering',op23,2,true);

        helper.updateTimeStampOnOpp('Fulfillment',op23,2,false);
        helper.updateTimeStampOnOpp('Fulfillment',op23,2,true);

        helper.updateTimeStampOnOpp('Analyzing Needs',op23,2,false);
        helper.updateTimeStampOnOpp('Analyzing Needs',op23,2,true);

        helper.updateTimeStampOnOpp('Outreach',op23,2,false);
        helper.updateTimeStampOnOpp('Outreach',op23,2,true);
        helper.updateTimeStampOnOpp('New',op23,2,true);

        helper.getTimeStampFieldValue('Outreach',op23);
        helper.getTimeStampFieldValue('Fulfillment',op23);
        helper.getTimeStampFieldValue('Considering',op23);
        helper.getTimeStampFieldValue('Analyzing Needs',op23);
        helper.getTimeStampFieldValue('ABC',op23);

        helper.getOtherFieldsAreNull('Outreach',op23);
        helper.getOtherFieldsAreNull('Fulfillment',op23);
        helper.getOtherFieldsAreNull('Considering',op23);
        helper.getOtherFieldsAreNull('Analyzing Needs',op23);
        helper.getOtherFieldsAreNull('ABC',op23);

        op23.Stagename = 'New';
        update op23;

        

        Test.stopTest();

  
      }
      static testMethod void OpportunityHelperTest8() {
        
        Opportunity op24 = [SELECT id,Last_TimeStamp_Updated__c,SLA_Business_Hours__c,StageName, SLA_Breached_New_Status__c, SLA_Breached_Outreach_Status__c,SLA_Breached_Considering_Status__c, SLA_Breached_Analyzing_Needs_Status__c,SLA_Breached_Fulfillment_Status__c, SLA_New__c, SLA_Outreach__c, SLA_Considering__c, SLA_Analyzing_Needs__c,SLA_Fulfillment__c, Hour_Spent_New_Status__c,Hour_Spent_Outreach_Status__c,Hour_Spent_Considering_Status__c,Hour_Spent_Analyzing_Needs_Status__c,Hour_Spent_Fulfillment_Status__c,TimeStamp_New_status__c,TimeStamp_Outreach_status__c,TimeStamp_Considering_status__c,TimeStamp_Analyzing_Needs_status__c,TimeStamp_Fulfillment_status__c,Product_Type__c,Total_Opportunity_Business_Hours__c From Opportunity where StageName = 'New' and Product_Type__c = 'Mortgage' and Opportunity_Source__c ='Branch Call'  limit 1];

        Test.startTest();

        op24.Stagename = 'Outreach';
        op24.Product_Amount__c =1000;
        op24.Sub_Status__c ='1st Attempt';

        op24.Last_TimeStamp_Updated__c = datetime.now();
        update op24;
        Test.stopTest();

  
      }

      static testMethod void OpportunityHelperTest9() {
        
        Opportunity op24 = [SELECT id,Last_TimeStamp_Updated__c,SLA_Business_Hours__c,StageName, SLA_Breached_New_Status__c, SLA_Breached_Outreach_Status__c,SLA_Breached_Considering_Status__c, SLA_Breached_Analyzing_Needs_Status__c,SLA_Breached_Fulfillment_Status__c, SLA_New__c, SLA_Outreach__c, SLA_Considering__c, SLA_Analyzing_Needs__c,SLA_Fulfillment__c, Hour_Spent_New_Status__c,Hour_Spent_Outreach_Status__c,Hour_Spent_Considering_Status__c,Hour_Spent_Analyzing_Needs_Status__c,Hour_Spent_Fulfillment_Status__c,TimeStamp_New_status__c,TimeStamp_Outreach_status__c,TimeStamp_Considering_status__c,TimeStamp_Analyzing_Needs_status__c,TimeStamp_Fulfillment_status__c,Product_Type__c,Total_Opportunity_Business_Hours__c From Opportunity where StageName = 'Analyzing Needs' and Product_Type__c = 'Mortgage' and Opportunity_Source__c ='Branch Call'  limit 1];

        Test.startTest();

        op24.Stagename = 'Considering';
        op24.Product_Amount__c =1000;
        op24.Last_TimeStamp_Updated__c = datetime.now();
        update op24;
        Test.stopTest();
  
      }

      static testMethod void OpportunityHelperTest10() {
        
        Opportunity op24 = [SELECT id,Last_TimeStamp_Updated__c,SLA_Business_Hours__c,StageName, SLA_Breached_New_Status__c, SLA_Breached_Outreach_Status__c,SLA_Breached_Considering_Status__c, SLA_Breached_Analyzing_Needs_Status__c,SLA_Breached_Fulfillment_Status__c, SLA_New__c, SLA_Outreach__c, SLA_Considering__c, SLA_Analyzing_Needs__c,SLA_Fulfillment__c, Hour_Spent_New_Status__c,Hour_Spent_Outreach_Status__c,Hour_Spent_Considering_Status__c,Hour_Spent_Analyzing_Needs_Status__c,Hour_Spent_Fulfillment_Status__c,TimeStamp_New_status__c,TimeStamp_Outreach_status__c,TimeStamp_Considering_status__c,TimeStamp_Analyzing_Needs_status__c,TimeStamp_Fulfillment_status__c,Product_Type__c,Total_Opportunity_Business_Hours__c From Opportunity where StageName = 'Fulfillment' and Product_Type__c = 'Mortgage' and Opportunity_Source__c ='Branch Call'  limit 1];

        Test.startTest();

        op24.Stagename = 'Analyzing Needs';
        op24.Product_Amount__c =1000;
        
        op24.Last_TimeStamp_Updated__c = datetime.now();
        update op24;
        Test.stopTest();
  
      }

      static testMethod void OpportunityHelperTest11() {
        
        Opportunity op24 = [SELECT id,Last_TimeStamp_Updated__c,SLA_Business_Hours__c,StageName, SLA_Breached_New_Status__c, SLA_Breached_Outreach_Status__c,SLA_Breached_Considering_Status__c, SLA_Breached_Analyzing_Needs_Status__c,SLA_Breached_Fulfillment_Status__c, SLA_New__c, SLA_Outreach__c, SLA_Considering__c, SLA_Analyzing_Needs__c,SLA_Fulfillment__c, Hour_Spent_New_Status__c,Hour_Spent_Outreach_Status__c,Hour_Spent_Considering_Status__c,Hour_Spent_Analyzing_Needs_Status__c,Hour_Spent_Fulfillment_Status__c,TimeStamp_New_status__c,TimeStamp_Outreach_status__c,TimeStamp_Considering_status__c,TimeStamp_Analyzing_Needs_status__c,TimeStamp_Fulfillment_status__c,Product_Type__c,Total_Opportunity_Business_Hours__c From Opportunity where StageName = 'Considering' and Product_Type__c = 'Mortgage' and Opportunity_Source__c ='Branch Call'  limit 1];

        Test.startTest();

        op24.Stagename = 'Fulfillment';
        op24.Product_Amount__c =1000;
        
        op24.Last_TimeStamp_Updated__c = datetime.now();
        update op24;
        Test.stopTest();
  
      }

      static testMethod void OpportunityHelperTest12() {
        
        Opportunity op24 = [SELECT id,Last_TimeStamp_Updated__c,SLA_Business_Hours__c,StageName, SLA_Breached_New_Status__c, SLA_Breached_Outreach_Status__c,SLA_Breached_Considering_Status__c, SLA_Breached_Analyzing_Needs_Status__c,SLA_Breached_Fulfillment_Status__c, SLA_New__c, SLA_Outreach__c, SLA_Considering__c, SLA_Analyzing_Needs__c,SLA_Fulfillment__c, Hour_Spent_New_Status__c,Hour_Spent_Outreach_Status__c,Hour_Spent_Considering_Status__c,Hour_Spent_Analyzing_Needs_Status__c,Hour_Spent_Fulfillment_Status__c,TimeStamp_New_status__c,TimeStamp_Outreach_status__c,TimeStamp_Considering_status__c,TimeStamp_Analyzing_Needs_status__c,TimeStamp_Fulfillment_status__c,Product_Type__c,Total_Opportunity_Business_Hours__c From Opportunity where StageName = 'Outreach' and Product_Type__c = 'Mortgage' and Opportunity_Source__c ='Branch Call'  limit 1];

        Test.startTest();
        op24.Product_Amount__c =1000;

        op24.Stagename = 'Considering';
        op24.Last_TimeStamp_Updated__c = datetime.now();
        update op24;
        Test.stopTest();
  
      }

}