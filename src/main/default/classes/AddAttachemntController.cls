global with sharing   class AddAttachemntController {
	public string UserName {get;set;}
	public string Stylesheet{get;set;}
	public string BrandName {get;set;}
	public string ImgName {get;set;}
	public string Sidebar{get;set;}
	public string CopyRights{get;set;}
	public string Extension {get;set;}
	 public List<selectOption> AccountNames{ get; set; }
	public string parentId {get;set;}
	 public set<String> accountNumberSet {get; set;}
	public List<Attachment> listAttachment{get;set;}
	public string Brand_Help {get;set;}
	public string Responsivecss {get;set;}
	public string parentType {get;set;}
	public string title {get;set;}
	public string SB {get;set;}
	public string SD {get;set;}
	public Attachment[] attachments {
	    get;
	    set;
	}
	public List<FileList> attachmentlist {get;set;}
		
	
	public List<FileList> ConvertAttachemntToFilelist()
	{
		 if (attachments != null)
        {
        	List<FileList> filelists = new List<FileList>();
        	integer j = 0;
            for(j=0; j< attachments.size(); j++ )
            {
                
                    FileList fl = new FileList();
                    fl.filename = attachments[j].Name;
                    fl.downloadurl = 'servlet/servlet.FileDownload?file=' + attachments[j].id ;
                    string ext = '';
                    try
                    { 
                        ext = attachments[j].Name.split('\\.')[1];
                    }
                    catch (Exception ex)
                    {
                    
                    }
                    ext = ext.toLowerCase();
                    if(ext == 'doc' || ext == 'docx'){
                    	ext = 'word';
                    }
                    else if(ext == 'xls' || ext == 'xlsx'){
                    	ext = 'excel';
                    }
                    else if(ext == 'ppt' || ext == 'ppts'){
                    	ext = 'powerpoint';
                    }
                     else if(ext == 'jpg' || ext == 'jpeg' || ext == 'png'|| ext == 'bmp'){
                    	ext = 'jpg';
                    }
                    else if(ext == 'one'){
                    	ext = 'onenote';
                    }
                    
                    fl.fileicon = ext;
                    string displaysize;
                    if(attachments[j].BodyLength != Null){    
	                    if(attachments[j].BodyLength < 1000)
	                    {
	                        displaySize = attachments[j].BodyLength + ' Bytes';
	                        //displaySize = attachments[j].BodyLength + 'KB';
	                        System.debug('displaySize1=='+ displaySize);
	                    }                               
	                    else if(attachments[j].BodyLength > 1000 && attachments[j].BodyLength < 1000000)
	                    {
	                        displaySize = Math.floor(attachments[j].BodyLength/1000) + ' KB';
	                        //displaySize = attachments[j].BodyLength + 'KB';
	                        System.debug('displaySize1=='+ displaySize);
	                    }
	                    else
	                    {
	                        displaySize  = Math.round((attachments[j].BodyLength / 1000000)*10)/10 + ' MB';
	                        //displaySize  = (attachments[j].BodyLength)/100 + 'MB';
	                         System.debug('displaySize2=='+ displaySize);
	                    }
                    }
                    fl.filesize = displaySize;
                    filelists.add(fl);
                
            }
            return filelists;
        }
		return null;
	}	
		public string  entityType {get;set;}
		public string  caseid {get;set;} 
				
	public AddAttachemntController()
	 {
	 	AccountNames = new List<selectOption>();
	    accountNumberSet = new Set<String>();   
	    parentId = ApexPages.currentPage().getParameters().get('parentId');
	    parentType = ApexPages.currentPage().getParameters().get('parentType');
	    SB = ApexPages.currentPage().getParameters().get('SB');
	    SD = ApexPages.currentPage().getParameters().get('SD');
	    entityType = ApexPages.currentPage().getParameters().get('entityType');
	   
	   	
	   
	    if(entityType == null || entityType == '')
	    {
	    	entityType = 'case';
	    }
	    if(entityType == 'case')
	    {
	    	parentType = 'SentMessages';
	    	Case c = [select Subject,CaseNumber from Case where Id =: parentId limit 1];
	    	caseid = c.id;
	    	title = 'Case # ' +  c.CaseNumber + ' - Upload files'; 
	    }
	    else if(entityType == 'notes')
	    {
	    	
	    	
	    	Member_Comment__c n = [select Member_Communication__c,Case__c from Member_Comment__c where ID  =: parentId limit 1];
	    	
	    	Case c = [select id,Subject,CaseNumber from Case where Id =: n.Case__c limit 1];
	    	
	    	title = 'Case # ' +  c.CaseNumber + ' - Upload files for reply'; 
	    	caseid = c.id;
	    }
	    	
	    
	    Attachment[] attachmentsLocal = [
	                    select Id, Name, Description, LastModifiedDate,BodyLength
	                    from Attachment
	                    where ParentId = :parentId
	                    order by Name
	                    ];
	    attachments =    attachmentsLocal;
	    attachmentlist = ConvertAttachemntToFilelist();
    }
    
    public void RefreshAll()
    {
    		
    	    Attachment[] attachmentsLocal = [
	                    select Id, Name, Description, LastModifiedDate,BodyLength
	                    from Attachment
	                    where ParentId = :parentId
	                    order by Name
	                    ];
	                    system.debug('111111');
	    attachments =    attachmentsLocal;
	    attachmentlist = ConvertAttachemntToFilelist();
	    system.debug('111111');
    }
    
	 public PageReference  PageLoad()
       {
        	getCategory();
        	
List <SecureEmailSetting__c> ses = SecureEmailSetting__c.getall().values();
		
        Extension = ses[0].List_of_Allowed_Extensions__c;
        
		CFCUAccount userAccount = new CFCUAccount();
		userAccount.personAccount = new Person_Account__c();
    	string LoggedinUser = UserInfo.getUserId();
        List<User> u = [SELECT Name, ContactId, FederationIdentifier from User Where ID=:LoggedinUser];
        userAccount.CurrentUser = u[0];
        userAccount.fedid = u[0].FederationIdentifier;
        UserName = userAccount.CurrentUser.Name;
        List<contact> c = [SELECT AccountId, FirstName, MiddleName, LastName FROM Contact WHERE Id =:u[0].ContactId];
        	 
        if (c.size()>0)
         {
         	userAccount.userBusinessContact = c[0];
         }
            system.debug('userAccount.fedid...' + userAccount.fedid);
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
		
            if(userAccount.Brand == 'Chevron')
        	{
        	   ImgName ='logoorig.png';
                Stylesheet= 'message1.css';
                CopyRights ='Chevron Federal Credit Union. All Rights Reserved';
                Sidebar ='SidebarSubmitPage.css';
                Brand_Help = ses[0].Chevron_KB__c;
                Responsivecss ='Responsive_Chevron.css';
        	}
        	else
        	{
        		ImgName = 'spectrum_logo.jpg';
                Stylesheet= 'message1_spectrum.css';
                CopyRights ='Spectrum Credit Union. All Rights Reserved';
                Sidebar ='SidebarSubmitPage.css';
                Brand_Help = ses[0].Spectrum_KB__c;
                Responsivecss ='Responsive_Spectrum.css';
        	}
        	
	        
        	 return null;	
        }
        
        public void RemoveFile()
        {
        
        		string id =  ApexPages.CurrentPage().getParameters().get('id').split('=')[1];
        		
        	  for (integer i = 0; i < attachments.size(); i++)
		        {
		            if (id == attachments[i].id)
		            {
		
		               
		                    delete attachments[i];
		               
		
		
		                attachments.remove(i);
		                
		                break;
		            }
		        }
        	 attachmentlist = ConvertAttachemntToFilelist();
        	
        	
        	 
        }
        
        public List<SelectOption> getCategory()
	{
		
	 	List<SelectOption> options = new List<SelectOption>();
	    Schema.Describefieldresult primaryCategory = Case.Primary_Category__c.getDescribe();
	    	
	        
	  // 	Schema.DescribeFieldResult fieldResult = Schema.sObjectType.cases.fields.Primary_Category__c.getDescribe();
	   	List<Schema.PicklistEntry> ple = primaryCategory.getPicklistValues();
	        
	  	 for( Schema.PicklistEntry f : ple)
		   {
		      options.add(new SelectOption(f.getValue(),f.getLabel()));
		   }       
	    return options;
	}

}