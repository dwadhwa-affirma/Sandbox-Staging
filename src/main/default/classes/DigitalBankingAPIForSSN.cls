@RestResource(urlMapping = '/DigitalBankingAPIForSSN/*')
global class DigitalBankingAPIForSSN{
	
    @HttpPOST
    global static Integer getMemberNumberBySSN() {
      
        RestRequest req = RestContext.request;
        system.debug('req'+req);
        
        String strSSN = req.params.get('SSN');
        system.debug('strSSN: '+strSSN);
        Integer MemberNumber;
        List<Person_Account__c> paPrimary = new List<Person_Account__c>();
            
        strSSN = '%' + strSSN;
        paPrimary = [SELECT Id, Account_Number__c,  PersonID__c, Account_Number__r.RecType__c, TypeTranslate__c, 
                                       Account_Number__r.Name,PersonID__r.PersonID__c,PersonID__r.Name
                                       FROM Person_Account__c 
                                       where PersonID__r.PersonID__c like :strSSN and TypeTranslate__c like '%Primary%'                     				   
                                       order by  Account_Number__r.Name asc LIMIT 1];
                
        
        if(paPrimary.size() == 0){
        	
            paPrimary = [SELECT Id, Account_Number__c,  PersonID__c, Account_Number__r.RecType__c, TypeTranslate__c, 
                                       Account_Number__r.Name,PersonID__r.PersonID__c,PersonID__r.Name
                                       FROM Person_Account__c 
                                       where PersonID__r.PersonID__c like :strSSN and TypeTranslate__c like '%Joint Owner%' 
                                       order by  Account_Number__r.Name asc LIMIT 1]; 
            
        }
        
        if(paPrimary.size() == 0){
        	
            paPrimary = [SELECT Id, Account_Number__c,  PersonID__c, Account_Number__r.RecType__c, TypeTranslate__c, 
                                       Account_Number__r.Name,PersonID__r.PersonID__c,PersonID__r.Name
                                       FROM Person_Account__c 
                                       where PersonID__r.PersonID__c like :strSSN and TypeTranslate__c like '%Joint Member%' 
                                       order by  Account_Number__r.Name asc LIMIT 1]; 
            
        }
        
        if(paPrimary.size() == 0){
        	
            paPrimary = [SELECT Id, Account_Number__c,  PersonID__c, Account_Number__r.RecType__c, TypeTranslate__c, 
                                       Account_Number__r.Name,PersonID__r.PersonID__c,PersonID__r.Name
                                       FROM Person_Account__c 
                                       where PersonID__r.PersonID__c like :strSSN and TypeTranslate__c like '%Trustee%' 
                                       order by  Account_Number__r.Name asc LIMIT 1]; 
            
        }
        
        if(paPrimary.size() == 0){
        	
            paPrimary = [SELECT Id, Account_Number__c,  PersonID__c, Account_Number__r.RecType__c, TypeTranslate__c, 
                                       Account_Number__r.Name,PersonID__r.PersonID__c,PersonID__r.Name
                                       FROM Person_Account__c 
                                       where PersonID__r.PersonID__c like :strSSN  
                                       order by  Account_Number__r.Name asc LIMIT 1]; 
            
        }
        
        System.debug('paPrimary: '+paPrimary);
        
        if(paPrimary.size() > 0){
            
            MemberNumber = Integer.valueOf(paPrimary[0].Account_Number__r.Name);
        }
        
        system.debug('MemberNumber: '+MemberNumber);
        
        return MemberNumber;
    }   
}