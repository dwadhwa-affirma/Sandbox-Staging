public with sharing class ConvertLeadController {
    
     @AuraEnabled   
    public static List<object> ConvertLead(Id leadId)
    {
    	
    	Lead leadObject = [select id,FirstName,LastName,MiddleName,Mortgage_Loan_Officer__r.id, Lead_Number__c,Other_Phone__c,Episys_User_ID__c,Description,Salutation,Suffix,Name,Status,Phone,Email,MobilePhone,Home_Phone__c,Owner.Name,OwnerId,How_did_you_hear_about_us__c,Event_Source__c,Mortgage_Loan_Officer__c,
    						/*Member_Branch__c,*/ Brand__c,LeadSource,Product_Type__c,Product_Subtype__c,CreatedById,CreatedDate, Street_Address_1__c, Street_Address_2__c,Best_Time_To_Call__c,Branch_of_Lead_creator__c,
    						State__c,Zip_Code__c,City__c,Country__c,Future_Date__c, I_m_interested_in__c, UID__c, Property_City__c, Property_Zip__c,Property_Address__c,Property_State__c,UnbounceSubmissionDate__c,UnbounceSubmissionTime__c, Timeframe__c,Estimate_Value__c, Loan_Amount__c, Sub_Status__c from Lead where Id =: leadId];
    						
    	
    	set<id> setlead = new Set<id>();
		 for(Lead ld1 : [select id,Name from lead where Owner.Type = 'Queue' and  id =: leadId]){
		 	
		 	SetLead.add(ld1.id);
		 }					
    	system.debug('###leadObject' + leadObject);
    	List<object> listObj = new List<object>(); 
    	Id LoggedinUser = UserInfo.getUserId();
    			if(leadObject.Status !='Closed - Converted' && leadObject.Status !='Closed - Not Converted')
    			{
    				
			    	Account acc = new Account();
			    	Id recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName()
			                  .get('Pre Member').getRecordTypeId();
			    	acc.RecordTypeId = recordTypeId;
			    	//acc.Name = leadObject.Name;
			    	acc.FirstName = leadObject.FirstName;
					acc.MiddleName = leadObject.MiddleName;
					acc.LastName = leadObject.LastName;
					acc.Salutation = leadObject.Salutation;
					acc.Suffix = leadObject.Suffix;
					//acc.PersonEmail = leadObject.Email;
					acc.Home_Phone__pc = leadObject.Home_Phone__c;
					acc.Work_Phone__pc = leadObject.Other_Phone__c;
					acc.Mobile_Phone__pc = leadObject.MobilePhone;
					acc.OwnerId = LoggedinUser;
					acc.Residential_City__pc = leadObject.City__c;
					acc.Residential_Country__pc = leadObject.Country__c;
					acc.Residential_State__pc = leadObject.State__c;
					acc.Residential_Street__pc = leadObject.Street_Address_1__c;
					acc.Residential_Extra_Address__pc = leadObject.Street_Address_2__c;
					acc.Residential_Zipocde__pc = leadObject.Zip_Code__c;
					acc.Parent_Lead__c = leadId;
					acc.Email_raw__c = leadObject.Email;
					acc.Pre_Member_Number__c = leadObject.Lead_Number__c;
					system.debug('###acc' + acc);
			    	insert acc;
			    	
			    	Opportunity opp = new Opportunity();
			    	opp.AccountId = acc.Id;
			    	opp.Product_Type__c = leadObject.Product_Type__c;
			    	opp.Product_Sub__c = leadObject.Product_Subtype__c;
			    	
			    	if(leadObject.Brand__c == 'CFCU'){
			    		opp.Brand__c =  'Chevron';
			    	}
			    	else{
			    		opp.Brand__c = leadObject.Brand__c;
			    	}
			    	//opp.StageName = 'New';
			    	opp.Name = 'Name';
			    	opp.CloseDate = date.ValueOf('2048-12-31');
			    	//System.Today().addDays(90);
			    	opp.Opportunity_Source__c = leadObject.LeadSource;
			    	opp.Future_Date__c= leadObject.Future_Date__c;
			    	opp.Product_Type__c = leadObject.Product_Type__c;
			    	opp.Product_Sub__c = leadObject.Product_Subtype__c;
			    	opp.How_did_you_hear_about_us__c = leadObject.How_did_you_hear_about_us__c;
			    	opp.Mortgage_Loan_Officer__c = leadObject.Mortgage_Loan_Officer__c;
			    	opp.Event_Source__c = leadObject.Event_Source__c;
			    	opp.Is_Converted__c = true;
			    	//opp.Member_Branch__c = leadObject.Member_Branch__c;
			    	/*opp.Lead_Created_by__c = leadObject.CreatedById;
			    	opp.Lead_Created_Date__c = leadObject.CreatedDate;*/
			    	opp.Parent_Lead__c = leadObject.id;
			    	opp.Lead_Created_Date__c = leadObject.CreatedDate;
			    	opp.Description = leadObject.Description;
			    	opp.Lead_Episys_User_ID__c = leadObject.Episys_User_ID__c;
			    	opp.User_Owner__c = LoggedinUser;
			    	opp.OwnerId = LoggedinUser;
			    	opp.I_m_interested_in__c = leadObject.I_m_interested_in__c;
			    	opp.UID__c = leadObject.UID__c;
			    	opp.Unbounce_Submission_Date__c = leadObject.UnbounceSubmissionDate__c;
			    	opp.Unbounce_Submission_Time__c = leadObject.UnbounceSubmissionTime__c;
			    	opp.Timeframe__c = leadObject.Timeframe__c;
			    	opp.Estimate_Value__c = leadObject.Estimate_Value__c;
			    	opp.Loan_Amount__c =  leadObject.Loan_Amount__c;
			    	opp.Property_City__c = leadObject.Property_City__c;
			    	opp.Property_Zip__c = leadObject.Property_Zip__c;
			    	opp.Property_Address__c	= leadObject.Property_Address__c;
			    	opp.Property_State__c = leadObject.Property_State__c;
			    	//opp.Member_Branch__c = leadObject.Member_Branch__c;
			    	opp.StageName = leadObject.Status;
			    	opp.Best_Time_To_Call__c = leadObject.Best_Time_To_Call__c;
			    	if(leadObject.Status == 'Outreach')
			    	{
			    		opp.Sub_Status__c = leadObject.Sub_Status__c;
			    	}
			    	//opp.Loan_Amount__c =	leadObject.Loan_Amount__c;
			    	opp.Branch_of_Lead_creator__c = leadObject.Branch_of_Lead_creator__c ;
			    	insert opp;
			    	Opportunity newopp = new Opportunity();
			    	newopp = [Select id, Opportunity_Number__c from Opportunity where id=: opp.id];			    	
			    	
			    	List<string> Ids = new List<string>();
			    	Ids.add(acc.id);
			    	Ids.add(opp.id);
			    	Ids.add(newopp.Opportunity_Number__c);
			    	listObj.add(Ids);
			    	listObj.add(leadObject);
			    	/*Lead obj = new Lead();
			    	leadObject.*/
			    	AttachActivity(opp, leadObject);	
			   
			    	if (leadObject.Product_Type__c== 'Accounts/Shares' && leadObject.Product_Subtype__c== 'Membership'){
			    	    
			    		AttachActivity(opp, leadObject);
			    	}
			    	else
			    	{
			    		Opportunity opp1 = new Opportunity();
					    	opp1.AccountId = acc.Id;
					    	opp1.Product_Type__c = leadObject.Product_Type__c;
					    	opp1.Product_Sub__c = leadObject.Product_Subtype__c;
					    	//opp1.OwnerId = LoggedinUser;
					    	if(leadObject.Brand__c == 'CFCU'){
					    		opp1.Brand__c =  'Chevron';
					    	}
					    	else{
					    		opp1.Brand__c = leadObject.Brand__c;
					    	}
					    	//opp1.StageName = 'New';
					    	opp1.Name = 'Name';
					    	opp1.CloseDate = date.ValueOf('2048-12-31');
					    	//System.Today().addDays(90);
					    	opp1.Opportunity_Source__c = leadObject.LeadSource;
					    	opp1.Future_Date__c= leadObject.Future_Date__c;
					    	opp1.Product_Type__c = 'Accounts/Shares';
					    	opp1.Product_Sub__c = 'Membership';
					    	opp1.How_did_you_hear_about_us__c = leadObject.How_did_you_hear_about_us__c;
					    	opp1.Mortgage_Loan_Officer__c = leadObject.Mortgage_Loan_Officer__c;
					    	opp1.Event_Source__c = leadObject.Event_Source__c;
					    	opp1.Is_Converted__c = true;
					    	//opp1.Member_Branch__c = leadObject.Member_Branch__c;
					    	/*opp1.Lead_Created_by__c = leadObject.CreatedById;
					    	opp1.Lead_Created_Date__c = leadObject.CreatedDate;*/
					    	opp1.Parent_Lead__c = leadObject.id;
					    	opp1.Lead_Created_Date__c = leadObject.CreatedDate;
					    	opp1.Description = leadObject.Description;
					    	opp1.Lead_Episys_User_ID__c =leadObject.Episys_User_ID__c;
					    	opp1.User_Owner__c = LoggedinUser;
						    opp1.OwnerId = LoggedinUser;
						    opp1.I_m_interested_in__c = leadObject.I_m_interested_in__c;
			    			opp1.UID__c = leadObject.UID__c;
			    			opp1.Unbounce_Submission_Date__c = leadObject.UnbounceSubmissionDate__c;
			    			opp1.Unbounce_Submission_Time__c = leadObject.UnbounceSubmissionTime__c;
			    			opp1.Timeframe__c = leadObject.Timeframe__c;
			    			opp1.Estimate_Value__c = leadObject.Estimate_Value__c;
			    			opp1.Loan_Amount__c =  leadObject.Loan_Amount__c;	
			    			opp1.Property_City__c = leadObject.Property_City__c;
			    			opp1.Property_Zip__c = leadObject.Property_Zip__c;
			    			opp1.Property_Address__c	= leadObject.Property_Address__c;
			    	        opp1.Property_State__c = leadObject.Property_State__c;
			    	        //opp1.Member_Branch__c = leadObject.Member_Branch__c;
			    	        opp1.StageName = leadObject.Status;
			    	        opp1.Best_Time_To_Call__c = leadObject.Best_Time_To_Call__c;
			    	        if(leadObject.Status == 'Outreach')
			    			{
			    				opp1.Sub_Status__c = leadObject.Sub_Status__c;
			    			}
			    			opp1.Branch_of_Lead_creator__c = leadObject.Branch_of_Lead_creator__c ;
					    	insert opp1;
					    		    			
			    	}
			    	leadObject.Status = 'Closed - Converted';
			    	if(SetLead.contains(leadId)){
	            		User u = [Select Id, alias from User where id =: LoggedinUser ];
				    	leadObject.Ownerid = u.Id;
			    	}
			    	update leadObject;
			    	return listObj;
    				
    			}
    			
    			return listObj;
    			
    			
    	   	
    	
    	
    }
    
    @AuraEnabled
    
    public static String Baseurl()
    {
	  string orgurl = URL.getSalesforceBaseUrl().toString();
	  return (orgurl);
   	}
   	
   	public static void AttachActivity(Opportunity opp, Lead leadObject){
   		List<ContentDocumentlink> cdl = [SELECT id, LinkedEntityId, ContentDocumentId, ShareType FROM ContentDocumentlink where LinkedEntityId =: leadObject.Id];
			    	List<Note> nt = [SELECT id,Body, Title,  ParentId FROM Note where parentid =: leadObject.Id];
			    	List<Task> task = [SELECT id,WhatId, ActivityDate, CallDisposition, CallDurationInSeconds, CallObject, CallType, Description, IsRecurrence, IsReminderSet, IsVisibleInSelfService, Priority, RecurrenceDayOfMonth, RecurrenceDayOfWeekMask, RecurrenceEndDateOnly, RecurrenceInstance, RecurrenceInterval, RecurrenceMonthOfYear, RecurrenceRegeneratedType, RecurrenceStartDateOnly, RecurrenceTimeZoneSidKey, RecurrenceType, ReminderDateTime, Status, Subject, TaskSubtype, Type, WhoId  FROM Task WHERE WhoId =: leadObject.Id];
					List<Event> event =	[SELECT id,ActivityDate, ActivityDateTime, Description, DurationInMinutes, EndDateTime, EventSubtype, IsAllDayEvent, IsPrivate, IsRecurrence, IsReminderSet, IsVisibleInSelfService, Location, OwnerId, RecurrenceDayOfMonth, RecurrenceDayOfWeekMask, RecurrenceEndDateOnly, RecurrenceInstance, RecurrenceInterval, RecurrenceMonthOfYear, RecurrenceStartDateTime, RecurrenceTimeZoneSidKey, RecurrenceType, ReminderDateTime, ShowAs, StartDateTime, Subject, Type, WhoId, WhatId FROM Event WHERE WhoId =: leadObject.Id]; 
			       	if(cdl.size() > 0){
			    		for(ContentDocumentLink ls : cdl){
			    			ContentDocumentLink cDe = new ContentDocumentLink();
			    			cde.LinkedEntityId = opp.id;
			    			cde.ContentDocumentId = ls.ContentDocumentId;
			    			cDe.ShareType = ls.ShareType;
			    			insert cde;
			 			   	}
			    		
			    	}
			    	delete cdl;
			    	if(nt.size() > 0){
			    		for(Note n : nt){
			    				note newnote= new note();
			    				 newnote.Body = n.Body;
			    				 newnote.Title = n.Title;
			    				 newnote.ParentId = opp.id;
			    				 
			    				insert newnote;
			 			   	}
			    	}
			    	delete nt;
			    	if(task.size() > 0){
			    		for(Task t : task){
			    				/*Task newtask= new Task();
			    				newtask.ActivityDate= t.ActivityDate;
			    				newtask.CallDisposition= t.CallDisposition;
			    				newtask.CallDurationInSeconds= t.CallDurationInSeconds;
			    				newtask.CallObject= t.CallObject;
			    				newtask.CallType= t.CallType;
			    				newtask.Description= t.Description;			    				
			    				newtask.IsRecurrence= t.IsRecurrence;
			    				newtask.IsReminderSet= t.IsReminderSet;
			    				newtask.IsVisibleInSelfService= t.IsVisibleInSelfService;
			    				newtask.Priority= t.Priority;
			    				newtask.RecurrenceDayOfMonth= t.RecurrenceDayOfMonth;
			    				newtask.RecurrenceDayOfWeekMask= t.RecurrenceDayOfWeekMask;
			    				newtask.RecurrenceEndDateOnly= t.RecurrenceEndDateOnly;
			    				newtask.RecurrenceInstance= t.RecurrenceInstance;
			    				newtask.RecurrenceInterval= t.RecurrenceInterval;
			    				newtask.RecurrenceMonthOfYear= t.RecurrenceMonthOfYear;
			    				newtask.RecurrenceRegeneratedType= t.RecurrenceRegeneratedType;
			    				newtask.RecurrenceStartDateOnly= t.RecurrenceStartDateOnly;
			    				newtask.RecurrenceTimeZoneSidKey= t.RecurrenceTimeZoneSidKey;
			    				newtask.RecurrenceType= t.RecurrenceType;
			    				newtask.ReminderDateTime= t.ReminderDateTime;
			    				newtask.Status= t.Status;
			    				newtask.Subject= t.Subject;
			    				newtask.TaskSubtype= t.TaskSubtype;			    				
			    				newtask.Type= t.Type;	*/	    						    				
			    				
			    				t.WhoId=null;		
			    				t.WhatId= opp.id;
			    				update t;
			    				//insert newtask;
			 			   	}
			    		
			    	}
			    	if(event.size() > 0){
			    		for(Event e : event){
			    				/*Event newevent= new Event();			    				
			    				newevent.ActivityDate = e.ActivityDate;
			    				newevent.ActivityDateTime = e.ActivityDateTime;  				
			    				newevent.Description = e.Description;			    				
			    				newevent.DurationInMinutes = e.DurationInMinutes;
			    				newevent.EndDateTime = e.EndDateTime;
			    				newevent.EventSubtype = e.EventSubtype;			    				
			    				newevent.IsAllDayEvent = e.IsAllDayEvent;			    				
			    				newevent.IsPrivate = e.IsPrivate;
			    				newevent.IsRecurrence = e.IsRecurrence;
			    				newevent.IsReminderSet = e.IsReminderSet;
			    				newevent.IsVisibleInSelfService = e.IsVisibleInSelfService;
			    				newevent.Location = e.Location;
			    				newevent.OwnerId = e.OwnerId;			    			
			    				newevent.RecurrenceDayOfMonth = e.RecurrenceDayOfMonth;
			    				newevent.RecurrenceDayOfWeekMask = e.RecurrenceDayOfWeekMask;
			    				newevent.RecurrenceEndDateOnly = e.RecurrenceEndDateOnly;
			    				newevent.RecurrenceInstance = e.RecurrenceInstance;
			    				newevent.RecurrenceInterval = e.RecurrenceInterval;
			    				newevent.RecurrenceMonthOfYear = e.RecurrenceMonthOfYear;
			    				newevent.RecurrenceStartDateTime = e.RecurrenceStartDateTime;
			    				newevent.RecurrenceTimeZoneSidKey = e.RecurrenceTimeZoneSidKey;
			    				newevent.RecurrenceType = e.RecurrenceType;
			    				newevent.ReminderDateTime = e.ReminderDateTime;
			    				newevent.ShowAs = e.ShowAs;
			    				newevent.StartDateTime = e.StartDateTime;
			    				newevent.Subject = e.Subject;
			    				newevent.Type = e.Type;		*/	    			
			    				
			    				e.WhoId= null;		    				
			    				e.WhatId= opp.id;
			    				update e;
			    				//insert newevent;
			 			   	}
			    		
			    	}
			    	
			    	
   	}
    
}