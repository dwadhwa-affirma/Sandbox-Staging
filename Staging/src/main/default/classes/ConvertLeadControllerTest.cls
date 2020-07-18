@isTest 
private class ConvertLeadControllerTest{
   
  static testmethod void setupTestData(){
      
    Amount_On_Lead_Opportunity__c mcs = new Amount_On_Lead_Opportunity__c();
      
      mcs.Amount__c = 264000.00;
      mcs.Product_Sub_Type__c = 'Purchase';
      mcs.Product_Type__c = 'Mortgage';
      mcs.Name = 'Mortgage-Purchase';
      insert mcs;

      
      
    Lead ld = new Lead ();
    ld.LastName = 'Test';
    ld.Email = 'test@gmail.com';
    ld.Product_Type__c = 'Misc';
    ld.Brand__c = 'Chevron';
    ld.FirstName = 'test';
    ld.LastName = 'New';    
    ld.MiddleName = 'New';
    ld.Description = 'New';
    ld.Salutation = 'MR.';
    ld.Suffix = 'MR'; 
    ld.Status = 'New';
    ld.Phone= '1234567890';
    ld.Email='test@test.com';
    ld.MobilePhone='1234567892';
    ld.How_did_you_hear_about_us__c='Website';
    ld.Event_Source__c='Event-Reston-Open House-04/20/18';
    ld.LeadSource='BDO-Realtor Referral';
    ld.Product_Type__c ='Mortgage';
    ld.Product_Subtype__c='Purchase';
    ld.Street_Address_1__c='Address 1';
    ld.State__c= 'NY';
    ld.Zip_Code__c= '12345';
    ld.City__c='NYC';
    ld.Country__c ='USA';    
    insert ld;
 

    
    //ConvertLeadController clc = new ConvertLeadController();
    ConvertLeadController.ConvertLead(ld.id);
    ConvertLeadController.Baseurl();
    
  }
}