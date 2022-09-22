@isTest  
public class AddressChangeLogControllerTest {
    @testSetup
    static void setup(){
        AddressChangeConfigurations__c cs = new AddressChangeConfigurations__c();     
        cs.SendEmail__c = false;  
        cs.Name = 'Primary'; 
        cs.SendSMS__c = true;  
        insert cs; 
        
        Address_Change_Email_Notifiations__c ac = new Address_Change_Email_Notifiations__c();     
        ac.Environment__c = 'test';  
        ac.Name = 'Primary'; 
        ac.TestEmailId__c = 'test@test.com';  
        insert ac; 
        
        Account acc = new Account();       
        acc.FirstName='Test FName';
        acc.LastName='Test LName';    
        acc.Mobile_Phone__pc='309-310-1173'; 
        acc.Email_raw__c='dbhavsar@affirma.com';   
        insert acc;
        
        Account_Details__c accDetail = new Account_Details__c();
        accDetail.Name = '0000147163';
        accDetail.RecType__c = 'ACCT';
        accDetail.TypeTranslate__c = '1-PERSONAL';
        insert accDetail;
        RecordType rt = [Select id, Name , SobjectType from Recordtype where sObjectType = 'case' and Name = 'Account Servicing' limit 1];
        
        CaseRecordType__c c = new CaseRecordType__c();
        c.Primary_Category__c = 'Account Maintenance';
        c.Secondary_Category__c= 'Memberships';
        c.Teritiary_Category__c= 'Address/Contact Updates';
        c.RecordTypeId__c = rt.Id;
        c.Name = '1';
        insert c;    
        
        
        
        list<CaseRecordType__c> scList = [SELECT Id,
                                          Primary_Category__c,
                                          Secondary_Category__c,
                                          Teritiary_Category__c,
                                          Record_Type_Name__c,
                                          RecordTypeId__c FROM CaseRecordType__c WHERE Primary_Category__c = 'Account Maintenance' AND Secondary_Category__c= 'Memberships' AND Teritiary_Category__c= 'Address/Contact Updates' LIMIT 1];  
        Test.startTest();
        
        AddressChangeLog__c objAC = new AddressChangeLog__c();
        objAC.Update_Type__c = 'Residential Address';
        objAC.AccountNamePair__c='0000244432|JEFF PACHENO FRANKLIN';
        objAC.AccountNumbersString__c = '0000000123,0000000124';
        objAC.Is_Temp_Mail_Expired__c=true;
        objAC.Expired_Temp_Mail_Details__c='0000222441|Test|Test|Test|Test|Test';
        objAC.Address2_New__c = 'New Address2';
        objAC.Address2_Old__c = 'Old Address2';
        //objAC.AccountNumber__c='0000000123';
        objAC.Address_New__c = 'New Address';
        objAC.Address_Old__c = 'Old Address';
        //  objAC.CaseId__c =case_Obj[0].Id;
        objAC.City_New__c = 'City Old';
        objAC.City_Old__c = 'City New';
        objAC.Email__c = 'test@test.com';
        //objAC.MemberName__c = 'Name';
        objAC.MobilePhone__c = '309-310-1173';
        objAC.State_New__c = 'CA';
        objAC.State_Old__c = 'CA';
        objAC.Zip_New__c = '12345';
        objAC.Zip_Old__c = '67890';
        objAC.AccountNumbersString__c =accDetail.Name;
        objAC.Member__c =acc.Id;
        objAC.Clean_Up_Intake_Method__c = 'In Person Request';
        
        insert objAC;

        test.stopTest();
    }

    static testMethod void UpdateResidentialAddress(){

        Account_Details__c accDetail = [select id, Name from Account_Details__c limit 1];
        Account acc = [select id, Name from Account limit 1];

        Test.startTest();
        
        AddressChangeLog__c objAC = new AddressChangeLog__c();
        objAC.Update_Type__c = 'Residential Address';
        objAC.AccountNamePair__c='0000244432|JEFF PACHENO FRANKLIN';
        objAC.AccountNumbersString__c = '0000000123,0000000124';
        objAC.Is_Temp_Mail_Expired__c=true;
        objAC.Expired_Temp_Mail_Details__c='0000222441|Test|Test|Test|Test|Test';
        objAC.Address2_New__c = 'New Address2';
        objAC.Address2_Old__c = 'Old Address2';
        //objAC.AccountNumber__c='0000000123';
        objAC.Address_New__c = 'New Address';
        objAC.Address_Old__c = 'Old Address';
        //  objAC.CaseId__c =case_Obj[0].Id;
        objAC.City_New__c = 'City Old';
        objAC.City_Old__c = 'City New';
        objAC.Email__c = 'test@test.com';
        //objAC.MemberName__c = 'Name';
        objAC.MobilePhone__c = '309-310-1173';
        objAC.State_New__c = 'CA';
        objAC.State_Old__c = 'CA';
        objAC.Zip_New__c = '12345';
        objAC.Zip_Old__c = '67890';
        objAC.AccountNumbersString__c =accDetail.Name;
        objAC.Member__c =acc.Id;
        objAC.Clean_Up_Intake_Method__c = 'In Person Request';
        
        insert objAC;

        test.stopTest();
    }

