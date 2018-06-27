global class KeyValuePairModel
    {
    
    	@auraenabled
    	public string Text {get;set;}
    	@auraenabled
	    public string Value {get;set;} 
	    
	    public KeyValuePairModel(string localtext, string localvalue)
	    {
	    	this.Text = localtext;
	    	this.Value = localvalue;
	    }
	    public KeyValuePairModel()
	    {
	    	this.Text = null;
	    	this.Value = null;
	    }
    }