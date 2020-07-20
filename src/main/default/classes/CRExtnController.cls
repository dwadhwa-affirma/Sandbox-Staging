public with sharing class CRExtnController {
    public final Canned_Responses__c crObject;
    public string PrimaryLookupOptions {get;set;}
    public string SecondaryLookupOptions {get;set;}
    public string TertiaryLookupOptions {get;set;}
    private ApexPages.StandardController stdController;
    
     public CRExtnController(ApexPages.StandardController stdController) 
     {
            this.crObject = (Canned_Responses__c)stdController.getRecord();
             this.stdController = stdController;
        
            PrimaryLookupOptions = '';
            SecondaryLookupOptions = '';
            TertiaryLookupOptions = '';
            List<Canned_Responses__c> crs = [Select Primary_Lookup_Text__c  from Canned_Responses__c  limit 5000];
            List<Canned_Responses__c> crs1 = [Select  Secondary_Lookup_Text__c from Canned_Responses__c  limit 5000];
            List<Canned_Responses__c> crs2 = [Select  Tertiary_Lookup_Text__c from Canned_Responses__c limit 5000];
            
            Set<String> setstring = new Set<String>();
                    
            for(Canned_Responses__c c :crs)
            {
                setstring.add(c.Primary_Lookup_Text__c );
                
            }
            for(string s :setstring)
            {
                
                PrimaryLookupOptions += '<option value=\'' + s + '\'></option>';
                
            }
            setstring = new Set<String>();
            for(Canned_Responses__c c :crs1)
            {
                if (c.Secondary_Lookup_Text__c != '' && c.Secondary_Lookup_Text__c != null)
                {
                    setstring.add(c.Secondary_Lookup_Text__c );
                    
                }
            }
            for(string s :setstring)
            {
                
                SecondaryLookupOptions += '<option value=\'' + s + '\'></option>';
                
            }
            setstring = new Set<String>();
            for(Canned_Responses__c c :crs2)
            {
                if (c.Tertiary_Lookup_Text__c != '' && c.Tertiary_Lookup_Text__c != null)
                {
                    setstring.add(c.Tertiary_Lookup_Text__c );
                    
                }
            }
            for(string s :setstring)
            {
                
                TertiaryLookupOptions += '<option value=\'' + s + '\'></option>';
                
            }
    }
}