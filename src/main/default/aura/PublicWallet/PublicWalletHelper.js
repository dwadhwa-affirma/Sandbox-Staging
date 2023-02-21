({
    getDLStateIdPassport: function (component, event, helper, memberId, IVRGUIDFromUrl) {
        
        var action = component.get("c.getPublicWalletInfo");
        action.setParams({"MemberId": memberId,"IVRGUIDFromUrl":IVRGUIDFromUrl});
        action.setCallback(this, function (response) {
            
            var status = response.getState();            
            if (component.isValid() && status === "SUCCESS") {
                var result = response.getReturnValue();
                
                if(result.DLcode != undefined){
                    if(result.DLcode.length > 0 ){
                        component.set("v.DLStateIdPassport",result['DLcode']);
                    }
                }
                else{
                    component.set("v.DLStateIdPassport",undefined);
                }
                
                if(result.BDate !=undefined){
                    if(result.BDate.length > 0 ){
                        component.set("v.BirthDate",result['BDate']);
                    }
                }
                else{
                    component.set("v.BirthDate",undefined);
                }
                
                if(result.ZCode !=undefined){
                    if(result.ZCode.length > 0){
                        component.set("v.ZipCode",result['ZCode']);
                    }
                }
                else{
                    component.set("v.ZipCode",undefined);
                }
                
                if(result.Emails !=undefined){
                    if(result.Emails.length > 0){
                        component.set("v.Emails",result['Emails']);
                        var nameArr = result['Emails'].split(',');
                        component.set("v.EmailList",nameArr);
                    }
                }
                else{
                    component.set("v.Emails",undefined);
                }
                
                if(result.MothersMaidenName !=undefined){
                    if(result.MothersMaidenName.length > 0 && result.MothersMaidenName !=undefined){
                        component.set("v.MothersMaidenName", result.MothersMaidenName);
                    }
                }
                else{
                    component.set("v.MothersMaidenName",undefined);
                }
                
                if(result.DefaultEmailInList != undefined){
                    component.set("v.DefaultEmailSelected", result.DefaultEmailInList);
                }
                
                debugger;
                if(component.get("v.IsUserSessionLoaded") == true)
                {
                    if(result.DOBMatch == undefined){
                        component.find('DobPassButton').set("v.variant", "neutral");
                        component.find('DobFailButton').set("v.variant", "neutral");
                    }	
                    if(result.DOBMatch == 'Pass'){
                        component.find('DobPassButton').set("v.variant", "success");
                        component.find('DobFailButton').set("v.variant", "neutral");
                    }
                    if(result.DOBMatch == 'Fail'){
                        component.find('DobFailButton').set("v.variant", "destructive");
                        component.find('DobPassButton').set("v.variant", "neutral");
                    }
                    
                    if(result.IdNumberMatch == undefined){
                        component.find('DLPassButton').set("v.variant", "neutral");
                        component.find('DLFailButton').set("v.variant", "neutral");
                    }	
                    if(result.IdNumberMatch == 'Pass'){
                        component.find('DLPassButton').set("v.variant", "success");
                        component.find('DLFailButton').set("v.variant", "neutral");
                    }
                    if(result.IdNumberMatch == 'Fail'){
                        component.find('DLFailButton').set("v.variant", "destructive");
                        component.find('DLPassButton').set("v.variant", "neutral");
                    }
                    
                    if(result.MMNMatch ==undefined){
                        component.find('MothersMaidenNamePassButton').set("v.variant", "neutral");
                        component.find('MothersMaidenNameFailButton').set("v.variant", "neutral");
                    }
                    if(result.MMNMatch == 'Pass'){
                        component.find('MothersMaidenNamePassButton').set("v.variant", "success");
                        component.find('MothersMaidenNameFailButton').set("v.variant", "neutral");
                    }
                   if(result.MMNMatch == 'Fail'){
                        component.find('MothersMaidenNameFailButton').set("v.variant", "destructive");
                        component.find('MothersMaidenNamePassButton').set("v.variant", "neutral");
                    }
                    
                    if(result.EmailMatch == undefined){
                        component.find('EmailPassButton').set("v.variant", "neutral");
                        component.find('EmailFailButton').set("v.variant", "neutral");
                    }
                    if(result.EmailMatch == 'Pass'){
                        component.find('EmailPassButton').set("v.variant", "success");
                        component.find('EmailFailButton').set("v.variant", "neutral");
                    }
                    if(result.EmailMatch == 'Fail'){
                        component.find('EmailFailButton').set("v.variant", "destructive");
                        component.find('EmailPassButton').set("v.variant", "neutral");
                    }
                    
                    if(result.AdditionalTokenMatch == undefined){
                        component.find('TokenPassButton1').set("v.variant", "neutral");
                        component.find('TokenFailButton1').set("v.variant", "neutral");
                    }
                    if(result.AdditionalTokenMatch == 'Pass'){
                        component.find('TokenPassButton1').set("v.variant", "success");
                        component.find('TokenFailButton1').set("v.variant", "neutral");
                        component.find("AdditionalToken1").set("v.value",result.Additional_Token_Option3__c);
                    }
                    if(result.AdditionalTokenMatch == 'Fail'){
                        component.find('TokenFailButton1').set("v.variant", "destructive");
                        component.find('TokenPassButton1').set("v.variant", "neutral");
                        component.find("AdditionalToken1").set("v.value",result.Additional_Token_Option3__c);
                    }
                    
                    if(result.AdditionalToken4Match == undefined){
                        component.find('TokenPassButton2').set("v.variant", "neutral");
                        component.find('TokenFailButton2').set("v.variant", "neutral");
                    }
                    if(result.AdditionalToken4Match == 'Pass'){
                        component.find('TokenPassButton2').set("v.variant", "success");
                        component.find('TokenFailButton2').set("v.variant", "neutral");
                        component.find("AdditionalToken2").set("v.value",result.Additional_Token_Option4__c);
                    }
                    if(result.AdditionalToken4Match == 'Fail'){
                        component.find('TokenFailButton2').set("v.variant", "destructive");
                        component.find('TokenPassButton2').set("v.variant", "neutral");
                        component.find("AdditionalToken2").set("v.value",result.Additional_Token_Option4__c);
                    }
                    
                    if(result.ReLaunchAuthPublicWalletStatus != undefined)
                    {
                        
                        if(result.ReLaunchAuthDOBMatch != undefined)
                        {
                            if(result.ReLaunchAuthDOBMatch.length > 0){
                                if(result.ReLaunchAuthDOBMatch == 'Pass'){
                                    component.find('DobPassButton').set("v.variant", "success");
                                    component.find('DobFailButton').set("v.variant", "neutral");
                                }
                                else{
                                    component.find('DobFailButton').set("v.variant", "destructive");
                                    component.find('DobPassButton').set("v.variant", "neutral");
                                }
                            }
                            
                        }
                        
                        if(result.ReLaunchAuthIdNumberMatch != undefined)
                        {	
                            if(result.ReLaunchAuthIdNumberMatch.length > 0){
                                if(result.ReLaunchAuthIdNumberMatch == 'Pass'){
                                    component.find('DLPassButton').set("v.variant", "success");
                                    component.find('DLFailButton').set("v.variant", "neutral");
                                }
                                else{
                                    component.find('DLFailButton').set("v.variant", "destructive");
                                    component.find('DLPassButton').set("v.variant", "neutral");
                                }
                            }
                            
                        }
                        if(result.ReLaunchAuthMMNMatch != undefined)
                        {				
                            if(result.ReLaunchAuthMMNMatch.length > 0){
                                if(result.ReLaunchAuthMMNMatch == 'Pass'){
                                    component.find('MothersMaidenNamePassButton').set("v.variant", "success");
                                    component.find('MothersMaidenNameFailButton').set("v.variant", "neutral");
                                }
                                else{
                                    component.find('MothersMaidenNameFailButton').set("v.variant", "destructive");
                                    component.find('MothersMaidenNamePassButton').set("v.variant", "neutral");
                                }
                            }
                            
                        }
                        if(result.ReLaunchAuthEmailMatch != undefined)
                        {
                            if(result.ReLaunchAuthEmailMatch.length > 0){
                                if(result.ReLaunchAuthEmailMatch == 'Pass'){
                                    component.find('EmailPassButton').set("v.variant", "success");
                                    component.find('EmailFailButton').set("v.variant", "neutral");
                                }
                                else{
                                    component.find('EmailFailButton').set("v.variant", "destructive");
                                    component.find('EmailPassButton').set("v.variant", "neutral");
                                }
                            }
                            
                        }
                        if(result.ReLaunchAuthAdditionalTokenMatch != undefined)
                        {
                            if(result.ReLaunchAuthAdditionalTokenMatch.length > 0){
                                if(result.ReLaunchAuthAdditionalTokenMatch == 'Pass'){
                                    component.find('TokenPassButton1').set("v.variant", "success");
                                    component.find('TokenFailButton1').set("v.variant", "neutral");
                                }
                                else{
                                    component.find('TokenFailButton1').set("v.variant", "destructive");
                                    component.find('TokenPassButton1').set("v.variant", "neutral");
                                }
                            }
                            
                        }
                        if(result.ReLaunchAuthAdditionalToken4Match != undefined)
                        {
                            if(result.ReLaunchAuthAdditionalToken4Match.length > 0){
                                if(result.ReLaunchAuthAdditionalToken4Match == 'Pass'){
                                    component.find('TokenPassButton2').set("v.variant", "success");
                                    component.find('TokenFailButton2').set("v.variant", "neutral");
                                }
                                else{
                                    component.find('TokenFailButton2').set("v.variant", "destructive");
                                    component.find('TokenPassButton2').set("v.variant", "neutral");
                                }
                            }
                            
                        }
                        
                        
                    }
                    
                   
                }
                
                 if(result.PublicWalletStatus =='Fail' && component.get("v.IsUserSessionLoaded") == false)
                    {
                        if(result.DOBMatch != undefined)
                        {
                            if(result.DOBMatch.length > 0){
                                if(result.DOBMatch == 'Pass'){
                                    component.find('DobPassButton').set("v.variant", "success");
                                    component.find('DobFailButton').set("v.variant", "neutral");
                                }
                                else{
                                    component.find('DobFailButton').set("v.variant", "destructive");
                                    component.find('DobPassButton').set("v.variant", "neutral");
                                }
                            }
                            
                        }
                        if(result.IdNumberMatch != undefined)
                        {	
                            if(result.IdNumberMatch.length > 0){
                                if(result.IdNumberMatch == 'Pass'){
                                    component.find('DLPassButton').set("v.variant", "success");
                                    component.find('DLFailButton').set("v.variant", "neutral");
                                }
                                else{
                                    component.find('DLFailButton').set("v.variant", "destructive");
                                    component.find('DLPassButton').set("v.variant", "neutral");
                                }
                            }
                            
                        }
                        if(result.MMNMatch != undefined)
                        {				
                            if(result.MMNMatch.length > 0){
                                if(result.MMNMatch == 'Pass'){
                                    component.find('MothersMaidenNamePassButton').set("v.variant", "success");
                                    component.find('MothersMaidenNameFailButton').set("v.variant", "neutral");
                                }
                                else{
                                    component.find('MothersMaidenNameFailButton').set("v.variant", "destructive");
                                    component.find('MothersMaidenNamePassButton').set("v.variant", "neutral");
                                }
                            }
                            
                        }
                        if(result.EmailMatch != undefined)
                        {
                            if(result.EmailMatch.length > 0){
                                if(result.EmailMatch == 'Pass'){
                                    component.find('EmailPassButton').set("v.variant", "success");
                                    component.find('EmailFailButton').set("v.variant", "neutral");
                                }
                                else{
                                    component.find('EmailFailButton').set("v.variant", "destructive");
                                    component.find('EmailPassButton').set("v.variant", "neutral");
                                }
                            }
                            
                        }
                        if(result.AdditionalTokenMatch != undefined)
                        {
                            if(result.AdditionalTokenMatch.length > 0){
                                if(result.AdditionalTokenMatch == 'Pass'){
                                    component.find('TokenPassButton1').set("v.variant", "success");
                                    component.find('TokenFailButton1').set("v.variant", "neutral");
                                }
                                else{
                                    component.find('TokenFailButton1').set("v.variant", "destructive");
                                    component.find('TokenPassButton1').set("v.variant", "neutral");
                                }
                            }
                            
                        }
                        if(result.AdditionalToken4Match != undefined)
                        {
                            if(result.AdditionalToken4Match.length > 0){
                                if(result.AdditionalToken4Match == 'Pass'){
                                    component.find('TokenPassButton2').set("v.variant", "success");
                                    component.find('TokenFailButton2').set("v.variant", "neutral");
                                }
                                else{
                                    component.find('TokenFailButton2').set("v.variant", "destructive");
                                    component.find('TokenPassButton2').set("v.variant", "neutral");
                                }
                            }
                            
                        }
                    }
                    else if(result.PublicWalletStatus =='Pass' && component.get("v.IsReLoadRequired") == false && component.get("v.IsUserSessionLoaded") == false)
                    {
                        helper.buttonOnLoad(component, event, helper);
                    }
                
                if(result.RePublicWalletStatus != undefined && component.get("v.IsReLoadRequired") == true)
                {
                    if(result.ReDOBMatch != undefined)
                    {
                        if(result.ReDOBMatch.length > 0){
                            if(result.ReDOBMatch == 'Pass'){
                                component.find('DobPassButton').set("v.variant", "success");
                                component.find('DobFailButton').set("v.variant", "neutral");
                            }
                            else{
                                component.find('DobFailButton').set("v.variant", "destructive");
                                component.find('DobPassButton').set("v.variant", "neutral");
                            }
                        }
                        
                    }
                    if(result.ReIdNumberMatch != undefined)
                    {	
                        if(result.ReIdNumberMatch.length > 0){
                            if(result.ReIdNumberMatch == 'Pass'){
                                component.find('DLPassButton').set("v.variant", "success");
                                component.find('DLFailButton').set("v.variant", "neutral");
                            }
                            else{
                                component.find('DLFailButton').set("v.variant", "destructive");
                                component.find('DLPassButton').set("v.variant", "neutral");
                            }
                        }
                        
                    }
                    if(result.ReMMNMatch != undefined)
                    {				
                        if(result.ReMMNMatch.length > 0){
                            if(result.ReMMNMatch == 'Pass'){
                                component.find('MothersMaidenNamePassButton').set("v.variant", "success");
                                component.find('MothersMaidenNameFailButton').set("v.variant", "neutral");
                            }
                            else{
                                component.find('MothersMaidenNameFailButton').set("v.variant", "destructive");
                                component.find('MothersMaidenNamePassButton').set("v.variant", "neutral");
                            }
                        }
                        
                    }
                    if(result.ReEmailMatch != undefined)
                    {
                        if(result.ReEmailMatch.length > 0){
                            if(result.ReEmailMatch == 'Pass'){
                                component.find('EmailPassButton').set("v.variant", "success");
                                component.find('EmailFailButton').set("v.variant", "neutral");
                            }
                            else{
                                component.find('EmailFailButton').set("v.variant", "destructive");
                                component.find('EmailPassButton').set("v.variant", "neutral");
                            }
                        }
                        
                    }
                    if(result.ReAdditionalTokenMatch != undefined)
                    {
                        if(result.ReAdditionalTokenMatch.length > 0){
                            if(result.ReAdditionalTokenMatch == 'Pass'){
                                component.find('TokenPassButton1').set("v.variant", "success");
                                component.find('TokenFailButton1').set("v.variant", "neutral");
                            }
                            else{
                                component.find('TokenFailButton1').set("v.variant", "destructive");
                                component.find('TokenPassButton1').set("v.variant", "neutral");
                            }
                        }
                        
                    }
                    if(result.ReAdditionalToken4Match != undefined)
                    {
                        if(result.ReAdditionalToken4Match.length > 0){
                            if(result.ReAdditionalTokenMatch == 'Pass'){
                                component.find('TokenPassButton2').set("v.variant", "success");
                                component.find('TokenFailButton2').set("v.variant", "neutral");
                            }
                            else{
                                component.find('TokenFailButton2').set("v.variant", "destructive");
                                component.find('TokenPassButton2').set("v.variant", "neutral");
                            }
                        }
                        
                    }
                    //component.set("v.PublicWalletStatusForDay",false);
                }
            }
        });	
        
        $A.enqueueAction(action); 
        
        
    },
    
    saveMethod : function(component, event, memberId, status) {
        
        
        var action = component.get("c.PublicWalletSaveLogData");
        var GUID = component.get("v.GUID");
        var IVRGUIDFromUrl = component.get("v.IVRGUIDFromUrl");
        var DOBMatch = component.get("v.DOBMatch");
        var IdNumberMatch = component.get("v.IdNumberMatch");
        var MMNMatch = component.get("v.MMNMatch");
        var EmailMatch = component.get("v.EmailMatch");
        var AdditionalTokenOption3Match = component.get("v.AdditionalTokenOption3Match");
        var AdditionalTokenOption4Match = component.get("v.AdditionalTokenOption4Match");
        var DOB = component.get("v.BirthDate");
        if(DOBMatch == undefined){
            DOB = '';
        }
        
        var IdNumber =  component.get("v.DLStateIdPassport");
        if(IdNumberMatch == undefined){
            IdNumber = '';
        }
        
        var MMN = component.get("v.MothersMaidenName");
        if(MMNMatch == undefined){
            
            MMN = '';
        }
        
        var Email = component.get("v.Emails");
        if(EmailMatch == undefined){
            Email = '';
        }
        
        var AdditionalTokenOption3 = component.get("v.AdditionalTokenOption3");
        if(AdditionalTokenOption3Match == undefined){
            AdditionalTokenOption3Match ='';
        }
        
        var AdditionalTokenOption4 = component.get("v.AdditionalTokenOption4");
        if(AdditionalTokenOption4Match == undefined){
            AdditionalTokenOption4Match ='';
        }
        
        var BirthPlace1 =  component.get("v.BirthPlace1");
        if(BirthPlace1 == undefined){
            BirthPlace1 = '';
        }
        
        var BirthPlace2 =  component.get("v.BirthPlace2");
        if(BirthPlace2 == undefined){
            BirthPlace2 = '';
        }
        
        
        var MemberNumber = (component.get("v.MemberNumberFromURL") != undefined && component.get("v.MemberNumberFromURL") != "" ) ? component.get("v.MemberNumberFromURL") : component.get("v.MemberNumberEntered");
        
        action.setParams({"MemberId": memberId, "Status": status, "GUID" : GUID, "DOBMatch" : DOBMatch, "IdNumberMatch" : IdNumberMatch, "MMNMatch" : MMNMatch, "EmailMatch" : EmailMatch, 
                          "AdditionalTokenOption3Match" : AdditionalTokenOption3Match, "IVRGUIDFromUrl" : IVRGUIDFromUrl,
                          "DOB": DOB,"IdNumber": IdNumber, "MMN": MMN,"Email": Email,"AdditionalTokenOption3": AdditionalTokenOption3,"MemberNumber": MemberNumber,
                          "AdditionalTokenOption4":AdditionalTokenOption4,
                          "AdditionalTokenOption4Match" : AdditionalTokenOption4Match});
        action.setCallback(this, function (response) {
            var status = response.getState();            
            if (component.isValid() && status === "SUCCESS") {
                var result = response.getReturnValue();
            }
            else
            {
                compEvent = component.getEvent("statusEvent");
            }
        });	
        
        $A.enqueueAction(action);
        
        
    },
    
    buttonOnLoad : function(component, event, helper){
        
        component.find('DobPassButton').set("v.variant", "neutral");
        component.find('DobFailButton').set("v.variant", "neutral");
        component.find('DLPassButton').set("v.variant", "neutral");
        component.find('DLFailButton').set("v.variant", "neutral");
        component.find('MothersMaidenNamePassButton').set("v.variant", "neutral");
        component.find('MothersMaidenNameFailButton').set("v.variant", "neutral");
        component.find('EmailPassButton').set("v.variant", "neutral");
        component.find('EmailFailButton').set("v.variant", "neutral");
        component.find('TokenPassButton1').set("v.variant", "neutral");
        component.find('TokenFailButton1').set("v.variant", "neutral");
        component.find('TokenPassButton2').set("v.variant", "neutral");
        component.find('TokenFailButton2').set("v.variant", "neutral");
    },
    
    
    
})