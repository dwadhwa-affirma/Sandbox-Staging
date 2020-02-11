({
	doInit : function(component, event, helper) {
		
        debugger;
        var action = component.get("c.GetAllData");
        
       // component.set('v.recordId', component.get("v.pageReference").state.id);
        var recordid = component.get("v.recordId");	
		
		
		
		if(recordid == undefined)
		{
			recordid = helper.getParameterByName('c__id');
		}
		
        action.setParams({ "accid": recordid });

        action.setCallback(this, function (response) {
        
        	var status = response.getState();
            component.set("v.loading", false);
            if (component.isValid() && status === "SUCCESS") {
            	
            	var result = response.getReturnValue();
            	component.set("v.accList", result.accList);
                var stracc ='';
                for(var i=0; i< result.accList.length; i++ )
                {
                   stracc = stracc + ',' + result.accList[i];
                }
                    stracc = stracc.substr(1);
                    
                
                var membername = result.MemberName;
                 	component.set("v.straccList", stracc);
        			component.set("v.accListtotalrecords", result.accList.totalrecords);
        		if(result.accList.totalrecords == 0) 
        		{
        			component.set("v.accListIsHidden", true);
        		}
        		else
        		{
        			component.set("v.accListIsHidden", false);
        		}       		        		
        		
            }
            else if (status === "ERROR") {
                var errors = response.getError();
                //console.error(errors);
            } 
            
            var hostname = window.location.hostname;
    		
    		//var URL = 'https://' + hostname + '/apex/flow?flow-id=04d6f632-1d3b-4b35-a0cd-6694169978a6&object-id=' + stracc + '&fullname=' + membername;
    		//var URL = 'https://' + hostname + '/apex/flow?flow-id=32853ba9-fabc-4943-99f7-344c8e187b0d&accountid=001j000000y6s29AAA';
    		var URL = 'https://flow.boomi.com/205f8437-a72f-4b9a-9dbd-f9df4a2346b3/play/ChangeRequestPlayer?flow-id=32853ba9-fabc-4943-99f7-344c8e187b0d&accountid='+recordid;
    		//window.location.href = URL
    		window.open(URL,'_blank');
            
            
        });
        
        component.set("v.loading", true);
        $A.enqueueAction(action);

    },
    
   /* nextClick: function(component, event, helper) {
     var recordid = component.get("v.recordId");	
		
		if(recordid == undefined)
		{
			recordid = helper.getParameterByName('c__id');
		}
    	var hostname = window.location.hostname;
    	var accno=component.get("v.selectedAccount")
    	var URL = 'https://' + hostname + '/apex/flow?flow-id=04d6f632-1d3b-4b35-a0cd-6694169978a6&object-id=' + accno + '&recordId=' + recordid;
    	window.location.href = URL
    	 
    	//  window.open(hostname + '/apex/flow?flow-id=04d6f632-1d3b-4b35-a0cd-6694169978a6&object-id=' + recordid,'_blank');
    },
    */
    handleRadioClick:function(cmp,event,helper){
        cmp.set("v.selectedAccount", event.target.value);
    	//alert("val1 = "+event.target.value);
},
closePopup: function(component, event, helper) {
	  $A.get('e.force:closeQuickAction').fire();
   },
})