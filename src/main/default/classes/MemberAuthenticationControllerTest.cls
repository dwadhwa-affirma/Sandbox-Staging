@isTest
public class MemberAuthenticationControllerTest {
    
    static testMethod void MemberAuthenticationTest1() {
        
        MemberAuthenticationController ma = new MemberAuthenticationController();
        ma.selectedID='';
        boolean showErrorMsgLoanData2 =ma.showErrorMsgLoanData;
        Account acobj = new Account();
        //acobj.Name = 'UD';
        acobj.FirstName = 'U';
        acobj.LastName = 'D';
        acobj.BIRTH_DATE__pc = date.parse('04/04/1963');
        acobj.Employee_Restricted_Access__c = 1234;
        acobj.Home_Phone__pc = '9169954478';
        acobj.Email_raw__c = 'test@test.com';
        insert acobj;
        
        ma.selectedID = acobj.id;          
        verifyCaller vc = new verifyCaller();
        ma.Names = vc.getAccountByName(acobj.id);
        // ma.firstname='U';
        //  ma.lastName='D';
        
        MemberAuthenticationController.JTMemberNameDoBWrapper objWrapper = new MemberAuthenticationController.JTMemberNameDoBWrapper();
        objWrapper.AccountNumber = '123245';
        objWrapper.RelationShip = 'Brother';
        objWrapper.Jtname = 'Michael';
        //objWrapper.DT = '1/1/1986 02:30';
        objWrapper.ckJtMemberNameConfirm = true;
        objWrapper.ckJtMemberDOBConfirm = false;
        
        boolean showTables = ma.showloantables;
        boolean showLoanData = ma.showloantables;
        boolean showErrorMsgLoanData =ma.showErrorMsgLoanData;
        Integer namelst  =ma.nameListSize;
        ma.JtMemberNameConfirm = true;
        ma.JtMemberDOBConfirm = true;
        
        ma.homePage();
        ma.NewLeadPage();
        ma.DetailsPage();
        
    }
    
