public class eSignatureContoller {
	@AuraEnabled
    public static Id saveSignature(String signatureBody, string wiresId){
       Attachment a = new Attachment();
        a.ParentId = wiresId; // record id of object.
        a.Body = EncodingUtil.base64Decode(signatureBody);
        a.ContentType = 'image/png';
        a.Name = 'Signature Capture.png';
        insert a;
        return a.Id;
    }
    
    @AuraEnabled   
    public static WIRES_Transaction__c getWireTransactionData(Id wiresId){
        WIRES_Transaction__c data= [SELECT Id,Name,WireAmount__c,Fees__c,FromAccount__c,TotalFromAccount__c,Share_ID__c,
                                    Member_Name__c,Member_Email__c,Member_Address__c,
                                    Member_City_State_Zip__c,Member_Home_Phone__c,
                                    ToAccoutId__r.Id,ToAccoutId__r.Name,ToAccoutId__r.Recipient_AccountNumber__c,
                                    ToAccoutId__r.BankName__c,ToAccoutId__r.RoutingNumber__c,
                                    ToAccoutId__r.Address1__c,ToAccoutId__r.City__c,ToAccoutId__r.State__c,
                                    ToAccoutId__r.Country__c,ToAccoutId__r.Zipcode__c 
                                    From WIRES_Transaction__c WHERE Id=:wiresId];
        return data;
    }
}