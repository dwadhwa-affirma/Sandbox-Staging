@isTest
public  class OpportunityTriggerTest {
   
    @testSetup
    static void SetUp(){
       
       SLA_Status_Manager__c sla = new SLA_Status_Manager__c();
    
      sla.Name = 'Opportunity';
      sla.Status__c = 'New';
    
        insert sla; 
            
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
        
        
        Opportunity op2 = new Opportunity(Event_Source__c='Advantage Credit',Name = 'Name', member_account__c = accDetail.id, StageName = 'Open',Product_Type__c = 'Misc', CloseDate = system.today(),  Is_Converted__c = false, Queue_Assigned_Id__c= listQueue.Id,  Opportunity_Source__c = 'Word of mouth', AccountId = account_Obj.id,  Ownership__c = 'Keep', Episys_User_ID__c = 1);
        
        
        Opportunity op3 = new Opportunity(Event_Source__c='Advantage Credit',Name = 'Name',member_account__c = accDetail.id,  StageName = 'Open', Product_Type__c = 'Misc',CloseDate = system.today(),  Is_Converted__c = false, Queue_Assigned_Id__c= listQueue.Id,  Opportunity_Source__c = 'Branch Call', AccountId = account_Obj1.id,  Ownership__c = 'Auto Assign', Episys_User_ID__c = 1);
        
        Opportunity op4 = new Opportunity(Event_Source__c='Advantage Credit',Name = 'Name', member_account__c = accDetail.id, StageName = 'Open', Product_Type__c = 'Misc', CloseDate = system.today(),  Is_Converted__c = false, Queue_Assigned_Id__c= listQueue.Id,  Opportunity_Source__c = 'Word of mouth', AccountId = account_Obj.id,  Ownership__c = 'Auto Assign', Episys_User_ID__c = 1);
        Opportunity op5 = new Opportunity(Event_Source__c='Advantage Credit',Name = 'Name', member_account__c = accDetail.id, StageName = 'Open', Product_Type__c = 'Misc', CloseDate = system.today(),  Is_Converted__c = false, Queue_Assigned_Id__c= listQueue.Id,  Opportunity_Source__c = 'Branch Call',   AccountId = account_Obj.id,  Ownership__c = 'Auto Assign', Episys_User_ID__c = 0);
        Opportunity op6 = new Opportunity(Event_Source__c='Advantage Credit',Name = 'Name',member_account__c = accDetail.id,  StageName = 'Open', Product_Type__c = 'Misc', CloseDate = system.today(),  Is_Converted__c = false, Queue_Assigned_Id__c= listQueue.Id,  Opportunity_Source__c = 'Branch Call',   AccountId = account_Obj.id,  Ownership__c = 'Auto Assign');
        
        Opportunity op7 = new Opportunity(Event_Source__c='Advantage Credit',Name = 'Name',member_account__c = accDetail.id, Product_Sub__c = 'Pre Select Auto',Product_Type__c = 'Consumer Lending', StageName = 'Open', CloseDate = system.today(),  Is_Converted__c = false, Queue_Assigned_Id__c= listQueue.Id,  Opportunity_Source__c = 'Event', AccountId = account_Obj.id,  Ownership__c = 'Auto Assign');
        Opportunity op8 = new Opportunity(Event_Source__c='Advantage Credit',Name = 'Name',member_account__c = accDetail.id,  StageName = 'Open', Product_Type__c = 'Misc',CloseDate = system.today(),  Is_Converted__c = false, Queue_Assigned_Id__c= listQueue.Id,  Opportunity_Source__c = 'Campaign Outreach', DESCRIPTION = 'Relevant Member Number',AccountId = account_Obj1.id,  Ownership__c = 'Auto Assign', Episys_User_ID__c = 1);
        Opportunity op9 = new Opportunity(Event_Source__c='Advantage Credit',Name = 'Name',member_account__c = accDetail.id,  StageName = 'Open', Product_Type__c = 'Misc',CloseDate = system.today(),  Is_Converted__c = false, Queue_Assigned_Id__c= listQueue.Id,  Opportunity_Source__c = 'Campaign Outreach', DESCRIPTION = 'Last Activity Date',AccountId = account_Obj1.id,  Ownership__c = 'Auto Assign', Episys_User_ID__c = 1);
        Opportunity op10 = new Opportunity(Event_Source__c='Advantage Credit',Name = 'Name',member_account__c = accDetail.id,  StageName = 'Open', Product_Type__c = 'Misc',CloseDate = system.today(),  Is_Converted__c = false, Queue_Assigned_Id__c= listQueue.Id,  Opportunity_Source__c = 'Campaign Outreach', DESCRIPTION = 'Dormant Date',AccountId = account_Obj1.id,  Ownership__c = 'Auto Assign', Episys_User_ID__c = 1);
        Opportunity op11 = new Opportunity(Event_Source__c='Advantage Credit',Name = 'Name',member_account__c = accDetail.id,  StageName = 'Open', Product_Type__c = 'Misc',CloseDate = system.today(),  Is_Converted__c = false, Queue_Assigned_Id__c= listQueue.Id,  Opportunity_Source__c = 'Campaign Outreach', DESCRIPTION = 'High Value/High Potential',AccountId = acc.id,  Ownership__c = 'Auto Assign', Episys_User_ID__c = 1);
        Opportunity op12 = new Opportunity(Event_Source__c='Advantage Credit',Name = 'Name',member_account__c = accDetail.id,  StageName = 'Open', Product_Type__c = 'Misc',CloseDate = system.today(),  Is_Converted__c = false, Queue_Assigned_Id__c= listQueue.Id,  Opportunity_Source__c = 'Campaign Outreach', DESCRIPTION = 'Script Link',AccountId = acc.id,  Ownership__c = 'Auto Assign', Episys_User_ID__c = 1);
        
       
        
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
          
        insert insertopp;
        
        Account_Details__c accDetailtrg = new Account_Details__c();
        accDetailtrg.Name = 'test';
        accDetailtrg.SecureEmailAddress__c = 'sample@sample.com';
        accDetailtrg.Created_By_User__c = 1;
        insert accDetailtrg;
        
        String RecTypeIdtrg= [select Id from RecordType where (Name='Person Account') and (SobjectType='Account')].Id;
        
        Account acctrg = new Account(
        RecordTypeID=RecTypeIdtrg,
        FirstName='Test FName',
        LastName='Test LName',
        PersonMailingStreet='test@yahoo.com',
        PersonMailingPostalCode='12345',
        PersonMailingCity='SFO',
        PersonEmail='test@yahoo.com',
        PersonHomePhone='1234567',
        PersonMobilePhone='12345678');
        
        insert acctrg;
        
        Person_Account__c patrg = new Person_Account__c();
        patrg.PersonID__c = acc.Id;
        patrg.Name_Type__c = 0;
        patrg.Account_Number__c = accDetail.Id;
        insert patrg;
        Opportunity opptrg;        
        opptrg = new Opportunity(Name = 'Name', Brand__c ='Chevron', How_did_you_hear_about_us__c ='Banner Ad', Is_Converted__c = true, Event_Source__c='Advantage Credit', member_account__c = accDetailtrg.id,  StageName = 'Closed Won' ,  Product_Amount__c =2.00, Product_Type__c = 'Misc',CloseDate = system.today(), Opportunity_Source__c = 'Branch Call', AccountId =acctrg.id, Allow_Error__c= true);        
		insert opptrg;
        
        
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
    SLA_Status_Manager__c sla = new SLA_Status_Manager__c();
    
    sla.Name = 'Opportunity';
    sla.Status__c = 'New';
    
    insert sla; 
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
    @istest
    static void getTimeDifferenceTest() {
        Test.startTest();   
        OpportunityTriggerHandler handler = new OpportunityTriggerHandler(true,0);
       	handler.getTimeDifference(system.now());         
        Test.stopTest();  
      
    } 
    @istest
    static  void opptyUpdateTest1() {
        Test.startTest();   
         
        
        try{
            Opportunity opp = DataFactoryTestClass.createOpportunitywithMemberAccount('Outreach');  
         	opp.Product_Type__c = 'Mortgage';
         	opp.Stagename = 'Closed Won';
         	opp.Loan_Number__c ='';
            opp.Allow_Error__c = true;
            update opp;
        }
        catch(Exception ex){           
            Boolean expectedExceptionThrown =  ex.getMessage().contains('Script-thrown exception') ? true : false;
            System.assertEquals(expectedExceptionThrown, true);
        }
         
        
        Test.stopTest();  
      
    } 
     @istest
    static  void opptyUpdateTest2() {
        Test.startTest();   
         
        
        try{
            Opportunity opp = DataFactoryTestClass.createOpportunitywithMemberAccount('Closed Won'); 
            opp.Is_Converted__c = true;
            update opp;
        }
        catch(Exception ex){           
            Boolean expectedExceptionThrown =  ex.getMessage().contains('Script-thrown exception') ? true : false;
            System.assertEquals(expectedExceptionThrown, true);
        }
         
        
        Test.stopTest();  
      
    } 
    @istest
    static  void opptyUpdateTest3() {
        Test.startTest();            
        
        try{
            Opportunity opp = [Select id, Allow_Error__c from Opportunity Where Allow_Error__c= true limit 1];
            opp.CloseDate = Date.newInstance(2022, 06, 09);            
            update opp;
        }
        catch(Exception ex){           
            Boolean expectedExceptionThrown =  ex.getMessage().contains('Script-thrown exception') ? true : false;
            System.assertEquals(expectedExceptionThrown, false);
        }
         
        
        Test.stopTest();  
      
    } 
    @istest
    static  void opptyUpdateTest4() {
        Test.startTest();            
        
        try{
            Opportunity opp = [Select id, Allow_Error__c from Opportunity Where Allow_Error__c= true limit 1];
            opp.Event_Source__c = 'Contractor Visit';            
            update opp;
        }
        catch(Exception ex){           
            Boolean expectedExceptionThrown =  ex.getMessage().contains('Script-thrown exception') ? true : false;
            System.assertEquals(expectedExceptionThrown, false);
        }
         
        
        Test.stopTest();  
      
    } 
     @istest
    static  void opptyUpdateTest5() {
        Test.startTest();            
        
        try{
            Opportunity opp = [Select id, Allow_Error__c from Opportunity Where Allow_Error__c= true limit 1];
            opp.Brand__c = 'Spectrum';            
            update opp;
        }
        catch(Exception ex){           
            Boolean expectedExceptionThrown =  ex.getMessage().contains('Script-thrown exception') ? true : false;
            System.assertEquals(expectedExceptionThrown, false);
        }
         
        
        Test.stopTest();  
      
    }
    @istest
    static  void opptyUpdateTest6() {
        Test.startTest();            
        
        try{
            Opportunity opp = [Select id, Allow_Error__c from Opportunity Where Allow_Error__c= true limit 1];
            opp.How_did_you_hear_about_us__c = 'Website';            
            update opp;
        }
        catch(Exception ex){           
            Boolean expectedExceptionThrown =  ex.getMessage().contains('Script-thrown exception') ? true : false;
            System.assertEquals(expectedExceptionThrown, false);
        }
         
        
        Test.stopTest();  
      
    }
    @istest
    static void updateTimeStampOnOppTest(){
        Test.startTest();      
        Opportunity opp = DataFactoryTestClass.createOpportunitywithMemberAccount('New');
        OpportunityTriggerHelper helper = new OpportunityTriggerHelper();
        helper.updateTimeStampOnOpp('New',opp, 2.15, true);
        helper.updateTimeStampOnOpp('New',opp, 2.15, false);
       Test.stopTest();   
    }
    @istest
    static void updateTimeStampOnOppTest1(){
        Test.startTest();      
        Opportunity opp = DataFactoryTestClass.createOpportunitywithMemberAccount('Outreach');
        OpportunityTriggerHelper helper = new OpportunityTriggerHelper();
        helper.updateTimeStampOnOpp('Outreach',opp, 2.15, true);
        helper.updateTimeStampOnOpp('Outreach',opp, 2.15, false);
       Test.stopTest();   
    }
     @istest
    static void updateTimeStampOnOppTest2(){
        Test.startTest();      
        Opportunity opp = DataFactoryTestClass.createOpportunitywithMemberAccount('Analyzing Needs');
        OpportunityTriggerHelper helper = new OpportunityTriggerHelper();
        helper.updateTimeStampOnOpp('Analyzing Needs',opp, 2.15, true);
        helper.updateTimeStampOnOpp('Analyzing Needs',opp, 2.15, false);
       Test.stopTest();   
    }
     @istest
    static void updateTimeStampOnOppTest3(){
        Test.startTest();      
        Opportunity opp = DataFactoryTestClass.createOpportunitywithMemberAccount('Considering');
        OpportunityTriggerHelper helper = new OpportunityTriggerHelper();
        helper.updateTimeStampOnOpp('Considering',opp, 2.15, true);
        helper.updateTimeStampOnOpp('Considering',opp, 2.15, false);
       Test.stopTest();   
    }
    @istest
    static void updateTimeStampOnOppTest4(){
        Test.startTest();      
        Opportunity opp = DataFactoryTestClass.createOpportunitywithMemberAccount('Fulfillment');
        OpportunityTriggerHelper helper = new OpportunityTriggerHelper();
        helper.updateTimeStampOnOpp('Fulfillment',opp, 2.15, true);
        helper.updateTimeStampOnOpp('Fulfillment',opp, 2.15, false);
       Test.stopTest();   
    }
    @istest
    static void getOtherFieldsAreNullTest1(){
        Test.startTest();      
        Opportunity opp = DataFactoryTestClass.createOpportunitywithMemberAccount('New');
        OpportunityTriggerHelper helper = new OpportunityTriggerHelper();
        helper.getOtherFieldsAreNull('New',opp);  
        helper.getTimeStampFieldValue('New',opp);
       Test.stopTest();   
    }
   @istest
    static void getOtherFieldsAreNullTest2(){
        Test.startTest();      
        Opportunity opp = DataFactoryTestClass.createOpportunitywithMemberAccount('Outreach');
        OpportunityTriggerHelper helper = new OpportunityTriggerHelper();
        helper.getOtherFieldsAreNull('Outreach',opp);
		helper.getTimeStampFieldValue('Outreach',opp);        
       Test.stopTest();   
    }
    @istest
    static void getOtherFieldsAreNullTest3(){
        Test.startTest();      
        Opportunity opp = DataFactoryTestClass.createOpportunitywithMemberAccount('Analyzing Needs');
        OpportunityTriggerHelper helper = new OpportunityTriggerHelper();
        helper.getOtherFieldsAreNull('Analyzing Needs',opp);  
        helper.getTimeStampFieldValue('Analyzing Needs',opp);
       Test.stopTest();   
    }
    @istest
    static void getOtherFieldsAreNullTest4(){
        Test.startTest();      
        Opportunity opp = DataFactoryTestClass.createOpportunitywithMemberAccount('Considering');
        OpportunityTriggerHelper helper = new OpportunityTriggerHelper();
        helper.getOtherFieldsAreNull('Considering',opp); 
        helper.getTimeStampFieldValue('Considering',opp);
       Test.stopTest();   
    }
    @istest
    static void getOtherFieldsAreNullTest5(){
        Test.startTest();      
        Opportunity opp = DataFactoryTestClass.createOpportunitywithMemberAccount('Fulfillment');
        OpportunityTriggerHelper helper = new OpportunityTriggerHelper();
        helper.getOtherFieldsAreNull('Fulfillment',opp); 
        helper.getTimeStampFieldValue('Fulfillment',opp);
       Test.stopTest();   
    }
     @istest
    static void getTimeDifferenceTest1(){
      OpportunityTriggerHelper helper = new OpportunityTriggerHelper();
        helper.getTimeDifference(Datetime.now());
    }
    
    static testMethod void OpportunityTriggerHandlerTest2() {
        
       
    Test.startTest(); 
    SLA_Status_Manager__c sla = new SLA_Status_Manager__c();    
    sla.Name = 'Opportunity';
    sla.Status__c = 'New,Considering,Analyzing Needs,Outreach';    
    insert sla; 
        Account account_Obj = [Select Id from Account limit 1];
        Account_Details__c ad = [select id from Account_Details__c where RecType__c = 'ACCT' limit 1];
        Opportunity opp = new Opportunity(Name = 'Name',TimeStamp_New_status__c = DateTime.now(), Hour_Spent_New_Status__c = 1.00 ,Event_Source__c='Advantage Credit', Hour_Spent_Outreach_Status__c = 1.00, Hour_Spent_Considering_Status__c = 1.00, Hour_Spent_Analyzing_Needs_Status__c = 1.00, Hour_Spent_Fulfillment_Status__c = 1.00, member_account__c = ad.id,  StageName = 'New' ,  Product_Amount__c =2.00, Product_Type__c = 'Misc',CloseDate = system.today(), Opportunity_Source__c = 'Campaign Outreach', AccountId =account_Obj.id);
        insert opp;
       
        Test.stopTest();  
      
    }
    static testMethod void OpportunityTriggerHandlerTest3() {
    Test.startTest(); 
    SLA_Status_Manager__c sla = new SLA_Status_Manager__c();    
    sla.Name = 'Opportunity';
    sla.Status__c = 'New,Considering,Analyzing Needs,Outreach';    
    insert sla; 
        Account account_Obj = [Select Id from Account limit 1];
        Account_Details__c ad = [select id from Account_Details__c where RecType__c = 'ACCT' limit 1];
        Opportunity opp = new Opportunity(Name = 'Name', Hour_Spent_New_Status__c = 1.00 ,Event_Source__c='Advantage Credit', Hour_Spent_Outreach_Status__c = 1.00, Hour_Spent_Considering_Status__c = 1.00,
                                          Hour_Spent_Analyzing_Needs_Status__c = 1.00, Hour_Spent_Fulfillment_Status__c = 1.00, member_account__c = ad.id,
                                          StageName = 'Considering' ,  Product_Amount__c =2.00, Product_Type__c = 'Misc',CloseDate = system.today(),
                                          Opportunity_Source__c = 'Campaign Outreach', AccountId =account_Obj.id);
        insert opp;       
        Test.stopTest();  
      
    }
    static testMethod void OpportunityTriggerHandlerTest4() {
    Test.startTest(); 
    SLA_Status_Manager__c sla = new SLA_Status_Manager__c();    
    sla.Name = 'Opportunity';
    sla.Status__c = 'New,Considering,Analyzing Needs,Outreach';    
    insert sla; 
        Account account_Obj = [Select Id from Account limit 1];
        Account_Details__c ad = [select id from Account_Details__c where RecType__c = 'ACCT' limit 1];
        Opportunity opp = new Opportunity(Name = 'Name', Hour_Spent_New_Status__c = 1.00 ,Event_Source__c='Advantage Credit', Hour_Spent_Outreach_Status__c = 1.00, Hour_Spent_Considering_Status__c = 1.00,
                                          Hour_Spent_Analyzing_Needs_Status__c = 1.00, Hour_Spent_Fulfillment_Status__c = 1.00, member_account__c = ad.id,
                                          StageName = 'Analyzing Needs' ,  Product_Amount__c =2.00, Product_Type__c = 'Misc',CloseDate = system.today(),
                                          Opportunity_Source__c = 'Campaign Outreach', AccountId =account_Obj.id);
        insert opp;       
        Test.stopTest();  
      
    }
    static testMethod void OpportunityTriggerHandlerTest5() {
    Test.startTest(); 
    SLA_Status_Manager__c sla = new SLA_Status_Manager__c();    
    sla.Name = 'Opportunity';
    sla.Status__c = 'New,Considering,Analyzing Needs,Outreach';    
    insert sla; 
        Account account_Obj = [Select Id from Account limit 1];
        Account_Details__c ad = [select id from Account_Details__c where RecType__c = 'ACCT' limit 1];
        Opportunity opp = new Opportunity(Name = 'Name', Hour_Spent_New_Status__c = 1.00 ,Event_Source__c='Advantage Credit', Hour_Spent_Outreach_Status__c = 1.00, Hour_Spent_Considering_Status__c = 1.00,
                                          Hour_Spent_Analyzing_Needs_Status__c = 1.00, Hour_Spent_Fulfillment_Status__c = 1.00, member_account__c = ad.id,
                                          StageName = 'Outreach' ,  Product_Amount__c =2.00, Product_Type__c = 'Misc',CloseDate = system.today(),
                                          Opportunity_Source__c = 'Campaign Outreach', Sub_Status__c ='1st attempt' , AccountId =account_Obj.id);
        insert opp; 
        opp.StageName = 'Analyzing Needs';
        update opp;
        Test.stopTest();  
      
    }
    static testMethod void OpportunityTriggerHandlerTest6() {
    Test.startTest(); 
    SLA_Status_Manager__c sla = new SLA_Status_Manager__c();    
    sla.Name = 'Opportunity';
    sla.Status__c = 'New,Considering,Analyzing Needs,Outreach, Fulfillment';    
    insert sla; 
        Account account_Obj = [Select Id from Account limit 1];
        Account_Details__c ad = [select id from Account_Details__c where RecType__c = 'ACCT' limit 1];
        Opportunity opp = new Opportunity(Name = 'Name', Hour_Spent_New_Status__c = 1.00 ,Event_Source__c='Advantage Credit', Hour_Spent_Outreach_Status__c = 1.00, Hour_Spent_Considering_Status__c = 1.00,
                                          Hour_Spent_Analyzing_Needs_Status__c = 1.00, Hour_Spent_Fulfillment_Status__c = 1.00, member_account__c = ad.id,
                                          StageName = 'Fulfillment' ,  Product_Amount__c =2.00, Product_Type__c = 'Misc',CloseDate = system.today(),
                                          Opportunity_Source__c = 'Campaign Outreach', AccountId =account_Obj.id);
        insert opp; 
        opp.StageName = 'Analyzing Needs';
        update opp;
        Test.stopTest();  
      
    }
}