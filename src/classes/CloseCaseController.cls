public class CloseCaseController {
	
	@auraenabled
    public static  case FetchCaseData(string recordId)
    {
    	case objCase = new case();    	
    	objCase = [select Id, status, Reason, ownerId from Case where Id =: recordId limit 1];
    	return objCase;    	
   	}	
   	
   	@auraenabled
    public static  case closeCaseSave(string recordId, string status, string Reason, string Comments)
    {
    	case objCase = new case();
    	objCase = [select Id, status, Reason, ownerId from Case where Id =: recordId limit 1];    	
    	if(objCase != null)
    	{   		
    		objCase.status = status;
	    	objCase.Reason = Reason;
	    	update objCase;
	    	
	    	if(Comments != null)
	    	{
				CaseComment cc = new CaseComment();
	            cc.ParentId = recordId;
	            cc.CommentBody = Comments;	            	             
	            insert cc; 
	    	}
    	}
    	return objCase;    	
   	}
}