@isTest
public class CreateCaseForNonMatchedMemBatchTest {
	
    static testmethod void test() {
    	
        RecordType objRecordType1 = [SELECT Id,Name FROM RecordType WHERE Name='Person Account'];
        
        Account account_Obj = new Account(RecordType = objRecordType1, Is_Case_Created__c = false,IsConverted__c=false,LastName = 'SPEGMAN', FirstName = 'KERI ', Type = 'null', PersonHasOptedOutOfEmail = false, 
                                          Created_By_Episys_User_Alias__c = 'IKIN', NA_Eligibility__c = false, NA_LEAV_Complete__c = true, NA_LECF_Complete__c = true, NA_LECP_Complete__c = true, NA_LEEM_Complete__c = true, NA_LEHS_Complete__c = true, 
                                          NA_LEMD_Complete__c = false, NA_LEMP_Complete__c = false, NA_LEMQ_Complete__c = true, NA_LEOL_Complete__c = true, NA_LEOM_Complete__c = true, NA_LEPT_Complete__c = true, 
                                          NA_LESB_Complete__c = false, NA_LESF_Complete__c = true, NA_LEWS_Complete__c = true, NA_Opt_Out__c = false);
        Insert account_Obj; 
        
        Datetime yesterday = Datetime.now().addDays(-5);
        Test.setCreatedDate(account_Obj.Id, yesterday); 
        
        List<Account_Details__c> account_details_Obj = new List<Account_Details__c>{
            						new Account_Details__c(Name = '0000147163', Balance__c = 0.00, Combined_Account_ID__c = '0000147163S0100P0100', ID1__c = '0100', 
                                    Onboarded__c = true, Reference__c = 'BC02',RecType__c = 'ACCT', TypeTranslate__c = '75-SECURED SOLAR')};
                                       
        insert account_details_Obj;
        
        List<Person_Account__c> person_obj= new List<Person_Account__c>{
                               new Person_Account__c(Name_Type__c = 0,TypeTranslate__c='0000/Primary',Account_Number__c = account_details_Obj[0].id, PersonID__c = account_Obj.Id)};
     	insert person_obj;
        
        MemberConversionSetting__c mcs = new MemberConversionSetting__c();
        mcs.Automation__c = 8;
        mcs.Manual__c = 10;
        mcs.Member_Matching_Cut_off_Date__c = System.today();
        mcs.Not_matched_Members_cut_off_window__c = 3;
        mcs.Unmerge__c = 10;
        mcs.Name = 'PrimaryRecord';    
        
        insert mcs;    
        
        Test.startTest();
        
        CreateCaseForNonMatchedMemberBatch c = new CreateCaseForNonMatchedMemberBatch();
		Database.executeBatch(c);
        
        Test.stopTest();
    }    
}