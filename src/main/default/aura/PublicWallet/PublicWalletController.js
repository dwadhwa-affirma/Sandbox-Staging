({
    doInit : function(component, event, helper) {
        
        var memberId = component.get("v.recordId");
        //var PublicWalletStatusForDay = component.get("v.PublicWalletStatusForDay");
        var IVRGUIDFromUrl = component.get("v.IVRGUIDFromUrl");
        helper.getDLStateIdPassport(component, event, helper, memberId, IVRGUIDFromUrl);
        component.set("v.IsSubmitClicked",false);
        component.set("v.ScoreObtained",0 );
        component.set("v.QuestionAttempt",0 );
        component.set("v.FailedCount",0 );
        component.set("v.IsSubmitClicked",false);
        component.set("v.IsButtonDisabled", true);
        
        component.find("AdditionalToken1").set("v.value","Select");
       // component.find("AdditionalToken2").set("v.value","Select");
        
        helper.buttonOnLoad(component, event, helper);
        var params = event.getParam('arguments');
        if (params) {
            var IsReLoadRequired =  params.param2;
            var IsUserSessionLoaded = params.param3;
            component.set("v.IsReLoadRequired", IsReLoadRequired);
            component.set("v.IsUserSessionLoaded", IsUserSessionLoaded);
        }
    },
    
    submit: function(component, event, helper) {
        
        if(component.get("v.IsSubmitClicked") == false)
        {
            if(component.get("v.QuestionAttempt") <=2){
                alert('Please select at least 3 questions before clicking submit.');
                //component.set("v.ScoreObtained",0 );
                //component.set("v.QuestionAttempt",0 );
                //component.set("v.FailedCount",0 );
            }
            else{
                var memberId = component.get("v.recordId");
                var ScoreObtained = component.get("v.ScoreObtained");
                var FailedCount = component.get("v.FailedCount");
                var status;
                var compEvent = component.getEvent("statusEvent");
                compEvent.setParams({"PublicWalletScoreObtained" : ScoreObtained,"PublicWalletFailedCount" : FailedCount, "ActionType": 'Public Wallet'});
                compEvent.fire();
                if(ScoreObtained >= 3 && FailedCount <= 1)
                    status = "Pass";
                else
                    status = "Fail";
                helper.saveMethod(component, event, memberId, status);
                component.set("v.IsSubmitClicked",true);
                component.set("v.IsButtonDisabled",true);
                //component.set("v.PublicWalletStatusForDay",false);
                
            }
            
            
        }
    },
    
    ButtonClick : function(component, event, helper) {
        
        if(component.get("v.IsSubmitClicked") == false)
        {
            var DOBMatch;
            var IdNumberMatch;
            var MMNMatch;
            var EmailMatch;
            var AdditionalTokenOption3Match;
           var AdditionalTokenOption4Match;
            var ButtonId = event.getSource().getLocalId();
            var Button = event.getSource();
            var findOtherButton;
            findOtherButton = component.find('DobFailButton');
            var QuestionAttempt = component.get("v.QuestionAttempt");
            var token1 = component.find("AdditionalToken1").get("v.value");
           // var token2 = component.find("AdditionalToken2").get("v.value");
            var ScoreObtained = component.get("v.ScoreObtained");
            var FailedCount = component.get("v.FailedCount");
            if(ButtonId =='DobPassButton'){
                if(Button.get("v.variant") ==  "success"){
                    Button.set("v.variant", "neutral");
                    QuestionAttempt = parseInt(QuestionAttempt) - 1;
                    ScoreObtained = parseInt(ScoreObtained) - 1;
                    DOBMatch = '';
                }
                else if(Button.get("v.variant") ==  "neutral"  && findOtherButton.get("v.variant" ) == "neutral"){
                    QuestionAttempt = parseInt(QuestionAttempt) + 1;
                    ScoreObtained = parseInt(ScoreObtained) + 1;
                    Button.set("v.variant", "success");  
                    DOBMatch = 'Pass';
                }
                else
                {
                    FailedCount = parseInt(FailedCount) - 1;
                    component.set("v.FailedCount",FailedCount);
                    ScoreObtained = parseInt(ScoreObtained) + 1;
                    Button.set("v.variant", "success");  
                    DOBMatch = 'Pass';
                }
                component.set("v.QuestionAttempt",QuestionAttempt );               
                              
                component.set("v.ScoreObtained",ScoreObtained);
                findOtherButton.set("v.variant", "neutral");                
                component.set("v.DOBMatch",DOBMatch);
                if(QuestionAttempt >=3){
                    component.set("v.IsButtonDisabled",false);
                }
            }
            else if(ButtonId =='DobFailButton'){        
                
                findOtherButton = component.find('DobPassButton');                
                
                if(Button.get("v.variant") ==  "destructive"){
                    Button.set("v.variant", "neutral");
                    QuestionAttempt = parseInt(QuestionAttempt) - 1;
                    ScoreObtained = parseInt(ScoreObtained) + 1;
                    FailedCount = parseInt(FailedCount) - 1;
                    DOBMatch = '';
                }
                else if(Button.get("v.variant") ==  "neutral" && findOtherButton.get("v.variant" ) == "neutral"){
                    QuestionAttempt = parseInt(QuestionAttempt) + 1;
                    Button.set("v.variant", "destructive");
                    DOBMatch = 'Fail';
                    FailedCount = parseInt(FailedCount) + 1;
                    ScoreObtained = parseInt(ScoreObtained) - 1;  
                }
                else
                {
                    ScoreObtained = parseInt(ScoreObtained) - 1;                   
                    Button.set("v.variant", "destructive");
                    DOBMatch = 'Fail';
                    FailedCount = parseInt(FailedCount) + 1;
                }
                 component.set("v.ScoreObtained",ScoreObtained);
                component.set("v.FailedCount",FailedCount);
                component.set("v.QuestionAttempt",QuestionAttempt  );     
                findOtherButton.set("v.variant", "neutral");                
                component.set("v.DOBMatch",DOBMatch);
                if(QuestionAttempt >=3){
                    component.set("v.IsButtonDisabled",false);
                }
                
            }
            else if(ButtonId =='DLPassButton')
                {                  
                   
                    findOtherButton = component.find('DLFailButton');
                    
                    if(Button.get("v.variant") ==  "success"){
                        Button.set("v.variant", "neutral");
                        QuestionAttempt = parseInt(QuestionAttempt) - 1;
                        ScoreObtained = parseInt(ScoreObtained) - 1;
                        IdNumberMatch = '';
                    }
                    else if(Button.get("v.variant") ==  "neutral"  && findOtherButton.get("v.variant" ) == "neutral"){
                        QuestionAttempt = parseInt(QuestionAttempt) + 1;
                        Button.set("v.variant", "success");
                        IdNumberMatch = 'Pass';
                         ScoreObtained = parseInt(ScoreObtained) + 1;
                    }
                    else
                    {
                        FailedCount = parseInt(FailedCount) - 1;
                        component.set("v.FailedCount",FailedCount);
                        Button.set("v.variant", "success");
                        IdNumberMatch = 'Pass';
                         ScoreObtained = parseInt(ScoreObtained) + 1;
                    }
                    component.set("v.QuestionAttempt",QuestionAttempt );
					findOtherButton.set("v.variant", "neutral");                    
                    component.set("v.ScoreObtained",ScoreObtained);
                    
                    component.set("v.IdNumberMatch",IdNumberMatch);
                    if(QuestionAttempt >=3){
                        component.set("v.IsButtonDisabled",false);
                    }
                    
                }
                    else if(ButtonId =='DLFailButton'){        
                        
                        findOtherButton = component.find('DLPassButton');
                        if(Button.get("v.variant") ==  "destructive"){
                            Button.set("v.variant", "neutral");
                            FailedCount = parseInt(FailedCount) - 1;
                            IdNumberMatch = '';
                        }
                        else if(Button.get("v.variant") ==  "neutral"  && findOtherButton.get("v.variant" ) == "neutral"){
                            QuestionAttempt = parseInt(QuestionAttempt) + 1;
                            Button.set("v.variant", "destructive");
                            FailedCount = parseInt(FailedCount) + 1;
                            IdNumberMatch = 'Fail';
                            ScoreObtained = parseInt(ScoreObtained) - 1;  
                        }
                        else
                        {
                            ScoreObtained = parseInt(ScoreObtained) - 1;
                            component.set("v.ScoreObtained",ScoreObtained);
                            Button.set("v.variant", "destructive");
                            FailedCount = parseInt(FailedCount) + 1;
                            IdNumberMatch = 'Fail';
                        }
                        component.set("v.QuestionAttempt",QuestionAttempt );                        
                        component.set("v.FailedCount",FailedCount);
                        component.set("v.ScoreObtained",ScoreObtained);
                        findOtherButton.set("v.variant", "neutral");                        
                        component.set("v.IdNumberMatch",IdNumberMatch);
                        if(QuestionAttempt >=3){
                            component.set("v.IsButtonDisabled",false);
                        }
                        
                    }
            
                        else if(ButtonId =='MothersMaidenNamePassButton')
                        {                        
                            
                            findOtherButton = component.find('MothersMaidenNameFailButton')
                            if(Button.get("v.variant") ==  "success"){
                                ScoreObtained = parseInt(ScoreObtained) - 1;
                                QuestionAttempt = parseInt(QuestionAttempt) - 1;
                                 Button.set("v.variant", "neutral");
                                 MMNMatch = '';
                            }
                            else if(Button.get("v.variant") ==  "neutral"  && findOtherButton.get("v.variant" ) == "neutral"){
                                QuestionAttempt = parseInt(QuestionAttempt) + 1;
                                ScoreObtained = parseInt(ScoreObtained) + 1;
                                 Button.set("v.variant", "success");
                                 MMNMatch = 'Pass';
                            }
                            else
                            {
                                FailedCount = parseInt(FailedCount) - 1;
                                component.set("v.FailedCount",FailedCount);
                                ScoreObtained = parseInt(ScoreObtained) + 1;
                                 Button.set("v.variant", "success");
                                 MMNMatch = 'Pass';
                            }
                            component.set("v.QuestionAttempt",QuestionAttempt );              
                           
                            findOtherButton.set("v.variant", "neutral");                           
                            component.set("v.ScoreObtained",ScoreObtained);                           
                            component.set("v.MMNMatch",MMNMatch);
                            if(QuestionAttempt >=3){
                                component.set("v.IsButtonDisabled",false);
                            }
                            
                        }
                            else if(ButtonId =='MothersMaidenNameFailButton'){        
                                
                               
                                
                                if(Button.get("v.variant") ==  "destructive"){
                                    Button.set("v.variant", "neutral");
                                     QuestionAttempt = parseInt(QuestionAttempt) - 1;
                                    ScoreObtained = parseInt(ScoreObtained) + 1;
                                     FailedCount = parseInt(FailedCount) - 1;
                                     MMNMatch = '';
                                }
                                else if(Button.get("v.variant") ==  "neutral"  && findOtherButton.get("v.variant" ) == "neutral"){
                                    QuestionAttempt = parseInt(QuestionAttempt) + 1;
                                    Button.set("v.variant", "destructive");
                                     FailedCount = parseInt(FailedCount) + 1;
                                     MMNMatch = 'Fail';
                                     ScoreObtained = parseInt(ScoreObtained) - 1;  
                                }
                                else
                                {
                                    ScoreObtained = parseInt(ScoreObtained) - 1;
                                    component.set("v.ScoreObtained",ScoreObtained);
                                    Button.set("v.variant", "destructive");
                                     FailedCount = parseInt(FailedCount) + 1;
                                     MMNMatch = 'Fail';
                                }
                                component.set("v.QuestionAttempt",QuestionAttempt );
                                component.set("v.FailedCount",FailedCount);
                                findOtherButton = component.find('MothersMaidenNamePassButton');
                                component.set("v.ScoreObtained",ScoreObtained);
                                findOtherButton.set("v.variant", "neutral");
                               
                                component.set("v.MMNMatch",MMNMatch);
                                if(QuestionAttempt >=3){
                                    component.set("v.IsButtonDisabled",false);
                                }
                                
                            }
            
                                else if(ButtonId =='EmailPassButton')
                                {
                                    findOtherButton = component.find('EmailFailButton');
                                    if(Button.get("v.variant") ==  "success"){
                                        ScoreObtained = parseInt(ScoreObtained) - 1;
                                        QuestionAttempt = parseInt(QuestionAttempt) - 1;
                                        Button.set("v.variant", "neutral");
                                          EmailMatch = '';
                                    }
                                    else if(Button.get("v.variant") ==  "neutral"  && findOtherButton.get("v.variant" ) == "neutral"){
                                        QuestionAttempt = parseInt(QuestionAttempt) + 1;
                                        ScoreObtained = parseInt(ScoreObtained) + 1;
                                        Button.set("v.variant", "success");
                                          EmailMatch = 'Pass';
                                    }
                                    else
                                    {
                                        FailedCount = parseInt(FailedCount) - 1;
                                        component.set("v.FailedCount",FailedCount);
                                        ScoreObtained = parseInt(ScoreObtained) + 1;
                                        Button.set("v.variant", "success");
                                          EmailMatch = 'Pass';
                                    }
                                    component.set("v.QuestionAttempt",QuestionAttempt );                                    
                                    component.set("v.ScoreObtained",ScoreObtained);                                    
                                    findOtherButton.set("v.variant", "neutral");                                  
                                    component.set("v.EmailMatch",EmailMatch);
                                    if(QuestionAttempt >=3){
                                        component.set("v.IsButtonDisabled",false);
                                    }
                                    
                                }
                                    else if(ButtonId =='EmailFailButton'){        
                                        
                                        findOtherButton = component.find('EmailPassButton');
                                        
                                        if(Button.get("v.variant") ==  "destructive"){	
                                            QuestionAttempt = parseInt(QuestionAttempt) - 1;
                                            FailedCount = parseInt(FailedCount) - 1;
                                            Button.set("v.variant", "neutral");
                                            EmailMatch = '';
                                        }
                                        else if(Button.get("v.variant") ==  "neutral"  && findOtherButton.get("v.variant" ) == "neutral"){
                                            QuestionAttempt = parseInt(QuestionAttempt) + 1;
                                            FailedCount = parseInt(FailedCount) + 1;
                                            Button.set("v.variant", "destructive");
                                            EmailMatch = 'Fail';
                                            ScoreObtained = parseInt(ScoreObtained) - 1;  
                                        }
                                        else
                                        {
                                            ScoreObtained = parseInt(ScoreObtained) - 1;
                                            component.set("v.ScoreObtained",ScoreObtained);
                                            FailedCount = parseInt(FailedCount) + 1;
                                            Button.set("v.variant", "destructive");
                                            EmailMatch = 'Fail';
                                        }
                                        component.set("v.QuestionAttempt",QuestionAttempt );                                        
                                        component.set("v.FailedCount",FailedCount);
                                        
                                        findOtherButton.set("v.variant", "neutral");
                                        component.set("v.ScoreObtained",ScoreObtained);
                                        component.set("v.EmailMatch",EmailMatch);
                                        if(QuestionAttempt >=3){
                                            component.set("v.IsButtonDisabled",false);
                                        }
                                        
                                    }
                                            else if(ButtonId =='TokenPassButton1')
                                            {
                                                
                                               // if(token1 == 'Select'){
                                                //    alert('Please select Additional Token');
                                               // }
                                                {                                                   
                                                    
                                                    findOtherButton = component.find('TokenFailButton1');
                                                    if(Button.get("v.variant") ==  "success"){
                                                        component.set("v.AdditionalTokenOption3",'');
                                                        QuestionAttempt = parseInt(QuestionAttempt) - 1;
                                                        ScoreObtained = parseInt(ScoreObtained) - 1;
                                                        Button.set("v.variant", "neutral");
                                                        AdditionalTokenOption3Match = '';
                                                    }
                                                    else if(Button.get("v.variant") ==  "neutral"  && findOtherButton.get("v.variant" ) == "neutral"){
                                                        QuestionAttempt = parseInt(QuestionAttempt) + 1;
                                                        component.set("v.AdditionalTokenOption3",token1);
                                                        ScoreObtained = parseInt(ScoreObtained) + 1;
                                                        Button.set("v.variant", "success");
                                                        AdditionalTokenOption3Match = 'Pass';
                                                    }
                                                    else
                                                    {
                                                        FailedCount = parseInt(FailedCount) - 1;
                                                        component.set("v.FailedCount",FailedCount);
                                                        component.set("v.AdditionalTokenOption3",token1);
                                                        ScoreObtained = parseInt(ScoreObtained) + 1;
                                                        Button.set("v.variant", "success");
                                                        AdditionalTokenOption3Match = 'Pass';
                                                    }
                                                    component.set("v.QuestionAttempt",QuestionAttempt );                                                    
                                                    component.set("v.ScoreObtained",ScoreObtained);                                                    
                                                    
                                                    findOtherButton.set("v.variant", "neutral");
                                                    
                                                    component.set("v.AdditionalTokenOption3Match",AdditionalTokenOption3Match);
                                                    if(QuestionAttempt >=3){
                                                        component.set("v.IsButtonDisabled",false);
                                                    }
                                                }
                                                
                                            }
                                                else if(ButtonId =='TokenFailButton1'){ 
                                                    //if(token1 == 'Select'){
                                                        //alert('Please select Additional Token');
                                                    //}
                                                    {                                                        
                                                        findOtherButton = component.find('TokenPassButton1');
                                                        if(Button.get("v.variant") ==  "destructive"){	
                                                           FailedCount = parseInt(FailedCount) - 1; 
                                                            Button.set("v.variant", "neutral");
                                                             AdditionalTokenOption3Match = '';
                                                             QuestionAttempt = parseInt(QuestionAttempt) - 1;
                                                             component.set("v.AdditionalTokenOption3",''); 
                                                        }
                                                        else if(Button.get("v.variant") ==  "neutral"  && findOtherButton.get("v.variant" ) == "neutral"){
                                                            QuestionAttempt = parseInt(QuestionAttempt) + 1;
                                                            FailedCount = parseInt(FailedCount) + 1;
                                                            Button.set("v.variant", "destructive");
                                                             AdditionalTokenOption3Match = 'Fail';
                                                             component.set("v.AdditionalTokenOption3",token1); 
                                                             ScoreObtained = parseInt(ScoreObtained) - 1;  
                                                        }
                                                        else
                                                        {
                                                            ScoreObtained = parseInt(ScoreObtained) - 1;
                                                            component.set("v.ScoreObtained",ScoreObtained);
                                                            FailedCount = parseInt(FailedCount) + 1;
                                                            Button.set("v.variant", "destructive");
                                                             AdditionalTokenOption3Match = 'Fail';
                                                             component.set("v.AdditionalTokenOption3",token1); 
                                                        }
                                                        component.set("v.QuestionAttempt",QuestionAttempt );
                                                        component.set("v.ScoreObtained",ScoreObtained);                                                     
                                                        component.set("v.FailedCount",FailedCount);                                                        
                                                        findOtherButton.set("v.variant", "neutral");
                                                       
                                                        component.set("v.AdditionalTokenOption3Match",AdditionalTokenOption3Match);
                                                        if(QuestionAttempt >=3){
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
                                                                ScoreObtained = parseInt(ScoreObtained) - 1;
                                                                component.set("v.AdditionalTokenOption4",'');
                                                                Button.set("v.variant", "neutral");
                                                                 AdditionalTokenOption4Match = '';
                                                            }
                                                            else if(Button.get("v.variant") ==  "neutral"  && findOtherButton.get("v.variant" ) == "neutral"){
                                                                QuestionAttempt = parseInt(QuestionAttempt) + 1;
                                                                component.set("v.AdditionalTokenOption4",token2);
                                                                ScoreObtained = parseInt(ScoreObtained) + 1;
                                                                Button.set("v.variant", "success");
                                                                 AdditionalTokenOption4Match = 'Pass';
                                                            }
                                                            else
                                                            {
                                                                FailedCount = parseInt(FailedCount) - 1;
                                                                component.set("v.FailedCount",FailedCount);
                                                                component.set("v.AdditionalTokenOption4",token2);
                                                                ScoreObtained = parseInt(ScoreObtained) + 1;
                                                                Button.set("v.variant", "success");
                                                                 AdditionalTokenOption4Match = 'Pass';
                                                            }
                                                            component.set("v.QuestionAttempt",QuestionAttempt );
                                                            component.set("v.ScoreObtained",ScoreObtained);
                                                            
                                                            findOtherButton.set("v.variant", "neutral");
                                                           
                                                            component.set("v.AdditionalTokenOption4Match",AdditionalTokenOption4Match);
                                                            if(QuestionAttempt >=3){
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
                                                                    component.set("v.AdditionalTokenOption4",'');
                                                                    FailedCount = parseInt(FailedCount) - 1;
                                                                    Button.set("v.variant", "neutral");
                                                                     AdditionalTokenOption4Match = '';
                                                                }
                                                                else if(Button.get("v.variant") ==  "neutral"  && findOtherButton.get("v.variant" ) == "neutral"){
                                                                    QuestionAttempt = parseInt(QuestionAttempt) + 1;
                                                                    component.set("v.AdditionalTokenOption4",token2);
                                                                    FailedCount = parseInt(FailedCount) + 1;
                                                                    Button.set("v.variant", "destructive");
                                                                     AdditionalTokenOption4Match = 'Fail';
                                                                     ScoreObtained = parseInt(ScoreObtained) - 1;  
                                                                }
                                                                else
                                                                {
                                                                    ScoreObtained = parseInt(ScoreObtained) - 1;
                                                                    component.set("v.ScoreObtained",ScoreObtained);
                                                                    component.set("v.AdditionalTokenOption4",token2);
                                                                    FailedCount = parseInt(FailedCount) + 1;
                                                                    Button.set("v.variant", "destructive");
                                                                     AdditionalTokenOption4Match = 'Fail';
                                                                }
                                                                component.set("v.QuestionAttempt",QuestionAttempt );                                                             
                                                                
                                                                component.set("v.FailedCount",FailedCount);
                                                                component.set("v.ScoreObtained",ScoreObtained);
                                                                findOtherButton.set("v.variant", "neutral");
                                                               
                                                                component.set("v.AdditionalTokenOption4Match",AdditionalTokenOption4Match);
                                                                if(QuestionAttempt >=3){
                                                                    component.set("v.IsButtonDisabled",false);
                                                                }
                                                                
                                                            }
                                                            
                                                        }
            
        }   
        
    },
})