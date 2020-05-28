({
	GetMasterLogData: function (component, event, helper, LogId) {
		debugger;
		var action = component.get("c.GetMasterLogData");
			action.setParams({"LogId": LogId});
		    action.setCallback(this, function (response) {
			var status = response.getState();            
				if (component.isValid() && status === "SUCCESS") {
					    var result = response.getReturnValue();
                    
					     if(result !=undefined && result.length > 0){ 
					    					    	
                                     if(result[0].Beneficiary_Details__c != undefined && result[0].Beneficiary_Details__c != '' && result[0].Beneficiary_Details__c.length > 1)
                                     {
                                         component.set("v.IsBeneficiaryAccountVisible", true);
                                     }
                                     if(result[0].JointOwner_Details__c != undefined && result[0].JointOwner_Details__c != '' && result[0].JointOwner_Details__c.length > 1)
                                     {
                                         component.set("v.IsJointAccountVisible", true);
                                     }
                                     if(result[0].CFCU_Card_Number__c != undefined && result[0].CFCU_Card_Number__c != '' && result[0].CFCU_Card_Number__c.length > 1)
                                     {
                                         component.set("v.IsCardVisible", true);
                                     }
                                    
                                     if(result[0].Member_Loan_Detail__c != undefined && result[0].Member_Loan_Detail__c != '' && result[0].Member_Loan_Detail__c.length > 1 )
                                     {
                                         component.set("v.IsLoanAccountVisible", true);
                                     }
                                     if(result[0].SalesforceID__c != undefined && result[0].SalesforceID__c != ''){                                 
                                       
                            			  var action1 = component.get("c.GetCFCUWalletInfo");
                                            action1.setParams({"selectedID": result[0].SalesforceID__c, "IVRGUIDFromUrl": ''});
                                            action1.setCallback(this, function (response) {
                                                    var status = response.getState(); 
                                                        
                                                        if (component.isValid() && status === "SUCCESS") {
                                                         var result1 = response.getReturnValue();
                                                         if(result1.RelationshipData != undefined &&result1.RelationshipData.length > 0){
                                                                    component.set("v.JointAccount", result1.RelationshipData);
                                                                    var BR = [];
                                                                    var JR = [];
                                                                    for(var i=0; i < result1.RelationshipData.length; i++ )
                                                                    {
                                                                        if(result1.RelationshipData[i].RelationShip == '0004/Beneficiary')
                                                                        {
                                                                            BR.push(result1.RelationshipData[i]);
                                                                        }
                                                                        else{
                                                                            JR.push(result1.RelationshipData[i]);
                                                                            
                                                                        }
                                                                    }
                                                                    component.set("v.JointAccountOnly", JR);
                                                                    component.set("v.BeneficiaryAccountOnly", BR);                                                
                                                                   
                                                         }
                                                         if(result1.LoanData!= undefined && result1.LoanData.length > 0){
                                                            component.set("v.LoanAccount", result1.LoanData);
                                                        }
                                                        if(result1.CardDetails.length > 0){
                                                                    component.set("v.Card", result1.CardDetails);
                    
                                                            }   
                                                        }
                                            
                                        
                               		 });
                                 	$A.enqueueAction(action1); 
                             }
                             
					     }		
                            
                            
                            
                   }
                         
                
                    
			});	
				  
			$A.enqueueAction(action); 
	
	},
})