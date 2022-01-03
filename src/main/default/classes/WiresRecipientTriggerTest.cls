@isTest
public class WiresRecipientTriggerTest {
    
    static testMethod void WireRecipient_AfterInsert(){
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
        accDetail.Name = '0000000123';
        accDetail.RecType__c = 'ACCT';
        accDetail.TypeTranslate__c = '1-PERSONAL';
        accDetail.ID1__c = '001';
        accDetail.OPEN_DATE__c = Date.newInstance(2018, 12, 10);
        accDetail.Reference__c ='BC01';
        insert accDetail;
        
        Person_Account__c p = new Person_Account__c();
        p.Account_Number__c=accDetail.Id;
        p.PersonID__c=acc.Id;
        insert p;
        
        
       Person_Account__c p1 = [Select Id,Name,Account_Number__r.RecType__c,
                              Account_Number__r.Name,PersonID__r.Home_Phone__pc,
                              PersonID__r.Mobile_Phone__pc,PersonID__r.Residential_City__pc,
                              PersonID__r.Residential_State__pc,PersonID__r.Residential_Street__pc,
                              PersonID__r.Residential_Zipocde__pc,PersonID__r.Name,
                              PersonID__r.Email_raw__c
                              From Person_Account__c Limit 1];
        
        p1.Account_Number__r.RecType__c='ACCT';
        p1.Account_Number__r.Name ='0000000123';
        p1.PersonID__r.Home_Phone__pc='123456789';
        p1.PersonID__r.Mobile_Phone__pc='123456789';
        p1.PersonID__r.Residential_City__pc='test';
        p1.PersonID__r.Residential_State__pc='test';
        p1.PersonID__r.Residential_Street__pc='test';
        p1.PersonID__r.Residential_Zipocde__pc='1234567';
        p1.PersonID__r.Name='test'; 
        p1.PersonID__r.Email_raw__c ='test@test.com';
        p1.TypeTranslate__c='Primary';
        
        update p1;
        
        WIRES_Recipient__c objWC = new WIRES_Recipient__c();
        objWC.Address1__c='Address1';
        objWC.Address2__c = 'Address2';
        objWC.BankName__c = 'Test';
        objWC.Chevron_AccountNumber__c ='0000000123';
        objWC.City__c = 'CA';
        objWC.AccountLocation__c = 'Domestic';
        objWC.Country__c = 'USA';
        objWC.isActive__c = true;
        
        insert objWC;
        
    }
}