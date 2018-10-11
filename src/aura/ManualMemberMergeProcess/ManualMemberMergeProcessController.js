({
	doInit : function(component, event, helper) {
	
    
		var action = component.get("c.GetMemberList");
		component.set("v.loading", true);
		component.set("v.NoMemberSelected", true);
		action.setCallback(this, function (response) {
		
			 var status = response.getState();
			 
	        if (component.isValid() && status === "SUCCESS") {
	        	var result =  response.getReturnValue();	            
	            component.set("v.accounts", result[0]);
	            
	            if(result[1].length > 0){
	            	
                   var arrayACC = new Array();
                   
                   for(var i =0; i< result[1].length; i++)
                   {
                	   arrayACC.push(result[1][i]);
                   }
                   
                   
                	component.set("v.PreMemberAccounts", arrayACC);
                	component.set("v.NoPreMemberAccount", false);
                	
                }
                else
                {
                	component.set("v.NoPreMemberAccount", true);
                	
                }  
	            
	            component.set("v.loading", false);
	            component.set("v.Firstloading", false);
	        }
		      
	       
		 });
	  $A.enqueueAction(action);
		
	},
	
	 onRadioClick : function(component, event, helper) {
         
        var selected = event.getSource().get("v.value");
        
        component.set("v.radioSelected", selected);
        
		 var action = component.get("c.GetMemberAccountDetail");
		 var id = component.get("v.radioSelected");
		 
		 action.setParams({	"id" : id });
		 component.set("v.loading", true);
		 action.setCallback(this, function(response){	    	    	
	        var state = response.getState();
	        if (state === "SUCCESS") {
              
                var result =  response.getReturnValue();
                 component.set("v.NoMemberSelected", false);
                 var accountdetail = result[0];
                 var PreMemberAccounts = result[1];
                 accountdetail['FormattedMobileno']='';
                 accountdetail['FormattedWorkPhoneno']='';
                 accountdetail['FormattedHomePhoneno']='';
                 PreMemberAccounts['FormattedMobileno'] = '';
                if(accountdetail.Mobile_Phone__pc != undefined && accountdetail.Mobile_Phone__pc != '') 
                	accountdetail.FormattedMobileno = accountdetail.Mobile_Phone__pc.replace(/-/g,'').replace(/\(|\)/g,'');
				if(accountdetail.Work_Phone__pc != undefined && accountdetail.Work_Phone__pc != '')
					accountdetail.FormattedWorkPhoneno = accountdetail.Work_Phone__pc.replace(/-/g,'').replace(/\(|\)/g,'');
				if(accountdetail.Home_Phone__pc != undefined && accountdetail.Home_Phone__pc != '')
					accountdetail.FormattedHomePhoneno = accountdetail.Home_Phone__pc.replace(/-/g,'').replace(/\(|\)/g,'');
				
				for(var i=0;i<PreMemberAccounts.length;i++){
					if(PreMemberAccounts[i].Mobile_Phone__pc != undefined && PreMemberAccounts[i].Mobile_Phone__pc != '')
						PreMemberAccounts[i].FormattedMobileno = PreMemberAccounts[i].Mobile_Phone__pc.replace(/-/g,'').replace(/\(|\)/g,'');
				}
                component.set("v.accountdetail", accountdetail);
                component.set("v.PreMemberAccounts", PreMemberAccounts);
	            	/*component.set("v.PreMemberAccounts", result[1]);
                	component.set("v.NoPreMemberAccount", false);*/
                	component.set("v.loading", false);
                	component.set("v.AddressShow", true);
                	component.set("v.PersonalShow", true);
                	component.set("v.PreMemberShow", true);
                	//component.set("v.PreMemberMobilenoToCompare", true);
                
	        }	        
	       component.set("v.loading", false);
	    });
	    
	    $A.enqueueAction(action);
		 
	 },
	 
	  onPreRadioClick : function(component, evt) {
		
		component.set("v.PreMemberSelected", evt.target.value);
		  
	 
	 },
	 
		mergeAccount : function(component, evt)
		{
			var action = component.get("c.MergeMemberAccount");
			var mid = component.get("v.radioSelected");
			var pmid = component.get("v.PreMemberSelected");
			
				if(mid == null || mid == ''){
				  var toastEvent1 = $A.get("e.force:showToast");
						        toastEvent1.setParams({		            
						            message : 'Please select member',	                        
						            duration:' 3000',
						            key: 'info_alt',
						            type: 'Error',
						            mode: 'pester'
						        });
						        toastEvent1.fire();	
						        return;
				}
				if(pmid == null || pmid == ''){
				  var toastEvent2 = $A.get("e.force:showToast");
						        toastEvent2.setParams({		            
						            message : 'Please select Pre-Member',	                        
						            duration:' 3000',
						            key: 'info_alt',
						            type: 'Error',
						            mode: 'pester'
						        });
						        toastEvent2.fire();	
						        return;
				}
			  action.setParams({
			    	"mid" : mid,
			    	"pmid" : pmid
	    	
			  });

			action.setCallback(this, function(response){
			component.set("v.loading", true);
			var state = response.getState();
	        if (state === "SUCCESS") {
	            var result =  response.getReturnValue();	            
	            component.set("v.success", true);
	             
	             var toastEvent = $A.get("e.force:showToast");
	        
		        toastEvent.setParams({		            
		            message : 'The record has been converted successfully.',	                        
		            duration:' 3000',
		            key: 'info_alt',
		            type: 'success',
		            mode: 'pester'
		        });
		        toastEvent.fire();	
	          /*   component.set("v.loading", false);
	             var mid1 = component.get("v.radioSelected");
	             var navEvt = $A.get("e.force:navigateToSObject");
			    navEvt.setParams({
			      "recordId": mid1
			    });
			    navEvt.fire();
                $A.get('e.force:refreshView').fire();*/
                var mid1 = component.get("v.radioSelected");
	            window.location.href = '/lightning/r/Account/' + mid1 +'/view' 
	        
	        }	    

			});
			
			$A.enqueueAction(action);
		},
		showHideAddress: function(component, evt)
		{
			var AddressShow = component.get("v.AddressShow");
			component.set("v.AddressShow", !AddressShow);
		},
		showHidePersonal: function(component, evt)
		{
			var PersonalShow = component.get("v.PersonalShow");
			component.set("v.PersonalShow", !PersonalShow);
			var AddressShow = component.get("v.AddressShow");
			component.set("v.AddressShow", !AddressShow);
		},
		showHidePreMember: function(component, evt)
		{
			var PreMemberShow = component.get("v.PreMemberShow");
			component.set("v.PreMemberShow", !PreMemberShow);
		},
		display  : function(component,event) 
		{
		    
		    var toggleText = component.find("tooltip");
		    $A.util.toggleClass(toggleText, "slds-hide");
		},
		

	 
})