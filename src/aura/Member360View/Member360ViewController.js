({
	 doInit : function(component, event, helper) {
		
        
        var action = component.get("c.GetAllData");
        var recordid = component.get("v.Id");
        action.setParams({ "accid": recordid });

        action.setCallback(this, function (response) {
        
        	var status = response.getState();
            component.set("v.loading", false);
            if (component.isValid() && status === "SUCCESS") {
            	
            	var result = response.getReturnValue();
            	component.set("v.accList", result.accList.accList);
        		component.set("v.accListtotalrecords", result.accList.totalrecords);
        		if(result.accList.totalrecords == 0) 
        		{
        			component.set("v.accListIsHidden", true);
        		}
        		else
        		{
        			component.set("v.accListIsHidden", false);
        		}
        		        		
        		component.set("v.contactList", result.contactList.accList);
        		component.set("v.contactListtotalrecords", result.contactList.totalrecords);
        		if(result.contactList.totalrecords == 0)
        		{
        			component.set("v.contactListIsHidden", true);
        		}
        		else
        		{
        			component.set("v.contactListIsHidden", false);
        		}
        		
        		component.set("v.cardList", result.cardList.accList);
        		component.set("v.cardListtotalrecords", result.cardList.totalrecords);
        		if(result.cardList.totalrecords == 0)       
        		{
        			component.set("v.cardListIsHidden", true);
        		} 
        		else
        		{
        			component.set("v.cardListIsHidden", false);
        		}	
        		 //Start: CRM-1400 - DB	
        		var ActiveCaseList = result.activecaseList.accList;
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
        			
        			helper.set(ActiveCaseList[i],'Account_Number__r.Name', ActiveCaseList[i].AccountName);
        			helper.set(ActiveCaseList[i],'Parent.CaseNumber', ActiveCaseList[i].ParentCaseNumber);
        			helper.set(ActiveCaseList[i],'Account.Name', ActiveCaseList[i].MemberName);
        			helper.set(ActiveCaseList[i],'Account_Number__r.Brand__c', ActiveCaseList[i].Brand);
        			helper.set(ActiveCaseList[i],'Owner.Name', ActiveCaseList[i].OwnerName);
        		}
        		component.set("v.activecaseList", ActiveCaseList);
        		component.set("v.activecaseListtotalrecords", result.activecaseList.totalrecords);
        		if(result.activecaseList.totalrecords == 0)
        		{
        			component.set("v.activecaseListIsHidden", true);
        		}
        		else
        		{
        			component.set("v.activecaseListIsHidden", false);
        		}
        		component.set("v.totalactivecases", result.activecaseList.totalrecords);
        		var CloaseCaseList = result.closecaseList.accList;
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
        			
        			helper.set(CloaseCaseList[i],'Account_Number__r.Name', CloaseCaseList[i].AccountName);
        			helper.set(CloaseCaseList[i],'Parent.CaseNumber', CloaseCaseList[i].ParentCaseNumber);
        			helper.set(CloaseCaseList[i],'Account.Name', CloaseCaseList[i].MemberName);
        			helper.set(CloaseCaseList[i],'Account_Number__r.Brand__c', CloaseCaseList[i].Brand);
        			helper.set(CloaseCaseList[i],'Owner.Name', CloaseCaseList[i].OwnerName);
        		}
        		component.set("v.closecaseList", CloaseCaseList);
        		//component.set("v.closecaseList", result.closecaseList.accList);
        		 //End: CRM-1400 - DB	
        		component.set("v.closecaseListtotalrecords", result.closecaseList.totalrecords);
        		if(result.closecaseList.totalrecords == 0)
        		{
        			component.set("v.closecaseListIsHidden", true);
        		}
        		else
        		{
        			component.set("v.closecaseListIsHidden", false);
        		}
        		
        		
        		   
        		component.set("v.casecommentsList", result.commentslist.accList);
        		component.set("v.casecommentsListtotalrecords", result.commentslist.totalrecords);
        		if(result.commentslist.totalrecords == 0)
        		{
        			component.set("v.casecommentsListIsHidden", true);
        		}
        		else
        		{
        			component.set("v.casecommentsListIsHidden", false);
        		}
        		
        		
        		component.set("v.taskList", result.taskList.accList);
        		component.set("v.taskListtotalrecords", result.taskList.totalrecords);
        		if(result.taskList.totalrecords == 0)
        		{
        			component.set("v.taskListIsHidden", true);
        		}
        		else
        		{
        			component.set("v.taskListIsHidden", false);
        		}
        		
        		component.set("v.worningcommentsList", result.warningList.accList);
        		component.set("v.worningcommentsListtotalrecords", result.warningList.totalrecords);   
        		if(result.warningList.totalrecords == 0)
        		{
        			component.set("v.worningcommentsListIsHidden", true);
        		}
        		else
        		{
        			component.set("v.worningcommentsListIsHidden", false);
        		}
        		component.set("v.currentTab", "1");   
        		
        		var totaltasks  = 0;
        		for(var i=0;i<result.taskList.accList.length;i++)
        		{
        			totaltasks +=  result.taskList.accList[i].lstTasks.length;
        		}      	
        		component.set('v.totaltasks',totaltasks );
            }
            else if (status === "ERROR") {
                var errors = response.getError();
                //console.error(errors);
            }        	
        });
        
        component.set("v.loading", true);
        $A.enqueueAction(action);

    },
    
    selectTab: function (component, event, helper) {       
    
        var activeTab = event.target.getAttribute("id");
        
        if (activeTab == 'tab-default-2__item') {            
            component.set("v.currentTab", "2");
        }
        else if (activeTab == 'tab-default-3__item') {
            component.set("v.currentTab", "3");;
        }
        else if (activeTab == 'tab-default-4__item') {
            component.set("v.currentTab", "4");
        }
        else if (activeTab == 'tab-default-5__item') {
            component.set("v.currentTab", "5");;
        }
        else if (activeTab == 'tab-default-6__item') {
            component.set("v.currentTab", "6");
        }
        else if (activeTab == 'tab-default-7__item') {
            component.set("v.currentTab", "7");
        }
        else if (activeTab == 'tab-default-8__item') {
            component.set("v.currentTab", "8");
        }      
        else if (activeTab == 'tab-default-1__item') {
            component.set("v.currentTab", "1");
        }             
    },
    HandlePaginationEvent: function(component, event, helper)
    {
    	
    	var SectionName = event.getParam("SectionName");
    	var PageNumber = event.getParam("PageNumber");
    	var PageSize = event.getParam("PageSize");
    	var PageSize = event.getParam("PageSize");
    	var SortBy = event.getParam("SortBy");
    	var SortDir = event.getParam("SortDir");
    	var SearchText = event.getParam("SearchText");
    	 var recordid = component.get("v.Id");
    	 var account = event.getParam("Account");
    	var card = event.getParam("CardNumber");
    	 if(account != undefined && account != null && card != undefined && card != undefined)
    	{    		 
    		 helper.MasterCardPagination(component, SectionName, PageNumber, PageSize, SortBy,SortDir,SearchText,account,card);
    	}
    	else
    		helper.Pagination(component, SectionName, PageNumber, PageSize, recordid,SortBy,SortDir,SearchText);
    },
    closeModal: function(component, event, helper)
    {
    	component.set("v.IsShowMasterCardAlert",false);
    }
})