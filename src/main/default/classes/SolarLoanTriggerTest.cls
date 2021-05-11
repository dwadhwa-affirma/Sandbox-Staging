@isTest
public class SolarLoanTriggerTest {
    
    @TestSetup
    public static void setup() {
    	 
        User u = [SELECT Id,Email,username FROM User WHERE IsActive = true and Profile.Name = 'CFCU Admin' limit 1];
		
        SolarLoan_To_Episys_API_Details__c api = new SolarLoan_To_Episys_API_Details__c();
        api.Name = 'ProductionURL';
        api.URL__c = 'https://symxapi.chevronfcu.org/devclient';
        insert api;
        
        Solar_Loan_Product_Types__c slpt = new Solar_Loan_Product_Types__c();
        slpt.Name = 'Solar';
        slpt.Description__c = 'SECURED SOLAR';
        insert slpt;
        
        DocuSign_User_Details__c DTChevron = new DocuSign_User_Details__c();
        DTChevron.TemplateId__c = 'dc16d8f8-57ec-497e-bbf5-42d8b25d4ee1';
        DTChevron.ReplyTo__c = 'noreply@chevron.org';
        DTChevron.AccountId__c = '2e80de6b-16cf-4202-bf90-dfa029c5949f';
        DTChevron.Username__c = '524ecc2e-873e-4590-b094-a079ad9a65a2';
        DTChevron.Password__c = '!DocusignApi';
        DTChevron.IntegratorKey__c = 	'12u7957a-484f-4fec-b6b3-461ec9b666aa';
        DTChevron.EndPoint__c = 'demo.docusign.net';
        DTChevron.Name = 'Chevron';
        
        insert DTChevron;
        
        DocuSign_User_Details__c DTSpectrum = new DocuSign_User_Details__c();
        DTSpectrum.TemplateId__c = 'dc16d8f8-571c-497e-bbf5-42d8b25d4ee1';
        DTSpectrum.ReplyTo__c = 'noreply@spectrum.org';
        DTSpectrum.AccountId__c = '2e80db6b-16cf-4202-bf90-dfa029c5949f';
        DTSpectrum.Username__c = '524ecc26-873e-4590-b094-a079ad9a65a2';
        DTSpectrum.Password__c = '!DocusignApi';
        DTSpectrum.IntegratorKey__c = 	'12c7957a-484f-4fec-b6b3-461ec9b666aa';
        DTSpectrum.EndPoint__c = 'demo.docusign.net';
        DTSpectrum.Name = 'Spectrum';
        
        insert DTSpectrum;
        
        Account ac = new Account();
        ac.FirstName = 'Jeff';
        ac.LastName = 'Franklin';
        insert ac;
        
        Account_Details__c ad = new Account_Details__c();
        ad.Name = '0000269355';
        ad.Reference__c = 'BC01';
        insert ad;
        
        Account_Details__c ad1 = new Account_Details__c();
        ad1.Name = '0000247286';
        ad1.Reference__c = 'BC01';
        insert ad1;
        
        Person_Account__c pa = new Person_Account__c();
        pa.account_number__c = ad.id;
        pa.PersonID__c = ac.id;
        pa.Name_Type__c = 0;
        insert pa;
        
        Person_Account__c pa1 = new Person_Account__c();
        pa1.account_number__c = ad1.id;
        pa1.PersonID__c = ac.id;
        pa.Name_Type__c = 0;
        insert pa1;
        
        SolarLoan_Docusign_Emails__c sde = new SolarLoan_Docusign_Emails__c();
        sde.Name = 'Email For Testing';
        sde.Emails__c = 'drana@chevronfcu.org';
        insert sde;
        
		System.runAs(u){        
            Solar_Loans__c sl = new Solar_Loans__c();
            sl.Joint_First_Name__c ='Tom';
            sl.Joint_Last_Name__c = 'Jerry';
            sl.Joint_DOB__c = System.today();
            sl.Joint_SSN__c =  '1715';
            sl.Joint_FICO_Score__c = 12.00;
            sl.Joint_City__c = 'city';
            sl.Joint_State__c = 'PA';
            sl.Joint_Zip_Code__c =  '12345';
            sl.Primary_First_Name__c ='Tom';
            sl.Primary_Last_Name__c = 'Jerry';
            sl.Primary_DOB__c = System.today();
            sl.Primary_SSN__c =  '1715';
            sl.Primary_Address_1__c = 'Add';
            sl.Primary_FICO_Score__c = 12.00;
            sl.Primary_City__c = 'city';
            sl.Primary_State__c = 'PA';
            sl.Primary_Zip_Code__c =  '12345';
            sl.Legal_Description__c = 'test';
            sl.Product__c = 'product';
            sl.Module__c = 'module';
            sl.Installer_Number__c = '12';
            sl.Inverter__c = 'inverter';
            sl.System_Size_kW__c = 12.00;
            sl.Battery__c = 'barary';
            sl.Installer__c = 'intealer';
            sl.Application_Date__c = system.today();
            sl.Mortgage_Balance__c = 1299.00;
            sl.Final_Payment_Amount__c = 111.00;
            sl.Go_To_Payment__c = 1252.00;
            sl.Membership_Fee__c = 126.00;
            sl.Net_Funding_Amount__c = 1213.00;
            sl.Loan_Amount__c = 1211.00;
            sl.Loan_Pmt_Amount__c = 1245.00;
            sl.Credit_Exception__c = 'cr';
            sl.ITC_Rate__c = 2.00;
            sl.ITC_Amount__c = 1245.88;
            sl.Term_months__c = 12;
            sl.OID_Fee__c = 11;
            sl.Approval_Date__c = system.today();
            sl.ECOA_Code__c = '1';
            sl.Site_UUID__c = '11';
            sl.FNI__c = '12';
            sl.Member_Number__c = '0000269355';
            sl.Status__c = 'New';
            sl.Bank_Name__c = 'Test Bank';
            sl.ABA_Bank_Name__c = 'Test Bank';
            sl.Additional_Amount__c = 100.00;
            sl.ACH__c = 'True';
            insert sl;
        	
            sl.Member_Number__c = '0000247286';
            update sl;
            
            System.debug('Current User: ' + UserInfo.getUserName());

            System.debug('ttt');
            System.debug('ttt1' + u);
            
            Account a = new Account();
            a.FirstName = 'Tom';
            a.LastName =   'Jerry';
            a.PersonEmail = 'jrakesh@affirma.com';
            insert a;
        }
    }
    static testMethod void testMethod1(){
     
        User u = [SELECT Id,Email,username FROM User WHERE IsActive = true and Profile.Name = 'CFCU Admin' limit 1];
                
        String userName = UserInfo.getUserName();
		User activeUser = [Select Email From User where Username = : userName limit 1];
		String userEmail = activeUser.Email;
        
        System.runAs(u){
            Solar_Loans__c s = [select id,Status__c,DocuSignId__c from Solar_Loans__c where Status__c = 'New'];
            s.Status__c = 'ACH Pending';    
            update s; 
        }
    }
    
