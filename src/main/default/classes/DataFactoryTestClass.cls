@isTest
public class DataFactoryTestClass {

    public static Account createAccount(Boolean doInsert, string firstName, string lastName, string email, string personalEmail) {
		Account acc = new Account(FirstName = firstName, LastName =lastName, Email_raw__c=email,PersonEmail = personalEmail  );
		if(doInsert) {
			insert acc;
		}
		return acc;
	}
	public static Account createAccountWithRecordType(Boolean doInsert, string name, string email, id recordTypeId) {
		Account acc = new Account(Name = name, Email_raw__c=email, RecordTypeID =recordTypeId);
		if(doInsert) {
			insert acc;
		}
		return acc;
	}
    public static Lead createLead(string fName, string lName, string status) {
		Group   listQueue = [select id,Name,Email from Group where Type = 'Queue' and (Email like '%lead.com') limit 1];
        Lead ld = new Lead (LastName = lName ,Product_Type__c = 'Card', Sub_Status__c = 'No Response',Brand__c = 'CFCU',FirstName = fName ,MiddleName = 'New', Description = 'New',Product_Amount__c =3.00,
        Salutation = 'MR.',Suffix = 'MR',Status = status ,Phone= '1234567890',Email='test@test.com',MobilePhone='1234567892',How_did_you_hear_about_us__c='Website',
        LeadSource='BDO-Realtor Referral' , Ownership__c='Queue', OwnerId = listQueue.Id, Street_Address_1__c='Address 1',State__c= 'NY',Zip_Code__c= '12345',City__c='NYC',Country__c ='USA');
        insert ld;
		return ld;
	}
    public static Opportunity createOpportunitywithMemberAccount(string Stagename) {
		Account_Details__c accDetail = new Account_Details__c();
        accDetail.Name = 'test';
        accDetail.SecureEmailAddress__c = 'sample@sample.com';
        accDetail.Created_By_User__c = 1;
        insert accDetail;
        
        String RecTypeId= [select Id from RecordType where (Name='Person Account') and (SobjectType='Account')].Id;
        
        Account acc = new Account(
        RecordTypeID=RecTypeId,
        FirstName='Test FName',
        LastName='Test LName',
        PersonMailingStreet='test@yahoo.com',
        PersonMailingPostalCode='12345',
        PersonMailingCity='SFO',
        PersonEmail='test@yahoo.com',
        PersonHomePhone='1234567',
        PersonMobilePhone='12345678');
        
        insert acc;
        
        Person_Account__c pa = new Person_Account__c();
        pa.PersonID__c = acc.Id;
        pa.Name_Type__c = 0;
        pa.Account_Number__c = accDetail.Id;
        insert pa;
        Opportunity opp;
        if(Stagename != 'Outreach'){
             opp = new Opportunity(Name = 'Name', member_account__c = accDetail.id,  StageName = Stagename ,  Product_Amount__c =2.00, Product_Type__c = 'Misc',CloseDate = system.today(), Opportunity_Source__c = 'Branch Call', AccountId =acc.id);
        }
        else{
            	 opp = new Opportunity(Name = 'Name', member_account__c = accDetail.id,  StageName = Stagename , Sub_Status__c ='1st attempt', Product_Amount__c =2.00, Product_Type__c = 'Misc',CloseDate = system.today(), Opportunity_Source__c = 'Branch Call', AccountId =acc.id);
            }
			insert opp;
		
		return opp;
	}
   
    public static Opportunity createOpportunitywithSLA(string Stagename) {
		Account_Details__c accDetail = new Account_Details__c();
        accDetail.Name = 'test';
        accDetail.SecureEmailAddress__c = 'sample@sample.com';
        accDetail.Created_By_User__c = 1;
        insert accDetail;
        
        String RecTypeId= [select Id from RecordType where (Name='Person Account') and (SobjectType='Account')].Id;
        
        Account acc = new Account(
        RecordTypeID=RecTypeId,
        FirstName='Test FName',
        LastName='Test LName',
        PersonMailingStreet='test@yahoo.com',
        PersonMailingPostalCode='12345',
        PersonMailingCity='SFO',
        PersonEmail='test@yahoo.com',
        PersonHomePhone='1234567',
        PersonMobilePhone='12345678');
        
        insert acc;
        
        Person_Account__c pa = new Person_Account__c();
        pa.PersonID__c = acc.Id;
        pa.Name_Type__c = 0;
        pa.Account_Number__c = accDetail.Id;
        insert pa;
        Opportunity opp;
        if(Stagename != 'Outreach'){
             opp = new Opportunity(Name = 'Name', Hour_Spent_New_Status__c = 1.00 , Hour_Spent_Outreach_Status__c = 1.00, Hour_Spent_Considering_Status__c = 1.00, Hour_Spent_Analyzing_Needs_Status__c = 1.00, Hour_Spent_Fulfillment_Status__c = 1.00, member_account__c = accDetail.id,  StageName = Stagename ,  Product_Amount__c =2.00, Product_Type__c = 'Misc',CloseDate = system.today(), Opportunity_Source__c = 'Branch Call', AccountId =acc.id);
        }
        else{
            	 opp = new Opportunity(Name = 'Name',Hour_Spent_New_Status__c = 1.00 , Hour_Spent_Outreach_Status__c = 1.00, Hour_Spent_Considering_Status__c = 1.00, Hour_Spent_Analyzing_Needs_Status__c = 1.00, Hour_Spent_Fulfillment_Status__c = 1.00, member_account__c = accDetail.id,  StageName = Stagename , Sub_Status__c ='1st attempt', Product_Amount__c =2.00, Product_Type__c = 'Misc',CloseDate = system.today(), Opportunity_Source__c = 'Branch Call', AccountId =acc.id);
            }
			insert opp;
		
		return opp;
	}
}