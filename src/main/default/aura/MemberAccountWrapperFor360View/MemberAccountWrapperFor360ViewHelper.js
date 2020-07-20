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
		             //Start: CRM-1400 - DB	
						var ActiveCaseList = result.accList.accList;
	        			for(var i=0; i< ActiveCaseList.length;i++){
		        			ActiveCaseList.map((obj) => {   
							obj.Category__c = "";
							obj.Account_Number__c = "";
							obj.Account = "";
							obj.Parent = "";
							obj.Account_Number__r = "";
							obj.Owner = "";
							});			
	        			}
	        		for(var i=0;i<ActiveCaseList.length;i++){
	        			ActiveCaseList[i].Category__c = ActiveCaseList[i].Category;
	        			ActiveCaseList[i].Account_Number__c = ActiveCaseList[i].AccountNumber;
	        			ActiveCaseList[i].Name = ActiveCaseList[i].AccountName;
	        			
	        			this.set(ActiveCaseList[i],'Account_Number__r.Name', ActiveCaseList[i].AccountName);
	        			this.set(ActiveCaseList[i],'Parent.CaseNumber', ActiveCaseList[i].ParentCaseNumber);
	        			this.set(ActiveCaseList[i],'Account.Name', ActiveCaseList[i].MemberName);
	        			this.set(ActiveCaseList[i],'Account_Number__r.Brand__c', ActiveCaseList[i].Brand);
	        			this.set(ActiveCaseList[i],'Owner.Name', ActiveCaseList[i].OwnerName);
	        		}    
	        		component.set("v.activecaseList", ActiveCaseList);
	            	//component.set("v.activecaseList", result.accList.accList);	            	
	            	component.set("v.activecaseListtotalrecords", result.accList.totalrecords);
				}
				else if(SectionName == 'close cases')
	            {	 
		            var CloaseCaseList = result.accList.accList;
						for(var i=0; i< CloaseCaseList.length;i++){
		        			CloaseCaseList.map((obj) => {   
							obj.Category__c = "";
							obj.Account_Number__c = "";
							obj.Account = "";
							obj.Parent = "";
							obj.Account_Number__r = "";
							obj.Owner = "";
							});					
	        		}
	        		for(var i=0;i<CloaseCaseList.length;i++){
	        			CloaseCaseList[i].Category__c = CloaseCaseList[i].Category;
	        			CloaseCaseList[i].Account_Number__c = CloaseCaseList[i].AccountNumber;
	        			CloaseCaseList[i].Name = CloaseCaseList[i].AccountName;
	        			
	        			this.set(CloaseCaseList[i],'Account_Number__r.Name', CloaseCaseList[i].AccountName);
	        			this.set(CloaseCaseList[i],'Parent.CaseNumber', CloaseCaseList[i].ParentCaseNumber);
	        			this.set(CloaseCaseList[i],'Account.Name', CloaseCaseList[i].MemberName);
	        			this.set(CloaseCaseList[i],'Account_Number__r.Brand__c', CloaseCaseList[i].Brand);
	        			this.set(CloaseCaseList[i],'Owner.Name', CloaseCaseList[i].OwnerName);
	        		}
	        		component.set("v.closecaseList", CloaseCaseList);           
	            	//component.set("v.closecaseList", result.accList.accList);	            	
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
	},
	
	set: function(obj, path, value) {
	    var schema = obj;  // a moving reference to internal objects within obj
	    var pList = path.split('.');
	    var len = pList.length;
	    for(var i = 0; i < len-1; i++) {
	        var elem = pList[i];
	        if( !schema[elem] ) schema[elem] = {}
	        schema = schema[elem];
	    }
	
	    schema[pList[len-1]] = value;
	}
})