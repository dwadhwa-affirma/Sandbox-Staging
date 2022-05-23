import { api, wire, track, LightningElement } from "lwc";
import Id from "@salesforce/user/Id";
import getMemberAccounts from "@salesforce/apex/CreateOpportunityController.getMemberAccounts";
import getEpisysDetails from "@salesforce/apex/CreateOpportunityController.getEpsysDetails";
import FetchLeadData from "@salesforce/apex/CreateOpportunityController.FetchLeadData";
import SearchTertiary from "@salesforce/apex/CreateOpportunityController.SearchTertiary";
import getTop10Cases from "@salesforce/apex/CreateOpportunityController.getTop10Cases";
import getQueueData from "@salesforce/apex/CreateCaseMemberPageController.getQueueData";
import getTop10CaseRecord from "@salesforce/apex/CreateOpportunityController.getTop10CaseRecord";
import selectCaseCategories from "@salesforce/apex/CreateCaseMemberPageController.selectCaseCategories";
import getData from "@salesforce/apex/CreateCaseMemberPageController.getData";
import CASE_OBJECT from "@salesforce/schema/Case";
import STANDARD_MC from "@salesforce/messageChannel/StandardMessageChannel__c";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import uploadFile from "@salesforce/apex/CreateCaseMemberPageController.uploadFile";
import uploadFiles2 from "@salesforce/apex/CreateCaseMemberPageController.uploadFiles2";
const MAX_FILE_SIZE = 24500;
import GetCaseAttachments from "@salesforce/apex/GetCaseAttachments.GetCaseAttachments"

import saveChunk from "@salesforce/apex/CreateCaseMemberPageController.saveChunk";


import {
  publish,
  subscribe,
  unsubscribe,
  APPLICATION_SCOPE,
  MessageContext,
} from "lightning/messageService";
import { NavigationMixin } from "lightning/navigation";
import getscOptions from "@salesforce/apex/CreateCaseMemberPageController.getscOptions";
import gettcOptions from "@salesforce/apex/CreateCaseMemberPageController.gettcOptions";
import getPicklistValues from "@salesforce/apex/CreateCaseMemberPageController.getPicklistValues";
import selectCaseCategoriesforTopTenTypes from "@salesforce/apex/CreateCaseMemberPageController.selectCaseCategoriesforTopTenTypes";
import saveData2 from "@salesforce/apex/CreateCaseMemberPageController.saveData2";

export default class createCaseLwc extends NavigationMixin(LightningElement) {
  @api recordId;
  @api showDorpDown = false;
  @wire(MessageContext)
  messageContext;
  showSpinner = false;
  @track filesData = [];
 

  

  subscription = null;
  receivedMessage;
  redirect = true;
  resetpage = false;
  error;
  userId = Id;
  showSpinner = false;
  showSaveEnabled = true;
  showStatusEnabled = false;
  showAssignDropdown = false;
  showQueueDropdown = false;
  showUserOwner = false;
  connectedCallbackCnt = 0;
  renderedCallbackCnt = 0;
  queueMap = {};
  queues = [];
  queuesData = [];
  memberAccounts = [];
  leadCreators = [];
  leadCreatorsMap = {};
  memberAccountMap = {};
  queueValue = "";
  queueAssignedId = "";
  episysUserId = "";
  episysUser = "";
  memberAccountValue = "";
  ownershipChangeValue = "Auto Assign";
  ownership = "Auto Assign";
  assignValue = "User";
  statusValue = "New";
  loaded = false;
  sub = "";
  searchText = "";
  searchOptions = [];
  searchValue = "";
  quickCase = "";
  quickCases = [];
  secondaryVals = [];
  caseRecordId = "";
  caseTypeId = "";
  primaryCat = "";
  secondaryCat = "";
  tertiaryCat = "";
  internalcmt = "";
  selectedText = "";
  firstval = "";
  scOptions = [];
  tcOptions = [];
  pcOptions = [];
  picklistFields = {};
  followupdate = new Date();
  subject = "";
  caseObject = CASE_OBJECT;
  followuptext = "";
  status = "Open";
  Ltk = "";
  reportNumber = "";
  email = "";
  accList = [];
  accListId = [];
  singleAccountDetail =false;
  selectedAcctNumber = {};
  accObject = {};
  isselectedAcctNumberEmpty = true;
  accountCount = 0;
  AccountObjectlist = [];
  isFileUpload = false;
  isNext = false;
  CaseNumber;
  fileNames = [];
  isNoFilesSelected = false;
  fileData = [];
  CaseId;
  IsUploadandNewPressed = false;
  

  @track caseObj = {};

  assignOptions = [
    { 'label': "User", 'value': "User" },
    { 'label': "Queue", 'value': "Queue" },
  ];

  handleQueueChange(event) {
    console.log(event.detail.value);
    this.queueValue = event.detail.value;
    console.log(this.queueValue);
  }

  handleOwnershipChange(event) {
    this.ownershipChangeValue = event.detail.value;
    console.log('testownership',this.ownershipChangeValue);
    switch (this.ownershipChangeValue) {
      case "":
      case "Auto Assign":
        this.showStatusEnabled = false;
        this.showUserOwner = false;
        this.showAssignDropdown = false;
        this.showQueueDropdown = false;
        this.resetField("Sub_Status__c");
        break;
      case "Keep":
        this.showStatusEnabled = true;
        this.showUserOwner = false;
        this.showAssignDropdown = false;
        this.showQueueDropdown = false;
        break;
      case "Assign":
        this.showStatusEnabled = false;
        this.showUserOwner = true;
        this.showAssignDropdown = true;
        this.showQueueDropdown = false;
        //this.resetField("Sub_Status__c");
        break;
    }
  }

