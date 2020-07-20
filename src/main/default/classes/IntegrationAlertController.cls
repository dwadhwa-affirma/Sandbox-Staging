public class IntegrationAlertController {

    public list<Integration_Alerts__c> showList = new list<Integration_Alerts__c>([select Name ,Link__c, Alert__c, Description__c, Type__c, Order__c, Link_URL__c from Integration_Alerts__c where Order__c > 0 OR Expiration__c > TODAY]);
    Public list<Integration_Alerts__c> getshowList(){
        
        return showList;
    }
}