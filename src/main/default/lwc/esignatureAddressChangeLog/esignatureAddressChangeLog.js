import { LightningElement, wire, api ,track} from "lwc";
import SPECTRUMLOGO from '@salesforce/resourceUrl/Logo_SpectrumCU';
import CHEVRONLOGO from '@salesforce/resourceUrl/ChevronLogo';
//1. import the methods getRecord and getFieldValue
import { getRecord, getFieldValue } from "lightning/uiRecordApi";

//2. Import reference to the object and the fields
import BRAND_FIELD from "@salesforce/schema/AddressChangeLog__c.Brand__c";


const fields = [BRAND_FIELD];

export default class esignatureAddressChangeLog extends LightningElement {
    @api attachmentId='true';
    @track default='authwrapDiv';
    @track eSignDiv;
    @track authwrapDiv1;
    eSignDiv ='eSignDiv';
    authwrapDiv1='authwrapDiv1';
    @api recordId;
    @wire(getRecord, {
        recordId: "$recordId",
        fields
      })
      AddressChangeLog__c;
      
      connectedCallback(){
        var today = new Date();
        this.date=today.toLocaleDateString("en-US");
        console.log(today.toISOString());
        this.authwrap='authwrapDiv';
        //this.eSignDiv='display:none';
    }
      renderedCallback() {
        console.log(this.AddressChangeLog__c.data);
      }
     
      chevronlogo = CHEVRONLOGO;
      spectrumlogo = SPECTRUMLOGO;
      get brand() {
     let brandvalue= getFieldValue(this.AddressChangeLog__c.data, BRAND_FIELD);
     
       return brandvalue;
       
      }
     get brandname(){
      
        if ( this.brand=='Spectrum')
        {
            return true;
        }
        else{
            return false; 
        }
        
    }
    

        addSignClass() {
         
          this.default='eSignDiv';

      
        }
  
       
         //var eSignDiv=component.find("eSignDiv");
             // $A.util.removeClass(eSignDiv, 'hidediv');
              //$A.util.addClass(eSignDiv, 'showdiv');
      
          //var authwrapDiv=component.find("authwrap");
              //$A.util.removeClass(authwrapDiv, 'showdiv');
             // $A.util.addClass(authwrapDiv,'hidediv'); 
      //}
  //}
      
}