  handleAssignChange(event) {
    if (event.detail.value == "User") {
      this.showQueueDropdown = false;
      this.showUserOwner = true;
    } else {
      this.showQueueDropdown = true;
      this.showUserOwner = false;
      this.getQueueDetails();
    }
    console.log("handleAssignChange...");
    console.log(event.detail.value);
    this.caseTypeId = event.detail.value;
    //this.loadTopCase();
  }

  handleEpisysUserIdChange(event) {
    let val = event.detail.value;
    let valNum = parseInt(val, 10);
    if (valNum > 9999) {
      this.episysUserId = 9999;
      this.resetField("Episys_User_ID__c");
    } else {
      this.episysUserId = val;
    }
  }

  handleSubjectChange(event) {
    let val = event.detail.value;
    this.subject = val;
  }

  resetField(name) {
    const inputFields = this.template.querySelectorAll("lightning-input-field");
    if (inputFields) {
      inputFields.forEach((field) => {
        if (field.fieldName === name) {
          console.log("resetting ", field);
          field.reset();
        }
      });
    }
  }

  handleLeadCreatorsChange(event) {
    console.log(event.detail.value);
    let mapKey = event.detail.value;
    if (mapKey) {
      let rec = this.leadCreatorsMap[mapKey];
      this.episysUserId = rec.Episys_ID__c;
    } else {
      this.episysUserId = "";
    }
  }

  handleMbrAcctChange(event) {
    this.memberAccountValue = event.detail.value;
  }

  handleSearchChange(event) {
    console.log("handlesearchchange...");
    console.log(event.target.value);
    debugger;
    this.getSearchOptions(event.target.value);
  }

  handleSearchRecChange(event) {
    console.log("handlesearchRecchange...");
    console.log(event);
    console.log(event.target.value);
    this.selectedText = event.target.value;
    this.loadCaseCategories();
  }
  
  handleEnter(event) {
    console.log("enter");
    console.log(event.keyCode);
    if (event.keyCode === 13) {
      this.handleSearchChange(event);
      return false;
      event.preventDefault();
    }
  }
  connectedCallback() {
    console.log(`userId: ${this.userId}`);
    // Note: If this component is NOT wrapped inside an Aura one, then recordId is not available here, so have to call handleLoad() from renderedCallback().
    if (this.recordId != undefined) {
      if (!this.loaded) {
        this.loaded = true;
        console.log(`renderedCallback recordId: ${this.recordId}`);
        this.handleLoad();
      }
    }
    console.log('pcvalue',this.primaryCat);
    this.connectedCallbackCnt++;
    this.loadQuickCases();
    console.log(
      `connectedCallback count : ${this.connectedCallbackCnt} - recordId: ${this.recordId}`
    );
    // this.subscribeMC();
    this.getAccData(this.recordId);
  }

  renderedCallback() {
    // Note: If this component is NOT wrapped inside an Aura one, then recordId must be hidden in the DOM so that it is eventually hydrated by Salesforce and this gets called when that happens.
    this.renderedCallbackCnt++;

    //console.log(`renderedCallback count : ${this.renderedCallbackCnt}`);
    if (this.recordId != undefined) {
      if (!this.loaded) {
        this.loaded = true;
        console.log(`renderedCallback recordId: ${this.recordId}`);
        this.handleLoad();
      }
    }
  }

  getQueueDetails(){
    getQueueData()
    .then((result) => {
      console.log('getQueueDetails...');
      console.log(result);
      for(var i=0; i<result.length; i++) {
        this.queuesData = [...this.queuesData ,{value: result[i].Id , label: result[i].Name}];
      }
    })
    .catch((error) => {
      console.log(error);
    });
  }

  getSearchOptions(searchText) {
    SearchTertiary({ searchText: searchText })
      .then((result) => {
        console.log("search options");
        //console.log(JSON.stringify(result));
        this.searchOptions = result;
        console.log(JSON.stringify(this.searchOptions));
        let searchList = []; //[{value: '', label:'--- None ---'}];
        result.forEach((rec) => {
          searchList.push({ value: rec, label: rec });
        });
        this.searchOptions = [...searchList];
      })
      .catch((error) => {
        console.log(error);
      });
    console.log("search options###", this.searchOptions);
  }

  getLeadDetails(id) {
    return new Promise((resolve, reject) => {
      FetchLeadData({ AccountID: id })
        .then((result) => {
          this.episysUserId = result[0].Episys_User_ID__c;
          this.episysUser = result[0].Branch_of_Lead_creator__c;
          let queueData = result[1];
          let queueList = [{ value: "", label: "--- None ---" }];
          queueData.forEach((rec) => {
            queueList.push({ value: rec.Id, label: rec.Name });
            if (!this.queueMap[rec.Id]) {
              this.queueMap[rec.Id] = rec;
            }
          });
          this.queues = [...queueList];
          console.log("------ getLeadDetails ------");
          console.log("this.episysUserId", this.episysUserId);
          console.log("this.episysUser", this.episysUser);
          console.log(result);
          console.log("---------------------------");
          console.log(queueList);
          console.log("-------- queueList above -------------------");
          console.log(this.queueMap);
          console.log("-------- queueMap above -------------------");
          resolve("Ok");
        })
        .catch((error) => {
          console.log(error);
          reject(error);
        });
    });
  }

  getEpisysData() {
    return new Promise((resolve, reject) => {
      getEpisysDetails()
        .then((result) => {
          let leadCreatorsData = [{ value: "", label: "--- None ---" }];
          for (let i = 0; i < result.length; i++) {
            let rec = result[i];
            let detail = `${rec.Episys_ID__c} - ${rec.Branch_Name__c}`;
            leadCreatorsData.push({ value: rec.Episys_ID__c, label: detail });
            if (!this.leadCreatorsMap[rec.Episys_ID__c]) {
              this.leadCreatorsMap[rec.Episys_ID__c] = rec;
            }
          }
          this.leadCreators = [...leadCreatorsData];

          console.log("----------this.leadCreatorsMap  -----------------");
          console.log(this.leadCreatorsMap);

          resolve("Ok");
        })
        .catch((error) => {
          console.log(error);
          reject(error);
        });
    });
  }

