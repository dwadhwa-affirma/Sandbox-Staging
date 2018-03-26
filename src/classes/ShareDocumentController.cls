public class ShareDocumentController{

    public id caseId;
    public List<Attachment> CaseAttachmentLst {get;set;}
    //public string attchId {get;set;}
    public string caseNum {get;set;}
    public List<attachmentWrapper> wrapperLst {get;set;}
    public List<Approve_Attachment__c> approvedLst;
    public set<id> approvalids;
    Public boolean showBtn {get;set;}
    public string message {get;set;}
    
    public shareDocumentController() {
        //Id caseId = ctrl.getRecord().get('id');
        //showDeleteBtn = false;
        message = 'No attachment found for this case';
        
        caseId = ApexPages.currentPage().getParameters().get('CaseId');
        system.debug(caseId);       
        //Attachment accobj;
        If(caseId != null){        
            Case c = [select CaseNumber from case where id =: caseId limit 1];
            caseNum = c.caseNumber;
            CaseAttachmentLst = [SELECT Id, Name, Body, ContentType FROM Attachment WHERE Parentid =:caseId AND createdby.Profile.UserLicense.LicenseDefinitionKey = 'SFDC'];         
        }
        system.debug('CaseAttachmentLst.size()'+CaseAttachmentLst.size());
        wrapperLst = new List<attachmentWrapper>();
        
        if(CaseAttachmentLst.size() > 0 && CaseAttachmentLst != null){
            showBtn = true;
            
            approvedLst = new List<Approve_Attachment__c>();
            approvedLst = [select id,Case_ID__c,Attachment_Id__c from Approve_Attachment__c where Case_ID__c = : caseId AND Attachment_Id__c  != Null];
            approvalids = new set<id>();
            if(approvedLst.size() > 0 && approvedLst != null){              
                for(Approve_Attachment__c ap: approvedLst){
                    approvalids.add(ap.Attachment_Id__c);
                }
            }
            system.debug('approvalIds111--'+approvalIds);
            
            for(Attachment c : CaseAttachmentLst){
                attachmentWrapper wrapobj = new attachmentWrapper(); 
                wrapobj.attachmentobj = c;
                if(!approvalIds.isEmpty()){
                    if(approvalids.contains(c.id)){
                        system.debug('approvalIds--'+approvalIds);                    
                        wrapobj.checkvalue = true;
                    }                                       
                }
                else if(!approvalids.contains(c.id)){
                    system.debug('approvalIds333--'+approvalIds);
                    wrapobj.checkvalue = false;
                }          
                wrapperLst.add(wrapobj);
                
                
            }
            system.debug('wrapperLst--'+wrapperLst);
        }
        
    }
    
    public pagereference ShareAttchment(){
        system.debug('wrapperLst---'+wrapperLst.size());
        Map<Id,string> attachmentDetails = new Map<Id,string>();
        //set <Id> aIdchecked = new set <Id>();
        set <Id> unchecked = new set <Id>();
        try{
            if(wrapperLst.size () > 0 && wrapperLst != null){
                for(attachmentWrapper wrap : wrapperLst){
                    if(wrap.checkvalue == true){  
                        attachmentDetails.put(wrap.attachmentobj.id,wrap.attachmentobj.Name);                                                                                                             
                    }
                    else{                            
                        unchecked.add(wrap.attachmentobj.id);
                    }                    
                } 
                system.debug('attachmentDetails----'+attachmentDetails);
                if(!attachmentDetails.isEmpty()){
                    List<Approve_Attachment__c> listToInsert  = new List<Approve_Attachment__c>();
                    for(Id s : attachmentDetails.keySet()){  
                        if(!approvalids.contains(s)){ // if checked in page and not found in exisiting then only insert
                            Approve_Attachment__c obj = new Approve_Attachment__c();
                            obj.Case_ID__c = caseId;
                            obj.Attachment_Id__c = s;
                            obj.Approved_By__c = UserInfo.getUserId();
                            obj.Attachment_Name__c = attachmentDetails.get(s);
                            system.debug('attachmentDetails.get(s)---'+attachmentDetails.get(s));
                            obj.Approved_Date_Time__c = system.now();
                            listToInsert.add(obj);
                        }
                    }
                    if(!listToInsert.isEmpty()){
                        insert listToInsert;
                    }
                }
                if(!unchecked.isEmpty()){
                Set<Id> attToDelete = new Set<Id>();
                    for(string s : unchecked){
                        if(approvalids.contains(s)){ // if unchecked in page and exist in object then delete
                            attToDelete.add(s);
                        }
                    }
                    if(!attToDelete.isEmpty()){
                        List<Approve_Attachment__c> listToDelete = [select id,Case_ID__c,Attachment_Id__c from Approve_Attachment__c where Attachment_Id__c IN : attToDelete];
                            if(!listToDelete.isEmpty()){
                                DELETE listToDelete;
                            }                   
                    }            
                }           
             }            
          
        PageReference nextPage = new PageReference('/' + caseId);
        return nextPage;
        }
        catch(exception e){
            system.debug(e);
        }
        return null;
        
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