    static testMethod void UpdateContactInfo(){

        Account_Details__c accDetail = [select id, Name from Account_Details__c limit 1];
        Account acc = [select id, Name from Account limit 1];
        Test.startTest();
        
        AddressChangeLog__c objAC = new AddressChangeLog__c();
        objAC.Update_Type__c = 'Contact Info';
        objAC.AccountNamePair__c='0000244432|JEFF PACHENO FRANKLIN';
        objAC.AccountNumbersString__c = '0000000123,0000000124';
        objAC.Address2_New__c = 'New Address2';
        objAC.Address2_Old__c = 'Old Address2';
        //objAC.AccountNumber__c='0000000123';
        objAC.Address_New__c = 'New Address';
        objAC.Address_Old__c = 'Old Address';
        //  objAC.CaseId__c =case_Obj[0].Id;
        objAC.City_New__c = 'City Old';
        objAC.City_Old__c = 'City New';
        objAC.Email__c = 'test@test.com';
        //objAC.MemberName__c = 'Name';
        objAC.MobilePhone__c = '309-310-1173';
        objAC.State_New__c = 'CA';
        objAC.State_Old__c = 'CA';
        objAC.Zip_New__c = '12345';
        objAC.Zip_Old__c = '67890';
        objAC.AccountNumbersString__c =accDetail.Name;
        objAC.Member__c =acc.Id;
        objAC.HomePhone_Old__c='9456787776';
        objAC.HomePhone_New__c='8787656745';
        objAC.MobilePhone_Old__c='7645345676';
        objAC.MobilePhone_New__c='7645345671';
        objAC.WorkPhone_Old__c='7645345276';
        objAC.WorkPhone_New__c='7645345336';
        objAC.WorkExtension_Old__c='1234';
        objAC.WorkExtension_New__c='5678';
        objAC.Email_Old__c='test@gmail.com';
        objAC.Email_New__c='test123@gmail.com';
        objAC.AlternateEmail_Old__c='ter@gmail.com';
        objAC.AlternateEmail_New__c='srg@gmail.com';
        objAC.AccountNameOldEmail__C='0000198612|SPECTRUMQA TEST612|MCATALANO@CHEVRONFCU.ORG|666147279,';
        objAC.Clean_Up_Intake_Method__c = 'In Person Request';     
        insert objAC;

        test.stopTest();
    }

    static testMethod void UpdateMailingAddress(){

        Account_Details__c accDetail = [select id, Name from Account_Details__c limit 1];
        Account acc = [select id, Name from Account limit 1];
        Test.startTest();
        
        AddressChangeLog__c objAC = new AddressChangeLog__c();
        objAC.Update_Type__c = 'Temp Mailing Address - New';
        objAC.AccountNamePair__c='0000286810|CHEVRONQA TEST123|666147265|6,';
        objAC.AccountNumbersString__c = '0000286810,';
        objAC.Address2_New__c = 'New Address2';
        objAC.Address2_Old__c = 'Old Address2';
        //objAC.AccountNumber__c='0000000123';
        objAC.Address_New__c = 'New Address';
        objAC.Address_Old__c = 'Old Address';
        //  objAC.CaseId__c =case_Obj[0].Id;
        objAC.City_New__c = 'City Old';
        objAC.City_Old__c = 'City New';
        objAC.Email__c = 'test@test.com';
        //objAC.MemberName__c = 'Name';
        objAC.MobilePhone__c = '309-310-1173';
        objAC.State_New__c = 'CA';
        objAC.State_Old__c = 'CA';
        objAC.Zip_New__c = '12345';
        objAC.Zip_Old__c = '67890';
        objAC.AccountNumbersString__c =accDetail.Name;
        objAC.Member__c =acc.Id;
        objAC.HomePhone_Old__c='9456787776';
        objAC.HomePhone_New__c='8787656745';
        objAC.MobilePhone_Old__c='7645345676';
        objAC.MobilePhone_New__c='7645345671';
        objAC.WorkPhone_Old__c='7645345276';
        objAC.WorkPhone_New__c='7645345336';
        objAC.WorkExtension_Old__c='1234';
        objAC.WorkExtension_New__c='5678';
        objAC.Email_Old__c='test@gmail.com';
        objAC.Email_New__c='test123@gmail.com';
        objAC.AlternateEmail_Old__c='ter@gmail.com';
        objAC.AlternateEmail_New__c='srg@gmail.com';
        objAC.AccountNameOldEmail__C='0000198612|SPECTRUMQA TEST612|MCATALANO@CHEVRONFCU.ORG|666147279,';
        objAC.Clean_Up_Intake_Method__c = 'In Person Request';     
        insert objAC;

        test.stopTest();
    }

    static testMethod void getIntakeMethodPickListValues(){
        AddressChangeLogController.getIntakeMethodPickListValues();
    }

    static testMethod void getIdentificationMethodPickListValues(){
        AddressChangeLogController.getIdentificationMethodPickListValues();
    }

    static testMethod void saveSignature(){

        AddressChangeLog__c accDetail = [select id, Name from AddressChangeLog__c limit 1];

        AddressChangeLogController.saveSignature('test',accDetail.id);
    }
}
