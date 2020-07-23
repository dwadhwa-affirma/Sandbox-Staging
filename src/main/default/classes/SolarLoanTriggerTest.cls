@isTest
public class SolarLoanTriggerTest {
    
    @TestSetup
    public static void setup() {
    	 
        User u = [SELECT Id,Email,username FROM User WHERE Email ='drana@chevronfcu.org'];
		
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
     
        User u = [SELECT Id,Email FROM User WHERE Email ='drana@chevronfcu.org'];
        
        DocuSign_Templates__c ds = new DocuSign_Templates__c();
        ds.Name = 'Chevron';
        ds.TemplateId__c = 'ad01d585-ad0a-4e68-b537-7e75293f0ef8';
        insert ds;
        
        DocuSign_Templates__c ds1 = new DocuSign_Templates__c();
        ds1.Name = 'Spectrum';
        ds1.TemplateId__c = 'dc16d8f8-571c-497e-bbf5-42d8b25d4ee1';
        insert ds1;
        
        String userName = UserInfo.getUserName();
		User activeUser = [Select Email From User where Username = : userName limit 1];
		String userEmail = activeUser.Email;
        
        System.runAs(u){
            Solar_Loans__c s = [select id,Status__c,DocuSignId__c from Solar_Loans__c where Status__c = 'New'];
            s.Status__c = 'ACH Pending';    
            update s; 
        }
    }
	
    static testMethod void testMethod3(){
     
        User u = [SELECT Id,Email FROM User WHERE Email ='drana@chevronfcu.org'];
        
        System.runAs(u){
            
            Solar_Loans__c s = [select id,Status__c,DocuSignId__c from Solar_Loans__c where Status__c = 'New'];
            s.Status__c = 'Approved';
            update s;
            
            Solar_Loans__c s1 = [select id,Status__c,DocuSignId__c from Solar_Loans__c where Status__c = 'Approved'];
            s1.Status__c = 'Completed';
            update s1; 
        }
    }
}