    static testMethod void MemberAuthenticationTest2() {
        string PhoneNumber = '9169954478';
        string EnteredMemberNumber = '214414';
        string EnteredMemberNumberRetain = '214414';
        string EnteredCardNumber = '3836';
        string EnteredSSN = '5051';
        string SalesforceID;
        string selectedID;
        string DOBthis = '2017-05-05';
        
        Account_Details__c ac = new Account_Details__c();
        ac.Name = '00001';
        ac.TypeTranslate__c = '1-PERSONAL';
        ac.Balance__c = 5000;
        ac.RecType__c = 'LOAN';       
        insert ac;
        
        Account acobj = new Account();
        //acobj.Name = 'UD';
        acobj.FirstName = 'U';
        acobj.LastName = 'D';
        acobj.BIRTH_DATE__pc = date.parse('04/04/1963');
        acobj.Employee_Restricted_Access__c = 1234;
        acobj.Home_Phone__pc = '9169954478';
        acobj.Email_raw__c = 'test@test.com';
        insert acobj;
        
        Person_Account__c pc2 = new Person_Account__c();
        pc2.Account_Number__c = ac.id;
        pc2.PersonID__c = acobj.id;
        pc2.RecType__c = 'LOAN';
        pc2.TypeTranslate__c = '001/Beneficiary';
        insert pc2;
        
        
        Person_Account__c pc = new Person_Account__c();
        pc.Account_Number__c = ac.id;
        pc.PersonID__c = acobj.id;
        pc.RecType__c = 'LOAN';
        pc.TypeTranslate__c = '001/Joint Member';
        insert pc;
        
        ApexPages.currentPage().getParameters().put('CallersPhoneNumber',PhoneNumber);
        ApexPages.currentPage().getParameters().put('PhoneNumber',PhoneNumber);
        ApexPages.currentPage().getParameters().put('EnteredMemberNumber',EnteredMemberNumber);
        ApexPages.currentPage().getParameters().put('EnteredCardNumber',EnteredCardNumber);
        ApexPages.currentPage().getParameters().put('EnteredSSN',EnteredSSN);
        ApexPages.currentPage().getParameters().put('SalesforceID',acobj.id);
        ApexPages.currentPage().getParameters().put('PINMatch','false');
        ApexPages.currentPage().getParameters().put('PhoneNumberMatch','false');
        ApexPages.currentPage().getParameters().put('MemberNumberMatch','false');
        ApexPages.currentPage().getParameters().put('SSNnumberMatch','true');
        ApexPages.currentPage().getParameters().put('CardNumberMatch','true');
        ApexPages.currentPage().getParameters().put('CardNumberMatch','null');
        //ApexPages.currentPage().getParameters().put('DOB',DOBthis);
        //ApexPages.currentPage().getParameters().put('DOBMatch','False');
        
        //ApexPages.currentPage().getParameters().put('selectedID',accounts[0].id);
        
        
        MemberAuthenticationController ma = new MemberAuthenticationController();
        ma.CheckIfMemberValidated();
        //ma.selectedID='123456789123456789';
        ma.PhoneNumberMatch  = 'true';
        ma.CardNumberMatch  = 'true';
        ma.MemberNumberMatch = 'true';
        ma.SSNnumberMatch = 'true';
        //ma.PhoneNumber = '1234567890';
        //ma.EnteredMemberNumber = '123456789';
        //ma.EnteredCardNumber = '123456789';
        ma.DOB= '1963-04-30';
        //ma.selectedID = accounts[0].id;
        
        /*verificationObject verificationObject = new verificationObject();
verificationObject.DOB = system.today();
verificationObject.ICardNumber = '12345678';
verificationObject.MMN = '123455';
verificationObject.Pin = 'test1234';   */ 
        
        //ma.VerifyCallerDeatils();
        //ma.NameList = new  list<Account>();
        //ma.NameList.add(acobj);
        
        //ma.verifySelectedCallerDetails();
        system.debug('Testma.NameList----'+ma.NameList);
        ma.NoIVRInformation();
        ma.selectedID = acobj.id;
        //ma.selectedID = ma.NameList[0].id;
        ma.verifySelectedCallerDetails();
        ma.SalesforceID = ma.selectedID;
        //ma.DetailsPage();
        //verifyCaller vc = new verifyCaller();
        //vc.getAccountByName(accounts[0].id);
    }
    
