({
	PagesChange: function(component, event, helper) {
		var TotalRecords = event.getParam("value");
        var PageSize = component.get('v.PageSize');
        var Pages = new Array();
        var totalPages = Math.ceil(TotalRecords / PageSize);
        
        helper.setPaging(TotalRecords,PageSize,component);
			
        var listObject = (component.get('v.ListObject'));
        if(listObject.length > 0)
        {
        	component.set("v.account", listObject[0].Member_Number__c);
        	component.set("v.card", listObject[0].Card_Number__c);
        }
    },

	doInit : function(component, event, helper) {
		var HeaderTitleString = component.get('v.HeaderTitleString');
		var HeaderTitleArray = HeaderTitleString.split(',');
		component.set('v.HeaderTitleArray',HeaderTitleArray);		
		
		var HeaderColumnString = component.get('v.HeaderColumnString');
		var HeaderColumnArray = HeaderColumnString.split(',');
		component.set('v.HeaderColumnArray',HeaderColumnArray);
		debugger;
		var widths =  component.get('v.widths');
		if(widths != null && widths != '' )
		{
			var widthsArray = widths.split(',');
			for(var i = 0; i < widthsArray.length; i++)
			{
				widthsArray[i] = "width:" + widthsArray[i] + ";";
			}
			component.set('v.widthsArray', widthsArray);
		}
		else
		{
			var widthsArray = new Array();
			for(var i = 0; i < HeaderColumnArray.length; i++)
			{
					widthsArray.push('width:auto;');
			}
			
			component.set('v.widthsArray',widthsArray);
		}
		console.log(HeaderColumnArray);       
		var PageSize = component.get('v.PageSize');
		
	},
	Previous: function(component, event, helper) {
		component.set("v.loading", true);
		var pageno = component.get('v.currentPage');
	    var PageSize = component.get('v.PageSize');
		var TotalRecords = component.get('v.TotalRecords');
		var totalPages = Math.ceil(TotalRecords / PageSize);
		if(pageno != 1)
		{
		pageno = pageno - 1;
		}
		
		
		var SectionName =  component.get('v.SectionName');
		try
		{
			component.set('v.currentPage',pageno);
			helper.setPaging(TotalRecords,PageSize,component);
		}
		catch(ex)
		{
		}
		var SortDir = component.get('v.SortDir');
		var SortBy = component.get('v.SortBy');
		var searchtext = component.get('v.searchField');
		if(SortDir == undefined)
		{
			SortDir = '';
		}
		if(SortBy == undefined)
		{
			SortBy = '';
		}
		if(SortBy.indexOf("|") > 0)
		{
		    	SortBy = SortBy.split("|")[1];
		}
		 if(SectionName == 'MasterCardAlert')
		 {
			 var account = component.get("v.account");
			 var card = component.get("v.card");
			 helper.getMasterCardPagingData(component, SectionName, pageno, PageSize,SortBy,SortDir,searchtext,account,card);
		 }        	
        else
        	helper.getPagingData(component,SectionName,pageno,PageSize,SortBy,SortDir,searchtext);
        component.set("v.loading", false);
	},
	Next: function(component, event, helper) {
       component.set("v.loading", true);
		var pageno = component.get('v.currentPage');
	   var PageSize = component.get('v.PageSize');
		var TotalRecords = component.get('v.TotalRecords');
		var totalPages = Math.ceil(TotalRecords / PageSize);
		if(pageno != totalPages)
		{
			pageno = pageno + 1;
			
		}		
				
        var SectionName =  component.get('v.SectionName');
		try
		{
			component.set('v.currentPage',pageno);
			helper.setPaging(TotalRecords,PageSize,component);
		}
		catch(ex)
		{
		}
		var SortDir = component.get('v.SortDir');
		var SortBy = component.get('v.SortBy');
		var searchtext = component.get('v.searchField');
		if(SortDir == undefined)
		{
			SortDir = '';
		}
		if(SortBy == undefined)
		{
			SortBy = '';
		}
		if(SortBy.indexOf("|") > 0)
		{
		    	SortBy = SortBy.split("|")[1];
		}
		 if(SectionName == 'MasterCardAlert')
		 {
			 var account = component.get("v.account");
			 var card = component.get("v.card");
			 helper.getMasterCardPagingData(component, SectionName, pageno, PageSize,SortBy,SortDir,searchtext,account,card);
		 }        	
        else
        	helper.getPagingData(component,SectionName,pageno,PageSize,SortBy,SortDir,searchtext);
		component.set("v.loading", false);
	},	
	
	ChangePage: function(component, event, helper)
	{
		component.set("v.loading", true);
		var pageno = parseInt(event.target.id);
		var currentPage = component.get('v.currentPage');
		var PageSize = parseInt( component.get('v.PageSize'));
		var TotalRecords = component.get('v.TotalRecords');
		
		if(currentPage != pageno)
		{			
			var SectionName =  component.get('v.SectionName');
			try
			{
				component.set('v.currentPage',pageno);
				helper.setPaging(TotalRecords,PageSize,component);		
			}
			catch(ex)
			{
			}
			var SortDir = component.get('v.SortDir');
			var SortBy = component.get('v.SortBy');
			var searchtext = component.get('v.searchField');
			if(SortDir == undefined)
			{
				SortDir = '';
			}
			if(SortBy == undefined)
			{
				SortBy = '';
			}
			if(SortBy.indexOf("|") > 0)
			{
		    	SortBy = SortBy.split("|")[1];
			}
			if(SectionName == 'MasterCardAlert')
			 {
				 var account = component.get("v.account");
				 var card = component.get("v.card");
				 helper.getMasterCardPagingData(component, SectionName, pageno, PageSize,SortBy,SortDir,searchtext,account,card);
			 }        	
	        else
	        	helper.getPagingData(component,SectionName,pageno,PageSize,SortBy,SortDir,searchtext);
		}
		component.set("v.loading", false);
	},
	
	
	changePageSize: function(component, event, helper)
	{
		component.set("v.loading", true);
		var PageSize = parseInt(component.get('v.PageSize'));
		component.set('v.PageSize',PageSize);
		try
		{
			component.set('v.currentPage',1);
		}
		catch(ex)
		{
		}
		var SectionName =  component.get('v.SectionName');
		var SortDir = component.get('v.SortDir');
		var SortBy = component.get('v.SortBy');
		var searchtext = component.get('v.searchField');
		if(SortDir == undefined)
		{
			SortDir = '';
		}
		if(SortBy == undefined)
		{
			SortBy = '';
		}
		if(SortBy.indexOf("|") > 0)
		{
		    	SortBy = SortBy.split("|")[1];
		}
		 if(SectionName == 'MasterCardAlert')
		 {
			 var account = component.get("v.account");
			 var card = component.get("v.card");
			 helper.getMasterCardPagingData(component, SectionName, 1, PageSize,SortBy,SortDir,searchtext,account,card);
		 }        	
        else
        	helper.getPagingData(component,SectionName,1,PageSize,SortBy,SortDir,searchtext);
        
        var TotalRecords = component.get('v.TotalRecords');
        var Pages = new Array();
        var totalPages = Math.ceil(TotalRecords / PageSize);
       
		helper.setPaging(TotalRecords,PageSize,component);
		
		component.set("v.loading", false);
	},
	
	
	SortColumn: function(component, event, helper)
	{
       component.set("v.loading", true);
		var columnIndex = parseInt(event.target.getAttribute("id"));
		var HeaderColumnString = component.get('v.HeaderColumnString');
		var HeaderColumnArray = HeaderColumnString.split(',');
		var columnName = HeaderColumnArray[columnIndex];
		var SortDir  = component.get('v.SortDir');
		var SortBy  = columnName;
		if(columnName)
		{
			if(columnName.indexOf("|") > 0)
		    {
		    	SortBy = columnName.split("|")[1];
		    }
		    var previousSortBy = component.get('v.SortBy');
		    if(columnName == previousSortBy)
		    {
		    	if(SortDir == "Asc"){
				SortDir = "Desc";
				}
				else
				{
					SortDir = "Asc";
				}
		    }
		    else
		    {
		    	SortDir = "Asc";
		    }			
			component.set('v.SortDir', SortDir);
			component.set('v.SortBy', columnName);
			var PageSize = component.get('v.PageSize');
			var PageNo = component.get('v.currentPage');
			var SectionName =  component.get('v.SectionName');
			component.set('v.currentPage', 1);
			var searchtext = component.get('v.searchField');
			 if(SectionName == 'MasterCardAlert')
			 {
				 var account = component.get("v.account");
				 var card = component.get("v.card");
				 helper.getMasterCardPagingData(component, SectionName, 1, PageSize,SortBy,SortDir,searchtext,account,card);
			 }        	
	        else
	        	helper.getPagingData(component,SectionName,1,PageSize,SortBy,SortDir,searchtext);
	        var TotalRecords = component.get('v.TotalRecords');
	       helper.setPaging(TotalRecords,PageSize,component);
		}
		component.set("v.loading", false);
		return false;
	},
	OpenMasterCardAlerts: function(component, event, helper)
	{
		var account = event.target.getAttribute("role");
		var card = event.target.getAttribute("id");
		var SectionName =  component.get('v.SectionName');		
		var PageSize = component.get('v.PageSize');
		component.set("v.account", account);
		component.set("v.card", card);
		helper.getMasterCardPagingData(component, SectionName, 1, PageSize,"","",'',account,card);
	},
	searchEvents: function(component, event, helper)
	{
		if(event.keyCode == 13){
			component.set("v.loading", true);
			var SectionName =  component.get('v.SectionName');
			var SortDir = component.get('v.SortDir');
			var SortBy = component.get('v.SortBy');
			
			if(SortDir == undefined)
			{
				SortDir = '';
			}
			if(SortBy == undefined)
			{
				SortBy = '';
			}
			if(SortBy.indexOf("|") > 0)
			{
		    	SortBy = SortBy.split("|")[1];
			}
			component.set('v.currentPage',1);
			var PageSize = component.get('v.PageSize');
			var PageNo = component.get('v.currentPage');
			var searchtext = event.target.value;
			component.set('v.searchField',searchtext);
			/*if(searchtext.indexOf("/") > 0 && searchtext.split("/").length == 3)
			{
				var datetime = new Date(searchtext);
		        if(datetime.toString() != "NaN" && datetime != "Invalid Date")
		        {                
		        	searchtext = helper.formatDate("yyyy-MM-dd",datetime);
		        }
			}*/			
			if(SectionName == 'MasterCardAlert')
			 {
				 var account = component.get("v.account");
				 var card = component.get("v.card");
				 helper.getMasterCardPagingData(component, SectionName, PageNo, PageSize,SortBy,SortDir,searchtext,account,card);
			 }        	
	        else
	        	helper.getPagingData(component,SectionName,PageNo,PageSize,SortBy,SortDir,searchtext);
	        component.set("v.loading", false);
        }
	},
	First: function(component, event, helper) {
		component.set("v.loading", true);
		var pageno = component.get('v.currentPage');
	    var PageSize = component.get('v.PageSize');
		var TotalRecords = component.get('v.TotalRecords');
		var totalPages = Math.ceil(TotalRecords / PageSize);
		if(pageno != 1)
		{
			pageno = 1;
		}		
		
		var SectionName =  component.get('v.SectionName');
		try
		{
			component.set('v.currentPage',pageno);
			helper.setPaging(TotalRecords,PageSize,component);
		}
		catch(ex)
		{
		}
		var SortDir = component.get('v.SortDir');
		var SortBy = component.get('v.SortBy');
		var searchtext = component.get('v.searchField');
		if(SortDir == undefined)
		{
			SortDir = '';
		}
		if(SortBy == undefined)
		{
			SortBy = '';
		}
		if(SortBy.indexOf("|") > 0)
		{
		    	SortBy = SortBy.split("|")[1];
		}
		 if(SectionName == 'MasterCardAlert')
		 {
			 var account = component.get("v.account");
			 var card = component.get("v.card");
			 helper.getMasterCardPagingData(component, SectionName, pageno, PageSize,SortBy,SortDir,searchtext,account,card);
		 }        	
        else
        	helper.getPagingData(component,SectionName,pageno,PageSize,SortBy,SortDir,searchtext);
        component.set("v.loading", false);
	},
	Last: function(component, event, helper) {
       component.set("v.loading", true);
		var pageno = component.get('v.currentPage');
	   var PageSize = component.get('v.PageSize');
		var TotalRecords = component.get('v.TotalRecords');
		var totalPages = Math.ceil(TotalRecords / PageSize);
		if(pageno != totalPages)
		{
			pageno = totalPages;
			
		}		
				
        var SectionName =  component.get('v.SectionName');
		try
		{
			component.set('v.currentPage',pageno);
			helper.setPaging(TotalRecords,PageSize,component);
		}
		catch(ex)
		{
		}
		var SortDir = component.get('v.SortDir');
		var SortBy = component.get('v.SortBy');
		var searchtext = component.get('v.searchField');
		if(SortDir == undefined)
		{
			SortDir = '';
		}
		if(SortBy == undefined)
		{
			SortBy = '';
		}
		if(SortBy.indexOf("|") > 0)
		{
		    	SortBy = SortBy.split("|")[1];
		}
		 if(SectionName == 'MasterCardAlert')
		 {
			 var account = component.get("v.account");
			 var card = component.get("v.card");
			 helper.getMasterCardPagingData(component, SectionName, pageno, PageSize,SortBy,SortDir,searchtext,account,card);
		 }        	
        else
        	helper.getPagingData(component,SectionName,pageno,PageSize,SortBy,SortDir,searchtext);
		component.set("v.loading", false);
	}
	
   
})