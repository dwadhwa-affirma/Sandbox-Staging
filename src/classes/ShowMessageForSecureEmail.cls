public  class ShowMessageForSecureEmail {
    
    public  String CaseId {get; set;} 
    public  string SecureEmail {get; set;}
    
     public ShowMessageForSecureEmail(ApexPages.StandardController controller) {
        
                CaseId = System.currentPageReference().getParameters().get('id');
               Case CaseDetail = new Case();
                CaseDetail = [Select Id,Secure_Email__c from Case where Id =: CaseId limit 1];
                
                if((CaseDetail.Secure_Email__c == null) && (String.IsEmpty(CaseDetail.Secure_Email__c)) )
                {
                   SecureEmail = 'Please add email address to member account in order to create a member message.';
                }
               


    }
    
    
}