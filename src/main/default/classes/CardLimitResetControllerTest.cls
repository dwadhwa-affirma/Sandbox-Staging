@isTest
public class CardLimitResetControllerTest {
    
     @testSetup
	static void setupTestData(){
   
     //---------------------------------------- Creating Account Details record-----------------------------------//
     
     SolarLoan_Document_Settings__c sds = new SolarLoan_Document_Settings__c();
     sds.Days__c = 10;
     sds.Name = 'Done';
     insert sds; 
      
     SolarLoan_To_Episys_API_Details__c api = new SolarLoan_To_Episys_API_Details__c();
     api.URL__c = 'https://symxapi.chevronfcu.org/devclient';
     api.Name = 'ProductionURL';
     insert api;  
   
     Account_Details__c parentacc = 
                new Account_Details__c(Name = '0000214414', Balance__c = 0.00, Combined_Account_ID__c = '0000147163S0100P0100', ID1__c = '0100', 
                Onboarded__c = true, RecType__c = 'ACCT', TypeTranslate__c = '1-PRIMARY SHARE');
     
     insert parentacc;
     List<Account_Details__c> account_details_Obj = new List<Account_Details__c>{
                new Account_Details__c(Name = '0000214414', Parent_Account__c = parentacc.id,Balance__c = 0.00, Combined_Account_ID__c = '0000147163S0100P0100', ID1__c = '0100', 
                Onboarded__c = true, Reference__c = 'BC02',RecType__c = 'LOAN', TypeTranslate__c = '75-SECURED SOLAR')};
    
     insert account_details_Obj;
      
    //---------------------------------------- Creating Member records---------------------------------------------//
    
    
     Account account_Obj = new Account(LastName = 'FRANKLIN', FirstName = 'JEFF', Type = 'null', PersonHasOptedOutOfEmail = false, 
              NA_Eligibility__c = false, NA_LEAV_Complete__c = true, NA_LECF_Complete__c = true, NA_LECP_Complete__c = true, NA_LEEM_Complete__c = true, NA_LEHS_Complete__c = true, 
              SSN_TIN_Encrypted__pc = '565138120', NA_LEMP_Complete__c = false, NA_LEMQ_Complete__c = true, NA_LEOL_Complete__c = true, NA_LEOM_Complete__c = true, NA_LEPT_Complete__c = true, 
              NA_LESB_Complete__c = false, NA_LESF_Complete__c = true, NA_LEWS_Complete__c = true, NA_Opt_Out__c = false);
     Insert account_Obj; 
    
     
     //---------------------------------------- Creating Person Account records--------------------------------------//
     
     List<Person_Account__c> person_obj= new List<Person_Account__c>{
                               new Person_Account__c(Name_Type__c = 0,TypeTranslate__c='0000/Primary',Account_Number__c = account_details_Obj[0].id, PersonID__c = account_Obj.Id)};
     insert person_obj;
           
     //---------------------------------------- Creating Solar Loan record---------------------------------------------//
     
    Test.startTest();
    List<Change_Limit__c> ChangeLimit_Obj = new List<Change_Limit__c>();
    Change_Limit__c cl1 = new Change_Limit__c();
    cl1.Auth_POS_Limit__c = 1200.00;
    cl1.ATM_Usage_Limit__c = 1100.00;
    cl1.Card_Number__c = '5460277067636965';
    cl1.Card_Locator__c = '33';
    cl1.Type__c = 'Change Card Limits';
    cl1.Member_Name__c = 'JEFF PACHECO FRANKLIN';
    cl1.Member_Account__c = account_details_Obj[0].id;
    cl1.Member__c = person_obj[0].id;
 
    Change_Limit__c cl2 = new Change_Limit__c();
    cl2.Auth_POS_Limit__c = 1200.00;
    cl2.ATM_Usage_Limit__c = 1100.00;
    cl2.Card_Number__c = '5460277067636965';
    cl2.Card_Locator__c = '33';
    cl2.Type__c = 'Reset Card Limits';
    cl2.Member_Name__c = 'JEFF PACHECO FRANKLIN';
    cl2.Member_Account__c = account_details_Obj[0].id;
    cl2.Member__c = person_obj[0].id;    
        
    ChangeLimit_Obj.add(cl1);
    ChangeLimit_Obj.add(cl2);
    
    RecordType rList = [Select id  From RecordType  Where sObjectType = 'Case'and RecordType.Name = 'Card Services'];
	CaseRecordType__c crt = new CaseRecordType__c();
    crt.Primary_Category__c = 'Card Services';
    crt.Secondary_Category__c = 'ATM/DEBIT';
    crt.Teritiary_Category__c = 'Limit Changes';
    crt.Name = 'AAA';
    crt.SLA__c = 1;
    crt.RecordTypeId__c = rList.id;
    insert crt;    
      
    test.stopTest();
      
	}
	static testMethod void testmethod1(){
    	
        Account member  =  [SELECT Id,name from Account limit 1];
        CardLimitResetController.getStageData(member.id,'test');
    }

	static testMethod void testmethod2(){
    	
        Account_Details__c memberacc  =  [SELECT Id,name from Account_Details__c limit 1];
        CardLimitResetController.getStageData(memberacc.id,'JEFF PACHECO FRANKLIN');
        CardLimitResetController.getMembers(memberacc.id);
        CardLimitResetController.getCard(memberacc.id,'JEFF PACHECO FRANKLIN');
        CardLimitResetController.Submit(memberacc.id,'5460277067636965','123','JEFF PACHECO FRANKLIN','Change Card Limits','123.00','456.00');
    }
    
    static testMethod void testmethod3(){
    	
        Account_Details__c memberacc  =  [SELECT Id,name from Account_Details__c limit 1];
        CardLimitResetController.getStageData(memberacc.id,'JEFF PACHECO FRANKLIN');
        CardLimitResetController.getMembers(memberacc.id);
        CardLimitResetController.getCard(memberacc.id,'JEFF PACHECO FRANKLIN');
        CardLimitResetController.getLimits(memberacc.id,'5460277067636965','JEFF PACHECO FRANKLIN');
    }

	static testMethod void testmethod4(){
    	
        Account member  =  [SELECT Id,name from Account limit 1];
        CardLimitResetController.getCard(member.id,'JEFF PACHECO FRANKLIN');
        CardLimitResetController.getLimits(member.id,'5460277067636965','JEFF PACHECO FRANKLIN');
        CardLimitResetController.Submit(member.id,'5460277067636965','123','JEFF PACHECO FRANKLIN','Change Card Limits','123.00','456.00');
    }
    
	static testMethod void testmethod5(){
    	
        Account member  =  [SELECT Id,name from Account limit 1];
        CardLimitResetController.getCard(member.id,'JEFF PACHECO FRANKLIN');        
        CardLimitResetController.Submit(member.id,'5460277067636965','123','JEFF PACHECO FRANKLIN','Reset Card Limits','2500.00','510.00');
    }   

}