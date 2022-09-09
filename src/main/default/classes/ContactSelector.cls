public class ContactSelector {
	
    public static List<Contact> getPersonContacts(Set<String> personIds) {
        return [SELECT Id, Name, AccountId
                FROM Contact 
                WHERE Contact.AccountId =:personIds];
    }
}