  getAccData(id){
    this.accountCount = 0;
    getData({ accoutid: id })
        .then((result) => {
          console.log('getAccData');
          console.log(result.accountDetails.PersonEmail);
          
          
          this.selectedAcctNumber = this.memberAccountValue;

          this.accList = this.memberAccountValue;
        
          this.email = result.accountDetails.PersonEmail;
          
          var aList = result.accList;
          
          this.accObject = result.accountDetails;
          aList.map((obj) => {   
            obj.isShow = true;
          }) 
            
          this.accList = aList;
          console.log('aList.length...');
          console.log(aList.length);
          
          if(this.accList.length == 2){
            this.isselectedAcctNumberEmpty = false;
          }

          if(this.accList.length == 2){
            for(var i = 0; i < aList.length; i++){
              if(aList[i].RecType__c == 'ACCT'){
                var serverResult = this.accList;
                var selItem = serverResult[0];
                console.log(selItem);
                if(selItem){
                  this.selectedAcctNumber = selItem;
                }
              }
            }
          }
          
         
        })
        .catch((error) => {
          console.log('getAccData');
          console.log(error);
        });
  }

  getAccountData(id) {
    return new Promise((resolve, reject) => {
      getMemberAccounts({ AccountId: id })
        .then((result) => {
          console.log('getAccountData...');
          console.log(result);
          let memberAccountData = [];
          for (let i = 0; i < result.length; i++) {
            let rec = result[i];
            let accountDetail = `${rec.RecType__c} | ${rec.TypeTranslate__c} | ${rec.Brand__c}`;
            let key = `${rec.Name} | ${accountDetail}`;
            memberAccountData.push({ value: key, label: accountDetail });
            if (!this.memberAccountMap[key]) {
              this.memberAccountMap[key] = rec;
            }
            
          }
          this.memberAccounts = [...memberAccountData];
          if (this.memberAccounts.length == 1) {
            this.memberAccountValue = memberAccountData[0].value;
          }
          console.log("------------ memberAccountValue -------------------");
          console.log(this.memberAccountValue);
          console.log("------------ this.memberAccountMap -------------------");
          console.log(this.memberAccountMap);

          resolve("ok");
        })
        .catch((error) => {
          console.log(error);
          reject(error);
        });
    });
  }

  async handleLoad() {
    console.log(`handleLoad recordId: ${this.recordId}`);
    let id = this.recordId;
    await this.getAccountData(id);
    await this.fetchPicklistFields();
    
  }

  loadQuickCases() {
    getTop10Cases()
      .then((result) => {
        console.log("search options");
        //console.log(JSON.stringify(result));
        this.quickCases = result;
        //console.log(JSON.stringify(this.quickCases));
        let caseList = [{ value: "", label: "--- None ---" }];
        let secondaryList = [{ value: "", label: "--- None ---" }];

        result.forEach((rec) => {
          console.log(JSON.stringify(rec));
          caseList.push({ value: rec.Case_Type__c, label: rec.Case_Type__c });
          secondaryList.push({
            value: rec.Id,
            label: rec.Secondary_Category__c,
          });
        });

        this.secondaryVals = [...secondaryList];
      })
      .catch((error) => {
        console.log(error);
      });
  }

  closeAction() {
    const payload = { origin: "CaseQuickAction", action: "Close" };
    publish(this.messageContext, STANDARD_MC, payload);
  }

  handleSubmit(event) {
    // Mimics CreateCaseController.CaseInsertUpdate behavior.
    event.preventDefault();
    this.showSpinner = true;

    let fields = event.detail.fields;
    console.log(this.memberAccountValue);
    console.log(this.memberAccountMap[this.memberAccountValue].Id);

    fields.CloseDate = "2049-12-31";
    fields.Name = "Name";
    if (this.memberAccountValue.includes("Pre-Member")) {
      // This is a Pre-Member and does not have Account_Detail__c
      console.log("This is a Pre-Member and does not have Account_Detail__c");
      fields.Member_Account__c = "";
    } else {
      fields.Member_Account__c =
        this.memberAccountMap[this.memberAccountValue].Id;
    }
    fields.AccountId = this.recordId;
    fields.StageName = this.statusValue;
    fields.Episys_User_ID__c = this.episysUserId;
    fields.Branch_of_Lead_creator__c = this.episysUser;
    fields.subject = this.subject;
    fields.followuptext = this.followuptext;
    fields.followupdate = this.followupdate;



    console.log(
      fields.subject,
      fields.Ownership__c,
      fields.Episys_User_ID__c,
      fields.Episys_User_ID__c,
      fields.Branch_of_Lead_creator__c,
      fields.User_Owner__c
    );
    console.log("Future_Date__c:", fields.Future_Date__c);
    console.log("Follow_up_Text__c:",fields.Follow_up_Text__c);
    console.log("Follow_up_Date__c:",fields.Follow_up_Date__c);


    switch (this.ownershipChangeValue) {
      case "":
      case "Auto Assign":
        fields.Queue_Owner__c = null;
        break;
      case "Keep":
        fields.User_Owner__c = this.userId;
        fields.Queue_Owner__c = null;
        break;
      case "Assign":
        console.log("[A] ", this.queueAssignedId);
        console.log('[B] ', this.queueMap[this.queueAssignedId].Name);
        fields.Queue_Owner__c       = this.queueMap[this.queueAssignedId].Name;
        fields.Queue_Assigned_Id__c = this.queueAssignedId;
        break;
    }
    debugger;
   
    this.template.querySelector("lightning-record-edit-form").submit(fields);
  }

