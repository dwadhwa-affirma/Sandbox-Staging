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
        
       Group g1 = new Group(Name='Branch 14 - 1600 Smith Queue', type='Queue');
            insert g1;
        
      /*  Lead_Queue__c lq = new Lead_Queue__c();
        lq.Episys_User_Branch_Name__c = '14 1600 Smith';
        lq.Lead_Queue_Name__c = 'Branch 14 - 1600 Smith Queue';
        insert lq;*/
        
         Episys_User__c eu = new Episys_User__c();
             eu.Episys_ID__c = 1;
             eu.Episys_Name__c = 'test';
             eu.Assigned_Branch__c =14;
        insert eu;
            
            
              Lead newlead = new Lead(LastName = 'LastName268', Status = 'New', HasOptedOutOfEmail = false, IsConverted = false, IsUnreadByOwner = false, 
                       smagicinteract__SMSOptOut__c = false, Escalated__c = false, Membership_Required_old__c = false, Keep__c = false, et4ae5__HasOptedOutOfMobile__c = false, Episys_Flag__c = false,
                                temp__c = false, Episys_User_ID__c= 1,LeadSource = 'Other', Product_Type__c ='Cards');
             insert newlead;
        
          newlead.Brand__c = 'Spectrum';
        update newlead;
      
    }
    
}