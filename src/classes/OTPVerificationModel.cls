public class OTPVerificationModel {

	@auraenabled
    public List<KeyValuePairModelWithBit> LstMemid {get;set;}
	@auraenabled
    public List<KeyValuePairModelWithBit> PhoneList_Options {get;set;}
    @auraenabled
    public List<KeyValuePairModelWithBit> EmailsList_Options {get;set;}
    
    @auraenabled
    public string IsIneligible {get;set;}
    
    @auraenabled
    public string Brand {get;set;}
   

}