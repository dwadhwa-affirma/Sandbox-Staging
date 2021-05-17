public class MarketingLeadCheck {

@future(callout=true)
    public static void LeadCheck(Id leadid){
	
        Set<string> email_set = new Set<String>();  
    	Set<string> phone_set = new Set<String>();
        List<Opportunity> oppToCreate = new List<Opportunity>();
        List<Lead> leadToUpdate = new List<Lead>();
        List<Lead> leadToDelete = new List<Lead>();
        
        List<Account> lstacc_email = new List<Account>();
        List<Account> lstacc_phone = new List<Account>();
        String groupName ;  
        Id groupnameid;
        List<Group> listQueue = [select id,Name,Email from Group where Type = 'Queue' and (Email like '%lead.com' or Email like '%opportunity.com')];
        
		List<Lead> LeadList = new List<Lead>();
		List<Lead> leads = [SELECT Address,Best_Time_To_Call__c,Branch_of_Lead_creator__c,Brand_Abbreviation__c,Brand_Code__c,Brand_Text__c,Brand__c,City,City__c,Company,ConvertedAccountId,ConvertedContactId,ConvertedDate,ConvertedOpportunityId,Country,CountryCode,Country__c,CreatedById,CreatedDate,Credit_Union_Name__c,Description,Description__c,Email,EmailBouncedDate,EmailBouncedReason,Episys_Flag__c,Episys_User_ID__c,Episys_User__c,Escalated__c,Estimate_Value__c,et4ae5__HasOptedOutOfMobile__c,et4ae5__Mobile_Country_Code__c,Event_Create_Date__c,Event_Source__c,FirstName,Future_Date__c,GeocodeAccuracy,HasOptedOutOfEmail,Helpdesk_Number__c,Home_Phone__c,How_did_you_hear_about_us__c,Id,Image_URL__c,IndividualId,Industry,IsConverted,IsDeleted,IsUnreadByOwner,I_m_interested_in__c,JigsawContactId,Keep__c,LastActivityDate,LastModifiedById,LastModifiedDate,LastName,LastReferencedDate,LastViewedDate,Latitude,LeadSource,lead_number_link__c,Lead_Number__c,Lead_Type__c,Loan_Amount__c,Longitude,MasterRecordId,Membership_Required_old__c,Membership_Required__c,Member_Account__c,Member_Branch__c,MiddleName,MobilePhone,Mortgage_Loan_Officer__c,Name,NumberOfEmployees,Other_Phone__c,Over_30_days__c,OwnerId,OwnerInfo1__c,OwnerInfo__c,Ownership__c,Person__c,Phone,PhotoUrl,PostalCode,Product_Subtype__c,Product_Type__c,Property_Address__c,Property_City__c,Property_State__c,Property_Zip__c,RecordTypeId,Salutation,smagicinteract__CurrentGenerators__c,smagicinteract__NumberofLocations__c,smagicinteract__Primary__c,smagicinteract__ProductInterest__c,smagicinteract__SICCode__c,smagicinteract__SMSOptOut__c,smagicinteract__TestDate__c,Source__c,Spectrum__c,State,StateCode,State__c,Status,Status1__c,Street,Street_Address_1__c,Street_Address_2__c,SubmitterIP__c,Sub_Status__c,Suffix,Support_Contact_Details__c,SystemModstamp,temp__c,Timeframe__c,Title,UID__c,UnbouncePageID__c,UnbouncePageVariant__c,UnbounceSubmissionDate__c,UnbounceSubmissionTime__c,Value__c,Zip_Code__c FROM Lead where id=:leadid];
		
        for(Lead lead : leads){
            
            if(lead.LeadSource == 'Real Estate help desk' && lead.I_m_interested_in__c == 'Home Loan Help Desk'){
            	
                String leadphone = lead.Home_Phone__c;
                String leadphone1;
                String leadphone2;
                String leadphone3;
                String leademail = lead.Email;
                
                system.debug('leadphone'+leadphone);
                
                if(leadphone.containsAny('() -')){
                    leadphone = leadphone.remove('(');
                    leadphone = leadphone.remove(')');
                    leadphone = leadphone.remove(' ');
                    leadphone = leadphone.remove('-');
                }
                if(leadphone.Length()>=3){
                    leadphone1 = leadphone.substring(0,3);
                }
                else{
                    leadphone1 = '';
                }
                if(leadphone.Length()>=6){
                    leadphone2 = leadphone.substring(3,6);
                }
                else{
                    leadphone2 = '';
                }
                if(leadphone.Length()>=10){
                    leadphone3 = leadphone.substring(6,10);
                }
                else{
                    leadphone3 = '';
                }
                leadphone = leadphone1+'-'+leadphone2+'-'+leadphone3;
        		system.debug('leadphone....'+leadphone);
                
                if(lead.Email != null){
                    system.debug('email'+lead.Email);
                	lstacc_email = [Select id from Account where Alt_Email_Raw__c =:leademail OR Email_raw__c =: leademail OR Alternate_Email__pc =:leademail];
            	}
            	if(leadphone != null){
                	lstacc_phone = [Select id from Account where (Phone =:leadphone OR Mobile_Phone__pc =:leadphone OR Home_Phone__pc =:leadphone) and recordtype.name = 'Person Account'];
            	}
            }
            system.debug('lstacc_email'+lstacc_email);
            system.debug('lstacc_phone'+lstacc_phone);
            
            if(lstacc_email.size() > 0 || lstacc_phone.size() > 0){
                Opportunity opp = new Opportunity();
                opp.Name = 'test';
                
                if(lstacc_email.size() > 0)
                	opp.AccountId = lstacc_email[0].id;
                if(lstacc_phone.size() > 0)
                	opp.AccountId = lstacc_phone[0].id;
                
                opp.CloseDate = Date.today();
                opp.Product_Type__c ='Mortgage';
                opp.Product_Sub__c = 'Xpress Refi';
                opp.StageName ='New';
                opp.Opportunity_Source__c ='Xpress Form - Web';
                opp.I_m_interested_in__c = 'Xpress Form - Web';
                
                for(Group grp : listQueue){
                    if(grp.name.containsIgnoreCase('Real Estate')){
                        groupName = grp.Name;
                        groupnameid = grp.id;
                        break;
                    }
                }
                
                if(groupName!=null && groupName!=''){
                    system.debug('Queue Name: '+groupName); 
                    opp.Queue_Owner__c = groupName;
                    opp.User_Owner__c = null;
                }
                
                Lead l = new Lead();
                l.id = lead.id;
                leadToDelete.add(l);
                
                opp.I_m_interested_in__c = lead.Description;
                oppToCreate.add(opp);
                System.debug('oppToCreate'+oppToCreate);
            }
            else{
                
                for(Group grp : listQueue){
                    if(grp.name.containsIgnoreCase('Real Estate')){
                        groupName = grp.Name;
                        groupnameid = grp.id;
                        break;
                    }
                }
                if(groupName!=null && groupName!=''){
                    system.debug('Queue Name: '+groupName); 
                    Lead l = new Lead();
                    l.id = lead.id;
                    l.Product_Subtype__c = 'Xpress Refi';
                    l.OwnerId = groupnameid;
                    leadToUpdate.add(l);
                }
            }
                
            
        }
        
        if(oppToCreate.size() > 0){
        	insert oppToCreate;
    	}
        if(leadToUpdate.size() > 0){
        	update leadToUpdate;
    	}
        if(leadToDelete.size() > 0){
        	delete leadToDelete;
    	}
        
	}

}