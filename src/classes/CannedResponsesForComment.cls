Public Class CannedResponsesForComment{

    public Canned_Responses__c cannedResponse{get;set;}
    public list<String> Titles{get;set;} //remove later
    public String searchText{get;set;}
    public List<Canned_Responses__c> output{get;set;}
    public Member_Comment__c member{get; set;}
    public String brand{get;set;}
    public String selectedTitle{get;set;}
    public String selectedPrimary{get;set;}
    public String selectedSecondary{get;set;}
    public String selectedTertiary{get;set;}
    public String chosenDescription{get;set;}
    public Id caseId{get;set;}
    ApexPages.StandardController con;
    public Canned_Message_Metadata__c cannedMessageHeader {get;set;}
    public List<Attachment> CaseAttachmentLst;
    public List<attachmentWrapper> wrapperLst {get;set;}
    List<Approve_Attachment__c> approvedLst;
    set<id> approvalids;
    public string MemberDescription {get;set;} 
     public boolean Draft {get;set;} 
    Public boolean showBtn {get;set;}
    //public string msg {get;set;}
    public boolean stopSave {get;set;}
    Case tempCase;
    public Account a;
    public Account_Details__c ad;
    
    public CannedResponsesForComment(ApexPages.StandardController controller) {
        stopSave = true;
        draft = false;
        con = controller;
        Member_Comment__c m = (Member_Comment__c)con.getrecord();
        caseId = m.case__c;

        cannedMessageHeader = [Select id, Chevron_Footer__c, Chevron_Header__c, Spectrum_Footer__c, Spectrum_Header__c from Canned_Message_Metadata__c limit 1];
        //msg = 'Please assign Email address to Member to save the Member Comment'; 
        cannedResponse = new Canned_Responses__c();
        output = new List<Canned_Responses__c>();//remove later   
        //output = [select id, Canned_Response_Title__c,Description__c from Canned_Responses__c];       
        //caseId = ApexPages.currentPage().getParameters().get('CaseId');
         // caseId = Member_Comment__c.Case__c;
        system.debug('caseId....'+caseId);    
        tempCase = new Case();        
        tempCase = [select id,Account_Number__c, AccountId, CreatedBy.Email,SecureEmail__c from case where id =:caseId];
        
     
        system.debug('case...'+tempCase);
        Id accid = tempCase.AccountId;
        
        if(tempCase != null){
            a = null;
            a = [select PersonEmail from account where id =: accid];
            ad =    [Select id,Brand__c, SecureEmailAddress__c FROM Account_Details__c Where ID =: tempCase.Account_Number__c];
       
            if(String.isEmpty(ad.SecureEmailAddress__c )){
                system.debug('ad.SecureEmailAddress__c--'+ad.SecureEmailAddress__c);
                stopSave = true;
            }
           
            else{
                stopSave = false;
                system.debug('a.PersonEmail-123-');
            }
            
            
            if(stopsave && !string.isEmpty( tempCase.SecureEmail__c))
            {
            	
            	 
                stopSave = false;
                
            
            }
            
        }
        
       // Account_Details__c tempMemberAccount = new Account_Details__c();
       // tempMemberAccount = [select id, Brand__c from Account_Details__c where id = :tempCase.Account_Number__c];
       
        brand = ad.Brand__c;
        
        wrapperLst = new List<attachmentWrapper>();
        CaseAttachmentLst = [SELECT Id, Name, Body, ContentType FROM Attachment WHERE Parentid =:caseId AND createdby.Profile.UserLicense.LicenseDefinitionKey = 'SFDC'];
        if(CaseAttachmentLst.size() > 0 && CaseAttachmentLst != null){
            approvedLst = new List<Approve_Attachment__c>();
            approvedLst = [select id,Case_ID__c,Attachment_Id__c from Approve_Attachment__c where Case_ID__c = : caseId];
            approvalids = new set<id>();
            if(approvedLst.size() > 0 && approvedLst != null){              
                for(Approve_Attachment__c ap: approvedLst){
                    approvalids.add(ap.Attachment_Id__c);
                }
            }
            for(Attachment c : CaseAttachmentLst){            
                if(!approvalIds.isEmpty()){
                    if(approvalids.contains(c.id)){
                        showBtn = true;
                        attachmentWrapper wrapobj = new attachmentWrapper(); 
                        system.debug('approvalIds--'+approvalIds);
                        wrapobj.attachmentobj = c;                    
                        wrapobj.checkvalue = false;
                        wrapperLst.add(wrapobj); 
                    }                    
                }                       
            }
            system.debug('wrapperLst--'+wrapperLst.size());
        }
        
    }
    
    public List<SelectOption> getItems() {
        List<SelectOption> options = new List<SelectOption>();
        System.Debug('output:' + output);
        for(Canned_Responses__c c: output){
            options.add(new SelectOption(c.id,c.Canned_Response_Title__c));        
        }
        return options;
    }
    
    public List<SelectOption> getPrimary() {
        List<SelectOption> options = new List<SelectOption>();
        List<Canned_Responses__c> primary = new List<Canned_Responses__c>();
        primary = [select id, Primary_Lookup_Text__c from Canned_Responses__c where Brand__c =:brand and Active__c = true and Primary_Lookup_Text__c != ''];
        set<String> uniques = new set<String>();        
        for(Canned_Responses__c c: primary){
            uniques.add(c.Primary_Lookup_Text__c);
        }
        options.add(new SelectOption('0','-None-'));
        for(String s: uniques){
            options.add(new SelectOption(s,s));        
        }
        return options;
    }
    
    public List<SelectOption> getSecondary() {
        System.debug(selectedPrimary);
        System.debug(brand);
        
        List<SelectOption> options = new List<SelectOption>();
        List<Canned_Responses__c> secondary = new List<Canned_Responses__c>();
        Set<String> uniques = new set<String>(); 
        if(selectedPrimary != null){
            secondary = [select id, Secondary_Lookup_Text__c from Canned_Responses__c where Brand__c =:brand and Active__c = true and Primary_Lookup_Text__c = :selectedPrimary and Secondary_Lookup_Text__c != ''];
            for(Canned_Responses__c c: secondary){
                uniques.add(c.Secondary_Lookup_Text__c);        
            }
            options.add(new SelectOption('0','-None-'));
            for(String s: uniques){
                options.add(new SelectOption(s,s));        
            }            
        }
        system.debug(options);
        return options;
    }
        
    public List<SelectOption> getTertiary() {
        List<SelectOption> options = new List<SelectOption>();
        List<Canned_Responses__c> tertiary = new List<Canned_Responses__c>();
        Set<String> uniques = new set<String>(); 
        if(selectedSecondary != null){
            tertiary = [select id, Tertiary_Lookup_Text__c from Canned_Responses__c where Brand__c =:brand and Active__c = true and Primary_Lookup_Text__c = :selectedPrimary and Secondary_Lookup_Text__c =:selectedSecondary and Tertiary_Lookup_Text__c != ''];
            for(Canned_Responses__c c: tertiary){
                uniques.add(c.Tertiary_Lookup_Text__c);        
            }
            options.add(new SelectOption('0','-None-')); 
            for(String s: uniques){
                options.add(new SelectOption(s,s));        
            }
        }
        return options;
    }

       
    
    public void getTitlesBySearchText(){
        output = new List<Canned_Responses__c>();
        if(brand.length()<1){  
            brand = 'Chevron';   
        }
        String queryString = 'Select id, Description__c,Canned_Response_Title__c,Brand__c from Canned_Responses__c where Active__c = true and Brand__c =\''+brand+'\''+' and (Primary_Lookup_Text__c like \'%'+searchText+'%\' OR Secondary_Lookup_Text__c like \'%'+searchText+'%\' OR Tertiary_Lookup_Text__c like \'%'+searchText+'%\' OR Canned_Response_Title__c like \'%'+searchText+'%\')';
        system.debug(querystring);
        output = Database.query(queryString);
        selectedPrimary = '0';
        selectedSecondary = '0';
        selectedTertiary = '0';
    }
    
    public void getTitlesByCategories(){
        output = new List<Canned_Responses__c>();
        /*if(brand.length()<1){  
            brand = 'Chevron';   
        }*/
        system.debug('cannedResponse Primary category..'+selectedPrimary);
        system.debug('cannedResponse Secondary category..'+selectedSecondary);
        system.debug('cannedResponseTertiary category..'+selectedTertiary);
        
        if(selectedPrimary != null && (selectedSecondary == null || selectedSecondary == '0') && (selectedTertiary == null || selectedTertiary == '0') && selectedPrimary != '0' ){
            system.debug('inside first if');
            output = [Select id, Description__c,Canned_Response_Title__c,Brand__c from Canned_Responses__c where Brand__c =:brand and Active__c = true and Primary_Lookup_Text__c = :selectedPrimary];
            system.debug('output...'+output);
        }
        else 
        if(selectedPrimary != null && selectedSecondary != null && (selectedTertiary == null || selectedTertiary == '0') && selectedPrimary != '0' && selectedSecondary != '0'){
            system.debug('inside second if');
            output = [Select id, Description__c,Canned_Response_Title__c,Brand__c from Canned_Responses__c where Brand__c =:brand and Active__c = true and Primary_Lookup_Text__c = :selectedPrimary and Secondary_Lookup_Text__c =:selectedSecondary];
            system.debug('output...'+output);
           }
           else{
            output = [Select id, Description__c,Canned_Response_Title__c,Brand__c from Canned_Responses__c where Brand__c = :brand and Active__c = true and Primary_Lookup_Text__c = :selectedPrimary and Secondary_Lookup_Text__c =:selectedSecondary and Tertiary_Lookup_Text__c = :selectedTertiary];
        }
        searchText = '';
    }
    public void getSelectedDecription(){
        if(selectedTitle != '' && selectedTitle != null){
            system.debug('selectedTitle ..'+selectedTitle);    
            for(Canned_Responses__c c: output){
                if(c.id == selectedTitle){    
                    system.debug('chosenDescription....'+c.Description__c);             
                    chosenDescription = '<p class="message_body">' + c.Description__c + '</p>';
                    if (cannedMessageHeader != null)
                    {
                        if (Brand == 'chevron' && cannedMessageHeader.Chevron_Header__c != '')
                        {
                            chosenDescription = '<span class="message_header">' +cannedMessageHeader.Chevron_Header__c.replace('\n', '<br/>') + '</span>' + chosenDescription;   
                        }
                        if (Brand == 'chevron' && cannedMessageHeader.Chevron_Footer__c != '')
                        {
                            chosenDescription = chosenDescription + '<span class="message_footer">' +cannedMessageHeader.Chevron_Footer__c.replace('\n', '<br/>') + '</span>';   
                        }
                        if (Brand == 'spectrum' && cannedMessageHeader.Spectrum_Header__c != '')
                        {
                            chosenDescription = '<span class="message_header">' +cannedMessageHeader.Spectrum_Header__c.replace('\n', '<br/>') + '</span>' + chosenDescription;  
                        }
                        if (Brand == 'spectrum' && cannedMessageHeader.Spectrum_Footer__c != '')
                        {
                            chosenDescription = chosenDescription + '<span class="message_footer">' +cannedMessageHeader.Spectrum_Footer__c.replace('\n', '<br/>') + '</span>';  
                        }
                    }
                }        
            }                    
        }   
    }
    public PageReference save(){
        system.debug('calledsave');
        system.debug('wrapperLst---'+wrapperLst.size());
        //List<attachmentWrapper> wraplst = new List<attachmentWrapper>();
        //wraplst.add();    
        List <string> aId;
        Id mid;
        List<Member_Comment__c> MemberLst;   
        try{
                       
            system.debug('aid----'+aId);
            system.debug('MemberDescription----'+MemberDescription);
            if(!string.isBlank(MemberDescription)){ 
                system.debug('MemberDescription----'+MemberDescription);
                
                /*Case c = [Select AccountId, CreatedBy.Email from Case where Id =: CaseId];
                
                Account a = null;
                if (c!= null)
                {
                    a = [Select PersonEmail from Account where Id=: c.AccountId];
                }   */
                MemberLst = new List<Member_Comment__c>();         
                Member_Comment__c mbobj = new Member_Comment__c();
                mbobj.Member_Communication__c = MemberDescription;
                mbobj.Draft__c = Draft;
                mbobj.Case__c = CaseId;
                if (tempCase != null && tempCase.SecureEmail__c != null)
                {
                    //mbobj.Member_Email__c = ad.SecureEmailAddress__c;
                    mbobj.Member_Email__c = tempCase.SecureEmail__c;
                }
                else if (ad != null)// This is temporay fix until all cases are updated
                {
                    mbobj.Member_Email__c = ad.SecureEmailAddress__c;
                    //mbobj.Member_Email__c = tempCase.SecureEmail__c
                }
                mbobj.Case_Creator_Email__c = tempCase.CreatedBy.Email;

                    MemberLst.add(mbobj);
                    if(!MemberLst.isEmpty()){
                        insert MemberLst;
                        mid = MemberLst[0].id;
                    }               
                                
                system.debug('MemberLst--'+MemberLst);
            }
            if(wrapperLst.size () > 0 && wrapperLst != null){
            aId = new List<string>();
                for(attachmentWrapper wrap : wrapperLst){
                    if(wrap.checkvalue == true){                        
                        aId.add(wrap.attachmentobj.id);                                                              
                    }                    
                }
                if(!MemberLst.isEmpty()){
                    if(aId != null && aId.size() > 0){           
                        List<Attachment> Lstattachment = new List<Attachment>();
                        Lstattachment = [SELECT Id, Name, Body, ContentType FROM Attachment where id IN : aId];
                        system.debug('Lstattachment ---'+Lstattachment);
                        if(Lstattachment != null && Lstattachment.size() > 0){
                            list<Attachment> MbAttchmentLst = new list<Attachment>();
                            for(Attachment a : Lstattachment){
                                 Attachment att = new Attachment();
                                 att.name = a.name;
                                 att.body = a.body;
                                 att.Name = a.Name;
                                 att.ContentType  = a.ContentType;
                                 att.parentid = MemberLst[0].id;
                                 MbAttchmentLst.add(att);
                            }
                            insert MbAttchmentLst;
                            system.debug('MbAttchmentLst--'+MbAttchmentLst[0].id);
                        }
                        
                    }
                }                                  
            }
            PageReference nextPage = new PageReference('/' + caseId);
            return nextPage;
        }
        catch(exception e){
            system.debug('e---'+e);
        }
        return null;
    }
    public PageReference savenew(){
        //con.save();    
        save();
        //PageReference pageRef= new PageReference('/apex/Canned_Responses_For_Member_Comment');
        //pageref.getParameters().put('retURL',caseId);  
        //Schema.DescribeSObjectResult describeResult = con.getRecord().getSObjectType().getDescribe(); 
        string url = ApexPages.CurrentPage().getUrl();
        system.debug('url --'+url );
        PageReference pageRef = new PageReference(url); //pr.setRedirect(true); return pr; 
        pageRef.setRedirect(true);    
        return pageRef;
        //return null;
    }
    public pagereference cancelall(){
         PageReference nextPage = new PageReference('/' + caseId);
         return nextPage;
    }
    
    
     public class attachmentWrapper{
        public Attachment attachmentobj {get;set;}
        public Boolean checkvalue {get;set;}
        
    }
    
}