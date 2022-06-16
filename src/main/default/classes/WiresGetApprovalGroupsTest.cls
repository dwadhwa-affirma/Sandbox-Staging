@isTest
public class WiresGetApprovalGroupsTest{
  @testSetup
  static void setup(){

    Account acc = new Account();
    acc.FirstName = 'Test FName';
    acc.LastName = 'Test LName';
    acc.Mobile_Phone__pc = '555-469-3885';
    acc.Home_Phone__pc = '555-469-3886';
    acc.Work_Phone__pc = '555-469-3887';
    acc.Email_raw__c = 'test@test.com';
    acc.PersonEmail = 'test1@test.com';
    acc.PersonID__c = 'V565138120';
    insert acc;

    acc.Mobile_Phone__pc = '555-479-3885';
    update acc;

    Account_Details__c accDetail = new Account_Details__c();
    accDetail.Name = '0000000123';
    accDetail.RecType__c = 'ACCT';
    accDetail.TypeTranslate__c = '1-PERSONAL';
    accDetail.ID1__c = '001';
    accDetail.OPEN_DATE__c = Date.newInstance(2018, 12, 10);
    accDetail.Reference__c = 'BC01';
    insert accDetail;

    Person_Account__c p = new Person_Account__c();
    p.Account_Number__c = accDetail.Id;
    p.PersonID__c = acc.Id;
    p.TypeTranslate__c = '0000/Primary';
    insert p;


    Person_Account__c p1 = [Select Id, Name, Account_Number__r.RecType__c, Account_Number__r.Name, PersonID__r.Home_Phone__pc, PersonID__r.Mobile_Phone__pc, PersonID__r.Residential_City__pc, PersonID__r.Residential_State__pc, PersonID__r.Residential_Street__pc, PersonID__r.Residential_Zipocde__pc, PersonID__r.Name, PersonID__r.Email_raw__c
                        From Person_Account__c
                        Limit 1];

    p1.Account_Number__r.RecType__c = 'ACCT';
    p1.Account_Number__r.Name = '0000000123';
    p1.PersonID__r.Home_Phone__pc = '123456789';
    p1.PersonID__r.Mobile_Phone__pc = '123456789';
    p1.PersonID__r.Residential_City__pc = 'test';
    p1.PersonID__r.Residential_State__pc = 'test';
    p1.PersonID__r.Residential_Street__pc = 'test';
    p1.PersonID__r.Residential_Zipocde__pc = '1234567';
    p1.PersonID__r.Name = 'test';
    p1.PersonID__r.Email_raw__c = 'test@test.com';
    p1.TypeTranslate__c = 'Primary';

    WIRES_Recipient__c objWR = new WIRES_Recipient__c();
    objWR.Address1__c = 'Address1';
    objWR.Address2__c = 'Address2';
    objWR.BankName__c = 'Test';
    objWR.Chevron_AccountNumber__c = '0000000123';
    objWR.City__c = 'CA';
    objWR.AccountLocation__c = 'Domestic';
    objWR.Country__c = 'USA';
    objWR.isActive__c = true;

    insert objWR;

    Wires_Progress_Email_Test__c wpet = new Wires_Progress_Email_Test__c();
    wpet.Name = 'Test';
    wpet.Email__c = 'mcatalano@chevronfcu.org';
    wpet.Phone__c = '7079336359';
    insert wpet;

    Wires_Docusign_Emails__c wde = new Wires_Docusign_Emails__c();
    wde.Name = 'Email For Testing';
    wde.Emails__c = 'Test';

    insert wde;

    Wires_DocuSign_User_Details__c wdae = new Wires_DocuSign_User_Details__c();
    wdae.Name = 'Chevron';
    wdae.AccountId__c = '2e80db6b-16cf-4202-bf90-dfa029c5949f';
    wdae.EndPoint__c = 'demo.docusign.net';
    wdae.IntegratorKey__c = '12c7957a-484f-4fec-b6b3-461ec9b666aa';
    wdae.ReplyTo__c = 'noreply@chevronfcu.org';
    wdae.TemplateId__c = '0d330f9b-9fe1-4165-a6d5-bef671134243';
    wdae.Username__c = '9c9450c4-0f40-47f7-8ee8-8292ad64f81b';
    wdae.IDVEndPoint__c = 'proof-d.docusign.net';

    insert wdae;

    Wires_DocuSign_User_Details__c wdae1 = new Wires_DocuSign_User_Details__c();
    wdae1.Name = 'Chevron-IDV';
    wdae1.AccountId__c = '2e80db6b-16cf-4202-bf90-dfa029c5949f';
    wdae1.EndPoint__c = 'demo.docusign.net';
    wdae1.IntegratorKey__c = '12c7957a-484f-4fec-b6b3-461ec9b666aa';
    wdae1.ReplyTo__c = 'noreply@chevronfcu.org';
    wdae1.TemplateId__c = '7e9a5e78-b8dd-4bde-888c-269864785110';
    wdae1.Username__c = '9c9450c4-0f40-47f7-8ee8-8292ad64f81b';
    wdae1.IDVEndPoint__c = 'proof-d.docusign.net';
    wdae1.Password__c = '!DocApi999999';
    insert wdae1;

    Wires_Approval_Notification_Time_Limit__c wantl = new Wires_Approval_Notification_Time_Limit__c();
    wantl.Time_In_Minutes__c = 0;
    wantl.Name = 'Online';
    insert wantl;

    WiresApprovalEscalation__c wae = new WiresApprovalEscalation__c();
    wae.Escalation__c = true;
    wae.Name = 'Online';
    insert wae;

    Wires_Good_Fund_Limit__c wgfl = new Wires_Good_Fund_Limit__c();
    wgfl.Amount__c = 0;
    wgfl.Name = 'Min';
    insert wgfl;

    SolarLoan_To_Episys_API_Details__c api = new SolarLoan_To_Episys_API_Details__c();
    api.name = 'ProductionURL';
    api.URL__c = 'https://symxapi.chevronfcu.org/devclient';
    insert api;

    WIRES_Transaction__c wiretransac = new WIRES_Transaction__c();

    wiretransac.Frequency__c = 'One - Time';
    wiretransac.Source__c = 'Online Banking';
    wiretransac.Brand__c = 'Chevron';
    wiretransac.IsActive__c = true;
    wiretransac.FromAccount__c = '0000000123';
    wiretransac.Chevron_Account_Number__c = '0000000123';
    wiretransac.Member_SSN__c = '565138120';
    wiretransac.Share_ID__c = '0200';
    wiretransac.ToAccountName__c = '0000000123';
    wiretransac.ToAccoutId__c = objWR.Id;
    wiretransac.WireAmount__c = 52000;
    wiretransac.Fees__c = 20.0;
    wiretransac.Description__c = 'Test recurring transaction';
    wiretransac.Current_Reviewer_Modified_Date__c = DateTime.Now();
    wiretransac.Approval_Status__c = 'Pending for Second Approval';
    wiretransac.First_Reviewer__c = '005j000000FjxTKAAZ';
    insert wiretransac;

    wiretransac.Status__c = 'Completed';
    update wiretransac;


    wiretransac.FlagAccountOpenfor45Days__c = true;
    wiretransac.FlagEmailStablefor30Days__c = true;
    wiretransac.FlagHomePhoneStablefor30Days__c = true;
    wiretransac.FlagMobilePhoneStablefor30Days__c = true;
    wiretransac.FlagWorkPhoneStablefor30Days__c = true;
    wiretransac.Docusign_IDV_Failure__c = false;
    update wiretransac;

    wiretransac.Approval_Status__c = 'Pending for Approval';
    update wiretransac;


    WIRES_Transaction__c wiretransac1 = new WIRES_Transaction__c();

    wiretransac1.Frequency__c = 'Recurring';
    wiretransac1.Source__c = 'Online Banking';
    wiretransac1.Brand__c = 'Chevron';
    wiretransac1.IsActive__c = true;
    wiretransac1.EndDate__c = Date.newInstance(2031, 10, 10);
    wiretransac1.RecurrenceDay__c = Date.today().day();
    wiretransac1.FromAccount__c = '0000000123';
    wiretransac1.Chevron_Account_Number__c = '0000000123';
    wiretransac1.Member_SSN__c = '565138120';
    wiretransac1.Share_ID__c = '0200';
    wiretransac1.ToAccountName__c = '0000000123';
    wiretransac1.ToAccoutId__c = objWR.Id;
    wiretransac1.WireAmount__c = 52000;
    wiretransac1.Fees__c = 20.0;
    wiretransac1.Description__c = 'Test recurring transaction';
    wiretransac1.Status__c = 'Completed';

    insert wiretransac1;

    Wires_Limit_Configurations__c wl = new Wires_Limit_Configurations__c();
    wl.Name = 'Limit C';
    wl.First_Approvers__c = 'Branch_Group_C,Branch_Group_D';
    wl.Limit_Tier__c = 'Limit C';
    wl.Maximum_Amount__c = 250000;
    wl.Minimum_Amount__c = 100001;
    wl.Number_of_Approvals__c = 2;
    wl.Second_Approver__c = 'Branch_Group_C,Branch_Group_D,Branch_Group_E';
    insert wl;

    Wires_Limit_Configurations__c wl1 = new Wires_Limit_Configurations__c();
    wl1.Name = 'Limit A';
    wl1.First_Approvers__c = 'Branch_Group_A,Branch_Group_B,Branch_Group_C,Branch_Group_D,Branch_Group_E';
    wl1.Limit_Tier__c = 'Limit A';
    wl1.Maximum_Amount__c = 25000;
    wl1.Minimum_Amount__c = 0;
    wl1.Number_of_Approvals__c = 1;
    wl1.Second_Approver__c = '';
    insert wl1;

    Wires_Limit_Configurations__c wl2 = new Wires_Limit_Configurations__c();
    wl2.Name = 'Limit B';
    wl2.First_Approvers__c = 'Branch_Group_B,Branch_Group_C,Branch_Group_D,Branch_Group_E';
    wl2.Limit_Tier__c = 'Limit B';
    wl2.Maximum_Amount__c = 100000;
    wl2.Minimum_Amount__c = 25001;
    wl2.Number_of_Approvals__c = 1;
    wl2.Second_Approver__c = '';
    insert wl2;


    Wires_Limit_Configurations__c wl4 = new Wires_Limit_Configurations__c();
    wl4.Name = 'Limit E';
    wl4.First_Approvers__c = 'Branch_Group_C,Branch_Group_D';
    wl4.Limit_Tier__c = 'Limit E';
    wl4.Minimum_Amount__c = 1000001;
    wl4.Number_of_Approvals__c = 2;
    wl4.Second_Approver__c = 'Branch_Group_E';
    insert wl4;


    Wires_Limit_Configurations_Online__c w1 = new Wires_Limit_Configurations_Online__c();
    w1.Name = 'Limit A';
    w1.First_Approvers__c = 'WIRES_Online_Group_A,WIRES_Online_Group_B,WIRES_Online_Group_C';
    w1.Limit_Tier__c = 'Limit A';
    w1.Maximum_Amount__c = 5000;
    w1.Minimum_Amount__c = 0;
    w1.Number_of_Approvals__c = 1;
    w1.Second_Approver__c = '';
    insert w1;

    Wires_Limit_Configurations_Online__c w2 = new Wires_Limit_Configurations_Online__c();
    w2.Name = 'Limit B';
    w2.First_Approvers__c = 'WIRES_Online_Group_A,WIRES_Online_Group_B,WIRES_Online_Group_C,WIRES_Online_Group_D';
    w2.Limit_Tier__c = 'Limit B';
    w2.Maximum_Amount__c = 50000;
    w2.Minimum_Amount__c = 5001;
    w2.Number_of_Approvals__c = 1;
    w2.Second_Approver__c = '';
    insert w2;

    Wires_Limit_Configurations_Online__c w3 = new Wires_Limit_Configurations_Online__c();
    w3.Name = 'Limit C';
    w3.First_Approvers__c = 'WIRES_Online_Group_B,WIRES_Online_Group_C,WIRES_Online_Group_D';
    w3.Limit_Tier__c = 'Limit C';
    w3.Maximum_Amount__c = 100000;
    w3.Minimum_Amount__c = 50001;
    w3.Number_of_Approvals__c = 1;
    w3.Second_Approver__c = '';
    insert w3;

    Wires_Limit_Configurations_Online__c w4 = new Wires_Limit_Configurations_Online__c();
    w4.Name = 'Limit D';
    w4.First_Approvers__c = 'WIRES_Online_Group_C,WIRES_Online_Group_D,WIRES_Online_Group_E';
    w4.Limit_Tier__c = 'Limit D';
    w4.Maximum_Amount__c = 500000;
    w4.Minimum_Amount__c = 100001;
    w4.Number_of_Approvals__c = 1;
    w4.Second_Approver__c = '';
    insert w4;

    Wires_Limit_Configurations_Online__c w5 = new Wires_Limit_Configurations_Online__c();
    w5.Name = 'Limit E';
    w5.First_Approvers__c = 'WIRES_Online_Group_D,WIRES_Online_Group_E';
    w5.Limit_Tier__c = 'Limit E';
    w5.Maximum_Amount__c = 1500000;
    w5.Minimum_Amount__c = 500001;
    w5.Number_of_Approvals__c = 1;
    w5.Second_Approver__c = '';
    insert w5;

    Wires_Limit_Configurations_Online__c w6 = new Wires_Limit_Configurations_Online__c();
    w6.Name = 'Limit F';
    w6.First_Approvers__c = 'WIRES_Online_Group_E';
    w6.Limit_Tier__c = 'Limit F';
    w6.Minimum_Amount__c = 1500001;
    w6.Number_of_Approvals__c = 1;
    w6.Second_Approver__c = '';
    insert w6;
  }

  @isTest
  static void CheckIfUserExistsTest(){
    Test.startTest();
    WiresGetApprovalGroups.CheckIfUserExists('Test Group1', UserInfo.getUserId());
    Test.stopTest();
  }

  @isTest
  static void GetFirstApprovalGroupBranchTest(){
    Test.startTest();
    decimal InputAmount1 = 25002;
    WiresGetApprovalGroups.GetFirstApprovalGroupBranch(InputAmount1);
    Test.stopTest();
  }

  @isTest
  static void GetSecondApprovalGroupBranchTest(){
    Test.startTest();
    decimal InputAmount2 = 25003;
    WiresGetApprovalGroups.GetSecondApprovalGroupBranch(InputAmount2);
    Test.stopTest();
  }

  @isTest
  static void GetFirstApprovalGroupOnlineTest(){
    Test.startTest();
    decimal InputAmount3 = 25005;
    WiresGetApprovalGroups.GetFirstApprovalGroupOnline(InputAmount3);
    Test.stopTest();
  }

}