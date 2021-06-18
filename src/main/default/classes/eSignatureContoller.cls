global class eSignatureContoller {
    
    public InPersonSigning__c wireTransaction;
    public InPersonSigning__c wireTransactionDetail{get; set;}
    public id objParentId{get;set;}
    public id toBeSIgnedListViewId{get;set;}
    public boolean showAlert { get; set; }
    
    global Id signAttachmentId{get {
        List<Attachment> a = new List<Attachment>();
        a = [SELECT Id FROM Attachment Where ParentId=:objParentId and Name='ESignature.png' Order by CreatedDate desc LIMIT 1]; 
        if(a.size() > 0) {return a[0].Id;} 
        return null;} set;}
    
    public eSignatureContoller(ApexPages.StandardController stdController) {
        ListView lstView=[SELECT Id,Name from ListView Where Name='To Be Signed' LIMIT 1]; 
        
        if(lstView!=null){
            toBeSIgnedListViewId= lstView.Id;
        }
        
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
    
    public void attach() {
         
        // Attach pdf to Wires transaction record
        InPersonSigning__c inPersonSign=[Select SalesforceID__c FROM InPersonSigning__c Where Id=: wireTransaction.Id LIMIT 1];
        WIRES_Transaction__c wire=[Select FromAccount__c,Name FROM WIRES_Transaction__c Where Id=: inPersonSign.SalesforceID__c LIMIT 1];
        
        Attachment myAttach = new Attachment();
        myAttach.ParentId = wireTransaction.Id;//Id of the object to which the page is attached
        myAttach.name = 'WIRETRANSFERAUTHORIZATION_'+wire.Name+'.pdf';
        PageReference myPdf = ApexPages.currentPage();//myPdfPage is the name of your pdf page
        myAttach.body = myPdf.getContentAsPdf();
        insert myAttach;
        
        if(inPersonSign!=null){
            Attachment wireTransferPDF = new Attachment();
            wireTransferPDF.ParentId = inPersonSign.SalesforceID__c;
            wireTransferPDF.name = 'WIRETRANSFERAUTHORIZATION_'+wire.Name+'.pdf';
            PageReference wireTranferPdfContent = ApexPages.currentPage();
            wireTransferPDF.body = wireTranferPdfContent.getContentAsPdf();
            insert wireTransferPDF;
            
            Wires_Document__c wireDoc=new Wires_Document__c();
            wireDoc.Attachment_Id__c =wireTransferPDF.Id;
            wireDoc.Member_Number__c = wire.FromAccount__c;
            wireDoc.IsMovedToOnBase__c = false;
            wireDoc.Document_Type__c = 'Wire Transfers';
            wireDoc.Document_Name__c = 'WIRETRANSFERAUTHORIZATION_'+wire.Name+'.pdf';
            wireDoc.Wires__c = inPersonSign.SalesforceID__c;
            wireDoc.Attachment_Created_On__c = DateTime.now();
            
            insert wireDoc;
        }
        
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
            inPersonSigning.Wires_Transaction__c=inPersonSign.SalesforceID__c;
            update inPersonSigning;
        }
        
        //Execute progress email notification and good fund check flow of WIRES
        set<Id> ids=new set<Id>();
        ids.add(inPersonSigning.SalesforceID__c);
        
        WiresTransactionApprovalController.CheckGoodFundAndUpdateStatus(ids);
        
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,'Wire Transfer Authorization pdf has been generated successfully.'));  
        
        //ListView lstView=[SELECT Id,Name from ListView Where Name='To Be Signed' LIMIT 1];
        //string baseUrl=URL.getSalesforceBaseUrl().toExternalForm()+ '/lightning/o/InPersonSigning__c/list?filterName='+lstView.Id; 
        //system.debug('BaseURL:'+baseUrl);
        //PageReference pageRef = new PageReference(baseUrl);
        
        //pageRef.setRedirect(true);
        //return pageRef;
        //
        
        //sforce.one.navigateToList('00B19000002CZbHEAW','To Be Signed','InPersonSigning__c');
        
        ListView lstView=[SELECT Id,Name from ListView Where Name='To Be Signed' LIMIT 1]; 
        showAlert=true;
    }
    
    //public PageReference Cancel() {
    //PageReference pageRef = new PageReference('/' + objParentId);
    //ListView lstView=[SELECT Id,Name from ListView Where Name='To Be Signed' LIMIT 1];
    //string baseUrl=URL.getSalesforceBaseUrl().toExternalForm()+ '/lightning/o/InPersonSigning__c/list?filterName='+lstView.Id; 
    //system.debug('BaseURL:'+baseUrl);
    //PageReference pageRef = new PageReference(baseUrl);
    //pageRef.setRedirect(true);
    //return pageRef;
    //}
    
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