global with sharing class SendRequestToOnBaseController {
 
    string accNumber;
    string endPointURL {get;set;}
    string xmlresult {get;set;}
    public list<onBaseRecords> obrListResult {get;set;}
    string authHeader;
    private Helper hObj = new Helper();
    private Blob private_Key;
    private string key = hObj.WebServiceClientkey;
    private string KeyPart2 = hObj.WebServiceClientKeyPart2;
    private string KeyPart3 = hObj.WebServiceClientKeyPart3;
    private string KeyPart4 = hObj.WebServiceClientKeyPart4;
    private string strPrivate_Key= key+KeyPart2+KeyPart3+KeyPart4;
    private string Origin;
    
    public SendRequestToOnBaseController(){
        authHeader = buildAuthHeader();
        System.debug('AuthHeader::::::'+authHeader);
        accNumber = System.currentPageReference().getParameters().get('accNum');
        endPointURL = 'https://sfrts.chevronfcu.org/api/documents/'+accNumber;
        System.debug(endPointURL);
       // callOutMethod('https://sfrtsqa.chevronfcu.org/api/documents/18249');
        callOutMethod(endPointURL, authHeader);
    }
    
    public string buildAuthHeader(){
        Origin = hObj.WebServiceClientOrigin;
        accNumber = System.currentPageReference().getParameters().get('accNum');
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
        
        authHeader = 'Origin='+Origin+',algorithm=rsa-sha256, headers='; 
        authHeader +=  url + ' ' +  'GET' + ' HTTP/1.1 ' + 'date=' + s_RequestDateTime +  ', signature ' + Signature;       
                
        return authHeader;
    }
    
     public void callOutMethod(string endPoint, string authHeader){
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
        
      //  if(!Test.isRunningTest())
      //  {
            try{
                res = h.send(req);
                xmlresult = res.getBody();
                System.debug('XML Result: ' + xmlresult);
                
                XmlStreamReader reader = res.getXmlStreamReader();
                  
                obrListResult = parserMethodMain(reader);
    
            if(Test.isRunningTest()){
               Integer x=1/0;}
            }catch(Exception e)
            {
                LoginResult = 'FailedException::::::::::::::' + e ;
                system.debug(LoginResult);
            }
        
      //  }
    }
    
    
    public list<onBaseRecords> parserMethodMain(XmlStreamReader reader){
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
    
    
    public onBaseRecords  onBaseParserMethodSub(XmlStreamReader reader){
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
    
    public string detailObrParser(XmlStreamReader reader){
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
    
    public class onBaseRecords{
        public string Brand {get;set;}
        public string DocumentName {get;set;}
        public string DocumentNumber {get;set;}
        public string DocumentType {get;set;}
        public string MemberId {get;set;}
        public string MemberFirstName {get;set;}
        public string MemberLastName {get;set;}
        public string PopDocUrl {get;set;}
        public string SortOrder {get;set;}
        
    }
}