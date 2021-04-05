global inherited sharing class KeyValuePairModelWithBitWebService {
    
    @auraenabled
    webservice string Text {get;set;}
    @auraenabled
    webservice string Value {get;set;}
    @auraenabled
    webservice boolean isEnabled {get;set;} 
    @auraenabled
    webservice string memId {get;set;} 
    
    public KeyValuePairModelWithBitWebService(string localtext, string localvalue, boolean isEnabled)
    {
        this.Text = localtext;
        this.Value = localvalue;
        this.isEnabled = isEnabled;
    }
    public KeyValuePairModelWithBitWebService(string localtext, string localvalue, boolean isEnabled,string localmemid)
    {
        this.Text = localtext;
        this.Value = localvalue;
        this.isEnabled = isEnabled;
        this.memId = localmemid;
    }
    public KeyValuePairModelWithBitWebService()
    {
        this.Text = null;
        this.Value = null;
        this.isEnabled = false;
    }
}