  showNotification(id) {
    const evt = new ShowToastEvent({
      title: "Success",
      message: `Case saved successfully`,
      variant: "success",
    });
    this.dispatchEvent(evt);
  }
  handleOnchange(event){
    console.log('##handle status',event.detail.value);
    this.status = event.detail.value;
  }
  handleOnchangesubject(event){
    console.log('##handle status',event.detail.value);
    this.subject =  event.detail.value;
  }
  handleOnchangefollowuptext(event){
    console.log('##handle followuptext',event.detail.value);
    this.followuptext =  event.detail.value;
  }
  handleOnchangeinternalcomment(event){
    console.log('##handle followuptext',event.detail.value);
    this.internalcmt =  event.detail.value;
  }
  handleOnchangefollowupDate(event){
    console.log('##handle followupdate',event.detail.value);
    this.followupdate = event.detail.value;
  }
  handleOnchangeticket(event){
    console.log('##handle ticket',event.detail.value);
    this.Ltk = event.detail.value;
  }
  handleOnchangereportingnumber(event){
    console.log('##handle reporting number',event.detail.value);
    this.reportNumber = event.detail.value;

  }

  handleSuccess(event) {
    this.showSaveEnabled = false;
    this.showSpinner = false;
    debugger;
    console.log(`Success - Case Id ${event.detail.id} created.`);
    this.showNotification(event.detail.id);
    this.caseRecordId = event.detail.id;
    this.navigateToCasePage();
    
    this.closeAction();
    
  }
 

  navigateToCasePage() {
    this[NavigationMixin.Navigate]({
      type: "standard__recordPage",
      attributes: {
        recordId: this.caseRecordId,
        objectApiName: "Case",
        actionName: "view",
      },
    });
  }

  handleError(event) {
    this.showSpinner = false;
    console.log("onerror: ", event.detail);
    console.log(event.message);
    console.log(event.detail.output.fieldErrors);
    console.log(JSON.stringify(event.detail));
    console.log(event.detail.detail);
  }
   preventDefaults(event) {
    event.preventDefault(); 
    this.fields = event.detail.fields;
  }
  
  print() {
    console.log("##in method");
    // alert('###this method');
    this.handleReset();
  }
 

  loadTopCase() {
    console.log("loadTopCase...");
    console.log(this.caseTypeId);
    getTop10CaseRecord({ recId: this.caseTypeId })
      .then((result) => {
        console.log("search options");
        console.log(result);
        console.log(result.Primary_Category__c);
        this.template.querySelector('[data-id="Primary_Category__c"]').value =
          result.Primary_Category__c;
        this.template.querySelector('[data-id="Secondary_Category__c"]').value =
          result.Secondary_Category__c;
        this.template.querySelector('[data-id="Tertiary_Category__c"]').value =
          result.Tertiary_Category__c;
        
        this.internalcmt = result.Internal_Comments__c;
        this.firstval = result[0].Secondary_Category__c;
        console.debug();
      })
      .catch((error) => {
        console.log(error);
      });
  }

  loadCaseCategories() {
    console.log("loadCaseCategories...");
    console.log(this.selectedText);
    selectCaseCategories({ selectedText: this.selectedText })
      .then((result) => {
        console.log(result);
        var selectedTextArray = this.selectedText.split(" / ");
       
        this.primaryCat = selectedTextArray[0];
        this.secondaryCat = selectedTextArray[1];
        this.tertiaryCat = selectedTextArray[2];
      })
      .catch((error) => {
        console.log(error);
      });
  }

  changePrimaryCategory(event) {
    var pcValue = event.target.value;
    console.log(event.target.value);
    this.primaryCat = pcValue;
    getscOptions({ pcValue: pcValue })
      .then((result) => {

        console.log(result);
        this.scOptions = result;
        this.Secondary_Category__c = null;
        this.Tertiary_Category__c = null;
        var tcOptions = [{ Text: "--- None ---", Value: "" }];

        this.tcOptions = tcOptions;
      })
      .catch((error) => {
        console.log(error);
      });
  }

