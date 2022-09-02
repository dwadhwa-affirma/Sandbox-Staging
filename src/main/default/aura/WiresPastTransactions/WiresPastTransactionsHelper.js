({
	/*getPastWires : function(component) {
		var action = component.get("c.GetPastWires");
		var recordId = component.get("v.recordId");	
		
		action.setParams({
		"WiresId": recordId
		});
			debugger;
			action.setCallback(this, function(resp) {				
			var state=resp.getState();			
			if(state === "SUCCESS"){	
			debugger;	
				var res = resp.getReturnValue();
				console.log(res);               
				component.set("v.PastWireTransactions", res.PastWireTransactions);									 			
			}
		});
		
		$A.enqueueAction(action);
	},*/
    
    setupDataTable: function (component) {
        component.set('v.columns', [
            {label: 'Wire Number', fieldName: 'WireNumber',sortable : false, type: 'text'},
            {label: 'Sent Date', fieldName: 'SentDate',sortable : false, type: 'date-local', typeAttributes: {day: '2-digit',
                                                                                                                     month: '2-digit',
                                                                                                                     year: 'numeric',
                                                                                                                    }},
            {label: 'From Account', fieldName: 'FromAccount',sortable : false, type: 'text'},
            {label: 'Recipient Account', fieldName: 'RecipientAccount',sortable : false, type: 'text'},
            {label: 'Amount', fieldName: 'Amount', sortable : false, type: 'currency',typeAttributes: { currencyCode: 'USD', maximumSignificantDigits: 5}},
            {label: 'Recipient', fieldName: 'Recipient', sortable : false, type: 'text'}
        ]);
    },
    
    getData: function (component) {
        return this.callAction(component)
            .then(
                $A.getCallback(imageRecords => {
                    component.set('v.allData', imageRecords);
                    component.set('v.filteredData', imageRecords);
                    this.preparePagination(component, imageRecords);
                })
            )
            .catch(
                $A.getCallback(errors => {
                    if (errors && errors.length > 0) {
                        $A.get("e.force:showToast")
                            .setParams({
                                message: errors[0].message != null ? errors[0].message : errors[0],
                                type: "error"
                            })
                            .fire();
                    }
                })
            );
    },
 
    callAction: function (component) {
        component.set("v.isLoading", true);
        return new Promise(
            $A.getCallback((resolve, reject) => {
                const action = component.get("c.GetPastWires");
                var recordId = component.get("v.recordId");	
		
                action.setParams({
                "WiresId": recordId
                });
                action.setCallback(this, response => {
                    component.set("v.isLoading", false);
                    const state = response.getState();
                    if (state === "SUCCESS") {
                        return resolve(response.getReturnValue().PastWireTransactions);
                    } else if (state === "ERROR") {
                        return reject(response.getError());
                    }
                    return null;
                });
                $A.enqueueAction(action);
            })
        );
    },
 
    preparePagination: function (component, imagesRecords) {
        let countTotalPage = Math.ceil(imagesRecords.length/component.get("v.pageSize"));
        let totalPage = countTotalPage > 0 ? countTotalPage : 1;
        component.set("v.totalPages", totalPage);
        component.set("v.currentPageNumber", 1);
        this.setPageDataAsPerPagination(component);
    },
 
    setPageDataAsPerPagination: function(component) {
        let data = [];
        let pageNumber = component.get("v.currentPageNumber");
        let pageSize = component.get("v.pageSize");
        let filteredData = component.get('v.filteredData');
        let x = (pageNumber - 1) * pageSize;
        for (; x < (pageNumber) * pageSize; x++){
            if (filteredData[x]) {
                data.push(filteredData[x]);
            }
        }
        component.set("v.tableData", data);
    },
        
    handleSort: function(cmp, event) {
        var fieldName = event.getParam('fieldName');
        var sortDirection = event.getParam('sortDirection');        
        var data = cmp.get("v.tableData");
        //var reverse = sortDirection !== 'asc';
        
        data = Object.assign([],
                             data.sort(this.sortBy(fieldName, sortDirection === 'asc' ? 1 : -1))
                            );
        cmp.set("v.tableData", data);
        cmp.set('v.sortDirection', sortDirection);
        cmp.set('v.sortedBy', fieldName);        
        this.getData(cmp)
    },
        
    sortBy: function (field, reverse, primer) {
        
        var key = primer
        ? function(x) { return primer(x[field]) }
        : function(x) { return x[field] };
        
        return function (a, b) {
            var A = key(a);
            var B = key(b);
            return reverse * ((A > B) - (B > A));
        };
    },
})