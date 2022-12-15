@isTest
public class SolarLoanSigCardControllerTest {
    
    @testSetup
    static void setup() {
        
        DocuSign_User_Details__c dt1 = new DocuSign_User_Details__c();
        
        dt1.TemplateId__c = 'ad01d585-ad0a-4e68-b537-7e75293f0ef8';
        dt1.Name = 'Chevron';  
        dt1.AccountId__c='2e80db6b-16cf-4202-bf90-dfa029c5949f';
        dt1.EndPoint__c='demo.docusign.net';
        dt1.IntegratorKey__c='12c7957a-484f-4fec-b6b3-461ec9b666aa';
        dt1.Password__c='!DocApi999999';
        dt1.ReplyTo__c='noreply@chevronfcu.org';
        dt1.Username__c='9c9450c4-0f40-47f7-8ee8-8292ad64f81b';
        
        insert dt1;
        
        DocuSign_User_Details__c dt2 = new DocuSign_User_Details__c();
        
        dt2.TemplateId__c = 'dc16d8f8-571c-497e-bbf5-42d8b25d4ee1';
        dt2.Name = 'Spectrum';
        dt2.AccountId__c='2e80db6b-16cf-4202-bf90-dfa029c5949f';
        dt2.EndPoint__c='demo.docusign.net';
        dt2.IntegratorKey__c='12c7957a-484f-4fec-b6b3-461ec9b666aa';
        dt2.Password__c='!DocusignApi';
        dt2.ReplyTo__c='noreply@spectrumcu.org';
        dt2.Username__c='524ecc26-873e-4590-b094-a079ad9a65a2';
        
        insert dt2;
        
        List<Solar_Loans__c> scList = TestDataFactory.getSolarLoans();
        Insert scList;
        
        ContentVersion cv = new ContentVersion();
        cv.Title = '9. Membership Application - KATIE  PIZIO - 0064M00000YGH7XQAX';
        cv.PathOnClient = '9. Membership Application - KATIE  PIZIO - 0064M00000YGH7XQAX.pdf';
        cv.VersionData = Blob.valueOf('Test Content');
        cv.IsMajorVersion = true;
        Insert cv;
        
        //Get Content Version
        List<ContentVersion> cvList = [SELECT Id, Title, ContentDocumentId FROM ContentVersion WHERE Id = :cv.Id];
        System.assertEquals(cvList.size(), 1);
        
        //Get Content Documents
        List<ContentDocument> cdList = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
        
        System.debug('cdList:'+cdList);
        System.assertEquals(cdList.size(), 1);
        
        SolarLoan_Document__c solarDoc=new SolarLoan_Document__c();
        solarDoc.Attachment_Id__c=cdList[0].Id;
        solarDoc.Solar_Loans__c=scList[0].Id;
        solarDoc.Document_Name__c='9. Membership Application - KATIE  PIZIO - 0064M00000YGH7XQAX.pdf';
        solarDoc.Document_Type__c='Signature Cards';
        solarDoc.IsMovedToOnBase__c=false;
        solarDoc.Member_Number__c='0000147163';
        
        Insert solarDoc;
    }
    
    @isTest static void testSolarloanSigCardStageNotEqual2Pt5(){    
        Solar_Loans__c solarLoan = [SELECT id,name,Name__c,Member_number__c,Current_Solar_Loan_Stage__c,
                                    Count__c,Signed__c from Solar_loans__c Order by CreatedDate DESC LIMIT 1];
        
        
        PageReference testPage = Page.SolarLoanSigCard; 
        Test.setCurrentPage(testPage);
        testPage.getParameters().put('Id', String.valueOf(solarLoan.Id));
        
        ApexPages.StandardController sc = new  ApexPages.StandardController(solarLoan);     
        SolarLoanSigCardController ext = new SolarLoanSigCardController(sc);         
        
    }
    
    @isTest static void testSolarloanSigCardStageEqual2Pt5(){    
        Solar_Loans__c solarLoan = [SELECT id,name,Name__c,Member_number__c,Current_Solar_Loan_Stage__c,
                                    Count__c,Signed__c from Solar_loans__c Order by CreatedDate DESC LIMIT 1];
        
        solarLoan.Current_Solar_Loan_Stage__c='Stage 2.5';
        update solarLoan;
        
        PageReference testPage = Page.SolarLoanSigCard; 
        Test.setCurrentPage(testPage);
        testPage.getParameters().put('Id', String.valueOf(solarLoan.Id));
        
        ApexPages.StandardController sc = new  ApexPages.StandardController(solarLoan);     
        SolarLoanSigCardController ext = new SolarLoanSigCardController(sc);         
        
    }
    
    @isTest static void testExecuteSignatureMethod(){    
        Solar_Loans__c solarLoan = [SELECT id,name,Name__c,Member_number__c,Current_Solar_Loan_Stage__c,
                                    Count__c,Signed__c from Solar_loans__c Order by CreatedDate DESC LIMIT 1];
        
        solarLoan.Current_Solar_Loan_Stage__c='Stage 2.5';
        update solarLoan;
        
        ApexPages.StandardController sc = new  ApexPages.StandardController(solarLoan);     
        SolarLoanSigCardController ext = new SolarLoanSigCardController(sc);       
        
        ext.ExecuteSignatureMethod();
    }
    
}