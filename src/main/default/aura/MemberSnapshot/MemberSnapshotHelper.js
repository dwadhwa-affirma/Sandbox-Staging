({
    getCurrentMAAPLevel:function(component, event, helper){
      var action = component.get("c.getLevel");
	  var recordid = component.get("v.recordId");
	  var parameters = {"accoutid": recordid };
	  action.setParams(parameters);
	  action.setCallback(this, function(response){
	  var status = response.getState();
          if(component.isValid() && status === "SUCCESS")
          {
                var result =  response.getReturnValue();
              	if(result!=null && result.Level != null){
                    component.set("v.Level",result.Level);
                }
          }
      });
        
      $A.enqueueAction(action);
    },
    getAvailableOpportunity:function(component, event, helper){
      var action = component.get("c.GetAvailableOpportunity");
	  var recordid = component.get("v.recordId");
	  var parameters = {"accountId": recordid };
	  action.setParams(parameters);
	  action.setCallback(this, function(response){
	  var status = response.getState();
          if(component.isValid() && status === "SUCCESS")
          {
                var result =  response.getReturnValue();
              	if(result != null){
                    component.set("v.IsOppAvailable",result.length > 0 ? true:false);
                    if(result.length>0){
                        
                    }
                }
          }
      });
        
      $A.enqueueAction(action);
    },
    getPromocode:function(component, event, helper){
      var action = component.get("c.GetPromocode");
	  var recordid = component.get("v.recordId");
	  var parameters = {"accountId": recordid };
	  action.setParams(parameters);
	  action.setCallback(this, function(response){
	  var status = response.getState();
          if(component.isValid() && status === "SUCCESS")
          {
                var result =  response.getReturnValue();
              	if(result != null){
                    component.set("v.Promocode",result);
                }
          }
      });
        
      $A.enqueueAction(action);
    },    
    getSureveyScore:function(component, event, helper){
      var action = component.get("c.GetSurveyScore");
	  var recordid = component.get("v.recordId");
	  var parameters = {"accountId": recordid };
	  action.setParams(parameters);
	  action.setCallback(this, function(response){
	  var status = response.getState();
          if(component.isValid() && status === "SUCCESS")
          {
                var result =  response.getReturnValue();
              	if(result != null){
                    component.set("v.SurveyScore",result);
                    let score=result.MaritzCX__Key_Metric_1_Bar__c;
                    if(result.MaritzCX__Key_Metric_1_Bar__c){
                        if(result.MaritzCX__Key_Metric_1_Bar__c.toString().toLowerCase().includes('out of range')){
                           score= result.MaritzCX__Key_Metric_1_Bar__c.toLowerCase().replace('out of range','');
                        }
                    }
                    component.set("v.SurveyScoreString",score);
                }
          }
      });
        
      $A.enqueueAction(action);
    },
    getFraudWarnings:function(component, event, helper){
      var action = component.get("c.GetFraudWarnings");
	  var recordid = component.get("v.recordId");
	  var parameters = {"accountId": recordid };
	  action.setParams(parameters);
	  action.setCallback(this, function(response){
	  var status = response.getState();
          if(component.isValid() && status === "SUCCESS")
          {
                var result =  response.getReturnValue();
              	if(result.length != null){
                    component.set("v.FraudWarnings",result);
                }
          }
      });
        
      $A.enqueueAction(action);
    },
    getReason:function(component, event, helper,ivrguid){
      var action = component.get("c.getReason");
	  var recordid = component.get("v.recordId");
	  var parameters = {"ivrguid": ivrguid };
	  action.setParams(parameters);
	  action.setCallback(this, function(response){
	  var status = response.getState();
          if(component.isValid() && status === "SUCCESS")
          {
                var result =  response.getReturnValue();
              	if(result != null){
                    component.set("v.Reason",result.IVR_Code__c);
                }
          }
      });
        
      $A.enqueueAction(action);
    },
    getUrlParameter: function(name) {
        name = name.replace(/[\[]/, '\\[').replace(/[\]]/, '\\]');
        var regex = new RegExp('[\\?&]' + name + '=([^&#]*)');
        var results = regex.exec(location.search);
        return results === null ? '' : decodeURIComponent(results[1].replace(/\+/g, ' '));
	},
    getMemberPageMessages:function(cmp, event, helper) {
        var action = cmp.get('c.accountDetails');	   
		action.setParams({actId : cmp.get('v.recordId')});
	    action.setCallback(this, $A.getCallback(function (response) {
	        var state = response.getState();	        
	        if (state === "SUCCESS") {	
              
	          var data = response.getReturnValue();
               cmp.set('v.ShowData', data.ShowData);
               cmp.set('v.Memberisunder18', data.Memberisunder18);
               cmp.set('v.RecordTypeName', data.RecordTypeName);
               cmp.set('v.Memberisnotprimary', data.Memberisnotprimary);
              
               cmp.set('v.MemberRefreshNeeded', data.MemberRefreshNeeded);
               cmp.set('v.Memberhaspartiallycompleted', data.Memberhaspartiallycompleted);
               cmp.set('v.MemberAssessmentHasCompleted', data.MemberAssessmentHasCompleted);

               cmp.set('v.AMemberAssessmentisdue', data.AMemberAssessmentisdue);
               cmp.set('v.MemberOptOut', data.MemberOptOut);
               cmp.set('v.Opt_Out_Date', data.Opt_Out_Date);
               
               cmp.set('v.Highvalueflag', data.Highvalueflag);
               cmp.set('v.Highpotentialflag', data.Highpotentialflag);
                
               cmp.set('v.ShowOTPInvalidAttempt', data.ShowOTPInvalidAttempt);
               cmp.set('v.OTPNextAttemptValidAfterHours', data.OTPNextAttemptValidAfterHours);
               cmp.set('v.IsShowOTPButton', data.IsShowOTPButton); 
                
               cmp.set('v.EStatements', data.EStatements);
               cmp.set('v.DirectDeposit', data.DirectDeposit);
               
	        } 
	        else if (state === "ERROR") {	        	
	           var errors = response.getError();      
	           
	       }
	        
	   }));	   
       $A.enqueueAction(action);
    }
})