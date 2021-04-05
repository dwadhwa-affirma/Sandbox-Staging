global class OTPVerificationModelWebService {

	@auraenabled
    webservice List<KeyValuePairModelWithBitWebService> LstMemid {get;set;}
	@auraenabled
    webservice List<KeyValuePairModelWithBitWebService> PhoneList_Options {get;set;}
    @auraenabled
    webservice List<KeyValuePairModelWithBitWebService> EmailsList_Options {get;set;}
    
    @auraenabled
    webservice string IsIneligible {get;set;}
    
    @auraenabled
    webservice string Brand {get;set;}
    
    @auraenabled
    webservice Boolean emailToShow {get;set;}
   
}