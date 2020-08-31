@isTest
public class CloseOppurtunityNoteTest {

	static testMethod void CloseOppurtunityNoteTest1(){
		test.StartTest();
		Account account_Obj = new Account(PersonHomePhone='', PersonHasOptedOutOfEmail = false, Name = 'MARIA BANDA');
		Insert account_Obj; 
	   
        Opportunity op1 = new Opportunity(Name = 'Name', StageName = 'Closed Won', CloseDate = system.today(),  Is_Converted__c = true, Opportunity_Source__c = 'Word of mouth', AccountId = account_Obj.id,  Ownership__c = 'Auto Assign', Episys_User_ID__c = 1);
        insert op1;
        Boolean result=false;
        
        Opportunity op = new Opportunity(Name = 'Name', StageName = 'New', CloseDate = system.today(),  Is_Converted__c = true, Opportunity_Source__c = 'Word of mouth', AccountId = account_Obj.id,  Ownership__c = 'Auto Assign', Episys_User_ID__c = 1);
        insert op;
        
        Note oNote = new Note();
        oNote.Title ='my opp note';
        oNote.Body = 'test note body';
        oNote.ParentId = op.id ;
        insert oNote;
        
        op.StageName = 'Closed Won';
        update op;
        
        try{
            Note oNote1 = new Note();
            oNote1.Title ='my opp note';
            oNote1.Body = 'test note body';
            oNote1.ParentId = op1.id ;// opportyniy id 
            Database.insert(oNote1);
        }
        catch(DMLException de){
          
            System.assert(de.getMessage().contains('Add new note not allowed for closed Opportunity'));
           
        }

        try{
            oNote.Title = 'Test';
            Database.Update(oNote);
        }
        catch(DMLException de){
          
        }
        op.StageName = 'New';
        update op;
        delete oNote;
		test.StopTest();		
	}		
}