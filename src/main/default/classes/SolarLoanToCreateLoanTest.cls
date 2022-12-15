@isTest
public class SolarLoanToCreateLoanTest {
    @testSetup
    static void setup() {
        SolarLoan_To_Episys_API_Details__c api = new SolarLoan_To_Episys_API_Details__c();
        api.URL__c = 'https://symxapi.chevronfcu.org/devclient';
        api.Name = 'ProductionURL';
        insert api; 
        
        ACH_To_Episys_API_Details__c apiACH = new ACH_To_Episys_API_Details__c();
		apiACH.URL__c = 'https://symxapi.chevronfcu.org/devclient';
		apiACH.Name = 'ProductionURL';
		insert apiACH;
        
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
    
    @isTest static void testCreateSolarLoans(){    
        Solar_Loans__c solarLoan = [SELECT id,name,Name__c,Member_number__c,Current_Solar_Loan_Stage__c,
                                    Count__c,Signed__c from Solar_loans__c Order by CreatedDate DESC LIMIT 1];
        
        
        set<Id> solarLoanIds=new  set<Id>();
        solarLoanIds.add(solarLoan.Id);
        SolarLoanToCreateLoan.CreateSolarLoans(solarLoanIds);
    }
    
    @isTest static void testCreateSolarLoans1(){    
        Solar_Loans__c solarLoan = [SELECT id,name,Name__c,Member_number__c,Current_Solar_Loan_Stage__c,
                                    Count__c,Signed__c from Solar_loans__c Order by CreatedDate DESC LIMIT 1];
        
        solarLoan.mem_Joint_Foreign_Gov_t_Position__c='Yes';
        solarLoan.mem_Joint_A_F_Foreign_Gov_t_Position__c='Yes';
        
        update solarLoan;
        
        set<Id> solarLoanIds=new  set<Id>();
        solarLoanIds.add(solarLoan.Id);
        SolarLoanToCreateLoan.CreateSolarLoans(solarLoanIds);
    }
    
     @isTest static void testCreateSolarLoans2(){    
        Solar_Loans__c solarLoan = [SELECT id,name,Name__c,Member_number__c,Current_Solar_Loan_Stage__c,
                                    Count__c,Signed__c from Solar_loans__c Order by CreatedDate DESC LIMIT 1];
        
        solarLoan.mem_Joint_Foreign_Gov_t_Position__c='No';
        solarLoan.mem_Joint_A_F_Foreign_Gov_t_Position__c='Yes';
        
        update solarLoan;
         
        set<Id> solarLoanIds=new  set<Id>();
        solarLoanIds.add(solarLoan.Id);
        SolarLoanToCreateLoan.CreateSolarLoans(solarLoanIds);
    }
    
    @isTest static void testCreateSolarLoans3(){    
        Solar_Loans__c solarLoan = [SELECT id,name,Name__c,Member_number__c,Current_Solar_Loan_Stage__c,
                                    Count__c,Signed__c from Solar_loans__c Order by CreatedDate DESC LIMIT 1];
        
        solarLoan.mem_Joint_Foreign_Gov_t_Position__c='Yes';
        solarLoan.mem_Joint_A_F_Foreign_Gov_t_Position__c='No';
        
        update solarLoan;
        
        set<Id> solarLoanIds=new  set<Id>();
        solarLoanIds.add(solarLoan.Id);
        SolarLoanToCreateLoan.CreateSolarLoans(solarLoanIds);
    }
    
    @isTest static void testCreateSolarLoans4(){    
        Solar_Loans__c solarLoan = [SELECT id,name,Name__c,Member_number__c,Current_Solar_Loan_Stage__c,
                                    Count__c,Signed__c from Solar_loans__c Order by CreatedDate DESC LIMIT 1];
        
        solarLoan.mem_Joint_Foreign_Gov_t_Position__c='No';
        solarLoan.mem_Joint_A_F_Foreign_Gov_t_Position__c='No';
        
        update solarLoan;
         
        
        set<Id> solarLoanIds=new  set<Id>();
        solarLoanIds.add(solarLoan.Id);
        SolarLoanToCreateLoan.CreateSolarLoans(solarLoanIds);
    }
    
     @isTest static void testgetMemberNumber(){    
        Solar_Loans__c solarLoan = [SELECT id,name,Name__c,Member_number__c,Current_Solar_Loan_Stage__c,
                                    Count__c,Signed__c from Solar_loans__c Order by CreatedDate DESC LIMIT 1];
         
        set<Id> solarLoanIds=new  set<Id>();
        solarLoanIds.add(solarLoan.Id);
        SolarLoanToCreateLoan.getMemberNumber(solarLoanIds);
    }
    
    @isTest static void testgetMemberBrand(){    
        Solar_Loans__c solarLoan = [SELECT id,name,Name__c,Member_number__c,Current_Solar_Loan_Stage__c,
                                    Count__c,Signed__c from Solar_loans__c Order by CreatedDate DESC LIMIT 1];
        
        
        set<Id> solarLoanIds=new  set<Id>();
        solarLoanIds.add(solarLoan.Id);
        SolarLoanToCreateLoan.getMemberBrand(solarLoanIds);
    }
}