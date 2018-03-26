trigger EmailNotification on Member_Comment__c (after insert) {

    //Member_Comment__c member = [select id,Case_Creator_Email__c,Communication_Origin__c,Case_Origin__c,Case__r.BrandfromAccount__c,Case__r.Origin,Category__c from Member_Comment__c where id =: trigger.newMap.keySet()];
    List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
    
    if(Trigger.isInsert && Trigger.isAfter){
        for(Member_Comment__c mc : Trigger.New){
            if(mc.Case_Creator_Email__c != null){
                String userEmail = mc.Case_Creator_Email__c;
                EmailTemplate et;
                Messaging.SingleEmailMessage singleMail = new Messaging.SingleEmailMessage();
                string subvalue = 'Account Maintenance / Wires / Foreign - New';
                if(mc.Communication_Origin__c == 'CU' && mc.Case__r.BrandfromAccount__c == 'specturm' && mc.Case__r.Origin == 'portal'){
                    et = [Select id from EmailTemplate where name=:'Secure Portal - Notification - Spectrum' limit 1];
                }
                else if(mc.Communication_Origin__c == 'CU' && mc.Case__r.BrandfromAccount__c == 'chevron' && mc.Case__r.Origin == 'portal'){
                    et = [Select id from EmailTemplate where name=:'Secure Portal - Notification - CFCU' limit 1];
                } 
                else if(mc.Case_Origin__c == 'CU' && mc.Case__r.BrandfromAccount__c == 'chevron' && mc.Case__r.Origin == 'portal' && mc.Category__c.contains(subvalue)){
                    et = [Select id from EmailTemplate where name=:'Secure Portal - Notification Wires - CFCU' limit 1];
                }
                else if(mc.Communication_Origin__c == 'CU' && mc.Case__r.BrandfromAccount__c == 'chevron' && mc.Case__r.Origin != 'portal'){
                    et = [Select id from EmailTemplate where name=:'Secure Portal - Notification CU Case - CFCU' limit 1];
                }
                else if(mc.Communication_Origin__c == 'CU' && mc.Case__r.BrandfromAccount__c == 'specturm' && mc.Case__r.Origin != 'portal' && mc.Category__c.contains(subvalue)){
                    et = [Select id from EmailTemplate where name=:'Secure Portal - Notification Wires - Spectrum' limit 1];
                }   
                else if(mc.Communication_Origin__c == 'CU' && mc.Case__r.BrandfromAccount__c == 'specturm' && mc.Case__r.Origin != 'portal'){
                    et = [Select id from EmailTemplate where name=:'Secure Portal - Notification CU Case - Spectrum' limit 1];
                }

                String[] toAddresses = new String[] {userEmail};
                singleMail.setToAddresses(toAddresses);
                singleMail.setTemplateId(et.Id);               
                //singleMail.setTargetObjectId(mc.Id);
                singleMail.setSaveAsActivity(false);
                mails.add(singleMail);  
        
            }            
        }
        Messaging.sendEmail(mails);
    }
}