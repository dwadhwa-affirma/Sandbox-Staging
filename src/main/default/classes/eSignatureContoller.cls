global class eSignatureContoller {
     
    public WIRES_Transaction__c wireTransaction;
    public WIRES_Transaction__c wireTransactionDetail{get; set;}
    public id objParentId{get;set;}
    
    global Id signAttachmentId{get {
        List<Attachment> a = new List<Attachment>();
        a = [SELECT Id FROM Attachment Where ParentId=:objParentId and Name='ESignature.png' Order by CreatedDate desc LIMIT 1]; 
        if(a.size() > 0) {return a[0].Id;} 
        return null;} set;}
    
    public eSignatureContoller(ApexPages.StandardController stdController) {
        this.wireTransaction = (WIRES_Transaction__c)stdController.getRecord();
        this.objParentId=this.wireTransaction.Id;
        system.debug(ApexPages.currentPage().getParameters().get('id'));
        this.wireTransactionDetail = [SELECT Id,Name,WireAmount__c,Fees__c,FromAccount__c,TotalFromAccount__c,Share_ID__c,
                                    Member_Name__c,Member_Email__c,Member_Address__c,
                                    Member_City_State_Zip__c,Member_Home_Phone__c,
                                    ToAccoutId__r.Id,ToAccoutId__r.Name,ToAccoutId__r.Recipient_AccountNumber__c,
                                    ToAccoutId__r.BankName__c,ToAccoutId__r.RoutingNumber__c,
                                    ToAccoutId__r.Address1__c,ToAccoutId__r.City__c,ToAccoutId__r.State__c,
                                    ToAccoutId__r.Country__c,ToAccoutId__r.Zipcode__c 
                                    From WIRES_Transaction__c WHERE Id=:this.wireTransaction.Id];
    }
    
	@AuraEnabled
    public static Id saveSignature(String signatureBody, string wiresId){
          
        Attachment a = new Attachment();
        a.ParentId = wiresId; // record id of object.
        a.Body = EncodingUtil.base64Decode(signatureBody);
        a.ContentType = 'image/png';
        a.Name = 'ESignature.png';
        insert a;
        return a.Id;
    }
    
    @RemoteAction
     global static Id saveSignature(String signatureBody, id parentId){
            Attachment a = new Attachment();
            a.ParentId = parentId; // record id of object.
            a.Body = EncodingUtil.base64Decode(signatureBody);
            a.ContentType = 'image/png';
            a.Name = 'ESignature.png';
            insert a;
            return a.Id;
      }
    
    
    
    @AuraEnabled
    public static void savePDF(Id wiresId){
        String htmlBody = '<h1>Hello , Test </h1>';
        Attachment a = new Attachment();
        a.ParentId = wiresId; // record id of object.
        a.Body = blob.toPDF(htmlBody);
        a.Name = 'Signature Capture.pdf';
        insert a;
    }
    
    @AuraEnabled   
    public static WIRES_Transaction__c getWireTransactionData(Id wiresId){
        WIRES_Transaction__c data= [SELECT Id,Name,WireAmount__c,Fees__c,FromAccount__c,TotalFromAccount__c,Share_ID__c,
                                    Member_Name__c,Member_Email__c,Member_Address__c,
                                    Member_City_State_Zip__c,Member_Home_Phone__c,
                                    ToAccoutId__r.Id,ToAccoutId__r.Name,ToAccoutId__r.Recipient_AccountNumber__c,
                                    ToAccoutId__r.BankName__c,ToAccoutId__r.RoutingNumber__c,
                                    ToAccoutId__r.Address1__c,ToAccoutId__r.City__c,ToAccoutId__r.State__c,
                                    ToAccoutId__r.Country__c,ToAccoutId__r.Zipcode__c 
                                    From WIRES_Transaction__c WHERE Id=:wiresId];
        return data;
    }
        
    public PageReference attach() {
        Attachment myAttach = new Attachment();
        myAttach.ParentId = wireTransaction.Id;//Id of the object to which the page is attached
        myAttach.name = 'WIRE TRANSFER AUTHORIZATION.pdf';
        PageReference myPdf = ApexPages.currentPage();//myPdfPage is the name of your pdf page
        myAttach.body = myPdf.getContentAsPdf();
        insert myAttach;
        
        List<Attachment> signatures = new List<Attachment>();
        	signatures = [SELECT Id FROM Attachment Where ParentId=:wireTransaction.Id and Name='ESignature.png' Order by CreatedDate desc OFFSET 1]; 
         	if(signatures.size()>0){
             delete signatures;
         	}
         
            List<Attachment> eSignPdfs = new List<Attachment>();
        	eSignPdfs = [SELECT Id FROM Attachment Where ParentId=:wireTransaction.Id and Name='WIRE TRANSFER AUTHORIZATION.pdf' Order by CreatedDate desc OFFSET 1]; 
         	if(eSignPdfs.size()>0){
             delete eSignPdfs;
         	}
        
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,'Wire Transfer Authorization pdf has been generated successfully.'));  
        
        PageReference pageRef = new PageReference('/' + objParentId);
		pageRef.setRedirect(true);
        return pageRef;
    }
    
     public PageReference Cancel() {
		PageReference pageRef = new PageReference('/' + objParentId);
		pageRef.setRedirect(true);
        return pageRef;
    }
    
    public void spin() {
        long now = datetime.now().gettime();
        //while(datetime.now().gettime()-now<5000); // Busy loop for 5000 ms
    }
    
    Integer count = 0;
                        
    public PageReference incrementCounter() {
            count++;
            return null;
    }
                        
    public Integer getCount() {
        return count;
    }
}