  changeSecondaryCategory(event) {
    var scValue = event.target.value;
    console.log(event.target.value);
    this.secondaryCat = scValue;
    gettcOptions({ scValue: scValue })
      .then((result) => {
        console.log(result);
        this.tcOptions = result;
        this.Tertiary_Category__c = null;
      })
      .catch((error) => {
        console.log(error);
      });
  }
  changeTirtaryCategory(event){
    var tcValue = event.target.value;
    this.tertiaryCat = tcValue;
  }
  selectfileupload(event){    	
    var ischecked = event.target.checked;
    this.checked = ischecked;
  }
  handleChangecheckbox(event) {
    this.isFileUpload = event.target.checked;
    //this.NextClick();
  }
  handleisNext(event){    	
    
    this.saveClicked();
    this.showNotification();
  }
  

openfileUpload(event){
  const files = event.target.files;
  var fileNames = new Array();
  
  if (event.target.files.length > 0) {
      for(var i = 0; i < event.target.files.length; i++)
      {
        
        let file = event.target.files[i]; 
        fileNames.push(file.name); 
        let reader = new FileReader();
                reader.onload = k => {
                    var fileContents = reader.result.split(',')[1]
                    this.filesData.push({'fileName':file.name, 'fileContent':fileContents});                    
                };
        reader.readAsDataURL(file); 
                 
      }
      
  }
  if(files.length == 0){
    this.isNoFilesSelected = true;
  }
  else{
    this.isNoFilesSelected = false;
  }
  this.fileNames = [...fileNames];

}

handleclickattechment(event){
  if(this.isNoFilesSelected == true){
    alert('Please Select a Valid File');
  }
  else{

  }


}

 

/*
Test from line 885 to 942
*/
handleFileUploaded(event) {
  if (event.target.files.length > 0) {
      for(var i=0; i< event.target.files.length; i++){
          if (event.target.files[i].size > MAX_FILE_SIZE) {
              this.showToast('Error!', 'error', 'File size exceeded the upload size limit.');
              return;
          }
          let file = event.target.files[i];
          let reader = new FileReader();
          reader.onload = e => {
              var fileContents = reader.result.split(',')[1]
              this.filesData.push({'fileName':file.name, 'fileContent':fileContents});
          };
          reader.readAsDataURL(file);
      }
  }
}

uploadFiles2(event) {
  if(event.target.label == "Upload Attachment"){
    this.IsUploadandNewPressed = false;
  }
  else{
    this.IsUploadandNewPressed = true;
  }
  
  if(this.filesData == [] || this.filesData.length == 0) {
      this.showToast('Error', 'error', 'Please select files first'); return;
  }
  this.showSpinner = true;
  uploadFiles2({
      recordId : this.CaseId,
      filedata : JSON.stringify(this.filesData)
  })
  .then(result => {
      console.log(result);
      if(result && result == 'success') {
          this.filesData = [];
          this.showToast('Success', 'success', 'Files Uploaded successfully.');
          if(!this.IsUploadandNewPressed){
            this[NavigationMixin.Navigate]({
              type: 'standard__recordPage',
              attributes: {
                  recordId:this.CaseId,
                  objectApiName:'Case',
                  actionName:'view'
              }
            })
          }
          else{
                  this.isNext = false;
                  this.isFileUpload = false;
                  this.handleReset();
          }
          
      } else {
          this.showToast('Error', 'error', result);
      }
  }).catch(error => {
      if(error && error.body && error.body.message) {
          this.showToast('Error', 'error', error.body.message);
      }
  }).finally(() => this.showSpinner = false );
  
}
CaseAttachments(){
  console.log("inside Case Attachment");
  GetCaseAttachments({
    CaseId : this.recordId,
})
.then(result => {
    console.log(result);
    if(result && result == 'success') {
        this.filesData = [];
        this.showToast('Success', 'success', 'Files Uploaded successfully.');
    } else {
        this.showToast('Error', 'error', result);
    }
}).catch(error => {
    if(error && error.body && error.body.message) {
        this.showToast('Error', 'error', error.body.message);
    }
}).finally(() => this.showSpinner = false );
}

removeReceiptImage(event) {
  var index = event.currentTarget.dataset.id;
  this.filesData.splice(index, 1);
}

showToast(title, variant, message) {
  this.dispatchEvent(
      new ShowToastEvent({
          title: title,
          variant: variant,
          message: message,
      })
  );
}
toast(title){
  const toastEvent = new ShowToastEvent({
    title,
    variant:"success"
  })
  this.dispatchEvent(toastEvent)
}
  fetchPicklistFields() {
    var NAFields = ["Primary_Category__c"];
    this.picklistFields["Case"] = NAFields;
    this.getPicklistValues(this.picklistFields);

    var scOptions = [{ Text: "--- None ---", Value: "" }];
    this.scOptions = scOptions;
    this.tcOptions = scOptions;
  }

  getPicklistValues(sobjFieldsmap) {
    getPicklistValues({ objpicklistFieldsMap: JSON.stringify(sobjFieldsmap) })
      .then((result) => {
        console.log(result);
        var obj;
        for (obj in result) {
          var objName = result[obj];
          console.log("object name --> " + obj);
          var field;
          for (field in objName) {
            console.log("fields --> " + field);
            var optionValues = objName[field];
            console.log("options --> " + optionValues);
            this.buildPicklist(obj + "." + field, optionValues);
          }
        }
      })
      .catch((error) => {
        console.log(error);
      });
  }

  buildPicklist(elementId, optionValues) {
    var opts = [];
    if (optionValues != undefined && optionValues.length > 0) {
      opts.push({
        class: "optionClass",
        Text: "--- None ---",
        Value: "",
      });
    }

    for (var i = 0; i < optionValues.length; i++) {
      opts.push({
        class: "optionClass",
        Value: optionValues[i],
        Text: optionValues[i],
      });
    }
    this.pcOptions = opts;
    
  }

