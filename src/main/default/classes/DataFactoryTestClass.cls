@isTest
public class DataFactoryTestClass {

    public static Account createAccount(Boolean doInsert, string firstName, string lastName, string email, string personalEmail) {
		Account acc = new Account(FirstName = firstName, LastName =lastName, Email_raw__c=email,PersonEmail = personalEmail  );
		if(doInsert) {
			insert acc;
		}
		return acc;
	}
	public static Account createAccountWithRecordType(Boolean doInsert, string firstName, string lastName, string email, string personalEmail, id recordTypeId) {
		Account acc = new Account(FirstName = firstName, LastName =lastName, Email_raw__c=email,PersonEmail = personalEmail, RecordTypeID =recordTypeId);
		if(doInsert) {
			insert acc;
		}
		return acc;
	}
	/*public static Contact createContact(Boolean doInsert) {
		Account acc = createAccount(true);
		return createContact(acc.id, true);
	}
    public static Contact createContact(Id accountId, Boolean doInsert) {
		Contact c = new Contact(firstName = 'Apex', lastName = 'Hours', accountId = accountId);
		if(doInsert) {
			insert c;
		}
		return c;
	}*/
}