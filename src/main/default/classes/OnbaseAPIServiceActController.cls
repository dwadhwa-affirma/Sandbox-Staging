public class OnbaseAPIServiceActController {
    public Account_Details__c ac{get;set;}
     public String st{get;set;}
    public OnbaseAPIServiceActController(ApexPages.StandardController controller){
         ac = [SELECT Id, name FROM Account_Details__c WHERE Id = :ApexPages.currentPage().getParameters().get('id')];
       
        ac.Name = ac.Name.replaceFirst('^0+','');

        
        System.debug('account selected is '+ac.name);
       // integer acct = Integer.valueOf(ac.name);
        
      //  requestparam.setEndpoint('https://boomi.chevronfcu.org:9090/ws/simple/queryOnbaseDoc'+'?CaseNumber=520065');
      
      
        // http request class
       httpRequest requestparam = new httpRequest(); 
        requestparam.setEndpoint('https://boomi.chevronfcu.org:9090/ws/simple/queryOnbaseDoc');
        requestparam.setMethod('POST');
        
     
        //json body for post method
        JSONGenerator gen = JSON.createGenerator(true);   
          gen.writeStartObject();     
          gen.writeNumberField('accountnumber', Integer.valueof(ac.Name));
          gen.writeEndObject();   
          String jsonS = gen.getAsString();
          System.debug('jsonMaterials'+jsonS);
          requestparam.setBody(jsonS);
          
        System.debug('Service request is ....' + requestparam);
        System.debug('Request body is ' + requestparam.getBody());
        
        // http response class
        http httpParam = new http();
        httpResponse response = httpParam.send(requestparam);
        
        String strStatus = response.getStatus();
        String strBody = response.getBody();
        System.debug('Service response is ....' + strStatus);
        System.debug('Service response is ....' + strBody);
       
          if(strBody!=''){
        
       Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
       
         System.debug('Service response is ....' + results);
        
        JSONParser parser1 = JSON.createParser(strBody);  
        System.debug('Service parser1 response is ....' + parser1);
        // get Account Number
      
        List<String> ActNum =new List<String>();
        
        while(parser1.nextToken()!=null){
            if((parser1.getCurrentToken()==JSONToken.FIELD_NAME)&&(parser1.getText()=='accountnumber')){
                // get the value
                parser1.nextToken();
                actNum.add(parser1.getText());
            }
          }
        
        JSONParser jparser2 = JSON.createParser(strBody);  
        // get the DocumentName
        List<String> DocumentName = new List<String>();
        while(jparser2.nextToken()!=null){
            if((jparser2.getCurrentToken()==JSONToken.FIELD_NAME)&&(jparser2.getText()=='DocumentName_c')){
                // get the value
                jparser2.nextToken();
                DocumentName.add(jparser2.getText());
            }
          }
        
        JSONParser jparser3 = JSON.createParser(strBody);  
        // get the list of DocumentNumber
        List<String> DocumentNumber = new List<String>();
        while(jparser3.nextToken()!=null){
            if((jparser3.getCurrentToken()==JSONToken.FIELD_NAME)&&(jparser3.getText()=='DocumentNumber_c')){
                // get the value
                jparser3.nextToken();
               DocumentNumber.add(jparser3.getText());
            }
           }
        
         JSONParser jparser4 = JSON.createParser(strBody);  
        // get the list of DocumentType
        List<String> DocumentType = new List<String>();
        while(jparser4.nextToken()!=null){
            if((jparser4.getCurrentToken()==JSONToken.FIELD_NAME)&&(jparser4.getText()=='DocumentType_c')){
                // get the value
                jparser4.nextToken();
                DocumentType.add(jparser4.getText());
            }
           } 
        
         JSONParser jparser5 = JSON.createParser(strBody); 
        // get the list of PopDocUrl
        List<String> PopDocUrl = new List<String>();
        while(jparser5.nextToken()!=null){
            if((jparser5.getCurrentToken()==JSONToken.FIELD_NAME)&&(jparser5.getText()=='PopDocUrl_c')){
                // get the value
                jparser5.nextToken();
                PopDocUrl.add(jparser5.getText());
            }
           } 
        
     
       lstWI = new List<wrapDocument>();
        for(Integer i=0; i<DocumentNumber.size(); i++){
           objWI = new wrapDocument();  
            // objWI.caseNum = CaseNum[i]; 
            objWI.actNum = actNum[i];
             objWI.docName = DocumentName[i]; 
             objWI.docNumber = DocumentNumber[i]; 
             objWI.docType = DocumentType[i]; 
             objWI.popDocUrl = PopDocUrl[i];
            lstWI.add(objWI);
        } 
       
          } 
         else{
         st = 'There are no documents in OnBase related to this Account';
    }
        
    } 
    
    public wrapDocument objWI{get; set;}
    public List<wrapDocument> lstWI{get;set;}
    
    public class wrapDocument{
       // public String caseNum{get; set;} 
        public String actNum{get;set;}
        public String docName{get; set;}
        public String docNumber{get; set;}
        public String docType{get; set;}
        public String popDocUrl{get; set;} 
         
       
    }  
             
}