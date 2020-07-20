public with sharing class PersonLookUpController {

	public String accID{get; set;}
	public Account_Details__c accountDetail{get; set;}
	public List<Person_Account__c> personAccountList{get; set;}
	public List<Account> personList{get; set;}
	public Set<String> personIdSet{get; set;}
	public Map<String,String> personIdTypeTranslateMap;
	public List<selectOption> personNames{get; set;}
	public String selectedPerson{get; set;}
	public String cfcuImageURL{get; set;}
	public String spectrumImageURL{get; set;}

    public PersonLookUpController(ApexPages.StandardController controller) {

    	try {
	    	accountDetail = new Account_Details__c();
	    	personAccountList = new List<Person_Account__c>();
	    	personList = new List<Account>();
	    	personIdSet = new Set<String>();
	    	personNames = new List<selectOption>();
	    	personIdTypeTranslateMap = new Map<String,String>();
	    	
	    	cfcuImageURL = '/servlet/servlet.FileDownload?file=';
	    	spectrumImageURL = '/servlet/servlet.FileDownload?file=';

	    	List<Document> documentList=[SELECT Name from Document WHERE Name = 'CFCU Logo' OR Name = 'Spectrum Logo'];
	    	if(documentList.size()>0)
	    	for (Document doc : documentList) {
	    		if (doc.Name == 'CFCU Logo') {
	    			cfcuImageURL = cfcuImageURL+doc.Id;
	    		} else if (doc.Name == 'Spectrum Logo') {
	    			spectrumImageURL = spectrumImageURL+doc.Id;
	    		}
	    	}

	    	accId = ApexPages.currentPage().getParameters().get('Id');
	    	accountDetail = [SELECT Id, Name, Reference__c, (SELECT Id, PersonID__c, TypeTranslate__c FROM Person_Account__r) FROM Account_Details__c WHERE Id = :accId LIMIT 1];
			personAccountList = accountDetail.Person_Account__r;
			for (Person_Account__c pa : personAccountList) {
				personIdSet.add(pa.PersonID__c);
				personIdTypeTranslateMap.put(pa.PersonID__c, pa.TypeTranslate__c);
			}

			personList = [SELECT Id, Name FROM Account WHERE Id IN :personIdSet];
			personNames.add(new selectOption('None', 'None'));
			for (Account p : personList) {
				System.debug('Person Name :'+p.Name);
				personNames.add(new selectOption(p.Id, p.Name+' - '+personIdTypeTranslateMap.get(p.Id)));
			}
		} catch (Exception e) {
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Sorry!! No ID was selected for this page'));
			System.debug('Error encountered in the constructor for PersonLookUpController '+e);
		}

    }

    public PageReference goToCase(){
    	
    	PageReference p = null;
    	String redirectUrl = null;

    	if (accountDetail != null) {
    		String brandText = '';
    		if (accountDetail.Reference__c != null && accountDetail.Reference__c == 'BC01'){ 
    		brandText = 'CFCU'; 
    		} else if (accountDetail.Reference__c != null && accountDetail.Reference__c == 'BC02') { 
    		brandText = 'Spectrum'; 
    		} 
    		redirectUrl = '/setup/ui/recordtypeselect.jsp?ent=Case&retURL='+accountDetail.Id+'&save_new_url=%2F500%2Fe%3FretURL%3D%252F500%252Fo&00N11000001DG0q='+brandText+'&CF00N11000001E9Gt_lkid='+accountDetail.Id+'&CF00N11000001E9Gt='+accountDetail.Name;
    	}
    	System.debug('The Selected Person ID is :'+selectedPerson);
    	if (selectedPerson != null && selectedPerson != 'None') {
    		Account per = [SELECT Id, Name, FirstName, LastName, Residential_Street__pc, Residential_City__pc, Residential_State__pc, Residential_Zipocde__pc, Residential_Country__pc, PersonHomePhone, PersonEmail FROM Account WHERE Id = :selectedPerson];
    		String streetAddress = '';
    		String firstName = '';
    		String lastName = '';
    		String city = '';
    		String state = '';
    		String zipCode = '';
    		String country = '';
    		String email = '';
    		String phone = '';

    		if (per.Residential_Street__pc != null) {
    			streetAddress = per.Residential_Street__pc;
    		}
    		if (per.FirstName != null) {
    			firstName = per.FirstName;
    		}
    		if (per.LastName != null) {
    			lastName = per.LastName;
    		}
    		if (per.Residential_City__pc != null) {
    			city = per.Residential_City__pc;
    		}
    		if (per.Residential_State__pc != null) {
    			state = per.Residential_State__pc;
    		}
    		if (per.Residential_Zipocde__pc != null) {
    			zipCode = per.Residential_Zipocde__pc;
    		}
    		if (per.Residential_Country__pc != null) {
    			country = per.Residential_Country__pc;
    		}
    		if (per.PersonEmail != null) {
    			email = per.PersonEmail;
    		}
    		if (per.PersonHomePhone != null) {
    			phone = per.PersonHomePhone;
    		}
    		redirectUrl+='&cas4='+per.Name+'&cas4_lkid='+per.Id+'&00N11000001CgXo='+streetAddress+'&00N11000001CgXZ='+firstName+'&00N11000001CgXe='+lastName+'&00N11000001CgY3='+city+'&00N11000001CgY8='+state+'&00N11000001CgYI='+zipCode+'&00N11000001CgYD='+country+'&00N11000001CvVx='+email+'&00N11000001CvW2='+phone; // adding prefill data in a url. ;
    	}

    	if (redirectUrl != null) {
    		p = new PageReference(redirectUrl);
    	}
    	return p;
    }

}