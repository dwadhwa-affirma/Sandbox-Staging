global class CreateCardServiceCaseEmailHandler implements Messaging.InboundEmailHandler {

    global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.InboundEnvelope envelope) {

        Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();
        
        String subject = email.subject;       
        System.debug('Test12' + subject);     
       
       
       string bodyText;
       bodyText =email.htmlBody.stripHtmlTags();      

        System.debug('bodyText111==' + bodyText);
        
        string[] subjectLines = bodyText.split('<br>');
        system.debug('subjectLines==='+subjectLines);
        system.debug('subjectLines==='+subjectLines[0].split(':')[1]);
        
        Set<Id> accDId = new Set<Id>();
        
         if(subject.contains('ATM/Debit/Credit Card Inquiry')){
         	string cardnumber = subjectLines[0].split(':')[1].trim();
         	string membernumber = subjectLines[2].split(':')[1].trim();
         	case c  = new case();
         	c.Primary_Category__c = 'Card Services';
         	c.Secondary_Category__c ='Debit Card';
         	c.Tertiary_Category__c='Special Instructions';
         	c.Member_Number__c = membernumber;
         	
         	System.debug('cardnumber::::'+cardnumber);
         	System.debug('membernumber::::'+membernumber);
         	
         	List<Account_Details__c> accDetails = [Select Id, Name, Parent_Account__c from Account_Details__c where Name =: membernumber AND RecType__c = 'CARD' and card_number__c =: cardnumber];
         	
         	System.debug('accDetails::::'+accDetails);
         	for(Account_Details__c accD : accDetails){
           		 accDId.add(accD.Parent_Account__c);
       		 }
       		 
       		 System.debug('list of accDId::::'+accDId);
        
       		 List<Person_Account__c> pa = [Select PersonId__c, PersonId__r.FirstName, PersonId__r.LastName, PersonId__r.MiddleName, Account_Number__c,
                                             PersonId__r.Residential_Street__pc, PersonId__r.Residential_Extra_Address__pc, PersonId__r.Residential_City__pc,
                                             PersonId__r.Residential_State__pc, PersonId__r.Residential_Country__pc, PersonId__r.Residential_Zipocde__pc from Person_Account__c where Account_Number__c =:accDId AND Name_Type__c = 0];
        
        	System.debug('list of person accounts::::'+pa);
         
       	 	Set<Id> perId = new Set<Id>();
	        for(Person_Account__c p : pa){
	                perId.add(p.PersonId__c);
	           }
             if(accDetails.size()>0 || pa.size()>0 ){
                c.Account_Number__c = accDetails[0].Parent_Account__c;
             }
             
 			QueueSObject QueueID = [Select Queue.Id, Queue.Name, Queue.Type from QueueSObject WHERE Queue.Type ='Queue' AND Queue.Name =: 'EPS ATM/Debit Card Queue' Limit 1];        
          	c.OwnerId = QueueID.Queue.Id;
          	c.CaseComments__c = bodyText;
          	insert c;
          	system.debug('case id==='+c.id);
         }
       
       return result;      
    }
    
    public static string HtmlToText(string html){
	   //replace all <BR> tags with \n to support new lines
	   string result = html.replaceAll('<br/>', '\n');
	   result = result.replaceAll('<br />', '\n');
	
	   //all HTML/XML tags
	   string HtmlPattern = '<.*?>';
	
	   Matcher match =  Pattern.compile(HtmlPattern).matcher(result);
	
	   //remove the tags and return string     
	   return match.replaceAll('');
	} 
}