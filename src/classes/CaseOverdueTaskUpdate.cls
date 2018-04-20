global class CaseOverdueTaskUpdate implements Schedulable {
     global void execute(SchedulableContext SC) {
       
    List<Case_Overdue_Task__c> lisCaseOverdueTask = new List<Case_Overdue_Task__c>();
       
       lisCaseOverdueTask = [select id from Case_Overdue_Task__c];
       
       delete lisCaseOverdueTask;
       
       
       AggregateResult[] groupedResults  = [select whatId,Count(id) from task where Status != 'Completed' and activityDate < today and What.Type = 'Case' group by whatId];
       
       system.debug('groupedResults###' + groupedResults);
       
       map<string,decimal> listMap = new map<string,decimal> ();
      string listCases  = '';
       
    
       
       
       List<Case_Overdue_Task__c> lisCaseOverdueTaskToBeInserted = new List<Case_Overdue_Task__c>();
       for (AggregateResult ar : groupedResults)  {
        string caseid = (string)ar.get('whatId');
             listMap.put(caseid, (decimal)ar.get('expr0'));  
             if(listCases == '')
             {
                listCases = listCases + '\'' + caseid + '\'';
             }
             else
             {  
                listCases =  listCases + ',' + '\'' + caseid + '\'';
             }
             
       }
       
       listCases = ' ('+ listCases +')';
       System.debug('listCases###: ' + listCases);
       CaseOverdueTaskUpdateBatch b = new CaseOverdueTaskUpdateBatch();
       b.listMap = listMap;
       b.listCases = listCases;
       Database.executeBatch(b, 10);
       
       
   }
}