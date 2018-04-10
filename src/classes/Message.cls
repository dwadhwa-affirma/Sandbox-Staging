global class Message {
   
		public string casenumber {get; set;}
		public string PrimaryCategory {get;set;}
		public string Description {get; set;} 
		public string ShortDescription {get;set;}
		public string Priority {get;set;}
		public string Status {get;set;} 
		public string Subject {get;set;}
		public datetime CreatedDate {get;set;}
		public Id Id {get;set;}
		//public string CommentBody {get;set;}
		//public string Type {get;set;}
		//public List<Member_Comment__c> comments {get;set;}
		public string SaveLink{get;set;}
    	public string DeleteLink {get;set;}
    	public string BackToView{get;set;}
    	//public datetime  caseCreatedDate{get;set;}
    	public Boolean shownext {get;set;} 
    	public Boolean showprev{get;set;}
    	public Boolean IsMarkDeleted {get;set;} 
    	public Boolean IsMarkSaved{get;set;}
    	public Boolean IsMarkRead{get;set;} 
    	public datetime ExpiresDate {get;set;}
    	public string LatestCommentBySupport {get;set;} 
    	public Id CreatedById {get;set;}
    	public List<FileList> files {get;set;}
    	public List<FileList> LatestCommentfiles {get;set;}
    	public Boolean ShowCaseBelow {get;set;} 
    	public Integer Days_after_closed_date {get; set;}
    	public DateTime CaseCreatedDate {get;set;}
    	
    	
		
}