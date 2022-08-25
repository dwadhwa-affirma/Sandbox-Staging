import { LightningElement, wire, api, track } from "lwc";
import SPECTRUMLOGO from '@salesforce/resourceUrl/Logo_SpectrumCU';
import CHEVRONLOGO from '@salesforce/resourceUrl/ChevronLogo';
import { NavigationMixin } from 'lightning/navigation';
import { getRecord, getFieldValue } from "lightning/uiRecordApi";

import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getIntakePickListValuesList from '@salesforce/apex/eSignatureAddressChangeLogHelper.getPickListValuesIntoList';
import getIdentificationpickListValuesList from '@salesforce/apex/eSignatureAddressChangeLogHelper.getPickListValuesIntoListIdentification';
import getInPersonSigningDetails from '@salesforce/apex/AddressChangeLogController.getInPersonSigningDetails';
import saveSignature from '@salesforce/apex/AddressChangeLogController.saveSignature';
let isDownFlag,
    isDotFlag = false,
    prevX = 0,
    currX = 0,
    prevY = 0,
    currY = 0;

let x = "#0000A0"; //blue color

let y = 1.5; //weight of line width and dot.

let canvasElement, ctx; //storing canvas context
let dataURL, convertedDataURI; //holds image data

export default class esignatureAddressChangeLog extends NavigationMixin(LightningElement){
    
    @api recordId;    
    @track inPersonSigningDetails = [];
    @track brandName;
    @track date;
    @track isMemberSignatureClicked = false;
    @api ContentVersionData;
    @api contentVersionId;
    @track defaultloadpage = true;
    @track isLogoChevron = false;
    @track Creditunion = true;
    @track intakePicklistOptions;
    @track identificationPicklistOptions;
    @track intakeCheckboxValue;
    @track identificationCheckboxValue;
    @track isMemberSignatureClicked = false;
    constructor() {
        super();
        // this.template.addEventListener('mousemove', this.handleMouseMove.bind(this));
        // this.template.addEventListener('mousedown', this.handleMouseDown.bind(this));
        // this.template.addEventListener('mouseup', this.handleMouseUp.bind(this));
        // this.template.addEventListener('mouseout', this.handleMouseOut.bind(this));
    }
    connectedCallback(){
        var today = new Date();
        this.date = today.toLocaleDateString("en-US");
        this.getInPersonSigningDetailsMethodCall();
        this.getIntakePickListValuesListMethodCall();
        this.getIdentificationpickListValuesListMethodCall();
        //this.selectIntakeCheckbox();
                
        }
        renderedCallback(){
            canvasElement = this.template.querySelector('canvas');
           // ctx = canvasElement.getContext("2d");
            //this.selectIntakeCheckbox();
        }

        
        getInPersonSigningDetailsMethodCall(){
            getInPersonSigningDetails( {
                inPersonSigningId: this.recordId})
                .then(result => {
                    if(result.length > 0){
                        this.intakeCheckboxValue = result[0].Clean_Up_Intake_Method__c;
                        this.identificationCheckboxValue = result[0].Identification_Method__c;
                        if(this.intakeCheckboxValue != undefined){
                            this.selectIntakeCheckbox();
                        }
                        if(this.identificationCheckboxValue != undefined){
                            this.selectIdentificationCheckbox(this.identificationCheckboxValue);
                        }
                        if(result[0].Brand__c == 'Chevron'){
                            this.isLogoChevron =  true;
                            this.brandName = CHEVRONLOGO;
                        }else{
                            this.isLogoChevron =  false;
                            this.brandName = SPECTRUMLOGO;
                        }
                        this.error = undefined;
                    }
                    
                    
                })
                .catch(error => {
                    this.error = error;
                });

        }
        getIntakePickListValuesListMethodCall(){
            getIntakePickListValuesList()
                .then(result => {
                    if(result.length > 0){
                        let theOptions = result;
                        let intakePicklistValue=[];
                        for (let i = 0; i< theOptions.length; i++){
           
                            intakePicklistValue.push(theOptions[i]) ;
                            console.log('picklist intake=='+intakePicklistValue);
                         }
                         this.intakePicklistOptions=intakePicklistValue;
                         console.log('picklistOptions=='+ this.intakePicklistOptions); 
                        this.error = undefined;
                    }
                    
                    
                })
                .catch(error => {
                    this.error = error;
                });

        }
        getIdentificationpickListValuesListMethodCall(){
            getIdentificationpickListValuesList()
                .then(result => {
                    if(result.length > 0){
                        let theOptions = result;
                        let identificationPicklistValue=[];
                        for (let i = 0; i< theOptions.length; i++){
           
                            identificationPicklistValue.push(theOptions[i]) ;
                            console.log('picklist identification=='+identificationPicklistValue);
                         }
                         this.identificationPicklistOptions=identificationPicklistValue;
                         console.log('picklistOptions=='+ this.identificationPicklistOptions); 
                        this.error = undefined;
                    }
                    
                    
                })
                .catch(error => {
                    this.error = error;
                });

        }
        selectIntakeCheckbox(){

            let i;
            let checkboxes = this.template.querySelectorAll('[data-id="In Person Request"]');
            for(i=0; i< checkboxes.length; i++) {
                checkboxes[i].checked = true;
            }
        }
        selectIdentificationCheckbox(val){

            let i;
            let qs = '[data-id="'+ val +'"]';            
            let checkboxesid = this.template.querySelectorAll(qs);
            for(i=0; i< checkboxesid.length; i++) {
              checkboxesid[i].checked = true;
            }
        }
        memberSignatureClicked(){
            this.isMemberSignatureClicked = true;
            this.defaultloadpage = false;
            this.Creditunion = false;
        }
        handleClearClick() {
            ctx.clearRect(0, 0, canvasElement.width, canvasElement.height);
        }
         //handler for mouse move operation
    handleMouseMove(event) {
        this.searchCoordinatesForEvent('move', event);
    }

