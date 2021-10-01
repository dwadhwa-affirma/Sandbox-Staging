global class Wires_ProcessRecurrenceTransactionBatch implements Database.Batchable<sObject>,Database.Stateful,Database.AllowsCallouts{    
    
    global Set<Id> wiresId = new Set<Id>();
    global Database.QueryLocator start(Database.BatchableContext BC){
        
        Integer daysInMonth=Date.daysInMonth(Date.today().year(),Date.today().month());
        Integer todayDay=Date.today().Day();
        
        if(daysInMonth==todayDay){
            return DataBase.getQueryLocator([SELECT Id, FromAccount__c, 
                                             WireAmount__c,Fees__c,Member_SSN__c,
                                             Description__c,Chevron_Account_Number__c,
                                             SendOn__c,ToAccountName__c, 
                                             ToAccoutId__c, Share_ID__c,Frequency__c,
                                             Source__c,First_Reviewer__c,
                                             RecurrenceEndDate__c
                                             FROM WIRES_Transaction__c 
                                             WHERE Frequency__c =: WiresConstant.Reccuring
                                             AND Source__c=:WiresConstant.Source_OnlineBanking
                                             AND TransactionStatus__c = 'Pending' 
                                             AND IsActive__c=true
                                             AND RecurrenceEndDate__c >=: Date.today()
                                             AND (RecurrenceDay__c = : Date.today().day() OR (RecurrenceDay__c>:daysInMonth))]);    
        }else{
            return DataBase.getQueryLocator([SELECT Id, FromAccount__c, WireAmount__c,Member_SSN__c,
                                             Fees__c,Description__c,Chevron_Account_Number__c,SendOn__c,
                                             ToAccountName__c, ToAccoutId__c, 
                                             Share_ID__c,Frequency__c,
                                             Source__c,First_Reviewer__c,RecurrenceEndDate__c
                                             FROM WIRES_Transaction__c 
                                             WHERE Frequency__c =: WiresConstant.Reccuring
                                             AND IsActive__c=true
                                             AND TransactionStatus__c = 'Pending' 
                                             AND RecurrenceEndDate__c >=: Date.today()
                                             AND RecurrenceDay__c = : Date.today().day()]);    
        }
    }
    
    global void execute(Database.BatchableContext BC,List<WIRES_Transaction__c> scopeWTIDs){
        CalculateBusinessDays cbd=new CalculateBusinessDays();
        
        List<WIRES_Transaction__c> onetimeWireObjs = new List<WIRES_Transaction__c>();
        Integer daysInMonth=Date.daysInMonth(Date.today().year(),Date.today().month());
        
        for(WIRES_Transaction__c wtc: scopeWTIDs){
            
            WIRES_Transaction__c objWTC = new WIRES_Transaction__c();
            objWTC.FromAccount__c = wtc.FromAccount__c;
            objWTC.Member_SSN__c=wtc.Member_SSN__c;
            objWTC.Chevron_Account_Number__c=wtc.Chevron_Account_Number__c;
            objWTC.Share_ID__c=wtc.Share_ID__c;
            
            objWTC.ToAccountName__c=wtc.ToAccountName__c;
            objWTC.ToAccoutId__c=wtc.ToAccoutId__c;
            
            objWTC.Frequency__c=WiresConstant.OneTime;
            
            objWTC.WireAmount__c =wtc.WireAmount__c;
            objWTC.Fees__c =wtc.Fees__c;
            
            objWTC.ParentTransaction__c = wtc.Id;
            
            objWTC.Description__c=wtc.Description__c;
            objWTC.Source__c=wtc.Source__c;
            objWTC.First_Reviewer__c=wtc.First_Reviewer__c;
                        
            DateTime d = DateTime.newInstance(System.today(), Time.newInstance(0, 0, 0, 0));
            if(cbd.isWorkingDay(d)==false){
            	d=cbd.getNextWorkingDay(d);
            }
            
            if(wtc.RecurrenceEndDate__c >= d) {	
                objWTC.SendOn__c=d.Date();
                onetimeWireObjs.add(objWTC);	
            }
        }
        insert onetimeWireObjs;
        
        for(WIRES_Transaction__c w:onetimeWireObjs){
        	wiresId.add(w.Id);
        }
    }
    
    global void finish(Database.BatchableContext BC){
        if(wiresId.size()>0){
             WiresTransToDocuSign.docusignAPIcallWithoutFuture(wiresId);
        }
    }
}