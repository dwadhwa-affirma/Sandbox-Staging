@isTest()
public class VisualAlertsControllerTest{
    
	public static testmethod void SendEmailCustomerDetailPdf1(){
    	
        String uid = UserInfo.getUserId();
        RecordType recordtype =[SELECT Id,Name FROM RecordType WHERE Name='Person Account'];
        User currentUser = [SELECT LocaleSidKey, LanguageLocaleKey, TimeZoneSidKey, EmailEncodingKey FROM User WHERE Id=:uid];    
        
        Create_SLA__c cl = new Create_SLA__c();
        cl.Status__c = 'Open';
        cl.Name = 'Open';
        cl.hours__c = 8;
        insert cl;
        
        Create_SLA__c cl1 = new Create_SLA__c();
        cl1.Status__c = 'In Process';
        cl1.Name = 'In Process';
        cl1.hours__c = 20;
        insert cl1;
        
        Create_SLA__c cl2 = new Create_SLA__c();
        cl2.Status__c = 'Resolution';
        cl2.Name = 'Resolution';
        cl2.hours__c = 20;
        insert cl2;
        
        Account acc = new Account();
        acc.Owner = currentUser;
        acc.FirstName = 'tFName';
        acc.LastName='TLName';
        acc.recordtypeid = recordtype.Id;
        acc.PersonID__C ='V554870800';
        acc.PersonEmail ='acctest@test.com';
        insert acc;
        
        List<Account_Details__c> Account_Details = new List<Account_Details__c>();
        Account_Details__c ad = new Account_Details__c();
        ad.Name = '0000999999';
        Account_Details.add(ad);
        insert Account_Details;
         
        Person_Account__c pa = new Person_Account__c();
        pa.Account_Number__c = ad.id;
        pa.Name_Type__c = 0;
        pa.PersonID__c = acc.Id;
        insert pa;
        
     	Case cas = new Case();
        cas.Subject = 'Test Subject Inquires';
        cas.Description = 'Test Description Inquires';
        cas.Account_Number__c = pa.Account_Number__c;
        cas.AccountID = acc.ID;
        cas.Primary_Category__c = 'Account Maintenance';
        cas.Secondary_Category__c = 'Memberships';
        cas.Tertiary_Category__c = 'Loan in Progress - New Membership';
        cas.Brand__c = 'CFCU';
        cas.Status ='Open';
        cas.LTK__c = '1111';
        
        insert cas;
        
        PageReference pageRef = Page.VisualAlerts;
        Test.setCurrentPage(pageRef);

     	pageRef.getParameters().put('Id', String.valueOf(cas.Id));
     	ApexPages.StandardController sc = new ApexPages.StandardController(cas);
     	VisualAlertsController vac = new VisualAlertsController(sc);
		vac.getCaseComment();
        vac.removeCaseComment();
        vac.getAttach();
        vac.RemoveAttach();
        vac.getMemberComment();
        vac.removeMemberComment();
    }
}