    static testMethod void MemberAuthenticationTest3() {
        
        MemberAuthenticationController ma = new MemberAuthenticationController();
        
        ma.PhoneNumberMatch  = 'true';
        ma.CardNumberMatch  = 'true';
        ma.MemberNumberMatch = 'false';
        ma.SSNnumberMatch = 'true';
        ma.PhoneNumber = '1234567890';
        ma.EnteredMemberNumber = '123456789';
        ma.EnteredCardNumber = '123456789';
        ma.EnteredSSN = '123456';
        ma.VerifyCallerDetails();
        ma.NoIVRInformation();
        
    }
    static testMethod void MemberAuthenticationTest4() {
        
        MemberAuthenticationController ma = new MemberAuthenticationController();
        
        ma.PhoneNumberMatch  = 'true';
        ma.CardNumberMatch  = 'false';
        ma.MemberNumberMatch = 'false';
        ma.SSNnumberMatch = 'false';
        ma.PhoneNumber = '9169954478';
        ma.EnteredMemberNumber = '';
        ma.EnteredCardNumber = '123456789';
        ma.EnteredSSN = '';
        ma.VerifyCallerDetails();
        //ma.verifySelectedCallerDetails();
        //ma.NoIVRInformation();
        
    }
    static testMethod void MemberAuthenticationTest5() {
        String SalesforceID;
        String selectedID;
        
        
        MemberAuthenticationController ma = new MemberAuthenticationController();
        List<SelectOption> options = ma.AdditionalTokens;
        List<SelectOption> optionsOther = ma.AdditionalTokensWithOther;
        
        String PhoneNumberMatch  = 'true';
        String CardNumberMatch  = 'false';
        String MemberNumberMatch = 'true';            
        String EnteredMemberNumber = '0000214414';
        String SSNnumberMatch = '';
        String PhoneNumber = '9169954478';
        String EnteredCardNumber = '1234';
        String EnteredSSN = '8120';
        String MMN = '';
        String MMNMatch = 'true';
        String DOB='1963-04-30';
        String DOBMatch = 'true';
        String IdNumber = 'N9482108';
        String IdNumberMatch = 'true';
        String SSNnumberConfirm  = 'true';
        
        
        //ma.verifySelectedCallerDetails();
        //ma.selectedID = accounts[0].id;
        ApexPages.currentPage().getParameters().put('CallersPhoneNumber',PhoneNumber);
        ApexPages.currentPage().getParameters().put('EnteredMemberNumber',EnteredMemberNumber);
        ApexPages.currentPage().getParameters().put('EnteredCardNumber',EnteredCardNumber);
        ApexPages.currentPage().getParameters().put('EnteredSSN',EnteredSSN);
        ApexPages.currentPage().getParameters().put('PhoneNumber',PhoneNumber);       
        ApexPages.currentPage().getParameters().put('PhoneNumberMatch','true');
        ApexPages.currentPage().getParameters().put('MemberNumberMatch','true');
        ApexPages.currentPage().getParameters().put('SSNnumberMatch','true');
        ApexPages.currentPage().getParameters().put('CardNumberMatch','');
        ApexPages.currentPage().getParameters().put('MMN',MMN);
        ApexPages.currentPage().getParameters().put('MMNMatch',MMNMatch);
        ApexPages.currentPage().getParameters().put('DOB',DOB);
        ApexPages.currentPage().getParameters().put('DOBMatch',DOBMatch);
        ApexPages.currentPage().getParameters().put('IdNumber',IdNumber);
        ApexPages.currentPage().getParameters().put('IdNumberMatch',IdNumberMatch);
        ApexPages.currentPage().getParameters().put('SSNnumberConfirm',SSNnumberConfirm);
        ApexPages.currentPage().getParameters().put('DLStateIdPassportMatch','true');
        ApexPages.currentPage().getParameters().put('EmailMatch','true');
        
        List<Account_Details__c> account_details_Obj = new List<Account_Details__c>{
            new Account_Details__c(Name = '0000147163', Balance__c = 0.00, Combined_Account_ID__c = '0000147163S0100P0100', ID1__c ='0100', Onboarded__c = true, RecType__c = 'ACCT', TypeTranslate__c = '1-PRIMARY SHARE',
                                   Comment_Block_01__c='ABC',
                                   Comment_Block_02__c='ABC',
                                   Comment_Block_03__c='ABC',
                                   Comment_Block_04__c='TELEPHONE/EMAIL CHANGED WITHIN 60 DAYS',
                                   Comment_Block_05__c='ABC',
                                   Comment_Block_06__c='ABC',
                                   Comment_Block_07__c='ABC',
                                   Comment_Block_08__c='ABC',
                                   Comment_Block_09__c='ABC',
                                   Comment_Block_10__c='ABC',
                                   Comment_Block_11__c='ABC',
                                   Comment_Block_12__c='ABC',
                                   Comment_Block_13__c='ABC',
                                   Comment_Block_14__c='ABC',
                                   Comment_Block_15__c='ABC',
                                   Comment_Block_16__c='TELEPHONE/EMAIL CHANGED WITHIN 60 DAYS',
                                   Comment_Block_17__c='ABC',
                                   Comment_Block_18__c='ABC',
                                   Comment_Block_19__c='ABC',
                                   Comment_Block_20__c='ABC') };
                                       
                                       
                                       Insert account_details_Obj;
        Account acobj = new Account();
        //acobj.Name = 'UD';
        acobj.FirstName = 'U';
        acobj.LastName = 'D';
        acobj.BIRTH_DATE__pc =  Date.newInstance(2008, 1, 1);
        acobj.Employee_Restricted_Access__c = 1234;
        acobj.Home_Phone__pc = '9169954478';
        acobj.PersonEmail = 'test@test.com';
        acobj.Alternate_Email__pc = 'test1@test.com';
        insert acobj;
        
        Account accobj1 = new Account(LastName = 'BANDATest', FirstName = 'MARIATest', Type = 'null', Member_Verification_OTP_Invalid_Attempt__c = system.now(), Home_Phone__pc = '123456333390', Mobile_Phone__pc = '258963147852', Work_Phone__pc = '233333232323', PersonEmail = 'test2@test.com', Alternate_Email__pc = 'abc2@abc.com');
        insert accobj1;
        
        List<Person_Account__c> person_obj= new List<Person_Account__c>{new Person_Account__c(Account_Number__c = account_details_Obj[0].Id, PersonID__c = acobj.Id), 
            new Person_Account__c(Account_Number__c = account_details_Obj[0].Id, PersonID__c = accobj1.Id)};
                Insert person_obj;
        acobj.PersonEmail = 'test3@test.com';
        acobj.Alternate_Email__pc = 'test13@test.com';
         update acobj;

        OTPSettings__c otp = new OTPSettings__c();
        otp.Name = 'Member Verification';
        otp.OTPExpirationSeconds__c = 1;
        insert otp;
        
        ma.selectedID = acobj.id;          
        verifyCaller vc = new verifyCaller();
        ma.Names = vc.getAccountByName(acobj.id);
        
        ma.CheckIfMemberValidated();
        ma.VerifyCallerDetails();
        
        
        
        ma.verifySelectedCallerDetails();
        ma.EnteredCardNumber = '511625';
        //ma.DetailsPage(); 
        
        
        
        ma.MMN = 'COSSI';
        ma.MMNMatch = '';
        ma.NoIVRInformation();
        
        ma.MMN = 'COSSIYG';
        ma.selectedID = '';
        ma.IdNumberMatch = '';
        ma.EnteredSSN = '812045';
        ma.NoIVRInformation();
        
        ma.selectedID = '';
        ma.EnteredSSN = '';
        ma.SSNnumberMatch = 'true';
        ma.NoIVRInformation();
        
        ma.selectedID = '';
        ma.IdNumberMatch = 'true';
        ma.IdNumber = '';
        ma.NoIVRInformation();
        
        ma.selectedID = '';
        ma.CardNumberMatch = '';
        ma.EnteredCardNumber = '511625';
        ma.NoIVRInformation();
        
        ma.selectedID = '';
        ma.MemberNumberMatch = 'true';
        ma.EnteredMemberNumber = '';
        ma.EnteredSSN = '8120';         
        ma.SSNnumberMatch = 'true';
        ma.CardNumberMatch = 'true';
        ma.DOBMatch = 'true';
        ma.IdNumberMatch ='true';
        ma.IdNumber = 'N9482108';
        ma.MMNMatch = 'true';
        ma.EmailMatch='true';
        ma.DLStateIdPassportMatch='true';
        ma.Email='test@test.com';
        ma.DLStateIdPassport='1234';
        ma.Email='test@test.com';
        ma.DLStateIdPassport='1234';
        ma.NoIVRInformation();
        
        ma.SSNnumberMatch = '';
        ma.EnteredSSN = '8456';
        ma.MMN = 'COSSI';
        ma.MMNMatch = '';
        ma.DOBMatch = '';
        ma.DOB = '10-09-1990';
        ma.PhoneNumber = '123-123-1234';
        ma.PhoneNumberMatch = '';
        ma.Email = 'test@test.com';
        ma.EmailMatch = '';
        ma.NoIVRInformation();
        
        ma.oldFieldToMatch='SSNNumber';
        ma.NoIVRInformation();
        
        ma.oldFieldToMatch='DOB';
        ma.NoIVRInformation();
        
         ma.oldFieldToMatch='PhoneNumber';
        ma.NoIVRInformation();
        
        ma.selectedID = acobj.id;  
        ma.Email='test@test.com';
        //ma.UpdateDefaultEmail();
    }
    static testMethod void MemberValidates() {
        MemberAuthenticationController ma = new MemberAuthenticationController();
        String PhoneNumberMatch  = 'true';
        String CardNumberMatch  = 'false';
        String MemberNumberMatch = 'false';            
        String EnteredMemberNumber = '00214414';
        String SSNnumberMatch = 'false';
        String PhoneNumber = '9169954478';
        String EnteredCardNumber = '5116';
        String EnteredSSN = '8120';
        String MMN = 'COSSI';
        String MMNMatch = 'false';
        String DOB='1963-04-30';
        String DOBMatch = 'false';
        String IdNumber = 'N9482108';
        String IdNumberMatch = 'false';
        
        ApexPages.currentPage().getParameters().put('CallersPhoneNumber',PhoneNumber);
        ApexPages.currentPage().getParameters().put('EnteredMemberNumber',EnteredMemberNumber);
        ApexPages.currentPage().getParameters().put('EnteredCardNumber',EnteredCardNumber);
        ApexPages.currentPage().getParameters().put('EnteredSSN',EnteredSSN);
        ApexPages.currentPage().getParameters().put('PINMatch','true');
        ApexPages.currentPage().getParameters().put('PhoneNumberMatch','true');
        ApexPages.currentPage().getParameters().put('MemberNumberMatch','true');
        ApexPages.currentPage().getParameters().put('SSNnumberMatch','true');
        ApexPages.currentPage().getParameters().put('CardNumberMatch','true');
        
        Account acobj = new Account();
        //acobj.Name = 'UD';
        acobj.FirstName = 'U';
        acobj.LastName = 'D';
        acobj.BIRTH_DATE__pc = date.parse('04/04/1963');
        acobj.Employee_Restricted_Access__c = 1234;
        acobj.Home_Phone__pc = '9169954478';
        acobj.SSN_Last_4__pc = '8120';
        insert acobj;
        
        Account_Details__c ac = new Account_Details__c();
        ac.Name = '00001';
        ac.TypeTranslate__c = '1-PERSONAL';
        ac.Balance__c = 5000;
        ac.RecType__c = 'LOAN';
        ac.Card_Number__c = '5116';        
        insert ac;
        
        Account_Details__c ac1 = new Account_Details__c();
        ac1.Parent_Account__c = ac.Id;       
        ac1.Card_Number__c = '5116';
        insert ac1;
        
        Person_Account__c pc = new Person_Account__c();
        pc.Account_Number__c = ac.id;
        pc.PersonID__c = acobj.id;
        pc.RecType__c = 'LOAN';
        pc.TypeTranslate__c = '001/Joint Member';
        insert pc;
        
        ma.selectedID = acobj.id;          
        verifyCaller vc = new verifyCaller();
        ma.Names = vc.getAccountByName(acobj.id);
        
        ma.CheckIfMemberValidated();
        ma.VerifyCallerDetails();        
        
        ma.verifySelectedCallerDetails();
        ma.SalesforceID = ma.selectedID;
        //ma.AlternateAutheticationPageAction(); 
        //ma.NameList.add(accounts[0]);
        //ma.getNameList_Options();
        ma.ClearAllFlag = true;
        ma.verifySelectedCallerDetails();
        ma.EnteredMemberNumber='';
        ma.verifySelectedCallerDetails();
    }
    
