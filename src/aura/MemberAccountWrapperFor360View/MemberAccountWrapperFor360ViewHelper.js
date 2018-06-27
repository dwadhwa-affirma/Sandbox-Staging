({
	Pagination: function(component, SectionName, PageNo, PageSize, accid,SortBy,SortDir,SearchText) {
		if(SortDir == 'Desc')
	    	SortDir = 'Desc NULLS LAST';
	    else if(SortDir == 'ASC')
	    	SortDir = 'ASC NULLS FIRST';
	    var action = component.get("c.GetPagingData");	    
	    action.setParams({
	    	"accid" : accid,
	        "PageNo": PageNo,
	        "PageSize":PageSize	,
	        "SectionName":SectionName,
	        "SortDir":SortDir,
	        "SortBy":SortBy,
	        "SearchText":SearchText      
	    });	    
	    
	    
	    action.setCallback(this, function(response){
	    	var state = response.getState();
	    	component.set("v.loading", false);	        
	        if (state === "SUCCESS") {
	        
	            var result =  response.getReturnValue();
	            if(SectionName == 'accList')
	            {	            
	            	component.set("v.accList", result.accList.accList);    
	            	component.set("v.accListtotalrecords", result.accList.totalrecords);
				}
				else if(SectionName == 'related persons')
	            {	            
	            	component.set("v.contactList", result.accList.accList);	            	
	            	component.set("v.contactListtotalrecords", result.accList.totalrecords);
				}
				else if(SectionName == 'cardList')
	            {	            
	            	component.set("v.cardList", result.accList.accList);	            	
	            	component.set("v.cardListtotalrecords", result.accList.totalrecords);
				}
				else if(SectionName == 'active cases')
	            {	            
	            	component.set("v.activecaseList", result.accList.accList);	            	
	            	component.set("v.activecaseListtotalrecords", result.accList.totalrecords);
				}
				else if(SectionName == 'close cases')
	            {	            
	            	component.set("v.closecaseList", result.accList.accList);	            	
	            	component.set("v.closecaseListtotalrecords", result.accList.totalrecords);
				}
				else if(SectionName == 'Case Comments')
	            {	            
	            	component.set("v.casecommentsList", result.accList.accList);	            	
	            	component.set("v.casecommentsListtotalrecords", result.accList.totalrecords);
				}
				else if(SectionName == 'Active Tasks')
	            {	            
	            	component.set("v.taskList", result.accList.accList);	            	
	            	component.set("v.taskListtotalrecords", result.accList.totalrecords);
				}
				else if(SectionName == 'Warning/Comments')
	            {	            
	            	component.set("v.worningcommentsList", result.accList.accList);	            	
	            	component.set("v.worningcommentsListtotalrecords", result.accList.totalrecords);
				}
	        }	 
	        else
	        {
	        }
	               
	    });
	    component.set("v.loading", true);
	    $A.enqueueAction(action);
	},
	MasterCardPagination: function(component, SectionName, PageNo, PageSize,SortBy,SortDir,SearchText,account,card){
		if(SortDir == 'Desc')
	    	SortDir = 'Desc NULLS LAST';
	    else if(SortDir == 'ASC')
	    	SortDir = 'ASC NULLS FIRST';
		 var action = component.get("c.GetMasterCardAlertsData");	    
	    action.setParams({	    	
	        "PageNo": PageNo,
	        "PageSize":PageSize,	       
	        "SortDir":SortDir,
	        "SortBy":SortBy,
	        "SearchText":SearchText,
	        "Account": account,
	        "Card":card      
	    });	    
	    
	    
	    action.setCallback(this, function(response){
	    	var state = response.getState();
	    	component.set("v.loading", false);	        
	        if (state === "SUCCESS") {
	        	var result =  response.getReturnValue();
	        	component.set("v.mastercardAlertsList", result.accList);	            	
	            component.set("v.mastercardAlertsListtotalrecords", result.totalrecords);
	            component.set("v.IsShowMasterCardAlert",true);
	        }
	        else if (status === "ERROR") {
                var errors = response.getError();
                //console.error(errors);
            }  
	      });
	       component.set("v.loading", true);
	    $A.enqueueAction(action);
	}
})