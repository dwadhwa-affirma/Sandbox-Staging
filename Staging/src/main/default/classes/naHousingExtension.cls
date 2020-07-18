public class naHousingExtension {
    
     NA_Housing__c nhs5;
    Needs_Assesment__c nas = new Needs_Assesment__c();
    
    public string firstPage {get;set;}
     public string accId {get;set;}
    NA_Housing__c nah = new NA_Housing__c();
     public  list<NA_Housing__c> nahouse = new list<NA_Housing__c>(); 
   
     public naHousingExtension(ApexPages.StandardController crt){
        nhs5 = (NA_Housing__c)crt.getRecord();
         
        firstPage = System.currentPageReference().getParameters().get('firstPage'); 
        if(firstPage == 'True'){
            accId = System.currentPageReference().getParameters().get('acctId');
        }
          accId = System.currentPageReference().getParameters().get('acctId');
           System.debug('accId is::::'+accId); 
         
         System.debug('current page is::::'+firstPage); 
    }
    
    
    
    public NA_Housing__c getnah(){
         NA_Housing__c nhs1 = new NA_Housing__c();
        firstPage = System.currentPageReference().getParameters().get('firstPage'); 
        if(firstPage == 'True'){
            accId = System.currentPageReference().getParameters().get('acctId');
        }
           
        list<Needs_Assesment__c> naList = new list<Needs_Assesment__c>();
        naList = [select id, member__c from Needs_Assesment__c where member__r.id=:'0017A00000Nxdfk'];
       
         System.debug('accid  check:::'+accId);
        
        set<String> naIdSet = new set<String>();
        
        if(naList.size()>0){
        
         for(Needs_Assesment__c var: naList){
           naIdSet.add(var.id);
        }
        
         nahouse = [select id, Current_Balance__c, Current_Rate__c, End_Date__c, Current_Lender__c, NA__c,  LastModifiedDate from NA_Housing__c where NA__r.id =:naIdSet ORDER by LastModifiedDate desc];
        
            
        nah.NA__c = nahouse[0].Id;
        nah.Current_Balance__c = nahouse[0].Current_Balance__c;
        nah = nahouse[0];
        }
        return nah;   
         
    }
}