    static testMethod void MemberAuthenticationTest6() {
        string PhoneNumber = '916-9954-478';
        string EnteredMemberNumber = '214414';
        string EnteredCardNumber = '5116';
        string EnteredSSN = '8120';
        string SalesforceID;
        string selectedID;
        
        //ApexPages.currentPage().getParameters().put('selectedID',accounts[0].id);
        
        MemberAuthenticationController ma = new MemberAuthenticationController();
        //ma.CheckIfMemberValidated();
        //ma.selectedID='123456789123456789';
        
        Account_Details__c ac = new Account_Details__c();
        ac.Name = '00001';
        ac.TypeTranslate__c = '1-PERSONAL';
        ac.Balance__c = 5000;
        ac.RecType__c = 'LOAN';
        insert ac;
        
        Account acobj = new Account();
        //acobj.Name = 'UD';
        acobj.FirstName = 'U';
        acobj.LastName = 'D';
        acobj.PersonEmail = 'test@test.com';
        //acobj.Default_Email__c='test@test.com';
        acobj.BIRTH_DATE__pc = date.parse('04/04/1963');
        acobj.Employee_Restricted_Access__c = 1234;
        acobj.Home_Phone__pc = '916-995-4478';
        acobj.Mobile_Phone__pc = '916-995-4478';
        acobj.Work_Phone__pc = '916-995-4478';
        acobj.PersonMobilePhone='916-995-4478';
        insert acobj;
        
        Person_Account__c pc2 = new Person_Account__c();
        pc2.Account_Number__c = ac.id;
        pc2.PersonID__c = acobj.id;
        pc2.RecType__c = 'LOAN';
        pc2.TypeTranslate__c = '001/Beneficiary';
        insert pc2;
        
        
        Person_Account__c pc = new Person_Account__c();
        pc.Account_Number__c = ac.id;
        pc.PersonID__c = acobj.id;
        pc.RecType__c = 'LOAN';
        pc.TypeTranslate__c = '001/Joint Member';
        insert pc;
        
        OTPSettings__c otp = new OTPSettings__c();
        otp.Name = 'Member Verification';
        otp.OTPExpirationSeconds__c = 1;
        insert otp;
        //ApexPages.currentPage().getParameters().put('selectedID',acobj.id);
        ApexPages.currentPage().getParameters().put('CallersPhoneNumber',PhoneNumber);
        ApexPages.currentPage().getParameters().put('EnteredMemberNumber',ac.Name);
        ApexPages.currentPage().getParameters().put('EnteredCardNumber',EnteredCardNumber);
        ApexPages.currentPage().getParameters().put('EnteredSSN',EnteredSSN);
        ApexPages.currentPage().getParameters().put('SalesforceID',acobj.id);
        ApexPages.currentPage().getParameters().put('PINMatch','false');
        ApexPages.currentPage().getParameters().put('PhoneNumber',PhoneNumber);
        ApexPages.currentPage().getParameters().put('PhoneNumberMatch','false');
        ApexPages.currentPage().getParameters().put('MemberNumberMatch','true');
        ApexPages.currentPage().getParameters().put('SSNnumberMatch','true');
        ApexPages.currentPage().getParameters().put('CardNumberMatch','null');
        
        //Test.startTest();
        ma.EnteredMemberNumber = ac.Name;
        system.debug('--ma.EnteredMemberNumber--'+ma.EnteredMemberNumber);
        ma.PhoneNumberMatch  = 'true';
        ma.CardNumberMatch  = 'true';
        ma.MemberNumberMatch = 'true';
        ma.SSNnumberMatch = 'true';
        ma.selectedID = acobj.id;
        //ma.DOB = date.parse('1963/04/04');
        ma.DOB= '1963/04/04';
        //ma.selectedID = accounts[0].id;
        ma.NameList = new  list<Account>();
        ma.NameList.add(acobj);
        ma.JTMemberNameDobDetails = new List<Person_Account__c>(); 
        ma.JTMemberNameDobDetails.add(pc);
        
        ma.SSNnumberConfirm = true;
        ma.JTMemberNameDobDetails = new List<Person_Account__c>(); 
        ma.JTMemberNameDobDetails.add(pc);
        system.debug('JTMemberNameDobDetailsin in test class-'+ma.JTMemberNameDobDetails);
        ma.LoanDetailConfirm = true;
        ma.SelectedID = pc2.id;
        ma.JTSelectedID = pc.id;
        ma.LoanSelectedID = '';
        
        ma.selectedID = acobj.id;          
        verifyCaller vc = new verifyCaller();
        ma.Names = vc.getAccountByName(acobj.id);
        
        ma.CheckIfMemberValidated();
        ma.NoIVRInformation();
        ma.DetailsPage();
        system.debug('--NameList test class--'+ma.NameList);
        system.debug('ma.SSNnumberConfirm test---'+ma.SSNnumberConfirm);
        
        
        
        ma.verifySelectedCallerDetails();
        ma.getNameList_Options();
        // ma.Showcardcheckbox  = true;
        ma.clearFields();
        //ma.DetailsPage();
        
        //Test.StopTest();
    }
    
