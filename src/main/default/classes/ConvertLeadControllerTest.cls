@isTest 
private class ConvertLeadControllerTest{
   
  static testmethod void setupTestData(){
      
      Amount_On_Lead_Opportunity__c mcs = new Amount_On_Lead_Opportunity__c();
      RecordType rec1 = [Select Name, Id From RecordType where sObjectType='Account' and isActive=true and Name='Pre Member'];      
      
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
 		
      Account pact = new Account();
      pact.FirstName = 'Test';
      pact.LastName = 'Test1';
      pact.PersonEmail = 'test@test.com';
      pact.RecordtypeId = rec1.Id;
      pact.Residential_Street__pc ='11';
      pact.Home_Phone__pc ='011-11111';
      insert pact;
      opportunity opp = new Opportunity();
      opp.Accountid = pact.id;
      opp.Name = 'Name';
      opp.StageName = 'Closed Won';
      opp.CloseDate = system.today();
      opp.Is_Converted__c = true;
      opp.DESCRIPTION = 'DESCRIPTION';
      opp.Opportunity_Source__c = 'Campaign Outreach';
      
      insert opp;
      
      ContentVersion content=new ContentVersion(); 
      content.Title='Header_Picture1'; 
      content.PathOnClient='/' + content.Title + '.jpg'; 
      Blob bodyBlob=Blob.valueOf('Unit Test ContentVersion Body'); 
      content.VersionData=bodyBlob; 
      //content.LinkedEntityId=sub.id;
      content.origin = 'H';
      insert content;
      
      ContentDocumentLink contentlink=new ContentDocumentLink();
      contentlink.LinkedEntityId=ld.id;
      contentlink.contentdocumentid=[select contentdocumentid from contentversion where id =: content.id].contentdocumentid;
      contentlink.ShareType = 'V';
      test.starttest();
      insert contentlink;
      
      Note testNote = new Note();
      testNote.Title = 'Test Account Note';
      testNote.Body = 'Test Account Note Body.';
      testNote.ParentId = ld.Id;
      
      insert testNote;
 	
      Event e = new Event();
      e.WhoId = ld.id;
      e.StartDateTime = system.today();
      e.EndDateTime = system.today()+5;
      insert e;
      
      Task t = new Task();
      t.WhoId = ld.id;
      insert t;
      
      //ConvertLeadController clc = new ConvertLeadController();
      ConvertLeadController.ConvertLead(ld.id);
      ConvertLeadController.Baseurl();
      ConvertLeadController.AttachActivity(opp, ld);  
    
  }
}