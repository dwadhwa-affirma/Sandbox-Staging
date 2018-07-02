public class KeyValuePairModelWithBit
    {
    
    	@auraenabled
    	public string Text {get;set;}
    	@auraenabled
	    public string Value {get;set;}
	    @auraenabled
	    public boolean isEnabled {get;set;} 
	    
	    public KeyValuePairModelWithBit(string localtext, string localvalue, boolean isEnabled)
	    {
	    	this.Text = localtext;
	    	this.Value = localvalue;
	    	this.isEnabled = isEnabled;
	    }
	    public KeyValuePairModelWithBit()
	    {
	    	this.Text = null;
	    	this.Value = null;
	    	this.isEnabled = false;
	    }
    }