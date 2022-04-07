@IsTest
public class MembersWebServiceTest{
  static testMethod void testInsert(){
    ACH_To_Episys_API_Details__c api = new ACH_To_Episys_API_Details__c();
    api.URL__c = 'https://symxapi.chevronfcu.org/devclient';
    api.Name = 'ProductionURL';
    insert api;
    MembersWebService.checkMemberDetails('9000282907', '34531B');
  }

  static testMethod void testUpdate(){

    Account_Details__c acc = new Account_Details__c();
    acc.Name = '9000282907';
    acc.Reference__c = 'test';
    acc.Brand_Code__c = 'test';
    acc.RecType__c = 'ACCT';
    acc.Created_At_Branch__c = 21;
    acc.Created_By_User__c = 12;
    acc.Invalid_Password_Attempts__c = 3;
    insert acc;

    Account_Details__c acc1 = new Account_Details__c();
    acc1.Name = '9000282907';
    acc1.Reference__c = 'test';
    acc1.Brand_Code__c = 'test';
    acc1.RecType__c = 'LOAN';
    acc1.Created_At_Branch__c = 21;
    acc1.Created_By_User__c = 12;
    acc1.Invalid_Password_Attempts__c = 3;
    acc1.ID1__c = '5600';
    insert acc1;

    Account_Details__c acc2 = new Account_Details__c();
    acc2.Name = '9000282907';
    acc2.Reference__c = 'test';
    acc2.Brand_Code__c = 'test';
    acc2.RecType__c = 'CARD';
    acc2.Created_At_Branch__c = 21;
    acc2.Created_By_User__c = 12;
    acc2.Invalid_Password_Attempts__c = 3;
    acc2.Card_Number__c = '5460277346125384';
    insert acc2;

    Account_Details__c acc3 = new Account_Details__c();
    acc3.Name = '9000282907';
    acc3.Reference__c = 'test';
    acc3.Brand_Code__c = 'test';
    acc3.RecType__c = 'SHAR';
    acc3.Created_At_Branch__c = 21;
    acc3.Created_By_User__c = 12;
    acc3.Invalid_Password_Attempts__c = 3;
    acc3.ID1__c = '0001';
    insert acc3;

    ACH_To_Episys_API_Details__c api = new ACH_To_Episys_API_Details__c();
    api.URL__c = 'https://symxapi.chevronfcu.org/devclient';
    api.Name = 'ProductionURL';
    insert api;

    MembersWebService.checkMemberDetails('9000282907', '34531B');
  }

  static testMethod void testUpdateAccount(){

    Account_Details__c acc = new Account_Details__c();
    acc.Name = '9000282907';
    acc.Reference__c = 'test';
    acc.Brand_Code__c = 'test';
    acc.RecType__c = 'ACCT';
    acc.Created_At_Branch__c = 21;
    acc.Created_By_User__c = 12;
    acc.Invalid_Password_Attempts__c = 3;
    insert acc;

    Account_Details__c acc1 = new Account_Details__c();
    acc1.Name = '9000282907';
    acc1.Reference__c = 'test';
    acc1.Brand_Code__c = 'test';
    acc1.RecType__c = 'LOAN';
    acc1.Created_At_Branch__c = 21;
    acc1.Created_By_User__c = 12;
    acc1.Invalid_Password_Attempts__c = 3;
    acc1.ID1__c = '5600';
    insert acc1;

    Account_Details__c acc2 = new Account_Details__c();
    acc2.Name = '9000282907';
    acc2.Reference__c = 'test';
    acc2.Brand_Code__c = 'test';
    acc2.RecType__c = 'CARD';
    acc2.Created_At_Branch__c = 21;
    acc2.Created_By_User__c = 12;
    acc2.Invalid_Password_Attempts__c = 3;
    acc2.Card_Number__c = '5460277346125384';
    insert acc2;


    Account account1 = new Account();
    //acc.RecordTypeID=rtId;
    account1.FirstName = 'Test FName';
    account1.LastName = 'Test LName';
    account1.Mobile_Phone__pc = '555-469-3885';
    account1.Email_raw__c = 'test@test.com';
    account1.PersonID__c = 'V999852654';
    insert account1;

    ACH_To_Episys_API_Details__c api = new ACH_To_Episys_API_Details__c();
    api.URL__c = 'https://symxapi.chevronfcu.org/devclient';
    api.Name = 'ProductionURL';
    insert api;


    MembersWebService.checkMemberDetails('9000282907', '34531B');
  }

  /* static testMethod void testDoPost1()
   {
   MembersWebService.accNum = '0090067880';
   Test.setMock(HttpCalloutMock.class, new Test_MockHttpResponseGenerator());
   MembersWebService.checkMemberDetails();
   }*/
}