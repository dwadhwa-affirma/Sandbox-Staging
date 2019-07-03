({
    myAction : function(component, event, helper) {
        
    },
    doInit : function(component, event, helper) {        
     
    },
    
    handleNext : function(component, event, helper) { 
        var pageNumber = component.get("v.pageNumber");
        component.set("v.pageNumber", pageNumber+1);
        helper.getData(component, helper);
    },
    onSingleSelectChange: function(cmp) {
         var selectCmp = cmp.find("InputSelectSingle");
          cmp.set('v.isfromto', false);
          cmp.set('v.todate',null);
          	cmp.set('v.fromdate',null);
         if( selectCmp.get("v.value") == "Date Range"){
        	 cmp.set('v.isfromto', true);
         }
	 },
    handlePrev : function(component, event, helper) {        
        var pageNumber = component.get("v.pageNumber");
        component.set("v.pageNumber", pageNumber-1);
        helper.getData(component, helper);
    },
    callCheckboxMethod : function(component, event, helper) {      
        var capturedCheckboxName = event.getSource().get("v.value");
        var selectedCheckBoxes =  component.get("v.selectedCheckBoxes");
        if(selectedCheckBoxes.indexOf(capturedCheckboxName) > -1){            
            selectedCheckBoxes.splice(selectedCheckBoxes.indexOf(capturedCheckboxName), 1);           
        }
        else{
            selectedCheckBoxes.push(capturedCheckboxName);
        }
        component.set("v.selectedCheckBoxes", selectedCheckBoxes);
        //alert('Selected--'+selectedCheckBoxes);
    },
    
    BtnFetchData:function(component, event, helper) {
        
        helper.fetchAllData(component,event,helper);
       
    },
    BtnMergeData :function(component, event, helper) {
        component.set('v.loaded', true);
        helper.MergeData(component,event,helper);
        component.set('v.loaded', false);
       
    },
     updateColumnSorting: function (cmp, event, helper) {
        cmp.set('v.loaded', true);
        // We use the setTimeout method here to simulate the async
        // process of the sorting data, so that user will see the
        // spinner loading when the data is being sorted.
        setTimeout(function() {
            var fieldName = event.getParam('fieldName');
            var sortDirection = event.getParam('sortDirection');
            cmp.set("v.sortedBy", fieldName);
            cmp.set("v.sortedDirection", sortDirection);
            helper.sortData(cmp, fieldName, sortDirection,event, helper);
            cmp.set('v.loaded', false);
        }, 0);
    },
    
    GridInit: function (cmp, event, helper) {
        //helper.fetchData(cmp,event,helper);
        
        
        // var fetchData = {
        //     userId: "userId",
        //     id: "id",
        //     title: "title",
        //     completed: "completed",
        //     // opportunityName: "company.companyName",
        //     // accountName : "name.findName",
        //     // closeDate : "date.future",
        //     // amount : "finance.amount",
        //     // contact: "internet.email",
        //     // phone : "phone.phoneNumber",
        //     // website : "internet.url",
        //     // status : {type : "helpers.randomize", values : [ 'Pending', 'Approved', 'Complete', 'Closed' ] },
        //     // actionLabel : {type : "helpers.randomize", values : [ 'Approve', 'Complete', 'Close', 'Closed' ]},
        //     // confidenceDeltaIcon : {type : "helpers.randomize", values : [ 'utility:up', 'utility:down' ]}
        // };
        
        
    }
    
    
})