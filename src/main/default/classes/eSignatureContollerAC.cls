global class eSignatureContollerAC {
    
    public InPersonSigning__c wireTransaction;
    public InPersonSigning__c wireTransactionDetail{get; set;}

    public InPersonSigning__c addressChangeObject;
    public InPersonSigning__c addressChangeObjectDetail{get; set;}


    public id objParentId{get;set;}
    public id toBeSIgnedListViewId{get;set;}
    public boolean showAlert { get; set; }
    public string fmtDate {get;set;}

    public List<String> str_intake {get;set;}
    public List<String> str_id {get;set;}

    
    global Id signAttachmentId{get {
        List<Attachment> a = new List<Attachment>();
        a = [SELECT Id FROM Attachment Where ParentId=:objParentId and Name='ESignature.png' Order by CreatedDate desc LIMIT 1]; 
        if(a.size() > 0) {return a[0].Id;} 
        return null;} set;}
    
    global string signImageUrl{
        get{
            string url=URL.getSalesforceBaseUrl().toExternalForm() +'/servlet/servlet.FileDownload?file='+signAttachmentId+'&oid='+UserInfo.getOrganizationId();
            url=url.replace('visual', 'content');
            System.debug('Url:'+url);
            return url;
        }
    }
    
    
    public eSignatureContollerAC(ApexPages.StandardController stdController) {
        ListView lstView=[SELECT Id,Name from ListView Where Name='To Be Signed' LIMIT 1]; 
        str_intake = new List<String>();
        str_id = new List<String>();
        if(lstView!=null){
            toBeSIgnedListViewId= lstView.Id;
        }
        
        this.addressChangeObject = (InPersonSigning__c)stdController.getRecord();
        this.objParentId=this.addressChangeObject.Id;
        Date tt = system.today();
        fmtDate = tt.format();
        
        system.debug(ApexPages.currentPage().getParameters().get('id'));
        this.addressChangeObjectDetail = [SELECT Id,Name,SalesforceID__c,Sender_Name__c,
                                        AC_Email__c,AC_Home_Phone__c,
                                        AC_Mailing_Address_City__c,AC_Mailing_Address_Country__c,AC_Mailing_Address_Country_Code__c,
                                        AC_Mailing_Address_Line1__c,AC_Mailing_Address_Line2__c,
                                        AC_Mailing_Address_State__c,AC_Mailing_Address_Zip__c,
                                        AC_Mobile_Phone__c,AC_Residential_Address_Line1__c,	AC_Residential_Address_Line2__c,
                                        AC_Residential_City__c,AC_Residential_Country__c,
                                        AC_Residential_Country_Code__c,AC_Residential_State__c,AC_Residential_Zip__c,AC_Work_Extension__c,
                                        AC_Work_Phone__c,Brand__c
                                        From InPersonSigning__c WHERE Id=:this.addressChangeObject.Id];
        
        //List<PicklistWrapper> inPersonSigninPickListValuesList= new List<PicklistWrapper>();
        Schema.DescribeFieldResult fieldResult_intake = InPersonSigning__c.Clean_Up_Intake_Method__c.getDescribe();
        List<Schema.PicklistEntry> ple_intake = fieldResult_intake.getPicklistValues();
        
        for( Schema.PicklistEntry pickListVal : ple_intake){ 
            /*PicklistWrapper option = new PicklistWrapper();
            option.Id=pickListVal.getValue();
            option.Name=pickListVal.getLabel();
            inPersonSigninPickListValuesList.add(option);*/
            str_intake.add(pickListVal.getValue());
        }
        
        //List<PicklistWrapper> pickListValuesListIdentification= new List<PicklistWrapper>();
        Schema.DescribeFieldResult fieldResult_id = InPersonSigning__c.Identification_Method__c.getDescribe();
        List<Schema.PicklistEntry> ple_id = fieldResult_id.getPicklistValues();
        
        for( Schema.PicklistEntry pickListVal : ple_id){ 
            /*PicklistWrapper option = new PicklistWrapper();
            option.Id=pickListVal.getValue();
            option.Name=pickListVal.getLabel();
            pickListValuesListIdentification.add(option);*/
            str_id.add(pickListVal.getValue());
        }            
        
    }

    
    
    @AuraEnabled
    public static Id saveSignature(String signatureBody, string addressChangeId){
        Attachment a = new Attachment();
        a.ParentId = addressChangeId; // record id of object.
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
                                    AC_Email__c,AC_Home_Phone__c,
                                    AC_Mailing_Address_City__c,AC_Mailing_Address_Country__c,AC_Mailing_Address_Country_Code__c,
                                    AC_Mailing_Address_Line1__c,AC_Mailing_Address_Line2__c,
                                    AC_Mailing_Address_State__c,AC_Mailing_Address_Zip__c,
                                    AC_Mobile_Phone__c,AC_Residential_Address_Line1__c,	AC_Residential_Address_Line2__c,
                                    AC_Residential_City__c,AC_Residential_Country__c,
                                    AC_Residential_Country_Code__c,AC_Residential_State__c,AC_Residential_Zip__c,AC_Work_Extension__c,
                                    AC_Work_Phone__c,Brand__c
                                  FROM InPersonSigning__c WHERE Id=:recordId];    
        return data;
    }
    
    public void attach() {
         
        // Attach pdf to Wires transaction record
        InPersonSigning__c inPersonSign=[Select SalesforceID__c FROM InPersonSigning__c Where Id=: addressChangeObject.Id LIMIT 1];
        //WIRES_Transaction__c wire=[Select FromAccount__c,Name FROM WIRES_Transaction__c Where Id=: inPersonSign.SalesforceID__c LIMIT 1];
        
        Attachment myAttach = new Attachment();
        myAttach.ParentId = addressChangeObject.Id;//Id of the object to which the page is attached
        myAttach.name = 'WIRETRANSFERAUTHORIZATION_12.pdf';
        PageReference myPdf = ApexPages.currentPage();//myPdfPage is the name of your pdf page
        myAttach.body = myPdf.getContentAsPdf();
        insert myAttach;
        System.debug('Inserted...' + myAttach.id);
        
        if(inPersonSign!=null){
            /*Attachment wireTransferPDF = new Attachment();
            wireTransferPDF.ParentId = inPersonSign.SalesforceID__c;
            wireTransferPDF.name = 'WIRETRANSFERAUTHORIZATION_'+wire.Name+'.pdf';
            PageReference wireTranferPdfContent = ApexPages.currentPage();
            wireTransferPDF.body = wireTranferPdfContent.getContentAsPdf();
            insert wireTransferPDF;*/
            
            /*Wires_Document__c wireDoc=new Wires_Document__c();
            wireDoc.Attachment_Id__c =wireTransferPDF.Id;
            wireDoc.Member_Number__c = wire.FromAccount__c;
            wireDoc.IsMovedToOnBase__c = false;
            wireDoc.Document_Type__c = 'Wire Transfers';
            wireDoc.Document_Name__c = 'WIRETRANSFERAUTHORIZATION_'+wire.Name+'.pdf';
            wireDoc.Wires__c = inPersonSign.SalesforceID__c;
            wireDoc.Attachment_Created_On__c = DateTime.now();
            
            insert wireDoc;*/
        }
        
        List<Attachment> signatures = new List<Attachment>();
        signatures = [SELECT Id FROM Attachment Where ParentId=:addressChangeObject.Id and Name='ESignature.png' Order by CreatedDate desc OFFSET 1]; 
        if(signatures.size()>0){
            delete signatures;
        }
        
        List<Attachment> eSignPdfs = new List<Attachment>();
        eSignPdfs = [SELECT Id FROM Attachment Where ParentId=:addressChangeObject.Id and Name='WIRE TRANSFER AUTHORIZATION.pdf' Order by CreatedDate desc OFFSET 1]; 
        if(eSignPdfs.size()>0){
            delete eSignPdfs;
        }
        
        InPersonSigning__c inPersonSigning=[SELECT Id, Name,SalesforceID__c FROM InPersonSigning__c WHERE Id=:addressChangeObject.Id LIMIT 1];
        if(inPersonSigning!=null){
            //inPersonSigning.Wires_Transaction__c=inPersonSign.SalesforceID__c;
            //update lock status
            //inPersonSigning.IsLocked__c=true;
            //update inPersonSigning;
        }
        
        //Execute progress email notification and good fund check flow of WIRES
        set<Id> ids=new set<Id>();
        ids.add(inPersonSigning.SalesforceID__c);
        
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