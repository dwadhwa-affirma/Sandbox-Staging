({
	getAccountServiceMenuData : function(component) {
	debugger;
		var action = component.get("c.getAccountServiceMenuData");
		var recordId = component.get("v.recordId");	
		action.setParams({
		"recordId": recordId
		});	
		action.setCallback(this, function(resp) {			
			var state=resp.getState();			
			if(state === "SUCCESS"){				
				var res = resp.getReturnValue();
				console.log(res);
                var submenu = res['SubMenu'];
				var menu = res['Menu'];  
				var LeftMenu = [];
				var RightMenu= [];             
				 component.set("v.Menu",menu);
				for(var i=0; i<menu.length;i++){
					if((menu.length/2) > i){
						LeftMenu.push(menu[i]);
					}
					else{
						RightMenu.push(menu[i]);
					}
				}
                 component.set("v.halfLength",(menu.length/2)+1);                
				 component.set("v.LeftMenu",LeftMenu);
				  component.set("v.RightMenu",RightMenu);
				 component.set("v.SubMenu",submenu);
                var object = component.get("v.sObjectName");
                 var finalSubMenu = [];
                	for(var i=0;i<menu.length; i++){
                        var clicked = menu[i];                        
                     
                     
                    
                     for(var j=0; j<submenu.length;j++){
                         if(submenu[j].Menu__c == clicked && submenu[j].Function__c!=undefined && submenu[j].Status__c != '0'){			
                             finalSubMenu.push(submenu[j]);
                         }
                     }
                     
                      
                    }
                    finalSubMenu.sort(function(a, b) {
                         return parseFloat(a.Order__c) - parseFloat(b.Order__c);
                     });
                
					if(object == 'Account'){
                          for(var i=0; i<finalSubMenu.length;i++){
                             if (finalSubMenu[i].isVisibleonMember__c == false) {
                                   	 finalSubMenu.splice(i, 1); 
                                }
                          }
                      }
                    else if(object == 'Account_Details__c'){
                    	 for(var i=0; i<finalSubMenu.length;i++){
                             if (finalSubMenu[i].isVisibleonMemberAccount__c == false) {
                                   	 finalSubMenu.splice(i, 1); 
                                }
                          }
                    } 
                    else if(object == 'Case'){
                    	if (finalSubMenu[i].isVisibleonCase__c == false) {
                                   	 finalSubMenu.splice(i, 1); 
                                }
                                
                    }                   
                     component.set("v.LoadSubMenu",finalSubMenu);
                     
				}
			});
		$A.enqueueAction(action);
	},
	
	getMenuData : function(component) {
		
     
		
		
	}

})