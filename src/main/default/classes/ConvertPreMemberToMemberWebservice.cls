global class ConvertPreMemberToMemberWebservice{
	webservice static void Convert(){
		ConvertPreMemberToMemberSchedular obj = new ConvertPreMemberToMemberSchedular();
		obj.Execute(null);
	}

	webservice static void CreateCaseForNonMatchedMember(){
		CreateAlertForNonMatchedMemberSchedular obj1 = new CreateAlertForNonMatchedMemberSchedular();
		obj1.Execute(null);
	}

	/*webservice static void MaturingCDTriggeredOpportunity() {
	 MaturingCDCreateOpportunitySchedular obj2 = new MaturingCDCreateOpportunitySchedular();
	 obj2.Execute(null);
	 } */
	/*webservice static void ImpendingDormancyTriggeredOpportunity() {
	 DormancyCreateOpportunitySchedular obj3 = new DormancyCreateOpportunitySchedular();
	 obj3.Execute(null);
	 }*/
	webservice static OTPVerificationModelWebService ListOfEmailsAndPhoneNumbers(string accid){
		//CreateAlertForNonMatchedMemberSchedular obj1 = new CreateAlertForNonMatchedMemberSchedular();
		OTPVerificationModel OTPVerificationModel = MemberVerificationLightningController.ListOfEmailsAndPhoneNumbers(accid, true);
		OTPVerificationModelWebService returnObj = new OTPVerificationModelWebService();

        List<KeyValuePairModelWithBitWebService> tempListMemId = new List<KeyValuePairModelWithBitWebService>();
        List<KeyValuePairModelWithBitWebService> tempPhoneList_Options = new List<KeyValuePairModelWithBitWebService>();
        List<KeyValuePairModelWithBitWebService> tempEmailsList_Options = new List<KeyValuePairModelWithBitWebService>();
        
        for (KeyValuePairModelWithBit kp : OTPVerificationModel.LstMemid){
			KeyValuePairModelWithBitWebService temp = new KeyValuePairModelWithBitWebService();
			temp.Text = kp.Text;
			temp.Value = kp.Value;
			temp.isEnabled = kp.isEnabled;
            temp.memId = kp.memId;
            tempListMemId.add(temp);
		}

        for (KeyValuePairModelWithBit kp : OTPVerificationModel.PhoneList_Options){
			KeyValuePairModelWithBitWebService temp = new KeyValuePairModelWithBitWebService();
			temp.Text = kp.Text;
			temp.Value = kp.Value;
			temp.isEnabled = kp.isEnabled;
            temp.memId = kp.memId;
            tempPhoneList_Options.add(temp);
        }
        
        for (KeyValuePairModelWithBit kp : OTPVerificationModel.EmailsList_Options){
			KeyValuePairModelWithBitWebService temp = new KeyValuePairModelWithBitWebService();
			temp.Text = kp.Text;
			temp.Value = kp.Value;
			temp.isEnabled = kp.isEnabled;
            temp.memId = kp.memId;
            tempEmailsList_Options.add(temp);
		}

		returnObj.LstMemid = tempListMemId;
		returnObj.PhoneList_Options = tempPhoneList_Options;
		returnObj.EmailsList_Options = tempEmailsList_Options;
		returnObj.IsIneligible = OTPVerificationModel.IsIneligible;
		returnObj.emailToShow = OTPVerificationModel.emailToShow;
		returnObj.Brand = OTPVerificationModel.Brand;


		return returnObj;
	}
}