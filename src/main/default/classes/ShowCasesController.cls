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
     public static Boolean isTyfone;
    
    public static String tyfoneSSN;
	
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
            
	    userAccount.fedid =  userAccount.fedid.leftPad(10,'0');
        system.debug('ttt'+userAccount.fedid);    
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
        List<String> UserList = new List<String>();
        List<Integer> mnlist = new List<Integer>();
        List<String> mnSList = new List<String>();
        Boolean isTyfone = false;
     	String tyfoneSSN;
        set<string> AuthorizedCreatedbyIds =  new set<string>();
        
        system.debug('LoggedinUser: '+LoggedinUser);
        List<User> u = [SELECT Name, ContactId, FederationIdentifier from User Where ID=:LoggedinUser];
        system.debug('Loggedin UserName: '+u[0].Name);
        system.debug('Loggedin user FID: '+u[0].FederationIdentifier);
        
        userAccount.CurrentUser = u[0];
        userAccount.fedid = u[0].FederationIdentifier;
        List<contact> c = [SELECT AccountId, FirstName, MiddleName, LastName FROM Contact WHERE Id =:u[0].ContactId];
        
        if(c.size()>0){
        	userAccount.userBusinessContact = c[0];
        }
            
	    userAccount.fedid =  userAccount.fedid.leftPad(10,'0');
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

        string acName  = userAccount.fedid + '-' + userAccount.Brand;
        string acName2  = u[0].FederationIdentifier + '-' + userAccount.Brand;
        
        system.debug('acName: '+ acName);
        system.debug('acName2: '+ acName2);
        
        List<String> Accounts = new List<String>();
        List<String> eligibleAccounts = new List<String>();
        List<String> lstAccounts = new List<String>();
        List<String> finalAccounts = new List<String>();
        
        String AccString;
        List<String> AccList = new List<String>();
        List<Account> aList = [SELECT Id,Name,Description FROM Account WHERE Name=:acName OR Name =:acName2 order by lastmodifieddate desc Limit 1];
        
        if(aList.size()>0){
            
            if(aList[0].Description != null){
                
                AccString = aList[0].Description.replaceAll('[()]', '');
            	system.debug('AccString: '+AccString);
                
                if(AccString != null){
                    AccList = AccString.split(',');
                }
                system.debug('AccList: '+AccList);
                
                if(AccList.size() != 1 && AccList.size() != 0){
                	
                    if(AccList.contains(userAccount.fedid) == false){
                        Accounts.add(userAccount.fedid);
                    }
                    
                    tyfoneSSN =(AccList[AccList.size()-1]).right(9);
                    
                    AccList.remove(AccList.size()-1);
                    system.debug('AccList: '+AccList);
                    
                    for(String s : AccList){
                        Accounts.add(s.trim());
                        isTyfone = true;
                    }
					system.debug('tyfoneSSN: '+tyfoneSSN);
                    system.debug('isTyfone: '+isTyfone);                    
                }
                else if(AccList.size() == 1){
                    
                    tyfoneSSN =(AccList[AccList.size()-1]).right(9);
                    isTyfone = true;
                    system.debug('tyfoneSSN: '+tyfoneSSN);
                    system.debug('isTyfone: '+isTyfone);
                    
                    Accounts.add(userAccount.fedid);
                }                
            }
			else{
                Accounts.add(userAccount.fedid);
            }            
        }
        
    	System.Debug('UserAccount:-' + userAccount);
        System.Debug('Accounts:-' + Accounts);
        
        if(Accounts.size()>0){
        	eligibleAccounts.addAll(Accounts);    
        }
        
        //------------------------------------------Member Authorization Matrix-----------------------------//
        
        string strNumber, strSSN;
        strNumber = userAccount.fedid;
        strNumber = '%' + strNumber;
        string loanAPI;
        
        ACH_To_Episys_API_Details__c api = ACH_To_Episys_API_Details__c.getValues('ProductionURL');
                
        if(api.URL__c != null){
            loanAPI = api.URL__c;
        }
        
        system.debug('strNumber: '+strNumber);
        
        List<Person_Account__c> paPrimary = [SELECT Id, Account_Number__c,  PersonID__c, Account_Number__r.RecType__c, TypeTranslate__c, 
									Account_Number__r.Name,PersonID__r.PersonID__c,PersonID__r.Name
									FROM Person_Account__c 
									where Account_Number__r.Name like :strNumber and TypeTranslate__c like '%Primary%' LIMIT 1];

        if(paPrimary.size() > 0){            
            strSSN = paPrimary[0].PersonID__r.PersonID__c.substring(1);
        }
        
        system.Debug('strSSN: '+strSSN);
        system.debug('isTyfone: '+isTyfone);
        
        if(strSSN.length() == 9 && isTyfone == true){
            if(string.isNotBlank(tyfoneSSN)){
                strSSN = tyfoneSSN;
            }
        	system.Debug('strSSN: '+strSSN);
            system.debug('-------------------Webservice for Member Authorization---------------');
            
            HttpRequest req1 = new HttpRequest();
            HttpResponse res1;
            Http http1 = new Http();
            string responseBody1;
            string AuthrorizedAccountString = '';
        
            req1.setEndpoint(loanAPI + '/MemberAuthorization/GetAuthorizedAccounts?ssn=' + strSSN);
            req1.setMethod('GET');
            //req1.setTimeout(1200000);
            
            if(!Test.isRunningTest()){                       
                res1 = http1.send(req1);
                responseBody1 = res1.getBody();                
            }
            else{
                responseBody1 = '{"Accounts":"0000000123,0000000256"}';
            }
        
            system.debug('responseBody1: '+responseBody1);
        
            if(responseBody1 != ''){
                map<string, object> jsonParsed = (map<string, object>)JSON.deserializeUntyped(responseBody1);
                system.debug('jsonParsed=='+jsonParsed);
                AuthrorizedAccountString = (string)jsonParsed.get('Accounts');
            }
                
            lstAccounts = AuthrorizedAccountString.split(',');
            Set<String> setAccounts = new Set<String>(lstAccounts);
        
            system.debug('lstAccounts: '+lstAccounts);
            
            
            system.debug('-------------------Webservice for Authorized Members---------------');
            
            HttpRequest req2 = new HttpRequest();
            HttpResponse res2;
            Http http2 = new Http();
            string responseBody2;
            Set<String> setAuthorizedSSNList = new Set<String>();
        
            req2.setEndpoint(loanAPI + '/MemberAuthorization/GetAuthorizedMemeber?accountNumber=' + userAccount.fedid);
            req2.setMethod('GET');
            //req1.setTimeout(1200000);
            
            if(!Test.isRunningTest()){                       
                res2 = http2.send(req2);
                responseBody2 = res2.getBody();                
            }
            else{
                responseBody2 = '[{"AddressType":"0","type":0,"accounttype":null,"accountnumber":"0000000123"},{"AddressType":"0","type":1,"accounttype":null,"accountnumber":"0000000123"}]';
            }
        
            system.debug('responseBody2: '+responseBody2);
            
            if(responseBody2 != ''){
                List<Object> jsonParsed = (List<Object>)JSON.deserializeUntyped(responseBody2);
                system.debug('jsonParsed=='+jsonParsed);
                for (Object obj : jsonParsed){
                        Map<String, Object> objItem = (Map<String, Object>)obj;
                        system.debug(String.valueof(objItem.get('ssnnumber')));
                        if(string.isNotBlank(String.valueof(objItem.get('ssnnumber')))){
                            setAuthorizedSSNList.add('%' + String.valueof(objItem.get('ssnnumber')));  
                        }
                    	                  	
                }               
            }
           
            system.debug('setAuthorizedSSNList: '+setAuthorizedSSNList);
            List<Person_Account__c> AuthorizedPA = new List<Person_Account__c>();
            if(setAuthorizedSSNList != null &&  setAuthorizedSSNList.size() > 0){
                AuthorizedPA = [select Id, Account_Number__c,  PersonID__c, Account_Number__r.RecType__c, TypeTranslate__c, 
									Account_Number__r.Name,PersonID__r.PersonID__c,PersonID__r.Name from person_account__c where PersonID__r.PersonID__c like: setAuthorizedSSNList and TypeTranslate__c like '%Primary%'];
            }
            
            Set<string> AuthorzedfedIds = new Set<string>();
            for(Person_Account__c apa: AuthorizedPA){
                string fedidwithoutzeros = apa.Account_Number__r.Name.replaceFirst('^0+', '');
                AuthorzedfedIds.add(fedidwithoutzeros);
            }
            
            List<User> AuthrorizedUsers = [Select id, name from user where FederationIdentifier in: AuthorzedfedIds];
            for(User us: AuthrorizedUsers){
                AuthorizedCreatedbyIds.add(us.id);
            }
 		}
        
        system.debug('eligibleAccounts: '+eligibleAccounts);
        
        for(string s: eligibleAccounts){
            system.debug('s: '+s.length());
        }
        for(string s1: lstAccounts){
            system.debug('s1: '+s1.length());
        }
        
        for(String a : eligibleAccounts){
            if(lstAccounts.contains(a.trim())){
            	finalAccounts.add(a);                
            }    
        }
        system.debug('finalAccounts: '+finalAccounts);
        
        system.debug('Accounts: '+Accounts);
        
        For(String mnumbers : Accounts){
            mnlist.add(integer.valueOf(mnumbers.trim()));
        }
        System.debug('mnlist: '+mnlist);
        
        For(Integer i : mnlist){
            mnSList.add(string.valueOf(i));
        }
        System.debug('mnSList: '+mnSList);
        
       	For(user uaccount : [select id,FederationIdentifier from user where FederationIdentifier in :Accounts OR FederationIdentifier in :mnSList]){
        	UserList.add(uaccount.id);
        }
        System.debug('UserList: '+UserList);
        
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
        System.Debug('UserList-' + UserList);
       	if (TypeOfView == 'Messages')
       	{
	       		//cases =[SELECT Id, CaseNumber,Primary_Category__c,Description,Priority,Status,Subject,CreatedDate,IsMarkRead__c,contactid,
	       		//		createdbyId from Case where AccountId =:contactid and createdbyId !=:LoggedinUserID
	       		//		and IsMarkDeleted__c = false and IsMarkSaved__c = false and CreatedDate >= LAST_N_MONTHS:18]; 
            if(AuthorizedCreatedbyIds.size() > 0){
                casesCreatedBySupport =[SELECT Id, CaseNumber,Account_Number__r.Name,Primary_Category__c,Description,Priority,Status,Subject,CreatedDate,IsMarkRead__c,contactid,
	       				createdbyId,MemberCommentCount__c from Case where /*Account_Number__r.Name= :userAccount.fedid and*/
                                        Account_Number__r.Name in:finalAccounts and
	       				((createdbyId !=: LoggedinUser and MemberCommentCount__c > 0) or (createdbyId in :UserList) or (createdbyId in :AuthorizedCreatedbyIds)) and                                        
                        IsMarkDeleted__c = false and IsMarkSaved__c = false and CreatedDate >= :date18months order by CreatedDate desc  ];
            }	
            else{
                casesCreatedBySupport =[SELECT Id, CaseNumber,Account_Number__r.Name,Primary_Category__c,Description,Priority,Status,Subject,CreatedDate,IsMarkRead__c,contactid,
	       				createdbyId,MemberCommentCount__c from Case where /*Account_Number__r.Name= :userAccount.fedid and*/
                                        Account_Number__r.Name in:finalAccounts and
	       				((createdbyId !=: LoggedinUser and MemberCommentCount__c > 0) or (createdbyId in :UserList)) and                                        
                        IsMarkDeleted__c = false and IsMarkSaved__c = false and CreatedDate >= :date18months order by CreatedDate desc  ];
            }
	     
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
			cases = [SELECT Id, CaseNumber,Account_Number__r.Name,Primary_Category__c,Description,Priority,Status,Subject,CreatedDate,IsMarkRead__c,contactid,
	       				createdbyId,MemberCommentCount__c from Case where Id IN:parentcaseId and IsMarkDeleted__c = false
	       				 and IsMarkSaved__c = false and CreatedDate >= :date18months  order by CreatedDate desc];
	       				 
			comments =[SELECT Case__r.Id, CreatedDate,Id,Member_Comment__c,Name, IsRead__c FROM Member_Comment__c Where Case__r.Id IN : parentcaseId and draft__c != true order by CreatedDate desc];
			
		 //	 	messagecount = [Select count() from Case where Id IN:parentcaseId and IsMarkDeleted__c = false and IsMarkSaved__c = false and CreatedDate >= LAST_N_MONTHS:18 ];
       	}
       	
       	if(TypeOfView == 'DeletedMessages')
       	{
       		cases =[SELECT Id, CaseNumber,Account_Number__r.Name,Primary_Category__c,Description,Priority,Status,Subject,CreatedDate,IsMarkRead__c,MemberCommentCount__c from Case 
							where IsMarkDeleted__c = true and IsMarkSaved__c = false and /*Account_Number__r.Name= : userAccount.fedid*/
                    		Account_Number__r.Name in:finalAccounts and CreatedDate > :date18months
							and ((MemberCommentCount__c > 0 and createdbyId !=: LoggedinUser) or 
                            (createdbyId in :UserList)) order by CreatedDate desc];
            
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
       		cases =[SELECT Id, CaseNumber,Account_Number__r.Name,Primary_Category__c,Description,Priority,Status,Subject,CreatedDate,IsMarkRead__c,MemberCommentCount__c from Case
                    	where IsMarkSaved__c = true and /*Account_Number__r.Name= : userAccount.fedid*/
                    	Account_Number__r.Name in:finalAccounts and  IsMarkDeleted__c= false  and CreatedDate > :date5Years 
       					and ((MemberCommentCount__c > 0 and createdbyId !=: LoggedinUser) or ( createdbyId in :UserList))
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
       		cases =[SELECT Id, CaseNumber,Account_Number__r.Name,Primary_Category__c,Description,Priority,Status,Subject,CreatedDate,IsMarkRead__c,MemberCommentCount__c from Case 
							where /*Account_Number__r.Name= : userAccount.fedid*/
                    		Account_Number__r.Name in:finalAccounts and IsMarkSaved__c = false and IsMarkDeleted__c= false  
                    		and createdbyId =:UserList order by CreatedDate desc];
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
				message.accountNumber = cases[i].Account_Number__r.Name; 
                
                String valueToMask = cases[i].Account_Number__r.Name.substring(0, 8);
                String mask = '*'.repeat(valueToMask.length());
                String masked = cases[i].Account_Number__r.Name.replaceFirst(valueToMask, mask);
                system.debug('Masked:'+masked);
                
				message.MaskedaccountNumber = masked;
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
		System.debug('-------------In--------------');        
	}
	/* method supports get message count call*/
	@RemoteAction
    global static Integer GetMessageCount()
    {
    		/* common code starts */
        List<String> ListAllMemberShips = new List<String>();
        ListAllMemberShips = getMembership();
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
            
	    userAccount.fedid =  userAccount.fedid.leftPad(10,'0');
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
        Integer Casemessagecount;
	  //  caseIds = [SELECT Id from Case where AccountId= :contact.AccountId and CreatedDate > LAST_N_MONTHS:18];
	 	
	    casesCreatedBySupport =[SELECT Id, CaseNumber,Primary_Category__c,Description,Priority,Status,Subject,CreatedDate,IsMarkRead__c,contactid,
	       				createdbyId from Case where Account_Number__r.Name IN: ListAllMemberShips and createdbyId !=:LoggedinUserID
	       				and IsMarkDeleted__c = false and IsMarkSaved__c = false and MemberCommentCount__c > 0 and CreatedDate >= LAST_N_MONTHS:18];
	       				
	     	for( i =0 ; i < casesCreatedBySupport.size(); i ++)
			{
				
				//string caseidstr = '\'' + cases[i].Id + '\'';
				parentcaseId.Add(casesCreatedBySupport[i].Id);
			}
			CommentsbySupport = [SELECT Case__r.Id, CreatedDate,Id,Member_Comment__c,Name, IsRead__c FROM Member_Comment__c Where CreatedById !=: LoggedinUserID and draft__c != true and case__r.Account_Number__r.Name IN: ListAllMemberShips];
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
        
        	List<Member_Comment__c> UnreadcommentsfromReadCases =[SELECT Case__r.Id, CreatedDate,Id,Member_Comment__c,Name, IsRead__c FROM Member_Comment__c Where Case__r.Id IN : parentcaseId and draft__c != true and Case__r.IsMarkRead__c = true and IsRead__c = false order by CreatedDate desc];
				
			messagecount = [Select count() from Case where Id IN:parentcaseId and IsMarkDeleted__c = false and IsMarkSaved__c = false and IsMarkRead__c = false and MemberCommentCount__c > 0 and CreatedDate >= LAST_N_MONTHS:18 ];
			/*set<id> ReadCaseswithUnreadComments = new set<id>();
            for(Member_Comment__c mc:UnreadcommentsfromReadCases){
                ReadCaseswithUnreadComments.add(mc.Case__c);
            }	
        	messagecount = Casemessagecount + ReadCaseswithUnreadComments.size();*/
        	system.debug('parentcaseId' +  parentcaseId);
			system.debug('messagecount' +  messagecount);
    		return messagecount;
    		
    }
    
    public static List<String> getMembership(){
		
        List<String> options = new List<String>();     
        
        CFCUAccount userAccount = new CFCUAccount();
        userAccount.personAccount = new Person_Account__c();
        string LoggedinUser = UserInfo.getUserId();
        List<User> u = [SELECT Name, ContactId, FederationIdentifier from User Where ID = :LoggedinUser];
        system.debug('Loggedin Id: '+u[0].Id);
        system.debug('Loggedin UserName: '+u[0].Name);
        system.debug('Loggedin user FID: '+u[0].FederationIdentifier);
        
        userAccount.CurrentUser = u[0];
        userAccount.fedid = u[0].FederationIdentifier;
        userAccount.fedid = userAccount.fedid.leftPad(10,'0');
        
        List<Person_Account__c> personaccounts = [SELECT Account_Number__c, Id, Name, PersonID__c,Account_Number__r.name
                                                  FROM Person_Account__c
                                                  Where Name_Type__c = 0 and Account_Number__r.Name = :userAccount.fedid];        
        
        System.debug(personaccounts[0].Account_Number__r.name);
        system.debug(userAccount.fedid);
        system.debug(u[0].name);
        
        List<Account_Details__c> ad = [Select name,Brand__c FROM Account_Details__c Where name = :userAccount.fedid LIMIT 1];
        if (ad.size() > 0){
            userAccount.Brand = ad[0].Brand__c;
        }
        
        string acName  = userAccount.fedid + '-' + userAccount.Brand;
        string acName2 = u[0].FederationIdentifier + '-' + userAccount.Brand;
            
        String AccString;
        List<String> AccList = new List<String>();
        List<String> AccDisList = new List<String>();
        
        system.debug(acName);
        system.debug(acName2);
        List<Account> aList = [SELECT Id,Name,Description FROM Account WHERE Name=:acName OR Name =:acName2 order by lastmodifieddate desc Limit 1];
        //system.debug('aList: '+aList[0].id);
        
        if(aList.size()>0){
            if(aList[0].Description != null){
                
                AccString = aList[0].Description.replaceAll('[()]', '');
            	system.debug('AccString: '+AccString);
                AccDisList.add(userAccount.fedid);
               
                if(AccString != null){
                    AccList = AccString.split(',');
                }
                system.debug('AccList: '+AccList);
                
                if(AccList.size() != 1){
                	
                    options.add(userAccount.fedid);                                          
                    tyfoneSSN =(AccList[AccList.size()-1]).right(9);
                    
                    AccList.remove(AccList.size()-1);     
                    system.debug('AccList: '+AccList);
                	
                    for(String s : AccList){
                        options.add(s.trim());
                        AccDisList.add(s.trim()); 
                        isTyfone = true;
                    }
                    
                    system.debug('tyfoneSSN: '+tyfoneSSN);
                    system.debug('isTyfone: '+isTyfone);
                    system.debug('AccDisList'+AccDisList);                  
                        
                                  
                }
                else if(AccList.size() == 1){
                    
                    tyfoneSSN =(AccList[AccList.size()-1]).right(9);
                    isTyfone = true;
                    system.debug('tyfoneSSN: '+tyfoneSSN);
                    system.debug('isTyfone: '+isTyfone);                    
                    options.add(userAccount.fedid);                    
                }
            }
            else{
                options.add(userAccount.fedid);                
            }            
        }
        
		return options;
	}

	/*STRY0012065  - Getting Email Address and adding warning if member tries to create or reply to a secure email if they don't have an email address.*/
	@RemoteAction
    global static EmailWrapper GetEmailAddress()
	{	
		EmailWrapper EmailResult = new EmailWrapper();
		CFCUAccount userAccount = new CFCUAccount();        
        string LoggedinUser = UserInfo.getUserId();
        List<User> u = [SELECT Name, ContactId, FederationIdentifier from User Where ID = :LoggedinUser];
           
        
        userAccount.CurrentUser = u[0];
        userAccount.fedid = u[0].FederationIdentifier;
        userAccount.fedid = userAccount.fedid.leftPad(10,'0');
        
        List<Account_Details__c> ad = [Select name,Brand__c FROM Account_Details__c Where name = :userAccount.fedid LIMIT 1];
        if (ad.size() > 0){
            userAccount.Brand = ad[0].Brand__c;
        }
        
        string acName  = userAccount.fedid + '-' + userAccount.Brand;
        string acName2 = u[0].FederationIdentifier + '-' + userAccount.Brand;
            
        String AccString;
        List<String> AccList = new List<String>();
        List<String> AccDisList = new List<String>();
       
        List<Account> aList = [SELECT Id,Name,Description FROM Account WHERE Name=:acName OR Name =:acName2 order by lastmodifieddate desc Limit 1];
        
        
        if(aList.size()>0){
            if(aList[0].Description != null){
                
                AccString = aList[0].Description.replaceAll('[()]', '');            	
                AccDisList.add(userAccount.fedid);
               
                if(AccString != null){
                    AccList = AccString.split(',');
                }                
                
                if(AccList.size() != 1){                	                                     
                    tyfoneSSN =(AccList[AccList.size()-1]).right(9);                    
                    AccList.remove(AccList.size()-1);               
                }
                else if(AccList.size() == 1){                    
                    tyfoneSSN =(AccList[AccList.size()-1]).right(9);                                   
                }
            }                     
        }
		system.debug('tyfoneSSN=='+tyfoneSSN);
		string TyfoneEmail = '';	
		string strSSN = '%' + tyfoneSSN;	
		system.debug('strSSN=='+strSSN);
		List<Person_Account__c> paPrimary = [SELECT Id, Account_Number__c,  PersonID__c, Account_Number__r.RecType__c, TypeTranslate__c, 
                                       Account_Number__r.Name,PersonID__r.PersonID__c,PersonID__r.Name, PersonID__r.PersonEmail	
                                       FROM Person_Account__c 
                                       where PersonID__r.PersonID__c like :strSSN                         			   
                         			   order by CreatedDate LIMIT 1];
		if(paPrimary.size() > 0){           
            if(string.isNotBlank(paPrimary[0].PersonID__r.PersonEmail))
				TyfoneEmail = paPrimary[0].PersonID__r.PersonEmail;
			else {
				TyfoneEmail = '';
				List<Secure_Email_Messages__mdt> SEmdt = [SELECT id, Message__c, Label, Brand__c from Secure_Email_Messages__mdt where Brand__c =: userAccount.Brand and Label like 'Email_Not_Available%' limit 1];
				if(SEmdt.size() > 0){
					EmailResult.ErrorMessage = SEmdt[0].Message__c;
				}
				
			}
        }

		
		
		system.debug('TyfoneEmail=='+TyfoneEmail);
		EmailResult.Email = TyfoneEmail;
		
		return EmailResult;
		
	}

	global class EmailWrapper{
		public string Email {get; set;}
		public string ErrorMessage {get; set;}
	}
}