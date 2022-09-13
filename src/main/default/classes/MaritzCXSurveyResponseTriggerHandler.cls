public class MaritzCXSurveyResponseTriggerHandler {
    
    public void beforeInsert(List<MaritzCX__Survey_Response__c> newSurveyRes){
        
        //-----STRY0012259 : Make Custom Meta Data and add fields --//
        
        MaritzCX_Response__mdt maritzResMdt = MaritzCX_Response__mdt.getInstance('MaritzCX_Response');
        for(MaritzCX__Survey_Response__c surveyRes : newSurveyRes) {
            surveyRes.MaritzCX__ALG_Survey_Id__c=maritzResMdt.MaritzCX_ALG_Survey_Id__c;
            surveyRes.MaritzCX__Key_Metric_5__c=maritzResMdt.MaritzCX_Key_Metric_5__c;
            surveyRes.MaritzCX__Key_Metric_6__c=maritzResMdt.MaritzCX_Key_Metric_6__c;
            surveyRes.MaritzCX__Key_Metric_7__c=maritzResMdt.MaritzCX_Key_Metric_7__c;
            //surveyRes.MaritzCX__respondent_email__c ='V555628874';
        }
    }
    
    public void afterInsert(List<MaritzCX__Survey_Response__c> newSurveyRes){
        
        System.debug('afterInsert');
        //-----STRY0012259 : Create Maritz Survey Response Case --//
        Set<String> personIds=new Set<String>();
        Set<String> accNums=new Set<String>();
        Set<String> surveyCaseCodes=new Set<String>();
        
        for(MaritzCX__Survey_Response__c surveyRes : newSurveyRes) {
            if(surveyRes.MaritzCX__respondent_email__c!=null){
                personIds.add(surveyRes.MaritzCX__respondent_email__c);
            }
            
            if(surveyRes.MaritzCX__Metric_1__c!=null){
                accNums.add(surveyRes.MaritzCX__Metric_1__c);
            }
            
            if(surveyRes.MaritzCX__Metric_2__c!=null){
                surveyCaseCodes.add(surveyRes.MaritzCX__Metric_2__c);
            }
        }
        
        List<CaseRecordType__c> recTypeList =RecordTypeSelector.getCaseRecordTypeByPrimaryCat('Surveys');
        
        System.debug('recTypeList:'+recTypeList);
        
        Set<String> surveyCodeQueues = new Set<String>();
        Map<String,Survey_Case_Codes__c> surveyCodesMap = new Map<String,Survey_Case_Codes__c>();
        for(Survey_Case_Codes__c caseCode : getSurveyCaseCodes(surveyCaseCodes))
        {
            surveyCodesMap.put(caseCode.Name,caseCode);
            surveyCodeQueues.add(caseCode.Queue__c);
        }
        
        Map<String,Account_Details__c> accDetailsMap = new Map<String,Account_Details__c>();
        for(Account_Details__c accDetail : AccountDetailsSelector.getACCTAccDetails(accNums))
        {
            accDetailsMap.put(accDetail.Name,accDetail);
        }
        
        System.debug('accDetailsMap:'+accDetailsMap);
        
        Map<String,Person_Account__c> personAccByAccNumberMap= new Map<String,Person_Account__c>();
        Map<String,Person_Account__c> personAccByPersonIdMap= new Map<String,Person_Account__c>();
        
        for(Person_Account__c pa : PersonAccountSelector.getACCTPersonAccByNumber(accNums))
        {
            personAccByAccNumberMap.put(pa.Account_Number__r.Name,pa);
            personAccByPersonIdMap.put(pa.PersonId__c,pa);
        }
        
        List<Contact> con = ContactSelector.getPersonContacts(personAccByPersonIdMap.keySet());        
        Map<Id,Id> conMap = new Map<Id,Id>();    
        if(con.size() > 0){
            for(Contact ct : con){
                conMap.put(ct.AccountId, ct.Id);
            }
        }
        
        System.debug('conMap:'+conMap);
        
        Map<String,Group> queueMap = new Map<String,Group>();
        for(Group g : [SELECT Id, Name FROM Group WHERE Name =:surveyCodeQueues]){
            queueMap.put(g.Name, g);
        }
        
        System.debug('queueMap:'+queueMap);
        
        Map<String,String> surveyResCaseMap=new Map<String,String>();
        for(MaritzCX__Survey_Response__c surveyRes : newSurveyRes) {
            Survey_Case_Codes__c surveyCode=surveyCodesMap.get(surveyRes.MaritzCX__Metric_2__c);
            if(surveyCode!=null) {
                System.debug('surveyCode:'+surveyCode);
                system.debug('case creation is started');
                Case case1=new Case();
                case1.Subject= surveyCode.Branch_Dept__c+' Alert'+' :'+surveyCode.Name+':'+surveyRes.MaritzCX__Metric_1__c;
                case1.Origin='MaritzCX';
                case1.Code_Number__c=surveyCode.Name;
                case1.Branch_Region__c='Member Services';
                Account_Details__c accDetail=accDetailsMap.get(surveyRes.MaritzCX__Metric_1__c);
                if(accDetail!=null) {
                    case1.Account_Number__c=accDetail.Id;
                    case1.Member_Number__c=accDetail.Name;
                }
                
                Person_Account__c pa=personAccByAccNumberMap.get(surveyRes.MaritzCX__Metric_1__c);
                if(pa!=null) 
                {
                    case1.AccountId = pa.PersonId__c;
                    case1.ContactId = conMap.get(pa.PersonId__c);
                    case1.Last_Name__c = pa.PersonId__r.LastName;
                    case1.Middle_Name__c = pa.PersonId__r.MiddleName;
                    case1.Street_Address_1__c = pa.PersonId__r.Residential_Street__pc;
                    case1.Street_Address_2__c = pa.PersonId__r.Residential_Extra_Address__pc;
                    case1.City__c = pa.PersonId__r.Residential_City__pc;
                    case1.State__c = pa.PersonId__r.Residential_State__pc;
                    case1.Country__c = pa.PersonId__r.Residential_Country__pc;
                    case1.Zip_Code__c = pa.PersonId__r.Residential_Zipocde__pc;
                }
                
                case1.Primary_Category__c = surveyCode.Primary_Category__c;
                case1.Secondary_Category__c = surveyCode.Secondary_Category__c;
                case1.Tertiary_Category__c = surveyCode.Tertiary_Category__c; 
                
                if(recTypeList.size() >0 ) {
                    case1.RecordTypeId = recTypeList[0].RecordTypeId__c;
                }
                
                Group queue=queueMap.get(surveyCode.Queue__c);
                if(queue!=null) {
                    case1.OwnerId = queue.Id;
                }
                
                insert case1;
                
                surveyResCaseMap.put(surveyRes.Id,case1.Id);
                
              
            } 
            
            List<MaritzCX__Survey_Response__c> resToUpdate=new List<MaritzCX__Survey_Response__c>();
            for(MaritzCX__Survey_Response__c res:getSurveyResponses(surveyResCaseMap.keySet())) {
                res.MaritzCX__Case_Id__c=surveyResCaseMap.get(res.Id);
                resToUpdate.add(res);
            }
            
            if(resToUpdate.size()>0) {
                update resToUpdate;
            }
        }
    }
    
    private static List<MaritzCX__Survey_Response__c> getSurveyResponses(Set<String> ids) 
    {
        return [SELECT Id,Name FROM MaritzCX__Survey_Response__c 
                WHERE Id=:ids];
    }
    
    private static List<Survey_Case_Codes__c> getSurveyCaseCodes(Set<String> codes) 
    {
        return [SELECT Name,Branch_Dept__c,Primary_Category__c, Secondary_Category__c, 
                Tertiary_Category__c, Queue__c 
                FROM Survey_Case_Codes__c 
                WHERE Name =:codes];
    }
}