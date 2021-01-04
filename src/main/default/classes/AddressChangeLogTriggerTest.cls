// ---------------------Created By: Dhwani: Test class for AddressChangeLog Trigger..................//       
@isTest  
public class AddressChangeLogTriggerTest {
    
    static testMethod void test1(){
        
        AddressChangeConfigurations__c cs = new AddressChangeConfigurations__c();	 	
        cs.SendEmail__c = false;	
        cs.Name = 'Primary'; 
        cs.SendSMS__c = true;	
        insert cs; 
        
        Account acc = new Account();
        //acc.RecordTypeID=rtId;
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
        //	objAC.CaseId__c =case_Obj[0].Id;
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
        insert objAC;
        
        AddressChangeLog__c objAC1 = new AddressChangeLog__c();
        objAC1.Update_Type__c = 'Card Mailing Address';
        objAC1.AccountNumbersString__c = '0000000123,0000000123';
        objAC1.Address2_New__c = 'New Address2';
        objAC1.Address2_Old__c = 'Old Address2';
        //objAC1.AccountNumber__c='0000000123';
        objAC1.Address_New__c = 'New Address';
        objAC1.Address_Old__c = 'Old Address';
        //objAC1.CaseId__c =case_Obj[0].Id;
        objAC1.City_New__c = 'City Old';
        objAC1.City_Old__c = 'City New';
        objAC1.Email__c = 'test@test.com';
        //objAC1.MemberName__c = 'Name';
        objAC1.MobilePhone__c = '309-310-1173';
        objAC1.State_New__c = 'CA';
        objAC1.State_Old__c = 'CA';
        objAC1.Zip_New__c = '12345';
        objAC1.Zip_Old__c = '67890';
        objAC1.AccountNumbersString__c =accDetail.Name;
        objAC1.Member__c =acc.Id;
        insert objAC1;
        
        AddressChangeLog__c objAC2 = new AddressChangeLog__c();
        objAC2.Update_Type__c = 'Temp Mailing Address';
        objAC2.AccountNumbersString__c = '0000000123,0000000124';
        objAC2.Address2_New__c = 'New Address2';
        objAC2.Address2_Old__c = 'Old Address2';
        //objAC2.AccountNumber__c='0000000123';
        objAC2.Address_New__c = 'New Address';
        objAC2.Address_Old__c = 'Old Address';
        //objAC2.CaseId__c =case_Obj[0].Id;
        objAC2.City_New__c = 'City New';
        objAC2.City_Old__c = 'City Old';
        objAC2.Email__c = 'test@test.com';
        //objAC2.MemberName__c = 'Name';
        objAC2.MobilePhone__c = '309-310-1173';
        objAC2.State_New__c = 'CA';
        objAC2.State_Old__c = 'CA';
        objAC2.Zip_New__c = '12345';
        objAC2.Zip_Old__c = '67890';
        objAC2.AccountNumbersString__c =accDetail.Name;
        objAC2.Member__c =acc.Id;
        insert objAC2;
        
        /*	AddressChangeLog__c objAC3 = new AddressChangeLog__c();
objAC3.Update_Type__c = 'Temp Mailing Address - New';
objAC3.AccountNumbersString__c = '0000000123,0000000124';
objAC3.Address2_New__c = 'New Address2';	 
objAC3.Address_New__c = 'New Address';
objAC3.Address_Old__c = 'Old Address';
//objAC3.CaseId__c =case_Obj[0].Id;
objAC3.City_New__c = 'City Old';	 	
objAC3.Email__c = 'test@test.com';
//objAC3.MemberName__c = 'Name';
objAC3.MobilePhone__c = '309-310-1173';
objAC3.State_New__c = 'CA';

objAC3.Zip_New__c = '12345';

objAC3.AccountNumbersString__c =accDetail.Name;
insert objAC3;

AddressChangeLog__c objAC4 = new AddressChangeLog__c();
objAC4.Update_Type__c = 'Contact Info';
objAC4.AccountNumbersString__c = '0000000123,0000000124';
objAC4.Address2_New__c = 'New Address2';	 
objAC4.Address_New__c = 'New Address';
objAC4.Address_Old__c = 'Old Address';
//	objAC4.CaseId__c =case_Obj[0].Id;
objAC4.City_New__c = 'City Old';	 	
objAC4.Email__c = 'test@test.com';
//objAC4.MemberName__c = 'Name';
objAC4.MobilePhone__c = '309-310-1173';
objAC4.State_New__c = 'CA';

objAC4.Zip_New__c = '12345';

objAC4.AccountNumbersString__c =accDetail.Name;
insert objAC4;*/
        Test.stopTest();
    }
    
    static testMethod void test2(){
        
        AddressChangeConfigurations__c cs = new AddressChangeConfigurations__c();	 	
        cs.SendEmail__c = false;	
        cs.Name = 'Primary'; 
        cs.SendSMS__c = true;	
        insert cs; 
        
        Account acc = new Account();
        //acc.RecordTypeID=rtId;
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
                                          RecordTypeId__c FROM CaseRecordType__c 
                                          WHERE Primary_Category__c = 'Account Maintenance' 
                                          AND Secondary_Category__c= 'Memberships' 
                                          AND Teritiary_Category__c= 'Address/Contact Updates' 
                                          LIMIT 1];	
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
        //	objAC.CaseId__c =case_Obj[0].Id;
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
        insert objAC;
        
