public class InPersonSigningContoller {
    @AuraEnabled
    public static void AssignWiresToInPersonSigning(Id wiresId){ 
        WIRES_Transaction__c wireDetail= [SELECT Id,Name,WireAmount__c,Fees__c,InPersonSigning__c,
                                          FromAccount__c,TotalFromAccount__c,Share_ID__c,
                                          Member_Name__c,Member_Email__c,Member_Address__c,
                                          Member_City_State_Zip__c,Member_Home_Phone__c,Description__c,
                                          ToAccoutId__r.Id,ToAccoutId__r.Name,ToAccoutId__r.Recipient_AccountNumber__c,
                                          ToAccoutId__r.BankName__c,ToAccoutId__r.RoutingNumber__c,
                                          ToAccoutId__r.Address1__c,ToAccoutId__r.City__c,ToAccoutId__r.State__c,
                                          ToAccoutId__r.Country__c,ToAccoutId__r.Zipcode__c,Brand__c
                                          From WIRES_Transaction__c WHERE Id=:wiresId];
        
        Id devRecordTypeId = Schema.SObjectType.InPersonSigning__c.getRecordTypeInfosByName().get('WIRES').getRecordTypeId();
        if(wireDetail!=null && wireDetail.InPersonSigning__c ==null){
            InPersonSigning__c inPersonSigning=new InPersonSigning__c();
            
            inPersonSigning.SalesforceID__c=wireDetail.Id;
            inPersonSigning.RecordTypeId=devRecordTypeId;
            inPersonSigning.Sender_AccountNumber__c=wireDetail.FromAccount__c;
            inPersonSigning.Sender_Address__c=wireDetail.Member_Address__c;
            inPersonSigning.Sender_Name__c=wireDetail.Member_Name__c;
            inPersonSigning.Sender_Email__c=wireDetail.Member_Email__c;
            inPersonSigning.Sender_Home_Phone__c=wireDetail.Member_Home_Phone__c;
            inPersonSigning.Sender_City_State_Zip__c=wireDetail.Member_City_State_Zip__c;
            
            inPersonSigning.Recipient_AccountNumber__c=wireDetail.ToAccoutId__r.Recipient_AccountNumber__c;
            inPersonSigning.Recipient_Address__c=wireDetail.ToAccoutId__r.Address1__c;
            inPersonSigning.Recipient_Bank__c=wireDetail.ToAccoutId__r.BankName__c;
            inPersonSigning.RecepientName__c=wireDetail.ToAccoutId__r.Name;
            inPersonSigning.RoutingNumber__c=wireDetail.ToAccoutId__r.RoutingNumber__c;
            
            inPersonSigning.Recipient_City__c=wireDetail.ToAccoutId__r.City__c;
            inPersonSigning.Recipient_State__c=wireDetail.ToAccoutId__r.State__c;
            inPersonSigning.Recipient_Zipcode__c=wireDetail.ToAccoutId__r.Zipcode__c;
            
            inPersonSigning.Share_ID__c=wireDetail.Share_ID__c;
            inPersonSigning.TotalAmount__c=wireDetail.TotalFromAccount__c;
            
            inPersonSigning.Description__c=wireDetail.Description__c;
            inPersonSigning.WireAmount__c=wireDetail.WireAmount__c;
            inPersonSigning.Fees__c=wireDetail.Fees__c;
            
            inPersonSigning.Brand__c=wireDetail.Brand__c;
            
            insert inPersonSigning;
            
            wireDetail.InPersonSigning__c =inPersonSigning.Id;
        	update wireDetail;
        }else{
            throw new AuraHandledException('Wires is already assigned for In person signing.');
        }
    }
    
    public void AssignWiresToInPersonSigningHandler(Id wiresId){ 
        WIRES_Transaction__c wireDetail= [SELECT Id,Name,WireAmount__c,Fees__c,InPersonSigning__c,
                                          FromAccount__c,TotalFromAccount__c,Share_ID__c,
                                          Member_Name__c,Member_Email__c,Member_Address__c,
                                          Member_City_State_Zip__c,Member_Home_Phone__c,Description__c,
                                          ToAccoutId__r.Id,ToAccoutId__r.Name,ToAccoutId__r.Recipient_AccountNumber__c,
                                          ToAccoutId__r.BankName__c,ToAccoutId__r.RoutingNumber__c,
                                          ToAccoutId__r.Address1__c,ToAccoutId__r.City__c,ToAccoutId__r.State__c,
                                          ToAccoutId__r.Country__c,ToAccoutId__r.Zipcode__c,Brand__c
                                          From WIRES_Transaction__c WHERE Id=:wiresId];
        
        Id devRecordTypeId = Schema.SObjectType.InPersonSigning__c.getRecordTypeInfosByName().get('WIRES').getRecordTypeId();
        if(wireDetail!=null && wireDetail.InPersonSigning__c ==null){
            InPersonSigning__c inPersonSigning=new InPersonSigning__c();
            
            inPersonSigning.SalesforceID__c=wireDetail.Id;
            inPersonSigning.RecordTypeId=devRecordTypeId;
            inPersonSigning.Sender_AccountNumber__c=wireDetail.FromAccount__c;
            inPersonSigning.Sender_Address__c=wireDetail.Member_Address__c;
            inPersonSigning.Sender_Name__c=wireDetail.Member_Name__c;
            inPersonSigning.Sender_Email__c=wireDetail.Member_Email__c;
            inPersonSigning.Sender_Home_Phone__c=wireDetail.Member_Home_Phone__c;
            inPersonSigning.Sender_City_State_Zip__c=wireDetail.Member_City_State_Zip__c;
            
            inPersonSigning.Recipient_AccountNumber__c=wireDetail.ToAccoutId__r.Recipient_AccountNumber__c;
            inPersonSigning.Recipient_Address__c=wireDetail.ToAccoutId__r.Address1__c;
            inPersonSigning.Recipient_Bank__c=wireDetail.ToAccoutId__r.BankName__c;
            inPersonSigning.RecepientName__c=wireDetail.ToAccoutId__r.Name;
            inPersonSigning.RoutingNumber__c=wireDetail.ToAccoutId__r.RoutingNumber__c;
            
            inPersonSigning.Recipient_City__c=wireDetail.ToAccoutId__r.City__c;
            inPersonSigning.Recipient_State__c=wireDetail.ToAccoutId__r.State__c;
            inPersonSigning.Recipient_Zipcode__c=wireDetail.ToAccoutId__r.Zipcode__c;
            
            inPersonSigning.Share_ID__c=wireDetail.Share_ID__c;
            inPersonSigning.TotalAmount__c=wireDetail.TotalFromAccount__c;
            
            inPersonSigning.Description__c=wireDetail.Description__c;
            
            inPersonSigning.WireAmount__c=wireDetail.WireAmount__c;
            inPersonSigning.Fees__c=wireDetail.Fees__c;
            
            inPersonSigning.Brand__c=wireDetail.Brand__c;
            
            insert inPersonSigning;
            
            wireDetail.InPersonSigning__c =inPersonSigning.Id;
        	update wireDetail;
        }else{
            throw new AuraHandledException('Wires is already assigned for In person signing.');
        }
    }
}