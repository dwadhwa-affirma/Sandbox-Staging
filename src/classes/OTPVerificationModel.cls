public class OTPVerificationModel {

	@auraenabled
    public List<KeyValuePairModel> PhoneList_Options {get;set;}
    @auraenabled
    public List<KeyValuePairModel> EmailsList_Options {get;set;}
    
    @auraenabled
    public string IsIneligible {get;set;}
    
    @auraenabled
    public string Brand {get;set;}
   
   
}