  changeTopTenCase(event) {
    var stc = event.target.value;

    var alltoptencategories = this.quickCases;
    console.log("alltoptencategories:" + alltoptencategories);
    for (var i = 0; i < alltoptencategories.length; i++) {
      if (alltoptencategories[i].Case_Type__c === stc) {
        var pc = alltoptencategories[i].Primary_Category__c;
        var sc = alltoptencategories[i].Secondary_Category__c;
        var tc = alltoptencategories[i].Tertiary_Category__c;
        var subject = alltoptencategories[i].Subject__c;
        var internalcomment = alltoptencategories[i].Internal_Comments__c;
        
        console.log(pc);
        console.log(sc);
        console.log(tc);
        this.primaryCat = pc;
        this.secondaryCat = sc;
        this.tertiaryCat = tc;

      selectCaseCategoriesforTopTenTypes({ PrimaryText: pc , SecondaryText: sc })
      .then((result) => {
        console.log(result);        
        var secopts = result.scOptions;
        for(var j=0; j< secopts.length;j++){
          if(secopts[j].Value == sc){
            secopts[j].isSelected = true;
          }
          else{
            secopts[j].isSelected = false;
          }
        }
        var teropts = result.tcOptions;
        for(var k=0; k< teropts.length;k++){
          if(teropts[k].Value == tc){
            teropts[k].isSelected = true;
          }
          else{
            teropts[k].isSelected = false;
          }
        }
        this.scOptions = [...secopts];
        this.tcOptions = [...teropts];

        this.template.querySelector('[data-id="Primary_Category__c"]').value = pc;          
        this.template.querySelector('[data-id="Secondary_Category__c"]').value = sc;          
        this.template.querySelector('[data-id="Tertiary_Category__c"]').value = tc; 
         
        this.internalcmt = internalcomment; 
            
        this.subject = subject;  
      })
      .catch((error) => {
        console.log(error);
      });
      }
    }
    console.log('pcvalue',this.primaryCat);

  }
  isInputValid() {
    let isValid = true;
    let inputFields = this.template.querySelectorAll('.slds-select');

    console.log('Testinput',inputFields);
    inputFields.forEach(inputField => {
        if(!inputField.checkValidity()) {
            inputField.reportValidity();
            isValid = false;
        }
       // this.contact[inputField.name] = inputField.value;
    });
    return isValid;
  }

saveClicked(){
  if(this.isInputValid()) {
    console.log('this.contact');
  console.log('saveClicked...');
  console.log('pcvalue',this.primaryCat);
  console.log(this.primaryCat);
  console.log(this.secondaryCat);
  console.log(this.tertiaryCat); 
 // console.log(this.memberAccountMap[this.memberAccountValue].Id);
 // console.log(this.memberAccounts);
  console.log(this.subject);
  console.log(this.followuptext);
  console.log(this.status);
  console.log(this.followupdate);
  console.log(this.Ltk);
  console.log(this.reportNumber);
  console.log(this.accList); 
 // console.log('queueValue...');
 // console.log(this.queueValue);
  console.log('##selectedAccountnumber',this.selectedAcctNumber);
  console.log(this.internalcmt);

  
  var a= this.accList;
  console.log('accList...');
  console.log(this.accList);
  var aList = [];
  a[1].isShow = false;
  for(var i=0;i<a.length;i++){
    if(a[i].isShow==false){
      aList[i] = a[i].Id;
    }
  }
  var aListToPass = [];
  for(var i=0;i<aList.length;i++){
    if(aList[i]){
      aListToPass[i] = aList[i];
    }
  }
  console.log('##selectedAcctNumber',this.selectedAcctNumber);
  console.log(aListToPass);
  console.log('##alist',aList.length);
  if(this.selectedAcctNumber == null || this.selectedAcctNumber == '' || this.selectedAcctNumber == undefined ){
    console.log('##123list',aList);

    const event = new ShowToastEvent({
      title: 'Error!',
      message: 'Account Number is required',
      variant: 'error'
  
  });
  this.dispatchEvent(event);
  return false;
  }
 
  saveData2({primaryCat: this.primaryCat, secondaryCat: this.secondaryCat, teritaryCat: this.tertiaryCat,followuptext: this.followuptext, followupdate: this.followupdate, comments: this.internalcmt, status: this.status, brand: '', subStatus: 'Day1 Started', reportNumber: this.reportNumber, Ltk: this.Ltk, description: '', subject: this.subject, accId: this.recordId, selectedAcctNumberId: aList, queueValue: this.queueValue ,caseownership: this.ownershipChangeValue })
  .then((result) => {
    console.log(result);
    console.log('###result');
    console.log(result.CaseId);
    this.CaseNumber = result.CaseNumber;
    this.CaseId = result.CaseId;
      if(this.isFileUpload == false){
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId:result.CaseId,
                objectApiName:'Case',
                actionName:'view'
            }
        })
      }
      if(this.isFileUpload == true){
        this.handleReset();
        this.isNext = true;
        this.isFileUpload = false;
      }

  })
  .catch((error) => {
    console.log(error);
  });
}
}
saveAndNewClick(){
  console.log("saveandnew");
  this.saveClick();

  
}
handleReset() {
  console.log("reset");


var a= this.accList;
for(var i=0;i<a.length;i++){            	  
  a[i].isShow=true;            	   
}               
this.accList = [...a];   

 
this.isselectedAcctNumberEmpty =true;

var acc = this.AccountObjectlist;
var length = this.accountCount;
acc.splice(0,parseInt(length));
this.AccountObjectlist = [...acc];
this.accountCount = 0;
 this.selectedAcctNumber = {};
 this.searchText= null;
 this.searchValue = null;
 this.followuptext = "";
 this.followupdate = new Date();
 this.Ltk = "";
 this.reportNumber="";
 this.subject = "";
 this.status="";
  this.searchValue = "";
  this.internalcmt = "";
 
  this.memberAccountValue ="";
  this.queueValue = "";
  const inputFields = this.template.querySelectorAll("lightning-input-field");
  console.log('##handelresetlast');
  if (inputFields) {
    inputFields.forEach((field) => {
      field.reset();

    });
  }

  if(this.template.querySelector('[data-id="Primary_Category__c"]') != null){
    const selectFieldsPrimary = this.template.querySelector('[data-id="Primary_Category__c"]').value='';
    if (selectFieldsPrimary) {
      selectFieldsPrimary.forEach((field) => {
        field.reset();
    
      });
    }
  }
  
  
  if(this.template.querySelector('[data-id="Secondary_Category__c"]') != null){
    const selectFieldsSecondary = this.template.querySelector('[data-id="Secondary_Category__c"]').value='';
    var Seccoptions =  this.scOptions;
    for(var i=0;i<Seccoptions.length;i++){
      Seccoptions[i].isSelected = false;
    }
    if (selectFieldsSecondary) {
      selectFieldsSecondary.forEach((field) => {
        field.reset();
    
      });
    }
  }
  
  if(this.template.querySelector('[data-id="Tertiary_Category__c"]') != null){
    const selectFieldsTertiary = this.template.querySelector('[data-id="Tertiary_Category__c"]').value='';
    var Tercoptions =  this.tcOptions;
    for(var i=0;i<Tercoptions.length;i++){
      Tercoptions[i].isSelected = false;
    }
    if (selectFieldsTertiary) {
      selectFieldsTertiary.forEach((field) => {
        field.reset();
    
      });
    }
  }
  
  if(this.template.querySelector('[data-id="Quick_case"]') != null){
    const selectFieldsQuickcase = this.template.querySelector('[data-id="Quick_case"]').value='';
    if (selectFieldsQuickcase) {
      selectFieldsQuickcase.forEach((field) => {
        field.reset();
    
      });
    }
  }
  
  if(this.template.querySelector('[data-id="Search_Result"]') != null){
    const selectFieldsSearchResult = this.template.querySelector('[data-id="Search_Result"]').value='';
    if (selectFieldsSearchResult) {
      selectFieldsSearchResult.forEach((field) => {
        field.reset();
    
      });
    }
  }
}

