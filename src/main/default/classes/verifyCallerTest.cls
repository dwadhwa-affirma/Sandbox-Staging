@isTest(seealldata = false)
public class verifyCallerTest {
    static testMethod void testValidateCaller(){
    	string phoneNumber = '234-567-8909';
    	
    	Account acobj = new Account();
        //acobj.Name = 'UD';
        acobj.FirstName = 'U';
        acobj.LastName = 'D';
        acobj.BIRTH_DATE__pc = date.parse('04/04/1963');
        acobj.Employee_Restricted_Access__c = 1234;
        acobj.PersonHomePhone = phoneNumber;
        insert acobj;        
    	
    	List<Account> lstAct = new List<Account>();
    	verifyCaller objverfyCaller = new verifyCaller();
    	lstAct = objverfyCaller.ValidatePhoneNumber(phoneNumber);
    	if(lstAct != null && lstAct.size() > 0)
    	{
    		acobj = objverfyCaller.getAccountByName(lstAct[0].ID);
    		phoneNumber = '(+91)-2345678909';
    		string additionalnumber = objverfyCaller.getAdditionalPhoneNumber(phoneNumber);
    		additionalnumber = objverfyCaller.getAdditionalPhoneNumber1(phoneNumber);
    	}
    	
    	List<Account_Details__c> lstActDetails = new List<Account_Details__c>();
    	Account_Details__c ac = new Account_Details__c();
        ac.Name = '00001';
        ac.TypeTranslate__c = '1-PERSONAL';
        ac.Balance__c = 5000;
        ac.RecType__c = 'LOAN';
        insert ac;
        
    	Person_Account__c pc = new Person_Account__c();
        pc.Account_Number__c = ac.id;
        pc.PersonID__c = acobj.id;
        pc.RecType__c = 'LOAN';
        pc.TypeTranslate__c = '001/Joint Member';
        insert pc;
    	
    	lstActDetails = objverfyCaller.AccountNumbersAuth(acobj.id);
    	lstActDetails = objverfyCaller.MemberLoanDetails(acobj.id);
    	lstActDetails = objverfyCaller.MemberDetailsDOB(acobj.id);
    	
    	List<Person_Account__c> lstPersonAct = new List<Person_Account__c>();
    	lstPersonAct = objverfyCaller.MemebersNameDobDetails(lstActDetails);
    	lstActDetails = objverfyCaller.CardNumbersAuth(acobj.id);
    	
    	boolean isverifyMember = objverfyCaller.validateMemberNumber('456799765');   	
    	objverfyCaller.CardNumbersAuth(pc.id);
    	
    	
    }
    
    static testmethod void testQueryByParametersAvailable()
    {
    	Account acobj = new Account();
        //acobj.Name = 'UD';
        acobj.FirstName = 'U';
        acobj.LastName = 'D';
        acobj.BIRTH_DATE__pc = date.parse('04/04/1963');
        acobj.Employee_Restricted_Access__c = 1234;
        acobj.PersonHomePhone = '(1)-234-567-8909';
       
        insert acobj;
        
        Account_Details__c ac = new Account_Details__c();
        ac.Name = '00001';
        ac.TypeTranslate__c = '1-PERSONAL';
        ac.Balance__c = 5000;
        ac.RecType__c = 'LOAN';
        ac.Card_Number__c = '7886580';        
        insert ac;
        
        Account_Details__c ac1 = new Account_Details__c();
        ac1.Name = '00001';
        ac1.TypeTranslate__c = '1-PERSONAL';
        ac1.Balance__c = 5000;
        ac1.RecType__c = 'LOAN';
        ac1.Card_Number__c = '7886580';
        ac1.Parent_Account__c = ac.id;
        insert ac1;        
        
        Person_Account__c pc = new Person_Account__c();
        pc.Account_Number__c = ac.id;
        pc.PersonID__c = acobj.id;
        pc.RecType__c = 'LOAN';
        pc.TypeTranslate__c = '001/Joint Member';
        insert pc;
        
    	verificationObject input = new verificationObject();
    	input.phoneNumber = '(1)-234-567-8909';
    	input.memberNumber = ac.id;
    	input.SSN = '5666';
    	input.ICardNumber = '7886580';
    	input.CardNumber = '7886580';
    	input.DOB = '04/04/1963';
    	input.MMN = '5465465';
    	input.Pin = '1234';
    	input.fieldnametocheck = 'memberNumber';
    	
    	List<Account> lstAct = new List<Account>();
    	verifyCaller objverfyCaller = new verifyCaller();
    	lstAct = objverfyCaller.queryByParametersAvailable(input, false);
    	
    	input.fieldnametocheck = 'CardNumber';
    	objverfyCaller = new verifyCaller();
    	lstAct = objverfyCaller.queryByParametersAvailable(input, false);
    	
    	input.fieldnametocheck = 'phoneNumber';
    	objverfyCaller = new verifyCaller();
    	lstAct = objverfyCaller.queryByParametersAvailable(input, false);
    	
        objverfyCaller.getNamesList(input, '0');
    	
    }
}