@isTest
public class MaritzCXSurveyResponseTriggerHandlerTest {
	
    static testMethod void testMaritzCXSurveyResponseAfterInsert() {
        
        Group grp=new Group();
        grp.Name='Lending Survey Queue';
        insert grp;
        
        RecordType recType = [Select Id From RecordType  Where SobjectType = 'Case' and Name = 'Survey Cases'];
        
        CaseRecordType__c caseRecType=new CaseRecordType__c();
        caseRecType.Name='657';
        caseRecType.Primary_Category__c='Surveys';
        caseRecType.Secondary_Category__c='Digital Banking - Survey';
        caseRecType.Teritiary_Category__c='Follow-Up';
        caseRecType.SLA__c=40;
        caseRecType.RecordTypeId__c=recType.Id;
        Insert caseRecType;
        
        List<Account_Details__c> lstAccDetails = TestDataFactory.getAccountDetailsData();
        Insert lstAccDetails;
        
        List<Account> lstAcc= TestDataFactory.getAccountsData();
        Insert lstAcc;
        
        List<Person_Account__c> lstPersons= new List<Person_Account__c>{
            new Person_Account__c(TypeTranslate__c='0000/Primary',Name_Type__c=0,Account_Number__c = lstAccDetails[0].id, PersonID__c = lstAcc[0].Id), 
            new Person_Account__c(TypeTranslate__c='0000/Primary',Account_Number__c = lstAccDetails[0].Id, PersonID__c = lstAcc[0].Id), 
            new Person_Account__c(Account_Number__c = lstAccDetails[2].Id, PersonID__c = lstAcc[0].Id)};
                
        Insert lstPersons;
        
        List<Person_Account__c> lstPersons1= 
		new List<Person_Account__c>{new Person_Account__c(TypeTranslate__c='0000/Primary',Account_Number__c = lstAccDetails[1].Id, PersonID__c = lstAcc[0].Id), 
		new Person_Account__c(TypeTranslate__c='0000/Primary',Account_Number__c = lstAccDetails[2].Id, PersonID__c = lstAcc[1].Id)};
            
		Insert lstPersons1; 
        
        Contact contact1=new Contact();
        contact1.LastName='BANDATest';
        contact1.Email='test@test.com';
        contact1.PersonID__c='V555628874';
        insert contact1;
        
        Survey_Case_Codes__c  surveyCaseCode=new Survey_Case_Codes__c();
        surveyCaseCode.Name='90';
        surveyCaseCode.Branch_Dept__c='RE Lending';
        surveyCaseCode.Primary_Category__c='Surveys';
        surveyCaseCode.Secondary_Category__c='RE Lending';
        surveyCaseCode.Tertiary_Category__c='Other';
        surveyCaseCode.Queue__c='RE Lending Survey Queue';
        
        Insert surveyCaseCode;
        
        MaritzCX__Survey__c maritzSurvey= new MaritzCX__Survey__c();
        maritzSurvey.MaritzCX__ALG_Survey_Id__c=18;
        maritzSurvey.Name='Lending Survey';
        maritzSurvey.MaritzCX__Allegiance_Survey_Response_View_Link__c=true;
        maritzSurvey.MaritzCX__Is_Default_Survey__c=false;
        maritzSurvey.MaritzCX__MCX_Company_Id__c=1082836647;
        
        Insert maritzSurvey;
        
        System.debug('maritzSurvey:'+maritzSurvey.Id);
        MaritzCX__Survey_Response__c objRes=new MaritzCX__Survey_Response__c(); 
 
        objRes.MaritzCX__Account__c=lstAcc[0].Id;
        objRes.MaritzCX__ALG_Response_Id__c=58090; //Unique thus increment by one on every insert
        objRes.MaritzCX__ALG_Survey_Id__c=18;
        objRes.MaritzCX__Key_Metric_5__c=2;
        objRes.MaritzCX__Key_Metric_6__c=4;
        objRes.MaritzCX__Key_Metric_7__c=5;
        objRes.MaritzCX__Metric_1__c=lstAccDetails[0].Name;
        objRes.MaritzCX__Metric_2__c='18';
        objRes.MaritzCX__respondent_email__c= 'test@test.com';
        objRes.MaritzCX__Respondent_State__c='Completed';
        objRes.MaritzCX__Survey_Id__c=maritzSurvey.Id;
        
        Insert objRes;
       
        MaritzCX__Survey__c maritzSurvey1= new MaritzCX__Survey__c();
        maritzSurvey1.MaritzCX__ALG_Survey_Id__c=90;
        maritzSurvey1.Name='Lending Survey';
        maritzSurvey1.MaritzCX__Allegiance_Survey_Response_View_Link__c=true;
        maritzSurvey1.MaritzCX__Is_Default_Survey__c=false;
        maritzSurvey1.MaritzCX__MCX_Company_Id__c=1082836647;
        
        Insert maritzSurvey1;
        
        MaritzCX__Survey_Response__c objRes1=new MaritzCX__Survey_Response__c(); 
 
        objRes1.MaritzCX__Account__c=lstAcc[0].Id;
        objRes1.MaritzCX__ALG_Response_Id__c=58090; 
        objRes1.MaritzCX__ALG_Survey_Id__c=18;
        objRes1.MaritzCX__Key_Metric_5__c=2;
        objRes1.MaritzCX__Key_Metric_6__c=4;
        objRes1.MaritzCX__Key_Metric_7__c=5;
        objRes1.MaritzCX__Metric_1__c=lstAccDetails[0].Name;
        objRes1.MaritzCX__Metric_2__c='90';
        objRes1.MaritzCX__respondent_email__c= 'V555628874';
        objRes1.MaritzCX__Respondent_State__c='Completed';
        objRes1.MaritzCX__Survey_Id__c=maritzSurvey1.Id;
        
        List<MaritzCX__Survey_Response__c> newSurveys=new List<MaritzCX__Survey_Response__c>();
        newSurveys.add(objRes1);
        
        MaritzCXSurveyResponseTriggerHandler objTriggerHandler=new MaritzCXSurveyResponseTriggerHandler();
		//objTriggerHandler.afterInsert(newSurveys);
    }
}