saveClick() {
  if(this.isInputValid()) {
    console.log('this.contact');

//console.log('testsldsselect',inputFields);
  console.log('saveClicked...');
  console.log(this.primaryCat);
  console.log(this.secondaryCat);
  console.log(this.tertiaryCat); 
 // console.log(this.memberAccountMap[this.memberAccountValue].Id);
 // console.log(this.memberAccounts);
  console.log(this.subject);
  console.log(this.followuptext);
  console.log(this.status);
  console.log(this.followupdate);
  console.log(this.Ltk);
  console.log(this.reportNumber);
 // console.log(this.accList); 
 // console.log('queueValue...');
  console.log(this.queueValue);
  
  console.log('##selectedAccountnumber',this.selectedAcctNumber);
  
  var a= this.accList;
  var aList = [];
  a[1].isShow = false;
  for(var i=0;i<a.length;i++){
    if(a[i].isShow==false){
      aList[i] = a[i].Id;
    }
  }
  
  var aListToPass = [];
  for(var i=0;i<aList.length;i++){
    if(aList[i]){
      aListToPass[i] = aList[i];
    }
  }
  console.log(aListToPass);
  console.log('##alist',aList);
  if(this.selectedAcctNumber == null || this.selectedAcctNumber == '' || this.selectedAcctNumber == undefined ){
    console.log('##123list',aList);

    const event = new ShowToastEvent({
      title: 'Error!',
      message: 'Account Number is required',
      variant: 'error'
  
  });
  this.dispatchEvent(event);
  return false;
  }
  
  saveData2({primaryCat: this.primaryCat, secondaryCat: this.secondaryCat, teritaryCat: this.tertiaryCat,followuptext: this.followuptext, followupdate: this.followupdate, comments: this.internalcmt, status: this.status, brand: '', subStatus: 'Day1 Started', reportNumber: this.reportNumber, Ltk: this.Ltk, description: '', subject: this.subject, accId: this.recordId, selectedAcctNumberId: aList, queueValue: this.queueValue ,caseownership: this.ownershipChangeValue })
  .then((result) => {
    console.log(result);
    console.log('###resultsavedata2');
    console.log(result.CaseId);
    this.handleReset();
  })
  .catch((error) => {
    console.log(error);
  });
}
}

