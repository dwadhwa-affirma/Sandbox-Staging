public class NeedAssessmentHistoryController
{
   public string HistoryFieldName {get;set;}
      //public string FieldValue {get;set;}
      public string NA_ID {get;set;}
      
   
  	 public string getFormattedValue(){
            if(string.isEmpty(NA_ID))
            {
                return '';
            }
            list<NeedAssessmentHistory__c> history = [select FieldValue_New__c, FieldValue_Old__c from NeedAssessmentHistory__c where Needs_Assessment__c =:NA_ID  and FieldName__C =: HistoryFieldName  ORDER by LastModifiedDate desc limit 2];
            if(history.size() == 1)
            {
                return history[0].FieldValue_Old__c ;
            }
            else if (history.size() > 1)
            {
            	return history[0].FieldValue_Old__c ;
            }
            else
            {
                return '';
            }
            return '';
   
           return '';
     
   }
   
   public string getFormattedDAte(){
            if(string.isEmpty(NA_ID))
            {
                return '';
            }
            list<NeedAssessmentHistory__c> history = [select FieldValue_New__c, FieldValue_Old__c,CreatedDAte
            		from NeedAssessmentHistory__c where Needs_Assessment__c =:NA_ID  and FieldName__C =: HistoryFieldName  ORDER by LastModifiedDate desc limit 2];
            if(history.size() == 1)
            {
                return '' ;
            }
            else if (history.size() > 1)
            {
            	return history[0].CreatedDAte.format('MMMM dd, yyyy') ;
            }
            else
            {
                return '';
            }
            return '';
     
   }
   
    public void InsertDataHistoryTable(string newvalue,string oldvalue, string name, Id Id)
     {
     	system.debug('insert history');
         NeedAssessmentHistory__c obj = new NeedAssessmentHistory__c();
         obj.FieldName__c = name;
         obj.FieldValue_New__c = newvalue;
         obj.FieldValue_Old__c = oldvalue;
         obj.Needs_Assessment__c = Id;
         //insert obj;
     }


}