        AddressChangeLog__c objAC1 = new AddressChangeLog__c();
        objAC1.Update_Type__c = 'Card Mailing Address';
        objAC1.AccountNumbersString__c = '0000000123,0000000123';
        objAC1.Address2_New__c = 'New Address2';
        objAC1.Address2_Old__c = 'Old Address2';
        //objAC1.AccountNumber__c='0000000123';
        objAC1.Address_New__c = 'New Address';
        objAC1.Address_Old__c = 'Old Address';
        //objAC1.CaseId__c =case_Obj[0].Id;
        objAC1.City_New__c = 'City Old';
        objAC1.City_Old__c = 'City New';
        objAC1.Email__c = 'test@test.com';
        //objAC1.MemberName__c = 'Name';
        objAC1.MobilePhone__c = '309-310-1173';
        objAC1.State_New__c = 'CA';
        objAC1.State_Old__c = 'CA';
        objAC1.Zip_New__c = '12345';
        objAC1.Zip_Old__c = '67890';
        objAC1.AccountNumbersString__c =accDetail.Name;
        objAC1.Member__c =acc.Id;
        insert objAC1;
        
        AddressChangeLog__c objAC2 = new AddressChangeLog__c();
        objAC2.Update_Type__c = 'Temp Mailing Address';
        objAC2.AccountNumbersString__c = '0000000123,0000000124';
        objAC2.Address2_New__c = 'New Address2';
        objAC2.Address2_Old__c = 'Old Address2';
        //objAC2.AccountNumber__c='0000000123';
        objAC2.Address_New__c = 'New Address';
        objAC2.Address_Old__c = 'Old Address';
        //objAC2.CaseId__c =case_Obj[0].Id;
        objAC2.City_New__c = 'City New';
        objAC2.City_Old__c = 'City Old';
        objAC2.Email__c = 'test@test.com';
        //objAC2.MemberName__c = 'Name';
        objAC2.MobilePhone__c = '309-310-1173';
        objAC2.State_New__c = 'CA';
        objAC2.State_Old__c = 'CA';
        objAC2.Zip_New__c = '12345';
        objAC2.Zip_Old__c = '67890';
        objAC2.AccountNumbersString__c =accDetail.Name;
        objAC2.Member__c =acc.Id;
        insert objAC2;
        
        
        Test.stopTest();
    }
    
    static testMethod void test3(){
        
        AddressChangeConfigurations__c cs = new AddressChangeConfigurations__c();	 	
        cs.SendEmail__c = false;	
        cs.Name = 'Primary'; 
        cs.SendSMS__c = true;	
        insert cs; 
        
        Account acc = new Account();
        //acc.RecordTypeID=rtId;
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
        RecordType rt = [Select id, Name , SobjectType from Recordtype 
                         where sObjectType = 'case' and Name = 'Account Servicing' limit 1];
        
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
                                          RecordTypeId__c FROM CaseRecordType__c 
                                          WHERE Primary_Category__c = 'Account Maintenance' 
                                          AND Secondary_Category__c= 'Memberships' 
                                          AND Teritiary_Category__c= 'Address/Contact Updates' 
                                          LIMIT 1];	
        Test.startTest();
        
        AddressChangeLog__c objAC = new AddressChangeLog__c();
        objAC.Update_Type__c = 'Temp Mailing Address - New';
        objAC.AccountNamePair__c='0000244432|JEFF PACHENO FRANKLIN';
        objAC.AccountNumbersString__c = '0000000123,0000000124';
        objAC.Address2_New__c = 'New Address2';
        objAC.Address2_Old__c = 'Old Address2';
        //objAC.AccountNumber__c='0000000123';
        objAC.Address_New__c = 'New Address';
        objAC.Address_Old__c = 'Old Address';
        //	objAC.CaseId__c =case_Obj[0].Id;
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
        insert objAC;
        
        AddressChangeLog__c objAC1 = new AddressChangeLog__c();
        objAC1.Update_Type__c = 'Card Mailing Address';
        objAC1.AccountNumbersString__c = '0000000123,0000000123';
        objAC1.Address2_New__c = 'New Address2';
        objAC1.Address2_Old__c = 'Old Address2';
        //objAC1.AccountNumber__c='0000000123';
        objAC1.Address_New__c = 'New Address';
        objAC1.Address_Old__c = 'Old Address';
        //objAC1.CaseId__c =case_Obj[0].Id;
        objAC1.City_New__c = 'City Old';
        objAC1.City_Old__c = 'City New';
        objAC1.Email__c = 'test@test.com';
        //objAC1.MemberName__c = 'Name';
        objAC1.MobilePhone__c = '309-310-1173';
        objAC1.State_New__c = 'CA';
        objAC1.State_Old__c = 'CA';
        objAC1.Zip_New__c = '12345';
        objAC1.Zip_Old__c = '67890';
        objAC1.AccountNumbersString__c =accDetail.Name;
        objAC1.Member__c =acc.Id;
        insert objAC1;
        
        AddressChangeLog__c objAC2 = new AddressChangeLog__c();
        objAC2.Update_Type__c = 'Temp Mailing Address';
        objAC2.AccountNumbersString__c = '0000000123,0000000124';
        objAC2.Address2_New__c = 'New Address2';
        objAC2.Address2_Old__c = 'Old Address2';
        //objAC2.AccountNumber__c='0000000123';
        objAC2.Address_New__c = 'New Address';
        objAC2.Address_Old__c = 'Old Address';
        //objAC2.CaseId__c =case_Obj[0].Id;
        objAC2.City_New__c = 'City New';
        objAC2.City_Old__c = 'City Old';
        objAC2.Email__c = 'test@test.com';
        //objAC2.MemberName__c = 'Name';
        objAC2.MobilePhone__c = '309-310-1173';
        objAC2.State_New__c = 'CA';
        objAC2.State_Old__c = 'CA';
        objAC2.Zip_New__c = '12345';
        objAC2.Zip_Old__c = '67890';
        objAC2.AccountNumbersString__c =accDetail.Name;
        objAC2.Member__c =acc.Id;
        insert objAC2;
        
        
        Test.stopTest();
    }
    
    static testMethod void test4(){
        
        AddressChangeConfigurations__c cs = new AddressChangeConfigurations__c();	 	
        cs.SendEmail__c = false;	
        cs.Name = 'Primary'; 
        cs.SendSMS__c = true;	
        insert cs; 
        
        Account acc = new Account();
        //acc.RecordTypeID=rtId;
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
        RecordType rt = [Select id, Name , SobjectType from Recordtype 
                         where sObjectType = 'case' and Name = 'Account Servicing' limit 1];
        
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
                                          RecordTypeId__c FROM CaseRecordType__c 
                                          WHERE Primary_Category__c = 'Account Maintenance' 
                                          AND Secondary_Category__c= 'Memberships' 
                                          AND Teritiary_Category__c= 'Address/Contact Updates' 
                                          LIMIT 1];	
        Test.startTest();
        
        AddressChangeLog__c objAC = new AddressChangeLog__c();
        objAC.Update_Type__c = 'Mailing Address';
        objAC.AccountNamePair__c='0000244432|JEFF|PACHENO|FRANKLIN';
        objAC.AccountNumbersString__c = '0000000123,0000000124';
        objAC.Address2_New__c = 'New Address2';
        objAC.Address2_Old__c = 'Old Address2';
        //objAC.AccountNumber__c='0000000123';
        objAC.Address_New__c = 'New Address';
        objAC.Address_Old__c = 'Old Address';
        //	objAC.CaseId__c =case_Obj[0].Id;
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
        insert objAC;
        
        AddressChangeLog__c objAC1 = new AddressChangeLog__c();
        objAC1.Update_Type__c = 'Card Mailing Address';
        objAC1.AccountNumbersString__c = '0000000123,0000000123';
        objAC1.Address2_New__c = 'New Address2';
        objAC1.Address2_Old__c = 'Old Address2';
        //objAC1.AccountNumber__c='0000000123';
        objAC1.Address_New__c = 'New Address';
        objAC1.Address_Old__c = 'Old Address';
        //objAC1.CaseId__c =case_Obj[0].Id;
        objAC1.City_New__c = 'City Old';
        objAC1.City_Old__c = 'City New';
        objAC1.Email__c = 'test@test.com';
        //objAC1.MemberName__c = 'Name';
        objAC1.MobilePhone__c = '309-310-1173';
        objAC1.State_New__c = 'CA';
        objAC1.State_Old__c = 'CA';
        objAC1.Zip_New__c = '12345';
        objAC1.Zip_Old__c = '67890';
        objAC1.AccountNumbersString__c =accDetail.Name;
        objAC1.Member__c =acc.Id;
        insert objAC1;
        
        AddressChangeLog__c objAC2 = new AddressChangeLog__c();
        objAC2.Update_Type__c = 'Temp Mailing Address';
        objAC2.AccountNumbersString__c = '0000000123,0000000124';
        objAC2.Address2_New__c = 'New Address2';
        objAC2.Address2_Old__c = 'Old Address2';
        //objAC2.AccountNumber__c='0000000123';
        objAC2.Address_New__c = 'New Address';
        objAC2.Address_Old__c = 'Old Address';
        //objAC2.CaseId__c =case_Obj[0].Id;
        objAC2.City_New__c = 'City New';
        objAC2.City_Old__c = 'City Old';
        objAC2.Email__c = 'test@test.com';
        //objAC2.MemberName__c = 'Name';
        objAC2.MobilePhone__c = '309-310-1173';
        objAC2.State_New__c = 'CA';
        objAC2.State_Old__c = 'CA';
        objAC2.Zip_New__c = '12345';
        objAC2.Zip_Old__c = '67890';
        objAC2.AccountNumbersString__c =accDetail.Name;
        objAC2.Member__c =acc.Id;
        insert objAC2;
        
        
        Test.stopTest();
    }
}