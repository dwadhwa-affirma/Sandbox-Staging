@isTest
public class LevyTriggerTest {
    
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
        
        
        Episys_User__c eu = new Episys_User__c();
        eu.Episys_ID__c = 1;
        eu.Episys_Name__c = 'test';
        eu.Assigned_Branch__c =14;
        insert eu;
        
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;
		Account_Details__c testAccountDetails = new Account_Details__c(Name = 'Test Account Detail');
        insert testAccountDetails;

        Levy__c newlevy = new Levy__c();
		newlevy.Member__c =testAccount.id ;
		newlevy.Member_Account__c = testAccountDetails.id; 
		newlevy.Debtor_SSN__c = 'LastName268';
		newlevy.Status__c = 'Open'; 
		newlevy.Other__c = 'false'; 
		newlevy.Amount_of_Hold__c = 35; 
		newlevy.Protected_amount__c = 56;                                       
		newlevy.Brand_is_Chevron__c = true;
		newlevy.Comment__c = 'Test'; 
		newlevy.Fee__c = 234; 	
		newlevy.Name = 'Test'; 
		newlevy.SLA__c = 43;
        insert newlevy;
        update newlevy;
        
    }
}