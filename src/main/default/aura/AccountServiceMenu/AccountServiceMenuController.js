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
		 /* if(object == 'Account'){
			  for(var i=0; i<finalSubMenu.length;i++){
				 if (finalSubMenu[i].Function__c == 'Travel Notices') {
					 	finalSubMenu.splice(i, 1); 
				 	}
			  }
		  }*/
		 component.set("v.LoadSubMenu",finalSubMenu);
		 var ele = document.getElementById('divAccountServiceSubMenu');
		 ele.style = '';
	},
	
	xpressRefiPageCall : function (component, event, helper) {
        
        var recordId = component.get("v.recordId");
        var x = screen.width/2 - 900/2;
        var y = screen.height/2 - 600/2;
        var url = '/apex/xpressRefi?MemberId=' + recordId;
        window.open(url, '_blank', 'height=500,width=900,left='+x+',top='+y);
       
	},
 
	loadComponent : function(component, event, helper) {		
		 var submenu = component.get("v.SubMenu");
		 var clicked = event.target.text;
			 event.target.classList.add("visited");
			   event.target.parentElement.classList.add("visited");
			 var submenus = document.getElementsByClassName("clsSubMenu")
			 for(var i=0; i<submenus.length;i++){		
				 if(submenus[i].innerText != clicked){
					 submenus[i].children[0].classList.remove("visited");
	                 submenus[i].children[0].parentElement.classList.remove("visited");
				 }
			 }
			 
			 var Component='';
			 var Url = '';
			 for(var i=0; i<submenu.length;i++){
				 if(submenu[i].Function__c == clicked){
					 if(submenu[i].Command__c != undefined){
						 Component = "c:" + (submenu[i].Command__c);
						 break;
		 			 }
		 			 if(submenu[i].URL__c != undefined){
						 Url = submenu[i].URL__c;
					     break;
		 			 }
				 }
			 }
			 
			 component.set("v.componentToOpen",Component);
			 	
			 	if(Url != ''){
			 		window.open(Url);
			 	}
			 	if(Component != ''){
				 var cmp = document.getElementsByClassName('divMenu');
				 cmp.style = 'display:none';
	             for(var i=0; i<cmp.length; i++){
	                 cmp[i].style='display:none';                 
	             }
				 //var cmp1 = document.getElementById('tblSearch');
				 //cmp1.style = 'display:none';
				 var header = document.getElementsByClassName('slds-modal__header');
				 if(header != null){
					  for(var i=0; i<header.length; i++){
	                 	header[i].style='display:none';                 
	            	 }
				 }
		         var footer = document.getElementsByClassName('modal-footer');
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
		
		
	},
	
	expandMenu: function(component, event, helper) {	
	     var submenu = component.get("v.SubMenu");
		 var clicked = event.target.text;
		 
		 var index =  event.target.parentElement.id
		//  event.target.classList.add("visited");
		// component.set("v.LoadSubMenu",finalSubMenu);
		 var ele = document.getElementById('divAccountServiceSubMenu'+index);
		 if(ele.style.display == ''){
			 ele.style.display = 'none';
			 event.target.parentElement.firstChild.innerHTML='&#9658;'
		 }
		 else{
			 ele.style.display = '';
			 event.target.parentElement.firstChild.innerHTML='&#9660;'
		 }
		// ele.style = '';
	
	}
})