NextClick() {
  if(this.isInputValid()) {
    console.log('this.contact');
  console.log('saveClicked...');
  console.log(this.primaryCat);
  console.log(this.secondaryCat);
  console.log(this.tertiaryCat); 
  console.log(this.subject);
  console.log(this.followuptext);
  console.log(this.status);
  console.log(this.followupdate);
  console.log(this.Ltk);
  console.log(this.reportNumber);
  console.log(this.queueValue);
  
  console.log('##selectedAccountnumber',this.selectedAcctNumber);
  
  var a= this.accList;
  var aList = [];
  a[1].isShow = false;
  for(var i=0;i<a.length;i++){
    if(a[i].isShow==false){
      aList[i] = a[i].Id;
    }
  }
  
  var aListToPass = [];
  for(var i=0;i<aList.length;i++){
    if(aList[i]){
      aListToPass[i] = aList[i];
    }
  }
  console.log(aListToPass);
  console.log('##alist',aList);
  if(aList.length == 0 ){
    console.log('##123list',aList);

    const event = new ShowToastEvent({
      title: 'Error!',
      message: 'Account Number is required.....',
      variant: 'error'
  
  });
  this.dispatchEvent(event);
  }
  
  saveData2({primaryCat: this.primaryCat, secondaryCat: this.secondaryCat, teritaryCat: this.tertiaryCat,followuptext: this.followuptext, followupdate: this.followupdate, comments: this.internalcmt, status: this.status, brand: '', subStatus: 'Day1 Started', reportNumber: this.reportNumber, Ltk: this.Ltk, description: '', subject: this.subject, accId: this.recordId, selectedAcctNumberId: aList, queueValue: this.queueValue ,caseownership: this.ownershipChangeValue })
  .then((result) => {
    console.log(result);
    console.log('###resultsavedata2');
    console.log(result.CaseId);
  })
  .catch((error) => {
    console.log(error);
  });
}
}
  changeSelectedCategory(event){

    var selectedText = event.target.value;
    selectCaseCategories({ selectedText: selectedText })
    .then((result) => {
      var secopts = result.scOptions;      
      var selectedTextArray  = selectedText.split(' / ');
      
      for(var j=0; j< secopts.length;j++){
        if(secopts[j].Value == selectedTextArray[1]){
          secopts[j].isSelected = true;
        }
        else{
          secopts[j].isSelected = false;
        }
      }
      var teropts = result.tcOptions;
      for(var k=0; k< teropts.length;k++){
        if(teropts[k].Value == selectedTextArray[2]){
          teropts[k].isSelected = true;
        }
        else{
          teropts[k].isSelected = false;
        }
      }
      this.primaryCat = selectedTextArray[0];
      this.secondaryCat = selectedTextArray[1];
      this.tertiaryCat = selectedTextArray[2];
      this.scOptions = [...secopts];
      this.tcOptions = [...teropts];

      this.template.querySelector('[data-id="Primary_Category__c"]').value = selectedTextArray[0];
    })
    .catch((error) => {
      console.log(error);
    });
  }

  get tabClass() {    
    return this.showDorpDown ? 'undefined lookup__menu uiAbstractList uiAutocompleteList uiInput uiAutocomplete uiInput--default uiInput--lookup class1' : 'undefined lookup__menu uiAbstractList uiAutocompleteList uiInput uiAutocomplete uiInput--default uiInput--lookup class2';
  }

  get isselectedAcctNumberEmpty(){    
    return this.selectedAcctNumber  ? true : false
  }

  set isselectedAcctNumberEmpty(value){
    this.isselectedAcctNumberEmpty = value;
  }

  set tabClass(value) {
    this.tabClass = value;
 }

  onBlurLookup(event){
    this.showDorpDown = false;   
    
  }

  onFocusLookup(event){
    this.showDorpDown = true; 
  }

  clearSelection(){
    var acc = this.selectedAcctNumber;
    var a= this.accList;
    for(var i=0;i<a.length;i++){
      if(a[i].Id == acc.Id){
        a[i].isShow=true;
      }
    }
    this.selectedAcctNumber = {};
    this.accList = [...a];
    this.isselectedAcctNumberEmpty = true;
  }

  itemSelected(event){
    var target = event.target;   
    console.log('in li...');
    console.log(JSON.stringify(event.target));
    console.log(JSON.stringify(event.target.parentElement.closest('li').dataset));
    console.log(JSON.stringify(event.target.parentElement.closest('li').dataset.selectedindex));

    var SelIndex = event.target.parentElement.closest('li').dataset.selectedindex;
    console.log(SelIndex);
    if(SelIndex){
      console.log('in if...');
      console.log(this.accList);
      var serverResult = this.accList;
      var selItem = serverResult[SelIndex];
      if(selItem){
         this.selectedAcctNumber = selItem ;
         this.showDorpDown = false;
         var a= this.accList;
         for(var i=0;i<a.length;i++){
           
           if(a[i].Id == selItem.Id){
             a[i].isShow=false;
             this.accListId = a[i].Id;
           }
         }
         this.accList = [...a];
         console.log(this.accList);
         console.log(this.accListId);
         this.isselectedAcctNumberEmpty = false;
         
      } 
  } 
  }

    getIndexFrmParent(target,attributeToFind){
      var SelIndex = target.getAttribute(attributeToFind);
      while(!SelIndex){
          target = target.parentNode ;
          SelIndex = getIndexFrmParent(target,helper,attributeToFind);           
      }
      return SelIndex;
  }

  addMemberAccount(){
    var count = this.accountCount;
      if(count < 9)
      {
            var AccountObjectlist =  this.AccountObjectlist;    	
            AccountObjectlist.push({'Account_Details__c': '','Id':null, 'isEmpty': true});
            this.AccountObjectlist = [...AccountObjectlist];
            count = count + 1;
            this.accountCount = count;
      }
  }
  clearSelectionAdditional(event){
    var acc = this.AccountObjectlist;
    var target = event.target; 
    var SelIndex = event.target.parentElement.closest('span').dataset.account;
    if(SelIndex){
      var serverResult = this.accList;  
      var selItem = acc[SelIndex];
        acc[SelIndex]= [{'Account_Details__c': '','Id':null, 'isEmpty': true}];
        var a= this.accList;
        for(var i=0;i<a.length;i++){
          if(a[i].Id == selItem.Id){
            a[i].isShow=true;
          }
        }
        for (var len = 0; len < acc.length; len++) {         
          acc[len].isEmpty = true;        
       }
        this.accList = [...a];
        this.AccountObjectlist= [...acc];
      }
  }

  onFocusLookupAdditional(event){
    var index = parseInt( event.target.getAttribute("data-class") );
      var autodiv = event.target.nextElementSibling;
      if(autodiv != undefined && autodiv != null){
        autodiv.style.display = '';
      }
      else{
        autodiv = event.target;
        autodiv.style.display = '';
      }
  }

  onBlurLookupAdditional(event){
    var index = parseInt( event.target.getAttribute("data-class") );
    var autodiv = event.target.nextElementSibling;
    if(autodiv != undefined && autodiv != null){
      autodiv.style.display = 'none';
    }
    else{
      autodiv = event.target;
      autodiv.style.display = 'none';
    }
  }

  itemSelectedAdditional(event){
    var target = event.target;
    var SelIndexid = event.target.parentElement.closest('div .dropdownadditionaaccount').dataset.class;
    var SelIndex = event.target.parentElement.closest('li').dataset.selectedindexid;

    if(SelIndex){
      var serverResult = this.accList;
      var selItem = serverResult[SelIndex];
       var acc = this.AccountObjectlist;    
      if(selItem){
          for (var len = 0; len < acc.length; len++) { 
             if(acc[len].Id== null && len == SelIndexid )
             {
               acc[len] = selItem;
               break;
             }
             acc[len].isEmpty = false;
            
          }
         
         this.AccountObjectlist= [...acc];
          var a= this.accList;
         for(var i=0;i<a.length;i++){
           if(a[i].Id == selItem.Id){
             a[i].isShow=false;           
           }
         }
         this.accList = [...a];
         console.log('additional');
        console.log(this.accList);
        }
     
    
  }
  }

  removeMemberAccount(event){
    var target = event.target.dataset.indexid;
    var AccountObjectlist =  this.AccountObjectlist; 
    var a= this.accList;
    for(var i=0;i<a.length;i++){
      if(a[i].Id == AccountObjectlist[target].Id){
        a[i].isShow=true;
      }
    }
    this.accList = [...a];
    AccountObjectlist.splice(parseInt(target),1);
    
    this.AccountObjectlist = [...AccountObjectlist];
    var count = this.accountCount;
    count = count - 1;
    this.accountCount = count;
  }
}