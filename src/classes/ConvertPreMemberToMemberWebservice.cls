global class ConvertPreMemberToMemberWebservice {
    webservice static void Convert() {
        ConvertPreMemberToMemberSchedular obj = new ConvertPreMemberToMemberSchedular();
        obj.Execute(null);
    }
    webservice static void CreateCaseForNonMatchedMember() {
        CreateAlertForNonMatchedMemberSchedular obj1 = new CreateAlertForNonMatchedMemberSchedular();
        	obj1.Execute(null);
    }
    /*webservice static void MaturingCDTriggeredOpportunity() {
        MaturingCDCreateOpportunitySchedular obj2 = new MaturingCDCreateOpportunitySchedular();
        obj2.Execute(null);
    } */
    webservice static void ImpendingDormancyTriggeredOpportunity() {
        DormancyCreateOpportunitySchedular obj3 = new DormancyCreateOpportunitySchedular();
        obj3.Execute(null);
    }
}