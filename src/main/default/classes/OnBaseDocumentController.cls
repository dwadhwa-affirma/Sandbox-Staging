public with sharing class OnBaseDocumentController{
  @AuraEnabled
  public static caseAttachments getAttachmentData(String caseId){
    List<OnBase_Supported_Extensions__c> supportedExtSetting = OnBase_Supported_Extensions__c.getall().values();
    set<string> supportedFileExtSet = new set<string>();
    for (OnBase_Supported_Extensions__c extObj : supportedExtSetting){
      supportedFileExtSet.Add(extObj.Name);
    }


    List<Attachment> CaseAttachmentLst = new List<Attachment>();
    List<ContentDocumentLink> ContentDocumentLst = new List<ContentDocumentLink>();
    List<OnBaseAttachments> onbaseDocumentList = new List<OnBaseAttachments>();
    Boolean IsInValidDocumentAvailable = false;
    string caseNum = '';
    caseAttachments objCaseAttach = new caseAttachments();
    objCaseAttach.AccountNumberNotAvailable = false;
    If (caseId != null){
      Case c = [select CaseNumber, Account_Number__c
          from case
          where id = :caseId
          limit 1];
      if (c.Account_Number__c == null){
        objCaseAttach.AccountNumberNotAvailable = true;
      } else{
        objCaseAttach.AccountNumberNotAvailable = false;
      }

      caseNum = c.caseNumber;
      CaseAttachmentLst = [SELECT Id, Name, ContentType
                     FROM Attachment
                     WHERE Parentid = :caseId];

      List<OnBase_Document__c> documentList = [select Id, Name, Document_Name__c, Attachment_Id__c, Document_Type__c, IsMovedToOnBase__c, Attachment_Created_On__c, Member_Comment__r.CreatedBy.Profile.Name
                                         from OnBase_Document__c
                                         where (Case__c = :caseId or Member_Comment__r.Case__C = :caseId) and IsMovedToOnBase__c = :false];
      for (OnBase_Document__c onbaseAttch : documentList){
        if (onbaseAttch.Member_Comment__c != null && onbaseAttch.Member_Comment__r.CreatedBy.Profile.Name != 'Messaging center Customers'){
          Continue;
        }
        system.debug('onbaseAttch---' + onbaseAttch.Member_Comment__r.CreatedBy.Profile.Name);
        OnBaseAttachments obj = new OnBaseAttachments();

        obj.Id = onbaseAttch.Id;
        obj.Name = (onbaseAttch.Document_Name__c != null) ? onbaseAttch.Document_Name__c : onbaseAttch.Name;
        obj.DocumentType = onbaseAttch.Document_Type__c;
        obj.IsMovedToOnBase = onbaseAttch.IsMovedToOnBase__c;
        obj.downloadLink = '/servlet/servlet.FileDownload?file=' + string.valueOf(onbaseAttch.Attachment_Id__c) + '&operationContext=S1';
        obj.LastModifiedDate = onbaseAttch.Attachment_Created_On__c.format('MM/dd/yyyy');
        if (supportedFileExtSet.contains(obj.Name.substringAfterLast('.').toLowerCase()) || supportedFileExtSet.contains(obj.Name.substringAfterLast('.').toUpperCase())){
          if (c.Account_Number__c == null){
            obj.IsOnBaseSupportedFile = false;
          } else{
            obj.IsOnBaseSupportedFile = true;
          }
        } else{
          obj.IsOnBaseSupportedFile = false;
        }

        if (IsInValidDocumentAvailable == false && obj.IsOnBaseSupportedFile == false){
          IsInValidDocumentAvailable = true;
        }
        onbaseDocumentList.add(obj);
      }


    }


    objCaseAttach.caseNumber = caseNum;
    objCaseAttach.onbaseDocuments = onbaseDocumentList;
    objCaseAttach.IsInValidDocumentAvailable = IsInValidDocumentAvailable;
    return objCaseAttach;
  }

  @AuraEnabled
  public static void saveAttachments(string wrapperString, string caseId, List<string> approvalids){
    system.debug('caseId :: ' + caseId);
    List<OnBaseAttachments> onbaseAttachList = (List<OnBaseAttachments>)JSON.deserialize(wrapperString, List<OnBaseAttachments>.class);


    List<OnBase_Document__c> onbaseListToInsert = new List<OnBase_Document__c>();

    if (onbaseAttachList.size() > 0 && onbaseAttachList != null){

      List<OnBase_Document__c> repeatedDocumentList = [select Id, Document_Name__c, Member_Comment__r.CreatedBy.Profile.Name
                                                 from OnBase_Document__c
                                                 where (Case__c = :caseId or Member_Comment__r.Case__C = :caseId) and Member_Comment__c != null and Member_Comment__r.CreatedBy.Profile.Name != 'Messaging center Customers' and IsMovedToOnBase__c = :false];
      system.debug('repeatedDocumentList :: ' + repeatedDocumentList);

      Map<String, OnBase_Document__c> otherMemberComAttachMap = new Map<String, OnBase_Document__c>();
      set<string> otherMemberComAttachAddedId = new set<string>();
      for (OnBase_Document__c onbaseObj : repeatedDocumentList){
        otherMemberComAttachMap.put(onbaseObj.Document_Name__c, onbaseObj);
      }

      for (OnBaseAttachments onbaseObj : onbaseAttachList){
        system.debug('DocumentType :: ' + onbaseObj.DocumentType);
        OnBase_Document__c onbaseDocObj = new OnBase_Document__c();
        onbaseDocObj.Id = onbaseObj.id;
        onbaseDocObj.Document_Type__c = onbaseObj.DocumentType;
        onbaseDocObj.Move_To_OnBase_Date__c = system.now();

        onbaseListToInsert.add(onbaseDocObj);

        if (otherMemberComAttachMap.containsKey(onbaseObj.Name)){
          OnBase_Document__c repeatedDoc = otherMemberComAttachMap.get(onbaseObj.Name);
          if(!otherMemberComAttachAddedId.contains(repeatedDoc.id)){
            repeatedDoc.Document_Type__c = onbaseObj.DocumentType;
            onbaseListToInsert.add(repeatedDoc);
            otherMemberComAttachAddedId.add(repeatedDoc.id);
          }          
        }
      }
      system.debug('onbaseListToInsert :: ' + onbaseListToInsert);
      update onbaseListToInsert;

    }
  }

  public class OnBaseAttachments{
    @AuraEnabled
    public string Id{ get; set; }

    @AuraEnabled
    public string Name{ get; set; }

    @AuraEnabled
    public string DocumentType{ get; set; }

    @AuraEnabled
    public boolean IsMovedToOnBase{ get; set; }

    @AuraEnabled
    public string downloadLink{ get; set; }

    @AuraEnabled
    public string LastModifiedDate;

    @AuraEnabled
    public boolean IsOnBaseSupportedFile{ get; set; }

  }

  public class caseAttachments{
    @AuraEnabled
    public List<OnBaseAttachments> onbaseDocuments{ get; set; }

    @AuraEnabled
    public String caseNumber{ get; set; }

    @AuraEnabled
    public set<id> approvalids{ get; set; }

    @AuraEnabled
    public Boolean IsInValidDocumentAvailable{ get; set; }

    @AuraEnabled
    public Boolean AccountNumberNotAvailable{ get; set; }

  }

  @AuraEnabled
  public static Map<String, Map<String, List<String>>> getPicklistValues(String objpicklistFieldsMap){

    Map<String, List<String>> objPickmap = (Map<String, List<String>>)JSON.deserialize(objpicklistFieldsMap, Map<String, List<String>>.class);


    Map<String, Map<String, List<String>>> objFieldPicklistMap = new Map<String, Map<String, List<String>>>();
    List<String> sobjectslist = new List<String>(objPickmap.keySet());
    Schema.DescribeSobjectResult[] results = Schema.describeSObjects(sobjectslist);
    Map<String, List<String>> fieldOptionsMap;

    for (Schema.DescribeSObjectResult result : results){
      fieldOptionsMap = new Map<String, List<String>>();

      Schema.sObjectType objType = result.getSObjectType();

      Schema.DescribeSObjectResult objDescribe = objType.getDescribe();
      map<String, Schema.SObjectField> fieldMap = objDescribe.fields.getMap();
      List<String> objFieldlist = objPickmap.get(result.getName());
      //system.debug('objname ' + result.getName());
      //system.debug('list of fields ' + objFieldlist);
      for (String fld : objFieldlist){
        //system.debug('fields ' + fld);
        List<String> allOpts = new list<String>();
        list<Schema.PicklistEntry> values = fieldMap.get(fld).getDescribe().getPickListValues();

        for (Schema.PicklistEntry a : values){
          allOpts.add(a.getValue());
        }
        fieldOptionsMap.put(fld, allOpts);
      }

      objFieldPicklistMap.put(result.getName(), fieldOptionsMap);
    }
    return objFieldPicklistMap;
  }

}