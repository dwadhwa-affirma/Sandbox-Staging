import { LightningElement,api,track, wire } from 'lwc';
import fetchLeads from '@salesforce/apex/LeadWithCompanyController.fetchLeads';
import delSelectedLeads from '@salesforce/apex/LeadWithCompanyController.deleteLeads';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';
import {refreshApex} from '@salesforce/apex';
import { NavigationMixin } from 'lightning/navigation'; ///Navigation

const actions = [
    { label: 'Delete', name: 'delete'}
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
    {
        type: 'action',
        typeAttributes: { rowActions: actions },
    }, 
    
];

export default class WrapperClassTestNavigation extends LightningElement {
    @api recordId;
    @api result;
    @track listAccsData = [];
    @track error;
    @track columns = columns;
    refreshTable;
    @wire(fetchLeads,{lead:'$recordId'})
    relations(result) {
        this.refreshTable = result;
        if (result.data) {
            this.data = result.data;
            this.emptyList = true;
        }
    }

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
        let row = event.detail.row;
        let actionName = event.detail.action.name;
        // View a custom object record.
        switch (actionName) {
            case 'record_details':
                this.viewCurrentRecord(row);
                break;
            case 'edit':
                this.editCurrentRecord(row);
                break;
            case 'delete':
                this.deleteCons(row);
                break;
        }
    }

    viewCurrentRecord(currentRow) {
        this.bShowModal = true;
        this.isEditForm = false;
        this.record = currentRow;
    }

    editCurrentRecord(currentRow) {
        // open modal box
        this.bShowModal = true;
        this.isEditForm = true;

        // assign record id to the record edit form
        this.currentRecordId = currentRow.Id;
    }

    deleteCons(currentRow) {
        let currentRecord = [];
        currentRecord.push(currentRow.Id);
        this.showLoadingSpinner = true;

        // calling apex class method to delete the selected contact
        delSelectedLeads({listLeads: currentRecord})
        .then(result => {
            window.console.log('result ====> ' + result);
            this.showLoadingSpinner = false;

            // showing success message
            this.dispatchEvent(new ShowToastEvent({
                title: 'Success!!',
                message: currentRow.FirstName + ' '+ currentRow.LastName +' Lead deleted.',
                variant: 'success'
            }),);

            // refreshing table data using refresh apex
             return refreshApex(this.refreshTable);

        })
        .catch(error => {
            window.console.log('Error ====> '+error);
            this.dispatchEvent(new ShowToastEvent({
                title: 'Error!!', 
                message: error.message, 
                variant: 'error'
            }),);
        });
    }

}