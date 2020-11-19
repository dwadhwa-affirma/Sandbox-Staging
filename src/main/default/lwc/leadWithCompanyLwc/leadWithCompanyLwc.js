import { LightningElement,api,track, wire } from 'lwc';
import fetchLeads from '@salesforce/apex/LeadWithCompanyController.fetchLeads';
import { NavigationMixin } from 'lightning/navigation'; ///Navigation

const actions = [
    { label: 'View', name: 'show_details' },
];

const columns = [
    
    { label: 'Name', fieldName: 'nameUrl',type:'url', 
        typeAttributes: {
            label: { 
                fieldName: 'Name' 
            },
            target : '_blank'
        }
    },
    { label: 'Company', fieldName: 'Company', type: 'text', sortable:'true'  },
    { label: 'Email', fieldName: 'Email', type: 'email' , sortable:'true' },
    { label: 'Phone', fieldName: 'Phone', type: 'phone', sortable:'true'  },
    
];

export default class WrapperClassTestNavigation extends LightningElement {
    @api recordId;
    @api result;
    @track listAccsData = [];
    @track error;
    @track columns = columns;

    @wire(fetchLeads,{lead:'$recordId'})
        test({ error, data }) {
            if(data){
                this.listAccsData = data.map(record => Object.assign(
                    { "nameUrl": 'https://'+location.host+'/'+record.Id},
                    record
                ));
            }
        }
    

    navigateToRecordViewPage(event) {
        this.record = event.detail.row;
        // View a custom object record.
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: this.record.id,
                objectApiName: 'Lead', // objectApiName is optional
                actionName: 'view'
            }
        });
    }

}