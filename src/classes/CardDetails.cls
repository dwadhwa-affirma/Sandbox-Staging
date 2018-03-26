public class CardDetails{
    
    
    
    
    
    public List<CFCU_Mastercard_Alerts__c> accList{    get {

                            List<AggregateResult> countResult =[select Count(Id) from CFCU_Mastercard_Alerts__c  where Card_Number__c =: card and Member_Number__c =: account ];
                         integer count = (Integer)  countResult [0].get('expr0');
                        
                            TotalPages  = count / PageSize  ;
                         if(TotalPages  * PageSize  < count )
                         {
                         TotalPages   = TotalPages   + 1;
                         }
                         integer offsetNumber = ((PageSize ) * (CurrentPageNumber - 1) );
                         
                            List<CFCU_Mastercard_Alerts__c>   accList1=[select OdsKey__c,transCountry__c,emailAddress__c,FirstName__c,LastName__c,merchantname__c,Card_Number__c,Name,Member_Number__c,transAmount__c, transAmtAlert__c from CFCU_Mastercard_Alerts__c where Card_Number__c =: card and Member_Number__c =: account order by CreatedDate,Card_Number__c  limit:PageSize  offset: offsetNumber];
                          
                          return accList1;    
                        }
    set;}
    
    
  
    
    public integer CurrentPageNumber {get;set;}
    
    public string card {get;set;}
    public string account {get;set;}
    

    
    public integer PageSize {get;set;}
    
        public integer TotalPages {get;set;}

     public CardDetails(ApexPages.StandardController crt)
    {
         CurrentPageNumber = 1;
         PageSize  = 20;
         card =    ApexPages.currentPage().getParameters().get('card');
         account=    ApexPages.currentPage().getParameters().get('account');

    }
    



}