    static testMethod void MemberAuthenticationTest7() {
        string PhoneNumber = '9169954478';
        string EnteredMemberNumber = '214414';
        string EnteredCardNumber = '5116';
        string EnteredSSN = '8120';
        string SalesforceID;
        string selectedID;
        
        //ApexPages.currentPage().getParameters().put('selectedID',accounts[0].id);
        
        MemberAuthenticationController ma = new MemberAuthenticationController();
        //ma.CheckIfMemberValidated();
        //ma.selectedID='123456789123456789';
        
        Account_Details__c ac = new Account_Details__c();
        ac.Name = '00001';
        ac.TypeTranslate__c = '1-PERSONAL';
        ac.Balance__c = 5000;
        ac.RecType__c = 'LOAN';
        ac.Close_Date__c  = system.today() + 30;
        insert ac;
        
        Account_Details__c ac2 = new Account_Details__c();
        ac2.Name = '00002';
        ac2.TypeTranslate__c = '1-PERSONAL';
        ac2.Balance__c = 5000;
        ac2.RecType__c = 'LOAN';
        ac2.Close_Date__c  = system.today() + 30;
        insert ac2;
        
        Account acobj = new Account();
        //acobj.Name = 'UD';
        acobj.FirstName = 'U';
        acobj.LastName = 'D';
        acobj.BIRTH_DATE__pc = date.parse('04/04/1963');
        acobj.Employee_Restricted_Access__c = 1234;
        acobj.Home_Phone__pc = '9169954478';
        insert acobj;
        
        
        Person_Account__c pc = new Person_Account__c();
        pc.Account_Number__c = ac.id;
        pc.PersonID__c = acobj.id;
        pc.RecType__c = 'LOAN';
        pc.TypeTranslate__c = '001/Joint Member';
        insert pc;
        
        Person_Account__c pc3 = new Person_Account__c();
        pc3.Account_Number__c = ac2.id;
        pc3.PersonID__c = acobj.id;
        pc3.RecType__c = 'ACCT';
        pc3.TypeTranslate__c = '002/Joint Member';
        insert pc3;
        
        //ApexPages.currentPage().getParameters().put('selectedID',acobj.id);
        ApexPages.currentPage().getParameters().put('CallersPhoneNumber',PhoneNumber);
        ApexPages.currentPage().getParameters().put('EnteredMemberNumber',ac.Name);
        ApexPages.currentPage().getParameters().put('EnteredCardNumber',EnteredCardNumber);
        ApexPages.currentPage().getParameters().put('EnteredSSN',EnteredSSN);
        ApexPages.currentPage().getParameters().put('SalesforceID',acobj.id);
        ApexPages.currentPage().getParameters().put('PINMatch','false');
        ApexPages.currentPage().getParameters().put('PhoneNumberMatch','true');
        ApexPages.currentPage().getParameters().put('MemberNumberMatch','false');
        ApexPages.currentPage().getParameters().put('SSNnumberMatch','true');
        ApexPages.currentPage().getParameters().put('CardNumberMatch','null');
        
        //Test.startTest();
        ma.EnteredMemberNumber = ac.Name;
        system.debug('--ma.EnteredMemberNumber--'+ma.EnteredMemberNumber);
        ma.PhoneNumberMatch  = 'true';
        ma.CardNumberMatch  = 'true';
        ma.MemberNumberMatch = 'true';
        ma.SSNnumberMatch = 'true';
        ma.selectedID = acobj.id;
        
        ma.DOB= '1963-04-04';
        //ma.selectedID = accounts[0].id;
        ma.NameList = new  list<Account>();
        ma.NameList.add(acobj);
        
        system.debug('--NameList test class--'+ma.NameList);
        system.debug('ma.SSNnumberConfirm test---'+ma.SSNnumberConfirm);
        
        ma.selectedID = acobj.id;          
        verifyCaller vc = new verifyCaller();
        ma.Names = vc.getAccountByName(acobj.id);
        ma.CheckIfMemberValidated();
        ma.NoIVRInformation();
        ma.verifySelectedCallerDetails();
        ma.getNameList_Options();
        ma.clearFields();
        ma.LoanDetailConfirm = true;
        ma.MemberLoanDetails.add(ac);
        ma.LoanSelectedID = '';
        //system.debug('ma.MemberLoanDetails---'+ma.MemberLoanDetails);
        ma.homePage();
        ma.LoanDetailConfirm = false;
        ma.MemberLoanDetails.add(ac);       
        ma.homePage();
        //ma.DetailsPage();
        
        //Test.StopTest();
    }
}