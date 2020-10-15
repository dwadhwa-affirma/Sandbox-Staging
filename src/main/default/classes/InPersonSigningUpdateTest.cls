@isTest
public class InPersonSigningUpdateTest {
    
    static testMethod void TestMethod1(){
        
        InPersonSigning__c ip = new InPersonSigning__c();
        ip.Recipient_AccountNumber__c = '1234';
        ip.IsLocked__c = true;
        insert ip;
        
        try{
            ip.Recipient_AccountNumber__c = '12';
        	update ip;
        }
        catch(Exception error){
        }
    }    
}