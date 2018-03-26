@isTest
public class LeadTrigger2Test {
    static testMethod void testMethod1(){
        RecordType recTpe = [Select Id, Name from RecordType where Name='Brand Details' Limit 1];
        
        Mapping__c mapg = new Mapping__c();
          mapg.RecordTypeId = recTpe.Id;
          mapg.Object_Name__c = 'Lead';
          mapg.Brand_Code__c = 'BC01';
          mapg.Brand_Abbreviation__c = 'CFCU';
          mapg.Credit_Union_Name__c = 'Chevron Federal';
          mapg.Image_URL__c = 'xyz';
          mapg.Support_Contact_Details__c = 'test details';       
        insert mapg;
        
        Lead ld = new Lead();
          ld.Brand__c = 'CFCU';
          ld.LastName = 'TestName';
          ld.Episys_Flag__c = FALSE;
        insert ld;
        
          ld.Brand__c = 'Spectrum';
        update ld;
      
    }
    
}