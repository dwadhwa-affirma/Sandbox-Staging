public  class ShowMessageForSecureEmail {
    
    public  String CaseId {get; set;} 
    public  string SecureEmail {get; set;}
    
     public ShowMessageForSecureEmail(ApexPages.StandardController controller) {
        
                CaseId = System.currentPageReference().getParameters().get('id');
               Case CaseDetail = new Case();
                CaseDetail = [Select Id,SecureEmail__c from Case where Id =: CaseId limit 1];
                
                if((CaseDetail.SecureEmail__c == null) && (String.IsEmpty(CaseDetail.SecureEmail__c)) )
                {
                   SecureEmail = 'Please add email address to member account in order to create a member message.';
                }
               


    }
    
    
}