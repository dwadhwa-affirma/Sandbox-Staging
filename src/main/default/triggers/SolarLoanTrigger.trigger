trigger SolarLoanTrigger on Solar_Loans__c (after insert,before insert, after update, before update) {
    
    Set<Id> SLIds = new Set<Id>();
    Set<Id> SLIdsToCreateLoan = new Set<Id>();
    Set<Id> UpdateStatus = new Set<Id>();
    Set<Id> SLIdsForEFT = new Set<Id>();
    Set<Id> SLIdsForEFTUpdate = new Set<Id>();
    
    Set<Id> SLIdsForRouting = new Set<Id>();
    Map<Id, Solar_Loans__c> SLForBranchIds = new Map<Id, Solar_Loans__c>();
    
    List<Solar_Loans__c> SLToUpdatesForRouting = new List<Solar_Loans__c>();
    Set<String> SLMemberNumber = new Set<String>();
    Set<String> SLMemberNumberForName = new Set<String>();
    
    List<Solar_Loans__c> SLForMemberName = new List<Solar_Loans__c>();
    Set<String> SLMemberFirstName = new Set<String>();
    Set<String> SLMemberLastName = new Set<String>();
    
    Map<Id,Solar_Loans__c> SolarLoanMap =new Map<Id,Solar_Loans__c>();
    Map<Id,Solar_Loans__c> SLToUpdates = new Map<Id,Solar_Loans__c>();
    String String1;
    String String2;
    
    //------------------------------------------------Before Insert ----------------------------------------------//
    
    if(Trigger.isInsert && Trigger.isBefore){
      List<Group> queList = [Select id, Name from Group where name = 'Solar Loans Queue' limit 1];
      for(Integer i=0; i<trigger.new.size(); i++){
        // code change for US: STRY0012031 begin
        if(trigger.new[i].Credit_Exception__c != null && trigger.new[i].Credit_Exception__c.length() >40  ){                        
            Trigger.new[i].addError('Credit Exception can\'t be greater than 40 character');
        }
        if(trigger.new[i].Installer__c != null && trigger.new[i].Installer__c.length() >40 ){                        
            Trigger.new[i].addError('Installer can\'t be greater than 40 character');
        }
        if(trigger.new[i].Inverter__c != null && trigger.new[i].Inverter__c.length() >40 ){                        
            Trigger.new[i].addError('Inverter can\'t be greater than 40 character');
        }
        if(trigger.new[i].Joint_Address_1__c != null && trigger.new[i].Joint_Address_1__c.length() >40 ){                        
            Trigger.new[i].addError('Joint Address 1 can\'t be greater than 40 character');
        }
        if(trigger.new[i].Joint_First_Name__c != null && trigger.new[i].Joint_First_Name__c.length() >40 ){                        
            Trigger.new[i].addError('Joint First Name can\'t be greater than 40 character');
        }
        if(trigger.new[i].mem_Joint_Employer__c != null && trigger.new[i].mem_Joint_Employer__c.length() >40 ){                        
            Trigger.new[i].addError('mem Joint Employer can\'t be greater than 40 character');
        }
        if(trigger.new[i].mem_Joint_Extra_Address__c != null && trigger.new[i].mem_Joint_Extra_Address__c.length() >40 ){                        
            Trigger.new[i].addError('mem Joint Extra Address can\'t be greater than 40 character');
        }
        if(trigger.new[i].Joint_ID_Number__c != null && trigger.new[i].Joint_ID_Number__c.length() >40 ){                        
            Trigger.new[i].addError('mem Joint ID Number can\'t be greater than 40 character');
        }
        if(trigger.new[i].Joint_ID_State__c != null && trigger.new[i].Joint_ID_State__c.length() >40 ){                        
            Trigger.new[i].addError('mem Joint ID State can\'t be greater than 40 character');
        }
        if(trigger.new[i].Joint_Maiden_Name__c != null && trigger.new[i].Joint_Maiden_Name__c.length() >40 ){                        
            Trigger.new[i].addError('mem Joint Maiden Name can\'t be greater than 40 character');
        }
        if(trigger.new[i].Joint_Occupation__c != null && trigger.new[i].Joint_Occupation__c.length() >40 ){                        
            Trigger.new[i].addError('mem Joint Occupation can\'t be greater than 40 character');
        }
        if(trigger.new[i].mem_Joint_Street__c != null && trigger.new[i].mem_Joint_Street__c.length() >40 ){                        
            Trigger.new[i].addError('mem Joint Street can\'t be greater than 40 character');
        }
        if(trigger.new[i].mem_Mailing_City__c != null && trigger.new[i].mem_Mailing_City__c.length() >40 ){                        
            Trigger.new[i].addError('mem Mailing City can\'t be greater than 40 character');
        }
        if(trigger.new[i].mem_Mailing_Extra_Address__c != null && trigger.new[i].mem_Mailing_Extra_Address__c.length() >40 ){                        
            Trigger.new[i].addError('mem Mailing Extra Address can\'t be greater than 40 character');
        }
        if(trigger.new[i].Mailing_Street__c != null && trigger.new[i].Mailing_Street__c.length() >40 ){                        
            Trigger.new[i].addError('mem Mailing Street can\'t be greater than 40 character');
        }
        if(trigger.new[i].Employer__c != null && trigger.new[i].Employer__c.length() >40 ){                        
            Trigger.new[i].addError('mem Primary Employer can\'t be greater than 40 character');
        }
        if(trigger.new[i].mem_Primary_Extra_Address__c != null && trigger.new[i].mem_Primary_Extra_Address__c.length() >40 ){                        
            Trigger.new[i].addError('mem Primary Extra Address can\'t be greater than 40 character');
        }
        if(trigger.new[i].Occupation__c != null && trigger.new[i].Occupation__c.length() >40 ){                        
            Trigger.new[i].addError('mem Primary Occupation can\'t be greater than 40 character');
        }
        if(trigger.new[i].mem_Primary_Street__c != null && trigger.new[i].mem_Primary_Street__c.length() >40 ){                        
            Trigger.new[i].addError('mem Primary Street can\'t be greater than 40 character');
        }
        if(trigger.new[i].Bank_Name__c != null && trigger.new[i].Bank_Name__c.length() >40 ){                        
            Trigger.new[i].addError('Member Entered Bank Name can\'t be greater than 40 character');
        }
        if(trigger.new[i].Member_Number__c != null && trigger.new[i].Member_Number__c.length() >40 ){                        
            Trigger.new[i].addError('Member Number can\'t be greater than 40 character');
        }
        if(trigger.new[i].Module__c != null && trigger.new[i].Module__c.length() >40 ){                        
            Trigger.new[i].addError('Module can\'t be greater than 40 character');
        }
        if(trigger.new[i].Product_Loan_Type__c != null && trigger.new[i].Product_Loan_Type__c.length() >40 ){                        
            Trigger.new[i].addError('Product Loan Type can\'t be greater than 40 character');
        }
        if(trigger.new[i].Site_UUID__c != null && trigger.new[i].Site_UUID__c.length() >40 ){                        
            Trigger.new[i].addError('Site UUID can\'t be greater than 40 character');
        }
        // code change for US: STRY0012031 ends here
        trigger.new[i].Ownerid = queList[0].id ;
        trigger.new[i].Current_Solar_Loan_Stage__c = 'Stage 1';
        if(trigger.new[i].Member_Number__c != null) {
            Integer MemberNumberLength = (trigger.new[i].Member_Number__c).length();
            if(MemberNumberLength == 6) {
              String s = '0000'+ trigger.new[i].Member_Number__c;
              trigger.new[i].Member_Number__c = s;
            }
        }
        if(trigger.new[i].Primary_Email__c != null) {
          String primaryEmail = trigger.new[i].Primary_Email__c;
          trigger.new[i].Primary_Email__c = primaryEmail.toLowerCase();
        }
        if(trigger.new[i].Joint_Email__c != null) {
          String jointEmail = trigger.new[i].Joint_Email__c;
          trigger.new[i].Joint_Email__c = jointEmail.toLowerCase();
        }
      }
    }
    
    //------------------------------------------------After Insert ----------------------------------------------//
    
    
    if(Trigger.isInsert && Trigger.isAfter){
        for(Integer i=0; i<trigger.new.size(); i++){
        
             //------------------------------- Adding ids if the Member Number field is not null---------------------------------------------------------------//
             
            if(trigger.new[i].Member_Number__c != null){ 
                SLForBranchIds.put(trigger.new[i].id, trigger.new[i]);
                SLMemberNumber.add(trigger.new[i].Member_Number__c);
            }
            
        }
        system.debug('SLForBranchIds'+SLForBranchIds);
        system.debug('SLMemberNumber'+SLMemberNumber);
        //--------------------------Updating "Member Name" based on "Name" field from Solar Loan record ---------------------------//
        
        if(SLMemberNumber.size() > 0){
            
            List<Person_Account__c > peraccountlist = [select id,PersonID__c,PersonID__r.name,account_number__c,account_number__r.name from Person_Account__c where account_number__r.name in:SLMemberNumber and Name_Type__c = 0];
            
            system.debug('peraccountlist'+peraccountlist);
            for(Solar_Loans__c solarloan : SLForBranchIds.values()){
                
                for(Person_Account__c personacc : peraccountlist){
                    
                    if(personacc.account_number__r.name == solarloan.Member_Number__c){
                    
                        Solar_Loans__c sName = new Solar_Loans__c();
                        sName.id = solarloan.id;
                        sName.Member_Name__c = personacc.PersonID__c;
                        SolarLoanMap.put(solarloan.id,sName);
                    }
                }
            }
            if(SolarLoanMap.size() > 0){
        
                update SolarLoanMap.values();   
            }
        }
        
        //--------------------------Updating "Brand" and "Four Digit Share Loan Type" from "Account Details" record------------------//
        
        
        List<Account_Details__c> adList = [select id, Name, Brand__c, ID1__c, TypeTranslate__c,RecType__c from Account_Details__c where Name in:SLMemberNumber and Brand__c != null];
        system.debug('adList'+adList);
       
        for(Solar_Loans__c sl : SLForBranchIds.values()){
            system.debug('sl'+sl);
            for(Account_Details__c a : adList){
                system.debug('a'+a);        
                if(a.Name == sl.Member_Number__c){
                    
                    Solar_Loans__c s = new Solar_Loans__c();
                    s.id = SLForBranchIds.get(sl.id).id;
                    //s.Brand__c = a.Brand__c;
                    s.Account_Number__c = a.id;
                    system.debug('a.id'+a.id);
                    SLToUpdates.put(sl.id,s);
                }
            }
        }
         
        if(SLToUpdates.size() > 0){
        
            update SLToUpdates.values();    
        }
         
    }
    
    
    //------------------------------- Checking if the status 'Completed' and Routing Number is 'Changed' ------------------------//
        
    if(Trigger.isBefore && Trigger.isUpdate){
        
        for(Integer i=0; i<trigger.new.size(); i++){
            // code change for US: STRY0012031 begin    
            if(trigger.new[i].Credit_Exception__c != trigger.old[i].Credit_Exception__c  && trigger.new[i].Credit_Exception__c.length() >40 ){                        
                Trigger.new[i].addError('Credit Exception can\'t be greater than 40 character');
            }
			if(trigger.new[i].Installer__c != trigger.old[i].Installer__c  && trigger.new[i].Installer__c.length() >40 ){                        
                Trigger.new[i].addError('Installer can\'t be greater than 40 character');
            }
			if(trigger.new[i].Inverter__c != trigger.old[i].Inverter__c  && trigger.new[i].Inverter__c.length() >40 ){                        
                Trigger.new[i].addError('Inverter can\'t be greater than 40 character');
            }
			if(trigger.new[i].Joint_Address_1__c != trigger.old[i].Joint_Address_1__c  && trigger.new[i].Joint_Address_1__c.length() >40 ){                        
                Trigger.new[i].addError('Joint Address 1 can\'t be greater than 40 character');
            }
			if(trigger.new[i].Joint_First_Name__c != trigger.old[i].Joint_First_Name__c  && trigger.new[i].Joint_First_Name__c.length() >40 ){                        
                Trigger.new[i].addError('Joint First Name can\'t be greater than 40 character');
            }
			if(trigger.new[i].mem_Joint_Employer__c != trigger.old[i].mem_Joint_Employer__c  && trigger.new[i].mem_Joint_Employer__c.length() >40 ){                        
                Trigger.new[i].addError('mem Joint Employer can\'t be greater than 40 character');
            }
			if(trigger.new[i].mem_Joint_Extra_Address__c != trigger.old[i].mem_Joint_Extra_Address__c  && trigger.new[i].mem_Joint_Extra_Address__c.length() >40 ){                        
                Trigger.new[i].addError('mem Joint Extra Address can\'t be greater than 40 character');
            }
			if(trigger.new[i].Joint_ID_Number__c != trigger.old[i].Joint_ID_Number__c  && trigger.new[i].Joint_ID_Number__c.length() >40 ){                        
                Trigger.new[i].addError('mem Joint ID Number can\'t be greater than 40 character');
            }
			if(trigger.new[i].Joint_ID_State__c != trigger.old[i].Joint_ID_State__c  && trigger.new[i].Joint_ID_State__c.length() >40 ){                        
                Trigger.new[i].addError('mem Joint ID State can\'t be greater than 40 character');
            }
			if(trigger.new[i].Joint_Maiden_Name__c != trigger.old[i].Joint_Maiden_Name__c  && trigger.new[i].Joint_Maiden_Name__c.length() >40 ){                        
                Trigger.new[i].addError('mem Joint Maiden Name can\'t be greater than 40 character');
            }
			if(trigger.new[i].Joint_Occupation__c != trigger.old[i].Joint_Occupation__c  && trigger.new[i].Joint_Occupation__c.length() >40 ){                        
                Trigger.new[i].addError('mem Joint Occupation can\'t be greater than 40 character');
            }
			if(trigger.new[i].mem_Joint_Street__c != trigger.old[i].mem_Joint_Street__c  && trigger.new[i].mem_Joint_Street__c.length() >40 ){                        
                Trigger.new[i].addError('mem Joint Street can\'t be greater than 40 character');
            }
			if(trigger.new[i].mem_Mailing_City__c != trigger.old[i].mem_Mailing_City__c  && trigger.new[i].mem_Mailing_City__c.length() >40 ){                        
                Trigger.new[i].addError('mem Mailing City can\'t be greater than 40 character');
            }
			if(trigger.new[i].mem_Mailing_Extra_Address__c != trigger.old[i].mem_Mailing_Extra_Address__c  && trigger.new[i].mem_Mailing_Extra_Address__c.length() >40 ){                        
                Trigger.new[i].addError('mem Mailing Extra Address can\'t be greater than 40 character');
            }
			if(trigger.new[i].Mailing_Street__c != trigger.old[i].Mailing_Street__c  && trigger.new[i].Mailing_Street__c.length() >40 ){                        
                Trigger.new[i].addError('mem Mailing Street can\'t be greater than 40 character');
            }
			if(trigger.new[i].Employer__c != trigger.old[i].Employer__c  && trigger.new[i].Employer__c.length() >40 ){                        
                Trigger.new[i].addError('mem Primary Employer can\'t be greater than 40 character');
            }
            if(trigger.new[i].mem_Primary_Extra_Address__c != trigger.old[i].mem_Primary_Extra_Address__c  && trigger.new[i].mem_Primary_Extra_Address__c.length() >40 ){                        
                Trigger.new[i].addError('mem Primary Extra Address can\'t be greater than 40 character');
            }
			if(trigger.new[i].Occupation__c != trigger.old[i].Occupation__c  && trigger.new[i].Occupation__c.length() >40 ){                        
                Trigger.new[i].addError('mem Primary Occupation can\'t be greater than 40 character');
            }
			if(trigger.new[i].mem_Primary_Street__c != trigger.old[i].mem_Primary_Street__c  && trigger.new[i].mem_Primary_Street__c.length() >40 ){                        
                Trigger.new[i].addError('mem Primary Street can\'t be greater than 40 character');
            }
			if(trigger.new[i].Bank_Name__c != trigger.old[i].Bank_Name__c  && trigger.new[i].Bank_Name__c.length() >40 ){                        
                Trigger.new[i].addError('Member Entered Bank Name can\'t be greater than 40 character');
            }
			if(trigger.new[i].Member_Number__c != trigger.old[i].Member_Number__c  && trigger.new[i].Member_Number__c.length() >40 ){                        
                Trigger.new[i].addError('Member Number can\'t be greater than 40 character');
            }
			if(trigger.new[i].Module__c != trigger.old[i].Module__c  && trigger.new[i].Module__c.length() >40 ){                        
                Trigger.new[i].addError('Module can\'t be greater than 40 character');
            }
			if(trigger.new[i].Product_Loan_Type__c != trigger.old[i].Product_Loan_Type__c  && trigger.new[i].Product_Loan_Type__c.length() >40 ){                        
                Trigger.new[i].addError('Product Loan Type can\'t be greater than 40 character');
            }
			if(trigger.new[i].Site_UUID__c != trigger.old[i].Site_UUID__c  && trigger.new[i].Site_UUID__c.length() >40 ){                        
                Trigger.new[i].addError('Site UUID can\'t be greater than 40 character');
            }
            // code change for US: STRY0012031 end 
                if(trigger.new[i].Routing_Number__c != trigger.old[i].Routing_Number__c && trigger.new[i].Routing_Number__c != null && trigger.new[i].Status__c == 'Completed'){
                trigger.new[i].Review_needed__c = true;
              }

          //------------------------------- Updating "SignatureCardURL to null if the Checkbox called "Signed" is false---------//
          if(trigger.old[i].Signed__c == true && trigger.new[i].Signed__c == false){
            trigger.new[i].SignatureCardURL__c = '';
          }
            
            //----------------------------- Start - Updating DocuSign Document Status -----------------------------------//
          if(trigger.old[i].Status__c != trigger.new[i].Status__c && trigger.new[i].Status__c ==  'ACH Pending'){
            trigger.new[i].DocuSign_Document_Status__c = 'Sent';
          }
            
          if(trigger.old[i].Status__c != trigger.new[i].Status__c && trigger.new[i].Status__c ==  'Completed'){
            trigger.new[i].DocuSign_Document_Status__c = 'Received';
          }
            
          //----------------------------- End - Updating DocuSign Document Status -----------------------------------//
            
          if(trigger.old[i].Status__c != trigger.new[i].Status__c && trigger.new[i].Status__c ==  'Declined'){
            trigger.new[i].Current_Solar_Loan_Stage__c = 'Stage 5';
          }
          if(trigger.old[i].Status__c != trigger.new[i].Status__c && trigger.new[i].Status__c ==  'Expired'){
            trigger.new[i].Current_Solar_Loan_Stage__c = 'Stage 5';
          }
            
          //----------------------------- Populate valid member number-----------------------------------------------//
            
              if(trigger.old[i].Member_Number__c != trigger.new[i].Member_Number__c || trigger.new[i].Member_Number__c !=  null){               
            if(trigger.new[i].Member_Number__c != null){
              Integer MemberNumberLength = (trigger.new[i].Member_Number__c).length();
              if(MemberNumberLength == 6){
                String s = '0000'+ trigger.new[i].Member_Number__c;
                trigger.new[i].Member_Number__c = s;
              }
            }
            }

          if(trigger.new[i].Primary_Email__c != null) {
            String primaryEmail = trigger.new[i].Primary_Email__c;
            trigger.new[i].Primary_Email__c = primaryEmail.toLowerCase();
          }
          if(trigger.new[i].Joint_Email__c != null) {
            String jointEmail = trigger.new[i].Joint_Email__c;
            trigger.new[i].Joint_Email__c = jointEmail.toLowerCase();
          }
        } 
              
    }
            
    if(Trigger.isAfter && Trigger.isUpdate){
        
        for(Integer i=0; i<trigger.new.size(); i++){
            //------------------------------- Checking if the status is being changed and status = 'ACH Pending'-----------------//
            if(trigger.old[i].Status__c != 'ACH Pending' && trigger.new[i].Status__c == 'ACH Pending'){
              SLIds.add(trigger.new[i].id);
            }
            
            if(trigger.old[i].SignatureCardURL__c == null && trigger.new[i].SignatureCardURL__c != null){
              SolarLoanToSignCard.SetCustomFieldTrue();
            }
            
            //------------------------------- Checking if the status is being changed and status = 'Completed'-----------------//
            if(trigger.old[i].Status__c != 'Completed' && trigger.new[i].Status__c == 'Completed' && trigger.new[i].ACH__c == 'True' &&
              (trigger.new[i].EftLocator__c == null || trigger.new[i].EftLocator__c == '')){
              SLIdsForEFT.add(trigger.new[i].id);
            }

            /*if(trigger.old[i].Status__c != 'Completed' && trigger.new[i].Status__c == 'Completed' && 
                    (trigger.new[i].EftLocator__c != null && trigger.new[i].EftLocator__c != '')){
                SLIdsForEFTUpdate.add(trigger.new[i].id);
            }*/
            if((trigger.new[i].EftLocator__c != null && trigger.new[i].EftLocator__c != '' && trigger.new[i].ACH__c == 'True') && (
                            (trigger.old[i].Status__c != 'Completed' && trigger.new[i].Status__c == 'Completed') ||
                            (trigger.old[i].Loan_Type__c != trigger.new[i].Loan_Type__c)                         ||
                            (trigger.old[i].Additional_Amount__c != trigger.new[i].Additional_Amount__c)         ||
                            (trigger.old[i].Bank_Account_Number__c != trigger.new[i].Bank_Account_Number__c)     ||
                            (trigger.old[i].Bank_Name__c != trigger.new[i].Bank_Name__c)                         ||
                            (trigger.old[i].Routing_Number__c != trigger.new[i].Routing_Number__c))){

                SLIdsForEFTUpdate.add(trigger.new[i].id);
            }
            if(trigger.old[i].Status__c != 'Completed' && trigger.new[i].Status__c == 'Completed' && 
                trigger.new[i].UCC_Id__c != null && trigger.new[i].Current_Solar_Loan_Stage__c == 'Stage 7'){

                    Solar_Loans__c sl = new Solar_Loans__c();
                    sl.id = trigger.new[i].id;
                    sl.Status__c = 'UCC Pending';
                    SLToUpdates.put(sl.id,sl);
            }   
            
            //------------------------------- Adding ids if the Member Number field is not null----------------------------------//
            
            if(trigger.new[i].Member_Number__c != null && trigger.new[i].Member_Name__c == null){ 
                SLForBranchIds.put(trigger.new[i].id, trigger.new[i]);
                SLMemberNumberForName.add(trigger.new[i].Member_Number__c);
            }
            
            if(trigger.new[i].Member_Number__c != null && trigger.new[i].Account_Number__c == null){ 
                SLForBranchIds.put(trigger.new[i].id, trigger.new[i]);
                SLMemberNumber.add(trigger.new[i].Member_Number__c);
            }
            
        } 
        system.debug('SLMemberNumberForName'+SLMemberNumberForName);
        system.debug('SLMemberNumber'+SLMemberNumber);
                    
        //--------------------------Updating "Member Name" based on "Name" field from Solar Loan record -----------------------//
        
            if(SLMemberNumberForName != null){
                
                List<Person_Account__c > peraccountlist = [select id,PersonID__c,PersonID__r.name,account_number__c,account_number__r.name from Person_Account__c where account_number__r.name in:SLMemberNumberForName and PersonID__c != null and Name_Type__c = 0 LIMIT 1];
                
                system.debug('peraccountlist'+peraccountlist);
                for(Solar_Loans__c solarloan : SLForBranchIds.values()){
                    
                    for(Person_Account__c personacc : peraccountlist){
                        
                        if(personacc.account_number__r.name == solarloan.Member_Number__c ){
                        
                            Solar_Loans__c sName = new Solar_Loans__c();
                            sName.id = solarloan.id;
                            sName.Member_Name__c = personacc.PersonID__c;
                            SolarLoanMap.put(solarloan.id,sName);
                        }
                    }
                }
                    
                    
                if(SolarLoanMap.size() > 0){
                    
                    update SolarLoanMap.values();   
                }
          }
                
        //--------------------------Updating "Brand" and "Four Digit Share Loan Type" from "Account Details" record------------------//
        
        
            //List<Account_Details__c> adList = [select id, Name, Brand__c, ID1__c, TypeTranslate__c,RecType__c from Account_Details__c where Name in:SLMemberNumber and Brand__c != null and RecType__c = 'LOAN' and TypeTranslate__c = '75-SECURED SOLAR'];
            List<Account_Details__c> adList = [select id, Name, Brand__c, ID1__c, TypeTranslate__c,RecType__c from Account_Details__c where Name in:SLMemberNumber and Brand__c != null];
            for(Solar_Loans__c sl : SLForBranchIds.values()){
            
                for(Account_Details__c a : adList){
                    
                    if(a.Name == sl.Member_Number__c){
                        
                        Solar_Loans__c s = new Solar_Loans__c();
                        s.id = SLForBranchIds.get(sl.id).id;
                        //s.Brand__c = a.Brand__c;
                        s.Account_Number__c = a.id;
                        SLToUpdates.put(sl.id,s);
                    }
                }
            }
             
        if(SLToUpdates.size() > 0){
        
            update SLToUpdates.values();    
        }
        //------------------------------- Calling Batch class with list of "Solar Loans" id to send a Docusign email-----------------//    
        if(SLIds.size() > 0){
            
            SolarLoanToDocuSign.docusignAPIcall(SLIds);
        }
        
        //------------------------------- Creating "EFT" record if the status = "Completed"------------------------------------------//
        if(SLIdsForEFT.size() > 0){
            
             SolarLoanToSymitar.insertSolarLoans(SLIdsForEFT);
        }

        //------------------------------- Updating "EFT" record if the status = "Completed"------------------------------------------//

        if(SLIdsForEFTUpdate.size() > 0){
            
            SolarLoanToSymitar.updateEFTrecord(SLIdsForEFTUpdate);
        }

    }
        
}