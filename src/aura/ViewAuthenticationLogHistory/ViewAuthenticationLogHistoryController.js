({
	doInit : function(component, event, helper) {
		
		var memberId = component.get("v.recordId");
		component.set("v.memberId",memberId );
		var GUID = component.get("v.GUID");
		if(memberId != null && memberId !=undefined )
		{
			var DaysParam = parseInt(7);
			helper.GetLogData(component, event, helper,DaysParam, memberId, GUID);
		}
		
	},
	
	onChange: function(component, event, helper) {
		var memberId = component.get("v.recordId");
		var DaysParam = component.find("DaysPicklist").get("v.value");
		component.set("v.DaysSelected",parseInt(DaysParam));
		helper.GetLogData(component, event, helper, DaysParam, memberId);
	},
	
	ViewDetail : function(component, event, helper) {
	      var lastIndex = parseInt(component.get("v.LastIndex")) -1;
	      if(event.getSource().get("v.iconName") == 'utility:chevronright')
	      {
	    	  component.set("v.IsLogSectionVisible", true); 
	    	  event.getSource().set("v.iconName", 'utility:chevrondown');
	      }
	      else{
	    	  component.set("v.IsLogSectionVisible", false); 
	    	  event.getSource().set("v.iconName", 'utility:chevronright');
	      }
	      
	      var SelectedGUID = event.getSource().get("v.value");
	      var selectedbtn = event.getSource().get("v.name");
	      var SelectedTrIndex  = 'TRRowIndex' + selectedbtn.substring(8); 
	      var SelctedTr = document.getElementById(SelectedTrIndex);
	      SelctedTr.classList.add("highlight");
	      component.set("v.SelectedGUID", SelectedGUID);
	     
	      var OthertrIndex;
	      var OtherTr;
	      for(var i =0; i <=lastIndex ; i++ )
	      {
	    	  OtherTrIndex = 'TRRowIndex' + i;
	    	  OtherTr = document.getElementById(OtherTrIndex);
	    	  if(OtherTrIndex != SelectedTrIndex)
	    	  {
	    		   OtherTr.classList.remove("highlight");
	    		   try{
	    			   OtherTr.firstChild.firstChild.firstChild.iconName ="utility:chevronright";
	    		   }catch(e){
	    			   
	    		   }
	    	  }
	    	 
	      }
	     
	     
	      var attribute1 = component.get("v.recordId");
	      var attribute2 = SelectedGUID;
	      var LogHistoryRowComponent = component.find('LogHistoryRow');
            if(LogHistoryRowComponent!=undefined){
            	LogHistoryRowComponent.LogMethod(attribute1,attribute2);
            }
	      
    },
    
    ViewDetailBlur : function(component, event, helper) {
    	
    	/* var BtnLabel = event.getSource().get("v.label");
    	 var BtnName = event.getSource().get("v.name");
    	 var SelectedGUID = event.getSource().get("v.value");	
    	 var sectionDiv = document.getElementById('LogExpansion');
    	 var BtnId = event.getSource().getLocalId()
	     var sectionState = sectionDiv.getAttribute('class').search('slds-is-open');
	     if(sectionState == -1){
	    	  sectionDiv.setAttribute('class' , 'slds-section slds-is-open');
	    	  
	    	  event.getSource().set("v.label", 'Hide');
	     }else{
	      		sectionDiv.setAttribute('class' , 'slds-section slds-is-close');
	      		
	      		event.getSource().set("v.label", 'View');
	     }*/
    },
})