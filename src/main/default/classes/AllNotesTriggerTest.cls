@isTest
public class AllNotesTriggerTest {

    static testMethod void testMethod1(){
        
        Episys_User__c eu = new Episys_User__c();
             eu.Episys_ID__c = 1;
             eu.Episys_Name__c = 'test';
        insert eu;
        
        AllNotes__c nts = new AllNotes__c();
             nts.NoteID__c = 'test1';
             nts.Created_By_User__c = 1;
        insert nts;
        
        nts.Created_By_User_Text__c = 'test';
        update nts;             
    }
}