({
	doInit : function(component, event, helper) {
		
		var recordId = component.get("v.recordId"); 
	},
    
    cancelAction: function(component, event, helper) {
    	$A.get("e.force:closeQuickAction").fire();
	},
	
	OpenDescription : function(component, event, helper) {
    	
		var container = component.find("containerCollapsable") ;
		$A.util.toggleClass(container, 'hide');
    },
    
    next: function (component, event, helper) {
        var ProgressBarStep1 = document.getElementById('Step1');
		var ProgressBarStep2 = document.getElementById('Step2');
		var ProgressBarStep3 = document.getElementById('Step3');
		var ProgressBarStep4 = document.getElementById('Step4');
		var ProgressBarStep5 = document.getElementById('Step5');
		var ProgressBarStep6 = document.getElementById('Step6');
		
        var stage1 = document.getElementById('stage1');
        var stage2 = document.getElementById('stage2');
        var stage3 = document.getElementById('stage3');
        var stage4 = document.getElementById('stage4');
        var stage5 = document.getElementById('stage5');
        var stage6 = document.getElementById('stage6');
        
        if(ProgressBarStep1.classList == "halFactive"){
            ProgressBarStep1.classList.remove('halFactive');
            ProgressBarStep1.classList.add('active');
            ProgressBarStep2.classList.add('halFactive');
            
            stage1.classList.remove('show'); 
        	stage1.classList.add('hidden');
        	stage2.classList.add('show');
        	stage2.classList.remove('hidden');
            
        	component.set("v.backButton",false);
            component.set("v.Stage1", "Create");
            return;
        }
        if(ProgressBarStep2.classList == "halFactive"){
            ProgressBarStep1.classList.add('active');
            ProgressBarStep2.classList.remove('halFactive');
            ProgressBarStep2.classList.add('active');
            ProgressBarStep3.classList.add('halFactive');
            
            stage2.classList.remove('show');
        	stage2.classList.add('hidden');
            stage3.classList.add('show');
        	stage3.classList.remove('hidden');
            
        	component.set("v.backButton",false); 
            component.set("v.Stage2", "247286");
            return;
        }
        if(ProgressBarStep3.classList == "halFactive"){
            ProgressBarStep1.classList.add('active');
            ProgressBarStep2.classList.add('active');
            ProgressBarStep3.classList.remove('halFactive');
            ProgressBarStep3.classList.add('active');
            ProgressBarStep4.classList.add('halFactive');
            
            stage3.classList.remove('show');
        	stage3.classList.add('hidden');
            stage4.classList.add('show');
        	stage4.classList.remove('hidden');
            
        	component.set("v.backButton",false);
            component.set("v.Stage3", "5000");
            return;
        }
        if(ProgressBarStep4.classList == "halFactive"){
            ProgressBarStep1.classList.add('active');
            ProgressBarStep2.classList.add('active');
            ProgressBarStep3.classList.add('active');
            ProgressBarStep4.classList.remove('halFactive');
            ProgressBarStep4.classList.add('active');
            ProgressBarStep5.classList.add('halFactive');
            
            stage4.classList.remove('show');
        	stage4.classList.add('hidden');
            stage5.classList.add('show');
        	stage5.classList.remove('hidden');
            
        	component.set("v.backButton",false); 
            component.set("v.Stage4", "Pawtucket  CU");
            return;
        }
        
        if(ProgressBarStep5.classList == "halFactive"){
            ProgressBarStep1.classList.add('active');
            ProgressBarStep2.classList.add('active');
            ProgressBarStep3.classList.add('active');
            ProgressBarStep4.classList.add('active');
            ProgressBarStep5.classList.remove('halFactive');
            ProgressBarStep5.classList.add('active');
            ProgressBarStep6.classList.add('halFactive');
            
            stage5.classList.remove('show');
        	stage5.classList.add('hidden');
            stage6.classList.add('show');
        	stage6.classList.remove('hidden');
            
        	component.set("v.backButton",false); 
            component.set("v.Stage5", "$287.25");
            return;
        }
        
    },
    
    back: function (component, event, helper) {
    	
        var ProgressBarStep1 = document.getElementById('Step1');
		var ProgressBarStep2 = document.getElementById('Step2');
		var ProgressBarStep3 = document.getElementById('Step3');
		var ProgressBarStep4 = document.getElementById('Step4');
		var ProgressBarStep5 = document.getElementById('Step5');
		var ProgressBarStep6 = document.getElementById('Step6');
        
    	var stage1 = document.getElementById('stage1');
        var stage2 = document.getElementById('stage2');
        var stage3 = document.getElementById('stage3');
        var stage4 = document.getElementById('stage4');
        var stage5 = document.getElementById('stage5');
        var stage6 = document.getElementById('stage6');
        
        if(ProgressBarStep2.classList == "halFactive"){
            stage2.classList.remove('show'); 
            stage2.classList.add('hidden');
            stage1.classList.add('show');
            stage1.classList.remove('hidden');
            
            ProgressBarStep1.classList.remove('active');
            ProgressBarStep1.classList.add('halFactive');
            ProgressBarStep2.classList.remove('halFactive');
            
            component.set("v.Stage1", "Waiting");
            component.set("v.backButton",true); 
        }
        
        if(ProgressBarStep3.classList == "halFactive"){
            stage3.classList.remove('show'); 
            stage3.classList.add('hidden');
            stage2.classList.add('show');
            stage2.classList.remove('hidden');
            
            ProgressBarStep2.classList.remove('active');
            ProgressBarStep2.classList.add('halFactive');
            ProgressBarStep3.classList.remove('halFactive');
            
            component.set("v.Stage2", "Waiting");
        }
        
        if(ProgressBarStep4.classList == "halFactive"){
            stage4.classList.remove('show'); 
            stage4.classList.add('hidden');
            stage3.classList.add('show');
            stage3.classList.remove('hidden');
            
            ProgressBarStep3.classList.remove('active');
            ProgressBarStep3.classList.add('halFactive');
            ProgressBarStep4.classList.remove('halFactive');
            
            component.set("v.Stage3", "Waiting");
        }
        
        if(ProgressBarStep5.classList == "halFactive"){
            stage5.classList.remove('show'); 
            stage5.classList.add('hidden');
            stage4.classList.add('show');
            stage4.classList.remove('hidden');
            
            ProgressBarStep4.classList.remove('active');
            ProgressBarStep4.classList.add('halFactive');
            ProgressBarStep5.classList.remove('halFactive');
            
            component.set("v.Stage4", "Waiting"); 
        }
        
        if(ProgressBarStep6.classList == "halFactive"){
            stage6.classList.remove('show'); 
            stage6.classList.add('hidden');
            stage5.classList.add('show');
            stage5.classList.remove('hidden');
            
            ProgressBarStep5.classList.remove('active');
            ProgressBarStep5.classList.add('halFactive');
            ProgressBarStep6.classList.remove('halFactive');
            
            component.set("v.Stage5", "Waiting");   
        }
    },
    
    onRadioChange: function (component, event, helper) {
        var changeValue = event.getParam("value");
        var childRadio = document.getElementById('childRadio');
        if(changeValue == '2'){
        	component.set("v.ActionDisabled",false);    
            childRadio.classList.remove('disable');
        }
        if(changeValue == '1'){
        	component.set("v.ActionDisabled",true);    
            childRadio.classList.add('disable');
        }
    }
})