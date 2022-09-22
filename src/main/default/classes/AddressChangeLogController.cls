public without sharing class AddressChangeLogController{
    @AuraEnabled
    public static List<InPersonSigning__c> getInPersonSigningDetails(Id inPersonSigningId){
        return [SELECT Id, Name, SalesforceID__c, RecordTypeId, Clean_Up_Intake_Method__c, Identification_Method__c, Brand__c, AC_Residential_Address_Line1__c, AC_Residential_Address_Line2__c, AC_Residential_City__c, AC_Residential_State__c, AC_Residential_Zip__c, AC_Residential_Country__c, AC_Residential_Country_Code__c, AC_Home_Phone__c, AC_Work_Phone__c, AC_Mobile_Phone__c, AC_Work_Extension__c, AC_Email__c, AC_Mailing_Address_Line1__c, AC_Mailing_Address_Line2__c, AC_Mailing_Address_City__c, AC_Mailing_Address_State__c, AC_Mailing_Address_Zip__c, AC_Mailing_Address_Country__c, AC_Mailing_Address_Country_Code__c, AC_Telephone_Type__c, AC_Member_Email__c, AC_Member_Account__c, AC_AccountNamePair__c, AC_Expires_On__c, AC_Mailing_Address_Type__c
                FROM InPersonSigning__c
                WHERE Id = :inPersonSigningId];
    }

    @AuraEnabled
    public static InPersonSigning__c getInPersonSigningData(Id recordId){
        InPersonSigning__c data = [SELECT Id, Name, SalesforceID__c, AC_Member__c, AC_Member__r.Name, RecordTypeId, Clean_Up_Intake_Method__c, Identification_Method__c, Brand__c, AC_Residential_Address_Line1__c, AC_Residential_Address_Line2__c, AC_Residential_City__c, AC_Residential_State__c, AC_Residential_Zip__c, AC_Residential_Country__c, AC_Residential_Country_Code__c, AC_Home_Phone__c, AC_Work_Phone__c, AC_Mobile_Phone__c, AC_Work_Extension__c, AC_Email__c, AC_Mailing_Address_Line1__c, AC_Mailing_Address_Line2__c, AC_Mailing_Address_City__c, AC_Mailing_Address_State__c, AC_Mailing_Address_Zip__c, AC_Mailing_Address_Country__c, AC_Mailing_Address_Country_Code__c, AC_Telephone_Type__c, AC_Member_Email__c, AC_Member_Account__c,AC_Member_Account__r.Name, AC_AccountNamePair__c, AC_Expires_On__c, AC_Mailing_Address_Type__c, AC_Address_Type__c FROM InPersonSigning__c WHERE Id =: recordId];
       
        return data;
    }

    @AuraEnabled
    public static void linkInPersonSigningToAddressChangeLog(Id addressChangeLogId){

        AddressChangeLog__c addressChangeDetails = [Select Names__c, AccountNumbersString__c, Email__c, Email_New__c, AlternateEmail_New__c, Address_New__c, Address2_New__c, City_New__c, State_New__c, Zip4_New__c, Zip_New__c, Country_New__c, CountryCode_New__c, HomePhone_New__c, MobilePhone__c, MobilePhone_New__c, WorkPhone_New__c, WorkExtension_New__c, Brand__c, Identification_Method__c, InPersonSigning__c, Telephone_Type__c, Pager_No__c, ExpirationDate_New__c, Address_Type__c, Clean_Up_Intake_Method__c, Update_Type__c, CaseId__c, AccountNamePair__c, Member__c,Member__r.Name, CaseId__r.Account_Number__c, CaseId__r.Account_Number__r.Name, CaseId__r.Account_Number__r.Brand__c
                                                    from AddressChangeLog__c
                                                    WHERE Id = :addressChangeLogId];


        if (addressChangeDetails != null && addressChangeDetails.InPersonSigning__c == null){
            InPersonSigning__c inPersonSigningRecord = insertInPersonSigningRecord(addressChangeDetails);
            addressChangeDetails.InPersonSigning__c = inPersonSigningRecord.Id;
            update addressChangeDetails;
        } else{
            throw new AuraHandledException('Branch is already assigned for In person signing.');
        }
    }

    public static InPersonSigning__c insertInPersonSigningRecord(AddressChangeLog__c addressChangeDetails){
        Id addressChangeRecordTypeId = Schema.SObjectType.InPersonSigning__c.getRecordTypeInfosByName().get('AddressChange').getRecordTypeId();
        InPersonSigning__c inPersonSigning = new InPersonSigning__c();
        inPersonSigning.SalesforceID__c = addressChangeDetails.Id;
        inPersonSigning.Identification_Method__c = addressChangeDetails.Identification_Method__c;
        inPersonSigning.Clean_Up_Intake_Method__c = addressChangeDetails.Clean_Up_Intake_Method__c;
        inPersonSigning.RecordTypeId = addressChangeRecordTypeId;
        if (addressChangeDetails.Brand__c != null){
            inPersonSigning.Brand__c = addressChangeDetails.Brand__c;
        }
        else{
            inPersonSigning.Brand__c = addressChangeDetails.CaseId__r.Account_Number__r.Brand__c;
        }
        if (addressChangeDetails.CaseId__c != null){
            inPersonSigning.AC_Case__c = addressChangeDetails.CaseId__c;
        }
        if (!String.isEmpty(addressChangeDetails.AccountNamePair__c)){
            String[] arrNames = addressChangeDetails.AccountNamePair__c.split(',');
            string AccNamePair = '';
            for(String nameItem : arrNames) {
                List<String> arryNameItem=nameItem.trim().split('\\|');
                if(arryNameItem.size() > = 2){
                    string AccountNumber = arryNameItem[0];
                    string Name = arryNameItem[1];

                    if(Name == addressChangeDetails.Member__r.Name && AccountNumber == addressChangeDetails.CaseId__r.Account_Number__r.Name){

                    }
                    else{
                        if(AccNamePair == ''){
                            AccNamePair = AccountNumber + ' - ' + Name;
                        }
                        else{
                            AccNamePair = AccNamePair + ', ' +  AccountNumber + ' - ' + Name;
                        }
                        
                    }
                }
            }
            inPersonSigning.AC_AccountNamePair__c = AccNamePair;
        }
        if (addressChangeDetails.Member__c != null){
            inPersonSigning.AC_Member__c = addressChangeDetails.Member__c;
        }
        if (addressChangeDetails.CaseId__r.Account_Number__c != null){
            inPersonSigning.AC_Member_Account__c = addressChangeDetails.CaseId__r.Account_Number__c;
        }
        if (addressChangeDetails.Email__c != null){
            inPersonSigning.AC_Member_Email__c = addressChangeDetails.Email__c;
        }

        if (addressChangeDetails.Update_Type__c == 'Contact Info'){
            if (addressChangeDetails.HomePhone_New__c != null){
                InPersonSigning.AC_Home_Phone__c = addressChangeDetails.HomePhone_New__c;
            }
            if (addressChangeDetails.MobilePhone_New__c != null){
                InPersonSigning.AC_Mobile_Phone__c = addressChangeDetails.MobilePhone_New__c;
            }
            if (addressChangeDetails.WorkPhone_New__c != null){
                InPersonSigning.AC_Work_Phone__c = addressChangeDetails.WorkPhone_New__c;
            }
            if (addressChangeDetails.WorkExtension_New__c != null){
                InPersonSigning.AC_Work_Extension__c = addressChangeDetails.WorkExtension_New__c;
            }
            if (addressChangeDetails.Email_New__c != null){
                InPersonSigning.AC_Email__c = addressChangeDetails.Email_New__c;
            }
            if (addressChangeDetails.Telephone_Type__c != null){
                InPersonSigning.AC_Telephone_Type__c = addressChangeDetails.Telephone_Type__c;
            }
        } else if (addressChangeDetails.Update_Type__c == 'Residential Address'){
            if (addressChangeDetails.Address_New__c != null){
                InPersonSigning.AC_Residential_Address_Line1__c = addressChangeDetails.Address_New__c;
            }
            if (addressChangeDetails.Address2_New__c != null){
                InPersonSigning.AC_Residential_Address_Line2__c = addressChangeDetails.Address2_New__c;
            }
            if (addressChangeDetails.City_New__c != null){
                InPersonSigning.AC_Residential_City__c = addressChangeDetails.City_New__c;
            }
            if (addressChangeDetails.State_New__c != null){
                InPersonSigning.AC_Residential_State__c = addressChangeDetails.State_New__c;
            }
            if (addressChangeDetails.Zip_New__c != null){
                InPersonSigning.AC_Residential_Zip__c = addressChangeDetails.Zip_New__c;
            }
            if (addressChangeDetails.Country_New__c != null){
                InPersonSigning.AC_Residential_Country__c = addressChangeDetails.Country_New__c;
            }
            if (addressChangeDetails.CountryCode_New__c != null){
                InPersonSigning.AC_Residential_Country_Code__c = addressChangeDetails.CountryCode_New__c;
            }
            if (addressChangeDetails.Address_Type__c != null){
                InPersonSigning.AC_Address_Type__c = addressChangeDetails.Address_Type__c;
            }
        } else if (addressChangeDetails.Update_Type__c == 'Temp Mailing Address - New'){
            if (addressChangeDetails.Address_New__c != null){
                InPersonSigning.AC_Mailing_Address_Line1__c = addressChangeDetails.Address_New__c;
            }
            if (addressChangeDetails.Address2_New__c != null){
                InPersonSigning.AC_Mailing_Address_Line2__c = addressChangeDetails.Address2_New__c;
            }
            if (addressChangeDetails.City_New__c != null){
                InPersonSigning.AC_Mailing_Address_City__c = addressChangeDetails.City_New__c;
            }
            if (addressChangeDetails.State_New__c != null){
                InPersonSigning.AC_Mailing_Address_State__c = addressChangeDetails.State_New__c;
            }
            if (addressChangeDetails.Zip_New__c != null){
                InPersonSigning.AC_Mailing_Address_Zip__c = addressChangeDetails.Zip_New__c;
            }
            if (addressChangeDetails.Country_New__c != null){
                InPersonSigning.AC_Mailing_Address_Country__c = addressChangeDetails.Country_New__c;
            }
            if (addressChangeDetails.CountryCode_New__c != null){
                InPersonSigning.AC_Mailing_Address_Country_Code__c = addressChangeDetails.CountryCode_New__c;
            }
            if (addressChangeDetails.Address_Type__c != null){
                InPersonSigning.AC_Mailing_Address_Type__c = addressChangeDetails.Address_Type__c;
            }
            if (addressChangeDetails.ExpirationDate_New__c != null){
                InPersonSigning.AC_Expires_On__c = addressChangeDetails.ExpirationDate_New__c;
            }
        }

        insert inPersonSigning;
        return inPersonSigning;
    }

    @AuraEnabled
    public static Id saveSignature(String signatureBody, string recordId){
        system.debug('recordId'+recordId);
        Attachment a = new Attachment();
        a.ParentId = recordId; // record id of object.
        a.Body = EncodingUtil.base64Decode(signatureBody);
        a.ContentType = 'image/png';
        a.Name = 'ESignature.png';
        insert a;
        return a.Id;
    }

    @AuraEnabled
    public static List<String> getIntakeMethodPickListValues(){
        List<String> str_intake = new List<String>();        

        Schema.DescribeFieldResult fieldResult_intake = InPersonSigning__c.Clean_Up_Intake_Method__c.getDescribe();
        List<Schema.PicklistEntry> ple_intake = fieldResult_intake.getPicklistValues();

        for (Schema.PicklistEntry pickListVal : ple_intake){            
            str_intake.add(pickListVal.getValue());
        }
        return str_intake;
    }

    @AuraEnabled
    public static List<String> getIdentificationMethodPickListValues(){
        List<String> str_id = new List<String>();       

        Schema.DescribeFieldResult fieldResult_id = InPersonSigning__c.Identification_Method__c.getDescribe();
        List<Schema.PicklistEntry> ple_id = fieldResult_id.getPicklistValues();

        for (Schema.PicklistEntry pickListVal : ple_id ){            
            str_id.add(pickListVal.getValue());
        }
        return str_id;
    }
}