public class HomeCustomLinksLightningController {
    @AuraEnabled
    public static Map<string, object> GetAllData()
    {
       list<NameLinkModel> CustomLinkslist = new list<NameLinkModel>();
       list<NameLinkModel> CFCULinkslist = new list<NameLinkModel>();
		list<NameLinkModel> ShortCutslist = new list<NameLinkModel>();
       List<Home_Page_Link__c> lstLinks = [select Id,Name,Type__c, Link__c from Home_Page_Link__c];
       if(lstLinks.size() > 0)
       {
      
       		for(Home_Page_Link__c link : lstLinks)
       		{
       			if(link.Type__c == 'CFCU')
       			{
       				CFCULinkslist.add(new NameLinkModel(link.Name,link.Link__c));
       			}
       			else if(link.Type__c == 'Custom Link')
       			{
       				CustomLinkslist.add(new NameLinkModel(link.Name,link.Link__c));
       			}
       			else
       			{
       				
       				ShortCutslist.add(new NameLinkModel(link.Name,link.Link__c));
       			}
       		}
       		
       		
       }
       
       Map<string,object> m = new Map<string,object>();
       m.put('CustomLinkslist', CustomLinkslist);
       m.put('CFCULinkslist',CFCULinkslist);
	   m.put('ShortCutslist',ShortCutslist);
       return m; 
    }
    
    public class NameLinkModel{
    	@AuraEnabled
    	public string Name{get;set;}
    	
    	@AuraEnabled
    	public string Link{get;set;}
    	
    	public NameLinkModel(string nam, string lnk)
		{
			Name = nam;
			Link = lnk;
		}
    }
  
}