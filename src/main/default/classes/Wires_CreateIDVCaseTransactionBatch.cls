global class Wires_CreateIDVCaseTransactionBatch implements Database.Batchable<sObject> {
    
    global Database.QueryLocator start(Database.BatchableContext BC){    
        return DataBase.getQueryLocator([SELECT Id,Name,
                                         FromAccount__c,Member__c,Share_ID__c,FormattedWireAmount__c,
                                         Fees__c,TotalFromAccount__c,ToAccountName__c,
                                         ToAccoutId__c,ToAccoutId__r.BankName__c ,
                                         Description__c,Frequency__c,SendOn__c,FormattedTotalAmount__c
                                         FROM WIRES_Transaction__c 
                                         WHERE Status__c = 'Pending'
                                         AND Approval_Status__c=:WiresConstant.ApprovalStatus_PendingForMemberReview 
                                         AND Source__c=:WiresConstant.Source_OnlineBanking
                                         AND Frequency__c=: WiresConstant.OneTime
                                         AND CreatedDate < N_DAYS_AGO:3 
                                         ORDER BY CreatedDate Desc]);  
        
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
                                          WHERE Primary_Category__c = 'Account Maintenance'
                                          AND Secondary_Category__c='Special Situations'
                                          AND Teritiary_Category__c='Potential Fraud' 
                                          LIMIT 1];
        
        List<WIRES_Transaction__c> onetimeWireObjs = new List<WIRES_Transaction__c>();
        List<Case> cases = new List<Case>();
        for(WIRES_Transaction__c wtc: scopeWTIDs){
            wtc.Approval_Status__c = WiresConstant.ApprovalStatus_DSExpired;
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
            cs.Status = 'Open';
            cs.AccountId=wtc.Member__c;
            cs.Subject = 'Wires DocuSign Expiration';
            cs.ownerid = UserInfo.getUserId();
            if(accDetail != null){
                cs.Account_Number__c = accDetail.Id;
            }
            
            Datetime dt = datetime.newInstance(Date.valueOf(wtc.SendOn__c).year(), Date.valueOf(wtc.SendOn__c).month(), Date.valueOf(wtc.SendOn__c).day());
            string caseDesc=+'Wire Name: '+ wtc.Name +'\n'
                                    +'Type of wire: '+ 'Domestic' +'\n'
                                    +'Account#: '+ wtc.FromAccount__c +'\n'
                                    +'Share ID: '+ wtc.Share_ID__c +'\n'
                                    +'Amount of Wire: $'+ wtc.FormattedWireAmount__c +'\n'
                                    +'Wire Fee: $'+ wtc.Fees__c +'\n'
                                    +'Total Amount to be debited from account: $'+ wtc.FormattedTotalAmount__c +'\n'
                                    +'Recipient Name: '+ wtc.ToAccountName__c +'\n'
                                    +'Recipient Account Number: '+ wtc.ToAccoutId__c +'\n'
                                    +'Financial Institution Name: '+ Wtc.ToAccoutId__r.BankName__c +'\n'
                                    +'Special Instructions: '+ wtc.Description__c +'\n'
                                    +'Frequency: '+ wtc.Frequency__c +'\n'
                                    +'Send On: '+ dt.format('MM/dd/yyyy') +'\n';
            
            
            cs.Description=caseDesc;
            cases.add(cs);
            insert cs;
            wtc.Case__c=cs.Id;
        }
        
        update onetimeWireObjs;
        //if(cases.size()>0){
            //insert cases;
        //}
    }
    
    global void finish(Database.BatchableContext BC){
        
    }
}