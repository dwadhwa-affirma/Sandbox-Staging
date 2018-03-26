global class MemberComment {
	public string CreatedById  {get;set;}
	public Datetime CreatedDate {get;set;}
    public string ShortComment {get;set;}
    public string FullComment {get;set;}
    public List<FileList> files {get;set;}
   
}