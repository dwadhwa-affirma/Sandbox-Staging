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
                var userstatus = res['UserStatus'];
                var userstatusEFT = res['UserStatusEFT'];
                var userstatusaddresschange = res['UserStatusAddressChange'];
                var userstatusxpressrefi = res['UserStatusXpressRefi'];
                
                var menuIcons = res['MenuIcons'];
              
                component.set("v.MenuIcons",menuIcons);
                console.log(menuIcons);
                component.set("v.IsUserInGroup",userstatus);
                component.set("v.IsUserInEFTGroup",userstatusEFT);
                component.set("v.IsUserInAddressChangeGroup",userstatusaddresschange);
                component.set("v.IsUserInXpressRefiGroup",userstatusxpressrefi);
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
                
                var oowMainIndex = RightMenu.indexOf('Member Authentication'); 
                var halflength = component.get("v.halfLength");
                
                
                oowIndex = parseFloat(oowMainIndex) + parseFloat(halflength);  
                component.set("v.OOWIndex",oowIndex); 
                
                
                
                var object = component.get("v.sObjectName");
                var finalSubMenu = [];
                for(var i=0;i<menu.length; i++){
                    var clicked = menu[i].Name;                        
                    
                    
                    
                    for(var j=0; j<submenu.length;j++){
                        if(submenu[j].Menu__c == clicked && submenu[j].Function__c!=undefined && submenu[j].Status__c != '0'){			
                            finalSubMenu.push(submenu[j]);
                        }
                    }
                    
                    
                }
                finalSubMenu.sort(function(a, b) {
                    return parseFloat(a.Order__c) - parseFloat(b.Order__c);
                });
                
                
                var j = 0;
                var length = finalSubMenu.length;
                if(object == 'Account'){
                    for(var i=0; i< length;i++){
                      
                        if (finalSubMenu[j].isVisibleonMember__c == false) {
                            //finalSubMenu.splice(j, 1); 
                            var currentObj=finalSubMenu[j];
                            currentObj["isDisable"]=true;
                            currentObj["toolTip"]='Available through Member Account/Account Services';
                            finalSubMenu[j]=currentObj;
                            j++;
                        }
                        else
                        {
                            var currentObj=finalSubMenu[j];
                            currentObj["isDisable"]=false;
                            currentObj["toolTip"]=null;
                            j++;			
                        }	
                    }
                }
                else if(object == 'Account_Details__c'){
                    for(var i=0; i< length;i++){
                        if (finalSubMenu[j].isVisibleonMemberAccount__c == false) {
                            //finalSubMenu.splice(j, 1); 
                            var currentObj=finalSubMenu[j];
                            currentObj["isDisable"]=true;
                            currentObj["toolTip"]='Available through Member/Account Services';
                            finalSubMenu[j]=currentObj;
                            j++;	
                        }
                        else
                        {
                            var currentObj=finalSubMenu[j];
                            currentObj["isDisable"]=false;
                            currentObj["toolTip"]=null;
                            j++;			
                        }
                    }
                } 
                else if(object == 'Case'){
                        for(var i=0; i< length;i++){
                            if (finalSubMenu[j].isVisibleonCase__c == false) {
                                //finalSubMenu.splice(j, 1); 
                                var currentObj=finalSubMenu[j];
                                currentObj["isDisable"]=true;
                            	currentObj["toolTip"]='Available through Member/Member Account Services';
                            	finalSubMenu[j]=currentObj;
                                j++;	
                            }
                            else
                            {
                                 var currentObj=finalSubMenu[j];
                            	 currentObj["isDisable"]=false;
                            	 currentObj["toolTip"]=null;
                                j++;			
                            }
                        }   
                    }
                
                console.log('--------finalSubMenu----------');
                console.log(finalSubMenu);
                component.set("v.LoadSubMenu",finalSubMenu);
            }
        });
        $A.enqueueAction(action);
    },
    
    getMenuData : function(component) {
    }
    
})