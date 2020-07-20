public  class Helper {
  
  public List<Web_Settings__c> WebServiceSetting; 
  
  public Helper()
  {
    WebServiceSetting = Web_Settings__c.getall().values();
  }

public string WebServiceURL 
{
   get
  {
    return WebServiceSetting[0].WebAddress__c;
    
  }
}
public string WebServiceClientOrigin 
{
   get
  {
    return WebServiceSetting[0].Origin__c;
    
  }
}
    
public string WebServiceClientkey 
{
   get
  {
    return WebServiceSetting[0].key__c;
    
  }
} 
    
public string WebServiceClientKeyPart2 
{
   get
  {
    return WebServiceSetting[0].Key_Part_2__c;
    
  }
}
    
public string WebServiceClientKeyPart3 
{
   get
  {
    return WebServiceSetting[0].Key_Part_3__c;
    
  }
}  
    
public string WebServiceClientKeyPart4 
{
   get
  {
    return WebServiceSetting[0].Key_Part_4__c;
    
  }
} 
    
}