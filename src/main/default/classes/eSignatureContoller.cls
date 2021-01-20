global class eSignatureContoller {
    
    public InPersonSigning__c wireTransaction;
    public InPersonSigning__c wireTransactionDetail{get; set;}
    public id objParentId{get;set;}
    
    global Id signAttachmentId{get {
        List<Attachment> a = new List<Attachment>();
        a = [SELECT Id FROM Attachment Where ParentId=:objParentId and Name='ESignature.png' Order by CreatedDate desc LIMIT 1]; 
        if(a.size() > 0) {return a[0].Id;} 
        return null;} set;}
    
    public eSignatureContoller(ApexPages.StandardController stdController) {
        this.wireTransaction = (InPersonSigning__c)stdController.getRecord();
        this.objParentId=this.wireTransaction.Id;
        system.debug(ApexPages.currentPage().getParameters().get('id'));
        this.wireTransactionDetail = [SELECT Id,Name,SalesforceID__c,
                                      Sender_AccountNumber__c,Sender_Address__c,
                                      Sender_Name__c,Sender_Email__c,Sender_Home_Phone__c,
                                      Sender_City_State_Zip__c,
                                      Recipient_AccountNumber__c,Recipient_Address__c,
                                      Recipient_City__c,	Recipient_State__c,	Recipient_Zipcode__c,
                                      Recipient_Bank__c,RecepientName__c,
                                      RoutingNumber__c,Share_ID__c,TotalAmount__c
                                      From InPersonSigning__c WHERE Id=:this.wireTransaction.Id];
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
    public static InPersonSigning__c getInPersonSigningData(Id recordId){
        InPersonSigning__c data= [SELECT Id,Name,SalesforceID__c,IsLocked__c,
                                  Sender_AccountNumber__c,Sender_Address__c,
                                  Sender_Name__c,Sender_Email__c,Sender_Home_Phone__c,
                                  Sender_City_State_Zip__c,
                                  Recipient_AccountNumber__c,Recipient_Address__c,
                                  Recipient_City__c,	Recipient_State__c,	Recipient_Zipcode__c,
                                  Recipient_Bank__c,RecepientName__c,
                                  RoutingNumber__c,Share_ID__c,TotalAmount__c 
                                  FROM InPersonSigning__c WHERE Id=:recordId];        
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
        
        InPersonSigning__c inPersonSigning=[SELECT Id, Name,SalesforceID__c FROM InPersonSigning__c WHERE Id=:wireTransaction.Id LIMIT 1];
        if(inPersonSigning!=null){
            inPersonSigning.IsLocked__c=true;
            update inPersonSigning;
        }
        
        //Execute progress email notification and red check flow of WIRES
        set<Id> ids=new set<Id>();
        ids.add(inPersonSigning.SalesforceID__c);
        WiresTransactionApprovalController.SendProgressNotification(ids);
        WiresTransactionApprovalController.CheckRedFlgsAndUpdateStatus(ids);
        
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