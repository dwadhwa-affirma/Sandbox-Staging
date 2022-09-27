/* ---------------------This trigger will be executed before insert of address change log.
It creates a case with addresschange details in description field.
It also sends Email and SMS notifications.................*/
trigger AddressChangeLogTrigger on AddressChangeLog__c(before insert, after insert){
    
    string intakemethod = '';
    string IdentificationMethod = '';
    string Description = '';
    string Subject = '';
    Id caseid;
    string IdentificationMethodInfo = '';
    
    
    if (trigger.isbefore && trigger.isInsert){
        set<string> setMemberId = new set<string>();
        
        for (AddressChangeLog__c objAddressChange : trigger.New){
            setMemberId.add(objAddressChange.Member__c);
        }
        
        Map<Id, Account> objMap = new Map<Id, Account>([SELECT Id, Name
                                                        FROM Account
                                                        WHERE Id IN :setMemberId]);
        
        for (AddressChangeLog__c objAddressChange : trigger.New){
            string memberemail = objAddressChange.Email__c;
            string phone = objAddressChange.MobilePhone__c;
            boolean SendEmail = false, SendSMS = false;
            
            String emailRegex = '([a-zA-Z0-9_\\-\\.]+)@((\\[a-z]{1,3}\\.[a-z]{1,3}\\.[a-z]{1,3}\\.)|(([a-zA-Z0-9\\-]+\\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})';
            Pattern MyPattern = Pattern.compile(emailRegex);
            
            // ---------------------Send Email/SMS Notifications..................//
            AddressChangeConfigurations__c accf = AddressChangeConfigurations__c.getValues('Primary');
            
            SendEmail = accf.SendEmail__c;
            SendSMS = accf.SendSMS__c;
            List<string> EmailList = new List<String>();
            if (memberemail != null && (MyPattern.matcher(memberemail).matches()))
                EmailList.add(memberemail);
            /*if (SendEmail && EmailList.size() > 0){
                //SendEmailNotifications(EmailList, 'Address Change', objAddressChange.Member__c);
            }
            if (SendSMS && phone != null){
                system.debug('memberPhone==' + phone);
                //SendSMS(phone);
            }*/
            
            String accountstring =objAddressChange.AccountNumbersString__c;
            List<String> listAccountNumber = new List<String>();
            if (accountstring.contains(',')){
                listAccountNumber = accountstring.split('\\,');
            } else{
                listAccountNumber.add(accountstring);
            }
            
            set<string> setAccountNumbers = new set<string>();
            map<string, id> mapAccountNumber = new map<string, id>();
            
            
            for (String s : listAccountNumber){
                if (!String.isEmpty(s)){
                    setAccountNumbers.add(s);
                }
            }
            
            List<Account_Details__c> listAccounts = [select id, name
                                                     from Account_Details__c
                                                     where name IN :setAccountNumbers and parent_account__c = null];
            for (Account_Details__c acc : listAccounts){
                mapAccountNumber.put(acc.name, acc.id);
            }
            
            /*----------------------------------Create and Format Case Description begins--------------------------------------------*/
            if (objAddressChange.Clean_Up_Intake_Method__c == 'Clean Up - Report Date'){
                Datetime dt = datetime.newInstance(Date.valueOf(objAddressChange.Clean_Up_Report_Date__c).year(), Date.valueOf(objAddressChange.Clean_Up_Report_Date__c).month(), Date.valueOf(objAddressChange.Clean_Up_Report_Date__c).day());
                intakemethod = 'Intake Method:' + objAddressChange.Clean_Up_Intake_Method__c + '\n' + 
                    'Clean Up Report Date:' + dt.format('MM/dd/yyyy')+'\n';
            } else{
                intakemethod = 'Intake Method:' + objAddressChange.Clean_Up_Intake_Method__c + '\n';
            }
            
            
            IdentificationMethod = 'Identification Method:' + objAddressChange.Identification_Method__c + '\n';
            if(objAddressChange.Identification_Method__c =='Company Badge' || objAddressChange.Identification_Method__c =='DL/ID/Other' || objAddressChange.Identification_Method__c =='Passport'){
                IdentificationMethodInfo = objAddressChange.Identification_Method_Information__c;
            }
            
            if(IdentificationMethodInfo != '' && IdentificationMethodInfo != null){
                IdentificationMethod = IdentificationMethod + 'Identification Method Information:' + IdentificationMethodInfo + '\n';
            }

            String MemberName;
            system.debug('objMap='+objMap);
            if(objMap != null && !(objMap.isEmpty()))
                MemberName = objMap.get(objAddressChange.Member__c).Name;
            
            if ((objAddressChange.Address_New__c == '' || objAddressChange.Address_New__c == null) && objAddressChange.Address2_New__c != '' && objAddressChange.Address2_New__c != null){
                objAddressChange.Address_New__c = objAddressChange.Address2_New__c;
                objAddressChange.Address2_New__c = '';
            }
            if (objAddressChange.Address2_New__c != null && objAddressChange.Address2_New__c != ''){
                if (objAddressChange.Address_New__c.toUpperCase().Contains('STE') || objAddressChange.Address_New__c.toUpperCase().Contains('SUITE') || objAddressChange.Address_New__c.toUpperCase().Contains('RM') || objAddressChange.Address_New__c.toUpperCase().Contains('DEPT') || objAddressChange.Address_New__c.toUpperCase().Contains('APT') || objAddressChange.Address_New__c.toUpperCase().Contains('APARTMENT')){
                    string temp = objAddressChange.Address_New__c;
                   // objAddressChange.Address_New__c = objAddressChange.Address2_New__c;
                   // objAddressChange.Address2_New__c = temp;
                }
            }
            
            if(objAddressChange.Zip_New__c != null && objAddressChange.Zip_New__c.Contains('-')){
                List<string> ZipCodes = objAddressChange.Zip_New__c.split('-');
                objAddressChange.Zip_New__c = ZipCodes[0];
                if(ZipCodes.size() > 1)
                    objAddressChange.Zip4_New__c = ZipCodes[1];
            }
            
            if(objAddressChange.Zip_Old__c != null && objAddressChange.Zip_Old__c.Contains('-')){
                List<string> ZipCodes1 = objAddressChange.Zip_Old__c.split('-');
                objAddressChange.Zip_Old__c = ZipCodes1[0];
                if(ZipCodes1.size() > 1)
                    objAddressChange.Zip4_Old__c = ZipCodes1[1];
            }
            
            //Construct Name field for case description
            // It will contact all accnumber|accName separated by ','
            // e.g. 0001234|Chevron Test123,0001234|Chevron Test456,000789|Chevron Test789
            string names='';
            set<string> setSSNs = new set<string>();
            set<string> setAccNos = new set<string>();
            if(objAddressChange.AccountNamePair__c!=null && !String.isEmpty(objAddressChange.AccountNamePair__c)){
                String[] arrNames = objAddressChange.AccountNamePair__c.split(',');
                for(String nameItem : arrNames) {
                    string accPipeName='';
                    List<String> arryNameItem=nameItem.trim().split('\\|');
                    integer index=0;
                    string ssn='';
                    string accNo = '';
                    string SSNaccNo = '';
                    if (objAddressChange.Update_Type__c == 'Mailing Address' 
                        || objAddressChange.Update_Type__c =='Temp Mailing Address - New'){
                            arryNameItem.remove(arryNameItem.size()-1);
                            boolean isNewName=false;
                            for(String item : arryNameItem) {  
                                if(index==0){
                                    if(names.indexOf(item)!=-1){
                                        break;
                                    }
                                    accPipeName=' '+item+'|';
                                    isNewName=true;
                                }else{
                                    if(item!='|'){
                                        accPipeName+=item+' ';
                                    }
                                }
                                index=index+1;
                            }
                            if(isNewName==true){
                                names+=accPipeName+',';
                            }
                        }
                    
                    else{
                        if(arryNameItem.size() >3){
                                ssn = arryNameItem[2]; 
                             accNo = arryNameItem[0]; 
                            SSNaccNo = ssn + ',' + accNo;
                            }                        
                        if(!setSSNs.contains(SSNaccNo)){
                            setSSNs.add(SSNaccNo);                           
                            for(String item : arryNameItem) {  
                                if(index==0){
                                    accPipeName=' '+item+'|';
                                }else{
                                    if(item!='|'){
                                        accPipeName+=item;
                                        names+=accPipeName+',';
                                        break;
                                    }
                                }
                                index=index+1;
                            }
                        }
                          
                        }
                }
            }
            
            if(names!=null&& names!=''){
                string lastCharacter = names.right(1);
                if(lastCharacter==','){
                    names=names.removeEnd(',');
                }
            }
            
            if (objAddressChange.Update_Type__c == 'Residential Address'){
                // To create case description for residential address change
                Description = '\n' + intakemethod 
                    + IdentificationMethod +'\n'
                    + 'Update Type:' + objAddressChange.Update_Type__c + '\n\n' 
                    + 'Member Name:' + MemberName + '\n' 
                    + 'Old Address1:' + (objAddressChange.Address_Old__c == null ? '' : objAddressChange.Address_Old__c)+'\n'
                    +'Old Address2:' + (objAddressChange.Address2_Old__c == null ? '' : objAddressChange.Address2_Old__c)+'\n' 
                    + 'Old City:' + (objAddressChange.City_Old__c == null ? '' : objAddressChange.City_Old__c)+'\n' 
                    + 'Old State:' + (objAddressChange.State_Old__c == null ? '' : objAddressChange.State_Old__c)+'\n'
                    +'Old Zip:' + (objAddressChange.Zip_Old__c == null ? '' : objAddressChange.Zip_Old__c)+'\n' 
                    +'Old Zip +4:' + (objAddressChange.Zip4_Old__c == null ? '' : objAddressChange.Zip4_Old__c)+'\n'
                    +'Old Country:' + (objAddressChange.Country_Old__c == null ? '' : objAddressChange.Country_Old__c)+'\n'
                    +'Old Country Code:' + (objAddressChange.CountryCode_Old__c == null ? '' : objAddressChange.CountryCode_Old__c)+'\n\n' 
                    + 'New Address1:' + (objAddressChange.Address_New__c == null ? '' : objAddressChange.Address_New__c)+'\n' 
                    + 'New Address2:' + (objAddressChange.Address2_New__c == null ? '' : objAddressChange.Address2_New__c)+'\n' 
                    + 'New City:' + (objAddressChange.City_New__c == null ? '' : objAddressChange.City_New__c)+'\n' 
                    + 'New State:' + (objAddressChange.State_New__c == null ? '' : objAddressChange.State_New__c)+'\n' 
                    + 'New Zip:' + (objAddressChange.Zip_New__c == null ? '' : objAddressChange.Zip_New__c)+'\n' 
                    + 'New Zip +4:' + (objAddressChange.Zip4_New__c == null ? '' : objAddressChange.Zip4_New__c)+'\n' 
                    + 'New Country:' + (objAddressChange.Country_New__c == null ? '' : objAddressChange.Country_New__c)+'\n'  
                    + 'New Country Code:' + (objAddressChange.CountryCode_New__c == null ? '' : objAddressChange.CountryCode_New__c)+'\n'
                    + 'Record Type Updated:' + 'Name Records' + '\n' 
                    + 'Names:' + names;
                
                //Log expired mailing address details to case description when comes from residential address change flow
                if (objAddressChange.Is_Temp_Mail_Expired__c && objAddressChange.Expired_Temp_Mail_Details__c != null){
                    List<string> TempMailList = objAddressChange.Expired_Temp_Mail_Details__c.split(',');
                    Description = Description + '\n' + '\n' + 'Expired Active Mail Record Details:' ;
                    for(string s: TempMailList){
                        if(s != '' && s != null){
                            string accno, add1, add2, city, state, zip;
                            List<string> AddressDetailsList = s.split('\\|');
                            accno = AddressDetailsList[0];
                            add1 = AddressDetailsList[1];
                            if(AddressDetailsList[2] != '' && AddressDetailsList[2] != null)
                                add2 = AddressDetailsList[2];
                            if(AddressDetailsList[3] != '' && AddressDetailsList[3] != null)
                                city = AddressDetailsList[3];
                            if(AddressDetailsList[4] != '' && AddressDetailsList[4] != null)
                                state = AddressDetailsList[4];
                            if(AddressDetailsList[5] != '' && AddressDetailsList[5] != null)
                                zip = AddressDetailsList[5]; 
                            Description = Description + '\n' +'Account Number:' + accno + '\n' + 'Address1:' + add1 + '\n' + 'Address2:' + add2 + '\n' + 'City:' + city + '\n' + 'State:' + state + '\n' + 'ZipCode:' + zip + '\n' + '\n';
                        }
                    }
                }
            
                if(string.isNotBlank(objAddressChange.Country_New__c)){
                    objAddressChange.Address_Type__c = 'Foreign';
                }
                else{
                    objAddressChange.Address_Type__c = 'Domestic';
                }
            } 
            else if (objAddressChange.Update_Type__c == 'Contact Info'){
                
                // To create case description for residential address change
                
                Description = '\n'+intakemethod 
                    + IdentificationMethod +'\n'
                    + 'Update Type:' + objAddressChange.Update_Type__c + '\n\n' 
                    + 'Member Name:' + MemberName + '\n' 
                    + 'Old HomePhone:' + (objAddressChange.HomePhone_Old__c == null ? '' : objAddressChange.HomePhone_Old__c)+'\n' 
                    + 'Old MobilePhone:' + (objAddressChange.MobilePhone_Old__c == null ? '' : objAddressChange.MobilePhone_Old__c)+'\n'
                    + 'Old WorkPhone:' + (objAddressChange.WorkPhone_Old__c == null ? '' : objAddressChange.WorkPhone_Old__c)+'\n' 
                    + 'Old WorkExtension:' + (objAddressChange.WorkExtension_Old__c == null ? '' : objAddressChange.WorkExtension_Old__c)+'\n' 
                    + 'Old Email:' + (objAddressChange.Email_Old__c == null ? '' : objAddressChange.Email_Old__c)+'\n' 
                    + 'Old AlternateEmail:' + (objAddressChange.AlternateEmail_Old__c == null ? '' : objAddressChange.AlternateEmail_Old__c)+'\n\n' 

                    + 'New HomePhone:' + (objAddressChange.HomePhone_New__c == null ? '' : objAddressChange.HomePhone_New__c)+'\n'                     
                    + 'New MobilePhone:' + (objAddressChange.MobilePhone_New__c == null ? '' : objAddressChange.MobilePhone_New__c)+'\n'                    
                    + 'New Workphone:' + (objAddressChange.WorkPhone_New__c == null ? '' : objAddressChange.WorkPhone_New__c)+'\n'                    
                    + 'New WorkExtension:' + (objAddressChange.WorkExtension_New__c == null ? '' : objAddressChange.WorkExtension_New__c)+'\n'                    
                    + 'New Email:' + (objAddressChange.Email_New__c == null ? '' : objAddressChange.Email_New__c)+'\n'                    
                    + 'New AlternateEmail:' + (objAddressChange.AlternateEmail_New__c == null ? '' : objAddressChange.AlternateEmail_New__c)+'\n' 
                    + 'Record Type Updated:' + 'Name Records' + '\n' + 
                    'Names:' + names;
                
                if(!isDomesticPhoneNumber(objAddressChange.HomePhone_New__c) || !isDomesticPhoneNumber(objAddressChange.MobilePhone_New__c) || !isDomesticPhoneNumber(objAddressChange.WorkPhone_New__c)){
                    objAddressChange.Telephone_Type__c = 'Foreign';
                }
                else{
                    objAddressChange.Telephone_Type__c = 'Domestic';
                }
            } 
            else if (objAddressChange.Update_Type__c == 'Mailing Address'){
                
                // To create case description for mailing address change
                Description = '\n'+ intakemethod 
                    + IdentificationMethod +'\n'
                    + 'Update Type:' + (objAddressChange.Update_Type__c + ' - Update')+ '\n\n'
                    + 'Member Name:' + MemberName + '\n' 
                    + 'Old Address:' + (objAddressChange.Address_Old__c == null ? '' : objAddressChange.Address_Old__c)+'\n' 
                    + 'Old City:' + (objAddressChange.City_Old__c == null ? '' : objAddressChange.City_Old__c)+'\n' 
                    + 'Old State:' + (objAddressChange.State_Old__c == null ? '' : objAddressChange.State_Old__c)+'\n' 
                    + 'Old Zip:' + (objAddressChange.Zip_Old__c == null ? '' : objAddressChange.Zip_Old__c)+'\n' 
                    + 'Old Expiration Date:' + objAddressChange.ExpirationDate_Old__c + '\n' 
                    + 'Old Active Flag:' + objAddressChange.isActive_Old__c + '\n\n' 
                    + 'New Address:' + (objAddressChange.Address_New__c == null ? '' : objAddressChange.Address_New__c)+'\n' 
                    + 'New City:' + (objAddressChange.City_New__c == null ? '' : objAddressChange.City_New__c)+'\n'                     
                    + 'New State:' + (objAddressChange.State_New__c == null ? '' : objAddressChange.State_New__c)+'\n' 
                    + 'New Zip:' + (objAddressChange.Zip_New__c == null ? '' : objAddressChange.Zip_New__c)+'\n' 
                    + 'New Expiration Date:' + objAddressChange.ExpirationDate_New__c + '\n' 
                    + 'New Active Flag:' + objAddressChange.isActive_New__c + '\n' 
                    + 'Record Type Updated:' + 'Mail only Records' + '\n' + 
                    'Locator:' + objAddressChange.Temp_Mail_Locators__c + '\n' + 
                    'Names:' + names;
            } 
            else if (objAddressChange.Update_Type__c == 'Temp Mailing Address - New'){
                 // To create case description for mailing address change
                Description = '\n'+intakemethod 
                    + IdentificationMethod +'\n'
                    + 'Update Type:' + 'Mailing Address' + '\n\n' 
                    + 'Member Name:' + MemberName + '\n' 
                    + 'Old Address1:' + (objAddressChange.Address_Old__c == null ? '' : objAddressChange.Address_Old__c)+'\n' 
                    + 'Old Address2:' + (objAddressChange.Address2_Old__c == null ? '' : objAddressChange.Address2_Old__c)+'\n'
                    + 'Old City:' + (objAddressChange.City_Old__c == null ? '' : objAddressChange.City_Old__c)+'\n' 
                    + 'Old State:' + (objAddressChange.State_Old__c == null ? '' : objAddressChange.State_Old__c)+'\n' 
                    + 'Old Zip:' + (objAddressChange.Zip_Old__c == null ? '' : objAddressChange.Zip_Old__c)+'\n' 
                    + 'Old Country:' + (objAddressChange.Country_Old__c == null ? '' : objAddressChange.Country_Old__c)+'\n' 
                    + 'Old Country Code:' + (objAddressChange.CountryCode_Old__c == null ? '' : objAddressChange.CountryCode_Old__c)+'\n\n' 
                    + 'New Address1:' + (objAddressChange.Address_New__c == null ? '' : objAddressChange.Address_New__c)+'\n' 
                    + 'New Address2:' + (objAddressChange.Address2_New__c == null ? '' : objAddressChange.Address2_New__c) +'\n' 
                    + 'New City:' + (objAddressChange.City_New__c == null ? '' : objAddressChange.City_New__c)+'\n' 
                    + 'New State:' + (objAddressChange.State_New__c == null ? '' : objAddressChange.State_New__c)+'\n' 
                    + 'New Zip:' + (objAddressChange.Zip_New__c == null ? '' : objAddressChange.Zip_New__c)+'\n' 
                    + 'New Country:' + (objAddressChange.Country_New__c == null ? '' : objAddressChange.Country_New__c)+'\n' 
                    + 'New Country Code:' + (objAddressChange.CountryCode_New__c == null ? '' : objAddressChange.CountryCode_New__c)+'\n\n'; 
                  
                // Expiration date change then display old and new values 
                // Expiration date did not change - display only new value 
                if(objAddressChange.ExpirationDate_New__c!=objAddressChange.ExpirationDate_Old__c){ 
                    
                      string oldValue=objAddressChange.ExpirationDate_Old__c!=null ? objAddressChange.ExpirationDate_Old__c.format('yyyy-MM-dd'):'';
                      string newValue=objAddressChange.ExpirationDate_New__c!=null ? objAddressChange.ExpirationDate_New__c.format('yyyy-MM-dd'):'';
                    
                       Description = Description + 'Expiration Date:\n'
                           + 'Old:'+oldValue+'\n'
                           + 'New:'+newValue;
                   }else{
                       Description =  Description+ 'Expiration Date:'+(objAddressChange.ExpirationDate_New__c!=null ? objAddressChange.ExpirationDate_New__c.format('yyyy-MM-dd'):'');
                   }
                
                Description =Description+'\n\n'+ 'Record Type Updated:' + 'Mail only Records' + '\n' 
                    + 'Locator:' + objAddressChange.Temp_Mail_Locators__c + '\n' 
                    + 'Names:' + names;
                
                 if(string.isNotBlank(objAddressChange.Country_New__c)){
                    objAddressChange.Address_Type__c = 'Foreign';
                    }
                    else{
                        objAddressChange.Address_Type__c = 'Domestic';
                    }
            }

            /*----------------------------------Create and Format Case Description Ends--------------------------------------------*/
            
            // --------------------- Check if Case exists..................//
            
            List<Address_Contact_Change_Case_Categories__c> accList = [SELECT id, name, Category__c
                                                                       FROM Address_Contact_Change_Case_Categories__c];
            
            Set<String> Categories = new set<String>();
            for (Address_Contact_Change_Case_Categories__c a : accList){
                Categories.add(a.Category__c);
            }
            
            List<Case> CaseList = [SELECT id, Account_Number__c, Account_Number__r.Name, Description
                                   from Case
                                   where Account_Number__r.Name IN :listAccountNumber AND status<>'Closed' AND category__c IN :Categories];
            
            if (CaseList.size() > 0){
                for (Case c : CaseList){
                    string tempdesc = c.Description;
                    if (tempdesc != null)
                        Description = tempdesc + '\n' + Description; 
                    if (objAddressChange.Updated_By__c != null && !String.isEmpty(objAddressChange.Updated_By__c))        
                        c.OwnerId = objAddressChange.Updated_By__c;
                    //c.Status = 'Closed';
                    c.Description = Description;
                    if(c.AccountId == null && objAddressChange.Member__c != null){
                        c.AccountId = objAddressChange.Member__c;
                    }
                }
                update CaseList;
                for (Case c : CaseList){  
                    if(objAddressChange.Is_Case_Open__c == true){
                        c.Status = 'Open';
                    }
                    else{
                        c.Status = 'Closed';
                    }          
                    //c.Status = 'Closed';        
                }
                update CaseList;
                objAddressChange.CaseId__c = CaseList[0].Id;
                caseid = CaseList[0].Id;
            }
            
            //Create Case for AddressChange if Case does not exist//
            
            else if (CaseList.size() <= 0){
                list<CaseRecordType__c> scList = [SELECT Id, Primary_Category__c, Secondary_Category__c, Teritiary_Category__c, Record_Type_Name__c, RecordTypeId__c
                                                  FROM CaseRecordType__c
                                                  WHERE Primary_Category__c = 'Account Maintenance' AND Secondary_Category__c = 'Memberships' AND Teritiary_Category__c = 'Address/Contact Updates'
                                                  LIMIT 1];
                
                Case caseobj = new Case();
                
                caseobj.Account_Number__c = listAccounts[0].id;
                if(objAddressChange.Is_Case_Open__c == true){
                    caseobj.Status = 'Open';
                }
                else{
                    caseobj.Status = 'Closed';
                }     
                if (objAddressChange.Member__c != null && !String.isEmpty(objAddressChange.Member__c))      
                    caseobj.AccountId = objAddressChange.Member__c;
                caseobj.RecordTypeId = scList[0].RecordTypeId__c;
                caseobj.Primary_Category__c = scList[0].Primary_Category__c;
                caseobj.Secondary_Category__c = scList[0].Secondary_Category__c;
                caseobj.Tertiary_Category__c = scList[0].Teritiary_Category__c;
                if (objAddressChange.Updated_By__c != null && !String.isEmpty(objAddressChange.Updated_By__c)){
                    caseobj.CreatedById = objAddressChange.Updated_By__c;
                    caseobj.OwnerId = objAddressChange.Updated_By__c;
                }  
                
                
                if (!String.IsBlank(objAddressChange.Address2_New__c) && String.IsBlank(objAddressChange.Address_New__c)){
                    objAddressChange.Address_New__c = objAddressChange.Address2_New__c;
                    objAddressChange.Address2_New__c = '';
                }
                
                
                if (objAddressChange.Update_Type__c == 'Residential Address'){
                    objAddressChange.Email_Old__c = '';
                    objAddressChange.MobilePhone_Old__c = '';
                    caseobj.Subject = 'Address Change';
                    caseobj.Description = Description;
                } else if (objAddressChange.Update_Type__c == 'Contact Info'){
                    caseobj.Subject = 'Contact Info Change';
                    caseobj.Description = Description;
                } else if (objAddressChange.Update_Type__c == 'Mailing Address'){
                    caseobj.Subject = 'Mailing Address Update';
                    caseobj.Description = Description;
                } else if (objAddressChange.Update_Type__c == 'Temp Mailing Address - New'){
                    caseobj.Subject = 'Mailing Address Update';
                    caseobj.Description = Description;
                }  
                
                if(!String.IsBlank(objAddressChange.Case_Origin__c))  {
                    caseobj.Origin = objAddressChange.Case_Origin__c;
                }              
                try{
                    insert caseobj;
                    caseid = caseobj.id;
                    objAddressChange.CaseId__c = caseid;
                    System.debug('Case created :' + caseobj.Id);
                    
                    
                } catch (exception e){
                    System.debug('An error occured while inserting case :' + e);
                }
                
                
            }
            
            // --------------------- Attach multiple Accounts with case..................//
            list<CaseAccountMemberDetail__c> listac = new List<CaseAccountMemberDetail__c>();
            
            for (String s : setAccountNumbers){
                CaseAccountMemberDetail__c obj = new CaseAccountMemberDetail__c();
                obj.Account_Name__c = s;
                obj.Case__c = caseid;
                obj.MemberAccountid__c = mapAccountNumber.get(s);
                listac.add(obj);
                
            }
            
            insert listac;

            List<Address_Change_Email_Configuration__mdt> EmailConfigMDT = [Select id, Label, Send_Email__c from Address_Change_Email_Configuration__mdt];
            Map<string, boolean> mapConfigValue = new Map<string, boolean>();
            for(Address_Change_Email_Configuration__mdt mdt: EmailConfigMDT){
                mapConfigValue.put(mdt.Label,mdt.Send_Email__c);
            }
            
            if (objAddressChange.Update_Type__c == 'Contact Info' && objAddressChange.Case_Origin__c == 'Digital Banking' && mapConfigValue.get('Tyfone') == true){//&& objAddressChange.Case_Origin__c == 'Digital Banking'
                AddressChangeLogHandler.SendEmailUpdateNotification(objAddressChange.AccountNameOldEmail__c,objAddressChange.Email_New__c, SendEmail);
            }
            else if(objAddressChange.Update_Type__c == 'Contact Info' && objAddressChange.Case_Origin__c != 'Digital Banking' && mapConfigValue.get('Internal') == true){
                AddressChangeLogHandler.SendEmailUpdateNotification(objAddressChange.AccountNameOldEmail__c,objAddressChange.Email_New__c, SendEmail);
            }
        }
    }
    
    if(trigger.isAfter && trigger.isInsert){
        for (AddressChangeLog__c objAddressChange : trigger.New){
            if (objAddressChange.Update_Type__c == 'Residential Address'){
                //Update Residential Address Details in Salesforce
                 string[] allNamePairRecords = objAddressChange.AccountNamePair__c.split(',');
                    set<string> setSSNs = new set<string>();                	
                    for(String nameItem : allNamePairRecords) {
                        List<String> arryNameItem=nameItem.trim().split('\\|');
                        if(arryNameItem.size() >= 3){
                            if(string.isNotBlank(arryNameItem[2])){
                                setSSNs.add(arryNameItem[2]);
                            }
                        }
                    }            
                	UpdateResidentialAddress(objAddressChange, setSSNs);
            }
            else if(objAddressChange.Update_Type__c == 'Contact Info'){
                //Update Contact Details in Salesforce
                string[] allNamePairRecords = objAddressChange.AccountNamePair__c.split(',');
                    set<string> setSSNs = new set<string>();
                    for(String nameItem : allNamePairRecords) {
                        List<String> arryNameItem=nameItem.trim().split('\\|');
                        if(arryNameItem.size() >= 3){
                            if(string.isNotBlank(arryNameItem[2])){
                                setSSNs.add(arryNameItem[2]);
                            }
                        }
                    }            
                	UpdateContactDetails(objAddressChange, setSSNs);
            }
            else if(objAddressChange.Update_Type__c == 'Temp Mailing Address - New'){
                //Update Contact Details in Salesforce
                string[] allNamePairRecords = objAddressChange.AccountNamePair__c.split(',');
                    set<string> setAccountNames = new set<string>();
                    for(String nameItem : allNamePairRecords) {
                        List<String> arryNameItem=nameItem.trim().split('\\|');
                        if(arryNameItem.size() >= 1){
                            if(string.isNotBlank(arryNameItem[0])){
                                setAccountNames.add(arryNameItem[0]);
                            }
                        }
                    }            
                	UpdateMailAddressDetails(objAddressChange, setAccountNames);
            }
        }
        for (AddressChangeLog__c objAddressChange1 : trigger.New){
            if (objAddressChange1.Clean_Up_Intake_Method__c == 'In Person Request' && objAddressChange1.Case_Origin__c != 'Digital Banking' )
            {
                AddressChangeLogController.LinkInPersonSigningToAddressChangeLog(objAddressChange1.id);
            } 
        }
    }
    
    // --------------------- Send SMS Notification..................//
    
    private void SendSMS(string phone){
        List<smagicinteract__smsmagic__c> smsObjectList = new List<smagicinteract__smsmagic__c>();
        String senderId = 'CreditUnion';
        smagicinteract__smsMagic__c smsObject = new smagicinteract__smsMagic__c();
        smsObject.smagicinteract__SenderId__c = 'CreditUnion';
        string emailadd;
        
        system.debug('UserInfo.getName()###' + UserInfo.getName());
        
        emailadd = 'Address Change';
        list<smagicinteract__SMS_Template__c> listTemplate = [select Id, smagicinteract__Text__c
                                                              from smagicinteract__SMS_Template__c
                                                              where smagicinteract__Name__c = :emailadd];
        
        smsObject.smagicinteract__PhoneNumber__c = phone;
        smsObject.smagicinteract__Name__c = 'SMS - User'; // records name
        //   smsObject.smagicinteract__ObjectType__c = 'Contact'; // record type
        smsObject.smagicinteract__disableSMSOnTrigger__c = 0; // this field either be 0 or 1, if you specify the value as 1 then sms will not get send but entry of sms will get create under SMS History object
        smsObject.smagicinteract__external_field__c = smagicinteract.ApexAPI.generateUniqueKey();
        
        smsObjectList.add(smsObject);
        Database.insert(smsObjectList, false);
        // LastOTPSent = System.Now();
    }   
    
    
    public void UpdateResidentialAddress(AddressChangeLog__c AddressChangeRecord, set<string> SSNList){
       List<String> substrings = new List<String>();
       string Address1 = AddressChangeRecord.Address_New__c;
       string Address2 = AddressChangeRecord.Address2_New__c;
        
       if (string.isBlank(Address1) && string.isNotBlank(Address2))
       {
           Address1 = Address2;
           Address2 = '';       
       }
        
       string fullAddress = Address1 + ' ' + Address2;
       if (string.isNotBlank(Address1) && string.isNotBlank(Address2) && fullAddress.length() <= 40)
        {
                    Address1 = Address1 + ' ' + Address2;
                    Address2 = '';
        }
       for(String wa: SSNList){
             if(String.isNotBlank(wa)){
                    substrings.add('%' + wa.trim());
                }       
        }
       List<Account> AccountstoUpdate= [Select Residential_Street__pc, Residential_Extra_Address__pc,Residential_City__pc, Residential_State__pc, Residential_Country__pc,Residential_Zipocde__pc, Residential_Country_Code__pc  from Account where PersonId__C Like: substrings];
        
        for(Account acc: AccountstoUpdate){
            if(acc.Residential_Street__pc != Address1){
                acc.Residential_Street__pc = Address1;
            }
            if(acc.Residential_Extra_Address__pc != Address2){
                acc.Residential_Extra_Address__pc = Address2;
            }
            if(acc.Residential_City__pc != AddressChangeRecord.City_New__c){
                acc.Residential_City__pc = AddressChangeRecord.City_New__c;
            }
            if(acc.Residential_State__pc != AddressChangeRecord.State_New__c){
                acc.Residential_State__pc = AddressChangeRecord.State_New__c;
            }
            if(acc.Residential_Country__pc != AddressChangeRecord.Country_New__c){
                acc.Residential_Country__pc = AddressChangeRecord.Country_New__c;
            }
            
            if(acc.Residential_Zipocde__pc != AddressChangeRecord.Zip_New__c){
                system.debug('1----');
                 if(AddressChangeRecord.Zip_New__c != null && AddressChangeRecord.Zip_New__c.Contains('-')){
                    List<string> ZipCodes = AddressChangeRecord.Zip_New__c.split('-');                     
                    acc.Residential_Zipocde__pc = ZipCodes[0];                      
                    if(ZipCodes.size() >= 1)
                        acc.Residential_Zipocde__pc += '-' + ZipCodes[1];                     
                }
                else if(AddressChangeRecord.Zip_New__c != null){
                    acc.Residential_Zipocde__pc = AddressChangeRecord.Zip_New__c;
                }
                else if(AddressChangeRecord.Zip_New__c == null){
                    acc.Residential_Zipocde__pc = '';
                }
            }     
            
			if(acc.Residential_Country_Code__pc != AddressChangeRecord.CountryCode_New__c){
                acc.Residential_Country_Code__pc = AddressChangeRecord.CountryCode_New__c;
            }            
        }
        
       update AccountstoUpdate;
    }
    
    public void UpdateContactDetails(AddressChangeLog__c AddressChangeRecord, set<string> SSNList){
        List<String> substrings = new List<String>();
       for(String wa: SSNList){
             if(String.isNotBlank(wa)){
                    substrings.add('%' + wa.trim());
                }       
        }
       List<Account> AccountstoUpdate= [Select Home_Phone__pc, Mobile_Phone__pc,Work_Phone__pc, Work_Phone_Extension__pc, PersonEmail,Alt_Email_Raw__c, Email_raw__c, Alternate_Email__pc from Account where PersonId__C Like: substrings];
        for(Account acc: AccountstoUpdate){
            if(acc.Home_Phone__pc != AddressChangeRecord.HomePhone_New__c && AddressChangeRecord.HomePhone_New__c != 'Not available'){
                if(string.isBlank(AddressChangeRecord.HomePhone_New__c)){
                    if(AddressChangeRecord.Case_Origin__c != 'Digital Banking'){
                        acc.Home_Phone__pc = AddressChangeRecord.HomePhone_New__c;
                    }                    
                }
                else{
                    acc.Home_Phone__pc = AddressChangeRecord.HomePhone_New__c;
                }
            }
            
            if(acc.Mobile_Phone__pc != AddressChangeRecord.MobilePhone_New__c && AddressChangeRecord.MobilePhone_New__c != 'Not available'){
                if(string.isBlank(AddressChangeRecord.MobilePhone_New__c) && string.isBlank(AddressChangeRecord.Email_New__c)){
                    if(AddressChangeRecord.Case_Origin__c == 'Digital Banking'){
                        acc.Mobile_Phone__pc = AddressChangeRecord.MobilePhone_New__c;
                    }                    
                }
                else{
                    if(string.isBlank(AddressChangeRecord.Email_New__c))
                    	acc.Mobile_Phone__pc = AddressChangeRecord.MobilePhone_New__c;
                }
            }
            
            if(acc.Work_Phone__pc != AddressChangeRecord.WorkPhone_New__c && AddressChangeRecord.WorkPhone_New__c != 'Not available'){
                if(string.isBlank(AddressChangeRecord.WorkPhone_New__c) && string.isBlank(AddressChangeRecord.Email_New__c)){
                    if(AddressChangeRecord.Case_Origin__c == 'Digital Banking'){
                        acc.Work_Phone__pc = AddressChangeRecord.WorkPhone_New__c;
                    }                    
                }
                else{
                     if(string.isBlank(AddressChangeRecord.Email_New__c))
                    	acc.Work_Phone__pc = AddressChangeRecord.WorkPhone_New__c;
                }               
            }
            
            if(acc.Work_Phone_Extension__pc != AddressChangeRecord.WorkExtension_New__c && AddressChangeRecord.WorkExtension_New__c != 'Not available'){
                if(string.isBlank(AddressChangeRecord.WorkExtension_New__c) && string.isBlank(AddressChangeRecord.Email_New__c)){
                    if(AddressChangeRecord.Case_Origin__c == 'Digital Banking'){
                        acc.Work_Phone_Extension__pc = AddressChangeRecord.WorkExtension_New__c;
                    }                    
                }
                else{
                     if(string.isBlank(AddressChangeRecord.Email_New__c))
                    	acc.Work_Phone_Extension__pc = AddressChangeRecord.WorkExtension_New__c;
                }                
            }
            
            if(acc.PersonEmail != AddressChangeRecord.Email_New__c && AddressChangeRecord.Email_New__c != 'Not available'){
                if(string.isBlank(AddressChangeRecord.Email_New__c)){
                    if(AddressChangeRecord.Case_Origin__c != 'Digital Banking'){
                        acc.PersonEmail = AddressChangeRecord.Email_New__c;
                    }                    
                }
                else{
                    acc.PersonEmail = AddressChangeRecord.Email_New__c;
                } 
                
            }

            if(acc.Email_raw__c != AddressChangeRecord.Email_New__c && AddressChangeRecord.Email_New__c != 'Not available'){
                if(string.isBlank(AddressChangeRecord.Email_New__c)){
                    if(AddressChangeRecord.Case_Origin__c != 'Digital Banking'){
                        acc.Email_raw__c = AddressChangeRecord.Email_New__c;
                    }                    
                }
                else{
                    acc.Email_raw__c = AddressChangeRecord.Email_New__c;
                }                
            }
            
            if(acc.Alt_Email_Raw__c != AddressChangeRecord.AlternateEmail_New__c && AddressChangeRecord.AlternateEmail_New__c != 'Not available'){
                if(string.isBlank(AddressChangeRecord.AlternateEmail_New__c)){
                    if(AddressChangeRecord.Case_Origin__c != 'Digital Banking'){
                        acc.Alt_Email_Raw__c = AddressChangeRecord.AlternateEmail_New__c;
                    }                    
                }
                else{
                    acc.Alt_Email_Raw__c = AddressChangeRecord.AlternateEmail_New__c;
                }                
            }

            if(acc.Alternate_Email__pc != AddressChangeRecord.AlternateEmail_New__c && AddressChangeRecord.AlternateEmail_New__c != 'Not available'){
                if(string.isBlank(AddressChangeRecord.AlternateEmail_New__c)){
                    if(AddressChangeRecord.Case_Origin__c != 'Digital Banking'){
                        acc.Alternate_Email__pc = AddressChangeRecord.AlternateEmail_New__c;
                    }                    
                }
                else{
                    acc.Alternate_Email__pc = AddressChangeRecord.AlternateEmail_New__c;
                }               
            }
        }
        
        update AccountstoUpdate;
    }
    
    public void UpdateMailAddressDetails(AddressChangeLog__c AddressChangeRecord, set<string> setAccountNames){
       List<String> substrings = new List<String>();
       string Address1 = AddressChangeRecord.Address_New__c;
       string Address2 = AddressChangeRecord.Address2_New__c;
        
       if (string.isBlank(Address1) && string.isNotBlank(Address2))
       {
           Address1 = Address2;
           Address2 = '';       
       }
        
       string fullAddress = Address1 + ' ' + Address2;
       if (string.isNotBlank(Address1) && string.isNotBlank(Address2) && fullAddress.length() <= 40)
        {
                    Address1 = Address1 + ' ' + Address2;
                    Address2 = '';
        }
       
       List<Person_Account__c> paList = [select id,TypeTranslate__c,Account_Number__r.name,Account_Number__r.Mailing_Street__c, Account_Number__r.Mailing_Extra_Address__c,Account_Number__r.Mailing_City__c, Account_Number__r.Mailing_State__c, Account_Number__r.Mailing_Country__c, Account_Number__r.Mailing_Zipcode__c, Account_Number__r.Mailing_Country_Code__c from Person_Account__c where Account_Number__r.name in: setAccountNames and TypeTranslate__c IN ('0000/Primary')];
       set<id> setAccountIds = new set<id>();
        
        for(Person_Account__c p2: paList){            
            setAccountIds.add(p2.Account_Number__c);
        }
       List<Account_Details__c> AccountstoUpdate= [Select Mailing_Street__c, Mailing_Extra_Address__c,Mailing_City__c, Mailing_State__c, Mailing_Country__c,Mailing_Zipcode__c, Mailing_Country_Code__c  from Account_Details__c where Id IN: setAccountIds];
        
        for(Account_Details__c acc: AccountstoUpdate){
            if(acc.Mailing_Street__c != Address1){
                acc.Mailing_Street__c = Address1;
            }
            if(acc.Mailing_Extra_Address__c != Address2){
                acc.Mailing_Extra_Address__c = Address2;
            }
            if(acc.Mailing_City__c != AddressChangeRecord.City_New__c){
                acc.Mailing_City__c = AddressChangeRecord.City_New__c;
            }
            if(acc.Mailing_State__c != AddressChangeRecord.State_New__c){
                acc.Mailing_State__c = AddressChangeRecord.State_New__c;
            }
            if(acc.Mailing_Country__c != AddressChangeRecord.Country_New__c){
                acc.Mailing_Country__c = AddressChangeRecord.Country_New__c;
            }
            
            if(acc.Mailing_Zipcode__c != AddressChangeRecord.Zip_New__c){
                system.debug('1----');
                 if(AddressChangeRecord.Zip_New__c != null && AddressChangeRecord.Zip_New__c.Contains('-')){
                    List<string> ZipCodes = AddressChangeRecord.Zip_New__c.split('-');                     
                    acc.Mailing_Zipcode__c = ZipCodes[0];                      
                    if(ZipCodes.size() >= 1)
                        acc.Mailing_Zipcode__c += '-' + ZipCodes[1];                     
                }
                else if(AddressChangeRecord.Zip_New__c != null){
                    acc.Mailing_Zipcode__c = AddressChangeRecord.Zip_New__c;
                }
                else if(AddressChangeRecord.Zip_New__c == null){
                    acc.Mailing_Zipcode__c = '';
                }
            }     
            
			if(acc.Mailing_Country_Code__c != AddressChangeRecord.CountryCode_New__c){
                acc.Mailing_Country_Code__c = AddressChangeRecord.CountryCode_New__c;
            }            
        }
        
       update AccountstoUpdate;
    }
	
    public boolean isDomesticPhoneNumber(string PhoneNumber){
        boolean isDomesticPhone = true;
        if(string.isNotBlank(PhoneNumber)){
            PhoneNumber = PhoneNumber.trim().replaceAll('\\(', '').replaceAll('\\)', '').replaceAll('-', '').replaceAll(' ', '');
            boolean isnum = PhoneNumber.isNumeric();
            if(isnum && PhoneNumber.length() == 10){
                isDomesticPhone = true;
            }
            else{
                isDomesticPhone = false;
            }
    	}    
    	return isDomesticPhone;
    }    
    
    public class EmailNotificationStatusList{
        @AuraEnabled
        public string accountNumber{ get; set; }
        
        @AuraEnabled
        public boolean IRACheck{ get; set; }
        
        @AuraEnabled
        public boolean RECheck{ get; set; }
    }
}