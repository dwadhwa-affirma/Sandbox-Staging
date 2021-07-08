({
    
    GetJointMemberDetail: function (component, event,helper, memberId, IVRGUIDFromUrl) {
        
        var action = component.get("c.GetCFCUWalletInfo");
        action.setParams({"selectedID": memberId, "IVRGUIDFromUrl": IVRGUIDFromUrl});
        action.setCallback(this, function (response) {
            var status = response.getState();            
            if (component.isValid() && status === "SUCCESS") {
                var result = response.getReturnValue();
                component.set("v.IsCFCUFailOnReload", '');
                component.set("v.IsCFCUFailForTheDay", '');
                
                
                //------------------------ If the CFCU is Failed for the day --------------------------------//
                
                if(result.CFCUReloadManulSessionInfo != undefined){
                    
                    if(result.CFCUReloadManulSessionInfo.length >0 ){ 
                        component.set("v.IsCFCUFailOnReload", result.CFCUReloadManulSessionInfo[0].CFCU_Wallet_Status__c);
                    }
                }	
                
                //------------------------ If the CFCU is Failed for session ---------------------------------//
                
                if(result.CFCULastSessionInfo != undefined){
                    
                    if(result.CFCULastSessionInfo.length > 0){
                        component.set("v.IsCFCUFailForTheDay", result.CFCULastSessionInfo[0].CFCU_Wallet_Status__c);
                    }
                } 
                
                if(result.RelationshipData.length > 0){
                    component.set("v.JointAccount", result.RelationshipData);
                    var BR = [];
                    var JR = [];
                    for(var i=0; i < result.RelationshipData.length; i++ )
                    {
                        if(result.RelationshipData[i].RelationShip == '0004/Beneficiary')
                        {
                            BR.push(result.RelationshipData[i]);
                        }
                        else{
                            JR.push(result.RelationshipData[i]);
                            
                        }
                    }
                    component.set("v.JointAccountOnly", JR);
                    component.set("v.BeneficiaryAccountOnly", BR);
                    
                    component.set("v.IsRelationshipDataAvailable", true);
                }
                else{
                    component.set("v.IsRelationshipDataAvailable", false);
                }
                
                if(result.LoanData.length > 0){
                    component.set("v.LoanAccount", result.LoanData);
                    component.set("v.IsLoanDataAvailable", true);
                }
                else
                {component.set("v.IsLoanDataAvailable", false);
                }
                if(result.CardDetails.length > 0){
                    component.set("v.Card", result.CardDetails);
                    component.set("v.IsCardDetailsAvailable", true);
                }
                else{
                    component.set("v.IsCardDetailsAvailable", false);
                }
                if(result.CFCULastSessionInfo != undefined && result.CFCULastSessionInfo.length > 0 && result.CFCULastSessionInfo[0].CFCU_Wallet_Status__c != undefined && component.get("v.IsUserSessionLoaded") == true){
                    
                    component.set("v.CFCULastSessionInfo", result.CFCULastSessionInfo);
                    if(result.CFCULastSessionInfo[0].BeneficiaryDetailMatch__c == undefined){
                        component.find('BeneficiaryPassButton').set("v.variant", "neutral");
                        component.find('BeneficiaryFailButton').set("v.variant", "neutral");
                    }		    		
                    if(result.CFCULastSessionInfo[0].BeneficiaryDetailMatch__c == 'Pass'){
                        component.find('BeneficiaryPassButton').set("v.variant", "success");
                        component.find('BeneficiaryFailButton').set("v.variant", "neutral");
                    }
                    if(result.CFCULastSessionInfo[0].BeneficiaryDetailMatch__c == 'Fail'){
                        component.find('BeneficiaryFailButton').set("v.variant", "destructive");
                        component.find('BeneficiaryPassButton').set("v.variant", "neutral");
                    }
                    
                    
                    if(result.CFCULastSessionInfo[0].Joint_OwnerDetailsMatch__c == undefined){
                        component.find('JointPassButton').set("v.variant", "neutral");
                        component.find('JointFailButton').set("v.variant", "neutral");
                    }
                    if(result.CFCULastSessionInfo[0].Joint_OwnerDetailsMatch__c == 'Pass'){
                        component.find('JointPassButton').set("v.variant", "success");
                        component.find('JointFailButton').set("v.variant", "neutral");
                    }
                    if(result.CFCULastSessionInfo[0].Joint_OwnerDetailsMatch__c == 'Fail'){
                        component.find('JointFailButton').set("v.variant", "destructive");
                        component.find('JointPassButton').set("v.variant", "neutral");
                    }
                    
                    
                    if(result.CFCULastSessionInfo[0].Loan_Detail_Match__c == undefined){
                        component.find('LoanPassButton').set("v.variant", "neutral");
                        component.find('LoanFailButton').set("v.variant", "neutral");
                    }
                    if(result.CFCULastSessionInfo[0].Loan_Detail_Match__c == 'Pass'){
                        component.find('LoanPassButton').set("v.variant", "success");
                        component.find('LoanFailButton').set("v.variant", "neutral");
                    }
                    if(result.CFCULastSessionInfo[0].Loan_Detail_Match__c == 'Fail'){
                        component.find('LoanFailButton').set("v.variant", "destructive");
                        component.find('LoanPassButton').set("v.variant", "neutral");
                    }
                    
                    
                    if(component.get("v.IsCFCUSectionVisible") == true){ 
                        if(result.CFCULastSessionInfo[0].CardNumberMatch__c == undefined){
                            component.find('CardPassButton').set("v.variant", "neutral");
                            component.find('CardFailButton').set("v.variant", "neutral");
                        }
                        if(result.CFCULastSessionInfo[0].CardNumberMatch__c == 'Pass'){
                            component.find('CardPassButton').set("v.variant", "success");
                            component.find('CardFailButton').set("v.variant", "neutral");
                        }
                        if(result.CFCULastSessionInfo[0].CardNumberMatch__c == 'Fail'){
                            component.find('CardFailButton').set("v.variant", "destructive");
                            component.find('CardPassButton').set("v.variant", "neutral");
                        }
                    }
                    
                    if(result.CFCULastSessionInfo[0].Additional_Token_Option1_Match__c == undefined){
                        component.find('TokenPassButton1').set("v.variant", "neutral");
                        component.find('TokenFailButton1').set("v.variant", "neutral");
                    }		    		
                    if(result.CFCULastSessionInfo[0].Additional_Token_Option1_Match__c == 'Pass'){
                        component.find('TokenPassButton1').set("v.variant", "success");
                        component.find('TokenFailButton1').set("v.variant", "neutral");
            		    component.find("AdditionalToken1").set("v.value",result.CFCULastSessionInfo[0].Additional_Token_Option1__c);
                    }
                    if(result.CFCULastSessionInfo[0].Additional_Token_Option1_Match__c == 'Fail'){
                        component.find('TokenFailButton1').set("v.variant", "destructive");
                        component.find('TokenPassButton1').set("v.variant", "neutral");
                        component.find("AdditionalToken1").set("v.value",result.CFCULastSessionInfo[0].Additional_Token_Option1__c);
                    }
                    
                    if(result.CFCULastSessionInfo[0].Additional_Token_Option2_Match__c == undefined){
                        component.find('TokenPassButton2').set("v.variant", "neutral");
                        component.find('TokenFailButton2').set("v.variant", "neutral");
                    }
                    if(result.CFCULastSessionInfo[0].Additional_Token_Option2_Match__c == 'Pass'){
                        component.find('TokenPassButton2').set("v.variant", "success");
                        component.find('TokenFailButton2').set("v.variant", "neutral");
                        component.find("AdditionalToken2").set("v.value",result.CFCULastSessionInfo[0].Additional_Token_Option2__c);
                    }
                    if(result.CFCULastSessionInfo[0].Additional_Token_Option2_Match__c == 'Fail'){
                        component.find('TokenFailButton2').set("v.variant", "destructive");
                        component.find('TokenPassButton2').set("v.variant", "neutral");
                        component.find("AdditionalToken2").set("v.value",result.CFCULastSessionInfo[0].Additional_Token_Option2__c);
                    }
                    
                    
                    if(result.CFCULastSessionInfo[0].Additional_Token_Option5_Match__c == undefined){
                        component.find('TokenPassButton3').set("v.variant", "neutral");
                        component.find('TokenFailButton3').set("v.variant", "neutral");
                    }
                    if(result.CFCULastSessionInfo[0].Additional_Token_Option5_Match__c == 'Pass'){
                        component.find('TokenPassButton3').set("v.variant", "success");
                        component.find('TokenFailButton3').set("v.variant", "neutral");
                        component.find("AdditionalToken3").set("v.value",result.CFCULastSessionInfo[0].Additional_Token_Option5__c);	
                    }
                    if(result.CFCULastSessionInfo[0].Additional_Token_Option5_Match__c == 'Fail'){
                        component.find('TokenFailButton3').set("v.variant", "destructive");
                        component.find('TokenPassButton3').set("v.variant", "neutral");
                        component.find("AdditionalToken3").set("v.value",result.CFCULastSessionInfo[0].Additional_Token_Option5__c);
                    }
                    
                    if(result.CFCULastSessionInfo[0].Additional_Token_Option6_Match__c == undefined){
                        component.find('TokenPassButton4').set("v.variant", "neutral");
                        component.find('TokenFailButton4').set("v.variant", "neutral");
                    }
                    if(result.CFCULastSessionInfo[0].Additional_Token_Option6_Match__c == 'Pass'){
                        component.find('TokenPassButton4').set("v.variant", "success");
                        component.find('TokenFailButton4').set("v.variant", "neutral");
                        component.find("AdditionalToken4").set("v.value",result.CFCULastSessionInfo[0].Additional_Token_Option6__c);
                    }
                    if(result.CFCULastSessionInfo[0].Additional_Token_Option6_Match__c == 'Fail'){
                        component.find('TokenFailButton4').set("v.variant", "destructive");
                        component.find('TokenPassButton4').set("v.variant", "neutral");
                        component.find("AdditionalToken4").set("v.value",result.CFCULastSessionInfo[0].Additional_Token_Option6__c);
                    }
                }
                else if(result.CFCULastSessionInfo !=undefined && result.CFCULastSessionInfo.length > 0 && result.CFCULastSessionInfo[0].CFCU_Wallet_Status__c != undefined  && component.get("v.IsUserSessionLoaded") == false  && component.get("v.IsReLoadRequired") == false){
                    
                    component.set("v.CFCULastSessionInfo", result.CFCULastSessionInfo);
                    if(result.CFCULastSessionInfo[0].CFCU_Wallet_Status__c == 'Pass'){
                        
                        helper.buttonOnLoad(component, event, helper);
                    }
                    else if(result.CFCULastSessionInfo[0].CFCU_Wallet_Status__c == 'Fail'){
                        
                        if(result.CFCULastSessionInfo[0].BeneficiaryDetailMatch__c == undefined){
                            component.find('BeneficiaryPassButton').set("v.variant", "neutral");
                            component.find('BeneficiaryFailButton').set("v.variant", "neutral");
                        }		    		
                        if(result.CFCULastSessionInfo[0].BeneficiaryDetailMatch__c == 'Pass'){
                            component.find('BeneficiaryPassButton').set("v.variant", "success");
                            component.find('BeneficiaryFailButton').set("v.variant", "neutral");
                        }
                        if(result.CFCULastSessionInfo[0].BeneficiaryDetailMatch__c == 'Fail'){
                            component.find('BeneficiaryFailButton').set("v.variant", "destructive");
                            component.find('BeneficiaryPassButton').set("v.variant", "neutral");
                        }
                        
                        
                        if(result.CFCULastSessionInfo[0].Joint_OwnerDetailsMatch__c == undefined){
                            component.find('JointPassButton').set("v.variant", "neutral");
                            component.find('JointFailButton').set("v.variant", "neutral");
                        }
                        if(result.CFCULastSessionInfo[0].Joint_OwnerDetailsMatch__c == 'Pass'){
                            component.find('JointPassButton').set("v.variant", "success");
                            component.find('JointFailButton').set("v.variant", "neutral");
                        }
                        if(result.CFCULastSessionInfo[0].Joint_OwnerDetailsMatch__c == 'Fail'){
                            component.find('JointFailButton').set("v.variant", "destructive");
                            component.find('JointPassButton').set("v.variant", "neutral");
                        }
                        
                        
                        if(result.CFCULastSessionInfo[0].Loan_Detail_Match__c == undefined){
                            component.find('LoanPassButton').set("v.variant", "neutral");
                            component.find('LoanFailButton').set("v.variant", "neutral");
                        }
                        if(result.CFCULastSessionInfo[0].Loan_Detail_Match__c == 'Pass'){
                            component.find('LoanPassButton').set("v.variant", "success");
                            component.find('LoanFailButton').set("v.variant", "neutral");
                        }
                        if(result.CFCULastSessionInfo[0].Loan_Detail_Match__c == 'Fail'){
                            component.find('LoanFailButton').set("v.variant", "destructive");
                            component.find('LoanPassButton').set("v.variant", "neutral");
                        }
                        
                        
                        if(component.get("v.IsCFCUSectionVisible") == true){ 
                            if(result.CFCULastSessionInfo[0].CardNumberMatch__c == undefined){
                                component.find('CardPassButton').set("v.variant", "neutral");
                                component.find('CardFailButton').set("v.variant", "neutral");
                            }
                            if(result.CFCULastSessionInfo[0].CardNumberMatch__c == 'Pass'){
                                component.find('CardPassButton').set("v.variant", "success");
                                component.find('CardFailButton').set("v.variant", "neutral");
                            }
                            if(result.CFCULastSessionInfo[0].CardNumberMatch__c == 'Fail'){
                                component.find('CardFailButton').set("v.variant", "destructive");
                                component.find('CardPassButton').set("v.variant", "neutral");
                            }
                        }
                        
                        if(result.CFCULastSessionInfo[0].Additional_Token_Option1_Match__c == undefined){
                            component.find('TokenPassButton1').set("v.variant", "neutral");
                            component.find('TokenFailButton1').set("v.variant", "neutral");
                        }		    		
                        if(result.CFCULastSessionInfo[0].Additional_Token_Option1_Match__c == 'Pass'){
                            component.find('TokenPassButton1').set("v.variant", "success");
                            component.find('TokenFailButton1').set("v.variant", "neutral");
                            component.find("AdditionalToken1").set("v.value",result.CFCULastSessionInfo[0].Additional_Token_Option1__c);
                        }
                        if(result.CFCULastSessionInfo[0].Additional_Token_Option1_Match__c == 'Fail'){
                            component.find('TokenFailButton1').set("v.variant", "destructive");
                            component.find('TokenPassButton1').set("v.variant", "neutral");
                            component.find("AdditionalToken1").set("v.value",result.CFCULastSessionInfo[0].Additional_Token_Option1__c);
                        }
                        
                        if(result.CFCULastSessionInfo[0].Additional_Token_Option2_Match__c == undefined){
                            component.find('TokenPassButton2').set("v.variant", "neutral");
                            component.find('TokenFailButton2').set("v.variant", "neutral");
                        }
                        if(result.CFCULastSessionInfo[0].Additional_Token_Option2_Match__c == 'Pass'){
                            component.find('TokenPassButton2').set("v.variant", "success");
                            component.find('TokenFailButton2').set("v.variant", "neutral");
                            component.find("AdditionalToken2").set("v.value",result.CFCULastSessionInfo[0].Additional_Token_Option2__c);
                        }
                        if(result.CFCULastSessionInfo[0].Additional_Token_Option2_Match__c == 'Fail'){
                            component.find('TokenFailButton2').set("v.variant", "destructive");
                            component.find('TokenPassButton2').set("v.variant", "neutral");
                            component.find("AdditionalToken2").set("v.value",result.CFCULastSessionInfo[0].Additional_Token_Option2__c);
                        }
                        
                        if(result.CFCULastSessionInfo[0].Additional_Token_Option5_Match__c == undefined){
                            component.find('TokenPassButton3').set("v.variant", "neutral");
                            component.find('TokenFailButton3').set("v.variant", "neutral");
                        }
                        if(result.CFCULastSessionInfo[0].Additional_Token_Option5_Match__c == 'Pass'){
                            component.find('TokenPassButton3').set("v.variant", "success");
                            component.find('TokenFailButton3').set("v.variant", "neutral");
                            component.find("AdditionalToken3").set("v.value",result.CFCULastSessionInfo[0].Additional_Token_Option5__c);
                        }
                        if(result.CFCULastSessionInfo[0].Additional_Token_Option5_Match__c == 'Fail'){
                            component.find('TokenFailButton3').set("v.variant", "destructive");
                            component.find('TokenPassButton3').set("v.variant", "neutral");
                            component.find("AdditionalToken3").set("v.value",result.CFCULastSessionInfo[0].Additional_Token_Option5__c);
                        }
                        
                        if(result.CFCULastSessionInfo[0].Additional_Token_Option6_Match__c == undefined){
                            component.find('TokenPassButton4').set("v.variant", "neutral");
                            component.find('TokenFailButton4').set("v.variant", "neutral");
                        }
                        if(result.CFCULastSessionInfo[0].Additional_Token_Option6_Match__c == 'Pass'){
                            component.find('TokenPassButton4').set("v.variant", "success");
                            component.find('TokenFailButton4').set("v.variant", "neutral");
                            component.find("AdditionalToken4").set("v.value",result.CFCULastSessionInfo[0].Additional_Token_Option6__c);
                        }
                        if(result.CFCULastSessionInfo[0].Additional_Token_Option6_Match__c == 'Fail'){
                            component.find('TokenFailButton4').set("v.variant", "destructive");
                            component.find('TokenPassButton4').set("v.variant", "neutral");
                            component.find("AdditionalToken4").set("v.value",result.CFCULastSessionInfo[0].Additional_Token_Option6__c);
                        }
                        
                    }		    		
                }
                
                    else if(component.get("v.IsReLoadRequired") != false  ){
                        
                        if(result.CFCUReloadInfo != undefined && result.CFCUReloadInfo.length > 0 && component.get("v.IsReLoadRequired") == true){
                            
                            if(result.CFCUReloadInfo[0].BeneficiaryDetailMatch__c == undefined){
                                component.find('BeneficiaryPassButton').set("v.variant", "neutral");
                                component.find('BeneficiaryFailButton').set("v.variant", "neutral");
                            }		    		
                            if(result.CFCUReloadInfo[0].BeneficiaryDetailMatch__c == 'Pass'){
                                component.find('BeneficiaryPassButton').set("v.variant", "success");
                                component.find('BeneficiaryFailButton').set("v.variant", "neutral");
                            }
                            if(result.CFCUReloadInfo[0].BeneficiaryDetailMatch__c == 'Fail'){
                                component.find('BeneficiaryFailButton').set("v.variant", "destructive");
                                component.find('BeneficiaryPassButton').set("v.variant", "neutral");
                            }
                            
                            
                            if(result.CFCUReloadInfo[0].Joint_OwnerDetailsMatch__c == undefined){
                                component.find('JointPassButton').set("v.variant", "neutral");
                                component.find('JointFailButton').set("v.variant", "neutral");
                            }
                            if(result.CFCUReloadInfo[0].Joint_OwnerDetailsMatch__c == 'Pass'){
                                component.find('JointPassButton').set("v.variant", "success");
                                component.find('JointFailButton').set("v.variant", "neutral");
                            }
                            if(result.CFCUReloadInfo[0].Joint_OwnerDetailsMatch__c == 'Fail'){
                                component.find('JointFailButton').set("v.variant", "destructive");
                                component.find('JointPassButton').set("v.variant", "neutral");
                            }
                            
                            
                            if(result.CFCUReloadInfo[0].Loan_Detail_Match__c == undefined){
                                component.find('LoanPassButton').set("v.variant", "neutral");
                                component.find('LoanFailButton').set("v.variant", "neutral");
                            }
                            if(result.CFCUReloadInfo[0].Loan_Detail_Match__c == 'Pass'){
                                component.find('LoanPassButton').set("v.variant", "success");
                                component.find('LoanFailButton').set("v.variant", "neutral");
                            }
                            if(result.CFCUReloadInfo[0].Loan_Detail_Match__c == 'Fail'){
                                component.find('LoanFailButton').set("v.variant", "destructive");
                                component.find('LoanPassButton').set("v.variant", "neutral");
                            }
                            
                            
                            if(component.get("v.IsCFCUSectionVisible") == true){ 
                                if(result.CFCUReloadInfo[0].CardNumberMatch__c == undefined){
                                    component.find('CardPassButton').set("v.variant", "neutral");
                                    component.find('CardFailButton').set("v.variant", "neutral");
                                }
                                if(result.CFCUReloadInfo[0].CardNumberMatch__c == 'Pass'){
                                    component.find('CardPassButton').set("v.variant", "success");
                                    component.find('CardFailButton').set("v.variant", "neutral");
                                }
                                if(result.CFCUReloadInfo[0].CardNumberMatch__c == 'Fail'){
                                    component.find('CardFailButton').set("v.variant", "destructive");
                                    component.find('CardPassButton').set("v.variant", "neutral");
                                }
                            }
                            
                            if(result.CFCUReloadInfo[0].Additional_Token_Option1_Match__c == undefined){
                                component.find('TokenPassButton1').set("v.variant", "neutral");
                                component.find('TokenFailButton1').set("v.variant", "neutral");
                            }		    		
                            if(result.CFCUReloadInfo[0].Additional_Token_Option1_Match__c == 'Pass'){
                                component.find('TokenPassButton1').set("v.variant", "success");
                                component.find('TokenFailButton1').set("v.variant", "neutral");
                                component.find("AdditionalToken1").set("v.value",result.CFCULastSessionInfo[0].Additional_Token_Option1__c);
                            }
                            if(result.CFCUReloadInfo[0].Additional_Token_Option1_Match__c == 'Fail'){
                                component.find('TokenFailButton1').set("v.variant", "destructive");
                                component.find('TokenPassButton1').set("v.variant", "neutral");
                                component.find("AdditionalToken1").set("v.value",result.CFCULastSessionInfo[0].Additional_Token_Option1__c);
                            }
                            
                            if(result.CFCUReloadInfo[0].Additional_Token_Option2_Match__c == undefined){
                                component.find('TokenPassButton2').set("v.variant", "neutral");
                                component.find('TokenFailButton2').set("v.variant", "neutral");
                            }
                            if(result.CFCUReloadInfo[0].Additional_Token_Option2_Match__c == 'Pass'){
                                component.find('TokenPassButton2').set("v.variant", "success");
                                component.find('TokenFailButton2').set("v.variant", "neutral");
                                component.find("AdditionalToken2").set("v.value",result.CFCULastSessionInfo[0].Additional_Token_Option2__c);
                            }
                            if(result.CFCUReloadInfo[0].Additional_Token_Option2_Match__c == 'Fail'){
                                component.find('TokenFailButton2').set("v.variant", "destructive");
                                component.find('TokenPassButton2').set("v.variant", "neutral");
                                component.find("AdditionalToken2").set("v.value",result.CFCULastSessionInfo[0].Additional_Token_Option2__c);
                            }
                            
                            if(result.CFCUReloadInfo[0].Additional_Token_Option5_Match__c == undefined){
                                component.find('TokenPassButton3').set("v.variant", "neutral");
                                component.find('TokenFailButton3').set("v.variant", "neutral");
                            }
                            if(result.CFCUReloadInfo[0].Additional_Token_Option5_Match__c == 'Pass'){
                                component.find('TokenPassButton3').set("v.variant", "success");
                                component.find('TokenFailButton3').set("v.variant", "neutral");
                                component.find("AdditionalToken3").set("v.value",result.CFCULastSessionInfo[0].Additional_Token_Option5__c);	
                            }
                            if(result.CFCUReloadInfo[0].Additional_Token_Option5_Match__c == 'Fail'){
                                component.find('TokenFailButton3').set("v.variant", "destructive");
                                component.find('TokenPassButton3').set("v.variant", "neutral");
                                component.find("AdditionalToken3").set("v.value",result.CFCULastSessionInfo[0].Additional_Token_Option5__c);	
                            }
                            
                            if(result.CFCUReloadInfo[0].Additional_Token_Option6_Match__c == undefined){
                                component.find('TokenPassButton4').set("v.variant", "neutral");
                                component.find('TokenFailButton4').set("v.variant", "neutral");
                            }
                            if(result.CFCUReloadInfo[0].Additional_Token_Option6_Match__c == 'Pass'){
                                component.find('TokenPassButton4').set("v.variant", "success");
                                component.find('TokenFailButton4').set("v.variant", "neutral");
                                component.find("AdditionalToken4").set("v.value",result.CFCULastSessionInfo[0].Additional_Token_Option6__c);	
                            }
                            if(result.CFCUReloadInfo[0].Additional_Token_Option6_Match__c == 'Fail'){
                                component.find('TokenFailButton4').set("v.variant", "destructive");
                                component.find('TokenPassButton4').set("v.variant", "neutral");
                                component.find("AdditionalToken4").set("v.value",result.CFCULastSessionInfo[0].Additional_Token_Option6__c);	
                            }
                            
                        }else if(result.CFCUReloadManulSessionInfo != undefined && result.CFCUReloadManulSessionInfo.length > 0 && component.get("v.IsReLoadRequired") == undefined){
                            
                            if(result.CFCUReloadManulSessionInfo[0].BeneficiaryDetailMatch__c == undefined){
                                component.find('BeneficiaryPassButton').set("v.variant", "neutral");
                                component.find('BeneficiaryFailButton').set("v.variant", "neutral");
                            }		    		
                            if(result.CFCUReloadManulSessionInfo[0].BeneficiaryDetailMatch__c == 'Pass'){
                                component.find('BeneficiaryPassButton').set("v.variant", "success");
                                component.find('BeneficiaryFailButton').set("v.variant", "neutral");
                            }
                            if(result.CFCUReloadManulSessionInfo[0].BeneficiaryDetailMatch__c == 'Fail'){
                                component.find('BeneficiaryFailButton').set("v.variant", "destructive");
                                component.find('BeneficiaryPassButton').set("v.variant", "neutral");
                            }
                            
                            
                            if(result.CFCUReloadManulSessionInfo[0].Joint_OwnerDetailsMatch__c == undefined){
                                component.find('JointPassButton').set("v.variant", "neutral");
                                component.find('JointFailButton').set("v.variant", "neutral");
                            }
                            if(result.CFCUReloadManulSessionInfo[0].Joint_OwnerDetailsMatch__c == 'Pass'){
                                component.find('JointPassButton').set("v.variant", "success");
                                component.find('JointFailButton').set("v.variant", "neutral");
                            }
                            if(result.CFCUReloadManulSessionInfo[0].Joint_OwnerDetailsMatch__c == 'Fail'){
                                component.find('JointFailButton').set("v.variant", "destructive");
                                component.find('JointPassButton').set("v.variant", "neutral");
                            }
                            
                            
                            if(result.CFCUReloadManulSessionInfo[0].Loan_Detail_Match__c == undefined){
                                component.find('LoanPassButton').set("v.variant", "neutral");
                                component.find('LoanFailButton').set("v.variant", "neutral");
                            }
                            if(result.CFCUReloadManulSessionInfo[0].Loan_Detail_Match__c == 'Pass'){
                                component.find('LoanPassButton').set("v.variant", "success");
                                component.find('LoanFailButton').set("v.variant", "neutral");
                            }
                            if(result.CFCUReloadManulSessionInfo[0].Loan_Detail_Match__c == 'Fail'){
                                component.find('LoanFailButton').set("v.variant", "destructive");
                                component.find('LoanPassButton').set("v.variant", "neutral");
                            }
                            
                            
                            if(component.get("v.IsCFCUSectionVisible") == true){ 
                                if(result.CFCUReloadManulSessionInfo[0].CardNumberMatch__c == undefined){
                                    component.find('CardPassButton').set("v.variant", "neutral");
                                    component.find('CardFailButton').set("v.variant", "neutral");
                                }
                                if(result.CFCUReloadManulSessionInfo[0].CardNumberMatch__c == 'Pass'){
                                    component.find('CardPassButton').set("v.variant", "success");
                                    component.find('CardFailButton').set("v.variant", "neutral");
                                }
                                if(result.CFCUReloadManulSessionInfo[0].CardNumberMatch__c == 'Fail'){
                                    component.find('CardFailButton').set("v.variant", "destructive");
                                    component.find('CardPassButton').set("v.variant", "neutral");
                                }
                            }
                            
                            if(result.CFCUReloadManulSessionInfo[0].Additional_Token_Option1_Match__c == undefined){
                                component.find('TokenPassButton1').set("v.variant", "neutral");
                                component.find('TokenFailButton1').set("v.variant", "neutral");
                            }		    		
                            if(result.CFCUReloadManulSessionInfo[0].Additional_Token_Option1_Match__c == 'Pass'){
                                component.find('TokenPassButton1').set("v.variant", "success");
                                component.find('TokenFailButton1').set("v.variant", "neutral");
                                component.find("AdditionalToken1").set("v.value",result.CFCULastSessionInfo[0].Additional_Token_Option1__c);
                            }
                            if(result.CFCUReloadManulSessionInfo[0].Additional_Token_Option1_Match__c == 'Fail'){
                                component.find('TokenFailButton1').set("v.variant", "destructive");
                                component.find('TokenPassButton1').set("v.variant", "neutral");
                                component.find("AdditionalToken1").set("v.value",result.CFCULastSessionInfo[0].Additional_Token_Option1__c);
                            }
                            
                            if(result.CFCUReloadManulSessionInfo[0].Additional_Token_Option2_Match__c == undefined){
                                component.find('TokenPassButton2').set("v.variant", "neutral");
                                component.find('TokenFailButton2').set("v.variant", "neutral");
                            }
                            if(result.CFCUReloadManulSessionInfo[0].Additional_Token_Option2_Match__c == 'Pass'){
                                component.find('TokenPassButton2').set("v.variant", "success");
                                component.find('TokenFailButton2').set("v.variant", "neutral");
                                component.find("AdditionalToken2").set("v.value",result.CFCULastSessionInfo[0].Additional_Token_Option2__c);
                            }
                            if(result.CFCUReloadManulSessionInfo[0].Additional_Token_Option2_Match__c == 'Fail'){
                                component.find('TokenFailButton2').set("v.variant", "destructive");
                                component.find('TokenPassButton2').set("v.variant", "neutral");
                                component.find("AdditionalToken2").set("v.value",result.CFCULastSessionInfo[0].Additional_Token_Option2__c);
                            }
                            
                            if(result.CFCUReloadManulSessionInfo[0].Additional_Token_Option5_Match__c == undefined){
                                component.find('TokenPassButton3').set("v.variant", "neutral");
                                component.find('TokenFailButton3').set("v.variant", "neutral");
                            }
                            if(result.CFCUReloadManulSessionInfo[0].Additional_Token_Option5_Match__c == 'Pass'){
                                component.find('TokenPassButton3').set("v.variant", "success");
                                component.find('TokenFailButton3').set("v.variant", "neutral");
                                component.find("AdditionalToken3").set("v.value",result.CFCULastSessionInfo[0].Additional_Token_Option5__c);	
                            }
                            if(result.CFCUReloadManulSessionInfo[0].Additional_Token_Option5_Match__c == 'Fail'){
                                component.find('TokenFailButton3').set("v.variant", "destructive");
                                component.find('TokenPassButton3').set("v.variant", "neutral");
                                component.find("AdditionalToken3").set("v.value",result.CFCULastSessionInfo[0].Additional_Token_Option5__c);	
                            }
                            
                            if(result.CFCUReloadManulSessionInfo[0].Additional_Token_Option6_Match__c == undefined){
                                component.find('TokenPassButton3').set("v.variant", "neutral");
                                component.find('TokenFailButton3').set("v.variant", "neutral");
                            }
                            if(result.CFCUReloadManulSessionInfo[0].Additional_Token_Option6_Match__c == 'Pass'){
                                component.find('TokenPassButton3').set("v.variant", "success");
                                component.find('TokenFailButton3').set("v.variant", "neutral");
                                component.find("AdditionalToken4").set("v.value",result.CFCULastSessionInfo[0].Additional_Token_Option6__c);
                            }
                            if(result.CFCUReloadManulSessionInfo[0].Additional_Token_Option6_Match__c == 'Fail'){
                                component.find('TokenFailButton3').set("v.variant", "destructive");
                                component.find('TokenPassButton3').set("v.variant", "neutral");
                                component.find("AdditionalToken4").set("v.value",result.CFCULastSessionInfo[0].Additional_Token_Option6__c);
                            }
                            
                        }
                    }
            }
        });	
        
        $A.enqueueAction(action); 
    },
    ButtonPassFailMethod : function(component, event, helper,ButtonId,Button) {
        if(component.get("v.IsSubmitClicked") == false)
        {	
            var BeneficiaryDetailMatch;
            var JointOwnerDetailMatch;
            var CardNumberMatch;
            var AdditionalTokenOption1Match;
            var AdditionalTokenOption2Match;
            var AdditionalTokenOption3Match;
            var AdditionalTokenOption4Match;
            var LoanDetailMatch;
            var findOtherButton;
            var ScoreObtained = component.get("v.ScoreObtained");
            var FailedCount = component.get("v.FailedCount");
            
            var token1 = component.find("AdditionalToken1").get("v.value");
            var token2 = component.find("AdditionalToken2").get("v.value");
            var token3 = component.find("AdditionalToken3").get("v.value");
            var token4 = component.find("AdditionalToken4").get("v.value");
            var QuestionAttempt = component.get("v.QuestionAttempt");
            var IsCFCUFailForTheDay = component.get("v.IsCFCUFailForTheDay");
            var IsCFCUFailOnReload = component.get("v.IsCFCUFailOnReload");
            
            findOtherButton = component.find('BeneficiaryFailButton');
            
            if(ButtonId =='BeneficiaryPassButton'){
                
                if(Button.get("v.variant") ==  "success"){
                     QuestionAttempt = parseInt(QuestionAttempt) - 1;
                    Button.set("v.variant", "neutral");
                    ScoreObtained = parseInt(ScoreObtained) - 1;
                    BeneficiaryDetailMatch = '';
                }
                else if(Button.get("v.variant") ==  "neutral"  && findOtherButton.get("v.variant" ) == "neutral"){
                    QuestionAttempt = parseInt(QuestionAttempt) + 1;
                    Button.set("v.variant", "success");
                    ScoreObtained = parseInt(ScoreObtained) + 1;
                    BeneficiaryDetailMatch = 'Pass';
                }
                else
                {
                    FailedCount = parseInt(FailedCount) - 1;
                    component.set("v.FailedCount",FailedCount);
                    Button.set("v.variant", "success");
                    ScoreObtained = parseInt(ScoreObtained) + 1;
                    BeneficiaryDetailMatch = 'Pass';
                }
                component.set("v.QuestionAttempt",QuestionAttempt );
				component.set("v.ScoreObtained",ScoreObtained);
                findOtherButton.set("v.variant", "neutral");                
                component.set("v.BeneficiaryDetailMatch",BeneficiaryDetailMatch);
                if(QuestionAttempt >=3 && IsCFCUFailForTheDay != 'Fail' && IsCFCUFailOnReload != 'Fail'){
                    component.set("v.IsButtonDisabled",false);
                }
            }
            else if(ButtonId =='BeneficiaryFailButton'){        
                
                findOtherButton = component.find('BeneficiaryPassButton');
                if(Button.get("v.variant") ==  "destructive"){
                    FailedCount = parseInt(FailedCount) - 1;
                    Button.set("v.variant", "neutral");
                    BeneficiaryDetailMatch = '';
                    QuestionAttempt = parseInt(QuestionAttempt) - 1;
                }
                else if(Button.get("v.variant") ==  "neutral"  && findOtherButton.get("v.variant" ) == "neutral"){
                    QuestionAttempt = parseInt(QuestionAttempt) + 1;
                    FailedCount = parseInt(FailedCount) + 1;
                    Button.set("v.variant", "destructive");
                    BeneficiaryDetailMatch = 'Fail';
                }
                else
                {
                    ScoreObtained = parseInt(ScoreObtained) - 1;
                    component.set("v.ScoreObtained",ScoreObtained);
                    FailedCount = parseInt(FailedCount) + 1;
                    Button.set("v.variant", "destructive");
                    BeneficiaryDetailMatch = 'Fail';                    
                }
                
                component.set("v.FailedCount",FailedCount);   
				component.set("v.QuestionAttempt",QuestionAttempt );
                findOtherButton.set("v.variant", "neutral");                
                component.set("v.BeneficiaryDetailMatch",BeneficiaryDetailMatch);
                if(QuestionAttempt >=3 && IsCFCUFailForTheDay != 'Fail' && IsCFCUFailOnReload != 'Fail'){
                    component.set("v.IsButtonDisabled",false);
                }
            }
                else if(ButtonId =='JointPassButton')
                {
                    
                    findOtherButton = component.find('JointFailButton');
                    if(Button.get("v.variant") ==  "success"){
                        Button.set("v.variant", "neutral");
                        QuestionAttempt = parseInt(QuestionAttempt) - 1;
                        ScoreObtained = parseInt(ScoreObtained) - 1;
                        JointOwnerDetailMatch = '';
                    }
                    else if(Button.get("v.variant") ==  "neutral"  && findOtherButton.get("v.variant" ) == "neutral"){
                        QuestionAttempt = parseInt(QuestionAttempt) + 1;
                        Button.set("v.variant", "success");
                        ScoreObtained = parseInt(ScoreObtained) + 1;
                        JointOwnerDetailMatch = 'Pass';
                    }
                    else
                    {
                        FailedCount = parseInt(FailedCount) - 1;
                        component.set("v.FailedCount",FailedCount);
                        Button.set("v.variant", "success");
                        ScoreObtained = parseInt(ScoreObtained) + 1;
                        JointOwnerDetailMatch = 'Pass';
                    }
                    component.set("v.QuestionAttempt",QuestionAttempt ); 					
                    component.set("v.ScoreObtained",ScoreObtained);
                    findOtherButton.set("v.variant", "neutral");                    
                    component.set("v.JointOwnerDetailMatch",JointOwnerDetailMatch);
                    if(QuestionAttempt >=3 && IsCFCUFailForTheDay != 'Fail' && IsCFCUFailOnReload != 'Fail'){
                        component.set("v.IsButtonDisabled",false);
                    }
                }
                    else if(ButtonId =='JointFailButton'){                       
                        findOtherButton = component.find('JointPassButton')
                        if(Button.get("v.variant") ==  "destructive"){
                            FailedCount = parseInt(FailedCount) - 1;
                            QuestionAttempt = parseInt(QuestionAttempt) - 1;
                            Button.set("v.variant", "neutral");
                            JointOwnerDetailMatch = '';
                        }
                        else if(Button.get("v.variant") ==  "neutral"  && findOtherButton.get("v.variant" ) == "neutral"){
                            QuestionAttempt = parseInt(QuestionAttempt) + 1;
                            FailedCount = parseInt(FailedCount) + 1;
                            Button.set("v.variant", "destructive");
                            JointOwnerDetailMatch = 'Fail';
                        }
                        else{
                            ScoreObtained = parseInt(ScoreObtained) - 1;
                            component.set("v.ScoreObtained",ScoreObtained); 
                            FailedCount = parseInt(FailedCount) + 1;
                            Button.set("v.variant", "destructive");
                            JointOwnerDetailMatch = 'Fail';
                        }                        
                        component.set("v.FailedCount",FailedCount);
                        component.set("v.QuestionAttempt",QuestionAttempt );                        
                        findOtherButton.set("v.variant", "neutral");                       
                        component.set("v.JointOwnerDetailMatch",JointOwnerDetailMatch);
                        if(QuestionAttempt >=3 && IsCFCUFailForTheDay != 'Fail' && IsCFCUFailOnReload != 'Fail'){
                            component.set("v.IsButtonDisabled",false);
                        }
                    }
                        else if(ButtonId =='LoanPassButton')
                        {
                            findOtherButton = component.find('LoanFailButton');
                            if(Button.get("v.variant") ==  "success"){
                                QuestionAttempt = parseInt(QuestionAttempt) - 1;
                                Button.set("v.variant", "neutral");
                                ScoreObtained = parseInt(ScoreObtained) - 1;
                                LoanDetailMatch = '';
                            }
                            else if(Button.get("v.variant") ==  "neutral"  && findOtherButton.get("v.variant" ) == "neutral"){
                                QuestionAttempt = parseInt(QuestionAttempt) + 1;
                                Button.set("v.variant", "success");
                                ScoreObtained = parseInt(ScoreObtained) + 1;
                                LoanDetailMatch = 'Pass';
                            }
                            else{
                                FailedCount = parseInt(FailedCount) - 1;
                                component.set("v.FailedCount",FailedCount);
                                Button.set("v.variant", "success");
                                ScoreObtained = parseInt(ScoreObtained) + 1;
                                LoanDetailMatch = 'Pass';
                            }
                            component.set("v.QuestionAttempt",QuestionAttempt );           
							component.set("v.ScoreObtained",ScoreObtained);
                            findOtherButton.set("v.variant", "neutral");                            
                            component.set("v.LoanDetailMatch",LoanDetailMatch);
                            if(QuestionAttempt >=3 && IsCFCUFailForTheDay != 'Fail' && IsCFCUFailOnReload != 'Fail'){
                                component.set("v.IsButtonDisabled",false);
                            }
                        }
                            else if(ButtonId =='LoanFailButton'){                       
                                findOtherButton = component.find('LoanPassButton');
                                if(Button.get("v.variant") ==  "destructive"){
                                    QuestionAttempt = parseInt(QuestionAttempt) - 1;
                                    FailedCount = parseInt(FailedCount) - 1;
                                    Button.set("v.variant", "neutral");
                                    LoanDetailMatch = '';
                                }
                                else if(Button.get("v.variant") ==  "neutral"  && findOtherButton.get("v.variant" ) == "neutral"){
                                    QuestionAttempt = parseInt(QuestionAttempt) + 1;
                                    FailedCount = parseInt(FailedCount) + 1;
                                    Button.set("v.variant", "destructive");
                                    LoanDetailMatch = 'Fail';
                                }
                                else{
                                    ScoreObtained = parseInt(ScoreObtained) - 1;
                                    component.set("v.ScoreObtained",ScoreObtained);
                                    FailedCount = parseInt(FailedCount) + 1;
                                    Button.set("v.variant", "destructive");
                                    LoanDetailMatch = 'Fail';
                                }
                                component.set("v.QuestionAttempt",QuestionAttempt );
								component.set("v.FailedCount",FailedCount);                                
                                findOtherButton.set("v.variant", "neutral");                                
                                component.set("v.LoanDetailMatch",LoanDetailMatch);
                                if(QuestionAttempt >=3 && IsCFCUFailForTheDay != 'Fail' && IsCFCUFailOnReload != 'Fail'){
                                    component.set("v.IsButtonDisabled",false);
                                }
                                
                            }
                                else if(ButtonId =='CardPassButton')
                                {
                                    findOtherButton = component.find('CardFailButton');
                                    if(Button.get("v.variant") ==  "success"){
                                        QuestionAttempt = parseInt(QuestionAttempt) - 1;
                                        Button.set("v.variant", "neutral");
                                        ScoreObtained = parseInt(ScoreObtained) - 1;
                                        CardNumberMatch = '';
                                    }
                                    else if(Button.get("v.variant") ==  "neutral"  && findOtherButton.get("v.variant" ) == "neutral"){
                                        QuestionAttempt = parseInt(QuestionAttempt) + 1;
                                        Button.set("v.variant", "success");
                                        ScoreObtained = parseInt(ScoreObtained) + 1;
                                        CardNumberMatch = 'Pass';
                                    }
                                    else{
                                        FailedCount = parseInt(FailedCount) - 1;
                                        component.set("v.FailedCount",FailedCount);
                                        Button.set("v.variant", "success");
                                        ScoreObtained = parseInt(ScoreObtained) + 1;
                                        CardNumberMatch = 'Pass';
                                    }
                                    component.set("v.QuestionAttempt",QuestionAttempt );                  
									component.set("v.ScoreObtained",ScoreObtained);
                                    findOtherButton.set("v.variant", "neutral");                                    
                                    component.set("v.CardNumberMatch",CardNumberMatch);
                                    if(QuestionAttempt >=3 && IsCFCUFailForTheDay != 'Fail' && IsCFCUFailOnReload != 'Fail'){
                                        component.set("v.IsButtonDisabled",false);
                                    }
                                }
                                    else if(ButtonId =='CardFailButton'){        
										findOtherButton = component.find('CardPassButton');
                                        if(Button.get("v.variant") ==  "destructive"){
                                            QuestionAttempt = parseInt(QuestionAttempt) - 1;
                                            Button.set("v.variant", "neutral");
                                            FailedCount = parseInt(FailedCount) - 1;
                                            CardNumberMatch = '';
                                        }
                                        else if(Button.get("v.variant") ==  "neutral"  && findOtherButton.get("v.variant" ) == "neutral"){
                                            QuestionAttempt = parseInt(QuestionAttempt) + 1;
                                            Button.set("v.variant", "destructive");
                                            FailedCount = parseInt(FailedCount) + 1;
                                            CardNumberMatch = 'Fail';
                                        }
                                        else
                                        {
                                            ScoreObtained = parseInt(ScoreObtained) - 1;
                                            component.set("v.ScoreObtained",ScoreObtained);
                                            Button.set("v.variant", "destructive"); 
                                            FailedCount = parseInt(FailedCount) + 1;
                                            CardNumberMatch = 'Fail';
                                        }
                                        component.set("v.QuestionAttempt",QuestionAttempt );                                        
                                        findOtherButton.set("v.variant", "neutral");                                        
                                        component.set("v.FailedCount",FailedCount);                                        
                                        component.set("v.CardNumberMatch",CardNumberMatch);
                                        if(QuestionAttempt >=3 && IsCFCUFailForTheDay != 'Fail' && IsCFCUFailOnReload != 'Fail'){
                                            component.set("v.IsButtonDisabled",false);
                                        }
                                        
                                    }
                                        else if(ButtonId =='TokenPassButton1')
                                        {
                                            
                                            if(token1 == 'Select'){
                                                alert('Please select Additional Token');
                                            }        	
                                            else{
                                                
                                                findOtherButton = component.find('TokenFailButton1');
                                                if(Button.get("v.variant") ==  "success"){
                                                    QuestionAttempt = parseInt(QuestionAttempt) - 1;
                                                    component.set("v.AdditionalTokenOption1",'');
                                                    Button.set("v.variant", "neutral");
                                                    ScoreObtained = parseInt(ScoreObtained) - 1;
                                                    AdditionalTokenOption1Match = '';
                                                }
                                                else if(Button.get("v.variant") ==  "neutral"  && findOtherButton.get("v.variant" ) == "neutral"){
                                                    QuestionAttempt = parseInt(QuestionAttempt) + 1;
                                                    component.set("v.AdditionalTokenOption1",token1);
                                                    Button.set("v.variant", "success");
                                                    ScoreObtained = parseInt(ScoreObtained) + 1;
                                                    AdditionalTokenOption1Match = 'Pass';
                                                }
                                                else{
                                                    FailedCount = parseInt(FailedCount) - 1;
                                                    component.set("v.FailedCount",FailedCount);
                                                    component.set("v.AdditionalTokenOption1",token1);
                                                    Button.set("v.variant", "success");
                                                    ScoreObtained = parseInt(ScoreObtained) + 1;
                                                    AdditionalTokenOption1Match = 'Pass';
                                                }
                                                component.set("v.QuestionAttempt",QuestionAttempt );                                                	
												component.set("v.ScoreObtained",ScoreObtained);
                                                findOtherButton.set("v.variant", "neutral");                                                
                                                component.set("v.AdditionalTokenOption1Match",AdditionalTokenOption1Match);	
                                                if(QuestionAttempt >=3 && IsCFCUFailForTheDay != 'Fail' && IsCFCUFailOnReload != 'Fail'){
                                                    component.set("v.IsButtonDisabled",false);
                                                }
                                            }
                                            
                                        }
                                            else if(ButtonId =='TokenFailButton1'){ 
                                                if(token1 == 'Select'){
                                                    alert('Please select Additional Token');
                                                }        	
                                                else{
                                                    
                                                    findOtherButton = component.find('TokenPassButton1');
                                                    if(Button.get("v.variant") ==  "destructive"){
                                                        QuestionAttempt = parseInt(QuestionAttempt) - 1;
                                                        component.set("v.AdditionalTokenOption1",'');	
                                                    	FailedCount = parseInt(FailedCount) - 1;
                                                        Button.set("v.variant", "neutral");
                                                        AdditionalTokenOption1Match = '';
                                                    }
                                                    else if(Button.get("v.variant") ==  "neutral"  && findOtherButton.get("v.variant" ) == "neutral"){
                                                        QuestionAttempt = parseInt(QuestionAttempt) + 1;
                                                        component.set("v.AdditionalTokenOption1",token1);	
                                                    	FailedCount = parseInt(FailedCount) + 1;
                                                        Button.set("v.variant", "destructive");
                                                        AdditionalTokenOption1Match = 'Fail';
                                                    }
                                                    
                                                    else{
                                                        ScoreObtained = parseInt(ScoreObtained) - 1;
                                                        component.set("v.ScoreObtained",ScoreObtained);  
                                                        component.set("v.AdditionalTokenOption1",token1);	
                                                    	FailedCount = parseInt(FailedCount) + 1;
                                                        Button.set("v.variant", "destructive");
                                                        AdditionalTokenOption1Match = 'Fail';
                                                    }
                                                    
                                                    component.set("v.FailedCount",FailedCount);
                                                    component.set("v.QuestionAttempt",QuestionAttempt );                                                    
                                                    findOtherButton.set("v.variant", "neutral");                                                    
                                                    component.set("v.AdditionalTokenOption1Match",AdditionalTokenOption1Match);
                                                    if(QuestionAttempt >=3 && IsCFCUFailForTheDay != 'Fail' && IsCFCUFailOnReload != 'Fail'){
                                                        component.set("v.IsButtonDisabled",false);
                                                    }
                                                }
                                                
                                                
                                            }
                                                else if(ButtonId =='TokenPassButton2')
                                                {
                                                    if(token2 == 'Select'){
                                                        alert('Please select Additional Token');
                                                    }
                                                    
                                                    else{
                                                        	
                                                        findOtherButton = component.find('TokenFailButton2');
                                                        if(Button.get("v.variant") ==  "success"){
                                                            QuestionAttempt = parseInt(QuestionAttempt) - 1;
                                                             component.set("v.AdditionalTokenOption2",'');
                                                            Button.set("v.variant", "neutral");
                                                            ScoreObtained = parseInt(ScoreObtained) - 1;
                                                            AdditionalTokenOption2Match = '';
                                                        }
                                                        else if(Button.get("v.variant") ==  "neutral"  && findOtherButton.get("v.variant" ) == "neutral"){
                                                            QuestionAttempt = parseInt(QuestionAttempt) + 1;
                                                             component.set("v.AdditionalTokenOption2",token2);
                                                            Button.set("v.variant", "success");
                                                            ScoreObtained = parseInt(ScoreObtained) + 1;
                                                            AdditionalTokenOption2Match = 'Pass';
                                                        }
                                                        else{
                                                            FailedCount = parseInt(FailedCount) - 1;
                                                             component.set("v.AdditionalTokenOption2",token2);
                                                            component.set("v.FailedCount",FailedCount);
                                                            Button.set("v.variant", "success");
                                                            ScoreObtained = parseInt(ScoreObtained) + 1;
                                                            AdditionalTokenOption2Match = 'Pass';
                                                        }                                                       
                                                        component.set("v.QuestionAttempt",QuestionAttempt );      	
                                  						component.set("v.ScoreObtained",ScoreObtained);
                                                        findOtherButton.set("v.variant", "neutral");                                                        
                                                        component.set("v.AdditionalTokenOption2Match",AdditionalTokenOption2Match);	
                                                        if(QuestionAttempt >=3 && IsCFCUFailForTheDay != 'Fail' && IsCFCUFailOnReload != 'Fail'){
                                                            component.set("v.IsButtonDisabled",false);
                                                        }
                                                    }
                                                    
                                                }
                                                    else if(ButtonId =='TokenFailButton2'){
                                                        if(token2 == 'Select'){
                                                            alert('Please select Additional Token');
                                                        }
                                                        
                                                        else{                                                           
                                                            findOtherButton = component.find('TokenPassButton2');
                                                            if(Button.get("v.variant") ==  "destructive"){
                                                                QuestionAttempt = parseInt(QuestionAttempt) - 1;
                                                                component.set("v.AdditionalTokenOption2",'');
                                                                FailedCount = parseInt(FailedCount) - 1;
                                                                Button.set("v.variant", "neutral");
                                                                AdditionalTokenOption2Match = '';
                                                            }
                                                            else if(Button.get("v.variant") ==  "neutral"  && findOtherButton.get("v.variant" ) == "neutral"){
                                                                QuestionAttempt = parseInt(QuestionAttempt) + 1;
                                                                component.set("v.AdditionalTokenOption2",token2);
                                                                FailedCount = parseInt(FailedCount) + 1;
                                                                Button.set("v.variant", "destructive");
                                                                AdditionalTokenOption2Match = 'Fail';
                                                            }
                                                            else{
                                                                ScoreObtained = parseInt(ScoreObtained) - 1;
                                                                component.set("v.ScoreObtained",ScoreObtained); 
                                                                component.set("v.AdditionalTokenOption2",token2);
                                                                FailedCount = parseInt(FailedCount) + 1;
                                                                Button.set("v.variant", "destructive");
                                                                AdditionalTokenOption2Match = 'Fail';
                                                            }
                                                            component.set("v.QuestionAttempt",QuestionAttempt );                                                    	
															component.set("v.FailedCount",FailedCount);                                                            
                                                            findOtherButton.set("v.variant", "neutral");                                                            
                                                            component.set("v.AdditionalTokenOption2Match",AdditionalTokenOption2Match);	
                                                            if(QuestionAttempt >=3 && IsCFCUFailForTheDay != 'Fail' && IsCFCUFailOnReload != 'Fail'){
                                                                component.set("v.IsButtonDisabled",false);
                                                            }
                                                        }
                                                    }     
                                                        else if(ButtonId =='TokenPassButton3')
                                                    {
                                                        if(token3 == 'Select'){
                                                            alert('Please select Additional Token');
                                                        }
                                                        
                                                        else{
                                                            debugger; 
                                                            if(Button.get("v.variant") ==  "success"){
                                                                QuestionAttempt = parseInt(QuestionAttempt) - 1;
                                                                component.set("v.AdditionalTokenOption3",'');
                                                                Button.set("v.variant", "neutral");
                                                            	ScoreObtained = parseInt(ScoreObtained) - 1;
                                                                AdditionalTokenOption3Match = '';
                                                            }
                                                            else if(Button.get("v.variant") ==  "neutral"  && findOtherButton.get("v.variant" ) == "neutral"){
                                                                QuestionAttempt = parseInt(QuestionAttempt) + 1;
                                                                component.set("v.AdditionalTokenOption3",token3);
                                                                Button.set("v.variant", "success");
                                                            	ScoreObtained = parseInt(ScoreObtained) + 1;
                                                                AdditionalTokenOption3Match = 'Pass';
                                                            }
                                                            else{
                                                                FailedCount = parseInt(FailedCount) - 1;
                                                                component.set("v.FailedCount",FailedCount);
                                                                component.set("v.AdditionalTokenOption3",token3);
                                                                 Button.set("v.variant", "success");
                                                            	ScoreObtained = parseInt(ScoreObtained) + 1;
                                                                AdditionalTokenOption3Match = 'Pass';
                                                            }
                                                            	
                                                            findOtherButton = component.find('TokenFailButton3');
                                                            component.set("v.QuestionAttempt",QuestionAttempt );                                                           
                                                            component.set("v.ScoreObtained",ScoreObtained);
                                                            findOtherButton.set("v.variant", "neutral");                                                            
                                                            component.set("v.AdditionalTokenOption3Match",AdditionalTokenOption3Match);	
                                                            if(QuestionAttempt >=3 && IsCFCUFailForTheDay != 'Fail' && IsCFCUFailOnReload != 'Fail'){
                                                                component.set("v.IsButtonDisabled",false);
                                                            }
                                                        }
                                                        
                                                    }
                                                        else if(ButtonId =='TokenFailButton3'){
                                                            if(token3 == 'Select'){
                                                                alert('Please select Additional Token');
                                                            }
                                                            
                                                            else{
                                                                
                                                                findOtherButton = component.find('TokenPassButton3');
                                                                if(Button.get("v.variant") ==  "destructive"){
                                                                    QuestionAttempt = parseInt(QuestionAttempt) - 1;
                                                                    component.set("v.AdditionalTokenOption3",'');	
                                                                    FailedCount = parseInt(FailedCount) - 1;
                                                                    Button.set("v.variant", "neutral");
                                                                    AdditionalTokenOption3Match = '';
                                                                }
                                                                else if(Button.get("v.variant") ==  "neutral"  && findOtherButton.get("v.variant" ) == "neutral"){
                                                                    QuestionAttempt = parseInt(QuestionAttempt) + 1;
                                                                    component.set("v.AdditionalTokenOption3",token3);	
                                                                    FailedCount = parseInt(FailedCount) + 1;   
                                                                    Button.set("v.variant", "destructive");
                                                                    AdditionalTokenOption3Match = 'Fail';
                                                                }
                                                                else{
                                                                    ScoreObtained = parseInt(ScoreObtained) - 1;
                                                                    component.set("v.ScoreObtained",ScoreObtained); 
                                                                    component.set("v.AdditionalTokenOption3",token3);	
                                                                    FailedCount = parseInt(FailedCount) + 1;   
                                                                    Button.set("v.variant", "destructive");
                                                                    AdditionalTokenOption3Match = 'Fail';
                                                                }
                                                                component.set("v.QuestionAttempt",QuestionAttempt );
                                                                component.set("v.FailedCount",FailedCount);                                                                
                                                                findOtherButton.set("v.variant", "neutral");                                                                
                                                                component.set("v.AdditionalTokenOption3Match",AdditionalTokenOption3Match);	
                                                                if(QuestionAttempt >=3 && IsCFCUFailForTheDay != 'Fail' && IsCFCUFailOnReload != 'Fail'){
                                                                    component.set("v.IsButtonDisabled",false);
                                                                }
                                                            }
                                                        }     
            
            
             else if(ButtonId =='TokenPassButton4')
                                                    {
                                                        if(token4 == 'Select'){
                                                            alert('Please select Additional Token');
                                                        }
                                                        
                                                        else{
                                                            	
                                                            findOtherButton = component.find('TokenFailButton4');
                                                            if(Button.get("v.variant") ==  "success"){
                                                                component.set("v.AdditionalTokenOption4",'');
                                                                QuestionAttempt = parseInt(QuestionAttempt) - 1;
                                                                Button.set("v.variant", "neutral");
                                                            	ScoreObtained = parseInt(ScoreObtained) - 1;
                                                                AdditionalTokenOption4Match = '';
                                                            }
                                                            else if(Button.get("v.variant") ==  "neutral"  && findOtherButton.get("v.variant" ) == "neutral"){
                                                                QuestionAttempt = parseInt(QuestionAttempt) + 1;
                                                                component.set("v.AdditionalTokenOption4",token4);
                                                                Button.set("v.variant", "success");
                                                           		ScoreObtained = parseInt(ScoreObtained) + 1;
                                                                AdditionalTokenOption4Match = 'Pass';
                                                            }
                                                            else{
                                                                FailedCount = parseInt(FailedCount) - 1;
                                                                component.set("v.FailedCount",FailedCount);
                                                                component.set("v.AdditionalTokenOption4",token4);
                                                                Button.set("v.variant", "success");
                                                            	ScoreObtained = parseInt(ScoreObtained) + 1;
                                                                AdditionalTokenOption4Match = 'Pass';
                                                            }
                                                            component.set("v.QuestionAttempt",QuestionAttempt );                                                           
                                                            component.set("v.ScoreObtained",ScoreObtained);
                                                            findOtherButton.set("v.variant", "neutral");
                                                            
                                                            component.set("v.AdditionalTokenOption4Match",AdditionalTokenOption4Match);	
                                                            if(QuestionAttempt >=3 && IsCFCUFailForTheDay != 'Fail' && IsCFCUFailOnReload != 'Fail'){
                                                                component.set("v.IsButtonDisabled",false);
                                                            }
                                                        }
                                                        
                                                    }
                                                        else if(ButtonId =='TokenFailButton4'){
                                                            if(token4 == 'Select'){
                                                                alert('Please select Additional Token');
                                                            }                                                            
                                                            else{                                                          
                                                                
                                                                findOtherButton = component.find('TokenPassButton4');
                                                                if(Button.get("v.variant") ==  "destructive"){
                                                                    component.set("v.AdditionalTokenOption4",'');	
                                                                	FailedCount = parseInt(FailedCount) - 1;
                                                                    Button.set("v.variant", "neutral");
                                                                    AdditionalTokenOption4Match = '';
                                                                }
                                                                else if(Button.get("v.variant") ==  "neutral"  && findOtherButton.get("v.variant" ) == "neutral"){
                                                                    QuestionAttempt = parseInt(QuestionAttempt) + 1;
                                                                    component.set("v.AdditionalTokenOption4",token4);	
                                                                	FailedCount = parseInt(FailedCount) + 1;
                                                                    Button.set("v.variant", "destructive");
                                                                    AdditionalTokenOption4Match = 'Fail';
                                                                }
                                                                else{
                                                                    ScoreObtained = parseInt(ScoreObtained) - 1;
                                                                    component.set("v.ScoreObtained",ScoreObtained); 
                                                                    component.set("v.AdditionalTokenOption4",token4);	
                                                                	FailedCount = parseInt(FailedCount) + 1;
                                                                    Button.set("v.variant", "destructive");
                                                                    AdditionalTokenOption4Match = 'Fail';
                                                                }
                                                                component.set("v.QuestionAttempt",QuestionAttempt );
                                                                component.set("v.FailedCount",FailedCount);
                                                                
                                                                findOtherButton.set("v.variant", "neutral");                                                                
                                                                component.set("v.AdditionalTokenOption4Match",AdditionalTokenOption4Match);	
                                                                if(QuestionAttempt >=3 && IsCFCUFailForTheDay != 'Fail' && IsCFCUFailOnReload != 'Fail'){
                                                                    component.set("v.IsButtonDisabled",false);
                                                                }
                                                            }
                                                        }  
            
                                                            else if(ButtonId == 'SubmitButton')
                                                            {
                                                                debugger;
                                                                if(component.get("v.QuestionAttempt") <=2){
                                                                    alert('Please select at least 3 questions before clicking submit.');		        		
                                                                }
                                                                else{
                                                                    var compEvent = component.getEvent("statusEvent");
                                                                    var memberId = component.get("v.recordId");
                                                                    var status;
                                                                    BeneficiaryDetailMatch = component.get("v.BeneficiaryDetailMatch");
                                                                    JointOwnerDetailMatch = component.get("v.JointOwnerDetailMatch");
                                                                    CardNumberMatch = component.get("v.CardNumberMatch");
                                                                    AdditionalTokenOption1Match = component.get("v.AdditionalTokenOption1Match");
                                                                    AdditionalTokenOption2Match = component.get("v.AdditionalTokenOption2Match");
                                                                    AdditionalTokenOption3Match = component.get("v.AdditionalTokenOption3Match");
                                                                    AdditionalTokenOption4Match = component.get("v.AdditionalTokenOption4Match");
                                                                    LoanDetailMatch = component.get("v.LoanDetailMatch");
                                                                    
                                                                    var BeneficiaryAccount = component.get("v.BeneficiaryAccountOnly");
                                                                    if(BeneficiaryDetailMatch == undefined || BeneficiaryDetailMatch == '')
                                                                    {
                                                                        BeneficiaryAccount = '';
                                                                    }
                                                                    
                                                                    var JointAccount = component.get("v.JointAccountOnly");
                                                                    if(JointOwnerDetailMatch == undefined || JointOwnerDetailMatch == ''){
                                                                        JointAccount = '';
                                                                    }
                                                                    
                                                                    
                                                                    var LoanAccount = component.get("v.LoanAccount") ;
                                                                    if(LoanDetailMatch == undefined || LoanDetailMatch == '')
                                                                    {
                                                                        LoanAccount = '';
                                                                    }
                                                                    
                                                                    var Card = component.get("v.Card") ;
                                                                    if(CardNumberMatch == undefined || CardNumberMatch == '' ){
                                                                        Card ='';
                                                                    }
                                                                    
                                                                    var AdditionalTokenOption1 =  component.get("v.AdditionalTokenOption1");
                                                                    if(AdditionalTokenOption1Match == undefined || AdditionalTokenOption1Match == ''){
                                                                        AdditionalTokenOption1 ='';
                                                                    }
                                                                    
                                                                    var AdditionalTokenOption2 =  component.get("v.AdditionalTokenOption2");
                                                                    if(AdditionalTokenOption2Match == undefined || AdditionalTokenOption2Match == ''){
                                                                        AdditionalTokenOption2 ='';
                                                                    }
                                                                    
                                                                    var AdditionalTokenOption3 =  component.get("v.AdditionalTokenOption3");
                                                                    if(AdditionalTokenOption3Match == undefined || AdditionalTokenOption3Match == ''){
                                                                        AdditionalTokenOption3 ='';
                                                                    }
                                                                    
                                                                    var AdditionalTokenOption4 =  component.get("v.AdditionalTokenOption4");
                                                                    if(AdditionalTokenOption4Match == undefined || AdditionalTokenOption4Match == ''){
                                                                        AdditionalTokenOption4 ='';
                                                                    }
                   
                                                                    var MemberNumber = (component.get("v.MemberNumberFromURL") != undefined && component.get("v.MemberNumberFromURL") != "" ) ? component.get("v.MemberNumberFromURL") : component.get("v.MemberNumberEntered");
                                                                    
                                                                    compEvent.setParams({"CFCUWalletScoreObtained" : ScoreObtained,"CFCUWalletFailedCount" : FailedCount, "ActionType": 'CFCU Wallet'});
                                                                    compEvent.fire();
                                                                    if(ScoreObtained >= 3 && FailedCount <= 1)
                                                                        status = "Pass";
                                                                    else
                                                                        status = "Fail";
                                                                    
                                                                    var action = component.get("c.CFCUWalletSaveLogData");
                                                                    var GUID = component.get("v.GUID");
                                                                    var IVRGUIDFromUrl = component.get("v.IVRGUIDFromUrl");
                                                                    action.setParams({"MemberId": memberId,
                                                                                      "Status": status,
                                                                                      "GUID" : GUID,
                                                                                      "BeneficiaryDetailMatch": BeneficiaryDetailMatch,
                                                                                      "JointOwnerDetailMatch": JointOwnerDetailMatch,
                                                                                      "CardNumberMatch": CardNumberMatch,
                                                                                      "AdditionalTokenOption1Match": AdditionalTokenOption1Match,
                                                                                      "AdditionalTokenOption2Match":AdditionalTokenOption2Match,
                                                                                      "LoanDetailMatch": LoanDetailMatch,
                                                                                      "IVRGUIDFromUrl" : IVRGUIDFromUrl,
                                                                                      "BeneficiaryAccount": BeneficiaryAccount,
                                                                                      "JointAccount" : JointAccount,
                                                                                      "LoanAccount": LoanAccount,
                                                                                      "Card": Card,
                                                                                      "AdditionalTokenOption1": AdditionalTokenOption1,
                                                                                      "AdditionalTokenOption2":AdditionalTokenOption2,
                                                                                      "MemberNumber": MemberNumber,
                                                                                      "AdditionalTokenOption3":AdditionalTokenOption3,
                                                                                      "AdditionalTokenOption3Match":AdditionalTokenOption3Match,
                                                                                      "AdditionalTokenOption4":AdditionalTokenOption4,
                                                                                      "AdditionalTokenOption4Match":AdditionalTokenOption4Match
                                                                                     });
                                                                    action.setCallback(this, function (response) {	    
                                                                        var status = response.getState();            
                                                                        if (component.isValid() && status === "SUCCESS") {
                                                                            var result = response.getReturnValue();
                                                                        }
                                                                        else
                                                                        {
                                                                            compEvent = component.getEvent("statusEvent");
                                                                        }
                                                                        component.set("v.IsSubmitClicked",true);
                                                                    });
                                                                    $A.enqueueAction(action);	
                                                                    component.set("v.IsButtonDisabled",true);
                                                                    //	component.set("v.CFCUWalletStatusForDay",false);
                                                                }
                                                            }
        }
    },
    buttonOnLoad : function(component, event, helper){
        component.find('BeneficiaryPassButton').set("v.variant", "neutral");
        component.find('BeneficiaryFailButton').set("v.variant", "neutral");
        component.find('JointPassButton').set("v.variant", "neutral");
        component.find('JointFailButton').set("v.variant", "neutral");
        component.find('LoanPassButton').set("v.variant", "neutral");
        component.find('LoanFailButton').set("v.variant", "neutral");
        if(component.get("v.IsCFCUSectionVisible") == true){                	
            component.find('CardPassButton').set("v.variant", "neutral");
            component.find('CardFailButton').set("v.variant", "neutral");
        }
        component.find('TokenPassButton1').set("v.variant", "neutral");
        component.find('TokenFailButton1').set("v.variant", "neutral");
        component.find('TokenPassButton2').set("v.variant", "neutral");
        component.find('TokenFailButton2').set("v.variant", "neutral");
        
        component.find('TokenPassButton3').set("v.variant", "neutral");
        component.find('TokenFailButton3').set("v.variant", "neutral");
        
        component.find('TokenPassButton4').set("v.variant", "neutral");
        component.find('TokenFailButton4').set("v.variant", "neutral");
    },
    
    
})