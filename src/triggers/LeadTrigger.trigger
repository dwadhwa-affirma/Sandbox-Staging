trigger LeadTrigger on Lead (before insert, before update) {

    List<Lead> leadsToUpdate;

    if (Trigger.isBefore) {
        if (Trigger.isInsert) {
            updateLeadBrandInfo(Trigger.new);
            updateleadOwner(Trigger.new);
            //updateleadCreator(Trigger.new);
        }

        if (Trigger.isUpdate) {
            updateLeadBrandInfo(Trigger.new);
            updateleadOwner(Trigger.new);
            //updateleadCreator(Trigger.new);
        }
    }


    // Method to update the Creator's Epysis ID of the Lead records
    //public void updateleadCreator(List<Lead> newLeads) {
    
    //    Map<String, Decimal> episysMap = new Map<String, Decimal>();
    //    Set<Double> episysSet = new Set<Double>();
    //    List<Episys_User__c> episysUsr = [Select Alias__c, Episys_ID__c from Episys_User__c];
    
     //   for(Episys_User__c eu : episysUsr ){
     //       episysMap.put(eu.Alias__c, eu.Episys_ID__c); 
            //episysSet.add(eu.Episys_ID__c);
     //   }
     //   for(Lead lead: Trigger.new){
     //        if (Trigger.isUpdate) {
     //            Lead oldLead = Trigger.oldMap.get(lead.Id);
     //            Lead.Episys_User_ID__c = episysMap.get(oldLead.Episys_User__c);
     //            System.Debug('>>>> the alias of created by is ' + oldLead.Episys_User__c);
     //            System.Debug('>>>> the map value for jfra is ' + episysMap.get(oldLead.Episys_User__c));
     //        } else if (Trigger.isInsert) {
     //            Lead.Episys_User_ID__c = episysMap.get(oldLead.Episys_User__c);
     //        }
     //   }
    //}
    

    // Method to update the owner of the Lead records
    public void updateleadOwner(List<Lead> newLeads) {

        for (Lead lead : newLeads) {
            if (lead.Mortgage_Loan_Officer__c != null) {    
                if (Trigger.isUpdate) {
                    Lead oldLead = Trigger.oldMap.get(lead.Id);
                    System.debug('oldLead.Mortgage_Loan_Officer__c is :'+oldLead.Mortgage_Loan_Officer__c);
                    if (oldLead.Mortgage_Loan_Officer__c != lead.Mortgage_Loan_Officer__c) {
                        lead.OwnerId = lead.Mortgage_Loan_Officer__c;
                    }
                } else if (Trigger.isInsert) {
                    lead.OwnerId = lead.Mortgage_Loan_Officer__c;
                }   
            }
        }
    }

    public void updateLeadBrandInfo(List<Lead> newLeadList) {

        Set<String> brandCodeSet = new Set<String>();
        Set<String> brandTextSet = new Set<String>();
        Map<String,Mapping__c> brandTextNBrandDetailMap = new Map<String,Mapping__c>();
        List<Lead> leadsToBeUpdated = new List<Lead>();

        try {

            // Iterating through the incoming cases to create a Set of Account_Details__c IDs
            for (Lead newLead : newLeadList) {

                if (newLead.Brand__c == NULL) {
                    newLead.Brand__c.addError('Please select a value!');
                } else if (newLead.Brand__c != NULL) {
                    if(Trigger.isInsert) {
                        brandTextSet.add(newLead.Brand__c);
                        leadsToBeUpdated.add(newLead);
                    } else {
                        Lead oldLead = Trigger.oldMap.get(newLead.Id);
                        if (oldLead.Brand__c != newLead.Brand__c) {
                            brandTextSet.add(newLead.Brand__c);
                            leadsToBeUpdated.add(newLead);
                        }
                    }
                }
            }

            System.debug('brandTextSet is :'+brandTextSet);

            if (brandTextSet.size() > 0) {
                for (Mapping__c mapping : [SELECT Id, Brand_Code__c, Brand_Abbreviation__c, Credit_Union_Name__c, Image_URL__c, Object_Name__c, Support_Contact_Details__c FROM Mapping__c WHERE RecordType.name = 'Brand Details' AND Object_Name__c = 'Lead' AND Brand_Abbreviation__c IN :brandTextSet]) {
                    for (String bt : brandTextSet) {
                        if (String.valueOf(bt) == String.valueOf(mapping.Brand_Abbreviation__c)) {
                            brandTextNBrandDetailMap.put(bt,mapping);
                        }
                    }
                }
            }

            System.debug('brandTextNBrandDetailMap is :'+brandTextNBrandDetailMap);

            // Iterating through the incoming cases again, This time grabbing the mapping record from the 
            // Map<AccountDetailsID,Mapping__c> based on the Account_DetailsID and updating the case Object
            for (Lead newLead : leadsToBeUpdated) {
                if (newLead.Brand__c != NULL) {
                    Mapping__c brandMapping = brandTextNBrandDetailMap.get(newLead.Brand__c);
                    if (brandMapping != NULL) {
                        newLead.Brand_Code__c = brandMapping.Brand_Code__c;
                        newLead.Brand_Abbreviation__c = brandMapping.Brand_Abbreviation__c;
                        newLead.Credit_Union_Name__c = brandMapping.Credit_Union_Name__c;
                        newLead.Image_URL__c = brandMapping.Image_URL__c;
                        newLead.Support_Contact_Details__c = brandMapping.Support_Contact_Details__c;
                    }
                }   
            }

        if(Test.isRunningTest()){
               Integer x=1/0;}
        } catch (Exception e) {
            System.debug('An error was encountered in the updateLeadBrandInfo method defined in the CaseTrigger :'+e);
        }

    }

}