    static testMethod void testMethod10(){
        

        	Solar_Loans__c s = [select id,Status__c,DocuSignId__c from Solar_Loans__c where Status__c = 'New' ];
			s.Status__c = 'Declined';            
            update s;
       
        
    }
    static testMethod void testMethod11(){
    
            Solar_Loans__c s = [select id,Status__c,DocuSignId__c from Solar_Loans__c where Status__c = 'New' ];
			s.Status__c = 'Expired';            
            update s; 
    }
    
    static testMethod void testMethod12(){
        Test.startTest();
        List<Solar_Loans__c> MemberTest = new list<Solar_Loans__c>();
        
        Solar_Loans__c s = new Solar_Loans__c();
        s.Member_Number__c = '123456';
        s.Site_UUID__c = '344';
        
        
        MemberTest.add(s);
        
        if(MemberTest.size()>0){
            insert MemberTest;
        }
        
        s.Member_Number__c = '123456';
        update MemberTest;
        Test.stopTest();
    }
    
    static testMethod void testMethod13(){
        	Solar_Loans__c s1 = [select id,Status__c,DocuSignId__c,EftLocator__c from Solar_Loans__c where Status__c = 'New' ];
			s1.Status__c = 'Completed';
        	s1.EftLocator__c = null;
            update s1;
    } 
    static testMethod void testMethod14(){
        
        Solar_Loans__c s = [select Id,DocuSignId__c,Member_Number__c,Member_Name__c from Solar_Loans__c];
        s.Member_Number__c = '123456';
        s.Member_Name__c = null;
        update s;
      
    } 
    static testMethod void testMethod15(){
        Solar_Loans__c s = [select Id,DocuSignId__c,Status__c,Routing_Number__c from Solar_Loans__c where Status__c = 'New' and Routing_Number__c = null ];
        s.Status__c = 'Completed';
        s.Routing_Number__c = '1234566';
        update s;

    }
    /* static testMethod void testMethod16(){
        Solar_Loans__c s = [select Id,DocuSignId__c,SignatureCardURL__c from Solar_Loans__c where SignatureCardURL__c = null ];
        s.SignatureCardURL__c = 'hkdsfsdfjsdhfkjsd';
        update s;

    } */
    
    static testMethod void testMethod3(){
     
        User u = [SELECT Id,Email,username FROM User WHERE IsActive = true and Profile.Name = 'CFCU Admin' limit 1];
        
        System.runAs(u){
            
            Solar_Loans__c s = [select id,Status__c,DocuSignId__c from Solar_Loans__c where Status__c = 'New'];
            s.Status__c = 'Approved';
            update s;
            
            Solar_Loans__c s1 = [select id,Status__c,DocuSignId__c from Solar_Loans__c where Status__c = 'Approved'];
            s1.Status__c = 'Completed';
            update s1;
        }
    }
    
    static testMethod void testMethod4(){
     
        User u = [SELECT Id,Email,username FROM User WHERE IsActive = true and Profile.Name = 'CFCU Admin' limit 1];
        
        System.runAs(u){
            
            Solar_Loans__c s = [select id,Status__c,EftLocator__c,DocuSignId__c from Solar_Loans__c where Status__c = 'New'];
            s.Status__c = 'Approved';
            s.EftLocator__c = '123';
            s.Bank_Name__c = 'Test Bank';
            s.Additional_Amount__c = 100.00;
            update s;
            
            Solar_Loans__c s1 = [select id,Status__c,DocuSignId__c from Solar_Loans__c where Status__c = 'Approved'];
            s1.Status__c = 'Completed';
            update s1;
        }
    }
}