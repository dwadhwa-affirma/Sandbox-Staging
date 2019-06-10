({
	doInit : function(component, event, helper) {		
		 helper.getAccountServiceMenuData(component, event);			
	},
	
	loadSubMenu : function(component, event, helper) {	
		
		 var submenu = component.get("v.SubMenu");
		 var clicked = event.target.text;
		 event.target.classList.add("visited");
		  var object = component.get("v.sObjectName");		
		 
		 var menu = document.getElementsByClassName("clsMenu")
		 for(var i=0; i<menu.length;i++){		
			 if(menu[i].innerText != clicked){
				 menu[i].children[0].classList.remove("visited");
			 }
		 }
		 var finalSubMenu = [];
		 for(var i=0; i<submenu.length;i++){
			 if(submenu[i].Menu__c == clicked && submenu[i].Function__c!=undefined && submenu[i].Status__c != '0'){			
				 finalSubMenu.push(submenu[i]);
			 }
		 }
		 finalSubMenu.sort(function(a, b) {
			 return parseFloat(a.Order__c) - parseFloat(b.Order__c);
		 });
		  if(object == 'Account'){
			  for(var i=0; i<finalSubMenu.length;i++){
				 if (finalSubMenu[i].Function__c == 'Travel Notices') {
					 	finalSubMenu.splice(i, 1); 
				 	}
			  }
		  }
		 
		 component.set("v.LoadSubMenu",finalSubMenu);
		 var ele = document.getElementById('divAccountServiceSubMenu');
		 ele.style = '';
	},
	
	loadComponent : function(component, event, helper) {		
		 var submenu = component.get("v.SubMenu");
		 var clicked = event.target.text;
		 event.target.classList.add("visited");
		 
		 var submenus = document.getElementsByClassName("clsSubMenu")
		 for(var i=0; i<submenus.length;i++){		
			 if(submenus[i].innerText != clicked){
				 submenus[i].children[0].classList.remove("visited");
			 }
		 }
		 
		 var Component='';
		 for(var i=0; i<submenu.length;i++){
			 if(submenu[i].Function__c == clicked){
			 if(submenu[i].Command__c != undefined){
				 Component = "c:" + (submenu[i].Command__c);
				break;
				 }
				
			 }
		 }
		 
		 component.set("v.componentToOpen",Component);
		 if(Component != ''){
			 var cmp = document.getElementById('tblAccountServiceMenu');
			 cmp.style = 'display:none';
			 var cmp1 = document.getElementById('tblSearch');
			 cmp1.style = 'display:none';
			 var header = document.getElementsByClassName('slds-modal__header');
			 if(header != null){
				 header[0].style="display:none"
			 }
	         var footer = document.getElementsByClassName('slds-modal__footer');
	          if(footer != null){
				 footer[0].style="display:none"
			 }
			 $A.createComponent(
	            component.get("v.componentToOpen"),
	            {
	                "recordId": component.get("v.recordId")  ,
	                "sObjectName": component.get("v.sObjectName")              
	            },
	            function(msgBox){                
	                if (component.isValid()) {
	                    var targetCmp = component.find('ModalDialogPlaceholder');
	                    var body = targetCmp.get("v.body");
	                    body.push(msgBox);
	                    targetCmp.set("v.body", body); 
	                }
	            }
	        );
		 }
		 
		 //var evt = $A.get("e.force:navigateToComponent");
		// evt.setParams({
		//componentDef : Component,
		//componentAttributes: {"recordId": component.get("v.recordId")}
		//});
		//evt.fire();
				
			},
			
	SearchMenu: function(component, event, helper) {	
		var ST = component.get("v.SearchText");
		var submenu = component.get("v.SubMenu");
		var finalSubMenu = [];
		
		 for(var i=0; i<submenu.length;i++){
			 if(submenu[i].Function__c!=undefined && submenu[i].Function__c.toLowerCase().includes(ST.toLowerCase()) && ST != ''){
				 finalSubMenu.push(submenu[i]);
			 }
		 }
		  finalSubMenu.sort(function(a, b) {
			 return parseFloat(a.Order__c) - parseFloat(b.Order__c);
		 });
		 component.set("v.LoadSubMenu",finalSubMenu);
		 var ele = document.getElementById('divAccountServiceSubMenu');
		 ele.style = '';
		//var slides = document.getElementsByClassName("clsSubMenu");
		/*for(var i = 0; i < slides.length; i++)
		{
		   if(!(slides.item(i).textContent.toLowerCase().includes(ST.toLowerCase()))){
			   slides.item(i).hidden=true;
		   }
		   else{
			   slides.item(i).hidden=false;
		   }
		}*/
		
		
	}
})