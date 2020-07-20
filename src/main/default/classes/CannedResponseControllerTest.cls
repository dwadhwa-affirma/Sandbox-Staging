@isTest
public class CannedResponseControllerTest {
    public static testMethod void CRExtnControllerMethodTest(){
        
        List<Canned_Responses__c> crLst = new List<Canned_Responses__c>();
        Canned_Responses__c cr = new Canned_Responses__c();        
            cr.Primary_Lookup_Text__c  = 'Test';
            cr.Secondary_Lookup_Text__c = 'Test';
            cr.Tertiary_Lookup_Text__c = 'Test';
            crLst.add(cr);
            insert crLst;
    
    	CannedResponseController.GetCannedResponse('');
    	CannedResponseController.GetCannedResponse(cr.id);
    	
    	CannedResponseController.saveCannedResponse(cr);
      
    }
}