    //handler for mouse down operation
    handleMouseDown(event) {
        this.searchCoordinatesForEvent('down', event);
    }

    //handler for mouse up operation
    handleMouseUp(event) {
        this.searchCoordinatesForEvent('up', event);
    }

    //handler for mouse out operation
    handleMouseOut(event) {
        this.searchCoordinatesForEvent('out', event);
    }
    searchCoordinatesForEvent(requestedEvent, event) {
        event.preventDefault();
        if (requestedEvent === 'down') {
            this.setupCoordinate(event);
            isDownFlag = true;
            isDotFlag = true;
            if (isDotFlag) {
                this.drawDot();
                isDotFlag = false;
            }
        }
        if (requestedEvent === 'up' || requestedEvent === "out") {
            isDownFlag = false;
        }
        if (requestedEvent === 'move') {
            if (isDownFlag) {
                this.setupCoordinate(event);
                this.redraw();
            }
        }
    }

    setupCoordinate(eventParam) {
        const clientRect = canvasElement.getBoundingClientRect();
        prevX = currX;
        prevY = currY;
        currX = eventParam.clientX - clientRect.left;
        currY = eventParam.clientY - clientRect.top;
    }

    redraw() {
        ctx.beginPath();
        ctx.moveTo(prevX, prevY);
        ctx.lineTo(currX, currY);
        ctx.strokeStyle = x; //sets the color, gradient and pattern of stroke
        ctx.lineWidth = y;
        ctx.closePath(); //create a path from current point to starting point
        ctx.stroke(); //draws the path
    }
    //this draws the dot
    drawDot() {
        ctx.beginPath();
        ctx.fillStyle = x; //blue color
        ctx.fillRect(currX, currY, y, y); //fill rectrangle with coordinates
        ctx.closePath();
    }
    handleSaveClick() {
        //set to draw behind current content
        ctx.globalCompositeOperation = "destination-over";
        ctx.fillStyle = "#FFF"; //white
        ctx.fillRect(0, 0, canvasElement.width, canvasElement.height);
       
        //convert to png image as dataURL
        dataURL = canvasElement.toDataURL("image/png");
        //convert that as base64 encoding
        convertedDataURI = dataURL.replace(/^data:image\/(png|jpg);base64,/, "");
        this.ContentVersionData = convertedDataURI;
        //call Apex method imperatively and use promise for handling sucess & failure
        this.isSpinner = true;
        this.saveSignMethodCall();
    }   
    
    saveSignMethodCall(){
        saveSignature({
            signatureBody: this.ContentVersionData,
            recordId: this.recordId
        })
            .then(result => {
                this.contentVersionId = result;
                 
                this[NavigationMixin.GenerateUrl]({
                    type: 'standard__webPage',
                    attributes: {
                        url: '/apex/ESignatureAC?id=' + this.recordId
                    }
                }).then(generatedUrl => {
                    //window.open(generatedUrl,"_self");
                    window.location.href = generatedUrl;
                });                
                
            })
            .catch(error => {
                console.log('error : ', error);
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error creating Salesforce File record',
                        message: error.body.message,
                        variant: 'error',
                    }),
                );
            })
            .finally(() => {
                this.isSpinner = false;
            });
    }
   


    
   
   
    



    
   

    

    
}