@isTest
public class CaseMemberNameChangeTest{
    
    static testMethod void myUnitTest() {
        
        Create_SLA__c cl = new Create_SLA__c();
        cl.Status__c = 'Open';
        cl.Name = 'Open';
        cl.hours__c = 8;
        insert cl;
        
        Account account_Obj = new Account(LastName = 'BANDATest', FirstName = 'MARIATest', Type = 'null', PersonHasOptedOutOfEmail = false, 
              NA_Eligibility__c = false, NA_LEAV_Complete__c = true, NA_LECF_Complete__c = true, NA_LECP_Complete__c = true, NA_LEEM_Complete__c = true, NA_LEHS_Complete__c = true, 
              NA_LEMD_Complete__c = false, NA_LEMP_Complete__c = false, NA_LEMQ_Complete__c = true, NA_LEOL_Complete__c = true, NA_LEOM_Complete__c = true, NA_LEPT_Complete__c = true, 
              NA_LESB_Complete__c = false, NA_LESF_Complete__c = true, NA_LEWS_Complete__c = true, NA_Opt_Out__c = false);
    	Insert account_Obj; 
        
        List<Account_Details__c> account_details_Obj = new List<Account_Details__c>{
                new Account_Details__c(Name = '0000147163', Balance__c = 0.00, Combined_Account_ID__c = '0000147163S0100P0100', ID1__c = '0100', 
                Onboarded__c = true, Reference__c = 'BC02',RecType__c = 'LOAN', TypeTranslate__c = '75-SECURED SOLAR')};
    
	    insert account_details_Obj;
        
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
            
        Case cs = new Case();
        cs.Brand__c = 'CFCU';
        cs.Primary_Category__c = 'Shared Branch';
        cs.Account_Number__c = account_details_Obj[0].id;
        
        insert cs;
       
        List<Person_Account__c> person_obj= new List<Person_Account__c>{
                               new Person_Account__c(Name_Type__c = 0,TypeTranslate__c='0000/Primary',Account_Number__c = account_details_Obj[0].id, PersonID__c = account_Obj.Id)};
     	insert person_obj;
        
        Test.startTest();
        
        user u = [select id from User where Alias ='smen'];
		system.runAs(u){
        	CaseMemberNameChange.GetMemberNameList(cs.id);                    
            CaseMemberNameChange.UpdateCase(cs.id,account_Obj.id);
        }
        Test.stopTest();
    }
}