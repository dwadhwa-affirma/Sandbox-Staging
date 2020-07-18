public class DocumentsLightningController {
    @AuraEnabled
    public static Map<string, object> GetAllData(string accid)
    {
    	Integer PageNo = 1,  PageSize = 5;
    	Map<string, object> m = new Map<string, object>();
    	Account_Details__c act = [select Name from Account_Details__c where Id =: accid Limit 1];
    	string endPointURL = 'https://sfrtsqa.chevronfcu.org/api/documents/'+act.Name;		    	
		string authHeader = buildAuthHeader(act.Name);
		list<onBaseRecords> obrListResult = new list<onBaseRecords>();
		obrListResult = callOutMethod(endPointURL, authHeader);
		m.put('obrListResult',obrListResult);
		m.put('obrListtotalrecords',obrListResult.size());
    	return m;
    }
    
     @AuraEnabled
    public static string GetAccountNumber(string accid) 
    {
    	
    	Account_Details__c act = [select Name from Account_Details__c where Id =: accid Limit 1];
    	string name = act.Name;		    	
    	return name;
    }
    
    public static string buildAuthHeader(string accNumber){
    	system.debug('accNumber --- ' + accNumber);
    	Helper hObj = new Helper();
    	Blob private_Key;
	    string key = hObj.WebServiceClientkey;
	    string KeyPart2 = hObj.WebServiceClientKeyPart2;
	    string KeyPart3 = hObj.WebServiceClientKeyPart3;
	    string KeyPart4 = hObj.WebServiceClientKeyPart4;
	    string strPrivate_Key= key+KeyPart2+KeyPart3+KeyPart4;
	    string Origin = hObj.WebServiceClientOrigin;
        String url = '/api/documents/'+accNumber;
        string s_RequestDateTime = DateTime.Now().formatGmt('MMM d yyyy HH:mm:ss') + ' GMT';
        String SigningString =  'GET' + ' ' + url + ' HTTP/1.1' 
                                + '\n' 
                                + 'date= ' + s_RequestDateTime
                                + '\n' 
                                + 'origin:' + Origin
                                + '\n'; 
        private_Key = EncodingUtil.base64Decode(strPrivate_Key);
        
        Blob signingdata = Blob.valueOf(SigningString);
        Blob MAC = Crypto.sign('RSA-SHA256', signingdata, private_Key);
        String Signature = EncodingUtil.base64Encode(MAC); 
        
        string authHeader = 'Origin='+Origin+',algorithm=rsa-sha256, headers='; 
        authHeader +=  url + ' ' +  'GET' + ' HTTP/1.1 ' + 'date=' + s_RequestDateTime +  ', signature ' + Signature;       
           system.debug('authHeader - ' + authHeader);     
        return authHeader;
    }
    
    public static list<onBaseRecords> callOutMethod(string endPoint, string authHeader){
        Http h = new Http();
        string s_RequestDateTime = DateTime.Now().formatGmt('MMM d yyyy HH:mm:ss') + ' GMT';
        HttpRequest req = new HttpRequest();
        req.setMethod('GET');
        req.setHeader('Accept', 'application/xml'); 
        req.setHeader('date', s_RequestDateTime);
        req.setHeader('content-type','application/xml');
        req.setHeader('Authorization',authHeader);
        req.setEndpoint(endPoint);
        req.setTimeout(120000);
        HttpResponse res; 
        string LoginResult = 'Success';
        list<onBaseRecords> obrListResult = new list<onBaseRecords>();
      //  if(!Test.isRunningTest())
      //  {
            try{
                res = h.send(req);
                string xmlresult = res.getBody();
                System.debug('XML Result: ' + xmlresult);
                
                XmlStreamReader reader = res.getXmlStreamReader();
                  
                obrListResult = parserMethodMain(reader);
    
            }catch(Exception e)
            {
                LoginResult = 'FailedException::::::::::::::' + e ;
                system.debug(LoginResult);
            }
        	return obrListResult;
      //  }
    }
    
    
    public static list<onBaseRecords> parserMethodMain(XmlStreamReader reader){
         list<onBaseRecords> obrList = new list<onBaseRecords>();
         
         OnBaseRecords obr = new OnBaseRecords();
         while(reader.hasNext()) {
             if (reader.getEventType() == XmlTag.START_ELEMENT) {
                   System.debug('^^^^' + reader.getLocalName());
                   if('OnBaseSignatureCard' == reader.getLocalName()){
                       obr = onBaseParserMethodSub(reader);
                       obrList.add(obr);
                   }
             }    
             reader.next();
         }
         
         system.debug('FinalOBRList::::::::::::::' +obrList);
         return obrList;
    }
    
    
    public static onBaseRecords  onBaseParserMethodSub(XmlStreamReader reader){
        onBaseRecords obr = new onBaseRecords();
        string Brand;
        string DocumentName;
        string DocumentNumber;
        string DocumentType;
        string MemberId;
        string MemberFirstName;
        string MemberLastName;
        string PopDocUrl;
        string SortOrder;
         
        while(reader.hasNext()) {
             
            if (reader.getEventType() == XmlTag.END_ELEMENT && 'OnBaseSignatureCard' == reader.getLocalName()) {
                break;
            }
            if (reader.getEventType() == XmlTag.START_ELEMENT) {
                System.debug('^^^^' + reader.getLocalName());
                if('Brand'== reader.getLocalName()){
                    Brand= detailObrParser(reader);
                    obr.Brand = Brand;
                    system.debug('Brand::::::'+Brand);
                }
                if('SortOrder'== reader.getLocalName()){
                    SortOrder= detailObrParser(reader);
                    obr.SortOrder = SortOrder;
                    system.debug('SortOrder::::::'+SortOrder);
                }
                if('DocumentName'== reader.getLocalName()){
                    DocumentName= detailObrParser(reader);
                    obr.DocumentName = DocumentName;
                    system.debug('DocumentName::::::'+DocumentName);
                }
                if('DocumentNumber'== reader.getLocalName()){
                    DocumentNumber= detailObrParser(reader);
                    obr.DocumentNumber = DocumentNumber;
                    system.debug('DocumentNumber::::::'+DocumentNumber);
                }
                if('DocumentType'== reader.getLocalName()){
                    DocumentType = detailObrParser(reader);
                    obr.DocumentType = DocumentType;
                    system.debug('DocumentType::::::'+DocumentType);
                }
                if('MemberFirstName'== reader.getLocalName()){
                    MemberFirstName = detailObrParser(reader);
                    obr.MemberFirstName = MemberFirstName;
                    system.debug('MemberFirstName::::::'+MemberFirstName);
                }
                if('MemberId'== reader.getLocalName()){
                    MemberId = detailObrParser(reader);
                    obr.MemberId = MemberId;
                    system.debug('MemberId::::::'+MemberId);
                }
                if('MemberLastName'== reader.getLocalName()){
                    MemberLastName = detailObrParser(reader);
                    obr.MemberLastName = MemberLastName;
                    system.debug('MemberLastName::::::'+MemberLastName);
                }
                if('PopDocUrl'== reader.getLocalName()){
                    PopDocUrl = detailObrParser(reader);
                    obr.PopDocUrl = PopDocUrl;
                    system.debug('PopDocUrl::::::'+PopDocUrl);
                }
            }
            reader.next();
        }
        return obr;
    }
    
    public static string detailObrParser(XmlStreamReader reader){
        String ObrElement ='';
        while(reader.hasNext()) {
            System.debug('^^^^' + reader.getEventType());
            if (reader.getEventType() == XmlTag.END_ELEMENT) {
                break;
            } else if (reader.getEventType() == XmlTag.CHARACTERS) {
                ObrElement = ObrElement+reader.getText();
                system.debug('ObrElement ::::::::::'+ObrElement);
            }
            reader.next();
        }
        
        return ObrElement;
    }
    
    @AuraEnabled
	public static Map<string, object> GetPagingData(string accid,Integer PageNo, Integer PageSize, String SectionName, string SortBy, string SortDir,string SearchText)
	{
		
    	Map<string, object> m = new Map<string, object>();
    	Account_Details__c act = [select Name from Account_Details__c where Id =: accid Limit 1];
    	string endPointURL = 'https://sfrts.chevronfcu.org/api/documents/'+act.Name;		    	
		string authHeader = buildAuthHeader(act.Name);
		list<onBaseRecords> obrListResult = new list<onBaseRecords>();
		m.put('obrListResult',obrListResult);
		m.put('obrListtotalrecords',obrListResult.size());
    	return m;
	}
    
    public class onBaseRecords{
    	@auraenabled
        public string Brand {get;set;}
        
        @auraenabled
        public string DocumentName {get;set;}
        
        @auraenabled
        public string DocumentNumber {get;set;}
        
        @auraenabled
        public string DocumentType {get;set;}
        
        @auraenabled
        public string MemberId {get;set;}
        
        @auraenabled
        public string MemberFirstName {get;set;}
        
        @auraenabled
        public string MemberLastName {get;set;}
        
        @auraenabled
        public string PopDocUrl {get;set;}
        
        @auraenabled
        public string SortOrder {get;set;}
        
    }
}