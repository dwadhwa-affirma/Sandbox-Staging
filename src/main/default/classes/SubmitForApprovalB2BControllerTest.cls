@isTest
public class SubmitForApprovalB2BControllerTest {

    static testMethod void CreateOpportunityControllerTest1(){
        
       	User u = [Select id, name, alias from User where alias = 'mcat'];
        
        SolarLoan_To_Episys_API_Details__c api = new SolarLoan_To_Episys_API_Details__c();
     	api.URL__c = 'https://symxapi.chevronfcu.org/devclient';
     	api.Name = 'ProductionURL';
     	insert api;
        
        Account account_Obj = new Account(PersonHomePhone='', PersonHasOptedOutOfEmail = false, Name = 'MARIA BANDA');
        insert account_Obj; 
        
        test.StartTest();
       
        Contact c = new contact();
        c.AccountID = account_Obj.id;
        c.FirstName = 'FirstName';
        c.LastName = 'LastName';
        insert c;
              
        Opportunity op1 = new Opportunity(Name = 'Name', SEG_Status__c ='Existing SEG', StageName = 'Open',Product_Type__c = 'Misc', CloseDate = system.today(),  Is_Converted__c = true,  Opportunity_Source__c = 'Word of mouth', AccountId = account_Obj.id,  Ownership__c = 'Auto Assign');
        insert op1;
        
        system.runAs(u){
        	SubmitForApprovalB2BController.saveOpportunity(op1.id,'Existing SEG');
            SubmitForApprovalB2BController.getProfileName(op1.id);
        }
        SubmitForApprovalB2BController.getProfileName(op1.id);
        test.stopTest();
        
    }
}