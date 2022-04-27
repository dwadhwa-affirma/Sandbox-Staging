({
    myAction : function(component, event, helper) {
        
    },
    doInit : function(component, event, helper) {      
    	 var action = component.get('c.SNAILSetting'); 
    	
    	 action.setCallback(this, function(a){
            var state = a.getState(); // get the response state
           
            if(state == 'SUCCESS') {
            var res = a.getReturnValue();
            var objsetting = res['SnailSetting'];
            var userstatus = res['UserStatus'];
            component.set("v.IsUserInGroup",userstatus);
             for(var i = 0 ; i < objsetting.length;i++){
             
                 if(objsetting[i].Name == 'BDI' && objsetting[i].Hidden__c == false){
                     
                	 component.set('v.ischk1',true);
                 }
            	 if(objsetting[i].Name == 'Salesforce' && objsetting[i].Hidden__c == false){
                	 component.set('v.ischk2',true);
                 }
                 if(objsetting[i].Name == 'Onbase' && objsetting[i].Hidden__c == false){
                	 component.set('v.ischk3',true);
                 }
                 if(objsetting[i].Name == 'Other' && objsetting[i].Hidden__c == false){
                	 component.set('v.ischk4',true);
                 }
                 if(objsetting[i].Name == 'OOW' && objsetting[i].Hidden__c == false){
                	 component.set('v.ischk5',true);
                 }
            	 component.set('v.ischk6',true);
                 component.set('v.ischk7',true);
                 component.set('v.ischk8',true);
                 component.set('v.ischk9',true);
                 component.set('v.ischk10',true);
                 component.set('v.ischk11',true);
            	
             }
            	
            	
            }
        });
        $A.enqueueAction(action);
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
        
        if(capturedCheckboxName == 'eStatements' && component.find("chk11").get("v.checked") == true){
            component.set("v.NotEstatements", false);
            for(var i = 0 ; i < selectedCheckBoxes.length;i++){
            	component.find("chk1").set("v.checked", false);
                component.find("chk5").set("v.checked", false);
                component.find("chk6").set("v.checked", false);
                component.find("chk7").set("v.checked", false);
                component.find("chk8").set("v.checked", false);
                component.find("chk9").set("v.checked", false);
                component.find("chk10").set("v.checked", false);                
            }   
        }
        else{            
            component.find("chk11").set("v.checked", false);
            component.set("v.NotEstatements", true);
        }
        
        component.set("v.selectedCheckBoxes", selectedCheckBoxes);
        component.set("v.NotEstatements", true);
        //alert('Selected--'+selectedCheckBoxes);
    },
    
    BtnFetchData:function(component, event, helper) {
        debugger;
        var todate=component.get('v.todate');
        var fromdate=component.get('v.fromdate');
        var keyword =component.get('v.keyword');
        var today = $A.localizationService.formatDate(new Date(), "YYYY-MM-DD");
        /*var recid = component.get('v.recordId');
        if(component.get('v.selectedCheckBoxes') == ''){
            
            var action = component.get('c.getListSSN'); 
            action.setParams({
                recid:recid,
            });
            action.setCallback(this, function(a){       
            var state = a.getState(); // get the response state          
                if(state == 'SUCCESS') {
                    var result = a.getReturnValue();
                    if(result != null && result != ''){
                        for(var i = 0; i < result.length; i++){
                            window.open("https://brsconbaseweb1.ctxcu.org/AppNet/docpop/docpop.aspx?KT101_0_0_0="+result[i]+"&clienttype=activex&doctypeid=129", '_blank');
                        }
                    }    
                }            
        	}); 
        	$A.enqueueAction(action); 
        }*/
        
        component.set('v.dateinvalid',false);
        if(keyword == 'Date Range' && (fromdate == "" || fromdate == null) && (todate == "" || todate == null)){
        	component.set('v.dateinvalid',true);
        }
        else if(keyword == 'Date Range' && fromdate > todate && fromdate > today){
        	component.set('v.dateinvalid',true);
        }
        
        else{
        	 helper.fetchAllData(component,event,helper);
        }
        component.set("v.NotEstatements", true);
       
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
        
        
    },
    getSelected: function(component, event, helper) {
    	
        var selectedRows = event.getParam('selectedRows'); 
        
        if(selectedRows.length == 0){
            component.set("v.NotEstatements", true);
        }
        else{
            component.set("v.NotEstatements", false);
        }
        
        var setRows = [];
        for ( var i = 0; i < selectedRows.length; i++ ) {
            
            setRows.push(selectedRows[i]);

        }
        component.set("v.selectedRecords", setRows);
      
    },
    handleSelectedRecords: function(component, event, helper) {
    	
        var url = window.location.href;
        var records = component.get("v.selectedRecords");
        var recordId = component.get("v.recordId");
        var selectedEstatements = [];
        
        for(var i = 0; i < records.length; i++ ){
            selectedEstatements[i] = records[i];
        }
        helper.showSpinner(component);
        if(selectedEstatements == ''){
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                title : 'Warning',
                message: 'Please Select at least one eStatement!',
                duration:' 1000',
                key: 'info_alt',
                type: 'Warning',
                mode: 'pester'
            });
            toastEvent.fire();
        }
        else if(selectedEstatements.length > 0){
            
            var action = component.get("c.processSelectedEstatements");
            action.setParams({
                "doclist" : selectedEstatements,
                "recordId" : recordId
            });
            action.setCallback(this, function(result){
                var state = result.getState();
                var obj = result.getReturnValue();
                if (component.isValid() && state === "SUCCESS"){
                    //window.close();                                        
                    for(var i=0;i<obj.length;i++){
                         window.open(obj[i]);
                    }                    
                    //window.open(url);                    
                    /*var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        title : 'Success',
                        message: 'eStatements have been set Successfully',
                        duration:' 1000',
                        key: 'info_alt',
                        type: 'success',
                        mode: 'pester'
                    });
                    toastEvent.fire();*/
                }
                helper.hideSpinner(component);
            });
            $A.enqueueAction(action);            
        }	
    }   
    
})