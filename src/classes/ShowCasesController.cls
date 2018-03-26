global with sharing  class ShowCasesController {
     public String typeparam {get;set;}	
     public	static List<Message> afterSort = new List<Message>();
	 public string ImgName {get;set;}
     public string Stylesheet{get;set;}
     public string Sidebar{get;set;}
     public static integer mini = 0;
     public string CopyRights {get;set;}
     public string Brand_Help {get;set;}
      public string Responsivecss {get;set;}
   //  public string redirecturl {get;set;}
  //   public string path {get;set;}
  //   public string currenturl {get;set;}
    // constructor
    	public ShowCasesController() 
    	{
	 		    		
	      	if(ApexPages.CurrentPage().getparameters().get('Type') == '' || ApexPages.CurrentPage().getparameters().get('Type')==null )
        	{
        		typeparam ='Messages';
        	}
        	else
        	{        	
	        	typeparam = ApexPages.CurrentPage().getparameters().get('Type');
        	}
        	//logo = ApexPages.CurrentPage().getparameters().get('logo');
	     	
   		}
       public PageReference  PageLoad()
        {

		/* Style sheet is set in page load. First detects user and finds Brand (chev/spec) and then sets variable for brand styling.
		Common code to get user information did not work CFCUAccount constructor for all methods. Had to duplicate code in all methods to get results.
		 Code was getting called asynchronously and so brand was not available sometimes in various global methods. */      		
     				/* common code starts */
		CFCUAccount userAccount = new CFCUAccount();
		List <SecureEmailSetting__c> ses = SecureEmailSetting__c.getall().values();
		userAccount.personAccount = new Person_Account__c();
    	string LoggedinUser = UserInfo.getUserId();
        List<User> u = [SELECT Name, ContactId, FederationIdentifier from User Where ID=:LoggedinUser];
        userAccount.CurrentUser = u[0];
        userAccount.fedid = u[0].FederationIdentifier;
        List<contact> c = [SELECT AccountId, FirstName, MiddleName, LastName FROM Contact WHERE Id =:u[0].ContactId];
        	 
        if (c.size()>0)
         {
         	userAccount.userBusinessContact = c[0];
         }
            
	    userAccount.fedid =  userAccount.Get10DigitFid(userAccount.fedid);
	    List<Person_Account__c> personaccounts =  [SELECT Account_Number__c,Id,Name, PersonID__c FROM Person_Account__c Where Name_Type__c = 0 and Account_Number__r.Name =:userAccount.fedid];
            
            
         if(personaccounts.size()>0)
         {
        	 userAccount.personAccount = personaccounts[0];
             userAccount.AccountId = userAccount.personaccount.PersonID__c;
             userAccount.AccountNumber = userAccount.personaccount.Account_Number__c;
         }
            
        List <Account_Details__c> ad = [Select Brand__c FROM Account_Details__c Where ID = :userAccount.AccountNumber];
        if(ad.size()>0)
        {
        	userAccount.Brand = ad[0].Brand__c;
        	String className = '';
        	if (userAccount.Brand == 'Chevron')
        	{
        		className ='logoorig.png';
        	}
        	else
        	{
        		className = 'spectrum_logo.jpg';
        	}
        	Cookie Brand = new Cookie('brand', className,null,-1,false);
        	ApexPages.currentPage().setCookies(new Cookie[]{Brand});
        	
        }
        	
    
		
		System.Debug('UserAccount:-' + userAccount);
		/* common code ends */
     		
			System.Debug('UserAccount:-' + userAccount);        	 
    		 
        	if(typeparam == '' )
        	{
        		typeparam ='Messages';
        	}
        	
        	if(userAccount.Brand == 'Chevron')
        	{
        		ImgName ='logoorig.png';
        		Stylesheet='main.css';
        		Sidebar='SidebarShowpage.css';
        		Responsivecss ='Responsive_Chevron.css';
        		CopyRights ='Chevron Federal Credit Union. All Rights Reserved';
        		Brand_Help = ses[0].Chevron_KB__c;
        	}
        	else
        	{
        		ImgName = 'spectrum_logo.jpg';
        		Stylesheet='spectrumcss.css';
        		Sidebar='SidebarShowpageSpectrum.css';
        		CopyRights ='Spectrum Credit Union. All Rights Reserved';
        		Responsivecss ='Responsive_Spectrum.css';
        		Brand_Help = ses[0].Spectrum_KB__c;
        	}
        	
        	return null;
        	
        	
        }
        
    /* remote action to support case views. Based on type of view (saved/messages/deleted etc... queries are executed to make a view and support UI functions)
    First cases are loaded then, member messages are loaded as part of the view.
    Cases with new member message are also added to messgae/inbox view*/    
    @RemoteAction
    global static MessageView LoadCase(string TypeOfView, string SortBy, string SortDirection)
	{	
		
		/* common code starts */
		CFCUAccount userAccount = new CFCUAccount();
		userAccount.personAccount = new Person_Account__c();
    	string LoggedinUser = UserInfo.getUserId();
        List<User> u = [SELECT Name, ContactId, FederationIdentifier from User Where ID=:LoggedinUser];
        userAccount.CurrentUser = u[0];
        userAccount.fedid = u[0].FederationIdentifier;
        List<contact> c = [SELECT AccountId, FirstName, MiddleName, LastName FROM Contact WHERE Id =:u[0].ContactId];
        	 
        if (c.size()>0)
         {
         	userAccount.userBusinessContact = c[0];
         }
            
	    userAccount.fedid =  userAccount.Get10DigitFid(userAccount.fedid);
	    List<Person_Account__c> personaccounts =  [SELECT Account_Number__c,Id,Name, PersonID__c FROM Person_Account__c Where Name_Type__c = 0 and Account_Number__r.Name =:userAccount.fedid];
            
            
         if(personaccounts.size()>0)
         {
        	 userAccount.personAccount = personaccounts[0];
             userAccount.AccountId = userAccount.personaccount.PersonID__c;
             userAccount.AccountNumber = userAccount.personaccount.Account_Number__c;
             System.Debug('userAccount.AccountNumber-' + userAccount.AccountNumber);
         }
            
        List <Account_Details__c> ad = [Select Brand__c FROM Account_Details__c Where ID = :userAccount.AccountNumber];
        if(ad.size()>0)
        {
        	userAccount.Brand = ad[0].Brand__c;
        }
        	
    	System.Debug('UserAccount:-' + userAccount);
		/* common code ends */
		DateTime date18months = DateTime.now().addMonths(-18);
		DateTime date5Years = DateTime.now().AddMonths(-60);
			if(TypeOfView == null || TypeOfView =='')
			{
				TypeOfView = 'Messages';
			}
			
        	integer i =0;
        	
       	MessageView mv = new MessageView(); 
	    Case[] caseIds = null;
	    List<Case> cases = null;
	    List<Case> casesCreatedBySupport = null;
	    List<Member_Comment__c> comments = null;
	     List<Member_Comment__c> CommentsbySupport = null;
	    List<Member_Comment__c> commentdate = null;
	    Set<Id> parentcaseId = new Set<Id>();
	    Integer messagecount; 
	   
	    caseIds = [SELECT Id from Case where Account_Number__r.Name= :userAccount.fedid and CreatedDate >= :date18months ];
    	commentdate =[Select CreatedDate from Member_Comment__c where  Case__c IN :caseIds and draft__c != true and draft__c != true order by CreatedDate limit 1 ];	
	 	mv.UserName = userAccount.CurrentUser.Name;
	 	System.Debug('user-' + userAccount.CurrentUser.Name);
       	if (TypeOfView == 'Messages')
       	{
	       		//cases =[SELECT Id, CaseNumber,Primary_Category__c,Description,Priority,Status,Subject,CreatedDate,IsMarkRead__c,contactid,
	       		//		createdbyId from Case where AccountId =:contactid and createdbyId !=:LoggedinUserID
	       		//		and IsMarkDeleted__c = false and IsMarkSaved__c = false and CreatedDate >= LAST_N_MONTHS:18]; 
	       		casesCreatedBySupport =[SELECT Id, CaseNumber,Primary_Category__c,Description,Priority,Status,Subject,CreatedDate,IsMarkRead__c,contactid,
	       				createdbyId,MemberCommentCount__c from Case where Account_Number__r.Name= :userAccount.fedid and 
	       				((createdbyId !=: LoggedinUser and MemberCommentCount__c > 0) or (createdbyId =: LoggedInUser))
	       				and IsMarkDeleted__c = false and IsMarkSaved__c = false and CreatedDate >= :date18months order by CreatedDate desc  ];
	     
		  	for( i =0 ; i < casesCreatedBySupport.size(); i ++)
			{
				
				//string caseidstr = '\'' + cases[i].Id + '\'';
				parentcaseId.Add(casesCreatedBySupport[i].Id);
			}
			//****** needs fix - filter by case or account id
			CommentsbySupport = [SELECT Case__r.Id, CreatedDate,Id,Member_Comment__c,Name, IsRead__c FROM Member_Comment__c Where CreatedById !=: LoggedinUser and draft__c != true and case__r.Account_Number__r.Name =:userAccount.fedid order by CreatedDate desc];
			if(CommentsbySupport.size()>0)
			{
				for(i=0; i < CommentsbySupport.size(); i ++)
				{
					parentcaseId.Add(CommentsbySupport[i].Case__r.Id);
				}
			}
			cases = [SELECT Id, CaseNumber,Primary_Category__c,Description,Priority,Status,Subject,CreatedDate,IsMarkRead__c,contactid,
	       				createdbyId,MemberCommentCount__c from Case where Id IN:parentcaseId and IsMarkDeleted__c = false
	       				 and IsMarkSaved__c = false and CreatedDate >= :date18months  order by CreatedDate desc];
	       				 
			comments =[SELECT Case__r.Id, CreatedDate,Id,Member_Comment__c,Name, IsRead__c FROM Member_Comment__c Where Case__r.Id IN : parentcaseId and draft__c != true order by CreatedDate desc];
			
		 //	 	messagecount = [Select count() from Case where Id IN:parentcaseId and IsMarkDeleted__c = false and IsMarkSaved__c = false and CreatedDate >= LAST_N_MONTHS:18 ];
       	}
       	
       	if(TypeOfView == 'DeletedMessages')
       	{
       		cases =[SELECT Id, CaseNumber,Primary_Category__c,Description,Priority,Status,Subject,CreatedDate,IsMarkRead__c,MemberCommentCount__c from Case 
							where IsMarkDeleted__c = true and IsMarkSaved__c = false and Account_Number__r.Name= : userAccount.fedid  and CreatedDate > :date18months
							and ((MemberCommentCount__c > 0 and createdbyId !=: LoggedinUser) or ( createdbyId =: LoggedinUser))
							 order by CreatedDate desc];
			if(cases.size() >0)
			{
				for( i =0 ; i <cases.size(); i ++)
				{
					parentcaseId.Add(cases[i].Id);
				}
			}
			System.Debug('parentcaseId=='+ parentcaseId);		
		  	//comments = [Select CommentBody, ParentId, CreatedDate from CaseComment where  parentId IN :parentcaseId ];
		  	comments =[SELECT Case__r.Id, CreatedDate,Id,Member_Comment__c,Name, IsRead__c FROM Member_Comment__c Where Case__r.Id IN : parentcaseId and draft__c != true order by CreatedDate desc];	
		 
       	}
       	
       if(TypeOfView == 'SavedMessages')
       	{
       		cases =[SELECT Id, CaseNumber,Primary_Category__c,Description,Priority,Status,Subject,CreatedDate,IsMarkRead__c,MemberCommentCount__c from Case
       					 where IsMarkSaved__c = true and Account_Number__r.Name= : userAccount.fedid and  IsMarkDeleted__c= false  and CreatedDate > :date5Years 
       					 and ((MemberCommentCount__c > 0 and createdbyId !=: LoggedinUser) or ( createdbyId =: LoggedinUser))
       					 order by CreatedDate desc];
			if(cases.size() >0)
			{
				for( i =0 ; i < cases.size(); i ++)
				{
					parentcaseId.Add(cases[i].Id);
				}
			}		
		  	//comments = [Select CommentBody, ParentId, CreatedDate from CaseComment where  parentId IN :parentcaseId ];
		  		comments =[SELECT Case__r.Id, CreatedDate,Id,Member_Comment__c,Name , IsRead__c FROM Member_Comment__c Where Case__r.Id IN : parentcaseId and draft__c != true order by CreatedDate desc];
       	}
       	if(TypeOfView == 'SentMessages')
       	{
       		cases =[SELECT Id, CaseNumber,Primary_Category__c,Description,Priority,Status,Subject,CreatedDate,IsMarkRead__c,MemberCommentCount__c from Case 
							where Account_Number__r.Name= : userAccount.fedid  and IsMarkSaved__c = false and IsMarkDeleted__c= false  and createdbyId =:LoggedinUser order by CreatedDate desc];
			if(cases.size() >0)
			{				
				for(i =0 ; i < cases.size(); i ++)
				{
					parentcaseId.Add(cases[i].Id);
				}
			}	
			System.Debug('parentcaseId====' + parentcaseId);	
			  	
		  	comments =[SELECT Case__r.Id, CreatedDate,Id,Member_Comment__c,Name , IsRead__c FROM Member_Comment__c Where Case__r.Id IN : parentcaseId and draft__c != true order by CreatedDate desc ];
		  	System.Debug('comments=='+ comments);
		
		 				
       	}
     	messagecount = GetMessageCount();
       	string shortdesc ='';
       	List<Message> messages = new List<Message>();
       	if(cases.size()>0)
		 {
			for( i =0 ; i < cases.size(); i++ )
			{
				Message message = new Message();
				message.casenumber = cases[i].CaseNumber; 
			
				message.PrimaryCategory = cases[i].Primary_Category__c;
			
				message.Description = cases[i].Description;
				
				message.Priority = cases[i].Priority;
				message.Status = cases[i].Status;
				message.Subject = cases[i].Subject;
				message.CreatedDate = cases[i].CreatedDate;
				message.Id = cases[i].Id;
				message.IsMarkRead = cases[i].IsMarkRead__c;
				message.ExpiresDate = cases[i].CreatedDate.addMonths(18);
				
				integer j = 0;
				for (j = 0; j < comments.size(); j++)
				{
					if (cases[i].Id == comments[j].Case__c)
					{	System.Debug('cases[i].Id' + cases[i].Id );
						System.Debug('comments[j].Case__c' + comments[j].Case__c );				
						//message.Description = comments[j].Member_Comment__c;
						message.CreatedDate = comments[j].CreatedDate;
						message.ExpiresDate = comments[j].CreatedDate.addMonths(18);
						if (comments[j].IsRead__c == false)
						{
							message.IsMarkRead  = false;			
						}
						break;
					}
				}
				
				
				if(message.Description != null)
				{			
					shortdesc = message.Description;
					shortdesc =shortdesc.abbreviate(100);
					message.Description = shortdesc; 
					
				}
				else
				{
					message.Description = ''; 
				}
				
				messages.Add(message);
			}	
		}
		
		List <Message> m1 = new List<Message>();
		
			Message [] m = messages;
		
			if(SortBy !='CreatedDate' && SortDirection !='Desc')
			{
				m1 = ShowCasesController.SortMessages(m,'CreatedDate', 'Desc');
				if(m1.Size() > 0 )
				{
					mv.LastUpdatedMessage = DateTime.Now(); //m1[0].CreatedDate;
					
				}
				else
				{
					mv.LastUpdatedMessage = system.now();
				}
				mv.MessageCount = messagecount;
				mv.Data = ShowCasesController.SortMessages(m, SortBy, SortDirection);	
			}
			
			else
			{
				m1 = ShowCasesController.SortMessages(m, SortBy, SortDirection);
				if(m1.Size() > 0)
				{
					mv.LastUpdatedMessage = system.Now(); //m1[0].CreatedDate;
			
						
				}
				else
				{
					mv.LastUpdatedMessage = system.now();
				}
			
				mv.Data = m1;	
					mv.MessageCount = messagecount;	
					
		}
	
		
		return mv;
	}
	/* method sortss data with date */
@TestVisible	private static List<Message> SortMessages(Message[] messages, string SortBy, string SortDirection )
	{
	 	
	 	if(messages.size()>0)
	 	{
	 	  integer targetsize = messages.size();	
		  while(afterSort.size() != targetsize){
                  ShowCasesController.findMinDateValue(SortBy,SortDirection,messages);
                  
            }
	 	}
          
        return  afterSort;  
	}
	@TestVisible  private static void findMinDateValue(string SB, string SD,Message[] messages )
	  {
 			List<string> cat = new List<string>();
 			if(SD == 'Desc' && SB == 'CreatedDate')
 			{
 				System.Debug('messages =='+ messages);
 				datetime dt = Datetime.newInstance(1900, 12, 31, 00, 00, 00); 
		        
		         for (integer i = 0; i != messages.size() ; i ++)
		         {
		            if(messages[i].CreatedDate > dt)
		            	{ 
		                        dt = messages[i].CreatedDate;
		                        mini = i;
		                  }
		         }
 			}
 			else if(SD == 'Asc' && SB == 'CreatedDate')
 			{
 				datetime dt = Datetime.newInstance(2999, 12, 31, 00, 00, 00);
 				
		        for (integer i = 0; i != messages.size() ; i ++){
		                  if(messages[i].CreatedDate < dt)
		                  { 
		                 
		                        dt = messages[i].CreatedDate;
		                        mini = i;
		                  }
		            }
		        
 			}
 			else if(SD == 'Desc' && SB == 'Category')
 			{
 				
 				String dt ='a';
 				for (integer i = 0; i != messages.size() ; i ++)
		         {
		            if(messages[i].PrimaryCategory > dt)
		            	{ 
		                        dt = messages[i].PrimaryCategory;
		                        mini = i;
		                }
		         }
 			}
 			else
 			{
 				String dt ='z';
 				for (integer i = 0; i != messages.size() ; i ++)
		         {
		            if(messages[i].PrimaryCategory < dt)
		            	{ 
		                        dt = messages[i].PrimaryCategory;
		                        mini = i;
		                }
		         } 
		         
		         			
 			}
 			
            afterSort.add(messages[mini]);
            
            messages.remove(mini);
        
      }
	
	
	/* method supports delete action */
	@RemoteAction
	global static void ButtonDelete_Click(string ids)
	{
		List<string> cids = new List <string>();
		for(string key: ids.split(','))
		{
			cids.add(key);
		}
		List<Case> cdata = [SELECT ID,IsMarkDeleted__c from case where Id IN :cids];
		for(Case cas:cdata)
		{
			cas.IsMarkDeleted__c = true;
			update cas;
		}
	}
	/* method supports delete action for saved messages */
	@RemoteAction
	global static void ButtonDelete1_Click(string ids)
	{
		List<string> cids = new List <string>();
		for(string key: ids.split(','))
		{
			cids.add(key);
		}
		List<Case> cdata = [SELECT ID,IsMarkDeleted__c from case where Id IN :cids];
		for(Case cas:cdata)
		{
			cas.IsMarkDeleted__c = true;
			cas.IsMarkSaved__c = false;
			update cas;
		}
	}
	/* method supports archive action */
	@RemoteAction
	global static void ButtonSave_Click(string ids)
	{
		List<string> cids = new List <string>();
		for(string key: ids.split(','))
		{
			cids.add(key);
		}
		List<Case> cdata = [SELECT ID,IsMarkSaved__c from case where Id IN :cids];
		for(Case cas:cdata)
		{
			cas.IsMarkSaved__c = true;
			update cas;
		}
	}
	/* method supports archive action for deleted messages*/
	@RemoteAction
	global static void ButtonSave1_Click(string ids)
	{
		List<string> cids = new List <string>();
		for(string key: ids.split(','))
		{
			cids.add(key);
		}
		List<Case> cdata = [SELECT ID,IsMarkSaved__c from case where Id IN :cids];
		for(Case cas:cdata)
		{
			cas.IsMarkSaved__c = true;
			cas.IsMarkDeleted__c = false;
			update cas;
		}
	}
	/* method supports mark as read action*/
	@RemoteAction
	global static void UpdateIsMarkRead(string id)
	{
		List<Case> cdata =[SELECT ID, IsMarkRead__c from case where Id =: id];
			for(Case cas:cdata)
			{
				cas.IsMarkRead__c = true;
				update cas;
			}
		List<Member_Comment__c> membercomments =  [SELECT Case__r.Id, CreatedDate,Id,Member_Comment__c,Name, IsRead__c FROM Member_Comment__c Where case__r.Id =: id and draft__c != true];
		
			for(Member_Comment__c mc:membercomments)
			{
				mc.IsRead__c = true;
				
			}
			update membercomments;
	}
	/* method supports get message count call*/
	@RemoteAction
    global static Integer GetMessageCount()
    {
    		/* common code starts */
		CFCUAccount userAccount = new CFCUAccount();
		userAccount.personAccount = new Person_Account__c();
    	string LoggedinUser = UserInfo.getUserId();
        List<User> u = [SELECT Name, ContactId, FederationIdentifier from User Where ID=:LoggedinUser];
        userAccount.CurrentUser = u[0];
        userAccount.fedid = u[0].FederationIdentifier;
        List<contact> c = [SELECT AccountId, FirstName, MiddleName, LastName FROM Contact WHERE Id =:u[0].ContactId];
        	 
        if (c.size()>0)
         {
         	userAccount.userBusinessContact = c[0];
         }
            
	    userAccount.fedid =  userAccount.Get10DigitFid(userAccount.fedid);
	    List<Person_Account__c> personaccounts =  [SELECT Account_Number__c,Id,Name, PersonID__c FROM Person_Account__c Where Name_Type__c = 0 and Account_Number__r.Name =:userAccount.fedid];
            
            
         if(personaccounts.size()>0)
         {
        	 userAccount.personAccount = personaccounts[0];
             userAccount.AccountId = userAccount.personaccount.PersonID__c;
             userAccount.AccountNumber = userAccount.personaccount.Account_Number__c;
         }
            
        List <Account_Details__c> ad = [Select Brand__c FROM Account_Details__c Where ID = :userAccount.AccountNumber];
        if(ad.size()>0)
        {
        	userAccount.Brand = ad[0].Brand__c;
        }
        		
		System.Debug('UserAccount:-' + userAccount);
		/* common code ends */
		
    	integer i;
    	List<Case> cases = null;
	    List<Case> casesCreatedBySupport = null;
	    List<Member_Comment__c> comments = null;
	    List<Member_Comment__c> CommentsbySupport = null;
	    List<Member_Comment__c> commentdate = null;
	    Set<Id> parentcaseId = new Set<Id>();
	    string LoggedinUserID =	UserInfo.getUserId();
	    
	    final Integer messagecount;
	  //  caseIds = [SELECT Id from Case where AccountId= :contact.AccountId and CreatedDate > LAST_N_MONTHS:18];
	 	
	    casesCreatedBySupport =[SELECT Id, CaseNumber,Primary_Category__c,Description,Priority,Status,Subject,CreatedDate,IsMarkRead__c,contactid,
	       				createdbyId from Case where Account_Number__r.Name= : userAccount.fedid and createdbyId !=:LoggedinUserID
	       				and IsMarkDeleted__c = false and IsMarkSaved__c = false and MemberCommentCount__c > 0 and CreatedDate >= LAST_N_MONTHS:18];
	       				
	     	for( i =0 ; i < casesCreatedBySupport.size(); i ++)
			{
				
				//string caseidstr = '\'' + cases[i].Id + '\'';
				parentcaseId.Add(casesCreatedBySupport[i].Id);
			}
			CommentsbySupport = [SELECT Case__r.Id, CreatedDate,Id,Member_Comment__c,Name, IsRead__c FROM Member_Comment__c Where CreatedById !=: LoggedinUserID and draft__c != true and case__r.Account_Number__r.Name= : userAccount.fedid];
			if(CommentsbySupport.size()>0)
			{
				for(i=0; i < CommentsbySupport.size(); i ++)
				{
					parentcaseId.Add(CommentsbySupport[i].Case__r.Id);
					
				}
			}
			cases = [SELECT Id, CaseNumber,Primary_Category__c,Description,Priority,Status,Subject,CreatedDate,IsMarkRead__c,contactid,
	       				createdbyId from Case where Id IN:parentcaseId and IsMarkDeleted__c = false and IsMarkSaved__c = false and CreatedDate >= LAST_N_MONTHS:18];
			comments =[SELECT Case__r.Id, CreatedDate,Id,Member_Comment__c,Name, IsRead__c FROM Member_Comment__c Where Case__r.Id IN : parentcaseId and draft__c != true order by CreatedDate desc];
				
			messagecount = [Select count() from Case where Id IN:parentcaseId and IsMarkDeleted__c = false and IsMarkSaved__c = false and IsMarkRead__c = false and MemberCommentCount__c > 0 and CreatedDate >= LAST_N_MONTHS:18 ];
			system.debug('parentcaseId' +  parentcaseId);
			system.debug('messagecount' +  messagecount);
    		return messagecount;
    		
    }

}