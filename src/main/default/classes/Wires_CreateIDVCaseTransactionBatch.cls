global class Wires_CreateIDVCaseTransactionBatch implements Database.Batchable<sObject> {
    
    global Database.QueryLocator start(Database.BatchableContext BC){    
        return DataBase.getQueryLocator([SELECT Id,Name,FromAccount__c  
                                         FROM WIRES_Transaction__c 
                                         WHERE Status__c != 'Completed'
                                         AND Approval_Status__c='Pending for Approval'
                                         AND TotalFromAccount__c > 5000 
                                         AND CreatedDate =N_DAYS_AGO:3]);    
    }
    
    global void execute(Database.BatchableContext BC,List<WIRES_Transaction__c> scopeWTIDs){
        
        list<CaseRecordType__c> scList = [SELECT Id,
                                          Primary_Category__c,
                                          Secondary_Category__c,
                                          Teritiary_Category__c,
                                          Record_Type_Name__c,
                                          SLA__c,
                                          RecordTypeId__c 
                                          FROM CaseRecordType__c 
                                          WHERE Primary_Category__c = 'Complaint' 
                                          AND Secondary_Category__c='Fraud' 
                                          AND Teritiary_Category__c='Fraud' LIMIT 1];
        
        List<WIRES_Transaction__c> onetimeWireObjs = new List<WIRES_Transaction__c>();
        List<Case> cases = new List<Case>();
        for(WIRES_Transaction__c wtc: scopeWTIDs){
            wtc.Approval_Status__c = 'IDV Incomplete – Cancelled';
            onetimeWireObjs.add(wtc);		
            
            Account_Details__c accDetail=[SELECT Id,Name, Brand__c 
                                          FROM Account_Details__c 
                                          WHERE Name=:wtc.FromAccount__c 
                                          AND RecType__c = 'ACCT' LIMIT 1];   
            
            case cs = new case();
            for(CaseRecordType__c crt : scList){
                cs.RecordTypeId = scList[0].RecordTypeId__c;
                cs.Primary_Category__c = scList[0].Primary_Category__c;
                cs.Secondary_Category__c = scList[0].Secondary_Category__c;
                cs.Tertiary_Category__c = scList[0].Teritiary_Category__c;
                cs.Sla__c = scList[0].SLA__c;
                
            }    
            cs.Status = 'Closed';
            cs.Subject = 'IDV Incomplete – Cancelled';
            cs.ownerid = UserInfo.getUserId();
            if(accDetail != null){
                cs.Account_Number__c = accDetail.Id;
            }
            cases.add(cs);
        }
        
        update onetimeWireObjs;
        if(cases.size()>0){
            insert cases;
        }
    }
    
    global void finish(Database.BatchableContext BC){
        
    }
}