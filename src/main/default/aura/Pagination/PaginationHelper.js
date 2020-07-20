({
	getPagingData: function(component, SectionName, PageNo, PageSize,SortBy,SortDir,SearchText) {	
        
        var updateEvent = component.getEvent("PaginationEvent");
        updateEvent.setParams({ "SectionName": SectionName});
        updateEvent.setParams({ "PageNumber": PageNo });
        updateEvent.setParams({ "PageSize": PageSize });
        updateEvent.setParams({ "SortBy": SortBy });
        updateEvent.setParams({ "SortDir": SortDir });
        updateEvent.setParams({"SearchText": SearchText});
        updateEvent.fire();
    },
    getMasterCardPagingData: function(component, SectionName, PageNo, PageSize,SortBy,SortDir,SearchText,Account,CardNumber) {	
        
        
        var updateEvent = component.getEvent("PaginationEvent");
        updateEvent.setParams({ "SectionName": SectionName});
        updateEvent.setParams({ "PageNumber": PageNo });
        updateEvent.setParams({ "PageSize": PageSize });
        updateEvent.setParams({ "SortBy": SortBy });
        updateEvent.setParams({ "SortDir": SortDir });
        updateEvent.setParams({"SearchText": SearchText});
        updateEvent.setParams({ "Account": Account});
        updateEvent.setParams({ "CardNumber": CardNumber});
        updateEvent.fire();
    },
    formatDate : function(format,date)
    {
    if (!format)
      format="MM/dd/yyyy";               
 
    var month = date.getMonth() + 1;
    var monthString = month.toString();
     if(month <= 9)
         monthString = "0" + month.toString();
    var year = date.getFullYear();    
 	 var dateString = date.getDate().toString();
     if(date.getDate() <= 9)
         dateString = "0" + date.getDate().toString();
        
    format = format.replace("MM",monthString);        
 
    if (format.indexOf("yyyy") > -1)
        format = format.replace("yyyy",year.toString());
    else if (format.indexOf("yy") > -1)
        format = format.replace("yy",year.toString().substr(2,2));
 
    format = format.replace("dd",dateString);
 
    var hours = date.getHours();       
    if (format.indexOf("t") > -1)
    {
       if (hours > 11)
        format = format.replace("t","pm")
       else
        format = format.replace("t","am")
    }
    var hoursString = hours.toString();
    if(hours < 9)
    {
        hoursString = "0" + hours.toString();
    }
    if (format.indexOf("HH") > -1)
        format = format.replace("HH",hoursString);
    if (format.indexOf("hh") > -1) {
        if (hours > 12) hours =hours - 12;
        if (hours == 0) hours = 12;
        hoursString = hours.toString();
        if(hours < 9)
        {
            hoursString = "0" + hours.toString();
        }
        format = format.replace("hh",hoursString);        
    }
    var minutes = date.getMinutes();
    var minsString = minutes.toString();
    if(minutes < 9)
    {
        minsString = "0" + minutes.toString();
    }
    var secs = date.getSeconds();
    var secsString = secs.toString();
    if(secs < 9)
    {
        secsString = "0" + secs.toString();
    }
    if (format.indexOf("mm") > -1)
       format = format.replace("mm",minsString);
    if (format.indexOf("ss") > -1)
       format = format.replace("ss",secsString);
    return format;
},

	setPaging:function(TotalRecords,PageSize,component)
	{
		var Pages = new Array();
        var totalPages = Math.ceil(TotalRecords / PageSize);
        if(totalPages <= 5)
        {
	        for(var i = 1; i <= totalPages; i++)
			{
				Pages.push(i);
			}
		}
		else
		{
			var pageno = component.get('v.currentPage');
			if(pageno == null || pageno == undefined || pageno == "")
				pageno = 1;
			var startIndex = pageno -2;
			var lastIndex = pageno + 2;
			if(startIndex < 0)
			{
				startIndex = startIndex + 2;
				lastIndex = lastIndex + 2;
			}
			else if(startIndex == 0)
			{
				startIndex = startIndex + 1;
				lastIndex = lastIndex + 1;
			}
			if(lastIndex > totalPages)
			{
				startIndex = totalPages - 4;
				lastIndex = totalPages;
				
			}
			
			for(var i = startIndex; i <= lastIndex; i++)
			{
				Pages.push(i);
			}
		}
		component.set('v.Pages', '');
		component.set('v.Pages', Pages);
		component.set('v.TotalPages', totalPages);
	}
    
})